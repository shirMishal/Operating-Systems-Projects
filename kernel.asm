
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 30 10 80       	mov    $0x80103040,%eax
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
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 40 78 10 80       	push   $0x80107840
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 d1 49 00 00       	call   80104a30 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
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
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 78 10 80       	push   $0x80107847
80100097:	50                   	push   %eax
80100098:	e8 53 48 00 00       	call   801048f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
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
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 c3 4a 00 00       	call   80104bb0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 09 4b 00 00       	call   80104c70 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 47 00 00       	call   80104930 <acquiresleep>
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
8010018c:	e8 ef 20 00 00       	call   80102280 <iderw>
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
801001a3:	68 4e 78 10 80       	push   $0x8010784e
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
801001c2:	e8 09 48 00 00       	call   801049d0 <holdingsleep>
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
801001d8:	e9 a3 20 00 00       	jmp    80102280 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 5f 78 10 80       	push   $0x8010785f
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
80100203:	e8 c8 47 00 00       	call   801049d0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 78 47 00 00       	call   80104990 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 8c 49 00 00       	call   80104bb0 <acquire>
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
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 fb 49 00 00       	jmp    80104c70 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 66 78 10 80       	push   $0x80107866
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
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 fa 48 00 00       	call   80104bb0 <acquire>
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
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 66 41 00 00       	call   80104450 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 21 38 00 00       	call   80103b20 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 5d 49 00 00       	call   80104c70 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
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
80100333:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%ecx
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
80100365:	e8 06 49 00 00       	call   80104c70 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
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
80100386:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
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
801003ad:	e8 ee 24 00 00       	call   801028a0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 6d 78 10 80       	push   $0x8010786d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 cb 81 10 80 	movl   $0x801081cb,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 6f 46 00 00       	call   80104a50 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 81 78 10 80       	push   $0x80107881
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
8010042a:	e8 01 60 00 00       	call   80106430 <uartputc>
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
80100515:	e8 16 5f 00 00       	call   80106430 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 0a 5f 00 00       	call   80106430 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 fe 5e 00 00       	call   80106430 <uartputc>
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
80100561:	e8 fa 47 00 00       	call   80104d60 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 45 47 00 00       	call   80104cc0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 85 78 10 80       	push   $0x80107885
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
801005c9:	0f b6 92 b0 78 10 80 	movzbl -0x7fef8750(%edx),%edx
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
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 4c 45 00 00       	call   80104bb0 <acquire>
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
80100697:	e8 d4 45 00 00       	call   80104c70 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

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
8010077d:	bb 98 78 10 80       	mov    $0x80107898,%ebx
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
801007bd:	e8 ee 43 00 00       	call   80104bb0 <acquire>
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
80100828:	e8 43 44 00 00       	call   80104c70 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 9f 78 10 80       	push   $0x8010789f
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
80100877:	e8 34 43 00 00       	call   80104bb0 <acquire>
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
801008b4:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 0f 11 80    	mov    %bl,-0x7feef0e0(%eax)
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
80100908:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100925:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
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
8010096a:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010096f:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100985:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
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
801009cf:	e8 9c 42 00 00       	call   80104c70 <release>
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
801009e3:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
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
801009ff:	e9 ec 3c 00 00       	jmp    801046f0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100a1b:	68 a0 0f 11 80       	push   $0x80110fa0
80100a20:	e8 fb 3b 00 00       	call   80104620 <wakeup>
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
80100a3a:	68 a8 78 10 80       	push   $0x801078a8
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 e7 3f 00 00       	call   80104a30 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 19 11 80 40 	movl   $0x80100640,0x8011196c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 19 11 80 90 	movl   $0x80100290,0x80111968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 be 19 00 00       	call   80102430 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 8b 30 00 00       	call   80103b20 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 90 22 00 00       	call   80102d30 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 b8 22 00 00       	call   80102da0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 8f 6a 00 00       	call   801075a0 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 48 68 00 00       	call   801073c0 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 42 67 00 00       	call   801072f0 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 30 69 00 00       	call   80107520 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 7a 21 00 00       	call   80102da0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 89 67 00 00       	call   801073c0 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 e8 69 00 00       	call   80107640 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 18 42 00 00       	call   80104ec0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 05 42 00 00       	call   80104ec0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 d4 6a 00 00       	call   801077a0 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 3a 68 00 00       	call   80107520 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 68 6a 00 00       	call   801077a0 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 0a 41 00 00       	call   80104e80 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 be 63 00 00       	call   80107160 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 76 67 00 00       	call   80107520 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 e7 1f 00 00       	call   80102da0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 c1 78 10 80       	push   $0x801078c1
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 cd 78 10 80       	push   $0x801078cd
80100def:	68 c0 0f 11 80       	push   $0x80110fc0
80100df4:	e8 37 3c 00 00       	call   80104a30 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 c0 0f 11 80       	push   $0x80110fc0
80100e15:	e8 96 3d 00 00       	call   80104bb0 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e41:	e8 2a 3e 00 00       	call   80104c70 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 0f 11 80       	push   $0x80110fc0
80100e5a:	e8 11 3e 00 00       	call   80104c70 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 c0 0f 11 80       	push   $0x80110fc0
80100e83:	e8 28 3d 00 00       	call   80104bb0 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 c0 0f 11 80       	push   $0x80110fc0
80100ea0:	e8 cb 3d 00 00       	call   80104c70 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 d4 78 10 80       	push   $0x801078d4
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 c0 0f 11 80       	push   $0x80110fc0
80100ed5:	e8 d6 3c 00 00       	call   80104bb0 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 5b 3d 00 00       	call   80104c70 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 2d 3d 00 00       	jmp    80104c70 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 e3 1d 00 00       	call   80102d30 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 39 1e 00 00       	jmp    80102da0 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 92 25 00 00       	call   80103510 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 dc 78 10 80       	push   $0x801078dc
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 46 26 00 00       	jmp    801036b0 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 e6 78 10 80       	push   $0x801078e6
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 aa 1c 00 00       	call   80102da0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 11 1c 00 00       	call   80102d30 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 4a 1c 00 00       	call   80102da0 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 ef 78 10 80       	push   $0x801078ef
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 1a 24 00 00       	jmp    801035b0 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 f5 78 10 80       	push   $0x801078f5
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011b0:	55                   	push   %ebp
801011b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011b3:	89 d0                	mov    %edx,%eax
801011b5:	c1 e8 0c             	shr    $0xc,%eax
801011b8:	03 05 d8 19 11 80    	add    0x801119d8,%eax
{
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	56                   	push   %esi
801011c1:	53                   	push   %ebx
801011c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	50                   	push   %eax
801011c8:	51                   	push   %ecx
801011c9:	e8 02 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011d0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011d3:	ba 01 00 00 00       	mov    $0x1,%edx
801011d8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011db:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011e1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011e4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011e6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011eb:	85 d1                	test   %edx,%ecx
801011ed:	74 25                	je     80101214 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ef:	f7 d2                	not    %edx
  log_write(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801011f6:	21 ca                	and    %ecx,%edx
801011f8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801011fc:	50                   	push   %eax
801011fd:	e8 0e 1d 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101202:	89 34 24             	mov    %esi,(%esp)
80101205:	e8 e6 ef ff ff       	call   801001f0 <brelse>
}
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101210:	5b                   	pop    %ebx
80101211:	5e                   	pop    %esi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
    panic("freeing free block");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 ff 78 10 80       	push   $0x801078ff
8010121c:	e8 6f f1 ff ff       	call   80100390 <panic>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122f:	90                   	nop

80101230 <balloc>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 87 00 00 00    	je     801012d1 <balloc+0xa1>
8010124a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101251:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	89 f0                	mov    %esi,%eax
80101259:	c1 f8 0c             	sar    $0xc,%eax
8010125c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	83 c4 10             	add    $0x10,%esp
8010126e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101271:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2f                	jmp    801012ac <balloc+0x7c>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 41                	je     801012e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 05                	je     801012b1 <balloc+0x81>
801012ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012af:	77 cf                	ja     80101280 <balloc+0x50>
    brelse(bp);
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012b7:	e8 34 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 12 79 10 80       	push   $0x80107912
801012d9:	e8 b2 f0 ff ff       	call   80100390 <panic>
801012de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012e6:	09 da                	or     %ebx,%edx
801012e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012ec:	57                   	push   %edi
801012ed:	e8 1e 1c 00 00       	call   80102f10 <log_write>
        brelse(bp);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012fa:	58                   	pop    %eax
801012fb:	5a                   	pop    %edx
801012fc:	56                   	push   %esi
801012fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101305:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101308:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010130a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010130d:	68 00 02 00 00       	push   $0x200
80101312:	6a 00                	push   $0x0
80101314:	50                   	push   %eax
80101315:	e8 a6 39 00 00       	call   80104cc0 <memset>
  log_write(bp);
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 ee 1b 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 f0                	mov    %esi,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010133f:	90                   	nop

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	89 c7                	mov    %eax,%edi
80101346:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101347:	31 f6                	xor    %esi,%esi
{
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 e0 19 11 80       	push   $0x801119e0
8010135a:	e8 51 38 00 00       	call   80104bb0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 3b                	cmp    %edi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101380:	73 26                	jae    801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101385:	85 c9                	test   %ecx,%ecx
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	89 d8                	mov    %ebx,%eax
8010138f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	75 6e                	jne    80101407 <iget+0xc7>
80101399:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139b:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013a1:	72 df                	jb     80101382 <iget+0x42>
801013a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013a7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 f6                	test   %esi,%esi
801013aa:	74 73                	je     8010141f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013c2:	68 e0 19 11 80       	push   $0x801119e0
801013c7:	e8 a4 38 00 00       	call   80104c70 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f0                	mov    %esi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret    
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      release(&icache.lock);
801013e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013ed:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
801013f2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013f5:	e8 76 38 00 00       	call   80104c70 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f0                	mov    %esi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010140d:	73 10                	jae    8010141f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101412:	85 c9                	test   %ecx,%ecx
80101414:	0f 8f 56 ff ff ff    	jg     80101370 <iget+0x30>
8010141a:	e9 6e ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 28 79 10 80       	push   $0x80107928
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	89 c6                	mov    %eax,%esi
80101437:	53                   	push   %ebx
80101438:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010143b:	83 fa 0b             	cmp    $0xb,%edx
8010143e:	0f 86 84 00 00 00    	jbe    801014c8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101444:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101447:	83 fb 7f             	cmp    $0x7f,%ebx
8010144a:	0f 87 98 00 00 00    	ja     801014e8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101450:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101456:	8b 16                	mov    (%esi),%edx
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 54                	je     801014b0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010145c:	83 ec 08             	sub    $0x8,%esp
8010145f:	50                   	push   %eax
80101460:	52                   	push   %edx
80101461:	e8 6a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101466:	83 c4 10             	add    $0x10,%esp
80101469:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010146d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010146f:	8b 1a                	mov    (%edx),%ebx
80101471:	85 db                	test   %ebx,%ebx
80101473:	74 1b                	je     80101490 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101475:	83 ec 0c             	sub    $0xc,%esp
80101478:	57                   	push   %edi
80101479:	e8 72 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010147e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101484:	89 d8                	mov    %ebx,%eax
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101495:	e8 96 fd ff ff       	call   80101230 <balloc>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010149d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014a0:	89 c3                	mov    %eax,%ebx
801014a2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014a4:	57                   	push   %edi
801014a5:	e8 66 1a 00 00       	call   80102f10 <log_write>
801014aa:	83 c4 10             	add    $0x10,%esp
801014ad:	eb c6                	jmp    80101475 <bmap+0x45>
801014af:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b0:	89 d0                	mov    %edx,%eax
801014b2:	e8 79 fd ff ff       	call   80101230 <balloc>
801014b7:	8b 16                	mov    (%esi),%edx
801014b9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014bf:	eb 9b                	jmp    8010145c <bmap+0x2c>
801014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014c8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014cb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ce:	85 db                	test   %ebx,%ebx
801014d0:	75 af                	jne    80101481 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d2:	8b 00                	mov    (%eax),%eax
801014d4:	e8 57 fd ff ff       	call   80101230 <balloc>
801014d9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014dc:	89 c3                	mov    %eax,%ebx
}
801014de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	5b                   	pop    %ebx
801014e4:	5e                   	pop    %esi
801014e5:	5f                   	pop    %edi
801014e6:	5d                   	pop    %ebp
801014e7:	c3                   	ret    
  panic("bmap: out of range");
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	68 38 79 10 80       	push   $0x80107938
801014f0:	e8 9b ee ff ff       	call   80100390 <panic>
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <readsb>:
{
80101500:	f3 0f 1e fb          	endbr32 
80101504:	55                   	push   %ebp
80101505:	89 e5                	mov    %esp,%ebp
80101507:	56                   	push   %esi
80101508:	53                   	push   %ebx
80101509:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	6a 01                	push   $0x1
80101511:	ff 75 08             	pushl  0x8(%ebp)
80101514:	e8 b7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101519:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010151c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010151e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101521:	6a 1c                	push   $0x1c
80101523:	50                   	push   %eax
80101524:	56                   	push   %esi
80101525:	e8 36 38 00 00       	call   80104d60 <memmove>
  brelse(bp);
8010152a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010152d:	83 c4 10             	add    $0x10,%esp
}
80101530:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101533:	5b                   	pop    %ebx
80101534:	5e                   	pop    %esi
80101535:	5d                   	pop    %ebp
  brelse(bp);
80101536:	e9 b5 ec ff ff       	jmp    801001f0 <brelse>
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 4b 79 10 80       	push   $0x8010794b
80101555:	68 e0 19 11 80       	push   $0x801119e0
8010155a:	e8 d1 34 00 00       	call   80104a30 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 52 79 10 80       	push   $0x80107952
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 74 33 00 00       	call   801048f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 c0 19 11 80       	push   $0x801119c0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 69 ff ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 d8 19 11 80    	pushl  0x801119d8
8010159d:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015a3:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015a9:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015af:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015b5:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015bb:	ff 35 c0 19 11 80    	pushl  0x801119c0
801015c1:	68 b8 79 10 80       	push   $0x801079b8
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d c8 19 11 80    	cmp    0x801119c8,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 5d 36 00 00       	call   80104cc0 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 9b 18 00 00       	call   80102f10 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 b0 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 58 79 10 80       	push   $0x80107958
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 56 36 00 00       	call   80104d60 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 fe 17 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 e0 19 11 80       	push   $0x801119e0
80101743:	e8 68 34 00 00       	call   80104bb0 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101753:	e8 18 35 00 00       	call   80104c70 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 a5 31 00 00       	call   80104930 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 63 35 00 00       	call   80104d60 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 70 79 10 80       	push   $0x80107970
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 6a 79 10 80       	push   $0x8010796a
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 74 31 00 00       	call   801049d0 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 18 31 00 00       	jmp    80104990 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 7f 79 10 80       	push   $0x8010797f
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 87 30 00 00       	call   80104930 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 cd 30 00 00       	call   80104990 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018ca:	e8 e1 32 00 00       	call   80104bb0 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 87 33 00 00       	jmp    80104c70 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 e0 19 11 80       	push   $0x801119e0
801018f8:	e8 b3 32 00 00       	call   80104bb0 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101907:	e8 64 33 00 00       	call   80104c70 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 74 f8 ff ff       	call   801011b0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 ec f7 ff ff       	call   801011b0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 c5 f7 ff ff       	call   801011b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 61 f9 ff ff       	call   80101430 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 54 32 00 00       	call   80104d60 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 61 f8 ff ff       	call   80101430 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 58 31 00 00       	call   80104d60 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 00 13 00 00       	call   80102f10 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 29 31 00 00       	call   80104dd0 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 c6 30 00 00       	call   80104dd0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 01 f6 ff ff       	call   80101340 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 99 79 10 80       	push   $0x80107999
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 87 79 10 80       	push   $0x80107987
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 91 1d 00 00       	call   80103b20 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 e0 19 11 80       	push   $0x801119e0
80101d9c:	e8 0f 2e 00 00       	call   80104bb0 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101dac:	e8 bf 2e 00 00       	call   80104c70 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 44 2f 00 00       	call   80104d60 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 b8 2e 00 00       	call   80104d60 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 1f f4 ff ff       	call   80101340 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 46 2e 00 00       	call   80104e20 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 a8 79 10 80       	push   $0x801079a8
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 b2 7f 10 80       	push   $0x80107fb2
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	66 90                	xchg   %ax,%ax
8010206a:	66 90                	xchg   %ax,%ax
8010206c:	66 90                	xchg   %ax,%ax
8010206e:	66 90                	xchg   %ax,%ax

80102070 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102079:	85 c0                	test   %eax,%eax
8010207b:	0f 84 b4 00 00 00    	je     80102135 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102081:	8b 70 08             	mov    0x8(%eax),%esi
80102084:	89 c3                	mov    %eax,%ebx
80102086:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010208c:	0f 87 96 00 00 00    	ja     80102128 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102092:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209e:	66 90                	xchg   %ax,%ax
801020a0:	89 ca                	mov    %ecx,%edx
801020a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a3:	83 e0 c0             	and    $0xffffffc0,%eax
801020a6:	3c 40                	cmp    $0x40,%al
801020a8:	75 f6                	jne    801020a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020aa:	31 ff                	xor    %edi,%edi
801020ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020b1:	89 f8                	mov    %edi,%eax
801020b3:	ee                   	out    %al,(%dx)
801020b4:	b8 01 00 00 00       	mov    $0x1,%eax
801020b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020be:	ee                   	out    %al,(%dx)
801020bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020c4:	89 f0                	mov    %esi,%eax
801020c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020c7:	89 f0                	mov    %esi,%eax
801020c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020ce:	c1 f8 08             	sar    $0x8,%eax
801020d1:	ee                   	out    %al,(%dx)
801020d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020d7:	89 f8                	mov    %edi,%eax
801020d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020da:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020e3:	c1 e0 04             	shl    $0x4,%eax
801020e6:	83 e0 10             	and    $0x10,%eax
801020e9:	83 c8 e0             	or     $0xffffffe0,%eax
801020ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020ed:	f6 03 04             	testb  $0x4,(%ebx)
801020f0:	75 16                	jne    80102108 <idestart+0x98>
801020f2:	b8 20 00 00 00       	mov    $0x20,%eax
801020f7:	89 ca                	mov    %ecx,%edx
801020f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020fd:	5b                   	pop    %ebx
801020fe:	5e                   	pop    %esi
801020ff:	5f                   	pop    %edi
80102100:	5d                   	pop    %ebp
80102101:	c3                   	ret    
80102102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102108:	b8 30 00 00 00       	mov    $0x30,%eax
8010210d:	89 ca                	mov    %ecx,%edx
8010210f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102110:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102115:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102118:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211d:	fc                   	cld    
8010211e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102120:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102123:	5b                   	pop    %ebx
80102124:	5e                   	pop    %esi
80102125:	5f                   	pop    %edi
80102126:	5d                   	pop    %ebp
80102127:	c3                   	ret    
    panic("incorrect blockno");
80102128:	83 ec 0c             	sub    $0xc,%esp
8010212b:	68 14 7a 10 80       	push   $0x80107a14
80102130:	e8 5b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 0b 7a 10 80       	push   $0x80107a0b
8010213d:	e8 4e e2 ff ff       	call   80100390 <panic>
80102142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102150 <ideinit>:
{
80102150:	f3 0f 1e fb          	endbr32 
80102154:	55                   	push   %ebp
80102155:	89 e5                	mov    %esp,%ebp
80102157:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010215a:	68 26 7a 10 80       	push   $0x80107a26
8010215f:	68 80 b5 10 80       	push   $0x8010b580
80102164:	e8 c7 28 00 00       	call   80104a30 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102169:	58                   	pop    %eax
8010216a:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010216f:	5a                   	pop    %edx
80102170:	83 e8 01             	sub    $0x1,%eax
80102173:	50                   	push   %eax
80102174:	6a 0e                	push   $0xe
80102176:	e8 b5 02 00 00       	call   80102430 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010217b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010217e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102187:	90                   	nop
80102188:	ec                   	in     (%dx),%al
80102189:	83 e0 c0             	and    $0xffffffc0,%eax
8010218c:	3c 40                	cmp    $0x40,%al
8010218e:	75 f8                	jne    80102188 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102190:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102195:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010219a:	ee                   	out    %al,(%dx)
8010219b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a5:	eb 0e                	jmp    801021b5 <ideinit+0x65>
801021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ae:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021b0:	83 e9 01             	sub    $0x1,%ecx
801021b3:	74 0f                	je     801021c4 <ideinit+0x74>
801021b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021b6:	84 c0                	test   %al,%al
801021b8:	74 f6                	je     801021b0 <ideinit+0x60>
      havedisk1 = 1;
801021ba:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801021c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ce:	ee                   	out    %al,(%dx)
}
801021cf:	c9                   	leave  
801021d0:	c3                   	ret    
801021d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021df:	90                   	nop

801021e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021e0:	f3 0f 1e fb          	endbr32 
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	57                   	push   %edi
801021e8:	56                   	push   %esi
801021e9:	53                   	push   %ebx
801021ea:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021ed:	68 80 b5 10 80       	push   $0x8010b580
801021f2:	e8 b9 29 00 00       	call   80104bb0 <acquire>

  if((b = idequeue) == 0){
801021f7:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801021fd:	83 c4 10             	add    $0x10,%esp
80102200:	85 db                	test   %ebx,%ebx
80102202:	74 5f                	je     80102263 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102204:	8b 43 58             	mov    0x58(%ebx),%eax
80102207:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010220c:	8b 33                	mov    (%ebx),%esi
8010220e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102214:	75 2b                	jne    80102241 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102216:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010221f:	90                   	nop
80102220:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102221:	89 c1                	mov    %eax,%ecx
80102223:	83 e1 c0             	and    $0xffffffc0,%ecx
80102226:	80 f9 40             	cmp    $0x40,%cl
80102229:	75 f5                	jne    80102220 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010222b:	a8 21                	test   $0x21,%al
8010222d:	75 12                	jne    80102241 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010222f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102232:	b9 80 00 00 00       	mov    $0x80,%ecx
80102237:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010223c:	fc                   	cld    
8010223d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010223f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102241:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102244:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102247:	83 ce 02             	or     $0x2,%esi
8010224a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010224c:	53                   	push   %ebx
8010224d:	e8 ce 23 00 00       	call   80104620 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102252:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	85 c0                	test   %eax,%eax
8010225c:	74 05                	je     80102263 <ideintr+0x83>
    idestart(idequeue);
8010225e:	e8 0d fe ff ff       	call   80102070 <idestart>
    release(&idelock);
80102263:	83 ec 0c             	sub    $0xc,%esp
80102266:	68 80 b5 10 80       	push   $0x8010b580
8010226b:	e8 00 2a 00 00       	call   80104c70 <release>

  release(&idelock);
}
80102270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102273:	5b                   	pop    %ebx
80102274:	5e                   	pop    %esi
80102275:	5f                   	pop    %edi
80102276:	5d                   	pop    %ebp
80102277:	c3                   	ret    
80102278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop

80102280 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102280:	f3 0f 1e fb          	endbr32 
80102284:	55                   	push   %ebp
80102285:	89 e5                	mov    %esp,%ebp
80102287:	53                   	push   %ebx
80102288:	83 ec 10             	sub    $0x10,%esp
8010228b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010228e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102291:	50                   	push   %eax
80102292:	e8 39 27 00 00       	call   801049d0 <holdingsleep>
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	85 c0                	test   %eax,%eax
8010229c:	0f 84 cf 00 00 00    	je     80102371 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022a2:	8b 03                	mov    (%ebx),%eax
801022a4:	83 e0 06             	and    $0x6,%eax
801022a7:	83 f8 02             	cmp    $0x2,%eax
801022aa:	0f 84 b4 00 00 00    	je     80102364 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022b0:	8b 53 04             	mov    0x4(%ebx),%edx
801022b3:	85 d2                	test   %edx,%edx
801022b5:	74 0d                	je     801022c4 <iderw+0x44>
801022b7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801022bc:	85 c0                	test   %eax,%eax
801022be:	0f 84 93 00 00 00    	je     80102357 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	68 80 b5 10 80       	push   $0x8010b580
801022cc:	e8 df 28 00 00       	call   80104bb0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
801022d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022dd:	83 c4 10             	add    $0x10,%esp
801022e0:	85 c0                	test   %eax,%eax
801022e2:	74 6c                	je     80102350 <iderw+0xd0>
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e8:	89 c2                	mov    %eax,%edx
801022ea:	8b 40 58             	mov    0x58(%eax),%eax
801022ed:	85 c0                	test   %eax,%eax
801022ef:	75 f7                	jne    801022e8 <iderw+0x68>
801022f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022f6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801022fc:	74 42                	je     80102340 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	74 23                	je     8010232b <iderw+0xab>
80102308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230f:	90                   	nop
    sleep(b, &idelock);
80102310:	83 ec 08             	sub    $0x8,%esp
80102313:	68 80 b5 10 80       	push   $0x8010b580
80102318:	53                   	push   %ebx
80102319:	e8 32 21 00 00       	call   80104450 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 c4 10             	add    $0x10,%esp
80102323:	83 e0 06             	and    $0x6,%eax
80102326:	83 f8 02             	cmp    $0x2,%eax
80102329:	75 e5                	jne    80102310 <iderw+0x90>
  }


  release(&idelock);
8010232b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102335:	c9                   	leave  
  release(&idelock);
80102336:	e9 35 29 00 00       	jmp    80104c70 <release>
8010233b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop
    idestart(b);
80102340:	89 d8                	mov    %ebx,%eax
80102342:	e8 29 fd ff ff       	call   80102070 <idestart>
80102347:	eb b5                	jmp    801022fe <iderw+0x7e>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102350:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102355:	eb 9d                	jmp    801022f4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	68 55 7a 10 80       	push   $0x80107a55
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 40 7a 10 80       	push   $0x80107a40
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	68 2a 7a 10 80       	push   $0x80107a2a
80102379:	e8 12 e0 ff ff       	call   80100390 <panic>
8010237e:	66 90                	xchg   %ax,%ax

80102380 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102380:	f3 0f 1e fb          	endbr32 
80102384:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102385:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
8010238c:	00 c0 fe 
{
8010238f:	89 e5                	mov    %esp,%ebp
80102391:	56                   	push   %esi
80102392:	53                   	push   %ebx
  ioapic->reg = reg;
80102393:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010239a:	00 00 00 
  return ioapic->data;
8010239d:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801023a3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023a6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023ac:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023b2:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023b9:	c1 ee 10             	shr    $0x10,%esi
801023bc:	89 f0                	mov    %esi,%eax
801023be:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023c1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023c4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023c7:	39 c2                	cmp    %eax,%edx
801023c9:	74 16                	je     801023e1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023cb:	83 ec 0c             	sub    $0xc,%esp
801023ce:	68 74 7a 10 80       	push   $0x80107a74
801023d3:	e8 d8 e2 ff ff       	call   801006b0 <cprintf>
801023d8:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	83 c6 21             	add    $0x21,%esi
{
801023e4:	ba 10 00 00 00       	mov    $0x10,%edx
801023e9:	b8 20 00 00 00       	mov    $0x20,%eax
801023ee:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801023f0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023f2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801023f4:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801023fa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023fd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102403:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102406:	8d 5a 01             	lea    0x1(%edx),%ebx
80102409:	83 c2 02             	add    $0x2,%edx
8010240c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010240e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102414:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010241b:	39 f0                	cmp    %esi,%eax
8010241d:	75 d1                	jne    801023f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010241f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102422:	5b                   	pop    %ebx
80102423:	5e                   	pop    %esi
80102424:	5d                   	pop    %ebp
80102425:	c3                   	ret    
80102426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242d:	8d 76 00             	lea    0x0(%esi),%esi

80102430 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102430:	f3 0f 1e fb          	endbr32 
80102434:	55                   	push   %ebp
  ioapic->reg = reg;
80102435:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
8010243b:	89 e5                	mov    %esp,%ebp
8010243d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102440:	8d 50 20             	lea    0x20(%eax),%edx
80102443:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102447:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102449:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010244f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102452:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102455:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102458:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010245a:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102462:	89 50 10             	mov    %edx,0x10(%eax)
}
80102465:	5d                   	pop    %ebp
80102466:	c3                   	ret    
80102467:	66 90                	xchg   %ax,%ax
80102469:	66 90                	xchg   %ax,%ax
8010246b:	66 90                	xchg   %ax,%ax
8010246d:	66 90                	xchg   %ax,%ax
8010246f:	90                   	nop

80102470 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102470:	f3 0f 1e fb          	endbr32 
80102474:	55                   	push   %ebp
80102475:	89 e5                	mov    %esp,%ebp
80102477:	53                   	push   %ebx
80102478:	83 ec 04             	sub    $0x4,%esp
8010247b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010247e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102484:	75 7a                	jne    80102500 <kfree+0x90>
80102486:	81 fb a8 6c 11 80    	cmp    $0x80116ca8,%ebx
8010248c:	72 72                	jb     80102500 <kfree+0x90>
8010248e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102494:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102499:	77 65                	ja     80102500 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010249b:	83 ec 04             	sub    $0x4,%esp
8010249e:	68 00 10 00 00       	push   $0x1000
801024a3:	6a 01                	push   $0x1
801024a5:	53                   	push   %ebx
801024a6:	e8 15 28 00 00       	call   80104cc0 <memset>

  if(kmem.use_lock)
801024ab:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801024b1:	83 c4 10             	add    $0x10,%esp
801024b4:	85 d2                	test   %edx,%edx
801024b6:	75 20                	jne    801024d8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024b8:	a1 78 36 11 80       	mov    0x80113678,%eax
801024bd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024bf:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801024c4:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801024ca:	85 c0                	test   %eax,%eax
801024cc:	75 22                	jne    801024f0 <kfree+0x80>
    release(&kmem.lock);
}
801024ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024d1:	c9                   	leave  
801024d2:	c3                   	ret    
801024d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d7:	90                   	nop
    acquire(&kmem.lock);
801024d8:	83 ec 0c             	sub    $0xc,%esp
801024db:	68 40 36 11 80       	push   $0x80113640
801024e0:	e8 cb 26 00 00       	call   80104bb0 <acquire>
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	eb ce                	jmp    801024b8 <kfree+0x48>
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801024f0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801024f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fa:	c9                   	leave  
    release(&kmem.lock);
801024fb:	e9 70 27 00 00       	jmp    80104c70 <release>
    panic("kfree");
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 a6 7a 10 80       	push   $0x80107aa6
80102508:	e8 83 de ff ff       	call   80100390 <panic>
8010250d:	8d 76 00             	lea    0x0(%esi),%esi

80102510 <freerange>:
{
80102510:	f3 0f 1e fb          	endbr32 
80102514:	55                   	push   %ebp
80102515:	89 e5                	mov    %esp,%ebp
80102517:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102518:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010251b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010251e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010251f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102525:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010252b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102531:	39 de                	cmp    %ebx,%esi
80102533:	72 1f                	jb     80102554 <freerange+0x44>
80102535:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102538:	83 ec 0c             	sub    $0xc,%esp
8010253b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102541:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102547:	50                   	push   %eax
80102548:	e8 23 ff ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	39 f3                	cmp    %esi,%ebx
80102552:	76 e4                	jbe    80102538 <freerange+0x28>
}
80102554:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102557:	5b                   	pop    %ebx
80102558:	5e                   	pop    %esi
80102559:	5d                   	pop    %ebp
8010255a:	c3                   	ret    
8010255b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010255f:	90                   	nop

80102560 <kinit1>:
{
80102560:	f3 0f 1e fb          	endbr32 
80102564:	55                   	push   %ebp
80102565:	89 e5                	mov    %esp,%ebp
80102567:	56                   	push   %esi
80102568:	53                   	push   %ebx
80102569:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010256c:	83 ec 08             	sub    $0x8,%esp
8010256f:	68 ac 7a 10 80       	push   $0x80107aac
80102574:	68 40 36 11 80       	push   $0x80113640
80102579:	e8 b2 24 00 00       	call   80104a30 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010257e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102581:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102584:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
8010258b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102594:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025a0:	39 de                	cmp    %ebx,%esi
801025a2:	72 20                	jb     801025c4 <kinit1+0x64>
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 b3 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 de                	cmp    %ebx,%esi
801025c2:	73 e4                	jae    801025a8 <kinit1+0x48>
}
801025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5d                   	pop    %ebp
801025ca:	c3                   	ret    
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <kinit2>:
{
801025d0:	f3 0f 1e fb          	endbr32 
801025d4:	55                   	push   %ebp
801025d5:	89 e5                	mov    %esp,%ebp
801025d7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025d8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025db:	8b 75 0c             	mov    0xc(%ebp),%esi
801025de:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025df:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025f1:	39 de                	cmp    %ebx,%esi
801025f3:	72 1f                	jb     80102614 <kinit2+0x44>
801025f5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 63 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102614:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010261b:	00 00 00 
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
80102624:	c3                   	ret    
80102625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102630:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102634:	a1 74 36 11 80       	mov    0x80113674,%eax
80102639:	85 c0                	test   %eax,%eax
8010263b:	75 1b                	jne    80102658 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010263d:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
80102642:	85 c0                	test   %eax,%eax
80102644:	74 0a                	je     80102650 <kalloc+0x20>
    kmem.freelist = r->next;
80102646:	8b 10                	mov    (%eax),%edx
80102648:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
8010264e:	c3                   	ret    
8010264f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102650:	c3                   	ret    
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102658:	55                   	push   %ebp
80102659:	89 e5                	mov    %esp,%ebp
8010265b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010265e:	68 40 36 11 80       	push   $0x80113640
80102663:	e8 48 25 00 00       	call   80104bb0 <acquire>
  r = kmem.freelist;
80102668:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010266d:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102673:	83 c4 10             	add    $0x10,%esp
80102676:	85 c0                	test   %eax,%eax
80102678:	74 08                	je     80102682 <kalloc+0x52>
    kmem.freelist = r->next;
8010267a:	8b 08                	mov    (%eax),%ecx
8010267c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102682:	85 d2                	test   %edx,%edx
80102684:	74 16                	je     8010269c <kalloc+0x6c>
    release(&kmem.lock);
80102686:	83 ec 0c             	sub    $0xc,%esp
80102689:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010268c:	68 40 36 11 80       	push   $0x80113640
80102691:	e8 da 25 00 00       	call   80104c70 <release>
  return (char*)r;
80102696:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102699:	83 c4 10             	add    $0x10,%esp
}
8010269c:	c9                   	leave  
8010269d:	c3                   	ret    
8010269e:	66 90                	xchg   %ax,%ax

801026a0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026a0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a4:	ba 64 00 00 00       	mov    $0x64,%edx
801026a9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026aa:	a8 01                	test   $0x1,%al
801026ac:	0f 84 be 00 00 00    	je     80102770 <kbdgetc+0xd0>
{
801026b2:	55                   	push   %ebp
801026b3:	ba 60 00 00 00       	mov    $0x60,%edx
801026b8:	89 e5                	mov    %esp,%ebp
801026ba:	53                   	push   %ebx
801026bb:	ec                   	in     (%dx),%al
  return data;
801026bc:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026c2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026c5:	3c e0                	cmp    $0xe0,%al
801026c7:	74 57                	je     80102720 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026c9:	89 d9                	mov    %ebx,%ecx
801026cb:	83 e1 40             	and    $0x40,%ecx
801026ce:	84 c0                	test   %al,%al
801026d0:	78 5e                	js     80102730 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026d2:	85 c9                	test   %ecx,%ecx
801026d4:	74 09                	je     801026df <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026d6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026d9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026dc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026df:	0f b6 8a e0 7b 10 80 	movzbl -0x7fef8420(%edx),%ecx
  shift ^= togglecode[data];
801026e6:	0f b6 82 e0 7a 10 80 	movzbl -0x7fef8520(%edx),%eax
  shift |= shiftcode[data];
801026ed:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ef:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026f1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026f3:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026f9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026fc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026ff:	8b 04 85 c0 7a 10 80 	mov    -0x7fef8540(,%eax,4),%eax
80102706:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010270a:	74 0b                	je     80102717 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010270c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010270f:	83 fa 19             	cmp    $0x19,%edx
80102712:	77 44                	ja     80102758 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102714:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102717:	5b                   	pop    %ebx
80102718:	5d                   	pop    %ebp
80102719:	c3                   	ret    
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102720:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102723:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102725:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010272b:	5b                   	pop    %ebx
8010272c:	5d                   	pop    %ebp
8010272d:	c3                   	ret    
8010272e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102730:	83 e0 7f             	and    $0x7f,%eax
80102733:	85 c9                	test   %ecx,%ecx
80102735:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102738:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010273a:	0f b6 8a e0 7b 10 80 	movzbl -0x7fef8420(%edx),%ecx
80102741:	83 c9 40             	or     $0x40,%ecx
80102744:	0f b6 c9             	movzbl %cl,%ecx
80102747:	f7 d1                	not    %ecx
80102749:	21 d9                	and    %ebx,%ecx
}
8010274b:	5b                   	pop    %ebx
8010274c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010274d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102753:	c3                   	ret    
80102754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102758:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010275b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010275e:	5b                   	pop    %ebx
8010275f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102760:	83 f9 1a             	cmp    $0x1a,%ecx
80102763:	0f 42 c2             	cmovb  %edx,%eax
}
80102766:	c3                   	ret    
80102767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276e:	66 90                	xchg   %ax,%ax
    return -1;
80102770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102775:	c3                   	ret    
80102776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277d:	8d 76 00             	lea    0x0(%esi),%esi

80102780 <kbdintr>:

void
kbdintr(void)
{
80102780:	f3 0f 1e fb          	endbr32 
80102784:	55                   	push   %ebp
80102785:	89 e5                	mov    %esp,%ebp
80102787:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010278a:	68 a0 26 10 80       	push   $0x801026a0
8010278f:	e8 cc e0 ff ff       	call   80100860 <consoleintr>
}
80102794:	83 c4 10             	add    $0x10,%esp
80102797:	c9                   	leave  
80102798:	c3                   	ret    
80102799:	66 90                	xchg   %ax,%ax
8010279b:	66 90                	xchg   %ax,%ax
8010279d:	66 90                	xchg   %ax,%ax
8010279f:	90                   	nop

801027a0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027a0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027a4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801027a9:	85 c0                	test   %eax,%eax
801027ab:	0f 84 c7 00 00 00    	je     80102878 <lapicinit+0xd8>
  lapic[index] = value;
801027b1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027b8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027be:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027c5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027cb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027d2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027d5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027df:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027e2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027ec:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ef:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027f9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027fc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027ff:	8b 50 30             	mov    0x30(%eax),%edx
80102802:	c1 ea 10             	shr    $0x10,%edx
80102805:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010280b:	75 73                	jne    80102880 <lapicinit+0xe0>
  lapic[index] = value;
8010280d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102814:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102821:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102827:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010282e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010283b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102848:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102855:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102858:	8b 50 20             	mov    0x20(%eax),%edx
8010285b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010285f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102860:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102866:	80 e6 10             	and    $0x10,%dh
80102869:	75 f5                	jne    80102860 <lapicinit+0xc0>
  lapic[index] = value;
8010286b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102872:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102875:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102878:	c3                   	ret    
80102879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102880:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102887:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010288d:	e9 7b ff ff ff       	jmp    8010280d <lapicinit+0x6d>
80102892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028a0 <lapicid>:

int
lapicid(void)
{
801028a0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028a4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028a9:	85 c0                	test   %eax,%eax
801028ab:	74 0b                	je     801028b8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028ad:	8b 40 20             	mov    0x20(%eax),%eax
801028b0:	c1 e8 18             	shr    $0x18,%eax
801028b3:	c3                   	ret    
801028b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028b8:	31 c0                	xor    %eax,%eax
}
801028ba:	c3                   	ret    
801028bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop

801028c0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028c0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028c4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028c9:	85 c0                	test   %eax,%eax
801028cb:	74 0d                	je     801028da <lapiceoi+0x1a>
  lapic[index] = value;
801028cd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028da:	c3                   	ret    
801028db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028df:	90                   	nop

801028e0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028e0:	f3 0f 1e fb          	endbr32 
}
801028e4:	c3                   	ret    
801028e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028f0:	f3 0f 1e fb          	endbr32 
801028f4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f5:	b8 0f 00 00 00       	mov    $0xf,%eax
801028fa:	ba 70 00 00 00       	mov    $0x70,%edx
801028ff:	89 e5                	mov    %esp,%ebp
80102901:	53                   	push   %ebx
80102902:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102905:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102908:	ee                   	out    %al,(%dx)
80102909:	b8 0a 00 00 00       	mov    $0xa,%eax
8010290e:	ba 71 00 00 00       	mov    $0x71,%edx
80102913:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102914:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102916:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102919:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010291f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102921:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102924:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102926:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102929:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010292c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102932:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102937:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010293d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102940:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102947:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010294a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010294d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102954:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102957:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102960:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102963:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102972:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102975:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010297b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010297c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010297f:	5d                   	pop    %ebp
80102980:	c3                   	ret    
80102981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298f:	90                   	nop

80102990 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102990:	f3 0f 1e fb          	endbr32 
80102994:	55                   	push   %ebp
80102995:	b8 0b 00 00 00       	mov    $0xb,%eax
8010299a:	ba 70 00 00 00       	mov    $0x70,%edx
8010299f:	89 e5                	mov    %esp,%ebp
801029a1:	57                   	push   %edi
801029a2:	56                   	push   %esi
801029a3:	53                   	push   %ebx
801029a4:	83 ec 4c             	sub    $0x4c,%esp
801029a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a8:	ba 71 00 00 00       	mov    $0x71,%edx
801029ad:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ae:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029b6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029c0:	31 c0                	xor    %eax,%eax
801029c2:	89 da                	mov    %ebx,%edx
801029c4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029ca:	89 ca                	mov    %ecx,%edx
801029cc:	ec                   	in     (%dx),%al
801029cd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d0:	89 da                	mov    %ebx,%edx
801029d2:	b8 02 00 00 00       	mov    $0x2,%eax
801029d7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d8:	89 ca                	mov    %ecx,%edx
801029da:	ec                   	in     (%dx),%al
801029db:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029de:	89 da                	mov    %ebx,%edx
801029e0:	b8 04 00 00 00       	mov    $0x4,%eax
801029e5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e6:	89 ca                	mov    %ecx,%edx
801029e8:	ec                   	in     (%dx),%al
801029e9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ec:	89 da                	mov    %ebx,%edx
801029ee:	b8 07 00 00 00       	mov    $0x7,%eax
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	89 ca                	mov    %ecx,%edx
801029f6:	ec                   	in     (%dx),%al
801029f7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	b8 08 00 00 00       	mov    $0x8,%eax
80102a01:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a07:	89 da                	mov    %ebx,%edx
80102a09:	b8 09 00 00 00       	mov    $0x9,%eax
80102a0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0f:	89 ca                	mov    %ecx,%edx
80102a11:	ec                   	in     (%dx),%al
80102a12:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a14:	89 da                	mov    %ebx,%edx
80102a16:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1c:	89 ca                	mov    %ecx,%edx
80102a1e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a1f:	84 c0                	test   %al,%al
80102a21:	78 9d                	js     801029c0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a23:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a27:	89 fa                	mov    %edi,%edx
80102a29:	0f b6 fa             	movzbl %dl,%edi
80102a2c:	89 f2                	mov    %esi,%edx
80102a2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a31:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a35:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a38:	89 da                	mov    %ebx,%edx
80102a3a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a3d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a40:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a44:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a47:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a4a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a4e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a51:	31 c0                	xor    %eax,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al
80102a57:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5a:	89 da                	mov    %ebx,%edx
80102a5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a5f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a64:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a65:	89 ca                	mov    %ecx,%edx
80102a67:	ec                   	in     (%dx),%al
80102a68:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6b:	89 da                	mov    %ebx,%edx
80102a6d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a70:	b8 04 00 00 00       	mov    $0x4,%eax
80102a75:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a76:	89 ca                	mov    %ecx,%edx
80102a78:	ec                   	in     (%dx),%al
80102a79:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7c:	89 da                	mov    %ebx,%edx
80102a7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a81:	b8 07 00 00 00       	mov    $0x7,%eax
80102a86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a87:	89 ca                	mov    %ecx,%edx
80102a89:	ec                   	in     (%dx),%al
80102a8a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8d:	89 da                	mov    %ebx,%edx
80102a8f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a92:	b8 08 00 00 00       	mov    $0x8,%eax
80102a97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a98:	89 ca                	mov    %ecx,%edx
80102a9a:	ec                   	in     (%dx),%al
80102a9b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9e:	89 da                	mov    %ebx,%edx
80102aa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aa3:	b8 09 00 00 00       	mov    $0x9,%eax
80102aa8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa9:	89 ca                	mov    %ecx,%edx
80102aab:	ec                   	in     (%dx),%al
80102aac:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aaf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ab2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ab5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ab8:	6a 18                	push   $0x18
80102aba:	50                   	push   %eax
80102abb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102abe:	50                   	push   %eax
80102abf:	e8 4c 22 00 00       	call   80104d10 <memcmp>
80102ac4:	83 c4 10             	add    $0x10,%esp
80102ac7:	85 c0                	test   %eax,%eax
80102ac9:	0f 85 f1 fe ff ff    	jne    801029c0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102acf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ad3:	75 78                	jne    80102b4d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ad5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ad8:	89 c2                	mov    %eax,%edx
80102ada:	83 e0 0f             	and    $0xf,%eax
80102add:	c1 ea 04             	shr    $0x4,%edx
80102ae0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ae3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ae6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ae9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102aec:	89 c2                	mov    %eax,%edx
80102aee:	83 e0 0f             	and    $0xf,%eax
80102af1:	c1 ea 04             	shr    $0x4,%edx
80102af4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102afa:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102afd:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b00:	89 c2                	mov    %eax,%edx
80102b02:	83 e0 0f             	and    $0xf,%eax
80102b05:	c1 ea 04             	shr    $0x4,%edx
80102b08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b11:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b14:	89 c2                	mov    %eax,%edx
80102b16:	83 e0 0f             	and    $0xf,%eax
80102b19:	c1 ea 04             	shr    $0x4,%edx
80102b1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b22:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b25:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b28:	89 c2                	mov    %eax,%edx
80102b2a:	83 e0 0f             	and    $0xf,%eax
80102b2d:	c1 ea 04             	shr    $0x4,%edx
80102b30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b36:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b39:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b3c:	89 c2                	mov    %eax,%edx
80102b3e:	83 e0 0f             	and    $0xf,%eax
80102b41:	c1 ea 04             	shr    $0x4,%edx
80102b44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b4d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b50:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b53:	89 06                	mov    %eax,(%esi)
80102b55:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b58:	89 46 04             	mov    %eax,0x4(%esi)
80102b5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b5e:	89 46 08             	mov    %eax,0x8(%esi)
80102b61:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b64:	89 46 0c             	mov    %eax,0xc(%esi)
80102b67:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b6a:	89 46 10             	mov    %eax,0x10(%esi)
80102b6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b70:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b73:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b7d:	5b                   	pop    %ebx
80102b7e:	5e                   	pop    %esi
80102b7f:	5f                   	pop    %edi
80102b80:	5d                   	pop    %ebp
80102b81:	c3                   	ret    
80102b82:	66 90                	xchg   %ax,%ax
80102b84:	66 90                	xchg   %ax,%ax
80102b86:	66 90                	xchg   %ax,%ax
80102b88:	66 90                	xchg   %ax,%ax
80102b8a:	66 90                	xchg   %ax,%ax
80102b8c:	66 90                	xchg   %ax,%ax
80102b8e:	66 90                	xchg   %ax,%ax

80102b90 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b90:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102b96:	85 c9                	test   %ecx,%ecx
80102b98:	0f 8e 8a 00 00 00    	jle    80102c28 <install_trans+0x98>
{
80102b9e:	55                   	push   %ebp
80102b9f:	89 e5                	mov    %esp,%ebp
80102ba1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ba2:	31 ff                	xor    %edi,%edi
{
80102ba4:	56                   	push   %esi
80102ba5:	53                   	push   %ebx
80102ba6:	83 ec 0c             	sub    $0xc,%esp
80102ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bb0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102bb5:	83 ec 08             	sub    $0x8,%esp
80102bb8:	01 f8                	add    %edi,%eax
80102bba:	83 c0 01             	add    $0x1,%eax
80102bbd:	50                   	push   %eax
80102bbe:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102bc4:	e8 07 d5 ff ff       	call   801000d0 <bread>
80102bc9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bcb:	58                   	pop    %eax
80102bcc:	5a                   	pop    %edx
80102bcd:	ff 34 bd cc 36 11 80 	pushl  -0x7feec934(,%edi,4)
80102bd4:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bda:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdd:	e8 ee d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102be5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bea:	68 00 02 00 00       	push   $0x200
80102bef:	50                   	push   %eax
80102bf0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102bf3:	50                   	push   %eax
80102bf4:	e8 67 21 00 00       	call   80104d60 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bf9:	89 1c 24             	mov    %ebx,(%esp)
80102bfc:	e8 af d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c01:	89 34 24             	mov    %esi,(%esp)
80102c04:	e8 e7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 df d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	39 3d c8 36 11 80    	cmp    %edi,0x801136c8
80102c1a:	7f 94                	jg     80102bb0 <install_trans+0x20>
  }
}
80102c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c1f:	5b                   	pop    %ebx
80102c20:	5e                   	pop    %esi
80102c21:	5f                   	pop    %edi
80102c22:	5d                   	pop    %ebp
80102c23:	c3                   	ret    
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c28:	c3                   	ret    
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	53                   	push   %ebx
80102c34:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c37:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102c3d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102c43:	e8 88 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c48:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c4b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c4d:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102c52:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c55:	85 c0                	test   %eax,%eax
80102c57:	7e 19                	jle    80102c72 <write_head+0x42>
80102c59:	31 d2                	xor    %edx,%edx
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c60:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102c67:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c6b:	83 c2 01             	add    $0x1,%edx
80102c6e:	39 d0                	cmp    %edx,%eax
80102c70:	75 ee                	jne    80102c60 <write_head+0x30>
  }
  bwrite(buf);
80102c72:	83 ec 0c             	sub    $0xc,%esp
80102c75:	53                   	push   %ebx
80102c76:	e8 35 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c7b:	89 1c 24             	mov    %ebx,(%esp)
80102c7e:	e8 6d d5 ff ff       	call   801001f0 <brelse>
}
80102c83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c86:	83 c4 10             	add    $0x10,%esp
80102c89:	c9                   	leave  
80102c8a:	c3                   	ret    
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop

80102c90 <initlog>:
{
80102c90:	f3 0f 1e fb          	endbr32 
80102c94:	55                   	push   %ebp
80102c95:	89 e5                	mov    %esp,%ebp
80102c97:	53                   	push   %ebx
80102c98:	83 ec 2c             	sub    $0x2c,%esp
80102c9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c9e:	68 e0 7c 10 80       	push   $0x80107ce0
80102ca3:	68 80 36 11 80       	push   $0x80113680
80102ca8:	e8 83 1d 00 00       	call   80104a30 <initlock>
  readsb(dev, &sb);
80102cad:	58                   	pop    %eax
80102cae:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cb1:	5a                   	pop    %edx
80102cb2:	50                   	push   %eax
80102cb3:	53                   	push   %ebx
80102cb4:	e8 47 e8 ff ff       	call   80101500 <readsb>
  log.start = sb.logstart;
80102cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cbc:	59                   	pop    %ecx
  log.dev = dev;
80102cbd:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102cc3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cc6:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  log.size = sb.nlog;
80102ccb:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  struct buf *buf = bread(log.dev, log.start);
80102cd1:	5a                   	pop    %edx
80102cd2:	50                   	push   %eax
80102cd3:	53                   	push   %ebx
80102cd4:	e8 f7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102cd9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cdc:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cdf:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	85 c9                	test   %ecx,%ecx
80102ce7:	7e 19                	jle    80102d02 <initlog+0x72>
80102ce9:	31 d2                	xor    %edx,%edx
80102ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102cf0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102cf4:	89 1c 95 cc 36 11 80 	mov    %ebx,-0x7feec934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cfb:	83 c2 01             	add    $0x1,%edx
80102cfe:	39 d1                	cmp    %edx,%ecx
80102d00:	75 ee                	jne    80102cf0 <initlog+0x60>
  brelse(buf);
80102d02:	83 ec 0c             	sub    $0xc,%esp
80102d05:	50                   	push   %eax
80102d06:	e8 e5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d0b:	e8 80 fe ff ff       	call   80102b90 <install_trans>
  log.lh.n = 0;
80102d10:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d17:	00 00 00 
  write_head(); // clear the log
80102d1a:	e8 11 ff ff ff       	call   80102c30 <write_head>
}
80102d1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d22:	83 c4 10             	add    $0x10,%esp
80102d25:	c9                   	leave  
80102d26:	c3                   	ret    
80102d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2e:	66 90                	xchg   %ax,%ax

80102d30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d30:	f3 0f 1e fb          	endbr32 
80102d34:	55                   	push   %ebp
80102d35:	89 e5                	mov    %esp,%ebp
80102d37:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d3a:	68 80 36 11 80       	push   $0x80113680
80102d3f:	e8 6c 1e 00 00       	call   80104bb0 <acquire>
80102d44:	83 c4 10             	add    $0x10,%esp
80102d47:	eb 1c                	jmp    80102d65 <begin_op+0x35>
80102d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d50:	83 ec 08             	sub    $0x8,%esp
80102d53:	68 80 36 11 80       	push   $0x80113680
80102d58:	68 80 36 11 80       	push   $0x80113680
80102d5d:	e8 ee 16 00 00       	call   80104450 <sleep>
80102d62:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d65:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102d6a:	85 c0                	test   %eax,%eax
80102d6c:	75 e2                	jne    80102d50 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d6e:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102d73:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102d79:	83 c0 01             	add    $0x1,%eax
80102d7c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d7f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d82:	83 fa 1e             	cmp    $0x1e,%edx
80102d85:	7f c9                	jg     80102d50 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d87:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d8a:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102d8f:	68 80 36 11 80       	push   $0x80113680
80102d94:	e8 d7 1e 00 00       	call   80104c70 <release>
      break;
    }
  }
}
80102d99:	83 c4 10             	add    $0x10,%esp
80102d9c:	c9                   	leave  
80102d9d:	c3                   	ret    
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102da0:	f3 0f 1e fb          	endbr32 
80102da4:	55                   	push   %ebp
80102da5:	89 e5                	mov    %esp,%ebp
80102da7:	57                   	push   %edi
80102da8:	56                   	push   %esi
80102da9:	53                   	push   %ebx
80102daa:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dad:	68 80 36 11 80       	push   $0x80113680
80102db2:	e8 f9 1d 00 00       	call   80104bb0 <acquire>
  log.outstanding -= 1;
80102db7:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102dbc:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102dc2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dc8:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102dce:	85 f6                	test   %esi,%esi
80102dd0:	0f 85 1e 01 00 00    	jne    80102ef4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102dd6:	85 db                	test   %ebx,%ebx
80102dd8:	0f 85 f2 00 00 00    	jne    80102ed0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dde:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102de5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102de8:	83 ec 0c             	sub    $0xc,%esp
80102deb:	68 80 36 11 80       	push   $0x80113680
80102df0:	e8 7b 1e 00 00       	call   80104c70 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102df5:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102dfb:	83 c4 10             	add    $0x10,%esp
80102dfe:	85 c9                	test   %ecx,%ecx
80102e00:	7f 3e                	jg     80102e40 <end_op+0xa0>
    acquire(&log.lock);
80102e02:	83 ec 0c             	sub    $0xc,%esp
80102e05:	68 80 36 11 80       	push   $0x80113680
80102e0a:	e8 a1 1d 00 00       	call   80104bb0 <acquire>
    wakeup(&log);
80102e0f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102e16:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102e1d:	00 00 00 
    wakeup(&log);
80102e20:	e8 fb 17 00 00       	call   80104620 <wakeup>
    release(&log.lock);
80102e25:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102e2c:	e8 3f 1e 00 00       	call   80104c70 <release>
80102e31:	83 c4 10             	add    $0x10,%esp
}
80102e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e37:	5b                   	pop    %ebx
80102e38:	5e                   	pop    %esi
80102e39:	5f                   	pop    %edi
80102e3a:	5d                   	pop    %ebp
80102e3b:	c3                   	ret    
80102e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e40:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	01 d8                	add    %ebx,%eax
80102e4a:	83 c0 01             	add    $0x1,%eax
80102e4d:	50                   	push   %eax
80102e4e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
80102e59:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e5b:	58                   	pop    %eax
80102e5c:	5a                   	pop    %edx
80102e5d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102e64:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6d:	e8 5e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e72:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e75:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e77:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e7a:	68 00 02 00 00       	push   $0x200
80102e7f:	50                   	push   %eax
80102e80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e83:	50                   	push   %eax
80102e84:	e8 d7 1e 00 00       	call   80104d60 <memmove>
    bwrite(to);  // write the log
80102e89:	89 34 24             	mov    %esi,(%esp)
80102e8c:	e8 1f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102e91:	89 3c 24             	mov    %edi,(%esp)
80102e94:	e8 57 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 4f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ea1:	83 c4 10             	add    $0x10,%esp
80102ea4:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102eaa:	7c 94                	jl     80102e40 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eac:	e8 7f fd ff ff       	call   80102c30 <write_head>
    install_trans(); // Now install writes to home locations
80102eb1:	e8 da fc ff ff       	call   80102b90 <install_trans>
    log.lh.n = 0;
80102eb6:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ebd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ec0:	e8 6b fd ff ff       	call   80102c30 <write_head>
80102ec5:	e9 38 ff ff ff       	jmp    80102e02 <end_op+0x62>
80102eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ed0:	83 ec 0c             	sub    $0xc,%esp
80102ed3:	68 80 36 11 80       	push   $0x80113680
80102ed8:	e8 43 17 00 00       	call   80104620 <wakeup>
  release(&log.lock);
80102edd:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102ee4:	e8 87 1d 00 00       	call   80104c70 <release>
80102ee9:	83 c4 10             	add    $0x10,%esp
}
80102eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eef:	5b                   	pop    %ebx
80102ef0:	5e                   	pop    %esi
80102ef1:	5f                   	pop    %edi
80102ef2:	5d                   	pop    %ebp
80102ef3:	c3                   	ret    
    panic("log.committing");
80102ef4:	83 ec 0c             	sub    $0xc,%esp
80102ef7:	68 e4 7c 10 80       	push   $0x80107ce4
80102efc:	e8 8f d4 ff ff       	call   80100390 <panic>
80102f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0f:	90                   	nop

80102f10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f10:	f3 0f 1e fb          	endbr32 
80102f14:	55                   	push   %ebp
80102f15:	89 e5                	mov    %esp,%ebp
80102f17:	53                   	push   %ebx
80102f18:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f1b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102f21:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f24:	83 fa 1d             	cmp    $0x1d,%edx
80102f27:	0f 8f 91 00 00 00    	jg     80102fbe <log_write+0xae>
80102f2d:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102f32:	83 e8 01             	sub    $0x1,%eax
80102f35:	39 c2                	cmp    %eax,%edx
80102f37:	0f 8d 81 00 00 00    	jge    80102fbe <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f3d:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f42:	85 c0                	test   %eax,%eax
80102f44:	0f 8e 81 00 00 00    	jle    80102fcb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 80 36 11 80       	push   $0x80113680
80102f52:	e8 59 1c 00 00       	call   80104bb0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f57:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102f5d:	83 c4 10             	add    $0x10,%esp
80102f60:	85 d2                	test   %edx,%edx
80102f62:	7e 4e                	jle    80102fb2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f64:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f67:	31 c0                	xor    %eax,%eax
80102f69:	eb 0c                	jmp    80102f77 <log_write+0x67>
80102f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f6f:	90                   	nop
80102f70:	83 c0 01             	add    $0x1,%eax
80102f73:	39 c2                	cmp    %eax,%edx
80102f75:	74 29                	je     80102fa0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f77:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102f7e:	75 f0                	jne    80102f70 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f87:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f8d:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102f94:	c9                   	leave  
  release(&log.lock);
80102f95:	e9 d6 1c 00 00       	jmp    80104c70 <release>
80102f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
    log.lh.n++;
80102fa7:	83 c2 01             	add    $0x1,%edx
80102faa:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
80102fb0:	eb d5                	jmp    80102f87 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fb2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fb5:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102fba:	75 cb                	jne    80102f87 <log_write+0x77>
80102fbc:	eb e9                	jmp    80102fa7 <log_write+0x97>
    panic("too big a transaction");
80102fbe:	83 ec 0c             	sub    $0xc,%esp
80102fc1:	68 f3 7c 10 80       	push   $0x80107cf3
80102fc6:	e8 c5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fcb:	83 ec 0c             	sub    $0xc,%esp
80102fce:	68 09 7d 10 80       	push   $0x80107d09
80102fd3:	e8 b8 d3 ff ff       	call   80100390 <panic>
80102fd8:	66 90                	xchg   %ax,%ax
80102fda:	66 90                	xchg   %ax,%ax
80102fdc:	66 90                	xchg   %ax,%ax
80102fde:	66 90                	xchg   %ax,%ax

80102fe0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	53                   	push   %ebx
80102fe4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fe7:	e8 14 0b 00 00       	call   80103b00 <cpuid>
80102fec:	89 c3                	mov    %eax,%ebx
80102fee:	e8 0d 0b 00 00       	call   80103b00 <cpuid>
80102ff3:	83 ec 04             	sub    $0x4,%esp
80102ff6:	53                   	push   %ebx
80102ff7:	50                   	push   %eax
80102ff8:	68 24 7d 10 80       	push   $0x80107d24
80102ffd:	e8 ae d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103002:	e8 39 30 00 00       	call   80106040 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103007:	e8 84 0a 00 00       	call   80103a90 <mycpu>
8010300c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010300e:	b8 01 00 00 00       	mov    $0x1,%eax
80103013:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010301a:	e8 21 11 00 00       	call   80104140 <scheduler>
8010301f:	90                   	nop

80103020 <mpenter>:
{
80103020:	f3 0f 1e fb          	endbr32 
80103024:	55                   	push   %ebp
80103025:	89 e5                	mov    %esp,%ebp
80103027:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010302a:	e8 11 41 00 00       	call   80107140 <switchkvm>
  seginit();
8010302f:	e8 7c 40 00 00       	call   801070b0 <seginit>
  lapicinit();
80103034:	e8 67 f7 ff ff       	call   801027a0 <lapicinit>
  mpmain();
80103039:	e8 a2 ff ff ff       	call   80102fe0 <mpmain>
8010303e:	66 90                	xchg   %ax,%ax

80103040 <main>:
{
80103040:	f3 0f 1e fb          	endbr32 
80103044:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103048:	83 e4 f0             	and    $0xfffffff0,%esp
8010304b:	ff 71 fc             	pushl  -0x4(%ecx)
8010304e:	55                   	push   %ebp
  sched_type = 0;
8010304f:	c7 05 18 0f 11 80 00 	movl   $0x0,0x80110f18
80103056:	00 00 00 
{
80103059:	89 e5                	mov    %esp,%ebp
8010305b:	53                   	push   %ebx
8010305c:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010305d:	83 ec 08             	sub    $0x8,%esp
80103060:	68 00 00 40 80       	push   $0x80400000
80103065:	68 a8 6c 11 80       	push   $0x80116ca8
8010306a:	e8 f1 f4 ff ff       	call   80102560 <kinit1>
  kvmalloc();      // kernel page table
8010306f:	e8 ac 45 00 00       	call   80107620 <kvmalloc>
  mpinit();        // detect other processors
80103074:	e8 87 01 00 00       	call   80103200 <mpinit>
  lapicinit();     // interrupt controller
80103079:	e8 22 f7 ff ff       	call   801027a0 <lapicinit>
  seginit();       // segment descriptors
8010307e:	e8 2d 40 00 00       	call   801070b0 <seginit>
  picinit();       // disable pic
80103083:	e8 58 03 00 00       	call   801033e0 <picinit>
  ioapicinit();    // another interrupt controller
80103088:	e8 f3 f2 ff ff       	call   80102380 <ioapicinit>
  consoleinit();   // console hardware
8010308d:	e8 9e d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103092:	e8 d9 32 00 00       	call   80106370 <uartinit>
  pinit();         // process table
80103097:	e8 d4 09 00 00       	call   80103a70 <pinit>
  tvinit();        // trap vectors
8010309c:	e8 1f 2f 00 00       	call   80105fc0 <tvinit>
  binit();         // buffer cache
801030a1:	e8 9a cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030a6:	e8 35 dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
801030ab:	e8 a0 f0 ff ff       	call   80102150 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030b0:	83 c4 0c             	add    $0xc,%esp
801030b3:	68 8a 00 00 00       	push   $0x8a
801030b8:	68 8c b4 10 80       	push   $0x8010b48c
801030bd:	68 00 70 00 80       	push   $0x80007000
801030c2:	e8 99 1c 00 00       	call   80104d60 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030c7:	83 c4 10             	add    $0x10,%esp
801030ca:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801030d1:	00 00 00 
801030d4:	05 80 37 11 80       	add    $0x80113780,%eax
801030d9:	3d 80 37 11 80       	cmp    $0x80113780,%eax
801030de:	0f 86 7c 00 00 00    	jbe    80103160 <main+0x120>
801030e4:	bb 80 37 11 80       	mov    $0x80113780,%ebx
801030e9:	eb 1e                	jmp    80103109 <main+0xc9>
801030eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030ef:	90                   	nop
801030f0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801030f7:	00 00 00 
801030fa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103100:	05 80 37 11 80       	add    $0x80113780,%eax
80103105:	39 c3                	cmp    %eax,%ebx
80103107:	73 57                	jae    80103160 <main+0x120>
    if(c == mycpu())  // We've started already.
80103109:	e8 82 09 00 00       	call   80103a90 <mycpu>
8010310e:	39 c3                	cmp    %eax,%ebx
80103110:	74 de                	je     801030f0 <main+0xb0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103112:	e8 19 f5 ff ff       	call   80102630 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103117:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010311a:	c7 05 f8 6f 00 80 20 	movl   $0x80103020,0x80006ff8
80103121:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103124:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010312b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010312e:	05 00 10 00 00       	add    $0x1000,%eax
80103133:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103138:	0f b6 03             	movzbl (%ebx),%eax
8010313b:	68 00 70 00 00       	push   $0x7000
80103140:	50                   	push   %eax
80103141:	e8 aa f7 ff ff       	call   801028f0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103146:	83 c4 10             	add    $0x10,%esp
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103150:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103156:	85 c0                	test   %eax,%eax
80103158:	74 f6                	je     80103150 <main+0x110>
8010315a:	eb 94                	jmp    801030f0 <main+0xb0>
8010315c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103160:	83 ec 08             	sub    $0x8,%esp
80103163:	68 00 00 00 8e       	push   $0x8e000000
80103168:	68 00 00 40 80       	push   $0x80400000
8010316d:	e8 5e f4 ff ff       	call   801025d0 <kinit2>
  userinit();      // first user process
80103172:	e8 69 0a 00 00       	call   80103be0 <userinit>
  mpmain();        // finish this processor's setup
80103177:	e8 64 fe ff ff       	call   80102fe0 <mpmain>
8010317c:	66 90                	xchg   %ax,%ax
8010317e:	66 90                	xchg   %ax,%ax

80103180 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103185:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010318b:	53                   	push   %ebx
  e = addr+len;
8010318c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010318f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103192:	39 de                	cmp    %ebx,%esi
80103194:	72 10                	jb     801031a6 <mpsearch1+0x26>
80103196:	eb 50                	jmp    801031e8 <mpsearch1+0x68>
80103198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010319f:	90                   	nop
801031a0:	89 fe                	mov    %edi,%esi
801031a2:	39 fb                	cmp    %edi,%ebx
801031a4:	76 42                	jbe    801031e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031a6:	83 ec 04             	sub    $0x4,%esp
801031a9:	8d 7e 10             	lea    0x10(%esi),%edi
801031ac:	6a 04                	push   $0x4
801031ae:	68 38 7d 10 80       	push   $0x80107d38
801031b3:	56                   	push   %esi
801031b4:	e8 57 1b 00 00       	call   80104d10 <memcmp>
801031b9:	83 c4 10             	add    $0x10,%esp
801031bc:	85 c0                	test   %eax,%eax
801031be:	75 e0                	jne    801031a0 <mpsearch1+0x20>
801031c0:	89 f2                	mov    %esi,%edx
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031c8:	0f b6 0a             	movzbl (%edx),%ecx
801031cb:	83 c2 01             	add    $0x1,%edx
801031ce:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031d0:	39 fa                	cmp    %edi,%edx
801031d2:	75 f4                	jne    801031c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d4:	84 c0                	test   %al,%al
801031d6:	75 c8                	jne    801031a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031db:	89 f0                	mov    %esi,%eax
801031dd:	5b                   	pop    %ebx
801031de:	5e                   	pop    %esi
801031df:	5f                   	pop    %edi
801031e0:	5d                   	pop    %ebp
801031e1:	c3                   	ret    
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031eb:	31 f6                	xor    %esi,%esi
}
801031ed:	5b                   	pop    %ebx
801031ee:	89 f0                	mov    %esi,%eax
801031f0:	5e                   	pop    %esi
801031f1:	5f                   	pop    %edi
801031f2:	5d                   	pop    %ebp
801031f3:	c3                   	ret    
801031f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ff:	90                   	nop

80103200 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103200:	f3 0f 1e fb          	endbr32 
80103204:	55                   	push   %ebp
80103205:	89 e5                	mov    %esp,%ebp
80103207:	57                   	push   %edi
80103208:	56                   	push   %esi
80103209:	53                   	push   %ebx
8010320a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010320d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103214:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010321b:	c1 e0 08             	shl    $0x8,%eax
8010321e:	09 d0                	or     %edx,%eax
80103220:	c1 e0 04             	shl    $0x4,%eax
80103223:	75 1b                	jne    80103240 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103225:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010322c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103233:	c1 e0 08             	shl    $0x8,%eax
80103236:	09 d0                	or     %edx,%eax
80103238:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010323b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103240:	ba 00 04 00 00       	mov    $0x400,%edx
80103245:	e8 36 ff ff ff       	call   80103180 <mpsearch1>
8010324a:	89 c6                	mov    %eax,%esi
8010324c:	85 c0                	test   %eax,%eax
8010324e:	0f 84 4c 01 00 00    	je     801033a0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103254:	8b 5e 04             	mov    0x4(%esi),%ebx
80103257:	85 db                	test   %ebx,%ebx
80103259:	0f 84 61 01 00 00    	je     801033c0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010325f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103262:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103268:	6a 04                	push   $0x4
8010326a:	68 3d 7d 10 80       	push   $0x80107d3d
8010326f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103273:	e8 98 1a 00 00       	call   80104d10 <memcmp>
80103278:	83 c4 10             	add    $0x10,%esp
8010327b:	85 c0                	test   %eax,%eax
8010327d:	0f 85 3d 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103283:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010328a:	3c 01                	cmp    $0x1,%al
8010328c:	74 08                	je     80103296 <mpinit+0x96>
8010328e:	3c 04                	cmp    $0x4,%al
80103290:	0f 85 2a 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103296:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010329d:	66 85 d2             	test   %dx,%dx
801032a0:	74 26                	je     801032c8 <mpinit+0xc8>
801032a2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032a5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032a7:	31 d2                	xor    %edx,%edx
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032b0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032b7:	83 c0 01             	add    $0x1,%eax
801032ba:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032bc:	39 f8                	cmp    %edi,%eax
801032be:	75 f0                	jne    801032b0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032c0:	84 d2                	test   %dl,%dl
801032c2:	0f 85 f8 00 00 00    	jne    801033c0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032c8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032ce:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032d9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032e0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032e8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ef:	90                   	nop
801032f0:	39 c2                	cmp    %eax,%edx
801032f2:	76 15                	jbe    80103309 <mpinit+0x109>
    switch(*p){
801032f4:	0f b6 08             	movzbl (%eax),%ecx
801032f7:	80 f9 02             	cmp    $0x2,%cl
801032fa:	74 5c                	je     80103358 <mpinit+0x158>
801032fc:	77 42                	ja     80103340 <mpinit+0x140>
801032fe:	84 c9                	test   %cl,%cl
80103300:	74 6e                	je     80103370 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103302:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103305:	39 c2                	cmp    %eax,%edx
80103307:	77 eb                	ja     801032f4 <mpinit+0xf4>
80103309:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010330c:	85 db                	test   %ebx,%ebx
8010330e:	0f 84 b9 00 00 00    	je     801033cd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103314:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103318:	74 15                	je     8010332f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331a:	b8 70 00 00 00       	mov    $0x70,%eax
8010331f:	ba 22 00 00 00       	mov    $0x22,%edx
80103324:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103325:	ba 23 00 00 00       	mov    $0x23,%edx
8010332a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010332b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332e:	ee                   	out    %al,(%dx)
  }
}
8010332f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103332:	5b                   	pop    %ebx
80103333:	5e                   	pop    %esi
80103334:	5f                   	pop    %edi
80103335:	5d                   	pop    %ebp
80103336:	c3                   	ret    
80103337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010333e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 ba                	jbe    80103302 <mpinit+0x102>
80103348:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010334f:	eb 9f                	jmp    801032f0 <mpinit+0xf0>
80103351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103358:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010335c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010335f:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      continue;
80103365:	eb 89                	jmp    801032f0 <mpinit+0xf0>
80103367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103370:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f 80 37 11 80    	mov    %bl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 54 ff ff ff       	jmp    801032f0 <mpinit+0xf0>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033aa:	e8 d1 fd ff ff       	call   80103180 <mpsearch1>
801033af:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033b1:	85 c0                	test   %eax,%eax
801033b3:	0f 85 9b fe ff ff    	jne    80103254 <mpinit+0x54>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033c0:	83 ec 0c             	sub    $0xc,%esp
801033c3:	68 42 7d 10 80       	push   $0x80107d42
801033c8:	e8 c3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033cd:	83 ec 0c             	sub    $0xc,%esp
801033d0:	68 5c 7d 10 80       	push   $0x80107d5c
801033d5:	e8 b6 cf ff ff       	call   80100390 <panic>
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033e0:	f3 0f 1e fb          	endbr32 
801033e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033e9:	ba 21 00 00 00       	mov    $0x21,%edx
801033ee:	ee                   	out    %al,(%dx)
801033ef:	ba a1 00 00 00       	mov    $0xa1,%edx
801033f4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033f5:	c3                   	ret    
801033f6:	66 90                	xchg   %ax,%ax
801033f8:	66 90                	xchg   %ax,%ax
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103400:	f3 0f 1e fb          	endbr32 
80103404:	55                   	push   %ebp
80103405:	89 e5                	mov    %esp,%ebp
80103407:	57                   	push   %edi
80103408:	56                   	push   %esi
80103409:	53                   	push   %ebx
8010340a:	83 ec 0c             	sub    $0xc,%esp
8010340d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103410:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103413:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103419:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010341f:	e8 dc d9 ff ff       	call   80100e00 <filealloc>
80103424:	89 03                	mov    %eax,(%ebx)
80103426:	85 c0                	test   %eax,%eax
80103428:	0f 84 ac 00 00 00    	je     801034da <pipealloc+0xda>
8010342e:	e8 cd d9 ff ff       	call   80100e00 <filealloc>
80103433:	89 06                	mov    %eax,(%esi)
80103435:	85 c0                	test   %eax,%eax
80103437:	0f 84 8b 00 00 00    	je     801034c8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010343d:	e8 ee f1 ff ff       	call   80102630 <kalloc>
80103442:	89 c7                	mov    %eax,%edi
80103444:	85 c0                	test   %eax,%eax
80103446:	0f 84 b4 00 00 00    	je     80103500 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010344c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103453:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103456:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103459:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103460:	00 00 00 
  p->nwrite = 0;
80103463:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010346a:	00 00 00 
  p->nread = 0;
8010346d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103474:	00 00 00 
  initlock(&p->lock, "pipe");
80103477:	68 7b 7d 10 80       	push   $0x80107d7b
8010347c:	50                   	push   %eax
8010347d:	e8 ae 15 00 00       	call   80104a30 <initlock>
  (*f0)->type = FD_PIPE;
80103482:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103484:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103487:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010348d:	8b 03                	mov    (%ebx),%eax
8010348f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103493:	8b 03                	mov    (%ebx),%eax
80103495:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103499:	8b 03                	mov    (%ebx),%eax
8010349b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010349e:	8b 06                	mov    (%esi),%eax
801034a0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034a6:	8b 06                	mov    (%esi),%eax
801034a8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034ac:	8b 06                	mov    (%esi),%eax
801034ae:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034b2:	8b 06                	mov    (%esi),%eax
801034b4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034ba:	31 c0                	xor    %eax,%eax
}
801034bc:	5b                   	pop    %ebx
801034bd:	5e                   	pop    %esi
801034be:	5f                   	pop    %edi
801034bf:	5d                   	pop    %ebp
801034c0:	c3                   	ret    
801034c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034c8:	8b 03                	mov    (%ebx),%eax
801034ca:	85 c0                	test   %eax,%eax
801034cc:	74 1e                	je     801034ec <pipealloc+0xec>
    fileclose(*f0);
801034ce:	83 ec 0c             	sub    $0xc,%esp
801034d1:	50                   	push   %eax
801034d2:	e8 e9 d9 ff ff       	call   80100ec0 <fileclose>
801034d7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	85 c0                	test   %eax,%eax
801034de:	74 0c                	je     801034ec <pipealloc+0xec>
    fileclose(*f1);
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	50                   	push   %eax
801034e4:	e8 d7 d9 ff ff       	call   80100ec0 <fileclose>
801034e9:	83 c4 10             	add    $0x10,%esp
}
801034ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034f4:	5b                   	pop    %ebx
801034f5:	5e                   	pop    %esi
801034f6:	5f                   	pop    %edi
801034f7:	5d                   	pop    %ebp
801034f8:	c3                   	ret    
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	75 c8                	jne    801034ce <pipealloc+0xce>
80103506:	eb d2                	jmp    801034da <pipealloc+0xda>
80103508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop

80103510 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103510:	f3 0f 1e fb          	endbr32 
80103514:	55                   	push   %ebp
80103515:	89 e5                	mov    %esp,%ebp
80103517:	56                   	push   %esi
80103518:	53                   	push   %ebx
80103519:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010351c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	53                   	push   %ebx
80103523:	e8 88 16 00 00       	call   80104bb0 <acquire>
  if(writable){
80103528:	83 c4 10             	add    $0x10,%esp
8010352b:	85 f6                	test   %esi,%esi
8010352d:	74 41                	je     80103570 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010352f:	83 ec 0c             	sub    $0xc,%esp
80103532:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103538:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010353f:	00 00 00 
    wakeup(&p->nread);
80103542:	50                   	push   %eax
80103543:	e8 d8 10 00 00       	call   80104620 <wakeup>
80103548:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010354b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103551:	85 d2                	test   %edx,%edx
80103553:	75 0a                	jne    8010355f <pipeclose+0x4f>
80103555:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010355b:	85 c0                	test   %eax,%eax
8010355d:	74 31                	je     80103590 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010355f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103562:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103565:	5b                   	pop    %ebx
80103566:	5e                   	pop    %esi
80103567:	5d                   	pop    %ebp
    release(&p->lock);
80103568:	e9 03 17 00 00       	jmp    80104c70 <release>
8010356d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103579:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103580:	00 00 00 
    wakeup(&p->nwrite);
80103583:	50                   	push   %eax
80103584:	e8 97 10 00 00       	call   80104620 <wakeup>
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	eb bd                	jmp    8010354b <pipeclose+0x3b>
8010358e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 d7 16 00 00       	call   80104c70 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 c6 ee ff ff       	jmp    80102470 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035b0:	f3 0f 1e fb          	endbr32 
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	57                   	push   %edi
801035b8:	56                   	push   %esi
801035b9:	53                   	push   %ebx
801035ba:	83 ec 28             	sub    $0x28,%esp
801035bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035c0:	53                   	push   %ebx
801035c1:	e8 ea 15 00 00       	call   80104bb0 <acquire>
  for(i = 0; i < n; i++){
801035c6:	8b 45 10             	mov    0x10(%ebp),%eax
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	85 c0                	test   %eax,%eax
801035ce:	0f 8e bc 00 00 00    	jle    80103690 <pipewrite+0xe0>
801035d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035d7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035dd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035e6:	03 45 10             	add    0x10(%ebp),%eax
801035e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035ec:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f8:	89 ca                	mov    %ecx,%edx
801035fa:	05 00 02 00 00       	add    $0x200,%eax
801035ff:	39 c1                	cmp    %eax,%ecx
80103601:	74 3b                	je     8010363e <pipewrite+0x8e>
80103603:	eb 63                	jmp    80103668 <pipewrite+0xb8>
80103605:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103608:	e8 13 05 00 00       	call   80103b20 <myproc>
8010360d:	8b 48 24             	mov    0x24(%eax),%ecx
80103610:	85 c9                	test   %ecx,%ecx
80103612:	75 34                	jne    80103648 <pipewrite+0x98>
      wakeup(&p->nread);
80103614:	83 ec 0c             	sub    $0xc,%esp
80103617:	57                   	push   %edi
80103618:	e8 03 10 00 00       	call   80104620 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361d:	58                   	pop    %eax
8010361e:	5a                   	pop    %edx
8010361f:	53                   	push   %ebx
80103620:	56                   	push   %esi
80103621:	e8 2a 0e 00 00       	call   80104450 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103626:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010362c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103632:	83 c4 10             	add    $0x10,%esp
80103635:	05 00 02 00 00       	add    $0x200,%eax
8010363a:	39 c2                	cmp    %eax,%edx
8010363c:	75 2a                	jne    80103668 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010363e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103644:	85 c0                	test   %eax,%eax
80103646:	75 c0                	jne    80103608 <pipewrite+0x58>
        release(&p->lock);
80103648:	83 ec 0c             	sub    $0xc,%esp
8010364b:	53                   	push   %ebx
8010364c:	e8 1f 16 00 00       	call   80104c70 <release>
        return -1;
80103651:	83 c4 10             	add    $0x10,%esp
80103654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103659:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010365c:	5b                   	pop    %ebx
8010365d:	5e                   	pop    %esi
8010365e:	5f                   	pop    %edi
8010365f:	5d                   	pop    %ebp
80103660:	c3                   	ret    
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103668:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010366b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010366e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103674:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010367a:	0f b6 06             	movzbl (%esi),%eax
8010367d:	83 c6 01             	add    $0x1,%esi
80103680:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103683:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103687:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010368a:	0f 85 5c ff ff ff    	jne    801035ec <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103699:	50                   	push   %eax
8010369a:	e8 81 0f 00 00       	call   80104620 <wakeup>
  release(&p->lock);
8010369f:	89 1c 24             	mov    %ebx,(%esp)
801036a2:	e8 c9 15 00 00       	call   80104c70 <release>
  return n;
801036a7:	8b 45 10             	mov    0x10(%ebp),%eax
801036aa:	83 c4 10             	add    $0x10,%esp
801036ad:	eb aa                	jmp    80103659 <pipewrite+0xa9>
801036af:	90                   	nop

801036b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036b0:	f3 0f 1e fb          	endbr32 
801036b4:	55                   	push   %ebp
801036b5:	89 e5                	mov    %esp,%ebp
801036b7:	57                   	push   %edi
801036b8:	56                   	push   %esi
801036b9:	53                   	push   %ebx
801036ba:	83 ec 18             	sub    $0x18,%esp
801036bd:	8b 75 08             	mov    0x8(%ebp),%esi
801036c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036c3:	56                   	push   %esi
801036c4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ca:	e8 e1 14 00 00       	call   80104bb0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036cf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036de:	74 33                	je     80103713 <piperead+0x63>
801036e0:	eb 3b                	jmp    8010371d <piperead+0x6d>
801036e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036e8:	e8 33 04 00 00       	call   80103b20 <myproc>
801036ed:	8b 48 24             	mov    0x24(%eax),%ecx
801036f0:	85 c9                	test   %ecx,%ecx
801036f2:	0f 85 88 00 00 00    	jne    80103780 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036f8:	83 ec 08             	sub    $0x8,%esp
801036fb:	56                   	push   %esi
801036fc:	53                   	push   %ebx
801036fd:	e8 4e 0d 00 00       	call   80104450 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103702:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103708:	83 c4 10             	add    $0x10,%esp
8010370b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103711:	75 0a                	jne    8010371d <piperead+0x6d>
80103713:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103719:	85 c0                	test   %eax,%eax
8010371b:	75 cb                	jne    801036e8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010371d:	8b 55 10             	mov    0x10(%ebp),%edx
80103720:	31 db                	xor    %ebx,%ebx
80103722:	85 d2                	test   %edx,%edx
80103724:	7f 28                	jg     8010374e <piperead+0x9e>
80103726:	eb 34                	jmp    8010375c <piperead+0xac>
80103728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010372f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103730:	8d 48 01             	lea    0x1(%eax),%ecx
80103733:	25 ff 01 00 00       	and    $0x1ff,%eax
80103738:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010373e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103743:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103746:	83 c3 01             	add    $0x1,%ebx
80103749:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010374c:	74 0e                	je     8010375c <piperead+0xac>
    if(p->nread == p->nwrite)
8010374e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	75 d4                	jne    80103730 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010375c:	83 ec 0c             	sub    $0xc,%esp
8010375f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103765:	50                   	push   %eax
80103766:	e8 b5 0e 00 00       	call   80104620 <wakeup>
  release(&p->lock);
8010376b:	89 34 24             	mov    %esi,(%esp)
8010376e:	e8 fd 14 00 00       	call   80104c70 <release>
  return i;
80103773:	83 c4 10             	add    $0x10,%esp
}
80103776:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103779:	89 d8                	mov    %ebx,%eax
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5f                   	pop    %edi
8010377e:	5d                   	pop    %ebp
8010377f:	c3                   	ret    
      release(&p->lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103783:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103788:	56                   	push   %esi
80103789:	e8 e2 14 00 00       	call   80104c70 <release>
      return -1;
8010378e:	83 c4 10             	add    $0x10,%esp
}
80103791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103794:	89 d8                	mov    %ebx,%eax
80103796:	5b                   	pop    %ebx
80103797:	5e                   	pop    %esi
80103798:	5f                   	pop    %edi
80103799:	5d                   	pop    %ebp
8010379a:	c3                   	ret    
8010379b:	66 90                	xchg   %ax,%ax
8010379d:	66 90                	xchg   %ax,%ax
8010379f:	90                   	nop

801037a0 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	57                   	push   %edi
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a4:	bf 54 3d 11 80       	mov    $0x80113d54,%edi
{
801037a9:	56                   	push   %esi
801037aa:	53                   	push   %ebx
801037ab:	83 ec 14             	sub    $0x14,%esp
801037ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
801037b1:	eb 17                	jmp    801037ca <wakeup1+0x2a>
801037b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037b7:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b8:	81 c7 9c 00 00 00    	add    $0x9c,%edi
801037be:	81 ff 54 64 11 80    	cmp    $0x80116454,%edi
801037c4:	0f 84 9f 00 00 00    	je     80103869 <wakeup1+0xc9>
    if(p->state == SLEEPING && p->chan == chan){
801037ca:	83 7f 0c 02          	cmpl   $0x2,0xc(%edi)
801037ce:	75 e8                	jne    801037b8 <wakeup1+0x18>
801037d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801037d3:	39 47 20             	cmp    %eax,0x20(%edi)
801037d6:	75 e0                	jne    801037b8 <wakeup1+0x18>
  int active_processes = 0;
801037d8:	31 c9                	xor    %ecx,%ecx
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
801037da:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  long long min_acc = __LONG_LONG_MAX__;
801037dd:	be ff ff ff ff       	mov    $0xffffffff,%esi
801037e2:	bb ff ff ff 7f       	mov    $0x7fffffff,%ebx
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
801037e7:	89 4d ec             	mov    %ecx,-0x14(%ebp)
801037ea:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801037ef:	eb 13                	jmp    80103804 <wakeup1+0x64>
801037f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037f8:	05 9c 00 00 00       	add    $0x9c,%eax
801037fd:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103802:	74 33                	je     80103837 <wakeup1+0x97>
    if ((proc->state == RUNNING || proc->state == RUNNABLE) && proc->accumulator < min_acc){
80103804:	8b 48 0c             	mov    0xc(%eax),%ecx
80103807:	8d 51 fd             	lea    -0x3(%ecx),%edx
8010380a:	83 fa 01             	cmp    $0x1,%edx
8010380d:	77 e9                	ja     801037f8 <wakeup1+0x58>
8010380f:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80103815:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
8010381b:	39 f1                	cmp    %esi,%ecx
8010381d:	89 d7                	mov    %edx,%edi
8010381f:	19 df                	sbb    %ebx,%edi
80103821:	7d d5                	jge    801037f8 <wakeup1+0x58>
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80103823:	05 9c 00 00 00       	add    $0x9c,%eax
      active_processes++;
80103828:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010382c:	89 ce                	mov    %ecx,%esi
8010382e:	89 d3                	mov    %edx,%ebx
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80103830:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103835:	75 cd                	jne    80103804 <wakeup1+0x64>
80103837:	8b 45 ec             	mov    -0x14(%ebp),%eax
    min_acc = 0;
8010383a:	ba 00 00 00 00       	mov    $0x0,%edx
8010383f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103842:	85 c0                	test   %eax,%eax
      update_min_acc(p);
      p->state = RUNNABLE;
80103844:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
    min_acc = 0;
8010384b:	0f 44 f2             	cmove  %edx,%esi
8010384e:	0f 44 da             	cmove  %edx,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103851:	81 c7 9c 00 00 00    	add    $0x9c,%edi
  p->accumulator = min_acc;
80103857:	89 77 e8             	mov    %esi,-0x18(%edi)
8010385a:	89 5f ec             	mov    %ebx,-0x14(%edi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010385d:	81 ff 54 64 11 80    	cmp    $0x80116454,%edi
80103863:	0f 85 61 ff ff ff    	jne    801037ca <wakeup1+0x2a>
    }
}
80103869:	83 c4 14             	add    $0x14,%esp
8010386c:	5b                   	pop    %ebx
8010386d:	5e                   	pop    %esi
8010386e:	5f                   	pop    %edi
8010386f:	5d                   	pop    %ebp
80103870:	c3                   	ret    
80103871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010387f:	90                   	nop

80103880 <allocproc>:
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	57                   	push   %edi
80103884:	56                   	push   %esi
80103885:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103886:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
8010388b:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
8010388e:	68 20 3d 11 80       	push   $0x80113d20
80103893:	e8 18 13 00 00       	call   80104bb0 <acquire>
80103898:	83 c4 10             	add    $0x10,%esp
8010389b:	eb 15                	jmp    801038b2 <allocproc+0x32>
8010389d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038a0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801038a6:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
801038ac:	0f 84 3b 01 00 00    	je     801039ed <allocproc+0x16d>
    if(p->state == UNUSED)
801038b2:	8b 43 0c             	mov    0xc(%ebx),%eax
801038b5:	85 c0                	test   %eax,%eax
801038b7:	75 e7                	jne    801038a0 <allocproc+0x20>
  p->pid = nextpid++;
801038b9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  release(&ptable.lock);
801038be:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801038c1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801038c8:	89 43 10             	mov    %eax,0x10(%ebx)
801038cb:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801038ce:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
801038d3:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801038d9:	e8 92 13 00 00       	call   80104c70 <release>
  if((p->kstack = kalloc()) == 0){
801038de:	e8 4d ed ff ff       	call   80102630 <kalloc>
801038e3:	83 c4 10             	add    $0x10,%esp
801038e6:	89 43 08             	mov    %eax,0x8(%ebx)
801038e9:	85 c0                	test   %eax,%eax
801038eb:	0f 84 18 01 00 00    	je     80103a09 <allocproc+0x189>
  sp -= sizeof *p->tf;
801038f1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
801038f7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038fa:	05 9c 0f 00 00       	add    $0xf9c,%eax
  long long min_acc = __LONG_LONG_MAX__;
801038ff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  sp -= sizeof *p->tf;
80103904:	89 53 18             	mov    %edx,0x18(%ebx)
  long long min_acc = __LONG_LONG_MAX__;
80103907:	be ff ff ff 7f       	mov    $0x7fffffff,%esi
  *(uint*)sp = (uint)trapret;
8010390c:	c7 40 14 aa 5f 10 80 	movl   $0x80105faa,0x14(%eax)
  p->context = (struct context*)sp;
80103913:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103916:	6a 14                	push   $0x14
80103918:	6a 00                	push   $0x0
8010391a:	50                   	push   %eax
8010391b:	e8 a0 13 00 00       	call   80104cc0 <memset>
  p->context->eip = (uint)forkret;
80103920:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103923:	c7 40 10 20 3a 10 80 	movl   $0x80103a20,0x10(%eax)
  acquire(&ptable.lock);
8010392a:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103931:	e8 7a 12 00 00       	call   80104bb0 <acquire>
  int active_processes = 0;
80103936:	31 d2                	xor    %edx,%edx
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80103938:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  acquire(&ptable.lock);
8010393b:	83 c4 10             	add    $0x10,%esp
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
8010393e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103941:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103946:	eb 14                	jmp    8010395c <allocproc+0xdc>
80103948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010394f:	90                   	nop
80103950:	05 9c 00 00 00       	add    $0x9c,%eax
80103955:	3d 54 64 11 80       	cmp    $0x80116454,%eax
8010395a:	74 33                	je     8010398f <allocproc+0x10f>
    if ((proc->state == RUNNING || proc->state == RUNNABLE) && proc->accumulator < min_acc){
8010395c:	8b 48 0c             	mov    0xc(%eax),%ecx
8010395f:	8d 51 fd             	lea    -0x3(%ecx),%edx
80103962:	83 fa 01             	cmp    $0x1,%edx
80103965:	77 e9                	ja     80103950 <allocproc+0xd0>
80103967:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
8010396d:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80103973:	39 f9                	cmp    %edi,%ecx
80103975:	89 d3                	mov    %edx,%ebx
80103977:	19 f3                	sbb    %esi,%ebx
80103979:	7d d5                	jge    80103950 <allocproc+0xd0>
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
8010397b:	05 9c 00 00 00       	add    $0x9c,%eax
      active_processes++;
80103980:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103984:	89 cf                	mov    %ecx,%edi
80103986:	89 d6                	mov    %edx,%esi
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80103988:	3d 54 64 11 80       	cmp    $0x80116454,%eax
8010398d:	75 cd                	jne    8010395c <allocproc+0xdc>
8010398f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    min_acc = 0;
80103992:	31 c0                	xor    %eax,%eax
80103994:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80103997:	85 c9                	test   %ecx,%ecx
80103999:	0f 44 f8             	cmove  %eax,%edi
8010399c:	0f 44 f0             	cmove  %eax,%esi
  release(&ptable.lock);
8010399f:	83 ec 0c             	sub    $0xc,%esp
  p->accumulator = min_acc;
801039a2:	89 bb 84 00 00 00    	mov    %edi,0x84(%ebx)
801039a8:	89 b3 88 00 00 00    	mov    %esi,0x88(%ebx)
  release(&ptable.lock);
801039ae:	68 20 3d 11 80       	push   $0x80113d20
801039b3:	e8 b8 12 00 00       	call   80104c70 <release>
  return p;
801039b8:	83 c4 10             	add    $0x10,%esp
}
801039bb:	89 d8                	mov    %ebx,%eax
  p->ps_priority = 5;
801039bd:	c7 83 80 00 00 00 05 	movl   $0x5,0x80(%ebx)
801039c4:	00 00 00 
  p->rtime = 0;
801039c7:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
801039ce:	00 00 00 
  p->retime = 0;
801039d1:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
801039d8:	00 00 00 
  p ->stime = 0;
801039db:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
801039e2:	00 00 00 
}
801039e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039e8:	5b                   	pop    %ebx
801039e9:	5e                   	pop    %esi
801039ea:	5f                   	pop    %edi
801039eb:	5d                   	pop    %ebp
801039ec:	c3                   	ret    
  release(&ptable.lock);
801039ed:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801039f0:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801039f2:	68 20 3d 11 80       	push   $0x80113d20
801039f7:	e8 74 12 00 00       	call   80104c70 <release>
  return 0;
801039fc:	83 c4 10             	add    $0x10,%esp
}
801039ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a02:	89 d8                	mov    %ebx,%eax
80103a04:	5b                   	pop    %ebx
80103a05:	5e                   	pop    %esi
80103a06:	5f                   	pop    %edi
80103a07:	5d                   	pop    %ebp
80103a08:	c3                   	ret    
    p->state = UNUSED;
80103a09:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
}
80103a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80103a13:	31 db                	xor    %ebx,%ebx
}
80103a15:	89 d8                	mov    %ebx,%eax
80103a17:	5b                   	pop    %ebx
80103a18:	5e                   	pop    %esi
80103a19:	5f                   	pop    %edi
80103a1a:	5d                   	pop    %ebp
80103a1b:	c3                   	ret    
80103a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a20 <forkret>:
{
80103a20:	f3 0f 1e fb          	endbr32 
80103a24:	55                   	push   %ebp
80103a25:	89 e5                	mov    %esp,%ebp
80103a27:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103a2a:	68 20 3d 11 80       	push   $0x80113d20
80103a2f:	e8 3c 12 00 00       	call   80104c70 <release>
  if (first) {
80103a34:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103a39:	83 c4 10             	add    $0x10,%esp
80103a3c:	85 c0                	test   %eax,%eax
80103a3e:	75 08                	jne    80103a48 <forkret+0x28>
}
80103a40:	c9                   	leave  
80103a41:	c3                   	ret    
80103a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103a48:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103a4f:	00 00 00 
    iinit(ROOTDEV);
80103a52:	83 ec 0c             	sub    $0xc,%esp
80103a55:	6a 01                	push   $0x1
80103a57:	e8 e4 da ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
80103a5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a63:	e8 28 f2 ff ff       	call   80102c90 <initlog>
}
80103a68:	83 c4 10             	add    $0x10,%esp
80103a6b:	c9                   	leave  
80103a6c:	c3                   	ret    
80103a6d:	8d 76 00             	lea    0x0(%esi),%esi

80103a70 <pinit>:
{
80103a70:	f3 0f 1e fb          	endbr32 
80103a74:	55                   	push   %ebp
80103a75:	89 e5                	mov    %esp,%ebp
80103a77:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a7a:	68 80 7d 10 80       	push   $0x80107d80
80103a7f:	68 20 3d 11 80       	push   $0x80113d20
80103a84:	e8 a7 0f 00 00       	call   80104a30 <initlock>
}
80103a89:	83 c4 10             	add    $0x10,%esp
80103a8c:	c9                   	leave  
80103a8d:	c3                   	ret    
80103a8e:	66 90                	xchg   %ax,%ax

80103a90 <mycpu>:
{
80103a90:	f3 0f 1e fb          	endbr32 
80103a94:	55                   	push   %ebp
80103a95:	89 e5                	mov    %esp,%ebp
80103a97:	56                   	push   %esi
80103a98:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a99:	9c                   	pushf  
80103a9a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a9b:	f6 c4 02             	test   $0x2,%ah
80103a9e:	75 4a                	jne    80103aea <mycpu+0x5a>
  apicid = lapicid();
80103aa0:	e8 fb ed ff ff       	call   801028a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103aa5:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
  apicid = lapicid();
80103aab:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103aad:	85 f6                	test   %esi,%esi
80103aaf:	7e 2c                	jle    80103add <mycpu+0x4d>
80103ab1:	31 d2                	xor    %edx,%edx
80103ab3:	eb 0a                	jmp    80103abf <mycpu+0x2f>
80103ab5:	8d 76 00             	lea    0x0(%esi),%esi
80103ab8:	83 c2 01             	add    $0x1,%edx
80103abb:	39 f2                	cmp    %esi,%edx
80103abd:	74 1e                	je     80103add <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103abf:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103ac5:	0f b6 81 80 37 11 80 	movzbl -0x7feec880(%ecx),%eax
80103acc:	39 d8                	cmp    %ebx,%eax
80103ace:	75 e8                	jne    80103ab8 <mycpu+0x28>
}
80103ad0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103ad3:	8d 81 80 37 11 80    	lea    -0x7feec880(%ecx),%eax
}
80103ad9:	5b                   	pop    %ebx
80103ada:	5e                   	pop    %esi
80103adb:	5d                   	pop    %ebp
80103adc:	c3                   	ret    
  panic("unknown apicid\n");
80103add:	83 ec 0c             	sub    $0xc,%esp
80103ae0:	68 87 7d 10 80       	push   $0x80107d87
80103ae5:	e8 a6 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103aea:	83 ec 0c             	sub    $0xc,%esp
80103aed:	68 78 7e 10 80       	push   $0x80107e78
80103af2:	e8 99 c8 ff ff       	call   80100390 <panic>
80103af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103afe:	66 90                	xchg   %ax,%ax

80103b00 <cpuid>:
cpuid() {
80103b00:	f3 0f 1e fb          	endbr32 
80103b04:	55                   	push   %ebp
80103b05:	89 e5                	mov    %esp,%ebp
80103b07:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b0a:	e8 81 ff ff ff       	call   80103a90 <mycpu>
}
80103b0f:	c9                   	leave  
  return mycpu()-cpus;
80103b10:	2d 80 37 11 80       	sub    $0x80113780,%eax
80103b15:	c1 f8 04             	sar    $0x4,%eax
80103b18:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b1e:	c3                   	ret    
80103b1f:	90                   	nop

80103b20 <myproc>:
myproc(void) {
80103b20:	f3 0f 1e fb          	endbr32 
80103b24:	55                   	push   %ebp
80103b25:	89 e5                	mov    %esp,%ebp
80103b27:	53                   	push   %ebx
80103b28:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b2b:	e8 80 0f 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80103b30:	e8 5b ff ff ff       	call   80103a90 <mycpu>
  p = c->proc;
80103b35:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b3b:	e8 c0 0f 00 00       	call   80104b00 <popcli>
}
80103b40:	83 c4 04             	add    $0x4,%esp
80103b43:	89 d8                	mov    %ebx,%eax
80103b45:	5b                   	pop    %ebx
80103b46:	5d                   	pop    %ebp
80103b47:	c3                   	ret    
80103b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b4f:	90                   	nop

80103b50 <update_min_acc>:
void update_min_acc(struct proc* p){
80103b50:	f3 0f 1e fb          	endbr32 
80103b54:	55                   	push   %ebp
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80103b55:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
void update_min_acc(struct proc* p){
80103b5a:	89 e5                	mov    %esp,%ebp
80103b5c:	57                   	push   %edi
  int active_processes = 0;
80103b5d:	31 ff                	xor    %edi,%edi
void update_min_acc(struct proc* p){
80103b5f:	56                   	push   %esi
  long long min_acc = __LONG_LONG_MAX__;
80103b60:	be ff ff ff ff       	mov    $0xffffffff,%esi
void update_min_acc(struct proc* p){
80103b65:	53                   	push   %ebx
  long long min_acc = __LONG_LONG_MAX__;
80103b66:	bb ff ff ff 7f       	mov    $0x7fffffff,%ebx
void update_min_acc(struct proc* p){
80103b6b:	83 ec 0c             	sub    $0xc,%esp
  long long min_acc = __LONG_LONG_MAX__;
80103b6e:	89 7d ec             	mov    %edi,-0x14(%ebp)
80103b71:	eb 11                	jmp    80103b84 <update_min_acc+0x34>
80103b73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b77:	90                   	nop
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80103b78:	05 9c 00 00 00       	add    $0x9c,%eax
80103b7d:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103b82:	74 33                	je     80103bb7 <update_min_acc+0x67>
    if ((proc->state == RUNNING || proc->state == RUNNABLE) && proc->accumulator < min_acc){
80103b84:	8b 48 0c             	mov    0xc(%eax),%ecx
80103b87:	8d 51 fd             	lea    -0x3(%ecx),%edx
80103b8a:	83 fa 01             	cmp    $0x1,%edx
80103b8d:	77 e9                	ja     80103b78 <update_min_acc+0x28>
80103b8f:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80103b95:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80103b9b:	39 f1                	cmp    %esi,%ecx
80103b9d:	89 d7                	mov    %edx,%edi
80103b9f:	19 df                	sbb    %ebx,%edi
80103ba1:	7d d5                	jge    80103b78 <update_min_acc+0x28>
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80103ba3:	05 9c 00 00 00       	add    $0x9c,%eax
      active_processes++;
80103ba8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80103bac:	89 ce                	mov    %ecx,%esi
80103bae:	89 d3                	mov    %edx,%ebx
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80103bb0:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103bb5:	75 cd                	jne    80103b84 <update_min_acc+0x34>
80103bb7:	8b 7d ec             	mov    -0x14(%ebp),%edi
    min_acc = 0;
80103bba:	31 c0                	xor    %eax,%eax
80103bbc:	85 ff                	test   %edi,%edi
80103bbe:	0f 44 f0             	cmove  %eax,%esi
80103bc1:	0f 44 d8             	cmove  %eax,%ebx
  p->accumulator = min_acc;
80103bc4:	8b 45 08             	mov    0x8(%ebp),%eax
80103bc7:	89 b0 84 00 00 00    	mov    %esi,0x84(%eax)
80103bcd:	89 98 88 00 00 00    	mov    %ebx,0x88(%eax)
}
80103bd3:	83 c4 0c             	add    $0xc,%esp
80103bd6:	5b                   	pop    %ebx
80103bd7:	5e                   	pop    %esi
80103bd8:	5f                   	pop    %edi
80103bd9:	5d                   	pop    %ebp
80103bda:	c3                   	ret    
80103bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bdf:	90                   	nop

80103be0 <userinit>:
{
80103be0:	f3 0f 1e fb          	endbr32 
80103be4:	55                   	push   %ebp
80103be5:	89 e5                	mov    %esp,%ebp
80103be7:	53                   	push   %ebx
80103be8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103beb:	e8 90 fc ff ff       	call   80103880 <allocproc>
80103bf0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bf2:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103bf7:	e8 a4 39 00 00       	call   801075a0 <setupkvm>
80103bfc:	89 43 04             	mov    %eax,0x4(%ebx)
80103bff:	85 c0                	test   %eax,%eax
80103c01:	0f 84 bd 00 00 00    	je     80103cc4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c07:	83 ec 04             	sub    $0x4,%esp
80103c0a:	68 2c 00 00 00       	push   $0x2c
80103c0f:	68 60 b4 10 80       	push   $0x8010b460
80103c14:	50                   	push   %eax
80103c15:	e8 56 36 00 00       	call   80107270 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c1a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c1d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c23:	6a 4c                	push   $0x4c
80103c25:	6a 00                	push   $0x0
80103c27:	ff 73 18             	pushl  0x18(%ebx)
80103c2a:	e8 91 10 00 00       	call   80104cc0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c32:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c37:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c3a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c3f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c43:	8b 43 18             	mov    0x18(%ebx),%eax
80103c46:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c4a:	8b 43 18             	mov    0x18(%ebx),%eax
80103c4d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c51:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c55:	8b 43 18             	mov    0x18(%ebx),%eax
80103c58:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c5c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c60:	8b 43 18             	mov    0x18(%ebx),%eax
80103c63:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c6a:	8b 43 18             	mov    0x18(%ebx),%eax
80103c6d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c74:	8b 43 18             	mov    0x18(%ebx),%eax
80103c77:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c7e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c81:	6a 10                	push   $0x10
80103c83:	68 b0 7d 10 80       	push   $0x80107db0
80103c88:	50                   	push   %eax
80103c89:	e8 f2 11 00 00       	call   80104e80 <safestrcpy>
  p->cwd = namei("/");
80103c8e:	c7 04 24 b9 7d 10 80 	movl   $0x80107db9,(%esp)
80103c95:	e8 96 e3 ff ff       	call   80102030 <namei>
80103c9a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c9d:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ca4:	e8 07 0f 00 00       	call   80104bb0 <acquire>
  p->state = RUNNABLE;
80103ca9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103cb0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103cb7:	e8 b4 0f 00 00       	call   80104c70 <release>
}
80103cbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cbf:	83 c4 10             	add    $0x10,%esp
80103cc2:	c9                   	leave  
80103cc3:	c3                   	ret    
    panic("userinit: out of memory?");
80103cc4:	83 ec 0c             	sub    $0xc,%esp
80103cc7:	68 97 7d 10 80       	push   $0x80107d97
80103ccc:	e8 bf c6 ff ff       	call   80100390 <panic>
80103cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cdf:	90                   	nop

80103ce0 <growproc>:
{
80103ce0:	f3 0f 1e fb          	endbr32 
80103ce4:	55                   	push   %ebp
80103ce5:	89 e5                	mov    %esp,%ebp
80103ce7:	56                   	push   %esi
80103ce8:	53                   	push   %ebx
80103ce9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103cec:	e8 bf 0d 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80103cf1:	e8 9a fd ff ff       	call   80103a90 <mycpu>
  p = c->proc;
80103cf6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cfc:	e8 ff 0d 00 00       	call   80104b00 <popcli>
  sz = curproc->sz;
80103d01:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103d03:	85 f6                	test   %esi,%esi
80103d05:	7f 19                	jg     80103d20 <growproc+0x40>
  } else if(n < 0){
80103d07:	75 37                	jne    80103d40 <growproc+0x60>
  switchuvm(curproc);
80103d09:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d0c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d0e:	53                   	push   %ebx
80103d0f:	e8 4c 34 00 00       	call   80107160 <switchuvm>
  return 0;
80103d14:	83 c4 10             	add    $0x10,%esp
80103d17:	31 c0                	xor    %eax,%eax
}
80103d19:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d1c:	5b                   	pop    %ebx
80103d1d:	5e                   	pop    %esi
80103d1e:	5d                   	pop    %ebp
80103d1f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d20:	83 ec 04             	sub    $0x4,%esp
80103d23:	01 c6                	add    %eax,%esi
80103d25:	56                   	push   %esi
80103d26:	50                   	push   %eax
80103d27:	ff 73 04             	pushl  0x4(%ebx)
80103d2a:	e8 91 36 00 00       	call   801073c0 <allocuvm>
80103d2f:	83 c4 10             	add    $0x10,%esp
80103d32:	85 c0                	test   %eax,%eax
80103d34:	75 d3                	jne    80103d09 <growproc+0x29>
      return -1;
80103d36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d3b:	eb dc                	jmp    80103d19 <growproc+0x39>
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d40:	83 ec 04             	sub    $0x4,%esp
80103d43:	01 c6                	add    %eax,%esi
80103d45:	56                   	push   %esi
80103d46:	50                   	push   %eax
80103d47:	ff 73 04             	pushl  0x4(%ebx)
80103d4a:	e8 a1 37 00 00       	call   801074f0 <deallocuvm>
80103d4f:	83 c4 10             	add    $0x10,%esp
80103d52:	85 c0                	test   %eax,%eax
80103d54:	75 b3                	jne    80103d09 <growproc+0x29>
80103d56:	eb de                	jmp    80103d36 <growproc+0x56>
80103d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d5f:	90                   	nop

80103d60 <fork>:
{
80103d60:	f3 0f 1e fb          	endbr32 
80103d64:	55                   	push   %ebp
80103d65:	89 e5                	mov    %esp,%ebp
80103d67:	57                   	push   %edi
80103d68:	56                   	push   %esi
80103d69:	53                   	push   %ebx
80103d6a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d6d:	e8 3e 0d 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80103d72:	e8 19 fd ff ff       	call   80103a90 <mycpu>
  p = c->proc;
80103d77:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d7d:	e8 7e 0d 00 00       	call   80104b00 <popcli>
  if((np = allocproc()) == 0){
80103d82:	e8 f9 fa ff ff       	call   80103880 <allocproc>
80103d87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d8a:	85 c0                	test   %eax,%eax
80103d8c:	0f 84 bb 00 00 00    	je     80103e4d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d92:	83 ec 08             	sub    $0x8,%esp
80103d95:	ff 33                	pushl  (%ebx)
80103d97:	89 c7                	mov    %eax,%edi
80103d99:	ff 73 04             	pushl  0x4(%ebx)
80103d9c:	e8 cf 38 00 00       	call   80107670 <copyuvm>
80103da1:	83 c4 10             	add    $0x10,%esp
80103da4:	89 47 04             	mov    %eax,0x4(%edi)
80103da7:	85 c0                	test   %eax,%eax
80103da9:	0f 84 a5 00 00 00    	je     80103e54 <fork+0xf4>
  np->sz = curproc->sz;
80103daf:	8b 03                	mov    (%ebx),%eax
80103db1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103db4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103db6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103db9:	89 c8                	mov    %ecx,%eax
80103dbb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103dbe:	b9 13 00 00 00       	mov    $0x13,%ecx
80103dc3:	8b 73 18             	mov    0x18(%ebx),%esi
80103dc6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103dc8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103dca:	8b 40 18             	mov    0x18(%eax),%eax
80103dcd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103dd8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ddc:	85 c0                	test   %eax,%eax
80103dde:	74 13                	je     80103df3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103de0:	83 ec 0c             	sub    $0xc,%esp
80103de3:	50                   	push   %eax
80103de4:	e8 87 d0 ff ff       	call   80100e70 <filedup>
80103de9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103dec:	83 c4 10             	add    $0x10,%esp
80103def:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103df3:	83 c6 01             	add    $0x1,%esi
80103df6:	83 fe 10             	cmp    $0x10,%esi
80103df9:	75 dd                	jne    80103dd8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103dfb:	83 ec 0c             	sub    $0xc,%esp
80103dfe:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e01:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103e04:	e8 27 d9 ff ff       	call   80101730 <idup>
80103e09:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e0c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e0f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e12:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e15:	6a 10                	push   $0x10
80103e17:	53                   	push   %ebx
80103e18:	50                   	push   %eax
80103e19:	e8 62 10 00 00       	call   80104e80 <safestrcpy>
  pid = np->pid;
80103e1e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103e21:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e28:	e8 83 0d 00 00       	call   80104bb0 <acquire>
  np->state = RUNNABLE;
80103e2d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103e34:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e3b:	e8 30 0e 00 00       	call   80104c70 <release>
  return pid;
80103e40:	83 c4 10             	add    $0x10,%esp
}
80103e43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e46:	89 d8                	mov    %ebx,%eax
80103e48:	5b                   	pop    %ebx
80103e49:	5e                   	pop    %esi
80103e4a:	5f                   	pop    %edi
80103e4b:	5d                   	pop    %ebp
80103e4c:	c3                   	ret    
    return -1;
80103e4d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e52:	eb ef                	jmp    80103e43 <fork+0xe3>
    kfree(np->kstack);
80103e54:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e57:	83 ec 0c             	sub    $0xc,%esp
80103e5a:	ff 73 08             	pushl  0x8(%ebx)
80103e5d:	e8 0e e6 ff ff       	call   80102470 <kfree>
    np->kstack = 0;
80103e62:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103e69:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e6c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e73:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e78:	eb c9                	jmp    80103e43 <fork+0xe3>
80103e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e80 <priority_scheduler>:
{
80103e80:	f3 0f 1e fb          	endbr32 
80103e84:	55                   	push   %ebp
80103e85:	89 e5                	mov    %esp,%ebp
80103e87:	57                   	push   %edi
80103e88:	56                   	push   %esi
80103e89:	53                   	push   %ebx
80103e8a:	83 ec 0c             	sub    $0xc,%esp
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e90:	fb                   	sti    
    acquire(&ptable.lock);
80103e91:	83 ec 0c             	sub    $0xc,%esp
    int runnable_exists = 0;
80103e94:	31 f6                	xor    %esi,%esi
    struct proc* min_acc_proc = null;
80103e96:	31 ff                	xor    %edi,%edi
    acquire(&ptable.lock);
80103e98:	68 20 3d 11 80       	push   $0x80113d20
80103e9d:	e8 0e 0d 00 00       	call   80104bb0 <acquire>
80103ea2:	83 c4 10             	add    $0x10,%esp
    long long min_acc = __LONG_LONG_MAX__;
80103ea5:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80103eaa:	ba ff ff ff 7f       	mov    $0x7fffffff,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eaf:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if (p->state != RUNNABLE)
80103eb8:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103ebc:	75 27                	jne    80103ee5 <priority_scheduler+0x65>
      if (p->accumulator < min_acc){
80103ebe:	8b 98 88 00 00 00    	mov    0x88(%eax),%ebx
80103ec4:	39 88 84 00 00 00    	cmp    %ecx,0x84(%eax)
80103eca:	19 d3                	sbb    %edx,%ebx
80103ecc:	bb 01 00 00 00       	mov    $0x1,%ebx
80103ed1:	0f 4c 88 84 00 00 00 	cmovl  0x84(%eax),%ecx
80103ed8:	0f 4c 90 88 00 00 00 	cmovl  0x88(%eax),%edx
80103edf:	0f 4c f8             	cmovl  %eax,%edi
80103ee2:	0f 4c f3             	cmovl  %ebx,%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee5:	05 9c 00 00 00       	add    $0x9c,%eax
80103eea:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103eef:	75 c7                	jne    80103eb8 <priority_scheduler+0x38>
    if (!runnable_exists){
80103ef1:	85 f6                	test   %esi,%esi
80103ef3:	74 52                	je     80103f47 <priority_scheduler+0xc7>
    c->proc = min_acc_proc;
80103ef5:	8b 45 08             	mov    0x8(%ebp),%eax
    switchuvm(min_acc_proc);
80103ef8:	83 ec 0c             	sub    $0xc,%esp
    c->proc = min_acc_proc;
80103efb:	89 b8 ac 00 00 00    	mov    %edi,0xac(%eax)
    switchuvm(min_acc_proc);
80103f01:	57                   	push   %edi
80103f02:	e8 59 32 00 00       	call   80107160 <switchuvm>
    min_acc_proc->state = RUNNING;
80103f07:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
    swtch(&(c->scheduler), min_acc_proc->context);
80103f0e:	58                   	pop    %eax
80103f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f12:	5a                   	pop    %edx
80103f13:	ff 77 1c             	pushl  0x1c(%edi)
80103f16:	83 c0 04             	add    $0x4,%eax
80103f19:	50                   	push   %eax
80103f1a:	e8 c4 0f 00 00       	call   80104ee3 <swtch>
    switchkvm();
80103f1f:	e8 1c 32 00 00       	call   80107140 <switchkvm>
    min_acc_proc->accumulator += min_acc_proc->ps_priority;
80103f24:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80103f2a:	99                   	cltd   
80103f2b:	01 87 84 00 00 00    	add    %eax,0x84(%edi)
    c->proc = 0;
80103f31:	8b 45 08             	mov    0x8(%ebp),%eax
    min_acc_proc->accumulator += min_acc_proc->ps_priority;
80103f34:	11 97 88 00 00 00    	adc    %edx,0x88(%edi)
    c->proc = 0;
80103f3a:	83 c4 10             	add    $0x10,%esp
80103f3d:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f44:	00 00 00 
    release(&ptable.lock);
80103f47:	83 ec 0c             	sub    $0xc,%esp
80103f4a:	68 20 3d 11 80       	push   $0x80113d20
80103f4f:	e8 1c 0d 00 00       	call   80104c70 <release>
    if (sched_type != PRIORITY_SCHEDULER){
80103f54:	83 c4 10             	add    $0x10,%esp
80103f57:	83 3d 18 0f 11 80 01 	cmpl   $0x1,0x80110f18
80103f5e:	0f 84 2c ff ff ff    	je     80103e90 <priority_scheduler+0x10>
}
80103f64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f67:	5b                   	pop    %ebx
80103f68:	5e                   	pop    %esi
80103f69:	5f                   	pop    %edi
80103f6a:	5d                   	pop    %ebp
80103f6b:	c3                   	ret    
80103f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f70 <fair_scheduler>:
{
80103f70:	f3 0f 1e fb          	endbr32 
80103f74:	55                   	push   %ebp
80103f75:	89 e5                	mov    %esp,%ebp
80103f77:	56                   	push   %esi
80103f78:	53                   	push   %ebx
80103f79:	83 ec 10             	sub    $0x10,%esp
80103f7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103f7f:	90                   	nop
80103f80:	fb                   	sti    
    acquire(&ptable.lock);
80103f81:	83 ec 0c             	sub    $0xc,%esp
    struct proc* min_ratio_proc = null;
80103f84:	31 f6                	xor    %esi,%esi
    acquire(&ptable.lock);
80103f86:	68 20 3d 11 80       	push   $0x80113d20
80103f8b:	e8 20 0c 00 00       	call   80104bb0 <acquire>
80103f90:	83 c4 10             	add    $0x10,%esp
    int runnable_exists = 0;
80103f93:	31 c9                	xor    %ecx,%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f95:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
    float min_ratio = __LONG_LONG_MAX__;
80103f9a:	d9 05 c4 7e 10 80    	flds   0x80107ec4
      if (p->state != RUNNABLE)
80103fa0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103fa4:	75 3c                	jne    80103fe2 <fair_scheduler+0x72>
      float ratio = ((p->rtime) * (p->cfs_decay_factor)) / (p->rtime + p->retime + p->stime);
80103fa6:	db 80 90 00 00 00    	fildl  0x90(%eax)
80103fac:	d9 80 8c 00 00 00    	flds   0x8c(%eax)
80103fb2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80103fb8:	03 90 94 00 00 00    	add    0x94(%eax),%edx
80103fbe:	03 90 98 00 00 00    	add    0x98(%eax),%edx
80103fc4:	de c9                	fmulp  %st,%st(1)
80103fc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
80103fc9:	db 45 f4             	fildl  -0xc(%ebp)
80103fcc:	de f9                	fdivrp %st,%st(1)
80103fce:	d9 c9                	fxch   %st(1)
      if (ratio < min_ratio){
80103fd0:	db f1                	fcomi  %st(1),%st
80103fd2:	76 0c                	jbe    80103fe0 <fair_scheduler+0x70>
80103fd4:	dd d8                	fstp   %st(0)
80103fd6:	89 c6                	mov    %eax,%esi
        runnable_exists = 1;
80103fd8:	b9 01 00 00 00       	mov    $0x1,%ecx
80103fdd:	eb 03                	jmp    80103fe2 <fair_scheduler+0x72>
80103fdf:	90                   	nop
80103fe0:	dd d9                	fstp   %st(1)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fe2:	05 9c 00 00 00       	add    $0x9c,%eax
80103fe7:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103fec:	75 b2                	jne    80103fa0 <fair_scheduler+0x30>
80103fee:	dd d8                	fstp   %st(0)
    if (!runnable_exists){
80103ff0:	85 c9                	test   %ecx,%ecx
80103ff2:	74 49                	je     8010403d <fair_scheduler+0xcd>
    switchuvm(min_ratio_proc);
80103ff4:	83 ec 0c             	sub    $0xc,%esp
    c->proc = min_ratio_proc;
80103ff7:	89 b3 ac 00 00 00    	mov    %esi,0xac(%ebx)
    switchuvm(min_ratio_proc);
80103ffd:	56                   	push   %esi
80103ffe:	e8 5d 31 00 00       	call   80107160 <switchuvm>
    min_ratio_proc->state = RUNNING;
80104003:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
    swtch(&(c->scheduler), min_ratio_proc->context);
8010400a:	58                   	pop    %eax
8010400b:	8d 43 04             	lea    0x4(%ebx),%eax
8010400e:	5a                   	pop    %edx
8010400f:	ff 76 1c             	pushl  0x1c(%esi)
80104012:	50                   	push   %eax
80104013:	e8 cb 0e 00 00       	call   80104ee3 <swtch>
    switchkvm();
80104018:	e8 23 31 00 00       	call   80107140 <switchkvm>
    min_ratio_proc->accumulator += min_ratio_proc->ps_priority;
8010401d:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
80104023:	99                   	cltd   
80104024:	01 86 84 00 00 00    	add    %eax,0x84(%esi)
8010402a:	11 96 88 00 00 00    	adc    %edx,0x88(%esi)
    c->proc = 0;
80104030:	83 c4 10             	add    $0x10,%esp
80104033:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
8010403a:	00 00 00 
    release(&ptable.lock);
8010403d:	83 ec 0c             	sub    $0xc,%esp
80104040:	68 20 3d 11 80       	push   $0x80113d20
80104045:	e8 26 0c 00 00       	call   80104c70 <release>
    if (sched_type != COMPLETELY_FAIR_SCHEDULER){
8010404a:	83 c4 10             	add    $0x10,%esp
8010404d:	83 3d 18 0f 11 80 02 	cmpl   $0x2,0x80110f18
80104054:	0f 84 26 ff ff ff    	je     80103f80 <fair_scheduler+0x10>
}
8010405a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010405d:	5b                   	pop    %ebx
8010405e:	5e                   	pop    %esi
8010405f:	5d                   	pop    %ebp
80104060:	c3                   	ret    
80104061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010406f:	90                   	nop

80104070 <default_scheduler>:
{
80104070:	f3 0f 1e fb          	endbr32 
80104074:	55                   	push   %ebp
80104075:	89 e5                	mov    %esp,%ebp
80104077:	57                   	push   %edi
80104078:	56                   	push   %esi
80104079:	53                   	push   %ebx
8010407a:	83 ec 0c             	sub    $0xc,%esp
8010407d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104080:	8d 73 04             	lea    0x4(%ebx),%esi
80104083:	fb                   	sti    
    acquire(&ptable.lock);
80104084:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104087:	bf 54 3d 11 80       	mov    $0x80113d54,%edi
    acquire(&ptable.lock);
8010408c:	68 20 3d 11 80       	push   $0x80113d20
80104091:	e8 1a 0b 00 00       	call   80104bb0 <acquire>
80104096:	83 c4 10             	add    $0x10,%esp
80104099:	eb 13                	jmp    801040ae <default_scheduler+0x3e>
8010409b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010409f:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040a0:	81 c7 9c 00 00 00    	add    $0x9c,%edi
801040a6:	81 ff 54 64 11 80    	cmp    $0x80116454,%edi
801040ac:	74 72                	je     80104120 <default_scheduler+0xb0>
      if(p->state != RUNNABLE)
801040ae:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
801040b2:	75 ec                	jne    801040a0 <default_scheduler+0x30>
      switchuvm(p);
801040b4:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801040b7:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
801040bd:	57                   	push   %edi
801040be:	e8 9d 30 00 00       	call   80107160 <switchuvm>
      swtch(&(c->scheduler), p->context);
801040c3:	58                   	pop    %eax
801040c4:	5a                   	pop    %edx
801040c5:	ff 77 1c             	pushl  0x1c(%edi)
801040c8:	56                   	push   %esi
      p->state = RUNNING;
801040c9:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      swtch(&(c->scheduler), p->context);
801040d0:	e8 0e 0e 00 00       	call   80104ee3 <swtch>
      switchkvm();
801040d5:	e8 66 30 00 00       	call   80107140 <switchkvm>
      p->accumulator += p->ps_priority;
801040da:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
      if (sched_type != DEFAULT_SCHEDULER){
801040e0:	8b 0d 18 0f 11 80    	mov    0x80110f18,%ecx
      p->accumulator += p->ps_priority;
801040e6:	99                   	cltd   
801040e7:	01 87 84 00 00 00    	add    %eax,0x84(%edi)
801040ed:	11 97 88 00 00 00    	adc    %edx,0x88(%edi)
      if (sched_type != DEFAULT_SCHEDULER){
801040f3:	83 c4 10             	add    $0x10,%esp
      c->proc = 0;
801040f6:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801040fd:	00 00 00 
      if (sched_type != DEFAULT_SCHEDULER){
80104100:	85 c9                	test   %ecx,%ecx
80104102:	74 9c                	je     801040a0 <default_scheduler+0x30>
        release(&ptable.lock);
80104104:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
8010410b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010410e:	5b                   	pop    %ebx
8010410f:	5e                   	pop    %esi
80104110:	5f                   	pop    %edi
80104111:	5d                   	pop    %ebp
        release(&ptable.lock);
80104112:	e9 59 0b 00 00       	jmp    80104c70 <release>
80104117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411e:	66 90                	xchg   %ax,%ax
    release(&ptable.lock);
80104120:	83 ec 0c             	sub    $0xc,%esp
80104123:	68 20 3d 11 80       	push   $0x80113d20
80104128:	e8 43 0b 00 00       	call   80104c70 <release>
    sti();
8010412d:	83 c4 10             	add    $0x10,%esp
80104130:	e9 4e ff ff ff       	jmp    80104083 <default_scheduler+0x13>
80104135:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010413c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104140 <scheduler>:
{
80104140:	f3 0f 1e fb          	endbr32 
80104144:	55                   	push   %ebp
80104145:	89 e5                	mov    %esp,%ebp
80104147:	53                   	push   %ebx
80104148:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c = mycpu();
8010414b:	e8 40 f9 ff ff       	call   80103a90 <mycpu>
  c->proc = 0;
80104150:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104157:	00 00 00 
  struct cpu *c = mycpu();
8010415a:	89 c3                	mov    %eax,%ebx
    switch (sched_type){
8010415c:	a1 18 0f 11 80       	mov    0x80110f18,%eax
80104161:	83 f8 01             	cmp    $0x1,%eax
80104164:	74 1a                	je     80104180 <scheduler+0x40>
80104166:	83 f8 02             	cmp    $0x2,%eax
80104169:	74 35                	je     801041a0 <scheduler+0x60>
8010416b:	85 c0                	test   %eax,%eax
8010416d:	74 21                	je     80104190 <scheduler+0x50>
      panic("bad scheduler type");
8010416f:	83 ec 0c             	sub    $0xc,%esp
80104172:	68 bb 7d 10 80       	push   $0x80107dbb
80104177:	e8 14 c2 ff ff       	call   80100390 <panic>
8010417c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      priority_scheduler(c);
80104180:	83 ec 0c             	sub    $0xc,%esp
80104183:	53                   	push   %ebx
80104184:	e8 f7 fc ff ff       	call   80103e80 <priority_scheduler>
      break;
80104189:	83 c4 10             	add    $0x10,%esp
8010418c:	eb ce                	jmp    8010415c <scheduler+0x1c>
8010418e:	66 90                	xchg   %ax,%ax
      default_scheduler(c);
80104190:	83 ec 0c             	sub    $0xc,%esp
80104193:	53                   	push   %ebx
80104194:	e8 d7 fe ff ff       	call   80104070 <default_scheduler>
      break;
80104199:	83 c4 10             	add    $0x10,%esp
8010419c:	eb be                	jmp    8010415c <scheduler+0x1c>
8010419e:	66 90                	xchg   %ax,%ax
      fair_scheduler(c);
801041a0:	83 ec 0c             	sub    $0xc,%esp
801041a3:	53                   	push   %ebx
801041a4:	e8 c7 fd ff ff       	call   80103f70 <fair_scheduler>
      break;
801041a9:	83 c4 10             	add    $0x10,%esp
801041ac:	eb ae                	jmp    8010415c <scheduler+0x1c>
801041ae:	66 90                	xchg   %ax,%ax

801041b0 <sched>:
{
801041b0:	f3 0f 1e fb          	endbr32 
801041b4:	55                   	push   %ebp
801041b5:	89 e5                	mov    %esp,%ebp
801041b7:	56                   	push   %esi
801041b8:	53                   	push   %ebx
  pushcli();
801041b9:	e8 f2 08 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
801041be:	e8 cd f8 ff ff       	call   80103a90 <mycpu>
  p = c->proc;
801041c3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041c9:	e8 32 09 00 00       	call   80104b00 <popcli>
  if(!holding(&ptable.lock))
801041ce:	83 ec 0c             	sub    $0xc,%esp
801041d1:	68 20 3d 11 80       	push   $0x80113d20
801041d6:	e8 85 09 00 00       	call   80104b60 <holding>
801041db:	83 c4 10             	add    $0x10,%esp
801041de:	85 c0                	test   %eax,%eax
801041e0:	74 4f                	je     80104231 <sched+0x81>
  if(mycpu()->ncli != 1)
801041e2:	e8 a9 f8 ff ff       	call   80103a90 <mycpu>
801041e7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801041ee:	75 68                	jne    80104258 <sched+0xa8>
  if(p->state == RUNNING)
801041f0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801041f4:	74 55                	je     8010424b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041f6:	9c                   	pushf  
801041f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041f8:	f6 c4 02             	test   $0x2,%ah
801041fb:	75 41                	jne    8010423e <sched+0x8e>
  intena = mycpu()->intena;
801041fd:	e8 8e f8 ff ff       	call   80103a90 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104202:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104205:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010420b:	e8 80 f8 ff ff       	call   80103a90 <mycpu>
80104210:	83 ec 08             	sub    $0x8,%esp
80104213:	ff 70 04             	pushl  0x4(%eax)
80104216:	53                   	push   %ebx
80104217:	e8 c7 0c 00 00       	call   80104ee3 <swtch>
  mycpu()->intena = intena;
8010421c:	e8 6f f8 ff ff       	call   80103a90 <mycpu>
}
80104221:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104224:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010422a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010422d:	5b                   	pop    %ebx
8010422e:	5e                   	pop    %esi
8010422f:	5d                   	pop    %ebp
80104230:	c3                   	ret    
    panic("sched ptable.lock");
80104231:	83 ec 0c             	sub    $0xc,%esp
80104234:	68 ce 7d 10 80       	push   $0x80107dce
80104239:	e8 52 c1 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010423e:	83 ec 0c             	sub    $0xc,%esp
80104241:	68 fa 7d 10 80       	push   $0x80107dfa
80104246:	e8 45 c1 ff ff       	call   80100390 <panic>
    panic("sched running");
8010424b:	83 ec 0c             	sub    $0xc,%esp
8010424e:	68 ec 7d 10 80       	push   $0x80107dec
80104253:	e8 38 c1 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	68 e0 7d 10 80       	push   $0x80107de0
80104260:	e8 2b c1 ff ff       	call   80100390 <panic>
80104265:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104270 <exit>:
{
80104270:	f3 0f 1e fb          	endbr32 
80104274:	55                   	push   %ebp
80104275:	89 e5                	mov    %esp,%ebp
80104277:	57                   	push   %edi
80104278:	56                   	push   %esi
80104279:	53                   	push   %ebx
8010427a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010427d:	e8 2e 08 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80104282:	e8 09 f8 ff ff       	call   80103a90 <mycpu>
  p = c->proc;
80104287:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010428d:	e8 6e 08 00 00       	call   80104b00 <popcli>
  if(curproc == initproc)
80104292:	8d 5e 28             	lea    0x28(%esi),%ebx
80104295:	8d 7e 68             	lea    0x68(%esi),%edi
80104298:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
8010429e:	0f 84 bd 00 00 00    	je     80104361 <exit+0xf1>
801042a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801042a8:	8b 03                	mov    (%ebx),%eax
801042aa:	85 c0                	test   %eax,%eax
801042ac:	74 12                	je     801042c0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801042ae:	83 ec 0c             	sub    $0xc,%esp
801042b1:	50                   	push   %eax
801042b2:	e8 09 cc ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
801042b7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801042bd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801042c0:	83 c3 04             	add    $0x4,%ebx
801042c3:	39 fb                	cmp    %edi,%ebx
801042c5:	75 e1                	jne    801042a8 <exit+0x38>
  begin_op();
801042c7:	e8 64 ea ff ff       	call   80102d30 <begin_op>
  iput(curproc->cwd);
801042cc:	83 ec 0c             	sub    $0xc,%esp
801042cf:	ff 76 68             	pushl  0x68(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042d2:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  iput(curproc->cwd);
801042d7:	e8 b4 d5 ff ff       	call   80101890 <iput>
  end_op();
801042dc:	e8 bf ea ff ff       	call   80102da0 <end_op>
  curproc->cwd = 0;
801042e1:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801042e8:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801042ef:	e8 bc 08 00 00       	call   80104bb0 <acquire>
  curproc->exit_status = status;
801042f4:	8b 45 08             	mov    0x8(%ebp),%eax
801042f7:	89 46 7c             	mov    %eax,0x7c(%esi)
  wakeup1(curproc->parent);
801042fa:	8b 46 14             	mov    0x14(%esi),%eax
801042fd:	e8 9e f4 ff ff       	call   801037a0 <wakeup1>
80104302:	83 c4 10             	add    $0x10,%esp
80104305:	eb 17                	jmp    8010431e <exit+0xae>
80104307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430e:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104310:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104316:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
8010431c:	74 2a                	je     80104348 <exit+0xd8>
    if(p->parent == curproc){
8010431e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104321:	75 ed                	jne    80104310 <exit+0xa0>
      p->parent = initproc;
80104323:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
      if(p->state == ZOMBIE)
80104328:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
      p->parent = initproc;
8010432c:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
8010432f:	75 df                	jne    80104310 <exit+0xa0>
        wakeup1(initproc);
80104331:	e8 6a f4 ff ff       	call   801037a0 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104336:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
8010433c:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80104342:	75 da                	jne    8010431e <exit+0xae>
80104344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  curproc->state = ZOMBIE;
80104348:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010434f:	e8 5c fe ff ff       	call   801041b0 <sched>
  panic("zombie exit");
80104354:	83 ec 0c             	sub    $0xc,%esp
80104357:	68 1b 7e 10 80       	push   $0x80107e1b
8010435c:	e8 2f c0 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104361:	83 ec 0c             	sub    $0xc,%esp
80104364:	68 0e 7e 10 80       	push   $0x80107e0e
80104369:	e8 22 c0 ff ff       	call   80100390 <panic>
8010436e:	66 90                	xchg   %ax,%ax

80104370 <update_ptable_stats>:
void update_ptable_stats(){
80104370:	f3 0f 1e fb          	endbr32 
80104374:	55                   	push   %ebp
80104375:	89 e5                	mov    %esp,%ebp
80104377:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
8010437a:	68 20 3d 11 80       	push   $0x80113d20
8010437f:	e8 2c 08 00 00       	call   80104bb0 <acquire>
80104384:	83 c4 10             	add    $0x10,%esp
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80104387:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010438c:	eb 13                	jmp    801043a1 <update_ptable_stats+0x31>
8010438e:	66 90                	xchg   %ax,%ax
    switch (proc->state)
80104390:	83 fa 02             	cmp    $0x2,%edx
80104393:	74 53                	je     801043e8 <update_ptable_stats+0x78>
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80104395:	05 9c 00 00 00       	add    $0x9c,%eax
8010439a:	3d 54 64 11 80       	cmp    $0x80116454,%eax
8010439f:	74 20                	je     801043c1 <update_ptable_stats+0x51>
    switch (proc->state)
801043a1:	8b 50 0c             	mov    0xc(%eax),%edx
801043a4:	83 fa 03             	cmp    $0x3,%edx
801043a7:	74 2f                	je     801043d8 <update_ptable_stats+0x68>
801043a9:	83 fa 04             	cmp    $0x4,%edx
801043ac:	75 e2                	jne    80104390 <update_ptable_stats+0x20>
      proc->rtime++;
801043ae:	83 80 90 00 00 00 01 	addl   $0x1,0x90(%eax)
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
801043b5:	05 9c 00 00 00       	add    $0x9c,%eax
801043ba:	3d 54 64 11 80       	cmp    $0x80116454,%eax
801043bf:	75 e0                	jne    801043a1 <update_ptable_stats+0x31>
  release(&ptable.lock);
801043c1:	83 ec 0c             	sub    $0xc,%esp
801043c4:	68 20 3d 11 80       	push   $0x80113d20
801043c9:	e8 a2 08 00 00       	call   80104c70 <release>
}
801043ce:	83 c4 10             	add    $0x10,%esp
801043d1:	c9                   	leave  
801043d2:	c3                   	ret    
801043d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043d7:	90                   	nop
      proc->retime++;
801043d8:	83 80 94 00 00 00 01 	addl   $0x1,0x94(%eax)
      break;
801043df:	eb b4                	jmp    80104395 <update_ptable_stats+0x25>
801043e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      proc->stime++;
801043e8:	83 80 98 00 00 00 01 	addl   $0x1,0x98(%eax)
      break;
801043ef:	eb a4                	jmp    80104395 <update_ptable_stats+0x25>
801043f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ff:	90                   	nop

80104400 <yield>:
{
80104400:	f3 0f 1e fb          	endbr32 
80104404:	55                   	push   %ebp
80104405:	89 e5                	mov    %esp,%ebp
80104407:	53                   	push   %ebx
80104408:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010440b:	68 20 3d 11 80       	push   $0x80113d20
80104410:	e8 9b 07 00 00       	call   80104bb0 <acquire>
  pushcli();
80104415:	e8 96 06 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
8010441a:	e8 71 f6 ff ff       	call   80103a90 <mycpu>
  p = c->proc;
8010441f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104425:	e8 d6 06 00 00       	call   80104b00 <popcli>
  myproc()->state = RUNNABLE;
8010442a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104431:	e8 7a fd ff ff       	call   801041b0 <sched>
  release(&ptable.lock);
80104436:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010443d:	e8 2e 08 00 00       	call   80104c70 <release>
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
80104463:	e8 48 06 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80104468:	e8 23 f6 ff ff       	call   80103a90 <mycpu>
  p = c->proc;
8010446d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104473:	e8 88 06 00 00       	call   80104b00 <popcli>
  if(p == 0)
80104478:	85 db                	test   %ebx,%ebx
8010447a:	0f 84 83 00 00 00    	je     80104503 <sleep+0xb3>
  if(lk == 0)
80104480:	85 f6                	test   %esi,%esi
80104482:	74 72                	je     801044f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104484:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
8010448a:	74 4c                	je     801044d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010448c:	83 ec 0c             	sub    $0xc,%esp
8010448f:	68 20 3d 11 80       	push   $0x80113d20
80104494:	e8 17 07 00 00       	call   80104bb0 <acquire>
    release(lk);
80104499:	89 34 24             	mov    %esi,(%esp)
8010449c:	e8 cf 07 00 00       	call   80104c70 <release>
  p->chan = chan;
801044a1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801044a4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044ab:	e8 00 fd ff ff       	call   801041b0 <sched>
  p->chan = 0;
801044b0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801044b7:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801044be:	e8 ad 07 00 00       	call   80104c70 <release>
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
801044d0:	e9 db 06 00 00       	jmp    80104bb0 <acquire>
801044d5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801044d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801044db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044e2:	e8 c9 fc ff ff       	call   801041b0 <sched>
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
801044f9:	68 2d 7e 10 80       	push   $0x80107e2d
801044fe:	e8 8d be ff ff       	call   80100390 <panic>
    panic("sleep");
80104503:	83 ec 0c             	sub    $0xc,%esp
80104506:	68 27 7e 10 80       	push   $0x80107e27
8010450b:	e8 80 be ff ff       	call   80100390 <panic>

80104510 <wait>:
{
80104510:	f3 0f 1e fb          	endbr32 
80104514:	55                   	push   %ebp
80104515:	89 e5                	mov    %esp,%ebp
80104517:	57                   	push   %edi
80104518:	56                   	push   %esi
80104519:	53                   	push   %ebx
8010451a:	83 ec 0c             	sub    $0xc,%esp
8010451d:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
80104520:	e8 8b 05 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80104525:	e8 66 f5 ff ff       	call   80103a90 <mycpu>
  p = c->proc;
8010452a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104530:	e8 cb 05 00 00       	call   80104b00 <popcli>
  acquire(&ptable.lock);
80104535:	83 ec 0c             	sub    $0xc,%esp
80104538:	68 20 3d 11 80       	push   $0x80113d20
8010453d:	e8 6e 06 00 00       	call   80104bb0 <acquire>
80104542:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104545:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104547:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
8010454c:	eb 10                	jmp    8010455e <wait+0x4e>
8010454e:	66 90                	xchg   %ax,%ax
80104550:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104556:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
8010455c:	74 1e                	je     8010457c <wait+0x6c>
      if(p->parent != curproc)
8010455e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104561:	75 ed                	jne    80104550 <wait+0x40>
      if(p->state == ZOMBIE){
80104563:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104567:	74 37                	je     801045a0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104569:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
      havekids = 1;
8010456f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104574:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
8010457a:	75 e2                	jne    8010455e <wait+0x4e>
    if(!havekids || curproc->killed){
8010457c:	85 c0                	test   %eax,%eax
8010457e:	0f 84 7c 00 00 00    	je     80104600 <wait+0xf0>
80104584:	8b 46 24             	mov    0x24(%esi),%eax
80104587:	85 c0                	test   %eax,%eax
80104589:	75 75                	jne    80104600 <wait+0xf0>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010458b:	83 ec 08             	sub    $0x8,%esp
8010458e:	68 20 3d 11 80       	push   $0x80113d20
80104593:	56                   	push   %esi
80104594:	e8 b7 fe ff ff       	call   80104450 <sleep>
    havekids = 0;
80104599:	83 c4 10             	add    $0x10,%esp
8010459c:	eb a7                	jmp    80104545 <wait+0x35>
8010459e:	66 90                	xchg   %ax,%ax
        pid = p->pid;
801045a0:	8b 73 10             	mov    0x10(%ebx),%esi
        if (status != null){
801045a3:	85 ff                	test   %edi,%edi
801045a5:	74 05                	je     801045ac <wait+0x9c>
          *status = p->exit_status; // returning child's exit status
801045a7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801045aa:	89 07                	mov    %eax,(%edi)
        kfree(p->kstack);
801045ac:	83 ec 0c             	sub    $0xc,%esp
801045af:	ff 73 08             	pushl  0x8(%ebx)
801045b2:	e8 b9 de ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
801045b7:	5a                   	pop    %edx
801045b8:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801045bb:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801045c2:	e8 59 2f 00 00       	call   80107520 <freevm>
        release(&ptable.lock);
801045c7:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
801045ce:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801045d5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801045dc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801045e0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801045e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801045ee:	e8 7d 06 00 00       	call   80104c70 <release>
        return pid;
801045f3:	83 c4 10             	add    $0x10,%esp
}
801045f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045f9:	89 f0                	mov    %esi,%eax
801045fb:	5b                   	pop    %ebx
801045fc:	5e                   	pop    %esi
801045fd:	5f                   	pop    %edi
801045fe:	5d                   	pop    %ebp
801045ff:	c3                   	ret    
      release(&ptable.lock);
80104600:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104603:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104608:	68 20 3d 11 80       	push   $0x80113d20
8010460d:	e8 5e 06 00 00       	call   80104c70 <release>
      return -1;
80104612:	83 c4 10             	add    $0x10,%esp
80104615:	eb df                	jmp    801045f6 <wait+0xe6>
80104617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010461e:	66 90                	xchg   %ax,%ax

80104620 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104620:	f3 0f 1e fb          	endbr32 
80104624:	55                   	push   %ebp
80104625:	89 e5                	mov    %esp,%ebp
80104627:	53                   	push   %ebx
80104628:	83 ec 10             	sub    $0x10,%esp
8010462b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010462e:	68 20 3d 11 80       	push   $0x80113d20
80104633:	e8 78 05 00 00       	call   80104bb0 <acquire>
  wakeup1(chan);
80104638:	89 d8                	mov    %ebx,%eax
8010463a:	e8 61 f1 ff ff       	call   801037a0 <wakeup1>
  release(&ptable.lock);
8010463f:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104646:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&ptable.lock);
80104649:	83 c4 10             	add    $0x10,%esp
}
8010464c:	c9                   	leave  
  release(&ptable.lock);
8010464d:	e9 1e 06 00 00       	jmp    80104c70 <release>
80104652:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104660 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104660:	f3 0f 1e fb          	endbr32 
80104664:	55                   	push   %ebp
80104665:	89 e5                	mov    %esp,%ebp
80104667:	53                   	push   %ebx
80104668:	83 ec 10             	sub    $0x10,%esp
8010466b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010466e:	68 20 3d 11 80       	push   $0x80113d20
80104673:	e8 38 05 00 00       	call   80104bb0 <acquire>
80104678:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010467b:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104680:	eb 12                	jmp    80104694 <kill+0x34>
80104682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104688:	05 9c 00 00 00       	add    $0x9c,%eax
8010468d:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104692:	74 34                	je     801046c8 <kill+0x68>
    if(p->pid == pid){
80104694:	39 58 10             	cmp    %ebx,0x10(%eax)
80104697:	75 ef                	jne    80104688 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104699:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010469d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801046a4:	75 07                	jne    801046ad <kill+0x4d>
        p->state = RUNNABLE;
801046a6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801046ad:	83 ec 0c             	sub    $0xc,%esp
801046b0:	68 20 3d 11 80       	push   $0x80113d20
801046b5:	e8 b6 05 00 00       	call   80104c70 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801046ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801046bd:	83 c4 10             	add    $0x10,%esp
801046c0:	31 c0                	xor    %eax,%eax
}
801046c2:	c9                   	leave  
801046c3:	c3                   	ret    
801046c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801046c8:	83 ec 0c             	sub    $0xc,%esp
801046cb:	68 20 3d 11 80       	push   $0x80113d20
801046d0:	e8 9b 05 00 00       	call   80104c70 <release>
}
801046d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801046d8:	83 c4 10             	add    $0x10,%esp
801046db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046e0:	c9                   	leave  
801046e1:	c3                   	ret    
801046e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801046f0:	f3 0f 1e fb          	endbr32 
801046f4:	55                   	push   %ebp
801046f5:	89 e5                	mov    %esp,%ebp
801046f7:	57                   	push   %edi
801046f8:	56                   	push   %esi
801046f9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801046fc:	53                   	push   %ebx
801046fd:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
80104702:	83 ec 3c             	sub    $0x3c,%esp
80104705:	eb 2b                	jmp    80104732 <procdump+0x42>
80104707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104710:	83 ec 0c             	sub    $0xc,%esp
80104713:	68 cb 81 10 80       	push   $0x801081cb
80104718:	e8 93 bf ff ff       	call   801006b0 <cprintf>
8010471d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104720:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104726:	81 fb c0 64 11 80    	cmp    $0x801164c0,%ebx
8010472c:	0f 84 8e 00 00 00    	je     801047c0 <procdump+0xd0>
    if(p->state == UNUSED)
80104732:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104735:	85 c0                	test   %eax,%eax
80104737:	74 e7                	je     80104720 <procdump+0x30>
      state = "???";
80104739:	ba 3e 7e 10 80       	mov    $0x80107e3e,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010473e:	83 f8 05             	cmp    $0x5,%eax
80104741:	77 11                	ja     80104754 <procdump+0x64>
80104743:	8b 14 85 ac 7e 10 80 	mov    -0x7fef8154(,%eax,4),%edx
      state = "???";
8010474a:	b8 3e 7e 10 80       	mov    $0x80107e3e,%eax
8010474f:	85 d2                	test   %edx,%edx
80104751:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104754:	53                   	push   %ebx
80104755:	52                   	push   %edx
80104756:	ff 73 a4             	pushl  -0x5c(%ebx)
80104759:	68 42 7e 10 80       	push   $0x80107e42
8010475e:	e8 4d bf ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104763:	83 c4 10             	add    $0x10,%esp
80104766:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010476a:	75 a4                	jne    80104710 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010476c:	83 ec 08             	sub    $0x8,%esp
8010476f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104772:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104775:	50                   	push   %eax
80104776:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104779:	8b 40 0c             	mov    0xc(%eax),%eax
8010477c:	83 c0 08             	add    $0x8,%eax
8010477f:	50                   	push   %eax
80104780:	e8 cb 02 00 00       	call   80104a50 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104785:	83 c4 10             	add    $0x10,%esp
80104788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010478f:	90                   	nop
80104790:	8b 17                	mov    (%edi),%edx
80104792:	85 d2                	test   %edx,%edx
80104794:	0f 84 76 ff ff ff    	je     80104710 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010479a:	83 ec 08             	sub    $0x8,%esp
8010479d:	83 c7 04             	add    $0x4,%edi
801047a0:	52                   	push   %edx
801047a1:	68 81 78 10 80       	push   $0x80107881
801047a6:	e8 05 bf ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801047ab:	83 c4 10             	add    $0x10,%esp
801047ae:	39 fe                	cmp    %edi,%esi
801047b0:	75 de                	jne    80104790 <procdump+0xa0>
801047b2:	e9 59 ff ff ff       	jmp    80104710 <procdump+0x20>
801047b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047be:	66 90                	xchg   %ax,%ax
  }
}
801047c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047c3:	5b                   	pop    %ebx
801047c4:	5e                   	pop    %esi
801047c5:	5f                   	pop    %edi
801047c6:	5d                   	pop    %ebp
801047c7:	c3                   	ret    
801047c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047cf:	90                   	nop

801047d0 <set_ps_priority>:

int set_ps_priority(int priority){
801047d0:	f3 0f 1e fb          	endbr32 
801047d4:	55                   	push   %ebp
801047d5:	89 e5                	mov    %esp,%ebp
801047d7:	56                   	push   %esi
801047d8:	53                   	push   %ebx
801047d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (priority > 10 || priority < 1){
801047dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
801047df:	83 f8 09             	cmp    $0x9,%eax
801047e2:	77 24                	ja     80104808 <set_ps_priority+0x38>
  pushcli();
801047e4:	e8 c7 02 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
801047e9:	e8 a2 f2 ff ff       	call   80103a90 <mycpu>
  p = c->proc;
801047ee:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801047f4:	e8 07 03 00 00       	call   80104b00 <popcli>
    return -1;
  }
  else{
    myproc()->ps_priority = priority;
    return 0;
801047f9:	31 c0                	xor    %eax,%eax
    myproc()->ps_priority = priority;
801047fb:	89 9e 80 00 00 00    	mov    %ebx,0x80(%esi)
  }
}
80104801:	5b                   	pop    %ebx
80104802:	5e                   	pop    %esi
80104803:	5d                   	pop    %ebp
80104804:	c3                   	ret    
80104805:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104808:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010480d:	eb f2                	jmp    80104801 <set_ps_priority+0x31>
8010480f:	90                   	nop

80104810 <policy>:

int policy(int policy){
80104810:	f3 0f 1e fb          	endbr32 
80104814:	55                   	push   %ebp
80104815:	89 e5                	mov    %esp,%ebp
80104817:	8b 45 08             	mov    0x8(%ebp),%eax
  if (policy > 3 || policy < 0){
8010481a:	83 f8 03             	cmp    $0x3,%eax
8010481d:	77 11                	ja     80104830 <policy+0x20>
    return -1; 
  }
  else{
    sched_type = policy;
8010481f:	a3 18 0f 11 80       	mov    %eax,0x80110f18
    return 0;
  } 
}
80104824:	5d                   	pop    %ebp
    return 0;
80104825:	31 c0                	xor    %eax,%eax
}
80104827:	c3                   	ret    
80104828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482f:	90                   	nop
    return -1; 
80104830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104835:	5d                   	pop    %ebp
80104836:	c3                   	ret    
80104837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010483e:	66 90                	xchg   %ax,%ax

80104840 <set_cfs_priority>:

int set_cfs_priority(int priority){
80104840:	f3 0f 1e fb          	endbr32 
80104844:	55                   	push   %ebp
80104845:	89 e5                	mov    %esp,%ebp
80104847:	53                   	push   %ebx
80104848:	83 ec 14             	sub    $0x14,%esp
8010484b:	8b 45 08             	mov    0x8(%ebp),%eax
8010484e:	83 e8 01             	sub    $0x1,%eax
80104851:	83 f8 02             	cmp    $0x2,%eax
80104854:	77 3a                	ja     80104890 <set_cfs_priority+0x50>
80104856:	d9 04 85 a0 7e 10 80 	flds   -0x7fef8160(,%eax,4)
8010485d:	d9 5d f4             	fstps  -0xc(%ebp)
  pushcli();
80104860:	e8 4b 02 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
80104865:	e8 26 f2 ff ff       	call   80103a90 <mycpu>
  p = c->proc;
8010486a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104870:	e8 8b 02 00 00       	call   80104b00 <popcli>
      break;
    default:
      return -1;
  }

  myproc()->cfs_decay_factor = decay_factor;
80104875:	d9 45 f4             	flds   -0xc(%ebp)
  return 0;
80104878:	31 c0                	xor    %eax,%eax
  myproc()->cfs_decay_factor = decay_factor;
8010487a:	d9 9b 8c 00 00 00    	fstps  0x8c(%ebx)
}
80104880:	83 c4 14             	add    $0x14,%esp
80104883:	5b                   	pop    %ebx
80104884:	5d                   	pop    %ebp
80104885:	c3                   	ret    
80104886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488d:	8d 76 00             	lea    0x0(%esi),%esi
      return -1;
80104890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104895:	eb e9                	jmp    80104880 <set_cfs_priority+0x40>
80104897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489e:	66 90                	xchg   %ax,%ax

801048a0 <proc_info>:

int proc_info(struct perf* performance){
801048a0:	f3 0f 1e fb          	endbr32 
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	56                   	push   %esi
801048a8:	53                   	push   %ebx
801048a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801048ac:	e8 ff 01 00 00       	call   80104ab0 <pushcli>
  c = mycpu();
801048b1:	e8 da f1 ff ff       	call   80103a90 <mycpu>
  p = c->proc;
801048b6:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801048bc:	e8 3f 02 00 00       	call   80104b00 <popcli>
  struct proc* p = myproc();
  performance->ps_priority = p->ps_priority;
801048c1:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
801048c7:	89 03                	mov    %eax,(%ebx)
  performance->retime = p->retime;
801048c9:	8b 86 94 00 00 00    	mov    0x94(%esi),%eax
801048cf:	89 43 08             	mov    %eax,0x8(%ebx)
  performance->rtime = p->rtime;
801048d2:	8b 86 90 00 00 00    	mov    0x90(%esi),%eax
801048d8:	89 43 0c             	mov    %eax,0xc(%ebx)
  performance->stime = p->stime;
801048db:	8b 86 98 00 00 00    	mov    0x98(%esi),%eax
801048e1:	89 43 04             	mov    %eax,0x4(%ebx)
  return 0; // TODO: verify this
}
801048e4:	31 c0                	xor    %eax,%eax
801048e6:	5b                   	pop    %ebx
801048e7:	5e                   	pop    %esi
801048e8:	5d                   	pop    %ebp
801048e9:	c3                   	ret    
801048ea:	66 90                	xchg   %ax,%ax
801048ec:	66 90                	xchg   %ax,%ax
801048ee:	66 90                	xchg   %ax,%ax

801048f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	53                   	push   %ebx
801048f8:	83 ec 0c             	sub    $0xc,%esp
801048fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801048fe:	68 c8 7e 10 80       	push   $0x80107ec8
80104903:	8d 43 04             	lea    0x4(%ebx),%eax
80104906:	50                   	push   %eax
80104907:	e8 24 01 00 00       	call   80104a30 <initlock>
  lk->name = name;
8010490c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010490f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104915:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104918:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010491f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104922:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104925:	c9                   	leave  
80104926:	c3                   	ret    
80104927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492e:	66 90                	xchg   %ax,%ax

80104930 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104930:	f3 0f 1e fb          	endbr32 
80104934:	55                   	push   %ebp
80104935:	89 e5                	mov    %esp,%ebp
80104937:	56                   	push   %esi
80104938:	53                   	push   %ebx
80104939:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010493c:	8d 73 04             	lea    0x4(%ebx),%esi
8010493f:	83 ec 0c             	sub    $0xc,%esp
80104942:	56                   	push   %esi
80104943:	e8 68 02 00 00       	call   80104bb0 <acquire>
  while (lk->locked) {
80104948:	8b 13                	mov    (%ebx),%edx
8010494a:	83 c4 10             	add    $0x10,%esp
8010494d:	85 d2                	test   %edx,%edx
8010494f:	74 1a                	je     8010496b <acquiresleep+0x3b>
80104951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104958:	83 ec 08             	sub    $0x8,%esp
8010495b:	56                   	push   %esi
8010495c:	53                   	push   %ebx
8010495d:	e8 ee fa ff ff       	call   80104450 <sleep>
  while (lk->locked) {
80104962:	8b 03                	mov    (%ebx),%eax
80104964:	83 c4 10             	add    $0x10,%esp
80104967:	85 c0                	test   %eax,%eax
80104969:	75 ed                	jne    80104958 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010496b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104971:	e8 aa f1 ff ff       	call   80103b20 <myproc>
80104976:	8b 40 10             	mov    0x10(%eax),%eax
80104979:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010497c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010497f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104982:	5b                   	pop    %ebx
80104983:	5e                   	pop    %esi
80104984:	5d                   	pop    %ebp
  release(&lk->lk);
80104985:	e9 e6 02 00 00       	jmp    80104c70 <release>
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104990 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104990:	f3 0f 1e fb          	endbr32 
80104994:	55                   	push   %ebp
80104995:	89 e5                	mov    %esp,%ebp
80104997:	56                   	push   %esi
80104998:	53                   	push   %ebx
80104999:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010499c:	8d 73 04             	lea    0x4(%ebx),%esi
8010499f:	83 ec 0c             	sub    $0xc,%esp
801049a2:	56                   	push   %esi
801049a3:	e8 08 02 00 00       	call   80104bb0 <acquire>
  lk->locked = 0;
801049a8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801049ae:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801049b5:	89 1c 24             	mov    %ebx,(%esp)
801049b8:	e8 63 fc ff ff       	call   80104620 <wakeup>
  release(&lk->lk);
801049bd:	89 75 08             	mov    %esi,0x8(%ebp)
801049c0:	83 c4 10             	add    $0x10,%esp
}
801049c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049c6:	5b                   	pop    %ebx
801049c7:	5e                   	pop    %esi
801049c8:	5d                   	pop    %ebp
  release(&lk->lk);
801049c9:	e9 a2 02 00 00       	jmp    80104c70 <release>
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801049d0:	f3 0f 1e fb          	endbr32 
801049d4:	55                   	push   %ebp
801049d5:	89 e5                	mov    %esp,%ebp
801049d7:	57                   	push   %edi
801049d8:	31 ff                	xor    %edi,%edi
801049da:	56                   	push   %esi
801049db:	53                   	push   %ebx
801049dc:	83 ec 18             	sub    $0x18,%esp
801049df:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801049e2:	8d 73 04             	lea    0x4(%ebx),%esi
801049e5:	56                   	push   %esi
801049e6:	e8 c5 01 00 00       	call   80104bb0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801049eb:	8b 03                	mov    (%ebx),%eax
801049ed:	83 c4 10             	add    $0x10,%esp
801049f0:	85 c0                	test   %eax,%eax
801049f2:	75 1c                	jne    80104a10 <holdingsleep+0x40>
  release(&lk->lk);
801049f4:	83 ec 0c             	sub    $0xc,%esp
801049f7:	56                   	push   %esi
801049f8:	e8 73 02 00 00       	call   80104c70 <release>
  return r;
}
801049fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a00:	89 f8                	mov    %edi,%eax
80104a02:	5b                   	pop    %ebx
80104a03:	5e                   	pop    %esi
80104a04:	5f                   	pop    %edi
80104a05:	5d                   	pop    %ebp
80104a06:	c3                   	ret    
80104a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104a10:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a13:	e8 08 f1 ff ff       	call   80103b20 <myproc>
80104a18:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a1b:	0f 94 c0             	sete   %al
80104a1e:	0f b6 c0             	movzbl %al,%eax
80104a21:	89 c7                	mov    %eax,%edi
80104a23:	eb cf                	jmp    801049f4 <holdingsleep+0x24>
80104a25:	66 90                	xchg   %ax,%ax
80104a27:	66 90                	xchg   %ax,%ax
80104a29:	66 90                	xchg   %ax,%ax
80104a2b:	66 90                	xchg   %ax,%ax
80104a2d:	66 90                	xchg   %ax,%ax
80104a2f:	90                   	nop

80104a30 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a30:	f3 0f 1e fb          	endbr32 
80104a34:	55                   	push   %ebp
80104a35:	89 e5                	mov    %esp,%ebp
80104a37:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a43:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a46:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a4d:	5d                   	pop    %ebp
80104a4e:	c3                   	ret    
80104a4f:	90                   	nop

80104a50 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a50:	f3 0f 1e fb          	endbr32 
80104a54:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a55:	31 d2                	xor    %edx,%edx
{
80104a57:	89 e5                	mov    %esp,%ebp
80104a59:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104a5a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104a5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104a60:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104a63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a67:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a68:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a6e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a74:	77 1a                	ja     80104a90 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a76:	8b 58 04             	mov    0x4(%eax),%ebx
80104a79:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a7c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a7f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a81:	83 fa 0a             	cmp    $0xa,%edx
80104a84:	75 e2                	jne    80104a68 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104a86:	5b                   	pop    %ebx
80104a87:	5d                   	pop    %ebp
80104a88:	c3                   	ret    
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104a90:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104a93:	8d 51 28             	lea    0x28(%ecx),%edx
80104a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104aa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104aa6:	83 c0 04             	add    $0x4,%eax
80104aa9:	39 d0                	cmp    %edx,%eax
80104aab:	75 f3                	jne    80104aa0 <getcallerpcs+0x50>
}
80104aad:	5b                   	pop    %ebx
80104aae:	5d                   	pop    %ebp
80104aaf:	c3                   	ret    

80104ab0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ab0:	f3 0f 1e fb          	endbr32 
80104ab4:	55                   	push   %ebp
80104ab5:	89 e5                	mov    %esp,%ebp
80104ab7:	53                   	push   %ebx
80104ab8:	83 ec 04             	sub    $0x4,%esp
80104abb:	9c                   	pushf  
80104abc:	5b                   	pop    %ebx
  asm volatile("cli");
80104abd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104abe:	e8 cd ef ff ff       	call   80103a90 <mycpu>
80104ac3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ac9:	85 c0                	test   %eax,%eax
80104acb:	74 13                	je     80104ae0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104acd:	e8 be ef ff ff       	call   80103a90 <mycpu>
80104ad2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ad9:	83 c4 04             	add    $0x4,%esp
80104adc:	5b                   	pop    %ebx
80104add:	5d                   	pop    %ebp
80104ade:	c3                   	ret    
80104adf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104ae0:	e8 ab ef ff ff       	call   80103a90 <mycpu>
80104ae5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104aeb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104af1:	eb da                	jmp    80104acd <pushcli+0x1d>
80104af3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b00 <popcli>:

void
popcli(void)
{
80104b00:	f3 0f 1e fb          	endbr32 
80104b04:	55                   	push   %ebp
80104b05:	89 e5                	mov    %esp,%ebp
80104b07:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b0a:	9c                   	pushf  
80104b0b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b0c:	f6 c4 02             	test   $0x2,%ah
80104b0f:	75 31                	jne    80104b42 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b11:	e8 7a ef ff ff       	call   80103a90 <mycpu>
80104b16:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b1d:	78 30                	js     80104b4f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b1f:	e8 6c ef ff ff       	call   80103a90 <mycpu>
80104b24:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b2a:	85 d2                	test   %edx,%edx
80104b2c:	74 02                	je     80104b30 <popcli+0x30>
    sti();
}
80104b2e:	c9                   	leave  
80104b2f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b30:	e8 5b ef ff ff       	call   80103a90 <mycpu>
80104b35:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b3b:	85 c0                	test   %eax,%eax
80104b3d:	74 ef                	je     80104b2e <popcli+0x2e>
  asm volatile("sti");
80104b3f:	fb                   	sti    
}
80104b40:	c9                   	leave  
80104b41:	c3                   	ret    
    panic("popcli - interruptible");
80104b42:	83 ec 0c             	sub    $0xc,%esp
80104b45:	68 d3 7e 10 80       	push   $0x80107ed3
80104b4a:	e8 41 b8 ff ff       	call   80100390 <panic>
    panic("popcli");
80104b4f:	83 ec 0c             	sub    $0xc,%esp
80104b52:	68 ea 7e 10 80       	push   $0x80107eea
80104b57:	e8 34 b8 ff ff       	call   80100390 <panic>
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b60 <holding>:
{
80104b60:	f3 0f 1e fb          	endbr32 
80104b64:	55                   	push   %ebp
80104b65:	89 e5                	mov    %esp,%ebp
80104b67:	56                   	push   %esi
80104b68:	53                   	push   %ebx
80104b69:	8b 75 08             	mov    0x8(%ebp),%esi
80104b6c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104b6e:	e8 3d ff ff ff       	call   80104ab0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b73:	8b 06                	mov    (%esi),%eax
80104b75:	85 c0                	test   %eax,%eax
80104b77:	75 0f                	jne    80104b88 <holding+0x28>
  popcli();
80104b79:	e8 82 ff ff ff       	call   80104b00 <popcli>
}
80104b7e:	89 d8                	mov    %ebx,%eax
80104b80:	5b                   	pop    %ebx
80104b81:	5e                   	pop    %esi
80104b82:	5d                   	pop    %ebp
80104b83:	c3                   	ret    
80104b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104b88:	8b 5e 08             	mov    0x8(%esi),%ebx
80104b8b:	e8 00 ef ff ff       	call   80103a90 <mycpu>
80104b90:	39 c3                	cmp    %eax,%ebx
80104b92:	0f 94 c3             	sete   %bl
  popcli();
80104b95:	e8 66 ff ff ff       	call   80104b00 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104b9a:	0f b6 db             	movzbl %bl,%ebx
}
80104b9d:	89 d8                	mov    %ebx,%eax
80104b9f:	5b                   	pop    %ebx
80104ba0:	5e                   	pop    %esi
80104ba1:	5d                   	pop    %ebp
80104ba2:	c3                   	ret    
80104ba3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bb0 <acquire>:
{
80104bb0:	f3 0f 1e fb          	endbr32 
80104bb4:	55                   	push   %ebp
80104bb5:	89 e5                	mov    %esp,%ebp
80104bb7:	56                   	push   %esi
80104bb8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104bb9:	e8 f2 fe ff ff       	call   80104ab0 <pushcli>
  if(holding(lk))
80104bbe:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bc1:	83 ec 0c             	sub    $0xc,%esp
80104bc4:	53                   	push   %ebx
80104bc5:	e8 96 ff ff ff       	call   80104b60 <holding>
80104bca:	83 c4 10             	add    $0x10,%esp
80104bcd:	85 c0                	test   %eax,%eax
80104bcf:	0f 85 7f 00 00 00    	jne    80104c54 <acquire+0xa4>
80104bd5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104bd7:	ba 01 00 00 00       	mov    $0x1,%edx
80104bdc:	eb 05                	jmp    80104be3 <acquire+0x33>
80104bde:	66 90                	xchg   %ax,%ax
80104be0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104be3:	89 d0                	mov    %edx,%eax
80104be5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104be8:	85 c0                	test   %eax,%eax
80104bea:	75 f4                	jne    80104be0 <acquire+0x30>
  __sync_synchronize();
80104bec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104bf1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bf4:	e8 97 ee ff ff       	call   80103a90 <mycpu>
80104bf9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104bfc:	89 e8                	mov    %ebp,%eax
80104bfe:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c00:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104c06:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104c0c:	77 22                	ja     80104c30 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104c0e:	8b 50 04             	mov    0x4(%eax),%edx
80104c11:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104c15:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104c18:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c1a:	83 fe 0a             	cmp    $0xa,%esi
80104c1d:	75 e1                	jne    80104c00 <acquire+0x50>
}
80104c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c22:	5b                   	pop    %ebx
80104c23:	5e                   	pop    %esi
80104c24:	5d                   	pop    %ebp
80104c25:	c3                   	ret    
80104c26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104c30:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104c34:	83 c3 34             	add    $0x34,%ebx
80104c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104c40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c46:	83 c0 04             	add    $0x4,%eax
80104c49:	39 d8                	cmp    %ebx,%eax
80104c4b:	75 f3                	jne    80104c40 <acquire+0x90>
}
80104c4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c50:	5b                   	pop    %ebx
80104c51:	5e                   	pop    %esi
80104c52:	5d                   	pop    %ebp
80104c53:	c3                   	ret    
    panic("acquire");
80104c54:	83 ec 0c             	sub    $0xc,%esp
80104c57:	68 f1 7e 10 80       	push   $0x80107ef1
80104c5c:	e8 2f b7 ff ff       	call   80100390 <panic>
80104c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6f:	90                   	nop

80104c70 <release>:
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	53                   	push   %ebx
80104c78:	83 ec 10             	sub    $0x10,%esp
80104c7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104c7e:	53                   	push   %ebx
80104c7f:	e8 dc fe ff ff       	call   80104b60 <holding>
80104c84:	83 c4 10             	add    $0x10,%esp
80104c87:	85 c0                	test   %eax,%eax
80104c89:	74 22                	je     80104cad <release+0x3d>
  lk->pcs[0] = 0;
80104c8b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104c92:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104c99:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104c9e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104ca4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca7:	c9                   	leave  
  popcli();
80104ca8:	e9 53 fe ff ff       	jmp    80104b00 <popcli>
    panic("release");
80104cad:	83 ec 0c             	sub    $0xc,%esp
80104cb0:	68 f9 7e 10 80       	push   $0x80107ef9
80104cb5:	e8 d6 b6 ff ff       	call   80100390 <panic>
80104cba:	66 90                	xchg   %ax,%ax
80104cbc:	66 90                	xchg   %ax,%ax
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cc0:	f3 0f 1e fb          	endbr32 
80104cc4:	55                   	push   %ebp
80104cc5:	89 e5                	mov    %esp,%ebp
80104cc7:	57                   	push   %edi
80104cc8:	8b 55 08             	mov    0x8(%ebp),%edx
80104ccb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104cce:	53                   	push   %ebx
80104ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104cd2:	89 d7                	mov    %edx,%edi
80104cd4:	09 cf                	or     %ecx,%edi
80104cd6:	83 e7 03             	and    $0x3,%edi
80104cd9:	75 25                	jne    80104d00 <memset+0x40>
    c &= 0xFF;
80104cdb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104cde:	c1 e0 18             	shl    $0x18,%eax
80104ce1:	89 fb                	mov    %edi,%ebx
80104ce3:	c1 e9 02             	shr    $0x2,%ecx
80104ce6:	c1 e3 10             	shl    $0x10,%ebx
80104ce9:	09 d8                	or     %ebx,%eax
80104ceb:	09 f8                	or     %edi,%eax
80104ced:	c1 e7 08             	shl    $0x8,%edi
80104cf0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104cf2:	89 d7                	mov    %edx,%edi
80104cf4:	fc                   	cld    
80104cf5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104cf7:	5b                   	pop    %ebx
80104cf8:	89 d0                	mov    %edx,%eax
80104cfa:	5f                   	pop    %edi
80104cfb:	5d                   	pop    %ebp
80104cfc:	c3                   	ret    
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104d00:	89 d7                	mov    %edx,%edi
80104d02:	fc                   	cld    
80104d03:	f3 aa                	rep stos %al,%es:(%edi)
80104d05:	5b                   	pop    %ebx
80104d06:	89 d0                	mov    %edx,%eax
80104d08:	5f                   	pop    %edi
80104d09:	5d                   	pop    %ebp
80104d0a:	c3                   	ret    
80104d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d0f:	90                   	nop

80104d10 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d10:	f3 0f 1e fb          	endbr32 
80104d14:	55                   	push   %ebp
80104d15:	89 e5                	mov    %esp,%ebp
80104d17:	56                   	push   %esi
80104d18:	8b 75 10             	mov    0x10(%ebp),%esi
80104d1b:	8b 55 08             	mov    0x8(%ebp),%edx
80104d1e:	53                   	push   %ebx
80104d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d22:	85 f6                	test   %esi,%esi
80104d24:	74 2a                	je     80104d50 <memcmp+0x40>
80104d26:	01 c6                	add    %eax,%esi
80104d28:	eb 10                	jmp    80104d3a <memcmp+0x2a>
80104d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104d30:	83 c0 01             	add    $0x1,%eax
80104d33:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104d36:	39 f0                	cmp    %esi,%eax
80104d38:	74 16                	je     80104d50 <memcmp+0x40>
    if(*s1 != *s2)
80104d3a:	0f b6 0a             	movzbl (%edx),%ecx
80104d3d:	0f b6 18             	movzbl (%eax),%ebx
80104d40:	38 d9                	cmp    %bl,%cl
80104d42:	74 ec                	je     80104d30 <memcmp+0x20>
      return *s1 - *s2;
80104d44:	0f b6 c1             	movzbl %cl,%eax
80104d47:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104d49:	5b                   	pop    %ebx
80104d4a:	5e                   	pop    %esi
80104d4b:	5d                   	pop    %ebp
80104d4c:	c3                   	ret    
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
80104d50:	5b                   	pop    %ebx
  return 0;
80104d51:	31 c0                	xor    %eax,%eax
}
80104d53:	5e                   	pop    %esi
80104d54:	5d                   	pop    %ebp
80104d55:	c3                   	ret    
80104d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi

80104d60 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d60:	f3 0f 1e fb          	endbr32 
80104d64:	55                   	push   %ebp
80104d65:	89 e5                	mov    %esp,%ebp
80104d67:	57                   	push   %edi
80104d68:	8b 55 08             	mov    0x8(%ebp),%edx
80104d6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d6e:	56                   	push   %esi
80104d6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d72:	39 d6                	cmp    %edx,%esi
80104d74:	73 2a                	jae    80104da0 <memmove+0x40>
80104d76:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104d79:	39 fa                	cmp    %edi,%edx
80104d7b:	73 23                	jae    80104da0 <memmove+0x40>
80104d7d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104d80:	85 c9                	test   %ecx,%ecx
80104d82:	74 13                	je     80104d97 <memmove+0x37>
80104d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104d88:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104d8c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104d8f:	83 e8 01             	sub    $0x1,%eax
80104d92:	83 f8 ff             	cmp    $0xffffffff,%eax
80104d95:	75 f1                	jne    80104d88 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d97:	5e                   	pop    %esi
80104d98:	89 d0                	mov    %edx,%eax
80104d9a:	5f                   	pop    %edi
80104d9b:	5d                   	pop    %ebp
80104d9c:	c3                   	ret    
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104da0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104da3:	89 d7                	mov    %edx,%edi
80104da5:	85 c9                	test   %ecx,%ecx
80104da7:	74 ee                	je     80104d97 <memmove+0x37>
80104da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104db0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104db1:	39 f0                	cmp    %esi,%eax
80104db3:	75 fb                	jne    80104db0 <memmove+0x50>
}
80104db5:	5e                   	pop    %esi
80104db6:	89 d0                	mov    %edx,%eax
80104db8:	5f                   	pop    %edi
80104db9:	5d                   	pop    %ebp
80104dba:	c3                   	ret    
80104dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dbf:	90                   	nop

80104dc0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104dc0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104dc4:	eb 9a                	jmp    80104d60 <memmove>
80104dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dcd:	8d 76 00             	lea    0x0(%esi),%esi

80104dd0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104dd0:	f3 0f 1e fb          	endbr32 
80104dd4:	55                   	push   %ebp
80104dd5:	89 e5                	mov    %esp,%ebp
80104dd7:	56                   	push   %esi
80104dd8:	8b 75 10             	mov    0x10(%ebp),%esi
80104ddb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dde:	53                   	push   %ebx
80104ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104de2:	85 f6                	test   %esi,%esi
80104de4:	74 32                	je     80104e18 <strncmp+0x48>
80104de6:	01 c6                	add    %eax,%esi
80104de8:	eb 14                	jmp    80104dfe <strncmp+0x2e>
80104dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104df0:	38 da                	cmp    %bl,%dl
80104df2:	75 14                	jne    80104e08 <strncmp+0x38>
    n--, p++, q++;
80104df4:	83 c0 01             	add    $0x1,%eax
80104df7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104dfa:	39 f0                	cmp    %esi,%eax
80104dfc:	74 1a                	je     80104e18 <strncmp+0x48>
80104dfe:	0f b6 11             	movzbl (%ecx),%edx
80104e01:	0f b6 18             	movzbl (%eax),%ebx
80104e04:	84 d2                	test   %dl,%dl
80104e06:	75 e8                	jne    80104df0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104e08:	0f b6 c2             	movzbl %dl,%eax
80104e0b:	29 d8                	sub    %ebx,%eax
}
80104e0d:	5b                   	pop    %ebx
80104e0e:	5e                   	pop    %esi
80104e0f:	5d                   	pop    %ebp
80104e10:	c3                   	ret    
80104e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e18:	5b                   	pop    %ebx
    return 0;
80104e19:	31 c0                	xor    %eax,%eax
}
80104e1b:	5e                   	pop    %esi
80104e1c:	5d                   	pop    %ebp
80104e1d:	c3                   	ret    
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
80104e25:	89 e5                	mov    %esp,%ebp
80104e27:	57                   	push   %edi
80104e28:	56                   	push   %esi
80104e29:	8b 75 08             	mov    0x8(%ebp),%esi
80104e2c:	53                   	push   %ebx
80104e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e30:	89 f2                	mov    %esi,%edx
80104e32:	eb 1b                	jmp    80104e4f <strncpy+0x2f>
80104e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e38:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104e3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104e3f:	83 c2 01             	add    $0x1,%edx
80104e42:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104e46:	89 f9                	mov    %edi,%ecx
80104e48:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e4b:	84 c9                	test   %cl,%cl
80104e4d:	74 09                	je     80104e58 <strncpy+0x38>
80104e4f:	89 c3                	mov    %eax,%ebx
80104e51:	83 e8 01             	sub    $0x1,%eax
80104e54:	85 db                	test   %ebx,%ebx
80104e56:	7f e0                	jg     80104e38 <strncpy+0x18>
    ;
  while(n-- > 0)
80104e58:	89 d1                	mov    %edx,%ecx
80104e5a:	85 c0                	test   %eax,%eax
80104e5c:	7e 15                	jle    80104e73 <strncpy+0x53>
80104e5e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104e60:	83 c1 01             	add    $0x1,%ecx
80104e63:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104e67:	89 c8                	mov    %ecx,%eax
80104e69:	f7 d0                	not    %eax
80104e6b:	01 d0                	add    %edx,%eax
80104e6d:	01 d8                	add    %ebx,%eax
80104e6f:	85 c0                	test   %eax,%eax
80104e71:	7f ed                	jg     80104e60 <strncpy+0x40>
  return os;
}
80104e73:	5b                   	pop    %ebx
80104e74:	89 f0                	mov    %esi,%eax
80104e76:	5e                   	pop    %esi
80104e77:	5f                   	pop    %edi
80104e78:	5d                   	pop    %ebp
80104e79:	c3                   	ret    
80104e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e80 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104e80:	f3 0f 1e fb          	endbr32 
80104e84:	55                   	push   %ebp
80104e85:	89 e5                	mov    %esp,%ebp
80104e87:	56                   	push   %esi
80104e88:	8b 55 10             	mov    0x10(%ebp),%edx
80104e8b:	8b 75 08             	mov    0x8(%ebp),%esi
80104e8e:	53                   	push   %ebx
80104e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104e92:	85 d2                	test   %edx,%edx
80104e94:	7e 21                	jle    80104eb7 <safestrcpy+0x37>
80104e96:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104e9a:	89 f2                	mov    %esi,%edx
80104e9c:	eb 12                	jmp    80104eb0 <safestrcpy+0x30>
80104e9e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ea0:	0f b6 08             	movzbl (%eax),%ecx
80104ea3:	83 c0 01             	add    $0x1,%eax
80104ea6:	83 c2 01             	add    $0x1,%edx
80104ea9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104eac:	84 c9                	test   %cl,%cl
80104eae:	74 04                	je     80104eb4 <safestrcpy+0x34>
80104eb0:	39 d8                	cmp    %ebx,%eax
80104eb2:	75 ec                	jne    80104ea0 <safestrcpy+0x20>
    ;
  *s = 0;
80104eb4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104eb7:	89 f0                	mov    %esi,%eax
80104eb9:	5b                   	pop    %ebx
80104eba:	5e                   	pop    %esi
80104ebb:	5d                   	pop    %ebp
80104ebc:	c3                   	ret    
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi

80104ec0 <strlen>:

int
strlen(const char *s)
{
80104ec0:	f3 0f 1e fb          	endbr32 
80104ec4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ec5:	31 c0                	xor    %eax,%eax
{
80104ec7:	89 e5                	mov    %esp,%ebp
80104ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ecc:	80 3a 00             	cmpb   $0x0,(%edx)
80104ecf:	74 10                	je     80104ee1 <strlen+0x21>
80104ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ed8:	83 c0 01             	add    $0x1,%eax
80104edb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104edf:	75 f7                	jne    80104ed8 <strlen+0x18>
    ;
  return n;
}
80104ee1:	5d                   	pop    %ebp
80104ee2:	c3                   	ret    

80104ee3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104ee3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104ee7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104eeb:	55                   	push   %ebp
  pushl %ebx
80104eec:	53                   	push   %ebx
  pushl %esi
80104eed:	56                   	push   %esi
  pushl %edi
80104eee:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104eef:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ef1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104ef3:	5f                   	pop    %edi
  popl %esi
80104ef4:	5e                   	pop    %esi
  popl %ebx
80104ef5:	5b                   	pop    %ebx
  popl %ebp
80104ef6:	5d                   	pop    %ebp
  ret
80104ef7:	c3                   	ret    
80104ef8:	66 90                	xchg   %ax,%ax
80104efa:	66 90                	xchg   %ax,%ax
80104efc:	66 90                	xchg   %ax,%ax
80104efe:	66 90                	xchg   %ax,%ax

80104f00 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f00:	f3 0f 1e fb          	endbr32 
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	53                   	push   %ebx
80104f08:	83 ec 04             	sub    $0x4,%esp
80104f0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f0e:	e8 0d ec ff ff       	call   80103b20 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f13:	8b 00                	mov    (%eax),%eax
80104f15:	39 d8                	cmp    %ebx,%eax
80104f17:	76 17                	jbe    80104f30 <fetchint+0x30>
80104f19:	8d 53 04             	lea    0x4(%ebx),%edx
80104f1c:	39 d0                	cmp    %edx,%eax
80104f1e:	72 10                	jb     80104f30 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f20:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f23:	8b 13                	mov    (%ebx),%edx
80104f25:	89 10                	mov    %edx,(%eax)
  return 0;
80104f27:	31 c0                	xor    %eax,%eax
}
80104f29:	83 c4 04             	add    $0x4,%esp
80104f2c:	5b                   	pop    %ebx
80104f2d:	5d                   	pop    %ebp
80104f2e:	c3                   	ret    
80104f2f:	90                   	nop
    return -1;
80104f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f35:	eb f2                	jmp    80104f29 <fetchint+0x29>
80104f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3e:	66 90                	xchg   %ax,%ax

80104f40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f40:	f3 0f 1e fb          	endbr32 
80104f44:	55                   	push   %ebp
80104f45:	89 e5                	mov    %esp,%ebp
80104f47:	53                   	push   %ebx
80104f48:	83 ec 04             	sub    $0x4,%esp
80104f4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f4e:	e8 cd eb ff ff       	call   80103b20 <myproc>

  if(addr >= curproc->sz)
80104f53:	39 18                	cmp    %ebx,(%eax)
80104f55:	76 31                	jbe    80104f88 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104f57:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f5a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104f5c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104f5e:	39 d3                	cmp    %edx,%ebx
80104f60:	73 26                	jae    80104f88 <fetchstr+0x48>
80104f62:	89 d8                	mov    %ebx,%eax
80104f64:	eb 11                	jmp    80104f77 <fetchstr+0x37>
80104f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi
80104f70:	83 c0 01             	add    $0x1,%eax
80104f73:	39 c2                	cmp    %eax,%edx
80104f75:	76 11                	jbe    80104f88 <fetchstr+0x48>
    if(*s == 0)
80104f77:	80 38 00             	cmpb   $0x0,(%eax)
80104f7a:	75 f4                	jne    80104f70 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104f7c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104f7f:	29 d8                	sub    %ebx,%eax
}
80104f81:	5b                   	pop    %ebx
80104f82:	5d                   	pop    %ebp
80104f83:	c3                   	ret    
80104f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f88:	83 c4 04             	add    $0x4,%esp
    return -1;
80104f8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f90:	5b                   	pop    %ebx
80104f91:	5d                   	pop    %ebp
80104f92:	c3                   	ret    
80104f93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fa0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104fa0:	f3 0f 1e fb          	endbr32 
80104fa4:	55                   	push   %ebp
80104fa5:	89 e5                	mov    %esp,%ebp
80104fa7:	56                   	push   %esi
80104fa8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fa9:	e8 72 eb ff ff       	call   80103b20 <myproc>
80104fae:	8b 55 08             	mov    0x8(%ebp),%edx
80104fb1:	8b 40 18             	mov    0x18(%eax),%eax
80104fb4:	8b 40 44             	mov    0x44(%eax),%eax
80104fb7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104fba:	e8 61 eb ff ff       	call   80103b20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fbf:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fc2:	8b 00                	mov    (%eax),%eax
80104fc4:	39 c6                	cmp    %eax,%esi
80104fc6:	73 18                	jae    80104fe0 <argint+0x40>
80104fc8:	8d 53 08             	lea    0x8(%ebx),%edx
80104fcb:	39 d0                	cmp    %edx,%eax
80104fcd:	72 11                	jb     80104fe0 <argint+0x40>
  *ip = *(int*)(addr);
80104fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fd2:	8b 53 04             	mov    0x4(%ebx),%edx
80104fd5:	89 10                	mov    %edx,(%eax)
  return 0;
80104fd7:	31 c0                	xor    %eax,%eax
}
80104fd9:	5b                   	pop    %ebx
80104fda:	5e                   	pop    %esi
80104fdb:	5d                   	pop    %ebp
80104fdc:	c3                   	ret    
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fe5:	eb f2                	jmp    80104fd9 <argint+0x39>
80104fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fee:	66 90                	xchg   %ax,%ax

80104ff0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ff0:	f3 0f 1e fb          	endbr32 
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	56                   	push   %esi
80104ff8:	53                   	push   %ebx
80104ff9:	83 ec 10             	sub    $0x10,%esp
80104ffc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104fff:	e8 1c eb ff ff       	call   80103b20 <myproc>
 
  if(argint(n, &i) < 0)
80105004:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105007:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105009:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010500c:	50                   	push   %eax
8010500d:	ff 75 08             	pushl  0x8(%ebp)
80105010:	e8 8b ff ff ff       	call   80104fa0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105015:	83 c4 10             	add    $0x10,%esp
80105018:	85 c0                	test   %eax,%eax
8010501a:	78 24                	js     80105040 <argptr+0x50>
8010501c:	85 db                	test   %ebx,%ebx
8010501e:	78 20                	js     80105040 <argptr+0x50>
80105020:	8b 16                	mov    (%esi),%edx
80105022:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105025:	39 c2                	cmp    %eax,%edx
80105027:	76 17                	jbe    80105040 <argptr+0x50>
80105029:	01 c3                	add    %eax,%ebx
8010502b:	39 da                	cmp    %ebx,%edx
8010502d:	72 11                	jb     80105040 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010502f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105032:	89 02                	mov    %eax,(%edx)
  return 0;
80105034:	31 c0                	xor    %eax,%eax
}
80105036:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105039:	5b                   	pop    %ebx
8010503a:	5e                   	pop    %esi
8010503b:	5d                   	pop    %ebp
8010503c:	c3                   	ret    
8010503d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105045:	eb ef                	jmp    80105036 <argptr+0x46>
80105047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010504e:	66 90                	xchg   %ax,%ax

80105050 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105050:	f3 0f 1e fb          	endbr32 
80105054:	55                   	push   %ebp
80105055:	89 e5                	mov    %esp,%ebp
80105057:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010505a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010505d:	50                   	push   %eax
8010505e:	ff 75 08             	pushl  0x8(%ebp)
80105061:	e8 3a ff ff ff       	call   80104fa0 <argint>
80105066:	83 c4 10             	add    $0x10,%esp
80105069:	85 c0                	test   %eax,%eax
8010506b:	78 13                	js     80105080 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010506d:	83 ec 08             	sub    $0x8,%esp
80105070:	ff 75 0c             	pushl  0xc(%ebp)
80105073:	ff 75 f4             	pushl  -0xc(%ebp)
80105076:	e8 c5 fe ff ff       	call   80104f40 <fetchstr>
8010507b:	83 c4 10             	add    $0x10,%esp
}
8010507e:	c9                   	leave  
8010507f:	c3                   	ret    
80105080:	c9                   	leave  
    return -1;
80105081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105086:	c3                   	ret    
80105087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508e:	66 90                	xchg   %ax,%ax

80105090 <syscall>:
[SYS_proc_info] sys_proc_info
};

void
syscall(void)
{
80105090:	f3 0f 1e fb          	endbr32 
80105094:	55                   	push   %ebp
80105095:	89 e5                	mov    %esp,%ebp
80105097:	53                   	push   %ebx
80105098:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010509b:	e8 80 ea ff ff       	call   80103b20 <myproc>
801050a0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801050a2:	8b 40 18             	mov    0x18(%eax),%eax
801050a5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801050a8:	8d 50 ff             	lea    -0x1(%eax),%edx
801050ab:	83 fa 19             	cmp    $0x19,%edx
801050ae:	77 20                	ja     801050d0 <syscall+0x40>
801050b0:	8b 14 85 20 7f 10 80 	mov    -0x7fef80e0(,%eax,4),%edx
801050b7:	85 d2                	test   %edx,%edx
801050b9:	74 15                	je     801050d0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801050bb:	ff d2                	call   *%edx
801050bd:	89 c2                	mov    %eax,%edx
801050bf:	8b 43 18             	mov    0x18(%ebx),%eax
801050c2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801050c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050c8:	c9                   	leave  
801050c9:	c3                   	ret    
801050ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801050d0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801050d1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801050d4:	50                   	push   %eax
801050d5:	ff 73 10             	pushl  0x10(%ebx)
801050d8:	68 01 7f 10 80       	push   $0x80107f01
801050dd:	e8 ce b5 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801050e2:	8b 43 18             	mov    0x18(%ebx),%eax
801050e5:	83 c4 10             	add    $0x10,%esp
801050e8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801050ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050f2:	c9                   	leave  
801050f3:	c3                   	ret    
801050f4:	66 90                	xchg   %ax,%ax
801050f6:	66 90                	xchg   %ax,%ax
801050f8:	66 90                	xchg   %ax,%ax
801050fa:	66 90                	xchg   %ax,%ax
801050fc:	66 90                	xchg   %ax,%ax
801050fe:	66 90                	xchg   %ax,%ax

80105100 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	57                   	push   %edi
80105104:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105105:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105108:	53                   	push   %ebx
80105109:	83 ec 34             	sub    $0x34,%esp
8010510c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010510f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105112:	57                   	push   %edi
80105113:	50                   	push   %eax
{
80105114:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105117:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010511a:	e8 31 cf ff ff       	call   80102050 <nameiparent>
8010511f:	83 c4 10             	add    $0x10,%esp
80105122:	85 c0                	test   %eax,%eax
80105124:	0f 84 46 01 00 00    	je     80105270 <create+0x170>
    return 0;
  ilock(dp);
8010512a:	83 ec 0c             	sub    $0xc,%esp
8010512d:	89 c3                	mov    %eax,%ebx
8010512f:	50                   	push   %eax
80105130:	e8 2b c6 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105135:	83 c4 0c             	add    $0xc,%esp
80105138:	6a 00                	push   $0x0
8010513a:	57                   	push   %edi
8010513b:	53                   	push   %ebx
8010513c:	e8 6f cb ff ff       	call   80101cb0 <dirlookup>
80105141:	83 c4 10             	add    $0x10,%esp
80105144:	89 c6                	mov    %eax,%esi
80105146:	85 c0                	test   %eax,%eax
80105148:	74 56                	je     801051a0 <create+0xa0>
    iunlockput(dp);
8010514a:	83 ec 0c             	sub    $0xc,%esp
8010514d:	53                   	push   %ebx
8010514e:	e8 ad c8 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80105153:	89 34 24             	mov    %esi,(%esp)
80105156:	e8 05 c6 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010515b:	83 c4 10             	add    $0x10,%esp
8010515e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105163:	75 1b                	jne    80105180 <create+0x80>
80105165:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010516a:	75 14                	jne    80105180 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010516c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010516f:	89 f0                	mov    %esi,%eax
80105171:	5b                   	pop    %ebx
80105172:	5e                   	pop    %esi
80105173:	5f                   	pop    %edi
80105174:	5d                   	pop    %ebp
80105175:	c3                   	ret    
80105176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105180:	83 ec 0c             	sub    $0xc,%esp
80105183:	56                   	push   %esi
    return 0;
80105184:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105186:	e8 75 c8 ff ff       	call   80101a00 <iunlockput>
    return 0;
8010518b:	83 c4 10             	add    $0x10,%esp
}
8010518e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105191:	89 f0                	mov    %esi,%eax
80105193:	5b                   	pop    %ebx
80105194:	5e                   	pop    %esi
80105195:	5f                   	pop    %edi
80105196:	5d                   	pop    %ebp
80105197:	c3                   	ret    
80105198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010519f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801051a0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801051a4:	83 ec 08             	sub    $0x8,%esp
801051a7:	50                   	push   %eax
801051a8:	ff 33                	pushl  (%ebx)
801051aa:	e8 31 c4 ff ff       	call   801015e0 <ialloc>
801051af:	83 c4 10             	add    $0x10,%esp
801051b2:	89 c6                	mov    %eax,%esi
801051b4:	85 c0                	test   %eax,%eax
801051b6:	0f 84 cd 00 00 00    	je     80105289 <create+0x189>
  ilock(ip);
801051bc:	83 ec 0c             	sub    $0xc,%esp
801051bf:	50                   	push   %eax
801051c0:	e8 9b c5 ff ff       	call   80101760 <ilock>
  ip->major = major;
801051c5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801051c9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801051cd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801051d1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801051d5:	b8 01 00 00 00       	mov    $0x1,%eax
801051da:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801051de:	89 34 24             	mov    %esi,(%esp)
801051e1:	e8 ba c4 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801051e6:	83 c4 10             	add    $0x10,%esp
801051e9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801051ee:	74 30                	je     80105220 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801051f0:	83 ec 04             	sub    $0x4,%esp
801051f3:	ff 76 04             	pushl  0x4(%esi)
801051f6:	57                   	push   %edi
801051f7:	53                   	push   %ebx
801051f8:	e8 73 cd ff ff       	call   80101f70 <dirlink>
801051fd:	83 c4 10             	add    $0x10,%esp
80105200:	85 c0                	test   %eax,%eax
80105202:	78 78                	js     8010527c <create+0x17c>
  iunlockput(dp);
80105204:	83 ec 0c             	sub    $0xc,%esp
80105207:	53                   	push   %ebx
80105208:	e8 f3 c7 ff ff       	call   80101a00 <iunlockput>
  return ip;
8010520d:	83 c4 10             	add    $0x10,%esp
}
80105210:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105213:	89 f0                	mov    %esi,%eax
80105215:	5b                   	pop    %ebx
80105216:	5e                   	pop    %esi
80105217:	5f                   	pop    %edi
80105218:	5d                   	pop    %ebp
80105219:	c3                   	ret    
8010521a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105220:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105223:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105228:	53                   	push   %ebx
80105229:	e8 72 c4 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010522e:	83 c4 0c             	add    $0xc,%esp
80105231:	ff 76 04             	pushl  0x4(%esi)
80105234:	68 a8 7f 10 80       	push   $0x80107fa8
80105239:	56                   	push   %esi
8010523a:	e8 31 cd ff ff       	call   80101f70 <dirlink>
8010523f:	83 c4 10             	add    $0x10,%esp
80105242:	85 c0                	test   %eax,%eax
80105244:	78 18                	js     8010525e <create+0x15e>
80105246:	83 ec 04             	sub    $0x4,%esp
80105249:	ff 73 04             	pushl  0x4(%ebx)
8010524c:	68 a7 7f 10 80       	push   $0x80107fa7
80105251:	56                   	push   %esi
80105252:	e8 19 cd ff ff       	call   80101f70 <dirlink>
80105257:	83 c4 10             	add    $0x10,%esp
8010525a:	85 c0                	test   %eax,%eax
8010525c:	79 92                	jns    801051f0 <create+0xf0>
      panic("create dots");
8010525e:	83 ec 0c             	sub    $0xc,%esp
80105261:	68 9b 7f 10 80       	push   $0x80107f9b
80105266:	e8 25 b1 ff ff       	call   80100390 <panic>
8010526b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010526f:	90                   	nop
}
80105270:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105273:	31 f6                	xor    %esi,%esi
}
80105275:	5b                   	pop    %ebx
80105276:	89 f0                	mov    %esi,%eax
80105278:	5e                   	pop    %esi
80105279:	5f                   	pop    %edi
8010527a:	5d                   	pop    %ebp
8010527b:	c3                   	ret    
    panic("create: dirlink");
8010527c:	83 ec 0c             	sub    $0xc,%esp
8010527f:	68 aa 7f 10 80       	push   $0x80107faa
80105284:	e8 07 b1 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105289:	83 ec 0c             	sub    $0xc,%esp
8010528c:	68 8c 7f 10 80       	push   $0x80107f8c
80105291:	e8 fa b0 ff ff       	call   80100390 <panic>
80105296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010529d:	8d 76 00             	lea    0x0(%esi),%esi

801052a0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	56                   	push   %esi
801052a4:	89 d6                	mov    %edx,%esi
801052a6:	53                   	push   %ebx
801052a7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801052a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801052ac:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801052af:	50                   	push   %eax
801052b0:	6a 00                	push   $0x0
801052b2:	e8 e9 fc ff ff       	call   80104fa0 <argint>
801052b7:	83 c4 10             	add    $0x10,%esp
801052ba:	85 c0                	test   %eax,%eax
801052bc:	78 2a                	js     801052e8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052be:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801052c2:	77 24                	ja     801052e8 <argfd.constprop.0+0x48>
801052c4:	e8 57 e8 ff ff       	call   80103b20 <myproc>
801052c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052cc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801052d0:	85 c0                	test   %eax,%eax
801052d2:	74 14                	je     801052e8 <argfd.constprop.0+0x48>
  if(pfd)
801052d4:	85 db                	test   %ebx,%ebx
801052d6:	74 02                	je     801052da <argfd.constprop.0+0x3a>
    *pfd = fd;
801052d8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801052da:	89 06                	mov    %eax,(%esi)
  return 0;
801052dc:	31 c0                	xor    %eax,%eax
}
801052de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052e1:	5b                   	pop    %ebx
801052e2:	5e                   	pop    %esi
801052e3:	5d                   	pop    %ebp
801052e4:	c3                   	ret    
801052e5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ed:	eb ef                	jmp    801052de <argfd.constprop.0+0x3e>
801052ef:	90                   	nop

801052f0 <sys_dup>:
{
801052f0:	f3 0f 1e fb          	endbr32 
801052f4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801052f5:	31 c0                	xor    %eax,%eax
{
801052f7:	89 e5                	mov    %esp,%ebp
801052f9:	56                   	push   %esi
801052fa:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801052fb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801052fe:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105301:	e8 9a ff ff ff       	call   801052a0 <argfd.constprop.0>
80105306:	85 c0                	test   %eax,%eax
80105308:	78 1e                	js     80105328 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010530a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010530d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010530f:	e8 0c e8 ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105318:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010531c:	85 d2                	test   %edx,%edx
8010531e:	74 20                	je     80105340 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105320:	83 c3 01             	add    $0x1,%ebx
80105323:	83 fb 10             	cmp    $0x10,%ebx
80105326:	75 f0                	jne    80105318 <sys_dup+0x28>
}
80105328:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010532b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105330:	89 d8                	mov    %ebx,%eax
80105332:	5b                   	pop    %ebx
80105333:	5e                   	pop    %esi
80105334:	5d                   	pop    %ebp
80105335:	c3                   	ret    
80105336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010533d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105340:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105344:	83 ec 0c             	sub    $0xc,%esp
80105347:	ff 75 f4             	pushl  -0xc(%ebp)
8010534a:	e8 21 bb ff ff       	call   80100e70 <filedup>
  return fd;
8010534f:	83 c4 10             	add    $0x10,%esp
}
80105352:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105355:	89 d8                	mov    %ebx,%eax
80105357:	5b                   	pop    %ebx
80105358:	5e                   	pop    %esi
80105359:	5d                   	pop    %ebp
8010535a:	c3                   	ret    
8010535b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010535f:	90                   	nop

80105360 <sys_read>:
{
80105360:	f3 0f 1e fb          	endbr32 
80105364:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105365:	31 c0                	xor    %eax,%eax
{
80105367:	89 e5                	mov    %esp,%ebp
80105369:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010536c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010536f:	e8 2c ff ff ff       	call   801052a0 <argfd.constprop.0>
80105374:	85 c0                	test   %eax,%eax
80105376:	78 48                	js     801053c0 <sys_read+0x60>
80105378:	83 ec 08             	sub    $0x8,%esp
8010537b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010537e:	50                   	push   %eax
8010537f:	6a 02                	push   $0x2
80105381:	e8 1a fc ff ff       	call   80104fa0 <argint>
80105386:	83 c4 10             	add    $0x10,%esp
80105389:	85 c0                	test   %eax,%eax
8010538b:	78 33                	js     801053c0 <sys_read+0x60>
8010538d:	83 ec 04             	sub    $0x4,%esp
80105390:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105393:	ff 75 f0             	pushl  -0x10(%ebp)
80105396:	50                   	push   %eax
80105397:	6a 01                	push   $0x1
80105399:	e8 52 fc ff ff       	call   80104ff0 <argptr>
8010539e:	83 c4 10             	add    $0x10,%esp
801053a1:	85 c0                	test   %eax,%eax
801053a3:	78 1b                	js     801053c0 <sys_read+0x60>
  return fileread(f, p, n);
801053a5:	83 ec 04             	sub    $0x4,%esp
801053a8:	ff 75 f0             	pushl  -0x10(%ebp)
801053ab:	ff 75 f4             	pushl  -0xc(%ebp)
801053ae:	ff 75 ec             	pushl  -0x14(%ebp)
801053b1:	e8 3a bc ff ff       	call   80100ff0 <fileread>
801053b6:	83 c4 10             	add    $0x10,%esp
}
801053b9:	c9                   	leave  
801053ba:	c3                   	ret    
801053bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053bf:	90                   	nop
801053c0:	c9                   	leave  
    return -1;
801053c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053c6:	c3                   	ret    
801053c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ce:	66 90                	xchg   %ax,%ax

801053d0 <sys_write>:
{
801053d0:	f3 0f 1e fb          	endbr32 
801053d4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053d5:	31 c0                	xor    %eax,%eax
{
801053d7:	89 e5                	mov    %esp,%ebp
801053d9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053dc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053df:	e8 bc fe ff ff       	call   801052a0 <argfd.constprop.0>
801053e4:	85 c0                	test   %eax,%eax
801053e6:	78 48                	js     80105430 <sys_write+0x60>
801053e8:	83 ec 08             	sub    $0x8,%esp
801053eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053ee:	50                   	push   %eax
801053ef:	6a 02                	push   $0x2
801053f1:	e8 aa fb ff ff       	call   80104fa0 <argint>
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	85 c0                	test   %eax,%eax
801053fb:	78 33                	js     80105430 <sys_write+0x60>
801053fd:	83 ec 04             	sub    $0x4,%esp
80105400:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105403:	ff 75 f0             	pushl  -0x10(%ebp)
80105406:	50                   	push   %eax
80105407:	6a 01                	push   $0x1
80105409:	e8 e2 fb ff ff       	call   80104ff0 <argptr>
8010540e:	83 c4 10             	add    $0x10,%esp
80105411:	85 c0                	test   %eax,%eax
80105413:	78 1b                	js     80105430 <sys_write+0x60>
  return filewrite(f, p, n);
80105415:	83 ec 04             	sub    $0x4,%esp
80105418:	ff 75 f0             	pushl  -0x10(%ebp)
8010541b:	ff 75 f4             	pushl  -0xc(%ebp)
8010541e:	ff 75 ec             	pushl  -0x14(%ebp)
80105421:	e8 6a bc ff ff       	call   80101090 <filewrite>
80105426:	83 c4 10             	add    $0x10,%esp
}
80105429:	c9                   	leave  
8010542a:	c3                   	ret    
8010542b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010542f:	90                   	nop
80105430:	c9                   	leave  
    return -1;
80105431:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105436:	c3                   	ret    
80105437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010543e:	66 90                	xchg   %ax,%ax

80105440 <sys_close>:
{
80105440:	f3 0f 1e fb          	endbr32 
80105444:	55                   	push   %ebp
80105445:	89 e5                	mov    %esp,%ebp
80105447:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010544a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010544d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105450:	e8 4b fe ff ff       	call   801052a0 <argfd.constprop.0>
80105455:	85 c0                	test   %eax,%eax
80105457:	78 27                	js     80105480 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105459:	e8 c2 e6 ff ff       	call   80103b20 <myproc>
8010545e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105461:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105464:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010546b:	00 
  fileclose(f);
8010546c:	ff 75 f4             	pushl  -0xc(%ebp)
8010546f:	e8 4c ba ff ff       	call   80100ec0 <fileclose>
  return 0;
80105474:	83 c4 10             	add    $0x10,%esp
80105477:	31 c0                	xor    %eax,%eax
}
80105479:	c9                   	leave  
8010547a:	c3                   	ret    
8010547b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010547f:	90                   	nop
80105480:	c9                   	leave  
    return -1;
80105481:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105486:	c3                   	ret    
80105487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010548e:	66 90                	xchg   %ax,%ax

80105490 <sys_fstat>:
{
80105490:	f3 0f 1e fb          	endbr32 
80105494:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105495:	31 c0                	xor    %eax,%eax
{
80105497:	89 e5                	mov    %esp,%ebp
80105499:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010549c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010549f:	e8 fc fd ff ff       	call   801052a0 <argfd.constprop.0>
801054a4:	85 c0                	test   %eax,%eax
801054a6:	78 30                	js     801054d8 <sys_fstat+0x48>
801054a8:	83 ec 04             	sub    $0x4,%esp
801054ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ae:	6a 14                	push   $0x14
801054b0:	50                   	push   %eax
801054b1:	6a 01                	push   $0x1
801054b3:	e8 38 fb ff ff       	call   80104ff0 <argptr>
801054b8:	83 c4 10             	add    $0x10,%esp
801054bb:	85 c0                	test   %eax,%eax
801054bd:	78 19                	js     801054d8 <sys_fstat+0x48>
  return filestat(f, st);
801054bf:	83 ec 08             	sub    $0x8,%esp
801054c2:	ff 75 f4             	pushl  -0xc(%ebp)
801054c5:	ff 75 f0             	pushl  -0x10(%ebp)
801054c8:	e8 d3 ba ff ff       	call   80100fa0 <filestat>
801054cd:	83 c4 10             	add    $0x10,%esp
}
801054d0:	c9                   	leave  
801054d1:	c3                   	ret    
801054d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054d8:	c9                   	leave  
    return -1;
801054d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054de:	c3                   	ret    
801054df:	90                   	nop

801054e0 <sys_link>:
{
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
801054e5:	89 e5                	mov    %esp,%ebp
801054e7:	57                   	push   %edi
801054e8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801054e9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801054ec:	53                   	push   %ebx
801054ed:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801054f0:	50                   	push   %eax
801054f1:	6a 00                	push   $0x0
801054f3:	e8 58 fb ff ff       	call   80105050 <argstr>
801054f8:	83 c4 10             	add    $0x10,%esp
801054fb:	85 c0                	test   %eax,%eax
801054fd:	0f 88 ff 00 00 00    	js     80105602 <sys_link+0x122>
80105503:	83 ec 08             	sub    $0x8,%esp
80105506:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105509:	50                   	push   %eax
8010550a:	6a 01                	push   $0x1
8010550c:	e8 3f fb ff ff       	call   80105050 <argstr>
80105511:	83 c4 10             	add    $0x10,%esp
80105514:	85 c0                	test   %eax,%eax
80105516:	0f 88 e6 00 00 00    	js     80105602 <sys_link+0x122>
  begin_op();
8010551c:	e8 0f d8 ff ff       	call   80102d30 <begin_op>
  if((ip = namei(old)) == 0){
80105521:	83 ec 0c             	sub    $0xc,%esp
80105524:	ff 75 d4             	pushl  -0x2c(%ebp)
80105527:	e8 04 cb ff ff       	call   80102030 <namei>
8010552c:	83 c4 10             	add    $0x10,%esp
8010552f:	89 c3                	mov    %eax,%ebx
80105531:	85 c0                	test   %eax,%eax
80105533:	0f 84 e8 00 00 00    	je     80105621 <sys_link+0x141>
  ilock(ip);
80105539:	83 ec 0c             	sub    $0xc,%esp
8010553c:	50                   	push   %eax
8010553d:	e8 1e c2 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105542:	83 c4 10             	add    $0x10,%esp
80105545:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010554a:	0f 84 b9 00 00 00    	je     80105609 <sys_link+0x129>
  iupdate(ip);
80105550:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105553:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105558:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010555b:	53                   	push   %ebx
8010555c:	e8 3f c1 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105561:	89 1c 24             	mov    %ebx,(%esp)
80105564:	e8 d7 c2 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105569:	58                   	pop    %eax
8010556a:	5a                   	pop    %edx
8010556b:	57                   	push   %edi
8010556c:	ff 75 d0             	pushl  -0x30(%ebp)
8010556f:	e8 dc ca ff ff       	call   80102050 <nameiparent>
80105574:	83 c4 10             	add    $0x10,%esp
80105577:	89 c6                	mov    %eax,%esi
80105579:	85 c0                	test   %eax,%eax
8010557b:	74 5f                	je     801055dc <sys_link+0xfc>
  ilock(dp);
8010557d:	83 ec 0c             	sub    $0xc,%esp
80105580:	50                   	push   %eax
80105581:	e8 da c1 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105586:	8b 03                	mov    (%ebx),%eax
80105588:	83 c4 10             	add    $0x10,%esp
8010558b:	39 06                	cmp    %eax,(%esi)
8010558d:	75 41                	jne    801055d0 <sys_link+0xf0>
8010558f:	83 ec 04             	sub    $0x4,%esp
80105592:	ff 73 04             	pushl  0x4(%ebx)
80105595:	57                   	push   %edi
80105596:	56                   	push   %esi
80105597:	e8 d4 c9 ff ff       	call   80101f70 <dirlink>
8010559c:	83 c4 10             	add    $0x10,%esp
8010559f:	85 c0                	test   %eax,%eax
801055a1:	78 2d                	js     801055d0 <sys_link+0xf0>
  iunlockput(dp);
801055a3:	83 ec 0c             	sub    $0xc,%esp
801055a6:	56                   	push   %esi
801055a7:	e8 54 c4 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
801055ac:	89 1c 24             	mov    %ebx,(%esp)
801055af:	e8 dc c2 ff ff       	call   80101890 <iput>
  end_op();
801055b4:	e8 e7 d7 ff ff       	call   80102da0 <end_op>
  return 0;
801055b9:	83 c4 10             	add    $0x10,%esp
801055bc:	31 c0                	xor    %eax,%eax
}
801055be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055c1:	5b                   	pop    %ebx
801055c2:	5e                   	pop    %esi
801055c3:	5f                   	pop    %edi
801055c4:	5d                   	pop    %ebp
801055c5:	c3                   	ret    
801055c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055cd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	56                   	push   %esi
801055d4:	e8 27 c4 ff ff       	call   80101a00 <iunlockput>
    goto bad;
801055d9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801055dc:	83 ec 0c             	sub    $0xc,%esp
801055df:	53                   	push   %ebx
801055e0:	e8 7b c1 ff ff       	call   80101760 <ilock>
  ip->nlink--;
801055e5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055ea:	89 1c 24             	mov    %ebx,(%esp)
801055ed:	e8 ae c0 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
801055f2:	89 1c 24             	mov    %ebx,(%esp)
801055f5:	e8 06 c4 ff ff       	call   80101a00 <iunlockput>
  end_op();
801055fa:	e8 a1 d7 ff ff       	call   80102da0 <end_op>
  return -1;
801055ff:	83 c4 10             	add    $0x10,%esp
80105602:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105607:	eb b5                	jmp    801055be <sys_link+0xde>
    iunlockput(ip);
80105609:	83 ec 0c             	sub    $0xc,%esp
8010560c:	53                   	push   %ebx
8010560d:	e8 ee c3 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105612:	e8 89 d7 ff ff       	call   80102da0 <end_op>
    return -1;
80105617:	83 c4 10             	add    $0x10,%esp
8010561a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010561f:	eb 9d                	jmp    801055be <sys_link+0xde>
    end_op();
80105621:	e8 7a d7 ff ff       	call   80102da0 <end_op>
    return -1;
80105626:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010562b:	eb 91                	jmp    801055be <sys_link+0xde>
8010562d:	8d 76 00             	lea    0x0(%esi),%esi

80105630 <sys_unlink>:
{
80105630:	f3 0f 1e fb          	endbr32 
80105634:	55                   	push   %ebp
80105635:	89 e5                	mov    %esp,%ebp
80105637:	57                   	push   %edi
80105638:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105639:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010563c:	53                   	push   %ebx
8010563d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105640:	50                   	push   %eax
80105641:	6a 00                	push   $0x0
80105643:	e8 08 fa ff ff       	call   80105050 <argstr>
80105648:	83 c4 10             	add    $0x10,%esp
8010564b:	85 c0                	test   %eax,%eax
8010564d:	0f 88 7d 01 00 00    	js     801057d0 <sys_unlink+0x1a0>
  begin_op();
80105653:	e8 d8 d6 ff ff       	call   80102d30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105658:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010565b:	83 ec 08             	sub    $0x8,%esp
8010565e:	53                   	push   %ebx
8010565f:	ff 75 c0             	pushl  -0x40(%ebp)
80105662:	e8 e9 c9 ff ff       	call   80102050 <nameiparent>
80105667:	83 c4 10             	add    $0x10,%esp
8010566a:	89 c6                	mov    %eax,%esi
8010566c:	85 c0                	test   %eax,%eax
8010566e:	0f 84 66 01 00 00    	je     801057da <sys_unlink+0x1aa>
  ilock(dp);
80105674:	83 ec 0c             	sub    $0xc,%esp
80105677:	50                   	push   %eax
80105678:	e8 e3 c0 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010567d:	58                   	pop    %eax
8010567e:	5a                   	pop    %edx
8010567f:	68 a8 7f 10 80       	push   $0x80107fa8
80105684:	53                   	push   %ebx
80105685:	e8 06 c6 ff ff       	call   80101c90 <namecmp>
8010568a:	83 c4 10             	add    $0x10,%esp
8010568d:	85 c0                	test   %eax,%eax
8010568f:	0f 84 03 01 00 00    	je     80105798 <sys_unlink+0x168>
80105695:	83 ec 08             	sub    $0x8,%esp
80105698:	68 a7 7f 10 80       	push   $0x80107fa7
8010569d:	53                   	push   %ebx
8010569e:	e8 ed c5 ff ff       	call   80101c90 <namecmp>
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	85 c0                	test   %eax,%eax
801056a8:	0f 84 ea 00 00 00    	je     80105798 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801056ae:	83 ec 04             	sub    $0x4,%esp
801056b1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801056b4:	50                   	push   %eax
801056b5:	53                   	push   %ebx
801056b6:	56                   	push   %esi
801056b7:	e8 f4 c5 ff ff       	call   80101cb0 <dirlookup>
801056bc:	83 c4 10             	add    $0x10,%esp
801056bf:	89 c3                	mov    %eax,%ebx
801056c1:	85 c0                	test   %eax,%eax
801056c3:	0f 84 cf 00 00 00    	je     80105798 <sys_unlink+0x168>
  ilock(ip);
801056c9:	83 ec 0c             	sub    $0xc,%esp
801056cc:	50                   	push   %eax
801056cd:	e8 8e c0 ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
801056d2:	83 c4 10             	add    $0x10,%esp
801056d5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801056da:	0f 8e 23 01 00 00    	jle    80105803 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801056e0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056e5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801056e8:	74 66                	je     80105750 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801056ea:	83 ec 04             	sub    $0x4,%esp
801056ed:	6a 10                	push   $0x10
801056ef:	6a 00                	push   $0x0
801056f1:	57                   	push   %edi
801056f2:	e8 c9 f5 ff ff       	call   80104cc0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801056f7:	6a 10                	push   $0x10
801056f9:	ff 75 c4             	pushl  -0x3c(%ebp)
801056fc:	57                   	push   %edi
801056fd:	56                   	push   %esi
801056fe:	e8 5d c4 ff ff       	call   80101b60 <writei>
80105703:	83 c4 20             	add    $0x20,%esp
80105706:	83 f8 10             	cmp    $0x10,%eax
80105709:	0f 85 e7 00 00 00    	jne    801057f6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010570f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105714:	0f 84 96 00 00 00    	je     801057b0 <sys_unlink+0x180>
  iunlockput(dp);
8010571a:	83 ec 0c             	sub    $0xc,%esp
8010571d:	56                   	push   %esi
8010571e:	e8 dd c2 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105723:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105728:	89 1c 24             	mov    %ebx,(%esp)
8010572b:	e8 70 bf ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105730:	89 1c 24             	mov    %ebx,(%esp)
80105733:	e8 c8 c2 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105738:	e8 63 d6 ff ff       	call   80102da0 <end_op>
  return 0;
8010573d:	83 c4 10             	add    $0x10,%esp
80105740:	31 c0                	xor    %eax,%eax
}
80105742:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105745:	5b                   	pop    %ebx
80105746:	5e                   	pop    %esi
80105747:	5f                   	pop    %edi
80105748:	5d                   	pop    %ebp
80105749:	c3                   	ret    
8010574a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105750:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105754:	76 94                	jbe    801056ea <sys_unlink+0xba>
80105756:	ba 20 00 00 00       	mov    $0x20,%edx
8010575b:	eb 0b                	jmp    80105768 <sys_unlink+0x138>
8010575d:	8d 76 00             	lea    0x0(%esi),%esi
80105760:	83 c2 10             	add    $0x10,%edx
80105763:	39 53 58             	cmp    %edx,0x58(%ebx)
80105766:	76 82                	jbe    801056ea <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105768:	6a 10                	push   $0x10
8010576a:	52                   	push   %edx
8010576b:	57                   	push   %edi
8010576c:	53                   	push   %ebx
8010576d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105770:	e8 eb c2 ff ff       	call   80101a60 <readi>
80105775:	83 c4 10             	add    $0x10,%esp
80105778:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010577b:	83 f8 10             	cmp    $0x10,%eax
8010577e:	75 69                	jne    801057e9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105780:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105785:	74 d9                	je     80105760 <sys_unlink+0x130>
    iunlockput(ip);
80105787:	83 ec 0c             	sub    $0xc,%esp
8010578a:	53                   	push   %ebx
8010578b:	e8 70 c2 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105790:	83 c4 10             	add    $0x10,%esp
80105793:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105797:	90                   	nop
  iunlockput(dp);
80105798:	83 ec 0c             	sub    $0xc,%esp
8010579b:	56                   	push   %esi
8010579c:	e8 5f c2 ff ff       	call   80101a00 <iunlockput>
  end_op();
801057a1:	e8 fa d5 ff ff       	call   80102da0 <end_op>
  return -1;
801057a6:	83 c4 10             	add    $0x10,%esp
801057a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ae:	eb 92                	jmp    80105742 <sys_unlink+0x112>
    iupdate(dp);
801057b0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801057b3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801057b8:	56                   	push   %esi
801057b9:	e8 e2 be ff ff       	call   801016a0 <iupdate>
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	e9 54 ff ff ff       	jmp    8010571a <sys_unlink+0xea>
801057c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d5:	e9 68 ff ff ff       	jmp    80105742 <sys_unlink+0x112>
    end_op();
801057da:	e8 c1 d5 ff ff       	call   80102da0 <end_op>
    return -1;
801057df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e4:	e9 59 ff ff ff       	jmp    80105742 <sys_unlink+0x112>
      panic("isdirempty: readi");
801057e9:	83 ec 0c             	sub    $0xc,%esp
801057ec:	68 cc 7f 10 80       	push   $0x80107fcc
801057f1:	e8 9a ab ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801057f6:	83 ec 0c             	sub    $0xc,%esp
801057f9:	68 de 7f 10 80       	push   $0x80107fde
801057fe:	e8 8d ab ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105803:	83 ec 0c             	sub    $0xc,%esp
80105806:	68 ba 7f 10 80       	push   $0x80107fba
8010580b:	e8 80 ab ff ff       	call   80100390 <panic>

80105810 <sys_open>:

int
sys_open(void)
{
80105810:	f3 0f 1e fb          	endbr32 
80105814:	55                   	push   %ebp
80105815:	89 e5                	mov    %esp,%ebp
80105817:	57                   	push   %edi
80105818:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105819:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010581c:	53                   	push   %ebx
8010581d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105820:	50                   	push   %eax
80105821:	6a 00                	push   $0x0
80105823:	e8 28 f8 ff ff       	call   80105050 <argstr>
80105828:	83 c4 10             	add    $0x10,%esp
8010582b:	85 c0                	test   %eax,%eax
8010582d:	0f 88 8a 00 00 00    	js     801058bd <sys_open+0xad>
80105833:	83 ec 08             	sub    $0x8,%esp
80105836:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105839:	50                   	push   %eax
8010583a:	6a 01                	push   $0x1
8010583c:	e8 5f f7 ff ff       	call   80104fa0 <argint>
80105841:	83 c4 10             	add    $0x10,%esp
80105844:	85 c0                	test   %eax,%eax
80105846:	78 75                	js     801058bd <sys_open+0xad>
    return -1;

  begin_op();
80105848:	e8 e3 d4 ff ff       	call   80102d30 <begin_op>

  if(omode & O_CREATE){
8010584d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105851:	75 75                	jne    801058c8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105853:	83 ec 0c             	sub    $0xc,%esp
80105856:	ff 75 e0             	pushl  -0x20(%ebp)
80105859:	e8 d2 c7 ff ff       	call   80102030 <namei>
8010585e:	83 c4 10             	add    $0x10,%esp
80105861:	89 c6                	mov    %eax,%esi
80105863:	85 c0                	test   %eax,%eax
80105865:	74 7e                	je     801058e5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105867:	83 ec 0c             	sub    $0xc,%esp
8010586a:	50                   	push   %eax
8010586b:	e8 f0 be ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105870:	83 c4 10             	add    $0x10,%esp
80105873:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105878:	0f 84 c2 00 00 00    	je     80105940 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010587e:	e8 7d b5 ff ff       	call   80100e00 <filealloc>
80105883:	89 c7                	mov    %eax,%edi
80105885:	85 c0                	test   %eax,%eax
80105887:	74 23                	je     801058ac <sys_open+0x9c>
  struct proc *curproc = myproc();
80105889:	e8 92 e2 ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010588e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105890:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105894:	85 d2                	test   %edx,%edx
80105896:	74 60                	je     801058f8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105898:	83 c3 01             	add    $0x1,%ebx
8010589b:	83 fb 10             	cmp    $0x10,%ebx
8010589e:	75 f0                	jne    80105890 <sys_open+0x80>
    if(f)
      fileclose(f);
801058a0:	83 ec 0c             	sub    $0xc,%esp
801058a3:	57                   	push   %edi
801058a4:	e8 17 b6 ff ff       	call   80100ec0 <fileclose>
801058a9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801058ac:	83 ec 0c             	sub    $0xc,%esp
801058af:	56                   	push   %esi
801058b0:	e8 4b c1 ff ff       	call   80101a00 <iunlockput>
    end_op();
801058b5:	e8 e6 d4 ff ff       	call   80102da0 <end_op>
    return -1;
801058ba:	83 c4 10             	add    $0x10,%esp
801058bd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058c2:	eb 6d                	jmp    80105931 <sys_open+0x121>
801058c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801058c8:	83 ec 0c             	sub    $0xc,%esp
801058cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801058ce:	31 c9                	xor    %ecx,%ecx
801058d0:	ba 02 00 00 00       	mov    $0x2,%edx
801058d5:	6a 00                	push   $0x0
801058d7:	e8 24 f8 ff ff       	call   80105100 <create>
    if(ip == 0){
801058dc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801058df:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801058e1:	85 c0                	test   %eax,%eax
801058e3:	75 99                	jne    8010587e <sys_open+0x6e>
      end_op();
801058e5:	e8 b6 d4 ff ff       	call   80102da0 <end_op>
      return -1;
801058ea:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058ef:	eb 40                	jmp    80105931 <sys_open+0x121>
801058f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801058f8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801058fb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801058ff:	56                   	push   %esi
80105900:	e8 3b bf ff ff       	call   80101840 <iunlock>
  end_op();
80105905:	e8 96 d4 ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
8010590a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105913:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105916:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105919:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010591b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105922:	f7 d0                	not    %eax
80105924:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105927:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010592a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010592d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105931:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105934:	89 d8                	mov    %ebx,%eax
80105936:	5b                   	pop    %ebx
80105937:	5e                   	pop    %esi
80105938:	5f                   	pop    %edi
80105939:	5d                   	pop    %ebp
8010593a:	c3                   	ret    
8010593b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010593f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105940:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105943:	85 c9                	test   %ecx,%ecx
80105945:	0f 84 33 ff ff ff    	je     8010587e <sys_open+0x6e>
8010594b:	e9 5c ff ff ff       	jmp    801058ac <sys_open+0x9c>

80105950 <sys_mkdir>:

int
sys_mkdir(void)
{
80105950:	f3 0f 1e fb          	endbr32 
80105954:	55                   	push   %ebp
80105955:	89 e5                	mov    %esp,%ebp
80105957:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010595a:	e8 d1 d3 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010595f:	83 ec 08             	sub    $0x8,%esp
80105962:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105965:	50                   	push   %eax
80105966:	6a 00                	push   $0x0
80105968:	e8 e3 f6 ff ff       	call   80105050 <argstr>
8010596d:	83 c4 10             	add    $0x10,%esp
80105970:	85 c0                	test   %eax,%eax
80105972:	78 34                	js     801059a8 <sys_mkdir+0x58>
80105974:	83 ec 0c             	sub    $0xc,%esp
80105977:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010597a:	31 c9                	xor    %ecx,%ecx
8010597c:	ba 01 00 00 00       	mov    $0x1,%edx
80105981:	6a 00                	push   $0x0
80105983:	e8 78 f7 ff ff       	call   80105100 <create>
80105988:	83 c4 10             	add    $0x10,%esp
8010598b:	85 c0                	test   %eax,%eax
8010598d:	74 19                	je     801059a8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010598f:	83 ec 0c             	sub    $0xc,%esp
80105992:	50                   	push   %eax
80105993:	e8 68 c0 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105998:	e8 03 d4 ff ff       	call   80102da0 <end_op>
  return 0;
8010599d:	83 c4 10             	add    $0x10,%esp
801059a0:	31 c0                	xor    %eax,%eax
}
801059a2:	c9                   	leave  
801059a3:	c3                   	ret    
801059a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801059a8:	e8 f3 d3 ff ff       	call   80102da0 <end_op>
    return -1;
801059ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059b2:	c9                   	leave  
801059b3:	c3                   	ret    
801059b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059bf:	90                   	nop

801059c0 <sys_mknod>:

int
sys_mknod(void)
{
801059c0:	f3 0f 1e fb          	endbr32 
801059c4:	55                   	push   %ebp
801059c5:	89 e5                	mov    %esp,%ebp
801059c7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801059ca:	e8 61 d3 ff ff       	call   80102d30 <begin_op>
  if((argstr(0, &path)) < 0 ||
801059cf:	83 ec 08             	sub    $0x8,%esp
801059d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059d5:	50                   	push   %eax
801059d6:	6a 00                	push   $0x0
801059d8:	e8 73 f6 ff ff       	call   80105050 <argstr>
801059dd:	83 c4 10             	add    $0x10,%esp
801059e0:	85 c0                	test   %eax,%eax
801059e2:	78 64                	js     80105a48 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801059e4:	83 ec 08             	sub    $0x8,%esp
801059e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059ea:	50                   	push   %eax
801059eb:	6a 01                	push   $0x1
801059ed:	e8 ae f5 ff ff       	call   80104fa0 <argint>
  if((argstr(0, &path)) < 0 ||
801059f2:	83 c4 10             	add    $0x10,%esp
801059f5:	85 c0                	test   %eax,%eax
801059f7:	78 4f                	js     80105a48 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801059f9:	83 ec 08             	sub    $0x8,%esp
801059fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ff:	50                   	push   %eax
80105a00:	6a 02                	push   $0x2
80105a02:	e8 99 f5 ff ff       	call   80104fa0 <argint>
     argint(1, &major) < 0 ||
80105a07:	83 c4 10             	add    $0x10,%esp
80105a0a:	85 c0                	test   %eax,%eax
80105a0c:	78 3a                	js     80105a48 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a0e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105a12:	83 ec 0c             	sub    $0xc,%esp
80105a15:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105a19:	ba 03 00 00 00       	mov    $0x3,%edx
80105a1e:	50                   	push   %eax
80105a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a22:	e8 d9 f6 ff ff       	call   80105100 <create>
     argint(2, &minor) < 0 ||
80105a27:	83 c4 10             	add    $0x10,%esp
80105a2a:	85 c0                	test   %eax,%eax
80105a2c:	74 1a                	je     80105a48 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a2e:	83 ec 0c             	sub    $0xc,%esp
80105a31:	50                   	push   %eax
80105a32:	e8 c9 bf ff ff       	call   80101a00 <iunlockput>
  end_op();
80105a37:	e8 64 d3 ff ff       	call   80102da0 <end_op>
  return 0;
80105a3c:	83 c4 10             	add    $0x10,%esp
80105a3f:	31 c0                	xor    %eax,%eax
}
80105a41:	c9                   	leave  
80105a42:	c3                   	ret    
80105a43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a47:	90                   	nop
    end_op();
80105a48:	e8 53 d3 ff ff       	call   80102da0 <end_op>
    return -1;
80105a4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a52:	c9                   	leave  
80105a53:	c3                   	ret    
80105a54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a5f:	90                   	nop

80105a60 <sys_chdir>:

int
sys_chdir(void)
{
80105a60:	f3 0f 1e fb          	endbr32 
80105a64:	55                   	push   %ebp
80105a65:	89 e5                	mov    %esp,%ebp
80105a67:	56                   	push   %esi
80105a68:	53                   	push   %ebx
80105a69:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105a6c:	e8 af e0 ff ff       	call   80103b20 <myproc>
80105a71:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105a73:	e8 b8 d2 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105a78:	83 ec 08             	sub    $0x8,%esp
80105a7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a7e:	50                   	push   %eax
80105a7f:	6a 00                	push   $0x0
80105a81:	e8 ca f5 ff ff       	call   80105050 <argstr>
80105a86:	83 c4 10             	add    $0x10,%esp
80105a89:	85 c0                	test   %eax,%eax
80105a8b:	78 73                	js     80105b00 <sys_chdir+0xa0>
80105a8d:	83 ec 0c             	sub    $0xc,%esp
80105a90:	ff 75 f4             	pushl  -0xc(%ebp)
80105a93:	e8 98 c5 ff ff       	call   80102030 <namei>
80105a98:	83 c4 10             	add    $0x10,%esp
80105a9b:	89 c3                	mov    %eax,%ebx
80105a9d:	85 c0                	test   %eax,%eax
80105a9f:	74 5f                	je     80105b00 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105aa1:	83 ec 0c             	sub    $0xc,%esp
80105aa4:	50                   	push   %eax
80105aa5:	e8 b6 bc ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
80105aaa:	83 c4 10             	add    $0x10,%esp
80105aad:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ab2:	75 2c                	jne    80105ae0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ab4:	83 ec 0c             	sub    $0xc,%esp
80105ab7:	53                   	push   %ebx
80105ab8:	e8 83 bd ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105abd:	58                   	pop    %eax
80105abe:	ff 76 68             	pushl  0x68(%esi)
80105ac1:	e8 ca bd ff ff       	call   80101890 <iput>
  end_op();
80105ac6:	e8 d5 d2 ff ff       	call   80102da0 <end_op>
  curproc->cwd = ip;
80105acb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105ace:	83 c4 10             	add    $0x10,%esp
80105ad1:	31 c0                	xor    %eax,%eax
}
80105ad3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ad6:	5b                   	pop    %ebx
80105ad7:	5e                   	pop    %esi
80105ad8:	5d                   	pop    %ebp
80105ad9:	c3                   	ret    
80105ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105ae0:	83 ec 0c             	sub    $0xc,%esp
80105ae3:	53                   	push   %ebx
80105ae4:	e8 17 bf ff ff       	call   80101a00 <iunlockput>
    end_op();
80105ae9:	e8 b2 d2 ff ff       	call   80102da0 <end_op>
    return -1;
80105aee:	83 c4 10             	add    $0x10,%esp
80105af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105af6:	eb db                	jmp    80105ad3 <sys_chdir+0x73>
80105af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aff:	90                   	nop
    end_op();
80105b00:	e8 9b d2 ff ff       	call   80102da0 <end_op>
    return -1;
80105b05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b0a:	eb c7                	jmp    80105ad3 <sys_chdir+0x73>
80105b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b10 <sys_exec>:

int
sys_exec(void)
{
80105b10:	f3 0f 1e fb          	endbr32 
80105b14:	55                   	push   %ebp
80105b15:	89 e5                	mov    %esp,%ebp
80105b17:	57                   	push   %edi
80105b18:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b19:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b1f:	53                   	push   %ebx
80105b20:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b26:	50                   	push   %eax
80105b27:	6a 00                	push   $0x0
80105b29:	e8 22 f5 ff ff       	call   80105050 <argstr>
80105b2e:	83 c4 10             	add    $0x10,%esp
80105b31:	85 c0                	test   %eax,%eax
80105b33:	0f 88 8b 00 00 00    	js     80105bc4 <sys_exec+0xb4>
80105b39:	83 ec 08             	sub    $0x8,%esp
80105b3c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b42:	50                   	push   %eax
80105b43:	6a 01                	push   $0x1
80105b45:	e8 56 f4 ff ff       	call   80104fa0 <argint>
80105b4a:	83 c4 10             	add    $0x10,%esp
80105b4d:	85 c0                	test   %eax,%eax
80105b4f:	78 73                	js     80105bc4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b51:	83 ec 04             	sub    $0x4,%esp
80105b54:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105b5a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105b5c:	68 80 00 00 00       	push   $0x80
80105b61:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105b67:	6a 00                	push   $0x0
80105b69:	50                   	push   %eax
80105b6a:	e8 51 f1 ff ff       	call   80104cc0 <memset>
80105b6f:	83 c4 10             	add    $0x10,%esp
80105b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b78:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105b7e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105b85:	83 ec 08             	sub    $0x8,%esp
80105b88:	57                   	push   %edi
80105b89:	01 f0                	add    %esi,%eax
80105b8b:	50                   	push   %eax
80105b8c:	e8 6f f3 ff ff       	call   80104f00 <fetchint>
80105b91:	83 c4 10             	add    $0x10,%esp
80105b94:	85 c0                	test   %eax,%eax
80105b96:	78 2c                	js     80105bc4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105b98:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105b9e:	85 c0                	test   %eax,%eax
80105ba0:	74 36                	je     80105bd8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105ba2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105ba8:	83 ec 08             	sub    $0x8,%esp
80105bab:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105bae:	52                   	push   %edx
80105baf:	50                   	push   %eax
80105bb0:	e8 8b f3 ff ff       	call   80104f40 <fetchstr>
80105bb5:	83 c4 10             	add    $0x10,%esp
80105bb8:	85 c0                	test   %eax,%eax
80105bba:	78 08                	js     80105bc4 <sys_exec+0xb4>
  for(i=0;; i++){
80105bbc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105bbf:	83 fb 20             	cmp    $0x20,%ebx
80105bc2:	75 b4                	jne    80105b78 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105bc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105bc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bcc:	5b                   	pop    %ebx
80105bcd:	5e                   	pop    %esi
80105bce:	5f                   	pop    %edi
80105bcf:	5d                   	pop    %ebp
80105bd0:	c3                   	ret    
80105bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105bd8:	83 ec 08             	sub    $0x8,%esp
80105bdb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105be1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105be8:	00 00 00 00 
  return exec(path, argv);
80105bec:	50                   	push   %eax
80105bed:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105bf3:	e8 88 ae ff ff       	call   80100a80 <exec>
80105bf8:	83 c4 10             	add    $0x10,%esp
}
80105bfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bfe:	5b                   	pop    %ebx
80105bff:	5e                   	pop    %esi
80105c00:	5f                   	pop    %edi
80105c01:	5d                   	pop    %ebp
80105c02:	c3                   	ret    
80105c03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c10 <sys_pipe>:

int
sys_pipe(void)
{
80105c10:	f3 0f 1e fb          	endbr32 
80105c14:	55                   	push   %ebp
80105c15:	89 e5                	mov    %esp,%ebp
80105c17:	57                   	push   %edi
80105c18:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c19:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c1c:	53                   	push   %ebx
80105c1d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c20:	6a 08                	push   $0x8
80105c22:	50                   	push   %eax
80105c23:	6a 00                	push   $0x0
80105c25:	e8 c6 f3 ff ff       	call   80104ff0 <argptr>
80105c2a:	83 c4 10             	add    $0x10,%esp
80105c2d:	85 c0                	test   %eax,%eax
80105c2f:	78 4e                	js     80105c7f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c31:	83 ec 08             	sub    $0x8,%esp
80105c34:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c37:	50                   	push   %eax
80105c38:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c3b:	50                   	push   %eax
80105c3c:	e8 bf d7 ff ff       	call   80103400 <pipealloc>
80105c41:	83 c4 10             	add    $0x10,%esp
80105c44:	85 c0                	test   %eax,%eax
80105c46:	78 37                	js     80105c7f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c48:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105c4b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c4d:	e8 ce de ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105c58:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105c5c:	85 f6                	test   %esi,%esi
80105c5e:	74 30                	je     80105c90 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105c60:	83 c3 01             	add    $0x1,%ebx
80105c63:	83 fb 10             	cmp    $0x10,%ebx
80105c66:	75 f0                	jne    80105c58 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105c68:	83 ec 0c             	sub    $0xc,%esp
80105c6b:	ff 75 e0             	pushl  -0x20(%ebp)
80105c6e:	e8 4d b2 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105c73:	58                   	pop    %eax
80105c74:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c77:	e8 44 b2 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105c7c:	83 c4 10             	add    $0x10,%esp
80105c7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c84:	eb 5b                	jmp    80105ce1 <sys_pipe+0xd1>
80105c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c8d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105c90:	8d 73 08             	lea    0x8(%ebx),%esi
80105c93:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c97:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105c9a:	e8 81 de ff ff       	call   80103b20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c9f:	31 d2                	xor    %edx,%edx
80105ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105ca8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105cac:	85 c9                	test   %ecx,%ecx
80105cae:	74 20                	je     80105cd0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105cb0:	83 c2 01             	add    $0x1,%edx
80105cb3:	83 fa 10             	cmp    $0x10,%edx
80105cb6:	75 f0                	jne    80105ca8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105cb8:	e8 63 de ff ff       	call   80103b20 <myproc>
80105cbd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105cc4:	00 
80105cc5:	eb a1                	jmp    80105c68 <sys_pipe+0x58>
80105cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105cd0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105cd4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cd7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105cd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cdc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105cdf:	31 c0                	xor    %eax,%eax
}
80105ce1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ce4:	5b                   	pop    %ebx
80105ce5:	5e                   	pop    %esi
80105ce6:	5f                   	pop    %edi
80105ce7:	5d                   	pop    %ebp
80105ce8:	c3                   	ret    
80105ce9:	66 90                	xchg   %ax,%ax
80105ceb:	66 90                	xchg   %ax,%ax
80105ced:	66 90                	xchg   %ax,%ax
80105cef:	90                   	nop

80105cf0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105cf0:	f3 0f 1e fb          	endbr32 
  return fork();
80105cf4:	e9 67 e0 ff ff       	jmp    80103d60 <fork>
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d00 <sys_exit>:
}

int
sys_exit(void)
{
80105d00:	f3 0f 1e fb          	endbr32 
80105d04:	55                   	push   %ebp
80105d05:	89 e5                	mov    %esp,%ebp
80105d07:	83 ec 20             	sub    $0x20,%esp
  int exit_status;
  argint(0, &exit_status);
80105d0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d0d:	50                   	push   %eax
80105d0e:	6a 00                	push   $0x0
80105d10:	e8 8b f2 ff ff       	call   80104fa0 <argint>
  exit(exit_status);
80105d15:	58                   	pop    %eax
80105d16:	ff 75 f4             	pushl  -0xc(%ebp)
80105d19:	e8 52 e5 ff ff       	call   80104270 <exit>
  return 0;  // not reached
}
80105d1e:	31 c0                	xor    %eax,%eax
80105d20:	c9                   	leave  
80105d21:	c3                   	ret    
80105d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d30 <sys_wait>:

int
sys_wait(void)
{
80105d30:	f3 0f 1e fb          	endbr32 
80105d34:	55                   	push   %ebp
80105d35:	89 e5                	mov    %esp,%ebp
80105d37:	83 ec 1c             	sub    $0x1c,%esp
  char *status_ptr;
  argptr(0, &status_ptr, 4);
80105d3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d3d:	6a 04                	push   $0x4
80105d3f:	50                   	push   %eax
80105d40:	6a 00                	push   $0x0
80105d42:	e8 a9 f2 ff ff       	call   80104ff0 <argptr>
  return wait((int*)status_ptr);
80105d47:	58                   	pop    %eax
80105d48:	ff 75 f4             	pushl  -0xc(%ebp)
80105d4b:	e8 c0 e7 ff ff       	call   80104510 <wait>
}
80105d50:	c9                   	leave  
80105d51:	c3                   	ret    
80105d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d60 <sys_kill>:

int
sys_kill(void)
{
80105d60:	f3 0f 1e fb          	endbr32 
80105d64:	55                   	push   %ebp
80105d65:	89 e5                	mov    %esp,%ebp
80105d67:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d6d:	50                   	push   %eax
80105d6e:	6a 00                	push   $0x0
80105d70:	e8 2b f2 ff ff       	call   80104fa0 <argint>
80105d75:	83 c4 10             	add    $0x10,%esp
80105d78:	85 c0                	test   %eax,%eax
80105d7a:	78 14                	js     80105d90 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d7c:	83 ec 0c             	sub    $0xc,%esp
80105d7f:	ff 75 f4             	pushl  -0xc(%ebp)
80105d82:	e8 d9 e8 ff ff       	call   80104660 <kill>
80105d87:	83 c4 10             	add    $0x10,%esp
}
80105d8a:	c9                   	leave  
80105d8b:	c3                   	ret    
80105d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d90:	c9                   	leave  
    return -1;
80105d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d96:	c3                   	ret    
80105d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9e:	66 90                	xchg   %ax,%ax

80105da0 <sys_getpid>:

int
sys_getpid(void)
{
80105da0:	f3 0f 1e fb          	endbr32 
80105da4:	55                   	push   %ebp
80105da5:	89 e5                	mov    %esp,%ebp
80105da7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105daa:	e8 71 dd ff ff       	call   80103b20 <myproc>
80105daf:	8b 40 10             	mov    0x10(%eax),%eax
}
80105db2:	c9                   	leave  
80105db3:	c3                   	ret    
80105db4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dbf:	90                   	nop

80105dc0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105dc0:	f3 0f 1e fb          	endbr32 
80105dc4:	55                   	push   %ebp
80105dc5:	89 e5                	mov    %esp,%ebp
80105dc7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105dc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105dcb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dce:	50                   	push   %eax
80105dcf:	6a 00                	push   $0x0
80105dd1:	e8 ca f1 ff ff       	call   80104fa0 <argint>
80105dd6:	83 c4 10             	add    $0x10,%esp
80105dd9:	85 c0                	test   %eax,%eax
80105ddb:	78 23                	js     80105e00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ddd:	e8 3e dd ff ff       	call   80103b20 <myproc>
  if(growproc(n) < 0)
80105de2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105de5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105de7:	ff 75 f4             	pushl  -0xc(%ebp)
80105dea:	e8 f1 de ff ff       	call   80103ce0 <growproc>
80105def:	83 c4 10             	add    $0x10,%esp
80105df2:	85 c0                	test   %eax,%eax
80105df4:	78 0a                	js     80105e00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105df6:	89 d8                	mov    %ebx,%eax
80105df8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dfb:	c9                   	leave  
80105dfc:	c3                   	ret    
80105dfd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e05:	eb ef                	jmp    80105df6 <sys_sbrk+0x36>
80105e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e0e:	66 90                	xchg   %ax,%ax

80105e10 <sys_sleep>:

int
sys_sleep(void)
{
80105e10:	f3 0f 1e fb          	endbr32 
80105e14:	55                   	push   %ebp
80105e15:	89 e5                	mov    %esp,%ebp
80105e17:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e18:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e1b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e1e:	50                   	push   %eax
80105e1f:	6a 00                	push   $0x0
80105e21:	e8 7a f1 ff ff       	call   80104fa0 <argint>
80105e26:	83 c4 10             	add    $0x10,%esp
80105e29:	85 c0                	test   %eax,%eax
80105e2b:	0f 88 86 00 00 00    	js     80105eb7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e31:	83 ec 0c             	sub    $0xc,%esp
80105e34:	68 60 64 11 80       	push   $0x80116460
80105e39:	e8 72 ed ff ff       	call   80104bb0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105e41:	8b 1d a0 6c 11 80    	mov    0x80116ca0,%ebx
  while(ticks - ticks0 < n){
80105e47:	83 c4 10             	add    $0x10,%esp
80105e4a:	85 d2                	test   %edx,%edx
80105e4c:	75 23                	jne    80105e71 <sys_sleep+0x61>
80105e4e:	eb 50                	jmp    80105ea0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e50:	83 ec 08             	sub    $0x8,%esp
80105e53:	68 60 64 11 80       	push   $0x80116460
80105e58:	68 a0 6c 11 80       	push   $0x80116ca0
80105e5d:	e8 ee e5 ff ff       	call   80104450 <sleep>
  while(ticks - ticks0 < n){
80105e62:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
80105e67:	83 c4 10             	add    $0x10,%esp
80105e6a:	29 d8                	sub    %ebx,%eax
80105e6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e6f:	73 2f                	jae    80105ea0 <sys_sleep+0x90>
    if(myproc()->killed){
80105e71:	e8 aa dc ff ff       	call   80103b20 <myproc>
80105e76:	8b 40 24             	mov    0x24(%eax),%eax
80105e79:	85 c0                	test   %eax,%eax
80105e7b:	74 d3                	je     80105e50 <sys_sleep+0x40>
      release(&tickslock);
80105e7d:	83 ec 0c             	sub    $0xc,%esp
80105e80:	68 60 64 11 80       	push   $0x80116460
80105e85:	e8 e6 ed ff ff       	call   80104c70 <release>
  }
  release(&tickslock);
  return 0;
}
80105e8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105e8d:	83 c4 10             	add    $0x10,%esp
80105e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e95:	c9                   	leave  
80105e96:	c3                   	ret    
80105e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	68 60 64 11 80       	push   $0x80116460
80105ea8:	e8 c3 ed ff ff       	call   80104c70 <release>
  return 0;
80105ead:	83 c4 10             	add    $0x10,%esp
80105eb0:	31 c0                	xor    %eax,%eax
}
80105eb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105eb5:	c9                   	leave  
80105eb6:	c3                   	ret    
    return -1;
80105eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebc:	eb f4                	jmp    80105eb2 <sys_sleep+0xa2>
80105ebe:	66 90                	xchg   %ax,%ax

80105ec0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ec0:	f3 0f 1e fb          	endbr32 
80105ec4:	55                   	push   %ebp
80105ec5:	89 e5                	mov    %esp,%ebp
80105ec7:	53                   	push   %ebx
80105ec8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ecb:	68 60 64 11 80       	push   $0x80116460
80105ed0:	e8 db ec ff ff       	call   80104bb0 <acquire>
  xticks = ticks;
80105ed5:	8b 1d a0 6c 11 80    	mov    0x80116ca0,%ebx
  release(&tickslock);
80105edb:	c7 04 24 60 64 11 80 	movl   $0x80116460,(%esp)
80105ee2:	e8 89 ed ff ff       	call   80104c70 <release>
  return xticks;
}
80105ee7:	89 d8                	mov    %ebx,%eax
80105ee9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105eec:	c9                   	leave  
80105eed:	c3                   	ret    
80105eee:	66 90                	xchg   %ax,%ax

80105ef0 <sys_memsize>:

int sys_memsize(void){
80105ef0:	f3 0f 1e fb          	endbr32 
80105ef4:	55                   	push   %ebp
80105ef5:	89 e5                	mov    %esp,%ebp
80105ef7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->sz;
80105efa:	e8 21 dc ff ff       	call   80103b20 <myproc>
80105eff:	8b 00                	mov    (%eax),%eax
}
80105f01:	c9                   	leave  
80105f02:	c3                   	ret    
80105f03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f10 <sys_set_ps_priority>:

int sys_set_ps_priority(void)
{
80105f10:	f3 0f 1e fb          	endbr32 
80105f14:	55                   	push   %ebp
80105f15:	89 e5                	mov    %esp,%ebp
80105f17:	83 ec 20             	sub    $0x20,%esp
  int priority;
  argint(0, &priority);
80105f1a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f1d:	50                   	push   %eax
80105f1e:	6a 00                	push   $0x0
80105f20:	e8 7b f0 ff ff       	call   80104fa0 <argint>
  return set_ps_priority(priority);
80105f25:	58                   	pop    %eax
80105f26:	ff 75 f4             	pushl  -0xc(%ebp)
80105f29:	e8 a2 e8 ff ff       	call   801047d0 <set_ps_priority>
}
80105f2e:	c9                   	leave  
80105f2f:	c3                   	ret    

80105f30 <sys_policy>:

int sys_policy(void)
{
80105f30:	f3 0f 1e fb          	endbr32 
80105f34:	55                   	push   %ebp
80105f35:	89 e5                	mov    %esp,%ebp
80105f37:	83 ec 20             	sub    $0x20,%esp
  int policy_type;
  argint(0, &policy_type);
80105f3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f3d:	50                   	push   %eax
80105f3e:	6a 00                	push   $0x0
80105f40:	e8 5b f0 ff ff       	call   80104fa0 <argint>
  return policy(policy_type);
80105f45:	58                   	pop    %eax
80105f46:	ff 75 f4             	pushl  -0xc(%ebp)
80105f49:	e8 c2 e8 ff ff       	call   80104810 <policy>
}
80105f4e:	c9                   	leave  
80105f4f:	c3                   	ret    

80105f50 <sys_set_cfs_priority>:

int sys_set_cfs_priority(void){
80105f50:	f3 0f 1e fb          	endbr32 
80105f54:	55                   	push   %ebp
80105f55:	89 e5                	mov    %esp,%ebp
80105f57:	83 ec 20             	sub    $0x20,%esp
  int priority;
  argint(0, &priority);
80105f5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f5d:	50                   	push   %eax
80105f5e:	6a 00                	push   $0x0
80105f60:	e8 3b f0 ff ff       	call   80104fa0 <argint>
  return set_cfs_priority(priority);
80105f65:	58                   	pop    %eax
80105f66:	ff 75 f4             	pushl  -0xc(%ebp)
80105f69:	e8 d2 e8 ff ff       	call   80104840 <set_cfs_priority>
}
80105f6e:	c9                   	leave  
80105f6f:	c3                   	ret    

80105f70 <sys_proc_info>:

int sys_proc_info(void){
80105f70:	f3 0f 1e fb          	endbr32 
80105f74:	55                   	push   %ebp
80105f75:	89 e5                	mov    %esp,%ebp
80105f77:	83 ec 1c             	sub    $0x1c,%esp
  char* performance;
  argptr(0, &performance, sizeof(struct perf));
80105f7a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f7d:	6a 10                	push   $0x10
80105f7f:	50                   	push   %eax
80105f80:	6a 00                	push   $0x0
80105f82:	e8 69 f0 ff ff       	call   80104ff0 <argptr>
  return proc_info((struct perf*) performance);
80105f87:	58                   	pop    %eax
80105f88:	ff 75 f4             	pushl  -0xc(%ebp)
80105f8b:	e8 10 e9 ff ff       	call   801048a0 <proc_info>
}
80105f90:	c9                   	leave  
80105f91:	c3                   	ret    

80105f92 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f92:	1e                   	push   %ds
  pushl %es
80105f93:	06                   	push   %es
  pushl %fs
80105f94:	0f a0                	push   %fs
  pushl %gs
80105f96:	0f a8                	push   %gs
  pushal
80105f98:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105f99:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105f9d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105f9f:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105fa1:	54                   	push   %esp
  call trap
80105fa2:	e8 c9 00 00 00       	call   80106070 <trap>
  addl $4, %esp
80105fa7:	83 c4 04             	add    $0x4,%esp

80105faa <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105faa:	61                   	popa   
  popl %gs
80105fab:	0f a9                	pop    %gs
  popl %fs
80105fad:	0f a1                	pop    %fs
  popl %es
80105faf:	07                   	pop    %es
  popl %ds
80105fb0:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105fb1:	83 c4 08             	add    $0x8,%esp
  iret
80105fb4:	cf                   	iret   
80105fb5:	66 90                	xchg   %ax,%ax
80105fb7:	66 90                	xchg   %ax,%ax
80105fb9:	66 90                	xchg   %ax,%ax
80105fbb:	66 90                	xchg   %ax,%ax
80105fbd:	66 90                	xchg   %ax,%ax
80105fbf:	90                   	nop

80105fc0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105fc0:	f3 0f 1e fb          	endbr32 
80105fc4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105fc5:	31 c0                	xor    %eax,%eax
{
80105fc7:	89 e5                	mov    %esp,%ebp
80105fc9:	83 ec 08             	sub    $0x8,%esp
80105fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105fd0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105fd7:	c7 04 c5 a2 64 11 80 	movl   $0x8e000008,-0x7fee9b5e(,%eax,8)
80105fde:	08 00 00 8e 
80105fe2:	66 89 14 c5 a0 64 11 	mov    %dx,-0x7fee9b60(,%eax,8)
80105fe9:	80 
80105fea:	c1 ea 10             	shr    $0x10,%edx
80105fed:	66 89 14 c5 a6 64 11 	mov    %dx,-0x7fee9b5a(,%eax,8)
80105ff4:	80 
  for(i = 0; i < 256; i++)
80105ff5:	83 c0 01             	add    $0x1,%eax
80105ff8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105ffd:	75 d1                	jne    80105fd0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105fff:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106002:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106007:	c7 05 a2 66 11 80 08 	movl   $0xef000008,0x801166a2
8010600e:	00 00 ef 
  initlock(&tickslock, "time");
80106011:	68 ed 7f 10 80       	push   $0x80107fed
80106016:	68 60 64 11 80       	push   $0x80116460
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010601b:	66 a3 a0 66 11 80    	mov    %ax,0x801166a0
80106021:	c1 e8 10             	shr    $0x10,%eax
80106024:	66 a3 a6 66 11 80    	mov    %ax,0x801166a6
  initlock(&tickslock, "time");
8010602a:	e8 01 ea ff ff       	call   80104a30 <initlock>
}
8010602f:	83 c4 10             	add    $0x10,%esp
80106032:	c9                   	leave  
80106033:	c3                   	ret    
80106034:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010603b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010603f:	90                   	nop

80106040 <idtinit>:

void
idtinit(void)
{
80106040:	f3 0f 1e fb          	endbr32 
80106044:	55                   	push   %ebp
  pd[0] = size-1;
80106045:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010604a:	89 e5                	mov    %esp,%ebp
8010604c:	83 ec 10             	sub    $0x10,%esp
8010604f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106053:	b8 a0 64 11 80       	mov    $0x801164a0,%eax
80106058:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010605c:	c1 e8 10             	shr    $0x10,%eax
8010605f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106063:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106066:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106069:	c9                   	leave  
8010606a:	c3                   	ret    
8010606b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010606f:	90                   	nop

80106070 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106070:	f3 0f 1e fb          	endbr32 
80106074:	55                   	push   %ebp
80106075:	89 e5                	mov    %esp,%ebp
80106077:	57                   	push   %edi
80106078:	56                   	push   %esi
80106079:	53                   	push   %ebx
8010607a:	83 ec 1c             	sub    $0x1c,%esp
8010607d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106080:	8b 43 30             	mov    0x30(%ebx),%eax
80106083:	83 f8 40             	cmp    $0x40,%eax
80106086:	0f 84 c4 01 00 00    	je     80106250 <trap+0x1e0>
    if(myproc()->killed)
      exit(myproc()->killed); // TODO: verify this
    return;
  }

  switch(tf->trapno){
8010608c:	83 e8 20             	sub    $0x20,%eax
8010608f:	83 f8 1f             	cmp    $0x1f,%eax
80106092:	77 08                	ja     8010609c <trap+0x2c>
80106094:	3e ff 24 85 94 80 10 	notrack jmp *-0x7fef7f6c(,%eax,4)
8010609b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010609c:	e8 7f da ff ff       	call   80103b20 <myproc>
801060a1:	8b 7b 38             	mov    0x38(%ebx),%edi
801060a4:	85 c0                	test   %eax,%eax
801060a6:	0f 84 19 02 00 00    	je     801062c5 <trap+0x255>
801060ac:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801060b0:	0f 84 0f 02 00 00    	je     801062c5 <trap+0x255>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801060b6:	0f 20 d1             	mov    %cr2,%ecx
801060b9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060bc:	e8 3f da ff ff       	call   80103b00 <cpuid>
801060c1:	8b 73 30             	mov    0x30(%ebx),%esi
801060c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
801060c7:	8b 43 34             	mov    0x34(%ebx),%eax
801060ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801060cd:	e8 4e da ff ff       	call   80103b20 <myproc>
801060d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801060d5:	e8 46 da ff ff       	call   80103b20 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060da:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801060dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801060e0:	51                   	push   %ecx
801060e1:	57                   	push   %edi
801060e2:	52                   	push   %edx
801060e3:	ff 75 e4             	pushl  -0x1c(%ebp)
801060e6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801060e7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801060ea:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060ed:	56                   	push   %esi
801060ee:	ff 70 10             	pushl  0x10(%eax)
801060f1:	68 50 80 10 80       	push   $0x80108050
801060f6:	e8 b5 a5 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801060fb:	83 c4 20             	add    $0x20,%esp
801060fe:	e8 1d da ff ff       	call   80103b20 <myproc>
80106103:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010610a:	e8 11 da ff ff       	call   80103b20 <myproc>
8010610f:	85 c0                	test   %eax,%eax
80106111:	74 1d                	je     80106130 <trap+0xc0>
80106113:	e8 08 da ff ff       	call   80103b20 <myproc>
80106118:	8b 50 24             	mov    0x24(%eax),%edx
8010611b:	85 d2                	test   %edx,%edx
8010611d:	74 11                	je     80106130 <trap+0xc0>
8010611f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106123:	83 e0 03             	and    $0x3,%eax
80106126:	66 83 f8 03          	cmp    $0x3,%ax
8010612a:	0f 84 60 01 00 00    	je     80106290 <trap+0x220>
    exit(myproc()->killed);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106130:	e8 eb d9 ff ff       	call   80103b20 <myproc>
80106135:	85 c0                	test   %eax,%eax
80106137:	74 0f                	je     80106148 <trap+0xd8>
80106139:	e8 e2 d9 ff ff       	call   80103b20 <myproc>
8010613e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106142:	0f 84 f0 00 00 00    	je     80106238 <trap+0x1c8>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106148:	e8 d3 d9 ff ff       	call   80103b20 <myproc>
8010614d:	85 c0                	test   %eax,%eax
8010614f:	74 1d                	je     8010616e <trap+0xfe>
80106151:	e8 ca d9 ff ff       	call   80103b20 <myproc>
80106156:	8b 40 24             	mov    0x24(%eax),%eax
80106159:	85 c0                	test   %eax,%eax
8010615b:	74 11                	je     8010616e <trap+0xfe>
8010615d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106161:	83 e0 03             	and    $0x3,%eax
80106164:	66 83 f8 03          	cmp    $0x3,%ax
80106168:	0f 84 0b 01 00 00    	je     80106279 <trap+0x209>
    exit(myproc()->killed);
}
8010616e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106171:	5b                   	pop    %ebx
80106172:	5e                   	pop    %esi
80106173:	5f                   	pop    %edi
80106174:	5d                   	pop    %ebp
80106175:	c3                   	ret    
    ideintr();
80106176:	e8 65 c0 ff ff       	call   801021e0 <ideintr>
    lapiceoi();
8010617b:	e8 40 c7 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106180:	e8 9b d9 ff ff       	call   80103b20 <myproc>
80106185:	85 c0                	test   %eax,%eax
80106187:	75 8a                	jne    80106113 <trap+0xa3>
80106189:	eb a5                	jmp    80106130 <trap+0xc0>
    if(cpuid() == 0){
8010618b:	e8 70 d9 ff ff       	call   80103b00 <cpuid>
80106190:	85 c0                	test   %eax,%eax
80106192:	75 e7                	jne    8010617b <trap+0x10b>
      acquire(&tickslock);
80106194:	83 ec 0c             	sub    $0xc,%esp
80106197:	68 60 64 11 80       	push   $0x80116460
8010619c:	e8 0f ea ff ff       	call   80104bb0 <acquire>
      ticks++;
801061a1:	83 05 a0 6c 11 80 01 	addl   $0x1,0x80116ca0
      update_ptable_stats();
801061a8:	e8 c3 e1 ff ff       	call   80104370 <update_ptable_stats>
      wakeup(&ticks);
801061ad:	c7 04 24 a0 6c 11 80 	movl   $0x80116ca0,(%esp)
801061b4:	e8 67 e4 ff ff       	call   80104620 <wakeup>
      release(&tickslock);
801061b9:	c7 04 24 60 64 11 80 	movl   $0x80116460,(%esp)
801061c0:	e8 ab ea ff ff       	call   80104c70 <release>
801061c5:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801061c8:	eb b1                	jmp    8010617b <trap+0x10b>
    kbdintr();
801061ca:	e8 b1 c5 ff ff       	call   80102780 <kbdintr>
    lapiceoi();
801061cf:	e8 ec c6 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061d4:	e8 47 d9 ff ff       	call   80103b20 <myproc>
801061d9:	85 c0                	test   %eax,%eax
801061db:	0f 85 32 ff ff ff    	jne    80106113 <trap+0xa3>
801061e1:	e9 4a ff ff ff       	jmp    80106130 <trap+0xc0>
    uartintr();
801061e6:	e8 75 02 00 00       	call   80106460 <uartintr>
    lapiceoi();
801061eb:	e8 d0 c6 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061f0:	e8 2b d9 ff ff       	call   80103b20 <myproc>
801061f5:	85 c0                	test   %eax,%eax
801061f7:	0f 85 16 ff ff ff    	jne    80106113 <trap+0xa3>
801061fd:	e9 2e ff ff ff       	jmp    80106130 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106202:	8b 7b 38             	mov    0x38(%ebx),%edi
80106205:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106209:	e8 f2 d8 ff ff       	call   80103b00 <cpuid>
8010620e:	57                   	push   %edi
8010620f:	56                   	push   %esi
80106210:	50                   	push   %eax
80106211:	68 f8 7f 10 80       	push   $0x80107ff8
80106216:	e8 95 a4 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
8010621b:	e8 a0 c6 ff ff       	call   801028c0 <lapiceoi>
    break;
80106220:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106223:	e8 f8 d8 ff ff       	call   80103b20 <myproc>
80106228:	85 c0                	test   %eax,%eax
8010622a:	0f 85 e3 fe ff ff    	jne    80106113 <trap+0xa3>
80106230:	e9 fb fe ff ff       	jmp    80106130 <trap+0xc0>
80106235:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106238:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010623c:	0f 85 06 ff ff ff    	jne    80106148 <trap+0xd8>
    yield();
80106242:	e8 b9 e1 ff ff       	call   80104400 <yield>
80106247:	e9 fc fe ff ff       	jmp    80106148 <trap+0xd8>
8010624c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106250:	e8 cb d8 ff ff       	call   80103b20 <myproc>
80106255:	8b 70 24             	mov    0x24(%eax),%esi
80106258:	85 f6                	test   %esi,%esi
8010625a:	75 54                	jne    801062b0 <trap+0x240>
    myproc()->tf = tf;
8010625c:	e8 bf d8 ff ff       	call   80103b20 <myproc>
80106261:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106264:	e8 27 ee ff ff       	call   80105090 <syscall>
    if(myproc()->killed)
80106269:	e8 b2 d8 ff ff       	call   80103b20 <myproc>
8010626e:	8b 48 24             	mov    0x24(%eax),%ecx
80106271:	85 c9                	test   %ecx,%ecx
80106273:	0f 84 f5 fe ff ff    	je     8010616e <trap+0xfe>
    exit(myproc()->killed);
80106279:	e8 a2 d8 ff ff       	call   80103b20 <myproc>
8010627e:	8b 40 24             	mov    0x24(%eax),%eax
80106281:	89 45 08             	mov    %eax,0x8(%ebp)
}
80106284:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106287:	5b                   	pop    %ebx
80106288:	5e                   	pop    %esi
80106289:	5f                   	pop    %edi
8010628a:	5d                   	pop    %ebp
    exit(myproc()->killed);
8010628b:	e9 e0 df ff ff       	jmp    80104270 <exit>
    exit(myproc()->killed);
80106290:	e8 8b d8 ff ff       	call   80103b20 <myproc>
80106295:	83 ec 0c             	sub    $0xc,%esp
80106298:	ff 70 24             	pushl  0x24(%eax)
8010629b:	e8 d0 df ff ff       	call   80104270 <exit>
801062a0:	83 c4 10             	add    $0x10,%esp
801062a3:	e9 88 fe ff ff       	jmp    80106130 <trap+0xc0>
801062a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062af:	90                   	nop
      exit(myproc()->killed); // TODO: verify this
801062b0:	e8 6b d8 ff ff       	call   80103b20 <myproc>
801062b5:	83 ec 0c             	sub    $0xc,%esp
801062b8:	ff 70 24             	pushl  0x24(%eax)
801062bb:	e8 b0 df ff ff       	call   80104270 <exit>
801062c0:	83 c4 10             	add    $0x10,%esp
801062c3:	eb 97                	jmp    8010625c <trap+0x1ec>
801062c5:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801062c8:	e8 33 d8 ff ff       	call   80103b00 <cpuid>
801062cd:	83 ec 0c             	sub    $0xc,%esp
801062d0:	56                   	push   %esi
801062d1:	57                   	push   %edi
801062d2:	50                   	push   %eax
801062d3:	ff 73 30             	pushl  0x30(%ebx)
801062d6:	68 1c 80 10 80       	push   $0x8010801c
801062db:	e8 d0 a3 ff ff       	call   801006b0 <cprintf>
      panic("trap");
801062e0:	83 c4 14             	add    $0x14,%esp
801062e3:	68 f2 7f 10 80       	push   $0x80107ff2
801062e8:	e8 a3 a0 ff ff       	call   80100390 <panic>
801062ed:	66 90                	xchg   %ax,%ax
801062ef:	90                   	nop

801062f0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801062f0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801062f4:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
801062f9:	85 c0                	test   %eax,%eax
801062fb:	74 1b                	je     80106318 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062fd:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106302:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106303:	a8 01                	test   $0x1,%al
80106305:	74 11                	je     80106318 <uartgetc+0x28>
80106307:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010630c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010630d:	0f b6 c0             	movzbl %al,%eax
80106310:	c3                   	ret    
80106311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106318:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010631d:	c3                   	ret    
8010631e:	66 90                	xchg   %ax,%ax

80106320 <uartputc.part.0>:
uartputc(int c)
80106320:	55                   	push   %ebp
80106321:	89 e5                	mov    %esp,%ebp
80106323:	57                   	push   %edi
80106324:	89 c7                	mov    %eax,%edi
80106326:	56                   	push   %esi
80106327:	be fd 03 00 00       	mov    $0x3fd,%esi
8010632c:	53                   	push   %ebx
8010632d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106332:	83 ec 0c             	sub    $0xc,%esp
80106335:	eb 1b                	jmp    80106352 <uartputc.part.0+0x32>
80106337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010633e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106340:	83 ec 0c             	sub    $0xc,%esp
80106343:	6a 0a                	push   $0xa
80106345:	e8 96 c5 ff ff       	call   801028e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010634a:	83 c4 10             	add    $0x10,%esp
8010634d:	83 eb 01             	sub    $0x1,%ebx
80106350:	74 07                	je     80106359 <uartputc.part.0+0x39>
80106352:	89 f2                	mov    %esi,%edx
80106354:	ec                   	in     (%dx),%al
80106355:	a8 20                	test   $0x20,%al
80106357:	74 e7                	je     80106340 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106359:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010635e:	89 f8                	mov    %edi,%eax
80106360:	ee                   	out    %al,(%dx)
}
80106361:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106364:	5b                   	pop    %ebx
80106365:	5e                   	pop    %esi
80106366:	5f                   	pop    %edi
80106367:	5d                   	pop    %ebp
80106368:	c3                   	ret    
80106369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106370 <uartinit>:
{
80106370:	f3 0f 1e fb          	endbr32 
80106374:	55                   	push   %ebp
80106375:	31 c9                	xor    %ecx,%ecx
80106377:	89 c8                	mov    %ecx,%eax
80106379:	89 e5                	mov    %esp,%ebp
8010637b:	57                   	push   %edi
8010637c:	56                   	push   %esi
8010637d:	53                   	push   %ebx
8010637e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106383:	89 da                	mov    %ebx,%edx
80106385:	83 ec 0c             	sub    $0xc,%esp
80106388:	ee                   	out    %al,(%dx)
80106389:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010638e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106393:	89 fa                	mov    %edi,%edx
80106395:	ee                   	out    %al,(%dx)
80106396:	b8 0c 00 00 00       	mov    $0xc,%eax
8010639b:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063a0:	ee                   	out    %al,(%dx)
801063a1:	be f9 03 00 00       	mov    $0x3f9,%esi
801063a6:	89 c8                	mov    %ecx,%eax
801063a8:	89 f2                	mov    %esi,%edx
801063aa:	ee                   	out    %al,(%dx)
801063ab:	b8 03 00 00 00       	mov    $0x3,%eax
801063b0:	89 fa                	mov    %edi,%edx
801063b2:	ee                   	out    %al,(%dx)
801063b3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801063b8:	89 c8                	mov    %ecx,%eax
801063ba:	ee                   	out    %al,(%dx)
801063bb:	b8 01 00 00 00       	mov    $0x1,%eax
801063c0:	89 f2                	mov    %esi,%edx
801063c2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063c3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063c8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801063c9:	3c ff                	cmp    $0xff,%al
801063cb:	74 52                	je     8010641f <uartinit+0xaf>
  uart = 1;
801063cd:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801063d4:	00 00 00 
801063d7:	89 da                	mov    %ebx,%edx
801063d9:	ec                   	in     (%dx),%al
801063da:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063df:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801063e0:	83 ec 08             	sub    $0x8,%esp
801063e3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
801063e8:	bb 14 81 10 80       	mov    $0x80108114,%ebx
  ioapicenable(IRQ_COM1, 0);
801063ed:	6a 00                	push   $0x0
801063ef:	6a 04                	push   $0x4
801063f1:	e8 3a c0 ff ff       	call   80102430 <ioapicenable>
801063f6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801063f9:	b8 78 00 00 00       	mov    $0x78,%eax
801063fe:	eb 04                	jmp    80106404 <uartinit+0x94>
80106400:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106404:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010640a:	85 d2                	test   %edx,%edx
8010640c:	74 08                	je     80106416 <uartinit+0xa6>
    uartputc(*p);
8010640e:	0f be c0             	movsbl %al,%eax
80106411:	e8 0a ff ff ff       	call   80106320 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106416:	89 f0                	mov    %esi,%eax
80106418:	83 c3 01             	add    $0x1,%ebx
8010641b:	84 c0                	test   %al,%al
8010641d:	75 e1                	jne    80106400 <uartinit+0x90>
}
8010641f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106422:	5b                   	pop    %ebx
80106423:	5e                   	pop    %esi
80106424:	5f                   	pop    %edi
80106425:	5d                   	pop    %ebp
80106426:	c3                   	ret    
80106427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010642e:	66 90                	xchg   %ax,%ax

80106430 <uartputc>:
{
80106430:	f3 0f 1e fb          	endbr32 
80106434:	55                   	push   %ebp
  if(!uart)
80106435:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
8010643b:	89 e5                	mov    %esp,%ebp
8010643d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106440:	85 d2                	test   %edx,%edx
80106442:	74 0c                	je     80106450 <uartputc+0x20>
}
80106444:	5d                   	pop    %ebp
80106445:	e9 d6 fe ff ff       	jmp    80106320 <uartputc.part.0>
8010644a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106450:	5d                   	pop    %ebp
80106451:	c3                   	ret    
80106452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106460 <uartintr>:

void
uartintr(void)
{
80106460:	f3 0f 1e fb          	endbr32 
80106464:	55                   	push   %ebp
80106465:	89 e5                	mov    %esp,%ebp
80106467:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010646a:	68 f0 62 10 80       	push   $0x801062f0
8010646f:	e8 ec a3 ff ff       	call   80100860 <consoleintr>
}
80106474:	83 c4 10             	add    $0x10,%esp
80106477:	c9                   	leave  
80106478:	c3                   	ret    

80106479 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106479:	6a 00                	push   $0x0
  pushl $0
8010647b:	6a 00                	push   $0x0
  jmp alltraps
8010647d:	e9 10 fb ff ff       	jmp    80105f92 <alltraps>

80106482 <vector1>:
.globl vector1
vector1:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $1
80106484:	6a 01                	push   $0x1
  jmp alltraps
80106486:	e9 07 fb ff ff       	jmp    80105f92 <alltraps>

8010648b <vector2>:
.globl vector2
vector2:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $2
8010648d:	6a 02                	push   $0x2
  jmp alltraps
8010648f:	e9 fe fa ff ff       	jmp    80105f92 <alltraps>

80106494 <vector3>:
.globl vector3
vector3:
  pushl $0
80106494:	6a 00                	push   $0x0
  pushl $3
80106496:	6a 03                	push   $0x3
  jmp alltraps
80106498:	e9 f5 fa ff ff       	jmp    80105f92 <alltraps>

8010649d <vector4>:
.globl vector4
vector4:
  pushl $0
8010649d:	6a 00                	push   $0x0
  pushl $4
8010649f:	6a 04                	push   $0x4
  jmp alltraps
801064a1:	e9 ec fa ff ff       	jmp    80105f92 <alltraps>

801064a6 <vector5>:
.globl vector5
vector5:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $5
801064a8:	6a 05                	push   $0x5
  jmp alltraps
801064aa:	e9 e3 fa ff ff       	jmp    80105f92 <alltraps>

801064af <vector6>:
.globl vector6
vector6:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $6
801064b1:	6a 06                	push   $0x6
  jmp alltraps
801064b3:	e9 da fa ff ff       	jmp    80105f92 <alltraps>

801064b8 <vector7>:
.globl vector7
vector7:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $7
801064ba:	6a 07                	push   $0x7
  jmp alltraps
801064bc:	e9 d1 fa ff ff       	jmp    80105f92 <alltraps>

801064c1 <vector8>:
.globl vector8
vector8:
  pushl $8
801064c1:	6a 08                	push   $0x8
  jmp alltraps
801064c3:	e9 ca fa ff ff       	jmp    80105f92 <alltraps>

801064c8 <vector9>:
.globl vector9
vector9:
  pushl $0
801064c8:	6a 00                	push   $0x0
  pushl $9
801064ca:	6a 09                	push   $0x9
  jmp alltraps
801064cc:	e9 c1 fa ff ff       	jmp    80105f92 <alltraps>

801064d1 <vector10>:
.globl vector10
vector10:
  pushl $10
801064d1:	6a 0a                	push   $0xa
  jmp alltraps
801064d3:	e9 ba fa ff ff       	jmp    80105f92 <alltraps>

801064d8 <vector11>:
.globl vector11
vector11:
  pushl $11
801064d8:	6a 0b                	push   $0xb
  jmp alltraps
801064da:	e9 b3 fa ff ff       	jmp    80105f92 <alltraps>

801064df <vector12>:
.globl vector12
vector12:
  pushl $12
801064df:	6a 0c                	push   $0xc
  jmp alltraps
801064e1:	e9 ac fa ff ff       	jmp    80105f92 <alltraps>

801064e6 <vector13>:
.globl vector13
vector13:
  pushl $13
801064e6:	6a 0d                	push   $0xd
  jmp alltraps
801064e8:	e9 a5 fa ff ff       	jmp    80105f92 <alltraps>

801064ed <vector14>:
.globl vector14
vector14:
  pushl $14
801064ed:	6a 0e                	push   $0xe
  jmp alltraps
801064ef:	e9 9e fa ff ff       	jmp    80105f92 <alltraps>

801064f4 <vector15>:
.globl vector15
vector15:
  pushl $0
801064f4:	6a 00                	push   $0x0
  pushl $15
801064f6:	6a 0f                	push   $0xf
  jmp alltraps
801064f8:	e9 95 fa ff ff       	jmp    80105f92 <alltraps>

801064fd <vector16>:
.globl vector16
vector16:
  pushl $0
801064fd:	6a 00                	push   $0x0
  pushl $16
801064ff:	6a 10                	push   $0x10
  jmp alltraps
80106501:	e9 8c fa ff ff       	jmp    80105f92 <alltraps>

80106506 <vector17>:
.globl vector17
vector17:
  pushl $17
80106506:	6a 11                	push   $0x11
  jmp alltraps
80106508:	e9 85 fa ff ff       	jmp    80105f92 <alltraps>

8010650d <vector18>:
.globl vector18
vector18:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $18
8010650f:	6a 12                	push   $0x12
  jmp alltraps
80106511:	e9 7c fa ff ff       	jmp    80105f92 <alltraps>

80106516 <vector19>:
.globl vector19
vector19:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $19
80106518:	6a 13                	push   $0x13
  jmp alltraps
8010651a:	e9 73 fa ff ff       	jmp    80105f92 <alltraps>

8010651f <vector20>:
.globl vector20
vector20:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $20
80106521:	6a 14                	push   $0x14
  jmp alltraps
80106523:	e9 6a fa ff ff       	jmp    80105f92 <alltraps>

80106528 <vector21>:
.globl vector21
vector21:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $21
8010652a:	6a 15                	push   $0x15
  jmp alltraps
8010652c:	e9 61 fa ff ff       	jmp    80105f92 <alltraps>

80106531 <vector22>:
.globl vector22
vector22:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $22
80106533:	6a 16                	push   $0x16
  jmp alltraps
80106535:	e9 58 fa ff ff       	jmp    80105f92 <alltraps>

8010653a <vector23>:
.globl vector23
vector23:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $23
8010653c:	6a 17                	push   $0x17
  jmp alltraps
8010653e:	e9 4f fa ff ff       	jmp    80105f92 <alltraps>

80106543 <vector24>:
.globl vector24
vector24:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $24
80106545:	6a 18                	push   $0x18
  jmp alltraps
80106547:	e9 46 fa ff ff       	jmp    80105f92 <alltraps>

8010654c <vector25>:
.globl vector25
vector25:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $25
8010654e:	6a 19                	push   $0x19
  jmp alltraps
80106550:	e9 3d fa ff ff       	jmp    80105f92 <alltraps>

80106555 <vector26>:
.globl vector26
vector26:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $26
80106557:	6a 1a                	push   $0x1a
  jmp alltraps
80106559:	e9 34 fa ff ff       	jmp    80105f92 <alltraps>

8010655e <vector27>:
.globl vector27
vector27:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $27
80106560:	6a 1b                	push   $0x1b
  jmp alltraps
80106562:	e9 2b fa ff ff       	jmp    80105f92 <alltraps>

80106567 <vector28>:
.globl vector28
vector28:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $28
80106569:	6a 1c                	push   $0x1c
  jmp alltraps
8010656b:	e9 22 fa ff ff       	jmp    80105f92 <alltraps>

80106570 <vector29>:
.globl vector29
vector29:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $29
80106572:	6a 1d                	push   $0x1d
  jmp alltraps
80106574:	e9 19 fa ff ff       	jmp    80105f92 <alltraps>

80106579 <vector30>:
.globl vector30
vector30:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $30
8010657b:	6a 1e                	push   $0x1e
  jmp alltraps
8010657d:	e9 10 fa ff ff       	jmp    80105f92 <alltraps>

80106582 <vector31>:
.globl vector31
vector31:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $31
80106584:	6a 1f                	push   $0x1f
  jmp alltraps
80106586:	e9 07 fa ff ff       	jmp    80105f92 <alltraps>

8010658b <vector32>:
.globl vector32
vector32:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $32
8010658d:	6a 20                	push   $0x20
  jmp alltraps
8010658f:	e9 fe f9 ff ff       	jmp    80105f92 <alltraps>

80106594 <vector33>:
.globl vector33
vector33:
  pushl $0
80106594:	6a 00                	push   $0x0
  pushl $33
80106596:	6a 21                	push   $0x21
  jmp alltraps
80106598:	e9 f5 f9 ff ff       	jmp    80105f92 <alltraps>

8010659d <vector34>:
.globl vector34
vector34:
  pushl $0
8010659d:	6a 00                	push   $0x0
  pushl $34
8010659f:	6a 22                	push   $0x22
  jmp alltraps
801065a1:	e9 ec f9 ff ff       	jmp    80105f92 <alltraps>

801065a6 <vector35>:
.globl vector35
vector35:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $35
801065a8:	6a 23                	push   $0x23
  jmp alltraps
801065aa:	e9 e3 f9 ff ff       	jmp    80105f92 <alltraps>

801065af <vector36>:
.globl vector36
vector36:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $36
801065b1:	6a 24                	push   $0x24
  jmp alltraps
801065b3:	e9 da f9 ff ff       	jmp    80105f92 <alltraps>

801065b8 <vector37>:
.globl vector37
vector37:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $37
801065ba:	6a 25                	push   $0x25
  jmp alltraps
801065bc:	e9 d1 f9 ff ff       	jmp    80105f92 <alltraps>

801065c1 <vector38>:
.globl vector38
vector38:
  pushl $0
801065c1:	6a 00                	push   $0x0
  pushl $38
801065c3:	6a 26                	push   $0x26
  jmp alltraps
801065c5:	e9 c8 f9 ff ff       	jmp    80105f92 <alltraps>

801065ca <vector39>:
.globl vector39
vector39:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $39
801065cc:	6a 27                	push   $0x27
  jmp alltraps
801065ce:	e9 bf f9 ff ff       	jmp    80105f92 <alltraps>

801065d3 <vector40>:
.globl vector40
vector40:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $40
801065d5:	6a 28                	push   $0x28
  jmp alltraps
801065d7:	e9 b6 f9 ff ff       	jmp    80105f92 <alltraps>

801065dc <vector41>:
.globl vector41
vector41:
  pushl $0
801065dc:	6a 00                	push   $0x0
  pushl $41
801065de:	6a 29                	push   $0x29
  jmp alltraps
801065e0:	e9 ad f9 ff ff       	jmp    80105f92 <alltraps>

801065e5 <vector42>:
.globl vector42
vector42:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $42
801065e7:	6a 2a                	push   $0x2a
  jmp alltraps
801065e9:	e9 a4 f9 ff ff       	jmp    80105f92 <alltraps>

801065ee <vector43>:
.globl vector43
vector43:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $43
801065f0:	6a 2b                	push   $0x2b
  jmp alltraps
801065f2:	e9 9b f9 ff ff       	jmp    80105f92 <alltraps>

801065f7 <vector44>:
.globl vector44
vector44:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $44
801065f9:	6a 2c                	push   $0x2c
  jmp alltraps
801065fb:	e9 92 f9 ff ff       	jmp    80105f92 <alltraps>

80106600 <vector45>:
.globl vector45
vector45:
  pushl $0
80106600:	6a 00                	push   $0x0
  pushl $45
80106602:	6a 2d                	push   $0x2d
  jmp alltraps
80106604:	e9 89 f9 ff ff       	jmp    80105f92 <alltraps>

80106609 <vector46>:
.globl vector46
vector46:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $46
8010660b:	6a 2e                	push   $0x2e
  jmp alltraps
8010660d:	e9 80 f9 ff ff       	jmp    80105f92 <alltraps>

80106612 <vector47>:
.globl vector47
vector47:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $47
80106614:	6a 2f                	push   $0x2f
  jmp alltraps
80106616:	e9 77 f9 ff ff       	jmp    80105f92 <alltraps>

8010661b <vector48>:
.globl vector48
vector48:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $48
8010661d:	6a 30                	push   $0x30
  jmp alltraps
8010661f:	e9 6e f9 ff ff       	jmp    80105f92 <alltraps>

80106624 <vector49>:
.globl vector49
vector49:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $49
80106626:	6a 31                	push   $0x31
  jmp alltraps
80106628:	e9 65 f9 ff ff       	jmp    80105f92 <alltraps>

8010662d <vector50>:
.globl vector50
vector50:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $50
8010662f:	6a 32                	push   $0x32
  jmp alltraps
80106631:	e9 5c f9 ff ff       	jmp    80105f92 <alltraps>

80106636 <vector51>:
.globl vector51
vector51:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $51
80106638:	6a 33                	push   $0x33
  jmp alltraps
8010663a:	e9 53 f9 ff ff       	jmp    80105f92 <alltraps>

8010663f <vector52>:
.globl vector52
vector52:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $52
80106641:	6a 34                	push   $0x34
  jmp alltraps
80106643:	e9 4a f9 ff ff       	jmp    80105f92 <alltraps>

80106648 <vector53>:
.globl vector53
vector53:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $53
8010664a:	6a 35                	push   $0x35
  jmp alltraps
8010664c:	e9 41 f9 ff ff       	jmp    80105f92 <alltraps>

80106651 <vector54>:
.globl vector54
vector54:
  pushl $0
80106651:	6a 00                	push   $0x0
  pushl $54
80106653:	6a 36                	push   $0x36
  jmp alltraps
80106655:	e9 38 f9 ff ff       	jmp    80105f92 <alltraps>

8010665a <vector55>:
.globl vector55
vector55:
  pushl $0
8010665a:	6a 00                	push   $0x0
  pushl $55
8010665c:	6a 37                	push   $0x37
  jmp alltraps
8010665e:	e9 2f f9 ff ff       	jmp    80105f92 <alltraps>

80106663 <vector56>:
.globl vector56
vector56:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $56
80106665:	6a 38                	push   $0x38
  jmp alltraps
80106667:	e9 26 f9 ff ff       	jmp    80105f92 <alltraps>

8010666c <vector57>:
.globl vector57
vector57:
  pushl $0
8010666c:	6a 00                	push   $0x0
  pushl $57
8010666e:	6a 39                	push   $0x39
  jmp alltraps
80106670:	e9 1d f9 ff ff       	jmp    80105f92 <alltraps>

80106675 <vector58>:
.globl vector58
vector58:
  pushl $0
80106675:	6a 00                	push   $0x0
  pushl $58
80106677:	6a 3a                	push   $0x3a
  jmp alltraps
80106679:	e9 14 f9 ff ff       	jmp    80105f92 <alltraps>

8010667e <vector59>:
.globl vector59
vector59:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $59
80106680:	6a 3b                	push   $0x3b
  jmp alltraps
80106682:	e9 0b f9 ff ff       	jmp    80105f92 <alltraps>

80106687 <vector60>:
.globl vector60
vector60:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $60
80106689:	6a 3c                	push   $0x3c
  jmp alltraps
8010668b:	e9 02 f9 ff ff       	jmp    80105f92 <alltraps>

80106690 <vector61>:
.globl vector61
vector61:
  pushl $0
80106690:	6a 00                	push   $0x0
  pushl $61
80106692:	6a 3d                	push   $0x3d
  jmp alltraps
80106694:	e9 f9 f8 ff ff       	jmp    80105f92 <alltraps>

80106699 <vector62>:
.globl vector62
vector62:
  pushl $0
80106699:	6a 00                	push   $0x0
  pushl $62
8010669b:	6a 3e                	push   $0x3e
  jmp alltraps
8010669d:	e9 f0 f8 ff ff       	jmp    80105f92 <alltraps>

801066a2 <vector63>:
.globl vector63
vector63:
  pushl $0
801066a2:	6a 00                	push   $0x0
  pushl $63
801066a4:	6a 3f                	push   $0x3f
  jmp alltraps
801066a6:	e9 e7 f8 ff ff       	jmp    80105f92 <alltraps>

801066ab <vector64>:
.globl vector64
vector64:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $64
801066ad:	6a 40                	push   $0x40
  jmp alltraps
801066af:	e9 de f8 ff ff       	jmp    80105f92 <alltraps>

801066b4 <vector65>:
.globl vector65
vector65:
  pushl $0
801066b4:	6a 00                	push   $0x0
  pushl $65
801066b6:	6a 41                	push   $0x41
  jmp alltraps
801066b8:	e9 d5 f8 ff ff       	jmp    80105f92 <alltraps>

801066bd <vector66>:
.globl vector66
vector66:
  pushl $0
801066bd:	6a 00                	push   $0x0
  pushl $66
801066bf:	6a 42                	push   $0x42
  jmp alltraps
801066c1:	e9 cc f8 ff ff       	jmp    80105f92 <alltraps>

801066c6 <vector67>:
.globl vector67
vector67:
  pushl $0
801066c6:	6a 00                	push   $0x0
  pushl $67
801066c8:	6a 43                	push   $0x43
  jmp alltraps
801066ca:	e9 c3 f8 ff ff       	jmp    80105f92 <alltraps>

801066cf <vector68>:
.globl vector68
vector68:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $68
801066d1:	6a 44                	push   $0x44
  jmp alltraps
801066d3:	e9 ba f8 ff ff       	jmp    80105f92 <alltraps>

801066d8 <vector69>:
.globl vector69
vector69:
  pushl $0
801066d8:	6a 00                	push   $0x0
  pushl $69
801066da:	6a 45                	push   $0x45
  jmp alltraps
801066dc:	e9 b1 f8 ff ff       	jmp    80105f92 <alltraps>

801066e1 <vector70>:
.globl vector70
vector70:
  pushl $0
801066e1:	6a 00                	push   $0x0
  pushl $70
801066e3:	6a 46                	push   $0x46
  jmp alltraps
801066e5:	e9 a8 f8 ff ff       	jmp    80105f92 <alltraps>

801066ea <vector71>:
.globl vector71
vector71:
  pushl $0
801066ea:	6a 00                	push   $0x0
  pushl $71
801066ec:	6a 47                	push   $0x47
  jmp alltraps
801066ee:	e9 9f f8 ff ff       	jmp    80105f92 <alltraps>

801066f3 <vector72>:
.globl vector72
vector72:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $72
801066f5:	6a 48                	push   $0x48
  jmp alltraps
801066f7:	e9 96 f8 ff ff       	jmp    80105f92 <alltraps>

801066fc <vector73>:
.globl vector73
vector73:
  pushl $0
801066fc:	6a 00                	push   $0x0
  pushl $73
801066fe:	6a 49                	push   $0x49
  jmp alltraps
80106700:	e9 8d f8 ff ff       	jmp    80105f92 <alltraps>

80106705 <vector74>:
.globl vector74
vector74:
  pushl $0
80106705:	6a 00                	push   $0x0
  pushl $74
80106707:	6a 4a                	push   $0x4a
  jmp alltraps
80106709:	e9 84 f8 ff ff       	jmp    80105f92 <alltraps>

8010670e <vector75>:
.globl vector75
vector75:
  pushl $0
8010670e:	6a 00                	push   $0x0
  pushl $75
80106710:	6a 4b                	push   $0x4b
  jmp alltraps
80106712:	e9 7b f8 ff ff       	jmp    80105f92 <alltraps>

80106717 <vector76>:
.globl vector76
vector76:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $76
80106719:	6a 4c                	push   $0x4c
  jmp alltraps
8010671b:	e9 72 f8 ff ff       	jmp    80105f92 <alltraps>

80106720 <vector77>:
.globl vector77
vector77:
  pushl $0
80106720:	6a 00                	push   $0x0
  pushl $77
80106722:	6a 4d                	push   $0x4d
  jmp alltraps
80106724:	e9 69 f8 ff ff       	jmp    80105f92 <alltraps>

80106729 <vector78>:
.globl vector78
vector78:
  pushl $0
80106729:	6a 00                	push   $0x0
  pushl $78
8010672b:	6a 4e                	push   $0x4e
  jmp alltraps
8010672d:	e9 60 f8 ff ff       	jmp    80105f92 <alltraps>

80106732 <vector79>:
.globl vector79
vector79:
  pushl $0
80106732:	6a 00                	push   $0x0
  pushl $79
80106734:	6a 4f                	push   $0x4f
  jmp alltraps
80106736:	e9 57 f8 ff ff       	jmp    80105f92 <alltraps>

8010673b <vector80>:
.globl vector80
vector80:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $80
8010673d:	6a 50                	push   $0x50
  jmp alltraps
8010673f:	e9 4e f8 ff ff       	jmp    80105f92 <alltraps>

80106744 <vector81>:
.globl vector81
vector81:
  pushl $0
80106744:	6a 00                	push   $0x0
  pushl $81
80106746:	6a 51                	push   $0x51
  jmp alltraps
80106748:	e9 45 f8 ff ff       	jmp    80105f92 <alltraps>

8010674d <vector82>:
.globl vector82
vector82:
  pushl $0
8010674d:	6a 00                	push   $0x0
  pushl $82
8010674f:	6a 52                	push   $0x52
  jmp alltraps
80106751:	e9 3c f8 ff ff       	jmp    80105f92 <alltraps>

80106756 <vector83>:
.globl vector83
vector83:
  pushl $0
80106756:	6a 00                	push   $0x0
  pushl $83
80106758:	6a 53                	push   $0x53
  jmp alltraps
8010675a:	e9 33 f8 ff ff       	jmp    80105f92 <alltraps>

8010675f <vector84>:
.globl vector84
vector84:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $84
80106761:	6a 54                	push   $0x54
  jmp alltraps
80106763:	e9 2a f8 ff ff       	jmp    80105f92 <alltraps>

80106768 <vector85>:
.globl vector85
vector85:
  pushl $0
80106768:	6a 00                	push   $0x0
  pushl $85
8010676a:	6a 55                	push   $0x55
  jmp alltraps
8010676c:	e9 21 f8 ff ff       	jmp    80105f92 <alltraps>

80106771 <vector86>:
.globl vector86
vector86:
  pushl $0
80106771:	6a 00                	push   $0x0
  pushl $86
80106773:	6a 56                	push   $0x56
  jmp alltraps
80106775:	e9 18 f8 ff ff       	jmp    80105f92 <alltraps>

8010677a <vector87>:
.globl vector87
vector87:
  pushl $0
8010677a:	6a 00                	push   $0x0
  pushl $87
8010677c:	6a 57                	push   $0x57
  jmp alltraps
8010677e:	e9 0f f8 ff ff       	jmp    80105f92 <alltraps>

80106783 <vector88>:
.globl vector88
vector88:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $88
80106785:	6a 58                	push   $0x58
  jmp alltraps
80106787:	e9 06 f8 ff ff       	jmp    80105f92 <alltraps>

8010678c <vector89>:
.globl vector89
vector89:
  pushl $0
8010678c:	6a 00                	push   $0x0
  pushl $89
8010678e:	6a 59                	push   $0x59
  jmp alltraps
80106790:	e9 fd f7 ff ff       	jmp    80105f92 <alltraps>

80106795 <vector90>:
.globl vector90
vector90:
  pushl $0
80106795:	6a 00                	push   $0x0
  pushl $90
80106797:	6a 5a                	push   $0x5a
  jmp alltraps
80106799:	e9 f4 f7 ff ff       	jmp    80105f92 <alltraps>

8010679e <vector91>:
.globl vector91
vector91:
  pushl $0
8010679e:	6a 00                	push   $0x0
  pushl $91
801067a0:	6a 5b                	push   $0x5b
  jmp alltraps
801067a2:	e9 eb f7 ff ff       	jmp    80105f92 <alltraps>

801067a7 <vector92>:
.globl vector92
vector92:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $92
801067a9:	6a 5c                	push   $0x5c
  jmp alltraps
801067ab:	e9 e2 f7 ff ff       	jmp    80105f92 <alltraps>

801067b0 <vector93>:
.globl vector93
vector93:
  pushl $0
801067b0:	6a 00                	push   $0x0
  pushl $93
801067b2:	6a 5d                	push   $0x5d
  jmp alltraps
801067b4:	e9 d9 f7 ff ff       	jmp    80105f92 <alltraps>

801067b9 <vector94>:
.globl vector94
vector94:
  pushl $0
801067b9:	6a 00                	push   $0x0
  pushl $94
801067bb:	6a 5e                	push   $0x5e
  jmp alltraps
801067bd:	e9 d0 f7 ff ff       	jmp    80105f92 <alltraps>

801067c2 <vector95>:
.globl vector95
vector95:
  pushl $0
801067c2:	6a 00                	push   $0x0
  pushl $95
801067c4:	6a 5f                	push   $0x5f
  jmp alltraps
801067c6:	e9 c7 f7 ff ff       	jmp    80105f92 <alltraps>

801067cb <vector96>:
.globl vector96
vector96:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $96
801067cd:	6a 60                	push   $0x60
  jmp alltraps
801067cf:	e9 be f7 ff ff       	jmp    80105f92 <alltraps>

801067d4 <vector97>:
.globl vector97
vector97:
  pushl $0
801067d4:	6a 00                	push   $0x0
  pushl $97
801067d6:	6a 61                	push   $0x61
  jmp alltraps
801067d8:	e9 b5 f7 ff ff       	jmp    80105f92 <alltraps>

801067dd <vector98>:
.globl vector98
vector98:
  pushl $0
801067dd:	6a 00                	push   $0x0
  pushl $98
801067df:	6a 62                	push   $0x62
  jmp alltraps
801067e1:	e9 ac f7 ff ff       	jmp    80105f92 <alltraps>

801067e6 <vector99>:
.globl vector99
vector99:
  pushl $0
801067e6:	6a 00                	push   $0x0
  pushl $99
801067e8:	6a 63                	push   $0x63
  jmp alltraps
801067ea:	e9 a3 f7 ff ff       	jmp    80105f92 <alltraps>

801067ef <vector100>:
.globl vector100
vector100:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $100
801067f1:	6a 64                	push   $0x64
  jmp alltraps
801067f3:	e9 9a f7 ff ff       	jmp    80105f92 <alltraps>

801067f8 <vector101>:
.globl vector101
vector101:
  pushl $0
801067f8:	6a 00                	push   $0x0
  pushl $101
801067fa:	6a 65                	push   $0x65
  jmp alltraps
801067fc:	e9 91 f7 ff ff       	jmp    80105f92 <alltraps>

80106801 <vector102>:
.globl vector102
vector102:
  pushl $0
80106801:	6a 00                	push   $0x0
  pushl $102
80106803:	6a 66                	push   $0x66
  jmp alltraps
80106805:	e9 88 f7 ff ff       	jmp    80105f92 <alltraps>

8010680a <vector103>:
.globl vector103
vector103:
  pushl $0
8010680a:	6a 00                	push   $0x0
  pushl $103
8010680c:	6a 67                	push   $0x67
  jmp alltraps
8010680e:	e9 7f f7 ff ff       	jmp    80105f92 <alltraps>

80106813 <vector104>:
.globl vector104
vector104:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $104
80106815:	6a 68                	push   $0x68
  jmp alltraps
80106817:	e9 76 f7 ff ff       	jmp    80105f92 <alltraps>

8010681c <vector105>:
.globl vector105
vector105:
  pushl $0
8010681c:	6a 00                	push   $0x0
  pushl $105
8010681e:	6a 69                	push   $0x69
  jmp alltraps
80106820:	e9 6d f7 ff ff       	jmp    80105f92 <alltraps>

80106825 <vector106>:
.globl vector106
vector106:
  pushl $0
80106825:	6a 00                	push   $0x0
  pushl $106
80106827:	6a 6a                	push   $0x6a
  jmp alltraps
80106829:	e9 64 f7 ff ff       	jmp    80105f92 <alltraps>

8010682e <vector107>:
.globl vector107
vector107:
  pushl $0
8010682e:	6a 00                	push   $0x0
  pushl $107
80106830:	6a 6b                	push   $0x6b
  jmp alltraps
80106832:	e9 5b f7 ff ff       	jmp    80105f92 <alltraps>

80106837 <vector108>:
.globl vector108
vector108:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $108
80106839:	6a 6c                	push   $0x6c
  jmp alltraps
8010683b:	e9 52 f7 ff ff       	jmp    80105f92 <alltraps>

80106840 <vector109>:
.globl vector109
vector109:
  pushl $0
80106840:	6a 00                	push   $0x0
  pushl $109
80106842:	6a 6d                	push   $0x6d
  jmp alltraps
80106844:	e9 49 f7 ff ff       	jmp    80105f92 <alltraps>

80106849 <vector110>:
.globl vector110
vector110:
  pushl $0
80106849:	6a 00                	push   $0x0
  pushl $110
8010684b:	6a 6e                	push   $0x6e
  jmp alltraps
8010684d:	e9 40 f7 ff ff       	jmp    80105f92 <alltraps>

80106852 <vector111>:
.globl vector111
vector111:
  pushl $0
80106852:	6a 00                	push   $0x0
  pushl $111
80106854:	6a 6f                	push   $0x6f
  jmp alltraps
80106856:	e9 37 f7 ff ff       	jmp    80105f92 <alltraps>

8010685b <vector112>:
.globl vector112
vector112:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $112
8010685d:	6a 70                	push   $0x70
  jmp alltraps
8010685f:	e9 2e f7 ff ff       	jmp    80105f92 <alltraps>

80106864 <vector113>:
.globl vector113
vector113:
  pushl $0
80106864:	6a 00                	push   $0x0
  pushl $113
80106866:	6a 71                	push   $0x71
  jmp alltraps
80106868:	e9 25 f7 ff ff       	jmp    80105f92 <alltraps>

8010686d <vector114>:
.globl vector114
vector114:
  pushl $0
8010686d:	6a 00                	push   $0x0
  pushl $114
8010686f:	6a 72                	push   $0x72
  jmp alltraps
80106871:	e9 1c f7 ff ff       	jmp    80105f92 <alltraps>

80106876 <vector115>:
.globl vector115
vector115:
  pushl $0
80106876:	6a 00                	push   $0x0
  pushl $115
80106878:	6a 73                	push   $0x73
  jmp alltraps
8010687a:	e9 13 f7 ff ff       	jmp    80105f92 <alltraps>

8010687f <vector116>:
.globl vector116
vector116:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $116
80106881:	6a 74                	push   $0x74
  jmp alltraps
80106883:	e9 0a f7 ff ff       	jmp    80105f92 <alltraps>

80106888 <vector117>:
.globl vector117
vector117:
  pushl $0
80106888:	6a 00                	push   $0x0
  pushl $117
8010688a:	6a 75                	push   $0x75
  jmp alltraps
8010688c:	e9 01 f7 ff ff       	jmp    80105f92 <alltraps>

80106891 <vector118>:
.globl vector118
vector118:
  pushl $0
80106891:	6a 00                	push   $0x0
  pushl $118
80106893:	6a 76                	push   $0x76
  jmp alltraps
80106895:	e9 f8 f6 ff ff       	jmp    80105f92 <alltraps>

8010689a <vector119>:
.globl vector119
vector119:
  pushl $0
8010689a:	6a 00                	push   $0x0
  pushl $119
8010689c:	6a 77                	push   $0x77
  jmp alltraps
8010689e:	e9 ef f6 ff ff       	jmp    80105f92 <alltraps>

801068a3 <vector120>:
.globl vector120
vector120:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $120
801068a5:	6a 78                	push   $0x78
  jmp alltraps
801068a7:	e9 e6 f6 ff ff       	jmp    80105f92 <alltraps>

801068ac <vector121>:
.globl vector121
vector121:
  pushl $0
801068ac:	6a 00                	push   $0x0
  pushl $121
801068ae:	6a 79                	push   $0x79
  jmp alltraps
801068b0:	e9 dd f6 ff ff       	jmp    80105f92 <alltraps>

801068b5 <vector122>:
.globl vector122
vector122:
  pushl $0
801068b5:	6a 00                	push   $0x0
  pushl $122
801068b7:	6a 7a                	push   $0x7a
  jmp alltraps
801068b9:	e9 d4 f6 ff ff       	jmp    80105f92 <alltraps>

801068be <vector123>:
.globl vector123
vector123:
  pushl $0
801068be:	6a 00                	push   $0x0
  pushl $123
801068c0:	6a 7b                	push   $0x7b
  jmp alltraps
801068c2:	e9 cb f6 ff ff       	jmp    80105f92 <alltraps>

801068c7 <vector124>:
.globl vector124
vector124:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $124
801068c9:	6a 7c                	push   $0x7c
  jmp alltraps
801068cb:	e9 c2 f6 ff ff       	jmp    80105f92 <alltraps>

801068d0 <vector125>:
.globl vector125
vector125:
  pushl $0
801068d0:	6a 00                	push   $0x0
  pushl $125
801068d2:	6a 7d                	push   $0x7d
  jmp alltraps
801068d4:	e9 b9 f6 ff ff       	jmp    80105f92 <alltraps>

801068d9 <vector126>:
.globl vector126
vector126:
  pushl $0
801068d9:	6a 00                	push   $0x0
  pushl $126
801068db:	6a 7e                	push   $0x7e
  jmp alltraps
801068dd:	e9 b0 f6 ff ff       	jmp    80105f92 <alltraps>

801068e2 <vector127>:
.globl vector127
vector127:
  pushl $0
801068e2:	6a 00                	push   $0x0
  pushl $127
801068e4:	6a 7f                	push   $0x7f
  jmp alltraps
801068e6:	e9 a7 f6 ff ff       	jmp    80105f92 <alltraps>

801068eb <vector128>:
.globl vector128
vector128:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $128
801068ed:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801068f2:	e9 9b f6 ff ff       	jmp    80105f92 <alltraps>

801068f7 <vector129>:
.globl vector129
vector129:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $129
801068f9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801068fe:	e9 8f f6 ff ff       	jmp    80105f92 <alltraps>

80106903 <vector130>:
.globl vector130
vector130:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $130
80106905:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010690a:	e9 83 f6 ff ff       	jmp    80105f92 <alltraps>

8010690f <vector131>:
.globl vector131
vector131:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $131
80106911:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106916:	e9 77 f6 ff ff       	jmp    80105f92 <alltraps>

8010691b <vector132>:
.globl vector132
vector132:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $132
8010691d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106922:	e9 6b f6 ff ff       	jmp    80105f92 <alltraps>

80106927 <vector133>:
.globl vector133
vector133:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $133
80106929:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010692e:	e9 5f f6 ff ff       	jmp    80105f92 <alltraps>

80106933 <vector134>:
.globl vector134
vector134:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $134
80106935:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010693a:	e9 53 f6 ff ff       	jmp    80105f92 <alltraps>

8010693f <vector135>:
.globl vector135
vector135:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $135
80106941:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106946:	e9 47 f6 ff ff       	jmp    80105f92 <alltraps>

8010694b <vector136>:
.globl vector136
vector136:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $136
8010694d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106952:	e9 3b f6 ff ff       	jmp    80105f92 <alltraps>

80106957 <vector137>:
.globl vector137
vector137:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $137
80106959:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010695e:	e9 2f f6 ff ff       	jmp    80105f92 <alltraps>

80106963 <vector138>:
.globl vector138
vector138:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $138
80106965:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010696a:	e9 23 f6 ff ff       	jmp    80105f92 <alltraps>

8010696f <vector139>:
.globl vector139
vector139:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $139
80106971:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106976:	e9 17 f6 ff ff       	jmp    80105f92 <alltraps>

8010697b <vector140>:
.globl vector140
vector140:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $140
8010697d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106982:	e9 0b f6 ff ff       	jmp    80105f92 <alltraps>

80106987 <vector141>:
.globl vector141
vector141:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $141
80106989:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010698e:	e9 ff f5 ff ff       	jmp    80105f92 <alltraps>

80106993 <vector142>:
.globl vector142
vector142:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $142
80106995:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010699a:	e9 f3 f5 ff ff       	jmp    80105f92 <alltraps>

8010699f <vector143>:
.globl vector143
vector143:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $143
801069a1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801069a6:	e9 e7 f5 ff ff       	jmp    80105f92 <alltraps>

801069ab <vector144>:
.globl vector144
vector144:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $144
801069ad:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801069b2:	e9 db f5 ff ff       	jmp    80105f92 <alltraps>

801069b7 <vector145>:
.globl vector145
vector145:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $145
801069b9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801069be:	e9 cf f5 ff ff       	jmp    80105f92 <alltraps>

801069c3 <vector146>:
.globl vector146
vector146:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $146
801069c5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801069ca:	e9 c3 f5 ff ff       	jmp    80105f92 <alltraps>

801069cf <vector147>:
.globl vector147
vector147:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $147
801069d1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801069d6:	e9 b7 f5 ff ff       	jmp    80105f92 <alltraps>

801069db <vector148>:
.globl vector148
vector148:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $148
801069dd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801069e2:	e9 ab f5 ff ff       	jmp    80105f92 <alltraps>

801069e7 <vector149>:
.globl vector149
vector149:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $149
801069e9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801069ee:	e9 9f f5 ff ff       	jmp    80105f92 <alltraps>

801069f3 <vector150>:
.globl vector150
vector150:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $150
801069f5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801069fa:	e9 93 f5 ff ff       	jmp    80105f92 <alltraps>

801069ff <vector151>:
.globl vector151
vector151:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $151
80106a01:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106a06:	e9 87 f5 ff ff       	jmp    80105f92 <alltraps>

80106a0b <vector152>:
.globl vector152
vector152:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $152
80106a0d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106a12:	e9 7b f5 ff ff       	jmp    80105f92 <alltraps>

80106a17 <vector153>:
.globl vector153
vector153:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $153
80106a19:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106a1e:	e9 6f f5 ff ff       	jmp    80105f92 <alltraps>

80106a23 <vector154>:
.globl vector154
vector154:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $154
80106a25:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106a2a:	e9 63 f5 ff ff       	jmp    80105f92 <alltraps>

80106a2f <vector155>:
.globl vector155
vector155:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $155
80106a31:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106a36:	e9 57 f5 ff ff       	jmp    80105f92 <alltraps>

80106a3b <vector156>:
.globl vector156
vector156:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $156
80106a3d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106a42:	e9 4b f5 ff ff       	jmp    80105f92 <alltraps>

80106a47 <vector157>:
.globl vector157
vector157:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $157
80106a49:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106a4e:	e9 3f f5 ff ff       	jmp    80105f92 <alltraps>

80106a53 <vector158>:
.globl vector158
vector158:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $158
80106a55:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a5a:	e9 33 f5 ff ff       	jmp    80105f92 <alltraps>

80106a5f <vector159>:
.globl vector159
vector159:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $159
80106a61:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a66:	e9 27 f5 ff ff       	jmp    80105f92 <alltraps>

80106a6b <vector160>:
.globl vector160
vector160:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $160
80106a6d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a72:	e9 1b f5 ff ff       	jmp    80105f92 <alltraps>

80106a77 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $161
80106a79:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a7e:	e9 0f f5 ff ff       	jmp    80105f92 <alltraps>

80106a83 <vector162>:
.globl vector162
vector162:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $162
80106a85:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a8a:	e9 03 f5 ff ff       	jmp    80105f92 <alltraps>

80106a8f <vector163>:
.globl vector163
vector163:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $163
80106a91:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a96:	e9 f7 f4 ff ff       	jmp    80105f92 <alltraps>

80106a9b <vector164>:
.globl vector164
vector164:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $164
80106a9d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106aa2:	e9 eb f4 ff ff       	jmp    80105f92 <alltraps>

80106aa7 <vector165>:
.globl vector165
vector165:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $165
80106aa9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106aae:	e9 df f4 ff ff       	jmp    80105f92 <alltraps>

80106ab3 <vector166>:
.globl vector166
vector166:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $166
80106ab5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106aba:	e9 d3 f4 ff ff       	jmp    80105f92 <alltraps>

80106abf <vector167>:
.globl vector167
vector167:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $167
80106ac1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106ac6:	e9 c7 f4 ff ff       	jmp    80105f92 <alltraps>

80106acb <vector168>:
.globl vector168
vector168:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $168
80106acd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106ad2:	e9 bb f4 ff ff       	jmp    80105f92 <alltraps>

80106ad7 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $169
80106ad9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106ade:	e9 af f4 ff ff       	jmp    80105f92 <alltraps>

80106ae3 <vector170>:
.globl vector170
vector170:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $170
80106ae5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106aea:	e9 a3 f4 ff ff       	jmp    80105f92 <alltraps>

80106aef <vector171>:
.globl vector171
vector171:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $171
80106af1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106af6:	e9 97 f4 ff ff       	jmp    80105f92 <alltraps>

80106afb <vector172>:
.globl vector172
vector172:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $172
80106afd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106b02:	e9 8b f4 ff ff       	jmp    80105f92 <alltraps>

80106b07 <vector173>:
.globl vector173
vector173:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $173
80106b09:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106b0e:	e9 7f f4 ff ff       	jmp    80105f92 <alltraps>

80106b13 <vector174>:
.globl vector174
vector174:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $174
80106b15:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106b1a:	e9 73 f4 ff ff       	jmp    80105f92 <alltraps>

80106b1f <vector175>:
.globl vector175
vector175:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $175
80106b21:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106b26:	e9 67 f4 ff ff       	jmp    80105f92 <alltraps>

80106b2b <vector176>:
.globl vector176
vector176:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $176
80106b2d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106b32:	e9 5b f4 ff ff       	jmp    80105f92 <alltraps>

80106b37 <vector177>:
.globl vector177
vector177:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $177
80106b39:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106b3e:	e9 4f f4 ff ff       	jmp    80105f92 <alltraps>

80106b43 <vector178>:
.globl vector178
vector178:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $178
80106b45:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106b4a:	e9 43 f4 ff ff       	jmp    80105f92 <alltraps>

80106b4f <vector179>:
.globl vector179
vector179:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $179
80106b51:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b56:	e9 37 f4 ff ff       	jmp    80105f92 <alltraps>

80106b5b <vector180>:
.globl vector180
vector180:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $180
80106b5d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b62:	e9 2b f4 ff ff       	jmp    80105f92 <alltraps>

80106b67 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $181
80106b69:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b6e:	e9 1f f4 ff ff       	jmp    80105f92 <alltraps>

80106b73 <vector182>:
.globl vector182
vector182:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $182
80106b75:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b7a:	e9 13 f4 ff ff       	jmp    80105f92 <alltraps>

80106b7f <vector183>:
.globl vector183
vector183:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $183
80106b81:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b86:	e9 07 f4 ff ff       	jmp    80105f92 <alltraps>

80106b8b <vector184>:
.globl vector184
vector184:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $184
80106b8d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b92:	e9 fb f3 ff ff       	jmp    80105f92 <alltraps>

80106b97 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $185
80106b99:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b9e:	e9 ef f3 ff ff       	jmp    80105f92 <alltraps>

80106ba3 <vector186>:
.globl vector186
vector186:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $186
80106ba5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106baa:	e9 e3 f3 ff ff       	jmp    80105f92 <alltraps>

80106baf <vector187>:
.globl vector187
vector187:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $187
80106bb1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106bb6:	e9 d7 f3 ff ff       	jmp    80105f92 <alltraps>

80106bbb <vector188>:
.globl vector188
vector188:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $188
80106bbd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106bc2:	e9 cb f3 ff ff       	jmp    80105f92 <alltraps>

80106bc7 <vector189>:
.globl vector189
vector189:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $189
80106bc9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106bce:	e9 bf f3 ff ff       	jmp    80105f92 <alltraps>

80106bd3 <vector190>:
.globl vector190
vector190:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $190
80106bd5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106bda:	e9 b3 f3 ff ff       	jmp    80105f92 <alltraps>

80106bdf <vector191>:
.globl vector191
vector191:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $191
80106be1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106be6:	e9 a7 f3 ff ff       	jmp    80105f92 <alltraps>

80106beb <vector192>:
.globl vector192
vector192:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $192
80106bed:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106bf2:	e9 9b f3 ff ff       	jmp    80105f92 <alltraps>

80106bf7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $193
80106bf9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106bfe:	e9 8f f3 ff ff       	jmp    80105f92 <alltraps>

80106c03 <vector194>:
.globl vector194
vector194:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $194
80106c05:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106c0a:	e9 83 f3 ff ff       	jmp    80105f92 <alltraps>

80106c0f <vector195>:
.globl vector195
vector195:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $195
80106c11:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106c16:	e9 77 f3 ff ff       	jmp    80105f92 <alltraps>

80106c1b <vector196>:
.globl vector196
vector196:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $196
80106c1d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106c22:	e9 6b f3 ff ff       	jmp    80105f92 <alltraps>

80106c27 <vector197>:
.globl vector197
vector197:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $197
80106c29:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106c2e:	e9 5f f3 ff ff       	jmp    80105f92 <alltraps>

80106c33 <vector198>:
.globl vector198
vector198:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $198
80106c35:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106c3a:	e9 53 f3 ff ff       	jmp    80105f92 <alltraps>

80106c3f <vector199>:
.globl vector199
vector199:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $199
80106c41:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106c46:	e9 47 f3 ff ff       	jmp    80105f92 <alltraps>

80106c4b <vector200>:
.globl vector200
vector200:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $200
80106c4d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106c52:	e9 3b f3 ff ff       	jmp    80105f92 <alltraps>

80106c57 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $201
80106c59:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c5e:	e9 2f f3 ff ff       	jmp    80105f92 <alltraps>

80106c63 <vector202>:
.globl vector202
vector202:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $202
80106c65:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c6a:	e9 23 f3 ff ff       	jmp    80105f92 <alltraps>

80106c6f <vector203>:
.globl vector203
vector203:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $203
80106c71:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c76:	e9 17 f3 ff ff       	jmp    80105f92 <alltraps>

80106c7b <vector204>:
.globl vector204
vector204:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $204
80106c7d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c82:	e9 0b f3 ff ff       	jmp    80105f92 <alltraps>

80106c87 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $205
80106c89:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c8e:	e9 ff f2 ff ff       	jmp    80105f92 <alltraps>

80106c93 <vector206>:
.globl vector206
vector206:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $206
80106c95:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c9a:	e9 f3 f2 ff ff       	jmp    80105f92 <alltraps>

80106c9f <vector207>:
.globl vector207
vector207:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $207
80106ca1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ca6:	e9 e7 f2 ff ff       	jmp    80105f92 <alltraps>

80106cab <vector208>:
.globl vector208
vector208:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $208
80106cad:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106cb2:	e9 db f2 ff ff       	jmp    80105f92 <alltraps>

80106cb7 <vector209>:
.globl vector209
vector209:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $209
80106cb9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106cbe:	e9 cf f2 ff ff       	jmp    80105f92 <alltraps>

80106cc3 <vector210>:
.globl vector210
vector210:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $210
80106cc5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106cca:	e9 c3 f2 ff ff       	jmp    80105f92 <alltraps>

80106ccf <vector211>:
.globl vector211
vector211:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $211
80106cd1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106cd6:	e9 b7 f2 ff ff       	jmp    80105f92 <alltraps>

80106cdb <vector212>:
.globl vector212
vector212:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $212
80106cdd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106ce2:	e9 ab f2 ff ff       	jmp    80105f92 <alltraps>

80106ce7 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $213
80106ce9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106cee:	e9 9f f2 ff ff       	jmp    80105f92 <alltraps>

80106cf3 <vector214>:
.globl vector214
vector214:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $214
80106cf5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106cfa:	e9 93 f2 ff ff       	jmp    80105f92 <alltraps>

80106cff <vector215>:
.globl vector215
vector215:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $215
80106d01:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106d06:	e9 87 f2 ff ff       	jmp    80105f92 <alltraps>

80106d0b <vector216>:
.globl vector216
vector216:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $216
80106d0d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106d12:	e9 7b f2 ff ff       	jmp    80105f92 <alltraps>

80106d17 <vector217>:
.globl vector217
vector217:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $217
80106d19:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106d1e:	e9 6f f2 ff ff       	jmp    80105f92 <alltraps>

80106d23 <vector218>:
.globl vector218
vector218:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $218
80106d25:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106d2a:	e9 63 f2 ff ff       	jmp    80105f92 <alltraps>

80106d2f <vector219>:
.globl vector219
vector219:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $219
80106d31:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106d36:	e9 57 f2 ff ff       	jmp    80105f92 <alltraps>

80106d3b <vector220>:
.globl vector220
vector220:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $220
80106d3d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106d42:	e9 4b f2 ff ff       	jmp    80105f92 <alltraps>

80106d47 <vector221>:
.globl vector221
vector221:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $221
80106d49:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106d4e:	e9 3f f2 ff ff       	jmp    80105f92 <alltraps>

80106d53 <vector222>:
.globl vector222
vector222:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $222
80106d55:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d5a:	e9 33 f2 ff ff       	jmp    80105f92 <alltraps>

80106d5f <vector223>:
.globl vector223
vector223:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $223
80106d61:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d66:	e9 27 f2 ff ff       	jmp    80105f92 <alltraps>

80106d6b <vector224>:
.globl vector224
vector224:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $224
80106d6d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d72:	e9 1b f2 ff ff       	jmp    80105f92 <alltraps>

80106d77 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $225
80106d79:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d7e:	e9 0f f2 ff ff       	jmp    80105f92 <alltraps>

80106d83 <vector226>:
.globl vector226
vector226:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $226
80106d85:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d8a:	e9 03 f2 ff ff       	jmp    80105f92 <alltraps>

80106d8f <vector227>:
.globl vector227
vector227:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $227
80106d91:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d96:	e9 f7 f1 ff ff       	jmp    80105f92 <alltraps>

80106d9b <vector228>:
.globl vector228
vector228:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $228
80106d9d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106da2:	e9 eb f1 ff ff       	jmp    80105f92 <alltraps>

80106da7 <vector229>:
.globl vector229
vector229:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $229
80106da9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106dae:	e9 df f1 ff ff       	jmp    80105f92 <alltraps>

80106db3 <vector230>:
.globl vector230
vector230:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $230
80106db5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106dba:	e9 d3 f1 ff ff       	jmp    80105f92 <alltraps>

80106dbf <vector231>:
.globl vector231
vector231:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $231
80106dc1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106dc6:	e9 c7 f1 ff ff       	jmp    80105f92 <alltraps>

80106dcb <vector232>:
.globl vector232
vector232:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $232
80106dcd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106dd2:	e9 bb f1 ff ff       	jmp    80105f92 <alltraps>

80106dd7 <vector233>:
.globl vector233
vector233:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $233
80106dd9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106dde:	e9 af f1 ff ff       	jmp    80105f92 <alltraps>

80106de3 <vector234>:
.globl vector234
vector234:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $234
80106de5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106dea:	e9 a3 f1 ff ff       	jmp    80105f92 <alltraps>

80106def <vector235>:
.globl vector235
vector235:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $235
80106df1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106df6:	e9 97 f1 ff ff       	jmp    80105f92 <alltraps>

80106dfb <vector236>:
.globl vector236
vector236:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $236
80106dfd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106e02:	e9 8b f1 ff ff       	jmp    80105f92 <alltraps>

80106e07 <vector237>:
.globl vector237
vector237:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $237
80106e09:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106e0e:	e9 7f f1 ff ff       	jmp    80105f92 <alltraps>

80106e13 <vector238>:
.globl vector238
vector238:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $238
80106e15:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106e1a:	e9 73 f1 ff ff       	jmp    80105f92 <alltraps>

80106e1f <vector239>:
.globl vector239
vector239:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $239
80106e21:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106e26:	e9 67 f1 ff ff       	jmp    80105f92 <alltraps>

80106e2b <vector240>:
.globl vector240
vector240:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $240
80106e2d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106e32:	e9 5b f1 ff ff       	jmp    80105f92 <alltraps>

80106e37 <vector241>:
.globl vector241
vector241:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $241
80106e39:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106e3e:	e9 4f f1 ff ff       	jmp    80105f92 <alltraps>

80106e43 <vector242>:
.globl vector242
vector242:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $242
80106e45:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106e4a:	e9 43 f1 ff ff       	jmp    80105f92 <alltraps>

80106e4f <vector243>:
.globl vector243
vector243:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $243
80106e51:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e56:	e9 37 f1 ff ff       	jmp    80105f92 <alltraps>

80106e5b <vector244>:
.globl vector244
vector244:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $244
80106e5d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e62:	e9 2b f1 ff ff       	jmp    80105f92 <alltraps>

80106e67 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $245
80106e69:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e6e:	e9 1f f1 ff ff       	jmp    80105f92 <alltraps>

80106e73 <vector246>:
.globl vector246
vector246:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $246
80106e75:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e7a:	e9 13 f1 ff ff       	jmp    80105f92 <alltraps>

80106e7f <vector247>:
.globl vector247
vector247:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $247
80106e81:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e86:	e9 07 f1 ff ff       	jmp    80105f92 <alltraps>

80106e8b <vector248>:
.globl vector248
vector248:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $248
80106e8d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e92:	e9 fb f0 ff ff       	jmp    80105f92 <alltraps>

80106e97 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $249
80106e99:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e9e:	e9 ef f0 ff ff       	jmp    80105f92 <alltraps>

80106ea3 <vector250>:
.globl vector250
vector250:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $250
80106ea5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106eaa:	e9 e3 f0 ff ff       	jmp    80105f92 <alltraps>

80106eaf <vector251>:
.globl vector251
vector251:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $251
80106eb1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106eb6:	e9 d7 f0 ff ff       	jmp    80105f92 <alltraps>

80106ebb <vector252>:
.globl vector252
vector252:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $252
80106ebd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106ec2:	e9 cb f0 ff ff       	jmp    80105f92 <alltraps>

80106ec7 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $253
80106ec9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106ece:	e9 bf f0 ff ff       	jmp    80105f92 <alltraps>

80106ed3 <vector254>:
.globl vector254
vector254:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $254
80106ed5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106eda:	e9 b3 f0 ff ff       	jmp    80105f92 <alltraps>

80106edf <vector255>:
.globl vector255
vector255:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $255
80106ee1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106ee6:	e9 a7 f0 ff ff       	jmp    80105f92 <alltraps>
80106eeb:	66 90                	xchg   %ax,%ax
80106eed:	66 90                	xchg   %ax,%ax
80106eef:	90                   	nop

80106ef0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	57                   	push   %edi
80106ef4:	56                   	push   %esi
80106ef5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ef7:	c1 ea 16             	shr    $0x16,%edx
{
80106efa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106efb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106efe:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106f01:	8b 1f                	mov    (%edi),%ebx
80106f03:	f6 c3 01             	test   $0x1,%bl
80106f06:	74 28                	je     80106f30 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f08:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106f0e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106f14:	89 f0                	mov    %esi,%eax
}
80106f16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106f19:	c1 e8 0a             	shr    $0xa,%eax
80106f1c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106f21:	01 d8                	add    %ebx,%eax
}
80106f23:	5b                   	pop    %ebx
80106f24:	5e                   	pop    %esi
80106f25:	5f                   	pop    %edi
80106f26:	5d                   	pop    %ebp
80106f27:	c3                   	ret    
80106f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f2f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106f30:	85 c9                	test   %ecx,%ecx
80106f32:	74 2c                	je     80106f60 <walkpgdir+0x70>
80106f34:	e8 f7 b6 ff ff       	call   80102630 <kalloc>
80106f39:	89 c3                	mov    %eax,%ebx
80106f3b:	85 c0                	test   %eax,%eax
80106f3d:	74 21                	je     80106f60 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106f3f:	83 ec 04             	sub    $0x4,%esp
80106f42:	68 00 10 00 00       	push   $0x1000
80106f47:	6a 00                	push   $0x0
80106f49:	50                   	push   %eax
80106f4a:	e8 71 dd ff ff       	call   80104cc0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106f4f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f55:	83 c4 10             	add    $0x10,%esp
80106f58:	83 c8 07             	or     $0x7,%eax
80106f5b:	89 07                	mov    %eax,(%edi)
80106f5d:	eb b5                	jmp    80106f14 <walkpgdir+0x24>
80106f5f:	90                   	nop
}
80106f60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106f63:	31 c0                	xor    %eax,%eax
}
80106f65:	5b                   	pop    %ebx
80106f66:	5e                   	pop    %esi
80106f67:	5f                   	pop    %edi
80106f68:	5d                   	pop    %ebp
80106f69:	c3                   	ret    
80106f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f70 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	57                   	push   %edi
80106f74:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f76:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106f7a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106f80:	89 d6                	mov    %edx,%esi
{
80106f82:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106f83:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106f89:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f8f:	8b 45 08             	mov    0x8(%ebp),%eax
80106f92:	29 f0                	sub    %esi,%eax
80106f94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f97:	eb 1f                	jmp    80106fb8 <mappages+0x48>
80106f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106fa0:	f6 00 01             	testb  $0x1,(%eax)
80106fa3:	75 45                	jne    80106fea <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106fa5:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106fa8:	83 cb 01             	or     $0x1,%ebx
80106fab:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106fad:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106fb0:	74 2e                	je     80106fe0 <mappages+0x70>
      break;
    a += PGSIZE;
80106fb2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106fb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106fbb:	b9 01 00 00 00       	mov    $0x1,%ecx
80106fc0:	89 f2                	mov    %esi,%edx
80106fc2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106fc5:	89 f8                	mov    %edi,%eax
80106fc7:	e8 24 ff ff ff       	call   80106ef0 <walkpgdir>
80106fcc:	85 c0                	test   %eax,%eax
80106fce:	75 d0                	jne    80106fa0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106fd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fd8:	5b                   	pop    %ebx
80106fd9:	5e                   	pop    %esi
80106fda:	5f                   	pop    %edi
80106fdb:	5d                   	pop    %ebp
80106fdc:	c3                   	ret    
80106fdd:	8d 76 00             	lea    0x0(%esi),%esi
80106fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106fe3:	31 c0                	xor    %eax,%eax
}
80106fe5:	5b                   	pop    %ebx
80106fe6:	5e                   	pop    %esi
80106fe7:	5f                   	pop    %edi
80106fe8:	5d                   	pop    %ebp
80106fe9:	c3                   	ret    
      panic("remap");
80106fea:	83 ec 0c             	sub    $0xc,%esp
80106fed:	68 1c 81 10 80       	push   $0x8010811c
80106ff2:	e8 99 93 ff ff       	call   80100390 <panic>
80106ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ffe:	66 90                	xchg   %ax,%ax

80107000 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	57                   	push   %edi
80107004:	56                   	push   %esi
80107005:	89 c6                	mov    %eax,%esi
80107007:	53                   	push   %ebx
80107008:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010700a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107010:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107016:	83 ec 1c             	sub    $0x1c,%esp
80107019:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010701c:	39 da                	cmp    %ebx,%edx
8010701e:	73 5b                	jae    8010707b <deallocuvm.part.0+0x7b>
80107020:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107023:	89 d7                	mov    %edx,%edi
80107025:	eb 14                	jmp    8010703b <deallocuvm.part.0+0x3b>
80107027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010702e:	66 90                	xchg   %ax,%ax
80107030:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107036:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107039:	76 40                	jbe    8010707b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010703b:	31 c9                	xor    %ecx,%ecx
8010703d:	89 fa                	mov    %edi,%edx
8010703f:	89 f0                	mov    %esi,%eax
80107041:	e8 aa fe ff ff       	call   80106ef0 <walkpgdir>
80107046:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107048:	85 c0                	test   %eax,%eax
8010704a:	74 44                	je     80107090 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010704c:	8b 00                	mov    (%eax),%eax
8010704e:	a8 01                	test   $0x1,%al
80107050:	74 de                	je     80107030 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107052:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107057:	74 47                	je     801070a0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107059:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010705c:	05 00 00 00 80       	add    $0x80000000,%eax
80107061:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107067:	50                   	push   %eax
80107068:	e8 03 b4 ff ff       	call   80102470 <kfree>
      *pte = 0;
8010706d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107073:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107076:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107079:	77 c0                	ja     8010703b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010707b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010707e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107081:	5b                   	pop    %ebx
80107082:	5e                   	pop    %esi
80107083:	5f                   	pop    %edi
80107084:	5d                   	pop    %ebp
80107085:	c3                   	ret    
80107086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010708d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107090:	89 fa                	mov    %edi,%edx
80107092:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107098:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010709e:	eb 96                	jmp    80107036 <deallocuvm.part.0+0x36>
        panic("kfree");
801070a0:	83 ec 0c             	sub    $0xc,%esp
801070a3:	68 a6 7a 10 80       	push   $0x80107aa6
801070a8:	e8 e3 92 ff ff       	call   80100390 <panic>
801070ad:	8d 76 00             	lea    0x0(%esi),%esi

801070b0 <seginit>:
{
801070b0:	f3 0f 1e fb          	endbr32 
801070b4:	55                   	push   %ebp
801070b5:	89 e5                	mov    %esp,%ebp
801070b7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801070ba:	e8 41 ca ff ff       	call   80103b00 <cpuid>
  pd[0] = size-1;
801070bf:	ba 2f 00 00 00       	mov    $0x2f,%edx
801070c4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801070ca:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070ce:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
801070d5:	ff 00 00 
801070d8:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
801070df:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070e2:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
801070e9:	ff 00 00 
801070ec:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
801070f3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070f6:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
801070fd:	ff 00 00 
80107100:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80107107:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010710a:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80107111:	ff 00 00 
80107114:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
8010711b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010711e:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80107123:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107127:	c1 e8 10             	shr    $0x10,%eax
8010712a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010712e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107131:	0f 01 10             	lgdtl  (%eax)
}
80107134:	c9                   	leave  
80107135:	c3                   	ret    
80107136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713d:	8d 76 00             	lea    0x0(%esi),%esi

80107140 <switchkvm>:
{
80107140:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107144:	a1 a4 6c 11 80       	mov    0x80116ca4,%eax
80107149:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010714e:	0f 22 d8             	mov    %eax,%cr3
}
80107151:	c3                   	ret    
80107152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107160 <switchuvm>:
{
80107160:	f3 0f 1e fb          	endbr32 
80107164:	55                   	push   %ebp
80107165:	89 e5                	mov    %esp,%ebp
80107167:	57                   	push   %edi
80107168:	56                   	push   %esi
80107169:	53                   	push   %ebx
8010716a:	83 ec 1c             	sub    $0x1c,%esp
8010716d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107170:	85 f6                	test   %esi,%esi
80107172:	0f 84 cb 00 00 00    	je     80107243 <switchuvm+0xe3>
  if(p->kstack == 0)
80107178:	8b 46 08             	mov    0x8(%esi),%eax
8010717b:	85 c0                	test   %eax,%eax
8010717d:	0f 84 da 00 00 00    	je     8010725d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107183:	8b 46 04             	mov    0x4(%esi),%eax
80107186:	85 c0                	test   %eax,%eax
80107188:	0f 84 c2 00 00 00    	je     80107250 <switchuvm+0xf0>
  pushcli();
8010718e:	e8 1d d9 ff ff       	call   80104ab0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107193:	e8 f8 c8 ff ff       	call   80103a90 <mycpu>
80107198:	89 c3                	mov    %eax,%ebx
8010719a:	e8 f1 c8 ff ff       	call   80103a90 <mycpu>
8010719f:	89 c7                	mov    %eax,%edi
801071a1:	e8 ea c8 ff ff       	call   80103a90 <mycpu>
801071a6:	83 c7 08             	add    $0x8,%edi
801071a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071ac:	e8 df c8 ff ff       	call   80103a90 <mycpu>
801071b1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071b4:	ba 67 00 00 00       	mov    $0x67,%edx
801071b9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801071c0:	83 c0 08             	add    $0x8,%eax
801071c3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071ca:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071cf:	83 c1 08             	add    $0x8,%ecx
801071d2:	c1 e8 18             	shr    $0x18,%eax
801071d5:	c1 e9 10             	shr    $0x10,%ecx
801071d8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801071de:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801071e4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801071e9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801071f0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801071f5:	e8 96 c8 ff ff       	call   80103a90 <mycpu>
801071fa:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107201:	e8 8a c8 ff ff       	call   80103a90 <mycpu>
80107206:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010720a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010720d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107213:	e8 78 c8 ff ff       	call   80103a90 <mycpu>
80107218:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010721b:	e8 70 c8 ff ff       	call   80103a90 <mycpu>
80107220:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107224:	b8 28 00 00 00       	mov    $0x28,%eax
80107229:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010722c:	8b 46 04             	mov    0x4(%esi),%eax
8010722f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107234:	0f 22 d8             	mov    %eax,%cr3
}
80107237:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010723a:	5b                   	pop    %ebx
8010723b:	5e                   	pop    %esi
8010723c:	5f                   	pop    %edi
8010723d:	5d                   	pop    %ebp
  popcli();
8010723e:	e9 bd d8 ff ff       	jmp    80104b00 <popcli>
    panic("switchuvm: no process");
80107243:	83 ec 0c             	sub    $0xc,%esp
80107246:	68 22 81 10 80       	push   $0x80108122
8010724b:	e8 40 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107250:	83 ec 0c             	sub    $0xc,%esp
80107253:	68 4d 81 10 80       	push   $0x8010814d
80107258:	e8 33 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010725d:	83 ec 0c             	sub    $0xc,%esp
80107260:	68 38 81 10 80       	push   $0x80108138
80107265:	e8 26 91 ff ff       	call   80100390 <panic>
8010726a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107270 <inituvm>:
{
80107270:	f3 0f 1e fb          	endbr32 
80107274:	55                   	push   %ebp
80107275:	89 e5                	mov    %esp,%ebp
80107277:	57                   	push   %edi
80107278:	56                   	push   %esi
80107279:	53                   	push   %ebx
8010727a:	83 ec 1c             	sub    $0x1c,%esp
8010727d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107280:	8b 75 10             	mov    0x10(%ebp),%esi
80107283:	8b 7d 08             	mov    0x8(%ebp),%edi
80107286:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107289:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010728f:	77 4b                	ja     801072dc <inituvm+0x6c>
  mem = kalloc();
80107291:	e8 9a b3 ff ff       	call   80102630 <kalloc>
  memset(mem, 0, PGSIZE);
80107296:	83 ec 04             	sub    $0x4,%esp
80107299:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010729e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801072a0:	6a 00                	push   $0x0
801072a2:	50                   	push   %eax
801072a3:	e8 18 da ff ff       	call   80104cc0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801072a8:	58                   	pop    %eax
801072a9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072af:	5a                   	pop    %edx
801072b0:	6a 06                	push   $0x6
801072b2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072b7:	31 d2                	xor    %edx,%edx
801072b9:	50                   	push   %eax
801072ba:	89 f8                	mov    %edi,%eax
801072bc:	e8 af fc ff ff       	call   80106f70 <mappages>
  memmove(mem, init, sz);
801072c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072c4:	89 75 10             	mov    %esi,0x10(%ebp)
801072c7:	83 c4 10             	add    $0x10,%esp
801072ca:	89 5d 08             	mov    %ebx,0x8(%ebp)
801072cd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801072d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072d3:	5b                   	pop    %ebx
801072d4:	5e                   	pop    %esi
801072d5:	5f                   	pop    %edi
801072d6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801072d7:	e9 84 da ff ff       	jmp    80104d60 <memmove>
    panic("inituvm: more than a page");
801072dc:	83 ec 0c             	sub    $0xc,%esp
801072df:	68 61 81 10 80       	push   $0x80108161
801072e4:	e8 a7 90 ff ff       	call   80100390 <panic>
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072f0 <loaduvm>:
{
801072f0:	f3 0f 1e fb          	endbr32 
801072f4:	55                   	push   %ebp
801072f5:	89 e5                	mov    %esp,%ebp
801072f7:	57                   	push   %edi
801072f8:	56                   	push   %esi
801072f9:	53                   	push   %ebx
801072fa:	83 ec 1c             	sub    $0x1c,%esp
801072fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80107300:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107303:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107308:	0f 85 99 00 00 00    	jne    801073a7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010730e:	01 f0                	add    %esi,%eax
80107310:	89 f3                	mov    %esi,%ebx
80107312:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107315:	8b 45 14             	mov    0x14(%ebp),%eax
80107318:	01 f0                	add    %esi,%eax
8010731a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010731d:	85 f6                	test   %esi,%esi
8010731f:	75 15                	jne    80107336 <loaduvm+0x46>
80107321:	eb 6d                	jmp    80107390 <loaduvm+0xa0>
80107323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107327:	90                   	nop
80107328:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010732e:	89 f0                	mov    %esi,%eax
80107330:	29 d8                	sub    %ebx,%eax
80107332:	39 c6                	cmp    %eax,%esi
80107334:	76 5a                	jbe    80107390 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107336:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107339:	8b 45 08             	mov    0x8(%ebp),%eax
8010733c:	31 c9                	xor    %ecx,%ecx
8010733e:	29 da                	sub    %ebx,%edx
80107340:	e8 ab fb ff ff       	call   80106ef0 <walkpgdir>
80107345:	85 c0                	test   %eax,%eax
80107347:	74 51                	je     8010739a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107349:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010734b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010734e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107353:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107358:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010735e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107361:	29 d9                	sub    %ebx,%ecx
80107363:	05 00 00 00 80       	add    $0x80000000,%eax
80107368:	57                   	push   %edi
80107369:	51                   	push   %ecx
8010736a:	50                   	push   %eax
8010736b:	ff 75 10             	pushl  0x10(%ebp)
8010736e:	e8 ed a6 ff ff       	call   80101a60 <readi>
80107373:	83 c4 10             	add    $0x10,%esp
80107376:	39 f8                	cmp    %edi,%eax
80107378:	74 ae                	je     80107328 <loaduvm+0x38>
}
8010737a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010737d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107382:	5b                   	pop    %ebx
80107383:	5e                   	pop    %esi
80107384:	5f                   	pop    %edi
80107385:	5d                   	pop    %ebp
80107386:	c3                   	ret    
80107387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010738e:	66 90                	xchg   %ax,%ax
80107390:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107393:	31 c0                	xor    %eax,%eax
}
80107395:	5b                   	pop    %ebx
80107396:	5e                   	pop    %esi
80107397:	5f                   	pop    %edi
80107398:	5d                   	pop    %ebp
80107399:	c3                   	ret    
      panic("loaduvm: address should exist");
8010739a:	83 ec 0c             	sub    $0xc,%esp
8010739d:	68 7b 81 10 80       	push   $0x8010817b
801073a2:	e8 e9 8f ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801073a7:	83 ec 0c             	sub    $0xc,%esp
801073aa:	68 1c 82 10 80       	push   $0x8010821c
801073af:	e8 dc 8f ff ff       	call   80100390 <panic>
801073b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073bf:	90                   	nop

801073c0 <allocuvm>:
{
801073c0:	f3 0f 1e fb          	endbr32 
801073c4:	55                   	push   %ebp
801073c5:	89 e5                	mov    %esp,%ebp
801073c7:	57                   	push   %edi
801073c8:	56                   	push   %esi
801073c9:	53                   	push   %ebx
801073ca:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801073cd:	8b 45 10             	mov    0x10(%ebp),%eax
{
801073d0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801073d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801073d6:	85 c0                	test   %eax,%eax
801073d8:	0f 88 b2 00 00 00    	js     80107490 <allocuvm+0xd0>
  if(newsz < oldsz)
801073de:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801073e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801073e4:	0f 82 96 00 00 00    	jb     80107480 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801073ea:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801073f0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801073f6:	39 75 10             	cmp    %esi,0x10(%ebp)
801073f9:	77 40                	ja     8010743b <allocuvm+0x7b>
801073fb:	e9 83 00 00 00       	jmp    80107483 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107400:	83 ec 04             	sub    $0x4,%esp
80107403:	68 00 10 00 00       	push   $0x1000
80107408:	6a 00                	push   $0x0
8010740a:	50                   	push   %eax
8010740b:	e8 b0 d8 ff ff       	call   80104cc0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107410:	58                   	pop    %eax
80107411:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107417:	5a                   	pop    %edx
80107418:	6a 06                	push   $0x6
8010741a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010741f:	89 f2                	mov    %esi,%edx
80107421:	50                   	push   %eax
80107422:	89 f8                	mov    %edi,%eax
80107424:	e8 47 fb ff ff       	call   80106f70 <mappages>
80107429:	83 c4 10             	add    $0x10,%esp
8010742c:	85 c0                	test   %eax,%eax
8010742e:	78 78                	js     801074a8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107430:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107436:	39 75 10             	cmp    %esi,0x10(%ebp)
80107439:	76 48                	jbe    80107483 <allocuvm+0xc3>
    mem = kalloc();
8010743b:	e8 f0 b1 ff ff       	call   80102630 <kalloc>
80107440:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107442:	85 c0                	test   %eax,%eax
80107444:	75 ba                	jne    80107400 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107446:	83 ec 0c             	sub    $0xc,%esp
80107449:	68 99 81 10 80       	push   $0x80108199
8010744e:	e8 5d 92 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107453:	8b 45 0c             	mov    0xc(%ebp),%eax
80107456:	83 c4 10             	add    $0x10,%esp
80107459:	39 45 10             	cmp    %eax,0x10(%ebp)
8010745c:	74 32                	je     80107490 <allocuvm+0xd0>
8010745e:	8b 55 10             	mov    0x10(%ebp),%edx
80107461:	89 c1                	mov    %eax,%ecx
80107463:	89 f8                	mov    %edi,%eax
80107465:	e8 96 fb ff ff       	call   80107000 <deallocuvm.part.0>
      return 0;
8010746a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107474:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107477:	5b                   	pop    %ebx
80107478:	5e                   	pop    %esi
80107479:	5f                   	pop    %edi
8010747a:	5d                   	pop    %ebp
8010747b:	c3                   	ret    
8010747c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107486:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107489:	5b                   	pop    %ebx
8010748a:	5e                   	pop    %esi
8010748b:	5f                   	pop    %edi
8010748c:	5d                   	pop    %ebp
8010748d:	c3                   	ret    
8010748e:	66 90                	xchg   %ax,%ax
    return 0;
80107490:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107497:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010749a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010749d:	5b                   	pop    %ebx
8010749e:	5e                   	pop    %esi
8010749f:	5f                   	pop    %edi
801074a0:	5d                   	pop    %ebp
801074a1:	c3                   	ret    
801074a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801074a8:	83 ec 0c             	sub    $0xc,%esp
801074ab:	68 b1 81 10 80       	push   $0x801081b1
801074b0:	e8 fb 91 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801074b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801074b8:	83 c4 10             	add    $0x10,%esp
801074bb:	39 45 10             	cmp    %eax,0x10(%ebp)
801074be:	74 0c                	je     801074cc <allocuvm+0x10c>
801074c0:	8b 55 10             	mov    0x10(%ebp),%edx
801074c3:	89 c1                	mov    %eax,%ecx
801074c5:	89 f8                	mov    %edi,%eax
801074c7:	e8 34 fb ff ff       	call   80107000 <deallocuvm.part.0>
      kfree(mem);
801074cc:	83 ec 0c             	sub    $0xc,%esp
801074cf:	53                   	push   %ebx
801074d0:	e8 9b af ff ff       	call   80102470 <kfree>
      return 0;
801074d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801074dc:	83 c4 10             	add    $0x10,%esp
}
801074df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074e5:	5b                   	pop    %ebx
801074e6:	5e                   	pop    %esi
801074e7:	5f                   	pop    %edi
801074e8:	5d                   	pop    %ebp
801074e9:	c3                   	ret    
801074ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074f0 <deallocuvm>:
{
801074f0:	f3 0f 1e fb          	endbr32 
801074f4:	55                   	push   %ebp
801074f5:	89 e5                	mov    %esp,%ebp
801074f7:	8b 55 0c             	mov    0xc(%ebp),%edx
801074fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
801074fd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107500:	39 d1                	cmp    %edx,%ecx
80107502:	73 0c                	jae    80107510 <deallocuvm+0x20>
}
80107504:	5d                   	pop    %ebp
80107505:	e9 f6 fa ff ff       	jmp    80107000 <deallocuvm.part.0>
8010750a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107510:	89 d0                	mov    %edx,%eax
80107512:	5d                   	pop    %ebp
80107513:	c3                   	ret    
80107514:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010751b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010751f:	90                   	nop

80107520 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107520:	f3 0f 1e fb          	endbr32 
80107524:	55                   	push   %ebp
80107525:	89 e5                	mov    %esp,%ebp
80107527:	57                   	push   %edi
80107528:	56                   	push   %esi
80107529:	53                   	push   %ebx
8010752a:	83 ec 0c             	sub    $0xc,%esp
8010752d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107530:	85 f6                	test   %esi,%esi
80107532:	74 55                	je     80107589 <freevm+0x69>
  if(newsz >= oldsz)
80107534:	31 c9                	xor    %ecx,%ecx
80107536:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010753b:	89 f0                	mov    %esi,%eax
8010753d:	89 f3                	mov    %esi,%ebx
8010753f:	e8 bc fa ff ff       	call   80107000 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107544:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010754a:	eb 0b                	jmp    80107557 <freevm+0x37>
8010754c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107550:	83 c3 04             	add    $0x4,%ebx
80107553:	39 df                	cmp    %ebx,%edi
80107555:	74 23                	je     8010757a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107557:	8b 03                	mov    (%ebx),%eax
80107559:	a8 01                	test   $0x1,%al
8010755b:	74 f3                	je     80107550 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010755d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107562:	83 ec 0c             	sub    $0xc,%esp
80107565:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107568:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010756d:	50                   	push   %eax
8010756e:	e8 fd ae ff ff       	call   80102470 <kfree>
80107573:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107576:	39 df                	cmp    %ebx,%edi
80107578:	75 dd                	jne    80107557 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010757a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010757d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107580:	5b                   	pop    %ebx
80107581:	5e                   	pop    %esi
80107582:	5f                   	pop    %edi
80107583:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107584:	e9 e7 ae ff ff       	jmp    80102470 <kfree>
    panic("freevm: no pgdir");
80107589:	83 ec 0c             	sub    $0xc,%esp
8010758c:	68 cd 81 10 80       	push   $0x801081cd
80107591:	e8 fa 8d ff ff       	call   80100390 <panic>
80107596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010759d:	8d 76 00             	lea    0x0(%esi),%esi

801075a0 <setupkvm>:
{
801075a0:	f3 0f 1e fb          	endbr32 
801075a4:	55                   	push   %ebp
801075a5:	89 e5                	mov    %esp,%ebp
801075a7:	56                   	push   %esi
801075a8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801075a9:	e8 82 b0 ff ff       	call   80102630 <kalloc>
801075ae:	89 c6                	mov    %eax,%esi
801075b0:	85 c0                	test   %eax,%eax
801075b2:	74 42                	je     801075f6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801075b4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075b7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801075bc:	68 00 10 00 00       	push   $0x1000
801075c1:	6a 00                	push   $0x0
801075c3:	50                   	push   %eax
801075c4:	e8 f7 d6 ff ff       	call   80104cc0 <memset>
801075c9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801075cc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801075cf:	83 ec 08             	sub    $0x8,%esp
801075d2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801075d5:	ff 73 0c             	pushl  0xc(%ebx)
801075d8:	8b 13                	mov    (%ebx),%edx
801075da:	50                   	push   %eax
801075db:	29 c1                	sub    %eax,%ecx
801075dd:	89 f0                	mov    %esi,%eax
801075df:	e8 8c f9 ff ff       	call   80106f70 <mappages>
801075e4:	83 c4 10             	add    $0x10,%esp
801075e7:	85 c0                	test   %eax,%eax
801075e9:	78 15                	js     80107600 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075eb:	83 c3 10             	add    $0x10,%ebx
801075ee:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801075f4:	75 d6                	jne    801075cc <setupkvm+0x2c>
}
801075f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075f9:	89 f0                	mov    %esi,%eax
801075fb:	5b                   	pop    %ebx
801075fc:	5e                   	pop    %esi
801075fd:	5d                   	pop    %ebp
801075fe:	c3                   	ret    
801075ff:	90                   	nop
      freevm(pgdir);
80107600:	83 ec 0c             	sub    $0xc,%esp
80107603:	56                   	push   %esi
      return 0;
80107604:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107606:	e8 15 ff ff ff       	call   80107520 <freevm>
      return 0;
8010760b:	83 c4 10             	add    $0x10,%esp
}
8010760e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107611:	89 f0                	mov    %esi,%eax
80107613:	5b                   	pop    %ebx
80107614:	5e                   	pop    %esi
80107615:	5d                   	pop    %ebp
80107616:	c3                   	ret    
80107617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010761e:	66 90                	xchg   %ax,%ax

80107620 <kvmalloc>:
{
80107620:	f3 0f 1e fb          	endbr32 
80107624:	55                   	push   %ebp
80107625:	89 e5                	mov    %esp,%ebp
80107627:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010762a:	e8 71 ff ff ff       	call   801075a0 <setupkvm>
8010762f:	a3 a4 6c 11 80       	mov    %eax,0x80116ca4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107634:	05 00 00 00 80       	add    $0x80000000,%eax
80107639:	0f 22 d8             	mov    %eax,%cr3
}
8010763c:	c9                   	leave  
8010763d:	c3                   	ret    
8010763e:	66 90                	xchg   %ax,%ax

80107640 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107640:	f3 0f 1e fb          	endbr32 
80107644:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107645:	31 c9                	xor    %ecx,%ecx
{
80107647:	89 e5                	mov    %esp,%ebp
80107649:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010764c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010764f:	8b 45 08             	mov    0x8(%ebp),%eax
80107652:	e8 99 f8 ff ff       	call   80106ef0 <walkpgdir>
  if(pte == 0)
80107657:	85 c0                	test   %eax,%eax
80107659:	74 05                	je     80107660 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010765b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010765e:	c9                   	leave  
8010765f:	c3                   	ret    
    panic("clearpteu");
80107660:	83 ec 0c             	sub    $0xc,%esp
80107663:	68 de 81 10 80       	push   $0x801081de
80107668:	e8 23 8d ff ff       	call   80100390 <panic>
8010766d:	8d 76 00             	lea    0x0(%esi),%esi

80107670 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107670:	f3 0f 1e fb          	endbr32 
80107674:	55                   	push   %ebp
80107675:	89 e5                	mov    %esp,%ebp
80107677:	57                   	push   %edi
80107678:	56                   	push   %esi
80107679:	53                   	push   %ebx
8010767a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010767d:	e8 1e ff ff ff       	call   801075a0 <setupkvm>
80107682:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107685:	85 c0                	test   %eax,%eax
80107687:	0f 84 9b 00 00 00    	je     80107728 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010768d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107690:	85 c9                	test   %ecx,%ecx
80107692:	0f 84 90 00 00 00    	je     80107728 <copyuvm+0xb8>
80107698:	31 f6                	xor    %esi,%esi
8010769a:	eb 46                	jmp    801076e2 <copyuvm+0x72>
8010769c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801076a0:	83 ec 04             	sub    $0x4,%esp
801076a3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801076a9:	68 00 10 00 00       	push   $0x1000
801076ae:	57                   	push   %edi
801076af:	50                   	push   %eax
801076b0:	e8 ab d6 ff ff       	call   80104d60 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801076b5:	58                   	pop    %eax
801076b6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801076bc:	5a                   	pop    %edx
801076bd:	ff 75 e4             	pushl  -0x1c(%ebp)
801076c0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076c5:	89 f2                	mov    %esi,%edx
801076c7:	50                   	push   %eax
801076c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076cb:	e8 a0 f8 ff ff       	call   80106f70 <mappages>
801076d0:	83 c4 10             	add    $0x10,%esp
801076d3:	85 c0                	test   %eax,%eax
801076d5:	78 61                	js     80107738 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801076d7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801076dd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801076e0:	76 46                	jbe    80107728 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801076e2:	8b 45 08             	mov    0x8(%ebp),%eax
801076e5:	31 c9                	xor    %ecx,%ecx
801076e7:	89 f2                	mov    %esi,%edx
801076e9:	e8 02 f8 ff ff       	call   80106ef0 <walkpgdir>
801076ee:	85 c0                	test   %eax,%eax
801076f0:	74 61                	je     80107753 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801076f2:	8b 00                	mov    (%eax),%eax
801076f4:	a8 01                	test   $0x1,%al
801076f6:	74 4e                	je     80107746 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801076f8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801076fa:	25 ff 0f 00 00       	and    $0xfff,%eax
801076ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107702:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107708:	e8 23 af ff ff       	call   80102630 <kalloc>
8010770d:	89 c3                	mov    %eax,%ebx
8010770f:	85 c0                	test   %eax,%eax
80107711:	75 8d                	jne    801076a0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107713:	83 ec 0c             	sub    $0xc,%esp
80107716:	ff 75 e0             	pushl  -0x20(%ebp)
80107719:	e8 02 fe ff ff       	call   80107520 <freevm>
  return 0;
8010771e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107725:	83 c4 10             	add    $0x10,%esp
}
80107728:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010772b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010772e:	5b                   	pop    %ebx
8010772f:	5e                   	pop    %esi
80107730:	5f                   	pop    %edi
80107731:	5d                   	pop    %ebp
80107732:	c3                   	ret    
80107733:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107737:	90                   	nop
      kfree(mem);
80107738:	83 ec 0c             	sub    $0xc,%esp
8010773b:	53                   	push   %ebx
8010773c:	e8 2f ad ff ff       	call   80102470 <kfree>
      goto bad;
80107741:	83 c4 10             	add    $0x10,%esp
80107744:	eb cd                	jmp    80107713 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107746:	83 ec 0c             	sub    $0xc,%esp
80107749:	68 02 82 10 80       	push   $0x80108202
8010774e:	e8 3d 8c ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107753:	83 ec 0c             	sub    $0xc,%esp
80107756:	68 e8 81 10 80       	push   $0x801081e8
8010775b:	e8 30 8c ff ff       	call   80100390 <panic>

80107760 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107760:	f3 0f 1e fb          	endbr32 
80107764:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107765:	31 c9                	xor    %ecx,%ecx
{
80107767:	89 e5                	mov    %esp,%ebp
80107769:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010776c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010776f:	8b 45 08             	mov    0x8(%ebp),%eax
80107772:	e8 79 f7 ff ff       	call   80106ef0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107777:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107779:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010777a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010777c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107781:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107784:	05 00 00 00 80       	add    $0x80000000,%eax
80107789:	83 fa 05             	cmp    $0x5,%edx
8010778c:	ba 00 00 00 00       	mov    $0x0,%edx
80107791:	0f 45 c2             	cmovne %edx,%eax
}
80107794:	c3                   	ret    
80107795:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010779c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801077a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801077a0:	f3 0f 1e fb          	endbr32 
801077a4:	55                   	push   %ebp
801077a5:	89 e5                	mov    %esp,%ebp
801077a7:	57                   	push   %edi
801077a8:	56                   	push   %esi
801077a9:	53                   	push   %ebx
801077aa:	83 ec 0c             	sub    $0xc,%esp
801077ad:	8b 75 14             	mov    0x14(%ebp),%esi
801077b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801077b3:	85 f6                	test   %esi,%esi
801077b5:	75 3c                	jne    801077f3 <copyout+0x53>
801077b7:	eb 67                	jmp    80107820 <copyout+0x80>
801077b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801077c0:	8b 55 0c             	mov    0xc(%ebp),%edx
801077c3:	89 fb                	mov    %edi,%ebx
801077c5:	29 d3                	sub    %edx,%ebx
801077c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801077cd:	39 f3                	cmp    %esi,%ebx
801077cf:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801077d2:	29 fa                	sub    %edi,%edx
801077d4:	83 ec 04             	sub    $0x4,%esp
801077d7:	01 c2                	add    %eax,%edx
801077d9:	53                   	push   %ebx
801077da:	ff 75 10             	pushl  0x10(%ebp)
801077dd:	52                   	push   %edx
801077de:	e8 7d d5 ff ff       	call   80104d60 <memmove>
    len -= n;
    buf += n;
801077e3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801077e6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801077ec:	83 c4 10             	add    $0x10,%esp
801077ef:	29 de                	sub    %ebx,%esi
801077f1:	74 2d                	je     80107820 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801077f3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801077f5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801077f8:	89 55 0c             	mov    %edx,0xc(%ebp)
801077fb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107801:	57                   	push   %edi
80107802:	ff 75 08             	pushl  0x8(%ebp)
80107805:	e8 56 ff ff ff       	call   80107760 <uva2ka>
    if(pa0 == 0)
8010780a:	83 c4 10             	add    $0x10,%esp
8010780d:	85 c0                	test   %eax,%eax
8010780f:	75 af                	jne    801077c0 <copyout+0x20>
  }
  return 0;
}
80107811:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107814:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107819:	5b                   	pop    %ebx
8010781a:	5e                   	pop    %esi
8010781b:	5f                   	pop    %edi
8010781c:	5d                   	pop    %ebp
8010781d:	c3                   	ret    
8010781e:	66 90                	xchg   %ax,%ax
80107820:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107823:	31 c0                	xor    %eax,%eax
}
80107825:	5b                   	pop    %ebx
80107826:	5e                   	pop    %esi
80107827:	5f                   	pop    %edi
80107828:	5d                   	pop    %ebp
80107829:	c3                   	ret    
