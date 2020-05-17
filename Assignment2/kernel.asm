
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
80100050:	68 c0 79 10 80       	push   $0x801079c0
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 91 4b 00 00       	call   80104bf0 <initlock>
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
80100092:	68 c7 79 10 80       	push   $0x801079c7
80100097:	50                   	push   %eax
80100098:	e8 13 4a 00 00       	call   80104ab0 <initsleeplock>
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
801000e8:	e8 83 4c 00 00       	call   80104d70 <acquire>
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
80100162:	e8 c9 4c 00 00       	call   80104e30 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 49 00 00       	call   80104af0 <acquiresleep>
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
801001a3:	68 ce 79 10 80       	push   $0x801079ce
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
801001c2:	e8 c9 49 00 00       	call   80104b90 <holdingsleep>
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
801001e0:	68 df 79 10 80       	push   $0x801079df
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
80100203:	e8 88 49 00 00       	call   80104b90 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 38 49 00 00       	call   80104b50 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 4c 4b 00 00       	call   80104d70 <acquire>
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
80100270:	e9 bb 4b 00 00       	jmp    80104e30 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 e6 79 10 80       	push   $0x801079e6
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
801002b1:	e8 ba 4a 00 00       	call   80104d70 <acquire>
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
801002fa:	e8 31 36 00 00       	call   80103930 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 1d 4b 00 00       	call   80104e30 <release>
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
80100365:	e8 c6 4a 00 00       	call   80104e30 <release>
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
801003b6:	68 ed 79 10 80       	push   $0x801079ed
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 83 85 10 80 	movl   $0x80108583,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 2f 48 00 00       	call   80104c10 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 01 7a 10 80       	push   $0x80107a01
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
8010042a:	e8 91 61 00 00       	call   801065c0 <uartputc>
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
80100515:	e8 a6 60 00 00       	call   801065c0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 9a 60 00 00       	call   801065c0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 8e 60 00 00       	call   801065c0 <uartputc>
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
80100561:	e8 ba 49 00 00       	call   80104f20 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 05 49 00 00       	call   80104e80 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 05 7a 10 80       	push   $0x80107a05
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
801005c9:	0f b6 92 30 7a 10 80 	movzbl -0x7fef85d0(%edx),%edx
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
8010065f:	e8 0c 47 00 00       	call   80104d70 <acquire>
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
80100697:	e8 94 47 00 00       	call   80104e30 <release>
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
8010077d:	bb 18 7a 10 80       	mov    $0x80107a18,%ebx
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
801007bd:	e8 ae 45 00 00       	call   80104d70 <acquire>
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
80100828:	e8 03 46 00 00       	call   80104e30 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 1f 7a 10 80       	push   $0x80107a1f
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
80100877:	e8 f4 44 00 00       	call   80104d70 <acquire>
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
801009cf:	e8 5c 44 00 00       	call   80104e30 <release>
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
801009ff:	e9 4c 3c 00 00       	jmp    80104650 <procdump>
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
80100a20:	e8 eb 3a 00 00       	call   80104510 <wakeup>
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
80100a3a:	68 28 7a 10 80       	push   $0x80107a28
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 a7 41 00 00       	call   80104bf0 <initlock>

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
80100b0c:	e8 1f 6c 00 00       	call   80107730 <setupkvm>
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
80100b73:	e8 d8 69 00 00       	call   80107550 <allocuvm>
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
80100ba9:	e8 d2 68 00 00       	call   80107480 <loaduvm>
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
80100beb:	e8 c0 6a 00 00       	call   801076b0 <freevm>
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
80100c32:	e8 19 69 00 00       	call   80107550 <allocuvm>
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
80100c53:	e8 78 6b 00 00       	call   801077d0 <clearpteu>
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
80100ca3:	e8 d8 43 00 00       	call   80105080 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 c5 43 00 00       	call   80105080 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 64 6c 00 00       	call   80107930 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 ca 69 00 00       	call   801076b0 <freevm>
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
80100d33:	e8 f8 6b 00 00       	call   80107930 <copyout>
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
80100d6f:	e8 cc 42 00 00       	call   80105040 <safestrcpy>
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
80100dca:	e8 21 65 00 00       	call   801072f0 <switchuvm>
  freevm(oldpgdir);
80100dcf:	89 3c 24             	mov    %edi,(%esp)
80100dd2:	e8 d9 68 00 00       	call   801076b0 <freevm>
  return 0;
80100dd7:	83 c4 10             	add    $0x10,%esp
80100dda:	31 c0                	xor    %eax,%eax
80100ddc:	e9 0f fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100de1:	e8 ea 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de6:	83 ec 0c             	sub    $0xc,%esp
80100de9:	68 41 7a 10 80       	push   $0x80107a41
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
80100e1a:	68 4d 7a 10 80       	push   $0x80107a4d
80100e1f:	68 c0 0f 11 80       	push   $0x80110fc0
80100e24:	e8 c7 3d 00 00       	call   80104bf0 <initlock>
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
80100e45:	e8 26 3f 00 00       	call   80104d70 <acquire>
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
80100e71:	e8 ba 3f 00 00       	call   80104e30 <release>
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
80100e8a:	e8 a1 3f 00 00       	call   80104e30 <release>
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
80100eb3:	e8 b8 3e 00 00       	call   80104d70 <acquire>
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
80100ed0:	e8 5b 3f 00 00       	call   80104e30 <release>
  return f;
}
80100ed5:	89 d8                	mov    %ebx,%eax
80100ed7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eda:	c9                   	leave  
80100edb:	c3                   	ret    
    panic("filedup");
80100edc:	83 ec 0c             	sub    $0xc,%esp
80100edf:	68 54 7a 10 80       	push   $0x80107a54
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
80100f05:	e8 66 3e 00 00       	call   80104d70 <acquire>
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
80100f40:	e8 eb 3e 00 00       	call   80104e30 <release>

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
80100f6e:	e9 bd 3e 00 00       	jmp    80104e30 <release>
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
80100fbc:	68 5c 7a 10 80       	push   $0x80107a5c
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
801010aa:	68 66 7a 10 80       	push   $0x80107a66
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
80101193:	68 6f 7a 10 80       	push   $0x80107a6f
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
801011c9:	68 75 7a 10 80       	push   $0x80107a75
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
80101247:	68 7f 7a 10 80       	push   $0x80107a7f
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
80101304:	68 92 7a 10 80       	push   $0x80107a92
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
80101345:	e8 36 3b 00 00       	call   80104e80 <memset>
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
8010138a:	e8 e1 39 00 00       	call   80104d70 <acquire>
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
801013f7:	e8 34 3a 00 00       	call   80104e30 <release>

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
80101425:	e8 06 3a 00 00       	call   80104e30 <release>
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
80101452:	68 a8 7a 10 80       	push   $0x80107aa8
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
8010151b:	68 b8 7a 10 80       	push   $0x80107ab8
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
80101555:	e8 c6 39 00 00       	call   80104f20 <memmove>
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
80101580:	68 cb 7a 10 80       	push   $0x80107acb
80101585:	68 e0 19 11 80       	push   $0x801119e0
8010158a:	e8 61 36 00 00       	call   80104bf0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010158f:	83 c4 10             	add    $0x10,%esp
80101592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101598:	83 ec 08             	sub    $0x8,%esp
8010159b:	68 d2 7a 10 80       	push   $0x80107ad2
801015a0:	53                   	push   %ebx
801015a1:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015a7:	e8 04 35 00 00       	call   80104ab0 <initsleeplock>
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
801015f1:	68 38 7b 10 80       	push   $0x80107b38
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
8010168e:	e8 ed 37 00 00       	call   80104e80 <memset>
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
801016c3:	68 d8 7a 10 80       	push   $0x80107ad8
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
80101735:	e8 e6 37 00 00       	call   80104f20 <memmove>
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
80101773:	e8 f8 35 00 00       	call   80104d70 <acquire>
  ip->ref++;
80101778:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010177c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101783:	e8 a8 36 00 00       	call   80104e30 <release>
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
801017b6:	e8 35 33 00 00       	call   80104af0 <acquiresleep>
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
80101828:	e8 f3 36 00 00       	call   80104f20 <memmove>
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
8010184d:	68 f0 7a 10 80       	push   $0x80107af0
80101852:	e8 39 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101857:	83 ec 0c             	sub    $0xc,%esp
8010185a:	68 ea 7a 10 80       	push   $0x80107aea
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
80101887:	e8 04 33 00 00       	call   80104b90 <holdingsleep>
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
801018a3:	e9 a8 32 00 00       	jmp    80104b50 <releasesleep>
    panic("iunlock");
801018a8:	83 ec 0c             	sub    $0xc,%esp
801018ab:	68 ff 7a 10 80       	push   $0x80107aff
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
801018d4:	e8 17 32 00 00       	call   80104af0 <acquiresleep>
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
801018ee:	e8 5d 32 00 00       	call   80104b50 <releasesleep>
  acquire(&icache.lock);
801018f3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018fa:	e8 71 34 00 00       	call   80104d70 <acquire>
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
80101914:	e9 17 35 00 00       	jmp    80104e30 <release>
80101919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101920:	83 ec 0c             	sub    $0xc,%esp
80101923:	68 e0 19 11 80       	push   $0x801119e0
80101928:	e8 43 34 00 00       	call   80104d70 <acquire>
    int r = ip->ref;
8010192d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101930:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101937:	e8 f4 34 00 00       	call   80104e30 <release>
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
80101b37:	e8 e4 33 00 00       	call   80104f20 <memmove>
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
80101c33:	e8 e8 32 00 00       	call   80104f20 <memmove>
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
80101cd2:	e8 b9 32 00 00       	call   80104f90 <strncmp>
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
80101d35:	e8 56 32 00 00       	call   80104f90 <strncmp>
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
80101d7a:	68 19 7b 10 80       	push   $0x80107b19
80101d7f:	e8 0c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d84:	83 ec 0c             	sub    $0xc,%esp
80101d87:	68 07 7b 10 80       	push   $0x80107b07
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
80101dcc:	e8 9f 2f 00 00       	call   80104d70 <acquire>
  ip->ref++;
80101dd1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101ddc:	e8 4f 30 00 00       	call   80104e30 <release>
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
80101e47:	e8 d4 30 00 00       	call   80104f20 <memmove>
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
80101ed3:	e8 48 30 00 00       	call   80104f20 <memmove>
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
80102005:	e8 d6 2f 00 00       	call   80104fe0 <strncpy>
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
80102043:	68 28 7b 10 80       	push   $0x80107b28
80102048:	e8 43 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010204d:	83 ec 0c             	sub    $0xc,%esp
80102050:	68 6a 83 10 80       	push   $0x8010836a
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
8010215b:	68 94 7b 10 80       	push   $0x80107b94
80102160:	e8 2b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102165:	83 ec 0c             	sub    $0xc,%esp
80102168:	68 8b 7b 10 80       	push   $0x80107b8b
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
8010218a:	68 a6 7b 10 80       	push   $0x80107ba6
8010218f:	68 80 b5 10 80       	push   $0x8010b580
80102194:	e8 57 2a 00 00       	call   80104bf0 <initlock>
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
80102222:	e8 49 2b 00 00       	call   80104d70 <acquire>

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
8010227d:	e8 8e 22 00 00       	call   80104510 <wakeup>

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
8010229b:	e8 90 2b 00 00       	call   80104e30 <release>

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
801022c2:	e8 c9 28 00 00       	call   80104b90 <holdingsleep>
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
801022fc:	e8 6f 2a 00 00       	call   80104d70 <acquire>

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
80102349:	e8 02 21 00 00       	call   80104450 <sleep>
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
80102366:	e9 c5 2a 00 00       	jmp    80104e30 <release>
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
8010238a:	68 d5 7b 10 80       	push   $0x80107bd5
8010238f:	e8 fc df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102394:	83 ec 0c             	sub    $0xc,%esp
80102397:	68 c0 7b 10 80       	push   $0x80107bc0
8010239c:	e8 ef df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801023a1:	83 ec 0c             	sub    $0xc,%esp
801023a4:	68 aa 7b 10 80       	push   $0x80107baa
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
801023fe:	68 f4 7b 10 80       	push   $0x80107bf4
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
801024b6:	81 fb a8 ab 11 80    	cmp    $0x8011aba8,%ebx
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
801024d6:	e8 a5 29 00 00       	call   80104e80 <memset>

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
80102510:	e8 5b 28 00 00       	call   80104d70 <acquire>
80102515:	83 c4 10             	add    $0x10,%esp
80102518:	eb ce                	jmp    801024e8 <kfree+0x48>
8010251a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102520:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102527:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010252a:	c9                   	leave  
    release(&kmem.lock);
8010252b:	e9 00 29 00 00       	jmp    80104e30 <release>
    panic("kfree");
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 26 7c 10 80       	push   $0x80107c26
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
8010259f:	68 2c 7c 10 80       	push   $0x80107c2c
801025a4:	68 40 36 11 80       	push   $0x80113640
801025a9:	e8 42 26 00 00       	call   80104bf0 <initlock>
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
80102693:	e8 d8 26 00 00       	call   80104d70 <acquire>
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
801026c1:	e8 6a 27 00 00       	call   80104e30 <release>
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
8010270f:	0f b6 8a 60 7d 10 80 	movzbl -0x7fef82a0(%edx),%ecx
  shift ^= togglecode[data];
80102716:	0f b6 82 60 7c 10 80 	movzbl -0x7fef83a0(%edx),%eax
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
8010272f:	8b 04 85 40 7c 10 80 	mov    -0x7fef83c0(,%eax,4),%eax
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
8010276a:	0f b6 8a 60 7d 10 80 	movzbl -0x7fef82a0(%edx),%ecx
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
80102aef:	e8 dc 23 00 00       	call   80104ed0 <memcmp>
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
80102c24:	e8 f7 22 00 00       	call   80104f20 <memmove>
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
80102cce:	68 60 7e 10 80       	push   $0x80107e60
80102cd3:	68 80 36 11 80       	push   $0x80113680
80102cd8:	e8 13 1f 00 00       	call   80104bf0 <initlock>
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
80102d6f:	e8 fc 1f 00 00       	call   80104d70 <acquire>
80102d74:	83 c4 10             	add    $0x10,%esp
80102d77:	eb 1c                	jmp    80102d95 <begin_op+0x35>
80102d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d80:	83 ec 08             	sub    $0x8,%esp
80102d83:	68 80 36 11 80       	push   $0x80113680
80102d88:	68 80 36 11 80       	push   $0x80113680
80102d8d:	e8 be 16 00 00       	call   80104450 <sleep>
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
80102dc4:	e8 67 20 00 00       	call   80104e30 <release>
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
80102de2:	e8 89 1f 00 00       	call   80104d70 <acquire>
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
80102e20:	e8 0b 20 00 00       	call   80104e30 <release>
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
80102e3a:	e8 31 1f 00 00       	call   80104d70 <acquire>
    wakeup(&log);
80102e3f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102e46:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102e4d:	00 00 00 
    wakeup(&log);
80102e50:	e8 bb 16 00 00       	call   80104510 <wakeup>
    release(&log.lock);
80102e55:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102e5c:	e8 cf 1f 00 00       	call   80104e30 <release>
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
80102eb4:	e8 67 20 00 00       	call   80104f20 <memmove>
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
80102f08:	e8 03 16 00 00       	call   80104510 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102f14:	e8 17 1f 00 00       	call   80104e30 <release>
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
80102f27:	68 64 7e 10 80       	push   $0x80107e64
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
80102f82:	e8 e9 1d 00 00       	call   80104d70 <acquire>
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
80102fc5:	e9 66 1e 00 00       	jmp    80104e30 <release>
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
80102ff1:	68 73 7e 10 80       	push   $0x80107e73
80102ff6:	e8 95 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102ffb:	83 ec 0c             	sub    $0xc,%esp
80102ffe:	68 89 7e 10 80       	push   $0x80107e89
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
80103028:	68 a4 7e 10 80       	push   $0x80107ea4
8010302d:	e8 7e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103032:	e8 c9 31 00 00       	call   80106200 <idtinit>
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
8010304a:	e8 51 0e 00 00       	call   80103ea0 <scheduler>
8010304f:	90                   	nop

80103050 <mpenter>:
{
80103050:	f3 0f 1e fb          	endbr32 
80103054:	55                   	push   %ebp
80103055:	89 e5                	mov    %esp,%ebp
80103057:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010305a:	e8 71 42 00 00       	call   801072d0 <switchkvm>
  seginit();
8010305f:	e8 dc 41 00 00       	call   80107240 <seginit>
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
8010308b:	68 a8 ab 11 80       	push   $0x8011aba8
80103090:	e8 fb f4 ff ff       	call   80102590 <kinit1>
  kvmalloc();      // kernel page table
80103095:	e8 16 47 00 00       	call   801077b0 <kvmalloc>
  mpinit();        // detect other processors
8010309a:	e8 81 01 00 00       	call   80103220 <mpinit>
  lapicinit();     // interrupt controller
8010309f:	e8 2c f7 ff ff       	call   801027d0 <lapicinit>
  seginit();       // segment descriptors
801030a4:	e8 97 41 00 00       	call   80107240 <seginit>
  picinit();       // disable pic
801030a9:	e8 52 03 00 00       	call   80103400 <picinit>
  ioapicinit();    // another interrupt controller
801030ae:	e8 fd f2 ff ff       	call   801023b0 <ioapicinit>
  consoleinit();   // console hardware
801030b3:	e8 78 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801030b8:	e8 43 34 00 00       	call   80106500 <uartinit>
  pinit();         // process table
801030bd:	e8 be 07 00 00       	call   80103880 <pinit>
  tvinit();        // trap vectors
801030c2:	e8 b9 30 00 00       	call   80106180 <tvinit>
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
801030e8:	e8 33 1e 00 00       	call   80104f20 <memmove>

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
80103192:	e8 89 09 00 00       	call   80103b20 <userinit>
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
801031ce:	68 b8 7e 10 80       	push   $0x80107eb8
801031d3:	56                   	push   %esi
801031d4:	e8 f7 1c 00 00       	call   80104ed0 <memcmp>
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
8010328a:	68 bd 7e 10 80       	push   $0x80107ebd
8010328f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103290:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103293:	e8 38 1c 00 00       	call   80104ed0 <memcmp>
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
801033e3:	68 c2 7e 10 80       	push   $0x80107ec2
801033e8:	e8 a3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033ed:	83 ec 0c             	sub    $0xc,%esp
801033f0:	68 dc 7e 10 80       	push   $0x80107edc
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
80103497:	68 fb 7e 10 80       	push   $0x80107efb
8010349c:	50                   	push   %eax
8010349d:	e8 4e 17 00 00       	call   80104bf0 <initlock>
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
80103543:	e8 28 18 00 00       	call   80104d70 <acquire>
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
80103563:	e8 a8 0f 00 00       	call   80104510 <wakeup>
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
80103588:	e9 a3 18 00 00       	jmp    80104e30 <release>
8010358d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103599:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035a0:	00 00 00 
    wakeup(&p->nwrite);
801035a3:	50                   	push   %eax
801035a4:	e8 67 0f 00 00       	call   80104510 <wakeup>
801035a9:	83 c4 10             	add    $0x10,%esp
801035ac:	eb bd                	jmp    8010356b <pipeclose+0x3b>
801035ae:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	53                   	push   %ebx
801035b4:	e8 77 18 00 00       	call   80104e30 <release>
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
801035e1:	e8 8a 17 00 00       	call   80104d70 <acquire>
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
80103638:	e8 d3 0e 00 00       	call   80104510 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 0a 0e 00 00       	call   80104450 <sleep>
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
8010366c:	e8 bf 17 00 00       	call   80104e30 <release>
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
801036ba:	e8 51 0e 00 00       	call   80104510 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 69 17 00 00       	call   80104e30 <release>
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
801036ea:	e8 81 16 00 00       	call   80104d70 <acquire>
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
8010371d:	e8 2e 0d 00 00       	call   80104450 <sleep>
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
80103786:	e8 85 0d 00 00       	call   80104510 <wakeup>
  release(&p->lock);
8010378b:	89 34 24             	mov    %esi,(%esp)
8010378e:	e8 9d 16 00 00       	call   80104e30 <release>
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
801037a9:	e8 82 16 00 00       	call   80104e30 <release>
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
801037c1:	ba 60 3d 11 80       	mov    $0x80113d60,%edx
801037c6:	89 e5                	mov    %esp,%ebp
801037c8:	57                   	push   %edi
801037c9:	89 c7                	mov    %eax,%edi
  ushort ss;
  ushort padding6;
};

static inline int cas(volatile void* addr, int expected, int newval){
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
801037cb:	b8 02 00 00 00       	mov    $0x2,%eax
801037d0:	56                   	push   %esi
801037d1:	53                   	push   %ebx
801037d2:	eb 12                	jmp    801037e6 <wakeup1+0x26>
801037d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d8:	81 c2 98 01 00 00    	add    $0x198,%edx
801037de:	81 fa 60 a3 11 80    	cmp    $0x8011a360,%edx
801037e4:	74 41                	je     80103827 <wakeup1+0x67>
    if(p->chan == chan){
801037e6:	39 7a 14             	cmp    %edi,0x14(%edx)
801037e9:	75 ed                	jne    801037d8 <wakeup1+0x18>
      // int flag = 0
      while ((p->state == SLEEPING || p->state == -SLEEPING)){
801037eb:	8b 0a                	mov    (%edx),%ecx
801037ed:	be 03 00 00 00       	mov    $0x3,%esi
801037f2:	83 f9 02             	cmp    $0x2,%ecx
801037f5:	0f 94 c3             	sete   %bl
801037f8:	83 f9 fe             	cmp    $0xfffffffe,%ecx
801037fb:	0f 94 c1             	sete   %cl
801037fe:	09 cb                	or     %ecx,%ebx
80103800:	84 db                	test   %bl,%bl
80103802:	74 d4                	je     801037d8 <wakeup1+0x18>
80103804:	f0 0f b1 32          	lock cmpxchg %esi,(%edx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103808:	9c                   	pushf  
80103809:	59                   	pop    %ecx
        if (cas(&(p->state), SLEEPING, RUNNABLE)){
8010380a:	83 e1 40             	and    $0x40,%ecx
8010380d:	74 f1                	je     80103800 <wakeup1+0x40>
          p->debug = 14;
8010380f:	c7 82 88 01 00 00 0e 	movl   $0xe,0x188(%edx)
80103816:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103819:	81 c2 98 01 00 00    	add    $0x198,%edx
8010381f:	81 fa 60 a3 11 80    	cmp    $0x8011a360,%edx
80103825:	75 bf                	jne    801037e6 <wakeup1+0x26>
          break;
        }
      }
    }
}
80103827:	5b                   	pop    %ebx
80103828:	5e                   	pop    %esi
80103829:	5f                   	pop    %edi
8010382a:	5d                   	pop    %ebp
8010382b:	c3                   	ret    
8010382c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103830 <forkret>:
{
80103830:	f3 0f 1e fb          	endbr32 
80103834:	55                   	push   %ebp
80103835:	89 e5                	mov    %esp,%ebp
80103837:	83 ec 08             	sub    $0x8,%esp
  popcli();
8010383a:	e8 81 14 00 00       	call   80104cc0 <popcli>
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
8010388a:	68 00 7f 10 80       	push   $0x80107f00
8010388f:	68 20 3d 11 80       	push   $0x80113d20
80103894:	e8 57 13 00 00       	call   80104bf0 <initlock>
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
801038f0:	68 07 7f 10 80       	push   $0x80107f07
801038f5:	e8 96 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801038fa:	83 ec 0c             	sub    $0xc,%esp
801038fd:	68 08 80 10 80       	push   $0x80108008
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
8010393b:	e8 30 13 00 00       	call   80104c70 <pushcli>
  c = mycpu();
80103940:	e8 5b ff ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103945:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010394b:	e8 70 13 00 00       	call   80104cc0 <popcli>
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
8010396b:	e8 00 13 00 00       	call   80104c70 <pushcli>
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
801039aa:	e8 c1 12 00 00       	call   80104c70 <pushcli>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
801039af:	31 c0                	xor    %eax,%eax
801039b1:	b9 01 00 00 00       	mov    $0x1,%ecx
801039b6:	eb 1a                	jmp    801039d2 <allocproc+0x32>
801039b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop
    p++;
801039c0:	81 c3 98 01 00 00    	add    $0x198,%ebx
  while (p < &ptable.proc[NPROC] && !cas(&(p->state), UNUSED, EMBRYO)){
801039c6:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
801039cc:	0f 84 ce 00 00 00    	je     80103aa0 <allocproc+0x100>
801039d2:	8d 53 0c             	lea    0xc(%ebx),%edx
801039d5:	f0 0f b1 0a          	lock cmpxchg %ecx,(%edx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039d9:	9c                   	pushf  
801039da:	5a                   	pop    %edx
801039db:	83 e2 40             	and    $0x40,%edx
801039de:	74 e0                	je     801039c0 <allocproc+0x20>
  p->debug = 3;
801039e0:	c7 83 94 01 00 00 03 	movl   $0x3,0x194(%ebx)
801039e7:	00 00 00 
  popcli();
801039ea:	e8 d1 12 00 00       	call   80104cc0 <popcli>
  p->pid = allocpid();
801039ef:	e8 6c ff ff ff       	call   80103960 <allocpid>
801039f4:	89 43 10             	mov    %eax,0x10(%ebx)
  if((p->kstack = kalloc()) == 0){
801039f7:	e8 64 ec ff ff       	call   80102660 <kalloc>
801039fc:	89 43 08             	mov    %eax,0x8(%ebx)
801039ff:	89 c6                	mov    %eax,%esi
80103a01:	85 c0                	test   %eax,%eax
80103a03:	0f 84 b1 00 00 00    	je     80103aba <allocproc+0x11a>
  p->user_trapframe_backup = (struct trapframe*)kalloc();
80103a09:	e8 52 ec ff ff       	call   80102660 <kalloc>
  memset(p->context, 0, sizeof *p->context);
80103a0e:	83 ec 04             	sub    $0x4,%esp
  p->user_trapframe_backup = (struct trapframe*)kalloc();
80103a11:	89 83 90 01 00 00    	mov    %eax,0x190(%ebx)
  sp -= sizeof *p->tf;
80103a17:	8d 86 b4 0f 00 00    	lea    0xfb4(%esi),%eax
  sp -= sizeof *p->context;
80103a1d:	81 c6 9c 0f 00 00    	add    $0xf9c,%esi
  sp -= sizeof *p->tf;
80103a23:	89 43 18             	mov    %eax,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a26:	c7 46 14 6b 61 10 80 	movl   $0x8010616b,0x14(%esi)
  p->context = (struct context*)sp;
80103a2d:	89 73 1c             	mov    %esi,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a30:	6a 14                	push   $0x14
80103a32:	6a 00                	push   $0x0
80103a34:	56                   	push   %esi
80103a35:	e8 46 14 00 00       	call   80104e80 <memset>
  p->context->eip = (uint)forkret;
80103a3a:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a3d:	8d 93 90 01 00 00    	lea    0x190(%ebx),%edx
80103a43:	83 c4 10             	add    $0x10,%esp
80103a46:	c7 40 10 30 38 10 80 	movl   $0x80103830,0x10(%eax)
  p->blocked_signal_mask = 0;
80103a4d:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
80103a53:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103a5a:	00 00 00 
  p->pending_signals = 0;
80103a5d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103a64:	00 00 00 
  for (int signum = 0; signum < 32; signum++){
80103a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a6e:	66 90                	xchg   %ax,%ax
    p->signal_handlers[signum].sa_handler = SIG_DFL;
80103a70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    p->signal_handlers[signum].sigmask = 0;
80103a76:	83 c0 08             	add    $0x8,%eax
80103a79:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for (int signum = 0; signum < 32; signum++){
80103a80:	39 d0                	cmp    %edx,%eax
80103a82:	75 ec                	jne    80103a70 <allocproc+0xd0>
  p->flag_frozen = 0;
80103a84:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->flag_in_user_handler = 0;
80103a8b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103a92:	00 00 00 
}
80103a95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a98:	89 d8                	mov    %ebx,%eax
80103a9a:	5b                   	pop    %ebx
80103a9b:	5e                   	pop    %esi
80103a9c:	5d                   	pop    %ebp
80103a9d:	c3                   	ret    
80103a9e:	66 90                	xchg   %ax,%ax
  p->debug = 3;
80103aa0:	c7 05 e8 a4 11 80 03 	movl   $0x3,0x8011a4e8
80103aa7:	00 00 00 
  return 0;
80103aaa:	31 db                	xor    %ebx,%ebx
  popcli();
80103aac:	e8 0f 12 00 00       	call   80104cc0 <popcli>
}
80103ab1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ab4:	89 d8                	mov    %ebx,%eax
80103ab6:	5b                   	pop    %ebx
80103ab7:	5e                   	pop    %esi
80103ab8:	5d                   	pop    %ebp
80103ab9:	c3                   	ret    
    p->state = UNUSED;
80103aba:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103ac1:	31 db                	xor    %ebx,%ebx
80103ac3:	eb d0                	jmp    80103a95 <allocproc+0xf5>
80103ac5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ad0 <switch_state>:
void switch_state(enum procstate* state_ptr, enum procstate old, enum procstate new){
80103ad0:	f3 0f 1e fb          	endbr32 
80103ad4:	55                   	push   %ebp
80103ad5:	89 e5                	mov    %esp,%ebp
80103ad7:	57                   	push   %edi
80103ad8:	56                   	push   %esi
80103ad9:	53                   	push   %ebx
80103ada:	83 ec 0c             	sub    $0xc,%esp
80103add:	8b 75 0c             	mov    0xc(%ebp),%esi
80103ae0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103ae3:	8b 7d 10             	mov    0x10(%ebp),%edi
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103ae6:	89 f0                	mov    %esi,%eax
80103ae8:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103aec:	9c                   	pushf  
80103aed:	58                   	pop    %eax
  while (!cas(state_ptr, old, new)){
80103aee:	a8 40                	test   $0x40,%al
80103af0:	75 23                	jne    80103b15 <switch_state+0x45>
80103af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("switch has not worked from state %d to state %d, current state = %d\n", old, new, *state_ptr);
80103af8:	ff 33                	pushl  (%ebx)
80103afa:	57                   	push   %edi
80103afb:	56                   	push   %esi
80103afc:	68 30 80 10 80       	push   $0x80108030
80103b01:	e8 aa cb ff ff       	call   801006b0 <cprintf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103b06:	89 f0                	mov    %esi,%eax
80103b08:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b0c:	9c                   	pushf  
80103b0d:	58                   	pop    %eax
  while (!cas(state_ptr, old, new)){
80103b0e:	83 c4 10             	add    $0x10,%esp
80103b11:	a8 40                	test   $0x40,%al
80103b13:	74 e3                	je     80103af8 <switch_state+0x28>
}
80103b15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b18:	5b                   	pop    %ebx
80103b19:	5e                   	pop    %esi
80103b1a:	5f                   	pop    %edi
80103b1b:	5d                   	pop    %ebp
80103b1c:	c3                   	ret    
80103b1d:	8d 76 00             	lea    0x0(%esi),%esi

80103b20 <userinit>:
{
80103b20:	f3 0f 1e fb          	endbr32 
80103b24:	55                   	push   %ebp
80103b25:	89 e5                	mov    %esp,%ebp
80103b27:	53                   	push   %ebx
80103b28:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b2b:	e8 70 fe ff ff       	call   801039a0 <allocproc>
80103b30:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b32:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103b37:	e8 f4 3b 00 00       	call   80107730 <setupkvm>
80103b3c:	89 43 04             	mov    %eax,0x4(%ebx)
80103b3f:	85 c0                	test   %eax,%eax
80103b41:	0f 84 c8 00 00 00    	je     80103c0f <userinit+0xef>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b47:	83 ec 04             	sub    $0x4,%esp
80103b4a:	68 2c 00 00 00       	push   $0x2c
80103b4f:	68 60 b4 10 80       	push   $0x8010b460
80103b54:	50                   	push   %eax
80103b55:	e8 a6 38 00 00       	call   80107400 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b5a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b5d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b63:	6a 4c                	push   $0x4c
80103b65:	6a 00                	push   $0x0
80103b67:	ff 73 18             	pushl  0x18(%ebx)
80103b6a:	e8 11 13 00 00       	call   80104e80 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b6f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b72:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b77:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b7a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b7f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b83:	8b 43 18             	mov    0x18(%ebx),%eax
80103b86:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b8a:	8b 43 18             	mov    0x18(%ebx),%eax
80103b8d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b91:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b95:	8b 43 18             	mov    0x18(%ebx),%eax
80103b98:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b9c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ba0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ba3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103baa:	8b 43 18             	mov    0x18(%ebx),%eax
80103bad:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103bb4:	8b 43 18             	mov    0x18(%ebx),%eax
80103bb7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bbe:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103bc1:	6a 10                	push   $0x10
80103bc3:	68 30 7f 10 80       	push   $0x80107f30
80103bc8:	50                   	push   %eax
80103bc9:	e8 72 14 00 00       	call   80105040 <safestrcpy>
  p->cwd = namei("/");
80103bce:	c7 04 24 39 7f 10 80 	movl   $0x80107f39,(%esp)
80103bd5:	e8 86 e4 ff ff       	call   80102060 <namei>
80103bda:	89 43 68             	mov    %eax,0x68(%ebx)
  pushcli();
80103bdd:	e8 8e 10 00 00       	call   80104c70 <pushcli>
  if (!cas(&(p->state), EMBRYO, RUNNABLE)){
80103be2:	8d 53 0c             	lea    0xc(%ebx),%edx
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103be5:	b8 01 00 00 00       	mov    $0x1,%eax
80103bea:	b9 03 00 00 00       	mov    $0x3,%ecx
80103bef:	f0 0f b1 0a          	lock cmpxchg %ecx,(%edx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bf3:	9c                   	pushf  
80103bf4:	58                   	pop    %eax
80103bf5:	83 c4 10             	add    $0x10,%esp
80103bf8:	a8 40                	test   $0x40,%al
80103bfa:	74 20                	je     80103c1c <userinit+0xfc>
  p->debug = 4;
80103bfc:	c7 83 94 01 00 00 04 	movl   $0x4,0x194(%ebx)
80103c03:	00 00 00 
}
80103c06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c09:	c9                   	leave  
  popcli();
80103c0a:	e9 b1 10 00 00       	jmp    80104cc0 <popcli>
    panic("userinit: out of memory?");
80103c0f:	83 ec 0c             	sub    $0xc,%esp
80103c12:	68 17 7f 10 80       	push   $0x80107f17
80103c17:	e8 74 c7 ff ff       	call   80100390 <panic>
    panic("switch state from embryo to runnable failed in userinit");
80103c1c:	83 ec 0c             	sub    $0xc,%esp
80103c1f:	68 78 80 10 80       	push   $0x80108078
80103c24:	e8 67 c7 ff ff       	call   80100390 <panic>
80103c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c30 <growproc>:
{
80103c30:	f3 0f 1e fb          	endbr32 
80103c34:	55                   	push   %ebp
80103c35:	89 e5                	mov    %esp,%ebp
80103c37:	56                   	push   %esi
80103c38:	53                   	push   %ebx
80103c39:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c3c:	e8 2f 10 00 00       	call   80104c70 <pushcli>
  c = mycpu();
80103c41:	e8 5a fc ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103c46:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c4c:	e8 6f 10 00 00       	call   80104cc0 <popcli>
  sz = curproc->sz;
80103c51:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c53:	85 f6                	test   %esi,%esi
80103c55:	7f 19                	jg     80103c70 <growproc+0x40>
  } else if(n < 0){
80103c57:	75 37                	jne    80103c90 <growproc+0x60>
  switchuvm(curproc);
80103c59:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c5c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c5e:	53                   	push   %ebx
80103c5f:	e8 8c 36 00 00       	call   801072f0 <switchuvm>
  return 0;
80103c64:	83 c4 10             	add    $0x10,%esp
80103c67:	31 c0                	xor    %eax,%eax
}
80103c69:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c6c:	5b                   	pop    %ebx
80103c6d:	5e                   	pop    %esi
80103c6e:	5d                   	pop    %ebp
80103c6f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c70:	83 ec 04             	sub    $0x4,%esp
80103c73:	01 c6                	add    %eax,%esi
80103c75:	56                   	push   %esi
80103c76:	50                   	push   %eax
80103c77:	ff 73 04             	pushl  0x4(%ebx)
80103c7a:	e8 d1 38 00 00       	call   80107550 <allocuvm>
80103c7f:	83 c4 10             	add    $0x10,%esp
80103c82:	85 c0                	test   %eax,%eax
80103c84:	75 d3                	jne    80103c59 <growproc+0x29>
      return -1;
80103c86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c8b:	eb dc                	jmp    80103c69 <growproc+0x39>
80103c8d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c90:	83 ec 04             	sub    $0x4,%esp
80103c93:	01 c6                	add    %eax,%esi
80103c95:	56                   	push   %esi
80103c96:	50                   	push   %eax
80103c97:	ff 73 04             	pushl  0x4(%ebx)
80103c9a:	e8 e1 39 00 00       	call   80107680 <deallocuvm>
80103c9f:	83 c4 10             	add    $0x10,%esp
80103ca2:	85 c0                	test   %eax,%eax
80103ca4:	75 b3                	jne    80103c59 <growproc+0x29>
80103ca6:	eb de                	jmp    80103c86 <growproc+0x56>
80103ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103caf:	90                   	nop

80103cb0 <fork>:
{
80103cb0:	f3 0f 1e fb          	endbr32 
80103cb4:	55                   	push   %ebp
80103cb5:	89 e5                	mov    %esp,%ebp
80103cb7:	57                   	push   %edi
80103cb8:	56                   	push   %esi
80103cb9:	53                   	push   %ebx
80103cba:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103cbd:	e8 ae 0f 00 00       	call   80104c70 <pushcli>
  c = mycpu();
80103cc2:	e8 d9 fb ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103cc7:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103ccd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  popcli();
80103cd0:	e8 eb 0f 00 00       	call   80104cc0 <popcli>
  if((np = allocproc()) == 0){
80103cd5:	e8 c6 fc ff ff       	call   801039a0 <allocproc>
80103cda:	85 c0                	test   %eax,%eax
80103cdc:	0f 84 14 01 00 00    	je     80103df6 <fork+0x146>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103ce2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ce5:	83 ec 08             	sub    $0x8,%esp
80103ce8:	89 c3                	mov    %eax,%ebx
80103cea:	ff 32                	pushl  (%edx)
80103cec:	ff 72 04             	pushl  0x4(%edx)
80103cef:	e8 0c 3b 00 00       	call   80107800 <copyuvm>
80103cf4:	83 c4 10             	add    $0x10,%esp
80103cf7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103cfa:	85 c0                	test   %eax,%eax
80103cfc:	89 43 04             	mov    %eax,0x4(%ebx)
80103cff:	0f 84 f8 00 00 00    	je     80103dfd <fork+0x14d>
  np->sz = curproc->sz;
80103d05:	8b 02                	mov    (%edx),%eax
  *np->tf = *curproc->tf;
80103d07:	8b 7b 18             	mov    0x18(%ebx),%edi
  np->parent = curproc;
80103d0a:	89 53 14             	mov    %edx,0x14(%ebx)
  *np->tf = *curproc->tf;
80103d0d:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103d12:	89 03                	mov    %eax,(%ebx)
  *np->tf = *curproc->tf;
80103d14:	8b 72 18             	mov    0x18(%edx),%esi
80103d17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(signum = 0; signum < NOFILE; signum++)
80103d19:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d1b:	8b 43 18             	mov    0x18(%ebx),%eax
80103d1e:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(signum = 0; signum < NOFILE; signum++)
80103d25:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[signum])
80103d28:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103d2c:	85 c0                	test   %eax,%eax
80103d2e:	74 16                	je     80103d46 <fork+0x96>
      np->ofile[signum] = filedup(curproc->ofile[signum]);
80103d30:	83 ec 0c             	sub    $0xc,%esp
80103d33:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103d36:	50                   	push   %eax
80103d37:	e8 64 d1 ff ff       	call   80100ea0 <filedup>
80103d3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d3f:	83 c4 10             	add    $0x10,%esp
80103d42:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
  for(signum = 0; signum < NOFILE; signum++)
80103d46:	83 c6 01             	add    $0x1,%esi
80103d49:	83 fe 10             	cmp    $0x10,%esi
80103d4c:	75 da                	jne    80103d28 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103d4e:	83 ec 0c             	sub    $0xc,%esp
80103d51:	ff 72 68             	pushl  0x68(%edx)
80103d54:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103d57:	e8 04 da ff ff       	call   80101760 <idup>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d5f:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d62:	89 43 68             	mov    %eax,0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d65:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d68:	83 c2 6c             	add    $0x6c,%edx
80103d6b:	6a 10                	push   $0x10
80103d6d:	52                   	push   %edx
80103d6e:	50                   	push   %eax
80103d6f:	e8 cc 12 00 00       	call   80105040 <safestrcpy>
  pid = np->pid;
80103d74:	8b 73 10             	mov    0x10(%ebx),%esi
  pushcli();
80103d77:	e8 f4 0e 00 00       	call   80104c70 <pushcli>
  if (!cas(&(np->state), EMBRYO, RUNNABLE)){
80103d7c:	8d 53 0c             	lea    0xc(%ebx),%edx
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103d7f:	b8 01 00 00 00       	mov    $0x1,%eax
80103d84:	b9 03 00 00 00       	mov    $0x3,%ecx
80103d89:	f0 0f b1 0a          	lock cmpxchg %ecx,(%edx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d8d:	9c                   	pushf  
80103d8e:	58                   	pop    %eax
80103d8f:	83 c4 10             	add    $0x10,%esp
80103d92:	a8 40                	test   $0x40,%al
80103d94:	0f 84 86 00 00 00    	je     80103e20 <fork+0x170>
  np->debug = 5;
80103d9a:	c7 83 94 01 00 00 05 	movl   $0x5,0x194(%ebx)
80103da1:	00 00 00 
  popcli();
80103da4:	e8 17 0f 00 00       	call   80104cc0 <popcli>
  np->blocked_signal_mask = np->parent->blocked_signal_mask;
80103da9:	8b 7b 14             	mov    0x14(%ebx),%edi
  for (int signum = 0; signum < 32; signum++){
80103dac:	31 c9                	xor    %ecx,%ecx
  np->blocked_signal_mask = np->parent->blocked_signal_mask;
80103dae:	8b 87 88 00 00 00    	mov    0x88(%edi),%eax
  np->pending_signals = 0;
80103db4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103dbb:	00 00 00 
  np->blocked_signal_mask = np->parent->blocked_signal_mask;
80103dbe:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  for (int signum = 0; signum < 32; signum++){
80103dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    np->signal_handlers[signum] = np->parent->signal_handlers[signum];
80103dc8:	8b 84 cf 90 00 00 00 	mov    0x90(%edi,%ecx,8),%eax
80103dcf:	8b 94 cf 94 00 00 00 	mov    0x94(%edi,%ecx,8),%edx
80103dd6:	89 84 cb 90 00 00 00 	mov    %eax,0x90(%ebx,%ecx,8)
80103ddd:	89 94 cb 94 00 00 00 	mov    %edx,0x94(%ebx,%ecx,8)
  for (int signum = 0; signum < 32; signum++){
80103de4:	83 c1 01             	add    $0x1,%ecx
80103de7:	83 f9 20             	cmp    $0x20,%ecx
80103dea:	75 dc                	jne    80103dc8 <fork+0x118>
}
80103dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103def:	89 f0                	mov    %esi,%eax
80103df1:	5b                   	pop    %ebx
80103df2:	5e                   	pop    %esi
80103df3:	5f                   	pop    %edi
80103df4:	5d                   	pop    %ebp
80103df5:	c3                   	ret    
    return -1;
80103df6:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103dfb:	eb ef                	jmp    80103dec <fork+0x13c>
    kfree(np->kstack);
80103dfd:	83 ec 0c             	sub    $0xc,%esp
80103e00:	ff 73 08             	pushl  0x8(%ebx)
    return -1;
80103e03:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103e08:	e8 93 e6 ff ff       	call   801024a0 <kfree>
    np->kstack = 0;
80103e0d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103e14:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e17:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e1e:	eb cc                	jmp    80103dec <fork+0x13c>
    panic("process in fork not at embryo");
80103e20:	83 ec 0c             	sub    $0xc,%esp
80103e23:	68 3b 7f 10 80       	push   $0x80107f3b
80103e28:	e8 63 c5 ff ff       	call   80100390 <panic>
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi

80103e30 <has_cont_pending>:
int has_cont_pending(struct proc* p){
80103e30:	f3 0f 1e fb          	endbr32 
80103e34:	55                   	push   %ebp
    if (!((1 << i) & p->pending_signals)){
80103e35:	31 c9                	xor    %ecx,%ecx
80103e37:	ba 01 00 00 00       	mov    $0x1,%edx
int has_cont_pending(struct proc* p){
80103e3c:	89 e5                	mov    %esp,%ebp
80103e3e:	56                   	push   %esi
80103e3f:	8b 75 08             	mov    0x8(%ebp),%esi
80103e42:	53                   	push   %ebx
    if (!((1 << i) & p->pending_signals)){
80103e43:	8b 9e 84 00 00 00    	mov    0x84(%esi),%ebx
80103e49:	eb 17                	jmp    80103e62 <has_cont_pending+0x32>
80103e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e4f:	90                   	nop
    if ((int)(p->signal_handlers[i].sa_handler) == SIGCONT){
80103e50:	83 bc ce 90 00 00 00 	cmpl   $0x13,0x90(%esi,%ecx,8)
80103e57:	13 
80103e58:	74 28                	je     80103e82 <has_cont_pending+0x52>
  for (int i = 0; i < 32; i++){
80103e5a:	83 f9 1f             	cmp    $0x1f,%ecx
80103e5d:	74 31                	je     80103e90 <has_cont_pending+0x60>
80103e5f:	83 c1 01             	add    $0x1,%ecx
    if (!((1 << i) & p->pending_signals)){
80103e62:	89 d0                	mov    %edx,%eax
80103e64:	d3 e0                	shl    %cl,%eax
80103e66:	85 d8                	test   %ebx,%eax
80103e68:	74 f0                	je     80103e5a <has_cont_pending+0x2a>
    if (i == SIGCONT && p->signal_handlers[i].sa_handler == SIG_DFL){
80103e6a:	83 f9 13             	cmp    $0x13,%ecx
80103e6d:	75 e1                	jne    80103e50 <has_cont_pending+0x20>
80103e6f:	8b 86 28 01 00 00    	mov    0x128(%esi),%eax
80103e75:	85 c0                	test   %eax,%eax
80103e77:	74 09                	je     80103e82 <has_cont_pending+0x52>
    if ((int)(p->signal_handlers[i].sa_handler) == SIGCONT){
80103e79:	83 be 28 01 00 00 13 	cmpl   $0x13,0x128(%esi)
80103e80:	75 dd                	jne    80103e5f <has_cont_pending+0x2f>
}
80103e82:	5b                   	pop    %ebx
      return 1;
80103e83:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103e88:	5e                   	pop    %esi
80103e89:	5d                   	pop    %ebp
80103e8a:	c3                   	ret    
80103e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e8f:	90                   	nop
80103e90:	5b                   	pop    %ebx
  return 0;
80103e91:	31 c0                	xor    %eax,%eax
}
80103e93:	5e                   	pop    %esi
80103e94:	5d                   	pop    %ebp
80103e95:	c3                   	ret    
80103e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e9d:	8d 76 00             	lea    0x0(%esi),%esi

80103ea0 <scheduler>:
{
80103ea0:	f3 0f 1e fb          	endbr32 
80103ea4:	55                   	push   %ebp
80103ea5:	89 e5                	mov    %esp,%ebp
80103ea7:	57                   	push   %edi
80103ea8:	56                   	push   %esi
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103ea9:	be 03 00 00 00       	mov    $0x3,%esi
80103eae:	53                   	push   %ebx
80103eaf:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103eb2:	e8 e9 f9 ff ff       	call   801038a0 <mycpu>
  c->proc = 0;
80103eb7:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ebe:	00 00 00 
  struct cpu *c = mycpu();
80103ec1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c->proc = 0;
80103ec4:	83 c0 04             	add    $0x4,%eax
80103ec7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  asm volatile("sti");
80103eca:	fb                   	sti    
    pushcli();
80103ecb:	e8 a0 0d 00 00       	call   80104c70 <pushcli>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ed0:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80103ed5:	e9 ac 00 00 00       	jmp    80103f86 <scheduler+0xe6>
80103eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (!cas(&(p->state), RUNNABLE, RUNNING)){
80103ee0:	8d 7b 0c             	lea    0xc(%ebx),%edi
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103ee3:	89 f0                	mov    %esi,%eax
80103ee5:	ba 04 00 00 00       	mov    $0x4,%edx
80103eea:	f0 0f b1 17          	lock cmpxchg %edx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103eee:	9c                   	pushf  
80103eef:	58                   	pop    %eax
80103ef0:	a8 40                	test   $0x40,%al
80103ef2:	0f 84 80 00 00 00    	je     80103f78 <scheduler+0xd8>
      p->debug = 11;
80103ef8:	c7 83 94 01 00 00 0b 	movl   $0xb,0x194(%ebx)
80103eff:	00 00 00 
      c->proc = p;
80103f02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      switchuvm(p);
80103f05:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f08:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
      switchuvm(p);
80103f0e:	53                   	push   %ebx
80103f0f:	e8 dc 33 00 00       	call   801072f0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f14:	58                   	pop    %eax
80103f15:	5a                   	pop    %edx
80103f16:	ff 73 1c             	pushl  0x1c(%ebx)
80103f19:	ff 75 e0             	pushl  -0x20(%ebp)
80103f1c:	e8 82 11 00 00       	call   801050a3 <swtch>
      switchkvm();
80103f21:	e8 aa 33 00 00       	call   801072d0 <switchkvm>
      c->proc = 0;
80103f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103f29:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f30:	00 00 00 
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103f33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80103f38:	f0 0f b1 37          	lock cmpxchg %esi,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f3c:	9c                   	pushf  
80103f3d:	58                   	pop    %eax
      if (cas(&(p->state), -RUNNABLE, RUNNABLE) || cas(&(p->state), -SLEEPING, SLEEPING) || cas(&(p->state), -ZOMBIE, ZOMBIE)){
80103f3e:	83 c4 10             	add    $0x10,%esp
80103f41:	a8 40                	test   $0x40,%al
80103f43:	0f 85 97 00 00 00    	jne    80103fe0 <scheduler+0x140>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103f49:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103f4e:	ba 02 00 00 00       	mov    $0x2,%edx
80103f53:	f0 0f b1 17          	lock cmpxchg %edx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f57:	9c                   	pushf  
80103f58:	58                   	pop    %eax
80103f59:	a8 40                	test   $0x40,%al
80103f5b:	0f 85 7f 00 00 00    	jne    80103fe0 <scheduler+0x140>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103f61:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
80103f66:	ba 05 00 00 00       	mov    $0x5,%edx
80103f6b:	f0 0f b1 17          	lock cmpxchg %edx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f6f:	9c                   	pushf  
80103f70:	58                   	pop    %eax
80103f71:	a8 40                	test   $0x40,%al
80103f73:	75 6b                	jne    80103fe0 <scheduler+0x140>
80103f75:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f78:	81 c3 98 01 00 00    	add    $0x198,%ebx
80103f7e:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
80103f84:	74 72                	je     80103ff8 <scheduler+0x158>
      if (p->flag_frozen && !has_cont_pending(p)){
80103f86:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
80103f89:	85 c9                	test   %ecx,%ecx
80103f8b:	0f 84 4f ff ff ff    	je     80103ee0 <scheduler+0x40>
    if (!((1 << i) & p->pending_signals)){
80103f91:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80103f97:	31 c9                	xor    %ecx,%ecx
80103f99:	b8 01 00 00 00       	mov    $0x1,%eax
80103f9e:	eb 16                	jmp    80103fb6 <scheduler+0x116>
    if ((int)(p->signal_handlers[i].sa_handler) == SIGCONT){
80103fa0:	83 bc cb 90 00 00 00 	cmpl   $0x13,0x90(%ebx,%ecx,8)
80103fa7:	13 
80103fa8:	0f 84 32 ff ff ff    	je     80103ee0 <scheduler+0x40>
  for (int i = 0; i < 32; i++){
80103fae:	83 f9 1f             	cmp    $0x1f,%ecx
80103fb1:	74 c5                	je     80103f78 <scheduler+0xd8>
80103fb3:	83 c1 01             	add    $0x1,%ecx
    if (!((1 << i) & p->pending_signals)){
80103fb6:	89 c7                	mov    %eax,%edi
80103fb8:	d3 e7                	shl    %cl,%edi
80103fba:	85 d7                	test   %edx,%edi
80103fbc:	74 f0                	je     80103fae <scheduler+0x10e>
    if (i == SIGCONT && p->signal_handlers[i].sa_handler == SIG_DFL){
80103fbe:	83 f9 13             	cmp    $0x13,%ecx
80103fc1:	75 dd                	jne    80103fa0 <scheduler+0x100>
80103fc3:	8b bb 28 01 00 00    	mov    0x128(%ebx),%edi
80103fc9:	85 ff                	test   %edi,%edi
80103fcb:	0f 84 0f ff ff ff    	je     80103ee0 <scheduler+0x40>
    if ((int)(p->signal_handlers[i].sa_handler) == SIGCONT){
80103fd1:	83 ff 13             	cmp    $0x13,%edi
80103fd4:	75 dd                	jne    80103fb3 <scheduler+0x113>
80103fd6:	e9 05 ff ff ff       	jmp    80103ee0 <scheduler+0x40>
80103fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fdf:	90                   	nop
        p->debug = 12;
80103fe0:	c7 83 94 01 00 00 0c 	movl   $0xc,0x194(%ebx)
80103fe7:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fea:	81 c3 98 01 00 00    	add    $0x198,%ebx
80103ff0:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
80103ff6:	75 8e                	jne    80103f86 <scheduler+0xe6>
    popcli();
80103ff8:	e8 c3 0c 00 00       	call   80104cc0 <popcli>
    sti();
80103ffd:	e9 c8 fe ff ff       	jmp    80103eca <scheduler+0x2a>
80104002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104010 <sched>:
{
80104010:	f3 0f 1e fb          	endbr32 
80104014:	55                   	push   %ebp
80104015:	89 e5                	mov    %esp,%ebp
80104017:	56                   	push   %esi
80104018:	53                   	push   %ebx
  pushcli();
80104019:	e8 52 0c 00 00       	call   80104c70 <pushcli>
  c = mycpu();
8010401e:	e8 7d f8 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104023:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104029:	e8 92 0c 00 00       	call   80104cc0 <popcli>
  if((p->state == RUNNING))
8010402e:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104032:	74 3b                	je     8010406f <sched+0x5f>
80104034:	9c                   	pushf  
80104035:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104036:	f6 c4 02             	test   $0x2,%ah
80104039:	75 41                	jne    8010407c <sched+0x6c>
  intena = mycpu()->intena;
8010403b:	e8 60 f8 ff ff       	call   801038a0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104040:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104043:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104049:	e8 52 f8 ff ff       	call   801038a0 <mycpu>
8010404e:	83 ec 08             	sub    $0x8,%esp
80104051:	ff 70 04             	pushl  0x4(%eax)
80104054:	53                   	push   %ebx
80104055:	e8 49 10 00 00       	call   801050a3 <swtch>
  mycpu()->intena = intena;
8010405a:	e8 41 f8 ff ff       	call   801038a0 <mycpu>
}
8010405f:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104062:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104068:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010406b:	5b                   	pop    %ebx
8010406c:	5e                   	pop    %esi
8010406d:	5d                   	pop    %ebp
8010406e:	c3                   	ret    
    panic("sched running");
8010406f:	83 ec 0c             	sub    $0xc,%esp
80104072:	68 59 7f 10 80       	push   $0x80107f59
80104077:	e8 14 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010407c:	83 ec 0c             	sub    $0xc,%esp
8010407f:	68 67 7f 10 80       	push   $0x80107f67
80104084:	e8 07 c3 ff ff       	call   80100390 <panic>
80104089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104090 <exit>:
{
80104090:	f3 0f 1e fb          	endbr32 
80104094:	55                   	push   %ebp
80104095:	89 e5                	mov    %esp,%ebp
80104097:	57                   	push   %edi
80104098:	56                   	push   %esi
80104099:	53                   	push   %ebx
8010409a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010409d:	e8 ce 0b 00 00       	call   80104c70 <pushcli>
  c = mycpu();
801040a2:	e8 f9 f7 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
801040a7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040ad:	e8 0e 0c 00 00       	call   80104cc0 <popcli>
  if(curproc == initproc)
801040b2:	8d 5e 28             	lea    0x28(%esi),%ebx
801040b5:	8d 7e 68             	lea    0x68(%esi),%edi
801040b8:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
801040be:	0f 84 2a 01 00 00    	je     801041ee <exit+0x15e>
801040c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801040c8:	8b 03                	mov    (%ebx),%eax
801040ca:	85 c0                	test   %eax,%eax
801040cc:	74 12                	je     801040e0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801040ce:	83 ec 0c             	sub    $0xc,%esp
801040d1:	50                   	push   %eax
801040d2:	e8 19 ce ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
801040d7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801040dd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801040e0:	83 c3 04             	add    $0x4,%ebx
801040e3:	39 df                	cmp    %ebx,%edi
801040e5:	75 e1                	jne    801040c8 <exit+0x38>
  begin_op();
801040e7:	e8 74 ec ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
801040ec:	83 ec 0c             	sub    $0xc,%esp
801040ef:	ff 76 68             	pushl  0x68(%esi)
801040f2:	e8 c9 d7 ff ff       	call   801018c0 <iput>
  end_op();
801040f7:	e8 d4 ec ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
801040fc:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  pushcli();
80104103:	e8 68 0b 00 00       	call   80104c70 <pushcli>
  if (!cas(&(curproc->state), RUNNING, -ZOMBIE)){
80104108:	8d 56 0c             	lea    0xc(%esi),%edx
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
8010410b:	b8 04 00 00 00       	mov    $0x4,%eax
80104110:	b9 fb ff ff ff       	mov    $0xfffffffb,%ecx
80104115:	f0 0f b1 0a          	lock cmpxchg %ecx,(%edx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104119:	9c                   	pushf  
8010411a:	58                   	pop    %eax
8010411b:	83 c4 10             	add    $0x10,%esp
8010411e:	a8 40                	test   $0x40,%al
80104120:	0f 84 a1 00 00 00    	je     801041c7 <exit+0x137>
  curproc->debug = 6;
80104126:	c7 86 94 01 00 00 06 	movl   $0x6,0x194(%esi)
8010412d:	00 00 00 
  int has_abandoned_children = 0;;
80104130:	31 d2                	xor    %edx,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104132:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104137:	eb 15                	jmp    8010414e <exit+0xbe>
80104139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104140:	81 c3 98 01 00 00    	add    $0x198,%ebx
80104146:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
8010414c:	74 4b                	je     80104199 <exit+0x109>
    if(p->parent == curproc){
8010414e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104151:	75 ed                	jne    80104140 <exit+0xb0>
      p->parent = initproc;
80104153:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80104158:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE || p->state == -ZOMBIE){
8010415b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010415e:	83 f8 05             	cmp    $0x5,%eax
80104161:	74 5d                	je     801041c0 <exit+0x130>
80104163:	83 f8 fb             	cmp    $0xfffffffb,%eax
80104166:	75 d8                	jne    80104140 <exit+0xb0>
80104168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416f:	90                   	nop
          cprintf("in exit waiting for -zombie to change to zombie");
80104170:	83 ec 0c             	sub    $0xc,%esp
80104173:	68 10 81 10 80       	push   $0x80108110
80104178:	e8 33 c5 ff ff       	call   801006b0 <cprintf>
        while (p->state == -ZOMBIE) {
8010417d:	83 c4 10             	add    $0x10,%esp
80104180:	83 7b 0c fb          	cmpl   $0xfffffffb,0xc(%ebx)
80104184:	74 ea                	je     80104170 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104186:	81 c3 98 01 00 00    	add    $0x198,%ebx
        has_abandoned_children = 1;
8010418c:	ba 01 00 00 00       	mov    $0x1,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104191:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
80104197:	75 b5                	jne    8010414e <exit+0xbe>
  if (has_abandoned_children){
80104199:	85 d2                	test   %edx,%edx
8010419b:	75 45                	jne    801041e2 <exit+0x152>
  wakeup1(curproc->parent);
8010419d:	8b 46 14             	mov    0x14(%esi),%eax
801041a0:	e8 1b f6 ff ff       	call   801037c0 <wakeup1>
  sched();
801041a5:	e8 66 fe ff ff       	call   80104010 <sched>
  panic("zombie exit");
801041aa:	83 ec 0c             	sub    $0xc,%esp
801041ad:	68 88 7f 10 80       	push   $0x80107f88
801041b2:	e8 d9 c1 ff ff       	call   80100390 <panic>
801041b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041be:	66 90                	xchg   %ax,%ax
        while (p->state == -ZOMBIE) {
801041c0:	83 f8 fb             	cmp    $0xfffffffb,%eax
801041c3:	74 ab                	je     80104170 <exit+0xe0>
801041c5:	eb bf                	jmp    80104186 <exit+0xf6>
    cprintf("exit is not at running state, real state is %d", curproc->state);
801041c7:	50                   	push   %eax
801041c8:	50                   	push   %eax
801041c9:	ff 76 0c             	pushl  0xc(%esi)
801041cc:	68 b0 80 10 80       	push   $0x801080b0
801041d1:	e8 da c4 ff ff       	call   801006b0 <cprintf>
    panic("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
801041d6:	c7 04 24 e0 80 10 80 	movl   $0x801080e0,(%esp)
801041dd:	e8 ae c1 ff ff       	call   80100390 <panic>
    wakeup1(initproc);
801041e2:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
801041e7:	e8 d4 f5 ff ff       	call   801037c0 <wakeup1>
801041ec:	eb af                	jmp    8010419d <exit+0x10d>
    panic("init exiting");
801041ee:	83 ec 0c             	sub    $0xc,%esp
801041f1:	68 7b 7f 10 80       	push   $0x80107f7b
801041f6:	e8 95 c1 ff ff       	call   80100390 <panic>
801041fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041ff:	90                   	nop

80104200 <wait>:
{
80104200:	f3 0f 1e fb          	endbr32 
80104204:	55                   	push   %ebp
80104205:	89 e5                	mov    %esp,%ebp
80104207:	57                   	push   %edi
80104208:	56                   	push   %esi
80104209:	53                   	push   %ebx
8010420a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010420d:	e8 5e 0a 00 00       	call   80104c70 <pushcli>
  c = mycpu();
80104212:	e8 89 f6 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104217:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010421d:	e8 9e 0a 00 00       	call   80104cc0 <popcli>
  pushcli();
80104222:	e8 49 0a 00 00       	call   80104c70 <pushcli>
80104227:	8d 43 0c             	lea    0xc(%ebx),%eax
8010422a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
8010422d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80104230:	ba fe ff ff ff       	mov    $0xfffffffe,%edx
80104235:	b8 04 00 00 00       	mov    $0x4,%eax
8010423a:	f0 0f b1 16          	lock cmpxchg %edx,(%esi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010423e:	9c                   	pushf  
8010423f:	58                   	pop    %eax
    if (!cas(&(curproc->state), RUNNING, -SLEEPING) && !cas(&(curproc->state), -SLEEPING, -SLEEPING)){
80104240:	a8 40                	test   $0x40,%al
80104242:	75 10                	jne    80104254 <wait+0x54>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80104244:	89 d0                	mov    %edx,%eax
80104246:	f0 0f b1 16          	lock cmpxchg %edx,(%esi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010424a:	9c                   	pushf  
8010424b:	58                   	pop    %eax
8010424c:	a8 40                	test   $0x40,%al
8010424e:	0f 84 64 01 00 00    	je     801043b8 <wait+0x1b8>
    p->debug = 7;
80104254:	c7 05 e8 a4 11 80 07 	movl   $0x7,0x8011a4e8
8010425b:	00 00 00 
    havekids = 0;
8010425e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104260:	bf 54 3d 11 80       	mov    $0x80113d54,%edi
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80104265:	31 f6                	xor    %esi,%esi
80104267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426e:	66 90                	xchg   %ax,%ax
      if(p->parent != curproc)
80104270:	39 5f 14             	cmp    %ebx,0x14(%edi)
80104273:	74 4b                	je     801042c0 <wait+0xc0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104275:	81 c7 98 01 00 00    	add    $0x198,%edi
8010427b:	81 ff 54 a3 11 80    	cmp    $0x8011a354,%edi
80104281:	75 ed                	jne    80104270 <wait+0x70>
    if(!havekids || curproc->killed){
80104283:	85 c0                	test   %eax,%eax
80104285:	0f 84 f3 00 00 00    	je     8010437e <wait+0x17e>
8010428b:	8b 43 24             	mov    0x24(%ebx),%eax
8010428e:	85 c0                	test   %eax,%eax
80104290:	0f 85 e8 00 00 00    	jne    8010437e <wait+0x17e>
    curproc->chan = curproc;
80104296:	89 5b 20             	mov    %ebx,0x20(%ebx)
    sched();
80104299:	e8 72 fd ff ff       	call   80104010 <sched>
    curproc->chan = 0;
8010429e:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    if (!cas(&(curproc->state), RUNNING, -SLEEPING) && !cas(&(curproc->state), -SLEEPING, -SLEEPING)){
801042a5:	eb 86                	jmp    8010422d <wait+0x2d>
801042a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ae:	66 90                	xchg   %ax,%ax
        cprintf("wait is waiting for -zombie to change to zombie");
801042b0:	83 ec 0c             	sub    $0xc,%esp
801042b3:	68 6c 81 10 80       	push   $0x8010816c
801042b8:	e8 f3 c3 ff ff       	call   801006b0 <cprintf>
      while(p->state == -ZOMBIE){
801042bd:	83 c4 10             	add    $0x10,%esp
801042c0:	83 7f 0c fb          	cmpl   $0xfffffffb,0xc(%edi)
801042c4:	74 ea                	je     801042b0 <wait+0xb0>
      if(cas(&(p->state), ZOMBIE, -UNUSED)){
801042c6:	8d 4f 0c             	lea    0xc(%edi),%ecx
801042c9:	b8 05 00 00 00       	mov    $0x5,%eax
801042ce:	f0 0f b1 31          	lock cmpxchg %esi,(%ecx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042d2:	9c                   	pushf  
801042d3:	58                   	pop    %eax
801042d4:	a8 40                	test   $0x40,%al
801042d6:	75 15                	jne    801042ed <wait+0xed>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042d8:	81 c7 98 01 00 00    	add    $0x198,%edi
      havekids = 1;
801042de:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042e3:	81 ff 54 a3 11 80    	cmp    $0x8011a354,%edi
801042e9:	75 85                	jne    80104270 <wait+0x70>
801042eb:	eb 96                	jmp    80104283 <wait+0x83>
        kfree(p->kstack);
801042ed:	83 ec 0c             	sub    $0xc,%esp
801042f0:	ff 77 08             	pushl  0x8(%edi)
        pid = p->pid;
801042f3:	8b 77 10             	mov    0x10(%edi),%esi
801042f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        p->debug = 8;
801042f9:	c7 87 94 01 00 00 08 	movl   $0x8,0x194(%edi)
80104300:	00 00 00 
        kfree(p->kstack);
80104303:	e8 98 e1 ff ff       	call   801024a0 <kfree>
        freevm(p->pgdir);
80104308:	5a                   	pop    %edx
80104309:	ff 77 04             	pushl  0x4(%edi)
        p->kstack = 0;
8010430c:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
        freevm(p->pgdir);
80104313:	e8 98 33 00 00       	call   801076b0 <freevm>
        switch_state(&(p->state), -UNUSED, UNUSED);
80104318:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010431b:	83 c4 0c             	add    $0xc,%esp
        p->name[0] = 0;
8010431e:	c6 47 6c 00          	movb   $0x0,0x6c(%edi)
        switch_state(&(p->state), -UNUSED, UNUSED);
80104322:	6a 00                	push   $0x0
80104324:	6a 00                	push   $0x0
80104326:	51                   	push   %ecx
        p->pid = 0;
80104327:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
        p->parent = 0;
8010432e:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
        p->killed = 0;
80104335:	c7 47 24 00 00 00 00 	movl   $0x0,0x24(%edi)
        switch_state(&(p->state), -UNUSED, UNUSED);
8010433c:	e8 8f f7 ff ff       	call   80103ad0 <switch_state>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80104341:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104344:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
        p->debug = 1;
80104349:	c7 87 94 01 00 00 01 	movl   $0x1,0x194(%edi)
80104350:	00 00 00 
80104353:	ba 04 00 00 00       	mov    $0x4,%edx
80104358:	f0 0f b1 11          	lock cmpxchg %edx,(%ecx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010435c:	9c                   	pushf  
8010435d:	58                   	pop    %eax
        if (!cas(&(curproc->state), -SLEEPING, RUNNING)){
8010435e:	83 c4 10             	add    $0x10,%esp
80104361:	a8 40                	test   $0x40,%al
80104363:	74 46                	je     801043ab <wait+0x1ab>
        curproc->debug = 9;
80104365:	c7 83 94 01 00 00 09 	movl   $0x9,0x194(%ebx)
8010436c:	00 00 00 
        popcli();
8010436f:	e8 4c 09 00 00       	call   80104cc0 <popcli>
}
80104374:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104377:	89 f0                	mov    %esi,%eax
80104379:	5b                   	pop    %ebx
8010437a:	5e                   	pop    %esi
8010437b:	5f                   	pop    %edi
8010437c:	5d                   	pop    %ebp
8010437d:	c3                   	ret    
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
8010437e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80104381:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80104386:	ba 04 00 00 00       	mov    $0x4,%edx
8010438b:	f0 0f b1 16          	lock cmpxchg %edx,(%esi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010438f:	9c                   	pushf  
80104390:	58                   	pop    %eax
      if (!cas(&(curproc->state), -SLEEPING, RUNNING)){
80104391:	a8 40                	test   $0x40,%al
80104393:	74 16                	je     801043ab <wait+0x1ab>
      curproc->debug = 10;
80104395:	c7 83 94 01 00 00 0a 	movl   $0xa,0x194(%ebx)
8010439c:	00 00 00 
      return -1;
8010439f:	be ff ff ff ff       	mov    $0xffffffff,%esi
      popcli();
801043a4:	e8 17 09 00 00       	call   80104cc0 <popcli>
      return -1;
801043a9:	eb c9                	jmp    80104374 <wait+0x174>
          panic("unable to return to running state in wait\n");
801043ab:	83 ec 0c             	sub    $0xc,%esp
801043ae:	68 9c 81 10 80       	push   $0x8010819c
801043b3:	e8 d8 bf ff ff       	call   80100390 <panic>
      cprintf("cant change state in wait. real state = %d\n", curproc->state);
801043b8:	51                   	push   %ecx
801043b9:	51                   	push   %ecx
801043ba:	ff 73 0c             	pushl  0xc(%ebx)
801043bd:	68 40 81 10 80       	push   $0x80108140
801043c2:	e8 e9 c2 ff ff       	call   801006b0 <cprintf>
      panic("^^");
801043c7:	c7 04 24 94 7f 10 80 	movl   $0x80107f94,(%esp)
801043ce:	e8 bd bf ff ff       	call   80100390 <panic>
801043d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043e0 <yield>:
{
801043e0:	f3 0f 1e fb          	endbr32 
801043e4:	55                   	push   %ebp
801043e5:	89 e5                	mov    %esp,%ebp
801043e7:	53                   	push   %ebx
801043e8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801043eb:	e8 80 08 00 00       	call   80104c70 <pushcli>
  pushcli();
801043f0:	e8 7b 08 00 00       	call   80104c70 <pushcli>
  c = mycpu();
801043f5:	e8 a6 f4 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
801043fa:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104400:	e8 bb 08 00 00       	call   80104cc0 <popcli>
  switch_state(&(myproc()->state), RUNNING, -RUNNABLE);
80104405:	83 ec 04             	sub    $0x4,%esp
80104408:	83 c3 0c             	add    $0xc,%ebx
8010440b:	6a fd                	push   $0xfffffffd
8010440d:	6a 04                	push   $0x4
8010440f:	53                   	push   %ebx
80104410:	e8 bb f6 ff ff       	call   80103ad0 <switch_state>
  pushcli();
80104415:	e8 56 08 00 00       	call   80104c70 <pushcli>
  c = mycpu();
8010441a:	e8 81 f4 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
8010441f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104425:	e8 96 08 00 00       	call   80104cc0 <popcli>
  myproc()->debug = 2;
8010442a:	c7 83 94 01 00 00 02 	movl   $0x2,0x194(%ebx)
80104431:	00 00 00 
  sched();
80104434:	e8 d7 fb ff ff       	call   80104010 <sched>
}
80104439:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  popcli();
8010443c:	83 c4 10             	add    $0x10,%esp
}
8010443f:	c9                   	leave  
  popcli();
80104440:	e9 7b 08 00 00       	jmp    80104cc0 <popcli>
80104445:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
80104463:	e8 08 08 00 00       	call   80104c70 <pushcli>
  c = mycpu();
80104468:	e8 33 f4 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
8010446d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104473:	e8 48 08 00 00       	call   80104cc0 <popcli>
  if(p == 0)
80104478:	85 db                	test   %ebx,%ebx
8010447a:	0f 84 83 00 00 00    	je     80104503 <sleep+0xb3>
  if(lk != null){  //DOC: sleeplock0
80104480:	85 f6                	test   %esi,%esi
80104482:	74 11                	je     80104495 <sleep+0x45>
    pushcli();
80104484:	e8 e7 07 00 00       	call   80104c70 <pushcli>
    release(lk);
80104489:	83 ec 0c             	sub    $0xc,%esp
8010448c:	56                   	push   %esi
8010448d:	e8 9e 09 00 00       	call   80104e30 <release>
80104492:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
80104495:	89 7b 20             	mov    %edi,0x20(%ebx)
  if (!cas(&(p->state), RUNNING, -SLEEPING)){
80104498:	8d 53 0c             	lea    0xc(%ebx),%edx
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
8010449b:	b8 04 00 00 00       	mov    $0x4,%eax
801044a0:	b9 fe ff ff ff       	mov    $0xfffffffe,%ecx
801044a5:	f0 0f b1 0a          	lock cmpxchg %ecx,(%edx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044a9:	9c                   	pushf  
801044aa:	58                   	pop    %eax
801044ab:	a8 40                	test   $0x40,%al
801044ad:	74 39                	je     801044e8 <sleep+0x98>
  p->debug = 13;
801044af:	c7 83 94 01 00 00 0d 	movl   $0xd,0x194(%ebx)
801044b6:	00 00 00 
  sched();
801044b9:	e8 52 fb ff ff       	call   80104010 <sched>
  p->chan = 0;
801044be:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != null){  //DOC: sleeplock2
801044c5:	85 f6                	test   %esi,%esi
801044c7:	74 17                	je     801044e0 <sleep+0x90>
    popcli();
801044c9:	e8 f2 07 00 00       	call   80104cc0 <popcli>
    acquire(lk);
801044ce:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044d4:	5b                   	pop    %ebx
801044d5:	5e                   	pop    %esi
801044d6:	5f                   	pop    %edi
801044d7:	5d                   	pop    %ebp
    acquire(lk);
801044d8:	e9 93 08 00 00       	jmp    80104d70 <acquire>
801044dd:	8d 76 00             	lea    0x0(%esi),%esi
}
801044e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044e3:	5b                   	pop    %ebx
801044e4:	5e                   	pop    %esi
801044e5:	5f                   	pop    %edi
801044e6:	5d                   	pop    %ebp
801044e7:	c3                   	ret    
    cprintf("real state = %d\n", p->state);
801044e8:	50                   	push   %eax
801044e9:	50                   	push   %eax
801044ea:	ff 73 0c             	pushl  0xc(%ebx)
801044ed:	68 9d 7f 10 80       	push   $0x80107f9d
801044f2:	e8 b9 c1 ff ff       	call   801006b0 <cprintf>
    panic("sleep change state failed");
801044f7:	c7 04 24 ae 7f 10 80 	movl   $0x80107fae,(%esp)
801044fe:	e8 8d be ff ff       	call   80100390 <panic>
    panic("sleep");
80104503:	83 ec 0c             	sub    $0xc,%esp
80104506:	68 97 7f 10 80       	push   $0x80107f97
8010450b:	e8 80 be ff ff       	call   80100390 <panic>

80104510 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104510:	f3 0f 1e fb          	endbr32 
80104514:	55                   	push   %ebp
80104515:	89 e5                	mov    %esp,%ebp
80104517:	53                   	push   %ebx
80104518:	83 ec 04             	sub    $0x4,%esp
8010451b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // possible bug
  // acquire(&ptable.lock);
  pushcli();
8010451e:	e8 4d 07 00 00       	call   80104c70 <pushcli>
  wakeup1(chan);
80104523:	89 d8                	mov    %ebx,%eax
80104525:	e8 96 f2 ff ff       	call   801037c0 <wakeup1>
  popcli();
  // release(&ptable.lock);
}
8010452a:	83 c4 04             	add    $0x4,%esp
8010452d:	5b                   	pop    %ebx
8010452e:	5d                   	pop    %ebp
  popcli();
8010452f:	e9 8c 07 00 00       	jmp    80104cc0 <popcli>
80104534:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010453b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010453f:	90                   	nop

80104540 <is_blocked>:

int is_blocked(uint mask, int signum){
80104540:	f3 0f 1e fb          	endbr32 
80104544:	55                   	push   %ebp
  return (mask & (1 << signum));
80104545:	b8 01 00 00 00       	mov    $0x1,%eax
int is_blocked(uint mask, int signum){
8010454a:	89 e5                	mov    %esp,%ebp
  return (mask & (1 << signum));
8010454c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010454f:	d3 e0                	shl    %cl,%eax
80104551:	23 45 08             	and    0x8(%ebp),%eax
}
80104554:	5d                   	pop    %ebp
80104555:	c3                   	ret    
80104556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455d:	8d 76 00             	lea    0x0(%esi),%esi

80104560 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid, int signum)
{
80104560:	f3 0f 1e fb          	endbr32 
80104564:	55                   	push   %ebp
80104565:	89 e5                	mov    %esp,%ebp
80104567:	57                   	push   %edi
80104568:	56                   	push   %esi
80104569:	53                   	push   %ebx
8010456a:	83 ec 0c             	sub    $0xc,%esp
8010456d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104570:	8b 75 08             	mov    0x8(%ebp),%esi
  if (signum < 0 || signum > 31){
80104573:	83 ff 1f             	cmp    $0x1f,%edi
80104576:	0f 87 be 00 00 00    	ja     8010463a <kill+0xda>
    return -1;
  }
  struct proc *p;
  // acquire(&ptable.lock);
  pushcli();
8010457c:	e8 ef 06 00 00       	call   80104c70 <pushcli>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104581:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104586:	eb 1a                	jmp    801045a2 <kill+0x42>
80104588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010458f:	90                   	nop
80104590:	81 c3 98 01 00 00    	add    $0x198,%ebx
80104596:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
8010459c:	0f 84 86 00 00 00    	je     80104628 <kill+0xc8>
    if(p->pid == pid){
801045a2:	39 73 10             	cmp    %esi,0x10(%ebx)
801045a5:	75 e9                	jne    80104590 <kill+0x30>
      if ((((int)(p->signal_handlers[signum].sa_handler) == SIGKILL && !is_blocked(p->blocked_signal_mask, signum)) || signum == SIGKILL || signum == SIGSTOP)){
801045a7:	be 01 00 00 00       	mov    $0x1,%esi
801045ac:	89 f9                	mov    %edi,%ecx
801045ae:	d3 e6                	shl    %cl,%esi
801045b0:	83 bc fb 90 00 00 00 	cmpl   $0x9,0x90(%ebx,%edi,8)
801045b7:	09 
801045b8:	74 5e                	je     80104618 <kill+0xb8>
801045ba:	83 ef 09             	sub    $0x9,%edi
801045bd:	83 e7 f7             	and    $0xfffffff7,%edi
801045c0:	74 2e                	je     801045f0 <kill+0x90>
          cprintf("kill waiting for -sleeping to change to sleeping");
        }
        cas(&(p->state), SLEEPING, RUNNABLE);
        p->debug = 15;
      }
      p->pending_signals = p->pending_signals | (1 << signum);
801045c2:	09 b3 84 00 00 00    	or     %esi,0x84(%ebx)
      // release(&ptable.lock);
      popcli();
801045c8:	e8 f3 06 00 00       	call   80104cc0 <popcli>
      return 0;
801045cd:	31 c0                	xor    %eax,%eax
    }
  }
  // release(&ptable.lock);
  popcli();
  return -1;
}
801045cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045d2:	5b                   	pop    %ebx
801045d3:	5e                   	pop    %esi
801045d4:	5f                   	pop    %edi
801045d5:	5d                   	pop    %ebp
801045d6:	c3                   	ret    
801045d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045de:	66 90                	xchg   %ax,%ax
          cprintf("kill waiting for -sleeping to change to sleeping");
801045e0:	83 ec 0c             	sub    $0xc,%esp
801045e3:	68 c8 81 10 80       	push   $0x801081c8
801045e8:	e8 c3 c0 ff ff       	call   801006b0 <cprintf>
        while(p->state == -SLEEPING){
801045ed:	83 c4 10             	add    $0x10,%esp
801045f0:	83 7b 0c fe          	cmpl   $0xfffffffe,0xc(%ebx)
801045f4:	74 ea                	je     801045e0 <kill+0x80>
        cas(&(p->state), SLEEPING, RUNNABLE);
801045f6:	8d 53 0c             	lea    0xc(%ebx),%edx
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
801045f9:	b8 02 00 00 00       	mov    $0x2,%eax
801045fe:	b9 03 00 00 00       	mov    $0x3,%ecx
80104603:	f0 0f b1 0a          	lock cmpxchg %ecx,(%edx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104607:	9c                   	pushf  
80104608:	58                   	pop    %eax
        p->debug = 15;
80104609:	c7 83 94 01 00 00 0f 	movl   $0xf,0x194(%ebx)
80104610:	00 00 00 
80104613:	eb ad                	jmp    801045c2 <kill+0x62>
80104615:	8d 76 00             	lea    0x0(%esi),%esi
      if ((((int)(p->signal_handlers[signum].sa_handler) == SIGKILL && !is_blocked(p->blocked_signal_mask, signum)) || signum == SIGKILL || signum == SIGSTOP)){
80104618:	85 b3 88 00 00 00    	test   %esi,0x88(%ebx)
8010461e:	75 9a                	jne    801045ba <kill+0x5a>
80104620:	eb ce                	jmp    801045f0 <kill+0x90>
80104622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  popcli();
80104628:	e8 93 06 00 00       	call   80104cc0 <popcli>
}
8010462d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104635:	5b                   	pop    %ebx
80104636:	5e                   	pop    %esi
80104637:	5f                   	pop    %edi
80104638:	5d                   	pop    %ebp
80104639:	c3                   	ret    
    return -1;
8010463a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010463f:	eb 8e                	jmp    801045cf <kill+0x6f>
80104641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010464f:	90                   	nop

80104650 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104650:	f3 0f 1e fb          	endbr32 
80104654:	55                   	push   %ebp
80104655:	89 e5                	mov    %esp,%ebp
80104657:	57                   	push   %edi
80104658:	56                   	push   %esi
80104659:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010465c:	53                   	push   %ebx
8010465d:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
80104662:	83 ec 3c             	sub    $0x3c,%esp
80104665:	eb 2b                	jmp    80104692 <procdump+0x42>
80104667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010466e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(signum=0; signum<10 && pc[signum] != 0; signum++)
        cprintf(" %p", pc[signum]);
    }
    cprintf("\n");
80104670:	83 ec 0c             	sub    $0xc,%esp
80104673:	68 83 85 10 80       	push   $0x80108583
80104678:	e8 33 c0 ff ff       	call   801006b0 <cprintf>
8010467d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104680:	81 c3 98 01 00 00    	add    $0x198,%ebx
80104686:	81 fb c0 a3 11 80    	cmp    $0x8011a3c0,%ebx
8010468c:	0f 84 8e 00 00 00    	je     80104720 <procdump+0xd0>
    if((p->state == UNUSED) || (p->state == -UNUSED))
80104692:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104695:	85 c0                	test   %eax,%eax
80104697:	74 e7                	je     80104680 <procdump+0x30>
      state = "???";
80104699:	ba c8 7f 10 80       	mov    $0x80107fc8,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010469e:	83 f8 05             	cmp    $0x5,%eax
801046a1:	77 11                	ja     801046b4 <procdump+0x64>
801046a3:	8b 14 85 70 82 10 80 	mov    -0x7fef7d90(,%eax,4),%edx
      state = "???";
801046aa:	b8 c8 7f 10 80       	mov    $0x80107fc8,%eax
801046af:	85 d2                	test   %edx,%edx
801046b1:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801046b4:	53                   	push   %ebx
801046b5:	52                   	push   %edx
801046b6:	ff 73 a4             	pushl  -0x5c(%ebx)
801046b9:	68 cc 7f 10 80       	push   $0x80107fcc
801046be:	e8 ed bf ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801046c3:	83 c4 10             	add    $0x10,%esp
801046c6:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801046ca:	75 a4                	jne    80104670 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801046cc:	83 ec 08             	sub    $0x8,%esp
801046cf:	8d 45 c0             	lea    -0x40(%ebp),%eax
801046d2:	8d 7d c0             	lea    -0x40(%ebp),%edi
801046d5:	50                   	push   %eax
801046d6:	8b 43 b0             	mov    -0x50(%ebx),%eax
801046d9:	8b 40 0c             	mov    0xc(%eax),%eax
801046dc:	83 c0 08             	add    $0x8,%eax
801046df:	50                   	push   %eax
801046e0:	e8 2b 05 00 00       	call   80104c10 <getcallerpcs>
      for(signum=0; signum<10 && pc[signum] != 0; signum++)
801046e5:	83 c4 10             	add    $0x10,%esp
801046e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ef:	90                   	nop
801046f0:	8b 17                	mov    (%edi),%edx
801046f2:	85 d2                	test   %edx,%edx
801046f4:	0f 84 76 ff ff ff    	je     80104670 <procdump+0x20>
        cprintf(" %p", pc[signum]);
801046fa:	83 ec 08             	sub    $0x8,%esp
801046fd:	83 c7 04             	add    $0x4,%edi
80104700:	52                   	push   %edx
80104701:	68 01 7a 10 80       	push   $0x80107a01
80104706:	e8 a5 bf ff ff       	call   801006b0 <cprintf>
      for(signum=0; signum<10 && pc[signum] != 0; signum++)
8010470b:	83 c4 10             	add    $0x10,%esp
8010470e:	39 fe                	cmp    %edi,%esi
80104710:	75 de                	jne    801046f0 <procdump+0xa0>
80104712:	e9 59 ff ff ff       	jmp    80104670 <procdump+0x20>
80104717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471e:	66 90                	xchg   %ax,%ax
  }
}
80104720:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104723:	5b                   	pop    %ebx
80104724:	5e                   	pop    %esi
80104725:	5f                   	pop    %edi
80104726:	5d                   	pop    %ebp
80104727:	c3                   	ret    
80104728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472f:	90                   	nop

80104730 <sigprocmask>:

uint sigprocmask(uint sigmask){
80104730:	f3 0f 1e fb          	endbr32 
80104734:	55                   	push   %ebp
80104735:	89 e5                	mov    %esp,%ebp
80104737:	56                   	push   %esi
80104738:	53                   	push   %ebx
  pushcli();
80104739:	e8 32 05 00 00       	call   80104c70 <pushcli>
  c = mycpu();
8010473e:	e8 5d f1 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104743:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104749:	e8 72 05 00 00       	call   80104cc0 <popcli>
  uint temp = myproc()->blocked_signal_mask;
8010474e:	8b 9b 88 00 00 00    	mov    0x88(%ebx),%ebx
  pushcli();
80104754:	e8 17 05 00 00       	call   80104c70 <pushcli>
  c = mycpu();
80104759:	e8 42 f1 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
8010475e:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104764:	e8 57 05 00 00       	call   80104cc0 <popcli>
  // Ignoring kill, stop, cont signals
  uint kill_mask = 1 << SIGKILL;
  uint cont_mask = 1 << SIGCONT;
  uint stop_mask = 1 << SIGSTOP;
  myproc()->blocked_signal_mask = sigmask & ~(kill_mask | stop_mask | cont_mask);
80104769:	8b 45 08             	mov    0x8(%ebp),%eax
8010476c:	25 ff fd f5 ff       	and    $0xfff5fdff,%eax
80104771:	89 86 88 00 00 00    	mov    %eax,0x88(%esi)
  return temp;
}
80104777:	89 d8                	mov    %ebx,%eax
80104779:	5b                   	pop    %ebx
8010477a:	5e                   	pop    %esi
8010477b:	5d                   	pop    %ebp
8010477c:	c3                   	ret    
8010477d:	8d 76 00             	lea    0x0(%esi),%esi

80104780 <sigaction>:

int sigaction(int signum, const struct sigaction* act, struct sigaction* oldact){
80104780:	f3 0f 1e fb          	endbr32 
80104784:	55                   	push   %ebp
80104785:	89 e5                	mov    %esp,%ebp
80104787:	57                   	push   %edi
80104788:	56                   	push   %esi
80104789:	53                   	push   %ebx
8010478a:	83 ec 0c             	sub    $0xc,%esp
8010478d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104790:	8b 5d 10             	mov    0x10(%ebp),%ebx
  // make sure SIGCONT also here
  if (signum == SIGKILL || signum == SIGSTOP || signum == SIGCONT){
80104793:	89 f8                	mov    %edi,%eax
80104795:	83 e0 fd             	and    $0xfffffffd,%eax
80104798:	83 f8 11             	cmp    $0x11,%eax
8010479b:	74 53                	je     801047f0 <sigaction+0x70>
8010479d:	83 ff 09             	cmp    $0x9,%edi
801047a0:	74 4e                	je     801047f0 <sigaction+0x70>
    return -1;
  }
  if (signum < 0 || signum > 31){
801047a2:	83 ff 1f             	cmp    $0x1f,%edi
801047a5:	77 49                	ja     801047f0 <sigaction+0x70>
  pushcli();
801047a7:	e8 c4 04 00 00       	call   80104c70 <pushcli>
  c = mycpu();
801047ac:	e8 ef f0 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
801047b1:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801047b7:	e8 04 05 00 00       	call   80104cc0 <popcli>
    return -1;
  }
  // 16 bytes struct
  struct proc* p = myproc();
  if (oldact != null){
801047bc:	8d 4f 12             	lea    0x12(%edi),%ecx
801047bf:	85 db                	test   %ebx,%ebx
801047c1:	74 0c                	je     801047cf <sigaction+0x4f>
    *oldact = p->signal_handlers[signum];
801047c3:	8b 04 ce             	mov    (%esi,%ecx,8),%eax
801047c6:	8b 54 ce 04          	mov    0x4(%esi,%ecx,8),%edx
801047ca:	89 03                	mov    %eax,(%ebx)
801047cc:	89 53 04             	mov    %edx,0x4(%ebx)
  }
  p->signal_handlers[signum] = *act;
801047cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801047d2:	8b 50 04             	mov    0x4(%eax),%edx
801047d5:	8b 00                	mov    (%eax),%eax
801047d7:	89 54 ce 04          	mov    %edx,0x4(%esi,%ecx,8)
801047db:	89 04 ce             	mov    %eax,(%esi,%ecx,8)
  return 0;
801047de:	31 c0                	xor    %eax,%eax
}
801047e0:	83 c4 0c             	add    $0xc,%esp
801047e3:	5b                   	pop    %ebx
801047e4:	5e                   	pop    %esi
801047e5:	5f                   	pop    %edi
801047e6:	5d                   	pop    %ebp
801047e7:	c3                   	ret    
801047e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ef:	90                   	nop
    return -1;
801047f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047f5:	eb e9                	jmp    801047e0 <sigaction+0x60>
801047f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047fe:	66 90                	xchg   %ax,%ax

80104800 <sigret>:

void sigret(){
80104800:	f3 0f 1e fb          	endbr32 
80104804:	55                   	push   %ebp
80104805:	89 e5                	mov    %esp,%ebp
80104807:	57                   	push   %edi
80104808:	56                   	push   %esi
80104809:	53                   	push   %ebx
8010480a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010480d:	e8 5e 04 00 00       	call   80104c70 <pushcli>
  c = mycpu();
80104812:	e8 89 f0 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104817:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010481d:	e8 9e 04 00 00       	call   80104cc0 <popcli>
  struct proc* p = myproc();
  if (p!= null){
80104822:	85 db                	test   %ebx,%ebx
80104824:	74 36                	je     8010485c <sigret+0x5c>
    *(p->tf) = *(p->user_trapframe_backup);
80104826:	8b b3 90 01 00 00    	mov    0x190(%ebx),%esi
8010482c:	8b 7b 18             	mov    0x18(%ebx),%edi
8010482f:	b9 13 00 00 00       	mov    $0x13,%ecx
    //memmove( p->tf, p->user_trapframe_backup, sizeof(*p->user_trapframe_backup));
    p->blocked_signal_mask = p->mask_backup;
    p->flag_in_user_handler = 0;
    cprintf("sigret debug\n");
80104834:	83 ec 0c             	sub    $0xc,%esp
    *(p->tf) = *(p->user_trapframe_backup);
80104837:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    p->flag_in_user_handler = 0;
80104839:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104840:	00 00 00 
    p->blocked_signal_mask = p->mask_backup;
80104843:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80104849:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
    cprintf("sigret debug\n");
8010484f:	68 d5 7f 10 80       	push   $0x80107fd5
80104854:	e8 57 be ff ff       	call   801006b0 <cprintf>
80104859:	83 c4 10             	add    $0x10,%esp
  }
  return;
 }
8010485c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010485f:	5b                   	pop    %ebx
80104860:	5e                   	pop    %esi
80104861:	5f                   	pop    %edi
80104862:	5d                   	pop    %ebp
80104863:	c3                   	ret    
80104864:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010486b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010486f:	90                   	nop

80104870 <sigkill>:

// Signals implementation
// Assumed that the signal is being clear from the pending signals by the caller
int
sigkill(){
80104870:	f3 0f 1e fb          	endbr32 
80104874:	55                   	push   %ebp
80104875:	89 e5                	mov    %esp,%ebp
80104877:	53                   	push   %ebx
80104878:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010487b:	e8 f0 03 00 00       	call   80104c70 <pushcli>
  c = mycpu();
80104880:	e8 1b f0 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104885:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010488b:	e8 30 04 00 00       	call   80104cc0 <popcli>
  cprintf("process with pid %d killed handled\n", myproc()->pid);
80104890:	83 ec 08             	sub    $0x8,%esp
80104893:	ff 73 10             	pushl  0x10(%ebx)
80104896:	68 fc 81 10 80       	push   $0x801081fc
8010489b:	e8 10 be ff ff       	call   801006b0 <cprintf>
  pushcli();
801048a0:	e8 cb 03 00 00       	call   80104c70 <pushcli>
  c = mycpu();
801048a5:	e8 f6 ef ff ff       	call   801038a0 <mycpu>
  p = c->proc;
801048aa:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048b0:	e8 0b 04 00 00       	call   80104cc0 <popcli>
  myproc()->killed = 1;
  // release(&ptable.lock);
  return 0;
}
801048b5:	31 c0                	xor    %eax,%eax
  myproc()->killed = 1;
801048b7:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
}
801048be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048c1:	c9                   	leave  
801048c2:	c3                   	ret    
801048c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048d0 <sigcont>:

int 
sigcont(){
801048d0:	f3 0f 1e fb          	endbr32 
801048d4:	55                   	push   %ebp
801048d5:	89 e5                	mov    %esp,%ebp
801048d7:	53                   	push   %ebx
801048d8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801048db:	e8 90 03 00 00       	call   80104c70 <pushcli>
  c = mycpu();
801048e0:	e8 bb ef ff ff       	call   801038a0 <mycpu>
  p = c->proc;
801048e5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048eb:	e8 d0 03 00 00       	call   80104cc0 <popcli>
  myproc()->flag_frozen = 0;
  return 0;
}
801048f0:	31 c0                	xor    %eax,%eax
  myproc()->flag_frozen = 0;
801048f2:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
}
801048f9:	83 c4 04             	add    $0x4,%esp
801048fc:	5b                   	pop    %ebx
801048fd:	5d                   	pop    %ebp
801048fe:	c3                   	ret    
801048ff:	90                   	nop

80104900 <sigstop>:

int 
sigstop(){
80104900:	f3 0f 1e fb          	endbr32 
80104904:	55                   	push   %ebp
80104905:	89 e5                	mov    %esp,%ebp
80104907:	53                   	push   %ebx
80104908:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010490b:	e8 60 03 00 00       	call   80104c70 <pushcli>
  c = mycpu();
80104910:	e8 8b ef ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104915:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010491b:	e8 a0 03 00 00       	call   80104cc0 <popcli>
  myproc()->flag_frozen = 1;
  return 0;
}
80104920:	31 c0                	xor    %eax,%eax
  myproc()->flag_frozen = 1;
80104922:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
}
80104929:	83 c4 04             	add    $0x4,%esp
8010492c:	5b                   	pop    %ebx
8010492d:	5d                   	pop    %ebp
8010492e:	c3                   	ret    
8010492f:	90                   	nop

80104930 <handle_signals>:


void handle_signals(){
80104930:	f3 0f 1e fb          	endbr32 
80104934:	55                   	push   %ebp
80104935:	89 e5                	mov    %esp,%ebp
80104937:	57                   	push   %edi
80104938:	56                   	push   %esi
80104939:	53                   	push   %ebx
8010493a:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
8010493d:	e8 2e 03 00 00       	call   80104c70 <pushcli>
  c = mycpu();
80104942:	e8 59 ef ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104947:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010494d:	e8 6e 03 00 00       	call   80104cc0 <popcli>
  struct proc* p = myproc();
  if (p == null){
80104952:	85 db                	test   %ebx,%ebx
80104954:	74 7e                	je     801049d4 <handle_signals+0xa4>
    return;
  }
 
  uint mask = p->blocked_signal_mask;
  uint pending = p->pending_signals;
  uint signals_to_handle = (~mask) & pending;
80104956:	8b bb 88 00 00 00    	mov    0x88(%ebx),%edi
8010495c:	be 01 00 00 00       	mov    $0x1,%esi
80104961:	f7 d7                	not    %edi
80104963:	23 bb 84 00 00 00    	and    0x84(%ebx),%edi
  for (int signum = 0; signum < 32; signum++){
80104969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104970:	8d 4e ff             	lea    -0x1(%esi),%ecx
    if (((signals_to_handle >> signum) & 0x1) == 0){
80104973:	0f a3 cf             	bt     %ecx,%edi
80104976:	73 38                	jae    801049b0 <handle_signals+0x80>
        continue;
    }
    // turning off the bit in pending signals
    p->pending_signals &= ~(1 << signum);
80104978:	b8 01 00 00 00       	mov    $0x1,%eax
8010497d:	d3 e0                	shl    %cl,%eax
8010497f:	f7 d0                	not    %eax
80104981:	21 83 84 00 00 00    	and    %eax,0x84(%ebx)

    // handle if kernel handler
    int sa_handler = (int)p->signal_handlers[signum].sa_handler;
80104987:	8b 94 f3 88 00 00 00 	mov    0x88(%ebx,%esi,8),%edx
    switch (sa_handler){
8010498e:	83 fa 13             	cmp    $0x13,%edx
80104991:	77 0d                	ja     801049a0 <handle_signals+0x70>
80104993:	3e ff 24 95 20 82 10 	notrack jmp *-0x7fef7de0(,%edx,4)
8010499a:	80 
8010499b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010499f:	90                   	nop
        else{
          sigkill();
        }
        break;
      default:
        if (p->flag_in_user_handler == 0){ 
801049a0:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801049a6:	85 c0                	test   %eax,%eax
801049a8:	74 6d                	je     80104a17 <handle_signals+0xe7>
801049aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (int signum = 0; signum < 32; signum++){
801049b0:	83 fe 20             	cmp    $0x20,%esi
801049b3:	74 1f                	je     801049d4 <handle_signals+0xa4>
801049b5:	83 c6 01             	add    $0x1,%esi
801049b8:	eb b6                	jmp    80104970 <handle_signals+0x40>
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (signum == SIGSTOP){
801049c0:	83 f9 11             	cmp    $0x11,%ecx
801049c3:	74 4b                	je     80104a10 <handle_signals+0xe0>
        else if (signum == SIGCONT){
801049c5:	83 f9 13             	cmp    $0x13,%ecx
801049c8:	74 36                	je     80104a00 <handle_signals+0xd0>
          sigkill();
801049ca:	e8 a1 fe ff ff       	call   80104870 <sigkill>
  for (int signum = 0; signum < 32; signum++){
801049cf:	83 fe 20             	cmp    $0x20,%esi
801049d2:	75 e1                	jne    801049b5 <handle_signals+0x85>
        }
    } 
    
  }
  return;
801049d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049d7:	5b                   	pop    %ebx
801049d8:	5e                   	pop    %esi
801049d9:	5f                   	pop    %edi
801049da:	5d                   	pop    %ebp
801049db:	c3                   	ret    
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        sigcont();
801049e0:	e8 eb fe ff ff       	call   801048d0 <sigcont>
        break;
801049e5:	eb c9                	jmp    801049b0 <handle_signals+0x80>
801049e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ee:	66 90                	xchg   %ax,%ax
        sigstop();
801049f0:	e8 0b ff ff ff       	call   80104900 <sigstop>
        break;
801049f5:	eb b9                	jmp    801049b0 <handle_signals+0x80>
801049f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fe:	66 90                	xchg   %ax,%ax
          sigcont();
80104a00:	e8 cb fe ff ff       	call   801048d0 <sigcont>
80104a05:	eb ae                	jmp    801049b5 <handle_signals+0x85>
80104a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0e:	66 90                	xchg   %ax,%ax
          sigstop();
80104a10:	e8 eb fe ff ff       	call   80104900 <sigstop>
80104a15:	eb 9e                	jmp    801049b5 <handle_signals+0x85>
80104a17:	89 c8                	mov    %ecx,%eax
          p->mask_backup = p->blocked_signal_mask;
80104a19:	8b 8b 88 00 00 00    	mov    0x88(%ebx),%ecx
          *(p->user_trapframe_backup) = *(p->tf);
80104a1f:	8b 73 18             	mov    0x18(%ebx),%esi
80104a22:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104a25:	8b bb 90 01 00 00    	mov    0x190(%ebx),%edi
          char call_sigret[7] = { 0xB8, 0x18, 0x00, 0x00, 0x00, 0xCD, 0x40 };
80104a2b:	ba 00 cd ff ff       	mov    $0xffffcd00,%edx
          memmove((void*)(p->tf->esp + 8), call_sigret, 7);
80104a30:	83 ec 04             	sub    $0x4,%esp
          p->flag_in_user_handler = 1;
80104a33:	c7 83 80 00 00 00 01 	movl   $0x1,0x80(%ebx)
80104a3a:	00 00 00 
          p->mask_backup = p->blocked_signal_mask;
80104a3d:	89 8b 8c 00 00 00    	mov    %ecx,0x8c(%ebx)
          p->blocked_signal_mask = p->signal_handlers[signum].sigmask;
80104a43:	8b 8c c3 94 00 00 00 	mov    0x94(%ebx,%eax,8),%ecx
80104a4a:	89 8b 88 00 00 00    	mov    %ecx,0x88(%ebx)
          *(p->user_trapframe_backup) = *(p->tf);
80104a50:	b9 13 00 00 00       	mov    $0x13,%ecx
80104a55:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
          char call_sigret[7] = { 0xB8, 0x18, 0x00, 0x00, 0x00, 0xCD, 0x40 };
80104a57:	66 89 55 e5          	mov    %dx,-0x1b(%ebp)
80104a5b:	c7 45 e1 b8 18 00 00 	movl   $0x18b8,-0x1f(%ebp)
          p->tf->esp -= 0xF;
80104a62:	8b 4b 18             	mov    0x18(%ebx),%ecx
          char call_sigret[7] = { 0xB8, 0x18, 0x00, 0x00, 0x00, 0xCD, 0x40 };
80104a65:	c6 45 e7 40          	movb   $0x40,-0x19(%ebp)
          p->tf->esp -= 0xF;
80104a69:	83 69 44 0f          	subl   $0xf,0x44(%ecx)
          *((int*)(p->tf->esp)) = p->tf->esp + 0x8;
80104a6d:	8b 4b 18             	mov    0x18(%ebx),%ecx
80104a70:	8b 49 44             	mov    0x44(%ecx),%ecx
80104a73:	8d 71 08             	lea    0x8(%ecx),%esi
80104a76:	89 31                	mov    %esi,(%ecx)
          *((int*)(p->tf->esp + 4)) = signum;
80104a78:	8b 4b 18             	mov    0x18(%ebx),%ecx
80104a7b:	8b 49 44             	mov    0x44(%ecx),%ecx
80104a7e:	89 41 04             	mov    %eax,0x4(%ecx)
          memmove((void*)(p->tf->esp + 8), call_sigret, 7);
80104a81:	8d 45 e1             	lea    -0x1f(%ebp),%eax
80104a84:	6a 07                	push   $0x7
80104a86:	50                   	push   %eax
80104a87:	8b 43 18             	mov    0x18(%ebx),%eax
80104a8a:	8b 40 44             	mov    0x44(%eax),%eax
80104a8d:	83 c0 08             	add    $0x8,%eax
80104a90:	50                   	push   %eax
80104a91:	e8 8a 04 00 00       	call   80104f20 <memmove>
          p->tf->eip = sa_handler + 4;
80104a96:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104a99:	8b 43 18             	mov    0x18(%ebx),%eax
80104a9c:	83 c4 10             	add    $0x10,%esp
80104a9f:	83 c2 04             	add    $0x4,%edx
80104aa2:	89 50 38             	mov    %edx,0x38(%eax)
80104aa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104aa8:	5b                   	pop    %ebx
80104aa9:	5e                   	pop    %esi
80104aaa:	5f                   	pop    %edi
80104aab:	5d                   	pop    %ebp
80104aac:	c3                   	ret    
80104aad:	66 90                	xchg   %ax,%ax
80104aaf:	90                   	nop

80104ab0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ab0:	f3 0f 1e fb          	endbr32 
80104ab4:	55                   	push   %ebp
80104ab5:	89 e5                	mov    %esp,%ebp
80104ab7:	53                   	push   %ebx
80104ab8:	83 ec 0c             	sub    $0xc,%esp
80104abb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104abe:	68 88 82 10 80       	push   $0x80108288
80104ac3:	8d 43 04             	lea    0x4(%ebx),%eax
80104ac6:	50                   	push   %eax
80104ac7:	e8 24 01 00 00       	call   80104bf0 <initlock>
  lk->name = name;
80104acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104acf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104ad5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104ad8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104adf:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104ae2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ae5:	c9                   	leave  
80104ae6:	c3                   	ret    
80104ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aee:	66 90                	xchg   %ax,%ax

80104af0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104af0:	f3 0f 1e fb          	endbr32 
80104af4:	55                   	push   %ebp
80104af5:	89 e5                	mov    %esp,%ebp
80104af7:	56                   	push   %esi
80104af8:	53                   	push   %ebx
80104af9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104afc:	8d 73 04             	lea    0x4(%ebx),%esi
80104aff:	83 ec 0c             	sub    $0xc,%esp
80104b02:	56                   	push   %esi
80104b03:	e8 68 02 00 00       	call   80104d70 <acquire>
  while (lk->locked) {
80104b08:	8b 13                	mov    (%ebx),%edx
80104b0a:	83 c4 10             	add    $0x10,%esp
80104b0d:	85 d2                	test   %edx,%edx
80104b0f:	74 1a                	je     80104b2b <acquiresleep+0x3b>
80104b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104b18:	83 ec 08             	sub    $0x8,%esp
80104b1b:	56                   	push   %esi
80104b1c:	53                   	push   %ebx
80104b1d:	e8 2e f9 ff ff       	call   80104450 <sleep>
  while (lk->locked) {
80104b22:	8b 03                	mov    (%ebx),%eax
80104b24:	83 c4 10             	add    $0x10,%esp
80104b27:	85 c0                	test   %eax,%eax
80104b29:	75 ed                	jne    80104b18 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104b2b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104b31:	e8 fa ed ff ff       	call   80103930 <myproc>
80104b36:	8b 40 10             	mov    0x10(%eax),%eax
80104b39:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104b3c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104b3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b42:	5b                   	pop    %ebx
80104b43:	5e                   	pop    %esi
80104b44:	5d                   	pop    %ebp
  release(&lk->lk);
80104b45:	e9 e6 02 00 00       	jmp    80104e30 <release>
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b50 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104b50:	f3 0f 1e fb          	endbr32 
80104b54:	55                   	push   %ebp
80104b55:	89 e5                	mov    %esp,%ebp
80104b57:	56                   	push   %esi
80104b58:	53                   	push   %ebx
80104b59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b5c:	8d 73 04             	lea    0x4(%ebx),%esi
80104b5f:	83 ec 0c             	sub    $0xc,%esp
80104b62:	56                   	push   %esi
80104b63:	e8 08 02 00 00       	call   80104d70 <acquire>
  lk->locked = 0;
80104b68:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b6e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104b75:	89 1c 24             	mov    %ebx,(%esp)
80104b78:	e8 93 f9 ff ff       	call   80104510 <wakeup>
  release(&lk->lk);
80104b7d:	89 75 08             	mov    %esi,0x8(%ebp)
80104b80:	83 c4 10             	add    $0x10,%esp
}
80104b83:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b86:	5b                   	pop    %ebx
80104b87:	5e                   	pop    %esi
80104b88:	5d                   	pop    %ebp
  release(&lk->lk);
80104b89:	e9 a2 02 00 00       	jmp    80104e30 <release>
80104b8e:	66 90                	xchg   %ax,%ax

80104b90 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104b90:	f3 0f 1e fb          	endbr32 
80104b94:	55                   	push   %ebp
80104b95:	89 e5                	mov    %esp,%ebp
80104b97:	57                   	push   %edi
80104b98:	31 ff                	xor    %edi,%edi
80104b9a:	56                   	push   %esi
80104b9b:	53                   	push   %ebx
80104b9c:	83 ec 18             	sub    $0x18,%esp
80104b9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104ba2:	8d 73 04             	lea    0x4(%ebx),%esi
80104ba5:	56                   	push   %esi
80104ba6:	e8 c5 01 00 00       	call   80104d70 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104bab:	8b 03                	mov    (%ebx),%eax
80104bad:	83 c4 10             	add    $0x10,%esp
80104bb0:	85 c0                	test   %eax,%eax
80104bb2:	75 1c                	jne    80104bd0 <holdingsleep+0x40>
  release(&lk->lk);
80104bb4:	83 ec 0c             	sub    $0xc,%esp
80104bb7:	56                   	push   %esi
80104bb8:	e8 73 02 00 00       	call   80104e30 <release>
  return r;
}
80104bbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bc0:	89 f8                	mov    %edi,%eax
80104bc2:	5b                   	pop    %ebx
80104bc3:	5e                   	pop    %esi
80104bc4:	5f                   	pop    %edi
80104bc5:	5d                   	pop    %ebp
80104bc6:	c3                   	ret    
80104bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bce:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104bd0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104bd3:	e8 58 ed ff ff       	call   80103930 <myproc>
80104bd8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104bdb:	0f 94 c0             	sete   %al
80104bde:	0f b6 c0             	movzbl %al,%eax
80104be1:	89 c7                	mov    %eax,%edi
80104be3:	eb cf                	jmp    80104bb4 <holdingsleep+0x24>
80104be5:	66 90                	xchg   %ax,%ax
80104be7:	66 90                	xchg   %ax,%ax
80104be9:	66 90                	xchg   %ax,%ax
80104beb:	66 90                	xchg   %ax,%ax
80104bed:	66 90                	xchg   %ax,%ax
80104bef:	90                   	nop

80104bf0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104bf0:	f3 0f 1e fb          	endbr32 
80104bf4:	55                   	push   %ebp
80104bf5:	89 e5                	mov    %esp,%ebp
80104bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104bfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104c03:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104c06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c0d:	5d                   	pop    %ebp
80104c0e:	c3                   	ret    
80104c0f:	90                   	nop

80104c10 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c10:	f3 0f 1e fb          	endbr32 
80104c14:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c15:	31 d2                	xor    %edx,%edx
{
80104c17:	89 e5                	mov    %esp,%ebp
80104c19:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104c1a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c20:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104c23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c27:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c28:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104c2e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c34:	77 1a                	ja     80104c50 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104c36:	8b 58 04             	mov    0x4(%eax),%ebx
80104c39:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104c3c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104c3f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c41:	83 fa 0a             	cmp    $0xa,%edx
80104c44:	75 e2                	jne    80104c28 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104c46:	5b                   	pop    %ebx
80104c47:	5d                   	pop    %ebp
80104c48:	c3                   	ret    
80104c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104c50:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104c53:	8d 51 28             	lea    0x28(%ecx),%edx
80104c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104c60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c66:	83 c0 04             	add    $0x4,%eax
80104c69:	39 d0                	cmp    %edx,%eax
80104c6b:	75 f3                	jne    80104c60 <getcallerpcs+0x50>
}
80104c6d:	5b                   	pop    %ebx
80104c6e:	5d                   	pop    %ebp
80104c6f:	c3                   	ret    

80104c70 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	53                   	push   %ebx
80104c78:	83 ec 04             	sub    $0x4,%esp
80104c7b:	9c                   	pushf  
80104c7c:	5b                   	pop    %ebx
  asm volatile("cli");
80104c7d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104c7e:	e8 1d ec ff ff       	call   801038a0 <mycpu>
80104c83:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c89:	85 c0                	test   %eax,%eax
80104c8b:	74 13                	je     80104ca0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104c8d:	e8 0e ec ff ff       	call   801038a0 <mycpu>
80104c92:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104c99:	83 c4 04             	add    $0x4,%esp
80104c9c:	5b                   	pop    %ebx
80104c9d:	5d                   	pop    %ebp
80104c9e:	c3                   	ret    
80104c9f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104ca0:	e8 fb eb ff ff       	call   801038a0 <mycpu>
80104ca5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104cab:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104cb1:	eb da                	jmp    80104c8d <pushcli+0x1d>
80104cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104cc0 <popcli>:

void
popcli(void)
{
80104cc0:	f3 0f 1e fb          	endbr32 
80104cc4:	55                   	push   %ebp
80104cc5:	89 e5                	mov    %esp,%ebp
80104cc7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104cca:	9c                   	pushf  
80104ccb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ccc:	f6 c4 02             	test   $0x2,%ah
80104ccf:	75 31                	jne    80104d02 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104cd1:	e8 ca eb ff ff       	call   801038a0 <mycpu>
80104cd6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104cdd:	78 30                	js     80104d0f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104cdf:	e8 bc eb ff ff       	call   801038a0 <mycpu>
80104ce4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104cea:	85 d2                	test   %edx,%edx
80104cec:	74 02                	je     80104cf0 <popcli+0x30>
    sti();
}
80104cee:	c9                   	leave  
80104cef:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104cf0:	e8 ab eb ff ff       	call   801038a0 <mycpu>
80104cf5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104cfb:	85 c0                	test   %eax,%eax
80104cfd:	74 ef                	je     80104cee <popcli+0x2e>
  asm volatile("sti");
80104cff:	fb                   	sti    
}
80104d00:	c9                   	leave  
80104d01:	c3                   	ret    
    panic("popcli - interruptible");
80104d02:	83 ec 0c             	sub    $0xc,%esp
80104d05:	68 93 82 10 80       	push   $0x80108293
80104d0a:	e8 81 b6 ff ff       	call   80100390 <panic>
    panic("popcli");
80104d0f:	83 ec 0c             	sub    $0xc,%esp
80104d12:	68 aa 82 10 80       	push   $0x801082aa
80104d17:	e8 74 b6 ff ff       	call   80100390 <panic>
80104d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d20 <holding>:
{
80104d20:	f3 0f 1e fb          	endbr32 
80104d24:	55                   	push   %ebp
80104d25:	89 e5                	mov    %esp,%ebp
80104d27:	56                   	push   %esi
80104d28:	53                   	push   %ebx
80104d29:	8b 75 08             	mov    0x8(%ebp),%esi
80104d2c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104d2e:	e8 3d ff ff ff       	call   80104c70 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d33:	8b 06                	mov    (%esi),%eax
80104d35:	85 c0                	test   %eax,%eax
80104d37:	75 0f                	jne    80104d48 <holding+0x28>
  popcli();
80104d39:	e8 82 ff ff ff       	call   80104cc0 <popcli>
}
80104d3e:	89 d8                	mov    %ebx,%eax
80104d40:	5b                   	pop    %ebx
80104d41:	5e                   	pop    %esi
80104d42:	5d                   	pop    %ebp
80104d43:	c3                   	ret    
80104d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104d48:	8b 5e 08             	mov    0x8(%esi),%ebx
80104d4b:	e8 50 eb ff ff       	call   801038a0 <mycpu>
80104d50:	39 c3                	cmp    %eax,%ebx
80104d52:	0f 94 c3             	sete   %bl
  popcli();
80104d55:	e8 66 ff ff ff       	call   80104cc0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104d5a:	0f b6 db             	movzbl %bl,%ebx
}
80104d5d:	89 d8                	mov    %ebx,%eax
80104d5f:	5b                   	pop    %ebx
80104d60:	5e                   	pop    %esi
80104d61:	5d                   	pop    %ebp
80104d62:	c3                   	ret    
80104d63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d70 <acquire>:
{
80104d70:	f3 0f 1e fb          	endbr32 
80104d74:	55                   	push   %ebp
80104d75:	89 e5                	mov    %esp,%ebp
80104d77:	56                   	push   %esi
80104d78:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104d79:	e8 f2 fe ff ff       	call   80104c70 <pushcli>
  if(holding(lk))
80104d7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d81:	83 ec 0c             	sub    $0xc,%esp
80104d84:	53                   	push   %ebx
80104d85:	e8 96 ff ff ff       	call   80104d20 <holding>
80104d8a:	83 c4 10             	add    $0x10,%esp
80104d8d:	85 c0                	test   %eax,%eax
80104d8f:	0f 85 7f 00 00 00    	jne    80104e14 <acquire+0xa4>
80104d95:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104d97:	ba 01 00 00 00       	mov    $0x1,%edx
80104d9c:	eb 05                	jmp    80104da3 <acquire+0x33>
80104d9e:	66 90                	xchg   %ax,%ax
80104da0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104da3:	89 d0                	mov    %edx,%eax
80104da5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104da8:	85 c0                	test   %eax,%eax
80104daa:	75 f4                	jne    80104da0 <acquire+0x30>
  __sync_synchronize();
80104dac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104db1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104db4:	e8 e7 ea ff ff       	call   801038a0 <mycpu>
80104db9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104dbc:	89 e8                	mov    %ebp,%eax
80104dbe:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104dc0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104dc6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104dcc:	77 22                	ja     80104df0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104dce:	8b 50 04             	mov    0x4(%eax),%edx
80104dd1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104dd5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104dd8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104dda:	83 fe 0a             	cmp    $0xa,%esi
80104ddd:	75 e1                	jne    80104dc0 <acquire+0x50>
}
80104ddf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104de2:	5b                   	pop    %ebx
80104de3:	5e                   	pop    %esi
80104de4:	5d                   	pop    %ebp
80104de5:	c3                   	ret    
80104de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ded:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104df0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104df4:	83 c3 34             	add    $0x34,%ebx
80104df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dfe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104e00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e06:	83 c0 04             	add    $0x4,%eax
80104e09:	39 d8                	cmp    %ebx,%eax
80104e0b:	75 f3                	jne    80104e00 <acquire+0x90>
}
80104e0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e10:	5b                   	pop    %ebx
80104e11:	5e                   	pop    %esi
80104e12:	5d                   	pop    %ebp
80104e13:	c3                   	ret    
    panic("acquire");
80104e14:	83 ec 0c             	sub    $0xc,%esp
80104e17:	68 b1 82 10 80       	push   $0x801082b1
80104e1c:	e8 6f b5 ff ff       	call   80100390 <panic>
80104e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2f:	90                   	nop

80104e30 <release>:
{
80104e30:	f3 0f 1e fb          	endbr32 
80104e34:	55                   	push   %ebp
80104e35:	89 e5                	mov    %esp,%ebp
80104e37:	53                   	push   %ebx
80104e38:	83 ec 10             	sub    $0x10,%esp
80104e3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104e3e:	53                   	push   %ebx
80104e3f:	e8 dc fe ff ff       	call   80104d20 <holding>
80104e44:	83 c4 10             	add    $0x10,%esp
80104e47:	85 c0                	test   %eax,%eax
80104e49:	74 22                	je     80104e6d <release+0x3d>
  lk->pcs[0] = 0;
80104e4b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104e52:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104e59:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104e5e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e67:	c9                   	leave  
  popcli();
80104e68:	e9 53 fe ff ff       	jmp    80104cc0 <popcli>
    panic("release");
80104e6d:	83 ec 0c             	sub    $0xc,%esp
80104e70:	68 b9 82 10 80       	push   $0x801082b9
80104e75:	e8 16 b5 ff ff       	call   80100390 <panic>
80104e7a:	66 90                	xchg   %ax,%ax
80104e7c:	66 90                	xchg   %ax,%ax
80104e7e:	66 90                	xchg   %ax,%ax

80104e80 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104e80:	f3 0f 1e fb          	endbr32 
80104e84:	55                   	push   %ebp
80104e85:	89 e5                	mov    %esp,%ebp
80104e87:	57                   	push   %edi
80104e88:	8b 55 08             	mov    0x8(%ebp),%edx
80104e8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e8e:	53                   	push   %ebx
80104e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104e92:	89 d7                	mov    %edx,%edi
80104e94:	09 cf                	or     %ecx,%edi
80104e96:	83 e7 03             	and    $0x3,%edi
80104e99:	75 25                	jne    80104ec0 <memset+0x40>
    c &= 0xFF;
80104e9b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104e9e:	c1 e0 18             	shl    $0x18,%eax
80104ea1:	89 fb                	mov    %edi,%ebx
80104ea3:	c1 e9 02             	shr    $0x2,%ecx
80104ea6:	c1 e3 10             	shl    $0x10,%ebx
80104ea9:	09 d8                	or     %ebx,%eax
80104eab:	09 f8                	or     %edi,%eax
80104ead:	c1 e7 08             	shl    $0x8,%edi
80104eb0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104eb2:	89 d7                	mov    %edx,%edi
80104eb4:	fc                   	cld    
80104eb5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104eb7:	5b                   	pop    %ebx
80104eb8:	89 d0                	mov    %edx,%eax
80104eba:	5f                   	pop    %edi
80104ebb:	5d                   	pop    %ebp
80104ebc:	c3                   	ret    
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104ec0:	89 d7                	mov    %edx,%edi
80104ec2:	fc                   	cld    
80104ec3:	f3 aa                	rep stos %al,%es:(%edi)
80104ec5:	5b                   	pop    %ebx
80104ec6:	89 d0                	mov    %edx,%eax
80104ec8:	5f                   	pop    %edi
80104ec9:	5d                   	pop    %ebp
80104eca:	c3                   	ret    
80104ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ecf:	90                   	nop

80104ed0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ed0:	f3 0f 1e fb          	endbr32 
80104ed4:	55                   	push   %ebp
80104ed5:	89 e5                	mov    %esp,%ebp
80104ed7:	56                   	push   %esi
80104ed8:	8b 75 10             	mov    0x10(%ebp),%esi
80104edb:	8b 55 08             	mov    0x8(%ebp),%edx
80104ede:	53                   	push   %ebx
80104edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104ee2:	85 f6                	test   %esi,%esi
80104ee4:	74 2a                	je     80104f10 <memcmp+0x40>
80104ee6:	01 c6                	add    %eax,%esi
80104ee8:	eb 10                	jmp    80104efa <memcmp+0x2a>
80104eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104ef0:	83 c0 01             	add    $0x1,%eax
80104ef3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104ef6:	39 f0                	cmp    %esi,%eax
80104ef8:	74 16                	je     80104f10 <memcmp+0x40>
    if(*s1 != *s2)
80104efa:	0f b6 0a             	movzbl (%edx),%ecx
80104efd:	0f b6 18             	movzbl (%eax),%ebx
80104f00:	38 d9                	cmp    %bl,%cl
80104f02:	74 ec                	je     80104ef0 <memcmp+0x20>
      return *s1 - *s2;
80104f04:	0f b6 c1             	movzbl %cl,%eax
80104f07:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104f09:	5b                   	pop    %ebx
80104f0a:	5e                   	pop    %esi
80104f0b:	5d                   	pop    %ebp
80104f0c:	c3                   	ret    
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
80104f10:	5b                   	pop    %ebx
  return 0;
80104f11:	31 c0                	xor    %eax,%eax
}
80104f13:	5e                   	pop    %esi
80104f14:	5d                   	pop    %ebp
80104f15:	c3                   	ret    
80104f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1d:	8d 76 00             	lea    0x0(%esi),%esi

80104f20 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f20:	f3 0f 1e fb          	endbr32 
80104f24:	55                   	push   %ebp
80104f25:	89 e5                	mov    %esp,%ebp
80104f27:	57                   	push   %edi
80104f28:	8b 55 08             	mov    0x8(%ebp),%edx
80104f2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f2e:	56                   	push   %esi
80104f2f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104f32:	39 d6                	cmp    %edx,%esi
80104f34:	73 2a                	jae    80104f60 <memmove+0x40>
80104f36:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104f39:	39 fa                	cmp    %edi,%edx
80104f3b:	73 23                	jae    80104f60 <memmove+0x40>
80104f3d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104f40:	85 c9                	test   %ecx,%ecx
80104f42:	74 13                	je     80104f57 <memmove+0x37>
80104f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104f48:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104f4c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104f4f:	83 e8 01             	sub    $0x1,%eax
80104f52:	83 f8 ff             	cmp    $0xffffffff,%eax
80104f55:	75 f1                	jne    80104f48 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104f57:	5e                   	pop    %esi
80104f58:	89 d0                	mov    %edx,%eax
80104f5a:	5f                   	pop    %edi
80104f5b:	5d                   	pop    %ebp
80104f5c:	c3                   	ret    
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104f60:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104f63:	89 d7                	mov    %edx,%edi
80104f65:	85 c9                	test   %ecx,%ecx
80104f67:	74 ee                	je     80104f57 <memmove+0x37>
80104f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104f70:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104f71:	39 f0                	cmp    %esi,%eax
80104f73:	75 fb                	jne    80104f70 <memmove+0x50>
}
80104f75:	5e                   	pop    %esi
80104f76:	89 d0                	mov    %edx,%eax
80104f78:	5f                   	pop    %edi
80104f79:	5d                   	pop    %ebp
80104f7a:	c3                   	ret    
80104f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f7f:	90                   	nop

80104f80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104f80:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104f84:	eb 9a                	jmp    80104f20 <memmove>
80104f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi

80104f90 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104f90:	f3 0f 1e fb          	endbr32 
80104f94:	55                   	push   %ebp
80104f95:	89 e5                	mov    %esp,%ebp
80104f97:	56                   	push   %esi
80104f98:	8b 75 10             	mov    0x10(%ebp),%esi
80104f9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f9e:	53                   	push   %ebx
80104f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104fa2:	85 f6                	test   %esi,%esi
80104fa4:	74 32                	je     80104fd8 <strncmp+0x48>
80104fa6:	01 c6                	add    %eax,%esi
80104fa8:	eb 14                	jmp    80104fbe <strncmp+0x2e>
80104faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fb0:	38 da                	cmp    %bl,%dl
80104fb2:	75 14                	jne    80104fc8 <strncmp+0x38>
    n--, p++, q++;
80104fb4:	83 c0 01             	add    $0x1,%eax
80104fb7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104fba:	39 f0                	cmp    %esi,%eax
80104fbc:	74 1a                	je     80104fd8 <strncmp+0x48>
80104fbe:	0f b6 11             	movzbl (%ecx),%edx
80104fc1:	0f b6 18             	movzbl (%eax),%ebx
80104fc4:	84 d2                	test   %dl,%dl
80104fc6:	75 e8                	jne    80104fb0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104fc8:	0f b6 c2             	movzbl %dl,%eax
80104fcb:	29 d8                	sub    %ebx,%eax
}
80104fcd:	5b                   	pop    %ebx
80104fce:	5e                   	pop    %esi
80104fcf:	5d                   	pop    %ebp
80104fd0:	c3                   	ret    
80104fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fd8:	5b                   	pop    %ebx
    return 0;
80104fd9:	31 c0                	xor    %eax,%eax
}
80104fdb:	5e                   	pop    %esi
80104fdc:	5d                   	pop    %ebp
80104fdd:	c3                   	ret    
80104fde:	66 90                	xchg   %ax,%ax

80104fe0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104fe0:	f3 0f 1e fb          	endbr32 
80104fe4:	55                   	push   %ebp
80104fe5:	89 e5                	mov    %esp,%ebp
80104fe7:	57                   	push   %edi
80104fe8:	56                   	push   %esi
80104fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80104fec:	53                   	push   %ebx
80104fed:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ff0:	89 f2                	mov    %esi,%edx
80104ff2:	eb 1b                	jmp    8010500f <strncpy+0x2f>
80104ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ff8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104ffc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104fff:	83 c2 01             	add    $0x1,%edx
80105002:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105006:	89 f9                	mov    %edi,%ecx
80105008:	88 4a ff             	mov    %cl,-0x1(%edx)
8010500b:	84 c9                	test   %cl,%cl
8010500d:	74 09                	je     80105018 <strncpy+0x38>
8010500f:	89 c3                	mov    %eax,%ebx
80105011:	83 e8 01             	sub    $0x1,%eax
80105014:	85 db                	test   %ebx,%ebx
80105016:	7f e0                	jg     80104ff8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105018:	89 d1                	mov    %edx,%ecx
8010501a:	85 c0                	test   %eax,%eax
8010501c:	7e 15                	jle    80105033 <strncpy+0x53>
8010501e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105020:	83 c1 01             	add    $0x1,%ecx
80105023:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105027:	89 c8                	mov    %ecx,%eax
80105029:	f7 d0                	not    %eax
8010502b:	01 d0                	add    %edx,%eax
8010502d:	01 d8                	add    %ebx,%eax
8010502f:	85 c0                	test   %eax,%eax
80105031:	7f ed                	jg     80105020 <strncpy+0x40>
  return os;
}
80105033:	5b                   	pop    %ebx
80105034:	89 f0                	mov    %esi,%eax
80105036:	5e                   	pop    %esi
80105037:	5f                   	pop    %edi
80105038:	5d                   	pop    %ebp
80105039:	c3                   	ret    
8010503a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105040 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105040:	f3 0f 1e fb          	endbr32 
80105044:	55                   	push   %ebp
80105045:	89 e5                	mov    %esp,%ebp
80105047:	56                   	push   %esi
80105048:	8b 55 10             	mov    0x10(%ebp),%edx
8010504b:	8b 75 08             	mov    0x8(%ebp),%esi
8010504e:	53                   	push   %ebx
8010504f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105052:	85 d2                	test   %edx,%edx
80105054:	7e 21                	jle    80105077 <safestrcpy+0x37>
80105056:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010505a:	89 f2                	mov    %esi,%edx
8010505c:	eb 12                	jmp    80105070 <safestrcpy+0x30>
8010505e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105060:	0f b6 08             	movzbl (%eax),%ecx
80105063:	83 c0 01             	add    $0x1,%eax
80105066:	83 c2 01             	add    $0x1,%edx
80105069:	88 4a ff             	mov    %cl,-0x1(%edx)
8010506c:	84 c9                	test   %cl,%cl
8010506e:	74 04                	je     80105074 <safestrcpy+0x34>
80105070:	39 d8                	cmp    %ebx,%eax
80105072:	75 ec                	jne    80105060 <safestrcpy+0x20>
    ;
  *s = 0;
80105074:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105077:	89 f0                	mov    %esi,%eax
80105079:	5b                   	pop    %ebx
8010507a:	5e                   	pop    %esi
8010507b:	5d                   	pop    %ebp
8010507c:	c3                   	ret    
8010507d:	8d 76 00             	lea    0x0(%esi),%esi

80105080 <strlen>:

int
strlen(const char *s)
{
80105080:	f3 0f 1e fb          	endbr32 
80105084:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105085:	31 c0                	xor    %eax,%eax
{
80105087:	89 e5                	mov    %esp,%ebp
80105089:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010508c:	80 3a 00             	cmpb   $0x0,(%edx)
8010508f:	74 10                	je     801050a1 <strlen+0x21>
80105091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105098:	83 c0 01             	add    $0x1,%eax
8010509b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010509f:	75 f7                	jne    80105098 <strlen+0x18>
    ;
  return n;
}
801050a1:	5d                   	pop    %ebp
801050a2:	c3                   	ret    

801050a3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801050a3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801050a7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801050ab:	55                   	push   %ebp
  pushl %ebx
801050ac:	53                   	push   %ebx
  pushl %esi
801050ad:	56                   	push   %esi
  pushl %edi
801050ae:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801050af:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801050b1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801050b3:	5f                   	pop    %edi
  popl %esi
801050b4:	5e                   	pop    %esi
  popl %ebx
801050b5:	5b                   	pop    %ebx
  popl %ebp
801050b6:	5d                   	pop    %ebp
  ret
801050b7:	c3                   	ret    
801050b8:	66 90                	xchg   %ax,%ax
801050ba:	66 90                	xchg   %ax,%ax
801050bc:	66 90                	xchg   %ax,%ax
801050be:	66 90                	xchg   %ax,%ax

801050c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801050c0:	f3 0f 1e fb          	endbr32 
801050c4:	55                   	push   %ebp
801050c5:	89 e5                	mov    %esp,%ebp
801050c7:	53                   	push   %ebx
801050c8:	83 ec 04             	sub    $0x4,%esp
801050cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801050ce:	e8 5d e8 ff ff       	call   80103930 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050d3:	8b 00                	mov    (%eax),%eax
801050d5:	39 d8                	cmp    %ebx,%eax
801050d7:	76 17                	jbe    801050f0 <fetchint+0x30>
801050d9:	8d 53 04             	lea    0x4(%ebx),%edx
801050dc:	39 d0                	cmp    %edx,%eax
801050de:	72 10                	jb     801050f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801050e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801050e3:	8b 13                	mov    (%ebx),%edx
801050e5:	89 10                	mov    %edx,(%eax)
  return 0;
801050e7:	31 c0                	xor    %eax,%eax
}
801050e9:	83 c4 04             	add    $0x4,%esp
801050ec:	5b                   	pop    %ebx
801050ed:	5d                   	pop    %ebp
801050ee:	c3                   	ret    
801050ef:	90                   	nop
    return -1;
801050f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f5:	eb f2                	jmp    801050e9 <fetchint+0x29>
801050f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050fe:	66 90                	xchg   %ax,%ax

80105100 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105100:	f3 0f 1e fb          	endbr32 
80105104:	55                   	push   %ebp
80105105:	89 e5                	mov    %esp,%ebp
80105107:	53                   	push   %ebx
80105108:	83 ec 04             	sub    $0x4,%esp
8010510b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010510e:	e8 1d e8 ff ff       	call   80103930 <myproc>

  if(addr >= curproc->sz)
80105113:	39 18                	cmp    %ebx,(%eax)
80105115:	76 31                	jbe    80105148 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105117:	8b 55 0c             	mov    0xc(%ebp),%edx
8010511a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010511c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010511e:	39 d3                	cmp    %edx,%ebx
80105120:	73 26                	jae    80105148 <fetchstr+0x48>
80105122:	89 d8                	mov    %ebx,%eax
80105124:	eb 11                	jmp    80105137 <fetchstr+0x37>
80105126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010512d:	8d 76 00             	lea    0x0(%esi),%esi
80105130:	83 c0 01             	add    $0x1,%eax
80105133:	39 c2                	cmp    %eax,%edx
80105135:	76 11                	jbe    80105148 <fetchstr+0x48>
    if(*s == 0)
80105137:	80 38 00             	cmpb   $0x0,(%eax)
8010513a:	75 f4                	jne    80105130 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010513c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010513f:	29 d8                	sub    %ebx,%eax
}
80105141:	5b                   	pop    %ebx
80105142:	5d                   	pop    %ebp
80105143:	c3                   	ret    
80105144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105148:	83 c4 04             	add    $0x4,%esp
    return -1;
8010514b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105150:	5b                   	pop    %ebx
80105151:	5d                   	pop    %ebp
80105152:	c3                   	ret    
80105153:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105160 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105160:	f3 0f 1e fb          	endbr32 
80105164:	55                   	push   %ebp
80105165:	89 e5                	mov    %esp,%ebp
80105167:	56                   	push   %esi
80105168:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105169:	e8 c2 e7 ff ff       	call   80103930 <myproc>
8010516e:	8b 55 08             	mov    0x8(%ebp),%edx
80105171:	8b 40 18             	mov    0x18(%eax),%eax
80105174:	8b 40 44             	mov    0x44(%eax),%eax
80105177:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010517a:	e8 b1 e7 ff ff       	call   80103930 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010517f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105182:	8b 00                	mov    (%eax),%eax
80105184:	39 c6                	cmp    %eax,%esi
80105186:	73 18                	jae    801051a0 <argint+0x40>
80105188:	8d 53 08             	lea    0x8(%ebx),%edx
8010518b:	39 d0                	cmp    %edx,%eax
8010518d:	72 11                	jb     801051a0 <argint+0x40>
  *ip = *(int*)(addr);
8010518f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105192:	8b 53 04             	mov    0x4(%ebx),%edx
80105195:	89 10                	mov    %edx,(%eax)
  return 0;
80105197:	31 c0                	xor    %eax,%eax
}
80105199:	5b                   	pop    %ebx
8010519a:	5e                   	pop    %esi
8010519b:	5d                   	pop    %ebp
8010519c:	c3                   	ret    
8010519d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051a5:	eb f2                	jmp    80105199 <argint+0x39>
801051a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801051b0:	f3 0f 1e fb          	endbr32 
801051b4:	55                   	push   %ebp
801051b5:	89 e5                	mov    %esp,%ebp
801051b7:	56                   	push   %esi
801051b8:	53                   	push   %ebx
801051b9:	83 ec 10             	sub    $0x10,%esp
801051bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801051bf:	e8 6c e7 ff ff       	call   80103930 <myproc>
 
  if(argint(n, &i) < 0)
801051c4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801051c7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801051c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051cc:	50                   	push   %eax
801051cd:	ff 75 08             	pushl  0x8(%ebp)
801051d0:	e8 8b ff ff ff       	call   80105160 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801051d5:	83 c4 10             	add    $0x10,%esp
801051d8:	85 c0                	test   %eax,%eax
801051da:	78 24                	js     80105200 <argptr+0x50>
801051dc:	85 db                	test   %ebx,%ebx
801051de:	78 20                	js     80105200 <argptr+0x50>
801051e0:	8b 16                	mov    (%esi),%edx
801051e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051e5:	39 c2                	cmp    %eax,%edx
801051e7:	76 17                	jbe    80105200 <argptr+0x50>
801051e9:	01 c3                	add    %eax,%ebx
801051eb:	39 da                	cmp    %ebx,%edx
801051ed:	72 11                	jb     80105200 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801051ef:	8b 55 0c             	mov    0xc(%ebp),%edx
801051f2:	89 02                	mov    %eax,(%edx)
  return 0;
801051f4:	31 c0                	xor    %eax,%eax
}
801051f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051f9:	5b                   	pop    %ebx
801051fa:	5e                   	pop    %esi
801051fb:	5d                   	pop    %ebp
801051fc:	c3                   	ret    
801051fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105205:	eb ef                	jmp    801051f6 <argptr+0x46>
80105207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520e:	66 90                	xchg   %ax,%ax

80105210 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105210:	f3 0f 1e fb          	endbr32 
80105214:	55                   	push   %ebp
80105215:	89 e5                	mov    %esp,%ebp
80105217:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010521a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010521d:	50                   	push   %eax
8010521e:	ff 75 08             	pushl  0x8(%ebp)
80105221:	e8 3a ff ff ff       	call   80105160 <argint>
80105226:	83 c4 10             	add    $0x10,%esp
80105229:	85 c0                	test   %eax,%eax
8010522b:	78 13                	js     80105240 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010522d:	83 ec 08             	sub    $0x8,%esp
80105230:	ff 75 0c             	pushl  0xc(%ebp)
80105233:	ff 75 f4             	pushl  -0xc(%ebp)
80105236:	e8 c5 fe ff ff       	call   80105100 <fetchstr>
8010523b:	83 c4 10             	add    $0x10,%esp
}
8010523e:	c9                   	leave  
8010523f:	c3                   	ret    
80105240:	c9                   	leave  
    return -1;
80105241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105246:	c3                   	ret    
80105247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524e:	66 90                	xchg   %ax,%ax

80105250 <syscall>:
[SYS_sigret] sys_sigret
};

void
syscall(void)
{
80105250:	f3 0f 1e fb          	endbr32 
80105254:	55                   	push   %ebp
80105255:	89 e5                	mov    %esp,%ebp
80105257:	53                   	push   %ebx
80105258:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010525b:	e8 d0 e6 ff ff       	call   80103930 <myproc>
80105260:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105262:	8b 40 18             	mov    0x18(%eax),%eax
80105265:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105268:	8d 50 ff             	lea    -0x1(%eax),%edx
8010526b:	83 fa 17             	cmp    $0x17,%edx
8010526e:	77 20                	ja     80105290 <syscall+0x40>
80105270:	8b 14 85 e0 82 10 80 	mov    -0x7fef7d20(,%eax,4),%edx
80105277:	85 d2                	test   %edx,%edx
80105279:	74 15                	je     80105290 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010527b:	ff d2                	call   *%edx
8010527d:	89 c2                	mov    %eax,%edx
8010527f:	8b 43 18             	mov    0x18(%ebx),%eax
80105282:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105288:	c9                   	leave  
80105289:	c3                   	ret    
8010528a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105290:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105291:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105294:	50                   	push   %eax
80105295:	ff 73 10             	pushl  0x10(%ebx)
80105298:	68 c1 82 10 80       	push   $0x801082c1
8010529d:	e8 0e b4 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801052a2:	8b 43 18             	mov    0x18(%ebx),%eax
801052a5:	83 c4 10             	add    $0x10,%esp
801052a8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801052af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052b2:	c9                   	leave  
801052b3:	c3                   	ret    
801052b4:	66 90                	xchg   %ax,%ax
801052b6:	66 90                	xchg   %ax,%ax
801052b8:	66 90                	xchg   %ax,%ax
801052ba:	66 90                	xchg   %ax,%ax
801052bc:	66 90                	xchg   %ax,%ax
801052be:	66 90                	xchg   %ax,%ax

801052c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801052c5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801052c8:	53                   	push   %ebx
801052c9:	83 ec 34             	sub    $0x34,%esp
801052cc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801052cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801052d2:	57                   	push   %edi
801052d3:	50                   	push   %eax
{
801052d4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801052d7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801052da:	e8 a1 cd ff ff       	call   80102080 <nameiparent>
801052df:	83 c4 10             	add    $0x10,%esp
801052e2:	85 c0                	test   %eax,%eax
801052e4:	0f 84 46 01 00 00    	je     80105430 <create+0x170>
    return 0;
  ilock(dp);
801052ea:	83 ec 0c             	sub    $0xc,%esp
801052ed:	89 c3                	mov    %eax,%ebx
801052ef:	50                   	push   %eax
801052f0:	e8 9b c4 ff ff       	call   80101790 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801052f5:	83 c4 0c             	add    $0xc,%esp
801052f8:	6a 00                	push   $0x0
801052fa:	57                   	push   %edi
801052fb:	53                   	push   %ebx
801052fc:	e8 df c9 ff ff       	call   80101ce0 <dirlookup>
80105301:	83 c4 10             	add    $0x10,%esp
80105304:	89 c6                	mov    %eax,%esi
80105306:	85 c0                	test   %eax,%eax
80105308:	74 56                	je     80105360 <create+0xa0>
    iunlockput(dp);
8010530a:	83 ec 0c             	sub    $0xc,%esp
8010530d:	53                   	push   %ebx
8010530e:	e8 1d c7 ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
80105313:	89 34 24             	mov    %esi,(%esp)
80105316:	e8 75 c4 ff ff       	call   80101790 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010531b:	83 c4 10             	add    $0x10,%esp
8010531e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105323:	75 1b                	jne    80105340 <create+0x80>
80105325:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010532a:	75 14                	jne    80105340 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010532c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010532f:	89 f0                	mov    %esi,%eax
80105331:	5b                   	pop    %ebx
80105332:	5e                   	pop    %esi
80105333:	5f                   	pop    %edi
80105334:	5d                   	pop    %ebp
80105335:	c3                   	ret    
80105336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010533d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	56                   	push   %esi
    return 0;
80105344:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105346:	e8 e5 c6 ff ff       	call   80101a30 <iunlockput>
    return 0;
8010534b:	83 c4 10             	add    $0x10,%esp
}
8010534e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105351:	89 f0                	mov    %esi,%eax
80105353:	5b                   	pop    %ebx
80105354:	5e                   	pop    %esi
80105355:	5f                   	pop    %edi
80105356:	5d                   	pop    %ebp
80105357:	c3                   	ret    
80105358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105360:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105364:	83 ec 08             	sub    $0x8,%esp
80105367:	50                   	push   %eax
80105368:	ff 33                	pushl  (%ebx)
8010536a:	e8 a1 c2 ff ff       	call   80101610 <ialloc>
8010536f:	83 c4 10             	add    $0x10,%esp
80105372:	89 c6                	mov    %eax,%esi
80105374:	85 c0                	test   %eax,%eax
80105376:	0f 84 cd 00 00 00    	je     80105449 <create+0x189>
  ilock(ip);
8010537c:	83 ec 0c             	sub    $0xc,%esp
8010537f:	50                   	push   %eax
80105380:	e8 0b c4 ff ff       	call   80101790 <ilock>
  ip->major = major;
80105385:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105389:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010538d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105391:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105395:	b8 01 00 00 00       	mov    $0x1,%eax
8010539a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010539e:	89 34 24             	mov    %esi,(%esp)
801053a1:	e8 2a c3 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801053a6:	83 c4 10             	add    $0x10,%esp
801053a9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801053ae:	74 30                	je     801053e0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801053b0:	83 ec 04             	sub    $0x4,%esp
801053b3:	ff 76 04             	pushl  0x4(%esi)
801053b6:	57                   	push   %edi
801053b7:	53                   	push   %ebx
801053b8:	e8 e3 cb ff ff       	call   80101fa0 <dirlink>
801053bd:	83 c4 10             	add    $0x10,%esp
801053c0:	85 c0                	test   %eax,%eax
801053c2:	78 78                	js     8010543c <create+0x17c>
  iunlockput(dp);
801053c4:	83 ec 0c             	sub    $0xc,%esp
801053c7:	53                   	push   %ebx
801053c8:	e8 63 c6 ff ff       	call   80101a30 <iunlockput>
  return ip;
801053cd:	83 c4 10             	add    $0x10,%esp
}
801053d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d3:	89 f0                	mov    %esi,%eax
801053d5:	5b                   	pop    %ebx
801053d6:	5e                   	pop    %esi
801053d7:	5f                   	pop    %edi
801053d8:	5d                   	pop    %ebp
801053d9:	c3                   	ret    
801053da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801053e0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801053e3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801053e8:	53                   	push   %ebx
801053e9:	e8 e2 c2 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801053ee:	83 c4 0c             	add    $0xc,%esp
801053f1:	ff 76 04             	pushl  0x4(%esi)
801053f4:	68 60 83 10 80       	push   $0x80108360
801053f9:	56                   	push   %esi
801053fa:	e8 a1 cb ff ff       	call   80101fa0 <dirlink>
801053ff:	83 c4 10             	add    $0x10,%esp
80105402:	85 c0                	test   %eax,%eax
80105404:	78 18                	js     8010541e <create+0x15e>
80105406:	83 ec 04             	sub    $0x4,%esp
80105409:	ff 73 04             	pushl  0x4(%ebx)
8010540c:	68 5f 83 10 80       	push   $0x8010835f
80105411:	56                   	push   %esi
80105412:	e8 89 cb ff ff       	call   80101fa0 <dirlink>
80105417:	83 c4 10             	add    $0x10,%esp
8010541a:	85 c0                	test   %eax,%eax
8010541c:	79 92                	jns    801053b0 <create+0xf0>
      panic("create dots");
8010541e:	83 ec 0c             	sub    $0xc,%esp
80105421:	68 53 83 10 80       	push   $0x80108353
80105426:	e8 65 af ff ff       	call   80100390 <panic>
8010542b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010542f:	90                   	nop
}
80105430:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105433:	31 f6                	xor    %esi,%esi
}
80105435:	5b                   	pop    %ebx
80105436:	89 f0                	mov    %esi,%eax
80105438:	5e                   	pop    %esi
80105439:	5f                   	pop    %edi
8010543a:	5d                   	pop    %ebp
8010543b:	c3                   	ret    
    panic("create: dirlink");
8010543c:	83 ec 0c             	sub    $0xc,%esp
8010543f:	68 62 83 10 80       	push   $0x80108362
80105444:	e8 47 af ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105449:	83 ec 0c             	sub    $0xc,%esp
8010544c:	68 44 83 10 80       	push   $0x80108344
80105451:	e8 3a af ff ff       	call   80100390 <panic>
80105456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010545d:	8d 76 00             	lea    0x0(%esi),%esi

80105460 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	56                   	push   %esi
80105464:	89 d6                	mov    %edx,%esi
80105466:	53                   	push   %ebx
80105467:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105469:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010546c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010546f:	50                   	push   %eax
80105470:	6a 00                	push   $0x0
80105472:	e8 e9 fc ff ff       	call   80105160 <argint>
80105477:	83 c4 10             	add    $0x10,%esp
8010547a:	85 c0                	test   %eax,%eax
8010547c:	78 2a                	js     801054a8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010547e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105482:	77 24                	ja     801054a8 <argfd.constprop.0+0x48>
80105484:	e8 a7 e4 ff ff       	call   80103930 <myproc>
80105489:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010548c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105490:	85 c0                	test   %eax,%eax
80105492:	74 14                	je     801054a8 <argfd.constprop.0+0x48>
  if(pfd)
80105494:	85 db                	test   %ebx,%ebx
80105496:	74 02                	je     8010549a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105498:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010549a:	89 06                	mov    %eax,(%esi)
  return 0;
8010549c:	31 c0                	xor    %eax,%eax
}
8010549e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054a1:	5b                   	pop    %ebx
801054a2:	5e                   	pop    %esi
801054a3:	5d                   	pop    %ebp
801054a4:	c3                   	ret    
801054a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ad:	eb ef                	jmp    8010549e <argfd.constprop.0+0x3e>
801054af:	90                   	nop

801054b0 <sys_dup>:
{
801054b0:	f3 0f 1e fb          	endbr32 
801054b4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801054b5:	31 c0                	xor    %eax,%eax
{
801054b7:	89 e5                	mov    %esp,%ebp
801054b9:	56                   	push   %esi
801054ba:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801054bb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801054be:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801054c1:	e8 9a ff ff ff       	call   80105460 <argfd.constprop.0>
801054c6:	85 c0                	test   %eax,%eax
801054c8:	78 1e                	js     801054e8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801054ca:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801054cd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054cf:	e8 5c e4 ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801054d8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054dc:	85 d2                	test   %edx,%edx
801054de:	74 20                	je     80105500 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801054e0:	83 c3 01             	add    $0x1,%ebx
801054e3:	83 fb 10             	cmp    $0x10,%ebx
801054e6:	75 f0                	jne    801054d8 <sys_dup+0x28>
}
801054e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801054eb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801054f0:	89 d8                	mov    %ebx,%eax
801054f2:	5b                   	pop    %ebx
801054f3:	5e                   	pop    %esi
801054f4:	5d                   	pop    %ebp
801054f5:	c3                   	ret    
801054f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054fd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105500:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105504:	83 ec 0c             	sub    $0xc,%esp
80105507:	ff 75 f4             	pushl  -0xc(%ebp)
8010550a:	e8 91 b9 ff ff       	call   80100ea0 <filedup>
  return fd;
8010550f:	83 c4 10             	add    $0x10,%esp
}
80105512:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105515:	89 d8                	mov    %ebx,%eax
80105517:	5b                   	pop    %ebx
80105518:	5e                   	pop    %esi
80105519:	5d                   	pop    %ebp
8010551a:	c3                   	ret    
8010551b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010551f:	90                   	nop

80105520 <sys_read>:
{
80105520:	f3 0f 1e fb          	endbr32 
80105524:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105525:	31 c0                	xor    %eax,%eax
{
80105527:	89 e5                	mov    %esp,%ebp
80105529:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010552c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010552f:	e8 2c ff ff ff       	call   80105460 <argfd.constprop.0>
80105534:	85 c0                	test   %eax,%eax
80105536:	78 48                	js     80105580 <sys_read+0x60>
80105538:	83 ec 08             	sub    $0x8,%esp
8010553b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010553e:	50                   	push   %eax
8010553f:	6a 02                	push   $0x2
80105541:	e8 1a fc ff ff       	call   80105160 <argint>
80105546:	83 c4 10             	add    $0x10,%esp
80105549:	85 c0                	test   %eax,%eax
8010554b:	78 33                	js     80105580 <sys_read+0x60>
8010554d:	83 ec 04             	sub    $0x4,%esp
80105550:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105553:	ff 75 f0             	pushl  -0x10(%ebp)
80105556:	50                   	push   %eax
80105557:	6a 01                	push   $0x1
80105559:	e8 52 fc ff ff       	call   801051b0 <argptr>
8010555e:	83 c4 10             	add    $0x10,%esp
80105561:	85 c0                	test   %eax,%eax
80105563:	78 1b                	js     80105580 <sys_read+0x60>
  return fileread(f, p, n);
80105565:	83 ec 04             	sub    $0x4,%esp
80105568:	ff 75 f0             	pushl  -0x10(%ebp)
8010556b:	ff 75 f4             	pushl  -0xc(%ebp)
8010556e:	ff 75 ec             	pushl  -0x14(%ebp)
80105571:	e8 aa ba ff ff       	call   80101020 <fileread>
80105576:	83 c4 10             	add    $0x10,%esp
}
80105579:	c9                   	leave  
8010557a:	c3                   	ret    
8010557b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010557f:	90                   	nop
80105580:	c9                   	leave  
    return -1;
80105581:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105586:	c3                   	ret    
80105587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010558e:	66 90                	xchg   %ax,%ax

80105590 <sys_write>:
{
80105590:	f3 0f 1e fb          	endbr32 
80105594:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105595:	31 c0                	xor    %eax,%eax
{
80105597:	89 e5                	mov    %esp,%ebp
80105599:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010559c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010559f:	e8 bc fe ff ff       	call   80105460 <argfd.constprop.0>
801055a4:	85 c0                	test   %eax,%eax
801055a6:	78 48                	js     801055f0 <sys_write+0x60>
801055a8:	83 ec 08             	sub    $0x8,%esp
801055ab:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055ae:	50                   	push   %eax
801055af:	6a 02                	push   $0x2
801055b1:	e8 aa fb ff ff       	call   80105160 <argint>
801055b6:	83 c4 10             	add    $0x10,%esp
801055b9:	85 c0                	test   %eax,%eax
801055bb:	78 33                	js     801055f0 <sys_write+0x60>
801055bd:	83 ec 04             	sub    $0x4,%esp
801055c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055c3:	ff 75 f0             	pushl  -0x10(%ebp)
801055c6:	50                   	push   %eax
801055c7:	6a 01                	push   $0x1
801055c9:	e8 e2 fb ff ff       	call   801051b0 <argptr>
801055ce:	83 c4 10             	add    $0x10,%esp
801055d1:	85 c0                	test   %eax,%eax
801055d3:	78 1b                	js     801055f0 <sys_write+0x60>
  return filewrite(f, p, n);
801055d5:	83 ec 04             	sub    $0x4,%esp
801055d8:	ff 75 f0             	pushl  -0x10(%ebp)
801055db:	ff 75 f4             	pushl  -0xc(%ebp)
801055de:	ff 75 ec             	pushl  -0x14(%ebp)
801055e1:	e8 da ba ff ff       	call   801010c0 <filewrite>
801055e6:	83 c4 10             	add    $0x10,%esp
}
801055e9:	c9                   	leave  
801055ea:	c3                   	ret    
801055eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055ef:	90                   	nop
801055f0:	c9                   	leave  
    return -1;
801055f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055f6:	c3                   	ret    
801055f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055fe:	66 90                	xchg   %ax,%ax

80105600 <sys_close>:
{
80105600:	f3 0f 1e fb          	endbr32 
80105604:	55                   	push   %ebp
80105605:	89 e5                	mov    %esp,%ebp
80105607:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010560a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010560d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105610:	e8 4b fe ff ff       	call   80105460 <argfd.constprop.0>
80105615:	85 c0                	test   %eax,%eax
80105617:	78 27                	js     80105640 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105619:	e8 12 e3 ff ff       	call   80103930 <myproc>
8010561e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105621:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105624:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010562b:	00 
  fileclose(f);
8010562c:	ff 75 f4             	pushl  -0xc(%ebp)
8010562f:	e8 bc b8 ff ff       	call   80100ef0 <fileclose>
  return 0;
80105634:	83 c4 10             	add    $0x10,%esp
80105637:	31 c0                	xor    %eax,%eax
}
80105639:	c9                   	leave  
8010563a:	c3                   	ret    
8010563b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010563f:	90                   	nop
80105640:	c9                   	leave  
    return -1;
80105641:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105646:	c3                   	ret    
80105647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010564e:	66 90                	xchg   %ax,%ax

80105650 <sys_fstat>:
{
80105650:	f3 0f 1e fb          	endbr32 
80105654:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105655:	31 c0                	xor    %eax,%eax
{
80105657:	89 e5                	mov    %esp,%ebp
80105659:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010565c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010565f:	e8 fc fd ff ff       	call   80105460 <argfd.constprop.0>
80105664:	85 c0                	test   %eax,%eax
80105666:	78 30                	js     80105698 <sys_fstat+0x48>
80105668:	83 ec 04             	sub    $0x4,%esp
8010566b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010566e:	6a 14                	push   $0x14
80105670:	50                   	push   %eax
80105671:	6a 01                	push   $0x1
80105673:	e8 38 fb ff ff       	call   801051b0 <argptr>
80105678:	83 c4 10             	add    $0x10,%esp
8010567b:	85 c0                	test   %eax,%eax
8010567d:	78 19                	js     80105698 <sys_fstat+0x48>
  return filestat(f, st);
8010567f:	83 ec 08             	sub    $0x8,%esp
80105682:	ff 75 f4             	pushl  -0xc(%ebp)
80105685:	ff 75 f0             	pushl  -0x10(%ebp)
80105688:	e8 43 b9 ff ff       	call   80100fd0 <filestat>
8010568d:	83 c4 10             	add    $0x10,%esp
}
80105690:	c9                   	leave  
80105691:	c3                   	ret    
80105692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105698:	c9                   	leave  
    return -1;
80105699:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010569e:	c3                   	ret    
8010569f:	90                   	nop

801056a0 <sys_link>:
{
801056a0:	f3 0f 1e fb          	endbr32 
801056a4:	55                   	push   %ebp
801056a5:	89 e5                	mov    %esp,%ebp
801056a7:	57                   	push   %edi
801056a8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056a9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801056ac:	53                   	push   %ebx
801056ad:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056b0:	50                   	push   %eax
801056b1:	6a 00                	push   $0x0
801056b3:	e8 58 fb ff ff       	call   80105210 <argstr>
801056b8:	83 c4 10             	add    $0x10,%esp
801056bb:	85 c0                	test   %eax,%eax
801056bd:	0f 88 ff 00 00 00    	js     801057c2 <sys_link+0x122>
801056c3:	83 ec 08             	sub    $0x8,%esp
801056c6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801056c9:	50                   	push   %eax
801056ca:	6a 01                	push   $0x1
801056cc:	e8 3f fb ff ff       	call   80105210 <argstr>
801056d1:	83 c4 10             	add    $0x10,%esp
801056d4:	85 c0                	test   %eax,%eax
801056d6:	0f 88 e6 00 00 00    	js     801057c2 <sys_link+0x122>
  begin_op();
801056dc:	e8 7f d6 ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
801056e1:	83 ec 0c             	sub    $0xc,%esp
801056e4:	ff 75 d4             	pushl  -0x2c(%ebp)
801056e7:	e8 74 c9 ff ff       	call   80102060 <namei>
801056ec:	83 c4 10             	add    $0x10,%esp
801056ef:	89 c3                	mov    %eax,%ebx
801056f1:	85 c0                	test   %eax,%eax
801056f3:	0f 84 e8 00 00 00    	je     801057e1 <sys_link+0x141>
  ilock(ip);
801056f9:	83 ec 0c             	sub    $0xc,%esp
801056fc:	50                   	push   %eax
801056fd:	e8 8e c0 ff ff       	call   80101790 <ilock>
  if(ip->type == T_DIR){
80105702:	83 c4 10             	add    $0x10,%esp
80105705:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010570a:	0f 84 b9 00 00 00    	je     801057c9 <sys_link+0x129>
  iupdate(ip);
80105710:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105713:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105718:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010571b:	53                   	push   %ebx
8010571c:	e8 af bf ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
80105721:	89 1c 24             	mov    %ebx,(%esp)
80105724:	e8 47 c1 ff ff       	call   80101870 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105729:	58                   	pop    %eax
8010572a:	5a                   	pop    %edx
8010572b:	57                   	push   %edi
8010572c:	ff 75 d0             	pushl  -0x30(%ebp)
8010572f:	e8 4c c9 ff ff       	call   80102080 <nameiparent>
80105734:	83 c4 10             	add    $0x10,%esp
80105737:	89 c6                	mov    %eax,%esi
80105739:	85 c0                	test   %eax,%eax
8010573b:	74 5f                	je     8010579c <sys_link+0xfc>
  ilock(dp);
8010573d:	83 ec 0c             	sub    $0xc,%esp
80105740:	50                   	push   %eax
80105741:	e8 4a c0 ff ff       	call   80101790 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105746:	8b 03                	mov    (%ebx),%eax
80105748:	83 c4 10             	add    $0x10,%esp
8010574b:	39 06                	cmp    %eax,(%esi)
8010574d:	75 41                	jne    80105790 <sys_link+0xf0>
8010574f:	83 ec 04             	sub    $0x4,%esp
80105752:	ff 73 04             	pushl  0x4(%ebx)
80105755:	57                   	push   %edi
80105756:	56                   	push   %esi
80105757:	e8 44 c8 ff ff       	call   80101fa0 <dirlink>
8010575c:	83 c4 10             	add    $0x10,%esp
8010575f:	85 c0                	test   %eax,%eax
80105761:	78 2d                	js     80105790 <sys_link+0xf0>
  iunlockput(dp);
80105763:	83 ec 0c             	sub    $0xc,%esp
80105766:	56                   	push   %esi
80105767:	e8 c4 c2 ff ff       	call   80101a30 <iunlockput>
  iput(ip);
8010576c:	89 1c 24             	mov    %ebx,(%esp)
8010576f:	e8 4c c1 ff ff       	call   801018c0 <iput>
  end_op();
80105774:	e8 57 d6 ff ff       	call   80102dd0 <end_op>
  return 0;
80105779:	83 c4 10             	add    $0x10,%esp
8010577c:	31 c0                	xor    %eax,%eax
}
8010577e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105781:	5b                   	pop    %ebx
80105782:	5e                   	pop    %esi
80105783:	5f                   	pop    %edi
80105784:	5d                   	pop    %ebp
80105785:	c3                   	ret    
80105786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	56                   	push   %esi
80105794:	e8 97 c2 ff ff       	call   80101a30 <iunlockput>
    goto bad;
80105799:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010579c:	83 ec 0c             	sub    $0xc,%esp
8010579f:	53                   	push   %ebx
801057a0:	e8 eb bf ff ff       	call   80101790 <ilock>
  ip->nlink--;
801057a5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057aa:	89 1c 24             	mov    %ebx,(%esp)
801057ad:	e8 1e bf ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801057b2:	89 1c 24             	mov    %ebx,(%esp)
801057b5:	e8 76 c2 ff ff       	call   80101a30 <iunlockput>
  end_op();
801057ba:	e8 11 d6 ff ff       	call   80102dd0 <end_op>
  return -1;
801057bf:	83 c4 10             	add    $0x10,%esp
801057c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057c7:	eb b5                	jmp    8010577e <sys_link+0xde>
    iunlockput(ip);
801057c9:	83 ec 0c             	sub    $0xc,%esp
801057cc:	53                   	push   %ebx
801057cd:	e8 5e c2 ff ff       	call   80101a30 <iunlockput>
    end_op();
801057d2:	e8 f9 d5 ff ff       	call   80102dd0 <end_op>
    return -1;
801057d7:	83 c4 10             	add    $0x10,%esp
801057da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057df:	eb 9d                	jmp    8010577e <sys_link+0xde>
    end_op();
801057e1:	e8 ea d5 ff ff       	call   80102dd0 <end_op>
    return -1;
801057e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057eb:	eb 91                	jmp    8010577e <sys_link+0xde>
801057ed:	8d 76 00             	lea    0x0(%esi),%esi

801057f0 <sys_unlink>:
{
801057f0:	f3 0f 1e fb          	endbr32 
801057f4:	55                   	push   %ebp
801057f5:	89 e5                	mov    %esp,%ebp
801057f7:	57                   	push   %edi
801057f8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801057f9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801057fc:	53                   	push   %ebx
801057fd:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105800:	50                   	push   %eax
80105801:	6a 00                	push   $0x0
80105803:	e8 08 fa ff ff       	call   80105210 <argstr>
80105808:	83 c4 10             	add    $0x10,%esp
8010580b:	85 c0                	test   %eax,%eax
8010580d:	0f 88 7d 01 00 00    	js     80105990 <sys_unlink+0x1a0>
  begin_op();
80105813:	e8 48 d5 ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105818:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010581b:	83 ec 08             	sub    $0x8,%esp
8010581e:	53                   	push   %ebx
8010581f:	ff 75 c0             	pushl  -0x40(%ebp)
80105822:	e8 59 c8 ff ff       	call   80102080 <nameiparent>
80105827:	83 c4 10             	add    $0x10,%esp
8010582a:	89 c6                	mov    %eax,%esi
8010582c:	85 c0                	test   %eax,%eax
8010582e:	0f 84 66 01 00 00    	je     8010599a <sys_unlink+0x1aa>
  ilock(dp);
80105834:	83 ec 0c             	sub    $0xc,%esp
80105837:	50                   	push   %eax
80105838:	e8 53 bf ff ff       	call   80101790 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010583d:	58                   	pop    %eax
8010583e:	5a                   	pop    %edx
8010583f:	68 60 83 10 80       	push   $0x80108360
80105844:	53                   	push   %ebx
80105845:	e8 76 c4 ff ff       	call   80101cc0 <namecmp>
8010584a:	83 c4 10             	add    $0x10,%esp
8010584d:	85 c0                	test   %eax,%eax
8010584f:	0f 84 03 01 00 00    	je     80105958 <sys_unlink+0x168>
80105855:	83 ec 08             	sub    $0x8,%esp
80105858:	68 5f 83 10 80       	push   $0x8010835f
8010585d:	53                   	push   %ebx
8010585e:	e8 5d c4 ff ff       	call   80101cc0 <namecmp>
80105863:	83 c4 10             	add    $0x10,%esp
80105866:	85 c0                	test   %eax,%eax
80105868:	0f 84 ea 00 00 00    	je     80105958 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010586e:	83 ec 04             	sub    $0x4,%esp
80105871:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105874:	50                   	push   %eax
80105875:	53                   	push   %ebx
80105876:	56                   	push   %esi
80105877:	e8 64 c4 ff ff       	call   80101ce0 <dirlookup>
8010587c:	83 c4 10             	add    $0x10,%esp
8010587f:	89 c3                	mov    %eax,%ebx
80105881:	85 c0                	test   %eax,%eax
80105883:	0f 84 cf 00 00 00    	je     80105958 <sys_unlink+0x168>
  ilock(ip);
80105889:	83 ec 0c             	sub    $0xc,%esp
8010588c:	50                   	push   %eax
8010588d:	e8 fe be ff ff       	call   80101790 <ilock>
  if(ip->nlink < 1)
80105892:	83 c4 10             	add    $0x10,%esp
80105895:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010589a:	0f 8e 23 01 00 00    	jle    801059c3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801058a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058a5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801058a8:	74 66                	je     80105910 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801058aa:	83 ec 04             	sub    $0x4,%esp
801058ad:	6a 10                	push   $0x10
801058af:	6a 00                	push   $0x0
801058b1:	57                   	push   %edi
801058b2:	e8 c9 f5 ff ff       	call   80104e80 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058b7:	6a 10                	push   $0x10
801058b9:	ff 75 c4             	pushl  -0x3c(%ebp)
801058bc:	57                   	push   %edi
801058bd:	56                   	push   %esi
801058be:	e8 cd c2 ff ff       	call   80101b90 <writei>
801058c3:	83 c4 20             	add    $0x20,%esp
801058c6:	83 f8 10             	cmp    $0x10,%eax
801058c9:	0f 85 e7 00 00 00    	jne    801059b6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801058cf:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058d4:	0f 84 96 00 00 00    	je     80105970 <sys_unlink+0x180>
  iunlockput(dp);
801058da:	83 ec 0c             	sub    $0xc,%esp
801058dd:	56                   	push   %esi
801058de:	e8 4d c1 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
801058e3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801058e8:	89 1c 24             	mov    %ebx,(%esp)
801058eb:	e8 e0 bd ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801058f0:	89 1c 24             	mov    %ebx,(%esp)
801058f3:	e8 38 c1 ff ff       	call   80101a30 <iunlockput>
  end_op();
801058f8:	e8 d3 d4 ff ff       	call   80102dd0 <end_op>
  return 0;
801058fd:	83 c4 10             	add    $0x10,%esp
80105900:	31 c0                	xor    %eax,%eax
}
80105902:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105905:	5b                   	pop    %ebx
80105906:	5e                   	pop    %esi
80105907:	5f                   	pop    %edi
80105908:	5d                   	pop    %ebp
80105909:	c3                   	ret    
8010590a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105910:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105914:	76 94                	jbe    801058aa <sys_unlink+0xba>
80105916:	ba 20 00 00 00       	mov    $0x20,%edx
8010591b:	eb 0b                	jmp    80105928 <sys_unlink+0x138>
8010591d:	8d 76 00             	lea    0x0(%esi),%esi
80105920:	83 c2 10             	add    $0x10,%edx
80105923:	39 53 58             	cmp    %edx,0x58(%ebx)
80105926:	76 82                	jbe    801058aa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105928:	6a 10                	push   $0x10
8010592a:	52                   	push   %edx
8010592b:	57                   	push   %edi
8010592c:	53                   	push   %ebx
8010592d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105930:	e8 5b c1 ff ff       	call   80101a90 <readi>
80105935:	83 c4 10             	add    $0x10,%esp
80105938:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010593b:	83 f8 10             	cmp    $0x10,%eax
8010593e:	75 69                	jne    801059a9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105940:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105945:	74 d9                	je     80105920 <sys_unlink+0x130>
    iunlockput(ip);
80105947:	83 ec 0c             	sub    $0xc,%esp
8010594a:	53                   	push   %ebx
8010594b:	e8 e0 c0 ff ff       	call   80101a30 <iunlockput>
    goto bad;
80105950:	83 c4 10             	add    $0x10,%esp
80105953:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105957:	90                   	nop
  iunlockput(dp);
80105958:	83 ec 0c             	sub    $0xc,%esp
8010595b:	56                   	push   %esi
8010595c:	e8 cf c0 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105961:	e8 6a d4 ff ff       	call   80102dd0 <end_op>
  return -1;
80105966:	83 c4 10             	add    $0x10,%esp
80105969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010596e:	eb 92                	jmp    80105902 <sys_unlink+0x112>
    iupdate(dp);
80105970:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105973:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105978:	56                   	push   %esi
80105979:	e8 52 bd ff ff       	call   801016d0 <iupdate>
8010597e:	83 c4 10             	add    $0x10,%esp
80105981:	e9 54 ff ff ff       	jmp    801058da <sys_unlink+0xea>
80105986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105995:	e9 68 ff ff ff       	jmp    80105902 <sys_unlink+0x112>
    end_op();
8010599a:	e8 31 d4 ff ff       	call   80102dd0 <end_op>
    return -1;
8010599f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059a4:	e9 59 ff ff ff       	jmp    80105902 <sys_unlink+0x112>
      panic("isdirempty: readi");
801059a9:	83 ec 0c             	sub    $0xc,%esp
801059ac:	68 84 83 10 80       	push   $0x80108384
801059b1:	e8 da a9 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801059b6:	83 ec 0c             	sub    $0xc,%esp
801059b9:	68 96 83 10 80       	push   $0x80108396
801059be:	e8 cd a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801059c3:	83 ec 0c             	sub    $0xc,%esp
801059c6:	68 72 83 10 80       	push   $0x80108372
801059cb:	e8 c0 a9 ff ff       	call   80100390 <panic>

801059d0 <sys_open>:

int
sys_open(void)
{
801059d0:	f3 0f 1e fb          	endbr32 
801059d4:	55                   	push   %ebp
801059d5:	89 e5                	mov    %esp,%ebp
801059d7:	57                   	push   %edi
801059d8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801059dc:	53                   	push   %ebx
801059dd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059e0:	50                   	push   %eax
801059e1:	6a 00                	push   $0x0
801059e3:	e8 28 f8 ff ff       	call   80105210 <argstr>
801059e8:	83 c4 10             	add    $0x10,%esp
801059eb:	85 c0                	test   %eax,%eax
801059ed:	0f 88 8a 00 00 00    	js     80105a7d <sys_open+0xad>
801059f3:	83 ec 08             	sub    $0x8,%esp
801059f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059f9:	50                   	push   %eax
801059fa:	6a 01                	push   $0x1
801059fc:	e8 5f f7 ff ff       	call   80105160 <argint>
80105a01:	83 c4 10             	add    $0x10,%esp
80105a04:	85 c0                	test   %eax,%eax
80105a06:	78 75                	js     80105a7d <sys_open+0xad>
    return -1;

  begin_op();
80105a08:	e8 53 d3 ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
80105a0d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a11:	75 75                	jne    80105a88 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a13:	83 ec 0c             	sub    $0xc,%esp
80105a16:	ff 75 e0             	pushl  -0x20(%ebp)
80105a19:	e8 42 c6 ff ff       	call   80102060 <namei>
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	89 c6                	mov    %eax,%esi
80105a23:	85 c0                	test   %eax,%eax
80105a25:	74 7e                	je     80105aa5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105a27:	83 ec 0c             	sub    $0xc,%esp
80105a2a:	50                   	push   %eax
80105a2b:	e8 60 bd ff ff       	call   80101790 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a30:	83 c4 10             	add    $0x10,%esp
80105a33:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105a38:	0f 84 c2 00 00 00    	je     80105b00 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105a3e:	e8 ed b3 ff ff       	call   80100e30 <filealloc>
80105a43:	89 c7                	mov    %eax,%edi
80105a45:	85 c0                	test   %eax,%eax
80105a47:	74 23                	je     80105a6c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105a49:	e8 e2 de ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a4e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105a50:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105a54:	85 d2                	test   %edx,%edx
80105a56:	74 60                	je     80105ab8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105a58:	83 c3 01             	add    $0x1,%ebx
80105a5b:	83 fb 10             	cmp    $0x10,%ebx
80105a5e:	75 f0                	jne    80105a50 <sys_open+0x80>
    if(f)
      fileclose(f);
80105a60:	83 ec 0c             	sub    $0xc,%esp
80105a63:	57                   	push   %edi
80105a64:	e8 87 b4 ff ff       	call   80100ef0 <fileclose>
80105a69:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105a6c:	83 ec 0c             	sub    $0xc,%esp
80105a6f:	56                   	push   %esi
80105a70:	e8 bb bf ff ff       	call   80101a30 <iunlockput>
    end_op();
80105a75:	e8 56 d3 ff ff       	call   80102dd0 <end_op>
    return -1;
80105a7a:	83 c4 10             	add    $0x10,%esp
80105a7d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a82:	eb 6d                	jmp    80105af1 <sys_open+0x121>
80105a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105a88:	83 ec 0c             	sub    $0xc,%esp
80105a8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a8e:	31 c9                	xor    %ecx,%ecx
80105a90:	ba 02 00 00 00       	mov    $0x2,%edx
80105a95:	6a 00                	push   $0x0
80105a97:	e8 24 f8 ff ff       	call   801052c0 <create>
    if(ip == 0){
80105a9c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105a9f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105aa1:	85 c0                	test   %eax,%eax
80105aa3:	75 99                	jne    80105a3e <sys_open+0x6e>
      end_op();
80105aa5:	e8 26 d3 ff ff       	call   80102dd0 <end_op>
      return -1;
80105aaa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105aaf:	eb 40                	jmp    80105af1 <sys_open+0x121>
80105ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105ab8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105abb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105abf:	56                   	push   %esi
80105ac0:	e8 ab bd ff ff       	call   80101870 <iunlock>
  end_op();
80105ac5:	e8 06 d3 ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
80105aca:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105ad0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ad3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105ad6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105ad9:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105adb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105ae2:	f7 d0                	not    %eax
80105ae4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ae7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105aea:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105aed:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105af1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105af4:	89 d8                	mov    %ebx,%eax
80105af6:	5b                   	pop    %ebx
80105af7:	5e                   	pop    %esi
80105af8:	5f                   	pop    %edi
80105af9:	5d                   	pop    %ebp
80105afa:	c3                   	ret    
80105afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aff:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b00:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b03:	85 c9                	test   %ecx,%ecx
80105b05:	0f 84 33 ff ff ff    	je     80105a3e <sys_open+0x6e>
80105b0b:	e9 5c ff ff ff       	jmp    80105a6c <sys_open+0x9c>

80105b10 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b10:	f3 0f 1e fb          	endbr32 
80105b14:	55                   	push   %ebp
80105b15:	89 e5                	mov    %esp,%ebp
80105b17:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b1a:	e8 41 d2 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b1f:	83 ec 08             	sub    $0x8,%esp
80105b22:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b25:	50                   	push   %eax
80105b26:	6a 00                	push   $0x0
80105b28:	e8 e3 f6 ff ff       	call   80105210 <argstr>
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	85 c0                	test   %eax,%eax
80105b32:	78 34                	js     80105b68 <sys_mkdir+0x58>
80105b34:	83 ec 0c             	sub    $0xc,%esp
80105b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b3a:	31 c9                	xor    %ecx,%ecx
80105b3c:	ba 01 00 00 00       	mov    $0x1,%edx
80105b41:	6a 00                	push   $0x0
80105b43:	e8 78 f7 ff ff       	call   801052c0 <create>
80105b48:	83 c4 10             	add    $0x10,%esp
80105b4b:	85 c0                	test   %eax,%eax
80105b4d:	74 19                	je     80105b68 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b4f:	83 ec 0c             	sub    $0xc,%esp
80105b52:	50                   	push   %eax
80105b53:	e8 d8 be ff ff       	call   80101a30 <iunlockput>
  end_op();
80105b58:	e8 73 d2 ff ff       	call   80102dd0 <end_op>
  return 0;
80105b5d:	83 c4 10             	add    $0x10,%esp
80105b60:	31 c0                	xor    %eax,%eax
}
80105b62:	c9                   	leave  
80105b63:	c3                   	ret    
80105b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b68:	e8 63 d2 ff ff       	call   80102dd0 <end_op>
    return -1;
80105b6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b72:	c9                   	leave  
80105b73:	c3                   	ret    
80105b74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b7f:	90                   	nop

80105b80 <sys_mknod>:

int
sys_mknod(void)
{
80105b80:	f3 0f 1e fb          	endbr32 
80105b84:	55                   	push   %ebp
80105b85:	89 e5                	mov    %esp,%ebp
80105b87:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105b8a:	e8 d1 d1 ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105b8f:	83 ec 08             	sub    $0x8,%esp
80105b92:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b95:	50                   	push   %eax
80105b96:	6a 00                	push   $0x0
80105b98:	e8 73 f6 ff ff       	call   80105210 <argstr>
80105b9d:	83 c4 10             	add    $0x10,%esp
80105ba0:	85 c0                	test   %eax,%eax
80105ba2:	78 64                	js     80105c08 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105ba4:	83 ec 08             	sub    $0x8,%esp
80105ba7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105baa:	50                   	push   %eax
80105bab:	6a 01                	push   $0x1
80105bad:	e8 ae f5 ff ff       	call   80105160 <argint>
  if((argstr(0, &path)) < 0 ||
80105bb2:	83 c4 10             	add    $0x10,%esp
80105bb5:	85 c0                	test   %eax,%eax
80105bb7:	78 4f                	js     80105c08 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105bb9:	83 ec 08             	sub    $0x8,%esp
80105bbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bbf:	50                   	push   %eax
80105bc0:	6a 02                	push   $0x2
80105bc2:	e8 99 f5 ff ff       	call   80105160 <argint>
     argint(1, &major) < 0 ||
80105bc7:	83 c4 10             	add    $0x10,%esp
80105bca:	85 c0                	test   %eax,%eax
80105bcc:	78 3a                	js     80105c08 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105bce:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105bd2:	83 ec 0c             	sub    $0xc,%esp
80105bd5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105bd9:	ba 03 00 00 00       	mov    $0x3,%edx
80105bde:	50                   	push   %eax
80105bdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105be2:	e8 d9 f6 ff ff       	call   801052c0 <create>
     argint(2, &minor) < 0 ||
80105be7:	83 c4 10             	add    $0x10,%esp
80105bea:	85 c0                	test   %eax,%eax
80105bec:	74 1a                	je     80105c08 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bee:	83 ec 0c             	sub    $0xc,%esp
80105bf1:	50                   	push   %eax
80105bf2:	e8 39 be ff ff       	call   80101a30 <iunlockput>
  end_op();
80105bf7:	e8 d4 d1 ff ff       	call   80102dd0 <end_op>
  return 0;
80105bfc:	83 c4 10             	add    $0x10,%esp
80105bff:	31 c0                	xor    %eax,%eax
}
80105c01:	c9                   	leave  
80105c02:	c3                   	ret    
80105c03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c07:	90                   	nop
    end_op();
80105c08:	e8 c3 d1 ff ff       	call   80102dd0 <end_op>
    return -1;
80105c0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c12:	c9                   	leave  
80105c13:	c3                   	ret    
80105c14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c1f:	90                   	nop

80105c20 <sys_chdir>:

int
sys_chdir(void)
{
80105c20:	f3 0f 1e fb          	endbr32 
80105c24:	55                   	push   %ebp
80105c25:	89 e5                	mov    %esp,%ebp
80105c27:	56                   	push   %esi
80105c28:	53                   	push   %ebx
80105c29:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c2c:	e8 ff dc ff ff       	call   80103930 <myproc>
80105c31:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c33:	e8 28 d1 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105c38:	83 ec 08             	sub    $0x8,%esp
80105c3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c3e:	50                   	push   %eax
80105c3f:	6a 00                	push   $0x0
80105c41:	e8 ca f5 ff ff       	call   80105210 <argstr>
80105c46:	83 c4 10             	add    $0x10,%esp
80105c49:	85 c0                	test   %eax,%eax
80105c4b:	78 73                	js     80105cc0 <sys_chdir+0xa0>
80105c4d:	83 ec 0c             	sub    $0xc,%esp
80105c50:	ff 75 f4             	pushl  -0xc(%ebp)
80105c53:	e8 08 c4 ff ff       	call   80102060 <namei>
80105c58:	83 c4 10             	add    $0x10,%esp
80105c5b:	89 c3                	mov    %eax,%ebx
80105c5d:	85 c0                	test   %eax,%eax
80105c5f:	74 5f                	je     80105cc0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105c61:	83 ec 0c             	sub    $0xc,%esp
80105c64:	50                   	push   %eax
80105c65:	e8 26 bb ff ff       	call   80101790 <ilock>
  if(ip->type != T_DIR){
80105c6a:	83 c4 10             	add    $0x10,%esp
80105c6d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c72:	75 2c                	jne    80105ca0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c74:	83 ec 0c             	sub    $0xc,%esp
80105c77:	53                   	push   %ebx
80105c78:	e8 f3 bb ff ff       	call   80101870 <iunlock>
  iput(curproc->cwd);
80105c7d:	58                   	pop    %eax
80105c7e:	ff 76 68             	pushl  0x68(%esi)
80105c81:	e8 3a bc ff ff       	call   801018c0 <iput>
  end_op();
80105c86:	e8 45 d1 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80105c8b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105c8e:	83 c4 10             	add    $0x10,%esp
80105c91:	31 c0                	xor    %eax,%eax
}
80105c93:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c96:	5b                   	pop    %ebx
80105c97:	5e                   	pop    %esi
80105c98:	5d                   	pop    %ebp
80105c99:	c3                   	ret    
80105c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105ca0:	83 ec 0c             	sub    $0xc,%esp
80105ca3:	53                   	push   %ebx
80105ca4:	e8 87 bd ff ff       	call   80101a30 <iunlockput>
    end_op();
80105ca9:	e8 22 d1 ff ff       	call   80102dd0 <end_op>
    return -1;
80105cae:	83 c4 10             	add    $0x10,%esp
80105cb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cb6:	eb db                	jmp    80105c93 <sys_chdir+0x73>
80105cb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbf:	90                   	nop
    end_op();
80105cc0:	e8 0b d1 ff ff       	call   80102dd0 <end_op>
    return -1;
80105cc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cca:	eb c7                	jmp    80105c93 <sys_chdir+0x73>
80105ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cd0 <sys_exec>:

int
sys_exec(void)
{
80105cd0:	f3 0f 1e fb          	endbr32 
80105cd4:	55                   	push   %ebp
80105cd5:	89 e5                	mov    %esp,%ebp
80105cd7:	57                   	push   %edi
80105cd8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105cd9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105cdf:	53                   	push   %ebx
80105ce0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ce6:	50                   	push   %eax
80105ce7:	6a 00                	push   $0x0
80105ce9:	e8 22 f5 ff ff       	call   80105210 <argstr>
80105cee:	83 c4 10             	add    $0x10,%esp
80105cf1:	85 c0                	test   %eax,%eax
80105cf3:	0f 88 8b 00 00 00    	js     80105d84 <sys_exec+0xb4>
80105cf9:	83 ec 08             	sub    $0x8,%esp
80105cfc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d02:	50                   	push   %eax
80105d03:	6a 01                	push   $0x1
80105d05:	e8 56 f4 ff ff       	call   80105160 <argint>
80105d0a:	83 c4 10             	add    $0x10,%esp
80105d0d:	85 c0                	test   %eax,%eax
80105d0f:	78 73                	js     80105d84 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d11:	83 ec 04             	sub    $0x4,%esp
80105d14:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105d1a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d1c:	68 80 00 00 00       	push   $0x80
80105d21:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105d27:	6a 00                	push   $0x0
80105d29:	50                   	push   %eax
80105d2a:	e8 51 f1 ff ff       	call   80104e80 <memset>
80105d2f:	83 c4 10             	add    $0x10,%esp
80105d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d38:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d3e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105d45:	83 ec 08             	sub    $0x8,%esp
80105d48:	57                   	push   %edi
80105d49:	01 f0                	add    %esi,%eax
80105d4b:	50                   	push   %eax
80105d4c:	e8 6f f3 ff ff       	call   801050c0 <fetchint>
80105d51:	83 c4 10             	add    $0x10,%esp
80105d54:	85 c0                	test   %eax,%eax
80105d56:	78 2c                	js     80105d84 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105d58:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105d5e:	85 c0                	test   %eax,%eax
80105d60:	74 36                	je     80105d98 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105d62:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105d68:	83 ec 08             	sub    $0x8,%esp
80105d6b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105d6e:	52                   	push   %edx
80105d6f:	50                   	push   %eax
80105d70:	e8 8b f3 ff ff       	call   80105100 <fetchstr>
80105d75:	83 c4 10             	add    $0x10,%esp
80105d78:	85 c0                	test   %eax,%eax
80105d7a:	78 08                	js     80105d84 <sys_exec+0xb4>
  for(i=0;; i++){
80105d7c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105d7f:	83 fb 20             	cmp    $0x20,%ebx
80105d82:	75 b4                	jne    80105d38 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105d87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d8c:	5b                   	pop    %ebx
80105d8d:	5e                   	pop    %esi
80105d8e:	5f                   	pop    %edi
80105d8f:	5d                   	pop    %ebp
80105d90:	c3                   	ret    
80105d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105d98:	83 ec 08             	sub    $0x8,%esp
80105d9b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105da1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105da8:	00 00 00 00 
  return exec(path, argv);
80105dac:	50                   	push   %eax
80105dad:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105db3:	e8 c8 ac ff ff       	call   80100a80 <exec>
80105db8:	83 c4 10             	add    $0x10,%esp
}
80105dbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dbe:	5b                   	pop    %ebx
80105dbf:	5e                   	pop    %esi
80105dc0:	5f                   	pop    %edi
80105dc1:	5d                   	pop    %ebp
80105dc2:	c3                   	ret    
80105dc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105dd0 <sys_pipe>:

int
sys_pipe(void)
{
80105dd0:	f3 0f 1e fb          	endbr32 
80105dd4:	55                   	push   %ebp
80105dd5:	89 e5                	mov    %esp,%ebp
80105dd7:	57                   	push   %edi
80105dd8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105dd9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105ddc:	53                   	push   %ebx
80105ddd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105de0:	6a 08                	push   $0x8
80105de2:	50                   	push   %eax
80105de3:	6a 00                	push   $0x0
80105de5:	e8 c6 f3 ff ff       	call   801051b0 <argptr>
80105dea:	83 c4 10             	add    $0x10,%esp
80105ded:	85 c0                	test   %eax,%eax
80105def:	78 4e                	js     80105e3f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105df1:	83 ec 08             	sub    $0x8,%esp
80105df4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105df7:	50                   	push   %eax
80105df8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105dfb:	50                   	push   %eax
80105dfc:	e8 1f d6 ff ff       	call   80103420 <pipealloc>
80105e01:	83 c4 10             	add    $0x10,%esp
80105e04:	85 c0                	test   %eax,%eax
80105e06:	78 37                	js     80105e3f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e08:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e0b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e0d:	e8 1e db ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105e18:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e1c:	85 f6                	test   %esi,%esi
80105e1e:	74 30                	je     80105e50 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105e20:	83 c3 01             	add    $0x1,%ebx
80105e23:	83 fb 10             	cmp    $0x10,%ebx
80105e26:	75 f0                	jne    80105e18 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e28:	83 ec 0c             	sub    $0xc,%esp
80105e2b:	ff 75 e0             	pushl  -0x20(%ebp)
80105e2e:	e8 bd b0 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
80105e33:	58                   	pop    %eax
80105e34:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e37:	e8 b4 b0 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105e3c:	83 c4 10             	add    $0x10,%esp
80105e3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e44:	eb 5b                	jmp    80105ea1 <sys_pipe+0xd1>
80105e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105e50:	8d 73 08             	lea    0x8(%ebx),%esi
80105e53:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105e5a:	e8 d1 da ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e5f:	31 d2                	xor    %edx,%edx
80105e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105e68:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105e6c:	85 c9                	test   %ecx,%ecx
80105e6e:	74 20                	je     80105e90 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105e70:	83 c2 01             	add    $0x1,%edx
80105e73:	83 fa 10             	cmp    $0x10,%edx
80105e76:	75 f0                	jne    80105e68 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105e78:	e8 b3 da ff ff       	call   80103930 <myproc>
80105e7d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105e84:	00 
80105e85:	eb a1                	jmp    80105e28 <sys_pipe+0x58>
80105e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e8e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e90:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105e94:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e97:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105e99:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e9c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105e9f:	31 c0                	xor    %eax,%eax
}
80105ea1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea4:	5b                   	pop    %ebx
80105ea5:	5e                   	pop    %esi
80105ea6:	5f                   	pop    %edi
80105ea7:	5d                   	pop    %ebp
80105ea8:	c3                   	ret    
80105ea9:	66 90                	xchg   %ax,%ax
80105eab:	66 90                	xchg   %ax,%ax
80105ead:	66 90                	xchg   %ax,%ax
80105eaf:	90                   	nop

80105eb0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105eb0:	f3 0f 1e fb          	endbr32 
  return fork();
80105eb4:	e9 f7 dd ff ff       	jmp    80103cb0 <fork>
80105eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ec0 <sys_exit>:
}

int
sys_exit(void)
{
80105ec0:	f3 0f 1e fb          	endbr32 
80105ec4:	55                   	push   %ebp
80105ec5:	89 e5                	mov    %esp,%ebp
80105ec7:	83 ec 08             	sub    $0x8,%esp
  exit();
80105eca:	e8 c1 e1 ff ff       	call   80104090 <exit>
  return 0;  // not reached
}
80105ecf:	31 c0                	xor    %eax,%eax
80105ed1:	c9                   	leave  
80105ed2:	c3                   	ret    
80105ed3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ee0 <sys_wait>:

int
sys_wait(void)
{
80105ee0:	f3 0f 1e fb          	endbr32 
  return wait();
80105ee4:	e9 17 e3 ff ff       	jmp    80104200 <wait>
80105ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ef0 <sys_kill>:
}

int
sys_kill(void)
{
80105ef0:	f3 0f 1e fb          	endbr32 
80105ef4:	55                   	push   %ebp
80105ef5:	89 e5                	mov    %esp,%ebp
80105ef7:	83 ec 20             	sub    $0x20,%esp
  int pid, signum;

  if(argint(0, &pid) < 0 || argint(1, &signum) < 0){
80105efa:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105efd:	50                   	push   %eax
80105efe:	6a 00                	push   $0x0
80105f00:	e8 5b f2 ff ff       	call   80105160 <argint>
80105f05:	83 c4 10             	add    $0x10,%esp
80105f08:	85 c0                	test   %eax,%eax
80105f0a:	78 2c                	js     80105f38 <sys_kill+0x48>
80105f0c:	83 ec 08             	sub    $0x8,%esp
80105f0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f12:	50                   	push   %eax
80105f13:	6a 01                	push   $0x1
80105f15:	e8 46 f2 ff ff       	call   80105160 <argint>
80105f1a:	83 c4 10             	add    $0x10,%esp
80105f1d:	85 c0                	test   %eax,%eax
80105f1f:	78 17                	js     80105f38 <sys_kill+0x48>
    return -1;
  }
  return kill(pid, signum);
80105f21:	83 ec 08             	sub    $0x8,%esp
80105f24:	ff 75 f4             	pushl  -0xc(%ebp)
80105f27:	ff 75 f0             	pushl  -0x10(%ebp)
80105f2a:	e8 31 e6 ff ff       	call   80104560 <kill>
80105f2f:	83 c4 10             	add    $0x10,%esp
}
80105f32:	c9                   	leave  
80105f33:	c3                   	ret    
80105f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f38:	c9                   	leave  
    return -1;
80105f39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f3e:	c3                   	ret    
80105f3f:	90                   	nop

80105f40 <sys_getpid>:

int
sys_getpid(void)
{
80105f40:	f3 0f 1e fb          	endbr32 
80105f44:	55                   	push   %ebp
80105f45:	89 e5                	mov    %esp,%ebp
80105f47:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f4a:	e8 e1 d9 ff ff       	call   80103930 <myproc>
80105f4f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f52:	c9                   	leave  
80105f53:	c3                   	ret    
80105f54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f5f:	90                   	nop

80105f60 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f60:	f3 0f 1e fb          	endbr32 
80105f64:	55                   	push   %ebp
80105f65:	89 e5                	mov    %esp,%ebp
80105f67:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f68:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f6b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f6e:	50                   	push   %eax
80105f6f:	6a 00                	push   $0x0
80105f71:	e8 ea f1 ff ff       	call   80105160 <argint>
80105f76:	83 c4 10             	add    $0x10,%esp
80105f79:	85 c0                	test   %eax,%eax
80105f7b:	78 23                	js     80105fa0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f7d:	e8 ae d9 ff ff       	call   80103930 <myproc>
  if(growproc(n) < 0)
80105f82:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105f85:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f87:	ff 75 f4             	pushl  -0xc(%ebp)
80105f8a:	e8 a1 dc ff ff       	call   80103c30 <growproc>
80105f8f:	83 c4 10             	add    $0x10,%esp
80105f92:	85 c0                	test   %eax,%eax
80105f94:	78 0a                	js     80105fa0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105f96:	89 d8                	mov    %ebx,%eax
80105f98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f9b:	c9                   	leave  
80105f9c:	c3                   	ret    
80105f9d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105fa0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fa5:	eb ef                	jmp    80105f96 <sys_sbrk+0x36>
80105fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fae:	66 90                	xchg   %ax,%ax

80105fb0 <sys_sleep>:

int
sys_sleep(void)
{
80105fb0:	f3 0f 1e fb          	endbr32 
80105fb4:	55                   	push   %ebp
80105fb5:	89 e5                	mov    %esp,%ebp
80105fb7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105fb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105fbb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105fbe:	50                   	push   %eax
80105fbf:	6a 00                	push   $0x0
80105fc1:	e8 9a f1 ff ff       	call   80105160 <argint>
80105fc6:	83 c4 10             	add    $0x10,%esp
80105fc9:	85 c0                	test   %eax,%eax
80105fcb:	0f 88 86 00 00 00    	js     80106057 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105fd1:	83 ec 0c             	sub    $0xc,%esp
80105fd4:	68 60 a3 11 80       	push   $0x8011a360
80105fd9:	e8 92 ed ff ff       	call   80104d70 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105fe1:	8b 1d a0 ab 11 80    	mov    0x8011aba0,%ebx
  while(ticks - ticks0 < n){
80105fe7:	83 c4 10             	add    $0x10,%esp
80105fea:	85 d2                	test   %edx,%edx
80105fec:	75 23                	jne    80106011 <sys_sleep+0x61>
80105fee:	eb 50                	jmp    80106040 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ff0:	83 ec 08             	sub    $0x8,%esp
80105ff3:	68 60 a3 11 80       	push   $0x8011a360
80105ff8:	68 a0 ab 11 80       	push   $0x8011aba0
80105ffd:	e8 4e e4 ff ff       	call   80104450 <sleep>
  while(ticks - ticks0 < n){
80106002:	a1 a0 ab 11 80       	mov    0x8011aba0,%eax
80106007:	83 c4 10             	add    $0x10,%esp
8010600a:	29 d8                	sub    %ebx,%eax
8010600c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010600f:	73 2f                	jae    80106040 <sys_sleep+0x90>
    if(myproc()->killed){
80106011:	e8 1a d9 ff ff       	call   80103930 <myproc>
80106016:	8b 40 24             	mov    0x24(%eax),%eax
80106019:	85 c0                	test   %eax,%eax
8010601b:	74 d3                	je     80105ff0 <sys_sleep+0x40>
      release(&tickslock);
8010601d:	83 ec 0c             	sub    $0xc,%esp
80106020:	68 60 a3 11 80       	push   $0x8011a360
80106025:	e8 06 ee ff ff       	call   80104e30 <release>
  }
  release(&tickslock);
  return 0;
}
8010602a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010602d:	83 c4 10             	add    $0x10,%esp
80106030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106035:	c9                   	leave  
80106036:	c3                   	ret    
80106037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010603e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106040:	83 ec 0c             	sub    $0xc,%esp
80106043:	68 60 a3 11 80       	push   $0x8011a360
80106048:	e8 e3 ed ff ff       	call   80104e30 <release>
  return 0;
8010604d:	83 c4 10             	add    $0x10,%esp
80106050:	31 c0                	xor    %eax,%eax
}
80106052:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106055:	c9                   	leave  
80106056:	c3                   	ret    
    return -1;
80106057:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010605c:	eb f4                	jmp    80106052 <sys_sleep+0xa2>
8010605e:	66 90                	xchg   %ax,%ax

80106060 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106060:	f3 0f 1e fb          	endbr32 
80106064:	55                   	push   %ebp
80106065:	89 e5                	mov    %esp,%ebp
80106067:	53                   	push   %ebx
80106068:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010606b:	68 60 a3 11 80       	push   $0x8011a360
80106070:	e8 fb ec ff ff       	call   80104d70 <acquire>
  xticks = ticks;
80106075:	8b 1d a0 ab 11 80    	mov    0x8011aba0,%ebx
  release(&tickslock);
8010607b:	c7 04 24 60 a3 11 80 	movl   $0x8011a360,(%esp)
80106082:	e8 a9 ed ff ff       	call   80104e30 <release>
  return xticks;
}
80106087:	89 d8                	mov    %ebx,%eax
80106089:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010608c:	c9                   	leave  
8010608d:	c3                   	ret    
8010608e:	66 90                	xchg   %ax,%ax

80106090 <sys_sigprocmask>:

int sys_sigprocmask(void){
80106090:	f3 0f 1e fb          	endbr32 
80106094:	55                   	push   %ebp
80106095:	89 e5                	mov    %esp,%ebp
80106097:	83 ec 20             	sub    $0x20,%esp
  uint sigmask;
  if (argint(0, (int*)&sigmask) < 0){
8010609a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010609d:	50                   	push   %eax
8010609e:	6a 00                	push   $0x0
801060a0:	e8 bb f0 ff ff       	call   80105160 <argint>
801060a5:	83 c4 10             	add    $0x10,%esp
801060a8:	85 c0                	test   %eax,%eax
801060aa:	78 14                	js     801060c0 <sys_sigprocmask+0x30>
    return -1;
  }
  return sigprocmask(sigmask);
801060ac:	83 ec 0c             	sub    $0xc,%esp
801060af:	ff 75 f4             	pushl  -0xc(%ebp)
801060b2:	e8 79 e6 ff ff       	call   80104730 <sigprocmask>
801060b7:	83 c4 10             	add    $0x10,%esp
}
801060ba:	c9                   	leave  
801060bb:	c3                   	ret    
801060bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060c0:	c9                   	leave  
    return -1;
801060c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060c6:	c3                   	ret    
801060c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ce:	66 90                	xchg   %ax,%ax

801060d0 <sys_sigaction>:

int sys_sigaction(void){
801060d0:	f3 0f 1e fb          	endbr32 
801060d4:	55                   	push   %ebp
801060d5:	89 e5                	mov    %esp,%ebp
801060d7:	83 ec 20             	sub    $0x20,%esp
  uint signum;
  struct sigaction* act;
  struct sigaction* oldact;
  if (argint(0, (int*)(&signum)) < 0 || argptr(1, (char**)(&act), 16) < 0 || argptr(2, (char**)(&oldact), 16)){
801060da:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060dd:	50                   	push   %eax
801060de:	6a 00                	push   $0x0
801060e0:	e8 7b f0 ff ff       	call   80105160 <argint>
801060e5:	83 c4 10             	add    $0x10,%esp
801060e8:	85 c0                	test   %eax,%eax
801060ea:	78 44                	js     80106130 <sys_sigaction+0x60>
801060ec:	83 ec 04             	sub    $0x4,%esp
801060ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060f2:	6a 10                	push   $0x10
801060f4:	50                   	push   %eax
801060f5:	6a 01                	push   $0x1
801060f7:	e8 b4 f0 ff ff       	call   801051b0 <argptr>
801060fc:	83 c4 10             	add    $0x10,%esp
801060ff:	85 c0                	test   %eax,%eax
80106101:	78 2d                	js     80106130 <sys_sigaction+0x60>
80106103:	83 ec 04             	sub    $0x4,%esp
80106106:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106109:	6a 10                	push   $0x10
8010610b:	50                   	push   %eax
8010610c:	6a 02                	push   $0x2
8010610e:	e8 9d f0 ff ff       	call   801051b0 <argptr>
80106113:	83 c4 10             	add    $0x10,%esp
80106116:	85 c0                	test   %eax,%eax
80106118:	75 16                	jne    80106130 <sys_sigaction+0x60>
    return -1;
  }

  return sigaction(signum, act, oldact);
8010611a:	83 ec 04             	sub    $0x4,%esp
8010611d:	ff 75 f4             	pushl  -0xc(%ebp)
80106120:	ff 75 f0             	pushl  -0x10(%ebp)
80106123:	ff 75 ec             	pushl  -0x14(%ebp)
80106126:	e8 55 e6 ff ff       	call   80104780 <sigaction>
8010612b:	83 c4 10             	add    $0x10,%esp
}
8010612e:	c9                   	leave  
8010612f:	c3                   	ret    
80106130:	c9                   	leave  
    return -1;
80106131:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106136:	c3                   	ret    
80106137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010613e:	66 90                	xchg   %ax,%ax

80106140 <sys_sigret>:

int sys_sigret(void){
80106140:	f3 0f 1e fb          	endbr32 
80106144:	55                   	push   %ebp
80106145:	89 e5                	mov    %esp,%ebp
80106147:	83 ec 08             	sub    $0x8,%esp
  sigret();
8010614a:	e8 b1 e6 ff ff       	call   80104800 <sigret>
  return 0;
}
8010614f:	31 c0                	xor    %eax,%eax
80106151:	c9                   	leave  
80106152:	c3                   	ret    

80106153 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106153:	1e                   	push   %ds
  pushl %es
80106154:	06                   	push   %es
  pushl %fs
80106155:	0f a0                	push   %fs
  pushl %gs
80106157:	0f a8                	push   %gs
  pushal
80106159:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010615a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010615e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106160:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106162:	54                   	push   %esp
  call trap
80106163:	e8 c8 00 00 00       	call   80106230 <trap>
  addl $4, %esp
80106168:	83 c4 04             	add    $0x4,%esp

8010616b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:

  call handle_signals
8010616b:	e8 c0 e7 ff ff       	call   80104930 <handle_signals>
  
  popal
80106170:	61                   	popa   
  popl %gs
80106171:	0f a9                	pop    %gs
  popl %fs
80106173:	0f a1                	pop    %fs
  popl %es
80106175:	07                   	pop    %es
  popl %ds
80106176:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106177:	83 c4 08             	add    $0x8,%esp
  iret
8010617a:	cf                   	iret   
8010617b:	66 90                	xchg   %ax,%ax
8010617d:	66 90                	xchg   %ax,%ax
8010617f:	90                   	nop

80106180 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106180:	f3 0f 1e fb          	endbr32 
80106184:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106185:	31 c0                	xor    %eax,%eax
{
80106187:	89 e5                	mov    %esp,%ebp
80106189:	83 ec 08             	sub    $0x8,%esp
8010618c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106190:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106197:	c7 04 c5 a2 a3 11 80 	movl   $0x8e000008,-0x7fee5c5e(,%eax,8)
8010619e:	08 00 00 8e 
801061a2:	66 89 14 c5 a0 a3 11 	mov    %dx,-0x7fee5c60(,%eax,8)
801061a9:	80 
801061aa:	c1 ea 10             	shr    $0x10,%edx
801061ad:	66 89 14 c5 a6 a3 11 	mov    %dx,-0x7fee5c5a(,%eax,8)
801061b4:	80 
  for(i = 0; i < 256; i++)
801061b5:	83 c0 01             	add    $0x1,%eax
801061b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801061bd:	75 d1                	jne    80106190 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801061bf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061c2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801061c7:	c7 05 a2 a5 11 80 08 	movl   $0xef000008,0x8011a5a2
801061ce:	00 00 ef 
  initlock(&tickslock, "time");
801061d1:	68 a5 83 10 80       	push   $0x801083a5
801061d6:	68 60 a3 11 80       	push   $0x8011a360
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061db:	66 a3 a0 a5 11 80    	mov    %ax,0x8011a5a0
801061e1:	c1 e8 10             	shr    $0x10,%eax
801061e4:	66 a3 a6 a5 11 80    	mov    %ax,0x8011a5a6
  initlock(&tickslock, "time");
801061ea:	e8 01 ea ff ff       	call   80104bf0 <initlock>
}
801061ef:	83 c4 10             	add    $0x10,%esp
801061f2:	c9                   	leave  
801061f3:	c3                   	ret    
801061f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061ff:	90                   	nop

80106200 <idtinit>:

void
idtinit(void)
{
80106200:	f3 0f 1e fb          	endbr32 
80106204:	55                   	push   %ebp
  pd[0] = size-1;
80106205:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010620a:	89 e5                	mov    %esp,%ebp
8010620c:	83 ec 10             	sub    $0x10,%esp
8010620f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106213:	b8 a0 a3 11 80       	mov    $0x8011a3a0,%eax
80106218:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010621c:	c1 e8 10             	shr    $0x10,%eax
8010621f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106223:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106226:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106229:	c9                   	leave  
8010622a:	c3                   	ret    
8010622b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010622f:	90                   	nop

80106230 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe* tf)
{
80106230:	f3 0f 1e fb          	endbr32 
80106234:	55                   	push   %ebp
80106235:	89 e5                	mov    %esp,%ebp
80106237:	57                   	push   %edi
80106238:	56                   	push   %esi
80106239:	53                   	push   %ebx
8010623a:	83 ec 1c             	sub    $0x1c,%esp
8010623d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106240:	8b 43 30             	mov    0x30(%ebx),%eax
80106243:	83 f8 40             	cmp    $0x40,%eax
80106246:	0f 84 bc 01 00 00    	je     80106408 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010624c:	83 e8 20             	sub    $0x20,%eax
8010624f:	83 f8 1f             	cmp    $0x1f,%eax
80106252:	77 08                	ja     8010625c <trap+0x2c>
80106254:	3e ff 24 85 4c 84 10 	notrack jmp *-0x7fef7bb4(,%eax,4)
8010625b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010625c:	e8 cf d6 ff ff       	call   80103930 <myproc>
80106261:	8b 7b 38             	mov    0x38(%ebx),%edi
80106264:	85 c0                	test   %eax,%eax
80106266:	0f 84 eb 01 00 00    	je     80106457 <trap+0x227>
8010626c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106270:	0f 84 e1 01 00 00    	je     80106457 <trap+0x227>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106276:	0f 20 d1             	mov    %cr2,%ecx
80106279:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010627c:	e8 8f d6 ff ff       	call   80103910 <cpuid>
80106281:	8b 73 30             	mov    0x30(%ebx),%esi
80106284:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106287:	8b 43 34             	mov    0x34(%ebx),%eax
8010628a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010628d:	e8 9e d6 ff ff       	call   80103930 <myproc>
80106292:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106295:	e8 96 d6 ff ff       	call   80103930 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010629a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010629d:	8b 55 dc             	mov    -0x24(%ebp),%edx
801062a0:	51                   	push   %ecx
801062a1:	57                   	push   %edi
801062a2:	52                   	push   %edx
801062a3:	ff 75 e4             	pushl  -0x1c(%ebp)
801062a6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801062a7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801062aa:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062ad:	56                   	push   %esi
801062ae:	ff 70 10             	pushl  0x10(%eax)
801062b1:	68 08 84 10 80       	push   $0x80108408
801062b6:	e8 f5 a3 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801062bb:	83 c4 20             	add    $0x20,%esp
801062be:	e8 6d d6 ff ff       	call   80103930 <myproc>
801062c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062ca:	e8 61 d6 ff ff       	call   80103930 <myproc>
801062cf:	85 c0                	test   %eax,%eax
801062d1:	74 1d                	je     801062f0 <trap+0xc0>
801062d3:	e8 58 d6 ff ff       	call   80103930 <myproc>
801062d8:	8b 50 24             	mov    0x24(%eax),%edx
801062db:	85 d2                	test   %edx,%edx
801062dd:	74 11                	je     801062f0 <trap+0xc0>
801062df:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062e3:	83 e0 03             	and    $0x3,%eax
801062e6:	66 83 f8 03          	cmp    $0x3,%ax
801062ea:	0f 84 50 01 00 00    	je     80106440 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801062f0:	e8 3b d6 ff ff       	call   80103930 <myproc>
801062f5:	85 c0                	test   %eax,%eax
801062f7:	74 0f                	je     80106308 <trap+0xd8>
801062f9:	e8 32 d6 ff ff       	call   80103930 <myproc>
801062fe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106302:	0f 84 e8 00 00 00    	je     801063f0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106308:	e8 23 d6 ff ff       	call   80103930 <myproc>
8010630d:	85 c0                	test   %eax,%eax
8010630f:	74 1d                	je     8010632e <trap+0xfe>
80106311:	e8 1a d6 ff ff       	call   80103930 <myproc>
80106316:	8b 40 24             	mov    0x24(%eax),%eax
80106319:	85 c0                	test   %eax,%eax
8010631b:	74 11                	je     8010632e <trap+0xfe>
8010631d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106321:	83 e0 03             	and    $0x3,%eax
80106324:	66 83 f8 03          	cmp    $0x3,%ax
80106328:	0f 84 03 01 00 00    	je     80106431 <trap+0x201>
    exit();
}
8010632e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106331:	5b                   	pop    %ebx
80106332:	5e                   	pop    %esi
80106333:	5f                   	pop    %edi
80106334:	5d                   	pop    %ebp
80106335:	c3                   	ret    
    ideintr();
80106336:	e8 d5 be ff ff       	call   80102210 <ideintr>
    lapiceoi();
8010633b:	e8 b0 c5 ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106340:	e8 eb d5 ff ff       	call   80103930 <myproc>
80106345:	85 c0                	test   %eax,%eax
80106347:	75 8a                	jne    801062d3 <trap+0xa3>
80106349:	eb a5                	jmp    801062f0 <trap+0xc0>
    if(cpuid() == 0){
8010634b:	e8 c0 d5 ff ff       	call   80103910 <cpuid>
80106350:	85 c0                	test   %eax,%eax
80106352:	75 e7                	jne    8010633b <trap+0x10b>
      acquire(&tickslock);
80106354:	83 ec 0c             	sub    $0xc,%esp
80106357:	68 60 a3 11 80       	push   $0x8011a360
8010635c:	e8 0f ea ff ff       	call   80104d70 <acquire>
      wakeup(&ticks);
80106361:	c7 04 24 a0 ab 11 80 	movl   $0x8011aba0,(%esp)
      ticks++;
80106368:	83 05 a0 ab 11 80 01 	addl   $0x1,0x8011aba0
      wakeup(&ticks);
8010636f:	e8 9c e1 ff ff       	call   80104510 <wakeup>
      release(&tickslock);
80106374:	c7 04 24 60 a3 11 80 	movl   $0x8011a360,(%esp)
8010637b:	e8 b0 ea ff ff       	call   80104e30 <release>
80106380:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106383:	eb b6                	jmp    8010633b <trap+0x10b>
    kbdintr();
80106385:	e8 26 c4 ff ff       	call   801027b0 <kbdintr>
    lapiceoi();
8010638a:	e8 61 c5 ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010638f:	e8 9c d5 ff ff       	call   80103930 <myproc>
80106394:	85 c0                	test   %eax,%eax
80106396:	0f 85 37 ff ff ff    	jne    801062d3 <trap+0xa3>
8010639c:	e9 4f ff ff ff       	jmp    801062f0 <trap+0xc0>
    uartintr();
801063a1:	e8 4a 02 00 00       	call   801065f0 <uartintr>
    lapiceoi();
801063a6:	e8 45 c5 ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063ab:	e8 80 d5 ff ff       	call   80103930 <myproc>
801063b0:	85 c0                	test   %eax,%eax
801063b2:	0f 85 1b ff ff ff    	jne    801062d3 <trap+0xa3>
801063b8:	e9 33 ff ff ff       	jmp    801062f0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801063bd:	8b 7b 38             	mov    0x38(%ebx),%edi
801063c0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801063c4:	e8 47 d5 ff ff       	call   80103910 <cpuid>
801063c9:	57                   	push   %edi
801063ca:	56                   	push   %esi
801063cb:	50                   	push   %eax
801063cc:	68 b0 83 10 80       	push   $0x801083b0
801063d1:	e8 da a2 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801063d6:	e8 15 c5 ff ff       	call   801028f0 <lapiceoi>
    break;
801063db:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063de:	e8 4d d5 ff ff       	call   80103930 <myproc>
801063e3:	85 c0                	test   %eax,%eax
801063e5:	0f 85 e8 fe ff ff    	jne    801062d3 <trap+0xa3>
801063eb:	e9 00 ff ff ff       	jmp    801062f0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
801063f0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801063f4:	0f 85 0e ff ff ff    	jne    80106308 <trap+0xd8>
    yield();
801063fa:	e8 e1 df ff ff       	call   801043e0 <yield>
801063ff:	e9 04 ff ff ff       	jmp    80106308 <trap+0xd8>
80106404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106408:	e8 23 d5 ff ff       	call   80103930 <myproc>
8010640d:	8b 70 24             	mov    0x24(%eax),%esi
80106410:	85 f6                	test   %esi,%esi
80106412:	75 3c                	jne    80106450 <trap+0x220>
    myproc()->tf = tf;
80106414:	e8 17 d5 ff ff       	call   80103930 <myproc>
80106419:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010641c:	e8 2f ee ff ff       	call   80105250 <syscall>
    if(myproc()->killed)
80106421:	e8 0a d5 ff ff       	call   80103930 <myproc>
80106426:	8b 48 24             	mov    0x24(%eax),%ecx
80106429:	85 c9                	test   %ecx,%ecx
8010642b:	0f 84 fd fe ff ff    	je     8010632e <trap+0xfe>
}
80106431:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106434:	5b                   	pop    %ebx
80106435:	5e                   	pop    %esi
80106436:	5f                   	pop    %edi
80106437:	5d                   	pop    %ebp
      exit();
80106438:	e9 53 dc ff ff       	jmp    80104090 <exit>
8010643d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106440:	e8 4b dc ff ff       	call   80104090 <exit>
80106445:	e9 a6 fe ff ff       	jmp    801062f0 <trap+0xc0>
8010644a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106450:	e8 3b dc ff ff       	call   80104090 <exit>
80106455:	eb bd                	jmp    80106414 <trap+0x1e4>
80106457:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010645a:	e8 b1 d4 ff ff       	call   80103910 <cpuid>
8010645f:	83 ec 0c             	sub    $0xc,%esp
80106462:	56                   	push   %esi
80106463:	57                   	push   %edi
80106464:	50                   	push   %eax
80106465:	ff 73 30             	pushl  0x30(%ebx)
80106468:	68 d4 83 10 80       	push   $0x801083d4
8010646d:	e8 3e a2 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106472:	83 c4 14             	add    $0x14,%esp
80106475:	68 aa 83 10 80       	push   $0x801083aa
8010647a:	e8 11 9f ff ff       	call   80100390 <panic>
8010647f:	90                   	nop

80106480 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106480:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106484:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106489:	85 c0                	test   %eax,%eax
8010648b:	74 1b                	je     801064a8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010648d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106492:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106493:	a8 01                	test   $0x1,%al
80106495:	74 11                	je     801064a8 <uartgetc+0x28>
80106497:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010649c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010649d:	0f b6 c0             	movzbl %al,%eax
801064a0:	c3                   	ret    
801064a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801064a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064ad:	c3                   	ret    
801064ae:	66 90                	xchg   %ax,%ax

801064b0 <uartputc.part.0>:
uartputc(int c)
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	57                   	push   %edi
801064b4:	89 c7                	mov    %eax,%edi
801064b6:	56                   	push   %esi
801064b7:	be fd 03 00 00       	mov    $0x3fd,%esi
801064bc:	53                   	push   %ebx
801064bd:	bb 80 00 00 00       	mov    $0x80,%ebx
801064c2:	83 ec 0c             	sub    $0xc,%esp
801064c5:	eb 1b                	jmp    801064e2 <uartputc.part.0+0x32>
801064c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ce:	66 90                	xchg   %ax,%ax
    microdelay(10);
801064d0:	83 ec 0c             	sub    $0xc,%esp
801064d3:	6a 0a                	push   $0xa
801064d5:	e8 36 c4 ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064da:	83 c4 10             	add    $0x10,%esp
801064dd:	83 eb 01             	sub    $0x1,%ebx
801064e0:	74 07                	je     801064e9 <uartputc.part.0+0x39>
801064e2:	89 f2                	mov    %esi,%edx
801064e4:	ec                   	in     (%dx),%al
801064e5:	a8 20                	test   $0x20,%al
801064e7:	74 e7                	je     801064d0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064e9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064ee:	89 f8                	mov    %edi,%eax
801064f0:	ee                   	out    %al,(%dx)
}
801064f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064f4:	5b                   	pop    %ebx
801064f5:	5e                   	pop    %esi
801064f6:	5f                   	pop    %edi
801064f7:	5d                   	pop    %ebp
801064f8:	c3                   	ret    
801064f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106500 <uartinit>:
{
80106500:	f3 0f 1e fb          	endbr32 
80106504:	55                   	push   %ebp
80106505:	31 c9                	xor    %ecx,%ecx
80106507:	89 c8                	mov    %ecx,%eax
80106509:	89 e5                	mov    %esp,%ebp
8010650b:	57                   	push   %edi
8010650c:	56                   	push   %esi
8010650d:	53                   	push   %ebx
8010650e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106513:	89 da                	mov    %ebx,%edx
80106515:	83 ec 0c             	sub    $0xc,%esp
80106518:	ee                   	out    %al,(%dx)
80106519:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010651e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106523:	89 fa                	mov    %edi,%edx
80106525:	ee                   	out    %al,(%dx)
80106526:	b8 0c 00 00 00       	mov    $0xc,%eax
8010652b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106530:	ee                   	out    %al,(%dx)
80106531:	be f9 03 00 00       	mov    $0x3f9,%esi
80106536:	89 c8                	mov    %ecx,%eax
80106538:	89 f2                	mov    %esi,%edx
8010653a:	ee                   	out    %al,(%dx)
8010653b:	b8 03 00 00 00       	mov    $0x3,%eax
80106540:	89 fa                	mov    %edi,%edx
80106542:	ee                   	out    %al,(%dx)
80106543:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106548:	89 c8                	mov    %ecx,%eax
8010654a:	ee                   	out    %al,(%dx)
8010654b:	b8 01 00 00 00       	mov    $0x1,%eax
80106550:	89 f2                	mov    %esi,%edx
80106552:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106553:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106558:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106559:	3c ff                	cmp    $0xff,%al
8010655b:	74 52                	je     801065af <uartinit+0xaf>
  uart = 1;
8010655d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106564:	00 00 00 
80106567:	89 da                	mov    %ebx,%edx
80106569:	ec                   	in     (%dx),%al
8010656a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010656f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106570:	83 ec 08             	sub    $0x8,%esp
80106573:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106578:	bb cc 84 10 80       	mov    $0x801084cc,%ebx
  ioapicenable(IRQ_COM1, 0);
8010657d:	6a 00                	push   $0x0
8010657f:	6a 04                	push   $0x4
80106581:	e8 da be ff ff       	call   80102460 <ioapicenable>
80106586:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106589:	b8 78 00 00 00       	mov    $0x78,%eax
8010658e:	eb 04                	jmp    80106594 <uartinit+0x94>
80106590:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106594:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010659a:	85 d2                	test   %edx,%edx
8010659c:	74 08                	je     801065a6 <uartinit+0xa6>
    uartputc(*p);
8010659e:	0f be c0             	movsbl %al,%eax
801065a1:	e8 0a ff ff ff       	call   801064b0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801065a6:	89 f0                	mov    %esi,%eax
801065a8:	83 c3 01             	add    $0x1,%ebx
801065ab:	84 c0                	test   %al,%al
801065ad:	75 e1                	jne    80106590 <uartinit+0x90>
}
801065af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065b2:	5b                   	pop    %ebx
801065b3:	5e                   	pop    %esi
801065b4:	5f                   	pop    %edi
801065b5:	5d                   	pop    %ebp
801065b6:	c3                   	ret    
801065b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065be:	66 90                	xchg   %ax,%ax

801065c0 <uartputc>:
{
801065c0:	f3 0f 1e fb          	endbr32 
801065c4:	55                   	push   %ebp
  if(!uart)
801065c5:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801065cb:	89 e5                	mov    %esp,%ebp
801065cd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801065d0:	85 d2                	test   %edx,%edx
801065d2:	74 0c                	je     801065e0 <uartputc+0x20>
}
801065d4:	5d                   	pop    %ebp
801065d5:	e9 d6 fe ff ff       	jmp    801064b0 <uartputc.part.0>
801065da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065e0:	5d                   	pop    %ebp
801065e1:	c3                   	ret    
801065e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065f0 <uartintr>:

void
uartintr(void)
{
801065f0:	f3 0f 1e fb          	endbr32 
801065f4:	55                   	push   %ebp
801065f5:	89 e5                	mov    %esp,%ebp
801065f7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801065fa:	68 80 64 10 80       	push   $0x80106480
801065ff:	e8 5c a2 ff ff       	call   80100860 <consoleintr>
}
80106604:	83 c4 10             	add    $0x10,%esp
80106607:	c9                   	leave  
80106608:	c3                   	ret    

80106609 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $0
8010660b:	6a 00                	push   $0x0
  jmp alltraps
8010660d:	e9 41 fb ff ff       	jmp    80106153 <alltraps>

80106612 <vector1>:
.globl vector1
vector1:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $1
80106614:	6a 01                	push   $0x1
  jmp alltraps
80106616:	e9 38 fb ff ff       	jmp    80106153 <alltraps>

8010661b <vector2>:
.globl vector2
vector2:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $2
8010661d:	6a 02                	push   $0x2
  jmp alltraps
8010661f:	e9 2f fb ff ff       	jmp    80106153 <alltraps>

80106624 <vector3>:
.globl vector3
vector3:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $3
80106626:	6a 03                	push   $0x3
  jmp alltraps
80106628:	e9 26 fb ff ff       	jmp    80106153 <alltraps>

8010662d <vector4>:
.globl vector4
vector4:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $4
8010662f:	6a 04                	push   $0x4
  jmp alltraps
80106631:	e9 1d fb ff ff       	jmp    80106153 <alltraps>

80106636 <vector5>:
.globl vector5
vector5:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $5
80106638:	6a 05                	push   $0x5
  jmp alltraps
8010663a:	e9 14 fb ff ff       	jmp    80106153 <alltraps>

8010663f <vector6>:
.globl vector6
vector6:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $6
80106641:	6a 06                	push   $0x6
  jmp alltraps
80106643:	e9 0b fb ff ff       	jmp    80106153 <alltraps>

80106648 <vector7>:
.globl vector7
vector7:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $7
8010664a:	6a 07                	push   $0x7
  jmp alltraps
8010664c:	e9 02 fb ff ff       	jmp    80106153 <alltraps>

80106651 <vector8>:
.globl vector8
vector8:
  pushl $8
80106651:	6a 08                	push   $0x8
  jmp alltraps
80106653:	e9 fb fa ff ff       	jmp    80106153 <alltraps>

80106658 <vector9>:
.globl vector9
vector9:
  pushl $0
80106658:	6a 00                	push   $0x0
  pushl $9
8010665a:	6a 09                	push   $0x9
  jmp alltraps
8010665c:	e9 f2 fa ff ff       	jmp    80106153 <alltraps>

80106661 <vector10>:
.globl vector10
vector10:
  pushl $10
80106661:	6a 0a                	push   $0xa
  jmp alltraps
80106663:	e9 eb fa ff ff       	jmp    80106153 <alltraps>

80106668 <vector11>:
.globl vector11
vector11:
  pushl $11
80106668:	6a 0b                	push   $0xb
  jmp alltraps
8010666a:	e9 e4 fa ff ff       	jmp    80106153 <alltraps>

8010666f <vector12>:
.globl vector12
vector12:
  pushl $12
8010666f:	6a 0c                	push   $0xc
  jmp alltraps
80106671:	e9 dd fa ff ff       	jmp    80106153 <alltraps>

80106676 <vector13>:
.globl vector13
vector13:
  pushl $13
80106676:	6a 0d                	push   $0xd
  jmp alltraps
80106678:	e9 d6 fa ff ff       	jmp    80106153 <alltraps>

8010667d <vector14>:
.globl vector14
vector14:
  pushl $14
8010667d:	6a 0e                	push   $0xe
  jmp alltraps
8010667f:	e9 cf fa ff ff       	jmp    80106153 <alltraps>

80106684 <vector15>:
.globl vector15
vector15:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $15
80106686:	6a 0f                	push   $0xf
  jmp alltraps
80106688:	e9 c6 fa ff ff       	jmp    80106153 <alltraps>

8010668d <vector16>:
.globl vector16
vector16:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $16
8010668f:	6a 10                	push   $0x10
  jmp alltraps
80106691:	e9 bd fa ff ff       	jmp    80106153 <alltraps>

80106696 <vector17>:
.globl vector17
vector17:
  pushl $17
80106696:	6a 11                	push   $0x11
  jmp alltraps
80106698:	e9 b6 fa ff ff       	jmp    80106153 <alltraps>

8010669d <vector18>:
.globl vector18
vector18:
  pushl $0
8010669d:	6a 00                	push   $0x0
  pushl $18
8010669f:	6a 12                	push   $0x12
  jmp alltraps
801066a1:	e9 ad fa ff ff       	jmp    80106153 <alltraps>

801066a6 <vector19>:
.globl vector19
vector19:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $19
801066a8:	6a 13                	push   $0x13
  jmp alltraps
801066aa:	e9 a4 fa ff ff       	jmp    80106153 <alltraps>

801066af <vector20>:
.globl vector20
vector20:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $20
801066b1:	6a 14                	push   $0x14
  jmp alltraps
801066b3:	e9 9b fa ff ff       	jmp    80106153 <alltraps>

801066b8 <vector21>:
.globl vector21
vector21:
  pushl $0
801066b8:	6a 00                	push   $0x0
  pushl $21
801066ba:	6a 15                	push   $0x15
  jmp alltraps
801066bc:	e9 92 fa ff ff       	jmp    80106153 <alltraps>

801066c1 <vector22>:
.globl vector22
vector22:
  pushl $0
801066c1:	6a 00                	push   $0x0
  pushl $22
801066c3:	6a 16                	push   $0x16
  jmp alltraps
801066c5:	e9 89 fa ff ff       	jmp    80106153 <alltraps>

801066ca <vector23>:
.globl vector23
vector23:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $23
801066cc:	6a 17                	push   $0x17
  jmp alltraps
801066ce:	e9 80 fa ff ff       	jmp    80106153 <alltraps>

801066d3 <vector24>:
.globl vector24
vector24:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $24
801066d5:	6a 18                	push   $0x18
  jmp alltraps
801066d7:	e9 77 fa ff ff       	jmp    80106153 <alltraps>

801066dc <vector25>:
.globl vector25
vector25:
  pushl $0
801066dc:	6a 00                	push   $0x0
  pushl $25
801066de:	6a 19                	push   $0x19
  jmp alltraps
801066e0:	e9 6e fa ff ff       	jmp    80106153 <alltraps>

801066e5 <vector26>:
.globl vector26
vector26:
  pushl $0
801066e5:	6a 00                	push   $0x0
  pushl $26
801066e7:	6a 1a                	push   $0x1a
  jmp alltraps
801066e9:	e9 65 fa ff ff       	jmp    80106153 <alltraps>

801066ee <vector27>:
.globl vector27
vector27:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $27
801066f0:	6a 1b                	push   $0x1b
  jmp alltraps
801066f2:	e9 5c fa ff ff       	jmp    80106153 <alltraps>

801066f7 <vector28>:
.globl vector28
vector28:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $28
801066f9:	6a 1c                	push   $0x1c
  jmp alltraps
801066fb:	e9 53 fa ff ff       	jmp    80106153 <alltraps>

80106700 <vector29>:
.globl vector29
vector29:
  pushl $0
80106700:	6a 00                	push   $0x0
  pushl $29
80106702:	6a 1d                	push   $0x1d
  jmp alltraps
80106704:	e9 4a fa ff ff       	jmp    80106153 <alltraps>

80106709 <vector30>:
.globl vector30
vector30:
  pushl $0
80106709:	6a 00                	push   $0x0
  pushl $30
8010670b:	6a 1e                	push   $0x1e
  jmp alltraps
8010670d:	e9 41 fa ff ff       	jmp    80106153 <alltraps>

80106712 <vector31>:
.globl vector31
vector31:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $31
80106714:	6a 1f                	push   $0x1f
  jmp alltraps
80106716:	e9 38 fa ff ff       	jmp    80106153 <alltraps>

8010671b <vector32>:
.globl vector32
vector32:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $32
8010671d:	6a 20                	push   $0x20
  jmp alltraps
8010671f:	e9 2f fa ff ff       	jmp    80106153 <alltraps>

80106724 <vector33>:
.globl vector33
vector33:
  pushl $0
80106724:	6a 00                	push   $0x0
  pushl $33
80106726:	6a 21                	push   $0x21
  jmp alltraps
80106728:	e9 26 fa ff ff       	jmp    80106153 <alltraps>

8010672d <vector34>:
.globl vector34
vector34:
  pushl $0
8010672d:	6a 00                	push   $0x0
  pushl $34
8010672f:	6a 22                	push   $0x22
  jmp alltraps
80106731:	e9 1d fa ff ff       	jmp    80106153 <alltraps>

80106736 <vector35>:
.globl vector35
vector35:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $35
80106738:	6a 23                	push   $0x23
  jmp alltraps
8010673a:	e9 14 fa ff ff       	jmp    80106153 <alltraps>

8010673f <vector36>:
.globl vector36
vector36:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $36
80106741:	6a 24                	push   $0x24
  jmp alltraps
80106743:	e9 0b fa ff ff       	jmp    80106153 <alltraps>

80106748 <vector37>:
.globl vector37
vector37:
  pushl $0
80106748:	6a 00                	push   $0x0
  pushl $37
8010674a:	6a 25                	push   $0x25
  jmp alltraps
8010674c:	e9 02 fa ff ff       	jmp    80106153 <alltraps>

80106751 <vector38>:
.globl vector38
vector38:
  pushl $0
80106751:	6a 00                	push   $0x0
  pushl $38
80106753:	6a 26                	push   $0x26
  jmp alltraps
80106755:	e9 f9 f9 ff ff       	jmp    80106153 <alltraps>

8010675a <vector39>:
.globl vector39
vector39:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $39
8010675c:	6a 27                	push   $0x27
  jmp alltraps
8010675e:	e9 f0 f9 ff ff       	jmp    80106153 <alltraps>

80106763 <vector40>:
.globl vector40
vector40:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $40
80106765:	6a 28                	push   $0x28
  jmp alltraps
80106767:	e9 e7 f9 ff ff       	jmp    80106153 <alltraps>

8010676c <vector41>:
.globl vector41
vector41:
  pushl $0
8010676c:	6a 00                	push   $0x0
  pushl $41
8010676e:	6a 29                	push   $0x29
  jmp alltraps
80106770:	e9 de f9 ff ff       	jmp    80106153 <alltraps>

80106775 <vector42>:
.globl vector42
vector42:
  pushl $0
80106775:	6a 00                	push   $0x0
  pushl $42
80106777:	6a 2a                	push   $0x2a
  jmp alltraps
80106779:	e9 d5 f9 ff ff       	jmp    80106153 <alltraps>

8010677e <vector43>:
.globl vector43
vector43:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $43
80106780:	6a 2b                	push   $0x2b
  jmp alltraps
80106782:	e9 cc f9 ff ff       	jmp    80106153 <alltraps>

80106787 <vector44>:
.globl vector44
vector44:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $44
80106789:	6a 2c                	push   $0x2c
  jmp alltraps
8010678b:	e9 c3 f9 ff ff       	jmp    80106153 <alltraps>

80106790 <vector45>:
.globl vector45
vector45:
  pushl $0
80106790:	6a 00                	push   $0x0
  pushl $45
80106792:	6a 2d                	push   $0x2d
  jmp alltraps
80106794:	e9 ba f9 ff ff       	jmp    80106153 <alltraps>

80106799 <vector46>:
.globl vector46
vector46:
  pushl $0
80106799:	6a 00                	push   $0x0
  pushl $46
8010679b:	6a 2e                	push   $0x2e
  jmp alltraps
8010679d:	e9 b1 f9 ff ff       	jmp    80106153 <alltraps>

801067a2 <vector47>:
.globl vector47
vector47:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $47
801067a4:	6a 2f                	push   $0x2f
  jmp alltraps
801067a6:	e9 a8 f9 ff ff       	jmp    80106153 <alltraps>

801067ab <vector48>:
.globl vector48
vector48:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $48
801067ad:	6a 30                	push   $0x30
  jmp alltraps
801067af:	e9 9f f9 ff ff       	jmp    80106153 <alltraps>

801067b4 <vector49>:
.globl vector49
vector49:
  pushl $0
801067b4:	6a 00                	push   $0x0
  pushl $49
801067b6:	6a 31                	push   $0x31
  jmp alltraps
801067b8:	e9 96 f9 ff ff       	jmp    80106153 <alltraps>

801067bd <vector50>:
.globl vector50
vector50:
  pushl $0
801067bd:	6a 00                	push   $0x0
  pushl $50
801067bf:	6a 32                	push   $0x32
  jmp alltraps
801067c1:	e9 8d f9 ff ff       	jmp    80106153 <alltraps>

801067c6 <vector51>:
.globl vector51
vector51:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $51
801067c8:	6a 33                	push   $0x33
  jmp alltraps
801067ca:	e9 84 f9 ff ff       	jmp    80106153 <alltraps>

801067cf <vector52>:
.globl vector52
vector52:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $52
801067d1:	6a 34                	push   $0x34
  jmp alltraps
801067d3:	e9 7b f9 ff ff       	jmp    80106153 <alltraps>

801067d8 <vector53>:
.globl vector53
vector53:
  pushl $0
801067d8:	6a 00                	push   $0x0
  pushl $53
801067da:	6a 35                	push   $0x35
  jmp alltraps
801067dc:	e9 72 f9 ff ff       	jmp    80106153 <alltraps>

801067e1 <vector54>:
.globl vector54
vector54:
  pushl $0
801067e1:	6a 00                	push   $0x0
  pushl $54
801067e3:	6a 36                	push   $0x36
  jmp alltraps
801067e5:	e9 69 f9 ff ff       	jmp    80106153 <alltraps>

801067ea <vector55>:
.globl vector55
vector55:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $55
801067ec:	6a 37                	push   $0x37
  jmp alltraps
801067ee:	e9 60 f9 ff ff       	jmp    80106153 <alltraps>

801067f3 <vector56>:
.globl vector56
vector56:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $56
801067f5:	6a 38                	push   $0x38
  jmp alltraps
801067f7:	e9 57 f9 ff ff       	jmp    80106153 <alltraps>

801067fc <vector57>:
.globl vector57
vector57:
  pushl $0
801067fc:	6a 00                	push   $0x0
  pushl $57
801067fe:	6a 39                	push   $0x39
  jmp alltraps
80106800:	e9 4e f9 ff ff       	jmp    80106153 <alltraps>

80106805 <vector58>:
.globl vector58
vector58:
  pushl $0
80106805:	6a 00                	push   $0x0
  pushl $58
80106807:	6a 3a                	push   $0x3a
  jmp alltraps
80106809:	e9 45 f9 ff ff       	jmp    80106153 <alltraps>

8010680e <vector59>:
.globl vector59
vector59:
  pushl $0
8010680e:	6a 00                	push   $0x0
  pushl $59
80106810:	6a 3b                	push   $0x3b
  jmp alltraps
80106812:	e9 3c f9 ff ff       	jmp    80106153 <alltraps>

80106817 <vector60>:
.globl vector60
vector60:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $60
80106819:	6a 3c                	push   $0x3c
  jmp alltraps
8010681b:	e9 33 f9 ff ff       	jmp    80106153 <alltraps>

80106820 <vector61>:
.globl vector61
vector61:
  pushl $0
80106820:	6a 00                	push   $0x0
  pushl $61
80106822:	6a 3d                	push   $0x3d
  jmp alltraps
80106824:	e9 2a f9 ff ff       	jmp    80106153 <alltraps>

80106829 <vector62>:
.globl vector62
vector62:
  pushl $0
80106829:	6a 00                	push   $0x0
  pushl $62
8010682b:	6a 3e                	push   $0x3e
  jmp alltraps
8010682d:	e9 21 f9 ff ff       	jmp    80106153 <alltraps>

80106832 <vector63>:
.globl vector63
vector63:
  pushl $0
80106832:	6a 00                	push   $0x0
  pushl $63
80106834:	6a 3f                	push   $0x3f
  jmp alltraps
80106836:	e9 18 f9 ff ff       	jmp    80106153 <alltraps>

8010683b <vector64>:
.globl vector64
vector64:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $64
8010683d:	6a 40                	push   $0x40
  jmp alltraps
8010683f:	e9 0f f9 ff ff       	jmp    80106153 <alltraps>

80106844 <vector65>:
.globl vector65
vector65:
  pushl $0
80106844:	6a 00                	push   $0x0
  pushl $65
80106846:	6a 41                	push   $0x41
  jmp alltraps
80106848:	e9 06 f9 ff ff       	jmp    80106153 <alltraps>

8010684d <vector66>:
.globl vector66
vector66:
  pushl $0
8010684d:	6a 00                	push   $0x0
  pushl $66
8010684f:	6a 42                	push   $0x42
  jmp alltraps
80106851:	e9 fd f8 ff ff       	jmp    80106153 <alltraps>

80106856 <vector67>:
.globl vector67
vector67:
  pushl $0
80106856:	6a 00                	push   $0x0
  pushl $67
80106858:	6a 43                	push   $0x43
  jmp alltraps
8010685a:	e9 f4 f8 ff ff       	jmp    80106153 <alltraps>

8010685f <vector68>:
.globl vector68
vector68:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $68
80106861:	6a 44                	push   $0x44
  jmp alltraps
80106863:	e9 eb f8 ff ff       	jmp    80106153 <alltraps>

80106868 <vector69>:
.globl vector69
vector69:
  pushl $0
80106868:	6a 00                	push   $0x0
  pushl $69
8010686a:	6a 45                	push   $0x45
  jmp alltraps
8010686c:	e9 e2 f8 ff ff       	jmp    80106153 <alltraps>

80106871 <vector70>:
.globl vector70
vector70:
  pushl $0
80106871:	6a 00                	push   $0x0
  pushl $70
80106873:	6a 46                	push   $0x46
  jmp alltraps
80106875:	e9 d9 f8 ff ff       	jmp    80106153 <alltraps>

8010687a <vector71>:
.globl vector71
vector71:
  pushl $0
8010687a:	6a 00                	push   $0x0
  pushl $71
8010687c:	6a 47                	push   $0x47
  jmp alltraps
8010687e:	e9 d0 f8 ff ff       	jmp    80106153 <alltraps>

80106883 <vector72>:
.globl vector72
vector72:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $72
80106885:	6a 48                	push   $0x48
  jmp alltraps
80106887:	e9 c7 f8 ff ff       	jmp    80106153 <alltraps>

8010688c <vector73>:
.globl vector73
vector73:
  pushl $0
8010688c:	6a 00                	push   $0x0
  pushl $73
8010688e:	6a 49                	push   $0x49
  jmp alltraps
80106890:	e9 be f8 ff ff       	jmp    80106153 <alltraps>

80106895 <vector74>:
.globl vector74
vector74:
  pushl $0
80106895:	6a 00                	push   $0x0
  pushl $74
80106897:	6a 4a                	push   $0x4a
  jmp alltraps
80106899:	e9 b5 f8 ff ff       	jmp    80106153 <alltraps>

8010689e <vector75>:
.globl vector75
vector75:
  pushl $0
8010689e:	6a 00                	push   $0x0
  pushl $75
801068a0:	6a 4b                	push   $0x4b
  jmp alltraps
801068a2:	e9 ac f8 ff ff       	jmp    80106153 <alltraps>

801068a7 <vector76>:
.globl vector76
vector76:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $76
801068a9:	6a 4c                	push   $0x4c
  jmp alltraps
801068ab:	e9 a3 f8 ff ff       	jmp    80106153 <alltraps>

801068b0 <vector77>:
.globl vector77
vector77:
  pushl $0
801068b0:	6a 00                	push   $0x0
  pushl $77
801068b2:	6a 4d                	push   $0x4d
  jmp alltraps
801068b4:	e9 9a f8 ff ff       	jmp    80106153 <alltraps>

801068b9 <vector78>:
.globl vector78
vector78:
  pushl $0
801068b9:	6a 00                	push   $0x0
  pushl $78
801068bb:	6a 4e                	push   $0x4e
  jmp alltraps
801068bd:	e9 91 f8 ff ff       	jmp    80106153 <alltraps>

801068c2 <vector79>:
.globl vector79
vector79:
  pushl $0
801068c2:	6a 00                	push   $0x0
  pushl $79
801068c4:	6a 4f                	push   $0x4f
  jmp alltraps
801068c6:	e9 88 f8 ff ff       	jmp    80106153 <alltraps>

801068cb <vector80>:
.globl vector80
vector80:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $80
801068cd:	6a 50                	push   $0x50
  jmp alltraps
801068cf:	e9 7f f8 ff ff       	jmp    80106153 <alltraps>

801068d4 <vector81>:
.globl vector81
vector81:
  pushl $0
801068d4:	6a 00                	push   $0x0
  pushl $81
801068d6:	6a 51                	push   $0x51
  jmp alltraps
801068d8:	e9 76 f8 ff ff       	jmp    80106153 <alltraps>

801068dd <vector82>:
.globl vector82
vector82:
  pushl $0
801068dd:	6a 00                	push   $0x0
  pushl $82
801068df:	6a 52                	push   $0x52
  jmp alltraps
801068e1:	e9 6d f8 ff ff       	jmp    80106153 <alltraps>

801068e6 <vector83>:
.globl vector83
vector83:
  pushl $0
801068e6:	6a 00                	push   $0x0
  pushl $83
801068e8:	6a 53                	push   $0x53
  jmp alltraps
801068ea:	e9 64 f8 ff ff       	jmp    80106153 <alltraps>

801068ef <vector84>:
.globl vector84
vector84:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $84
801068f1:	6a 54                	push   $0x54
  jmp alltraps
801068f3:	e9 5b f8 ff ff       	jmp    80106153 <alltraps>

801068f8 <vector85>:
.globl vector85
vector85:
  pushl $0
801068f8:	6a 00                	push   $0x0
  pushl $85
801068fa:	6a 55                	push   $0x55
  jmp alltraps
801068fc:	e9 52 f8 ff ff       	jmp    80106153 <alltraps>

80106901 <vector86>:
.globl vector86
vector86:
  pushl $0
80106901:	6a 00                	push   $0x0
  pushl $86
80106903:	6a 56                	push   $0x56
  jmp alltraps
80106905:	e9 49 f8 ff ff       	jmp    80106153 <alltraps>

8010690a <vector87>:
.globl vector87
vector87:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $87
8010690c:	6a 57                	push   $0x57
  jmp alltraps
8010690e:	e9 40 f8 ff ff       	jmp    80106153 <alltraps>

80106913 <vector88>:
.globl vector88
vector88:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $88
80106915:	6a 58                	push   $0x58
  jmp alltraps
80106917:	e9 37 f8 ff ff       	jmp    80106153 <alltraps>

8010691c <vector89>:
.globl vector89
vector89:
  pushl $0
8010691c:	6a 00                	push   $0x0
  pushl $89
8010691e:	6a 59                	push   $0x59
  jmp alltraps
80106920:	e9 2e f8 ff ff       	jmp    80106153 <alltraps>

80106925 <vector90>:
.globl vector90
vector90:
  pushl $0
80106925:	6a 00                	push   $0x0
  pushl $90
80106927:	6a 5a                	push   $0x5a
  jmp alltraps
80106929:	e9 25 f8 ff ff       	jmp    80106153 <alltraps>

8010692e <vector91>:
.globl vector91
vector91:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $91
80106930:	6a 5b                	push   $0x5b
  jmp alltraps
80106932:	e9 1c f8 ff ff       	jmp    80106153 <alltraps>

80106937 <vector92>:
.globl vector92
vector92:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $92
80106939:	6a 5c                	push   $0x5c
  jmp alltraps
8010693b:	e9 13 f8 ff ff       	jmp    80106153 <alltraps>

80106940 <vector93>:
.globl vector93
vector93:
  pushl $0
80106940:	6a 00                	push   $0x0
  pushl $93
80106942:	6a 5d                	push   $0x5d
  jmp alltraps
80106944:	e9 0a f8 ff ff       	jmp    80106153 <alltraps>

80106949 <vector94>:
.globl vector94
vector94:
  pushl $0
80106949:	6a 00                	push   $0x0
  pushl $94
8010694b:	6a 5e                	push   $0x5e
  jmp alltraps
8010694d:	e9 01 f8 ff ff       	jmp    80106153 <alltraps>

80106952 <vector95>:
.globl vector95
vector95:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $95
80106954:	6a 5f                	push   $0x5f
  jmp alltraps
80106956:	e9 f8 f7 ff ff       	jmp    80106153 <alltraps>

8010695b <vector96>:
.globl vector96
vector96:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $96
8010695d:	6a 60                	push   $0x60
  jmp alltraps
8010695f:	e9 ef f7 ff ff       	jmp    80106153 <alltraps>

80106964 <vector97>:
.globl vector97
vector97:
  pushl $0
80106964:	6a 00                	push   $0x0
  pushl $97
80106966:	6a 61                	push   $0x61
  jmp alltraps
80106968:	e9 e6 f7 ff ff       	jmp    80106153 <alltraps>

8010696d <vector98>:
.globl vector98
vector98:
  pushl $0
8010696d:	6a 00                	push   $0x0
  pushl $98
8010696f:	6a 62                	push   $0x62
  jmp alltraps
80106971:	e9 dd f7 ff ff       	jmp    80106153 <alltraps>

80106976 <vector99>:
.globl vector99
vector99:
  pushl $0
80106976:	6a 00                	push   $0x0
  pushl $99
80106978:	6a 63                	push   $0x63
  jmp alltraps
8010697a:	e9 d4 f7 ff ff       	jmp    80106153 <alltraps>

8010697f <vector100>:
.globl vector100
vector100:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $100
80106981:	6a 64                	push   $0x64
  jmp alltraps
80106983:	e9 cb f7 ff ff       	jmp    80106153 <alltraps>

80106988 <vector101>:
.globl vector101
vector101:
  pushl $0
80106988:	6a 00                	push   $0x0
  pushl $101
8010698a:	6a 65                	push   $0x65
  jmp alltraps
8010698c:	e9 c2 f7 ff ff       	jmp    80106153 <alltraps>

80106991 <vector102>:
.globl vector102
vector102:
  pushl $0
80106991:	6a 00                	push   $0x0
  pushl $102
80106993:	6a 66                	push   $0x66
  jmp alltraps
80106995:	e9 b9 f7 ff ff       	jmp    80106153 <alltraps>

8010699a <vector103>:
.globl vector103
vector103:
  pushl $0
8010699a:	6a 00                	push   $0x0
  pushl $103
8010699c:	6a 67                	push   $0x67
  jmp alltraps
8010699e:	e9 b0 f7 ff ff       	jmp    80106153 <alltraps>

801069a3 <vector104>:
.globl vector104
vector104:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $104
801069a5:	6a 68                	push   $0x68
  jmp alltraps
801069a7:	e9 a7 f7 ff ff       	jmp    80106153 <alltraps>

801069ac <vector105>:
.globl vector105
vector105:
  pushl $0
801069ac:	6a 00                	push   $0x0
  pushl $105
801069ae:	6a 69                	push   $0x69
  jmp alltraps
801069b0:	e9 9e f7 ff ff       	jmp    80106153 <alltraps>

801069b5 <vector106>:
.globl vector106
vector106:
  pushl $0
801069b5:	6a 00                	push   $0x0
  pushl $106
801069b7:	6a 6a                	push   $0x6a
  jmp alltraps
801069b9:	e9 95 f7 ff ff       	jmp    80106153 <alltraps>

801069be <vector107>:
.globl vector107
vector107:
  pushl $0
801069be:	6a 00                	push   $0x0
  pushl $107
801069c0:	6a 6b                	push   $0x6b
  jmp alltraps
801069c2:	e9 8c f7 ff ff       	jmp    80106153 <alltraps>

801069c7 <vector108>:
.globl vector108
vector108:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $108
801069c9:	6a 6c                	push   $0x6c
  jmp alltraps
801069cb:	e9 83 f7 ff ff       	jmp    80106153 <alltraps>

801069d0 <vector109>:
.globl vector109
vector109:
  pushl $0
801069d0:	6a 00                	push   $0x0
  pushl $109
801069d2:	6a 6d                	push   $0x6d
  jmp alltraps
801069d4:	e9 7a f7 ff ff       	jmp    80106153 <alltraps>

801069d9 <vector110>:
.globl vector110
vector110:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $110
801069db:	6a 6e                	push   $0x6e
  jmp alltraps
801069dd:	e9 71 f7 ff ff       	jmp    80106153 <alltraps>

801069e2 <vector111>:
.globl vector111
vector111:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $111
801069e4:	6a 6f                	push   $0x6f
  jmp alltraps
801069e6:	e9 68 f7 ff ff       	jmp    80106153 <alltraps>

801069eb <vector112>:
.globl vector112
vector112:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $112
801069ed:	6a 70                	push   $0x70
  jmp alltraps
801069ef:	e9 5f f7 ff ff       	jmp    80106153 <alltraps>

801069f4 <vector113>:
.globl vector113
vector113:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $113
801069f6:	6a 71                	push   $0x71
  jmp alltraps
801069f8:	e9 56 f7 ff ff       	jmp    80106153 <alltraps>

801069fd <vector114>:
.globl vector114
vector114:
  pushl $0
801069fd:	6a 00                	push   $0x0
  pushl $114
801069ff:	6a 72                	push   $0x72
  jmp alltraps
80106a01:	e9 4d f7 ff ff       	jmp    80106153 <alltraps>

80106a06 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $115
80106a08:	6a 73                	push   $0x73
  jmp alltraps
80106a0a:	e9 44 f7 ff ff       	jmp    80106153 <alltraps>

80106a0f <vector116>:
.globl vector116
vector116:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $116
80106a11:	6a 74                	push   $0x74
  jmp alltraps
80106a13:	e9 3b f7 ff ff       	jmp    80106153 <alltraps>

80106a18 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $117
80106a1a:	6a 75                	push   $0x75
  jmp alltraps
80106a1c:	e9 32 f7 ff ff       	jmp    80106153 <alltraps>

80106a21 <vector118>:
.globl vector118
vector118:
  pushl $0
80106a21:	6a 00                	push   $0x0
  pushl $118
80106a23:	6a 76                	push   $0x76
  jmp alltraps
80106a25:	e9 29 f7 ff ff       	jmp    80106153 <alltraps>

80106a2a <vector119>:
.globl vector119
vector119:
  pushl $0
80106a2a:	6a 00                	push   $0x0
  pushl $119
80106a2c:	6a 77                	push   $0x77
  jmp alltraps
80106a2e:	e9 20 f7 ff ff       	jmp    80106153 <alltraps>

80106a33 <vector120>:
.globl vector120
vector120:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $120
80106a35:	6a 78                	push   $0x78
  jmp alltraps
80106a37:	e9 17 f7 ff ff       	jmp    80106153 <alltraps>

80106a3c <vector121>:
.globl vector121
vector121:
  pushl $0
80106a3c:	6a 00                	push   $0x0
  pushl $121
80106a3e:	6a 79                	push   $0x79
  jmp alltraps
80106a40:	e9 0e f7 ff ff       	jmp    80106153 <alltraps>

80106a45 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a45:	6a 00                	push   $0x0
  pushl $122
80106a47:	6a 7a                	push   $0x7a
  jmp alltraps
80106a49:	e9 05 f7 ff ff       	jmp    80106153 <alltraps>

80106a4e <vector123>:
.globl vector123
vector123:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $123
80106a50:	6a 7b                	push   $0x7b
  jmp alltraps
80106a52:	e9 fc f6 ff ff       	jmp    80106153 <alltraps>

80106a57 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $124
80106a59:	6a 7c                	push   $0x7c
  jmp alltraps
80106a5b:	e9 f3 f6 ff ff       	jmp    80106153 <alltraps>

80106a60 <vector125>:
.globl vector125
vector125:
  pushl $0
80106a60:	6a 00                	push   $0x0
  pushl $125
80106a62:	6a 7d                	push   $0x7d
  jmp alltraps
80106a64:	e9 ea f6 ff ff       	jmp    80106153 <alltraps>

80106a69 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a69:	6a 00                	push   $0x0
  pushl $126
80106a6b:	6a 7e                	push   $0x7e
  jmp alltraps
80106a6d:	e9 e1 f6 ff ff       	jmp    80106153 <alltraps>

80106a72 <vector127>:
.globl vector127
vector127:
  pushl $0
80106a72:	6a 00                	push   $0x0
  pushl $127
80106a74:	6a 7f                	push   $0x7f
  jmp alltraps
80106a76:	e9 d8 f6 ff ff       	jmp    80106153 <alltraps>

80106a7b <vector128>:
.globl vector128
vector128:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $128
80106a7d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a82:	e9 cc f6 ff ff       	jmp    80106153 <alltraps>

80106a87 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $129
80106a89:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a8e:	e9 c0 f6 ff ff       	jmp    80106153 <alltraps>

80106a93 <vector130>:
.globl vector130
vector130:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $130
80106a95:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a9a:	e9 b4 f6 ff ff       	jmp    80106153 <alltraps>

80106a9f <vector131>:
.globl vector131
vector131:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $131
80106aa1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106aa6:	e9 a8 f6 ff ff       	jmp    80106153 <alltraps>

80106aab <vector132>:
.globl vector132
vector132:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $132
80106aad:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ab2:	e9 9c f6 ff ff       	jmp    80106153 <alltraps>

80106ab7 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $133
80106ab9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106abe:	e9 90 f6 ff ff       	jmp    80106153 <alltraps>

80106ac3 <vector134>:
.globl vector134
vector134:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $134
80106ac5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106aca:	e9 84 f6 ff ff       	jmp    80106153 <alltraps>

80106acf <vector135>:
.globl vector135
vector135:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $135
80106ad1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ad6:	e9 78 f6 ff ff       	jmp    80106153 <alltraps>

80106adb <vector136>:
.globl vector136
vector136:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $136
80106add:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ae2:	e9 6c f6 ff ff       	jmp    80106153 <alltraps>

80106ae7 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $137
80106ae9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106aee:	e9 60 f6 ff ff       	jmp    80106153 <alltraps>

80106af3 <vector138>:
.globl vector138
vector138:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $138
80106af5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106afa:	e9 54 f6 ff ff       	jmp    80106153 <alltraps>

80106aff <vector139>:
.globl vector139
vector139:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $139
80106b01:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b06:	e9 48 f6 ff ff       	jmp    80106153 <alltraps>

80106b0b <vector140>:
.globl vector140
vector140:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $140
80106b0d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b12:	e9 3c f6 ff ff       	jmp    80106153 <alltraps>

80106b17 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $141
80106b19:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b1e:	e9 30 f6 ff ff       	jmp    80106153 <alltraps>

80106b23 <vector142>:
.globl vector142
vector142:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $142
80106b25:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b2a:	e9 24 f6 ff ff       	jmp    80106153 <alltraps>

80106b2f <vector143>:
.globl vector143
vector143:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $143
80106b31:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b36:	e9 18 f6 ff ff       	jmp    80106153 <alltraps>

80106b3b <vector144>:
.globl vector144
vector144:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $144
80106b3d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b42:	e9 0c f6 ff ff       	jmp    80106153 <alltraps>

80106b47 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $145
80106b49:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b4e:	e9 00 f6 ff ff       	jmp    80106153 <alltraps>

80106b53 <vector146>:
.globl vector146
vector146:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $146
80106b55:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b5a:	e9 f4 f5 ff ff       	jmp    80106153 <alltraps>

80106b5f <vector147>:
.globl vector147
vector147:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $147
80106b61:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b66:	e9 e8 f5 ff ff       	jmp    80106153 <alltraps>

80106b6b <vector148>:
.globl vector148
vector148:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $148
80106b6d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b72:	e9 dc f5 ff ff       	jmp    80106153 <alltraps>

80106b77 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $149
80106b79:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b7e:	e9 d0 f5 ff ff       	jmp    80106153 <alltraps>

80106b83 <vector150>:
.globl vector150
vector150:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $150
80106b85:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b8a:	e9 c4 f5 ff ff       	jmp    80106153 <alltraps>

80106b8f <vector151>:
.globl vector151
vector151:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $151
80106b91:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b96:	e9 b8 f5 ff ff       	jmp    80106153 <alltraps>

80106b9b <vector152>:
.globl vector152
vector152:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $152
80106b9d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106ba2:	e9 ac f5 ff ff       	jmp    80106153 <alltraps>

80106ba7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $153
80106ba9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106bae:	e9 a0 f5 ff ff       	jmp    80106153 <alltraps>

80106bb3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $154
80106bb5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106bba:	e9 94 f5 ff ff       	jmp    80106153 <alltraps>

80106bbf <vector155>:
.globl vector155
vector155:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $155
80106bc1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106bc6:	e9 88 f5 ff ff       	jmp    80106153 <alltraps>

80106bcb <vector156>:
.globl vector156
vector156:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $156
80106bcd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106bd2:	e9 7c f5 ff ff       	jmp    80106153 <alltraps>

80106bd7 <vector157>:
.globl vector157
vector157:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $157
80106bd9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bde:	e9 70 f5 ff ff       	jmp    80106153 <alltraps>

80106be3 <vector158>:
.globl vector158
vector158:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $158
80106be5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106bea:	e9 64 f5 ff ff       	jmp    80106153 <alltraps>

80106bef <vector159>:
.globl vector159
vector159:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $159
80106bf1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106bf6:	e9 58 f5 ff ff       	jmp    80106153 <alltraps>

80106bfb <vector160>:
.globl vector160
vector160:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $160
80106bfd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c02:	e9 4c f5 ff ff       	jmp    80106153 <alltraps>

80106c07 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $161
80106c09:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c0e:	e9 40 f5 ff ff       	jmp    80106153 <alltraps>

80106c13 <vector162>:
.globl vector162
vector162:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $162
80106c15:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c1a:	e9 34 f5 ff ff       	jmp    80106153 <alltraps>

80106c1f <vector163>:
.globl vector163
vector163:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $163
80106c21:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c26:	e9 28 f5 ff ff       	jmp    80106153 <alltraps>

80106c2b <vector164>:
.globl vector164
vector164:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $164
80106c2d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c32:	e9 1c f5 ff ff       	jmp    80106153 <alltraps>

80106c37 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $165
80106c39:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c3e:	e9 10 f5 ff ff       	jmp    80106153 <alltraps>

80106c43 <vector166>:
.globl vector166
vector166:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $166
80106c45:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c4a:	e9 04 f5 ff ff       	jmp    80106153 <alltraps>

80106c4f <vector167>:
.globl vector167
vector167:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $167
80106c51:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c56:	e9 f8 f4 ff ff       	jmp    80106153 <alltraps>

80106c5b <vector168>:
.globl vector168
vector168:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $168
80106c5d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c62:	e9 ec f4 ff ff       	jmp    80106153 <alltraps>

80106c67 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $169
80106c69:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c6e:	e9 e0 f4 ff ff       	jmp    80106153 <alltraps>

80106c73 <vector170>:
.globl vector170
vector170:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $170
80106c75:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c7a:	e9 d4 f4 ff ff       	jmp    80106153 <alltraps>

80106c7f <vector171>:
.globl vector171
vector171:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $171
80106c81:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c86:	e9 c8 f4 ff ff       	jmp    80106153 <alltraps>

80106c8b <vector172>:
.globl vector172
vector172:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $172
80106c8d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c92:	e9 bc f4 ff ff       	jmp    80106153 <alltraps>

80106c97 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $173
80106c99:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c9e:	e9 b0 f4 ff ff       	jmp    80106153 <alltraps>

80106ca3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $174
80106ca5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106caa:	e9 a4 f4 ff ff       	jmp    80106153 <alltraps>

80106caf <vector175>:
.globl vector175
vector175:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $175
80106cb1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106cb6:	e9 98 f4 ff ff       	jmp    80106153 <alltraps>

80106cbb <vector176>:
.globl vector176
vector176:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $176
80106cbd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106cc2:	e9 8c f4 ff ff       	jmp    80106153 <alltraps>

80106cc7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $177
80106cc9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106cce:	e9 80 f4 ff ff       	jmp    80106153 <alltraps>

80106cd3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $178
80106cd5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106cda:	e9 74 f4 ff ff       	jmp    80106153 <alltraps>

80106cdf <vector179>:
.globl vector179
vector179:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $179
80106ce1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ce6:	e9 68 f4 ff ff       	jmp    80106153 <alltraps>

80106ceb <vector180>:
.globl vector180
vector180:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $180
80106ced:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cf2:	e9 5c f4 ff ff       	jmp    80106153 <alltraps>

80106cf7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $181
80106cf9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cfe:	e9 50 f4 ff ff       	jmp    80106153 <alltraps>

80106d03 <vector182>:
.globl vector182
vector182:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $182
80106d05:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d0a:	e9 44 f4 ff ff       	jmp    80106153 <alltraps>

80106d0f <vector183>:
.globl vector183
vector183:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $183
80106d11:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d16:	e9 38 f4 ff ff       	jmp    80106153 <alltraps>

80106d1b <vector184>:
.globl vector184
vector184:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $184
80106d1d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d22:	e9 2c f4 ff ff       	jmp    80106153 <alltraps>

80106d27 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $185
80106d29:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d2e:	e9 20 f4 ff ff       	jmp    80106153 <alltraps>

80106d33 <vector186>:
.globl vector186
vector186:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $186
80106d35:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d3a:	e9 14 f4 ff ff       	jmp    80106153 <alltraps>

80106d3f <vector187>:
.globl vector187
vector187:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $187
80106d41:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d46:	e9 08 f4 ff ff       	jmp    80106153 <alltraps>

80106d4b <vector188>:
.globl vector188
vector188:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $188
80106d4d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d52:	e9 fc f3 ff ff       	jmp    80106153 <alltraps>

80106d57 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $189
80106d59:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d5e:	e9 f0 f3 ff ff       	jmp    80106153 <alltraps>

80106d63 <vector190>:
.globl vector190
vector190:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $190
80106d65:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d6a:	e9 e4 f3 ff ff       	jmp    80106153 <alltraps>

80106d6f <vector191>:
.globl vector191
vector191:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $191
80106d71:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d76:	e9 d8 f3 ff ff       	jmp    80106153 <alltraps>

80106d7b <vector192>:
.globl vector192
vector192:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $192
80106d7d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d82:	e9 cc f3 ff ff       	jmp    80106153 <alltraps>

80106d87 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $193
80106d89:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d8e:	e9 c0 f3 ff ff       	jmp    80106153 <alltraps>

80106d93 <vector194>:
.globl vector194
vector194:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $194
80106d95:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d9a:	e9 b4 f3 ff ff       	jmp    80106153 <alltraps>

80106d9f <vector195>:
.globl vector195
vector195:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $195
80106da1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106da6:	e9 a8 f3 ff ff       	jmp    80106153 <alltraps>

80106dab <vector196>:
.globl vector196
vector196:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $196
80106dad:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106db2:	e9 9c f3 ff ff       	jmp    80106153 <alltraps>

80106db7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $197
80106db9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106dbe:	e9 90 f3 ff ff       	jmp    80106153 <alltraps>

80106dc3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $198
80106dc5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106dca:	e9 84 f3 ff ff       	jmp    80106153 <alltraps>

80106dcf <vector199>:
.globl vector199
vector199:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $199
80106dd1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106dd6:	e9 78 f3 ff ff       	jmp    80106153 <alltraps>

80106ddb <vector200>:
.globl vector200
vector200:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $200
80106ddd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106de2:	e9 6c f3 ff ff       	jmp    80106153 <alltraps>

80106de7 <vector201>:
.globl vector201
vector201:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $201
80106de9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106dee:	e9 60 f3 ff ff       	jmp    80106153 <alltraps>

80106df3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $202
80106df5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106dfa:	e9 54 f3 ff ff       	jmp    80106153 <alltraps>

80106dff <vector203>:
.globl vector203
vector203:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $203
80106e01:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e06:	e9 48 f3 ff ff       	jmp    80106153 <alltraps>

80106e0b <vector204>:
.globl vector204
vector204:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $204
80106e0d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e12:	e9 3c f3 ff ff       	jmp    80106153 <alltraps>

80106e17 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $205
80106e19:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e1e:	e9 30 f3 ff ff       	jmp    80106153 <alltraps>

80106e23 <vector206>:
.globl vector206
vector206:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $206
80106e25:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e2a:	e9 24 f3 ff ff       	jmp    80106153 <alltraps>

80106e2f <vector207>:
.globl vector207
vector207:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $207
80106e31:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e36:	e9 18 f3 ff ff       	jmp    80106153 <alltraps>

80106e3b <vector208>:
.globl vector208
vector208:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $208
80106e3d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e42:	e9 0c f3 ff ff       	jmp    80106153 <alltraps>

80106e47 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $209
80106e49:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e4e:	e9 00 f3 ff ff       	jmp    80106153 <alltraps>

80106e53 <vector210>:
.globl vector210
vector210:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $210
80106e55:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e5a:	e9 f4 f2 ff ff       	jmp    80106153 <alltraps>

80106e5f <vector211>:
.globl vector211
vector211:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $211
80106e61:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e66:	e9 e8 f2 ff ff       	jmp    80106153 <alltraps>

80106e6b <vector212>:
.globl vector212
vector212:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $212
80106e6d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e72:	e9 dc f2 ff ff       	jmp    80106153 <alltraps>

80106e77 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $213
80106e79:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e7e:	e9 d0 f2 ff ff       	jmp    80106153 <alltraps>

80106e83 <vector214>:
.globl vector214
vector214:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $214
80106e85:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e8a:	e9 c4 f2 ff ff       	jmp    80106153 <alltraps>

80106e8f <vector215>:
.globl vector215
vector215:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $215
80106e91:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e96:	e9 b8 f2 ff ff       	jmp    80106153 <alltraps>

80106e9b <vector216>:
.globl vector216
vector216:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $216
80106e9d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ea2:	e9 ac f2 ff ff       	jmp    80106153 <alltraps>

80106ea7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $217
80106ea9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106eae:	e9 a0 f2 ff ff       	jmp    80106153 <alltraps>

80106eb3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $218
80106eb5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106eba:	e9 94 f2 ff ff       	jmp    80106153 <alltraps>

80106ebf <vector219>:
.globl vector219
vector219:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $219
80106ec1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ec6:	e9 88 f2 ff ff       	jmp    80106153 <alltraps>

80106ecb <vector220>:
.globl vector220
vector220:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $220
80106ecd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ed2:	e9 7c f2 ff ff       	jmp    80106153 <alltraps>

80106ed7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $221
80106ed9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106ede:	e9 70 f2 ff ff       	jmp    80106153 <alltraps>

80106ee3 <vector222>:
.globl vector222
vector222:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $222
80106ee5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106eea:	e9 64 f2 ff ff       	jmp    80106153 <alltraps>

80106eef <vector223>:
.globl vector223
vector223:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $223
80106ef1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ef6:	e9 58 f2 ff ff       	jmp    80106153 <alltraps>

80106efb <vector224>:
.globl vector224
vector224:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $224
80106efd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f02:	e9 4c f2 ff ff       	jmp    80106153 <alltraps>

80106f07 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $225
80106f09:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f0e:	e9 40 f2 ff ff       	jmp    80106153 <alltraps>

80106f13 <vector226>:
.globl vector226
vector226:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $226
80106f15:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f1a:	e9 34 f2 ff ff       	jmp    80106153 <alltraps>

80106f1f <vector227>:
.globl vector227
vector227:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $227
80106f21:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f26:	e9 28 f2 ff ff       	jmp    80106153 <alltraps>

80106f2b <vector228>:
.globl vector228
vector228:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $228
80106f2d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f32:	e9 1c f2 ff ff       	jmp    80106153 <alltraps>

80106f37 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $229
80106f39:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f3e:	e9 10 f2 ff ff       	jmp    80106153 <alltraps>

80106f43 <vector230>:
.globl vector230
vector230:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $230
80106f45:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f4a:	e9 04 f2 ff ff       	jmp    80106153 <alltraps>

80106f4f <vector231>:
.globl vector231
vector231:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $231
80106f51:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f56:	e9 f8 f1 ff ff       	jmp    80106153 <alltraps>

80106f5b <vector232>:
.globl vector232
vector232:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $232
80106f5d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f62:	e9 ec f1 ff ff       	jmp    80106153 <alltraps>

80106f67 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $233
80106f69:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f6e:	e9 e0 f1 ff ff       	jmp    80106153 <alltraps>

80106f73 <vector234>:
.globl vector234
vector234:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $234
80106f75:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f7a:	e9 d4 f1 ff ff       	jmp    80106153 <alltraps>

80106f7f <vector235>:
.globl vector235
vector235:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $235
80106f81:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f86:	e9 c8 f1 ff ff       	jmp    80106153 <alltraps>

80106f8b <vector236>:
.globl vector236
vector236:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $236
80106f8d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f92:	e9 bc f1 ff ff       	jmp    80106153 <alltraps>

80106f97 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $237
80106f99:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f9e:	e9 b0 f1 ff ff       	jmp    80106153 <alltraps>

80106fa3 <vector238>:
.globl vector238
vector238:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $238
80106fa5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106faa:	e9 a4 f1 ff ff       	jmp    80106153 <alltraps>

80106faf <vector239>:
.globl vector239
vector239:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $239
80106fb1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106fb6:	e9 98 f1 ff ff       	jmp    80106153 <alltraps>

80106fbb <vector240>:
.globl vector240
vector240:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $240
80106fbd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106fc2:	e9 8c f1 ff ff       	jmp    80106153 <alltraps>

80106fc7 <vector241>:
.globl vector241
vector241:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $241
80106fc9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106fce:	e9 80 f1 ff ff       	jmp    80106153 <alltraps>

80106fd3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $242
80106fd5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106fda:	e9 74 f1 ff ff       	jmp    80106153 <alltraps>

80106fdf <vector243>:
.globl vector243
vector243:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $243
80106fe1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106fe6:	e9 68 f1 ff ff       	jmp    80106153 <alltraps>

80106feb <vector244>:
.globl vector244
vector244:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $244
80106fed:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106ff2:	e9 5c f1 ff ff       	jmp    80106153 <alltraps>

80106ff7 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $245
80106ff9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106ffe:	e9 50 f1 ff ff       	jmp    80106153 <alltraps>

80107003 <vector246>:
.globl vector246
vector246:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $246
80107005:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010700a:	e9 44 f1 ff ff       	jmp    80106153 <alltraps>

8010700f <vector247>:
.globl vector247
vector247:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $247
80107011:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107016:	e9 38 f1 ff ff       	jmp    80106153 <alltraps>

8010701b <vector248>:
.globl vector248
vector248:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $248
8010701d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107022:	e9 2c f1 ff ff       	jmp    80106153 <alltraps>

80107027 <vector249>:
.globl vector249
vector249:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $249
80107029:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010702e:	e9 20 f1 ff ff       	jmp    80106153 <alltraps>

80107033 <vector250>:
.globl vector250
vector250:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $250
80107035:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010703a:	e9 14 f1 ff ff       	jmp    80106153 <alltraps>

8010703f <vector251>:
.globl vector251
vector251:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $251
80107041:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107046:	e9 08 f1 ff ff       	jmp    80106153 <alltraps>

8010704b <vector252>:
.globl vector252
vector252:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $252
8010704d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107052:	e9 fc f0 ff ff       	jmp    80106153 <alltraps>

80107057 <vector253>:
.globl vector253
vector253:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $253
80107059:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010705e:	e9 f0 f0 ff ff       	jmp    80106153 <alltraps>

80107063 <vector254>:
.globl vector254
vector254:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $254
80107065:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010706a:	e9 e4 f0 ff ff       	jmp    80106153 <alltraps>

8010706f <vector255>:
.globl vector255
vector255:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $255
80107071:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107076:	e9 d8 f0 ff ff       	jmp    80106153 <alltraps>
8010707b:	66 90                	xchg   %ax,%ax
8010707d:	66 90                	xchg   %ax,%ax
8010707f:	90                   	nop

80107080 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	57                   	push   %edi
80107084:	56                   	push   %esi
80107085:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107087:	c1 ea 16             	shr    $0x16,%edx
{
8010708a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010708b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010708e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107091:	8b 1f                	mov    (%edi),%ebx
80107093:	f6 c3 01             	test   $0x1,%bl
80107096:	74 28                	je     801070c0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107098:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010709e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801070a4:	89 f0                	mov    %esi,%eax
}
801070a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801070a9:	c1 e8 0a             	shr    $0xa,%eax
801070ac:	25 fc 0f 00 00       	and    $0xffc,%eax
801070b1:	01 d8                	add    %ebx,%eax
}
801070b3:	5b                   	pop    %ebx
801070b4:	5e                   	pop    %esi
801070b5:	5f                   	pop    %edi
801070b6:	5d                   	pop    %ebp
801070b7:	c3                   	ret    
801070b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070bf:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801070c0:	85 c9                	test   %ecx,%ecx
801070c2:	74 2c                	je     801070f0 <walkpgdir+0x70>
801070c4:	e8 97 b5 ff ff       	call   80102660 <kalloc>
801070c9:	89 c3                	mov    %eax,%ebx
801070cb:	85 c0                	test   %eax,%eax
801070cd:	74 21                	je     801070f0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801070cf:	83 ec 04             	sub    $0x4,%esp
801070d2:	68 00 10 00 00       	push   $0x1000
801070d7:	6a 00                	push   $0x0
801070d9:	50                   	push   %eax
801070da:	e8 a1 dd ff ff       	call   80104e80 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801070df:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070e5:	83 c4 10             	add    $0x10,%esp
801070e8:	83 c8 07             	or     $0x7,%eax
801070eb:	89 07                	mov    %eax,(%edi)
801070ed:	eb b5                	jmp    801070a4 <walkpgdir+0x24>
801070ef:	90                   	nop
}
801070f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801070f3:	31 c0                	xor    %eax,%eax
}
801070f5:	5b                   	pop    %ebx
801070f6:	5e                   	pop    %esi
801070f7:	5f                   	pop    %edi
801070f8:	5d                   	pop    %ebp
801070f9:	c3                   	ret    
801070fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107100 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107106:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010710a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010710b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107110:	89 d6                	mov    %edx,%esi
{
80107112:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107113:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107119:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010711c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010711f:	8b 45 08             	mov    0x8(%ebp),%eax
80107122:	29 f0                	sub    %esi,%eax
80107124:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107127:	eb 1f                	jmp    80107148 <mappages+0x48>
80107129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107130:	f6 00 01             	testb  $0x1,(%eax)
80107133:	75 45                	jne    8010717a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107135:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107138:	83 cb 01             	or     $0x1,%ebx
8010713b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010713d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107140:	74 2e                	je     80107170 <mappages+0x70>
      break;
    a += PGSIZE;
80107142:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107148:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010714b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107150:	89 f2                	mov    %esi,%edx
80107152:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107155:	89 f8                	mov    %edi,%eax
80107157:	e8 24 ff ff ff       	call   80107080 <walkpgdir>
8010715c:	85 c0                	test   %eax,%eax
8010715e:	75 d0                	jne    80107130 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107160:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107163:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107168:	5b                   	pop    %ebx
80107169:	5e                   	pop    %esi
8010716a:	5f                   	pop    %edi
8010716b:	5d                   	pop    %ebp
8010716c:	c3                   	ret    
8010716d:	8d 76 00             	lea    0x0(%esi),%esi
80107170:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107173:	31 c0                	xor    %eax,%eax
}
80107175:	5b                   	pop    %ebx
80107176:	5e                   	pop    %esi
80107177:	5f                   	pop    %edi
80107178:	5d                   	pop    %ebp
80107179:	c3                   	ret    
      panic("remap");
8010717a:	83 ec 0c             	sub    $0xc,%esp
8010717d:	68 d4 84 10 80       	push   $0x801084d4
80107182:	e8 09 92 ff ff       	call   80100390 <panic>
80107187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718e:	66 90                	xchg   %ax,%ax

80107190 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	57                   	push   %edi
80107194:	56                   	push   %esi
80107195:	89 c6                	mov    %eax,%esi
80107197:	53                   	push   %ebx
80107198:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010719a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801071a0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801071a6:	83 ec 1c             	sub    $0x1c,%esp
801071a9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801071ac:	39 da                	cmp    %ebx,%edx
801071ae:	73 5b                	jae    8010720b <deallocuvm.part.0+0x7b>
801071b0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801071b3:	89 d7                	mov    %edx,%edi
801071b5:	eb 14                	jmp    801071cb <deallocuvm.part.0+0x3b>
801071b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071be:	66 90                	xchg   %ax,%ax
801071c0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801071c6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801071c9:	76 40                	jbe    8010720b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
801071cb:	31 c9                	xor    %ecx,%ecx
801071cd:	89 fa                	mov    %edi,%edx
801071cf:	89 f0                	mov    %esi,%eax
801071d1:	e8 aa fe ff ff       	call   80107080 <walkpgdir>
801071d6:	89 c3                	mov    %eax,%ebx
    if(!pte)
801071d8:	85 c0                	test   %eax,%eax
801071da:	74 44                	je     80107220 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801071dc:	8b 00                	mov    (%eax),%eax
801071de:	a8 01                	test   $0x1,%al
801071e0:	74 de                	je     801071c0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801071e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071e7:	74 47                	je     80107230 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801071e9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801071ec:	05 00 00 00 80       	add    $0x80000000,%eax
801071f1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
801071f7:	50                   	push   %eax
801071f8:	e8 a3 b2 ff ff       	call   801024a0 <kfree>
      *pte = 0;
801071fd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107203:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107206:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107209:	77 c0                	ja     801071cb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010720b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010720e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107211:	5b                   	pop    %ebx
80107212:	5e                   	pop    %esi
80107213:	5f                   	pop    %edi
80107214:	5d                   	pop    %ebp
80107215:	c3                   	ret    
80107216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010721d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107220:	89 fa                	mov    %edi,%edx
80107222:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107228:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010722e:	eb 96                	jmp    801071c6 <deallocuvm.part.0+0x36>
        panic("kfree");
80107230:	83 ec 0c             	sub    $0xc,%esp
80107233:	68 26 7c 10 80       	push   $0x80107c26
80107238:	e8 53 91 ff ff       	call   80100390 <panic>
8010723d:	8d 76 00             	lea    0x0(%esi),%esi

80107240 <seginit>:
{
80107240:	f3 0f 1e fb          	endbr32 
80107244:	55                   	push   %ebp
80107245:	89 e5                	mov    %esp,%ebp
80107247:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010724a:	e8 c1 c6 ff ff       	call   80103910 <cpuid>
  pd[0] = size-1;
8010724f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107254:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010725a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010725e:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80107265:	ff 00 00 
80107268:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
8010726f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107272:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80107279:	ff 00 00 
8010727c:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80107283:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107286:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
8010728d:	ff 00 00 
80107290:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80107297:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010729a:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
801072a1:	ff 00 00 
801072a4:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
801072ab:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801072ae:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
801072b3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801072b7:	c1 e8 10             	shr    $0x10,%eax
801072ba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801072be:	8d 45 f2             	lea    -0xe(%ebp),%eax
801072c1:	0f 01 10             	lgdtl  (%eax)
}
801072c4:	c9                   	leave  
801072c5:	c3                   	ret    
801072c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072cd:	8d 76 00             	lea    0x0(%esi),%esi

801072d0 <switchkvm>:
{
801072d0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072d4:	a1 a4 ab 11 80       	mov    0x8011aba4,%eax
801072d9:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072de:	0f 22 d8             	mov    %eax,%cr3
}
801072e1:	c3                   	ret    
801072e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072f0 <switchuvm>:
{
801072f0:	f3 0f 1e fb          	endbr32 
801072f4:	55                   	push   %ebp
801072f5:	89 e5                	mov    %esp,%ebp
801072f7:	57                   	push   %edi
801072f8:	56                   	push   %esi
801072f9:	53                   	push   %ebx
801072fa:	83 ec 1c             	sub    $0x1c,%esp
801072fd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107300:	85 f6                	test   %esi,%esi
80107302:	0f 84 cb 00 00 00    	je     801073d3 <switchuvm+0xe3>
  if(p->kstack == 0)
80107308:	8b 46 08             	mov    0x8(%esi),%eax
8010730b:	85 c0                	test   %eax,%eax
8010730d:	0f 84 da 00 00 00    	je     801073ed <switchuvm+0xfd>
  if(p->pgdir == 0)
80107313:	8b 46 04             	mov    0x4(%esi),%eax
80107316:	85 c0                	test   %eax,%eax
80107318:	0f 84 c2 00 00 00    	je     801073e0 <switchuvm+0xf0>
  pushcli();
8010731e:	e8 4d d9 ff ff       	call   80104c70 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107323:	e8 78 c5 ff ff       	call   801038a0 <mycpu>
80107328:	89 c3                	mov    %eax,%ebx
8010732a:	e8 71 c5 ff ff       	call   801038a0 <mycpu>
8010732f:	89 c7                	mov    %eax,%edi
80107331:	e8 6a c5 ff ff       	call   801038a0 <mycpu>
80107336:	83 c7 08             	add    $0x8,%edi
80107339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010733c:	e8 5f c5 ff ff       	call   801038a0 <mycpu>
80107341:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107344:	ba 67 00 00 00       	mov    $0x67,%edx
80107349:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107350:	83 c0 08             	add    $0x8,%eax
80107353:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010735a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010735f:	83 c1 08             	add    $0x8,%ecx
80107362:	c1 e8 18             	shr    $0x18,%eax
80107365:	c1 e9 10             	shr    $0x10,%ecx
80107368:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010736e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107374:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107379:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107380:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107385:	e8 16 c5 ff ff       	call   801038a0 <mycpu>
8010738a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107391:	e8 0a c5 ff ff       	call   801038a0 <mycpu>
80107396:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010739a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010739d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073a3:	e8 f8 c4 ff ff       	call   801038a0 <mycpu>
801073a8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073ab:	e8 f0 c4 ff ff       	call   801038a0 <mycpu>
801073b0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801073b4:	b8 28 00 00 00       	mov    $0x28,%eax
801073b9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801073bc:	8b 46 04             	mov    0x4(%esi),%eax
801073bf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073c4:	0f 22 d8             	mov    %eax,%cr3
}
801073c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ca:	5b                   	pop    %ebx
801073cb:	5e                   	pop    %esi
801073cc:	5f                   	pop    %edi
801073cd:	5d                   	pop    %ebp
  popcli();
801073ce:	e9 ed d8 ff ff       	jmp    80104cc0 <popcli>
    panic("switchuvm: no process");
801073d3:	83 ec 0c             	sub    $0xc,%esp
801073d6:	68 da 84 10 80       	push   $0x801084da
801073db:	e8 b0 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801073e0:	83 ec 0c             	sub    $0xc,%esp
801073e3:	68 05 85 10 80       	push   $0x80108505
801073e8:	e8 a3 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801073ed:	83 ec 0c             	sub    $0xc,%esp
801073f0:	68 f0 84 10 80       	push   $0x801084f0
801073f5:	e8 96 8f ff ff       	call   80100390 <panic>
801073fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107400 <inituvm>:
{
80107400:	f3 0f 1e fb          	endbr32 
80107404:	55                   	push   %ebp
80107405:	89 e5                	mov    %esp,%ebp
80107407:	57                   	push   %edi
80107408:	56                   	push   %esi
80107409:	53                   	push   %ebx
8010740a:	83 ec 1c             	sub    $0x1c,%esp
8010740d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107410:	8b 75 10             	mov    0x10(%ebp),%esi
80107413:	8b 7d 08             	mov    0x8(%ebp),%edi
80107416:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107419:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010741f:	77 4b                	ja     8010746c <inituvm+0x6c>
  mem = kalloc();
80107421:	e8 3a b2 ff ff       	call   80102660 <kalloc>
  memset(mem, 0, PGSIZE);
80107426:	83 ec 04             	sub    $0x4,%esp
80107429:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010742e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107430:	6a 00                	push   $0x0
80107432:	50                   	push   %eax
80107433:	e8 48 da ff ff       	call   80104e80 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107438:	58                   	pop    %eax
80107439:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010743f:	5a                   	pop    %edx
80107440:	6a 06                	push   $0x6
80107442:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107447:	31 d2                	xor    %edx,%edx
80107449:	50                   	push   %eax
8010744a:	89 f8                	mov    %edi,%eax
8010744c:	e8 af fc ff ff       	call   80107100 <mappages>
  memmove(mem, init, sz);
80107451:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107454:	89 75 10             	mov    %esi,0x10(%ebp)
80107457:	83 c4 10             	add    $0x10,%esp
8010745a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010745d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107460:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107463:	5b                   	pop    %ebx
80107464:	5e                   	pop    %esi
80107465:	5f                   	pop    %edi
80107466:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107467:	e9 b4 da ff ff       	jmp    80104f20 <memmove>
    panic("inituvm: more than a page");
8010746c:	83 ec 0c             	sub    $0xc,%esp
8010746f:	68 19 85 10 80       	push   $0x80108519
80107474:	e8 17 8f ff ff       	call   80100390 <panic>
80107479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107480 <loaduvm>:
{
80107480:	f3 0f 1e fb          	endbr32 
80107484:	55                   	push   %ebp
80107485:	89 e5                	mov    %esp,%ebp
80107487:	57                   	push   %edi
80107488:	56                   	push   %esi
80107489:	53                   	push   %ebx
8010748a:	83 ec 1c             	sub    $0x1c,%esp
8010748d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107490:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107493:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107498:	0f 85 99 00 00 00    	jne    80107537 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010749e:	01 f0                	add    %esi,%eax
801074a0:	89 f3                	mov    %esi,%ebx
801074a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074a5:	8b 45 14             	mov    0x14(%ebp),%eax
801074a8:	01 f0                	add    %esi,%eax
801074aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801074ad:	85 f6                	test   %esi,%esi
801074af:	75 15                	jne    801074c6 <loaduvm+0x46>
801074b1:	eb 6d                	jmp    80107520 <loaduvm+0xa0>
801074b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074b7:	90                   	nop
801074b8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801074be:	89 f0                	mov    %esi,%eax
801074c0:	29 d8                	sub    %ebx,%eax
801074c2:	39 c6                	cmp    %eax,%esi
801074c4:	76 5a                	jbe    80107520 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801074c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074c9:	8b 45 08             	mov    0x8(%ebp),%eax
801074cc:	31 c9                	xor    %ecx,%ecx
801074ce:	29 da                	sub    %ebx,%edx
801074d0:	e8 ab fb ff ff       	call   80107080 <walkpgdir>
801074d5:	85 c0                	test   %eax,%eax
801074d7:	74 51                	je     8010752a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801074d9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801074de:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801074e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801074e8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801074ee:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074f1:	29 d9                	sub    %ebx,%ecx
801074f3:	05 00 00 00 80       	add    $0x80000000,%eax
801074f8:	57                   	push   %edi
801074f9:	51                   	push   %ecx
801074fa:	50                   	push   %eax
801074fb:	ff 75 10             	pushl  0x10(%ebp)
801074fe:	e8 8d a5 ff ff       	call   80101a90 <readi>
80107503:	83 c4 10             	add    $0x10,%esp
80107506:	39 f8                	cmp    %edi,%eax
80107508:	74 ae                	je     801074b8 <loaduvm+0x38>
}
8010750a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010750d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107512:	5b                   	pop    %ebx
80107513:	5e                   	pop    %esi
80107514:	5f                   	pop    %edi
80107515:	5d                   	pop    %ebp
80107516:	c3                   	ret    
80107517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010751e:	66 90                	xchg   %ax,%ax
80107520:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107523:	31 c0                	xor    %eax,%eax
}
80107525:	5b                   	pop    %ebx
80107526:	5e                   	pop    %esi
80107527:	5f                   	pop    %edi
80107528:	5d                   	pop    %ebp
80107529:	c3                   	ret    
      panic("loaduvm: address should exist");
8010752a:	83 ec 0c             	sub    $0xc,%esp
8010752d:	68 33 85 10 80       	push   $0x80108533
80107532:	e8 59 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107537:	83 ec 0c             	sub    $0xc,%esp
8010753a:	68 d4 85 10 80       	push   $0x801085d4
8010753f:	e8 4c 8e ff ff       	call   80100390 <panic>
80107544:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010754b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010754f:	90                   	nop

80107550 <allocuvm>:
{
80107550:	f3 0f 1e fb          	endbr32 
80107554:	55                   	push   %ebp
80107555:	89 e5                	mov    %esp,%ebp
80107557:	57                   	push   %edi
80107558:	56                   	push   %esi
80107559:	53                   	push   %ebx
8010755a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010755d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107560:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107563:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107566:	85 c0                	test   %eax,%eax
80107568:	0f 88 b2 00 00 00    	js     80107620 <allocuvm+0xd0>
  if(newsz < oldsz)
8010756e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107571:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107574:	0f 82 96 00 00 00    	jb     80107610 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010757a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107580:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107586:	39 75 10             	cmp    %esi,0x10(%ebp)
80107589:	77 40                	ja     801075cb <allocuvm+0x7b>
8010758b:	e9 83 00 00 00       	jmp    80107613 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107590:	83 ec 04             	sub    $0x4,%esp
80107593:	68 00 10 00 00       	push   $0x1000
80107598:	6a 00                	push   $0x0
8010759a:	50                   	push   %eax
8010759b:	e8 e0 d8 ff ff       	call   80104e80 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801075a0:	58                   	pop    %eax
801075a1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075a7:	5a                   	pop    %edx
801075a8:	6a 06                	push   $0x6
801075aa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075af:	89 f2                	mov    %esi,%edx
801075b1:	50                   	push   %eax
801075b2:	89 f8                	mov    %edi,%eax
801075b4:	e8 47 fb ff ff       	call   80107100 <mappages>
801075b9:	83 c4 10             	add    $0x10,%esp
801075bc:	85 c0                	test   %eax,%eax
801075be:	78 78                	js     80107638 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801075c0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801075c6:	39 75 10             	cmp    %esi,0x10(%ebp)
801075c9:	76 48                	jbe    80107613 <allocuvm+0xc3>
    mem = kalloc();
801075cb:	e8 90 b0 ff ff       	call   80102660 <kalloc>
801075d0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801075d2:	85 c0                	test   %eax,%eax
801075d4:	75 ba                	jne    80107590 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801075d6:	83 ec 0c             	sub    $0xc,%esp
801075d9:	68 51 85 10 80       	push   $0x80108551
801075de:	e8 cd 90 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801075e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801075e6:	83 c4 10             	add    $0x10,%esp
801075e9:	39 45 10             	cmp    %eax,0x10(%ebp)
801075ec:	74 32                	je     80107620 <allocuvm+0xd0>
801075ee:	8b 55 10             	mov    0x10(%ebp),%edx
801075f1:	89 c1                	mov    %eax,%ecx
801075f3:	89 f8                	mov    %edi,%eax
801075f5:	e8 96 fb ff ff       	call   80107190 <deallocuvm.part.0>
      return 0;
801075fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107604:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107607:	5b                   	pop    %ebx
80107608:	5e                   	pop    %esi
80107609:	5f                   	pop    %edi
8010760a:	5d                   	pop    %ebp
8010760b:	c3                   	ret    
8010760c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107610:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107616:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107619:	5b                   	pop    %ebx
8010761a:	5e                   	pop    %esi
8010761b:	5f                   	pop    %edi
8010761c:	5d                   	pop    %ebp
8010761d:	c3                   	ret    
8010761e:	66 90                	xchg   %ax,%ax
    return 0;
80107620:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010762a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010762d:	5b                   	pop    %ebx
8010762e:	5e                   	pop    %esi
8010762f:	5f                   	pop    %edi
80107630:	5d                   	pop    %ebp
80107631:	c3                   	ret    
80107632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107638:	83 ec 0c             	sub    $0xc,%esp
8010763b:	68 69 85 10 80       	push   $0x80108569
80107640:	e8 6b 90 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107645:	8b 45 0c             	mov    0xc(%ebp),%eax
80107648:	83 c4 10             	add    $0x10,%esp
8010764b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010764e:	74 0c                	je     8010765c <allocuvm+0x10c>
80107650:	8b 55 10             	mov    0x10(%ebp),%edx
80107653:	89 c1                	mov    %eax,%ecx
80107655:	89 f8                	mov    %edi,%eax
80107657:	e8 34 fb ff ff       	call   80107190 <deallocuvm.part.0>
      kfree(mem);
8010765c:	83 ec 0c             	sub    $0xc,%esp
8010765f:	53                   	push   %ebx
80107660:	e8 3b ae ff ff       	call   801024a0 <kfree>
      return 0;
80107665:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010766c:	83 c4 10             	add    $0x10,%esp
}
8010766f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107672:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107675:	5b                   	pop    %ebx
80107676:	5e                   	pop    %esi
80107677:	5f                   	pop    %edi
80107678:	5d                   	pop    %ebp
80107679:	c3                   	ret    
8010767a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107680 <deallocuvm>:
{
80107680:	f3 0f 1e fb          	endbr32 
80107684:	55                   	push   %ebp
80107685:	89 e5                	mov    %esp,%ebp
80107687:	8b 55 0c             	mov    0xc(%ebp),%edx
8010768a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010768d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107690:	39 d1                	cmp    %edx,%ecx
80107692:	73 0c                	jae    801076a0 <deallocuvm+0x20>
}
80107694:	5d                   	pop    %ebp
80107695:	e9 f6 fa ff ff       	jmp    80107190 <deallocuvm.part.0>
8010769a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801076a0:	89 d0                	mov    %edx,%eax
801076a2:	5d                   	pop    %ebp
801076a3:	c3                   	ret    
801076a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076af:	90                   	nop

801076b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801076b0:	f3 0f 1e fb          	endbr32 
801076b4:	55                   	push   %ebp
801076b5:	89 e5                	mov    %esp,%ebp
801076b7:	57                   	push   %edi
801076b8:	56                   	push   %esi
801076b9:	53                   	push   %ebx
801076ba:	83 ec 0c             	sub    $0xc,%esp
801076bd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801076c0:	85 f6                	test   %esi,%esi
801076c2:	74 55                	je     80107719 <freevm+0x69>
  if(newsz >= oldsz)
801076c4:	31 c9                	xor    %ecx,%ecx
801076c6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801076cb:	89 f0                	mov    %esi,%eax
801076cd:	89 f3                	mov    %esi,%ebx
801076cf:	e8 bc fa ff ff       	call   80107190 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801076d4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801076da:	eb 0b                	jmp    801076e7 <freevm+0x37>
801076dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076e0:	83 c3 04             	add    $0x4,%ebx
801076e3:	39 df                	cmp    %ebx,%edi
801076e5:	74 23                	je     8010770a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801076e7:	8b 03                	mov    (%ebx),%eax
801076e9:	a8 01                	test   $0x1,%al
801076eb:	74 f3                	je     801076e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801076f2:	83 ec 0c             	sub    $0xc,%esp
801076f5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076f8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801076fd:	50                   	push   %eax
801076fe:	e8 9d ad ff ff       	call   801024a0 <kfree>
80107703:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107706:	39 df                	cmp    %ebx,%edi
80107708:	75 dd                	jne    801076e7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010770a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010770d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107710:	5b                   	pop    %ebx
80107711:	5e                   	pop    %esi
80107712:	5f                   	pop    %edi
80107713:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107714:	e9 87 ad ff ff       	jmp    801024a0 <kfree>
    panic("freevm: no pgdir");
80107719:	83 ec 0c             	sub    $0xc,%esp
8010771c:	68 85 85 10 80       	push   $0x80108585
80107721:	e8 6a 8c ff ff       	call   80100390 <panic>
80107726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010772d:	8d 76 00             	lea    0x0(%esi),%esi

80107730 <setupkvm>:
{
80107730:	f3 0f 1e fb          	endbr32 
80107734:	55                   	push   %ebp
80107735:	89 e5                	mov    %esp,%ebp
80107737:	56                   	push   %esi
80107738:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107739:	e8 22 af ff ff       	call   80102660 <kalloc>
8010773e:	89 c6                	mov    %eax,%esi
80107740:	85 c0                	test   %eax,%eax
80107742:	74 42                	je     80107786 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107744:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107747:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010774c:	68 00 10 00 00       	push   $0x1000
80107751:	6a 00                	push   $0x0
80107753:	50                   	push   %eax
80107754:	e8 27 d7 ff ff       	call   80104e80 <memset>
80107759:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010775c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010775f:	83 ec 08             	sub    $0x8,%esp
80107762:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107765:	ff 73 0c             	pushl  0xc(%ebx)
80107768:	8b 13                	mov    (%ebx),%edx
8010776a:	50                   	push   %eax
8010776b:	29 c1                	sub    %eax,%ecx
8010776d:	89 f0                	mov    %esi,%eax
8010776f:	e8 8c f9 ff ff       	call   80107100 <mappages>
80107774:	83 c4 10             	add    $0x10,%esp
80107777:	85 c0                	test   %eax,%eax
80107779:	78 15                	js     80107790 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010777b:	83 c3 10             	add    $0x10,%ebx
8010777e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107784:	75 d6                	jne    8010775c <setupkvm+0x2c>
}
80107786:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107789:	89 f0                	mov    %esi,%eax
8010778b:	5b                   	pop    %ebx
8010778c:	5e                   	pop    %esi
8010778d:	5d                   	pop    %ebp
8010778e:	c3                   	ret    
8010778f:	90                   	nop
      freevm(pgdir);
80107790:	83 ec 0c             	sub    $0xc,%esp
80107793:	56                   	push   %esi
      return 0;
80107794:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107796:	e8 15 ff ff ff       	call   801076b0 <freevm>
      return 0;
8010779b:	83 c4 10             	add    $0x10,%esp
}
8010779e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077a1:	89 f0                	mov    %esi,%eax
801077a3:	5b                   	pop    %ebx
801077a4:	5e                   	pop    %esi
801077a5:	5d                   	pop    %ebp
801077a6:	c3                   	ret    
801077a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ae:	66 90                	xchg   %ax,%ax

801077b0 <kvmalloc>:
{
801077b0:	f3 0f 1e fb          	endbr32 
801077b4:	55                   	push   %ebp
801077b5:	89 e5                	mov    %esp,%ebp
801077b7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801077ba:	e8 71 ff ff ff       	call   80107730 <setupkvm>
801077bf:	a3 a4 ab 11 80       	mov    %eax,0x8011aba4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077c4:	05 00 00 00 80       	add    $0x80000000,%eax
801077c9:	0f 22 d8             	mov    %eax,%cr3
}
801077cc:	c9                   	leave  
801077cd:	c3                   	ret    
801077ce:	66 90                	xchg   %ax,%ax

801077d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801077d0:	f3 0f 1e fb          	endbr32 
801077d4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077d5:	31 c9                	xor    %ecx,%ecx
{
801077d7:	89 e5                	mov    %esp,%ebp
801077d9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801077dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801077df:	8b 45 08             	mov    0x8(%ebp),%eax
801077e2:	e8 99 f8 ff ff       	call   80107080 <walkpgdir>
  if(pte == 0)
801077e7:	85 c0                	test   %eax,%eax
801077e9:	74 05                	je     801077f0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801077eb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801077ee:	c9                   	leave  
801077ef:	c3                   	ret    
    panic("clearpteu");
801077f0:	83 ec 0c             	sub    $0xc,%esp
801077f3:	68 96 85 10 80       	push   $0x80108596
801077f8:	e8 93 8b ff ff       	call   80100390 <panic>
801077fd:	8d 76 00             	lea    0x0(%esi),%esi

80107800 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107800:	f3 0f 1e fb          	endbr32 
80107804:	55                   	push   %ebp
80107805:	89 e5                	mov    %esp,%ebp
80107807:	57                   	push   %edi
80107808:	56                   	push   %esi
80107809:	53                   	push   %ebx
8010780a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010780d:	e8 1e ff ff ff       	call   80107730 <setupkvm>
80107812:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107815:	85 c0                	test   %eax,%eax
80107817:	0f 84 9b 00 00 00    	je     801078b8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010781d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107820:	85 c9                	test   %ecx,%ecx
80107822:	0f 84 90 00 00 00    	je     801078b8 <copyuvm+0xb8>
80107828:	31 f6                	xor    %esi,%esi
8010782a:	eb 46                	jmp    80107872 <copyuvm+0x72>
8010782c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107830:	83 ec 04             	sub    $0x4,%esp
80107833:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107839:	68 00 10 00 00       	push   $0x1000
8010783e:	57                   	push   %edi
8010783f:	50                   	push   %eax
80107840:	e8 db d6 ff ff       	call   80104f20 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107845:	58                   	pop    %eax
80107846:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010784c:	5a                   	pop    %edx
8010784d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107850:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107855:	89 f2                	mov    %esi,%edx
80107857:	50                   	push   %eax
80107858:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010785b:	e8 a0 f8 ff ff       	call   80107100 <mappages>
80107860:	83 c4 10             	add    $0x10,%esp
80107863:	85 c0                	test   %eax,%eax
80107865:	78 61                	js     801078c8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107867:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010786d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107870:	76 46                	jbe    801078b8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107872:	8b 45 08             	mov    0x8(%ebp),%eax
80107875:	31 c9                	xor    %ecx,%ecx
80107877:	89 f2                	mov    %esi,%edx
80107879:	e8 02 f8 ff ff       	call   80107080 <walkpgdir>
8010787e:	85 c0                	test   %eax,%eax
80107880:	74 61                	je     801078e3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107882:	8b 00                	mov    (%eax),%eax
80107884:	a8 01                	test   $0x1,%al
80107886:	74 4e                	je     801078d6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107888:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010788a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010788f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107892:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107898:	e8 c3 ad ff ff       	call   80102660 <kalloc>
8010789d:	89 c3                	mov    %eax,%ebx
8010789f:	85 c0                	test   %eax,%eax
801078a1:	75 8d                	jne    80107830 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801078a3:	83 ec 0c             	sub    $0xc,%esp
801078a6:	ff 75 e0             	pushl  -0x20(%ebp)
801078a9:	e8 02 fe ff ff       	call   801076b0 <freevm>
  return 0;
801078ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801078b5:	83 c4 10             	add    $0x10,%esp
}
801078b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078be:	5b                   	pop    %ebx
801078bf:	5e                   	pop    %esi
801078c0:	5f                   	pop    %edi
801078c1:	5d                   	pop    %ebp
801078c2:	c3                   	ret    
801078c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078c7:	90                   	nop
      kfree(mem);
801078c8:	83 ec 0c             	sub    $0xc,%esp
801078cb:	53                   	push   %ebx
801078cc:	e8 cf ab ff ff       	call   801024a0 <kfree>
      goto bad;
801078d1:	83 c4 10             	add    $0x10,%esp
801078d4:	eb cd                	jmp    801078a3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801078d6:	83 ec 0c             	sub    $0xc,%esp
801078d9:	68 ba 85 10 80       	push   $0x801085ba
801078de:	e8 ad 8a ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801078e3:	83 ec 0c             	sub    $0xc,%esp
801078e6:	68 a0 85 10 80       	push   $0x801085a0
801078eb:	e8 a0 8a ff ff       	call   80100390 <panic>

801078f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801078f0:	f3 0f 1e fb          	endbr32 
801078f4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801078f5:	31 c9                	xor    %ecx,%ecx
{
801078f7:	89 e5                	mov    %esp,%ebp
801078f9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801078fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801078ff:	8b 45 08             	mov    0x8(%ebp),%eax
80107902:	e8 79 f7 ff ff       	call   80107080 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107907:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107909:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010790a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010790c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107911:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107914:	05 00 00 00 80       	add    $0x80000000,%eax
80107919:	83 fa 05             	cmp    $0x5,%edx
8010791c:	ba 00 00 00 00       	mov    $0x0,%edx
80107921:	0f 45 c2             	cmovne %edx,%eax
}
80107924:	c3                   	ret    
80107925:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010792c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107930 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107930:	f3 0f 1e fb          	endbr32 
80107934:	55                   	push   %ebp
80107935:	89 e5                	mov    %esp,%ebp
80107937:	57                   	push   %edi
80107938:	56                   	push   %esi
80107939:	53                   	push   %ebx
8010793a:	83 ec 0c             	sub    $0xc,%esp
8010793d:	8b 75 14             	mov    0x14(%ebp),%esi
80107940:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107943:	85 f6                	test   %esi,%esi
80107945:	75 3c                	jne    80107983 <copyout+0x53>
80107947:	eb 67                	jmp    801079b0 <copyout+0x80>
80107949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107950:	8b 55 0c             	mov    0xc(%ebp),%edx
80107953:	89 fb                	mov    %edi,%ebx
80107955:	29 d3                	sub    %edx,%ebx
80107957:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010795d:	39 f3                	cmp    %esi,%ebx
8010795f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107962:	29 fa                	sub    %edi,%edx
80107964:	83 ec 04             	sub    $0x4,%esp
80107967:	01 c2                	add    %eax,%edx
80107969:	53                   	push   %ebx
8010796a:	ff 75 10             	pushl  0x10(%ebp)
8010796d:	52                   	push   %edx
8010796e:	e8 ad d5 ff ff       	call   80104f20 <memmove>
    len -= n;
    buf += n;
80107973:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107976:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010797c:	83 c4 10             	add    $0x10,%esp
8010797f:	29 de                	sub    %ebx,%esi
80107981:	74 2d                	je     801079b0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107983:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107985:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107988:	89 55 0c             	mov    %edx,0xc(%ebp)
8010798b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107991:	57                   	push   %edi
80107992:	ff 75 08             	pushl  0x8(%ebp)
80107995:	e8 56 ff ff ff       	call   801078f0 <uva2ka>
    if(pa0 == 0)
8010799a:	83 c4 10             	add    $0x10,%esp
8010799d:	85 c0                	test   %eax,%eax
8010799f:	75 af                	jne    80107950 <copyout+0x20>
  }
  return 0;
}
801079a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079a9:	5b                   	pop    %ebx
801079aa:	5e                   	pop    %esi
801079ab:	5f                   	pop    %edi
801079ac:	5d                   	pop    %ebp
801079ad:	c3                   	ret    
801079ae:	66 90                	xchg   %ax,%ax
801079b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079b3:	31 c0                	xor    %eax,%eax
}
801079b5:	5b                   	pop    %ebx
801079b6:	5e                   	pop    %esi
801079b7:	5f                   	pop    %edi
801079b8:	5d                   	pop    %ebp
801079b9:	c3                   	ret    
