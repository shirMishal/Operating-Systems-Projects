
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
8010002d:	b8 70 30 10 80       	mov    $0x80103070,%eax
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
80100050:	68 c0 77 10 80       	push   $0x801077c0
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 91 49 00 00       	call   801049f0 <initlock>
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
80100092:	68 c7 77 10 80       	push   $0x801077c7
80100097:	50                   	push   %eax
80100098:	e8 13 48 00 00       	call   801048b0 <initsleeplock>
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
801000e8:	e8 83 4a 00 00       	call   80104b70 <acquire>
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
80100162:	e8 c9 4a 00 00       	call   80104c30 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 47 00 00       	call   801048f0 <acquiresleep>
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
8010018c:	e8 1f 21 00 00       	call   801022b0 <iderw>
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
801001a3:	68 ce 77 10 80       	push   $0x801077ce
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
801001c2:	e8 c9 47 00 00       	call   80104990 <holdingsleep>
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
801001d8:	e9 d3 20 00 00       	jmp    801022b0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 df 77 10 80       	push   $0x801077df
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
80100203:	e8 88 47 00 00       	call   80104990 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 38 47 00 00       	call   80104950 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 4c 49 00 00       	call   80104b70 <acquire>
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
80100270:	e9 bb 49 00 00       	jmp    80104c30 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 e6 77 10 80       	push   $0x801077e6
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
801002a5:	e8 c6 15 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 ba 48 00 00       	call   80104b70 <acquire>
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
801002e5:	e8 e6 3e 00 00       	call   801041d0 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 31 36 00 00       	call   80103930 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 1d 49 00 00       	call   80104c30 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 74 14 00 00       	call   80101790 <ilock>
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
80100365:	e8 c6 48 00 00       	call   80104c30 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 1d 14 00 00       	call   80101790 <ilock>
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
801003ad:	e8 1e 25 00 00       	call   801028d0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ed 77 10 80       	push   $0x801077ed
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 83 82 10 80 	movl   $0x80108283,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 2f 46 00 00       	call   80104a10 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 01 78 10 80       	push   $0x80107801
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
8010042a:	e8 91 5f 00 00       	call   801063c0 <uartputc>
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
80100515:	e8 a6 5e 00 00       	call   801063c0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 9a 5e 00 00       	call   801063c0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 8e 5e 00 00       	call   801063c0 <uartputc>
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
80100561:	e8 ba 47 00 00       	call   80104d20 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 05 47 00 00       	call   80104c80 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 05 78 10 80       	push   $0x80107805
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
801005c9:	0f b6 92 30 78 10 80 	movzbl -0x7fef87d0(%edx),%edx
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
80100653:	e8 18 12 00 00       	call   80101870 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 0c 45 00 00       	call   80104b70 <acquire>
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
80100697:	e8 94 45 00 00       	call   80104c30 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 eb 10 00 00       	call   80101790 <ilock>

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
8010077d:	bb 18 78 10 80       	mov    $0x80107818,%ebx
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
801007bd:	e8 ae 43 00 00       	call   80104b70 <acquire>
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
80100828:	e8 03 44 00 00       	call   80104c30 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 1f 78 10 80       	push   $0x8010781f
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
80100877:	e8 f4 42 00 00       	call   80104b70 <acquire>
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
801009cf:	e8 5c 42 00 00       	call   80104c30 <release>
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
801009ff:	e9 8c 3a 00 00       	jmp    80104490 <procdump>
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
80100a20:	e8 6b 39 00 00       	call   80104390 <wakeup>
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
80100a3a:	68 28 78 10 80       	push   $0x80107828
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 a7 3f 00 00       	call   801049f0 <initlock>

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
80100a6d:	e8 ee 19 00 00       	call   80102460 <ioapicenable>
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
80100a90:	e8 9b 2e 00 00       	call   80103930 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 c0 22 00 00       	call   80102d60 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 b5 15 00 00       	call   80102060 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 2b 03 00 00    	je     80100de1 <exec+0x361>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 cf 0c 00 00       	call   80101790 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 be 0f 00 00       	call   80101a90 <readi>
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
80100ade:	e8 4d 0f 00 00       	call   80101a30 <iunlockput>
    end_op();
80100ae3:	e8 e8 22 00 00       	call   80102dd0 <end_op>
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
80100b0c:	e8 1f 6a 00 00       	call   80107530 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 d1 02 00 00    	je     80100e00 <exec+0x380>
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
80100b73:	e8 d8 67 00 00       	call   80107350 <allocuvm>
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
80100ba9:	e8 d2 66 00 00       	call   80107280 <loaduvm>
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
80100bd1:	e8 ba 0e 00 00       	call   80101a90 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 c0 68 00 00       	call   801074b0 <freevm>
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
80100c1c:	e8 0f 0e 00 00       	call   80101a30 <iunlockput>
  end_op();
80100c21:	e8 aa 21 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 19 67 00 00       	call   80107350 <allocuvm>
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
80100c53:	e8 78 69 00 00       	call   801075d0 <clearpteu>
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
80100ca3:	e8 d8 41 00 00       	call   80104e80 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 c5 41 00 00       	call   80104e80 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 64 6a 00 00       	call   80107730 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 ca 67 00 00       	call   801074b0 <freevm>
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
80100d33:	e8 f8 69 00 00       	call   80107730 <copyout>
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
80100d6a:	8d 47 6c             	lea    0x6c(%edi),%eax
80100d6d:	52                   	push   %edx
80100d6e:	50                   	push   %eax
80100d6f:	e8 cc 40 00 00       	call   80104e40 <safestrcpy>
  curproc->pgdir = pgdir;
80100d74:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d7a:	89 f9                	mov    %edi,%ecx
80100d7c:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d7f:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d82:	89 31                	mov    %esi,(%ecx)
80100d84:	83 c4 10             	add    $0x10,%esp
  curproc->pgdir = pgdir;
80100d87:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d8a:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d90:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d93:	8b 41 18             	mov    0x18(%ecx),%eax
80100d96:	8d 91 90 01 00 00    	lea    0x190(%ecx),%edx
80100d9c:	89 58 44             	mov    %ebx,0x44(%eax)
  for (int i = 0; i < 32; i++){
80100d9f:	8d 81 90 00 00 00    	lea    0x90(%ecx),%eax
80100da5:	8d 76 00             	lea    0x0(%esi),%esi
    if ((int)(curproc->signal_handlers[i].sa_handler) != SIG_IGN){
80100da8:	83 38 01             	cmpl   $0x1,(%eax)
80100dab:	74 0d                	je     80100dba <exec+0x33a>
      curproc->signal_handlers[i].sa_handler = SIG_DFL;
80100dad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      curproc->signal_handlers[i].sigmask = 0;
80100db3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  for (int i = 0; i < 32; i++){
80100dba:	83 c0 08             	add    $0x8,%eax
80100dbd:	39 c2                	cmp    %eax,%edx
80100dbf:	75 e7                	jne    80100da8 <exec+0x328>
  switchuvm(curproc);
80100dc1:	83 ec 0c             	sub    $0xc,%esp
80100dc4:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100dca:	e8 21 63 00 00       	call   801070f0 <switchuvm>
  freevm(oldpgdir);
80100dcf:	89 3c 24             	mov    %edi,(%esp)
80100dd2:	e8 d9 66 00 00       	call   801074b0 <freevm>
  return 0;
80100dd7:	83 c4 10             	add    $0x10,%esp
80100dda:	31 c0                	xor    %eax,%eax
80100ddc:	e9 0f fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100de1:	e8 ea 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de6:	83 ec 0c             	sub    $0xc,%esp
80100de9:	68 41 78 10 80       	push   $0x80107841
80100dee:	e8 bd f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100df3:	83 c4 10             	add    $0x10,%esp
80100df6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfb:	e9 f0 fc ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e00:	31 ff                	xor    %edi,%edi
80100e02:	be 00 20 00 00       	mov    $0x2000,%esi
80100e07:	e9 0c fe ff ff       	jmp    80100c18 <exec+0x198>
80100e0c:	66 90                	xchg   %ax,%ax
80100e0e:	66 90                	xchg   %ax,%ax

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	f3 0f 1e fb          	endbr32 
80100e14:	55                   	push   %ebp
80100e15:	89 e5                	mov    %esp,%ebp
80100e17:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e1a:	68 4d 78 10 80       	push   $0x8010784d
80100e1f:	68 c0 0f 11 80       	push   $0x80110fc0
80100e24:	e8 c7 3b 00 00       	call   801049f0 <initlock>
}
80100e29:	83 c4 10             	add    $0x10,%esp
80100e2c:	c9                   	leave  
80100e2d:	c3                   	ret    
80100e2e:	66 90                	xchg   %ax,%ax

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	f3 0f 1e fb          	endbr32 
80100e34:	55                   	push   %ebp
80100e35:	89 e5                	mov    %esp,%ebp
80100e37:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e38:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e3d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e40:	68 c0 0f 11 80       	push   $0x80110fc0
80100e45:	e8 26 3d 00 00       	call   80104b70 <acquire>
80100e4a:	83 c4 10             	add    $0x10,%esp
80100e4d:	eb 0c                	jmp    80100e5b <filealloc+0x2b>
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e71:	e8 ba 3d 00 00       	call   80104c30 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 c0 0f 11 80       	push   $0x80110fc0
80100e8a:	e8 a1 3d 00 00       	call   80104c30 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	f3 0f 1e fb          	endbr32 
80100ea4:	55                   	push   %ebp
80100ea5:	89 e5                	mov    %esp,%ebp
80100ea7:	53                   	push   %ebx
80100ea8:	83 ec 10             	sub    $0x10,%esp
80100eab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eae:	68 c0 0f 11 80       	push   $0x80110fc0
80100eb3:	e8 b8 3c 00 00       	call   80104b70 <acquire>
  if(f->ref < 1)
80100eb8:	8b 43 04             	mov    0x4(%ebx),%eax
80100ebb:	83 c4 10             	add    $0x10,%esp
80100ebe:	85 c0                	test   %eax,%eax
80100ec0:	7e 1a                	jle    80100edc <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ec2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ecb:	68 c0 0f 11 80       	push   $0x80110fc0
80100ed0:	e8 5b 3d 00 00       	call   80104c30 <release>
  return f;
}
80100ed5:	89 d8                	mov    %ebx,%eax
80100ed7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eda:	c9                   	leave  
80100edb:	c3                   	ret    
    panic("filedup");
80100edc:	83 ec 0c             	sub    $0xc,%esp
80100edf:	68 54 78 10 80       	push   $0x80107854
80100ee4:	e8 a7 f4 ff ff       	call   80100390 <panic>
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	f3 0f 1e fb          	endbr32 
80100ef4:	55                   	push   %ebp
80100ef5:	89 e5                	mov    %esp,%ebp
80100ef7:	57                   	push   %edi
80100ef8:	56                   	push   %esi
80100ef9:	53                   	push   %ebx
80100efa:	83 ec 28             	sub    $0x28,%esp
80100efd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f00:	68 c0 0f 11 80       	push   $0x80110fc0
80100f05:	e8 66 3c 00 00       	call   80104b70 <acquire>
  if(f->ref < 1)
80100f0a:	8b 53 04             	mov    0x4(%ebx),%edx
80100f0d:	83 c4 10             	add    $0x10,%esp
80100f10:	85 d2                	test   %edx,%edx
80100f12:	0f 8e a1 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f18:	83 ea 01             	sub    $0x1,%edx
80100f1b:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1e:	75 40                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f20:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f24:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f27:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f29:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f32:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f35:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f38:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f40:	e8 eb 3c 00 00       	call   80104c30 <release>

  if(ff.type == FD_PIPE)
80100f45:	83 c4 10             	add    $0x10,%esp
80100f48:	83 ff 01             	cmp    $0x1,%edi
80100f4b:	74 53                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f4d:	83 ff 02             	cmp    $0x2,%edi
80100f50:	74 26                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f55:	5b                   	pop    %ebx
80100f56:	5e                   	pop    %esi
80100f57:	5f                   	pop    %edi
80100f58:	5d                   	pop    %ebp
80100f59:	c3                   	ret    
80100f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 bd 3c 00 00       	jmp    80104c30 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	pushl  -0x20(%ebp)
80100f83:	e8 38 09 00 00       	call   801018c0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 25 00 00       	call   80103530 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 5c 78 10 80       	push   $0x8010785c
80100fc1:	e8 ca f3 ff ff       	call   80100390 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	f3 0f 1e fb          	endbr32 
80100fd4:	55                   	push   %ebp
80100fd5:	89 e5                	mov    %esp,%ebp
80100fd7:	53                   	push   %ebx
80100fd8:	83 ec 04             	sub    $0x4,%esp
80100fdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fde:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fe1:	75 2d                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fe3:	83 ec 0c             	sub    $0xc,%esp
80100fe6:	ff 73 10             	pushl  0x10(%ebx)
80100fe9:	e8 a2 07 00 00       	call   80101790 <ilock>
    stati(f->ip, st);
80100fee:	58                   	pop    %eax
80100fef:	5a                   	pop    %edx
80100ff0:	ff 75 0c             	pushl  0xc(%ebp)
80100ff3:	ff 73 10             	pushl  0x10(%ebx)
80100ff6:	e8 65 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ffb:	59                   	pop    %ecx
80100ffc:	ff 73 10             	pushl  0x10(%ebx)
80100fff:	e8 6c 08 00 00       	call   80101870 <iunlock>
    return 0;
  }
  return -1;
}
80101004:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101007:	83 c4 10             	add    $0x10,%esp
8010100a:	31 c0                	xor    %eax,%eax
}
8010100c:	c9                   	leave  
8010100d:	c3                   	ret    
8010100e:	66 90                	xchg   %ax,%ax
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	f3 0f 1e fb          	endbr32 
80101024:	55                   	push   %ebp
80101025:	89 e5                	mov    %esp,%ebp
80101027:	57                   	push   %edi
80101028:	56                   	push   %esi
80101029:	53                   	push   %ebx
8010102a:	83 ec 0c             	sub    $0xc,%esp
8010102d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101030:	8b 75 0c             	mov    0xc(%ebp),%esi
80101033:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101036:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010103a:	74 64                	je     801010a0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010103c:	8b 03                	mov    (%ebx),%eax
8010103e:	83 f8 01             	cmp    $0x1,%eax
80101041:	74 45                	je     80101088 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101043:	83 f8 02             	cmp    $0x2,%eax
80101046:	75 5f                	jne    801010a7 <fileread+0x87>
    ilock(f->ip);
80101048:	83 ec 0c             	sub    $0xc,%esp
8010104b:	ff 73 10             	pushl  0x10(%ebx)
8010104e:	e8 3d 07 00 00       	call   80101790 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101053:	57                   	push   %edi
80101054:	ff 73 14             	pushl  0x14(%ebx)
80101057:	56                   	push   %esi
80101058:	ff 73 10             	pushl  0x10(%ebx)
8010105b:	e8 30 0a 00 00       	call   80101a90 <readi>
80101060:	83 c4 20             	add    $0x20,%esp
80101063:	89 c6                	mov    %eax,%esi
80101065:	85 c0                	test   %eax,%eax
80101067:	7e 03                	jle    8010106c <fileread+0x4c>
      f->off += r;
80101069:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010106c:	83 ec 0c             	sub    $0xc,%esp
8010106f:	ff 73 10             	pushl  0x10(%ebx)
80101072:	e8 f9 07 00 00       	call   80101870 <iunlock>
    return r;
80101077:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010107a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010107d:	89 f0                	mov    %esi,%eax
8010107f:	5b                   	pop    %ebx
80101080:	5e                   	pop    %esi
80101081:	5f                   	pop    %edi
80101082:	5d                   	pop    %ebp
80101083:	c3                   	ret    
80101084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101088:	8b 43 0c             	mov    0xc(%ebx),%eax
8010108b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010108e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101091:	5b                   	pop    %ebx
80101092:	5e                   	pop    %esi
80101093:	5f                   	pop    %edi
80101094:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101095:	e9 36 26 00 00       	jmp    801036d0 <piperead>
8010109a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010a5:	eb d3                	jmp    8010107a <fileread+0x5a>
  panic("fileread");
801010a7:	83 ec 0c             	sub    $0xc,%esp
801010aa:	68 66 78 10 80       	push   $0x80107866
801010af:	e8 dc f2 ff ff       	call   80100390 <panic>
801010b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010bf:	90                   	nop

801010c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010c0:	f3 0f 1e fb          	endbr32 
801010c4:	55                   	push   %ebp
801010c5:	89 e5                	mov    %esp,%ebp
801010c7:	57                   	push   %edi
801010c8:	56                   	push   %esi
801010c9:	53                   	push   %ebx
801010ca:	83 ec 1c             	sub    $0x1c,%esp
801010cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801010d0:	8b 75 08             	mov    0x8(%ebp),%esi
801010d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010d6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010d9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010e0:	0f 84 c1 00 00 00    	je     801011a7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010e6:	8b 06                	mov    (%esi),%eax
801010e8:	83 f8 01             	cmp    $0x1,%eax
801010eb:	0f 84 c3 00 00 00    	je     801011b4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010f1:	83 f8 02             	cmp    $0x2,%eax
801010f4:	0f 85 cc 00 00 00    	jne    801011c6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010fd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010ff:	85 c0                	test   %eax,%eax
80101101:	7f 34                	jg     80101137 <filewrite+0x77>
80101103:	e9 98 00 00 00       	jmp    801011a0 <filewrite+0xe0>
80101108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010110f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101110:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101113:	83 ec 0c             	sub    $0xc,%esp
80101116:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101119:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010111c:	e8 4f 07 00 00       	call   80101870 <iunlock>
      end_op();
80101121:	e8 aa 1c 00 00       	call   80102dd0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101126:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101129:	83 c4 10             	add    $0x10,%esp
8010112c:	39 c3                	cmp    %eax,%ebx
8010112e:	75 60                	jne    80101190 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101130:	01 df                	add    %ebx,%edi
    while(i < n){
80101132:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101135:	7e 69                	jle    801011a0 <filewrite+0xe0>
      int n1 = n - i;
80101137:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010113a:	b8 00 06 00 00       	mov    $0x600,%eax
8010113f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101141:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101147:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010114a:	e8 11 1c 00 00       	call   80102d60 <begin_op>
      ilock(f->ip);
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	ff 76 10             	pushl  0x10(%esi)
80101155:	e8 36 06 00 00       	call   80101790 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010115a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010115d:	53                   	push   %ebx
8010115e:	ff 76 14             	pushl  0x14(%esi)
80101161:	01 f8                	add    %edi,%eax
80101163:	50                   	push   %eax
80101164:	ff 76 10             	pushl  0x10(%esi)
80101167:	e8 24 0a 00 00       	call   80101b90 <writei>
8010116c:	83 c4 20             	add    $0x20,%esp
8010116f:	85 c0                	test   %eax,%eax
80101171:	7f 9d                	jg     80101110 <filewrite+0x50>
      iunlock(f->ip);
80101173:	83 ec 0c             	sub    $0xc,%esp
80101176:	ff 76 10             	pushl  0x10(%esi)
80101179:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010117c:	e8 ef 06 00 00       	call   80101870 <iunlock>
      end_op();
80101181:	e8 4a 1c 00 00       	call   80102dd0 <end_op>
      if(r < 0)
80101186:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101189:	83 c4 10             	add    $0x10,%esp
8010118c:	85 c0                	test   %eax,%eax
8010118e:	75 17                	jne    801011a7 <filewrite+0xe7>
        panic("short filewrite");
80101190:	83 ec 0c             	sub    $0xc,%esp
80101193:	68 6f 78 10 80       	push   $0x8010786f
80101198:	e8 f3 f1 ff ff       	call   80100390 <panic>
8010119d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801011a0:	89 f8                	mov    %edi,%eax
801011a2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801011a5:	74 05                	je     801011ac <filewrite+0xec>
801011a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011af:	5b                   	pop    %ebx
801011b0:	5e                   	pop    %esi
801011b1:	5f                   	pop    %edi
801011b2:	5d                   	pop    %ebp
801011b3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011b4:	8b 46 0c             	mov    0xc(%esi),%eax
801011b7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011bd:	5b                   	pop    %ebx
801011be:	5e                   	pop    %esi
801011bf:	5f                   	pop    %edi
801011c0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011c1:	e9 0a 24 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011c6:	83 ec 0c             	sub    $0xc,%esp
801011c9:	68 75 78 10 80       	push   $0x80107875
801011ce:	e8 bd f1 ff ff       	call   80100390 <panic>
801011d3:	66 90                	xchg   %ax,%ax
801011d5:	66 90                	xchg   %ax,%ax
801011d7:	66 90                	xchg   %ax,%ax
801011d9:	66 90                	xchg   %ax,%ax
801011db:	66 90                	xchg   %ax,%ax
801011dd:	66 90                	xchg   %ax,%ax
801011df:	90                   	nop

801011e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011e0:	55                   	push   %ebp
801011e1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011e3:	89 d0                	mov    %edx,%eax
801011e5:	c1 e8 0c             	shr    $0xc,%eax
801011e8:	03 05 d8 19 11 80    	add    0x801119d8,%eax
{
801011ee:	89 e5                	mov    %esp,%ebp
801011f0:	56                   	push   %esi
801011f1:	53                   	push   %ebx
801011f2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011f4:	83 ec 08             	sub    $0x8,%esp
801011f7:	50                   	push   %eax
801011f8:	51                   	push   %ecx
801011f9:	e8 d2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011fe:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101200:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101203:	ba 01 00 00 00       	mov    $0x1,%edx
80101208:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010120b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101211:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101214:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101216:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010121b:	85 d1                	test   %edx,%ecx
8010121d:	74 25                	je     80101244 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010121f:	f7 d2                	not    %edx
  log_write(bp);
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101226:	21 ca                	and    %ecx,%edx
80101228:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010122c:	50                   	push   %eax
8010122d:	e8 0e 1d 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101232:	89 34 24             	mov    %esi,(%esp)
80101235:	e8 b6 ef ff ff       	call   801001f0 <brelse>
}
8010123a:	83 c4 10             	add    $0x10,%esp
8010123d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101240:	5b                   	pop    %ebx
80101241:	5e                   	pop    %esi
80101242:	5d                   	pop    %ebp
80101243:	c3                   	ret    
    panic("freeing free block");
80101244:	83 ec 0c             	sub    $0xc,%esp
80101247:	68 7f 78 10 80       	push   $0x8010787f
8010124c:	e8 3f f1 ff ff       	call   80100390 <panic>
80101251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010125f:	90                   	nop

80101260 <balloc>:
{
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	57                   	push   %edi
80101264:	56                   	push   %esi
80101265:	53                   	push   %ebx
80101266:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101269:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010126f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101272:	85 c9                	test   %ecx,%ecx
80101274:	0f 84 87 00 00 00    	je     80101301 <balloc+0xa1>
8010127a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101281:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101284:	83 ec 08             	sub    $0x8,%esp
80101287:	89 f0                	mov    %esi,%eax
80101289:	c1 f8 0c             	sar    $0xc,%eax
8010128c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101292:	50                   	push   %eax
80101293:	ff 75 d8             	pushl  -0x28(%ebp)
80101296:	e8 35 ee ff ff       	call   801000d0 <bread>
8010129b:	83 c4 10             	add    $0x10,%esp
8010129e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012a1:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801012a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012a9:	31 c0                	xor    %eax,%eax
801012ab:	eb 2f                	jmp    801012dc <balloc+0x7c>
801012ad:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012b0:	89 c1                	mov    %eax,%ecx
801012b2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012ba:	83 e1 07             	and    $0x7,%ecx
801012bd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012bf:	89 c1                	mov    %eax,%ecx
801012c1:	c1 f9 03             	sar    $0x3,%ecx
801012c4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012c9:	89 fa                	mov    %edi,%edx
801012cb:	85 df                	test   %ebx,%edi
801012cd:	74 41                	je     80101310 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012cf:	83 c0 01             	add    $0x1,%eax
801012d2:	83 c6 01             	add    $0x1,%esi
801012d5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012da:	74 05                	je     801012e1 <balloc+0x81>
801012dc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012df:	77 cf                	ja     801012b0 <balloc+0x50>
    brelse(bp);
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012e7:	e8 04 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012ec:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012f3:	83 c4 10             	add    $0x10,%esp
801012f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012f9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801012ff:	77 80                	ja     80101281 <balloc+0x21>
  panic("balloc: out of blocks");
80101301:	83 ec 0c             	sub    $0xc,%esp
80101304:	68 92 78 10 80       	push   $0x80107892
80101309:	e8 82 f0 ff ff       	call   80100390 <panic>
8010130e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101310:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101313:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101316:	09 da                	or     %ebx,%edx
80101318:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010131c:	57                   	push   %edi
8010131d:	e8 1e 1c 00 00       	call   80102f40 <log_write>
        brelse(bp);
80101322:	89 3c 24             	mov    %edi,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010132a:	58                   	pop    %eax
8010132b:	5a                   	pop    %edx
8010132c:	56                   	push   %esi
8010132d:	ff 75 d8             	pushl  -0x28(%ebp)
80101330:	e8 9b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101335:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101338:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010133a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010133d:	68 00 02 00 00       	push   $0x200
80101342:	6a 00                	push   $0x0
80101344:	50                   	push   %eax
80101345:	e8 36 39 00 00       	call   80104c80 <memset>
  log_write(bp);
8010134a:	89 1c 24             	mov    %ebx,(%esp)
8010134d:	e8 ee 1b 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101352:	89 1c 24             	mov    %ebx,(%esp)
80101355:	e8 96 ee ff ff       	call   801001f0 <brelse>
}
8010135a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135d:	89 f0                	mov    %esi,%eax
8010135f:	5b                   	pop    %ebx
80101360:	5e                   	pop    %esi
80101361:	5f                   	pop    %edi
80101362:	5d                   	pop    %ebp
80101363:	c3                   	ret    
80101364:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010136f:	90                   	nop

80101370 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	57                   	push   %edi
80101374:	89 c7                	mov    %eax,%edi
80101376:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101377:	31 f6                	xor    %esi,%esi
{
80101379:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010137f:	83 ec 28             	sub    $0x28,%esp
80101382:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101385:	68 e0 19 11 80       	push   $0x801119e0
8010138a:	e8 e1 37 00 00       	call   80104b70 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101392:	83 c4 10             	add    $0x10,%esp
80101395:	eb 1b                	jmp    801013b2 <iget+0x42>
80101397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010139e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a0:	39 3b                	cmp    %edi,(%ebx)
801013a2:	74 6c                	je     80101410 <iget+0xa0>
801013a4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013aa:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013b0:	73 26                	jae    801013d8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013b2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801013b5:	85 c9                	test   %ecx,%ecx
801013b7:	7f e7                	jg     801013a0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013b9:	85 f6                	test   %esi,%esi
801013bb:	75 e7                	jne    801013a4 <iget+0x34>
801013bd:	89 d8                	mov    %ebx,%eax
801013bf:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013c5:	85 c9                	test   %ecx,%ecx
801013c7:	75 6e                	jne    80101437 <iget+0xc7>
801013c9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013cb:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013d1:	72 df                	jb     801013b2 <iget+0x42>
801013d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013d7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013d8:	85 f6                	test   %esi,%esi
801013da:	74 73                	je     8010144f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013dc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013df:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013e1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013e4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013eb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013f2:	68 e0 19 11 80       	push   $0x801119e0
801013f7:	e8 34 38 00 00       	call   80104c30 <release>

  return ip;
801013fc:	83 c4 10             	add    $0x10,%esp
}
801013ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101402:	89 f0                	mov    %esi,%eax
80101404:	5b                   	pop    %ebx
80101405:	5e                   	pop    %esi
80101406:	5f                   	pop    %edi
80101407:	5d                   	pop    %ebp
80101408:	c3                   	ret    
80101409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101410:	39 53 04             	cmp    %edx,0x4(%ebx)
80101413:	75 8f                	jne    801013a4 <iget+0x34>
      release(&icache.lock);
80101415:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101418:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010141b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010141d:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
80101422:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101425:	e8 06 38 00 00       	call   80104c30 <release>
      return ip;
8010142a:	83 c4 10             	add    $0x10,%esp
}
8010142d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101430:	89 f0                	mov    %esi,%eax
80101432:	5b                   	pop    %ebx
80101433:	5e                   	pop    %esi
80101434:	5f                   	pop    %edi
80101435:	5d                   	pop    %ebp
80101436:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101437:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010143d:	73 10                	jae    8010144f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010143f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101442:	85 c9                	test   %ecx,%ecx
80101444:	0f 8f 56 ff ff ff    	jg     801013a0 <iget+0x30>
8010144a:	e9 6e ff ff ff       	jmp    801013bd <iget+0x4d>
    panic("iget: no inodes");
8010144f:	83 ec 0c             	sub    $0xc,%esp
80101452:	68 a8 78 10 80       	push   $0x801078a8
80101457:	e8 34 ef ff ff       	call   80100390 <panic>
8010145c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101460 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	57                   	push   %edi
80101464:	56                   	push   %esi
80101465:	89 c6                	mov    %eax,%esi
80101467:	53                   	push   %ebx
80101468:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010146b:	83 fa 0b             	cmp    $0xb,%edx
8010146e:	0f 86 84 00 00 00    	jbe    801014f8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101474:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101477:	83 fb 7f             	cmp    $0x7f,%ebx
8010147a:	0f 87 98 00 00 00    	ja     80101518 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101480:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101486:	8b 16                	mov    (%esi),%edx
80101488:	85 c0                	test   %eax,%eax
8010148a:	74 54                	je     801014e0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010148c:	83 ec 08             	sub    $0x8,%esp
8010148f:	50                   	push   %eax
80101490:	52                   	push   %edx
80101491:	e8 3a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101496:	83 c4 10             	add    $0x10,%esp
80101499:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010149d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010149f:	8b 1a                	mov    (%edx),%ebx
801014a1:	85 db                	test   %ebx,%ebx
801014a3:	74 1b                	je     801014c0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014a5:	83 ec 0c             	sub    $0xc,%esp
801014a8:	57                   	push   %edi
801014a9:	e8 42 ed ff ff       	call   801001f0 <brelse>
    return addr;
801014ae:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801014b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014b4:	89 d8                	mov    %ebx,%eax
801014b6:	5b                   	pop    %ebx
801014b7:	5e                   	pop    %esi
801014b8:	5f                   	pop    %edi
801014b9:	5d                   	pop    %ebp
801014ba:	c3                   	ret    
801014bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014bf:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014c0:	8b 06                	mov    (%esi),%eax
801014c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014c5:	e8 96 fd ff ff       	call   80101260 <balloc>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014cd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014d0:	89 c3                	mov    %eax,%ebx
801014d2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014d4:	57                   	push   %edi
801014d5:	e8 66 1a 00 00       	call   80102f40 <log_write>
801014da:	83 c4 10             	add    $0x10,%esp
801014dd:	eb c6                	jmp    801014a5 <bmap+0x45>
801014df:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014e0:	89 d0                	mov    %edx,%eax
801014e2:	e8 79 fd ff ff       	call   80101260 <balloc>
801014e7:	8b 16                	mov    (%esi),%edx
801014e9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014ef:	eb 9b                	jmp    8010148c <bmap+0x2c>
801014f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014f8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014fb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014fe:	85 db                	test   %ebx,%ebx
80101500:	75 af                	jne    801014b1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101502:	8b 00                	mov    (%eax),%eax
80101504:	e8 57 fd ff ff       	call   80101260 <balloc>
80101509:	89 47 5c             	mov    %eax,0x5c(%edi)
8010150c:	89 c3                	mov    %eax,%ebx
}
8010150e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101511:	89 d8                	mov    %ebx,%eax
80101513:	5b                   	pop    %ebx
80101514:	5e                   	pop    %esi
80101515:	5f                   	pop    %edi
80101516:	5d                   	pop    %ebp
80101517:	c3                   	ret    
  panic("bmap: out of range");
80101518:	83 ec 0c             	sub    $0xc,%esp
8010151b:	68 b8 78 10 80       	push   $0x801078b8
80101520:	e8 6b ee ff ff       	call   80100390 <panic>
80101525:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010152c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101530 <readsb>:
{
80101530:	f3 0f 1e fb          	endbr32 
80101534:	55                   	push   %ebp
80101535:	89 e5                	mov    %esp,%ebp
80101537:	56                   	push   %esi
80101538:	53                   	push   %ebx
80101539:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010153c:	83 ec 08             	sub    $0x8,%esp
8010153f:	6a 01                	push   $0x1
80101541:	ff 75 08             	pushl  0x8(%ebp)
80101544:	e8 87 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101549:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010154c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010154e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101551:	6a 1c                	push   $0x1c
80101553:	50                   	push   %eax
80101554:	56                   	push   %esi
80101555:	e8 c6 37 00 00       	call   80104d20 <memmove>
  brelse(bp);
8010155a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010155d:	83 c4 10             	add    $0x10,%esp
}
80101560:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101563:	5b                   	pop    %ebx
80101564:	5e                   	pop    %esi
80101565:	5d                   	pop    %ebp
  brelse(bp);
80101566:	e9 85 ec ff ff       	jmp    801001f0 <brelse>
8010156b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010156f:	90                   	nop

80101570 <iinit>:
{
80101570:	f3 0f 1e fb          	endbr32 
80101574:	55                   	push   %ebp
80101575:	89 e5                	mov    %esp,%ebp
80101577:	53                   	push   %ebx
80101578:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
8010157d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101580:	68 cb 78 10 80       	push   $0x801078cb
80101585:	68 e0 19 11 80       	push   $0x801119e0
8010158a:	e8 61 34 00 00       	call   801049f0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010158f:	83 c4 10             	add    $0x10,%esp
80101592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101598:	83 ec 08             	sub    $0x8,%esp
8010159b:	68 d2 78 10 80       	push   $0x801078d2
801015a0:	53                   	push   %ebx
801015a1:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015a7:	e8 04 33 00 00       	call   801048b0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015ac:	83 c4 10             	add    $0x10,%esp
801015af:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801015b5:	75 e1                	jne    80101598 <iinit+0x28>
  readsb(dev, &sb);
801015b7:	83 ec 08             	sub    $0x8,%esp
801015ba:	68 c0 19 11 80       	push   $0x801119c0
801015bf:	ff 75 08             	pushl  0x8(%ebp)
801015c2:	e8 69 ff ff ff       	call   80101530 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c7:	ff 35 d8 19 11 80    	pushl  0x801119d8
801015cd:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015d3:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015d9:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015df:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015e5:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015eb:	ff 35 c0 19 11 80    	pushl  0x801119c0
801015f1:	68 38 79 10 80       	push   $0x80107938
801015f6:	e8 b5 f0 ff ff       	call   801006b0 <cprintf>
}
801015fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015fe:	83 c4 30             	add    $0x30,%esp
80101601:	c9                   	leave  
80101602:	c3                   	ret    
80101603:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101610 <ialloc>:
{
80101610:	f3 0f 1e fb          	endbr32 
80101614:	55                   	push   %ebp
80101615:	89 e5                	mov    %esp,%ebp
80101617:	57                   	push   %edi
80101618:	56                   	push   %esi
80101619:	53                   	push   %ebx
8010161a:	83 ec 1c             	sub    $0x1c,%esp
8010161d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101620:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
80101627:	8b 75 08             	mov    0x8(%ebp),%esi
8010162a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010162d:	0f 86 8d 00 00 00    	jbe    801016c0 <ialloc+0xb0>
80101633:	bf 01 00 00 00       	mov    $0x1,%edi
80101638:	eb 1d                	jmp    80101657 <ialloc+0x47>
8010163a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d c8 19 11 80    	cmp    0x801119c8,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 ed 35 00 00       	call   80104c80 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 b0 fc ff ff       	jmp    80101370 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 d8 78 10 80       	push   $0x801078d8
801016c8:	e8 c3 ec ff ff       	call   80100390 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	f3 0f 1e fb          	endbr32 
801016d4:	55                   	push   %ebp
801016d5:	89 e5                	mov    %esp,%ebp
801016d7:	56                   	push   %esi
801016d8:	53                   	push   %ebx
801016d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016dc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016df:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e2:	83 ec 08             	sub    $0x8,%esp
801016e5:	c1 e8 03             	shr    $0x3,%eax
801016e8:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016ee:	50                   	push   %eax
801016ef:	ff 73 a4             	pushl  -0x5c(%ebx)
801016f2:	e8 d9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fe:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101700:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101703:	83 e0 07             	and    $0x7,%eax
80101706:	c1 e0 06             	shl    $0x6,%eax
80101709:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010170d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101710:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101714:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101717:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010171b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101723:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101727:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010172b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101731:	6a 34                	push   $0x34
80101733:	53                   	push   %ebx
80101734:	50                   	push   %eax
80101735:	e8 e6 35 00 00       	call   80104d20 <memmove>
  log_write(bp);
8010173a:	89 34 24             	mov    %esi,(%esp)
8010173d:	e8 fe 17 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101742:	89 75 08             	mov    %esi,0x8(%ebp)
80101745:	83 c4 10             	add    $0x10,%esp
}
80101748:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010174b:	5b                   	pop    %ebx
8010174c:	5e                   	pop    %esi
8010174d:	5d                   	pop    %ebp
  brelse(bp);
8010174e:	e9 9d ea ff ff       	jmp    801001f0 <brelse>
80101753:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010175a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101760 <idup>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	53                   	push   %ebx
80101768:	83 ec 10             	sub    $0x10,%esp
8010176b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010176e:	68 e0 19 11 80       	push   $0x801119e0
80101773:	e8 f8 33 00 00       	call   80104b70 <acquire>
  ip->ref++;
80101778:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010177c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101783:	e8 a8 34 00 00       	call   80104c30 <release>
}
80101788:	89 d8                	mov    %ebx,%eax
8010178a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010178d:	c9                   	leave  
8010178e:	c3                   	ret    
8010178f:	90                   	nop

80101790 <ilock>:
{
80101790:	f3 0f 1e fb          	endbr32 
80101794:	55                   	push   %ebp
80101795:	89 e5                	mov    %esp,%ebp
80101797:	56                   	push   %esi
80101798:	53                   	push   %ebx
80101799:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010179c:	85 db                	test   %ebx,%ebx
8010179e:	0f 84 b3 00 00 00    	je     80101857 <ilock+0xc7>
801017a4:	8b 53 08             	mov    0x8(%ebx),%edx
801017a7:	85 d2                	test   %edx,%edx
801017a9:	0f 8e a8 00 00 00    	jle    80101857 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017af:	83 ec 0c             	sub    $0xc,%esp
801017b2:	8d 43 0c             	lea    0xc(%ebx),%eax
801017b5:	50                   	push   %eax
801017b6:	e8 35 31 00 00       	call   801048f0 <acquiresleep>
  if(ip->valid == 0){
801017bb:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017be:	83 c4 10             	add    $0x10,%esp
801017c1:	85 c0                	test   %eax,%eax
801017c3:	74 0b                	je     801017d0 <ilock+0x40>
}
801017c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017c8:	5b                   	pop    %ebx
801017c9:	5e                   	pop    %esi
801017ca:	5d                   	pop    %ebp
801017cb:	c3                   	ret    
801017cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017d0:	8b 43 04             	mov    0x4(%ebx),%eax
801017d3:	83 ec 08             	sub    $0x8,%esp
801017d6:	c1 e8 03             	shr    $0x3,%eax
801017d9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801017df:	50                   	push   %eax
801017e0:	ff 33                	pushl  (%ebx)
801017e2:	e8 e9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017e7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ea:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017ec:	8b 43 04             	mov    0x4(%ebx),%eax
801017ef:	83 e0 07             	and    $0x7,%eax
801017f2:	c1 e0 06             	shl    $0x6,%eax
801017f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101803:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101807:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010180b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010180f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101813:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101817:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010181b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010181e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101821:	6a 34                	push   $0x34
80101823:	50                   	push   %eax
80101824:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101827:	50                   	push   %eax
80101828:	e8 f3 34 00 00       	call   80104d20 <memmove>
    brelse(bp);
8010182d:	89 34 24             	mov    %esi,(%esp)
80101830:	e8 bb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101835:	83 c4 10             	add    $0x10,%esp
80101838:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010183d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101844:	0f 85 7b ff ff ff    	jne    801017c5 <ilock+0x35>
      panic("ilock: no type");
8010184a:	83 ec 0c             	sub    $0xc,%esp
8010184d:	68 f0 78 10 80       	push   $0x801078f0
80101852:	e8 39 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101857:	83 ec 0c             	sub    $0xc,%esp
8010185a:	68 ea 78 10 80       	push   $0x801078ea
8010185f:	e8 2c eb ff ff       	call   80100390 <panic>
80101864:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010186b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010186f:	90                   	nop

80101870 <iunlock>:
{
80101870:	f3 0f 1e fb          	endbr32 
80101874:	55                   	push   %ebp
80101875:	89 e5                	mov    %esp,%ebp
80101877:	56                   	push   %esi
80101878:	53                   	push   %ebx
80101879:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010187c:	85 db                	test   %ebx,%ebx
8010187e:	74 28                	je     801018a8 <iunlock+0x38>
80101880:	83 ec 0c             	sub    $0xc,%esp
80101883:	8d 73 0c             	lea    0xc(%ebx),%esi
80101886:	56                   	push   %esi
80101887:	e8 04 31 00 00       	call   80104990 <holdingsleep>
8010188c:	83 c4 10             	add    $0x10,%esp
8010188f:	85 c0                	test   %eax,%eax
80101891:	74 15                	je     801018a8 <iunlock+0x38>
80101893:	8b 43 08             	mov    0x8(%ebx),%eax
80101896:	85 c0                	test   %eax,%eax
80101898:	7e 0e                	jle    801018a8 <iunlock+0x38>
  releasesleep(&ip->lock);
8010189a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010189d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018a0:	5b                   	pop    %ebx
801018a1:	5e                   	pop    %esi
801018a2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018a3:	e9 a8 30 00 00       	jmp    80104950 <releasesleep>
    panic("iunlock");
801018a8:	83 ec 0c             	sub    $0xc,%esp
801018ab:	68 ff 78 10 80       	push   $0x801078ff
801018b0:	e8 db ea ff ff       	call   80100390 <panic>
801018b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018c0 <iput>:
{
801018c0:	f3 0f 1e fb          	endbr32 
801018c4:	55                   	push   %ebp
801018c5:	89 e5                	mov    %esp,%ebp
801018c7:	57                   	push   %edi
801018c8:	56                   	push   %esi
801018c9:	53                   	push   %ebx
801018ca:	83 ec 28             	sub    $0x28,%esp
801018cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018d0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018d3:	57                   	push   %edi
801018d4:	e8 17 30 00 00       	call   801048f0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018d9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018dc:	83 c4 10             	add    $0x10,%esp
801018df:	85 d2                	test   %edx,%edx
801018e1:	74 07                	je     801018ea <iput+0x2a>
801018e3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018e8:	74 36                	je     80101920 <iput+0x60>
  releasesleep(&ip->lock);
801018ea:	83 ec 0c             	sub    $0xc,%esp
801018ed:	57                   	push   %edi
801018ee:	e8 5d 30 00 00       	call   80104950 <releasesleep>
  acquire(&icache.lock);
801018f3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018fa:	e8 71 32 00 00       	call   80104b70 <acquire>
  ip->ref--;
801018ff:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
8010190d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101910:	5b                   	pop    %ebx
80101911:	5e                   	pop    %esi
80101912:	5f                   	pop    %edi
80101913:	5d                   	pop    %ebp
  release(&icache.lock);
80101914:	e9 17 33 00 00       	jmp    80104c30 <release>
80101919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101920:	83 ec 0c             	sub    $0xc,%esp
80101923:	68 e0 19 11 80       	push   $0x801119e0
80101928:	e8 43 32 00 00       	call   80104b70 <acquire>
    int r = ip->ref;
8010192d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101930:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101937:	e8 f4 32 00 00       	call   80104c30 <release>
    if(r == 1){
8010193c:	83 c4 10             	add    $0x10,%esp
8010193f:	83 fe 01             	cmp    $0x1,%esi
80101942:	75 a6                	jne    801018ea <iput+0x2a>
80101944:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010194a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010194d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101950:	89 cf                	mov    %ecx,%edi
80101952:	eb 0b                	jmp    8010195f <iput+0x9f>
80101954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101958:	83 c6 04             	add    $0x4,%esi
8010195b:	39 fe                	cmp    %edi,%esi
8010195d:	74 19                	je     80101978 <iput+0xb8>
    if(ip->addrs[i]){
8010195f:	8b 16                	mov    (%esi),%edx
80101961:	85 d2                	test   %edx,%edx
80101963:	74 f3                	je     80101958 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101965:	8b 03                	mov    (%ebx),%eax
80101967:	e8 74 f8 ff ff       	call   801011e0 <bfree>
      ip->addrs[i] = 0;
8010196c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101972:	eb e4                	jmp    80101958 <iput+0x98>
80101974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101978:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010197e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101981:	85 c0                	test   %eax,%eax
80101983:	75 33                	jne    801019b8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101985:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101988:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010198f:	53                   	push   %ebx
80101990:	e8 3b fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
80101995:	31 c0                	xor    %eax,%eax
80101997:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010199b:	89 1c 24             	mov    %ebx,(%esp)
8010199e:	e8 2d fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
801019a3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019aa:	83 c4 10             	add    $0x10,%esp
801019ad:	e9 38 ff ff ff       	jmp    801018ea <iput+0x2a>
801019b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019b8:	83 ec 08             	sub    $0x8,%esp
801019bb:	50                   	push   %eax
801019bc:	ff 33                	pushl  (%ebx)
801019be:	e8 0d e7 ff ff       	call   801000d0 <bread>
801019c3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019c6:	83 c4 10             	add    $0x10,%esp
801019c9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019d2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019d5:	89 cf                	mov    %ecx,%edi
801019d7:	eb 0e                	jmp    801019e7 <iput+0x127>
801019d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 f7                	cmp    %esi,%edi
801019e5:	74 19                	je     80101a00 <iput+0x140>
      if(a[j])
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019ed:	8b 03                	mov    (%ebx),%eax
801019ef:	e8 ec f7 ff ff       	call   801011e0 <bfree>
801019f4:	eb ea                	jmp    801019e0 <iput+0x120>
801019f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019fd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101a00:	83 ec 0c             	sub    $0xc,%esp
80101a03:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a06:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a09:	e8 e2 e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a0e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a14:	8b 03                	mov    (%ebx),%eax
80101a16:	e8 c5 f7 ff ff       	call   801011e0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a1b:	83 c4 10             	add    $0x10,%esp
80101a1e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a25:	00 00 00 
80101a28:	e9 58 ff ff ff       	jmp    80101985 <iput+0xc5>
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi

80101a30 <iunlockput>:
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	53                   	push   %ebx
80101a38:	83 ec 10             	sub    $0x10,%esp
80101a3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a3e:	53                   	push   %ebx
80101a3f:	e8 2c fe ff ff       	call   80101870 <iunlock>
  iput(ip);
80101a44:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a47:	83 c4 10             	add    $0x10,%esp
}
80101a4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a4d:	c9                   	leave  
  iput(ip);
80101a4e:	e9 6d fe ff ff       	jmp    801018c0 <iput>
80101a53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	8b 55 08             	mov    0x8(%ebp),%edx
80101a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a6d:	8b 0a                	mov    (%edx),%ecx
80101a6f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a72:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a75:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a78:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a7c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a83:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a87:	8b 52 58             	mov    0x58(%edx),%edx
80101a8a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a8d:	5d                   	pop    %ebp
80101a8e:	c3                   	ret    
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	f3 0f 1e fb          	endbr32 
80101a94:	55                   	push   %ebp
80101a95:	89 e5                	mov    %esp,%ebp
80101a97:	57                   	push   %edi
80101a98:	56                   	push   %esi
80101a99:	53                   	push   %ebx
80101a9a:	83 ec 1c             	sub    $0x1c,%esp
80101a9d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa3:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa6:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa9:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aac:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ab1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab7:	0f 84 a3 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101abd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ac0:	8b 40 58             	mov    0x58(%eax),%eax
80101ac3:	39 c6                	cmp    %eax,%esi
80101ac5:	0f 87 b6 00 00 00    	ja     80101b81 <readi+0xf1>
80101acb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ace:	31 c9                	xor    %ecx,%ecx
80101ad0:	89 da                	mov    %ebx,%edx
80101ad2:	01 f2                	add    %esi,%edx
80101ad4:	0f 92 c1             	setb   %cl
80101ad7:	89 cf                	mov    %ecx,%edi
80101ad9:	0f 82 a2 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adf:	89 c1                	mov    %eax,%ecx
80101ae1:	29 f1                	sub    %esi,%ecx
80101ae3:	39 d0                	cmp    %edx,%eax
80101ae5:	0f 43 cb             	cmovae %ebx,%ecx
80101ae8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aeb:	85 c9                	test   %ecx,%ecx
80101aed:	74 63                	je     80101b52 <readi+0xc2>
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 61 f9 ff ff       	call   80101460 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	pushl  (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b12:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b15:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b17:	89 f0                	mov    %esi,%eax
80101b19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b20:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b23:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b25:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b29:	39 d9                	cmp    %ebx,%ecx
80101b2b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	pushl  -0x20(%ebp)
80101b37:	e8 e4 31 00 00       	call   80104d20 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	f3 0f 1e fb          	endbr32 
80101b94:	55                   	push   %ebp
80101b95:	89 e5                	mov    %esp,%ebp
80101b97:	57                   	push   %edi
80101b98:	56                   	push   %esi
80101b99:	53                   	push   %ebx
80101b9a:	83 ec 1c             	sub    $0x1c,%esp
80101b9d:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba0:	8b 75 0c             	mov    0xc(%ebp),%esi
80101ba3:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba6:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bab:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bae:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bb1:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb7:	0f 84 b3 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bbd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bc0:	39 70 58             	cmp    %esi,0x58(%eax)
80101bc3:	0f 82 e3 00 00 00    	jb     80101cac <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bc9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bcc:	89 f8                	mov    %edi,%eax
80101bce:	01 f0                	add    %esi,%eax
80101bd0:	0f 82 d6 00 00 00    	jb     80101cac <writei+0x11c>
80101bd6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bdb:	0f 87 cb 00 00 00    	ja     80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101be8:	85 ff                	test   %edi,%edi
80101bea:	74 75                	je     80101c61 <writei+0xd1>
80101bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 61 f8 ff ff       	call   80101460 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	pushl  (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	83 c4 0c             	add    $0xc,%esp
80101c1c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c21:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c23:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c27:	39 d9                	cmp    %ebx,%ecx
80101c29:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 e8 30 00 00       	call   80104d20 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	f3 0f 1e fb          	endbr32 
80101cc4:	55                   	push   %ebp
80101cc5:	89 e5                	mov    %esp,%ebp
80101cc7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cca:	6a 0e                	push   $0xe
80101ccc:	ff 75 0c             	pushl  0xc(%ebp)
80101ccf:	ff 75 08             	pushl  0x8(%ebp)
80101cd2:	e8 b9 30 00 00       	call   80104d90 <strncmp>
}
80101cd7:	c9                   	leave  
80101cd8:	c3                   	ret    
80101cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	f3 0f 1e fb          	endbr32 
80101ce4:	55                   	push   %ebp
80101ce5:	89 e5                	mov    %esp,%ebp
80101ce7:	57                   	push   %edi
80101ce8:	56                   	push   %esi
80101ce9:	53                   	push   %ebx
80101cea:	83 ec 1c             	sub    $0x1c,%esp
80101ced:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cf0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf5:	0f 85 89 00 00 00    	jne    80101d84 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cfb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfe:	31 ff                	xor    %edi,%edi
80101d00:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d03:	85 d2                	test   %edx,%edx
80101d05:	74 42                	je     80101d49 <dirlookup+0x69>
80101d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d0e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d10:	6a 10                	push   $0x10
80101d12:	57                   	push   %edi
80101d13:	56                   	push   %esi
80101d14:	53                   	push   %ebx
80101d15:	e8 76 fd ff ff       	call   80101a90 <readi>
80101d1a:	83 c4 10             	add    $0x10,%esp
80101d1d:	83 f8 10             	cmp    $0x10,%eax
80101d20:	75 55                	jne    80101d77 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d22:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d27:	74 18                	je     80101d41 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d29:	83 ec 04             	sub    $0x4,%esp
80101d2c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d2f:	6a 0e                	push   $0xe
80101d31:	50                   	push   %eax
80101d32:	ff 75 0c             	pushl  0xc(%ebp)
80101d35:	e8 56 30 00 00       	call   80104d90 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d3a:	83 c4 10             	add    $0x10,%esp
80101d3d:	85 c0                	test   %eax,%eax
80101d3f:	74 17                	je     80101d58 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d41:	83 c7 10             	add    $0x10,%edi
80101d44:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d47:	72 c7                	jb     80101d10 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d4c:	31 c0                	xor    %eax,%eax
}
80101d4e:	5b                   	pop    %ebx
80101d4f:	5e                   	pop    %esi
80101d50:	5f                   	pop    %edi
80101d51:	5d                   	pop    %ebp
80101d52:	c3                   	ret    
80101d53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d57:	90                   	nop
      if(poff)
80101d58:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5b:	85 c0                	test   %eax,%eax
80101d5d:	74 05                	je     80101d64 <dirlookup+0x84>
        *poff = off;
80101d5f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d62:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d64:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d68:	8b 03                	mov    (%ebx),%eax
80101d6a:	e8 01 f6 ff ff       	call   80101370 <iget>
}
80101d6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d72:	5b                   	pop    %ebx
80101d73:	5e                   	pop    %esi
80101d74:	5f                   	pop    %edi
80101d75:	5d                   	pop    %ebp
80101d76:	c3                   	ret    
      panic("dirlookup read");
80101d77:	83 ec 0c             	sub    $0xc,%esp
80101d7a:	68 19 79 10 80       	push   $0x80107919
80101d7f:	e8 0c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d84:	83 ec 0c             	sub    $0xc,%esp
80101d87:	68 07 79 10 80       	push   $0x80107907
80101d8c:	e8 ff e5 ff ff       	call   80100390 <panic>
80101d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d9f:	90                   	nop

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 86 01 00 00    	je     80101f40 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 71 1b 00 00       	call   80103930 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
80101dc2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101dc4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc7:	68 e0 19 11 80       	push   $0x801119e0
80101dcc:	e8 9f 2d 00 00       	call   80104b70 <acquire>
  ip->ref++;
80101dd1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101ddc:	e8 4f 2e 00 00       	call   80104c30 <release>
80101de1:	83 c4 10             	add    $0x10,%esp
80101de4:	eb 0d                	jmp    80101df3 <namex+0x53>
80101de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ded:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101df0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101df3:	0f b6 07             	movzbl (%edi),%eax
80101df6:	3c 2f                	cmp    $0x2f,%al
80101df8:	74 f6                	je     80101df0 <namex+0x50>
  if(*path == 0)
80101dfa:	84 c0                	test   %al,%al
80101dfc:	0f 84 ee 00 00 00    	je     80101ef0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101e02:	0f b6 07             	movzbl (%edi),%eax
80101e05:	84 c0                	test   %al,%al
80101e07:	0f 84 fb 00 00 00    	je     80101f08 <namex+0x168>
80101e0d:	89 fb                	mov    %edi,%ebx
80101e0f:	3c 2f                	cmp    $0x2f,%al
80101e11:	0f 84 f1 00 00 00    	je     80101f08 <namex+0x168>
80101e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e1e:	66 90                	xchg   %ax,%ax
80101e20:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e24:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e27:	3c 2f                	cmp    $0x2f,%al
80101e29:	74 04                	je     80101e2f <namex+0x8f>
80101e2b:	84 c0                	test   %al,%al
80101e2d:	75 f1                	jne    80101e20 <namex+0x80>
  len = path - s;
80101e2f:	89 d8                	mov    %ebx,%eax
80101e31:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e33:	83 f8 0d             	cmp    $0xd,%eax
80101e36:	0f 8e 84 00 00 00    	jle    80101ec0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e3c:	83 ec 04             	sub    $0x4,%esp
80101e3f:	6a 0e                	push   $0xe
80101e41:	57                   	push   %edi
    path++;
80101e42:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e44:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e47:	e8 d4 2e 00 00       	call   80104d20 <memmove>
80101e4c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e4f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e52:	75 0c                	jne    80101e60 <namex+0xc0>
80101e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e58:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e5b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e5e:	74 f8                	je     80101e58 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e60:	83 ec 0c             	sub    $0xc,%esp
80101e63:	56                   	push   %esi
80101e64:	e8 27 f9 ff ff       	call   80101790 <ilock>
    if(ip->type != T_DIR){
80101e69:	83 c4 10             	add    $0x10,%esp
80101e6c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e71:	0f 85 a1 00 00 00    	jne    80101f18 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e77:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e7a:	85 d2                	test   %edx,%edx
80101e7c:	74 09                	je     80101e87 <namex+0xe7>
80101e7e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e81:	0f 84 d9 00 00 00    	je     80101f60 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e87:	83 ec 04             	sub    $0x4,%esp
80101e8a:	6a 00                	push   $0x0
80101e8c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e8f:	56                   	push   %esi
80101e90:	e8 4b fe ff ff       	call   80101ce0 <dirlookup>
80101e95:	83 c4 10             	add    $0x10,%esp
80101e98:	89 c3                	mov    %eax,%ebx
80101e9a:	85 c0                	test   %eax,%eax
80101e9c:	74 7a                	je     80101f18 <namex+0x178>
  iunlock(ip);
80101e9e:	83 ec 0c             	sub    $0xc,%esp
80101ea1:	56                   	push   %esi
80101ea2:	e8 c9 f9 ff ff       	call   80101870 <iunlock>
  iput(ip);
80101ea7:	89 34 24             	mov    %esi,(%esp)
80101eaa:	89 de                	mov    %ebx,%esi
80101eac:	e8 0f fa ff ff       	call   801018c0 <iput>
80101eb1:	83 c4 10             	add    $0x10,%esp
80101eb4:	e9 3a ff ff ff       	jmp    80101df3 <namex+0x53>
80101eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ec0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ec3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101ec6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101ec9:	83 ec 04             	sub    $0x4,%esp
80101ecc:	50                   	push   %eax
80101ecd:	57                   	push   %edi
    name[len] = 0;
80101ece:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ed0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ed3:	e8 48 2e 00 00       	call   80104d20 <memmove>
    name[len] = 0;
80101ed8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101edb:	83 c4 10             	add    $0x10,%esp
80101ede:	c6 00 00             	movb   $0x0,(%eax)
80101ee1:	e9 69 ff ff ff       	jmp    80101e4f <namex+0xaf>
80101ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eed:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 85 00 00 00    	jne    80101f80 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
80101f05:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101f08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f0b:	89 fb                	mov    %edi,%ebx
80101f0d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101f10:	31 c0                	xor    %eax,%eax
80101f12:	eb b5                	jmp    80101ec9 <namex+0x129>
80101f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f18:	83 ec 0c             	sub    $0xc,%esp
80101f1b:	56                   	push   %esi
80101f1c:	e8 4f f9 ff ff       	call   80101870 <iunlock>
  iput(ip);
80101f21:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f24:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f26:	e8 95 f9 ff ff       	call   801018c0 <iput>
      return 0;
80101f2b:	83 c4 10             	add    $0x10,%esp
}
80101f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f31:	89 f0                	mov    %esi,%eax
80101f33:	5b                   	pop    %ebx
80101f34:	5e                   	pop    %esi
80101f35:	5f                   	pop    %edi
80101f36:	5d                   	pop    %ebp
80101f37:	c3                   	ret    
80101f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f3f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f40:	ba 01 00 00 00       	mov    $0x1,%edx
80101f45:	b8 01 00 00 00       	mov    $0x1,%eax
80101f4a:	89 df                	mov    %ebx,%edi
80101f4c:	e8 1f f4 ff ff       	call   80101370 <iget>
80101f51:	89 c6                	mov    %eax,%esi
80101f53:	e9 9b fe ff ff       	jmp    80101df3 <namex+0x53>
80101f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f5f:	90                   	nop
      iunlock(ip);
80101f60:	83 ec 0c             	sub    $0xc,%esp
80101f63:	56                   	push   %esi
80101f64:	e8 07 f9 ff ff       	call   80101870 <iunlock>
      return ip;
80101f69:	83 c4 10             	add    $0x10,%esp
}
80101f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f6f:	89 f0                	mov    %esi,%eax
80101f71:	5b                   	pop    %ebx
80101f72:	5e                   	pop    %esi
80101f73:	5f                   	pop    %edi
80101f74:	5d                   	pop    %ebp
80101f75:	c3                   	ret    
80101f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f80:	83 ec 0c             	sub    $0xc,%esp
80101f83:	56                   	push   %esi
    return 0;
80101f84:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f86:	e8 35 f9 ff ff       	call   801018c0 <iput>
    return 0;
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	e9 68 ff ff ff       	jmp    80101efb <namex+0x15b>
80101f93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101fa0 <dirlink>:
{
80101fa0:	f3 0f 1e fb          	endbr32 
80101fa4:	55                   	push   %ebp
80101fa5:	89 e5                	mov    %esp,%ebp
80101fa7:	57                   	push   %edi
80101fa8:	56                   	push   %esi
80101fa9:	53                   	push   %ebx
80101faa:	83 ec 20             	sub    $0x20,%esp
80101fad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fb0:	6a 00                	push   $0x0
80101fb2:	ff 75 0c             	pushl  0xc(%ebp)
80101fb5:	53                   	push   %ebx
80101fb6:	e8 25 fd ff ff       	call   80101ce0 <dirlookup>
80101fbb:	83 c4 10             	add    $0x10,%esp
80101fbe:	85 c0                	test   %eax,%eax
80101fc0:	75 6b                	jne    8010202d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fc2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fc5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fc8:	85 ff                	test   %edi,%edi
80101fca:	74 2d                	je     80101ff9 <dirlink+0x59>
80101fcc:	31 ff                	xor    %edi,%edi
80101fce:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fd1:	eb 0d                	jmp    80101fe0 <dirlink+0x40>
80101fd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fd7:	90                   	nop
80101fd8:	83 c7 10             	add    $0x10,%edi
80101fdb:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fde:	73 19                	jae    80101ff9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe0:	6a 10                	push   $0x10
80101fe2:	57                   	push   %edi
80101fe3:	56                   	push   %esi
80101fe4:	53                   	push   %ebx
80101fe5:	e8 a6 fa ff ff       	call   80101a90 <readi>
80101fea:	83 c4 10             	add    $0x10,%esp
80101fed:	83 f8 10             	cmp    $0x10,%eax
80101ff0:	75 4e                	jne    80102040 <dirlink+0xa0>
    if(de.inum == 0)
80101ff2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ff7:	75 df                	jne    80101fd8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101ff9:	83 ec 04             	sub    $0x4,%esp
80101ffc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fff:	6a 0e                	push   $0xe
80102001:	ff 75 0c             	pushl  0xc(%ebp)
80102004:	50                   	push   %eax
80102005:	e8 d6 2d 00 00       	call   80104de0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010200a:	6a 10                	push   $0x10
  de.inum = inum;
8010200c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010200f:	57                   	push   %edi
80102010:	56                   	push   %esi
80102011:	53                   	push   %ebx
  de.inum = inum;
80102012:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102016:	e8 75 fb ff ff       	call   80101b90 <writei>
8010201b:	83 c4 20             	add    $0x20,%esp
8010201e:	83 f8 10             	cmp    $0x10,%eax
80102021:	75 2a                	jne    8010204d <dirlink+0xad>
  return 0;
80102023:	31 c0                	xor    %eax,%eax
}
80102025:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102028:	5b                   	pop    %ebx
80102029:	5e                   	pop    %esi
8010202a:	5f                   	pop    %edi
8010202b:	5d                   	pop    %ebp
8010202c:	c3                   	ret    
    iput(ip);
8010202d:	83 ec 0c             	sub    $0xc,%esp
80102030:	50                   	push   %eax
80102031:	e8 8a f8 ff ff       	call   801018c0 <iput>
    return -1;
80102036:	83 c4 10             	add    $0x10,%esp
80102039:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010203e:	eb e5                	jmp    80102025 <dirlink+0x85>
      panic("dirlink read");
80102040:	83 ec 0c             	sub    $0xc,%esp
80102043:	68 28 79 10 80       	push   $0x80107928
80102048:	e8 43 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010204d:	83 ec 0c             	sub    $0xc,%esp
80102050:	68 6a 80 10 80       	push   $0x8010806a
80102055:	e8 36 e3 ff ff       	call   80100390 <panic>
8010205a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102060 <namei>:

struct inode*
namei(char *path)
{
80102060:	f3 0f 1e fb          	endbr32 
80102064:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102065:	31 d2                	xor    %edx,%edx
{
80102067:	89 e5                	mov    %esp,%ebp
80102069:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010206c:	8b 45 08             	mov    0x8(%ebp),%eax
8010206f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102072:	e8 29 fd ff ff       	call   80101da0 <namex>
}
80102077:	c9                   	leave  
80102078:	c3                   	ret    
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102080 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102080:	f3 0f 1e fb          	endbr32 
80102084:	55                   	push   %ebp
  return namex(path, 1, name);
80102085:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010208a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010208c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010208f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102092:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102093:	e9 08 fd ff ff       	jmp    80101da0 <namex>
80102098:	66 90                	xchg   %ax,%ax
8010209a:	66 90                	xchg   %ax,%ax
8010209c:	66 90                	xchg   %ax,%ax
8010209e:	66 90                	xchg   %ax,%ax

801020a0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	57                   	push   %edi
801020a4:	56                   	push   %esi
801020a5:	53                   	push   %ebx
801020a6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020a9:	85 c0                	test   %eax,%eax
801020ab:	0f 84 b4 00 00 00    	je     80102165 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020b1:	8b 70 08             	mov    0x8(%eax),%esi
801020b4:	89 c3                	mov    %eax,%ebx
801020b6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020bc:	0f 87 96 00 00 00    	ja     80102158 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ce:	66 90                	xchg   %ax,%ax
801020d0:	89 ca                	mov    %ecx,%edx
801020d2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020d3:	83 e0 c0             	and    $0xffffffc0,%eax
801020d6:	3c 40                	cmp    $0x40,%al
801020d8:	75 f6                	jne    801020d0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020da:	31 ff                	xor    %edi,%edi
801020dc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020e1:	89 f8                	mov    %edi,%eax
801020e3:	ee                   	out    %al,(%dx)
801020e4:	b8 01 00 00 00       	mov    $0x1,%eax
801020e9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020ee:	ee                   	out    %al,(%dx)
801020ef:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020f4:	89 f0                	mov    %esi,%eax
801020f6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020f7:	89 f0                	mov    %esi,%eax
801020f9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020fe:	c1 f8 08             	sar    $0x8,%eax
80102101:	ee                   	out    %al,(%dx)
80102102:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102107:	89 f8                	mov    %edi,%eax
80102109:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010210a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010210e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102113:	c1 e0 04             	shl    $0x4,%eax
80102116:	83 e0 10             	and    $0x10,%eax
80102119:	83 c8 e0             	or     $0xffffffe0,%eax
8010211c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010211d:	f6 03 04             	testb  $0x4,(%ebx)
80102120:	75 16                	jne    80102138 <idestart+0x98>
80102122:	b8 20 00 00 00       	mov    $0x20,%eax
80102127:	89 ca                	mov    %ecx,%edx
80102129:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010212a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010212d:	5b                   	pop    %ebx
8010212e:	5e                   	pop    %esi
8010212f:	5f                   	pop    %edi
80102130:	5d                   	pop    %ebp
80102131:	c3                   	ret    
80102132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102138:	b8 30 00 00 00       	mov    $0x30,%eax
8010213d:	89 ca                	mov    %ecx,%edx
8010213f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102140:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102145:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102148:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010214d:	fc                   	cld    
8010214e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102150:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102153:	5b                   	pop    %ebx
80102154:	5e                   	pop    %esi
80102155:	5f                   	pop    %edi
80102156:	5d                   	pop    %ebp
80102157:	c3                   	ret    
    panic("incorrect blockno");
80102158:	83 ec 0c             	sub    $0xc,%esp
8010215b:	68 94 79 10 80       	push   $0x80107994
80102160:	e8 2b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102165:	83 ec 0c             	sub    $0xc,%esp
80102168:	68 8b 79 10 80       	push   $0x8010798b
8010216d:	e8 1e e2 ff ff       	call   80100390 <panic>
80102172:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102180 <ideinit>:
{
80102180:	f3 0f 1e fb          	endbr32 
80102184:	55                   	push   %ebp
80102185:	89 e5                	mov    %esp,%ebp
80102187:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010218a:	68 a6 79 10 80       	push   $0x801079a6
8010218f:	68 80 b5 10 80       	push   $0x8010b580
80102194:	e8 57 28 00 00       	call   801049f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102199:	58                   	pop    %eax
8010219a:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010219f:	5a                   	pop    %edx
801021a0:	83 e8 01             	sub    $0x1,%eax
801021a3:	50                   	push   %eax
801021a4:	6a 0e                	push   $0xe
801021a6:	e8 b5 02 00 00       	call   80102460 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021ab:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ae:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021b7:	90                   	nop
801021b8:	ec                   	in     (%dx),%al
801021b9:	83 e0 c0             	and    $0xffffffc0,%eax
801021bc:	3c 40                	cmp    $0x40,%al
801021be:	75 f8                	jne    801021b8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021c5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ca:	ee                   	out    %al,(%dx)
801021cb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021d0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021d5:	eb 0e                	jmp    801021e5 <ideinit+0x65>
801021d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021de:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021e0:	83 e9 01             	sub    $0x1,%ecx
801021e3:	74 0f                	je     801021f4 <ideinit+0x74>
801021e5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021e6:	84 c0                	test   %al,%al
801021e8:	74 f6                	je     801021e0 <ideinit+0x60>
      havedisk1 = 1;
801021ea:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801021f1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021f9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021fe:	ee                   	out    %al,(%dx)
}
801021ff:	c9                   	leave  
80102200:	c3                   	ret    
80102201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010220f:	90                   	nop

80102210 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102210:	f3 0f 1e fb          	endbr32 
80102214:	55                   	push   %ebp
80102215:	89 e5                	mov    %esp,%ebp
80102217:	57                   	push   %edi
80102218:	56                   	push   %esi
80102219:	53                   	push   %ebx
8010221a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010221d:	68 80 b5 10 80       	push   $0x8010b580
80102222:	e8 49 29 00 00       	call   80104b70 <acquire>

  if((b = idequeue) == 0){
80102227:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010222d:	83 c4 10             	add    $0x10,%esp
80102230:	85 db                	test   %ebx,%ebx
80102232:	74 5f                	je     80102293 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102234:	8b 43 58             	mov    0x58(%ebx),%eax
80102237:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010223c:	8b 33                	mov    (%ebx),%esi
8010223e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102244:	75 2b                	jne    80102271 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102246:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010224b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010224f:	90                   	nop
80102250:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102251:	89 c1                	mov    %eax,%ecx
80102253:	83 e1 c0             	and    $0xffffffc0,%ecx
80102256:	80 f9 40             	cmp    $0x40,%cl
80102259:	75 f5                	jne    80102250 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010225b:	a8 21                	test   $0x21,%al
8010225d:	75 12                	jne    80102271 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010225f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102262:	b9 80 00 00 00       	mov    $0x80,%ecx
80102267:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010226c:	fc                   	cld    
8010226d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010226f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102271:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102274:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102277:	83 ce 02             	or     $0x2,%esi
8010227a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010227c:	53                   	push   %ebx
8010227d:	e8 0e 21 00 00       	call   80104390 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102282:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102287:	83 c4 10             	add    $0x10,%esp
8010228a:	85 c0                	test   %eax,%eax
8010228c:	74 05                	je     80102293 <ideintr+0x83>
    idestart(idequeue);
8010228e:	e8 0d fe ff ff       	call   801020a0 <idestart>
    release(&idelock);
80102293:	83 ec 0c             	sub    $0xc,%esp
80102296:	68 80 b5 10 80       	push   $0x8010b580
8010229b:	e8 90 29 00 00       	call   80104c30 <release>

  release(&idelock);
}
801022a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022a3:	5b                   	pop    %ebx
801022a4:	5e                   	pop    %esi
801022a5:	5f                   	pop    %edi
801022a6:	5d                   	pop    %ebp
801022a7:	c3                   	ret    
801022a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022af:	90                   	nop

801022b0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022b0:	f3 0f 1e fb          	endbr32 
801022b4:	55                   	push   %ebp
801022b5:	89 e5                	mov    %esp,%ebp
801022b7:	53                   	push   %ebx
801022b8:	83 ec 10             	sub    $0x10,%esp
801022bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022be:	8d 43 0c             	lea    0xc(%ebx),%eax
801022c1:	50                   	push   %eax
801022c2:	e8 c9 26 00 00       	call   80104990 <holdingsleep>
801022c7:	83 c4 10             	add    $0x10,%esp
801022ca:	85 c0                	test   %eax,%eax
801022cc:	0f 84 cf 00 00 00    	je     801023a1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022d2:	8b 03                	mov    (%ebx),%eax
801022d4:	83 e0 06             	and    $0x6,%eax
801022d7:	83 f8 02             	cmp    $0x2,%eax
801022da:	0f 84 b4 00 00 00    	je     80102394 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022e0:	8b 53 04             	mov    0x4(%ebx),%edx
801022e3:	85 d2                	test   %edx,%edx
801022e5:	74 0d                	je     801022f4 <iderw+0x44>
801022e7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801022ec:	85 c0                	test   %eax,%eax
801022ee:	0f 84 93 00 00 00    	je     80102387 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022f4:	83 ec 0c             	sub    $0xc,%esp
801022f7:	68 80 b5 10 80       	push   $0x8010b580
801022fc:	e8 6f 28 00 00       	call   80104b70 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102301:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
80102306:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010230d:	83 c4 10             	add    $0x10,%esp
80102310:	85 c0                	test   %eax,%eax
80102312:	74 6c                	je     80102380 <iderw+0xd0>
80102314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102318:	89 c2                	mov    %eax,%edx
8010231a:	8b 40 58             	mov    0x58(%eax),%eax
8010231d:	85 c0                	test   %eax,%eax
8010231f:	75 f7                	jne    80102318 <iderw+0x68>
80102321:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102324:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102326:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010232c:	74 42                	je     80102370 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010232e:	8b 03                	mov    (%ebx),%eax
80102330:	83 e0 06             	and    $0x6,%eax
80102333:	83 f8 02             	cmp    $0x2,%eax
80102336:	74 23                	je     8010235b <iderw+0xab>
80102338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop
    sleep(b, &idelock);
80102340:	83 ec 08             	sub    $0x8,%esp
80102343:	68 80 b5 10 80       	push   $0x8010b580
80102348:	53                   	push   %ebx
80102349:	e8 82 1e 00 00       	call   801041d0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010234e:	8b 03                	mov    (%ebx),%eax
80102350:	83 c4 10             	add    $0x10,%esp
80102353:	83 e0 06             	and    $0x6,%eax
80102356:	83 f8 02             	cmp    $0x2,%eax
80102359:	75 e5                	jne    80102340 <iderw+0x90>
  }


  release(&idelock);
8010235b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102362:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102365:	c9                   	leave  
  release(&idelock);
80102366:	e9 c5 28 00 00       	jmp    80104c30 <release>
8010236b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010236f:	90                   	nop
    idestart(b);
80102370:	89 d8                	mov    %ebx,%eax
80102372:	e8 29 fd ff ff       	call   801020a0 <idestart>
80102377:	eb b5                	jmp    8010232e <iderw+0x7e>
80102379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102380:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102385:	eb 9d                	jmp    80102324 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102387:	83 ec 0c             	sub    $0xc,%esp
8010238a:	68 d5 79 10 80       	push   $0x801079d5
8010238f:	e8 fc df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102394:	83 ec 0c             	sub    $0xc,%esp
80102397:	68 c0 79 10 80       	push   $0x801079c0
8010239c:	e8 ef df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801023a1:	83 ec 0c             	sub    $0xc,%esp
801023a4:	68 aa 79 10 80       	push   $0x801079aa
801023a9:	e8 e2 df ff ff       	call   80100390 <panic>
801023ae:	66 90                	xchg   %ax,%ax

801023b0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023b0:	f3 0f 1e fb          	endbr32 
801023b4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023b5:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
801023bc:	00 c0 fe 
{
801023bf:	89 e5                	mov    %esp,%ebp
801023c1:	56                   	push   %esi
801023c2:	53                   	push   %ebx
  ioapic->reg = reg;
801023c3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023ca:	00 00 00 
  return ioapic->data;
801023cd:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801023d3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023d6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023dc:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023e2:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023e9:	c1 ee 10             	shr    $0x10,%esi
801023ec:	89 f0                	mov    %esi,%eax
801023ee:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023f1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023f4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023f7:	39 c2                	cmp    %eax,%edx
801023f9:	74 16                	je     80102411 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023fb:	83 ec 0c             	sub    $0xc,%esp
801023fe:	68 f4 79 10 80       	push   $0x801079f4
80102403:	e8 a8 e2 ff ff       	call   801006b0 <cprintf>
80102408:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010240e:	83 c4 10             	add    $0x10,%esp
80102411:	83 c6 21             	add    $0x21,%esi
{
80102414:	ba 10 00 00 00       	mov    $0x10,%edx
80102419:	b8 20 00 00 00       	mov    $0x20,%eax
8010241e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102420:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102422:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102424:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010242a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010242d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102433:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102436:	8d 5a 01             	lea    0x1(%edx),%ebx
80102439:	83 c2 02             	add    $0x2,%edx
8010243c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010243e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102444:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010244b:	39 f0                	cmp    %esi,%eax
8010244d:	75 d1                	jne    80102420 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010244f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102452:	5b                   	pop    %ebx
80102453:	5e                   	pop    %esi
80102454:	5d                   	pop    %ebp
80102455:	c3                   	ret    
80102456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010245d:	8d 76 00             	lea    0x0(%esi),%esi

80102460 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102460:	f3 0f 1e fb          	endbr32 
80102464:	55                   	push   %ebp
  ioapic->reg = reg;
80102465:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
8010246b:	89 e5                	mov    %esp,%ebp
8010246d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102470:	8d 50 20             	lea    0x20(%eax),%edx
80102473:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102477:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102479:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010247f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102482:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102485:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102488:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010248a:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010248f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102492:	89 50 10             	mov    %edx,0x10(%eax)
}
80102495:	5d                   	pop    %ebp
80102496:	c3                   	ret    
80102497:	66 90                	xchg   %ax,%ax
80102499:	66 90                	xchg   %ax,%ax
8010249b:	66 90                	xchg   %ax,%ax
8010249d:	66 90                	xchg   %ax,%ax
8010249f:	90                   	nop

801024a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024a0:	f3 0f 1e fb          	endbr32 
801024a4:	55                   	push   %ebp
801024a5:	89 e5                	mov    %esp,%ebp
801024a7:	53                   	push   %ebx
801024a8:	83 ec 04             	sub    $0x4,%esp
801024ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ae:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024b4:	75 7a                	jne    80102530 <kfree+0x90>
801024b6:	81 fb a8 aa 11 80    	cmp    $0x8011aaa8,%ebx
801024bc:	72 72                	jb     80102530 <kfree+0x90>
801024be:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024c4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024c9:	77 65                	ja     80102530 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024cb:	83 ec 04             	sub    $0x4,%esp
801024ce:	68 00 10 00 00       	push   $0x1000
801024d3:	6a 01                	push   $0x1
801024d5:	53                   	push   %ebx
801024d6:	e8 a5 27 00 00       	call   80104c80 <memset>

  if(kmem.use_lock)
801024db:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801024e1:	83 c4 10             	add    $0x10,%esp
801024e4:	85 d2                	test   %edx,%edx
801024e6:	75 20                	jne    80102508 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024e8:	a1 78 36 11 80       	mov    0x80113678,%eax
801024ed:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024ef:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801024f4:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801024fa:	85 c0                	test   %eax,%eax
801024fc:	75 22                	jne    80102520 <kfree+0x80>
    release(&kmem.lock);
}
801024fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102501:	c9                   	leave  
80102502:	c3                   	ret    
80102503:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102507:	90                   	nop
    acquire(&kmem.lock);
80102508:	83 ec 0c             	sub    $0xc,%esp
8010250b:	68 40 36 11 80       	push   $0x80113640
80102510:	e8 5b 26 00 00       	call   80104b70 <acquire>
80102515:	83 c4 10             	add    $0x10,%esp
80102518:	eb ce                	jmp    801024e8 <kfree+0x48>
8010251a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102520:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102527:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010252a:	c9                   	leave  
    release(&kmem.lock);
8010252b:	e9 00 27 00 00       	jmp    80104c30 <release>
    panic("kfree");
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 26 7a 10 80       	push   $0x80107a26
80102538:	e8 53 de ff ff       	call   80100390 <panic>
8010253d:	8d 76 00             	lea    0x0(%esi),%esi

80102540 <freerange>:
{
80102540:	f3 0f 1e fb          	endbr32 
80102544:	55                   	push   %ebp
80102545:	89 e5                	mov    %esp,%ebp
80102547:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102548:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010254b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010254e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010254f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102555:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010255b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102561:	39 de                	cmp    %ebx,%esi
80102563:	72 1f                	jb     80102584 <freerange+0x44>
80102565:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102571:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102577:	50                   	push   %eax
80102578:	e8 23 ff ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	39 f3                	cmp    %esi,%ebx
80102582:	76 e4                	jbe    80102568 <freerange+0x28>
}
80102584:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102587:	5b                   	pop    %ebx
80102588:	5e                   	pop    %esi
80102589:	5d                   	pop    %ebp
8010258a:	c3                   	ret    
8010258b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010258f:	90                   	nop

80102590 <kinit1>:
{
80102590:	f3 0f 1e fb          	endbr32 
80102594:	55                   	push   %ebp
80102595:	89 e5                	mov    %esp,%ebp
80102597:	56                   	push   %esi
80102598:	53                   	push   %ebx
80102599:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010259c:	83 ec 08             	sub    $0x8,%esp
8010259f:	68 2c 7a 10 80       	push   $0x80107a2c
801025a4:	68 40 36 11 80       	push   $0x80113640
801025a9:	e8 42 24 00 00       	call   801049f0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801025ae:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801025b4:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
801025bb:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801025be:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	72 20                	jb     801025f4 <kinit1+0x64>
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 b3 fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit1+0x48>
}
801025f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025f7:	5b                   	pop    %ebx
801025f8:	5e                   	pop    %esi
801025f9:	5d                   	pop    %ebp
801025fa:	c3                   	ret    
801025fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025ff:	90                   	nop

80102600 <kinit2>:
{
80102600:	f3 0f 1e fb          	endbr32 
80102604:	55                   	push   %ebp
80102605:	89 e5                	mov    %esp,%ebp
80102607:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102608:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010260b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010260e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010260f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102615:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102621:	39 de                	cmp    %ebx,%esi
80102623:	72 1f                	jb     80102644 <kinit2+0x44>
80102625:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102628:	83 ec 0c             	sub    $0xc,%esp
8010262b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102631:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102637:	50                   	push   %eax
80102638:	e8 63 fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	39 de                	cmp    %ebx,%esi
80102642:	73 e4                	jae    80102628 <kinit2+0x28>
  kmem.use_lock = 1;
80102644:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010264b:	00 00 00 
}
8010264e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102651:	5b                   	pop    %ebx
80102652:	5e                   	pop    %esi
80102653:	5d                   	pop    %ebp
80102654:	c3                   	ret    
80102655:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010265c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102660 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102660:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102664:	a1 74 36 11 80       	mov    0x80113674,%eax
80102669:	85 c0                	test   %eax,%eax
8010266b:	75 1b                	jne    80102688 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010266d:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
80102672:	85 c0                	test   %eax,%eax
80102674:	74 0a                	je     80102680 <kalloc+0x20>
    kmem.freelist = r->next;
80102676:	8b 10                	mov    (%eax),%edx
80102678:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
8010267e:	c3                   	ret    
8010267f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102680:	c3                   	ret    
80102681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102688:	55                   	push   %ebp
80102689:	89 e5                	mov    %esp,%ebp
8010268b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010268e:	68 40 36 11 80       	push   $0x80113640
80102693:	e8 d8 24 00 00       	call   80104b70 <acquire>
  r = kmem.freelist;
80102698:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010269d:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801026a3:	83 c4 10             	add    $0x10,%esp
801026a6:	85 c0                	test   %eax,%eax
801026a8:	74 08                	je     801026b2 <kalloc+0x52>
    kmem.freelist = r->next;
801026aa:	8b 08                	mov    (%eax),%ecx
801026ac:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
801026b2:	85 d2                	test   %edx,%edx
801026b4:	74 16                	je     801026cc <kalloc+0x6c>
    release(&kmem.lock);
801026b6:	83 ec 0c             	sub    $0xc,%esp
801026b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026bc:	68 40 36 11 80       	push   $0x80113640
801026c1:	e8 6a 25 00 00       	call   80104c30 <release>
  return (char*)r;
801026c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026c9:	83 c4 10             	add    $0x10,%esp
}
801026cc:	c9                   	leave  
801026cd:	c3                   	ret    
801026ce:	66 90                	xchg   %ax,%ax

801026d0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026d0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026d4:	ba 64 00 00 00       	mov    $0x64,%edx
801026d9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026da:	a8 01                	test   $0x1,%al
801026dc:	0f 84 be 00 00 00    	je     801027a0 <kbdgetc+0xd0>
{
801026e2:	55                   	push   %ebp
801026e3:	ba 60 00 00 00       	mov    $0x60,%edx
801026e8:	89 e5                	mov    %esp,%ebp
801026ea:	53                   	push   %ebx
801026eb:	ec                   	in     (%dx),%al
  return data;
801026ec:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026f2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026f5:	3c e0                	cmp    $0xe0,%al
801026f7:	74 57                	je     80102750 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026f9:	89 d9                	mov    %ebx,%ecx
801026fb:	83 e1 40             	and    $0x40,%ecx
801026fe:	84 c0                	test   %al,%al
80102700:	78 5e                	js     80102760 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102702:	85 c9                	test   %ecx,%ecx
80102704:	74 09                	je     8010270f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102706:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102709:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010270c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010270f:	0f b6 8a 60 7b 10 80 	movzbl -0x7fef84a0(%edx),%ecx
  shift ^= togglecode[data];
80102716:	0f b6 82 60 7a 10 80 	movzbl -0x7fef85a0(%edx),%eax
  shift |= shiftcode[data];
8010271d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010271f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102721:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102723:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102729:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010272c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010272f:	8b 04 85 40 7a 10 80 	mov    -0x7fef85c0(,%eax,4),%eax
80102736:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010273a:	74 0b                	je     80102747 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010273c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010273f:	83 fa 19             	cmp    $0x19,%edx
80102742:	77 44                	ja     80102788 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102744:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102747:	5b                   	pop    %ebx
80102748:	5d                   	pop    %ebp
80102749:	c3                   	ret    
8010274a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102750:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102753:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102755:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010275b:	5b                   	pop    %ebx
8010275c:	5d                   	pop    %ebp
8010275d:	c3                   	ret    
8010275e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102760:	83 e0 7f             	and    $0x7f,%eax
80102763:	85 c9                	test   %ecx,%ecx
80102765:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102768:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010276a:	0f b6 8a 60 7b 10 80 	movzbl -0x7fef84a0(%edx),%ecx
80102771:	83 c9 40             	or     $0x40,%ecx
80102774:	0f b6 c9             	movzbl %cl,%ecx
80102777:	f7 d1                	not    %ecx
80102779:	21 d9                	and    %ebx,%ecx
}
8010277b:	5b                   	pop    %ebx
8010277c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010277d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102783:	c3                   	ret    
80102784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102788:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010278b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010278e:	5b                   	pop    %ebx
8010278f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102790:	83 f9 1a             	cmp    $0x1a,%ecx
80102793:	0f 42 c2             	cmovb  %edx,%eax
}
80102796:	c3                   	ret    
80102797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010279e:	66 90                	xchg   %ax,%ax
    return -1;
801027a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027a5:	c3                   	ret    
801027a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ad:	8d 76 00             	lea    0x0(%esi),%esi

801027b0 <kbdintr>:

void
kbdintr(void)
{
801027b0:	f3 0f 1e fb          	endbr32 
801027b4:	55                   	push   %ebp
801027b5:	89 e5                	mov    %esp,%ebp
801027b7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027ba:	68 d0 26 10 80       	push   $0x801026d0
801027bf:	e8 9c e0 ff ff       	call   80100860 <consoleintr>
}
801027c4:	83 c4 10             	add    $0x10,%esp
801027c7:	c9                   	leave  
801027c8:	c3                   	ret    
801027c9:	66 90                	xchg   %ax,%ax
801027cb:	66 90                	xchg   %ax,%ax
801027cd:	66 90                	xchg   %ax,%ax
801027cf:	90                   	nop

801027d0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027d0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027d4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801027d9:	85 c0                	test   %eax,%eax
801027db:	0f 84 c7 00 00 00    	je     801028a8 <lapicinit+0xd8>
  lapic[index] = value;
801027e1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027e8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ee:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027f5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102802:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102805:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102808:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010280f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102812:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102815:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010281c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010281f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102822:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102829:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010282c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010282f:	8b 50 30             	mov    0x30(%eax),%edx
80102832:	c1 ea 10             	shr    $0x10,%edx
80102835:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010283b:	75 73                	jne    801028b0 <lapicinit+0xe0>
  lapic[index] = value;
8010283d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102844:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102847:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102851:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102854:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102857:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010285e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102861:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102864:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010286b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102871:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102878:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102885:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102888:	8b 50 20             	mov    0x20(%eax),%edx
8010288b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010288f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102890:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102896:	80 e6 10             	and    $0x10,%dh
80102899:	75 f5                	jne    80102890 <lapicinit+0xc0>
  lapic[index] = value;
8010289b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028a2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028a8:	c3                   	ret    
801028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028b0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028b7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ba:	8b 50 20             	mov    0x20(%eax),%edx
}
801028bd:	e9 7b ff ff ff       	jmp    8010283d <lapicinit+0x6d>
801028c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028d0 <lapicid>:

int
lapicid(void)
{
801028d0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028d4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028d9:	85 c0                	test   %eax,%eax
801028db:	74 0b                	je     801028e8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028dd:	8b 40 20             	mov    0x20(%eax),%eax
801028e0:	c1 e8 18             	shr    $0x18,%eax
801028e3:	c3                   	ret    
801028e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028e8:	31 c0                	xor    %eax,%eax
}
801028ea:	c3                   	ret    
801028eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ef:	90                   	nop

801028f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028f0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028f4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028f9:	85 c0                	test   %eax,%eax
801028fb:	74 0d                	je     8010290a <lapiceoi+0x1a>
  lapic[index] = value;
801028fd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102904:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102907:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010290a:	c3                   	ret    
8010290b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010290f:	90                   	nop

80102910 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102910:	f3 0f 1e fb          	endbr32 
}
80102914:	c3                   	ret    
80102915:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102920 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102920:	f3 0f 1e fb          	endbr32 
80102924:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102925:	b8 0f 00 00 00       	mov    $0xf,%eax
8010292a:	ba 70 00 00 00       	mov    $0x70,%edx
8010292f:	89 e5                	mov    %esp,%ebp
80102931:	53                   	push   %ebx
80102932:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102935:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102938:	ee                   	out    %al,(%dx)
80102939:	b8 0a 00 00 00       	mov    $0xa,%eax
8010293e:	ba 71 00 00 00       	mov    $0x71,%edx
80102943:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102944:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102946:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102949:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010294f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102951:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102954:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102956:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102959:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010295c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102962:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102967:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010296d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102970:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102977:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010297a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010297d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102984:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102987:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102990:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102993:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102999:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010299c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801029ab:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 40 20             	mov    0x20(%eax),%eax
}
801029af:	5d                   	pop    %ebp
801029b0:	c3                   	ret    
801029b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029bf:	90                   	nop

801029c0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029c0:	f3 0f 1e fb          	endbr32 
801029c4:	55                   	push   %ebp
801029c5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029ca:	ba 70 00 00 00       	mov    $0x70,%edx
801029cf:	89 e5                	mov    %esp,%ebp
801029d1:	57                   	push   %edi
801029d2:	56                   	push   %esi
801029d3:	53                   	push   %ebx
801029d4:	83 ec 4c             	sub    $0x4c,%esp
801029d7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d8:	ba 71 00 00 00       	mov    $0x71,%edx
801029dd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029de:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029e6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029f0:	31 c0                	xor    %eax,%eax
801029f2:	89 da                	mov    %ebx,%edx
801029f4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029fa:	89 ca                	mov    %ecx,%edx
801029fc:	ec                   	in     (%dx),%al
801029fd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a00:	89 da                	mov    %ebx,%edx
80102a02:	b8 02 00 00 00       	mov    $0x2,%eax
80102a07:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a08:	89 ca                	mov    %ecx,%edx
80102a0a:	ec                   	in     (%dx),%al
80102a0b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0e:	89 da                	mov    %ebx,%edx
80102a10:	b8 04 00 00 00       	mov    $0x4,%eax
80102a15:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a16:	89 ca                	mov    %ecx,%edx
80102a18:	ec                   	in     (%dx),%al
80102a19:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1c:	89 da                	mov    %ebx,%edx
80102a1e:	b8 07 00 00 00       	mov    $0x7,%eax
80102a23:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a24:	89 ca                	mov    %ecx,%edx
80102a26:	ec                   	in     (%dx),%al
80102a27:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2a:	89 da                	mov    %ebx,%edx
80102a2c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a31:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a32:	89 ca                	mov    %ecx,%edx
80102a34:	ec                   	in     (%dx),%al
80102a35:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a37:	89 da                	mov    %ebx,%edx
80102a39:	b8 09 00 00 00       	mov    $0x9,%eax
80102a3e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3f:	89 ca                	mov    %ecx,%edx
80102a41:	ec                   	in     (%dx),%al
80102a42:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a44:	89 da                	mov    %ebx,%edx
80102a46:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4c:	89 ca                	mov    %ecx,%edx
80102a4e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a4f:	84 c0                	test   %al,%al
80102a51:	78 9d                	js     801029f0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a53:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a57:	89 fa                	mov    %edi,%edx
80102a59:	0f b6 fa             	movzbl %dl,%edi
80102a5c:	89 f2                	mov    %esi,%edx
80102a5e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a61:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a65:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a68:	89 da                	mov    %ebx,%edx
80102a6a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a6d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a70:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a74:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a77:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a7a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a7e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a81:	31 c0                	xor    %eax,%eax
80102a83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a84:	89 ca                	mov    %ecx,%edx
80102a86:	ec                   	in     (%dx),%al
80102a87:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8a:	89 da                	mov    %ebx,%edx
80102a8c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a8f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a94:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a95:	89 ca                	mov    %ecx,%edx
80102a97:	ec                   	in     (%dx),%al
80102a98:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9b:	89 da                	mov    %ebx,%edx
80102a9d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa0:	b8 04 00 00 00       	mov    $0x4,%eax
80102aa5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa6:	89 ca                	mov    %ecx,%edx
80102aa8:	ec                   	in     (%dx),%al
80102aa9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aac:	89 da                	mov    %ebx,%edx
80102aae:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab1:	b8 07 00 00 00       	mov    $0x7,%eax
80102ab6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab7:	89 ca                	mov    %ecx,%edx
80102ab9:	ec                   	in     (%dx),%al
80102aba:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abd:	89 da                	mov    %ebx,%edx
80102abf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ac2:	b8 08 00 00 00       	mov    $0x8,%eax
80102ac7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac8:	89 ca                	mov    %ecx,%edx
80102aca:	ec                   	in     (%dx),%al
80102acb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ace:	89 da                	mov    %ebx,%edx
80102ad0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ad3:	b8 09 00 00 00       	mov    $0x9,%eax
80102ad8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad9:	89 ca                	mov    %ecx,%edx
80102adb:	ec                   	in     (%dx),%al
80102adc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102adf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ae2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ae8:	6a 18                	push   $0x18
80102aea:	50                   	push   %eax
80102aeb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102aee:	50                   	push   %eax
80102aef:	e8 dc 21 00 00       	call   80104cd0 <memcmp>
80102af4:	83 c4 10             	add    $0x10,%esp
80102af7:	85 c0                	test   %eax,%eax
80102af9:	0f 85 f1 fe ff ff    	jne    801029f0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102aff:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b03:	75 78                	jne    80102b7d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b05:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b08:	89 c2                	mov    %eax,%edx
80102b0a:	83 e0 0f             	and    $0xf,%eax
80102b0d:	c1 ea 04             	shr    $0x4,%edx
80102b10:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b13:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b16:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b19:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b1c:	89 c2                	mov    %eax,%edx
80102b1e:	83 e0 0f             	and    $0xf,%eax
80102b21:	c1 ea 04             	shr    $0x4,%edx
80102b24:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b27:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b2a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b2d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b30:	89 c2                	mov    %eax,%edx
80102b32:	83 e0 0f             	and    $0xf,%eax
80102b35:	c1 ea 04             	shr    $0x4,%edx
80102b38:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b41:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b44:	89 c2                	mov    %eax,%edx
80102b46:	83 e0 0f             	and    $0xf,%eax
80102b49:	c1 ea 04             	shr    $0x4,%edx
80102b4c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b52:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b55:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b58:	89 c2                	mov    %eax,%edx
80102b5a:	83 e0 0f             	and    $0xf,%eax
80102b5d:	c1 ea 04             	shr    $0x4,%edx
80102b60:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b63:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b66:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b69:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b6c:	89 c2                	mov    %eax,%edx
80102b6e:	83 e0 0f             	and    $0xf,%eax
80102b71:	c1 ea 04             	shr    $0x4,%edx
80102b74:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b77:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b7d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b80:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b83:	89 06                	mov    %eax,(%esi)
80102b85:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b88:	89 46 04             	mov    %eax,0x4(%esi)
80102b8b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b8e:	89 46 08             	mov    %eax,0x8(%esi)
80102b91:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b94:	89 46 0c             	mov    %eax,0xc(%esi)
80102b97:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b9a:	89 46 10             	mov    %eax,0x10(%esi)
80102b9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102ba3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102baa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bad:	5b                   	pop    %ebx
80102bae:	5e                   	pop    %esi
80102baf:	5f                   	pop    %edi
80102bb0:	5d                   	pop    %ebp
80102bb1:	c3                   	ret    
80102bb2:	66 90                	xchg   %ax,%ax
80102bb4:	66 90                	xchg   %ax,%ax
80102bb6:	66 90                	xchg   %ax,%ax
80102bb8:	66 90                	xchg   %ax,%ax
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd2:	31 ff                	xor    %edi,%edi
{
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd cc 36 11 80 	pushl  -0x7feec934(,%edi,4)
80102c04:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 f7 20 00 00       	call   80104d20 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d c8 36 11 80    	cmp    %edi,0x801136c8
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret    
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c3                   	ret    
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c67:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102c6d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102c97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
}
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <initlog>:
{
80102cc0:	f3 0f 1e fb          	endbr32 
80102cc4:	55                   	push   %ebp
80102cc5:	89 e5                	mov    %esp,%ebp
80102cc7:	53                   	push   %ebx
80102cc8:	83 ec 2c             	sub    $0x2c,%esp
80102ccb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cce:	68 60 7c 10 80       	push   $0x80107c60
80102cd3:	68 80 36 11 80       	push   $0x80113680
80102cd8:	e8 13 1d 00 00       	call   801049f0 <initlock>
  readsb(dev, &sb);
80102cdd:	58                   	pop    %eax
80102cde:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ce1:	5a                   	pop    %edx
80102ce2:	50                   	push   %eax
80102ce3:	53                   	push   %ebx
80102ce4:	e8 47 e8 ff ff       	call   80101530 <readsb>
  log.start = sb.logstart;
80102ce9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cec:	59                   	pop    %ecx
  log.dev = dev;
80102ced:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102cf3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf6:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  log.size = sb.nlog;
80102cfb:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  struct buf *buf = bread(log.dev, log.start);
80102d01:	5a                   	pop    %edx
80102d02:	50                   	push   %eax
80102d03:	53                   	push   %ebx
80102d04:	e8 c7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d09:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d0c:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102d0f:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102d15:	85 c9                	test   %ecx,%ecx
80102d17:	7e 19                	jle    80102d32 <initlog+0x72>
80102d19:	31 d2                	xor    %edx,%edx
80102d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d1f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d20:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d24:	89 1c 95 cc 36 11 80 	mov    %ebx,-0x7feec934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d1                	cmp    %edx,%ecx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d40:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d47:	00 00 00 
  write_head(); // clear the log
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
}
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	f3 0f 1e fb          	endbr32 
80102d64:	55                   	push   %ebp
80102d65:	89 e5                	mov    %esp,%ebp
80102d67:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d6a:	68 80 36 11 80       	push   $0x80113680
80102d6f:	e8 fc 1d 00 00       	call   80104b70 <acquire>
80102d74:	83 c4 10             	add    $0x10,%esp
80102d77:	eb 1c                	jmp    80102d95 <begin_op+0x35>
80102d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d80:	83 ec 08             	sub    $0x8,%esp
80102d83:	68 80 36 11 80       	push   $0x80113680
80102d88:	68 80 36 11 80       	push   $0x80113680
80102d8d:	e8 3e 14 00 00       	call   801041d0 <sleep>
80102d92:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d95:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102d9a:	85 c0                	test   %eax,%eax
80102d9c:	75 e2                	jne    80102d80 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d9e:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102da3:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102da9:	83 c0 01             	add    $0x1,%eax
80102dac:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102daf:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102db2:	83 fa 1e             	cmp    $0x1e,%edx
80102db5:	7f c9                	jg     80102d80 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102db7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dba:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102dbf:	68 80 36 11 80       	push   $0x80113680
80102dc4:	e8 67 1e 00 00       	call   80104c30 <release>
      break;
    }
  }
}
80102dc9:	83 c4 10             	add    $0x10,%esp
80102dcc:	c9                   	leave  
80102dcd:	c3                   	ret    
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	f3 0f 1e fb          	endbr32 
80102dd4:	55                   	push   %ebp
80102dd5:	89 e5                	mov    %esp,%ebp
80102dd7:	57                   	push   %edi
80102dd8:	56                   	push   %esi
80102dd9:	53                   	push   %ebx
80102dda:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ddd:	68 80 36 11 80       	push   $0x80113680
80102de2:	e8 89 1d 00 00       	call   80104b70 <acquire>
  log.outstanding -= 1;
80102de7:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102dec:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102df2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df8:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102dfe:	85 f6                	test   %esi,%esi
80102e00:	0f 85 1e 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e06:	85 db                	test   %ebx,%ebx
80102e08:	0f 85 f2 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0e:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102e15:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e18:	83 ec 0c             	sub    $0xc,%esp
80102e1b:	68 80 36 11 80       	push   $0x80113680
80102e20:	e8 0b 1e 00 00       	call   80104c30 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e25:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102e2b:	83 c4 10             	add    $0x10,%esp
80102e2e:	85 c9                	test   %ecx,%ecx
80102e30:	7f 3e                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e32:	83 ec 0c             	sub    $0xc,%esp
80102e35:	68 80 36 11 80       	push   $0x80113680
80102e3a:	e8 31 1d 00 00       	call   80104b70 <acquire>
    wakeup(&log);
80102e3f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102e46:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102e4d:	00 00 00 
    wakeup(&log);
80102e50:	e8 3b 15 00 00       	call   80104390 <wakeup>
    release(&log.lock);
80102e55:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102e5c:	e8 cf 1d 00 00       	call   80104c30 <release>
80102e61:	83 c4 10             	add    $0x10,%esp
}
80102e64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e67:	5b                   	pop    %ebx
80102e68:	5e                   	pop    %esi
80102e69:	5f                   	pop    %edi
80102e6a:	5d                   	pop    %ebp
80102e6b:	c3                   	ret    
80102e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e70:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102e94:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ea2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 67 1e 00 00       	call   80104d20 <memmove>
    bwrite(to);  // write the log
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 38 ff ff ff       	jmp    80102e32 <end_op+0x62>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 80 36 11 80       	push   $0x80113680
80102f08:	e8 83 14 00 00       	call   80104390 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102f14:	e8 17 1d 00 00       	call   80104c30 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret    
    panic("log.committing");
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 64 7c 10 80       	push   $0x80107c64
80102f2c:	e8 5f d4 ff ff       	call   80100390 <panic>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	f3 0f 1e fb          	endbr32 
80102f44:	55                   	push   %ebp
80102f45:	89 e5                	mov    %esp,%ebp
80102f47:	53                   	push   %ebx
80102f48:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f4b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102f51:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f54:	83 fa 1d             	cmp    $0x1d,%edx
80102f57:	0f 8f 91 00 00 00    	jg     80102fee <log_write+0xae>
80102f5d:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102f62:	83 e8 01             	sub    $0x1,%eax
80102f65:	39 c2                	cmp    %eax,%edx
80102f67:	0f 8d 81 00 00 00    	jge    80102fee <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f6d:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f72:	85 c0                	test   %eax,%eax
80102f74:	0f 8e 81 00 00 00    	jle    80102ffb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f7a:	83 ec 0c             	sub    $0xc,%esp
80102f7d:	68 80 36 11 80       	push   $0x80113680
80102f82:	e8 e9 1b 00 00       	call   80104b70 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f87:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102f8d:	83 c4 10             	add    $0x10,%esp
80102f90:	85 d2                	test   %edx,%edx
80102f92:	7e 4e                	jle    80102fe2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f94:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f97:	31 c0                	xor    %eax,%eax
80102f99:	eb 0c                	jmp    80102fa7 <log_write+0x67>
80102f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f9f:	90                   	nop
80102fa0:	83 c0 01             	add    $0x1,%eax
80102fa3:	39 c2                	cmp    %eax,%edx
80102fa5:	74 29                	je     80102fd0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fa7:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102fae:	75 f0                	jne    80102fa0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fb7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fbd:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102fc4:	c9                   	leave  
  release(&log.lock);
80102fc5:	e9 66 1c 00 00       	jmp    80104c30 <release>
80102fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fd0:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
    log.lh.n++;
80102fd7:	83 c2 01             	add    $0x1,%edx
80102fda:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
80102fe0:	eb d5                	jmp    80102fb7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fe2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fe5:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102fea:	75 cb                	jne    80102fb7 <log_write+0x77>
80102fec:	eb e9                	jmp    80102fd7 <log_write+0x97>
    panic("too big a transaction");
80102fee:	83 ec 0c             	sub    $0xc,%esp
80102ff1:	68 73 7c 10 80       	push   $0x80107c73
80102ff6:	e8 95 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102ffb:	83 ec 0c             	sub    $0xc,%esp
80102ffe:	68 89 7c 10 80       	push   $0x80107c89
80103003:	e8 88 d3 ff ff       	call   80100390 <panic>
80103008:	66 90                	xchg   %ax,%ax
8010300a:	66 90                	xchg   %ax,%ax
8010300c:	66 90                	xchg   %ax,%ax
8010300e:	66 90                	xchg   %ax,%ax

80103010 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	53                   	push   %ebx
80103014:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103017:	e8 f4 08 00 00       	call   80103910 <cpuid>
8010301c:	89 c3                	mov    %eax,%ebx
8010301e:	e8 ed 08 00 00       	call   80103910 <cpuid>
80103023:	83 ec 04             	sub    $0x4,%esp
80103026:	53                   	push   %ebx
80103027:	50                   	push   %eax
80103028:	68 a4 7c 10 80       	push   $0x80107ca4
8010302d:	e8 7e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103032:	e8 c9 2f 00 00       	call   80106000 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103037:	e8 64 08 00 00       	call   801038a0 <mycpu>
8010303c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010303e:	b8 01 00 00 00       	mov    $0x1,%eax
80103043:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010304a:	e8 01 0e 00 00       	call   80103e50 <scheduler>
8010304f:	90                   	nop

80103050 <mpenter>:
{
80103050:	f3 0f 1e fb          	endbr32 
80103054:	55                   	push   %ebp
80103055:	89 e5                	mov    %esp,%ebp
80103057:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010305a:	e8 71 40 00 00       	call   801070d0 <switchkvm>
  seginit();
8010305f:	e8 dc 3f 00 00       	call   80107040 <seginit>
  lapicinit();
80103064:	e8 67 f7 ff ff       	call   801027d0 <lapicinit>
  mpmain();
80103069:	e8 a2 ff ff ff       	call   80103010 <mpmain>
8010306e:	66 90                	xchg   %ax,%ax

80103070 <main>:
{
80103070:	f3 0f 1e fb          	endbr32 
80103074:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103078:	83 e4 f0             	and    $0xfffffff0,%esp
8010307b:	ff 71 fc             	pushl  -0x4(%ecx)
8010307e:	55                   	push   %ebp
8010307f:	89 e5                	mov    %esp,%ebp
80103081:	53                   	push   %ebx
80103082:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103083:	83 ec 08             	sub    $0x8,%esp
80103086:	68 00 00 40 80       	push   $0x80400000
8010308b:	68 a8 aa 11 80       	push   $0x8011aaa8
80103090:	e8 fb f4 ff ff       	call   80102590 <kinit1>
  kvmalloc();      // kernel page table
80103095:	e8 16 45 00 00       	call   801075b0 <kvmalloc>
  mpinit();        // detect other processors
8010309a:	e8 81 01 00 00       	call   80103220 <mpinit>
  lapicinit();     // interrupt controller
8010309f:	e8 2c f7 ff ff       	call   801027d0 <lapicinit>
  seginit();       // segment descriptors
801030a4:	e8 97 3f 00 00       	call   80107040 <seginit>
  picinit();       // disable pic
801030a9:	e8 52 03 00 00       	call   80103400 <picinit>
  ioapicinit();    // another interrupt controller
801030ae:	e8 fd f2 ff ff       	call   801023b0 <ioapicinit>
  consoleinit();   // console hardware
801030b3:	e8 78 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801030b8:	e8 43 32 00 00       	call   80106300 <uartinit>
  pinit();         // process table
801030bd:	e8 be 07 00 00       	call   80103880 <pinit>
  tvinit();        // trap vectors
801030c2:	e8 b9 2e 00 00       	call   80105f80 <tvinit>
  binit();         // buffer cache
801030c7:	e8 74 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030cc:	e8 3f dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030d1:	e8 aa f0 ff ff       	call   80102180 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030d6:	83 c4 0c             	add    $0xc,%esp
801030d9:	68 8a 00 00 00       	push   $0x8a
801030de:	68 8c b4 10 80       	push   $0x8010b48c
801030e3:	68 00 70 00 80       	push   $0x80007000
801030e8:	e8 33 1c 00 00       	call   80104d20 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030ed:	83 c4 10             	add    $0x10,%esp
801030f0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801030f7:	00 00 00 
801030fa:	05 80 37 11 80       	add    $0x80113780,%eax
801030ff:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80103104:	76 7a                	jbe    80103180 <main+0x110>
80103106:	bb 80 37 11 80       	mov    $0x80113780,%ebx
8010310b:	eb 1c                	jmp    80103129 <main+0xb9>
8010310d:	8d 76 00             	lea    0x0(%esi),%esi
80103110:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103117:	00 00 00 
8010311a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103120:	05 80 37 11 80       	add    $0x80113780,%eax
80103125:	39 c3                	cmp    %eax,%ebx
80103127:	73 57                	jae    80103180 <main+0x110>
    if(c == mycpu())  // We've started already.
80103129:	e8 72 07 00 00       	call   801038a0 <mycpu>
8010312e:	39 c3                	cmp    %eax,%ebx
80103130:	74 de                	je     80103110 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103132:	e8 29 f5 ff ff       	call   80102660 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103137:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010313a:	c7 05 f8 6f 00 80 50 	movl   $0x80103050,0x80006ff8
80103141:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103144:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010314b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010314e:	05 00 10 00 00       	add    $0x1000,%eax
80103153:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103158:	0f b6 03             	movzbl (%ebx),%eax
8010315b:	68 00 70 00 00       	push   $0x7000
80103160:	50                   	push   %eax
80103161:	e8 ba f7 ff ff       	call   80102920 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103166:	83 c4 10             	add    $0x10,%esp
80103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103170:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103176:	85 c0                	test   %eax,%eax
80103178:	74 f6                	je     80103170 <main+0x100>
8010317a:	eb 94                	jmp    80103110 <main+0xa0>
8010317c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103180:	83 ec 08             	sub    $0x8,%esp
80103183:	68 00 00 00 8e       	push   $0x8e000000
80103188:	68 00 00 40 80       	push   $0x80400000
8010318d:	e8 6e f4 ff ff       	call   80102600 <kinit2>
  userinit();      // first user process
80103192:	e8 49 09 00 00       	call   80103ae0 <userinit>
  mpmain();        // finish this processor's setup
80103197:	e8 74 fe ff ff       	call   80103010 <mpmain>
8010319c:	66 90                	xchg   %ax,%ax
8010319e:	66 90                	xchg   %ax,%ax

801031a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	57                   	push   %edi
801031a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031ab:	53                   	push   %ebx
  e = addr+len;
801031ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031b2:	39 de                	cmp    %ebx,%esi
801031b4:	72 10                	jb     801031c6 <mpsearch1+0x26>
801031b6:	eb 50                	jmp    80103208 <mpsearch1+0x68>
801031b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031bf:	90                   	nop
801031c0:	89 fe                	mov    %edi,%esi
801031c2:	39 fb                	cmp    %edi,%ebx
801031c4:	76 42                	jbe    80103208 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031c6:	83 ec 04             	sub    $0x4,%esp
801031c9:	8d 7e 10             	lea    0x10(%esi),%edi
801031cc:	6a 04                	push   $0x4
801031ce:	68 b8 7c 10 80       	push   $0x80107cb8
801031d3:	56                   	push   %esi
801031d4:	e8 f7 1a 00 00       	call   80104cd0 <memcmp>
801031d9:	83 c4 10             	add    $0x10,%esp
801031dc:	85 c0                	test   %eax,%eax
801031de:	75 e0                	jne    801031c0 <mpsearch1+0x20>
801031e0:	89 f2                	mov    %esi,%edx
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031e8:	0f b6 0a             	movzbl (%edx),%ecx
801031eb:	83 c2 01             	add    $0x1,%edx
801031ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031f0:	39 fa                	cmp    %edi,%edx
801031f2:	75 f4                	jne    801031e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f4:	84 c0                	test   %al,%al
801031f6:	75 c8                	jne    801031c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031fb:	89 f0                	mov    %esi,%eax
801031fd:	5b                   	pop    %ebx
801031fe:	5e                   	pop    %esi
801031ff:	5f                   	pop    %edi
80103200:	5d                   	pop    %ebp
80103201:	c3                   	ret    
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103208:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010320b:	31 f6                	xor    %esi,%esi
}
8010320d:	5b                   	pop    %ebx
8010320e:	89 f0                	mov    %esi,%eax
80103210:	5e                   	pop    %esi
80103211:	5f                   	pop    %edi
80103212:	5d                   	pop    %ebp
80103213:	c3                   	ret    
80103214:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010321f:	90                   	nop

80103220 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103220:	f3 0f 1e fb          	endbr32 
80103224:	55                   	push   %ebp
80103225:	89 e5                	mov    %esp,%ebp
80103227:	57                   	push   %edi
80103228:	56                   	push   %esi
80103229:	53                   	push   %ebx
8010322a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010322d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103234:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010323b:	c1 e0 08             	shl    $0x8,%eax
8010323e:	09 d0                	or     %edx,%eax
80103240:	c1 e0 04             	shl    $0x4,%eax
80103243:	75 1b                	jne    80103260 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103245:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010324c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103253:	c1 e0 08             	shl    $0x8,%eax
80103256:	09 d0                	or     %edx,%eax
80103258:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010325b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103260:	ba 00 04 00 00       	mov    $0x400,%edx
80103265:	e8 36 ff ff ff       	call   801031a0 <mpsearch1>
8010326a:	89 c6                	mov    %eax,%esi
8010326c:	85 c0                	test   %eax,%eax
8010326e:	0f 84 4c 01 00 00    	je     801033c0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103274:	8b 5e 04             	mov    0x4(%esi),%ebx
80103277:	85 db                	test   %ebx,%ebx
80103279:	0f 84 61 01 00 00    	je     801033e0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103282:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103288:	6a 04                	push   $0x4
8010328a:	68 bd 7c 10 80       	push   $0x80107cbd
8010328f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103290:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103293:	e8 38 1a 00 00       	call   80104cd0 <memcmp>
80103298:	83 c4 10             	add    $0x10,%esp
8010329b:	85 c0                	test   %eax,%eax
8010329d:	0f 85 3d 01 00 00    	jne    801033e0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801032a3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801032aa:	3c 01                	cmp    $0x1,%al
801032ac:	74 08                	je     801032b6 <mpinit+0x96>
801032ae:	3c 04                	cmp    $0x4,%al
801032b0:	0f 85 2a 01 00 00    	jne    801033e0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801032b6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801032bd:	66 85 d2             	test   %dx,%dx
801032c0:	74 26                	je     801032e8 <mpinit+0xc8>
801032c2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032c5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032c7:	31 d2                	xor    %edx,%edx
801032c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032d0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032d7:	83 c0 01             	add    $0x1,%eax
801032da:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032dc:	39 f8                	cmp    %edi,%eax
801032de:	75 f0                	jne    801032d0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032e0:	84 d2                	test   %dl,%dl
801032e2:	0f 85 f8 00 00 00    	jne    801033e0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032e8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032ee:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032f3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032f9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103300:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103305:	03 55 e4             	add    -0x1c(%ebp),%edx
80103308:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010330b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010330f:	90                   	nop
80103310:	39 c2                	cmp    %eax,%edx
80103312:	76 15                	jbe    80103329 <mpinit+0x109>
    switch(*p){
80103314:	0f b6 08             	movzbl (%eax),%ecx
80103317:	80 f9 02             	cmp    $0x2,%cl
8010331a:	74 5c                	je     80103378 <mpinit+0x158>
8010331c:	77 42                	ja     80103360 <mpinit+0x140>
8010331e:	84 c9                	test   %cl,%cl
80103320:	74 6e                	je     80103390 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103322:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103325:	39 c2                	cmp    %eax,%edx
80103327:	77 eb                	ja     80103314 <mpinit+0xf4>
80103329:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010332c:	85 db                	test   %ebx,%ebx
8010332e:	0f 84 b9 00 00 00    	je     801033ed <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103334:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103338:	74 15                	je     8010334f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010333a:	b8 70 00 00 00       	mov    $0x70,%eax
8010333f:	ba 22 00 00 00       	mov    $0x22,%edx
80103344:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103345:	ba 23 00 00 00       	mov    $0x23,%edx
8010334a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010334b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010334e:	ee                   	out    %al,(%dx)
  }
}
8010334f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103352:	5b                   	pop    %ebx
80103353:	5e                   	pop    %esi
80103354:	5f                   	pop    %edi
80103355:	5d                   	pop    %ebp
80103356:	c3                   	ret    
80103357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010335e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103360:	83 e9 03             	sub    $0x3,%ecx
80103363:	80 f9 01             	cmp    $0x1,%cl
80103366:	76 ba                	jbe    80103322 <mpinit+0x102>
80103368:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010336f:	eb 9f                	jmp    80103310 <mpinit+0xf0>
80103371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103378:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010337c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010337f:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      continue;
80103385:	eb 89                	jmp    80103310 <mpinit+0xf0>
80103387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010338e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103390:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
80103396:	83 f9 07             	cmp    $0x7,%ecx
80103399:	7f 19                	jg     801033b4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010339b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033a1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033a5:	83 c1 01             	add    $0x1,%ecx
801033a8:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ae:	88 9f 80 37 11 80    	mov    %bl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
801033b4:	83 c0 14             	add    $0x14,%eax
      continue;
801033b7:	e9 54 ff ff ff       	jmp    80103310 <mpinit+0xf0>
801033bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033c0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033c5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033ca:	e8 d1 fd ff ff       	call   801031a0 <mpsearch1>
801033cf:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033d1:	85 c0                	test   %eax,%eax
801033d3:	0f 85 9b fe ff ff    	jne    80103274 <mpinit+0x54>
801033d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033e0:	83 ec 0c             	sub    $0xc,%esp
801033e3:	68 c2 7c 10 80       	push   $0x80107cc2
801033e8:	e8 a3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033ed:	83 ec 0c             	sub    $0xc,%esp
801033f0:	68 dc 7c 10 80       	push   $0x80107cdc
801033f5:	e8 96 cf ff ff       	call   80100390 <panic>
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103400:	f3 0f 1e fb          	endbr32 
80103404:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103409:	ba 21 00 00 00       	mov    $0x21,%edx
8010340e:	ee                   	out    %al,(%dx)
8010340f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103414:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103415:	c3                   	ret    
80103416:	66 90                	xchg   %ax,%ax
80103418:	66 90                	xchg   %ax,%ax
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103420:	f3 0f 1e fb          	endbr32 
80103424:	55                   	push   %ebp
80103425:	89 e5                	mov    %esp,%ebp
80103427:	57                   	push   %edi
80103428:	56                   	push   %esi
80103429:	53                   	push   %ebx
8010342a:	83 ec 0c             	sub    $0xc,%esp
8010342d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103430:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103433:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103439:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010343f:	e8 ec d9 ff ff       	call   80100e30 <filealloc>
80103444:	89 03                	mov    %eax,(%ebx)
80103446:	85 c0                	test   %eax,%eax
80103448:	0f 84 ac 00 00 00    	je     801034fa <pipealloc+0xda>
8010344e:	e8 dd d9 ff ff       	call   80100e30 <filealloc>
80103453:	89 06                	mov    %eax,(%esi)
80103455:	85 c0                	test   %eax,%eax
80103457:	0f 84 8b 00 00 00    	je     801034e8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010345d:	e8 fe f1 ff ff       	call   80102660 <kalloc>
80103462:	89 c7                	mov    %eax,%edi
80103464:	85 c0                	test   %eax,%eax
80103466:	0f 84 b4 00 00 00    	je     80103520 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010346c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103473:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103476:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103479:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103480:	00 00 00 
  p->nwrite = 0;
80103483:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010348a:	00 00 00 
  p->nread = 0;
8010348d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103494:	00 00 00 
  initlock(&p->lock, "pipe");
80103497:	68 fb 7c 10 80       	push   $0x80107cfb
8010349c:	50                   	push   %eax
8010349d:	e8 4e 15 00 00       	call   801049f0 <initlock>
  (*f0)->type = FD_PIPE;
801034a2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034a4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034a7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034ad:	8b 03                	mov    (%ebx),%eax
801034af:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034b3:	8b 03                	mov    (%ebx),%eax
801034b5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034b9:	8b 03                	mov    (%ebx),%eax
801034bb:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034be:	8b 06                	mov    (%esi),%eax
801034c0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034c6:	8b 06                	mov    (%esi),%eax
801034c8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034cc:	8b 06                	mov    (%esi),%eax
801034ce:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034da:	31 c0                	xor    %eax,%eax
}
801034dc:	5b                   	pop    %ebx
801034dd:	5e                   	pop    %esi
801034de:	5f                   	pop    %edi
801034df:	5d                   	pop    %ebp
801034e0:	c3                   	ret    
801034e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034e8:	8b 03                	mov    (%ebx),%eax
801034ea:	85 c0                	test   %eax,%eax
801034ec:	74 1e                	je     8010350c <pipealloc+0xec>
    fileclose(*f0);
801034ee:	83 ec 0c             	sub    $0xc,%esp
801034f1:	50                   	push   %eax
801034f2:	e8 f9 d9 ff ff       	call   80100ef0 <fileclose>
801034f7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034fa:	8b 06                	mov    (%esi),%eax
801034fc:	85 c0                	test   %eax,%eax
801034fe:	74 0c                	je     8010350c <pipealloc+0xec>
    fileclose(*f1);
80103500:	83 ec 0c             	sub    $0xc,%esp
80103503:	50                   	push   %eax
80103504:	e8 e7 d9 ff ff       	call   80100ef0 <fileclose>
80103509:	83 c4 10             	add    $0x10,%esp
}
8010350c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010350f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103514:	5b                   	pop    %ebx
80103515:	5e                   	pop    %esi
80103516:	5f                   	pop    %edi
80103517:	5d                   	pop    %ebp
80103518:	c3                   	ret    
80103519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103520:	8b 03                	mov    (%ebx),%eax
80103522:	85 c0                	test   %eax,%eax
80103524:	75 c8                	jne    801034ee <pipealloc+0xce>
80103526:	eb d2                	jmp    801034fa <pipealloc+0xda>
80103528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010352f:	90                   	nop

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	f3 0f 1e fb          	endbr32 
80103534:	55                   	push   %ebp
80103535:	89 e5                	mov    %esp,%ebp
80103537:	56                   	push   %esi
80103538:	53                   	push   %ebx
80103539:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010353c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353f:	83 ec 0c             	sub    $0xc,%esp
80103542:	53                   	push   %ebx
80103543:	e8 28 16 00 00       	call   80104b70 <acquire>
  if(writable){
80103548:	83 c4 10             	add    $0x10,%esp
8010354b:	85 f6                	test   %esi,%esi
8010354d:	74 41                	je     80103590 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354f:	83 ec 0c             	sub    $0xc,%esp
80103552:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103558:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355f:	00 00 00 
    wakeup(&p->nread);
80103562:	50                   	push   %eax
80103563:	e8 28 0e 00 00       	call   80104390 <wakeup>
80103568:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010356b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103571:	85 d2                	test   %edx,%edx
80103573:	75 0a                	jne    8010357f <pipeclose+0x4f>
80103575:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010357b:	85 c0                	test   %eax,%eax
8010357d:	74 31                	je     801035b0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103582:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103585:	5b                   	pop    %ebx
80103586:	5e                   	pop    %esi
80103587:	5d                   	pop    %ebp
    release(&p->lock);
80103588:	e9 a3 16 00 00       	jmp    80104c30 <release>
8010358d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103599:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035a0:	00 00 00 
    wakeup(&p->nwrite);
801035a3:	50                   	push   %eax
801035a4:	e8 e7 0d 00 00       	call   80104390 <wakeup>
801035a9:	83 c4 10             	add    $0x10,%esp
801035ac:	eb bd                	jmp    8010356b <pipeclose+0x3b>
801035ae:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	53                   	push   %ebx
801035b4:	e8 77 16 00 00       	call   80104c30 <release>
    kfree((char*)p);
801035b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035bc:	83 c4 10             	add    $0x10,%esp
}
801035bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035c2:	5b                   	pop    %ebx
801035c3:	5e                   	pop    %esi
801035c4:	5d                   	pop    %ebp
    kfree((char*)p);
801035c5:	e9 d6 ee ff ff       	jmp    801024a0 <kfree>
801035ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	f3 0f 1e fb          	endbr32 
801035d4:	55                   	push   %ebp
801035d5:	89 e5                	mov    %esp,%ebp
801035d7:	57                   	push   %edi
801035d8:	56                   	push   %esi
801035d9:	53                   	push   %ebx
801035da:	83 ec 28             	sub    $0x28,%esp
801035dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035e0:	53                   	push   %ebx
801035e1:	e8 8a 15 00 00       	call   80104b70 <acquire>
  for(i = 0; i < n; i++){
801035e6:	8b 45 10             	mov    0x10(%ebp),%eax
801035e9:	83 c4 10             	add    $0x10,%esp
801035ec:	85 c0                	test   %eax,%eax
801035ee:	0f 8e bc 00 00 00    	jle    801036b0 <pipewrite+0xe0>
801035f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035f7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035fd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103603:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103606:	03 45 10             	add    0x10(%ebp),%eax
80103609:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010360c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103612:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103618:	89 ca                	mov    %ecx,%edx
8010361a:	05 00 02 00 00       	add    $0x200,%eax
8010361f:	39 c1                	cmp    %eax,%ecx
80103621:	74 3b                	je     8010365e <pipewrite+0x8e>
80103623:	eb 63                	jmp    80103688 <pipewrite+0xb8>
80103625:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103628:	e8 03 03 00 00       	call   80103930 <myproc>
8010362d:	8b 48 24             	mov    0x24(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 53 0d 00 00       	call   80104390 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 8a 0b 00 00       	call   801041d0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103646:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103652:	83 c4 10             	add    $0x10,%esp
80103655:	05 00 02 00 00       	add    $0x200,%eax
8010365a:	39 c2                	cmp    %eax,%edx
8010365c:	75 2a                	jne    80103688 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010365e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c0                	jne    80103628 <pipewrite+0x58>
        release(&p->lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	53                   	push   %ebx
8010366c:	e8 bf 15 00 00       	call   80104c30 <release>
        return -1;
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103688:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010368b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010368e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103694:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010369a:	0f b6 06             	movzbl (%esi),%eax
8010369d:	83 c6 01             	add    $0x1,%esi
801036a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801036a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036aa:	0f 85 5c ff ff ff    	jne    8010360c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036b9:	50                   	push   %eax
801036ba:	e8 d1 0c 00 00       	call   80104390 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 69 15 00 00       	call   80104c30 <release>
  return n;
801036c7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	eb aa                	jmp    80103679 <pipewrite+0xa9>
801036cf:	90                   	nop

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	f3 0f 1e fb          	endbr32 
801036d4:	55                   	push   %ebp
801036d5:	89 e5                	mov    %esp,%ebp
801036d7:	57                   	push   %edi
801036d8:	56                   	push   %esi
801036d9:	53                   	push   %ebx
801036da:	83 ec 18             	sub    $0x18,%esp
801036dd:	8b 75 08             	mov    0x8(%ebp),%esi
801036e0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036e3:	56                   	push   %esi
801036e4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ea:	e8 81 14 00 00       	call   80104b70 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036ef:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fe:	74 33                	je     80103733 <piperead+0x63>
80103700:	eb 3b                	jmp    8010373d <piperead+0x6d>
80103702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103708:	e8 23 02 00 00       	call   80103930 <myproc>
8010370d:	8b 48 24             	mov    0x24(%eax),%ecx
80103710:	85 c9                	test   %ecx,%ecx
80103712:	0f 85 88 00 00 00    	jne    801037a0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103718:	83 ec 08             	sub    $0x8,%esp
8010371b:	56                   	push   %esi
8010371c:	53                   	push   %ebx
8010371d:	e8 ae 0a 00 00       	call   801041d0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103722:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103728:	83 c4 10             	add    $0x10,%esp
8010372b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103731:	75 0a                	jne    8010373d <piperead+0x6d>
80103733:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103739:	85 c0                	test   %eax,%eax
8010373b:	75 cb                	jne    80103708 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010373d:	8b 55 10             	mov    0x10(%ebp),%edx
80103740:	31 db                	xor    %ebx,%ebx
80103742:	85 d2                	test   %edx,%edx
80103744:	7f 28                	jg     8010376e <piperead+0x9e>
80103746:	eb 34                	jmp    8010377c <piperead+0xac>
80103748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010374f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103750:	8d 48 01             	lea    0x1(%eax),%ecx
80103753:	25 ff 01 00 00       	and    $0x1ff,%eax
80103758:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010375e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103763:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103766:	83 c3 01             	add    $0x1,%ebx
80103769:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010376c:	74 0e                	je     8010377c <piperead+0xac>
    if(p->nread == p->nwrite)
8010376e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103774:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010377a:	75 d4                	jne    80103750 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010377c:	83 ec 0c             	sub    $0xc,%esp
8010377f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103785:	50                   	push   %eax
80103786:	e8 05 0c 00 00       	call   80104390 <wakeup>
  release(&p->lock);
8010378b:	89 34 24             	mov    %esi,(%esp)
8010378e:	e8 9d 14 00 00       	call   80104c30 <release>
  return i;
80103793:	83 c4 10             	add    $0x10,%esp
}
80103796:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103799:	89 d8                	mov    %ebx,%eax
8010379b:	5b                   	pop    %ebx
8010379c:	5e                   	pop    %esi
8010379d:	5f                   	pop    %edi
8010379e:	5d                   	pop    %ebp
8010379f:	c3                   	ret    
      release(&p->lock);
801037a0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037a8:	56                   	push   %esi
801037a9:	e8 82 14 00 00       	call   80104c30 <release>
      return -1;
801037ae:	83 c4 10             	add    $0x10,%esp
}
801037b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037b4:	89 d8                	mov    %ebx,%eax
801037b6:	5b                   	pop    %ebx
801037b7:	5e                   	pop    %esi
801037b8:	5f                   	pop    %edi
801037b9:	5d                   	pop    %ebp
801037ba:	c3                   	ret    
801037bb:	66 90                	xchg   %ax,%ax
801037bd:	66 90                	xchg   %ax,%ax
801037bf:	90                   	nop

801037c0 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801037c0:	55                   	push   %ebp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c1:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
{
801037c6:	89 e5                	mov    %esp,%ebp
801037c8:	57                   	push   %edi
801037c9:	56                   	push   %esi
801037ca:	89 c6                	mov    %eax,%esi
  ushort ss;
  ushort padding6;
};

static inline int cas(volatile void* addr, int expected, int newval){
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
801037cc:	b8 02 00 00 00       	mov    $0x2,%eax
801037d1:	53                   	push   %ebx
801037d2:	bb 03 00 00 00       	mov    $0x3,%ebx
801037d7:	eb 15                	jmp    801037ee <wakeup1+0x2e>
801037d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e0:	81 c2 94 01 00 00    	add    $0x194,%edx
801037e6:	81 fa 54 a2 11 80    	cmp    $0x8011a254,%edx
801037ec:	74 33                	je     80103821 <wakeup1+0x61>
    if((p->state == SLEEPING || p->state == -SLEEPING) && p->chan == chan)
801037ee:	8b 4a 0c             	mov    0xc(%edx),%ecx
801037f1:	83 f9 02             	cmp    $0x2,%ecx
801037f4:	74 05                	je     801037fb <wakeup1+0x3b>
801037f6:	83 f9 fe             	cmp    $0xfffffffe,%ecx
801037f9:	75 e5                	jne    801037e0 <wakeup1+0x20>
801037fb:	39 72 20             	cmp    %esi,0x20(%edx)
801037fe:	75 e0                	jne    801037e0 <wakeup1+0x20>
      switch_state(&(p->state), SLEEPING, RUNNABLE);
80103800:	8d 4a 0c             	lea    0xc(%edx),%ecx
  while (!cas(state_ptr, old, new)){}
80103803:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103807:	90                   	nop
80103808:	f0 0f b1 19          	lock cmpxchg %ebx,(%ecx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010380c:	9c                   	pushf  
8010380d:	5f                   	pop    %edi
8010380e:	83 e7 40             	and    $0x40,%edi
80103811:	74 f5                	je     80103808 <wakeup1+0x48>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103813:	81 c2 94 01 00 00    	add    $0x194,%edx
80103819:	81 fa 54 a2 11 80    	cmp    $0x8011a254,%edx
8010381f:	75 cd                	jne    801037ee <wakeup1+0x2e>
}
80103821:	5b                   	pop    %ebx
80103822:	5e                   	pop    %esi
80103823:	5f                   	pop    %edi
80103824:	5d                   	pop    %ebp
80103825:	c3                   	ret    
80103826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010382d:	8d 76 00             	lea    0x0(%esi),%esi

80103830 <forkret>:
{
80103830:	f3 0f 1e fb          	endbr32 
80103834:	55                   	push   %ebp
80103835:	89 e5                	mov    %esp,%ebp
80103837:	83 ec 08             	sub    $0x8,%esp
  popcli();
8010383a:	e8 81 12 00 00       	call   80104ac0 <popcli>
  if (first) {
8010383f:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103844:	85 c0                	test   %eax,%eax
80103846:	75 08                	jne    80103850 <forkret+0x20>
}
80103848:	c9                   	leave  
80103849:	c3                   	ret    
8010384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103850:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103857:	00 00 00 
    iinit(ROOTDEV);
8010385a:	83 ec 0c             	sub    $0xc,%esp
8010385d:	6a 01                	push   $0x1
8010385f:	e8 0c dd ff ff       	call   80101570 <iinit>
    initlog(ROOTDEV);
80103864:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010386b:	e8 50 f4 ff ff       	call   80102cc0 <initlog>
}
80103870:	83 c4 10             	add    $0x10,%esp
80103873:	c9                   	leave  
80103874:	c3                   	ret    
80103875:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010387c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103880 <pinit>:
{
80103880:	f3 0f 1e fb          	endbr32 
80103884:	55                   	push   %ebp
80103885:	89 e5                	mov    %esp,%ebp
80103887:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010388a:	68 00 7d 10 80       	push   $0x80107d00
8010388f:	68 20 3d 11 80       	push   $0x80113d20
80103894:	e8 57 11 00 00       	call   801049f0 <initlock>
}
80103899:	83 c4 10             	add    $0x10,%esp
8010389c:	c9                   	leave  
8010389d:	c3                   	ret    
8010389e:	66 90                	xchg   %ax,%ax

801038a0 <mycpu>:
{
801038a0:	f3 0f 1e fb          	endbr32 
801038a4:	55                   	push   %ebp
801038a5:	89 e5                	mov    %esp,%ebp
801038a7:	56                   	push   %esi
801038a8:	53                   	push   %ebx
801038a9:	9c                   	pushf  
801038aa:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038ab:	f6 c4 02             	test   $0x2,%ah
801038ae:	75 4a                	jne    801038fa <mycpu+0x5a>
  apicid = lapicid();
801038b0:	e8 1b f0 ff ff       	call   801028d0 <lapicid>
  for (signum = 0; signum < ncpu; ++signum) {
801038b5:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
  apicid = lapicid();
801038bb:	89 c3                	mov    %eax,%ebx
  for (signum = 0; signum < ncpu; ++signum) {
801038bd:	85 f6                	test   %esi,%esi
801038bf:	7e 2c                	jle    801038ed <mycpu+0x4d>
801038c1:	31 d2                	xor    %edx,%edx
801038c3:	eb 0a                	jmp    801038cf <mycpu+0x2f>
801038c5:	8d 76 00             	lea    0x0(%esi),%esi
801038c8:	83 c2 01             	add    $0x1,%edx
801038cb:	39 f2                	cmp    %esi,%edx
801038cd:	74 1e                	je     801038ed <mycpu+0x4d>
    if (cpus[signum].apicid == apicid)
801038cf:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801038d5:	0f b6 81 80 37 11 80 	movzbl -0x7feec880(%ecx),%eax
801038dc:	39 d8                	cmp    %ebx,%eax
801038de:	75 e8                	jne    801038c8 <mycpu+0x28>
}
801038e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[signum];
801038e3:	8d 81 80 37 11 80    	lea    -0x7feec880(%ecx),%eax
}
801038e9:	5b                   	pop    %ebx
801038ea:	5e                   	pop    %esi
801038eb:	5d                   	pop    %ebp
801038ec:	c3                   	ret    
  panic("unknown apicid\n");
801038ed:	83 ec 0c             	sub    $0xc,%esp
801038f0:	68 07 7d 10 80       	push   $0x80107d07
801038f5:	e8 96 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801038fa:	83 ec 0c             	sub    $0xc,%esp
801038fd:	68 e4 7d 10 80       	push   $0x80107de4
80103902:	e8 89 ca ff ff       	call   80100390 <panic>
80103907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010390e:	66 90                	xchg   %ax,%ax

80103910 <cpuid>:
cpuid() {
80103910:	f3 0f 1e fb          	endbr32 
80103914:	55                   	push   %ebp
80103915:	89 e5                	mov    %esp,%ebp
80103917:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010391a:	e8 81 ff ff ff       	call   801038a0 <mycpu>
}
8010391f:	c9                   	leave  
  return mycpu()-cpus;
80103920:	2d 80 37 11 80       	sub    $0x80113780,%eax
80103925:	c1 f8 04             	sar    $0x4,%eax
80103928:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010392e:	c3                   	ret    
8010392f:	90                   	nop

80103930 <myproc>:
myproc(void) {
80103930:	f3 0f 1e fb          	endbr32 
80103934:	55                   	push   %ebp
80103935:	89 e5                	mov    %esp,%ebp
80103937:	53                   	push   %ebx
80103938:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010393b:	e8 30 11 00 00       	call   80104a70 <pushcli>
  c = mycpu();
80103940:	e8 5b ff ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103945:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010394b:	e8 70 11 00 00       	call   80104ac0 <popcli>
}
80103950:	83 c4 04             	add    $0x4,%esp
80103953:	89 d8                	mov    %ebx,%eax
80103955:	5b                   	pop    %ebx
80103956:	5d                   	pop    %ebp
80103957:	c3                   	ret    
80103958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010395f:	90                   	nop

80103960 <allocpid>:
{
80103960:	f3 0f 1e fb          	endbr32 
80103964:	55                   	push   %ebp
80103965:	89 e5                	mov    %esp,%ebp
80103967:	53                   	push   %ebx
80103968:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010396b:	e8 00 11 00 00       	call   80104a70 <pushcli>
    oldval = nextpid;
80103970:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80103975:	b9 04 b0 10 80       	mov    $0x8010b004,%ecx
  } while(!cas(&nextpid, oldval, nextpid + 1));
8010397a:	8d 58 01             	lea    0x1(%eax),%ebx
8010397d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103980:	f0 0f b1 19          	lock cmpxchg %ebx,(%ecx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103984:	9c                   	pushf  
80103985:	5a                   	pop    %edx
80103986:	83 e2 40             	and    $0x40,%edx
80103989:	74 f5                	je     80103980 <allocpid+0x20>
}
8010398b:	83 c4 04             	add    $0x4,%esp
8010398e:	5b                   	pop    %ebx
8010398f:	5d                   	pop    %ebp
80103990:	c3                   	ret    
80103991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010399f:	90                   	nop

801039a0 <allocproc>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	56                   	push   %esi
801039a4:	53                   	push   %ebx
  p = ptable.proc;
801039a5:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  pushcli();
801039aa:	e8 c1 10 00 00       	call   80104a70 <pushcli>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
801039af:	31 c0                	xor    %eax,%eax
801039b1:	b9 01 00 00 00       	mov    $0x1,%ecx
801039b6:	eb 1a                	jmp    801039d2 <allocproc+0x32>
801039b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop
    p++;
801039c0:	81 c3 94 01 00 00    	add    $0x194,%ebx
  while (p < &ptable.proc[NPROC] && !cas(&(p->state), UNUSED, EMBRYO)){
801039c6:	81 fb 54 a2 11 80    	cmp    $0x8011a254,%ebx
801039cc:	0f 84 be 00 00 00    	je     80103a90 <allocproc+0xf0>
801039d2:	8d 53 0c             	lea    0xc(%ebx),%edx
801039d5:	f0 0f b1 0a          	lock cmpxchg %ecx,(%edx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039d9:	9c                   	pushf  
801039da:	5a                   	pop    %edx
801039db:	83 e2 40             	and    $0x40,%edx
801039de:	74 e0                	je     801039c0 <allocproc+0x20>
  popcli();
801039e0:	e8 db 10 00 00       	call   80104ac0 <popcli>
  p->pid = allocpid();
801039e5:	e8 76 ff ff ff       	call   80103960 <allocpid>
801039ea:	89 43 10             	mov    %eax,0x10(%ebx)
  if((p->kstack = kalloc()) == 0){
801039ed:	e8 6e ec ff ff       	call   80102660 <kalloc>
801039f2:	89 43 08             	mov    %eax,0x8(%ebx)
801039f5:	89 c6                	mov    %eax,%esi
801039f7:	85 c0                	test   %eax,%eax
801039f9:	0f 84 a1 00 00 00    	je     80103aa0 <allocproc+0x100>
  p->user_trapframe_backup = (struct trapframe*)kalloc();
801039ff:	e8 5c ec ff ff       	call   80102660 <kalloc>
  memset(p->context, 0, sizeof *p->context);
80103a04:	83 ec 04             	sub    $0x4,%esp
  p->user_trapframe_backup = (struct trapframe*)kalloc();
80103a07:	89 83 90 01 00 00    	mov    %eax,0x190(%ebx)
  sp -= sizeof *p->tf;
80103a0d:	8d 86 b4 0f 00 00    	lea    0xfb4(%esi),%eax
  sp -= sizeof *p->context;
80103a13:	81 c6 9c 0f 00 00    	add    $0xf9c,%esi
  sp -= sizeof *p->tf;
80103a19:	89 43 18             	mov    %eax,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a1c:	c7 46 14 6b 5f 10 80 	movl   $0x80105f6b,0x14(%esi)
  p->context = (struct context*)sp;
80103a23:	89 73 1c             	mov    %esi,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a26:	6a 14                	push   $0x14
80103a28:	6a 00                	push   $0x0
80103a2a:	56                   	push   %esi
80103a2b:	e8 50 12 00 00       	call   80104c80 <memset>
  p->context->eip = (uint)forkret;
80103a30:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a33:	8d 93 90 01 00 00    	lea    0x190(%ebx),%edx
80103a39:	83 c4 10             	add    $0x10,%esp
80103a3c:	c7 40 10 30 38 10 80 	movl   $0x80103830,0x10(%eax)
  p->blocked_signal_mask = 0;
80103a43:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
80103a49:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103a50:	00 00 00 
  p->pending_signals = 0;
80103a53:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103a5a:	00 00 00 
  for (int signum = 0; signum < 32; signum++){
80103a5d:	8d 76 00             	lea    0x0(%esi),%esi
    p->signal_handlers[signum].sa_handler = SIG_DFL;
80103a60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    p->signal_handlers[signum].sigmask = 0;
80103a66:	83 c0 08             	add    $0x8,%eax
80103a69:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (int signum = 0; signum < 32; signum++){
80103a70:	39 c2                	cmp    %eax,%edx
80103a72:	75 ec                	jne    80103a60 <allocproc+0xc0>
  p->flag_frozen = 0;
80103a74:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->flag_in_user_handler = 0;
80103a7b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103a82:	00 00 00 
}
80103a85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a88:	89 d8                	mov    %ebx,%eax
80103a8a:	5b                   	pop    %ebx
80103a8b:	5e                   	pop    %esi
80103a8c:	5d                   	pop    %ebp
80103a8d:	c3                   	ret    
80103a8e:	66 90                	xchg   %ax,%ax
  popcli();
80103a90:	e8 2b 10 00 00       	call   80104ac0 <popcli>
  return 0;
80103a95:	31 db                	xor    %ebx,%ebx
}
80103a97:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a9a:	89 d8                	mov    %ebx,%eax
80103a9c:	5b                   	pop    %ebx
80103a9d:	5e                   	pop    %esi
80103a9e:	5d                   	pop    %ebp
80103a9f:	c3                   	ret    
    p->state = UNUSED;
80103aa0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103aa7:	31 db                	xor    %ebx,%ebx
80103aa9:	eb da                	jmp    80103a85 <allocproc+0xe5>
80103aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103aaf:	90                   	nop

80103ab0 <switch_state>:
void switch_state(enum procstate* state_ptr, enum procstate old, enum procstate new){
80103ab0:	f3 0f 1e fb          	endbr32 
80103ab4:	55                   	push   %ebp
80103ab5:	89 e5                	mov    %esp,%ebp
80103ab7:	53                   	push   %ebx
80103ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103abb:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103abe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  while (!cas(state_ptr, old, new)){}
80103ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103ac8:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103acc:	9c                   	pushf  
80103acd:	5a                   	pop    %edx
80103ace:	83 e2 40             	and    $0x40,%edx
80103ad1:	74 f5                	je     80103ac8 <switch_state+0x18>
}
80103ad3:	5b                   	pop    %ebx
80103ad4:	5d                   	pop    %ebp
80103ad5:	c3                   	ret    
80103ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103add:	8d 76 00             	lea    0x0(%esi),%esi

80103ae0 <userinit>:
{
80103ae0:	f3 0f 1e fb          	endbr32 
80103ae4:	55                   	push   %ebp
80103ae5:	89 e5                	mov    %esp,%ebp
80103ae7:	53                   	push   %ebx
80103ae8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103aeb:	e8 b0 fe ff ff       	call   801039a0 <allocproc>
80103af0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103af2:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103af7:	e8 34 3a 00 00       	call   80107530 <setupkvm>
80103afc:	89 43 04             	mov    %eax,0x4(%ebx)
80103aff:	85 c0                	test   %eax,%eax
80103b01:	0f 84 be 00 00 00    	je     80103bc5 <userinit+0xe5>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b07:	83 ec 04             	sub    $0x4,%esp
80103b0a:	68 2c 00 00 00       	push   $0x2c
80103b0f:	68 60 b4 10 80       	push   $0x8010b460
80103b14:	50                   	push   %eax
80103b15:	e8 e6 36 00 00       	call   80107200 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b1a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b1d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b23:	6a 4c                	push   $0x4c
80103b25:	6a 00                	push   $0x0
80103b27:	ff 73 18             	pushl  0x18(%ebx)
80103b2a:	e8 51 11 00 00       	call   80104c80 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b32:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b37:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b3a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b3f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b43:	8b 43 18             	mov    0x18(%ebx),%eax
80103b46:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b4a:	8b 43 18             	mov    0x18(%ebx),%eax
80103b4d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b51:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b55:	8b 43 18             	mov    0x18(%ebx),%eax
80103b58:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b5c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b60:	8b 43 18             	mov    0x18(%ebx),%eax
80103b63:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b6a:	8b 43 18             	mov    0x18(%ebx),%eax
80103b6d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b74:	8b 43 18             	mov    0x18(%ebx),%eax
80103b77:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b7e:	8d 43 6c             	lea    0x6c(%ebx),%eax
  if (!cas(&(p->state), EMBRYO, RUNNABLE)){
80103b81:	83 c3 0c             	add    $0xc,%ebx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b84:	6a 10                	push   $0x10
80103b86:	68 30 7d 10 80       	push   $0x80107d30
80103b8b:	50                   	push   %eax
80103b8c:	e8 af 12 00 00       	call   80104e40 <safestrcpy>
  p->cwd = namei("/");
80103b91:	c7 04 24 39 7d 10 80 	movl   $0x80107d39,(%esp)
80103b98:	e8 c3 e4 ff ff       	call   80102060 <namei>
80103b9d:	89 43 5c             	mov    %eax,0x5c(%ebx)
  pushcli();
80103ba0:	e8 cb 0e 00 00       	call   80104a70 <pushcli>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103ba5:	b8 01 00 00 00       	mov    $0x1,%eax
80103baa:	ba 03 00 00 00       	mov    $0x3,%edx
80103baf:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bb3:	9c                   	pushf  
80103bb4:	58                   	pop    %eax
  if (!cas(&(p->state), EMBRYO, RUNNABLE)){
80103bb5:	83 c4 10             	add    $0x10,%esp
80103bb8:	a8 40                	test   $0x40,%al
80103bba:	74 16                	je     80103bd2 <userinit+0xf2>
}
80103bbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bbf:	c9                   	leave  
  popcli();
80103bc0:	e9 fb 0e 00 00       	jmp    80104ac0 <popcli>
    panic("userinit: out of memory?");
80103bc5:	83 ec 0c             	sub    $0xc,%esp
80103bc8:	68 17 7d 10 80       	push   $0x80107d17
80103bcd:	e8 be c7 ff ff       	call   80100390 <panic>
    panic("switch state from embryo to runnable failed in userinit");
80103bd2:	83 ec 0c             	sub    $0xc,%esp
80103bd5:	68 0c 7e 10 80       	push   $0x80107e0c
80103bda:	e8 b1 c7 ff ff       	call   80100390 <panic>
80103bdf:	90                   	nop

80103be0 <growproc>:
{
80103be0:	f3 0f 1e fb          	endbr32 
80103be4:	55                   	push   %ebp
80103be5:	89 e5                	mov    %esp,%ebp
80103be7:	56                   	push   %esi
80103be8:	53                   	push   %ebx
80103be9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103bec:	e8 7f 0e 00 00       	call   80104a70 <pushcli>
  c = mycpu();
80103bf1:	e8 aa fc ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103bf6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bfc:	e8 bf 0e 00 00       	call   80104ac0 <popcli>
  sz = curproc->sz;
80103c01:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c03:	85 f6                	test   %esi,%esi
80103c05:	7f 19                	jg     80103c20 <growproc+0x40>
  } else if(n < 0){
80103c07:	75 37                	jne    80103c40 <growproc+0x60>
  switchuvm(curproc);
80103c09:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c0c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c0e:	53                   	push   %ebx
80103c0f:	e8 dc 34 00 00       	call   801070f0 <switchuvm>
  return 0;
80103c14:	83 c4 10             	add    $0x10,%esp
80103c17:	31 c0                	xor    %eax,%eax
}
80103c19:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c1c:	5b                   	pop    %ebx
80103c1d:	5e                   	pop    %esi
80103c1e:	5d                   	pop    %ebp
80103c1f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c20:	83 ec 04             	sub    $0x4,%esp
80103c23:	01 c6                	add    %eax,%esi
80103c25:	56                   	push   %esi
80103c26:	50                   	push   %eax
80103c27:	ff 73 04             	pushl  0x4(%ebx)
80103c2a:	e8 21 37 00 00       	call   80107350 <allocuvm>
80103c2f:	83 c4 10             	add    $0x10,%esp
80103c32:	85 c0                	test   %eax,%eax
80103c34:	75 d3                	jne    80103c09 <growproc+0x29>
      return -1;
80103c36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c3b:	eb dc                	jmp    80103c19 <growproc+0x39>
80103c3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c40:	83 ec 04             	sub    $0x4,%esp
80103c43:	01 c6                	add    %eax,%esi
80103c45:	56                   	push   %esi
80103c46:	50                   	push   %eax
80103c47:	ff 73 04             	pushl  0x4(%ebx)
80103c4a:	e8 31 38 00 00       	call   80107480 <deallocuvm>
80103c4f:	83 c4 10             	add    $0x10,%esp
80103c52:	85 c0                	test   %eax,%eax
80103c54:	75 b3                	jne    80103c09 <growproc+0x29>
80103c56:	eb de                	jmp    80103c36 <growproc+0x56>
80103c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c5f:	90                   	nop

80103c60 <fork>:
{
80103c60:	f3 0f 1e fb          	endbr32 
80103c64:	55                   	push   %ebp
80103c65:	89 e5                	mov    %esp,%ebp
80103c67:	57                   	push   %edi
80103c68:	56                   	push   %esi
80103c69:	53                   	push   %ebx
80103c6a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c6d:	e8 fe 0d 00 00       	call   80104a70 <pushcli>
  c = mycpu();
80103c72:	e8 29 fc ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103c77:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103c7d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  popcli();
80103c80:	e8 3b 0e 00 00       	call   80104ac0 <popcli>
  if((np = allocproc()) == 0){
80103c85:	e8 16 fd ff ff       	call   801039a0 <allocproc>
80103c8a:	85 c0                	test   %eax,%eax
80103c8c:	0f 84 0c 01 00 00    	je     80103d9e <fork+0x13e>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c95:	83 ec 08             	sub    $0x8,%esp
80103c98:	89 c3                	mov    %eax,%ebx
80103c9a:	ff 32                	pushl  (%edx)
80103c9c:	ff 72 04             	pushl  0x4(%edx)
80103c9f:	e8 5c 39 00 00       	call   80107600 <copyuvm>
80103ca4:	83 c4 10             	add    $0x10,%esp
80103ca7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103caa:	85 c0                	test   %eax,%eax
80103cac:	89 43 04             	mov    %eax,0x4(%ebx)
80103caf:	0f 84 f0 00 00 00    	je     80103da5 <fork+0x145>
  np->sz = curproc->sz;
80103cb5:	8b 02                	mov    (%edx),%eax
  *np->tf = *curproc->tf;
80103cb7:	8b 7b 18             	mov    0x18(%ebx),%edi
  np->parent = curproc;
80103cba:	89 53 14             	mov    %edx,0x14(%ebx)
  *np->tf = *curproc->tf;
80103cbd:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103cc2:	89 03                	mov    %eax,(%ebx)
  *np->tf = *curproc->tf;
80103cc4:	8b 72 18             	mov    0x18(%edx),%esi
80103cc7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(signum = 0; signum < NOFILE; signum++)
80103cc9:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ccb:	8b 43 18             	mov    0x18(%ebx),%eax
80103cce:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(signum = 0; signum < NOFILE; signum++)
80103cd5:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[signum])
80103cd8:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103cdc:	85 c0                	test   %eax,%eax
80103cde:	74 16                	je     80103cf6 <fork+0x96>
      np->ofile[signum] = filedup(curproc->ofile[signum]);
80103ce0:	83 ec 0c             	sub    $0xc,%esp
80103ce3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103ce6:	50                   	push   %eax
80103ce7:	e8 b4 d1 ff ff       	call   80100ea0 <filedup>
80103cec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103cef:	83 c4 10             	add    $0x10,%esp
80103cf2:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
  for(signum = 0; signum < NOFILE; signum++)
80103cf6:	83 c6 01             	add    $0x1,%esi
80103cf9:	83 fe 10             	cmp    $0x10,%esi
80103cfc:	75 da                	jne    80103cd8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103cfe:	83 ec 0c             	sub    $0xc,%esp
80103d01:	ff 72 68             	pushl  0x68(%edx)
80103d04:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103d07:	e8 54 da ff ff       	call   80101760 <idup>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d0f:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d12:	89 43 68             	mov    %eax,0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d15:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d18:	83 c2 6c             	add    $0x6c,%edx
80103d1b:	6a 10                	push   $0x10
80103d1d:	52                   	push   %edx
80103d1e:	50                   	push   %eax
80103d1f:	e8 1c 11 00 00       	call   80104e40 <safestrcpy>
  pid = np->pid;
80103d24:	8b 73 10             	mov    0x10(%ebx),%esi
  pushcli();
80103d27:	e8 44 0d 00 00       	call   80104a70 <pushcli>
  if (!cas(&(np->state), EMBRYO, RUNNABLE)){
80103d2c:	8d 53 0c             	lea    0xc(%ebx),%edx
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103d2f:	b8 01 00 00 00       	mov    $0x1,%eax
80103d34:	b9 03 00 00 00       	mov    $0x3,%ecx
80103d39:	f0 0f b1 0a          	lock cmpxchg %ecx,(%edx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d3d:	9c                   	pushf  
80103d3e:	58                   	pop    %eax
80103d3f:	83 c4 10             	add    $0x10,%esp
80103d42:	a8 40                	test   $0x40,%al
80103d44:	0f 84 7e 00 00 00    	je     80103dc8 <fork+0x168>
  popcli();
80103d4a:	e8 71 0d 00 00       	call   80104ac0 <popcli>
  np->blocked_signal_mask = np->parent->blocked_signal_mask;
80103d4f:	8b 7b 14             	mov    0x14(%ebx),%edi
  for (int signum = 0; signum < 32; signum++){
80103d52:	31 c9                	xor    %ecx,%ecx
  np->blocked_signal_mask = np->parent->blocked_signal_mask;
80103d54:	8b 87 88 00 00 00    	mov    0x88(%edi),%eax
  np->pending_signals = 0;
80103d5a:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103d61:	00 00 00 
  np->blocked_signal_mask = np->parent->blocked_signal_mask;
80103d64:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  for (int signum = 0; signum < 32; signum++){
80103d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    np->signal_handlers[signum] = np->parent->signal_handlers[signum];
80103d70:	8b 84 cf 90 00 00 00 	mov    0x90(%edi,%ecx,8),%eax
80103d77:	8b 94 cf 94 00 00 00 	mov    0x94(%edi,%ecx,8),%edx
80103d7e:	89 84 cb 90 00 00 00 	mov    %eax,0x90(%ebx,%ecx,8)
80103d85:	89 94 cb 94 00 00 00 	mov    %edx,0x94(%ebx,%ecx,8)
  for (int signum = 0; signum < 32; signum++){
80103d8c:	83 c1 01             	add    $0x1,%ecx
80103d8f:	83 f9 20             	cmp    $0x20,%ecx
80103d92:	75 dc                	jne    80103d70 <fork+0x110>
}
80103d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d97:	89 f0                	mov    %esi,%eax
80103d99:	5b                   	pop    %ebx
80103d9a:	5e                   	pop    %esi
80103d9b:	5f                   	pop    %edi
80103d9c:	5d                   	pop    %ebp
80103d9d:	c3                   	ret    
    return -1;
80103d9e:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103da3:	eb ef                	jmp    80103d94 <fork+0x134>
    kfree(np->kstack);
80103da5:	83 ec 0c             	sub    $0xc,%esp
80103da8:	ff 73 08             	pushl  0x8(%ebx)
    return -1;
80103dab:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103db0:	e8 eb e6 ff ff       	call   801024a0 <kfree>
    np->kstack = 0;
80103db5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103dbc:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103dbf:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103dc6:	eb cc                	jmp    80103d94 <fork+0x134>
    panic("process in fork not at embryo");
80103dc8:	83 ec 0c             	sub    $0xc,%esp
80103dcb:	68 3b 7d 10 80       	push   $0x80107d3b
80103dd0:	e8 bb c5 ff ff       	call   80100390 <panic>
80103dd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103de0 <has_cont_pending>:
int has_cont_pending(struct proc* p){
80103de0:	f3 0f 1e fb          	endbr32 
80103de4:	55                   	push   %ebp
    if (!((1 << i) & p->pending_signals)){
80103de5:	31 c9                	xor    %ecx,%ecx
80103de7:	ba 01 00 00 00       	mov    $0x1,%edx
int has_cont_pending(struct proc* p){
80103dec:	89 e5                	mov    %esp,%ebp
80103dee:	56                   	push   %esi
80103def:	8b 75 08             	mov    0x8(%ebp),%esi
80103df2:	53                   	push   %ebx
    if (!((1 << i) & p->pending_signals)){
80103df3:	8b 9e 84 00 00 00    	mov    0x84(%esi),%ebx
80103df9:	eb 17                	jmp    80103e12 <has_cont_pending+0x32>
80103dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dff:	90                   	nop
    if ((int)(p->signal_handlers[i].sa_handler) == SIGCONT){
80103e00:	83 bc ce 90 00 00 00 	cmpl   $0x13,0x90(%esi,%ecx,8)
80103e07:	13 
80103e08:	74 28                	je     80103e32 <has_cont_pending+0x52>
  for (int i = 0; i < 32; i++){
80103e0a:	83 f9 1f             	cmp    $0x1f,%ecx
80103e0d:	74 31                	je     80103e40 <has_cont_pending+0x60>
80103e0f:	83 c1 01             	add    $0x1,%ecx
    if (!((1 << i) & p->pending_signals)){
80103e12:	89 d0                	mov    %edx,%eax
80103e14:	d3 e0                	shl    %cl,%eax
80103e16:	85 d8                	test   %ebx,%eax
80103e18:	74 f0                	je     80103e0a <has_cont_pending+0x2a>
    if (i == SIGCONT && p->signal_handlers[i].sa_handler == SIG_DFL){
80103e1a:	83 f9 13             	cmp    $0x13,%ecx
80103e1d:	75 e1                	jne    80103e00 <has_cont_pending+0x20>
80103e1f:	8b 86 28 01 00 00    	mov    0x128(%esi),%eax
80103e25:	85 c0                	test   %eax,%eax
80103e27:	74 09                	je     80103e32 <has_cont_pending+0x52>
    if ((int)(p->signal_handlers[i].sa_handler) == SIGCONT){
80103e29:	83 be 28 01 00 00 13 	cmpl   $0x13,0x128(%esi)
80103e30:	75 dd                	jne    80103e0f <has_cont_pending+0x2f>
}
80103e32:	5b                   	pop    %ebx
      return 1;
80103e33:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103e38:	5e                   	pop    %esi
80103e39:	5d                   	pop    %ebp
80103e3a:	c3                   	ret    
80103e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e3f:	90                   	nop
80103e40:	5b                   	pop    %ebx
  return 0;
80103e41:	31 c0                	xor    %eax,%eax
}
80103e43:	5e                   	pop    %esi
80103e44:	5d                   	pop    %ebp
80103e45:	c3                   	ret    
80103e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e4d:	8d 76 00             	lea    0x0(%esi),%esi

80103e50 <scheduler>:
{
80103e50:	f3 0f 1e fb          	endbr32 
80103e54:	55                   	push   %ebp
80103e55:	89 e5                	mov    %esp,%ebp
80103e57:	57                   	push   %edi
80103e58:	56                   	push   %esi
80103e59:	53                   	push   %ebx
80103e5a:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103e5d:	e8 3e fa ff ff       	call   801038a0 <mycpu>
  c->proc = 0;
80103e62:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e69:	00 00 00 
  struct cpu *c = mycpu();
80103e6c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e6e:	8d 40 04             	lea    0x4(%eax),%eax
80103e71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103e74:	fb                   	sti    
    pushcli();
80103e75:	e8 f6 0b 00 00       	call   80104a70 <pushcli>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e7a:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80103e7f:	90                   	nop
      if(p->state != RUNNABLE && p->state != -RUNNABLE){
80103e80:	8b 43 0c             	mov    0xc(%ebx),%eax
80103e83:	83 f8 03             	cmp    $0x3,%eax
80103e86:	74 09                	je     80103e91 <scheduler+0x41>
80103e88:	83 f8 fd             	cmp    $0xfffffffd,%eax
80103e8b:	0f 85 bf 00 00 00    	jne    80103f50 <scheduler+0x100>
      if (p->flag_frozen && !has_cont_pending(p)){
80103e91:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103e94:	85 c0                	test   %eax,%eax
80103e96:	0f 85 d4 00 00 00    	jne    80103f70 <scheduler+0x120>
      switchuvm(p);
80103e9c:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e9f:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103ea5:	8d 7b 0c             	lea    0xc(%ebx),%edi
80103ea8:	53                   	push   %ebx
80103ea9:	e8 42 32 00 00       	call   801070f0 <switchuvm>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103eae:	b8 03 00 00 00       	mov    $0x3,%eax
80103eb3:	ba 04 00 00 00       	mov    $0x4,%edx
80103eb8:	f0 0f b1 17          	lock cmpxchg %edx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ebc:	9c                   	pushf  
80103ebd:	58                   	pop    %eax
      if (!cas(&(p->state), RUNNABLE, RUNNING)){
80103ebe:	83 c4 10             	add    $0x10,%esp
80103ec1:	a8 40                	test   $0x40,%al
80103ec3:	74 7b                	je     80103f40 <scheduler+0xf0>
      swtch(&(c->scheduler), p->context);
80103ec5:	83 ec 08             	sub    $0x8,%esp
80103ec8:	ff 73 1c             	pushl  0x1c(%ebx)
80103ecb:	ff 75 e4             	pushl  -0x1c(%ebp)
80103ece:	e8 d0 0f 00 00       	call   80104ea3 <swtch>
      switchkvm();
80103ed3:	e8 f8 31 00 00       	call   801070d0 <switchkvm>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103ed8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80103edd:	ba 03 00 00 00       	mov    $0x3,%edx
      c->proc = 0;
80103ee2:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ee9:	00 00 00 
80103eec:	f0 0f b1 17          	lock cmpxchg %edx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ef0:	9c                   	pushf  
80103ef1:	58                   	pop    %eax
      if (cas(&(p->state), -RUNNABLE, RUNNABLE) || cas(&(p->state), -SLEEPING, SLEEPING) || cas(&(p->state), -ZOMBIE, ZOMBIE)){
80103ef2:	83 c4 10             	add    $0x10,%esp
80103ef5:	a8 40                	test   $0x40,%al
80103ef7:	75 57                	jne    80103f50 <scheduler+0x100>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103ef9:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103efe:	ba 02 00 00 00       	mov    $0x2,%edx
80103f03:	f0 0f b1 17          	lock cmpxchg %edx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f07:	9c                   	pushf  
80103f08:	58                   	pop    %eax
80103f09:	a8 40                	test   $0x40,%al
80103f0b:	75 43                	jne    80103f50 <scheduler+0x100>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103f0d:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
80103f12:	ba 05 00 00 00       	mov    $0x5,%edx
80103f17:	f0 0f b1 17          	lock cmpxchg %edx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f1b:	9c                   	pushf  
80103f1c:	58                   	pop    %eax
80103f1d:	a8 40                	test   $0x40,%al
80103f1f:	75 2f                	jne    80103f50 <scheduler+0x100>
        cprintf("process returned to scheduler in not (- sleeping) or (- runnable) or (- zombie) state. real state = %d\n", p->state);
80103f21:	83 ec 08             	sub    $0x8,%esp
80103f24:	ff 73 0c             	pushl  0xc(%ebx)
80103f27:	68 44 7e 10 80       	push   $0x80107e44
80103f2c:	e8 7f c7 ff ff       	call   801006b0 <cprintf>
        panic("^^^^^^^^^^^^^^^^^^^^^^");
80103f31:	c7 04 24 59 7d 10 80 	movl   $0x80107d59,(%esp)
80103f38:	e8 53 c4 ff ff       	call   80100390 <panic>
80103f3d:	8d 76 00             	lea    0x0(%esi),%esi
        switchkvm();
80103f40:	e8 8b 31 00 00       	call   801070d0 <switchkvm>
        c->proc = 0;
80103f45:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f4c:	00 00 00 
        continue;
80103f4f:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f50:	81 c3 94 01 00 00    	add    $0x194,%ebx
80103f56:	81 fb 54 a2 11 80    	cmp    $0x8011a254,%ebx
80103f5c:	0f 85 1e ff ff ff    	jne    80103e80 <scheduler+0x30>
    popcli();
80103f62:	e8 59 0b 00 00       	call   80104ac0 <popcli>
    sti();
80103f67:	e9 08 ff ff ff       	jmp    80103e74 <scheduler+0x24>
80103f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (!((1 << i) & p->pending_signals)){
80103f70:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80103f76:	31 c9                	xor    %ecx,%ecx
80103f78:	b8 01 00 00 00       	mov    $0x1,%eax
80103f7d:	eb 17                	jmp    80103f96 <scheduler+0x146>
80103f7f:	90                   	nop
    if ((int)(p->signal_handlers[i].sa_handler) == SIGCONT){
80103f80:	83 bc cb 90 00 00 00 	cmpl   $0x13,0x90(%ebx,%ecx,8)
80103f87:	13 
80103f88:	0f 84 0e ff ff ff    	je     80103e9c <scheduler+0x4c>
  for (int i = 0; i < 32; i++){
80103f8e:	83 f9 1f             	cmp    $0x1f,%ecx
80103f91:	74 bd                	je     80103f50 <scheduler+0x100>
80103f93:	83 c1 01             	add    $0x1,%ecx
    if (!((1 << i) & p->pending_signals)){
80103f96:	89 c7                	mov    %eax,%edi
80103f98:	d3 e7                	shl    %cl,%edi
80103f9a:	85 d7                	test   %edx,%edi
80103f9c:	74 f0                	je     80103f8e <scheduler+0x13e>
    if (i == SIGCONT && p->signal_handlers[i].sa_handler == SIG_DFL){
80103f9e:	83 f9 13             	cmp    $0x13,%ecx
80103fa1:	75 dd                	jne    80103f80 <scheduler+0x130>
80103fa3:	8b bb 28 01 00 00    	mov    0x128(%ebx),%edi
80103fa9:	85 ff                	test   %edi,%edi
80103fab:	0f 84 eb fe ff ff    	je     80103e9c <scheduler+0x4c>
    if ((int)(p->signal_handlers[i].sa_handler) == SIGCONT){
80103fb1:	83 ff 13             	cmp    $0x13,%edi
80103fb4:	75 dd                	jne    80103f93 <scheduler+0x143>
80103fb6:	e9 e1 fe ff ff       	jmp    80103e9c <scheduler+0x4c>
80103fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fbf:	90                   	nop

80103fc0 <sched>:
{
80103fc0:	f3 0f 1e fb          	endbr32 
80103fc4:	55                   	push   %ebp
80103fc5:	89 e5                	mov    %esp,%ebp
80103fc7:	56                   	push   %esi
80103fc8:	53                   	push   %ebx
  pushcli();
80103fc9:	e8 a2 0a 00 00       	call   80104a70 <pushcli>
  c = mycpu();
80103fce:	e8 cd f8 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103fd3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fd9:	e8 e2 0a 00 00       	call   80104ac0 <popcli>
  if((p->state == RUNNING))
80103fde:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103fe2:	74 3b                	je     8010401f <sched+0x5f>
80103fe4:	9c                   	pushf  
80103fe5:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103fe6:	f6 c4 02             	test   $0x2,%ah
80103fe9:	75 41                	jne    8010402c <sched+0x6c>
  intena = mycpu()->intena;
80103feb:	e8 b0 f8 ff ff       	call   801038a0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103ff0:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ff3:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ff9:	e8 a2 f8 ff ff       	call   801038a0 <mycpu>
80103ffe:	83 ec 08             	sub    $0x8,%esp
80104001:	ff 70 04             	pushl  0x4(%eax)
80104004:	53                   	push   %ebx
80104005:	e8 99 0e 00 00       	call   80104ea3 <swtch>
  mycpu()->intena = intena;
8010400a:	e8 91 f8 ff ff       	call   801038a0 <mycpu>
}
8010400f:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104012:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104018:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010401b:	5b                   	pop    %ebx
8010401c:	5e                   	pop    %esi
8010401d:	5d                   	pop    %ebp
8010401e:	c3                   	ret    
    panic("sched running");
8010401f:	83 ec 0c             	sub    $0xc,%esp
80104022:	68 70 7d 10 80       	push   $0x80107d70
80104027:	e8 64 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010402c:	83 ec 0c             	sub    $0xc,%esp
8010402f:	68 7e 7d 10 80       	push   $0x80107d7e
80104034:	e8 57 c3 ff ff       	call   80100390 <panic>
80104039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104040 <exit>:
{
80104040:	f3 0f 1e fb          	endbr32 
80104044:	55                   	push   %ebp
80104045:	89 e5                	mov    %esp,%ebp
80104047:	57                   	push   %edi
80104048:	56                   	push   %esi
80104049:	53                   	push   %ebx
8010404a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010404d:	e8 1e 0a 00 00       	call   80104a70 <pushcli>
  c = mycpu();
80104052:	e8 49 f8 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104057:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010405d:	e8 5e 0a 00 00       	call   80104ac0 <popcli>
  if(curproc == initproc)
80104062:	8d 5e 28             	lea    0x28(%esi),%ebx
80104065:	8d 7e 68             	lea    0x68(%esi),%edi
80104068:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
8010406e:	0f 84 e0 00 00 00    	je     80104154 <exit+0x114>
80104074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104078:	8b 03                	mov    (%ebx),%eax
8010407a:	85 c0                	test   %eax,%eax
8010407c:	74 12                	je     80104090 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010407e:	83 ec 0c             	sub    $0xc,%esp
80104081:	50                   	push   %eax
80104082:	e8 69 ce ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80104087:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010408d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104090:	83 c3 04             	add    $0x4,%ebx
80104093:	39 fb                	cmp    %edi,%ebx
80104095:	75 e1                	jne    80104078 <exit+0x38>
  begin_op();
80104097:	e8 c4 ec ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
8010409c:	83 ec 0c             	sub    $0xc,%esp
8010409f:	ff 76 68             	pushl  0x68(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040a2:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  iput(curproc->cwd);
801040a7:	e8 14 d8 ff ff       	call   801018c0 <iput>
  end_op();
801040ac:	e8 1f ed ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
801040b1:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  pushcli();
801040b8:	e8 b3 09 00 00       	call   80104a70 <pushcli>
  wakeup1(curproc->parent);
801040bd:	8b 46 14             	mov    0x14(%esi),%eax
801040c0:	e8 fb f6 ff ff       	call   801037c0 <wakeup1>
801040c5:	83 c4 10             	add    $0x10,%esp
801040c8:	eb 14                	jmp    801040de <exit+0x9e>
801040ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040d0:	81 c3 94 01 00 00    	add    $0x194,%ebx
801040d6:	81 fb 54 a2 11 80    	cmp    $0x8011a254,%ebx
801040dc:	74 32                	je     80104110 <exit+0xd0>
    if(p->parent == curproc){
801040de:	39 73 14             	cmp    %esi,0x14(%ebx)
801040e1:	75 ed                	jne    801040d0 <exit+0x90>
      p->parent = initproc;
801040e3:	8b 15 b8 b5 10 80    	mov    0x8010b5b8,%edx
      if(p->state == ZOMBIE || p->state == -ZOMBIE)
801040e9:	8b 43 0c             	mov    0xc(%ebx),%eax
      p->parent = initproc;
801040ec:	89 53 14             	mov    %edx,0x14(%ebx)
      if(p->state == ZOMBIE || p->state == -ZOMBIE)
801040ef:	83 f8 05             	cmp    $0x5,%eax
801040f2:	74 05                	je     801040f9 <exit+0xb9>
801040f4:	83 f8 fb             	cmp    $0xfffffffb,%eax
801040f7:	75 d7                	jne    801040d0 <exit+0x90>
        wakeup1(initproc);
801040f9:	89 d0                	mov    %edx,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040fb:	81 c3 94 01 00 00    	add    $0x194,%ebx
        wakeup1(initproc);
80104101:	e8 ba f6 ff ff       	call   801037c0 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104106:	81 fb 54 a2 11 80    	cmp    $0x8011a254,%ebx
8010410c:	75 d0                	jne    801040de <exit+0x9e>
8010410e:	66 90                	xchg   %ax,%ax
  if (!cas(&(curproc->state), RUNNING, -ZOMBIE)){
80104110:	8d 56 0c             	lea    0xc(%esi),%edx
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80104113:	b8 04 00 00 00       	mov    $0x4,%eax
80104118:	b9 fb ff ff ff       	mov    $0xfffffffb,%ecx
8010411d:	f0 0f b1 0a          	lock cmpxchg %ecx,(%edx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104121:	9c                   	pushf  
80104122:	58                   	pop    %eax
80104123:	a8 40                	test   $0x40,%al
80104125:	75 1b                	jne    80104142 <exit+0x102>
    cprintf("exit is not at running state, real state is %d", curproc->state);
80104127:	50                   	push   %eax
80104128:	50                   	push   %eax
80104129:	ff 76 0c             	pushl  0xc(%esi)
8010412c:	68 ac 7e 10 80       	push   $0x80107eac
80104131:	e8 7a c5 ff ff       	call   801006b0 <cprintf>
    panic("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
80104136:	c7 04 24 dc 7e 10 80 	movl   $0x80107edc,(%esp)
8010413d:	e8 4e c2 ff ff       	call   80100390 <panic>
  sched();
80104142:	e8 79 fe ff ff       	call   80103fc0 <sched>
  panic("zombie exit");
80104147:	83 ec 0c             	sub    $0xc,%esp
8010414a:	68 9f 7d 10 80       	push   $0x80107d9f
8010414f:	e8 3c c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104154:	83 ec 0c             	sub    $0xc,%esp
80104157:	68 92 7d 10 80       	push   $0x80107d92
8010415c:	e8 2f c2 ff ff       	call   80100390 <panic>
80104161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416f:	90                   	nop

80104170 <yield>:
{
80104170:	f3 0f 1e fb          	endbr32 
80104174:	55                   	push   %ebp
80104175:	89 e5                	mov    %esp,%ebp
80104177:	53                   	push   %ebx
80104178:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010417b:	e8 f0 08 00 00       	call   80104a70 <pushcli>
  pushcli();
80104180:	e8 eb 08 00 00       	call   80104a70 <pushcli>
  c = mycpu();
80104185:	e8 16 f7 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
8010418a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104190:	e8 2b 09 00 00       	call   80104ac0 <popcli>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80104195:	b8 04 00 00 00       	mov    $0x4,%eax
  switch_state(&(myproc()->state), RUNNING, -RUNNABLE);
8010419a:	8d 4b 0c             	lea    0xc(%ebx),%ecx
8010419d:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
801041a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041a8:	f0 0f b1 19          	lock cmpxchg %ebx,(%ecx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041ac:	9c                   	pushf  
801041ad:	5a                   	pop    %edx
  while (!cas(state_ptr, old, new)){}
801041ae:	83 e2 40             	and    $0x40,%edx
801041b1:	74 f5                	je     801041a8 <yield+0x38>
  sched();
801041b3:	e8 08 fe ff ff       	call   80103fc0 <sched>
}
801041b8:	83 c4 04             	add    $0x4,%esp
801041bb:	5b                   	pop    %ebx
801041bc:	5d                   	pop    %ebp
  popcli();
801041bd:	e9 fe 08 00 00       	jmp    80104ac0 <popcli>
801041c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041d0 <sleep>:
{
801041d0:	f3 0f 1e fb          	endbr32 
801041d4:	55                   	push   %ebp
801041d5:	89 e5                	mov    %esp,%ebp
801041d7:	57                   	push   %edi
801041d8:	56                   	push   %esi
801041d9:	53                   	push   %ebx
801041da:	83 ec 0c             	sub    $0xc,%esp
801041dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801041e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041e3:	e8 88 08 00 00       	call   80104a70 <pushcli>
  c = mycpu();
801041e8:	e8 b3 f6 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
801041ed:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041f3:	e8 c8 08 00 00       	call   80104ac0 <popcli>
  if(p == 0)
801041f8:	85 db                	test   %ebx,%ebx
801041fa:	74 6c                	je     80104268 <sleep+0x98>
  if(lk != null){  //DOC: sleeplock0
801041fc:	85 f6                	test   %esi,%esi
801041fe:	74 11                	je     80104211 <sleep+0x41>
    pushcli();
80104200:	e8 6b 08 00 00       	call   80104a70 <pushcli>
    release(lk);
80104205:	83 ec 0c             	sub    $0xc,%esp
80104208:	56                   	push   %esi
80104209:	e8 22 0a 00 00       	call   80104c30 <release>
8010420e:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
80104211:	89 7b 20             	mov    %edi,0x20(%ebx)
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80104214:	b8 04 00 00 00       	mov    $0x4,%eax
  switch_state(&(p->state), RUNNING, -SLEEPING);
80104219:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010421c:	b9 fe ff ff ff       	mov    $0xfffffffe,%ecx
80104221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104228:	f0 0f b1 0f          	lock cmpxchg %ecx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010422c:	9c                   	pushf  
8010422d:	5a                   	pop    %edx
  while (!cas(state_ptr, old, new)){}
8010422e:	83 e2 40             	and    $0x40,%edx
80104231:	74 f5                	je     80104228 <sleep+0x58>
  sched();
80104233:	e8 88 fd ff ff       	call   80103fc0 <sched>
  p->chan = 0;
80104238:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != null){  //DOC: sleeplock2
8010423f:	85 f6                	test   %esi,%esi
80104241:	74 1d                	je     80104260 <sleep+0x90>
    popcli();
80104243:	e8 78 08 00 00       	call   80104ac0 <popcli>
    acquire(lk);
80104248:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010424b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010424e:	5b                   	pop    %ebx
8010424f:	5e                   	pop    %esi
80104250:	5f                   	pop    %edi
80104251:	5d                   	pop    %ebp
    acquire(lk);
80104252:	e9 19 09 00 00       	jmp    80104b70 <acquire>
80104257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010425e:	66 90                	xchg   %ax,%ax
}
80104260:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104263:	5b                   	pop    %ebx
80104264:	5e                   	pop    %esi
80104265:	5f                   	pop    %edi
80104266:	5d                   	pop    %ebp
80104267:	c3                   	ret    
    panic("sleep");
80104268:	83 ec 0c             	sub    $0xc,%esp
8010426b:	68 ab 7d 10 80       	push   $0x80107dab
80104270:	e8 1b c1 ff ff       	call   80100390 <panic>
80104275:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010427c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104280 <wait>:
{
80104280:	f3 0f 1e fb          	endbr32 
80104284:	55                   	push   %ebp
80104285:	89 e5                	mov    %esp,%ebp
80104287:	57                   	push   %edi
80104288:	56                   	push   %esi
80104289:	53                   	push   %ebx
8010428a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010428d:	e8 de 07 00 00       	call   80104a70 <pushcli>
  c = mycpu();
80104292:	e8 09 f6 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104297:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010429d:	e8 1e 08 00 00       	call   80104ac0 <popcli>
  pushcli();
801042a2:	e8 c9 07 00 00       	call   80104a70 <pushcli>
    havekids = 0;
801042a7:	31 c9                	xor    %ecx,%ecx
801042a9:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042ab:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
801042b0:	b8 05 00 00 00       	mov    $0x5,%eax
801042b5:	eb 17                	jmp    801042ce <wait+0x4e>
801042b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042be:	66 90                	xchg   %ax,%ax
801042c0:	81 c3 94 01 00 00    	add    $0x194,%ebx
801042c6:	81 fb 54 a2 11 80    	cmp    $0x8011a254,%ebx
801042cc:	74 33                	je     80104301 <wait+0x81>
      if(p->parent != curproc)
801042ce:	39 73 14             	cmp    %esi,0x14(%ebx)
801042d1:	75 ed                	jne    801042c0 <wait+0x40>
      while(p->state == -ZOMBIE){}
801042d3:	83 7b 0c fb          	cmpl   $0xfffffffb,0xc(%ebx)
801042d7:	75 07                	jne    801042e0 <wait+0x60>
801042d9:	eb fe                	jmp    801042d9 <wait+0x59>
801042db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042df:	90                   	nop
      if(cas(&(p->state), ZOMBIE, -UNUSED)){
801042e0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801042e3:	f0 0f b1 0f          	lock cmpxchg %ecx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042e7:	9c                   	pushf  
801042e8:	5a                   	pop    %edx
801042e9:	83 e2 40             	and    $0x40,%edx
801042ec:	75 30                	jne    8010431e <wait+0x9e>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042ee:	81 c3 94 01 00 00    	add    $0x194,%ebx
      havekids = 1;
801042f4:	ba 01 00 00 00       	mov    $0x1,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042f9:	81 fb 54 a2 11 80    	cmp    $0x8011a254,%ebx
801042ff:	75 cd                	jne    801042ce <wait+0x4e>
    if(!havekids || curproc->killed){
80104301:	85 d2                	test   %edx,%edx
80104303:	74 75                	je     8010437a <wait+0xfa>
80104305:	8b 46 24             	mov    0x24(%esi),%eax
80104308:	85 c0                	test   %eax,%eax
8010430a:	75 6e                	jne    8010437a <wait+0xfa>
    sleep(curproc, null);  //DOC: wait-sleep
8010430c:	83 ec 08             	sub    $0x8,%esp
8010430f:	6a 00                	push   $0x0
80104311:	56                   	push   %esi
80104312:	e8 b9 fe ff ff       	call   801041d0 <sleep>
    havekids = 0;
80104317:	83 c4 10             	add    $0x10,%esp
8010431a:	31 c9                	xor    %ecx,%ecx
8010431c:	eb 8b                	jmp    801042a9 <wait+0x29>
        kfree(p->kstack);
8010431e:	83 ec 0c             	sub    $0xc,%esp
80104321:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104324:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104327:	e8 74 e1 ff ff       	call   801024a0 <kfree>
        freevm(p->pgdir);
8010432c:	5a                   	pop    %edx
8010432d:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104330:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104337:	e8 74 31 00 00       	call   801074b0 <freevm>
        p->name[0] = 0;
8010433c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
  while (!cas(state_ptr, old, new)){}
80104340:	83 c4 10             	add    $0x10,%esp
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80104343:	31 c0                	xor    %eax,%eax
        p->pid = 0;
80104345:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010434c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->killed = 0;
80104353:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
  while (!cas(state_ptr, old, new)){}
8010435a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104360:	f0 0f b1 07          	lock cmpxchg %eax,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104364:	9c                   	pushf  
80104365:	5a                   	pop    %edx
80104366:	83 e2 40             	and    $0x40,%edx
80104369:	74 f5                	je     80104360 <wait+0xe0>
        popcli();
8010436b:	e8 50 07 00 00       	call   80104ac0 <popcli>
}
80104370:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104373:	89 f0                	mov    %esi,%eax
80104375:	5b                   	pop    %ebx
80104376:	5e                   	pop    %esi
80104377:	5f                   	pop    %edi
80104378:	5d                   	pop    %ebp
80104379:	c3                   	ret    
      popcli();
8010437a:	e8 41 07 00 00       	call   80104ac0 <popcli>
      return -1;
8010437f:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104384:	eb ea                	jmp    80104370 <wait+0xf0>
80104386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010438d:	8d 76 00             	lea    0x0(%esi),%esi

80104390 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104390:	f3 0f 1e fb          	endbr32 
80104394:	55                   	push   %ebp
80104395:	89 e5                	mov    %esp,%ebp
80104397:	53                   	push   %ebx
80104398:	83 ec 04             	sub    $0x4,%esp
8010439b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // possible bug
  // acquire(&ptable.lock);
  pushcli();
8010439e:	e8 cd 06 00 00       	call   80104a70 <pushcli>
  wakeup1(chan);
801043a3:	89 d8                	mov    %ebx,%eax
801043a5:	e8 16 f4 ff ff       	call   801037c0 <wakeup1>
  popcli();
  // release(&ptable.lock);
}
801043aa:	83 c4 04             	add    $0x4,%esp
801043ad:	5b                   	pop    %ebx
801043ae:	5d                   	pop    %ebp
  popcli();
801043af:	e9 0c 07 00 00       	jmp    80104ac0 <popcli>
801043b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043bf:	90                   	nop

801043c0 <is_blocked>:

int is_blocked(uint mask, int signum){
801043c0:	f3 0f 1e fb          	endbr32 
801043c4:	55                   	push   %ebp
  return (mask & (1 << signum));
801043c5:	b8 01 00 00 00       	mov    $0x1,%eax
int is_blocked(uint mask, int signum){
801043ca:	89 e5                	mov    %esp,%ebp
  return (mask & (1 << signum));
801043cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801043cf:	d3 e0                	shl    %cl,%eax
801043d1:	23 45 08             	and    0x8(%ebp),%eax
}
801043d4:	5d                   	pop    %ebp
801043d5:	c3                   	ret    
801043d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043dd:	8d 76 00             	lea    0x0(%esi),%esi

801043e0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid, int signum)
{
801043e0:	f3 0f 1e fb          	endbr32 
801043e4:	55                   	push   %ebp
801043e5:	89 e5                	mov    %esp,%ebp
801043e7:	56                   	push   %esi
801043e8:	8b 75 0c             	mov    0xc(%ebp),%esi
801043eb:	53                   	push   %ebx
801043ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (signum < 0 || signum > 31){
801043ef:	83 fe 1f             	cmp    $0x1f,%esi
801043f2:	0f 87 8e 00 00 00    	ja     80104486 <kill+0xa6>
    return -1;
  }
  struct proc *p;
  // acquire(&ptable.lock);
  pushcli();
801043f8:	e8 73 06 00 00       	call   80104a70 <pushcli>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043fd:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80104402:	eb 12                	jmp    80104416 <kill+0x36>
80104404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104408:	81 c2 94 01 00 00    	add    $0x194,%edx
8010440e:	81 fa 54 a2 11 80    	cmp    $0x8011a254,%edx
80104414:	74 62                	je     80104478 <kill+0x98>
    if(p->pid == pid){
80104416:	39 5a 10             	cmp    %ebx,0x10(%edx)
80104419:	75 ed                	jne    80104408 <kill+0x28>
      if ((((int)(p->signal_handlers[signum].sa_handler) == SIGKILL && !is_blocked(p->blocked_signal_mask, signum)) || signum == SIGKILL || signum == SIGSTOP)){
8010441b:	89 f1                	mov    %esi,%ecx
8010441d:	b8 01 00 00 00       	mov    $0x1,%eax
80104422:	d3 e0                	shl    %cl,%eax
80104424:	83 bc f2 90 00 00 00 	cmpl   $0x9,0x90(%edx,%esi,8)
8010442b:	09 
8010442c:	89 c1                	mov    %eax,%ecx
8010442e:	74 20                	je     80104450 <kill+0x70>
80104430:	83 ee 09             	sub    $0x9,%esi
80104433:	83 e6 f7             	and    $0xfffffff7,%esi
80104436:	74 20                	je     80104458 <kill+0x78>
        while(p->state == -SLEEPING){}
        cas(&(p->state), SLEEPING, RUNNABLE);
      }
      p->pending_signals = p->pending_signals | (1 << signum);
80104438:	09 8a 84 00 00 00    	or     %ecx,0x84(%edx)
      // release(&ptable.lock);
      popcli();
8010443e:	e8 7d 06 00 00       	call   80104ac0 <popcli>
      return 0;
80104443:	31 c0                	xor    %eax,%eax
    }
  }
  // release(&ptable.lock);
  popcli();
  return -1;
}
80104445:	5b                   	pop    %ebx
80104446:	5e                   	pop    %esi
80104447:	5d                   	pop    %ebp
80104448:	c3                   	ret    
80104449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if ((((int)(p->signal_handlers[signum].sa_handler) == SIGKILL && !is_blocked(p->blocked_signal_mask, signum)) || signum == SIGKILL || signum == SIGSTOP)){
80104450:	85 82 88 00 00 00    	test   %eax,0x88(%edx)
80104456:	75 d8                	jne    80104430 <kill+0x50>
        while(p->state == -SLEEPING){}
80104458:	83 7a 0c fe          	cmpl   $0xfffffffe,0xc(%edx)
8010445c:	75 02                	jne    80104460 <kill+0x80>
8010445e:	eb fe                	jmp    8010445e <kill+0x7e>
        cas(&(p->state), SLEEPING, RUNNABLE);
80104460:	8d 5a 0c             	lea    0xc(%edx),%ebx
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80104463:	b8 02 00 00 00       	mov    $0x2,%eax
80104468:	be 03 00 00 00       	mov    $0x3,%esi
8010446d:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104471:	9c                   	pushf  
80104472:	58                   	pop    %eax
 : :"r" (addr), "a" (expected), "r" (newval));
  return (readeflags() & 0x0040);
80104473:	eb c3                	jmp    80104438 <kill+0x58>
80104475:	8d 76 00             	lea    0x0(%esi),%esi
  popcli();
80104478:	e8 43 06 00 00       	call   80104ac0 <popcli>
}
8010447d:	5b                   	pop    %ebx
  return -1;
8010447e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104483:	5e                   	pop    %esi
80104484:	5d                   	pop    %ebp
80104485:	c3                   	ret    
    return -1;
80104486:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010448b:	eb b8                	jmp    80104445 <kill+0x65>
8010448d:	8d 76 00             	lea    0x0(%esi),%esi

80104490 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104490:	f3 0f 1e fb          	endbr32 
80104494:	55                   	push   %ebp
80104495:	89 e5                	mov    %esp,%ebp
80104497:	57                   	push   %edi
80104498:	56                   	push   %esi
80104499:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010449c:	53                   	push   %ebx
8010449d:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801044a2:	83 ec 3c             	sub    $0x3c,%esp
801044a5:	eb 2b                	jmp    801044d2 <procdump+0x42>
801044a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ae:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(signum=0; signum<10 && pc[signum] != 0; signum++)
        cprintf(" %p", pc[signum]);
    }
    cprintf("\n");
801044b0:	83 ec 0c             	sub    $0xc,%esp
801044b3:	68 83 82 10 80       	push   $0x80108283
801044b8:	e8 f3 c1 ff ff       	call   801006b0 <cprintf>
801044bd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044c0:	81 c3 94 01 00 00    	add    $0x194,%ebx
801044c6:	81 fb c0 a2 11 80    	cmp    $0x8011a2c0,%ebx
801044cc:	0f 84 8e 00 00 00    	je     80104560 <procdump+0xd0>
    if((p->state == UNUSED) || (p->state == -UNUSED))
801044d2:	8b 43 a0             	mov    -0x60(%ebx),%eax
801044d5:	85 c0                	test   %eax,%eax
801044d7:	74 e7                	je     801044c0 <procdump+0x30>
      state = "???";
801044d9:	ba b1 7d 10 80       	mov    $0x80107db1,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044de:	83 f8 05             	cmp    $0x5,%eax
801044e1:	77 11                	ja     801044f4 <procdump+0x64>
801044e3:	8b 14 85 5c 7f 10 80 	mov    -0x7fef80a4(,%eax,4),%edx
      state = "???";
801044ea:	b8 b1 7d 10 80       	mov    $0x80107db1,%eax
801044ef:	85 d2                	test   %edx,%edx
801044f1:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801044f4:	53                   	push   %ebx
801044f5:	52                   	push   %edx
801044f6:	ff 73 a4             	pushl  -0x5c(%ebx)
801044f9:	68 b5 7d 10 80       	push   $0x80107db5
801044fe:	e8 ad c1 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104503:	83 c4 10             	add    $0x10,%esp
80104506:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010450a:	75 a4                	jne    801044b0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010450c:	83 ec 08             	sub    $0x8,%esp
8010450f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104512:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104515:	50                   	push   %eax
80104516:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104519:	8b 40 0c             	mov    0xc(%eax),%eax
8010451c:	83 c0 08             	add    $0x8,%eax
8010451f:	50                   	push   %eax
80104520:	e8 eb 04 00 00       	call   80104a10 <getcallerpcs>
      for(signum=0; signum<10 && pc[signum] != 0; signum++)
80104525:	83 c4 10             	add    $0x10,%esp
80104528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010452f:	90                   	nop
80104530:	8b 17                	mov    (%edi),%edx
80104532:	85 d2                	test   %edx,%edx
80104534:	0f 84 76 ff ff ff    	je     801044b0 <procdump+0x20>
        cprintf(" %p", pc[signum]);
8010453a:	83 ec 08             	sub    $0x8,%esp
8010453d:	83 c7 04             	add    $0x4,%edi
80104540:	52                   	push   %edx
80104541:	68 01 78 10 80       	push   $0x80107801
80104546:	e8 65 c1 ff ff       	call   801006b0 <cprintf>
      for(signum=0; signum<10 && pc[signum] != 0; signum++)
8010454b:	83 c4 10             	add    $0x10,%esp
8010454e:	39 fe                	cmp    %edi,%esi
80104550:	75 de                	jne    80104530 <procdump+0xa0>
80104552:	e9 59 ff ff ff       	jmp    801044b0 <procdump+0x20>
80104557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455e:	66 90                	xchg   %ax,%ax
  }
}
80104560:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104563:	5b                   	pop    %ebx
80104564:	5e                   	pop    %esi
80104565:	5f                   	pop    %edi
80104566:	5d                   	pop    %ebp
80104567:	c3                   	ret    
80104568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010456f:	90                   	nop

80104570 <sigprocmask>:

uint sigprocmask(uint sigmask){
80104570:	f3 0f 1e fb          	endbr32 
80104574:	55                   	push   %ebp
80104575:	89 e5                	mov    %esp,%ebp
80104577:	56                   	push   %esi
80104578:	53                   	push   %ebx
  pushcli();
80104579:	e8 f2 04 00 00       	call   80104a70 <pushcli>
  c = mycpu();
8010457e:	e8 1d f3 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104583:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104589:	e8 32 05 00 00       	call   80104ac0 <popcli>
  uint temp = myproc()->blocked_signal_mask;
8010458e:	8b 9b 88 00 00 00    	mov    0x88(%ebx),%ebx
  pushcli();
80104594:	e8 d7 04 00 00       	call   80104a70 <pushcli>
  c = mycpu();
80104599:	e8 02 f3 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
8010459e:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045a4:	e8 17 05 00 00       	call   80104ac0 <popcli>
  // Ignoring kill, stop, cont signals
  uint kill_mask = 1 << SIGKILL;
  uint cont_mask = 1 << SIGCONT;
  uint stop_mask = 1 << SIGSTOP;
  myproc()->blocked_signal_mask = sigmask & ~(kill_mask | stop_mask | cont_mask);
801045a9:	8b 45 08             	mov    0x8(%ebp),%eax
801045ac:	25 ff fd f5 ff       	and    $0xfff5fdff,%eax
801045b1:	89 86 88 00 00 00    	mov    %eax,0x88(%esi)
  return temp;
}
801045b7:	89 d8                	mov    %ebx,%eax
801045b9:	5b                   	pop    %ebx
801045ba:	5e                   	pop    %esi
801045bb:	5d                   	pop    %ebp
801045bc:	c3                   	ret    
801045bd:	8d 76 00             	lea    0x0(%esi),%esi

801045c0 <sigaction>:

int sigaction(int signum, const struct sigaction* act, struct sigaction* oldact){
801045c0:	f3 0f 1e fb          	endbr32 
801045c4:	55                   	push   %ebp
801045c5:	89 e5                	mov    %esp,%ebp
801045c7:	57                   	push   %edi
801045c8:	56                   	push   %esi
801045c9:	53                   	push   %ebx
801045ca:	83 ec 0c             	sub    $0xc,%esp
801045cd:	8b 7d 08             	mov    0x8(%ebp),%edi
801045d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  // make sure SIGCONT also here
  if (signum == SIGKILL || signum == SIGSTOP || signum == SIGCONT){
801045d3:	89 f8                	mov    %edi,%eax
801045d5:	83 e0 fd             	and    $0xfffffffd,%eax
801045d8:	83 f8 11             	cmp    $0x11,%eax
801045db:	74 53                	je     80104630 <sigaction+0x70>
801045dd:	83 ff 09             	cmp    $0x9,%edi
801045e0:	74 4e                	je     80104630 <sigaction+0x70>
    return -1;
  }
  if (signum < 0 || signum > 31){
801045e2:	83 ff 1f             	cmp    $0x1f,%edi
801045e5:	77 49                	ja     80104630 <sigaction+0x70>
  pushcli();
801045e7:	e8 84 04 00 00       	call   80104a70 <pushcli>
  c = mycpu();
801045ec:	e8 af f2 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
801045f1:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045f7:	e8 c4 04 00 00       	call   80104ac0 <popcli>
    return -1;
  }
  // 16 bytes struct
  struct proc* p = myproc();
  if (oldact != null){
801045fc:	8d 4f 12             	lea    0x12(%edi),%ecx
801045ff:	85 db                	test   %ebx,%ebx
80104601:	74 0c                	je     8010460f <sigaction+0x4f>
    *oldact = p->signal_handlers[signum];
80104603:	8b 04 ce             	mov    (%esi,%ecx,8),%eax
80104606:	8b 54 ce 04          	mov    0x4(%esi,%ecx,8),%edx
8010460a:	89 03                	mov    %eax,(%ebx)
8010460c:	89 53 04             	mov    %edx,0x4(%ebx)
  }
  p->signal_handlers[signum] = *act;
8010460f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104612:	8b 50 04             	mov    0x4(%eax),%edx
80104615:	8b 00                	mov    (%eax),%eax
80104617:	89 54 ce 04          	mov    %edx,0x4(%esi,%ecx,8)
8010461b:	89 04 ce             	mov    %eax,(%esi,%ecx,8)
  return 0;
8010461e:	31 c0                	xor    %eax,%eax
}
80104620:	83 c4 0c             	add    $0xc,%esp
80104623:	5b                   	pop    %ebx
80104624:	5e                   	pop    %esi
80104625:	5f                   	pop    %edi
80104626:	5d                   	pop    %ebp
80104627:	c3                   	ret    
80104628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010462f:	90                   	nop
    return -1;
80104630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104635:	eb e9                	jmp    80104620 <sigaction+0x60>
80104637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010463e:	66 90                	xchg   %ax,%ax

80104640 <sigret>:

void sigret(){
80104640:	f3 0f 1e fb          	endbr32 
80104644:	55                   	push   %ebp
80104645:	89 e5                	mov    %esp,%ebp
80104647:	57                   	push   %edi
80104648:	56                   	push   %esi
80104649:	53                   	push   %ebx
8010464a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010464d:	e8 1e 04 00 00       	call   80104a70 <pushcli>
  c = mycpu();
80104652:	e8 49 f2 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104657:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010465d:	e8 5e 04 00 00       	call   80104ac0 <popcli>
  struct proc* p = myproc();
  if (p!= null){
80104662:	85 db                	test   %ebx,%ebx
80104664:	74 26                	je     8010468c <sigret+0x4c>
    *(p->tf) = *(p->user_trapframe_backup);
80104666:	8b b3 90 01 00 00    	mov    0x190(%ebx),%esi
8010466c:	8b 7b 18             	mov    0x18(%ebx),%edi
8010466f:	b9 13 00 00 00       	mov    $0x13,%ecx
80104674:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    //memmove( p->tf, p->user_trapframe_backup, sizeof(*p->user_trapframe_backup));
    p->blocked_signal_mask = p->mask_backup;
    p->flag_in_user_handler = 0;
80104676:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010467d:	00 00 00 
    p->blocked_signal_mask = p->mask_backup;
80104680:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80104686:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
    // cprintf("sigret debug\n");
  }
  return;
 }
8010468c:	83 c4 0c             	add    $0xc,%esp
8010468f:	5b                   	pop    %ebx
80104690:	5e                   	pop    %esi
80104691:	5f                   	pop    %edi
80104692:	5d                   	pop    %ebp
80104693:	c3                   	ret    
80104694:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010469b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010469f:	90                   	nop

801046a0 <sigkill>:

// Signals implementation
// Assumed that the signal is being clear from the pending signals by the caller
int
sigkill(){
801046a0:	f3 0f 1e fb          	endbr32 
801046a4:	55                   	push   %ebp
801046a5:	89 e5                	mov    %esp,%ebp
801046a7:	53                   	push   %ebx
801046a8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801046ab:	e8 c0 03 00 00       	call   80104a70 <pushcli>
  c = mycpu();
801046b0:	e8 eb f1 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
801046b5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046bb:	e8 00 04 00 00       	call   80104ac0 <popcli>
  // cprintf("process with pid %d killed handled\n", myproc()->pid);
  myproc()->killed = 1;
  // release(&ptable.lock);
  return 0;
}
801046c0:	31 c0                	xor    %eax,%eax
  myproc()->killed = 1;
801046c2:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
}
801046c9:	83 c4 04             	add    $0x4,%esp
801046cc:	5b                   	pop    %ebx
801046cd:	5d                   	pop    %ebp
801046ce:	c3                   	ret    
801046cf:	90                   	nop

801046d0 <sigcont>:

int 
sigcont(){
801046d0:	f3 0f 1e fb          	endbr32 
801046d4:	55                   	push   %ebp
801046d5:	89 e5                	mov    %esp,%ebp
801046d7:	53                   	push   %ebx
801046d8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801046db:	e8 90 03 00 00       	call   80104a70 <pushcli>
  c = mycpu();
801046e0:	e8 bb f1 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
801046e5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046eb:	e8 d0 03 00 00       	call   80104ac0 <popcli>
  myproc()->flag_frozen = 0;
  return 0;
}
801046f0:	31 c0                	xor    %eax,%eax
  myproc()->flag_frozen = 0;
801046f2:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
}
801046f9:	83 c4 04             	add    $0x4,%esp
801046fc:	5b                   	pop    %ebx
801046fd:	5d                   	pop    %ebp
801046fe:	c3                   	ret    
801046ff:	90                   	nop

80104700 <sigstop>:

int 
sigstop(){
80104700:	f3 0f 1e fb          	endbr32 
80104704:	55                   	push   %ebp
80104705:	89 e5                	mov    %esp,%ebp
80104707:	53                   	push   %ebx
80104708:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010470b:	e8 60 03 00 00       	call   80104a70 <pushcli>
  c = mycpu();
80104710:	e8 8b f1 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104715:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010471b:	e8 a0 03 00 00       	call   80104ac0 <popcli>
  myproc()->flag_frozen = 1;
  return 0;
}
80104720:	31 c0                	xor    %eax,%eax
  myproc()->flag_frozen = 1;
80104722:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
}
80104729:	83 c4 04             	add    $0x4,%esp
8010472c:	5b                   	pop    %ebx
8010472d:	5d                   	pop    %ebp
8010472e:	c3                   	ret    
8010472f:	90                   	nop

80104730 <handle_signals>:


void handle_signals(){
80104730:	f3 0f 1e fb          	endbr32 
80104734:	55                   	push   %ebp
80104735:	89 e5                	mov    %esp,%ebp
80104737:	57                   	push   %edi
80104738:	56                   	push   %esi
80104739:	53                   	push   %ebx
8010473a:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
8010473d:	e8 2e 03 00 00       	call   80104a70 <pushcli>
  c = mycpu();
80104742:	e8 59 f1 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104747:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010474d:	e8 6e 03 00 00       	call   80104ac0 <popcli>
  struct proc* p = myproc();
  if (p == null){
80104752:	85 db                	test   %ebx,%ebx
80104754:	74 7e                	je     801047d4 <handle_signals+0xa4>
    return;
  }
 
  uint mask = p->blocked_signal_mask;
  uint pending = p->pending_signals;
  uint signals_to_handle = (~mask) & pending;
80104756:	8b bb 88 00 00 00    	mov    0x88(%ebx),%edi
8010475c:	be 01 00 00 00       	mov    $0x1,%esi
80104761:	f7 d7                	not    %edi
80104763:	23 bb 84 00 00 00    	and    0x84(%ebx),%edi
  for (int signum = 0; signum < 32; signum++){
80104769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104770:	8d 4e ff             	lea    -0x1(%esi),%ecx
    if (((signals_to_handle >> signum) & 0x1) == 0){
80104773:	0f a3 cf             	bt     %ecx,%edi
80104776:	73 38                	jae    801047b0 <handle_signals+0x80>
        continue;
    }
    // turning off the bit in pending signals
    p->pending_signals &= ~(1 << signum);
80104778:	b8 01 00 00 00       	mov    $0x1,%eax
8010477d:	d3 e0                	shl    %cl,%eax
8010477f:	f7 d0                	not    %eax
80104781:	21 83 84 00 00 00    	and    %eax,0x84(%ebx)

    // handle if kernel handler
    int sa_handler = (int)p->signal_handlers[signum].sa_handler;
80104787:	8b 94 f3 88 00 00 00 	mov    0x88(%ebx,%esi,8),%edx
    switch (sa_handler){
8010478e:	83 fa 13             	cmp    $0x13,%edx
80104791:	77 0d                	ja     801047a0 <handle_signals+0x70>
80104793:	3e ff 24 95 0c 7f 10 	notrack jmp *-0x7fef80f4(,%edx,4)
8010479a:	80 
8010479b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010479f:	90                   	nop
        else{
          sigkill();
        }
        break;
      default:
        if (p->flag_in_user_handler == 0){ 
801047a0:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801047a6:	85 c0                	test   %eax,%eax
801047a8:	74 6d                	je     80104817 <handle_signals+0xe7>
801047aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (int signum = 0; signum < 32; signum++){
801047b0:	83 fe 20             	cmp    $0x20,%esi
801047b3:	74 1f                	je     801047d4 <handle_signals+0xa4>
801047b5:	83 c6 01             	add    $0x1,%esi
801047b8:	eb b6                	jmp    80104770 <handle_signals+0x40>
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (signum == SIGSTOP){
801047c0:	83 f9 11             	cmp    $0x11,%ecx
801047c3:	74 4b                	je     80104810 <handle_signals+0xe0>
        else if (signum == SIGCONT){
801047c5:	83 f9 13             	cmp    $0x13,%ecx
801047c8:	74 36                	je     80104800 <handle_signals+0xd0>
          sigkill();
801047ca:	e8 d1 fe ff ff       	call   801046a0 <sigkill>
  for (int signum = 0; signum < 32; signum++){
801047cf:	83 fe 20             	cmp    $0x20,%esi
801047d2:	75 e1                	jne    801047b5 <handle_signals+0x85>
        }
    } 
    
  }
  return;
801047d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047d7:	5b                   	pop    %ebx
801047d8:	5e                   	pop    %esi
801047d9:	5f                   	pop    %edi
801047da:	5d                   	pop    %ebp
801047db:	c3                   	ret    
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        sigcont();
801047e0:	e8 eb fe ff ff       	call   801046d0 <sigcont>
        break;
801047e5:	eb c9                	jmp    801047b0 <handle_signals+0x80>
801047e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ee:	66 90                	xchg   %ax,%ax
        sigstop();
801047f0:	e8 0b ff ff ff       	call   80104700 <sigstop>
        break;
801047f5:	eb b9                	jmp    801047b0 <handle_signals+0x80>
801047f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047fe:	66 90                	xchg   %ax,%ax
          sigcont();
80104800:	e8 cb fe ff ff       	call   801046d0 <sigcont>
80104805:	eb ae                	jmp    801047b5 <handle_signals+0x85>
80104807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010480e:	66 90                	xchg   %ax,%ax
          sigstop();
80104810:	e8 eb fe ff ff       	call   80104700 <sigstop>
80104815:	eb 9e                	jmp    801047b5 <handle_signals+0x85>
80104817:	89 c8                	mov    %ecx,%eax
          p->mask_backup = p->blocked_signal_mask;
80104819:	8b 8b 88 00 00 00    	mov    0x88(%ebx),%ecx
          *(p->user_trapframe_backup) = *(p->tf);
8010481f:	8b 73 18             	mov    0x18(%ebx),%esi
80104822:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104825:	8b bb 90 01 00 00    	mov    0x190(%ebx),%edi
          char call_sigret[7] = { 0xB8, 0x18, 0x00, 0x00, 0x00, 0xCD, 0x40 };
8010482b:	ba 00 cd ff ff       	mov    $0xffffcd00,%edx
          memmove((void*)(p->tf->esp + 8), call_sigret, 7);
80104830:	83 ec 04             	sub    $0x4,%esp
          p->flag_in_user_handler = 1;
80104833:	c7 83 80 00 00 00 01 	movl   $0x1,0x80(%ebx)
8010483a:	00 00 00 
          p->mask_backup = p->blocked_signal_mask;
8010483d:	89 8b 8c 00 00 00    	mov    %ecx,0x8c(%ebx)
          p->blocked_signal_mask = p->signal_handlers[signum].sigmask;
80104843:	8b 8c c3 94 00 00 00 	mov    0x94(%ebx,%eax,8),%ecx
8010484a:	89 8b 88 00 00 00    	mov    %ecx,0x88(%ebx)
          *(p->user_trapframe_backup) = *(p->tf);
80104850:	b9 13 00 00 00       	mov    $0x13,%ecx
80104855:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
          char call_sigret[7] = { 0xB8, 0x18, 0x00, 0x00, 0x00, 0xCD, 0x40 };
80104857:	66 89 55 e5          	mov    %dx,-0x1b(%ebp)
8010485b:	c7 45 e1 b8 18 00 00 	movl   $0x18b8,-0x1f(%ebp)
          p->tf->esp -= 0xF;
80104862:	8b 4b 18             	mov    0x18(%ebx),%ecx
          char call_sigret[7] = { 0xB8, 0x18, 0x00, 0x00, 0x00, 0xCD, 0x40 };
80104865:	c6 45 e7 40          	movb   $0x40,-0x19(%ebp)
          p->tf->esp -= 0xF;
80104869:	83 69 44 0f          	subl   $0xf,0x44(%ecx)
          *((int*)(p->tf->esp)) = p->tf->esp + 0x8;
8010486d:	8b 4b 18             	mov    0x18(%ebx),%ecx
80104870:	8b 49 44             	mov    0x44(%ecx),%ecx
80104873:	8d 71 08             	lea    0x8(%ecx),%esi
80104876:	89 31                	mov    %esi,(%ecx)
          *((int*)(p->tf->esp + 4)) = signum;
80104878:	8b 4b 18             	mov    0x18(%ebx),%ecx
8010487b:	8b 49 44             	mov    0x44(%ecx),%ecx
8010487e:	89 41 04             	mov    %eax,0x4(%ecx)
          memmove((void*)(p->tf->esp + 8), call_sigret, 7);
80104881:	8d 45 e1             	lea    -0x1f(%ebp),%eax
80104884:	6a 07                	push   $0x7
80104886:	50                   	push   %eax
80104887:	8b 43 18             	mov    0x18(%ebx),%eax
8010488a:	8b 40 44             	mov    0x44(%eax),%eax
8010488d:	83 c0 08             	add    $0x8,%eax
80104890:	50                   	push   %eax
80104891:	e8 8a 04 00 00       	call   80104d20 <memmove>
          p->tf->eip = sa_handler + 4;
80104896:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104899:	8b 43 18             	mov    0x18(%ebx),%eax
8010489c:	83 c4 10             	add    $0x10,%esp
8010489f:	83 c2 04             	add    $0x4,%edx
801048a2:	89 50 38             	mov    %edx,0x38(%eax)
801048a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048a8:	5b                   	pop    %ebx
801048a9:	5e                   	pop    %esi
801048aa:	5f                   	pop    %edi
801048ab:	5d                   	pop    %ebp
801048ac:	c3                   	ret    
801048ad:	66 90                	xchg   %ax,%ax
801048af:	90                   	nop

801048b0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801048b0:	f3 0f 1e fb          	endbr32 
801048b4:	55                   	push   %ebp
801048b5:	89 e5                	mov    %esp,%ebp
801048b7:	53                   	push   %ebx
801048b8:	83 ec 0c             	sub    $0xc,%esp
801048bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801048be:	68 74 7f 10 80       	push   $0x80107f74
801048c3:	8d 43 04             	lea    0x4(%ebx),%eax
801048c6:	50                   	push   %eax
801048c7:	e8 24 01 00 00       	call   801049f0 <initlock>
  lk->name = name;
801048cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801048cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801048d5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801048d8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801048df:	89 43 38             	mov    %eax,0x38(%ebx)
}
801048e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048e5:	c9                   	leave  
801048e6:	c3                   	ret    
801048e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ee:	66 90                	xchg   %ax,%ax

801048f0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	56                   	push   %esi
801048f8:	53                   	push   %ebx
801048f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048fc:	8d 73 04             	lea    0x4(%ebx),%esi
801048ff:	83 ec 0c             	sub    $0xc,%esp
80104902:	56                   	push   %esi
80104903:	e8 68 02 00 00       	call   80104b70 <acquire>
  while (lk->locked) {
80104908:	8b 13                	mov    (%ebx),%edx
8010490a:	83 c4 10             	add    $0x10,%esp
8010490d:	85 d2                	test   %edx,%edx
8010490f:	74 1a                	je     8010492b <acquiresleep+0x3b>
80104911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104918:	83 ec 08             	sub    $0x8,%esp
8010491b:	56                   	push   %esi
8010491c:	53                   	push   %ebx
8010491d:	e8 ae f8 ff ff       	call   801041d0 <sleep>
  while (lk->locked) {
80104922:	8b 03                	mov    (%ebx),%eax
80104924:	83 c4 10             	add    $0x10,%esp
80104927:	85 c0                	test   %eax,%eax
80104929:	75 ed                	jne    80104918 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010492b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104931:	e8 fa ef ff ff       	call   80103930 <myproc>
80104936:	8b 40 10             	mov    0x10(%eax),%eax
80104939:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010493c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010493f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104942:	5b                   	pop    %ebx
80104943:	5e                   	pop    %esi
80104944:	5d                   	pop    %ebp
  release(&lk->lk);
80104945:	e9 e6 02 00 00       	jmp    80104c30 <release>
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104950 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	56                   	push   %esi
80104958:	53                   	push   %ebx
80104959:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010495c:	8d 73 04             	lea    0x4(%ebx),%esi
8010495f:	83 ec 0c             	sub    $0xc,%esp
80104962:	56                   	push   %esi
80104963:	e8 08 02 00 00       	call   80104b70 <acquire>
  lk->locked = 0;
80104968:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010496e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104975:	89 1c 24             	mov    %ebx,(%esp)
80104978:	e8 13 fa ff ff       	call   80104390 <wakeup>
  release(&lk->lk);
8010497d:	89 75 08             	mov    %esi,0x8(%ebp)
80104980:	83 c4 10             	add    $0x10,%esp
}
80104983:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104986:	5b                   	pop    %ebx
80104987:	5e                   	pop    %esi
80104988:	5d                   	pop    %ebp
  release(&lk->lk);
80104989:	e9 a2 02 00 00       	jmp    80104c30 <release>
8010498e:	66 90                	xchg   %ax,%ax

80104990 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104990:	f3 0f 1e fb          	endbr32 
80104994:	55                   	push   %ebp
80104995:	89 e5                	mov    %esp,%ebp
80104997:	57                   	push   %edi
80104998:	31 ff                	xor    %edi,%edi
8010499a:	56                   	push   %esi
8010499b:	53                   	push   %ebx
8010499c:	83 ec 18             	sub    $0x18,%esp
8010499f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801049a2:	8d 73 04             	lea    0x4(%ebx),%esi
801049a5:	56                   	push   %esi
801049a6:	e8 c5 01 00 00       	call   80104b70 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801049ab:	8b 03                	mov    (%ebx),%eax
801049ad:	83 c4 10             	add    $0x10,%esp
801049b0:	85 c0                	test   %eax,%eax
801049b2:	75 1c                	jne    801049d0 <holdingsleep+0x40>
  release(&lk->lk);
801049b4:	83 ec 0c             	sub    $0xc,%esp
801049b7:	56                   	push   %esi
801049b8:	e8 73 02 00 00       	call   80104c30 <release>
  return r;
}
801049bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049c0:	89 f8                	mov    %edi,%eax
801049c2:	5b                   	pop    %ebx
801049c3:	5e                   	pop    %esi
801049c4:	5f                   	pop    %edi
801049c5:	5d                   	pop    %ebp
801049c6:	c3                   	ret    
801049c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ce:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
801049d0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801049d3:	e8 58 ef ff ff       	call   80103930 <myproc>
801049d8:	39 58 10             	cmp    %ebx,0x10(%eax)
801049db:	0f 94 c0             	sete   %al
801049de:	0f b6 c0             	movzbl %al,%eax
801049e1:	89 c7                	mov    %eax,%edi
801049e3:	eb cf                	jmp    801049b4 <holdingsleep+0x24>
801049e5:	66 90                	xchg   %ax,%ax
801049e7:	66 90                	xchg   %ax,%ax
801049e9:	66 90                	xchg   %ax,%ax
801049eb:	66 90                	xchg   %ax,%ax
801049ed:	66 90                	xchg   %ax,%ax
801049ef:	90                   	nop

801049f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801049f0:	f3 0f 1e fb          	endbr32 
801049f4:	55                   	push   %ebp
801049f5:	89 e5                	mov    %esp,%ebp
801049f7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801049fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801049fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a03:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a0d:	5d                   	pop    %ebp
80104a0e:	c3                   	ret    
80104a0f:	90                   	nop

80104a10 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a10:	f3 0f 1e fb          	endbr32 
80104a14:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a15:	31 d2                	xor    %edx,%edx
{
80104a17:	89 e5                	mov    %esp,%ebp
80104a19:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104a1a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104a1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104a20:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104a23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a27:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a28:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a2e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a34:	77 1a                	ja     80104a50 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a36:	8b 58 04             	mov    0x4(%eax),%ebx
80104a39:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a3c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a3f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a41:	83 fa 0a             	cmp    $0xa,%edx
80104a44:	75 e2                	jne    80104a28 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104a46:	5b                   	pop    %ebx
80104a47:	5d                   	pop    %ebp
80104a48:	c3                   	ret    
80104a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104a50:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104a53:	8d 51 28             	lea    0x28(%ecx),%edx
80104a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104a60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104a66:	83 c0 04             	add    $0x4,%eax
80104a69:	39 d0                	cmp    %edx,%eax
80104a6b:	75 f3                	jne    80104a60 <getcallerpcs+0x50>
}
80104a6d:	5b                   	pop    %ebx
80104a6e:	5d                   	pop    %ebp
80104a6f:	c3                   	ret    

80104a70 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104a70:	f3 0f 1e fb          	endbr32 
80104a74:	55                   	push   %ebp
80104a75:	89 e5                	mov    %esp,%ebp
80104a77:	53                   	push   %ebx
80104a78:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a7b:	9c                   	pushf  
80104a7c:	5b                   	pop    %ebx
  asm volatile("cli");
80104a7d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104a7e:	e8 1d ee ff ff       	call   801038a0 <mycpu>
80104a83:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a89:	85 c0                	test   %eax,%eax
80104a8b:	74 13                	je     80104aa0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104a8d:	e8 0e ee ff ff       	call   801038a0 <mycpu>
80104a92:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104a99:	83 c4 04             	add    $0x4,%esp
80104a9c:	5b                   	pop    %ebx
80104a9d:	5d                   	pop    %ebp
80104a9e:	c3                   	ret    
80104a9f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104aa0:	e8 fb ed ff ff       	call   801038a0 <mycpu>
80104aa5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104aab:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104ab1:	eb da                	jmp    80104a8d <pushcli+0x1d>
80104ab3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ac0 <popcli>:

void
popcli(void)
{
80104ac0:	f3 0f 1e fb          	endbr32 
80104ac4:	55                   	push   %ebp
80104ac5:	89 e5                	mov    %esp,%ebp
80104ac7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104aca:	9c                   	pushf  
80104acb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104acc:	f6 c4 02             	test   $0x2,%ah
80104acf:	75 31                	jne    80104b02 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104ad1:	e8 ca ed ff ff       	call   801038a0 <mycpu>
80104ad6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104add:	78 30                	js     80104b0f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104adf:	e8 bc ed ff ff       	call   801038a0 <mycpu>
80104ae4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104aea:	85 d2                	test   %edx,%edx
80104aec:	74 02                	je     80104af0 <popcli+0x30>
    sti();
}
80104aee:	c9                   	leave  
80104aef:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104af0:	e8 ab ed ff ff       	call   801038a0 <mycpu>
80104af5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104afb:	85 c0                	test   %eax,%eax
80104afd:	74 ef                	je     80104aee <popcli+0x2e>
  asm volatile("sti");
80104aff:	fb                   	sti    
}
80104b00:	c9                   	leave  
80104b01:	c3                   	ret    
    panic("popcli - interruptible");
80104b02:	83 ec 0c             	sub    $0xc,%esp
80104b05:	68 7f 7f 10 80       	push   $0x80107f7f
80104b0a:	e8 81 b8 ff ff       	call   80100390 <panic>
    panic("popcli");
80104b0f:	83 ec 0c             	sub    $0xc,%esp
80104b12:	68 96 7f 10 80       	push   $0x80107f96
80104b17:	e8 74 b8 ff ff       	call   80100390 <panic>
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b20 <holding>:
{
80104b20:	f3 0f 1e fb          	endbr32 
80104b24:	55                   	push   %ebp
80104b25:	89 e5                	mov    %esp,%ebp
80104b27:	56                   	push   %esi
80104b28:	53                   	push   %ebx
80104b29:	8b 75 08             	mov    0x8(%ebp),%esi
80104b2c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104b2e:	e8 3d ff ff ff       	call   80104a70 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b33:	8b 06                	mov    (%esi),%eax
80104b35:	85 c0                	test   %eax,%eax
80104b37:	75 0f                	jne    80104b48 <holding+0x28>
  popcli();
80104b39:	e8 82 ff ff ff       	call   80104ac0 <popcli>
}
80104b3e:	89 d8                	mov    %ebx,%eax
80104b40:	5b                   	pop    %ebx
80104b41:	5e                   	pop    %esi
80104b42:	5d                   	pop    %ebp
80104b43:	c3                   	ret    
80104b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104b48:	8b 5e 08             	mov    0x8(%esi),%ebx
80104b4b:	e8 50 ed ff ff       	call   801038a0 <mycpu>
80104b50:	39 c3                	cmp    %eax,%ebx
80104b52:	0f 94 c3             	sete   %bl
  popcli();
80104b55:	e8 66 ff ff ff       	call   80104ac0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104b5a:	0f b6 db             	movzbl %bl,%ebx
}
80104b5d:	89 d8                	mov    %ebx,%eax
80104b5f:	5b                   	pop    %ebx
80104b60:	5e                   	pop    %esi
80104b61:	5d                   	pop    %ebp
80104b62:	c3                   	ret    
80104b63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b70 <acquire>:
{
80104b70:	f3 0f 1e fb          	endbr32 
80104b74:	55                   	push   %ebp
80104b75:	89 e5                	mov    %esp,%ebp
80104b77:	56                   	push   %esi
80104b78:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104b79:	e8 f2 fe ff ff       	call   80104a70 <pushcli>
  if(holding(lk))
80104b7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b81:	83 ec 0c             	sub    $0xc,%esp
80104b84:	53                   	push   %ebx
80104b85:	e8 96 ff ff ff       	call   80104b20 <holding>
80104b8a:	83 c4 10             	add    $0x10,%esp
80104b8d:	85 c0                	test   %eax,%eax
80104b8f:	0f 85 7f 00 00 00    	jne    80104c14 <acquire+0xa4>
80104b95:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104b97:	ba 01 00 00 00       	mov    $0x1,%edx
80104b9c:	eb 05                	jmp    80104ba3 <acquire+0x33>
80104b9e:	66 90                	xchg   %ax,%ax
80104ba0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ba3:	89 d0                	mov    %edx,%eax
80104ba5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104ba8:	85 c0                	test   %eax,%eax
80104baa:	75 f4                	jne    80104ba0 <acquire+0x30>
  __sync_synchronize();
80104bac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104bb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bb4:	e8 e7 ec ff ff       	call   801038a0 <mycpu>
80104bb9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104bbc:	89 e8                	mov    %ebp,%eax
80104bbe:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104bc0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104bc6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104bcc:	77 22                	ja     80104bf0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104bce:	8b 50 04             	mov    0x4(%eax),%edx
80104bd1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104bd5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104bd8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104bda:	83 fe 0a             	cmp    $0xa,%esi
80104bdd:	75 e1                	jne    80104bc0 <acquire+0x50>
}
80104bdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104be2:	5b                   	pop    %ebx
80104be3:	5e                   	pop    %esi
80104be4:	5d                   	pop    %ebp
80104be5:	c3                   	ret    
80104be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bed:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104bf0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104bf4:	83 c3 34             	add    $0x34,%ebx
80104bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bfe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104c00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c06:	83 c0 04             	add    $0x4,%eax
80104c09:	39 d8                	cmp    %ebx,%eax
80104c0b:	75 f3                	jne    80104c00 <acquire+0x90>
}
80104c0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c10:	5b                   	pop    %ebx
80104c11:	5e                   	pop    %esi
80104c12:	5d                   	pop    %ebp
80104c13:	c3                   	ret    
    panic("acquire");
80104c14:	83 ec 0c             	sub    $0xc,%esp
80104c17:	68 9d 7f 10 80       	push   $0x80107f9d
80104c1c:	e8 6f b7 ff ff       	call   80100390 <panic>
80104c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2f:	90                   	nop

80104c30 <release>:
{
80104c30:	f3 0f 1e fb          	endbr32 
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	53                   	push   %ebx
80104c38:	83 ec 10             	sub    $0x10,%esp
80104c3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104c3e:	53                   	push   %ebx
80104c3f:	e8 dc fe ff ff       	call   80104b20 <holding>
80104c44:	83 c4 10             	add    $0x10,%esp
80104c47:	85 c0                	test   %eax,%eax
80104c49:	74 22                	je     80104c6d <release+0x3d>
  lk->pcs[0] = 0;
80104c4b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104c52:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104c59:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104c5e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104c64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c67:	c9                   	leave  
  popcli();
80104c68:	e9 53 fe ff ff       	jmp    80104ac0 <popcli>
    panic("release");
80104c6d:	83 ec 0c             	sub    $0xc,%esp
80104c70:	68 a5 7f 10 80       	push   $0x80107fa5
80104c75:	e8 16 b7 ff ff       	call   80100390 <panic>
80104c7a:	66 90                	xchg   %ax,%ax
80104c7c:	66 90                	xchg   %ax,%ax
80104c7e:	66 90                	xchg   %ax,%ax

80104c80 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104c80:	f3 0f 1e fb          	endbr32 
80104c84:	55                   	push   %ebp
80104c85:	89 e5                	mov    %esp,%ebp
80104c87:	57                   	push   %edi
80104c88:	8b 55 08             	mov    0x8(%ebp),%edx
80104c8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c8e:	53                   	push   %ebx
80104c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104c92:	89 d7                	mov    %edx,%edi
80104c94:	09 cf                	or     %ecx,%edi
80104c96:	83 e7 03             	and    $0x3,%edi
80104c99:	75 25                	jne    80104cc0 <memset+0x40>
    c &= 0xFF;
80104c9b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104c9e:	c1 e0 18             	shl    $0x18,%eax
80104ca1:	89 fb                	mov    %edi,%ebx
80104ca3:	c1 e9 02             	shr    $0x2,%ecx
80104ca6:	c1 e3 10             	shl    $0x10,%ebx
80104ca9:	09 d8                	or     %ebx,%eax
80104cab:	09 f8                	or     %edi,%eax
80104cad:	c1 e7 08             	shl    $0x8,%edi
80104cb0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104cb2:	89 d7                	mov    %edx,%edi
80104cb4:	fc                   	cld    
80104cb5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104cb7:	5b                   	pop    %ebx
80104cb8:	89 d0                	mov    %edx,%eax
80104cba:	5f                   	pop    %edi
80104cbb:	5d                   	pop    %ebp
80104cbc:	c3                   	ret    
80104cbd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104cc0:	89 d7                	mov    %edx,%edi
80104cc2:	fc                   	cld    
80104cc3:	f3 aa                	rep stos %al,%es:(%edi)
80104cc5:	5b                   	pop    %ebx
80104cc6:	89 d0                	mov    %edx,%eax
80104cc8:	5f                   	pop    %edi
80104cc9:	5d                   	pop    %ebp
80104cca:	c3                   	ret    
80104ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ccf:	90                   	nop

80104cd0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104cd0:	f3 0f 1e fb          	endbr32 
80104cd4:	55                   	push   %ebp
80104cd5:	89 e5                	mov    %esp,%ebp
80104cd7:	56                   	push   %esi
80104cd8:	8b 75 10             	mov    0x10(%ebp),%esi
80104cdb:	8b 55 08             	mov    0x8(%ebp),%edx
80104cde:	53                   	push   %ebx
80104cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104ce2:	85 f6                	test   %esi,%esi
80104ce4:	74 2a                	je     80104d10 <memcmp+0x40>
80104ce6:	01 c6                	add    %eax,%esi
80104ce8:	eb 10                	jmp    80104cfa <memcmp+0x2a>
80104cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104cf0:	83 c0 01             	add    $0x1,%eax
80104cf3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104cf6:	39 f0                	cmp    %esi,%eax
80104cf8:	74 16                	je     80104d10 <memcmp+0x40>
    if(*s1 != *s2)
80104cfa:	0f b6 0a             	movzbl (%edx),%ecx
80104cfd:	0f b6 18             	movzbl (%eax),%ebx
80104d00:	38 d9                	cmp    %bl,%cl
80104d02:	74 ec                	je     80104cf0 <memcmp+0x20>
      return *s1 - *s2;
80104d04:	0f b6 c1             	movzbl %cl,%eax
80104d07:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104d09:	5b                   	pop    %ebx
80104d0a:	5e                   	pop    %esi
80104d0b:	5d                   	pop    %ebp
80104d0c:	c3                   	ret    
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi
80104d10:	5b                   	pop    %ebx
  return 0;
80104d11:	31 c0                	xor    %eax,%eax
}
80104d13:	5e                   	pop    %esi
80104d14:	5d                   	pop    %ebp
80104d15:	c3                   	ret    
80104d16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1d:	8d 76 00             	lea    0x0(%esi),%esi

80104d20 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d20:	f3 0f 1e fb          	endbr32 
80104d24:	55                   	push   %ebp
80104d25:	89 e5                	mov    %esp,%ebp
80104d27:	57                   	push   %edi
80104d28:	8b 55 08             	mov    0x8(%ebp),%edx
80104d2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d2e:	56                   	push   %esi
80104d2f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d32:	39 d6                	cmp    %edx,%esi
80104d34:	73 2a                	jae    80104d60 <memmove+0x40>
80104d36:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104d39:	39 fa                	cmp    %edi,%edx
80104d3b:	73 23                	jae    80104d60 <memmove+0x40>
80104d3d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104d40:	85 c9                	test   %ecx,%ecx
80104d42:	74 13                	je     80104d57 <memmove+0x37>
80104d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104d48:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104d4c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104d4f:	83 e8 01             	sub    $0x1,%eax
80104d52:	83 f8 ff             	cmp    $0xffffffff,%eax
80104d55:	75 f1                	jne    80104d48 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d57:	5e                   	pop    %esi
80104d58:	89 d0                	mov    %edx,%eax
80104d5a:	5f                   	pop    %edi
80104d5b:	5d                   	pop    %ebp
80104d5c:	c3                   	ret    
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104d60:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104d63:	89 d7                	mov    %edx,%edi
80104d65:	85 c9                	test   %ecx,%ecx
80104d67:	74 ee                	je     80104d57 <memmove+0x37>
80104d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104d70:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104d71:	39 f0                	cmp    %esi,%eax
80104d73:	75 fb                	jne    80104d70 <memmove+0x50>
}
80104d75:	5e                   	pop    %esi
80104d76:	89 d0                	mov    %edx,%eax
80104d78:	5f                   	pop    %edi
80104d79:	5d                   	pop    %ebp
80104d7a:	c3                   	ret    
80104d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d7f:	90                   	nop

80104d80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104d80:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104d84:	eb 9a                	jmp    80104d20 <memmove>
80104d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi

80104d90 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104d90:	f3 0f 1e fb          	endbr32 
80104d94:	55                   	push   %ebp
80104d95:	89 e5                	mov    %esp,%ebp
80104d97:	56                   	push   %esi
80104d98:	8b 75 10             	mov    0x10(%ebp),%esi
80104d9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d9e:	53                   	push   %ebx
80104d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104da2:	85 f6                	test   %esi,%esi
80104da4:	74 32                	je     80104dd8 <strncmp+0x48>
80104da6:	01 c6                	add    %eax,%esi
80104da8:	eb 14                	jmp    80104dbe <strncmp+0x2e>
80104daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104db0:	38 da                	cmp    %bl,%dl
80104db2:	75 14                	jne    80104dc8 <strncmp+0x38>
    n--, p++, q++;
80104db4:	83 c0 01             	add    $0x1,%eax
80104db7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104dba:	39 f0                	cmp    %esi,%eax
80104dbc:	74 1a                	je     80104dd8 <strncmp+0x48>
80104dbe:	0f b6 11             	movzbl (%ecx),%edx
80104dc1:	0f b6 18             	movzbl (%eax),%ebx
80104dc4:	84 d2                	test   %dl,%dl
80104dc6:	75 e8                	jne    80104db0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104dc8:	0f b6 c2             	movzbl %dl,%eax
80104dcb:	29 d8                	sub    %ebx,%eax
}
80104dcd:	5b                   	pop    %ebx
80104dce:	5e                   	pop    %esi
80104dcf:	5d                   	pop    %ebp
80104dd0:	c3                   	ret    
80104dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dd8:	5b                   	pop    %ebx
    return 0;
80104dd9:	31 c0                	xor    %eax,%eax
}
80104ddb:	5e                   	pop    %esi
80104ddc:	5d                   	pop    %ebp
80104ddd:	c3                   	ret    
80104dde:	66 90                	xchg   %ax,%ax

80104de0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
80104de5:	89 e5                	mov    %esp,%ebp
80104de7:	57                   	push   %edi
80104de8:	56                   	push   %esi
80104de9:	8b 75 08             	mov    0x8(%ebp),%esi
80104dec:	53                   	push   %ebx
80104ded:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104df0:	89 f2                	mov    %esi,%edx
80104df2:	eb 1b                	jmp    80104e0f <strncpy+0x2f>
80104df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104df8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104dfc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104dff:	83 c2 01             	add    $0x1,%edx
80104e02:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104e06:	89 f9                	mov    %edi,%ecx
80104e08:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e0b:	84 c9                	test   %cl,%cl
80104e0d:	74 09                	je     80104e18 <strncpy+0x38>
80104e0f:	89 c3                	mov    %eax,%ebx
80104e11:	83 e8 01             	sub    $0x1,%eax
80104e14:	85 db                	test   %ebx,%ebx
80104e16:	7f e0                	jg     80104df8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104e18:	89 d1                	mov    %edx,%ecx
80104e1a:	85 c0                	test   %eax,%eax
80104e1c:	7e 15                	jle    80104e33 <strncpy+0x53>
80104e1e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104e20:	83 c1 01             	add    $0x1,%ecx
80104e23:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104e27:	89 c8                	mov    %ecx,%eax
80104e29:	f7 d0                	not    %eax
80104e2b:	01 d0                	add    %edx,%eax
80104e2d:	01 d8                	add    %ebx,%eax
80104e2f:	85 c0                	test   %eax,%eax
80104e31:	7f ed                	jg     80104e20 <strncpy+0x40>
  return os;
}
80104e33:	5b                   	pop    %ebx
80104e34:	89 f0                	mov    %esi,%eax
80104e36:	5e                   	pop    %esi
80104e37:	5f                   	pop    %edi
80104e38:	5d                   	pop    %ebp
80104e39:	c3                   	ret    
80104e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e40 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104e40:	f3 0f 1e fb          	endbr32 
80104e44:	55                   	push   %ebp
80104e45:	89 e5                	mov    %esp,%ebp
80104e47:	56                   	push   %esi
80104e48:	8b 55 10             	mov    0x10(%ebp),%edx
80104e4b:	8b 75 08             	mov    0x8(%ebp),%esi
80104e4e:	53                   	push   %ebx
80104e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104e52:	85 d2                	test   %edx,%edx
80104e54:	7e 21                	jle    80104e77 <safestrcpy+0x37>
80104e56:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104e5a:	89 f2                	mov    %esi,%edx
80104e5c:	eb 12                	jmp    80104e70 <safestrcpy+0x30>
80104e5e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104e60:	0f b6 08             	movzbl (%eax),%ecx
80104e63:	83 c0 01             	add    $0x1,%eax
80104e66:	83 c2 01             	add    $0x1,%edx
80104e69:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e6c:	84 c9                	test   %cl,%cl
80104e6e:	74 04                	je     80104e74 <safestrcpy+0x34>
80104e70:	39 d8                	cmp    %ebx,%eax
80104e72:	75 ec                	jne    80104e60 <safestrcpy+0x20>
    ;
  *s = 0;
80104e74:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104e77:	89 f0                	mov    %esi,%eax
80104e79:	5b                   	pop    %ebx
80104e7a:	5e                   	pop    %esi
80104e7b:	5d                   	pop    %ebp
80104e7c:	c3                   	ret    
80104e7d:	8d 76 00             	lea    0x0(%esi),%esi

80104e80 <strlen>:

int
strlen(const char *s)
{
80104e80:	f3 0f 1e fb          	endbr32 
80104e84:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104e85:	31 c0                	xor    %eax,%eax
{
80104e87:	89 e5                	mov    %esp,%ebp
80104e89:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104e8c:	80 3a 00             	cmpb   $0x0,(%edx)
80104e8f:	74 10                	je     80104ea1 <strlen+0x21>
80104e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e98:	83 c0 01             	add    $0x1,%eax
80104e9b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104e9f:	75 f7                	jne    80104e98 <strlen+0x18>
    ;
  return n;
}
80104ea1:	5d                   	pop    %ebp
80104ea2:	c3                   	ret    

80104ea3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104ea3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104ea7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104eab:	55                   	push   %ebp
  pushl %ebx
80104eac:	53                   	push   %ebx
  pushl %esi
80104ead:	56                   	push   %esi
  pushl %edi
80104eae:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104eaf:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104eb1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104eb3:	5f                   	pop    %edi
  popl %esi
80104eb4:	5e                   	pop    %esi
  popl %ebx
80104eb5:	5b                   	pop    %ebx
  popl %ebp
80104eb6:	5d                   	pop    %ebp
  ret
80104eb7:	c3                   	ret    
80104eb8:	66 90                	xchg   %ax,%ax
80104eba:	66 90                	xchg   %ax,%ax
80104ebc:	66 90                	xchg   %ax,%ax
80104ebe:	66 90                	xchg   %ax,%ax

80104ec0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ec0:	f3 0f 1e fb          	endbr32 
80104ec4:	55                   	push   %ebp
80104ec5:	89 e5                	mov    %esp,%ebp
80104ec7:	53                   	push   %ebx
80104ec8:	83 ec 04             	sub    $0x4,%esp
80104ecb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104ece:	e8 5d ea ff ff       	call   80103930 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ed3:	8b 00                	mov    (%eax),%eax
80104ed5:	39 d8                	cmp    %ebx,%eax
80104ed7:	76 17                	jbe    80104ef0 <fetchint+0x30>
80104ed9:	8d 53 04             	lea    0x4(%ebx),%edx
80104edc:	39 d0                	cmp    %edx,%eax
80104ede:	72 10                	jb     80104ef0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ee3:	8b 13                	mov    (%ebx),%edx
80104ee5:	89 10                	mov    %edx,(%eax)
  return 0;
80104ee7:	31 c0                	xor    %eax,%eax
}
80104ee9:	83 c4 04             	add    $0x4,%esp
80104eec:	5b                   	pop    %ebx
80104eed:	5d                   	pop    %ebp
80104eee:	c3                   	ret    
80104eef:	90                   	nop
    return -1;
80104ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ef5:	eb f2                	jmp    80104ee9 <fetchint+0x29>
80104ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efe:	66 90                	xchg   %ax,%ax

80104f00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f00:	f3 0f 1e fb          	endbr32 
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	53                   	push   %ebx
80104f08:	83 ec 04             	sub    $0x4,%esp
80104f0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f0e:	e8 1d ea ff ff       	call   80103930 <myproc>

  if(addr >= curproc->sz)
80104f13:	39 18                	cmp    %ebx,(%eax)
80104f15:	76 31                	jbe    80104f48 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104f17:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f1a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104f1c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104f1e:	39 d3                	cmp    %edx,%ebx
80104f20:	73 26                	jae    80104f48 <fetchstr+0x48>
80104f22:	89 d8                	mov    %ebx,%eax
80104f24:	eb 11                	jmp    80104f37 <fetchstr+0x37>
80104f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
80104f30:	83 c0 01             	add    $0x1,%eax
80104f33:	39 c2                	cmp    %eax,%edx
80104f35:	76 11                	jbe    80104f48 <fetchstr+0x48>
    if(*s == 0)
80104f37:	80 38 00             	cmpb   $0x0,(%eax)
80104f3a:	75 f4                	jne    80104f30 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104f3c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104f3f:	29 d8                	sub    %ebx,%eax
}
80104f41:	5b                   	pop    %ebx
80104f42:	5d                   	pop    %ebp
80104f43:	c3                   	ret    
80104f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f48:	83 c4 04             	add    $0x4,%esp
    return -1;
80104f4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f50:	5b                   	pop    %ebx
80104f51:	5d                   	pop    %ebp
80104f52:	c3                   	ret    
80104f53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f60 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f60:	f3 0f 1e fb          	endbr32 
80104f64:	55                   	push   %ebp
80104f65:	89 e5                	mov    %esp,%ebp
80104f67:	56                   	push   %esi
80104f68:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f69:	e8 c2 e9 ff ff       	call   80103930 <myproc>
80104f6e:	8b 55 08             	mov    0x8(%ebp),%edx
80104f71:	8b 40 18             	mov    0x18(%eax),%eax
80104f74:	8b 40 44             	mov    0x44(%eax),%eax
80104f77:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f7a:	e8 b1 e9 ff ff       	call   80103930 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f7f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f82:	8b 00                	mov    (%eax),%eax
80104f84:	39 c6                	cmp    %eax,%esi
80104f86:	73 18                	jae    80104fa0 <argint+0x40>
80104f88:	8d 53 08             	lea    0x8(%ebx),%edx
80104f8b:	39 d0                	cmp    %edx,%eax
80104f8d:	72 11                	jb     80104fa0 <argint+0x40>
  *ip = *(int*)(addr);
80104f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f92:	8b 53 04             	mov    0x4(%ebx),%edx
80104f95:	89 10                	mov    %edx,(%eax)
  return 0;
80104f97:	31 c0                	xor    %eax,%eax
}
80104f99:	5b                   	pop    %ebx
80104f9a:	5e                   	pop    %esi
80104f9b:	5d                   	pop    %ebp
80104f9c:	c3                   	ret    
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fa5:	eb f2                	jmp    80104f99 <argint+0x39>
80104fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fae:	66 90                	xchg   %ax,%ax

80104fb0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104fb0:	f3 0f 1e fb          	endbr32 
80104fb4:	55                   	push   %ebp
80104fb5:	89 e5                	mov    %esp,%ebp
80104fb7:	56                   	push   %esi
80104fb8:	53                   	push   %ebx
80104fb9:	83 ec 10             	sub    $0x10,%esp
80104fbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104fbf:	e8 6c e9 ff ff       	call   80103930 <myproc>
 
  if(argint(n, &i) < 0)
80104fc4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104fc7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104fc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fcc:	50                   	push   %eax
80104fcd:	ff 75 08             	pushl  0x8(%ebp)
80104fd0:	e8 8b ff ff ff       	call   80104f60 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104fd5:	83 c4 10             	add    $0x10,%esp
80104fd8:	85 c0                	test   %eax,%eax
80104fda:	78 24                	js     80105000 <argptr+0x50>
80104fdc:	85 db                	test   %ebx,%ebx
80104fde:	78 20                	js     80105000 <argptr+0x50>
80104fe0:	8b 16                	mov    (%esi),%edx
80104fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fe5:	39 c2                	cmp    %eax,%edx
80104fe7:	76 17                	jbe    80105000 <argptr+0x50>
80104fe9:	01 c3                	add    %eax,%ebx
80104feb:	39 da                	cmp    %ebx,%edx
80104fed:	72 11                	jb     80105000 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104fef:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ff2:	89 02                	mov    %eax,(%edx)
  return 0;
80104ff4:	31 c0                	xor    %eax,%eax
}
80104ff6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ff9:	5b                   	pop    %ebx
80104ffa:	5e                   	pop    %esi
80104ffb:	5d                   	pop    %ebp
80104ffc:	c3                   	ret    
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105005:	eb ef                	jmp    80104ff6 <argptr+0x46>
80105007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010500e:	66 90                	xchg   %ax,%ax

80105010 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105010:	f3 0f 1e fb          	endbr32 
80105014:	55                   	push   %ebp
80105015:	89 e5                	mov    %esp,%ebp
80105017:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010501a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010501d:	50                   	push   %eax
8010501e:	ff 75 08             	pushl  0x8(%ebp)
80105021:	e8 3a ff ff ff       	call   80104f60 <argint>
80105026:	83 c4 10             	add    $0x10,%esp
80105029:	85 c0                	test   %eax,%eax
8010502b:	78 13                	js     80105040 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010502d:	83 ec 08             	sub    $0x8,%esp
80105030:	ff 75 0c             	pushl  0xc(%ebp)
80105033:	ff 75 f4             	pushl  -0xc(%ebp)
80105036:	e8 c5 fe ff ff       	call   80104f00 <fetchstr>
8010503b:	83 c4 10             	add    $0x10,%esp
}
8010503e:	c9                   	leave  
8010503f:	c3                   	ret    
80105040:	c9                   	leave  
    return -1;
80105041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105046:	c3                   	ret    
80105047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010504e:	66 90                	xchg   %ax,%ax

80105050 <syscall>:
[SYS_sigret] sys_sigret
};

void
syscall(void)
{
80105050:	f3 0f 1e fb          	endbr32 
80105054:	55                   	push   %ebp
80105055:	89 e5                	mov    %esp,%ebp
80105057:	53                   	push   %ebx
80105058:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010505b:	e8 d0 e8 ff ff       	call   80103930 <myproc>
80105060:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105062:	8b 40 18             	mov    0x18(%eax),%eax
80105065:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105068:	8d 50 ff             	lea    -0x1(%eax),%edx
8010506b:	83 fa 17             	cmp    $0x17,%edx
8010506e:	77 20                	ja     80105090 <syscall+0x40>
80105070:	8b 14 85 e0 7f 10 80 	mov    -0x7fef8020(,%eax,4),%edx
80105077:	85 d2                	test   %edx,%edx
80105079:	74 15                	je     80105090 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010507b:	ff d2                	call   *%edx
8010507d:	89 c2                	mov    %eax,%edx
8010507f:	8b 43 18             	mov    0x18(%ebx),%eax
80105082:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105085:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105088:	c9                   	leave  
80105089:	c3                   	ret    
8010508a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105090:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105091:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105094:	50                   	push   %eax
80105095:	ff 73 10             	pushl  0x10(%ebx)
80105098:	68 ad 7f 10 80       	push   $0x80107fad
8010509d:	e8 0e b6 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801050a2:	8b 43 18             	mov    0x18(%ebx),%eax
801050a5:	83 c4 10             	add    $0x10,%esp
801050a8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801050af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050b2:	c9                   	leave  
801050b3:	c3                   	ret    
801050b4:	66 90                	xchg   %ax,%ax
801050b6:	66 90                	xchg   %ax,%ax
801050b8:	66 90                	xchg   %ax,%ax
801050ba:	66 90                	xchg   %ax,%ax
801050bc:	66 90                	xchg   %ax,%ax
801050be:	66 90                	xchg   %ax,%ax

801050c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	57                   	push   %edi
801050c4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801050c5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801050c8:	53                   	push   %ebx
801050c9:	83 ec 34             	sub    $0x34,%esp
801050cc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801050cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801050d2:	57                   	push   %edi
801050d3:	50                   	push   %eax
{
801050d4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801050d7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801050da:	e8 a1 cf ff ff       	call   80102080 <nameiparent>
801050df:	83 c4 10             	add    $0x10,%esp
801050e2:	85 c0                	test   %eax,%eax
801050e4:	0f 84 46 01 00 00    	je     80105230 <create+0x170>
    return 0;
  ilock(dp);
801050ea:	83 ec 0c             	sub    $0xc,%esp
801050ed:	89 c3                	mov    %eax,%ebx
801050ef:	50                   	push   %eax
801050f0:	e8 9b c6 ff ff       	call   80101790 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801050f5:	83 c4 0c             	add    $0xc,%esp
801050f8:	6a 00                	push   $0x0
801050fa:	57                   	push   %edi
801050fb:	53                   	push   %ebx
801050fc:	e8 df cb ff ff       	call   80101ce0 <dirlookup>
80105101:	83 c4 10             	add    $0x10,%esp
80105104:	89 c6                	mov    %eax,%esi
80105106:	85 c0                	test   %eax,%eax
80105108:	74 56                	je     80105160 <create+0xa0>
    iunlockput(dp);
8010510a:	83 ec 0c             	sub    $0xc,%esp
8010510d:	53                   	push   %ebx
8010510e:	e8 1d c9 ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
80105113:	89 34 24             	mov    %esi,(%esp)
80105116:	e8 75 c6 ff ff       	call   80101790 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010511b:	83 c4 10             	add    $0x10,%esp
8010511e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105123:	75 1b                	jne    80105140 <create+0x80>
80105125:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010512a:	75 14                	jne    80105140 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010512c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010512f:	89 f0                	mov    %esi,%eax
80105131:	5b                   	pop    %ebx
80105132:	5e                   	pop    %esi
80105133:	5f                   	pop    %edi
80105134:	5d                   	pop    %ebp
80105135:	c3                   	ret    
80105136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105140:	83 ec 0c             	sub    $0xc,%esp
80105143:	56                   	push   %esi
    return 0;
80105144:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105146:	e8 e5 c8 ff ff       	call   80101a30 <iunlockput>
    return 0;
8010514b:	83 c4 10             	add    $0x10,%esp
}
8010514e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105151:	89 f0                	mov    %esi,%eax
80105153:	5b                   	pop    %ebx
80105154:	5e                   	pop    %esi
80105155:	5f                   	pop    %edi
80105156:	5d                   	pop    %ebp
80105157:	c3                   	ret    
80105158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105160:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105164:	83 ec 08             	sub    $0x8,%esp
80105167:	50                   	push   %eax
80105168:	ff 33                	pushl  (%ebx)
8010516a:	e8 a1 c4 ff ff       	call   80101610 <ialloc>
8010516f:	83 c4 10             	add    $0x10,%esp
80105172:	89 c6                	mov    %eax,%esi
80105174:	85 c0                	test   %eax,%eax
80105176:	0f 84 cd 00 00 00    	je     80105249 <create+0x189>
  ilock(ip);
8010517c:	83 ec 0c             	sub    $0xc,%esp
8010517f:	50                   	push   %eax
80105180:	e8 0b c6 ff ff       	call   80101790 <ilock>
  ip->major = major;
80105185:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105189:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010518d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105191:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105195:	b8 01 00 00 00       	mov    $0x1,%eax
8010519a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010519e:	89 34 24             	mov    %esi,(%esp)
801051a1:	e8 2a c5 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801051a6:	83 c4 10             	add    $0x10,%esp
801051a9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801051ae:	74 30                	je     801051e0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801051b0:	83 ec 04             	sub    $0x4,%esp
801051b3:	ff 76 04             	pushl  0x4(%esi)
801051b6:	57                   	push   %edi
801051b7:	53                   	push   %ebx
801051b8:	e8 e3 cd ff ff       	call   80101fa0 <dirlink>
801051bd:	83 c4 10             	add    $0x10,%esp
801051c0:	85 c0                	test   %eax,%eax
801051c2:	78 78                	js     8010523c <create+0x17c>
  iunlockput(dp);
801051c4:	83 ec 0c             	sub    $0xc,%esp
801051c7:	53                   	push   %ebx
801051c8:	e8 63 c8 ff ff       	call   80101a30 <iunlockput>
  return ip;
801051cd:	83 c4 10             	add    $0x10,%esp
}
801051d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051d3:	89 f0                	mov    %esi,%eax
801051d5:	5b                   	pop    %ebx
801051d6:	5e                   	pop    %esi
801051d7:	5f                   	pop    %edi
801051d8:	5d                   	pop    %ebp
801051d9:	c3                   	ret    
801051da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801051e0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801051e3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801051e8:	53                   	push   %ebx
801051e9:	e8 e2 c4 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801051ee:	83 c4 0c             	add    $0xc,%esp
801051f1:	ff 76 04             	pushl  0x4(%esi)
801051f4:	68 60 80 10 80       	push   $0x80108060
801051f9:	56                   	push   %esi
801051fa:	e8 a1 cd ff ff       	call   80101fa0 <dirlink>
801051ff:	83 c4 10             	add    $0x10,%esp
80105202:	85 c0                	test   %eax,%eax
80105204:	78 18                	js     8010521e <create+0x15e>
80105206:	83 ec 04             	sub    $0x4,%esp
80105209:	ff 73 04             	pushl  0x4(%ebx)
8010520c:	68 5f 80 10 80       	push   $0x8010805f
80105211:	56                   	push   %esi
80105212:	e8 89 cd ff ff       	call   80101fa0 <dirlink>
80105217:	83 c4 10             	add    $0x10,%esp
8010521a:	85 c0                	test   %eax,%eax
8010521c:	79 92                	jns    801051b0 <create+0xf0>
      panic("create dots");
8010521e:	83 ec 0c             	sub    $0xc,%esp
80105221:	68 53 80 10 80       	push   $0x80108053
80105226:	e8 65 b1 ff ff       	call   80100390 <panic>
8010522b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010522f:	90                   	nop
}
80105230:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105233:	31 f6                	xor    %esi,%esi
}
80105235:	5b                   	pop    %ebx
80105236:	89 f0                	mov    %esi,%eax
80105238:	5e                   	pop    %esi
80105239:	5f                   	pop    %edi
8010523a:	5d                   	pop    %ebp
8010523b:	c3                   	ret    
    panic("create: dirlink");
8010523c:	83 ec 0c             	sub    $0xc,%esp
8010523f:	68 62 80 10 80       	push   $0x80108062
80105244:	e8 47 b1 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105249:	83 ec 0c             	sub    $0xc,%esp
8010524c:	68 44 80 10 80       	push   $0x80108044
80105251:	e8 3a b1 ff ff       	call   80100390 <panic>
80105256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010525d:	8d 76 00             	lea    0x0(%esi),%esi

80105260 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	56                   	push   %esi
80105264:	89 d6                	mov    %edx,%esi
80105266:	53                   	push   %ebx
80105267:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105269:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010526c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010526f:	50                   	push   %eax
80105270:	6a 00                	push   $0x0
80105272:	e8 e9 fc ff ff       	call   80104f60 <argint>
80105277:	83 c4 10             	add    $0x10,%esp
8010527a:	85 c0                	test   %eax,%eax
8010527c:	78 2a                	js     801052a8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010527e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105282:	77 24                	ja     801052a8 <argfd.constprop.0+0x48>
80105284:	e8 a7 e6 ff ff       	call   80103930 <myproc>
80105289:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010528c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105290:	85 c0                	test   %eax,%eax
80105292:	74 14                	je     801052a8 <argfd.constprop.0+0x48>
  if(pfd)
80105294:	85 db                	test   %ebx,%ebx
80105296:	74 02                	je     8010529a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105298:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010529a:	89 06                	mov    %eax,(%esi)
  return 0;
8010529c:	31 c0                	xor    %eax,%eax
}
8010529e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052a1:	5b                   	pop    %ebx
801052a2:	5e                   	pop    %esi
801052a3:	5d                   	pop    %ebp
801052a4:	c3                   	ret    
801052a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052ad:	eb ef                	jmp    8010529e <argfd.constprop.0+0x3e>
801052af:	90                   	nop

801052b0 <sys_dup>:
{
801052b0:	f3 0f 1e fb          	endbr32 
801052b4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801052b5:	31 c0                	xor    %eax,%eax
{
801052b7:	89 e5                	mov    %esp,%ebp
801052b9:	56                   	push   %esi
801052ba:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801052bb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801052be:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801052c1:	e8 9a ff ff ff       	call   80105260 <argfd.constprop.0>
801052c6:	85 c0                	test   %eax,%eax
801052c8:	78 1e                	js     801052e8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801052ca:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801052cd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801052cf:	e8 5c e6 ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801052d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801052d8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052dc:	85 d2                	test   %edx,%edx
801052de:	74 20                	je     80105300 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801052e0:	83 c3 01             	add    $0x1,%ebx
801052e3:	83 fb 10             	cmp    $0x10,%ebx
801052e6:	75 f0                	jne    801052d8 <sys_dup+0x28>
}
801052e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801052eb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801052f0:	89 d8                	mov    %ebx,%eax
801052f2:	5b                   	pop    %ebx
801052f3:	5e                   	pop    %esi
801052f4:	5d                   	pop    %ebp
801052f5:	c3                   	ret    
801052f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052fd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105300:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105304:	83 ec 0c             	sub    $0xc,%esp
80105307:	ff 75 f4             	pushl  -0xc(%ebp)
8010530a:	e8 91 bb ff ff       	call   80100ea0 <filedup>
  return fd;
8010530f:	83 c4 10             	add    $0x10,%esp
}
80105312:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105315:	89 d8                	mov    %ebx,%eax
80105317:	5b                   	pop    %ebx
80105318:	5e                   	pop    %esi
80105319:	5d                   	pop    %ebp
8010531a:	c3                   	ret    
8010531b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010531f:	90                   	nop

80105320 <sys_read>:
{
80105320:	f3 0f 1e fb          	endbr32 
80105324:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105325:	31 c0                	xor    %eax,%eax
{
80105327:	89 e5                	mov    %esp,%ebp
80105329:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010532c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010532f:	e8 2c ff ff ff       	call   80105260 <argfd.constprop.0>
80105334:	85 c0                	test   %eax,%eax
80105336:	78 48                	js     80105380 <sys_read+0x60>
80105338:	83 ec 08             	sub    $0x8,%esp
8010533b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010533e:	50                   	push   %eax
8010533f:	6a 02                	push   $0x2
80105341:	e8 1a fc ff ff       	call   80104f60 <argint>
80105346:	83 c4 10             	add    $0x10,%esp
80105349:	85 c0                	test   %eax,%eax
8010534b:	78 33                	js     80105380 <sys_read+0x60>
8010534d:	83 ec 04             	sub    $0x4,%esp
80105350:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105353:	ff 75 f0             	pushl  -0x10(%ebp)
80105356:	50                   	push   %eax
80105357:	6a 01                	push   $0x1
80105359:	e8 52 fc ff ff       	call   80104fb0 <argptr>
8010535e:	83 c4 10             	add    $0x10,%esp
80105361:	85 c0                	test   %eax,%eax
80105363:	78 1b                	js     80105380 <sys_read+0x60>
  return fileread(f, p, n);
80105365:	83 ec 04             	sub    $0x4,%esp
80105368:	ff 75 f0             	pushl  -0x10(%ebp)
8010536b:	ff 75 f4             	pushl  -0xc(%ebp)
8010536e:	ff 75 ec             	pushl  -0x14(%ebp)
80105371:	e8 aa bc ff ff       	call   80101020 <fileread>
80105376:	83 c4 10             	add    $0x10,%esp
}
80105379:	c9                   	leave  
8010537a:	c3                   	ret    
8010537b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010537f:	90                   	nop
80105380:	c9                   	leave  
    return -1;
80105381:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105386:	c3                   	ret    
80105387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538e:	66 90                	xchg   %ax,%ax

80105390 <sys_write>:
{
80105390:	f3 0f 1e fb          	endbr32 
80105394:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105395:	31 c0                	xor    %eax,%eax
{
80105397:	89 e5                	mov    %esp,%ebp
80105399:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010539c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010539f:	e8 bc fe ff ff       	call   80105260 <argfd.constprop.0>
801053a4:	85 c0                	test   %eax,%eax
801053a6:	78 48                	js     801053f0 <sys_write+0x60>
801053a8:	83 ec 08             	sub    $0x8,%esp
801053ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053ae:	50                   	push   %eax
801053af:	6a 02                	push   $0x2
801053b1:	e8 aa fb ff ff       	call   80104f60 <argint>
801053b6:	83 c4 10             	add    $0x10,%esp
801053b9:	85 c0                	test   %eax,%eax
801053bb:	78 33                	js     801053f0 <sys_write+0x60>
801053bd:	83 ec 04             	sub    $0x4,%esp
801053c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053c3:	ff 75 f0             	pushl  -0x10(%ebp)
801053c6:	50                   	push   %eax
801053c7:	6a 01                	push   $0x1
801053c9:	e8 e2 fb ff ff       	call   80104fb0 <argptr>
801053ce:	83 c4 10             	add    $0x10,%esp
801053d1:	85 c0                	test   %eax,%eax
801053d3:	78 1b                	js     801053f0 <sys_write+0x60>
  return filewrite(f, p, n);
801053d5:	83 ec 04             	sub    $0x4,%esp
801053d8:	ff 75 f0             	pushl  -0x10(%ebp)
801053db:	ff 75 f4             	pushl  -0xc(%ebp)
801053de:	ff 75 ec             	pushl  -0x14(%ebp)
801053e1:	e8 da bc ff ff       	call   801010c0 <filewrite>
801053e6:	83 c4 10             	add    $0x10,%esp
}
801053e9:	c9                   	leave  
801053ea:	c3                   	ret    
801053eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ef:	90                   	nop
801053f0:	c9                   	leave  
    return -1;
801053f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053f6:	c3                   	ret    
801053f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053fe:	66 90                	xchg   %ax,%ax

80105400 <sys_close>:
{
80105400:	f3 0f 1e fb          	endbr32 
80105404:	55                   	push   %ebp
80105405:	89 e5                	mov    %esp,%ebp
80105407:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010540a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010540d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105410:	e8 4b fe ff ff       	call   80105260 <argfd.constprop.0>
80105415:	85 c0                	test   %eax,%eax
80105417:	78 27                	js     80105440 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105419:	e8 12 e5 ff ff       	call   80103930 <myproc>
8010541e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105421:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105424:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010542b:	00 
  fileclose(f);
8010542c:	ff 75 f4             	pushl  -0xc(%ebp)
8010542f:	e8 bc ba ff ff       	call   80100ef0 <fileclose>
  return 0;
80105434:	83 c4 10             	add    $0x10,%esp
80105437:	31 c0                	xor    %eax,%eax
}
80105439:	c9                   	leave  
8010543a:	c3                   	ret    
8010543b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010543f:	90                   	nop
80105440:	c9                   	leave  
    return -1;
80105441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105446:	c3                   	ret    
80105447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010544e:	66 90                	xchg   %ax,%ax

80105450 <sys_fstat>:
{
80105450:	f3 0f 1e fb          	endbr32 
80105454:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105455:	31 c0                	xor    %eax,%eax
{
80105457:	89 e5                	mov    %esp,%ebp
80105459:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010545c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010545f:	e8 fc fd ff ff       	call   80105260 <argfd.constprop.0>
80105464:	85 c0                	test   %eax,%eax
80105466:	78 30                	js     80105498 <sys_fstat+0x48>
80105468:	83 ec 04             	sub    $0x4,%esp
8010546b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010546e:	6a 14                	push   $0x14
80105470:	50                   	push   %eax
80105471:	6a 01                	push   $0x1
80105473:	e8 38 fb ff ff       	call   80104fb0 <argptr>
80105478:	83 c4 10             	add    $0x10,%esp
8010547b:	85 c0                	test   %eax,%eax
8010547d:	78 19                	js     80105498 <sys_fstat+0x48>
  return filestat(f, st);
8010547f:	83 ec 08             	sub    $0x8,%esp
80105482:	ff 75 f4             	pushl  -0xc(%ebp)
80105485:	ff 75 f0             	pushl  -0x10(%ebp)
80105488:	e8 43 bb ff ff       	call   80100fd0 <filestat>
8010548d:	83 c4 10             	add    $0x10,%esp
}
80105490:	c9                   	leave  
80105491:	c3                   	ret    
80105492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105498:	c9                   	leave  
    return -1;
80105499:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010549e:	c3                   	ret    
8010549f:	90                   	nop

801054a0 <sys_link>:
{
801054a0:	f3 0f 1e fb          	endbr32 
801054a4:	55                   	push   %ebp
801054a5:	89 e5                	mov    %esp,%ebp
801054a7:	57                   	push   %edi
801054a8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801054a9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801054ac:	53                   	push   %ebx
801054ad:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801054b0:	50                   	push   %eax
801054b1:	6a 00                	push   $0x0
801054b3:	e8 58 fb ff ff       	call   80105010 <argstr>
801054b8:	83 c4 10             	add    $0x10,%esp
801054bb:	85 c0                	test   %eax,%eax
801054bd:	0f 88 ff 00 00 00    	js     801055c2 <sys_link+0x122>
801054c3:	83 ec 08             	sub    $0x8,%esp
801054c6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801054c9:	50                   	push   %eax
801054ca:	6a 01                	push   $0x1
801054cc:	e8 3f fb ff ff       	call   80105010 <argstr>
801054d1:	83 c4 10             	add    $0x10,%esp
801054d4:	85 c0                	test   %eax,%eax
801054d6:	0f 88 e6 00 00 00    	js     801055c2 <sys_link+0x122>
  begin_op();
801054dc:	e8 7f d8 ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
801054e1:	83 ec 0c             	sub    $0xc,%esp
801054e4:	ff 75 d4             	pushl  -0x2c(%ebp)
801054e7:	e8 74 cb ff ff       	call   80102060 <namei>
801054ec:	83 c4 10             	add    $0x10,%esp
801054ef:	89 c3                	mov    %eax,%ebx
801054f1:	85 c0                	test   %eax,%eax
801054f3:	0f 84 e8 00 00 00    	je     801055e1 <sys_link+0x141>
  ilock(ip);
801054f9:	83 ec 0c             	sub    $0xc,%esp
801054fc:	50                   	push   %eax
801054fd:	e8 8e c2 ff ff       	call   80101790 <ilock>
  if(ip->type == T_DIR){
80105502:	83 c4 10             	add    $0x10,%esp
80105505:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010550a:	0f 84 b9 00 00 00    	je     801055c9 <sys_link+0x129>
  iupdate(ip);
80105510:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105513:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105518:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010551b:	53                   	push   %ebx
8010551c:	e8 af c1 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
80105521:	89 1c 24             	mov    %ebx,(%esp)
80105524:	e8 47 c3 ff ff       	call   80101870 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105529:	58                   	pop    %eax
8010552a:	5a                   	pop    %edx
8010552b:	57                   	push   %edi
8010552c:	ff 75 d0             	pushl  -0x30(%ebp)
8010552f:	e8 4c cb ff ff       	call   80102080 <nameiparent>
80105534:	83 c4 10             	add    $0x10,%esp
80105537:	89 c6                	mov    %eax,%esi
80105539:	85 c0                	test   %eax,%eax
8010553b:	74 5f                	je     8010559c <sys_link+0xfc>
  ilock(dp);
8010553d:	83 ec 0c             	sub    $0xc,%esp
80105540:	50                   	push   %eax
80105541:	e8 4a c2 ff ff       	call   80101790 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105546:	8b 03                	mov    (%ebx),%eax
80105548:	83 c4 10             	add    $0x10,%esp
8010554b:	39 06                	cmp    %eax,(%esi)
8010554d:	75 41                	jne    80105590 <sys_link+0xf0>
8010554f:	83 ec 04             	sub    $0x4,%esp
80105552:	ff 73 04             	pushl  0x4(%ebx)
80105555:	57                   	push   %edi
80105556:	56                   	push   %esi
80105557:	e8 44 ca ff ff       	call   80101fa0 <dirlink>
8010555c:	83 c4 10             	add    $0x10,%esp
8010555f:	85 c0                	test   %eax,%eax
80105561:	78 2d                	js     80105590 <sys_link+0xf0>
  iunlockput(dp);
80105563:	83 ec 0c             	sub    $0xc,%esp
80105566:	56                   	push   %esi
80105567:	e8 c4 c4 ff ff       	call   80101a30 <iunlockput>
  iput(ip);
8010556c:	89 1c 24             	mov    %ebx,(%esp)
8010556f:	e8 4c c3 ff ff       	call   801018c0 <iput>
  end_op();
80105574:	e8 57 d8 ff ff       	call   80102dd0 <end_op>
  return 0;
80105579:	83 c4 10             	add    $0x10,%esp
8010557c:	31 c0                	xor    %eax,%eax
}
8010557e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105581:	5b                   	pop    %ebx
80105582:	5e                   	pop    %esi
80105583:	5f                   	pop    %edi
80105584:	5d                   	pop    %ebp
80105585:	c3                   	ret    
80105586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010558d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105590:	83 ec 0c             	sub    $0xc,%esp
80105593:	56                   	push   %esi
80105594:	e8 97 c4 ff ff       	call   80101a30 <iunlockput>
    goto bad;
80105599:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010559c:	83 ec 0c             	sub    $0xc,%esp
8010559f:	53                   	push   %ebx
801055a0:	e8 eb c1 ff ff       	call   80101790 <ilock>
  ip->nlink--;
801055a5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055aa:	89 1c 24             	mov    %ebx,(%esp)
801055ad:	e8 1e c1 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801055b2:	89 1c 24             	mov    %ebx,(%esp)
801055b5:	e8 76 c4 ff ff       	call   80101a30 <iunlockput>
  end_op();
801055ba:	e8 11 d8 ff ff       	call   80102dd0 <end_op>
  return -1;
801055bf:	83 c4 10             	add    $0x10,%esp
801055c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055c7:	eb b5                	jmp    8010557e <sys_link+0xde>
    iunlockput(ip);
801055c9:	83 ec 0c             	sub    $0xc,%esp
801055cc:	53                   	push   %ebx
801055cd:	e8 5e c4 ff ff       	call   80101a30 <iunlockput>
    end_op();
801055d2:	e8 f9 d7 ff ff       	call   80102dd0 <end_op>
    return -1;
801055d7:	83 c4 10             	add    $0x10,%esp
801055da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055df:	eb 9d                	jmp    8010557e <sys_link+0xde>
    end_op();
801055e1:	e8 ea d7 ff ff       	call   80102dd0 <end_op>
    return -1;
801055e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055eb:	eb 91                	jmp    8010557e <sys_link+0xde>
801055ed:	8d 76 00             	lea    0x0(%esi),%esi

801055f0 <sys_unlink>:
{
801055f0:	f3 0f 1e fb          	endbr32 
801055f4:	55                   	push   %ebp
801055f5:	89 e5                	mov    %esp,%ebp
801055f7:	57                   	push   %edi
801055f8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801055f9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801055fc:	53                   	push   %ebx
801055fd:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105600:	50                   	push   %eax
80105601:	6a 00                	push   $0x0
80105603:	e8 08 fa ff ff       	call   80105010 <argstr>
80105608:	83 c4 10             	add    $0x10,%esp
8010560b:	85 c0                	test   %eax,%eax
8010560d:	0f 88 7d 01 00 00    	js     80105790 <sys_unlink+0x1a0>
  begin_op();
80105613:	e8 48 d7 ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105618:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010561b:	83 ec 08             	sub    $0x8,%esp
8010561e:	53                   	push   %ebx
8010561f:	ff 75 c0             	pushl  -0x40(%ebp)
80105622:	e8 59 ca ff ff       	call   80102080 <nameiparent>
80105627:	83 c4 10             	add    $0x10,%esp
8010562a:	89 c6                	mov    %eax,%esi
8010562c:	85 c0                	test   %eax,%eax
8010562e:	0f 84 66 01 00 00    	je     8010579a <sys_unlink+0x1aa>
  ilock(dp);
80105634:	83 ec 0c             	sub    $0xc,%esp
80105637:	50                   	push   %eax
80105638:	e8 53 c1 ff ff       	call   80101790 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010563d:	58                   	pop    %eax
8010563e:	5a                   	pop    %edx
8010563f:	68 60 80 10 80       	push   $0x80108060
80105644:	53                   	push   %ebx
80105645:	e8 76 c6 ff ff       	call   80101cc0 <namecmp>
8010564a:	83 c4 10             	add    $0x10,%esp
8010564d:	85 c0                	test   %eax,%eax
8010564f:	0f 84 03 01 00 00    	je     80105758 <sys_unlink+0x168>
80105655:	83 ec 08             	sub    $0x8,%esp
80105658:	68 5f 80 10 80       	push   $0x8010805f
8010565d:	53                   	push   %ebx
8010565e:	e8 5d c6 ff ff       	call   80101cc0 <namecmp>
80105663:	83 c4 10             	add    $0x10,%esp
80105666:	85 c0                	test   %eax,%eax
80105668:	0f 84 ea 00 00 00    	je     80105758 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010566e:	83 ec 04             	sub    $0x4,%esp
80105671:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105674:	50                   	push   %eax
80105675:	53                   	push   %ebx
80105676:	56                   	push   %esi
80105677:	e8 64 c6 ff ff       	call   80101ce0 <dirlookup>
8010567c:	83 c4 10             	add    $0x10,%esp
8010567f:	89 c3                	mov    %eax,%ebx
80105681:	85 c0                	test   %eax,%eax
80105683:	0f 84 cf 00 00 00    	je     80105758 <sys_unlink+0x168>
  ilock(ip);
80105689:	83 ec 0c             	sub    $0xc,%esp
8010568c:	50                   	push   %eax
8010568d:	e8 fe c0 ff ff       	call   80101790 <ilock>
  if(ip->nlink < 1)
80105692:	83 c4 10             	add    $0x10,%esp
80105695:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010569a:	0f 8e 23 01 00 00    	jle    801057c3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801056a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056a5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801056a8:	74 66                	je     80105710 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801056aa:	83 ec 04             	sub    $0x4,%esp
801056ad:	6a 10                	push   $0x10
801056af:	6a 00                	push   $0x0
801056b1:	57                   	push   %edi
801056b2:	e8 c9 f5 ff ff       	call   80104c80 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801056b7:	6a 10                	push   $0x10
801056b9:	ff 75 c4             	pushl  -0x3c(%ebp)
801056bc:	57                   	push   %edi
801056bd:	56                   	push   %esi
801056be:	e8 cd c4 ff ff       	call   80101b90 <writei>
801056c3:	83 c4 20             	add    $0x20,%esp
801056c6:	83 f8 10             	cmp    $0x10,%eax
801056c9:	0f 85 e7 00 00 00    	jne    801057b6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801056cf:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056d4:	0f 84 96 00 00 00    	je     80105770 <sys_unlink+0x180>
  iunlockput(dp);
801056da:	83 ec 0c             	sub    $0xc,%esp
801056dd:	56                   	push   %esi
801056de:	e8 4d c3 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
801056e3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801056e8:	89 1c 24             	mov    %ebx,(%esp)
801056eb:	e8 e0 bf ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801056f0:	89 1c 24             	mov    %ebx,(%esp)
801056f3:	e8 38 c3 ff ff       	call   80101a30 <iunlockput>
  end_op();
801056f8:	e8 d3 d6 ff ff       	call   80102dd0 <end_op>
  return 0;
801056fd:	83 c4 10             	add    $0x10,%esp
80105700:	31 c0                	xor    %eax,%eax
}
80105702:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105705:	5b                   	pop    %ebx
80105706:	5e                   	pop    %esi
80105707:	5f                   	pop    %edi
80105708:	5d                   	pop    %ebp
80105709:	c3                   	ret    
8010570a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105710:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105714:	76 94                	jbe    801056aa <sys_unlink+0xba>
80105716:	ba 20 00 00 00       	mov    $0x20,%edx
8010571b:	eb 0b                	jmp    80105728 <sys_unlink+0x138>
8010571d:	8d 76 00             	lea    0x0(%esi),%esi
80105720:	83 c2 10             	add    $0x10,%edx
80105723:	39 53 58             	cmp    %edx,0x58(%ebx)
80105726:	76 82                	jbe    801056aa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105728:	6a 10                	push   $0x10
8010572a:	52                   	push   %edx
8010572b:	57                   	push   %edi
8010572c:	53                   	push   %ebx
8010572d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105730:	e8 5b c3 ff ff       	call   80101a90 <readi>
80105735:	83 c4 10             	add    $0x10,%esp
80105738:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010573b:	83 f8 10             	cmp    $0x10,%eax
8010573e:	75 69                	jne    801057a9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105740:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105745:	74 d9                	je     80105720 <sys_unlink+0x130>
    iunlockput(ip);
80105747:	83 ec 0c             	sub    $0xc,%esp
8010574a:	53                   	push   %ebx
8010574b:	e8 e0 c2 ff ff       	call   80101a30 <iunlockput>
    goto bad;
80105750:	83 c4 10             	add    $0x10,%esp
80105753:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105757:	90                   	nop
  iunlockput(dp);
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	56                   	push   %esi
8010575c:	e8 cf c2 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105761:	e8 6a d6 ff ff       	call   80102dd0 <end_op>
  return -1;
80105766:	83 c4 10             	add    $0x10,%esp
80105769:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010576e:	eb 92                	jmp    80105702 <sys_unlink+0x112>
    iupdate(dp);
80105770:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105773:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105778:	56                   	push   %esi
80105779:	e8 52 bf ff ff       	call   801016d0 <iupdate>
8010577e:	83 c4 10             	add    $0x10,%esp
80105781:	e9 54 ff ff ff       	jmp    801056da <sys_unlink+0xea>
80105786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105790:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105795:	e9 68 ff ff ff       	jmp    80105702 <sys_unlink+0x112>
    end_op();
8010579a:	e8 31 d6 ff ff       	call   80102dd0 <end_op>
    return -1;
8010579f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a4:	e9 59 ff ff ff       	jmp    80105702 <sys_unlink+0x112>
      panic("isdirempty: readi");
801057a9:	83 ec 0c             	sub    $0xc,%esp
801057ac:	68 84 80 10 80       	push   $0x80108084
801057b1:	e8 da ab ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801057b6:	83 ec 0c             	sub    $0xc,%esp
801057b9:	68 96 80 10 80       	push   $0x80108096
801057be:	e8 cd ab ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801057c3:	83 ec 0c             	sub    $0xc,%esp
801057c6:	68 72 80 10 80       	push   $0x80108072
801057cb:	e8 c0 ab ff ff       	call   80100390 <panic>

801057d0 <sys_open>:

int
sys_open(void)
{
801057d0:	f3 0f 1e fb          	endbr32 
801057d4:	55                   	push   %ebp
801057d5:	89 e5                	mov    %esp,%ebp
801057d7:	57                   	push   %edi
801057d8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801057d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801057dc:	53                   	push   %ebx
801057dd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801057e0:	50                   	push   %eax
801057e1:	6a 00                	push   $0x0
801057e3:	e8 28 f8 ff ff       	call   80105010 <argstr>
801057e8:	83 c4 10             	add    $0x10,%esp
801057eb:	85 c0                	test   %eax,%eax
801057ed:	0f 88 8a 00 00 00    	js     8010587d <sys_open+0xad>
801057f3:	83 ec 08             	sub    $0x8,%esp
801057f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057f9:	50                   	push   %eax
801057fa:	6a 01                	push   $0x1
801057fc:	e8 5f f7 ff ff       	call   80104f60 <argint>
80105801:	83 c4 10             	add    $0x10,%esp
80105804:	85 c0                	test   %eax,%eax
80105806:	78 75                	js     8010587d <sys_open+0xad>
    return -1;

  begin_op();
80105808:	e8 53 d5 ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
8010580d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105811:	75 75                	jne    80105888 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105813:	83 ec 0c             	sub    $0xc,%esp
80105816:	ff 75 e0             	pushl  -0x20(%ebp)
80105819:	e8 42 c8 ff ff       	call   80102060 <namei>
8010581e:	83 c4 10             	add    $0x10,%esp
80105821:	89 c6                	mov    %eax,%esi
80105823:	85 c0                	test   %eax,%eax
80105825:	74 7e                	je     801058a5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105827:	83 ec 0c             	sub    $0xc,%esp
8010582a:	50                   	push   %eax
8010582b:	e8 60 bf ff ff       	call   80101790 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105830:	83 c4 10             	add    $0x10,%esp
80105833:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105838:	0f 84 c2 00 00 00    	je     80105900 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010583e:	e8 ed b5 ff ff       	call   80100e30 <filealloc>
80105843:	89 c7                	mov    %eax,%edi
80105845:	85 c0                	test   %eax,%eax
80105847:	74 23                	je     8010586c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105849:	e8 e2 e0 ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010584e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105850:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105854:	85 d2                	test   %edx,%edx
80105856:	74 60                	je     801058b8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105858:	83 c3 01             	add    $0x1,%ebx
8010585b:	83 fb 10             	cmp    $0x10,%ebx
8010585e:	75 f0                	jne    80105850 <sys_open+0x80>
    if(f)
      fileclose(f);
80105860:	83 ec 0c             	sub    $0xc,%esp
80105863:	57                   	push   %edi
80105864:	e8 87 b6 ff ff       	call   80100ef0 <fileclose>
80105869:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010586c:	83 ec 0c             	sub    $0xc,%esp
8010586f:	56                   	push   %esi
80105870:	e8 bb c1 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105875:	e8 56 d5 ff ff       	call   80102dd0 <end_op>
    return -1;
8010587a:	83 c4 10             	add    $0x10,%esp
8010587d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105882:	eb 6d                	jmp    801058f1 <sys_open+0x121>
80105884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105888:	83 ec 0c             	sub    $0xc,%esp
8010588b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010588e:	31 c9                	xor    %ecx,%ecx
80105890:	ba 02 00 00 00       	mov    $0x2,%edx
80105895:	6a 00                	push   $0x0
80105897:	e8 24 f8 ff ff       	call   801050c0 <create>
    if(ip == 0){
8010589c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010589f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801058a1:	85 c0                	test   %eax,%eax
801058a3:	75 99                	jne    8010583e <sys_open+0x6e>
      end_op();
801058a5:	e8 26 d5 ff ff       	call   80102dd0 <end_op>
      return -1;
801058aa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058af:	eb 40                	jmp    801058f1 <sys_open+0x121>
801058b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801058b8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801058bb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801058bf:	56                   	push   %esi
801058c0:	e8 ab bf ff ff       	call   80101870 <iunlock>
  end_op();
801058c5:	e8 06 d5 ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
801058ca:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801058d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058d3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801058d6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801058d9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801058db:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801058e2:	f7 d0                	not    %eax
801058e4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058e7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801058ea:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058ed:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801058f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058f4:	89 d8                	mov    %ebx,%eax
801058f6:	5b                   	pop    %ebx
801058f7:	5e                   	pop    %esi
801058f8:	5f                   	pop    %edi
801058f9:	5d                   	pop    %ebp
801058fa:	c3                   	ret    
801058fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058ff:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105900:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105903:	85 c9                	test   %ecx,%ecx
80105905:	0f 84 33 ff ff ff    	je     8010583e <sys_open+0x6e>
8010590b:	e9 5c ff ff ff       	jmp    8010586c <sys_open+0x9c>

80105910 <sys_mkdir>:

int
sys_mkdir(void)
{
80105910:	f3 0f 1e fb          	endbr32 
80105914:	55                   	push   %ebp
80105915:	89 e5                	mov    %esp,%ebp
80105917:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010591a:	e8 41 d4 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010591f:	83 ec 08             	sub    $0x8,%esp
80105922:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105925:	50                   	push   %eax
80105926:	6a 00                	push   $0x0
80105928:	e8 e3 f6 ff ff       	call   80105010 <argstr>
8010592d:	83 c4 10             	add    $0x10,%esp
80105930:	85 c0                	test   %eax,%eax
80105932:	78 34                	js     80105968 <sys_mkdir+0x58>
80105934:	83 ec 0c             	sub    $0xc,%esp
80105937:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010593a:	31 c9                	xor    %ecx,%ecx
8010593c:	ba 01 00 00 00       	mov    $0x1,%edx
80105941:	6a 00                	push   $0x0
80105943:	e8 78 f7 ff ff       	call   801050c0 <create>
80105948:	83 c4 10             	add    $0x10,%esp
8010594b:	85 c0                	test   %eax,%eax
8010594d:	74 19                	je     80105968 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010594f:	83 ec 0c             	sub    $0xc,%esp
80105952:	50                   	push   %eax
80105953:	e8 d8 c0 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105958:	e8 73 d4 ff ff       	call   80102dd0 <end_op>
  return 0;
8010595d:	83 c4 10             	add    $0x10,%esp
80105960:	31 c0                	xor    %eax,%eax
}
80105962:	c9                   	leave  
80105963:	c3                   	ret    
80105964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105968:	e8 63 d4 ff ff       	call   80102dd0 <end_op>
    return -1;
8010596d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105972:	c9                   	leave  
80105973:	c3                   	ret    
80105974:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010597f:	90                   	nop

80105980 <sys_mknod>:

int
sys_mknod(void)
{
80105980:	f3 0f 1e fb          	endbr32 
80105984:	55                   	push   %ebp
80105985:	89 e5                	mov    %esp,%ebp
80105987:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010598a:	e8 d1 d3 ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010598f:	83 ec 08             	sub    $0x8,%esp
80105992:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105995:	50                   	push   %eax
80105996:	6a 00                	push   $0x0
80105998:	e8 73 f6 ff ff       	call   80105010 <argstr>
8010599d:	83 c4 10             	add    $0x10,%esp
801059a0:	85 c0                	test   %eax,%eax
801059a2:	78 64                	js     80105a08 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801059a4:	83 ec 08             	sub    $0x8,%esp
801059a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059aa:	50                   	push   %eax
801059ab:	6a 01                	push   $0x1
801059ad:	e8 ae f5 ff ff       	call   80104f60 <argint>
  if((argstr(0, &path)) < 0 ||
801059b2:	83 c4 10             	add    $0x10,%esp
801059b5:	85 c0                	test   %eax,%eax
801059b7:	78 4f                	js     80105a08 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801059b9:	83 ec 08             	sub    $0x8,%esp
801059bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059bf:	50                   	push   %eax
801059c0:	6a 02                	push   $0x2
801059c2:	e8 99 f5 ff ff       	call   80104f60 <argint>
     argint(1, &major) < 0 ||
801059c7:	83 c4 10             	add    $0x10,%esp
801059ca:	85 c0                	test   %eax,%eax
801059cc:	78 3a                	js     80105a08 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
801059ce:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801059d2:	83 ec 0c             	sub    $0xc,%esp
801059d5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801059d9:	ba 03 00 00 00       	mov    $0x3,%edx
801059de:	50                   	push   %eax
801059df:	8b 45 ec             	mov    -0x14(%ebp),%eax
801059e2:	e8 d9 f6 ff ff       	call   801050c0 <create>
     argint(2, &minor) < 0 ||
801059e7:	83 c4 10             	add    $0x10,%esp
801059ea:	85 c0                	test   %eax,%eax
801059ec:	74 1a                	je     80105a08 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059ee:	83 ec 0c             	sub    $0xc,%esp
801059f1:	50                   	push   %eax
801059f2:	e8 39 c0 ff ff       	call   80101a30 <iunlockput>
  end_op();
801059f7:	e8 d4 d3 ff ff       	call   80102dd0 <end_op>
  return 0;
801059fc:	83 c4 10             	add    $0x10,%esp
801059ff:	31 c0                	xor    %eax,%eax
}
80105a01:	c9                   	leave  
80105a02:	c3                   	ret    
80105a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a07:	90                   	nop
    end_op();
80105a08:	e8 c3 d3 ff ff       	call   80102dd0 <end_op>
    return -1;
80105a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a12:	c9                   	leave  
80105a13:	c3                   	ret    
80105a14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a1f:	90                   	nop

80105a20 <sys_chdir>:

int
sys_chdir(void)
{
80105a20:	f3 0f 1e fb          	endbr32 
80105a24:	55                   	push   %ebp
80105a25:	89 e5                	mov    %esp,%ebp
80105a27:	56                   	push   %esi
80105a28:	53                   	push   %ebx
80105a29:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105a2c:	e8 ff de ff ff       	call   80103930 <myproc>
80105a31:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105a33:	e8 28 d3 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105a38:	83 ec 08             	sub    $0x8,%esp
80105a3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a3e:	50                   	push   %eax
80105a3f:	6a 00                	push   $0x0
80105a41:	e8 ca f5 ff ff       	call   80105010 <argstr>
80105a46:	83 c4 10             	add    $0x10,%esp
80105a49:	85 c0                	test   %eax,%eax
80105a4b:	78 73                	js     80105ac0 <sys_chdir+0xa0>
80105a4d:	83 ec 0c             	sub    $0xc,%esp
80105a50:	ff 75 f4             	pushl  -0xc(%ebp)
80105a53:	e8 08 c6 ff ff       	call   80102060 <namei>
80105a58:	83 c4 10             	add    $0x10,%esp
80105a5b:	89 c3                	mov    %eax,%ebx
80105a5d:	85 c0                	test   %eax,%eax
80105a5f:	74 5f                	je     80105ac0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105a61:	83 ec 0c             	sub    $0xc,%esp
80105a64:	50                   	push   %eax
80105a65:	e8 26 bd ff ff       	call   80101790 <ilock>
  if(ip->type != T_DIR){
80105a6a:	83 c4 10             	add    $0x10,%esp
80105a6d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a72:	75 2c                	jne    80105aa0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105a74:	83 ec 0c             	sub    $0xc,%esp
80105a77:	53                   	push   %ebx
80105a78:	e8 f3 bd ff ff       	call   80101870 <iunlock>
  iput(curproc->cwd);
80105a7d:	58                   	pop    %eax
80105a7e:	ff 76 68             	pushl  0x68(%esi)
80105a81:	e8 3a be ff ff       	call   801018c0 <iput>
  end_op();
80105a86:	e8 45 d3 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80105a8b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105a8e:	83 c4 10             	add    $0x10,%esp
80105a91:	31 c0                	xor    %eax,%eax
}
80105a93:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a96:	5b                   	pop    %ebx
80105a97:	5e                   	pop    %esi
80105a98:	5d                   	pop    %ebp
80105a99:	c3                   	ret    
80105a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105aa0:	83 ec 0c             	sub    $0xc,%esp
80105aa3:	53                   	push   %ebx
80105aa4:	e8 87 bf ff ff       	call   80101a30 <iunlockput>
    end_op();
80105aa9:	e8 22 d3 ff ff       	call   80102dd0 <end_op>
    return -1;
80105aae:	83 c4 10             	add    $0x10,%esp
80105ab1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ab6:	eb db                	jmp    80105a93 <sys_chdir+0x73>
80105ab8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105abf:	90                   	nop
    end_op();
80105ac0:	e8 0b d3 ff ff       	call   80102dd0 <end_op>
    return -1;
80105ac5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aca:	eb c7                	jmp    80105a93 <sys_chdir+0x73>
80105acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ad0 <sys_exec>:

int
sys_exec(void)
{
80105ad0:	f3 0f 1e fb          	endbr32 
80105ad4:	55                   	push   %ebp
80105ad5:	89 e5                	mov    %esp,%ebp
80105ad7:	57                   	push   %edi
80105ad8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ad9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105adf:	53                   	push   %ebx
80105ae0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ae6:	50                   	push   %eax
80105ae7:	6a 00                	push   $0x0
80105ae9:	e8 22 f5 ff ff       	call   80105010 <argstr>
80105aee:	83 c4 10             	add    $0x10,%esp
80105af1:	85 c0                	test   %eax,%eax
80105af3:	0f 88 8b 00 00 00    	js     80105b84 <sys_exec+0xb4>
80105af9:	83 ec 08             	sub    $0x8,%esp
80105afc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b02:	50                   	push   %eax
80105b03:	6a 01                	push   $0x1
80105b05:	e8 56 f4 ff ff       	call   80104f60 <argint>
80105b0a:	83 c4 10             	add    $0x10,%esp
80105b0d:	85 c0                	test   %eax,%eax
80105b0f:	78 73                	js     80105b84 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b11:	83 ec 04             	sub    $0x4,%esp
80105b14:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105b1a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105b1c:	68 80 00 00 00       	push   $0x80
80105b21:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105b27:	6a 00                	push   $0x0
80105b29:	50                   	push   %eax
80105b2a:	e8 51 f1 ff ff       	call   80104c80 <memset>
80105b2f:	83 c4 10             	add    $0x10,%esp
80105b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b38:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105b3e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105b45:	83 ec 08             	sub    $0x8,%esp
80105b48:	57                   	push   %edi
80105b49:	01 f0                	add    %esi,%eax
80105b4b:	50                   	push   %eax
80105b4c:	e8 6f f3 ff ff       	call   80104ec0 <fetchint>
80105b51:	83 c4 10             	add    $0x10,%esp
80105b54:	85 c0                	test   %eax,%eax
80105b56:	78 2c                	js     80105b84 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105b58:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105b5e:	85 c0                	test   %eax,%eax
80105b60:	74 36                	je     80105b98 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105b62:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105b68:	83 ec 08             	sub    $0x8,%esp
80105b6b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105b6e:	52                   	push   %edx
80105b6f:	50                   	push   %eax
80105b70:	e8 8b f3 ff ff       	call   80104f00 <fetchstr>
80105b75:	83 c4 10             	add    $0x10,%esp
80105b78:	85 c0                	test   %eax,%eax
80105b7a:	78 08                	js     80105b84 <sys_exec+0xb4>
  for(i=0;; i++){
80105b7c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105b7f:	83 fb 20             	cmp    $0x20,%ebx
80105b82:	75 b4                	jne    80105b38 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105b84:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105b87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b8c:	5b                   	pop    %ebx
80105b8d:	5e                   	pop    %esi
80105b8e:	5f                   	pop    %edi
80105b8f:	5d                   	pop    %ebp
80105b90:	c3                   	ret    
80105b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105b98:	83 ec 08             	sub    $0x8,%esp
80105b9b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105ba1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ba8:	00 00 00 00 
  return exec(path, argv);
80105bac:	50                   	push   %eax
80105bad:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105bb3:	e8 c8 ae ff ff       	call   80100a80 <exec>
80105bb8:	83 c4 10             	add    $0x10,%esp
}
80105bbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bbe:	5b                   	pop    %ebx
80105bbf:	5e                   	pop    %esi
80105bc0:	5f                   	pop    %edi
80105bc1:	5d                   	pop    %ebp
80105bc2:	c3                   	ret    
80105bc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bd0 <sys_pipe>:

int
sys_pipe(void)
{
80105bd0:	f3 0f 1e fb          	endbr32 
80105bd4:	55                   	push   %ebp
80105bd5:	89 e5                	mov    %esp,%ebp
80105bd7:	57                   	push   %edi
80105bd8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105bd9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105bdc:	53                   	push   %ebx
80105bdd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105be0:	6a 08                	push   $0x8
80105be2:	50                   	push   %eax
80105be3:	6a 00                	push   $0x0
80105be5:	e8 c6 f3 ff ff       	call   80104fb0 <argptr>
80105bea:	83 c4 10             	add    $0x10,%esp
80105bed:	85 c0                	test   %eax,%eax
80105bef:	78 4e                	js     80105c3f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105bf1:	83 ec 08             	sub    $0x8,%esp
80105bf4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bf7:	50                   	push   %eax
80105bf8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105bfb:	50                   	push   %eax
80105bfc:	e8 1f d8 ff ff       	call   80103420 <pipealloc>
80105c01:	83 c4 10             	add    $0x10,%esp
80105c04:	85 c0                	test   %eax,%eax
80105c06:	78 37                	js     80105c3f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c08:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105c0b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c0d:	e8 1e dd ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105c18:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105c1c:	85 f6                	test   %esi,%esi
80105c1e:	74 30                	je     80105c50 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105c20:	83 c3 01             	add    $0x1,%ebx
80105c23:	83 fb 10             	cmp    $0x10,%ebx
80105c26:	75 f0                	jne    80105c18 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105c28:	83 ec 0c             	sub    $0xc,%esp
80105c2b:	ff 75 e0             	pushl  -0x20(%ebp)
80105c2e:	e8 bd b2 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
80105c33:	58                   	pop    %eax
80105c34:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c37:	e8 b4 b2 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105c3c:	83 c4 10             	add    $0x10,%esp
80105c3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c44:	eb 5b                	jmp    80105ca1 <sys_pipe+0xd1>
80105c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105c50:	8d 73 08             	lea    0x8(%ebx),%esi
80105c53:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105c5a:	e8 d1 dc ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c5f:	31 d2                	xor    %edx,%edx
80105c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105c68:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105c6c:	85 c9                	test   %ecx,%ecx
80105c6e:	74 20                	je     80105c90 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105c70:	83 c2 01             	add    $0x1,%edx
80105c73:	83 fa 10             	cmp    $0x10,%edx
80105c76:	75 f0                	jne    80105c68 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105c78:	e8 b3 dc ff ff       	call   80103930 <myproc>
80105c7d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105c84:	00 
80105c85:	eb a1                	jmp    80105c28 <sys_pipe+0x58>
80105c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c8e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105c90:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105c94:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c97:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105c99:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c9c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105c9f:	31 c0                	xor    %eax,%eax
}
80105ca1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ca4:	5b                   	pop    %ebx
80105ca5:	5e                   	pop    %esi
80105ca6:	5f                   	pop    %edi
80105ca7:	5d                   	pop    %ebp
80105ca8:	c3                   	ret    
80105ca9:	66 90                	xchg   %ax,%ax
80105cab:	66 90                	xchg   %ax,%ax
80105cad:	66 90                	xchg   %ax,%ax
80105caf:	90                   	nop

80105cb0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105cb0:	f3 0f 1e fb          	endbr32 
  return fork();
80105cb4:	e9 a7 df ff ff       	jmp    80103c60 <fork>
80105cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cc0 <sys_exit>:
}

int
sys_exit(void)
{
80105cc0:	f3 0f 1e fb          	endbr32 
80105cc4:	55                   	push   %ebp
80105cc5:	89 e5                	mov    %esp,%ebp
80105cc7:	83 ec 08             	sub    $0x8,%esp
  exit();
80105cca:	e8 71 e3 ff ff       	call   80104040 <exit>
  return 0;  // not reached
}
80105ccf:	31 c0                	xor    %eax,%eax
80105cd1:	c9                   	leave  
80105cd2:	c3                   	ret    
80105cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ce0 <sys_wait>:

int
sys_wait(void)
{
80105ce0:	f3 0f 1e fb          	endbr32 
  return wait();
80105ce4:	e9 97 e5 ff ff       	jmp    80104280 <wait>
80105ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cf0 <sys_kill>:
}

int
sys_kill(void)
{
80105cf0:	f3 0f 1e fb          	endbr32 
80105cf4:	55                   	push   %ebp
80105cf5:	89 e5                	mov    %esp,%ebp
80105cf7:	83 ec 20             	sub    $0x20,%esp
  int pid, signum;

  if(argint(0, &pid) < 0 || argint(1, &signum) < 0){
80105cfa:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cfd:	50                   	push   %eax
80105cfe:	6a 00                	push   $0x0
80105d00:	e8 5b f2 ff ff       	call   80104f60 <argint>
80105d05:	83 c4 10             	add    $0x10,%esp
80105d08:	85 c0                	test   %eax,%eax
80105d0a:	78 2c                	js     80105d38 <sys_kill+0x48>
80105d0c:	83 ec 08             	sub    $0x8,%esp
80105d0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d12:	50                   	push   %eax
80105d13:	6a 01                	push   $0x1
80105d15:	e8 46 f2 ff ff       	call   80104f60 <argint>
80105d1a:	83 c4 10             	add    $0x10,%esp
80105d1d:	85 c0                	test   %eax,%eax
80105d1f:	78 17                	js     80105d38 <sys_kill+0x48>
    return -1;
  }
  return kill(pid, signum);
80105d21:	83 ec 08             	sub    $0x8,%esp
80105d24:	ff 75 f4             	pushl  -0xc(%ebp)
80105d27:	ff 75 f0             	pushl  -0x10(%ebp)
80105d2a:	e8 b1 e6 ff ff       	call   801043e0 <kill>
80105d2f:	83 c4 10             	add    $0x10,%esp
}
80105d32:	c9                   	leave  
80105d33:	c3                   	ret    
80105d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d38:	c9                   	leave  
    return -1;
80105d39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d3e:	c3                   	ret    
80105d3f:	90                   	nop

80105d40 <sys_getpid>:

int
sys_getpid(void)
{
80105d40:	f3 0f 1e fb          	endbr32 
80105d44:	55                   	push   %ebp
80105d45:	89 e5                	mov    %esp,%ebp
80105d47:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105d4a:	e8 e1 db ff ff       	call   80103930 <myproc>
80105d4f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d52:	c9                   	leave  
80105d53:	c3                   	ret    
80105d54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d5f:	90                   	nop

80105d60 <sys_sbrk>:

int
sys_sbrk(void)
{
80105d60:	f3 0f 1e fb          	endbr32 
80105d64:	55                   	push   %ebp
80105d65:	89 e5                	mov    %esp,%ebp
80105d67:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105d68:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d6b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105d6e:	50                   	push   %eax
80105d6f:	6a 00                	push   $0x0
80105d71:	e8 ea f1 ff ff       	call   80104f60 <argint>
80105d76:	83 c4 10             	add    $0x10,%esp
80105d79:	85 c0                	test   %eax,%eax
80105d7b:	78 23                	js     80105da0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105d7d:	e8 ae db ff ff       	call   80103930 <myproc>
  if(growproc(n) < 0)
80105d82:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105d85:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105d87:	ff 75 f4             	pushl  -0xc(%ebp)
80105d8a:	e8 51 de ff ff       	call   80103be0 <growproc>
80105d8f:	83 c4 10             	add    $0x10,%esp
80105d92:	85 c0                	test   %eax,%eax
80105d94:	78 0a                	js     80105da0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105d96:	89 d8                	mov    %ebx,%eax
80105d98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d9b:	c9                   	leave  
80105d9c:	c3                   	ret    
80105d9d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105da0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105da5:	eb ef                	jmp    80105d96 <sys_sbrk+0x36>
80105da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dae:	66 90                	xchg   %ax,%ax

80105db0 <sys_sleep>:

int
sys_sleep(void)
{
80105db0:	f3 0f 1e fb          	endbr32 
80105db4:	55                   	push   %ebp
80105db5:	89 e5                	mov    %esp,%ebp
80105db7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105db8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105dbb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dbe:	50                   	push   %eax
80105dbf:	6a 00                	push   $0x0
80105dc1:	e8 9a f1 ff ff       	call   80104f60 <argint>
80105dc6:	83 c4 10             	add    $0x10,%esp
80105dc9:	85 c0                	test   %eax,%eax
80105dcb:	0f 88 86 00 00 00    	js     80105e57 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105dd1:	83 ec 0c             	sub    $0xc,%esp
80105dd4:	68 60 a2 11 80       	push   $0x8011a260
80105dd9:	e8 92 ed ff ff       	call   80104b70 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105dde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105de1:	8b 1d a0 aa 11 80    	mov    0x8011aaa0,%ebx
  while(ticks - ticks0 < n){
80105de7:	83 c4 10             	add    $0x10,%esp
80105dea:	85 d2                	test   %edx,%edx
80105dec:	75 23                	jne    80105e11 <sys_sleep+0x61>
80105dee:	eb 50                	jmp    80105e40 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105df0:	83 ec 08             	sub    $0x8,%esp
80105df3:	68 60 a2 11 80       	push   $0x8011a260
80105df8:	68 a0 aa 11 80       	push   $0x8011aaa0
80105dfd:	e8 ce e3 ff ff       	call   801041d0 <sleep>
  while(ticks - ticks0 < n){
80105e02:	a1 a0 aa 11 80       	mov    0x8011aaa0,%eax
80105e07:	83 c4 10             	add    $0x10,%esp
80105e0a:	29 d8                	sub    %ebx,%eax
80105e0c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e0f:	73 2f                	jae    80105e40 <sys_sleep+0x90>
    if(myproc()->killed){
80105e11:	e8 1a db ff ff       	call   80103930 <myproc>
80105e16:	8b 40 24             	mov    0x24(%eax),%eax
80105e19:	85 c0                	test   %eax,%eax
80105e1b:	74 d3                	je     80105df0 <sys_sleep+0x40>
      release(&tickslock);
80105e1d:	83 ec 0c             	sub    $0xc,%esp
80105e20:	68 60 a2 11 80       	push   $0x8011a260
80105e25:	e8 06 ee ff ff       	call   80104c30 <release>
  }
  release(&tickslock);
  return 0;
}
80105e2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105e2d:	83 c4 10             	add    $0x10,%esp
80105e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e35:	c9                   	leave  
80105e36:	c3                   	ret    
80105e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105e40:	83 ec 0c             	sub    $0xc,%esp
80105e43:	68 60 a2 11 80       	push   $0x8011a260
80105e48:	e8 e3 ed ff ff       	call   80104c30 <release>
  return 0;
80105e4d:	83 c4 10             	add    $0x10,%esp
80105e50:	31 c0                	xor    %eax,%eax
}
80105e52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e55:	c9                   	leave  
80105e56:	c3                   	ret    
    return -1;
80105e57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e5c:	eb f4                	jmp    80105e52 <sys_sleep+0xa2>
80105e5e:	66 90                	xchg   %ax,%ax

80105e60 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105e60:	f3 0f 1e fb          	endbr32 
80105e64:	55                   	push   %ebp
80105e65:	89 e5                	mov    %esp,%ebp
80105e67:	53                   	push   %ebx
80105e68:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105e6b:	68 60 a2 11 80       	push   $0x8011a260
80105e70:	e8 fb ec ff ff       	call   80104b70 <acquire>
  xticks = ticks;
80105e75:	8b 1d a0 aa 11 80    	mov    0x8011aaa0,%ebx
  release(&tickslock);
80105e7b:	c7 04 24 60 a2 11 80 	movl   $0x8011a260,(%esp)
80105e82:	e8 a9 ed ff ff       	call   80104c30 <release>
  return xticks;
}
80105e87:	89 d8                	mov    %ebx,%eax
80105e89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e8c:	c9                   	leave  
80105e8d:	c3                   	ret    
80105e8e:	66 90                	xchg   %ax,%ax

80105e90 <sys_sigprocmask>:

int sys_sigprocmask(void){
80105e90:	f3 0f 1e fb          	endbr32 
80105e94:	55                   	push   %ebp
80105e95:	89 e5                	mov    %esp,%ebp
80105e97:	83 ec 20             	sub    $0x20,%esp
  uint sigmask;
  if (argint(0, (int*)&sigmask) < 0){
80105e9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e9d:	50                   	push   %eax
80105e9e:	6a 00                	push   $0x0
80105ea0:	e8 bb f0 ff ff       	call   80104f60 <argint>
80105ea5:	83 c4 10             	add    $0x10,%esp
80105ea8:	85 c0                	test   %eax,%eax
80105eaa:	78 14                	js     80105ec0 <sys_sigprocmask+0x30>
    return -1;
  }
  return sigprocmask(sigmask);
80105eac:	83 ec 0c             	sub    $0xc,%esp
80105eaf:	ff 75 f4             	pushl  -0xc(%ebp)
80105eb2:	e8 b9 e6 ff ff       	call   80104570 <sigprocmask>
80105eb7:	83 c4 10             	add    $0x10,%esp
}
80105eba:	c9                   	leave  
80105ebb:	c3                   	ret    
80105ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ec0:	c9                   	leave  
    return -1;
80105ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ec6:	c3                   	ret    
80105ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ece:	66 90                	xchg   %ax,%ax

80105ed0 <sys_sigaction>:

int sys_sigaction(void){
80105ed0:	f3 0f 1e fb          	endbr32 
80105ed4:	55                   	push   %ebp
80105ed5:	89 e5                	mov    %esp,%ebp
80105ed7:	83 ec 20             	sub    $0x20,%esp
  uint signum;
  struct sigaction* act;
  struct sigaction* oldact;
  if (argint(0, (int*)(&signum)) < 0 || argptr(1, (char**)(&act), 16) < 0 || argptr(2, (char**)(&oldact), 16)){
80105eda:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105edd:	50                   	push   %eax
80105ede:	6a 00                	push   $0x0
80105ee0:	e8 7b f0 ff ff       	call   80104f60 <argint>
80105ee5:	83 c4 10             	add    $0x10,%esp
80105ee8:	85 c0                	test   %eax,%eax
80105eea:	78 44                	js     80105f30 <sys_sigaction+0x60>
80105eec:	83 ec 04             	sub    $0x4,%esp
80105eef:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ef2:	6a 10                	push   $0x10
80105ef4:	50                   	push   %eax
80105ef5:	6a 01                	push   $0x1
80105ef7:	e8 b4 f0 ff ff       	call   80104fb0 <argptr>
80105efc:	83 c4 10             	add    $0x10,%esp
80105eff:	85 c0                	test   %eax,%eax
80105f01:	78 2d                	js     80105f30 <sys_sigaction+0x60>
80105f03:	83 ec 04             	sub    $0x4,%esp
80105f06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f09:	6a 10                	push   $0x10
80105f0b:	50                   	push   %eax
80105f0c:	6a 02                	push   $0x2
80105f0e:	e8 9d f0 ff ff       	call   80104fb0 <argptr>
80105f13:	83 c4 10             	add    $0x10,%esp
80105f16:	85 c0                	test   %eax,%eax
80105f18:	75 16                	jne    80105f30 <sys_sigaction+0x60>
    return -1;
  }

  return sigaction(signum, act, oldact);
80105f1a:	83 ec 04             	sub    $0x4,%esp
80105f1d:	ff 75 f4             	pushl  -0xc(%ebp)
80105f20:	ff 75 f0             	pushl  -0x10(%ebp)
80105f23:	ff 75 ec             	pushl  -0x14(%ebp)
80105f26:	e8 95 e6 ff ff       	call   801045c0 <sigaction>
80105f2b:	83 c4 10             	add    $0x10,%esp
}
80105f2e:	c9                   	leave  
80105f2f:	c3                   	ret    
80105f30:	c9                   	leave  
    return -1;
80105f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f36:	c3                   	ret    
80105f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3e:	66 90                	xchg   %ax,%ax

80105f40 <sys_sigret>:

int sys_sigret(void){
80105f40:	f3 0f 1e fb          	endbr32 
80105f44:	55                   	push   %ebp
80105f45:	89 e5                	mov    %esp,%ebp
80105f47:	83 ec 08             	sub    $0x8,%esp
  sigret();
80105f4a:	e8 f1 e6 ff ff       	call   80104640 <sigret>
  return 0;
}
80105f4f:	31 c0                	xor    %eax,%eax
80105f51:	c9                   	leave  
80105f52:	c3                   	ret    

80105f53 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f53:	1e                   	push   %ds
  pushl %es
80105f54:	06                   	push   %es
  pushl %fs
80105f55:	0f a0                	push   %fs
  pushl %gs
80105f57:	0f a8                	push   %gs
  pushal
80105f59:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105f5a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105f5e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105f60:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105f62:	54                   	push   %esp
  call trap
80105f63:	e8 c8 00 00 00       	call   80106030 <trap>
  addl $4, %esp
80105f68:	83 c4 04             	add    $0x4,%esp

80105f6b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:

  call handle_signals
80105f6b:	e8 c0 e7 ff ff       	call   80104730 <handle_signals>
  
  popal
80105f70:	61                   	popa   
  popl %gs
80105f71:	0f a9                	pop    %gs
  popl %fs
80105f73:	0f a1                	pop    %fs
  popl %es
80105f75:	07                   	pop    %es
  popl %ds
80105f76:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105f77:	83 c4 08             	add    $0x8,%esp
  iret
80105f7a:	cf                   	iret   
80105f7b:	66 90                	xchg   %ax,%ax
80105f7d:	66 90                	xchg   %ax,%ax
80105f7f:	90                   	nop

80105f80 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f80:	f3 0f 1e fb          	endbr32 
80105f84:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105f85:	31 c0                	xor    %eax,%eax
{
80105f87:	89 e5                	mov    %esp,%ebp
80105f89:	83 ec 08             	sub    $0x8,%esp
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105f90:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105f97:	c7 04 c5 a2 a2 11 80 	movl   $0x8e000008,-0x7fee5d5e(,%eax,8)
80105f9e:	08 00 00 8e 
80105fa2:	66 89 14 c5 a0 a2 11 	mov    %dx,-0x7fee5d60(,%eax,8)
80105fa9:	80 
80105faa:	c1 ea 10             	shr    $0x10,%edx
80105fad:	66 89 14 c5 a6 a2 11 	mov    %dx,-0x7fee5d5a(,%eax,8)
80105fb4:	80 
  for(i = 0; i < 256; i++)
80105fb5:	83 c0 01             	add    $0x1,%eax
80105fb8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105fbd:	75 d1                	jne    80105f90 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105fbf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105fc2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105fc7:	c7 05 a2 a4 11 80 08 	movl   $0xef000008,0x8011a4a2
80105fce:	00 00 ef 
  initlock(&tickslock, "time");
80105fd1:	68 a5 80 10 80       	push   $0x801080a5
80105fd6:	68 60 a2 11 80       	push   $0x8011a260
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105fdb:	66 a3 a0 a4 11 80    	mov    %ax,0x8011a4a0
80105fe1:	c1 e8 10             	shr    $0x10,%eax
80105fe4:	66 a3 a6 a4 11 80    	mov    %ax,0x8011a4a6
  initlock(&tickslock, "time");
80105fea:	e8 01 ea ff ff       	call   801049f0 <initlock>
}
80105fef:	83 c4 10             	add    $0x10,%esp
80105ff2:	c9                   	leave  
80105ff3:	c3                   	ret    
80105ff4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fff:	90                   	nop

80106000 <idtinit>:

void
idtinit(void)
{
80106000:	f3 0f 1e fb          	endbr32 
80106004:	55                   	push   %ebp
  pd[0] = size-1;
80106005:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010600a:	89 e5                	mov    %esp,%ebp
8010600c:	83 ec 10             	sub    $0x10,%esp
8010600f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106013:	b8 a0 a2 11 80       	mov    $0x8011a2a0,%eax
80106018:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010601c:	c1 e8 10             	shr    $0x10,%eax
8010601f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106023:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106026:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106029:	c9                   	leave  
8010602a:	c3                   	ret    
8010602b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010602f:	90                   	nop

80106030 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe* tf)
{
80106030:	f3 0f 1e fb          	endbr32 
80106034:	55                   	push   %ebp
80106035:	89 e5                	mov    %esp,%ebp
80106037:	57                   	push   %edi
80106038:	56                   	push   %esi
80106039:	53                   	push   %ebx
8010603a:	83 ec 1c             	sub    $0x1c,%esp
8010603d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106040:	8b 43 30             	mov    0x30(%ebx),%eax
80106043:	83 f8 40             	cmp    $0x40,%eax
80106046:	0f 84 bc 01 00 00    	je     80106208 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010604c:	83 e8 20             	sub    $0x20,%eax
8010604f:	83 f8 1f             	cmp    $0x1f,%eax
80106052:	77 08                	ja     8010605c <trap+0x2c>
80106054:	3e ff 24 85 4c 81 10 	notrack jmp *-0x7fef7eb4(,%eax,4)
8010605b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010605c:	e8 cf d8 ff ff       	call   80103930 <myproc>
80106061:	8b 7b 38             	mov    0x38(%ebx),%edi
80106064:	85 c0                	test   %eax,%eax
80106066:	0f 84 eb 01 00 00    	je     80106257 <trap+0x227>
8010606c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106070:	0f 84 e1 01 00 00    	je     80106257 <trap+0x227>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106076:	0f 20 d1             	mov    %cr2,%ecx
80106079:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010607c:	e8 8f d8 ff ff       	call   80103910 <cpuid>
80106081:	8b 73 30             	mov    0x30(%ebx),%esi
80106084:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106087:	8b 43 34             	mov    0x34(%ebx),%eax
8010608a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010608d:	e8 9e d8 ff ff       	call   80103930 <myproc>
80106092:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106095:	e8 96 d8 ff ff       	call   80103930 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010609a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010609d:	8b 55 dc             	mov    -0x24(%ebp),%edx
801060a0:	51                   	push   %ecx
801060a1:	57                   	push   %edi
801060a2:	52                   	push   %edx
801060a3:	ff 75 e4             	pushl  -0x1c(%ebp)
801060a6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801060a7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801060aa:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801060ad:	56                   	push   %esi
801060ae:	ff 70 10             	pushl  0x10(%eax)
801060b1:	68 08 81 10 80       	push   $0x80108108
801060b6:	e8 f5 a5 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801060bb:	83 c4 20             	add    $0x20,%esp
801060be:	e8 6d d8 ff ff       	call   80103930 <myproc>
801060c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060ca:	e8 61 d8 ff ff       	call   80103930 <myproc>
801060cf:	85 c0                	test   %eax,%eax
801060d1:	74 1d                	je     801060f0 <trap+0xc0>
801060d3:	e8 58 d8 ff ff       	call   80103930 <myproc>
801060d8:	8b 50 24             	mov    0x24(%eax),%edx
801060db:	85 d2                	test   %edx,%edx
801060dd:	74 11                	je     801060f0 <trap+0xc0>
801060df:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801060e3:	83 e0 03             	and    $0x3,%eax
801060e6:	66 83 f8 03          	cmp    $0x3,%ax
801060ea:	0f 84 50 01 00 00    	je     80106240 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801060f0:	e8 3b d8 ff ff       	call   80103930 <myproc>
801060f5:	85 c0                	test   %eax,%eax
801060f7:	74 0f                	je     80106108 <trap+0xd8>
801060f9:	e8 32 d8 ff ff       	call   80103930 <myproc>
801060fe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106102:	0f 84 e8 00 00 00    	je     801061f0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106108:	e8 23 d8 ff ff       	call   80103930 <myproc>
8010610d:	85 c0                	test   %eax,%eax
8010610f:	74 1d                	je     8010612e <trap+0xfe>
80106111:	e8 1a d8 ff ff       	call   80103930 <myproc>
80106116:	8b 40 24             	mov    0x24(%eax),%eax
80106119:	85 c0                	test   %eax,%eax
8010611b:	74 11                	je     8010612e <trap+0xfe>
8010611d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106121:	83 e0 03             	and    $0x3,%eax
80106124:	66 83 f8 03          	cmp    $0x3,%ax
80106128:	0f 84 03 01 00 00    	je     80106231 <trap+0x201>
    exit();
}
8010612e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106131:	5b                   	pop    %ebx
80106132:	5e                   	pop    %esi
80106133:	5f                   	pop    %edi
80106134:	5d                   	pop    %ebp
80106135:	c3                   	ret    
    ideintr();
80106136:	e8 d5 c0 ff ff       	call   80102210 <ideintr>
    lapiceoi();
8010613b:	e8 b0 c7 ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106140:	e8 eb d7 ff ff       	call   80103930 <myproc>
80106145:	85 c0                	test   %eax,%eax
80106147:	75 8a                	jne    801060d3 <trap+0xa3>
80106149:	eb a5                	jmp    801060f0 <trap+0xc0>
    if(cpuid() == 0){
8010614b:	e8 c0 d7 ff ff       	call   80103910 <cpuid>
80106150:	85 c0                	test   %eax,%eax
80106152:	75 e7                	jne    8010613b <trap+0x10b>
      acquire(&tickslock);
80106154:	83 ec 0c             	sub    $0xc,%esp
80106157:	68 60 a2 11 80       	push   $0x8011a260
8010615c:	e8 0f ea ff ff       	call   80104b70 <acquire>
      wakeup(&ticks);
80106161:	c7 04 24 a0 aa 11 80 	movl   $0x8011aaa0,(%esp)
      ticks++;
80106168:	83 05 a0 aa 11 80 01 	addl   $0x1,0x8011aaa0
      wakeup(&ticks);
8010616f:	e8 1c e2 ff ff       	call   80104390 <wakeup>
      release(&tickslock);
80106174:	c7 04 24 60 a2 11 80 	movl   $0x8011a260,(%esp)
8010617b:	e8 b0 ea ff ff       	call   80104c30 <release>
80106180:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106183:	eb b6                	jmp    8010613b <trap+0x10b>
    kbdintr();
80106185:	e8 26 c6 ff ff       	call   801027b0 <kbdintr>
    lapiceoi();
8010618a:	e8 61 c7 ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010618f:	e8 9c d7 ff ff       	call   80103930 <myproc>
80106194:	85 c0                	test   %eax,%eax
80106196:	0f 85 37 ff ff ff    	jne    801060d3 <trap+0xa3>
8010619c:	e9 4f ff ff ff       	jmp    801060f0 <trap+0xc0>
    uartintr();
801061a1:	e8 4a 02 00 00       	call   801063f0 <uartintr>
    lapiceoi();
801061a6:	e8 45 c7 ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061ab:	e8 80 d7 ff ff       	call   80103930 <myproc>
801061b0:	85 c0                	test   %eax,%eax
801061b2:	0f 85 1b ff ff ff    	jne    801060d3 <trap+0xa3>
801061b8:	e9 33 ff ff ff       	jmp    801060f0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801061bd:	8b 7b 38             	mov    0x38(%ebx),%edi
801061c0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801061c4:	e8 47 d7 ff ff       	call   80103910 <cpuid>
801061c9:	57                   	push   %edi
801061ca:	56                   	push   %esi
801061cb:	50                   	push   %eax
801061cc:	68 b0 80 10 80       	push   $0x801080b0
801061d1:	e8 da a4 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801061d6:	e8 15 c7 ff ff       	call   801028f0 <lapiceoi>
    break;
801061db:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061de:	e8 4d d7 ff ff       	call   80103930 <myproc>
801061e3:	85 c0                	test   %eax,%eax
801061e5:	0f 85 e8 fe ff ff    	jne    801060d3 <trap+0xa3>
801061eb:	e9 00 ff ff ff       	jmp    801060f0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
801061f0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801061f4:	0f 85 0e ff ff ff    	jne    80106108 <trap+0xd8>
    yield();
801061fa:	e8 71 df ff ff       	call   80104170 <yield>
801061ff:	e9 04 ff ff ff       	jmp    80106108 <trap+0xd8>
80106204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106208:	e8 23 d7 ff ff       	call   80103930 <myproc>
8010620d:	8b 70 24             	mov    0x24(%eax),%esi
80106210:	85 f6                	test   %esi,%esi
80106212:	75 3c                	jne    80106250 <trap+0x220>
    myproc()->tf = tf;
80106214:	e8 17 d7 ff ff       	call   80103930 <myproc>
80106219:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010621c:	e8 2f ee ff ff       	call   80105050 <syscall>
    if(myproc()->killed)
80106221:	e8 0a d7 ff ff       	call   80103930 <myproc>
80106226:	8b 48 24             	mov    0x24(%eax),%ecx
80106229:	85 c9                	test   %ecx,%ecx
8010622b:	0f 84 fd fe ff ff    	je     8010612e <trap+0xfe>
}
80106231:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106234:	5b                   	pop    %ebx
80106235:	5e                   	pop    %esi
80106236:	5f                   	pop    %edi
80106237:	5d                   	pop    %ebp
      exit();
80106238:	e9 03 de ff ff       	jmp    80104040 <exit>
8010623d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106240:	e8 fb dd ff ff       	call   80104040 <exit>
80106245:	e9 a6 fe ff ff       	jmp    801060f0 <trap+0xc0>
8010624a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106250:	e8 eb dd ff ff       	call   80104040 <exit>
80106255:	eb bd                	jmp    80106214 <trap+0x1e4>
80106257:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010625a:	e8 b1 d6 ff ff       	call   80103910 <cpuid>
8010625f:	83 ec 0c             	sub    $0xc,%esp
80106262:	56                   	push   %esi
80106263:	57                   	push   %edi
80106264:	50                   	push   %eax
80106265:	ff 73 30             	pushl  0x30(%ebx)
80106268:	68 d4 80 10 80       	push   $0x801080d4
8010626d:	e8 3e a4 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106272:	83 c4 14             	add    $0x14,%esp
80106275:	68 aa 80 10 80       	push   $0x801080aa
8010627a:	e8 11 a1 ff ff       	call   80100390 <panic>
8010627f:	90                   	nop

80106280 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106280:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106284:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106289:	85 c0                	test   %eax,%eax
8010628b:	74 1b                	je     801062a8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010628d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106292:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106293:	a8 01                	test   $0x1,%al
80106295:	74 11                	je     801062a8 <uartgetc+0x28>
80106297:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010629c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010629d:	0f b6 c0             	movzbl %al,%eax
801062a0:	c3                   	ret    
801062a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801062a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062ad:	c3                   	ret    
801062ae:	66 90                	xchg   %ax,%ax

801062b0 <uartputc.part.0>:
uartputc(int c)
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	57                   	push   %edi
801062b4:	89 c7                	mov    %eax,%edi
801062b6:	56                   	push   %esi
801062b7:	be fd 03 00 00       	mov    $0x3fd,%esi
801062bc:	53                   	push   %ebx
801062bd:	bb 80 00 00 00       	mov    $0x80,%ebx
801062c2:	83 ec 0c             	sub    $0xc,%esp
801062c5:	eb 1b                	jmp    801062e2 <uartputc.part.0+0x32>
801062c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ce:	66 90                	xchg   %ax,%ax
    microdelay(10);
801062d0:	83 ec 0c             	sub    $0xc,%esp
801062d3:	6a 0a                	push   $0xa
801062d5:	e8 36 c6 ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801062da:	83 c4 10             	add    $0x10,%esp
801062dd:	83 eb 01             	sub    $0x1,%ebx
801062e0:	74 07                	je     801062e9 <uartputc.part.0+0x39>
801062e2:	89 f2                	mov    %esi,%edx
801062e4:	ec                   	in     (%dx),%al
801062e5:	a8 20                	test   $0x20,%al
801062e7:	74 e7                	je     801062d0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062e9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062ee:	89 f8                	mov    %edi,%eax
801062f0:	ee                   	out    %al,(%dx)
}
801062f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062f4:	5b                   	pop    %ebx
801062f5:	5e                   	pop    %esi
801062f6:	5f                   	pop    %edi
801062f7:	5d                   	pop    %ebp
801062f8:	c3                   	ret    
801062f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106300 <uartinit>:
{
80106300:	f3 0f 1e fb          	endbr32 
80106304:	55                   	push   %ebp
80106305:	31 c9                	xor    %ecx,%ecx
80106307:	89 c8                	mov    %ecx,%eax
80106309:	89 e5                	mov    %esp,%ebp
8010630b:	57                   	push   %edi
8010630c:	56                   	push   %esi
8010630d:	53                   	push   %ebx
8010630e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106313:	89 da                	mov    %ebx,%edx
80106315:	83 ec 0c             	sub    $0xc,%esp
80106318:	ee                   	out    %al,(%dx)
80106319:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010631e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106323:	89 fa                	mov    %edi,%edx
80106325:	ee                   	out    %al,(%dx)
80106326:	b8 0c 00 00 00       	mov    $0xc,%eax
8010632b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106330:	ee                   	out    %al,(%dx)
80106331:	be f9 03 00 00       	mov    $0x3f9,%esi
80106336:	89 c8                	mov    %ecx,%eax
80106338:	89 f2                	mov    %esi,%edx
8010633a:	ee                   	out    %al,(%dx)
8010633b:	b8 03 00 00 00       	mov    $0x3,%eax
80106340:	89 fa                	mov    %edi,%edx
80106342:	ee                   	out    %al,(%dx)
80106343:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106348:	89 c8                	mov    %ecx,%eax
8010634a:	ee                   	out    %al,(%dx)
8010634b:	b8 01 00 00 00       	mov    $0x1,%eax
80106350:	89 f2                	mov    %esi,%edx
80106352:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106353:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106358:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106359:	3c ff                	cmp    $0xff,%al
8010635b:	74 52                	je     801063af <uartinit+0xaf>
  uart = 1;
8010635d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106364:	00 00 00 
80106367:	89 da                	mov    %ebx,%edx
80106369:	ec                   	in     (%dx),%al
8010636a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010636f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106370:	83 ec 08             	sub    $0x8,%esp
80106373:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106378:	bb cc 81 10 80       	mov    $0x801081cc,%ebx
  ioapicenable(IRQ_COM1, 0);
8010637d:	6a 00                	push   $0x0
8010637f:	6a 04                	push   $0x4
80106381:	e8 da c0 ff ff       	call   80102460 <ioapicenable>
80106386:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106389:	b8 78 00 00 00       	mov    $0x78,%eax
8010638e:	eb 04                	jmp    80106394 <uartinit+0x94>
80106390:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106394:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010639a:	85 d2                	test   %edx,%edx
8010639c:	74 08                	je     801063a6 <uartinit+0xa6>
    uartputc(*p);
8010639e:	0f be c0             	movsbl %al,%eax
801063a1:	e8 0a ff ff ff       	call   801062b0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801063a6:	89 f0                	mov    %esi,%eax
801063a8:	83 c3 01             	add    $0x1,%ebx
801063ab:	84 c0                	test   %al,%al
801063ad:	75 e1                	jne    80106390 <uartinit+0x90>
}
801063af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063b2:	5b                   	pop    %ebx
801063b3:	5e                   	pop    %esi
801063b4:	5f                   	pop    %edi
801063b5:	5d                   	pop    %ebp
801063b6:	c3                   	ret    
801063b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063be:	66 90                	xchg   %ax,%ax

801063c0 <uartputc>:
{
801063c0:	f3 0f 1e fb          	endbr32 
801063c4:	55                   	push   %ebp
  if(!uart)
801063c5:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801063cb:	89 e5                	mov    %esp,%ebp
801063cd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801063d0:	85 d2                	test   %edx,%edx
801063d2:	74 0c                	je     801063e0 <uartputc+0x20>
}
801063d4:	5d                   	pop    %ebp
801063d5:	e9 d6 fe ff ff       	jmp    801062b0 <uartputc.part.0>
801063da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801063e0:	5d                   	pop    %ebp
801063e1:	c3                   	ret    
801063e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063f0 <uartintr>:

void
uartintr(void)
{
801063f0:	f3 0f 1e fb          	endbr32 
801063f4:	55                   	push   %ebp
801063f5:	89 e5                	mov    %esp,%ebp
801063f7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801063fa:	68 80 62 10 80       	push   $0x80106280
801063ff:	e8 5c a4 ff ff       	call   80100860 <consoleintr>
}
80106404:	83 c4 10             	add    $0x10,%esp
80106407:	c9                   	leave  
80106408:	c3                   	ret    

80106409 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106409:	6a 00                	push   $0x0
  pushl $0
8010640b:	6a 00                	push   $0x0
  jmp alltraps
8010640d:	e9 41 fb ff ff       	jmp    80105f53 <alltraps>

80106412 <vector1>:
.globl vector1
vector1:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $1
80106414:	6a 01                	push   $0x1
  jmp alltraps
80106416:	e9 38 fb ff ff       	jmp    80105f53 <alltraps>

8010641b <vector2>:
.globl vector2
vector2:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $2
8010641d:	6a 02                	push   $0x2
  jmp alltraps
8010641f:	e9 2f fb ff ff       	jmp    80105f53 <alltraps>

80106424 <vector3>:
.globl vector3
vector3:
  pushl $0
80106424:	6a 00                	push   $0x0
  pushl $3
80106426:	6a 03                	push   $0x3
  jmp alltraps
80106428:	e9 26 fb ff ff       	jmp    80105f53 <alltraps>

8010642d <vector4>:
.globl vector4
vector4:
  pushl $0
8010642d:	6a 00                	push   $0x0
  pushl $4
8010642f:	6a 04                	push   $0x4
  jmp alltraps
80106431:	e9 1d fb ff ff       	jmp    80105f53 <alltraps>

80106436 <vector5>:
.globl vector5
vector5:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $5
80106438:	6a 05                	push   $0x5
  jmp alltraps
8010643a:	e9 14 fb ff ff       	jmp    80105f53 <alltraps>

8010643f <vector6>:
.globl vector6
vector6:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $6
80106441:	6a 06                	push   $0x6
  jmp alltraps
80106443:	e9 0b fb ff ff       	jmp    80105f53 <alltraps>

80106448 <vector7>:
.globl vector7
vector7:
  pushl $0
80106448:	6a 00                	push   $0x0
  pushl $7
8010644a:	6a 07                	push   $0x7
  jmp alltraps
8010644c:	e9 02 fb ff ff       	jmp    80105f53 <alltraps>

80106451 <vector8>:
.globl vector8
vector8:
  pushl $8
80106451:	6a 08                	push   $0x8
  jmp alltraps
80106453:	e9 fb fa ff ff       	jmp    80105f53 <alltraps>

80106458 <vector9>:
.globl vector9
vector9:
  pushl $0
80106458:	6a 00                	push   $0x0
  pushl $9
8010645a:	6a 09                	push   $0x9
  jmp alltraps
8010645c:	e9 f2 fa ff ff       	jmp    80105f53 <alltraps>

80106461 <vector10>:
.globl vector10
vector10:
  pushl $10
80106461:	6a 0a                	push   $0xa
  jmp alltraps
80106463:	e9 eb fa ff ff       	jmp    80105f53 <alltraps>

80106468 <vector11>:
.globl vector11
vector11:
  pushl $11
80106468:	6a 0b                	push   $0xb
  jmp alltraps
8010646a:	e9 e4 fa ff ff       	jmp    80105f53 <alltraps>

8010646f <vector12>:
.globl vector12
vector12:
  pushl $12
8010646f:	6a 0c                	push   $0xc
  jmp alltraps
80106471:	e9 dd fa ff ff       	jmp    80105f53 <alltraps>

80106476 <vector13>:
.globl vector13
vector13:
  pushl $13
80106476:	6a 0d                	push   $0xd
  jmp alltraps
80106478:	e9 d6 fa ff ff       	jmp    80105f53 <alltraps>

8010647d <vector14>:
.globl vector14
vector14:
  pushl $14
8010647d:	6a 0e                	push   $0xe
  jmp alltraps
8010647f:	e9 cf fa ff ff       	jmp    80105f53 <alltraps>

80106484 <vector15>:
.globl vector15
vector15:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $15
80106486:	6a 0f                	push   $0xf
  jmp alltraps
80106488:	e9 c6 fa ff ff       	jmp    80105f53 <alltraps>

8010648d <vector16>:
.globl vector16
vector16:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $16
8010648f:	6a 10                	push   $0x10
  jmp alltraps
80106491:	e9 bd fa ff ff       	jmp    80105f53 <alltraps>

80106496 <vector17>:
.globl vector17
vector17:
  pushl $17
80106496:	6a 11                	push   $0x11
  jmp alltraps
80106498:	e9 b6 fa ff ff       	jmp    80105f53 <alltraps>

8010649d <vector18>:
.globl vector18
vector18:
  pushl $0
8010649d:	6a 00                	push   $0x0
  pushl $18
8010649f:	6a 12                	push   $0x12
  jmp alltraps
801064a1:	e9 ad fa ff ff       	jmp    80105f53 <alltraps>

801064a6 <vector19>:
.globl vector19
vector19:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $19
801064a8:	6a 13                	push   $0x13
  jmp alltraps
801064aa:	e9 a4 fa ff ff       	jmp    80105f53 <alltraps>

801064af <vector20>:
.globl vector20
vector20:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $20
801064b1:	6a 14                	push   $0x14
  jmp alltraps
801064b3:	e9 9b fa ff ff       	jmp    80105f53 <alltraps>

801064b8 <vector21>:
.globl vector21
vector21:
  pushl $0
801064b8:	6a 00                	push   $0x0
  pushl $21
801064ba:	6a 15                	push   $0x15
  jmp alltraps
801064bc:	e9 92 fa ff ff       	jmp    80105f53 <alltraps>

801064c1 <vector22>:
.globl vector22
vector22:
  pushl $0
801064c1:	6a 00                	push   $0x0
  pushl $22
801064c3:	6a 16                	push   $0x16
  jmp alltraps
801064c5:	e9 89 fa ff ff       	jmp    80105f53 <alltraps>

801064ca <vector23>:
.globl vector23
vector23:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $23
801064cc:	6a 17                	push   $0x17
  jmp alltraps
801064ce:	e9 80 fa ff ff       	jmp    80105f53 <alltraps>

801064d3 <vector24>:
.globl vector24
vector24:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $24
801064d5:	6a 18                	push   $0x18
  jmp alltraps
801064d7:	e9 77 fa ff ff       	jmp    80105f53 <alltraps>

801064dc <vector25>:
.globl vector25
vector25:
  pushl $0
801064dc:	6a 00                	push   $0x0
  pushl $25
801064de:	6a 19                	push   $0x19
  jmp alltraps
801064e0:	e9 6e fa ff ff       	jmp    80105f53 <alltraps>

801064e5 <vector26>:
.globl vector26
vector26:
  pushl $0
801064e5:	6a 00                	push   $0x0
  pushl $26
801064e7:	6a 1a                	push   $0x1a
  jmp alltraps
801064e9:	e9 65 fa ff ff       	jmp    80105f53 <alltraps>

801064ee <vector27>:
.globl vector27
vector27:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $27
801064f0:	6a 1b                	push   $0x1b
  jmp alltraps
801064f2:	e9 5c fa ff ff       	jmp    80105f53 <alltraps>

801064f7 <vector28>:
.globl vector28
vector28:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $28
801064f9:	6a 1c                	push   $0x1c
  jmp alltraps
801064fb:	e9 53 fa ff ff       	jmp    80105f53 <alltraps>

80106500 <vector29>:
.globl vector29
vector29:
  pushl $0
80106500:	6a 00                	push   $0x0
  pushl $29
80106502:	6a 1d                	push   $0x1d
  jmp alltraps
80106504:	e9 4a fa ff ff       	jmp    80105f53 <alltraps>

80106509 <vector30>:
.globl vector30
vector30:
  pushl $0
80106509:	6a 00                	push   $0x0
  pushl $30
8010650b:	6a 1e                	push   $0x1e
  jmp alltraps
8010650d:	e9 41 fa ff ff       	jmp    80105f53 <alltraps>

80106512 <vector31>:
.globl vector31
vector31:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $31
80106514:	6a 1f                	push   $0x1f
  jmp alltraps
80106516:	e9 38 fa ff ff       	jmp    80105f53 <alltraps>

8010651b <vector32>:
.globl vector32
vector32:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $32
8010651d:	6a 20                	push   $0x20
  jmp alltraps
8010651f:	e9 2f fa ff ff       	jmp    80105f53 <alltraps>

80106524 <vector33>:
.globl vector33
vector33:
  pushl $0
80106524:	6a 00                	push   $0x0
  pushl $33
80106526:	6a 21                	push   $0x21
  jmp alltraps
80106528:	e9 26 fa ff ff       	jmp    80105f53 <alltraps>

8010652d <vector34>:
.globl vector34
vector34:
  pushl $0
8010652d:	6a 00                	push   $0x0
  pushl $34
8010652f:	6a 22                	push   $0x22
  jmp alltraps
80106531:	e9 1d fa ff ff       	jmp    80105f53 <alltraps>

80106536 <vector35>:
.globl vector35
vector35:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $35
80106538:	6a 23                	push   $0x23
  jmp alltraps
8010653a:	e9 14 fa ff ff       	jmp    80105f53 <alltraps>

8010653f <vector36>:
.globl vector36
vector36:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $36
80106541:	6a 24                	push   $0x24
  jmp alltraps
80106543:	e9 0b fa ff ff       	jmp    80105f53 <alltraps>

80106548 <vector37>:
.globl vector37
vector37:
  pushl $0
80106548:	6a 00                	push   $0x0
  pushl $37
8010654a:	6a 25                	push   $0x25
  jmp alltraps
8010654c:	e9 02 fa ff ff       	jmp    80105f53 <alltraps>

80106551 <vector38>:
.globl vector38
vector38:
  pushl $0
80106551:	6a 00                	push   $0x0
  pushl $38
80106553:	6a 26                	push   $0x26
  jmp alltraps
80106555:	e9 f9 f9 ff ff       	jmp    80105f53 <alltraps>

8010655a <vector39>:
.globl vector39
vector39:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $39
8010655c:	6a 27                	push   $0x27
  jmp alltraps
8010655e:	e9 f0 f9 ff ff       	jmp    80105f53 <alltraps>

80106563 <vector40>:
.globl vector40
vector40:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $40
80106565:	6a 28                	push   $0x28
  jmp alltraps
80106567:	e9 e7 f9 ff ff       	jmp    80105f53 <alltraps>

8010656c <vector41>:
.globl vector41
vector41:
  pushl $0
8010656c:	6a 00                	push   $0x0
  pushl $41
8010656e:	6a 29                	push   $0x29
  jmp alltraps
80106570:	e9 de f9 ff ff       	jmp    80105f53 <alltraps>

80106575 <vector42>:
.globl vector42
vector42:
  pushl $0
80106575:	6a 00                	push   $0x0
  pushl $42
80106577:	6a 2a                	push   $0x2a
  jmp alltraps
80106579:	e9 d5 f9 ff ff       	jmp    80105f53 <alltraps>

8010657e <vector43>:
.globl vector43
vector43:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $43
80106580:	6a 2b                	push   $0x2b
  jmp alltraps
80106582:	e9 cc f9 ff ff       	jmp    80105f53 <alltraps>

80106587 <vector44>:
.globl vector44
vector44:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $44
80106589:	6a 2c                	push   $0x2c
  jmp alltraps
8010658b:	e9 c3 f9 ff ff       	jmp    80105f53 <alltraps>

80106590 <vector45>:
.globl vector45
vector45:
  pushl $0
80106590:	6a 00                	push   $0x0
  pushl $45
80106592:	6a 2d                	push   $0x2d
  jmp alltraps
80106594:	e9 ba f9 ff ff       	jmp    80105f53 <alltraps>

80106599 <vector46>:
.globl vector46
vector46:
  pushl $0
80106599:	6a 00                	push   $0x0
  pushl $46
8010659b:	6a 2e                	push   $0x2e
  jmp alltraps
8010659d:	e9 b1 f9 ff ff       	jmp    80105f53 <alltraps>

801065a2 <vector47>:
.globl vector47
vector47:
  pushl $0
801065a2:	6a 00                	push   $0x0
  pushl $47
801065a4:	6a 2f                	push   $0x2f
  jmp alltraps
801065a6:	e9 a8 f9 ff ff       	jmp    80105f53 <alltraps>

801065ab <vector48>:
.globl vector48
vector48:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $48
801065ad:	6a 30                	push   $0x30
  jmp alltraps
801065af:	e9 9f f9 ff ff       	jmp    80105f53 <alltraps>

801065b4 <vector49>:
.globl vector49
vector49:
  pushl $0
801065b4:	6a 00                	push   $0x0
  pushl $49
801065b6:	6a 31                	push   $0x31
  jmp alltraps
801065b8:	e9 96 f9 ff ff       	jmp    80105f53 <alltraps>

801065bd <vector50>:
.globl vector50
vector50:
  pushl $0
801065bd:	6a 00                	push   $0x0
  pushl $50
801065bf:	6a 32                	push   $0x32
  jmp alltraps
801065c1:	e9 8d f9 ff ff       	jmp    80105f53 <alltraps>

801065c6 <vector51>:
.globl vector51
vector51:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $51
801065c8:	6a 33                	push   $0x33
  jmp alltraps
801065ca:	e9 84 f9 ff ff       	jmp    80105f53 <alltraps>

801065cf <vector52>:
.globl vector52
vector52:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $52
801065d1:	6a 34                	push   $0x34
  jmp alltraps
801065d3:	e9 7b f9 ff ff       	jmp    80105f53 <alltraps>

801065d8 <vector53>:
.globl vector53
vector53:
  pushl $0
801065d8:	6a 00                	push   $0x0
  pushl $53
801065da:	6a 35                	push   $0x35
  jmp alltraps
801065dc:	e9 72 f9 ff ff       	jmp    80105f53 <alltraps>

801065e1 <vector54>:
.globl vector54
vector54:
  pushl $0
801065e1:	6a 00                	push   $0x0
  pushl $54
801065e3:	6a 36                	push   $0x36
  jmp alltraps
801065e5:	e9 69 f9 ff ff       	jmp    80105f53 <alltraps>

801065ea <vector55>:
.globl vector55
vector55:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $55
801065ec:	6a 37                	push   $0x37
  jmp alltraps
801065ee:	e9 60 f9 ff ff       	jmp    80105f53 <alltraps>

801065f3 <vector56>:
.globl vector56
vector56:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $56
801065f5:	6a 38                	push   $0x38
  jmp alltraps
801065f7:	e9 57 f9 ff ff       	jmp    80105f53 <alltraps>

801065fc <vector57>:
.globl vector57
vector57:
  pushl $0
801065fc:	6a 00                	push   $0x0
  pushl $57
801065fe:	6a 39                	push   $0x39
  jmp alltraps
80106600:	e9 4e f9 ff ff       	jmp    80105f53 <alltraps>

80106605 <vector58>:
.globl vector58
vector58:
  pushl $0
80106605:	6a 00                	push   $0x0
  pushl $58
80106607:	6a 3a                	push   $0x3a
  jmp alltraps
80106609:	e9 45 f9 ff ff       	jmp    80105f53 <alltraps>

8010660e <vector59>:
.globl vector59
vector59:
  pushl $0
8010660e:	6a 00                	push   $0x0
  pushl $59
80106610:	6a 3b                	push   $0x3b
  jmp alltraps
80106612:	e9 3c f9 ff ff       	jmp    80105f53 <alltraps>

80106617 <vector60>:
.globl vector60
vector60:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $60
80106619:	6a 3c                	push   $0x3c
  jmp alltraps
8010661b:	e9 33 f9 ff ff       	jmp    80105f53 <alltraps>

80106620 <vector61>:
.globl vector61
vector61:
  pushl $0
80106620:	6a 00                	push   $0x0
  pushl $61
80106622:	6a 3d                	push   $0x3d
  jmp alltraps
80106624:	e9 2a f9 ff ff       	jmp    80105f53 <alltraps>

80106629 <vector62>:
.globl vector62
vector62:
  pushl $0
80106629:	6a 00                	push   $0x0
  pushl $62
8010662b:	6a 3e                	push   $0x3e
  jmp alltraps
8010662d:	e9 21 f9 ff ff       	jmp    80105f53 <alltraps>

80106632 <vector63>:
.globl vector63
vector63:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $63
80106634:	6a 3f                	push   $0x3f
  jmp alltraps
80106636:	e9 18 f9 ff ff       	jmp    80105f53 <alltraps>

8010663b <vector64>:
.globl vector64
vector64:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $64
8010663d:	6a 40                	push   $0x40
  jmp alltraps
8010663f:	e9 0f f9 ff ff       	jmp    80105f53 <alltraps>

80106644 <vector65>:
.globl vector65
vector65:
  pushl $0
80106644:	6a 00                	push   $0x0
  pushl $65
80106646:	6a 41                	push   $0x41
  jmp alltraps
80106648:	e9 06 f9 ff ff       	jmp    80105f53 <alltraps>

8010664d <vector66>:
.globl vector66
vector66:
  pushl $0
8010664d:	6a 00                	push   $0x0
  pushl $66
8010664f:	6a 42                	push   $0x42
  jmp alltraps
80106651:	e9 fd f8 ff ff       	jmp    80105f53 <alltraps>

80106656 <vector67>:
.globl vector67
vector67:
  pushl $0
80106656:	6a 00                	push   $0x0
  pushl $67
80106658:	6a 43                	push   $0x43
  jmp alltraps
8010665a:	e9 f4 f8 ff ff       	jmp    80105f53 <alltraps>

8010665f <vector68>:
.globl vector68
vector68:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $68
80106661:	6a 44                	push   $0x44
  jmp alltraps
80106663:	e9 eb f8 ff ff       	jmp    80105f53 <alltraps>

80106668 <vector69>:
.globl vector69
vector69:
  pushl $0
80106668:	6a 00                	push   $0x0
  pushl $69
8010666a:	6a 45                	push   $0x45
  jmp alltraps
8010666c:	e9 e2 f8 ff ff       	jmp    80105f53 <alltraps>

80106671 <vector70>:
.globl vector70
vector70:
  pushl $0
80106671:	6a 00                	push   $0x0
  pushl $70
80106673:	6a 46                	push   $0x46
  jmp alltraps
80106675:	e9 d9 f8 ff ff       	jmp    80105f53 <alltraps>

8010667a <vector71>:
.globl vector71
vector71:
  pushl $0
8010667a:	6a 00                	push   $0x0
  pushl $71
8010667c:	6a 47                	push   $0x47
  jmp alltraps
8010667e:	e9 d0 f8 ff ff       	jmp    80105f53 <alltraps>

80106683 <vector72>:
.globl vector72
vector72:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $72
80106685:	6a 48                	push   $0x48
  jmp alltraps
80106687:	e9 c7 f8 ff ff       	jmp    80105f53 <alltraps>

8010668c <vector73>:
.globl vector73
vector73:
  pushl $0
8010668c:	6a 00                	push   $0x0
  pushl $73
8010668e:	6a 49                	push   $0x49
  jmp alltraps
80106690:	e9 be f8 ff ff       	jmp    80105f53 <alltraps>

80106695 <vector74>:
.globl vector74
vector74:
  pushl $0
80106695:	6a 00                	push   $0x0
  pushl $74
80106697:	6a 4a                	push   $0x4a
  jmp alltraps
80106699:	e9 b5 f8 ff ff       	jmp    80105f53 <alltraps>

8010669e <vector75>:
.globl vector75
vector75:
  pushl $0
8010669e:	6a 00                	push   $0x0
  pushl $75
801066a0:	6a 4b                	push   $0x4b
  jmp alltraps
801066a2:	e9 ac f8 ff ff       	jmp    80105f53 <alltraps>

801066a7 <vector76>:
.globl vector76
vector76:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $76
801066a9:	6a 4c                	push   $0x4c
  jmp alltraps
801066ab:	e9 a3 f8 ff ff       	jmp    80105f53 <alltraps>

801066b0 <vector77>:
.globl vector77
vector77:
  pushl $0
801066b0:	6a 00                	push   $0x0
  pushl $77
801066b2:	6a 4d                	push   $0x4d
  jmp alltraps
801066b4:	e9 9a f8 ff ff       	jmp    80105f53 <alltraps>

801066b9 <vector78>:
.globl vector78
vector78:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $78
801066bb:	6a 4e                	push   $0x4e
  jmp alltraps
801066bd:	e9 91 f8 ff ff       	jmp    80105f53 <alltraps>

801066c2 <vector79>:
.globl vector79
vector79:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $79
801066c4:	6a 4f                	push   $0x4f
  jmp alltraps
801066c6:	e9 88 f8 ff ff       	jmp    80105f53 <alltraps>

801066cb <vector80>:
.globl vector80
vector80:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $80
801066cd:	6a 50                	push   $0x50
  jmp alltraps
801066cf:	e9 7f f8 ff ff       	jmp    80105f53 <alltraps>

801066d4 <vector81>:
.globl vector81
vector81:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $81
801066d6:	6a 51                	push   $0x51
  jmp alltraps
801066d8:	e9 76 f8 ff ff       	jmp    80105f53 <alltraps>

801066dd <vector82>:
.globl vector82
vector82:
  pushl $0
801066dd:	6a 00                	push   $0x0
  pushl $82
801066df:	6a 52                	push   $0x52
  jmp alltraps
801066e1:	e9 6d f8 ff ff       	jmp    80105f53 <alltraps>

801066e6 <vector83>:
.globl vector83
vector83:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $83
801066e8:	6a 53                	push   $0x53
  jmp alltraps
801066ea:	e9 64 f8 ff ff       	jmp    80105f53 <alltraps>

801066ef <vector84>:
.globl vector84
vector84:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $84
801066f1:	6a 54                	push   $0x54
  jmp alltraps
801066f3:	e9 5b f8 ff ff       	jmp    80105f53 <alltraps>

801066f8 <vector85>:
.globl vector85
vector85:
  pushl $0
801066f8:	6a 00                	push   $0x0
  pushl $85
801066fa:	6a 55                	push   $0x55
  jmp alltraps
801066fc:	e9 52 f8 ff ff       	jmp    80105f53 <alltraps>

80106701 <vector86>:
.globl vector86
vector86:
  pushl $0
80106701:	6a 00                	push   $0x0
  pushl $86
80106703:	6a 56                	push   $0x56
  jmp alltraps
80106705:	e9 49 f8 ff ff       	jmp    80105f53 <alltraps>

8010670a <vector87>:
.globl vector87
vector87:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $87
8010670c:	6a 57                	push   $0x57
  jmp alltraps
8010670e:	e9 40 f8 ff ff       	jmp    80105f53 <alltraps>

80106713 <vector88>:
.globl vector88
vector88:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $88
80106715:	6a 58                	push   $0x58
  jmp alltraps
80106717:	e9 37 f8 ff ff       	jmp    80105f53 <alltraps>

8010671c <vector89>:
.globl vector89
vector89:
  pushl $0
8010671c:	6a 00                	push   $0x0
  pushl $89
8010671e:	6a 59                	push   $0x59
  jmp alltraps
80106720:	e9 2e f8 ff ff       	jmp    80105f53 <alltraps>

80106725 <vector90>:
.globl vector90
vector90:
  pushl $0
80106725:	6a 00                	push   $0x0
  pushl $90
80106727:	6a 5a                	push   $0x5a
  jmp alltraps
80106729:	e9 25 f8 ff ff       	jmp    80105f53 <alltraps>

8010672e <vector91>:
.globl vector91
vector91:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $91
80106730:	6a 5b                	push   $0x5b
  jmp alltraps
80106732:	e9 1c f8 ff ff       	jmp    80105f53 <alltraps>

80106737 <vector92>:
.globl vector92
vector92:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $92
80106739:	6a 5c                	push   $0x5c
  jmp alltraps
8010673b:	e9 13 f8 ff ff       	jmp    80105f53 <alltraps>

80106740 <vector93>:
.globl vector93
vector93:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $93
80106742:	6a 5d                	push   $0x5d
  jmp alltraps
80106744:	e9 0a f8 ff ff       	jmp    80105f53 <alltraps>

80106749 <vector94>:
.globl vector94
vector94:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $94
8010674b:	6a 5e                	push   $0x5e
  jmp alltraps
8010674d:	e9 01 f8 ff ff       	jmp    80105f53 <alltraps>

80106752 <vector95>:
.globl vector95
vector95:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $95
80106754:	6a 5f                	push   $0x5f
  jmp alltraps
80106756:	e9 f8 f7 ff ff       	jmp    80105f53 <alltraps>

8010675b <vector96>:
.globl vector96
vector96:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $96
8010675d:	6a 60                	push   $0x60
  jmp alltraps
8010675f:	e9 ef f7 ff ff       	jmp    80105f53 <alltraps>

80106764 <vector97>:
.globl vector97
vector97:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $97
80106766:	6a 61                	push   $0x61
  jmp alltraps
80106768:	e9 e6 f7 ff ff       	jmp    80105f53 <alltraps>

8010676d <vector98>:
.globl vector98
vector98:
  pushl $0
8010676d:	6a 00                	push   $0x0
  pushl $98
8010676f:	6a 62                	push   $0x62
  jmp alltraps
80106771:	e9 dd f7 ff ff       	jmp    80105f53 <alltraps>

80106776 <vector99>:
.globl vector99
vector99:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $99
80106778:	6a 63                	push   $0x63
  jmp alltraps
8010677a:	e9 d4 f7 ff ff       	jmp    80105f53 <alltraps>

8010677f <vector100>:
.globl vector100
vector100:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $100
80106781:	6a 64                	push   $0x64
  jmp alltraps
80106783:	e9 cb f7 ff ff       	jmp    80105f53 <alltraps>

80106788 <vector101>:
.globl vector101
vector101:
  pushl $0
80106788:	6a 00                	push   $0x0
  pushl $101
8010678a:	6a 65                	push   $0x65
  jmp alltraps
8010678c:	e9 c2 f7 ff ff       	jmp    80105f53 <alltraps>

80106791 <vector102>:
.globl vector102
vector102:
  pushl $0
80106791:	6a 00                	push   $0x0
  pushl $102
80106793:	6a 66                	push   $0x66
  jmp alltraps
80106795:	e9 b9 f7 ff ff       	jmp    80105f53 <alltraps>

8010679a <vector103>:
.globl vector103
vector103:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $103
8010679c:	6a 67                	push   $0x67
  jmp alltraps
8010679e:	e9 b0 f7 ff ff       	jmp    80105f53 <alltraps>

801067a3 <vector104>:
.globl vector104
vector104:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $104
801067a5:	6a 68                	push   $0x68
  jmp alltraps
801067a7:	e9 a7 f7 ff ff       	jmp    80105f53 <alltraps>

801067ac <vector105>:
.globl vector105
vector105:
  pushl $0
801067ac:	6a 00                	push   $0x0
  pushl $105
801067ae:	6a 69                	push   $0x69
  jmp alltraps
801067b0:	e9 9e f7 ff ff       	jmp    80105f53 <alltraps>

801067b5 <vector106>:
.globl vector106
vector106:
  pushl $0
801067b5:	6a 00                	push   $0x0
  pushl $106
801067b7:	6a 6a                	push   $0x6a
  jmp alltraps
801067b9:	e9 95 f7 ff ff       	jmp    80105f53 <alltraps>

801067be <vector107>:
.globl vector107
vector107:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $107
801067c0:	6a 6b                	push   $0x6b
  jmp alltraps
801067c2:	e9 8c f7 ff ff       	jmp    80105f53 <alltraps>

801067c7 <vector108>:
.globl vector108
vector108:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $108
801067c9:	6a 6c                	push   $0x6c
  jmp alltraps
801067cb:	e9 83 f7 ff ff       	jmp    80105f53 <alltraps>

801067d0 <vector109>:
.globl vector109
vector109:
  pushl $0
801067d0:	6a 00                	push   $0x0
  pushl $109
801067d2:	6a 6d                	push   $0x6d
  jmp alltraps
801067d4:	e9 7a f7 ff ff       	jmp    80105f53 <alltraps>

801067d9 <vector110>:
.globl vector110
vector110:
  pushl $0
801067d9:	6a 00                	push   $0x0
  pushl $110
801067db:	6a 6e                	push   $0x6e
  jmp alltraps
801067dd:	e9 71 f7 ff ff       	jmp    80105f53 <alltraps>

801067e2 <vector111>:
.globl vector111
vector111:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $111
801067e4:	6a 6f                	push   $0x6f
  jmp alltraps
801067e6:	e9 68 f7 ff ff       	jmp    80105f53 <alltraps>

801067eb <vector112>:
.globl vector112
vector112:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $112
801067ed:	6a 70                	push   $0x70
  jmp alltraps
801067ef:	e9 5f f7 ff ff       	jmp    80105f53 <alltraps>

801067f4 <vector113>:
.globl vector113
vector113:
  pushl $0
801067f4:	6a 00                	push   $0x0
  pushl $113
801067f6:	6a 71                	push   $0x71
  jmp alltraps
801067f8:	e9 56 f7 ff ff       	jmp    80105f53 <alltraps>

801067fd <vector114>:
.globl vector114
vector114:
  pushl $0
801067fd:	6a 00                	push   $0x0
  pushl $114
801067ff:	6a 72                	push   $0x72
  jmp alltraps
80106801:	e9 4d f7 ff ff       	jmp    80105f53 <alltraps>

80106806 <vector115>:
.globl vector115
vector115:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $115
80106808:	6a 73                	push   $0x73
  jmp alltraps
8010680a:	e9 44 f7 ff ff       	jmp    80105f53 <alltraps>

8010680f <vector116>:
.globl vector116
vector116:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $116
80106811:	6a 74                	push   $0x74
  jmp alltraps
80106813:	e9 3b f7 ff ff       	jmp    80105f53 <alltraps>

80106818 <vector117>:
.globl vector117
vector117:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $117
8010681a:	6a 75                	push   $0x75
  jmp alltraps
8010681c:	e9 32 f7 ff ff       	jmp    80105f53 <alltraps>

80106821 <vector118>:
.globl vector118
vector118:
  pushl $0
80106821:	6a 00                	push   $0x0
  pushl $118
80106823:	6a 76                	push   $0x76
  jmp alltraps
80106825:	e9 29 f7 ff ff       	jmp    80105f53 <alltraps>

8010682a <vector119>:
.globl vector119
vector119:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $119
8010682c:	6a 77                	push   $0x77
  jmp alltraps
8010682e:	e9 20 f7 ff ff       	jmp    80105f53 <alltraps>

80106833 <vector120>:
.globl vector120
vector120:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $120
80106835:	6a 78                	push   $0x78
  jmp alltraps
80106837:	e9 17 f7 ff ff       	jmp    80105f53 <alltraps>

8010683c <vector121>:
.globl vector121
vector121:
  pushl $0
8010683c:	6a 00                	push   $0x0
  pushl $121
8010683e:	6a 79                	push   $0x79
  jmp alltraps
80106840:	e9 0e f7 ff ff       	jmp    80105f53 <alltraps>

80106845 <vector122>:
.globl vector122
vector122:
  pushl $0
80106845:	6a 00                	push   $0x0
  pushl $122
80106847:	6a 7a                	push   $0x7a
  jmp alltraps
80106849:	e9 05 f7 ff ff       	jmp    80105f53 <alltraps>

8010684e <vector123>:
.globl vector123
vector123:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $123
80106850:	6a 7b                	push   $0x7b
  jmp alltraps
80106852:	e9 fc f6 ff ff       	jmp    80105f53 <alltraps>

80106857 <vector124>:
.globl vector124
vector124:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $124
80106859:	6a 7c                	push   $0x7c
  jmp alltraps
8010685b:	e9 f3 f6 ff ff       	jmp    80105f53 <alltraps>

80106860 <vector125>:
.globl vector125
vector125:
  pushl $0
80106860:	6a 00                	push   $0x0
  pushl $125
80106862:	6a 7d                	push   $0x7d
  jmp alltraps
80106864:	e9 ea f6 ff ff       	jmp    80105f53 <alltraps>

80106869 <vector126>:
.globl vector126
vector126:
  pushl $0
80106869:	6a 00                	push   $0x0
  pushl $126
8010686b:	6a 7e                	push   $0x7e
  jmp alltraps
8010686d:	e9 e1 f6 ff ff       	jmp    80105f53 <alltraps>

80106872 <vector127>:
.globl vector127
vector127:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $127
80106874:	6a 7f                	push   $0x7f
  jmp alltraps
80106876:	e9 d8 f6 ff ff       	jmp    80105f53 <alltraps>

8010687b <vector128>:
.globl vector128
vector128:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $128
8010687d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106882:	e9 cc f6 ff ff       	jmp    80105f53 <alltraps>

80106887 <vector129>:
.globl vector129
vector129:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $129
80106889:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010688e:	e9 c0 f6 ff ff       	jmp    80105f53 <alltraps>

80106893 <vector130>:
.globl vector130
vector130:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $130
80106895:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010689a:	e9 b4 f6 ff ff       	jmp    80105f53 <alltraps>

8010689f <vector131>:
.globl vector131
vector131:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $131
801068a1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801068a6:	e9 a8 f6 ff ff       	jmp    80105f53 <alltraps>

801068ab <vector132>:
.globl vector132
vector132:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $132
801068ad:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801068b2:	e9 9c f6 ff ff       	jmp    80105f53 <alltraps>

801068b7 <vector133>:
.globl vector133
vector133:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $133
801068b9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801068be:	e9 90 f6 ff ff       	jmp    80105f53 <alltraps>

801068c3 <vector134>:
.globl vector134
vector134:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $134
801068c5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801068ca:	e9 84 f6 ff ff       	jmp    80105f53 <alltraps>

801068cf <vector135>:
.globl vector135
vector135:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $135
801068d1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068d6:	e9 78 f6 ff ff       	jmp    80105f53 <alltraps>

801068db <vector136>:
.globl vector136
vector136:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $136
801068dd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801068e2:	e9 6c f6 ff ff       	jmp    80105f53 <alltraps>

801068e7 <vector137>:
.globl vector137
vector137:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $137
801068e9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801068ee:	e9 60 f6 ff ff       	jmp    80105f53 <alltraps>

801068f3 <vector138>:
.globl vector138
vector138:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $138
801068f5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801068fa:	e9 54 f6 ff ff       	jmp    80105f53 <alltraps>

801068ff <vector139>:
.globl vector139
vector139:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $139
80106901:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106906:	e9 48 f6 ff ff       	jmp    80105f53 <alltraps>

8010690b <vector140>:
.globl vector140
vector140:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $140
8010690d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106912:	e9 3c f6 ff ff       	jmp    80105f53 <alltraps>

80106917 <vector141>:
.globl vector141
vector141:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $141
80106919:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010691e:	e9 30 f6 ff ff       	jmp    80105f53 <alltraps>

80106923 <vector142>:
.globl vector142
vector142:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $142
80106925:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010692a:	e9 24 f6 ff ff       	jmp    80105f53 <alltraps>

8010692f <vector143>:
.globl vector143
vector143:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $143
80106931:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106936:	e9 18 f6 ff ff       	jmp    80105f53 <alltraps>

8010693b <vector144>:
.globl vector144
vector144:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $144
8010693d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106942:	e9 0c f6 ff ff       	jmp    80105f53 <alltraps>

80106947 <vector145>:
.globl vector145
vector145:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $145
80106949:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010694e:	e9 00 f6 ff ff       	jmp    80105f53 <alltraps>

80106953 <vector146>:
.globl vector146
vector146:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $146
80106955:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010695a:	e9 f4 f5 ff ff       	jmp    80105f53 <alltraps>

8010695f <vector147>:
.globl vector147
vector147:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $147
80106961:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106966:	e9 e8 f5 ff ff       	jmp    80105f53 <alltraps>

8010696b <vector148>:
.globl vector148
vector148:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $148
8010696d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106972:	e9 dc f5 ff ff       	jmp    80105f53 <alltraps>

80106977 <vector149>:
.globl vector149
vector149:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $149
80106979:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010697e:	e9 d0 f5 ff ff       	jmp    80105f53 <alltraps>

80106983 <vector150>:
.globl vector150
vector150:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $150
80106985:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010698a:	e9 c4 f5 ff ff       	jmp    80105f53 <alltraps>

8010698f <vector151>:
.globl vector151
vector151:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $151
80106991:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106996:	e9 b8 f5 ff ff       	jmp    80105f53 <alltraps>

8010699b <vector152>:
.globl vector152
vector152:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $152
8010699d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801069a2:	e9 ac f5 ff ff       	jmp    80105f53 <alltraps>

801069a7 <vector153>:
.globl vector153
vector153:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $153
801069a9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801069ae:	e9 a0 f5 ff ff       	jmp    80105f53 <alltraps>

801069b3 <vector154>:
.globl vector154
vector154:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $154
801069b5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801069ba:	e9 94 f5 ff ff       	jmp    80105f53 <alltraps>

801069bf <vector155>:
.globl vector155
vector155:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $155
801069c1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801069c6:	e9 88 f5 ff ff       	jmp    80105f53 <alltraps>

801069cb <vector156>:
.globl vector156
vector156:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $156
801069cd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801069d2:	e9 7c f5 ff ff       	jmp    80105f53 <alltraps>

801069d7 <vector157>:
.globl vector157
vector157:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $157
801069d9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069de:	e9 70 f5 ff ff       	jmp    80105f53 <alltraps>

801069e3 <vector158>:
.globl vector158
vector158:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $158
801069e5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801069ea:	e9 64 f5 ff ff       	jmp    80105f53 <alltraps>

801069ef <vector159>:
.globl vector159
vector159:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $159
801069f1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801069f6:	e9 58 f5 ff ff       	jmp    80105f53 <alltraps>

801069fb <vector160>:
.globl vector160
vector160:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $160
801069fd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a02:	e9 4c f5 ff ff       	jmp    80105f53 <alltraps>

80106a07 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $161
80106a09:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a0e:	e9 40 f5 ff ff       	jmp    80105f53 <alltraps>

80106a13 <vector162>:
.globl vector162
vector162:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $162
80106a15:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a1a:	e9 34 f5 ff ff       	jmp    80105f53 <alltraps>

80106a1f <vector163>:
.globl vector163
vector163:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $163
80106a21:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a26:	e9 28 f5 ff ff       	jmp    80105f53 <alltraps>

80106a2b <vector164>:
.globl vector164
vector164:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $164
80106a2d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a32:	e9 1c f5 ff ff       	jmp    80105f53 <alltraps>

80106a37 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $165
80106a39:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a3e:	e9 10 f5 ff ff       	jmp    80105f53 <alltraps>

80106a43 <vector166>:
.globl vector166
vector166:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $166
80106a45:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a4a:	e9 04 f5 ff ff       	jmp    80105f53 <alltraps>

80106a4f <vector167>:
.globl vector167
vector167:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $167
80106a51:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a56:	e9 f8 f4 ff ff       	jmp    80105f53 <alltraps>

80106a5b <vector168>:
.globl vector168
vector168:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $168
80106a5d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a62:	e9 ec f4 ff ff       	jmp    80105f53 <alltraps>

80106a67 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $169
80106a69:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a6e:	e9 e0 f4 ff ff       	jmp    80105f53 <alltraps>

80106a73 <vector170>:
.globl vector170
vector170:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $170
80106a75:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a7a:	e9 d4 f4 ff ff       	jmp    80105f53 <alltraps>

80106a7f <vector171>:
.globl vector171
vector171:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $171
80106a81:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a86:	e9 c8 f4 ff ff       	jmp    80105f53 <alltraps>

80106a8b <vector172>:
.globl vector172
vector172:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $172
80106a8d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a92:	e9 bc f4 ff ff       	jmp    80105f53 <alltraps>

80106a97 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $173
80106a99:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a9e:	e9 b0 f4 ff ff       	jmp    80105f53 <alltraps>

80106aa3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $174
80106aa5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106aaa:	e9 a4 f4 ff ff       	jmp    80105f53 <alltraps>

80106aaf <vector175>:
.globl vector175
vector175:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $175
80106ab1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ab6:	e9 98 f4 ff ff       	jmp    80105f53 <alltraps>

80106abb <vector176>:
.globl vector176
vector176:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $176
80106abd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ac2:	e9 8c f4 ff ff       	jmp    80105f53 <alltraps>

80106ac7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $177
80106ac9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106ace:	e9 80 f4 ff ff       	jmp    80105f53 <alltraps>

80106ad3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $178
80106ad5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ada:	e9 74 f4 ff ff       	jmp    80105f53 <alltraps>

80106adf <vector179>:
.globl vector179
vector179:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $179
80106ae1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ae6:	e9 68 f4 ff ff       	jmp    80105f53 <alltraps>

80106aeb <vector180>:
.globl vector180
vector180:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $180
80106aed:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106af2:	e9 5c f4 ff ff       	jmp    80105f53 <alltraps>

80106af7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $181
80106af9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106afe:	e9 50 f4 ff ff       	jmp    80105f53 <alltraps>

80106b03 <vector182>:
.globl vector182
vector182:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $182
80106b05:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b0a:	e9 44 f4 ff ff       	jmp    80105f53 <alltraps>

80106b0f <vector183>:
.globl vector183
vector183:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $183
80106b11:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b16:	e9 38 f4 ff ff       	jmp    80105f53 <alltraps>

80106b1b <vector184>:
.globl vector184
vector184:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $184
80106b1d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b22:	e9 2c f4 ff ff       	jmp    80105f53 <alltraps>

80106b27 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $185
80106b29:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b2e:	e9 20 f4 ff ff       	jmp    80105f53 <alltraps>

80106b33 <vector186>:
.globl vector186
vector186:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $186
80106b35:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b3a:	e9 14 f4 ff ff       	jmp    80105f53 <alltraps>

80106b3f <vector187>:
.globl vector187
vector187:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $187
80106b41:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b46:	e9 08 f4 ff ff       	jmp    80105f53 <alltraps>

80106b4b <vector188>:
.globl vector188
vector188:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $188
80106b4d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b52:	e9 fc f3 ff ff       	jmp    80105f53 <alltraps>

80106b57 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $189
80106b59:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b5e:	e9 f0 f3 ff ff       	jmp    80105f53 <alltraps>

80106b63 <vector190>:
.globl vector190
vector190:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $190
80106b65:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b6a:	e9 e4 f3 ff ff       	jmp    80105f53 <alltraps>

80106b6f <vector191>:
.globl vector191
vector191:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $191
80106b71:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b76:	e9 d8 f3 ff ff       	jmp    80105f53 <alltraps>

80106b7b <vector192>:
.globl vector192
vector192:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $192
80106b7d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b82:	e9 cc f3 ff ff       	jmp    80105f53 <alltraps>

80106b87 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $193
80106b89:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b8e:	e9 c0 f3 ff ff       	jmp    80105f53 <alltraps>

80106b93 <vector194>:
.globl vector194
vector194:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $194
80106b95:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b9a:	e9 b4 f3 ff ff       	jmp    80105f53 <alltraps>

80106b9f <vector195>:
.globl vector195
vector195:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $195
80106ba1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ba6:	e9 a8 f3 ff ff       	jmp    80105f53 <alltraps>

80106bab <vector196>:
.globl vector196
vector196:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $196
80106bad:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106bb2:	e9 9c f3 ff ff       	jmp    80105f53 <alltraps>

80106bb7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $197
80106bb9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106bbe:	e9 90 f3 ff ff       	jmp    80105f53 <alltraps>

80106bc3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $198
80106bc5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106bca:	e9 84 f3 ff ff       	jmp    80105f53 <alltraps>

80106bcf <vector199>:
.globl vector199
vector199:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $199
80106bd1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106bd6:	e9 78 f3 ff ff       	jmp    80105f53 <alltraps>

80106bdb <vector200>:
.globl vector200
vector200:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $200
80106bdd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106be2:	e9 6c f3 ff ff       	jmp    80105f53 <alltraps>

80106be7 <vector201>:
.globl vector201
vector201:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $201
80106be9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106bee:	e9 60 f3 ff ff       	jmp    80105f53 <alltraps>

80106bf3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $202
80106bf5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106bfa:	e9 54 f3 ff ff       	jmp    80105f53 <alltraps>

80106bff <vector203>:
.globl vector203
vector203:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $203
80106c01:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c06:	e9 48 f3 ff ff       	jmp    80105f53 <alltraps>

80106c0b <vector204>:
.globl vector204
vector204:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $204
80106c0d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c12:	e9 3c f3 ff ff       	jmp    80105f53 <alltraps>

80106c17 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $205
80106c19:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c1e:	e9 30 f3 ff ff       	jmp    80105f53 <alltraps>

80106c23 <vector206>:
.globl vector206
vector206:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $206
80106c25:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c2a:	e9 24 f3 ff ff       	jmp    80105f53 <alltraps>

80106c2f <vector207>:
.globl vector207
vector207:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $207
80106c31:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c36:	e9 18 f3 ff ff       	jmp    80105f53 <alltraps>

80106c3b <vector208>:
.globl vector208
vector208:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $208
80106c3d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c42:	e9 0c f3 ff ff       	jmp    80105f53 <alltraps>

80106c47 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $209
80106c49:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c4e:	e9 00 f3 ff ff       	jmp    80105f53 <alltraps>

80106c53 <vector210>:
.globl vector210
vector210:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $210
80106c55:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c5a:	e9 f4 f2 ff ff       	jmp    80105f53 <alltraps>

80106c5f <vector211>:
.globl vector211
vector211:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $211
80106c61:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c66:	e9 e8 f2 ff ff       	jmp    80105f53 <alltraps>

80106c6b <vector212>:
.globl vector212
vector212:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $212
80106c6d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c72:	e9 dc f2 ff ff       	jmp    80105f53 <alltraps>

80106c77 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $213
80106c79:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c7e:	e9 d0 f2 ff ff       	jmp    80105f53 <alltraps>

80106c83 <vector214>:
.globl vector214
vector214:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $214
80106c85:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c8a:	e9 c4 f2 ff ff       	jmp    80105f53 <alltraps>

80106c8f <vector215>:
.globl vector215
vector215:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $215
80106c91:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c96:	e9 b8 f2 ff ff       	jmp    80105f53 <alltraps>

80106c9b <vector216>:
.globl vector216
vector216:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $216
80106c9d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ca2:	e9 ac f2 ff ff       	jmp    80105f53 <alltraps>

80106ca7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $217
80106ca9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106cae:	e9 a0 f2 ff ff       	jmp    80105f53 <alltraps>

80106cb3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $218
80106cb5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106cba:	e9 94 f2 ff ff       	jmp    80105f53 <alltraps>

80106cbf <vector219>:
.globl vector219
vector219:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $219
80106cc1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106cc6:	e9 88 f2 ff ff       	jmp    80105f53 <alltraps>

80106ccb <vector220>:
.globl vector220
vector220:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $220
80106ccd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106cd2:	e9 7c f2 ff ff       	jmp    80105f53 <alltraps>

80106cd7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $221
80106cd9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106cde:	e9 70 f2 ff ff       	jmp    80105f53 <alltraps>

80106ce3 <vector222>:
.globl vector222
vector222:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $222
80106ce5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106cea:	e9 64 f2 ff ff       	jmp    80105f53 <alltraps>

80106cef <vector223>:
.globl vector223
vector223:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $223
80106cf1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106cf6:	e9 58 f2 ff ff       	jmp    80105f53 <alltraps>

80106cfb <vector224>:
.globl vector224
vector224:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $224
80106cfd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d02:	e9 4c f2 ff ff       	jmp    80105f53 <alltraps>

80106d07 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $225
80106d09:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d0e:	e9 40 f2 ff ff       	jmp    80105f53 <alltraps>

80106d13 <vector226>:
.globl vector226
vector226:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $226
80106d15:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d1a:	e9 34 f2 ff ff       	jmp    80105f53 <alltraps>

80106d1f <vector227>:
.globl vector227
vector227:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $227
80106d21:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d26:	e9 28 f2 ff ff       	jmp    80105f53 <alltraps>

80106d2b <vector228>:
.globl vector228
vector228:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $228
80106d2d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d32:	e9 1c f2 ff ff       	jmp    80105f53 <alltraps>

80106d37 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $229
80106d39:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d3e:	e9 10 f2 ff ff       	jmp    80105f53 <alltraps>

80106d43 <vector230>:
.globl vector230
vector230:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $230
80106d45:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d4a:	e9 04 f2 ff ff       	jmp    80105f53 <alltraps>

80106d4f <vector231>:
.globl vector231
vector231:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $231
80106d51:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d56:	e9 f8 f1 ff ff       	jmp    80105f53 <alltraps>

80106d5b <vector232>:
.globl vector232
vector232:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $232
80106d5d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d62:	e9 ec f1 ff ff       	jmp    80105f53 <alltraps>

80106d67 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $233
80106d69:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d6e:	e9 e0 f1 ff ff       	jmp    80105f53 <alltraps>

80106d73 <vector234>:
.globl vector234
vector234:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $234
80106d75:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d7a:	e9 d4 f1 ff ff       	jmp    80105f53 <alltraps>

80106d7f <vector235>:
.globl vector235
vector235:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $235
80106d81:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d86:	e9 c8 f1 ff ff       	jmp    80105f53 <alltraps>

80106d8b <vector236>:
.globl vector236
vector236:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $236
80106d8d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d92:	e9 bc f1 ff ff       	jmp    80105f53 <alltraps>

80106d97 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $237
80106d99:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d9e:	e9 b0 f1 ff ff       	jmp    80105f53 <alltraps>

80106da3 <vector238>:
.globl vector238
vector238:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $238
80106da5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106daa:	e9 a4 f1 ff ff       	jmp    80105f53 <alltraps>

80106daf <vector239>:
.globl vector239
vector239:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $239
80106db1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106db6:	e9 98 f1 ff ff       	jmp    80105f53 <alltraps>

80106dbb <vector240>:
.globl vector240
vector240:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $240
80106dbd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106dc2:	e9 8c f1 ff ff       	jmp    80105f53 <alltraps>

80106dc7 <vector241>:
.globl vector241
vector241:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $241
80106dc9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106dce:	e9 80 f1 ff ff       	jmp    80105f53 <alltraps>

80106dd3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $242
80106dd5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106dda:	e9 74 f1 ff ff       	jmp    80105f53 <alltraps>

80106ddf <vector243>:
.globl vector243
vector243:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $243
80106de1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106de6:	e9 68 f1 ff ff       	jmp    80105f53 <alltraps>

80106deb <vector244>:
.globl vector244
vector244:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $244
80106ded:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106df2:	e9 5c f1 ff ff       	jmp    80105f53 <alltraps>

80106df7 <vector245>:
.globl vector245
vector245:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $245
80106df9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106dfe:	e9 50 f1 ff ff       	jmp    80105f53 <alltraps>

80106e03 <vector246>:
.globl vector246
vector246:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $246
80106e05:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e0a:	e9 44 f1 ff ff       	jmp    80105f53 <alltraps>

80106e0f <vector247>:
.globl vector247
vector247:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $247
80106e11:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e16:	e9 38 f1 ff ff       	jmp    80105f53 <alltraps>

80106e1b <vector248>:
.globl vector248
vector248:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $248
80106e1d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e22:	e9 2c f1 ff ff       	jmp    80105f53 <alltraps>

80106e27 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $249
80106e29:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e2e:	e9 20 f1 ff ff       	jmp    80105f53 <alltraps>

80106e33 <vector250>:
.globl vector250
vector250:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $250
80106e35:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e3a:	e9 14 f1 ff ff       	jmp    80105f53 <alltraps>

80106e3f <vector251>:
.globl vector251
vector251:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $251
80106e41:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e46:	e9 08 f1 ff ff       	jmp    80105f53 <alltraps>

80106e4b <vector252>:
.globl vector252
vector252:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $252
80106e4d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e52:	e9 fc f0 ff ff       	jmp    80105f53 <alltraps>

80106e57 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $253
80106e59:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e5e:	e9 f0 f0 ff ff       	jmp    80105f53 <alltraps>

80106e63 <vector254>:
.globl vector254
vector254:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $254
80106e65:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e6a:	e9 e4 f0 ff ff       	jmp    80105f53 <alltraps>

80106e6f <vector255>:
.globl vector255
vector255:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $255
80106e71:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e76:	e9 d8 f0 ff ff       	jmp    80105f53 <alltraps>
80106e7b:	66 90                	xchg   %ax,%ax
80106e7d:	66 90                	xchg   %ax,%ax
80106e7f:	90                   	nop

80106e80 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	57                   	push   %edi
80106e84:	56                   	push   %esi
80106e85:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106e87:	c1 ea 16             	shr    $0x16,%edx
{
80106e8a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106e8b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106e8e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106e91:	8b 1f                	mov    (%edi),%ebx
80106e93:	f6 c3 01             	test   $0x1,%bl
80106e96:	74 28                	je     80106ec0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e98:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106e9e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ea4:	89 f0                	mov    %esi,%eax
}
80106ea6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106ea9:	c1 e8 0a             	shr    $0xa,%eax
80106eac:	25 fc 0f 00 00       	and    $0xffc,%eax
80106eb1:	01 d8                	add    %ebx,%eax
}
80106eb3:	5b                   	pop    %ebx
80106eb4:	5e                   	pop    %esi
80106eb5:	5f                   	pop    %edi
80106eb6:	5d                   	pop    %ebp
80106eb7:	c3                   	ret    
80106eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebf:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ec0:	85 c9                	test   %ecx,%ecx
80106ec2:	74 2c                	je     80106ef0 <walkpgdir+0x70>
80106ec4:	e8 97 b7 ff ff       	call   80102660 <kalloc>
80106ec9:	89 c3                	mov    %eax,%ebx
80106ecb:	85 c0                	test   %eax,%eax
80106ecd:	74 21                	je     80106ef0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106ecf:	83 ec 04             	sub    $0x4,%esp
80106ed2:	68 00 10 00 00       	push   $0x1000
80106ed7:	6a 00                	push   $0x0
80106ed9:	50                   	push   %eax
80106eda:	e8 a1 dd ff ff       	call   80104c80 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106edf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ee5:	83 c4 10             	add    $0x10,%esp
80106ee8:	83 c8 07             	or     $0x7,%eax
80106eeb:	89 07                	mov    %eax,(%edi)
80106eed:	eb b5                	jmp    80106ea4 <walkpgdir+0x24>
80106eef:	90                   	nop
}
80106ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ef3:	31 c0                	xor    %eax,%eax
}
80106ef5:	5b                   	pop    %ebx
80106ef6:	5e                   	pop    %esi
80106ef7:	5f                   	pop    %edi
80106ef8:	5d                   	pop    %ebp
80106ef9:	c3                   	ret    
80106efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f00 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f06:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106f0a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106f10:	89 d6                	mov    %edx,%esi
{
80106f12:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106f13:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106f19:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80106f22:	29 f0                	sub    %esi,%eax
80106f24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f27:	eb 1f                	jmp    80106f48 <mappages+0x48>
80106f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106f30:	f6 00 01             	testb  $0x1,(%eax)
80106f33:	75 45                	jne    80106f7a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106f35:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106f38:	83 cb 01             	or     $0x1,%ebx
80106f3b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106f3d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106f40:	74 2e                	je     80106f70 <mappages+0x70>
      break;
    a += PGSIZE;
80106f42:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106f48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f4b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106f50:	89 f2                	mov    %esi,%edx
80106f52:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106f55:	89 f8                	mov    %edi,%eax
80106f57:	e8 24 ff ff ff       	call   80106e80 <walkpgdir>
80106f5c:	85 c0                	test   %eax,%eax
80106f5e:	75 d0                	jne    80106f30 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106f60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f68:	5b                   	pop    %ebx
80106f69:	5e                   	pop    %esi
80106f6a:	5f                   	pop    %edi
80106f6b:	5d                   	pop    %ebp
80106f6c:	c3                   	ret    
80106f6d:	8d 76 00             	lea    0x0(%esi),%esi
80106f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f73:	31 c0                	xor    %eax,%eax
}
80106f75:	5b                   	pop    %ebx
80106f76:	5e                   	pop    %esi
80106f77:	5f                   	pop    %edi
80106f78:	5d                   	pop    %ebp
80106f79:	c3                   	ret    
      panic("remap");
80106f7a:	83 ec 0c             	sub    $0xc,%esp
80106f7d:	68 d4 81 10 80       	push   $0x801081d4
80106f82:	e8 09 94 ff ff       	call   80100390 <panic>
80106f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f8e:	66 90                	xchg   %ax,%ax

80106f90 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	89 c6                	mov    %eax,%esi
80106f97:	53                   	push   %ebx
80106f98:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106f9a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106fa0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fa6:	83 ec 1c             	sub    $0x1c,%esp
80106fa9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106fac:	39 da                	cmp    %ebx,%edx
80106fae:	73 5b                	jae    8010700b <deallocuvm.part.0+0x7b>
80106fb0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106fb3:	89 d7                	mov    %edx,%edi
80106fb5:	eb 14                	jmp    80106fcb <deallocuvm.part.0+0x3b>
80106fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fbe:	66 90                	xchg   %ax,%ax
80106fc0:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106fc6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106fc9:	76 40                	jbe    8010700b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106fcb:	31 c9                	xor    %ecx,%ecx
80106fcd:	89 fa                	mov    %edi,%edx
80106fcf:	89 f0                	mov    %esi,%eax
80106fd1:	e8 aa fe ff ff       	call   80106e80 <walkpgdir>
80106fd6:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106fd8:	85 c0                	test   %eax,%eax
80106fda:	74 44                	je     80107020 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106fdc:	8b 00                	mov    (%eax),%eax
80106fde:	a8 01                	test   $0x1,%al
80106fe0:	74 de                	je     80106fc0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106fe2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fe7:	74 47                	je     80107030 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106fe9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106fec:	05 00 00 00 80       	add    $0x80000000,%eax
80106ff1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106ff7:	50                   	push   %eax
80106ff8:	e8 a3 b4 ff ff       	call   801024a0 <kfree>
      *pte = 0;
80106ffd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107003:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107006:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107009:	77 c0                	ja     80106fcb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010700b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010700e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107011:	5b                   	pop    %ebx
80107012:	5e                   	pop    %esi
80107013:	5f                   	pop    %edi
80107014:	5d                   	pop    %ebp
80107015:	c3                   	ret    
80107016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010701d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107020:	89 fa                	mov    %edi,%edx
80107022:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107028:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010702e:	eb 96                	jmp    80106fc6 <deallocuvm.part.0+0x36>
        panic("kfree");
80107030:	83 ec 0c             	sub    $0xc,%esp
80107033:	68 26 7a 10 80       	push   $0x80107a26
80107038:	e8 53 93 ff ff       	call   80100390 <panic>
8010703d:	8d 76 00             	lea    0x0(%esi),%esi

80107040 <seginit>:
{
80107040:	f3 0f 1e fb          	endbr32 
80107044:	55                   	push   %ebp
80107045:	89 e5                	mov    %esp,%ebp
80107047:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010704a:	e8 c1 c8 ff ff       	call   80103910 <cpuid>
  pd[0] = size-1;
8010704f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107054:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010705a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010705e:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80107065:	ff 00 00 
80107068:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
8010706f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107072:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80107079:	ff 00 00 
8010707c:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80107083:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107086:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
8010708d:	ff 00 00 
80107090:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80107097:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010709a:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
801070a1:	ff 00 00 
801070a4:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
801070ab:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801070ae:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
801070b3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801070b7:	c1 e8 10             	shr    $0x10,%eax
801070ba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801070be:	8d 45 f2             	lea    -0xe(%ebp),%eax
801070c1:	0f 01 10             	lgdtl  (%eax)
}
801070c4:	c9                   	leave  
801070c5:	c3                   	ret    
801070c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070cd:	8d 76 00             	lea    0x0(%esi),%esi

801070d0 <switchkvm>:
{
801070d0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070d4:	a1 a4 aa 11 80       	mov    0x8011aaa4,%eax
801070d9:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070de:	0f 22 d8             	mov    %eax,%cr3
}
801070e1:	c3                   	ret    
801070e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070f0 <switchuvm>:
{
801070f0:	f3 0f 1e fb          	endbr32 
801070f4:	55                   	push   %ebp
801070f5:	89 e5                	mov    %esp,%ebp
801070f7:	57                   	push   %edi
801070f8:	56                   	push   %esi
801070f9:	53                   	push   %ebx
801070fa:	83 ec 1c             	sub    $0x1c,%esp
801070fd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107100:	85 f6                	test   %esi,%esi
80107102:	0f 84 cb 00 00 00    	je     801071d3 <switchuvm+0xe3>
  if(p->kstack == 0)
80107108:	8b 46 08             	mov    0x8(%esi),%eax
8010710b:	85 c0                	test   %eax,%eax
8010710d:	0f 84 da 00 00 00    	je     801071ed <switchuvm+0xfd>
  if(p->pgdir == 0)
80107113:	8b 46 04             	mov    0x4(%esi),%eax
80107116:	85 c0                	test   %eax,%eax
80107118:	0f 84 c2 00 00 00    	je     801071e0 <switchuvm+0xf0>
  pushcli();
8010711e:	e8 4d d9 ff ff       	call   80104a70 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107123:	e8 78 c7 ff ff       	call   801038a0 <mycpu>
80107128:	89 c3                	mov    %eax,%ebx
8010712a:	e8 71 c7 ff ff       	call   801038a0 <mycpu>
8010712f:	89 c7                	mov    %eax,%edi
80107131:	e8 6a c7 ff ff       	call   801038a0 <mycpu>
80107136:	83 c7 08             	add    $0x8,%edi
80107139:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010713c:	e8 5f c7 ff ff       	call   801038a0 <mycpu>
80107141:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107144:	ba 67 00 00 00       	mov    $0x67,%edx
80107149:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107150:	83 c0 08             	add    $0x8,%eax
80107153:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010715a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010715f:	83 c1 08             	add    $0x8,%ecx
80107162:	c1 e8 18             	shr    $0x18,%eax
80107165:	c1 e9 10             	shr    $0x10,%ecx
80107168:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010716e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107174:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107179:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107180:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107185:	e8 16 c7 ff ff       	call   801038a0 <mycpu>
8010718a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107191:	e8 0a c7 ff ff       	call   801038a0 <mycpu>
80107196:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010719a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010719d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071a3:	e8 f8 c6 ff ff       	call   801038a0 <mycpu>
801071a8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071ab:	e8 f0 c6 ff ff       	call   801038a0 <mycpu>
801071b0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801071b4:	b8 28 00 00 00       	mov    $0x28,%eax
801071b9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801071bc:	8b 46 04             	mov    0x4(%esi),%eax
801071bf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071c4:	0f 22 d8             	mov    %eax,%cr3
}
801071c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071ca:	5b                   	pop    %ebx
801071cb:	5e                   	pop    %esi
801071cc:	5f                   	pop    %edi
801071cd:	5d                   	pop    %ebp
  popcli();
801071ce:	e9 ed d8 ff ff       	jmp    80104ac0 <popcli>
    panic("switchuvm: no process");
801071d3:	83 ec 0c             	sub    $0xc,%esp
801071d6:	68 da 81 10 80       	push   $0x801081da
801071db:	e8 b0 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801071e0:	83 ec 0c             	sub    $0xc,%esp
801071e3:	68 05 82 10 80       	push   $0x80108205
801071e8:	e8 a3 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801071ed:	83 ec 0c             	sub    $0xc,%esp
801071f0:	68 f0 81 10 80       	push   $0x801081f0
801071f5:	e8 96 91 ff ff       	call   80100390 <panic>
801071fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107200 <inituvm>:
{
80107200:	f3 0f 1e fb          	endbr32 
80107204:	55                   	push   %ebp
80107205:	89 e5                	mov    %esp,%ebp
80107207:	57                   	push   %edi
80107208:	56                   	push   %esi
80107209:	53                   	push   %ebx
8010720a:	83 ec 1c             	sub    $0x1c,%esp
8010720d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107210:	8b 75 10             	mov    0x10(%ebp),%esi
80107213:	8b 7d 08             	mov    0x8(%ebp),%edi
80107216:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107219:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010721f:	77 4b                	ja     8010726c <inituvm+0x6c>
  mem = kalloc();
80107221:	e8 3a b4 ff ff       	call   80102660 <kalloc>
  memset(mem, 0, PGSIZE);
80107226:	83 ec 04             	sub    $0x4,%esp
80107229:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010722e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107230:	6a 00                	push   $0x0
80107232:	50                   	push   %eax
80107233:	e8 48 da ff ff       	call   80104c80 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107238:	58                   	pop    %eax
80107239:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010723f:	5a                   	pop    %edx
80107240:	6a 06                	push   $0x6
80107242:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107247:	31 d2                	xor    %edx,%edx
80107249:	50                   	push   %eax
8010724a:	89 f8                	mov    %edi,%eax
8010724c:	e8 af fc ff ff       	call   80106f00 <mappages>
  memmove(mem, init, sz);
80107251:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107254:	89 75 10             	mov    %esi,0x10(%ebp)
80107257:	83 c4 10             	add    $0x10,%esp
8010725a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010725d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107260:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107263:	5b                   	pop    %ebx
80107264:	5e                   	pop    %esi
80107265:	5f                   	pop    %edi
80107266:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107267:	e9 b4 da ff ff       	jmp    80104d20 <memmove>
    panic("inituvm: more than a page");
8010726c:	83 ec 0c             	sub    $0xc,%esp
8010726f:	68 19 82 10 80       	push   $0x80108219
80107274:	e8 17 91 ff ff       	call   80100390 <panic>
80107279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107280 <loaduvm>:
{
80107280:	f3 0f 1e fb          	endbr32 
80107284:	55                   	push   %ebp
80107285:	89 e5                	mov    %esp,%ebp
80107287:	57                   	push   %edi
80107288:	56                   	push   %esi
80107289:	53                   	push   %ebx
8010728a:	83 ec 1c             	sub    $0x1c,%esp
8010728d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107290:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107293:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107298:	0f 85 99 00 00 00    	jne    80107337 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010729e:	01 f0                	add    %esi,%eax
801072a0:	89 f3                	mov    %esi,%ebx
801072a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072a5:	8b 45 14             	mov    0x14(%ebp),%eax
801072a8:	01 f0                	add    %esi,%eax
801072aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801072ad:	85 f6                	test   %esi,%esi
801072af:	75 15                	jne    801072c6 <loaduvm+0x46>
801072b1:	eb 6d                	jmp    80107320 <loaduvm+0xa0>
801072b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072b7:	90                   	nop
801072b8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801072be:	89 f0                	mov    %esi,%eax
801072c0:	29 d8                	sub    %ebx,%eax
801072c2:	39 c6                	cmp    %eax,%esi
801072c4:	76 5a                	jbe    80107320 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801072c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801072c9:	8b 45 08             	mov    0x8(%ebp),%eax
801072cc:	31 c9                	xor    %ecx,%ecx
801072ce:	29 da                	sub    %ebx,%edx
801072d0:	e8 ab fb ff ff       	call   80106e80 <walkpgdir>
801072d5:	85 c0                	test   %eax,%eax
801072d7:	74 51                	je     8010732a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801072d9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801072de:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801072e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801072e8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801072ee:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801072f1:	29 d9                	sub    %ebx,%ecx
801072f3:	05 00 00 00 80       	add    $0x80000000,%eax
801072f8:	57                   	push   %edi
801072f9:	51                   	push   %ecx
801072fa:	50                   	push   %eax
801072fb:	ff 75 10             	pushl  0x10(%ebp)
801072fe:	e8 8d a7 ff ff       	call   80101a90 <readi>
80107303:	83 c4 10             	add    $0x10,%esp
80107306:	39 f8                	cmp    %edi,%eax
80107308:	74 ae                	je     801072b8 <loaduvm+0x38>
}
8010730a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010730d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107312:	5b                   	pop    %ebx
80107313:	5e                   	pop    %esi
80107314:	5f                   	pop    %edi
80107315:	5d                   	pop    %ebp
80107316:	c3                   	ret    
80107317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010731e:	66 90                	xchg   %ax,%ax
80107320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107323:	31 c0                	xor    %eax,%eax
}
80107325:	5b                   	pop    %ebx
80107326:	5e                   	pop    %esi
80107327:	5f                   	pop    %edi
80107328:	5d                   	pop    %ebp
80107329:	c3                   	ret    
      panic("loaduvm: address should exist");
8010732a:	83 ec 0c             	sub    $0xc,%esp
8010732d:	68 33 82 10 80       	push   $0x80108233
80107332:	e8 59 90 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107337:	83 ec 0c             	sub    $0xc,%esp
8010733a:	68 d4 82 10 80       	push   $0x801082d4
8010733f:	e8 4c 90 ff ff       	call   80100390 <panic>
80107344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010734b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010734f:	90                   	nop

80107350 <allocuvm>:
{
80107350:	f3 0f 1e fb          	endbr32 
80107354:	55                   	push   %ebp
80107355:	89 e5                	mov    %esp,%ebp
80107357:	57                   	push   %edi
80107358:	56                   	push   %esi
80107359:	53                   	push   %ebx
8010735a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010735d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107360:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107363:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107366:	85 c0                	test   %eax,%eax
80107368:	0f 88 b2 00 00 00    	js     80107420 <allocuvm+0xd0>
  if(newsz < oldsz)
8010736e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107371:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107374:	0f 82 96 00 00 00    	jb     80107410 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010737a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107380:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107386:	39 75 10             	cmp    %esi,0x10(%ebp)
80107389:	77 40                	ja     801073cb <allocuvm+0x7b>
8010738b:	e9 83 00 00 00       	jmp    80107413 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107390:	83 ec 04             	sub    $0x4,%esp
80107393:	68 00 10 00 00       	push   $0x1000
80107398:	6a 00                	push   $0x0
8010739a:	50                   	push   %eax
8010739b:	e8 e0 d8 ff ff       	call   80104c80 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801073a0:	58                   	pop    %eax
801073a1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073a7:	5a                   	pop    %edx
801073a8:	6a 06                	push   $0x6
801073aa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073af:	89 f2                	mov    %esi,%edx
801073b1:	50                   	push   %eax
801073b2:	89 f8                	mov    %edi,%eax
801073b4:	e8 47 fb ff ff       	call   80106f00 <mappages>
801073b9:	83 c4 10             	add    $0x10,%esp
801073bc:	85 c0                	test   %eax,%eax
801073be:	78 78                	js     80107438 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801073c0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073c6:	39 75 10             	cmp    %esi,0x10(%ebp)
801073c9:	76 48                	jbe    80107413 <allocuvm+0xc3>
    mem = kalloc();
801073cb:	e8 90 b2 ff ff       	call   80102660 <kalloc>
801073d0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801073d2:	85 c0                	test   %eax,%eax
801073d4:	75 ba                	jne    80107390 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801073d6:	83 ec 0c             	sub    $0xc,%esp
801073d9:	68 51 82 10 80       	push   $0x80108251
801073de:	e8 cd 92 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801073e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801073e6:	83 c4 10             	add    $0x10,%esp
801073e9:	39 45 10             	cmp    %eax,0x10(%ebp)
801073ec:	74 32                	je     80107420 <allocuvm+0xd0>
801073ee:	8b 55 10             	mov    0x10(%ebp),%edx
801073f1:	89 c1                	mov    %eax,%ecx
801073f3:	89 f8                	mov    %edi,%eax
801073f5:	e8 96 fb ff ff       	call   80106f90 <deallocuvm.part.0>
      return 0;
801073fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107401:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107404:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107407:	5b                   	pop    %ebx
80107408:	5e                   	pop    %esi
80107409:	5f                   	pop    %edi
8010740a:	5d                   	pop    %ebp
8010740b:	c3                   	ret    
8010740c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107410:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107416:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107419:	5b                   	pop    %ebx
8010741a:	5e                   	pop    %esi
8010741b:	5f                   	pop    %edi
8010741c:	5d                   	pop    %ebp
8010741d:	c3                   	ret    
8010741e:	66 90                	xchg   %ax,%ax
    return 0;
80107420:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010742a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010742d:	5b                   	pop    %ebx
8010742e:	5e                   	pop    %esi
8010742f:	5f                   	pop    %edi
80107430:	5d                   	pop    %ebp
80107431:	c3                   	ret    
80107432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107438:	83 ec 0c             	sub    $0xc,%esp
8010743b:	68 69 82 10 80       	push   $0x80108269
80107440:	e8 6b 92 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107445:	8b 45 0c             	mov    0xc(%ebp),%eax
80107448:	83 c4 10             	add    $0x10,%esp
8010744b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010744e:	74 0c                	je     8010745c <allocuvm+0x10c>
80107450:	8b 55 10             	mov    0x10(%ebp),%edx
80107453:	89 c1                	mov    %eax,%ecx
80107455:	89 f8                	mov    %edi,%eax
80107457:	e8 34 fb ff ff       	call   80106f90 <deallocuvm.part.0>
      kfree(mem);
8010745c:	83 ec 0c             	sub    $0xc,%esp
8010745f:	53                   	push   %ebx
80107460:	e8 3b b0 ff ff       	call   801024a0 <kfree>
      return 0;
80107465:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010746c:	83 c4 10             	add    $0x10,%esp
}
8010746f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107472:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107475:	5b                   	pop    %ebx
80107476:	5e                   	pop    %esi
80107477:	5f                   	pop    %edi
80107478:	5d                   	pop    %ebp
80107479:	c3                   	ret    
8010747a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107480 <deallocuvm>:
{
80107480:	f3 0f 1e fb          	endbr32 
80107484:	55                   	push   %ebp
80107485:	89 e5                	mov    %esp,%ebp
80107487:	8b 55 0c             	mov    0xc(%ebp),%edx
8010748a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010748d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107490:	39 d1                	cmp    %edx,%ecx
80107492:	73 0c                	jae    801074a0 <deallocuvm+0x20>
}
80107494:	5d                   	pop    %ebp
80107495:	e9 f6 fa ff ff       	jmp    80106f90 <deallocuvm.part.0>
8010749a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074a0:	89 d0                	mov    %edx,%eax
801074a2:	5d                   	pop    %ebp
801074a3:	c3                   	ret    
801074a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074af:	90                   	nop

801074b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801074b0:	f3 0f 1e fb          	endbr32 
801074b4:	55                   	push   %ebp
801074b5:	89 e5                	mov    %esp,%ebp
801074b7:	57                   	push   %edi
801074b8:	56                   	push   %esi
801074b9:	53                   	push   %ebx
801074ba:	83 ec 0c             	sub    $0xc,%esp
801074bd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801074c0:	85 f6                	test   %esi,%esi
801074c2:	74 55                	je     80107519 <freevm+0x69>
  if(newsz >= oldsz)
801074c4:	31 c9                	xor    %ecx,%ecx
801074c6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801074cb:	89 f0                	mov    %esi,%eax
801074cd:	89 f3                	mov    %esi,%ebx
801074cf:	e8 bc fa ff ff       	call   80106f90 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801074d4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801074da:	eb 0b                	jmp    801074e7 <freevm+0x37>
801074dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074e0:	83 c3 04             	add    $0x4,%ebx
801074e3:	39 df                	cmp    %ebx,%edi
801074e5:	74 23                	je     8010750a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801074e7:	8b 03                	mov    (%ebx),%eax
801074e9:	a8 01                	test   $0x1,%al
801074eb:	74 f3                	je     801074e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801074f2:	83 ec 0c             	sub    $0xc,%esp
801074f5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801074f8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801074fd:	50                   	push   %eax
801074fe:	e8 9d af ff ff       	call   801024a0 <kfree>
80107503:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107506:	39 df                	cmp    %ebx,%edi
80107508:	75 dd                	jne    801074e7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010750a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010750d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107510:	5b                   	pop    %ebx
80107511:	5e                   	pop    %esi
80107512:	5f                   	pop    %edi
80107513:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107514:	e9 87 af ff ff       	jmp    801024a0 <kfree>
    panic("freevm: no pgdir");
80107519:	83 ec 0c             	sub    $0xc,%esp
8010751c:	68 85 82 10 80       	push   $0x80108285
80107521:	e8 6a 8e ff ff       	call   80100390 <panic>
80107526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010752d:	8d 76 00             	lea    0x0(%esi),%esi

80107530 <setupkvm>:
{
80107530:	f3 0f 1e fb          	endbr32 
80107534:	55                   	push   %ebp
80107535:	89 e5                	mov    %esp,%ebp
80107537:	56                   	push   %esi
80107538:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107539:	e8 22 b1 ff ff       	call   80102660 <kalloc>
8010753e:	89 c6                	mov    %eax,%esi
80107540:	85 c0                	test   %eax,%eax
80107542:	74 42                	je     80107586 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107544:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107547:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010754c:	68 00 10 00 00       	push   $0x1000
80107551:	6a 00                	push   $0x0
80107553:	50                   	push   %eax
80107554:	e8 27 d7 ff ff       	call   80104c80 <memset>
80107559:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010755c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010755f:	83 ec 08             	sub    $0x8,%esp
80107562:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107565:	ff 73 0c             	pushl  0xc(%ebx)
80107568:	8b 13                	mov    (%ebx),%edx
8010756a:	50                   	push   %eax
8010756b:	29 c1                	sub    %eax,%ecx
8010756d:	89 f0                	mov    %esi,%eax
8010756f:	e8 8c f9 ff ff       	call   80106f00 <mappages>
80107574:	83 c4 10             	add    $0x10,%esp
80107577:	85 c0                	test   %eax,%eax
80107579:	78 15                	js     80107590 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010757b:	83 c3 10             	add    $0x10,%ebx
8010757e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107584:	75 d6                	jne    8010755c <setupkvm+0x2c>
}
80107586:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107589:	89 f0                	mov    %esi,%eax
8010758b:	5b                   	pop    %ebx
8010758c:	5e                   	pop    %esi
8010758d:	5d                   	pop    %ebp
8010758e:	c3                   	ret    
8010758f:	90                   	nop
      freevm(pgdir);
80107590:	83 ec 0c             	sub    $0xc,%esp
80107593:	56                   	push   %esi
      return 0;
80107594:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107596:	e8 15 ff ff ff       	call   801074b0 <freevm>
      return 0;
8010759b:	83 c4 10             	add    $0x10,%esp
}
8010759e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075a1:	89 f0                	mov    %esi,%eax
801075a3:	5b                   	pop    %ebx
801075a4:	5e                   	pop    %esi
801075a5:	5d                   	pop    %ebp
801075a6:	c3                   	ret    
801075a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ae:	66 90                	xchg   %ax,%ax

801075b0 <kvmalloc>:
{
801075b0:	f3 0f 1e fb          	endbr32 
801075b4:	55                   	push   %ebp
801075b5:	89 e5                	mov    %esp,%ebp
801075b7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801075ba:	e8 71 ff ff ff       	call   80107530 <setupkvm>
801075bf:	a3 a4 aa 11 80       	mov    %eax,0x8011aaa4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801075c4:	05 00 00 00 80       	add    $0x80000000,%eax
801075c9:	0f 22 d8             	mov    %eax,%cr3
}
801075cc:	c9                   	leave  
801075cd:	c3                   	ret    
801075ce:	66 90                	xchg   %ax,%ax

801075d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801075d0:	f3 0f 1e fb          	endbr32 
801075d4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801075d5:	31 c9                	xor    %ecx,%ecx
{
801075d7:	89 e5                	mov    %esp,%ebp
801075d9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801075dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801075df:	8b 45 08             	mov    0x8(%ebp),%eax
801075e2:	e8 99 f8 ff ff       	call   80106e80 <walkpgdir>
  if(pte == 0)
801075e7:	85 c0                	test   %eax,%eax
801075e9:	74 05                	je     801075f0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801075eb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801075ee:	c9                   	leave  
801075ef:	c3                   	ret    
    panic("clearpteu");
801075f0:	83 ec 0c             	sub    $0xc,%esp
801075f3:	68 96 82 10 80       	push   $0x80108296
801075f8:	e8 93 8d ff ff       	call   80100390 <panic>
801075fd:	8d 76 00             	lea    0x0(%esi),%esi

80107600 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107600:	f3 0f 1e fb          	endbr32 
80107604:	55                   	push   %ebp
80107605:	89 e5                	mov    %esp,%ebp
80107607:	57                   	push   %edi
80107608:	56                   	push   %esi
80107609:	53                   	push   %ebx
8010760a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010760d:	e8 1e ff ff ff       	call   80107530 <setupkvm>
80107612:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107615:	85 c0                	test   %eax,%eax
80107617:	0f 84 9b 00 00 00    	je     801076b8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010761d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107620:	85 c9                	test   %ecx,%ecx
80107622:	0f 84 90 00 00 00    	je     801076b8 <copyuvm+0xb8>
80107628:	31 f6                	xor    %esi,%esi
8010762a:	eb 46                	jmp    80107672 <copyuvm+0x72>
8010762c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107630:	83 ec 04             	sub    $0x4,%esp
80107633:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107639:	68 00 10 00 00       	push   $0x1000
8010763e:	57                   	push   %edi
8010763f:	50                   	push   %eax
80107640:	e8 db d6 ff ff       	call   80104d20 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107645:	58                   	pop    %eax
80107646:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010764c:	5a                   	pop    %edx
8010764d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107650:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107655:	89 f2                	mov    %esi,%edx
80107657:	50                   	push   %eax
80107658:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010765b:	e8 a0 f8 ff ff       	call   80106f00 <mappages>
80107660:	83 c4 10             	add    $0x10,%esp
80107663:	85 c0                	test   %eax,%eax
80107665:	78 61                	js     801076c8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107667:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010766d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107670:	76 46                	jbe    801076b8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107672:	8b 45 08             	mov    0x8(%ebp),%eax
80107675:	31 c9                	xor    %ecx,%ecx
80107677:	89 f2                	mov    %esi,%edx
80107679:	e8 02 f8 ff ff       	call   80106e80 <walkpgdir>
8010767e:	85 c0                	test   %eax,%eax
80107680:	74 61                	je     801076e3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107682:	8b 00                	mov    (%eax),%eax
80107684:	a8 01                	test   $0x1,%al
80107686:	74 4e                	je     801076d6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107688:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010768a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010768f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107692:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107698:	e8 c3 af ff ff       	call   80102660 <kalloc>
8010769d:	89 c3                	mov    %eax,%ebx
8010769f:	85 c0                	test   %eax,%eax
801076a1:	75 8d                	jne    80107630 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801076a3:	83 ec 0c             	sub    $0xc,%esp
801076a6:	ff 75 e0             	pushl  -0x20(%ebp)
801076a9:	e8 02 fe ff ff       	call   801074b0 <freevm>
  return 0;
801076ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801076b5:	83 c4 10             	add    $0x10,%esp
}
801076b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076be:	5b                   	pop    %ebx
801076bf:	5e                   	pop    %esi
801076c0:	5f                   	pop    %edi
801076c1:	5d                   	pop    %ebp
801076c2:	c3                   	ret    
801076c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076c7:	90                   	nop
      kfree(mem);
801076c8:	83 ec 0c             	sub    $0xc,%esp
801076cb:	53                   	push   %ebx
801076cc:	e8 cf ad ff ff       	call   801024a0 <kfree>
      goto bad;
801076d1:	83 c4 10             	add    $0x10,%esp
801076d4:	eb cd                	jmp    801076a3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801076d6:	83 ec 0c             	sub    $0xc,%esp
801076d9:	68 ba 82 10 80       	push   $0x801082ba
801076de:	e8 ad 8c ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801076e3:	83 ec 0c             	sub    $0xc,%esp
801076e6:	68 a0 82 10 80       	push   $0x801082a0
801076eb:	e8 a0 8c ff ff       	call   80100390 <panic>

801076f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801076f0:	f3 0f 1e fb          	endbr32 
801076f4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801076f5:	31 c9                	xor    %ecx,%ecx
{
801076f7:	89 e5                	mov    %esp,%ebp
801076f9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801076fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801076ff:	8b 45 08             	mov    0x8(%ebp),%eax
80107702:	e8 79 f7 ff ff       	call   80106e80 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107707:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107709:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010770a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010770c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107711:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107714:	05 00 00 00 80       	add    $0x80000000,%eax
80107719:	83 fa 05             	cmp    $0x5,%edx
8010771c:	ba 00 00 00 00       	mov    $0x0,%edx
80107721:	0f 45 c2             	cmovne %edx,%eax
}
80107724:	c3                   	ret    
80107725:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010772c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107730 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107730:	f3 0f 1e fb          	endbr32 
80107734:	55                   	push   %ebp
80107735:	89 e5                	mov    %esp,%ebp
80107737:	57                   	push   %edi
80107738:	56                   	push   %esi
80107739:	53                   	push   %ebx
8010773a:	83 ec 0c             	sub    $0xc,%esp
8010773d:	8b 75 14             	mov    0x14(%ebp),%esi
80107740:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107743:	85 f6                	test   %esi,%esi
80107745:	75 3c                	jne    80107783 <copyout+0x53>
80107747:	eb 67                	jmp    801077b0 <copyout+0x80>
80107749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107750:	8b 55 0c             	mov    0xc(%ebp),%edx
80107753:	89 fb                	mov    %edi,%ebx
80107755:	29 d3                	sub    %edx,%ebx
80107757:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010775d:	39 f3                	cmp    %esi,%ebx
8010775f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107762:	29 fa                	sub    %edi,%edx
80107764:	83 ec 04             	sub    $0x4,%esp
80107767:	01 c2                	add    %eax,%edx
80107769:	53                   	push   %ebx
8010776a:	ff 75 10             	pushl  0x10(%ebp)
8010776d:	52                   	push   %edx
8010776e:	e8 ad d5 ff ff       	call   80104d20 <memmove>
    len -= n;
    buf += n;
80107773:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107776:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010777c:	83 c4 10             	add    $0x10,%esp
8010777f:	29 de                	sub    %ebx,%esi
80107781:	74 2d                	je     801077b0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107783:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107785:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107788:	89 55 0c             	mov    %edx,0xc(%ebp)
8010778b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107791:	57                   	push   %edi
80107792:	ff 75 08             	pushl  0x8(%ebp)
80107795:	e8 56 ff ff ff       	call   801076f0 <uva2ka>
    if(pa0 == 0)
8010779a:	83 c4 10             	add    $0x10,%esp
8010779d:	85 c0                	test   %eax,%eax
8010779f:	75 af                	jne    80107750 <copyout+0x20>
  }
  return 0;
}
801077a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801077a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801077a9:	5b                   	pop    %ebx
801077aa:	5e                   	pop    %esi
801077ab:	5f                   	pop    %edi
801077ac:	5d                   	pop    %ebp
801077ad:	c3                   	ret    
801077ae:	66 90                	xchg   %ax,%ax
801077b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801077b3:	31 c0                	xor    %eax,%eax
}
801077b5:	5b                   	pop    %ebx
801077b6:	5e                   	pop    %esi
801077b7:	5f                   	pop    %edi
801077b8:	5d                   	pop    %ebp
801077b9:	c3                   	ret    
