
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
80100050:	68 20 79 10 80       	push   $0x80107920
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 a1 4a 00 00       	call   80104b00 <initlock>
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
80100092:	68 27 79 10 80       	push   $0x80107927
80100097:	50                   	push   %eax
80100098:	e8 23 49 00 00       	call   801049c0 <initsleeplock>
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
801000e8:	e8 93 4b 00 00       	call   80104c80 <acquire>
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
80100162:	e8 d9 4b 00 00       	call   80104d40 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 48 00 00       	call   80104a00 <acquiresleep>
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
801001a3:	68 2e 79 10 80       	push   $0x8010792e
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
801001c2:	e8 d9 48 00 00       	call   80104aa0 <holdingsleep>
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
801001e0:	68 3f 79 10 80       	push   $0x8010793f
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
80100203:	e8 98 48 00 00       	call   80104aa0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 48 48 00 00       	call   80104a60 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 5c 4a 00 00       	call   80104c80 <acquire>
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
80100270:	e9 cb 4a 00 00       	jmp    80104d40 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 46 79 10 80       	push   $0x80107946
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
801002b1:	e8 ca 49 00 00       	call   80104c80 <acquire>
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
801002e5:	e8 36 42 00 00       	call   80104520 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 f1 38 00 00       	call   80103bf0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 2d 4a 00 00       	call   80104d40 <release>
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
80100365:	e8 d6 49 00 00       	call   80104d40 <release>
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
801003b6:	68 4d 79 10 80       	push   $0x8010794d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 ab 82 10 80 	movl   $0x801082ab,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 3f 47 00 00       	call   80104b20 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 61 79 10 80       	push   $0x80107961
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
8010042a:	e8 f1 60 00 00       	call   80106520 <uartputc>
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
80100515:	e8 06 60 00 00       	call   80106520 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 fa 5f 00 00       	call   80106520 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ee 5f 00 00       	call   80106520 <uartputc>
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
80100561:	e8 ca 48 00 00       	call   80104e30 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 15 48 00 00       	call   80104d90 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 65 79 10 80       	push   $0x80107965
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
801005c9:	0f b6 92 90 79 10 80 	movzbl -0x7fef8670(%edx),%edx
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
8010065f:	e8 1c 46 00 00       	call   80104c80 <acquire>
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
80100697:	e8 a4 46 00 00       	call   80104d40 <release>
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
8010077d:	bb 78 79 10 80       	mov    $0x80107978,%ebx
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
801007bd:	e8 be 44 00 00       	call   80104c80 <acquire>
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
80100828:	e8 13 45 00 00       	call   80104d40 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 7f 79 10 80       	push   $0x8010797f
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
80100877:	e8 04 44 00 00       	call   80104c80 <acquire>
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
801009cf:	e8 6c 43 00 00       	call   80104d40 <release>
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
801009ff:	e9 bc 3d 00 00       	jmp    801047c0 <procdump>
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
80100a20:	e8 cb 3c 00 00       	call   801046f0 <wakeup>
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
80100a3a:	68 88 79 10 80       	push   $0x80107988
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 b7 40 00 00       	call   80104b00 <initlock>

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
80100a90:	e8 5b 31 00 00       	call   80103bf0 <myproc>
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
80100b0c:	e8 7f 6b 00 00       	call   80107690 <setupkvm>
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
80100b73:	e8 38 69 00 00       	call   801074b0 <allocuvm>
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
80100ba9:	e8 32 68 00 00       	call   801073e0 <loaduvm>
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
80100beb:	e8 20 6a 00 00       	call   80107610 <freevm>
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
80100c32:	e8 79 68 00 00       	call   801074b0 <allocuvm>
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
80100c53:	e8 d8 6a 00 00       	call   80107730 <clearpteu>
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
80100ca3:	e8 e8 42 00 00       	call   80104f90 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 d5 42 00 00       	call   80104f90 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 c4 6b 00 00       	call   80107890 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 2a 69 00 00       	call   80107610 <freevm>
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
80100d33:	e8 58 6b 00 00       	call   80107890 <copyout>
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
80100d71:	e8 da 41 00 00       	call   80104f50 <safestrcpy>
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
80100d9d:	e8 ae 64 00 00       	call   80107250 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 66 68 00 00       	call   80107610 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 e7 1f 00 00       	call   80102da0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 a1 79 10 80       	push   $0x801079a1
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
80100dea:	68 ad 79 10 80       	push   $0x801079ad
80100def:	68 c0 0f 11 80       	push   $0x80110fc0
80100df4:	e8 07 3d 00 00       	call   80104b00 <initlock>
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
80100e15:	e8 66 3e 00 00       	call   80104c80 <acquire>
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
80100e41:	e8 fa 3e 00 00       	call   80104d40 <release>
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
80100e5a:	e8 e1 3e 00 00       	call   80104d40 <release>
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
80100e83:	e8 f8 3d 00 00       	call   80104c80 <acquire>
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
80100ea0:	e8 9b 3e 00 00       	call   80104d40 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 b4 79 10 80       	push   $0x801079b4
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
80100ed5:	e8 a6 3d 00 00       	call   80104c80 <acquire>
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
80100f10:	e8 2b 3e 00 00       	call   80104d40 <release>

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
80100f3e:	e9 fd 3d 00 00       	jmp    80104d40 <release>
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
80100f8c:	68 bc 79 10 80       	push   $0x801079bc
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
8010107a:	68 c6 79 10 80       	push   $0x801079c6
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
80101163:	68 cf 79 10 80       	push   $0x801079cf
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
80101199:	68 d5 79 10 80       	push   $0x801079d5
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
80101217:	68 df 79 10 80       	push   $0x801079df
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
801012d4:	68 f2 79 10 80       	push   $0x801079f2
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
80101315:	e8 76 3a 00 00       	call   80104d90 <memset>
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
8010135a:	e8 21 39 00 00       	call   80104c80 <acquire>
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
801013c7:	e8 74 39 00 00       	call   80104d40 <release>

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
801013f5:	e8 46 39 00 00       	call   80104d40 <release>
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
80101422:	68 08 7a 10 80       	push   $0x80107a08
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
801014eb:	68 18 7a 10 80       	push   $0x80107a18
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
80101525:	e8 06 39 00 00       	call   80104e30 <memmove>
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
80101550:	68 2b 7a 10 80       	push   $0x80107a2b
80101555:	68 e0 19 11 80       	push   $0x801119e0
8010155a:	e8 a1 35 00 00       	call   80104b00 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 32 7a 10 80       	push   $0x80107a32
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 44 34 00 00       	call   801049c0 <initsleeplock>
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
801015c1:	68 98 7a 10 80       	push   $0x80107a98
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
8010165e:	e8 2d 37 00 00       	call   80104d90 <memset>
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
80101693:	68 38 7a 10 80       	push   $0x80107a38
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
80101705:	e8 26 37 00 00       	call   80104e30 <memmove>
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
80101743:	e8 38 35 00 00       	call   80104c80 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101753:	e8 e8 35 00 00       	call   80104d40 <release>
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
80101786:	e8 75 32 00 00       	call   80104a00 <acquiresleep>
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
801017f8:	e8 33 36 00 00       	call   80104e30 <memmove>
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
8010181d:	68 50 7a 10 80       	push   $0x80107a50
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 4a 7a 10 80       	push   $0x80107a4a
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
80101857:	e8 44 32 00 00       	call   80104aa0 <holdingsleep>
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
80101873:	e9 e8 31 00 00       	jmp    80104a60 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 5f 7a 10 80       	push   $0x80107a5f
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
801018a4:	e8 57 31 00 00       	call   80104a00 <acquiresleep>
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
801018be:	e8 9d 31 00 00       	call   80104a60 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018ca:	e8 b1 33 00 00       	call   80104c80 <acquire>
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
801018e4:	e9 57 34 00 00       	jmp    80104d40 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 e0 19 11 80       	push   $0x801119e0
801018f8:	e8 83 33 00 00       	call   80104c80 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101907:	e8 34 34 00 00       	call   80104d40 <release>
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
80101b07:	e8 24 33 00 00       	call   80104e30 <memmove>
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
80101c03:	e8 28 32 00 00       	call   80104e30 <memmove>
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
80101ca2:	e8 f9 31 00 00       	call   80104ea0 <strncmp>
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
80101d05:	e8 96 31 00 00       	call   80104ea0 <strncmp>
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
80101d4a:	68 79 7a 10 80       	push   $0x80107a79
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 67 7a 10 80       	push   $0x80107a67
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
80101d8a:	e8 61 1e 00 00       	call   80103bf0 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 e0 19 11 80       	push   $0x801119e0
80101d9c:	e8 df 2e 00 00       	call   80104c80 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101dac:	e8 8f 2f 00 00       	call   80104d40 <release>
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
80101e17:	e8 14 30 00 00       	call   80104e30 <memmove>
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
80101ea3:	e8 88 2f 00 00       	call   80104e30 <memmove>
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
80101fd5:	e8 16 2f 00 00       	call   80104ef0 <strncpy>
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
80102013:	68 88 7a 10 80       	push   $0x80107a88
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 92 80 10 80       	push   $0x80108092
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
8010212b:	68 f4 7a 10 80       	push   $0x80107af4
80102130:	e8 5b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 eb 7a 10 80       	push   $0x80107aeb
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
8010215a:	68 06 7b 10 80       	push   $0x80107b06
8010215f:	68 80 b5 10 80       	push   $0x8010b580
80102164:	e8 97 29 00 00       	call   80104b00 <initlock>
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
801021f2:	e8 89 2a 00 00       	call   80104c80 <acquire>

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
8010224d:	e8 9e 24 00 00       	call   801046f0 <wakeup>

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
8010226b:	e8 d0 2a 00 00       	call   80104d40 <release>

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
80102292:	e8 09 28 00 00       	call   80104aa0 <holdingsleep>
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
801022cc:	e8 af 29 00 00       	call   80104c80 <acquire>

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
80102319:	e8 02 22 00 00       	call   80104520 <sleep>
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
80102336:	e9 05 2a 00 00       	jmp    80104d40 <release>
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
8010235a:	68 35 7b 10 80       	push   $0x80107b35
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 20 7b 10 80       	push   $0x80107b20
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	68 0a 7b 10 80       	push   $0x80107b0a
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
801023ce:	68 54 7b 10 80       	push   $0x80107b54
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
801024a6:	e8 e5 28 00 00       	call   80104d90 <memset>

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
801024e0:	e8 9b 27 00 00       	call   80104c80 <acquire>
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	eb ce                	jmp    801024b8 <kfree+0x48>
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801024f0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801024f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fa:	c9                   	leave  
    release(&kmem.lock);
801024fb:	e9 40 28 00 00       	jmp    80104d40 <release>
    panic("kfree");
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 86 7b 10 80       	push   $0x80107b86
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
8010256f:	68 8c 7b 10 80       	push   $0x80107b8c
80102574:	68 40 36 11 80       	push   $0x80113640
80102579:	e8 82 25 00 00       	call   80104b00 <initlock>
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
80102663:	e8 18 26 00 00       	call   80104c80 <acquire>
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
80102691:	e8 aa 26 00 00       	call   80104d40 <release>
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
801026df:	0f b6 8a c0 7c 10 80 	movzbl -0x7fef8340(%edx),%ecx
  shift ^= togglecode[data];
801026e6:	0f b6 82 c0 7b 10 80 	movzbl -0x7fef8440(%edx),%eax
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
801026ff:	8b 04 85 a0 7b 10 80 	mov    -0x7fef8460(,%eax,4),%eax
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
8010273a:	0f b6 8a c0 7c 10 80 	movzbl -0x7fef8340(%edx),%ecx
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
80102abf:	e8 1c 23 00 00       	call   80104de0 <memcmp>
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
80102bf4:	e8 37 22 00 00       	call   80104e30 <memmove>
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
80102c9e:	68 c0 7d 10 80       	push   $0x80107dc0
80102ca3:	68 80 36 11 80       	push   $0x80113680
80102ca8:	e8 53 1e 00 00       	call   80104b00 <initlock>
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
80102d3f:	e8 3c 1f 00 00       	call   80104c80 <acquire>
80102d44:	83 c4 10             	add    $0x10,%esp
80102d47:	eb 1c                	jmp    80102d65 <begin_op+0x35>
80102d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d50:	83 ec 08             	sub    $0x8,%esp
80102d53:	68 80 36 11 80       	push   $0x80113680
80102d58:	68 80 36 11 80       	push   $0x80113680
80102d5d:	e8 be 17 00 00       	call   80104520 <sleep>
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
80102d94:	e8 a7 1f 00 00       	call   80104d40 <release>
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
80102db2:	e8 c9 1e 00 00       	call   80104c80 <acquire>
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
80102df0:	e8 4b 1f 00 00       	call   80104d40 <release>
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
80102e0a:	e8 71 1e 00 00       	call   80104c80 <acquire>
    wakeup(&log);
80102e0f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102e16:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102e1d:	00 00 00 
    wakeup(&log);
80102e20:	e8 cb 18 00 00       	call   801046f0 <wakeup>
    release(&log.lock);
80102e25:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102e2c:	e8 0f 1f 00 00       	call   80104d40 <release>
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
80102e84:	e8 a7 1f 00 00       	call   80104e30 <memmove>
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
80102ed8:	e8 13 18 00 00       	call   801046f0 <wakeup>
  release(&log.lock);
80102edd:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102ee4:	e8 57 1e 00 00       	call   80104d40 <release>
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
80102ef7:	68 c4 7d 10 80       	push   $0x80107dc4
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
80102f52:	e8 29 1d 00 00       	call   80104c80 <acquire>
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
80102f95:	e9 a6 1d 00 00       	jmp    80104d40 <release>
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
80102fc1:	68 d3 7d 10 80       	push   $0x80107dd3
80102fc6:	e8 c5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fcb:	83 ec 0c             	sub    $0xc,%esp
80102fce:	68 e9 7d 10 80       	push   $0x80107de9
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
80102fe7:	e8 e4 0b 00 00       	call   80103bd0 <cpuid>
80102fec:	89 c3                	mov    %eax,%ebx
80102fee:	e8 dd 0b 00 00       	call   80103bd0 <cpuid>
80102ff3:	83 ec 04             	sub    $0x4,%esp
80102ff6:	53                   	push   %ebx
80102ff7:	50                   	push   %eax
80102ff8:	68 04 7e 10 80       	push   $0x80107e04
80102ffd:	e8 ae d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103002:	e8 09 31 00 00       	call   80106110 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103007:	e8 54 0b 00 00       	call   80103b60 <mycpu>
8010300c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010300e:	b8 01 00 00 00       	mov    $0x1,%eax
80103013:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010301a:	e8 f1 11 00 00       	call   80104210 <scheduler>
8010301f:	90                   	nop

80103020 <mpenter>:
{
80103020:	f3 0f 1e fb          	endbr32 
80103024:	55                   	push   %ebp
80103025:	89 e5                	mov    %esp,%ebp
80103027:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010302a:	e8 01 42 00 00       	call   80107230 <switchkvm>
  seginit();
8010302f:	e8 6c 41 00 00       	call   801071a0 <seginit>
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
8010306f:	e8 9c 46 00 00       	call   80107710 <kvmalloc>
  mpinit();        // detect other processors
80103074:	e8 87 01 00 00       	call   80103200 <mpinit>
  lapicinit();     // interrupt controller
80103079:	e8 22 f7 ff ff       	call   801027a0 <lapicinit>
  seginit();       // segment descriptors
8010307e:	e8 1d 41 00 00       	call   801071a0 <seginit>
  picinit();       // disable pic
80103083:	e8 58 03 00 00       	call   801033e0 <picinit>
  ioapicinit();    // another interrupt controller
80103088:	e8 f3 f2 ff ff       	call   80102380 <ioapicinit>
  consoleinit();   // console hardware
8010308d:	e8 9e d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103092:	e8 c9 33 00 00       	call   80106460 <uartinit>
  pinit();         // process table
80103097:	e8 a4 0a 00 00       	call   80103b40 <pinit>
  tvinit();        // trap vectors
8010309c:	e8 ef 2f 00 00       	call   80106090 <tvinit>
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
801030c2:	e8 69 1d 00 00       	call   80104e30 <memmove>

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
80103109:	e8 52 0a 00 00       	call   80103b60 <mycpu>
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
80103172:	e8 39 0b 00 00       	call   80103cb0 <userinit>
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
801031ae:	68 18 7e 10 80       	push   $0x80107e18
801031b3:	56                   	push   %esi
801031b4:	e8 27 1c 00 00       	call   80104de0 <memcmp>
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
8010326a:	68 1d 7e 10 80       	push   $0x80107e1d
8010326f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103273:	e8 68 1b 00 00       	call   80104de0 <memcmp>
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
801033c3:	68 22 7e 10 80       	push   $0x80107e22
801033c8:	e8 c3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033cd:	83 ec 0c             	sub    $0xc,%esp
801033d0:	68 3c 7e 10 80       	push   $0x80107e3c
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
80103477:	68 5b 7e 10 80       	push   $0x80107e5b
8010347c:	50                   	push   %eax
8010347d:	e8 7e 16 00 00       	call   80104b00 <initlock>
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
80103523:	e8 58 17 00 00       	call   80104c80 <acquire>
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
80103543:	e8 a8 11 00 00       	call   801046f0 <wakeup>
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
80103568:	e9 d3 17 00 00       	jmp    80104d40 <release>
8010356d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103579:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103580:	00 00 00 
    wakeup(&p->nwrite);
80103583:	50                   	push   %eax
80103584:	e8 67 11 00 00       	call   801046f0 <wakeup>
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	eb bd                	jmp    8010354b <pipeclose+0x3b>
8010358e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 a7 17 00 00       	call   80104d40 <release>
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
801035c1:	e8 ba 16 00 00       	call   80104c80 <acquire>
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
80103608:	e8 e3 05 00 00       	call   80103bf0 <myproc>
8010360d:	8b 48 24             	mov    0x24(%eax),%ecx
80103610:	85 c9                	test   %ecx,%ecx
80103612:	75 34                	jne    80103648 <pipewrite+0x98>
      wakeup(&p->nread);
80103614:	83 ec 0c             	sub    $0xc,%esp
80103617:	57                   	push   %edi
80103618:	e8 d3 10 00 00       	call   801046f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361d:	58                   	pop    %eax
8010361e:	5a                   	pop    %edx
8010361f:	53                   	push   %ebx
80103620:	56                   	push   %esi
80103621:	e8 fa 0e 00 00       	call   80104520 <sleep>
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
8010364c:	e8 ef 16 00 00       	call   80104d40 <release>
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
8010369a:	e8 51 10 00 00       	call   801046f0 <wakeup>
  release(&p->lock);
8010369f:	89 1c 24             	mov    %ebx,(%esp)
801036a2:	e8 99 16 00 00       	call   80104d40 <release>
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
801036ca:	e8 b1 15 00 00       	call   80104c80 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036cf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036de:	74 33                	je     80103713 <piperead+0x63>
801036e0:	eb 3b                	jmp    8010371d <piperead+0x6d>
801036e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036e8:	e8 03 05 00 00       	call   80103bf0 <myproc>
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
801036fd:	e8 1e 0e 00 00       	call   80104520 <sleep>
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
80103766:	e8 85 0f 00 00       	call   801046f0 <wakeup>
  release(&p->lock);
8010376b:	89 34 24             	mov    %esi,(%esp)
8010376e:	e8 cd 15 00 00       	call   80104d40 <release>
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
80103789:	e8 b2 15 00 00       	call   80104d40 <release>
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
801037a1:	89 c1                	mov    %eax,%ecx
  struct proc *p;
  int sleeping = 0;
  int awake = 0;
801037a3:	31 d2                	xor    %edx,%edx
{
801037a5:	89 e5                	mov    %esp,%ebp
801037a7:	57                   	push   %edi
801037a8:	56                   	push   %esi
  long long min_acc_sleeping = __LONG_LONG_MAX__;
801037a9:	be ff ff ff 7f       	mov    $0x7fffffff,%esi
{
801037ae:	53                   	push   %ebx
  long long min_acc_sleeping = __LONG_LONG_MAX__;
801037af:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
{
801037b4:	83 ec 24             	sub    $0x24,%esp
801037b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037ba:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
  int sleeping = 0;
801037bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037c6:	89 5d e8             	mov    %ebx,-0x18(%ebp)
801037c9:	eb 1a                	jmp    801037e5 <wakeup1+0x45>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
      sleeping++;
      if (p->accumulator < min_acc_sleeping){
          min_acc_sleeping = p->accumulator;
      }
    }
    else if (p->state == RUNNABLE || p->state == RUNNING){
801037d0:	83 ef 03             	sub    $0x3,%edi
      awake++;
801037d3:	83 ff 02             	cmp    $0x2,%edi
801037d6:	83 d2 00             	adc    $0x0,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037d9:	05 9c 00 00 00       	add    $0x9c,%eax
801037de:	3d 54 64 11 80       	cmp    $0x80116454,%eax
801037e3:	74 40                	je     80103825 <wakeup1+0x85>
    if(p->state == SLEEPING && p->chan == chan){
801037e5:	8b 78 0c             	mov    0xc(%eax),%edi
801037e8:	83 ff 02             	cmp    $0x2,%edi
801037eb:	75 e3                	jne    801037d0 <wakeup1+0x30>
801037ed:	39 48 20             	cmp    %ecx,0x20(%eax)
801037f0:	75 e7                	jne    801037d9 <wakeup1+0x39>
      if (p->accumulator < min_acc_sleeping){
801037f2:	8b b8 88 00 00 00    	mov    0x88(%eax),%edi
801037f8:	8b 5d e8             	mov    -0x18(%ebp),%ebx
      sleeping++;
801037fb:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
801037ff:	39 98 84 00 00 00    	cmp    %ebx,0x84(%eax)
80103805:	89 fb                	mov    %edi,%ebx
80103807:	19 f3                	sbb    %esi,%ebx
80103809:	8b 5d e8             	mov    -0x18(%ebp),%ebx
8010380c:	0f 4c 98 84 00 00 00 	cmovl  0x84(%eax),%ebx
80103813:	0f 4c f7             	cmovl  %edi,%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103816:	05 9c 00 00 00       	add    $0x9c,%eax
8010381b:	89 5d e8             	mov    %ebx,-0x18(%ebp)
8010381e:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103823:	75 c0                	jne    801037e5 <wakeup1+0x45>
80103825:	89 55 dc             	mov    %edx,-0x24(%ebp)
    }
  }
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103828:	bf 54 3d 11 80       	mov    $0x80113d54,%edi
8010382d:	89 75 d4             	mov    %esi,-0x2c(%ebp)
80103830:	eb 14                	jmp    80103846 <wakeup1+0xa6>
80103832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103838:	81 c7 9c 00 00 00    	add    $0x9c,%edi
8010383e:	81 ff 54 64 11 80    	cmp    $0x80116454,%edi
80103844:	74 46                	je     8010388c <wakeup1+0xec>
    if(p->state == SLEEPING && p->chan == chan){
80103846:	83 7f 0c 02          	cmpl   $0x2,0xc(%edi)
8010384a:	75 ec                	jne    80103838 <wakeup1+0x98>
8010384c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010384f:	39 47 20             	cmp    %eax,0x20(%edi)
80103852:	75 e4                	jne    80103838 <wakeup1+0x98>
      if (awake > 0){
80103854:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103857:	85 c0                	test   %eax,%eax
80103859:	75 3d                	jne    80103898 <wakeup1+0xf8>
        update_min_acc(p);
      }
      else if (sleeping == 1){
8010385b:	83 7d e0 01          	cmpl   $0x1,-0x20(%ebp)
8010385f:	0f 84 b6 00 00 00    	je     8010391b <wakeup1+0x17b>
        p->accumulator = 0;
      }
      else{
        p->accumulator = min_acc_sleeping;
80103865:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103868:	89 87 84 00 00 00    	mov    %eax,0x84(%edi)
8010386e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80103871:	89 87 88 00 00 00    	mov    %eax,0x88(%edi)
      }
      p->state = RUNNABLE;
80103877:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010387e:	81 c7 9c 00 00 00    	add    $0x9c,%edi
80103884:	81 ff 54 64 11 80    	cmp    $0x80116454,%edi
8010388a:	75 ba                	jne    80103846 <wakeup1+0xa6>
    }
}
8010388c:	83 c4 24             	add    $0x24,%esp
8010388f:	5b                   	pop    %ebx
80103890:	5e                   	pop    %esi
80103891:	5f                   	pop    %edi
80103892:	5d                   	pop    %ebp
80103893:	c3                   	ret    
80103894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int active_processes = 0;
80103898:	31 c9                	xor    %ecx,%ecx
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
8010389a:	89 7d d8             	mov    %edi,-0x28(%ebp)
  long long min_acc = __LONG_LONG_MAX__;
8010389d:	be ff ff ff ff       	mov    $0xffffffff,%esi
801038a2:	bb ff ff ff 7f       	mov    $0x7fffffff,%ebx
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
801038a7:	89 4d ec             	mov    %ecx,-0x14(%ebp)
801038aa:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801038af:	eb 13                	jmp    801038c4 <wakeup1+0x124>
801038b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038b8:	05 9c 00 00 00       	add    $0x9c,%eax
801038bd:	3d 54 64 11 80       	cmp    $0x80116454,%eax
801038c2:	74 33                	je     801038f7 <wakeup1+0x157>
    if ((proc->state == RUNNING || proc->state == RUNNABLE) && proc->accumulator < min_acc){
801038c4:	8b 48 0c             	mov    0xc(%eax),%ecx
801038c7:	8d 51 fd             	lea    -0x3(%ecx),%edx
801038ca:	83 fa 01             	cmp    $0x1,%edx
801038cd:	77 e9                	ja     801038b8 <wakeup1+0x118>
801038cf:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
801038d5:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
801038db:	39 f1                	cmp    %esi,%ecx
801038dd:	89 d7                	mov    %edx,%edi
801038df:	19 df                	sbb    %ebx,%edi
801038e1:	7d d5                	jge    801038b8 <wakeup1+0x118>
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
801038e3:	05 9c 00 00 00       	add    $0x9c,%eax
      active_processes++;
801038e8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801038ec:	89 ce                	mov    %ecx,%esi
801038ee:	89 d3                	mov    %edx,%ebx
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
801038f0:	3d 54 64 11 80       	cmp    $0x80116454,%eax
801038f5:	75 cd                	jne    801038c4 <wakeup1+0x124>
801038f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    min_acc = 0;
801038fa:	b9 00 00 00 00       	mov    $0x0,%ecx
801038ff:	8b 7d d8             	mov    -0x28(%ebp),%edi
80103902:	85 c0                	test   %eax,%eax
80103904:	0f 44 f1             	cmove  %ecx,%esi
80103907:	0f 44 d9             	cmove  %ecx,%ebx
  p->accumulator = min_acc;
8010390a:	89 b7 84 00 00 00    	mov    %esi,0x84(%edi)
80103910:	89 9f 88 00 00 00    	mov    %ebx,0x88(%edi)
}
80103916:	e9 5c ff ff ff       	jmp    80103877 <wakeup1+0xd7>
        p->accumulator = 0;
8010391b:	c7 87 84 00 00 00 00 	movl   $0x0,0x84(%edi)
80103922:	00 00 00 
80103925:	c7 87 88 00 00 00 00 	movl   $0x0,0x88(%edi)
8010392c:	00 00 00 
8010392f:	e9 43 ff ff ff       	jmp    80103877 <wakeup1+0xd7>
80103934:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010393b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010393f:	90                   	nop

80103940 <allocproc>:
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	57                   	push   %edi
80103944:	56                   	push   %esi
80103945:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103946:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
8010394b:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
8010394e:	68 20 3d 11 80       	push   $0x80113d20
80103953:	e8 28 13 00 00       	call   80104c80 <acquire>
80103958:	83 c4 10             	add    $0x10,%esp
8010395b:	eb 15                	jmp    80103972 <allocproc+0x32>
8010395d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103960:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80103966:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
8010396c:	0f 84 45 01 00 00    	je     80103ab7 <allocproc+0x177>
    if(p->state == UNUSED)
80103972:	8b 43 0c             	mov    0xc(%ebx),%eax
80103975:	85 c0                	test   %eax,%eax
80103977:	75 e7                	jne    80103960 <allocproc+0x20>
  p->pid = nextpid++;
80103979:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  release(&ptable.lock);
8010397e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103981:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103988:	89 43 10             	mov    %eax,0x10(%ebx)
8010398b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010398e:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
80103993:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103999:	e8 a2 13 00 00       	call   80104d40 <release>
  if((p->kstack = kalloc()) == 0){
8010399e:	e8 8d ec ff ff       	call   80102630 <kalloc>
801039a3:	83 c4 10             	add    $0x10,%esp
801039a6:	89 43 08             	mov    %eax,0x8(%ebx)
801039a9:	85 c0                	test   %eax,%eax
801039ab:	0f 84 22 01 00 00    	je     80103ad3 <allocproc+0x193>
  sp -= sizeof *p->tf;
801039b1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
801039b7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801039ba:	05 9c 0f 00 00       	add    $0xf9c,%eax
  long long min_acc = __LONG_LONG_MAX__;
801039bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  sp -= sizeof *p->tf;
801039c4:	89 53 18             	mov    %edx,0x18(%ebx)
  long long min_acc = __LONG_LONG_MAX__;
801039c7:	be ff ff ff 7f       	mov    $0x7fffffff,%esi
  *(uint*)sp = (uint)trapret;
801039cc:	c7 40 14 7a 60 10 80 	movl   $0x8010607a,0x14(%eax)
  p->context = (struct context*)sp;
801039d3:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039d6:	6a 14                	push   $0x14
801039d8:	6a 00                	push   $0x0
801039da:	50                   	push   %eax
801039db:	e8 b0 13 00 00       	call   80104d90 <memset>
  p->context->eip = (uint)forkret;
801039e0:	8b 43 1c             	mov    0x1c(%ebx),%eax
801039e3:	c7 40 10 f0 3a 10 80 	movl   $0x80103af0,0x10(%eax)
  acquire(&ptable.lock);
801039ea:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801039f1:	e8 8a 12 00 00       	call   80104c80 <acquire>
  int active_processes = 0;
801039f6:	31 d2                	xor    %edx,%edx
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
801039f8:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  acquire(&ptable.lock);
801039fb:	83 c4 10             	add    $0x10,%esp
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
801039fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103a01:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103a06:	eb 14                	jmp    80103a1c <allocproc+0xdc>
80103a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a0f:	90                   	nop
80103a10:	05 9c 00 00 00       	add    $0x9c,%eax
80103a15:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103a1a:	74 33                	je     80103a4f <allocproc+0x10f>
    if ((proc->state == RUNNING || proc->state == RUNNABLE) && proc->accumulator < min_acc){
80103a1c:	8b 48 0c             	mov    0xc(%eax),%ecx
80103a1f:	8d 51 fd             	lea    -0x3(%ecx),%edx
80103a22:	83 fa 01             	cmp    $0x1,%edx
80103a25:	77 e9                	ja     80103a10 <allocproc+0xd0>
80103a27:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80103a2d:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80103a33:	39 f9                	cmp    %edi,%ecx
80103a35:	89 d3                	mov    %edx,%ebx
80103a37:	19 f3                	sbb    %esi,%ebx
80103a39:	7d d5                	jge    80103a10 <allocproc+0xd0>
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80103a3b:	05 9c 00 00 00       	add    $0x9c,%eax
      active_processes++;
80103a40:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80103a44:	89 cf                	mov    %ecx,%edi
80103a46:	89 d6                	mov    %edx,%esi
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80103a48:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103a4d:	75 cd                	jne    80103a1c <allocproc+0xdc>
80103a4f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    min_acc = 0;
80103a52:	31 c0                	xor    %eax,%eax
80103a54:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80103a57:	85 c9                	test   %ecx,%ecx
80103a59:	0f 44 f8             	cmove  %eax,%edi
80103a5c:	0f 44 f0             	cmove  %eax,%esi
  release(&ptable.lock);
80103a5f:	83 ec 0c             	sub    $0xc,%esp
  p->accumulator = min_acc;
80103a62:	89 bb 84 00 00 00    	mov    %edi,0x84(%ebx)
80103a68:	89 b3 88 00 00 00    	mov    %esi,0x88(%ebx)
  release(&ptable.lock);
80103a6e:	68 20 3d 11 80       	push   $0x80113d20
80103a73:	e8 c8 12 00 00       	call   80104d40 <release>
  return p;
80103a78:	83 c4 10             	add    $0x10,%esp
}
80103a7b:	89 d8                	mov    %ebx,%eax
  p->cfs_decay_factor = 1;
80103a7d:	c7 83 8c 00 00 00 00 	movl   $0x3f800000,0x8c(%ebx)
80103a84:	00 80 3f 
  p->ps_priority = 5;
80103a87:	c7 83 80 00 00 00 05 	movl   $0x5,0x80(%ebx)
80103a8e:	00 00 00 
  p->rtime = 1;
80103a91:	c7 83 90 00 00 00 01 	movl   $0x1,0x90(%ebx)
80103a98:	00 00 00 
  p->retime = 1;
80103a9b:	c7 83 94 00 00 00 01 	movl   $0x1,0x94(%ebx)
80103aa2:	00 00 00 
  p ->stime = 1;
80103aa5:	c7 83 98 00 00 00 01 	movl   $0x1,0x98(%ebx)
80103aac:	00 00 00 
}
80103aaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ab2:	5b                   	pop    %ebx
80103ab3:	5e                   	pop    %esi
80103ab4:	5f                   	pop    %edi
80103ab5:	5d                   	pop    %ebp
80103ab6:	c3                   	ret    
  release(&ptable.lock);
80103ab7:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103aba:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103abc:	68 20 3d 11 80       	push   $0x80113d20
80103ac1:	e8 7a 12 00 00       	call   80104d40 <release>
  return 0;
80103ac6:	83 c4 10             	add    $0x10,%esp
}
80103ac9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103acc:	89 d8                	mov    %ebx,%eax
80103ace:	5b                   	pop    %ebx
80103acf:	5e                   	pop    %esi
80103ad0:	5f                   	pop    %edi
80103ad1:	5d                   	pop    %ebp
80103ad2:	c3                   	ret    
    p->state = UNUSED;
80103ad3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
}
80103ada:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80103add:	31 db                	xor    %ebx,%ebx
}
80103adf:	89 d8                	mov    %ebx,%eax
80103ae1:	5b                   	pop    %ebx
80103ae2:	5e                   	pop    %esi
80103ae3:	5f                   	pop    %edi
80103ae4:	5d                   	pop    %ebp
80103ae5:	c3                   	ret    
80103ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aed:	8d 76 00             	lea    0x0(%esi),%esi

80103af0 <forkret>:
{
80103af0:	f3 0f 1e fb          	endbr32 
80103af4:	55                   	push   %ebp
80103af5:	89 e5                	mov    %esp,%ebp
80103af7:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103afa:	68 20 3d 11 80       	push   $0x80113d20
80103aff:	e8 3c 12 00 00       	call   80104d40 <release>
  if (first) {
80103b04:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103b09:	83 c4 10             	add    $0x10,%esp
80103b0c:	85 c0                	test   %eax,%eax
80103b0e:	75 08                	jne    80103b18 <forkret+0x28>
}
80103b10:	c9                   	leave  
80103b11:	c3                   	ret    
80103b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103b18:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103b1f:	00 00 00 
    iinit(ROOTDEV);
80103b22:	83 ec 0c             	sub    $0xc,%esp
80103b25:	6a 01                	push   $0x1
80103b27:	e8 14 da ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
80103b2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103b33:	e8 58 f1 ff ff       	call   80102c90 <initlog>
}
80103b38:	83 c4 10             	add    $0x10,%esp
80103b3b:	c9                   	leave  
80103b3c:	c3                   	ret    
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi

80103b40 <pinit>:
{
80103b40:	f3 0f 1e fb          	endbr32 
80103b44:	55                   	push   %ebp
80103b45:	89 e5                	mov    %esp,%ebp
80103b47:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b4a:	68 60 7e 10 80       	push   $0x80107e60
80103b4f:	68 20 3d 11 80       	push   $0x80113d20
80103b54:	e8 a7 0f 00 00       	call   80104b00 <initlock>
}
80103b59:	83 c4 10             	add    $0x10,%esp
80103b5c:	c9                   	leave  
80103b5d:	c3                   	ret    
80103b5e:	66 90                	xchg   %ax,%ax

80103b60 <mycpu>:
{
80103b60:	f3 0f 1e fb          	endbr32 
80103b64:	55                   	push   %ebp
80103b65:	89 e5                	mov    %esp,%ebp
80103b67:	56                   	push   %esi
80103b68:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b69:	9c                   	pushf  
80103b6a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b6b:	f6 c4 02             	test   $0x2,%ah
80103b6e:	75 4a                	jne    80103bba <mycpu+0x5a>
  apicid = lapicid();
80103b70:	e8 2b ed ff ff       	call   801028a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b75:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
  apicid = lapicid();
80103b7b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103b7d:	85 f6                	test   %esi,%esi
80103b7f:	7e 2c                	jle    80103bad <mycpu+0x4d>
80103b81:	31 d2                	xor    %edx,%edx
80103b83:	eb 0a                	jmp    80103b8f <mycpu+0x2f>
80103b85:	8d 76 00             	lea    0x0(%esi),%esi
80103b88:	83 c2 01             	add    $0x1,%edx
80103b8b:	39 f2                	cmp    %esi,%edx
80103b8d:	74 1e                	je     80103bad <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103b8f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103b95:	0f b6 81 80 37 11 80 	movzbl -0x7feec880(%ecx),%eax
80103b9c:	39 d8                	cmp    %ebx,%eax
80103b9e:	75 e8                	jne    80103b88 <mycpu+0x28>
}
80103ba0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103ba3:	8d 81 80 37 11 80    	lea    -0x7feec880(%ecx),%eax
}
80103ba9:	5b                   	pop    %ebx
80103baa:	5e                   	pop    %esi
80103bab:	5d                   	pop    %ebp
80103bac:	c3                   	ret    
  panic("unknown apicid\n");
80103bad:	83 ec 0c             	sub    $0xc,%esp
80103bb0:	68 67 7e 10 80       	push   $0x80107e67
80103bb5:	e8 d6 c7 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103bba:	83 ec 0c             	sub    $0xc,%esp
80103bbd:	68 58 7f 10 80       	push   $0x80107f58
80103bc2:	e8 c9 c7 ff ff       	call   80100390 <panic>
80103bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bce:	66 90                	xchg   %ax,%ax

80103bd0 <cpuid>:
cpuid() {
80103bd0:	f3 0f 1e fb          	endbr32 
80103bd4:	55                   	push   %ebp
80103bd5:	89 e5                	mov    %esp,%ebp
80103bd7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103bda:	e8 81 ff ff ff       	call   80103b60 <mycpu>
}
80103bdf:	c9                   	leave  
  return mycpu()-cpus;
80103be0:	2d 80 37 11 80       	sub    $0x80113780,%eax
80103be5:	c1 f8 04             	sar    $0x4,%eax
80103be8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103bee:	c3                   	ret    
80103bef:	90                   	nop

80103bf0 <myproc>:
myproc(void) {
80103bf0:	f3 0f 1e fb          	endbr32 
80103bf4:	55                   	push   %ebp
80103bf5:	89 e5                	mov    %esp,%ebp
80103bf7:	53                   	push   %ebx
80103bf8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103bfb:	e8 80 0f 00 00       	call   80104b80 <pushcli>
  c = mycpu();
80103c00:	e8 5b ff ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80103c05:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c0b:	e8 c0 0f 00 00       	call   80104bd0 <popcli>
}
80103c10:	83 c4 04             	add    $0x4,%esp
80103c13:	89 d8                	mov    %ebx,%eax
80103c15:	5b                   	pop    %ebx
80103c16:	5d                   	pop    %ebp
80103c17:	c3                   	ret    
80103c18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c1f:	90                   	nop

80103c20 <update_min_acc>:
void update_min_acc(struct proc* p){
80103c20:	f3 0f 1e fb          	endbr32 
80103c24:	55                   	push   %ebp
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80103c25:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
void update_min_acc(struct proc* p){
80103c2a:	89 e5                	mov    %esp,%ebp
80103c2c:	57                   	push   %edi
  int active_processes = 0;
80103c2d:	31 ff                	xor    %edi,%edi
void update_min_acc(struct proc* p){
80103c2f:	56                   	push   %esi
  long long min_acc = __LONG_LONG_MAX__;
80103c30:	be ff ff ff ff       	mov    $0xffffffff,%esi
void update_min_acc(struct proc* p){
80103c35:	53                   	push   %ebx
  long long min_acc = __LONG_LONG_MAX__;
80103c36:	bb ff ff ff 7f       	mov    $0x7fffffff,%ebx
void update_min_acc(struct proc* p){
80103c3b:	83 ec 0c             	sub    $0xc,%esp
  long long min_acc = __LONG_LONG_MAX__;
80103c3e:	89 7d ec             	mov    %edi,-0x14(%ebp)
80103c41:	eb 11                	jmp    80103c54 <update_min_acc+0x34>
80103c43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c47:	90                   	nop
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80103c48:	05 9c 00 00 00       	add    $0x9c,%eax
80103c4d:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103c52:	74 33                	je     80103c87 <update_min_acc+0x67>
    if ((proc->state == RUNNING || proc->state == RUNNABLE) && proc->accumulator < min_acc){
80103c54:	8b 48 0c             	mov    0xc(%eax),%ecx
80103c57:	8d 51 fd             	lea    -0x3(%ecx),%edx
80103c5a:	83 fa 01             	cmp    $0x1,%edx
80103c5d:	77 e9                	ja     80103c48 <update_min_acc+0x28>
80103c5f:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80103c65:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80103c6b:	39 f1                	cmp    %esi,%ecx
80103c6d:	89 d7                	mov    %edx,%edi
80103c6f:	19 df                	sbb    %ebx,%edi
80103c71:	7d d5                	jge    80103c48 <update_min_acc+0x28>
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80103c73:	05 9c 00 00 00       	add    $0x9c,%eax
      active_processes++;
80103c78:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80103c7c:	89 ce                	mov    %ecx,%esi
80103c7e:	89 d3                	mov    %edx,%ebx
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80103c80:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103c85:	75 cd                	jne    80103c54 <update_min_acc+0x34>
80103c87:	8b 7d ec             	mov    -0x14(%ebp),%edi
    min_acc = 0;
80103c8a:	31 c0                	xor    %eax,%eax
80103c8c:	85 ff                	test   %edi,%edi
80103c8e:	0f 44 f0             	cmove  %eax,%esi
80103c91:	0f 44 d8             	cmove  %eax,%ebx
  p->accumulator = min_acc;
80103c94:	8b 45 08             	mov    0x8(%ebp),%eax
80103c97:	89 b0 84 00 00 00    	mov    %esi,0x84(%eax)
80103c9d:	89 98 88 00 00 00    	mov    %ebx,0x88(%eax)
}
80103ca3:	83 c4 0c             	add    $0xc,%esp
80103ca6:	5b                   	pop    %ebx
80103ca7:	5e                   	pop    %esi
80103ca8:	5f                   	pop    %edi
80103ca9:	5d                   	pop    %ebp
80103caa:	c3                   	ret    
80103cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103caf:	90                   	nop

80103cb0 <userinit>:
{
80103cb0:	f3 0f 1e fb          	endbr32 
80103cb4:	55                   	push   %ebp
80103cb5:	89 e5                	mov    %esp,%ebp
80103cb7:	53                   	push   %ebx
80103cb8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103cbb:	e8 80 fc ff ff       	call   80103940 <allocproc>
80103cc0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103cc2:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103cc7:	e8 c4 39 00 00       	call   80107690 <setupkvm>
80103ccc:	89 43 04             	mov    %eax,0x4(%ebx)
80103ccf:	85 c0                	test   %eax,%eax
80103cd1:	0f 84 bd 00 00 00    	je     80103d94 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103cd7:	83 ec 04             	sub    $0x4,%esp
80103cda:	68 2c 00 00 00       	push   $0x2c
80103cdf:	68 60 b4 10 80       	push   $0x8010b460
80103ce4:	50                   	push   %eax
80103ce5:	e8 76 36 00 00       	call   80107360 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103cea:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103ced:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103cf3:	6a 4c                	push   $0x4c
80103cf5:	6a 00                	push   $0x0
80103cf7:	ff 73 18             	pushl  0x18(%ebx)
80103cfa:	e8 91 10 00 00       	call   80104d90 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cff:	8b 43 18             	mov    0x18(%ebx),%eax
80103d02:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d07:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d0a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d0f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d13:	8b 43 18             	mov    0x18(%ebx),%eax
80103d16:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103d1a:	8b 43 18             	mov    0x18(%ebx),%eax
80103d1d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d21:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d25:	8b 43 18             	mov    0x18(%ebx),%eax
80103d28:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d2c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d30:	8b 43 18             	mov    0x18(%ebx),%eax
80103d33:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d3a:	8b 43 18             	mov    0x18(%ebx),%eax
80103d3d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d44:	8b 43 18             	mov    0x18(%ebx),%eax
80103d47:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d4e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d51:	6a 10                	push   $0x10
80103d53:	68 90 7e 10 80       	push   $0x80107e90
80103d58:	50                   	push   %eax
80103d59:	e8 f2 11 00 00       	call   80104f50 <safestrcpy>
  p->cwd = namei("/");
80103d5e:	c7 04 24 99 7e 10 80 	movl   $0x80107e99,(%esp)
80103d65:	e8 c6 e2 ff ff       	call   80102030 <namei>
80103d6a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103d6d:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d74:	e8 07 0f 00 00       	call   80104c80 <acquire>
  p->state = RUNNABLE;
80103d79:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103d80:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d87:	e8 b4 0f 00 00       	call   80104d40 <release>
}
80103d8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d8f:	83 c4 10             	add    $0x10,%esp
80103d92:	c9                   	leave  
80103d93:	c3                   	ret    
    panic("userinit: out of memory?");
80103d94:	83 ec 0c             	sub    $0xc,%esp
80103d97:	68 77 7e 10 80       	push   $0x80107e77
80103d9c:	e8 ef c5 ff ff       	call   80100390 <panic>
80103da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103daf:	90                   	nop

80103db0 <growproc>:
{
80103db0:	f3 0f 1e fb          	endbr32 
80103db4:	55                   	push   %ebp
80103db5:	89 e5                	mov    %esp,%ebp
80103db7:	56                   	push   %esi
80103db8:	53                   	push   %ebx
80103db9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103dbc:	e8 bf 0d 00 00       	call   80104b80 <pushcli>
  c = mycpu();
80103dc1:	e8 9a fd ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80103dc6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dcc:	e8 ff 0d 00 00       	call   80104bd0 <popcli>
  sz = curproc->sz;
80103dd1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103dd3:	85 f6                	test   %esi,%esi
80103dd5:	7f 19                	jg     80103df0 <growproc+0x40>
  } else if(n < 0){
80103dd7:	75 37                	jne    80103e10 <growproc+0x60>
  switchuvm(curproc);
80103dd9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ddc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103dde:	53                   	push   %ebx
80103ddf:	e8 6c 34 00 00       	call   80107250 <switchuvm>
  return 0;
80103de4:	83 c4 10             	add    $0x10,%esp
80103de7:	31 c0                	xor    %eax,%eax
}
80103de9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dec:	5b                   	pop    %ebx
80103ded:	5e                   	pop    %esi
80103dee:	5d                   	pop    %ebp
80103def:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103df0:	83 ec 04             	sub    $0x4,%esp
80103df3:	01 c6                	add    %eax,%esi
80103df5:	56                   	push   %esi
80103df6:	50                   	push   %eax
80103df7:	ff 73 04             	pushl  0x4(%ebx)
80103dfa:	e8 b1 36 00 00       	call   801074b0 <allocuvm>
80103dff:	83 c4 10             	add    $0x10,%esp
80103e02:	85 c0                	test   %eax,%eax
80103e04:	75 d3                	jne    80103dd9 <growproc+0x29>
      return -1;
80103e06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e0b:	eb dc                	jmp    80103de9 <growproc+0x39>
80103e0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e10:	83 ec 04             	sub    $0x4,%esp
80103e13:	01 c6                	add    %eax,%esi
80103e15:	56                   	push   %esi
80103e16:	50                   	push   %eax
80103e17:	ff 73 04             	pushl  0x4(%ebx)
80103e1a:	e8 c1 37 00 00       	call   801075e0 <deallocuvm>
80103e1f:	83 c4 10             	add    $0x10,%esp
80103e22:	85 c0                	test   %eax,%eax
80103e24:	75 b3                	jne    80103dd9 <growproc+0x29>
80103e26:	eb de                	jmp    80103e06 <growproc+0x56>
80103e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e2f:	90                   	nop

80103e30 <fork>:
{
80103e30:	f3 0f 1e fb          	endbr32 
80103e34:	55                   	push   %ebp
80103e35:	89 e5                	mov    %esp,%ebp
80103e37:	57                   	push   %edi
80103e38:	56                   	push   %esi
80103e39:	53                   	push   %ebx
80103e3a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103e3d:	e8 3e 0d 00 00       	call   80104b80 <pushcli>
  c = mycpu();
80103e42:	e8 19 fd ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80103e47:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e4d:	e8 7e 0d 00 00       	call   80104bd0 <popcli>
  if((np = allocproc()) == 0){
80103e52:	e8 e9 fa ff ff       	call   80103940 <allocproc>
80103e57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e5a:	85 c0                	test   %eax,%eax
80103e5c:	0f 84 c7 00 00 00    	je     80103f29 <fork+0xf9>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103e62:	83 ec 08             	sub    $0x8,%esp
80103e65:	ff 33                	pushl  (%ebx)
80103e67:	89 c7                	mov    %eax,%edi
80103e69:	ff 73 04             	pushl  0x4(%ebx)
80103e6c:	e8 ef 38 00 00       	call   80107760 <copyuvm>
80103e71:	83 c4 10             	add    $0x10,%esp
80103e74:	89 47 04             	mov    %eax,0x4(%edi)
80103e77:	85 c0                	test   %eax,%eax
80103e79:	0f 84 b1 00 00 00    	je     80103f30 <fork+0x100>
  np->sz = curproc->sz;
80103e7f:	8b 03                	mov    (%ebx),%eax
80103e81:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e84:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103e86:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103e89:	89 c8                	mov    %ecx,%eax
80103e8b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103e8e:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e93:	8b 73 18             	mov    0x18(%ebx),%esi
80103e96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e98:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e9a:	8b 40 18             	mov    0x18(%eax),%eax
80103e9d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103ea8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103eac:	85 c0                	test   %eax,%eax
80103eae:	74 13                	je     80103ec3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103eb0:	83 ec 0c             	sub    $0xc,%esp
80103eb3:	50                   	push   %eax
80103eb4:	e8 b7 cf ff ff       	call   80100e70 <filedup>
80103eb9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ebc:	83 c4 10             	add    $0x10,%esp
80103ebf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103ec3:	83 c6 01             	add    $0x1,%esi
80103ec6:	83 fe 10             	cmp    $0x10,%esi
80103ec9:	75 dd                	jne    80103ea8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103ecb:	83 ec 0c             	sub    $0xc,%esp
80103ece:	ff 73 68             	pushl  0x68(%ebx)
80103ed1:	e8 5a d8 ff ff       	call   80101730 <idup>
80103ed6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ed9:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103edc:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103edf:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ee2:	6a 10                	push   $0x10
80103ee4:	50                   	push   %eax
80103ee5:	8d 47 6c             	lea    0x6c(%edi),%eax
80103ee8:	50                   	push   %eax
80103ee9:	e8 62 10 00 00       	call   80104f50 <safestrcpy>
  np->cfs_decay_factor = curproc->cfs_decay_factor;
80103eee:	d9 83 8c 00 00 00    	flds   0x8c(%ebx)
  pid = np->pid;
80103ef4:	8b 5f 10             	mov    0x10(%edi),%ebx
  np->cfs_decay_factor = curproc->cfs_decay_factor;
80103ef7:	d9 9f 8c 00 00 00    	fstps  0x8c(%edi)
  acquire(&ptable.lock);
80103efd:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f04:	e8 77 0d 00 00       	call   80104c80 <acquire>
  np->state = RUNNABLE;
80103f09:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103f10:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f17:	e8 24 0e 00 00       	call   80104d40 <release>
  return pid;
80103f1c:	83 c4 10             	add    $0x10,%esp
}
80103f1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f22:	89 d8                	mov    %ebx,%eax
80103f24:	5b                   	pop    %ebx
80103f25:	5e                   	pop    %esi
80103f26:	5f                   	pop    %edi
80103f27:	5d                   	pop    %ebp
80103f28:	c3                   	ret    
    return -1;
80103f29:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f2e:	eb ef                	jmp    80103f1f <fork+0xef>
    kfree(np->kstack);
80103f30:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103f33:	83 ec 0c             	sub    $0xc,%esp
80103f36:	ff 73 08             	pushl  0x8(%ebx)
80103f39:	e8 32 e5 ff ff       	call   80102470 <kfree>
    np->kstack = 0;
80103f3e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103f45:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103f48:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103f4f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f54:	eb c9                	jmp    80103f1f <fork+0xef>
80103f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f5d:	8d 76 00             	lea    0x0(%esi),%esi

80103f60 <priority_scheduler>:
{
80103f60:	f3 0f 1e fb          	endbr32 
80103f64:	55                   	push   %ebp
80103f65:	89 e5                	mov    %esp,%ebp
80103f67:	57                   	push   %edi
80103f68:	56                   	push   %esi
80103f69:	53                   	push   %ebx
80103f6a:	83 ec 1c             	sub    $0x1c,%esp
    swtch(&(c->scheduler), min_acc_proc->context);
80103f6d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f70:	83 c0 04             	add    $0x4,%eax
80103f73:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f7d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103f80:	fb                   	sti    
    acquire(&ptable.lock);
80103f81:	83 ec 0c             	sub    $0xc,%esp
    struct proc* min_acc_proc = null;
80103f84:	31 ff                	xor    %edi,%edi
    acquire(&ptable.lock);
80103f86:	68 20 3d 11 80       	push   $0x80113d20
80103f8b:	e8 f0 0c 00 00       	call   80104c80 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f90:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    acquire(&ptable.lock);
80103f93:	83 c4 10             	add    $0x10,%esp
    long long min_acc = __LONG_LONG_MAX__;
80103f96:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80103f9b:	ba ff ff ff 7f       	mov    $0x7fffffff,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa0:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103fa5:	8d 76 00             	lea    0x0(%esi),%esi
      if (p->state != RUNNABLE)
80103fa8:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103fac:	75 21                	jne    80103fcf <priority_scheduler+0x6f>
      if (p->accumulator < min_acc){
80103fae:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
80103fb4:	8b 98 88 00 00 00    	mov    0x88(%eax),%ebx
80103fba:	39 ce                	cmp    %ecx,%esi
80103fbc:	89 df                	mov    %ebx,%edi
80103fbe:	19 d7                	sbb    %edx,%edi
80103fc0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103fc3:	0f 4c ce             	cmovl  %esi,%ecx
80103fc6:	0f 4c d3             	cmovl  %ebx,%edx
80103fc9:	0f 4c f8             	cmovl  %eax,%edi
80103fcc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fcf:	05 9c 00 00 00       	add    $0x9c,%eax
80103fd4:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80103fd9:	75 cd                	jne    80103fa8 <priority_scheduler+0x48>
80103fdb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    if (min_acc_proc == null){
80103fde:	85 ff                	test   %edi,%edi
80103fe0:	74 3b                	je     8010401d <priority_scheduler+0xbd>
    c->proc = min_acc_proc;
80103fe2:	8b 45 08             	mov    0x8(%ebp),%eax
    switchuvm(min_acc_proc);
80103fe5:	83 ec 0c             	sub    $0xc,%esp
    c->proc = min_acc_proc;
80103fe8:	89 b8 ac 00 00 00    	mov    %edi,0xac(%eax)
    switchuvm(min_acc_proc);
80103fee:	57                   	push   %edi
80103fef:	e8 5c 32 00 00       	call   80107250 <switchuvm>
    min_acc_proc->state = RUNNING;
80103ff4:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
    swtch(&(c->scheduler), min_acc_proc->context);
80103ffb:	58                   	pop    %eax
80103ffc:	5a                   	pop    %edx
80103ffd:	ff 77 1c             	pushl  0x1c(%edi)
80104000:	ff 75 e0             	pushl  -0x20(%ebp)
80104003:	e8 ab 0f 00 00       	call   80104fb3 <swtch>
    switchkvm();
80104008:	e8 23 32 00 00       	call   80107230 <switchkvm>
    c->proc = 0;
8010400d:	8b 45 08             	mov    0x8(%ebp),%eax
80104010:	83 c4 10             	add    $0x10,%esp
80104013:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010401a:	00 00 00 
    release(&ptable.lock);
8010401d:	83 ec 0c             	sub    $0xc,%esp
80104020:	68 20 3d 11 80       	push   $0x80113d20
80104025:	e8 16 0d 00 00       	call   80104d40 <release>
    if (sched_type != PRIORITY_SCHEDULER){
8010402a:	83 c4 10             	add    $0x10,%esp
8010402d:	83 3d 18 0f 11 80 01 	cmpl   $0x1,0x80110f18
80104034:	0f 84 46 ff ff ff    	je     80103f80 <priority_scheduler+0x20>
}
8010403a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010403d:	5b                   	pop    %ebx
8010403e:	5e                   	pop    %esi
8010403f:	5f                   	pop    %edi
80104040:	5d                   	pop    %ebp
80104041:	c3                   	ret    
80104042:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104050 <fair_scheduler>:
{
80104050:	f3 0f 1e fb          	endbr32 
80104054:	55                   	push   %ebp
80104055:	89 e5                	mov    %esp,%ebp
80104057:	57                   	push   %edi
80104058:	56                   	push   %esi
80104059:	53                   	push   %ebx
8010405a:	83 ec 1c             	sub    $0x1c,%esp
8010405d:	8b 5d 08             	mov    0x8(%ebp),%ebx
    swtch(&(c->scheduler), min_ratio_proc->context);
80104060:	8d 73 04             	lea    0x4(%ebx),%esi
80104063:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104067:	90                   	nop
80104068:	fb                   	sti    
    acquire(&ptable.lock);
80104069:	83 ec 0c             	sub    $0xc,%esp
    struct proc* min_ratio_proc = null;
8010406c:	31 ff                	xor    %edi,%edi
    acquire(&ptable.lock);
8010406e:	68 20 3d 11 80       	push   $0x80113d20
80104073:	e8 08 0c 00 00       	call   80104c80 <acquire>
    float min_ratio = __LONG_LONG_MAX__;
80104078:	d9 05 a4 7f 10 80    	flds   0x80107fa4
    acquire(&ptable.lock);
8010407e:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104081:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408d:	8d 76 00             	lea    0x0(%esi),%esi
      if (p->state != RUNNABLE)
80104090:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104094:	75 3c                	jne    801040d2 <fair_scheduler+0x82>
      float ratio = ((p->rtime) * (p->cfs_decay_factor)) / (p->rtime + p->retime + p->stime);
80104096:	db 80 90 00 00 00    	fildl  0x90(%eax)
8010409c:	d9 80 8c 00 00 00    	flds   0x8c(%eax)
801040a2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
801040a8:	03 90 94 00 00 00    	add    0x94(%eax),%edx
801040ae:	03 90 98 00 00 00    	add    0x98(%eax),%edx
801040b4:	de c9                	fmulp  %st,%st(1)
801040b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801040b9:	db 45 e4             	fildl  -0x1c(%ebp)
801040bc:	de f9                	fdivrp %st,%st(1)
801040be:	d9 c9                	fxch   %st(1)
      if (ratio < min_ratio){
801040c0:	db f1                	fcomi  %st(1),%st
801040c2:	76 0c                	jbe    801040d0 <fair_scheduler+0x80>
801040c4:	dd d8                	fstp   %st(0)
801040c6:	89 c7                	mov    %eax,%edi
801040c8:	eb 08                	jmp    801040d2 <fair_scheduler+0x82>
801040ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801040d0:	dd d9                	fstp   %st(1)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040d2:	05 9c 00 00 00       	add    $0x9c,%eax
801040d7:	3d 54 64 11 80       	cmp    $0x80116454,%eax
801040dc:	75 b2                	jne    80104090 <fair_scheduler+0x40>
801040de:	dd d8                	fstp   %st(0)
    if (min_ratio_proc == null){
801040e0:	85 ff                	test   %edi,%edi
801040e2:	74 33                	je     80104117 <fair_scheduler+0xc7>
    switchuvm(min_ratio_proc);
801040e4:	83 ec 0c             	sub    $0xc,%esp
    c->proc = min_ratio_proc;
801040e7:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
    switchuvm(min_ratio_proc);
801040ed:	57                   	push   %edi
801040ee:	e8 5d 31 00 00       	call   80107250 <switchuvm>
    min_ratio_proc->state = RUNNING;
801040f3:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
    swtch(&(c->scheduler), min_ratio_proc->context);
801040fa:	58                   	pop    %eax
801040fb:	5a                   	pop    %edx
801040fc:	ff 77 1c             	pushl  0x1c(%edi)
801040ff:	56                   	push   %esi
80104100:	e8 ae 0e 00 00       	call   80104fb3 <swtch>
    switchkvm();
80104105:	e8 26 31 00 00       	call   80107230 <switchkvm>
    c->proc = 0;
8010410a:	83 c4 10             	add    $0x10,%esp
8010410d:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80104114:	00 00 00 
    release(&ptable.lock);
80104117:	83 ec 0c             	sub    $0xc,%esp
8010411a:	68 20 3d 11 80       	push   $0x80113d20
8010411f:	e8 1c 0c 00 00       	call   80104d40 <release>
    if (sched_type != COMPLETELY_FAIR_SCHEDULER){
80104124:	83 c4 10             	add    $0x10,%esp
80104127:	83 3d 18 0f 11 80 02 	cmpl   $0x2,0x80110f18
8010412e:	0f 84 34 ff ff ff    	je     80104068 <fair_scheduler+0x18>
}
80104134:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104137:	5b                   	pop    %ebx
80104138:	5e                   	pop    %esi
80104139:	5f                   	pop    %edi
8010413a:	5d                   	pop    %ebp
8010413b:	c3                   	ret    
8010413c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104140 <default_scheduler>:
{
80104140:	f3 0f 1e fb          	endbr32 
80104144:	55                   	push   %ebp
80104145:	89 e5                	mov    %esp,%ebp
80104147:	57                   	push   %edi
80104148:	56                   	push   %esi
80104149:	53                   	push   %ebx
8010414a:	83 ec 0c             	sub    $0xc,%esp
8010414d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104150:	8d 73 04             	lea    0x4(%ebx),%esi
80104153:	fb                   	sti    
    acquire(&ptable.lock);
80104154:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104157:	bf 54 3d 11 80       	mov    $0x80113d54,%edi
    acquire(&ptable.lock);
8010415c:	68 20 3d 11 80       	push   $0x80113d20
80104161:	e8 1a 0b 00 00       	call   80104c80 <acquire>
80104166:	83 c4 10             	add    $0x10,%esp
80104169:	eb 13                	jmp    8010417e <default_scheduler+0x3e>
8010416b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010416f:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104170:	81 c7 9c 00 00 00    	add    $0x9c,%edi
80104176:	81 ff 54 64 11 80    	cmp    $0x80116454,%edi
8010417c:	74 72                	je     801041f0 <default_scheduler+0xb0>
      if(p->state != RUNNABLE)
8010417e:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80104182:	75 ec                	jne    80104170 <default_scheduler+0x30>
      switchuvm(p);
80104184:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104187:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
8010418d:	57                   	push   %edi
8010418e:	e8 bd 30 00 00       	call   80107250 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104193:	58                   	pop    %eax
80104194:	5a                   	pop    %edx
80104195:	ff 77 1c             	pushl  0x1c(%edi)
80104198:	56                   	push   %esi
      p->state = RUNNING;
80104199:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      swtch(&(c->scheduler), p->context);
801041a0:	e8 0e 0e 00 00       	call   80104fb3 <swtch>
      switchkvm();
801041a5:	e8 86 30 00 00       	call   80107230 <switchkvm>
      p->accumulator += p->ps_priority;
801041aa:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
      if (sched_type != DEFAULT_SCHEDULER){
801041b0:	8b 0d 18 0f 11 80    	mov    0x80110f18,%ecx
      p->accumulator += p->ps_priority;
801041b6:	99                   	cltd   
801041b7:	01 87 84 00 00 00    	add    %eax,0x84(%edi)
801041bd:	11 97 88 00 00 00    	adc    %edx,0x88(%edi)
      if (sched_type != DEFAULT_SCHEDULER){
801041c3:	83 c4 10             	add    $0x10,%esp
      c->proc = 0;
801041c6:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801041cd:	00 00 00 
      if (sched_type != DEFAULT_SCHEDULER){
801041d0:	85 c9                	test   %ecx,%ecx
801041d2:	74 9c                	je     80104170 <default_scheduler+0x30>
        release(&ptable.lock);
801041d4:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
801041db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041de:	5b                   	pop    %ebx
801041df:	5e                   	pop    %esi
801041e0:	5f                   	pop    %edi
801041e1:	5d                   	pop    %ebp
        release(&ptable.lock);
801041e2:	e9 59 0b 00 00       	jmp    80104d40 <release>
801041e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ee:	66 90                	xchg   %ax,%ax
    release(&ptable.lock);
801041f0:	83 ec 0c             	sub    $0xc,%esp
801041f3:	68 20 3d 11 80       	push   $0x80113d20
801041f8:	e8 43 0b 00 00       	call   80104d40 <release>
    sti();
801041fd:	83 c4 10             	add    $0x10,%esp
80104200:	e9 4e ff ff ff       	jmp    80104153 <default_scheduler+0x13>
80104205:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104210 <scheduler>:
{
80104210:	f3 0f 1e fb          	endbr32 
80104214:	55                   	push   %ebp
80104215:	89 e5                	mov    %esp,%ebp
80104217:	53                   	push   %ebx
80104218:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c = mycpu();
8010421b:	e8 40 f9 ff ff       	call   80103b60 <mycpu>
  c->proc = 0;
80104220:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104227:	00 00 00 
  struct cpu *c = mycpu();
8010422a:	89 c3                	mov    %eax,%ebx
    switch (sched_type){
8010422c:	a1 18 0f 11 80       	mov    0x80110f18,%eax
80104231:	83 f8 01             	cmp    $0x1,%eax
80104234:	74 1a                	je     80104250 <scheduler+0x40>
80104236:	83 f8 02             	cmp    $0x2,%eax
80104239:	74 35                	je     80104270 <scheduler+0x60>
8010423b:	85 c0                	test   %eax,%eax
8010423d:	74 21                	je     80104260 <scheduler+0x50>
      panic("bad scheduler type");
8010423f:	83 ec 0c             	sub    $0xc,%esp
80104242:	68 9b 7e 10 80       	push   $0x80107e9b
80104247:	e8 44 c1 ff ff       	call   80100390 <panic>
8010424c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      priority_scheduler(c);
80104250:	83 ec 0c             	sub    $0xc,%esp
80104253:	53                   	push   %ebx
80104254:	e8 07 fd ff ff       	call   80103f60 <priority_scheduler>
      break;
80104259:	83 c4 10             	add    $0x10,%esp
8010425c:	eb ce                	jmp    8010422c <scheduler+0x1c>
8010425e:	66 90                	xchg   %ax,%ax
      default_scheduler(c);
80104260:	83 ec 0c             	sub    $0xc,%esp
80104263:	53                   	push   %ebx
80104264:	e8 d7 fe ff ff       	call   80104140 <default_scheduler>
      break;
80104269:	83 c4 10             	add    $0x10,%esp
8010426c:	eb be                	jmp    8010422c <scheduler+0x1c>
8010426e:	66 90                	xchg   %ax,%ax
      fair_scheduler(c);
80104270:	83 ec 0c             	sub    $0xc,%esp
80104273:	53                   	push   %ebx
80104274:	e8 d7 fd ff ff       	call   80104050 <fair_scheduler>
      break;
80104279:	83 c4 10             	add    $0x10,%esp
8010427c:	eb ae                	jmp    8010422c <scheduler+0x1c>
8010427e:	66 90                	xchg   %ax,%ax

80104280 <sched>:
{
80104280:	f3 0f 1e fb          	endbr32 
80104284:	55                   	push   %ebp
80104285:	89 e5                	mov    %esp,%ebp
80104287:	56                   	push   %esi
80104288:	53                   	push   %ebx
  pushcli();
80104289:	e8 f2 08 00 00       	call   80104b80 <pushcli>
  c = mycpu();
8010428e:	e8 cd f8 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80104293:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104299:	e8 32 09 00 00       	call   80104bd0 <popcli>
  if(!holding(&ptable.lock))
8010429e:	83 ec 0c             	sub    $0xc,%esp
801042a1:	68 20 3d 11 80       	push   $0x80113d20
801042a6:	e8 85 09 00 00       	call   80104c30 <holding>
801042ab:	83 c4 10             	add    $0x10,%esp
801042ae:	85 c0                	test   %eax,%eax
801042b0:	74 4f                	je     80104301 <sched+0x81>
  if(mycpu()->ncli != 1)
801042b2:	e8 a9 f8 ff ff       	call   80103b60 <mycpu>
801042b7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801042be:	75 68                	jne    80104328 <sched+0xa8>
  if(p->state == RUNNING)
801042c0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801042c4:	74 55                	je     8010431b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042c6:	9c                   	pushf  
801042c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801042c8:	f6 c4 02             	test   $0x2,%ah
801042cb:	75 41                	jne    8010430e <sched+0x8e>
  intena = mycpu()->intena;
801042cd:	e8 8e f8 ff ff       	call   80103b60 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801042d2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801042d5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801042db:	e8 80 f8 ff ff       	call   80103b60 <mycpu>
801042e0:	83 ec 08             	sub    $0x8,%esp
801042e3:	ff 70 04             	pushl  0x4(%eax)
801042e6:	53                   	push   %ebx
801042e7:	e8 c7 0c 00 00       	call   80104fb3 <swtch>
  mycpu()->intena = intena;
801042ec:	e8 6f f8 ff ff       	call   80103b60 <mycpu>
}
801042f1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801042f4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801042fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042fd:	5b                   	pop    %ebx
801042fe:	5e                   	pop    %esi
801042ff:	5d                   	pop    %ebp
80104300:	c3                   	ret    
    panic("sched ptable.lock");
80104301:	83 ec 0c             	sub    $0xc,%esp
80104304:	68 ae 7e 10 80       	push   $0x80107eae
80104309:	e8 82 c0 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010430e:	83 ec 0c             	sub    $0xc,%esp
80104311:	68 da 7e 10 80       	push   $0x80107eda
80104316:	e8 75 c0 ff ff       	call   80100390 <panic>
    panic("sched running");
8010431b:	83 ec 0c             	sub    $0xc,%esp
8010431e:	68 cc 7e 10 80       	push   $0x80107ecc
80104323:	e8 68 c0 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104328:	83 ec 0c             	sub    $0xc,%esp
8010432b:	68 c0 7e 10 80       	push   $0x80107ec0
80104330:	e8 5b c0 ff ff       	call   80100390 <panic>
80104335:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010433c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104340 <exit>:
{
80104340:	f3 0f 1e fb          	endbr32 
80104344:	55                   	push   %ebp
80104345:	89 e5                	mov    %esp,%ebp
80104347:	57                   	push   %edi
80104348:	56                   	push   %esi
80104349:	53                   	push   %ebx
8010434a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010434d:	e8 2e 08 00 00       	call   80104b80 <pushcli>
  c = mycpu();
80104352:	e8 09 f8 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80104357:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010435d:	e8 6e 08 00 00       	call   80104bd0 <popcli>
  if(curproc == initproc)
80104362:	8d 5e 28             	lea    0x28(%esi),%ebx
80104365:	8d 7e 68             	lea    0x68(%esi),%edi
80104368:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
8010436e:	0f 84 bd 00 00 00    	je     80104431 <exit+0xf1>
80104374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104378:	8b 03                	mov    (%ebx),%eax
8010437a:	85 c0                	test   %eax,%eax
8010437c:	74 12                	je     80104390 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010437e:	83 ec 0c             	sub    $0xc,%esp
80104381:	50                   	push   %eax
80104382:	e8 39 cb ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80104387:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010438d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104390:	83 c3 04             	add    $0x4,%ebx
80104393:	39 fb                	cmp    %edi,%ebx
80104395:	75 e1                	jne    80104378 <exit+0x38>
  begin_op();
80104397:	e8 94 e9 ff ff       	call   80102d30 <begin_op>
  iput(curproc->cwd);
8010439c:	83 ec 0c             	sub    $0xc,%esp
8010439f:	ff 76 68             	pushl  0x68(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043a2:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  iput(curproc->cwd);
801043a7:	e8 e4 d4 ff ff       	call   80101890 <iput>
  end_op();
801043ac:	e8 ef e9 ff ff       	call   80102da0 <end_op>
  curproc->cwd = 0;
801043b1:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801043b8:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801043bf:	e8 bc 08 00 00       	call   80104c80 <acquire>
  curproc->exit_status = status;
801043c4:	8b 45 08             	mov    0x8(%ebp),%eax
801043c7:	89 46 7c             	mov    %eax,0x7c(%esi)
  wakeup1(curproc->parent);
801043ca:	8b 46 14             	mov    0x14(%esi),%eax
801043cd:	e8 ce f3 ff ff       	call   801037a0 <wakeup1>
801043d2:	83 c4 10             	add    $0x10,%esp
801043d5:	eb 17                	jmp    801043ee <exit+0xae>
801043d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043de:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043e0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801043e6:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
801043ec:	74 2a                	je     80104418 <exit+0xd8>
    if(p->parent == curproc){
801043ee:	39 73 14             	cmp    %esi,0x14(%ebx)
801043f1:	75 ed                	jne    801043e0 <exit+0xa0>
      p->parent = initproc;
801043f3:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
      if(p->state == ZOMBIE)
801043f8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
      p->parent = initproc;
801043fc:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
801043ff:	75 df                	jne    801043e0 <exit+0xa0>
        wakeup1(initproc);
80104401:	e8 9a f3 ff ff       	call   801037a0 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104406:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
8010440c:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
80104412:	75 da                	jne    801043ee <exit+0xae>
80104414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  curproc->state = ZOMBIE;
80104418:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010441f:	e8 5c fe ff ff       	call   80104280 <sched>
  panic("zombie exit");
80104424:	83 ec 0c             	sub    $0xc,%esp
80104427:	68 fb 7e 10 80       	push   $0x80107efb
8010442c:	e8 5f bf ff ff       	call   80100390 <panic>
    panic("init exiting");
80104431:	83 ec 0c             	sub    $0xc,%esp
80104434:	68 ee 7e 10 80       	push   $0x80107eee
80104439:	e8 52 bf ff ff       	call   80100390 <panic>
8010443e:	66 90                	xchg   %ax,%ax

80104440 <update_ptable_stats>:
void update_ptable_stats(){
80104440:	f3 0f 1e fb          	endbr32 
80104444:	55                   	push   %ebp
80104445:	89 e5                	mov    %esp,%ebp
80104447:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
8010444a:	68 20 3d 11 80       	push   $0x80113d20
8010444f:	e8 2c 08 00 00       	call   80104c80 <acquire>
80104454:	83 c4 10             	add    $0x10,%esp
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80104457:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010445c:	eb 13                	jmp    80104471 <update_ptable_stats+0x31>
8010445e:	66 90                	xchg   %ax,%ax
    switch (proc->state)
80104460:	83 fa 02             	cmp    $0x2,%edx
80104463:	74 53                	je     801044b8 <update_ptable_stats+0x78>
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80104465:	05 9c 00 00 00       	add    $0x9c,%eax
8010446a:	3d 54 64 11 80       	cmp    $0x80116454,%eax
8010446f:	74 20                	je     80104491 <update_ptable_stats+0x51>
    switch (proc->state)
80104471:	8b 50 0c             	mov    0xc(%eax),%edx
80104474:	83 fa 03             	cmp    $0x3,%edx
80104477:	74 2f                	je     801044a8 <update_ptable_stats+0x68>
80104479:	83 fa 04             	cmp    $0x4,%edx
8010447c:	75 e2                	jne    80104460 <update_ptable_stats+0x20>
      proc->rtime++;
8010447e:	83 80 90 00 00 00 01 	addl   $0x1,0x90(%eax)
  for(struct proc* proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80104485:	05 9c 00 00 00       	add    $0x9c,%eax
8010448a:	3d 54 64 11 80       	cmp    $0x80116454,%eax
8010448f:	75 e0                	jne    80104471 <update_ptable_stats+0x31>
  release(&ptable.lock);
80104491:	83 ec 0c             	sub    $0xc,%esp
80104494:	68 20 3d 11 80       	push   $0x80113d20
80104499:	e8 a2 08 00 00       	call   80104d40 <release>
}
8010449e:	83 c4 10             	add    $0x10,%esp
801044a1:	c9                   	leave  
801044a2:	c3                   	ret    
801044a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044a7:	90                   	nop
      proc->retime++;
801044a8:	83 80 94 00 00 00 01 	addl   $0x1,0x94(%eax)
      break;
801044af:	eb b4                	jmp    80104465 <update_ptable_stats+0x25>
801044b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      proc->stime++;
801044b8:	83 80 98 00 00 00 01 	addl   $0x1,0x98(%eax)
      break;
801044bf:	eb a4                	jmp    80104465 <update_ptable_stats+0x25>
801044c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044cf:	90                   	nop

801044d0 <yield>:
{
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	53                   	push   %ebx
801044d8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801044db:	68 20 3d 11 80       	push   $0x80113d20
801044e0:	e8 9b 07 00 00       	call   80104c80 <acquire>
  pushcli();
801044e5:	e8 96 06 00 00       	call   80104b80 <pushcli>
  c = mycpu();
801044ea:	e8 71 f6 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
801044ef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044f5:	e8 d6 06 00 00       	call   80104bd0 <popcli>
  myproc()->state = RUNNABLE;
801044fa:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104501:	e8 7a fd ff ff       	call   80104280 <sched>
  release(&ptable.lock);
80104506:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010450d:	e8 2e 08 00 00       	call   80104d40 <release>
}
80104512:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104515:	83 c4 10             	add    $0x10,%esp
80104518:	c9                   	leave  
80104519:	c3                   	ret    
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104520 <sleep>:
{
80104520:	f3 0f 1e fb          	endbr32 
80104524:	55                   	push   %ebp
80104525:	89 e5                	mov    %esp,%ebp
80104527:	57                   	push   %edi
80104528:	56                   	push   %esi
80104529:	53                   	push   %ebx
8010452a:	83 ec 0c             	sub    $0xc,%esp
8010452d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104530:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104533:	e8 48 06 00 00       	call   80104b80 <pushcli>
  c = mycpu();
80104538:	e8 23 f6 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
8010453d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104543:	e8 88 06 00 00       	call   80104bd0 <popcli>
  if(p == 0)
80104548:	85 db                	test   %ebx,%ebx
8010454a:	0f 84 83 00 00 00    	je     801045d3 <sleep+0xb3>
  if(lk == 0)
80104550:	85 f6                	test   %esi,%esi
80104552:	74 72                	je     801045c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104554:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
8010455a:	74 4c                	je     801045a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010455c:	83 ec 0c             	sub    $0xc,%esp
8010455f:	68 20 3d 11 80       	push   $0x80113d20
80104564:	e8 17 07 00 00       	call   80104c80 <acquire>
    release(lk);
80104569:	89 34 24             	mov    %esi,(%esp)
8010456c:	e8 cf 07 00 00       	call   80104d40 <release>
  p->chan = chan;
80104571:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104574:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010457b:	e8 00 fd ff ff       	call   80104280 <sched>
  p->chan = 0;
80104580:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104587:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010458e:	e8 ad 07 00 00       	call   80104d40 <release>
    acquire(lk);
80104593:	89 75 08             	mov    %esi,0x8(%ebp)
80104596:	83 c4 10             	add    $0x10,%esp
}
80104599:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010459c:	5b                   	pop    %ebx
8010459d:	5e                   	pop    %esi
8010459e:	5f                   	pop    %edi
8010459f:	5d                   	pop    %ebp
    acquire(lk);
801045a0:	e9 db 06 00 00       	jmp    80104c80 <acquire>
801045a5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801045a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801045ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801045b2:	e8 c9 fc ff ff       	call   80104280 <sched>
  p->chan = 0;
801045b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801045be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045c1:	5b                   	pop    %ebx
801045c2:	5e                   	pop    %esi
801045c3:	5f                   	pop    %edi
801045c4:	5d                   	pop    %ebp
801045c5:	c3                   	ret    
    panic("sleep without lk");
801045c6:	83 ec 0c             	sub    $0xc,%esp
801045c9:	68 0d 7f 10 80       	push   $0x80107f0d
801045ce:	e8 bd bd ff ff       	call   80100390 <panic>
    panic("sleep");
801045d3:	83 ec 0c             	sub    $0xc,%esp
801045d6:	68 07 7f 10 80       	push   $0x80107f07
801045db:	e8 b0 bd ff ff       	call   80100390 <panic>

801045e0 <wait>:
{
801045e0:	f3 0f 1e fb          	endbr32 
801045e4:	55                   	push   %ebp
801045e5:	89 e5                	mov    %esp,%ebp
801045e7:	57                   	push   %edi
801045e8:	56                   	push   %esi
801045e9:	53                   	push   %ebx
801045ea:	83 ec 0c             	sub    $0xc,%esp
801045ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
801045f0:	e8 8b 05 00 00       	call   80104b80 <pushcli>
  c = mycpu();
801045f5:	e8 66 f5 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
801045fa:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104600:	e8 cb 05 00 00       	call   80104bd0 <popcli>
  acquire(&ptable.lock);
80104605:	83 ec 0c             	sub    $0xc,%esp
80104608:	68 20 3d 11 80       	push   $0x80113d20
8010460d:	e8 6e 06 00 00       	call   80104c80 <acquire>
80104612:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104615:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104617:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
8010461c:	eb 10                	jmp    8010462e <wait+0x4e>
8010461e:	66 90                	xchg   %ax,%ax
80104620:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104626:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
8010462c:	74 1e                	je     8010464c <wait+0x6c>
      if(p->parent != curproc)
8010462e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104631:	75 ed                	jne    80104620 <wait+0x40>
      if(p->state == ZOMBIE){
80104633:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104637:	74 37                	je     80104670 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104639:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
      havekids = 1;
8010463f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104644:	81 fb 54 64 11 80    	cmp    $0x80116454,%ebx
8010464a:	75 e2                	jne    8010462e <wait+0x4e>
    if(!havekids || curproc->killed){
8010464c:	85 c0                	test   %eax,%eax
8010464e:	0f 84 7c 00 00 00    	je     801046d0 <wait+0xf0>
80104654:	8b 46 24             	mov    0x24(%esi),%eax
80104657:	85 c0                	test   %eax,%eax
80104659:	75 75                	jne    801046d0 <wait+0xf0>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010465b:	83 ec 08             	sub    $0x8,%esp
8010465e:	68 20 3d 11 80       	push   $0x80113d20
80104663:	56                   	push   %esi
80104664:	e8 b7 fe ff ff       	call   80104520 <sleep>
    havekids = 0;
80104669:	83 c4 10             	add    $0x10,%esp
8010466c:	eb a7                	jmp    80104615 <wait+0x35>
8010466e:	66 90                	xchg   %ax,%ax
        pid = p->pid;
80104670:	8b 73 10             	mov    0x10(%ebx),%esi
        if (status != null){
80104673:	85 ff                	test   %edi,%edi
80104675:	74 05                	je     8010467c <wait+0x9c>
          *status = p->exit_status; // returning child's exit status
80104677:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010467a:	89 07                	mov    %eax,(%edi)
        kfree(p->kstack);
8010467c:	83 ec 0c             	sub    $0xc,%esp
8010467f:	ff 73 08             	pushl  0x8(%ebx)
80104682:	e8 e9 dd ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
80104687:	5a                   	pop    %edx
80104688:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010468b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104692:	e8 79 2f 00 00       	call   80107610 <freevm>
        release(&ptable.lock);
80104697:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
8010469e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801046a5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801046ac:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801046b0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801046b7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801046be:	e8 7d 06 00 00       	call   80104d40 <release>
        return pid;
801046c3:	83 c4 10             	add    $0x10,%esp
}
801046c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046c9:	89 f0                	mov    %esi,%eax
801046cb:	5b                   	pop    %ebx
801046cc:	5e                   	pop    %esi
801046cd:	5f                   	pop    %edi
801046ce:	5d                   	pop    %ebp
801046cf:	c3                   	ret    
      release(&ptable.lock);
801046d0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801046d3:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801046d8:	68 20 3d 11 80       	push   $0x80113d20
801046dd:	e8 5e 06 00 00       	call   80104d40 <release>
      return -1;
801046e2:	83 c4 10             	add    $0x10,%esp
801046e5:	eb df                	jmp    801046c6 <wait+0xe6>
801046e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ee:	66 90                	xchg   %ax,%ax

801046f0 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801046f0:	f3 0f 1e fb          	endbr32 
801046f4:	55                   	push   %ebp
801046f5:	89 e5                	mov    %esp,%ebp
801046f7:	53                   	push   %ebx
801046f8:	83 ec 10             	sub    $0x10,%esp
801046fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801046fe:	68 20 3d 11 80       	push   $0x80113d20
80104703:	e8 78 05 00 00       	call   80104c80 <acquire>
  wakeup1(chan);
80104708:	89 d8                	mov    %ebx,%eax
8010470a:	e8 91 f0 ff ff       	call   801037a0 <wakeup1>
  release(&ptable.lock);
8010470f:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104716:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&ptable.lock);
80104719:	83 c4 10             	add    $0x10,%esp
}
8010471c:	c9                   	leave  
  release(&ptable.lock);
8010471d:	e9 1e 06 00 00       	jmp    80104d40 <release>
80104722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104730 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104730:	f3 0f 1e fb          	endbr32 
80104734:	55                   	push   %ebp
80104735:	89 e5                	mov    %esp,%ebp
80104737:	53                   	push   %ebx
80104738:	83 ec 10             	sub    $0x10,%esp
8010473b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010473e:	68 20 3d 11 80       	push   $0x80113d20
80104743:	e8 38 05 00 00       	call   80104c80 <acquire>
80104748:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010474b:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104750:	eb 12                	jmp    80104764 <kill+0x34>
80104752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104758:	05 9c 00 00 00       	add    $0x9c,%eax
8010475d:	3d 54 64 11 80       	cmp    $0x80116454,%eax
80104762:	74 34                	je     80104798 <kill+0x68>
    if(p->pid == pid){
80104764:	39 58 10             	cmp    %ebx,0x10(%eax)
80104767:	75 ef                	jne    80104758 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104769:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010476d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104774:	75 07                	jne    8010477d <kill+0x4d>
        p->state = RUNNABLE;
80104776:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010477d:	83 ec 0c             	sub    $0xc,%esp
80104780:	68 20 3d 11 80       	push   $0x80113d20
80104785:	e8 b6 05 00 00       	call   80104d40 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010478a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010478d:	83 c4 10             	add    $0x10,%esp
80104790:	31 c0                	xor    %eax,%eax
}
80104792:	c9                   	leave  
80104793:	c3                   	ret    
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104798:	83 ec 0c             	sub    $0xc,%esp
8010479b:	68 20 3d 11 80       	push   $0x80113d20
801047a0:	e8 9b 05 00 00       	call   80104d40 <release>
}
801047a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801047a8:	83 c4 10             	add    $0x10,%esp
801047ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047b0:	c9                   	leave  
801047b1:	c3                   	ret    
801047b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801047c0:	f3 0f 1e fb          	endbr32 
801047c4:	55                   	push   %ebp
801047c5:	89 e5                	mov    %esp,%ebp
801047c7:	57                   	push   %edi
801047c8:	56                   	push   %esi
801047c9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801047cc:	53                   	push   %ebx
801047cd:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801047d2:	83 ec 3c             	sub    $0x3c,%esp
801047d5:	eb 2b                	jmp    80104802 <procdump+0x42>
801047d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047de:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801047e0:	83 ec 0c             	sub    $0xc,%esp
801047e3:	68 ab 82 10 80       	push   $0x801082ab
801047e8:	e8 c3 be ff ff       	call   801006b0 <cprintf>
801047ed:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047f0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801047f6:	81 fb c0 64 11 80    	cmp    $0x801164c0,%ebx
801047fc:	0f 84 8e 00 00 00    	je     80104890 <procdump+0xd0>
    if(p->state == UNUSED)
80104802:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104805:	85 c0                	test   %eax,%eax
80104807:	74 e7                	je     801047f0 <procdump+0x30>
      state = "???";
80104809:	ba 1e 7f 10 80       	mov    $0x80107f1e,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010480e:	83 f8 05             	cmp    $0x5,%eax
80104811:	77 11                	ja     80104824 <procdump+0x64>
80104813:	8b 14 85 8c 7f 10 80 	mov    -0x7fef8074(,%eax,4),%edx
      state = "???";
8010481a:	b8 1e 7f 10 80       	mov    $0x80107f1e,%eax
8010481f:	85 d2                	test   %edx,%edx
80104821:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104824:	53                   	push   %ebx
80104825:	52                   	push   %edx
80104826:	ff 73 a4             	pushl  -0x5c(%ebx)
80104829:	68 22 7f 10 80       	push   $0x80107f22
8010482e:	e8 7d be ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104833:	83 c4 10             	add    $0x10,%esp
80104836:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010483a:	75 a4                	jne    801047e0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010483c:	83 ec 08             	sub    $0x8,%esp
8010483f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104842:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104845:	50                   	push   %eax
80104846:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104849:	8b 40 0c             	mov    0xc(%eax),%eax
8010484c:	83 c0 08             	add    $0x8,%eax
8010484f:	50                   	push   %eax
80104850:	e8 cb 02 00 00       	call   80104b20 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104855:	83 c4 10             	add    $0x10,%esp
80104858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485f:	90                   	nop
80104860:	8b 17                	mov    (%edi),%edx
80104862:	85 d2                	test   %edx,%edx
80104864:	0f 84 76 ff ff ff    	je     801047e0 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010486a:	83 ec 08             	sub    $0x8,%esp
8010486d:	83 c7 04             	add    $0x4,%edi
80104870:	52                   	push   %edx
80104871:	68 61 79 10 80       	push   $0x80107961
80104876:	e8 35 be ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010487b:	83 c4 10             	add    $0x10,%esp
8010487e:	39 fe                	cmp    %edi,%esi
80104880:	75 de                	jne    80104860 <procdump+0xa0>
80104882:	e9 59 ff ff ff       	jmp    801047e0 <procdump+0x20>
80104887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488e:	66 90                	xchg   %ax,%ax
  }
}
80104890:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104893:	5b                   	pop    %ebx
80104894:	5e                   	pop    %esi
80104895:	5f                   	pop    %edi
80104896:	5d                   	pop    %ebp
80104897:	c3                   	ret    
80104898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489f:	90                   	nop

801048a0 <set_ps_priority>:

int set_ps_priority(int priority){
801048a0:	f3 0f 1e fb          	endbr32 
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	56                   	push   %esi
801048a8:	53                   	push   %ebx
801048a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (priority > 10 || priority < 1){
801048ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
801048af:	83 f8 09             	cmp    $0x9,%eax
801048b2:	77 24                	ja     801048d8 <set_ps_priority+0x38>
  pushcli();
801048b4:	e8 c7 02 00 00       	call   80104b80 <pushcli>
  c = mycpu();
801048b9:	e8 a2 f2 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
801048be:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801048c4:	e8 07 03 00 00       	call   80104bd0 <popcli>
    return -1;
  }
  else{
    myproc()->ps_priority = priority;
    return 0;
801048c9:	31 c0                	xor    %eax,%eax
    myproc()->ps_priority = priority;
801048cb:	89 9e 80 00 00 00    	mov    %ebx,0x80(%esi)
  }
}
801048d1:	5b                   	pop    %ebx
801048d2:	5e                   	pop    %esi
801048d3:	5d                   	pop    %ebp
801048d4:	c3                   	ret    
801048d5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801048d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048dd:	eb f2                	jmp    801048d1 <set_ps_priority+0x31>
801048df:	90                   	nop

801048e0 <policy>:

int policy(int policy){
801048e0:	f3 0f 1e fb          	endbr32 
801048e4:	55                   	push   %ebp
801048e5:	89 e5                	mov    %esp,%ebp
801048e7:	8b 45 08             	mov    0x8(%ebp),%eax
  if (policy > 3 || policy < 0){
801048ea:	83 f8 03             	cmp    $0x3,%eax
801048ed:	77 11                	ja     80104900 <policy+0x20>
    return -1; 
  }
  else{
    sched_type = policy;
801048ef:	a3 18 0f 11 80       	mov    %eax,0x80110f18
    return 0;
  } 
}
801048f4:	5d                   	pop    %ebp
    return 0;
801048f5:	31 c0                	xor    %eax,%eax
}
801048f7:	c3                   	ret    
801048f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ff:	90                   	nop
    return -1; 
80104900:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104905:	5d                   	pop    %ebp
80104906:	c3                   	ret    
80104907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490e:	66 90                	xchg   %ax,%ax

80104910 <set_cfs_priority>:

int set_cfs_priority(int priority){
80104910:	f3 0f 1e fb          	endbr32 
80104914:	55                   	push   %ebp
80104915:	89 e5                	mov    %esp,%ebp
80104917:	53                   	push   %ebx
80104918:	83 ec 14             	sub    $0x14,%esp
8010491b:	8b 45 08             	mov    0x8(%ebp),%eax
8010491e:	83 e8 01             	sub    $0x1,%eax
80104921:	83 f8 02             	cmp    $0x2,%eax
80104924:	77 3a                	ja     80104960 <set_cfs_priority+0x50>
80104926:	d9 04 85 80 7f 10 80 	flds   -0x7fef8080(,%eax,4)
8010492d:	d9 5d f4             	fstps  -0xc(%ebp)
  pushcli();
80104930:	e8 4b 02 00 00       	call   80104b80 <pushcli>
  c = mycpu();
80104935:	e8 26 f2 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
8010493a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104940:	e8 8b 02 00 00       	call   80104bd0 <popcli>
      break;
    default:
      return -1;
  }

  myproc()->cfs_decay_factor = decay_factor;
80104945:	d9 45 f4             	flds   -0xc(%ebp)
  return 0;
80104948:	31 c0                	xor    %eax,%eax
  myproc()->cfs_decay_factor = decay_factor;
8010494a:	d9 9b 8c 00 00 00    	fstps  0x8c(%ebx)
}
80104950:	83 c4 14             	add    $0x14,%esp
80104953:	5b                   	pop    %ebx
80104954:	5d                   	pop    %ebp
80104955:	c3                   	ret    
80104956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495d:	8d 76 00             	lea    0x0(%esi),%esi
      return -1;
80104960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104965:	eb e9                	jmp    80104950 <set_cfs_priority+0x40>
80104967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496e:	66 90                	xchg   %ax,%ax

80104970 <proc_info>:

int proc_info(struct perf* performance){
80104970:	f3 0f 1e fb          	endbr32 
80104974:	55                   	push   %ebp
80104975:	89 e5                	mov    %esp,%ebp
80104977:	56                   	push   %esi
80104978:	53                   	push   %ebx
80104979:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010497c:	e8 ff 01 00 00       	call   80104b80 <pushcli>
  c = mycpu();
80104981:	e8 da f1 ff ff       	call   80103b60 <mycpu>
  p = c->proc;
80104986:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010498c:	e8 3f 02 00 00       	call   80104bd0 <popcli>
  struct proc* p = myproc();
  performance->ps_priority = p->ps_priority;
80104991:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
80104997:	89 03                	mov    %eax,(%ebx)
  performance->retime = p->retime;
80104999:	8b 86 94 00 00 00    	mov    0x94(%esi),%eax
8010499f:	89 43 08             	mov    %eax,0x8(%ebx)
  performance->rtime = p->rtime;
801049a2:	8b 86 90 00 00 00    	mov    0x90(%esi),%eax
801049a8:	89 43 0c             	mov    %eax,0xc(%ebx)
  performance->stime = p->stime;
801049ab:	8b 86 98 00 00 00    	mov    0x98(%esi),%eax
801049b1:	89 43 04             	mov    %eax,0x4(%ebx)
  return 0; // TODO: verify this
}
801049b4:	31 c0                	xor    %eax,%eax
801049b6:	5b                   	pop    %ebx
801049b7:	5e                   	pop    %esi
801049b8:	5d                   	pop    %ebp
801049b9:	c3                   	ret    
801049ba:	66 90                	xchg   %ax,%ax
801049bc:	66 90                	xchg   %ax,%ax
801049be:	66 90                	xchg   %ax,%ax

801049c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801049c0:	f3 0f 1e fb          	endbr32 
801049c4:	55                   	push   %ebp
801049c5:	89 e5                	mov    %esp,%ebp
801049c7:	53                   	push   %ebx
801049c8:	83 ec 0c             	sub    $0xc,%esp
801049cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801049ce:	68 a8 7f 10 80       	push   $0x80107fa8
801049d3:	8d 43 04             	lea    0x4(%ebx),%eax
801049d6:	50                   	push   %eax
801049d7:	e8 24 01 00 00       	call   80104b00 <initlock>
  lk->name = name;
801049dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801049df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801049e5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801049e8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801049ef:	89 43 38             	mov    %eax,0x38(%ebx)
}
801049f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049f5:	c9                   	leave  
801049f6:	c3                   	ret    
801049f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104a00:	f3 0f 1e fb          	endbr32 
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	56                   	push   %esi
80104a08:	53                   	push   %ebx
80104a09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a0c:	8d 73 04             	lea    0x4(%ebx),%esi
80104a0f:	83 ec 0c             	sub    $0xc,%esp
80104a12:	56                   	push   %esi
80104a13:	e8 68 02 00 00       	call   80104c80 <acquire>
  while (lk->locked) {
80104a18:	8b 13                	mov    (%ebx),%edx
80104a1a:	83 c4 10             	add    $0x10,%esp
80104a1d:	85 d2                	test   %edx,%edx
80104a1f:	74 1a                	je     80104a3b <acquiresleep+0x3b>
80104a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104a28:	83 ec 08             	sub    $0x8,%esp
80104a2b:	56                   	push   %esi
80104a2c:	53                   	push   %ebx
80104a2d:	e8 ee fa ff ff       	call   80104520 <sleep>
  while (lk->locked) {
80104a32:	8b 03                	mov    (%ebx),%eax
80104a34:	83 c4 10             	add    $0x10,%esp
80104a37:	85 c0                	test   %eax,%eax
80104a39:	75 ed                	jne    80104a28 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104a3b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104a41:	e8 aa f1 ff ff       	call   80103bf0 <myproc>
80104a46:	8b 40 10             	mov    0x10(%eax),%eax
80104a49:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104a4c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104a4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a52:	5b                   	pop    %ebx
80104a53:	5e                   	pop    %esi
80104a54:	5d                   	pop    %ebp
  release(&lk->lk);
80104a55:	e9 e6 02 00 00       	jmp    80104d40 <release>
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a60 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	56                   	push   %esi
80104a68:	53                   	push   %ebx
80104a69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a6c:	8d 73 04             	lea    0x4(%ebx),%esi
80104a6f:	83 ec 0c             	sub    $0xc,%esp
80104a72:	56                   	push   %esi
80104a73:	e8 08 02 00 00       	call   80104c80 <acquire>
  lk->locked = 0;
80104a78:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a7e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a85:	89 1c 24             	mov    %ebx,(%esp)
80104a88:	e8 63 fc ff ff       	call   801046f0 <wakeup>
  release(&lk->lk);
80104a8d:	89 75 08             	mov    %esi,0x8(%ebp)
80104a90:	83 c4 10             	add    $0x10,%esp
}
80104a93:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a96:	5b                   	pop    %ebx
80104a97:	5e                   	pop    %esi
80104a98:	5d                   	pop    %ebp
  release(&lk->lk);
80104a99:	e9 a2 02 00 00       	jmp    80104d40 <release>
80104a9e:	66 90                	xchg   %ax,%ax

80104aa0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104aa0:	f3 0f 1e fb          	endbr32 
80104aa4:	55                   	push   %ebp
80104aa5:	89 e5                	mov    %esp,%ebp
80104aa7:	57                   	push   %edi
80104aa8:	31 ff                	xor    %edi,%edi
80104aaa:	56                   	push   %esi
80104aab:	53                   	push   %ebx
80104aac:	83 ec 18             	sub    $0x18,%esp
80104aaf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104ab2:	8d 73 04             	lea    0x4(%ebx),%esi
80104ab5:	56                   	push   %esi
80104ab6:	e8 c5 01 00 00       	call   80104c80 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104abb:	8b 03                	mov    (%ebx),%eax
80104abd:	83 c4 10             	add    $0x10,%esp
80104ac0:	85 c0                	test   %eax,%eax
80104ac2:	75 1c                	jne    80104ae0 <holdingsleep+0x40>
  release(&lk->lk);
80104ac4:	83 ec 0c             	sub    $0xc,%esp
80104ac7:	56                   	push   %esi
80104ac8:	e8 73 02 00 00       	call   80104d40 <release>
  return r;
}
80104acd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ad0:	89 f8                	mov    %edi,%eax
80104ad2:	5b                   	pop    %ebx
80104ad3:	5e                   	pop    %esi
80104ad4:	5f                   	pop    %edi
80104ad5:	5d                   	pop    %ebp
80104ad6:	c3                   	ret    
80104ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ade:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104ae0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104ae3:	e8 08 f1 ff ff       	call   80103bf0 <myproc>
80104ae8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104aeb:	0f 94 c0             	sete   %al
80104aee:	0f b6 c0             	movzbl %al,%eax
80104af1:	89 c7                	mov    %eax,%edi
80104af3:	eb cf                	jmp    80104ac4 <holdingsleep+0x24>
80104af5:	66 90                	xchg   %ax,%ax
80104af7:	66 90                	xchg   %ax,%ax
80104af9:	66 90                	xchg   %ax,%ax
80104afb:	66 90                	xchg   %ax,%ax
80104afd:	66 90                	xchg   %ax,%ax
80104aff:	90                   	nop

80104b00 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b00:	f3 0f 1e fb          	endbr32 
80104b04:	55                   	push   %ebp
80104b05:	89 e5                	mov    %esp,%ebp
80104b07:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104b0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104b13:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104b16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104b1d:	5d                   	pop    %ebp
80104b1e:	c3                   	ret    
80104b1f:	90                   	nop

80104b20 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b20:	f3 0f 1e fb          	endbr32 
80104b24:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104b25:	31 d2                	xor    %edx,%edx
{
80104b27:	89 e5                	mov    %esp,%ebp
80104b29:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104b2a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104b2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104b30:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104b33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b37:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b38:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104b3e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b44:	77 1a                	ja     80104b60 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104b46:	8b 58 04             	mov    0x4(%eax),%ebx
80104b49:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104b4c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104b4f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b51:	83 fa 0a             	cmp    $0xa,%edx
80104b54:	75 e2                	jne    80104b38 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104b56:	5b                   	pop    %ebx
80104b57:	5d                   	pop    %ebp
80104b58:	c3                   	ret    
80104b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104b60:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b63:	8d 51 28             	lea    0x28(%ecx),%edx
80104b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104b70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b76:	83 c0 04             	add    $0x4,%eax
80104b79:	39 d0                	cmp    %edx,%eax
80104b7b:	75 f3                	jne    80104b70 <getcallerpcs+0x50>
}
80104b7d:	5b                   	pop    %ebx
80104b7e:	5d                   	pop    %ebp
80104b7f:	c3                   	ret    

80104b80 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b80:	f3 0f 1e fb          	endbr32 
80104b84:	55                   	push   %ebp
80104b85:	89 e5                	mov    %esp,%ebp
80104b87:	53                   	push   %ebx
80104b88:	83 ec 04             	sub    $0x4,%esp
80104b8b:	9c                   	pushf  
80104b8c:	5b                   	pop    %ebx
  asm volatile("cli");
80104b8d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b8e:	e8 cd ef ff ff       	call   80103b60 <mycpu>
80104b93:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b99:	85 c0                	test   %eax,%eax
80104b9b:	74 13                	je     80104bb0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104b9d:	e8 be ef ff ff       	call   80103b60 <mycpu>
80104ba2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104ba9:	83 c4 04             	add    $0x4,%esp
80104bac:	5b                   	pop    %ebx
80104bad:	5d                   	pop    %ebp
80104bae:	c3                   	ret    
80104baf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104bb0:	e8 ab ef ff ff       	call   80103b60 <mycpu>
80104bb5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104bbb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104bc1:	eb da                	jmp    80104b9d <pushcli+0x1d>
80104bc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bd0 <popcli>:

void
popcli(void)
{
80104bd0:	f3 0f 1e fb          	endbr32 
80104bd4:	55                   	push   %ebp
80104bd5:	89 e5                	mov    %esp,%ebp
80104bd7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104bda:	9c                   	pushf  
80104bdb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104bdc:	f6 c4 02             	test   $0x2,%ah
80104bdf:	75 31                	jne    80104c12 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104be1:	e8 7a ef ff ff       	call   80103b60 <mycpu>
80104be6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104bed:	78 30                	js     80104c1f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104bef:	e8 6c ef ff ff       	call   80103b60 <mycpu>
80104bf4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104bfa:	85 d2                	test   %edx,%edx
80104bfc:	74 02                	je     80104c00 <popcli+0x30>
    sti();
}
80104bfe:	c9                   	leave  
80104bff:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c00:	e8 5b ef ff ff       	call   80103b60 <mycpu>
80104c05:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c0b:	85 c0                	test   %eax,%eax
80104c0d:	74 ef                	je     80104bfe <popcli+0x2e>
  asm volatile("sti");
80104c0f:	fb                   	sti    
}
80104c10:	c9                   	leave  
80104c11:	c3                   	ret    
    panic("popcli - interruptible");
80104c12:	83 ec 0c             	sub    $0xc,%esp
80104c15:	68 b3 7f 10 80       	push   $0x80107fb3
80104c1a:	e8 71 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104c1f:	83 ec 0c             	sub    $0xc,%esp
80104c22:	68 ca 7f 10 80       	push   $0x80107fca
80104c27:	e8 64 b7 ff ff       	call   80100390 <panic>
80104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c30 <holding>:
{
80104c30:	f3 0f 1e fb          	endbr32 
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	56                   	push   %esi
80104c38:	53                   	push   %ebx
80104c39:	8b 75 08             	mov    0x8(%ebp),%esi
80104c3c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104c3e:	e8 3d ff ff ff       	call   80104b80 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104c43:	8b 06                	mov    (%esi),%eax
80104c45:	85 c0                	test   %eax,%eax
80104c47:	75 0f                	jne    80104c58 <holding+0x28>
  popcli();
80104c49:	e8 82 ff ff ff       	call   80104bd0 <popcli>
}
80104c4e:	89 d8                	mov    %ebx,%eax
80104c50:	5b                   	pop    %ebx
80104c51:	5e                   	pop    %esi
80104c52:	5d                   	pop    %ebp
80104c53:	c3                   	ret    
80104c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104c58:	8b 5e 08             	mov    0x8(%esi),%ebx
80104c5b:	e8 00 ef ff ff       	call   80103b60 <mycpu>
80104c60:	39 c3                	cmp    %eax,%ebx
80104c62:	0f 94 c3             	sete   %bl
  popcli();
80104c65:	e8 66 ff ff ff       	call   80104bd0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104c6a:	0f b6 db             	movzbl %bl,%ebx
}
80104c6d:	89 d8                	mov    %ebx,%eax
80104c6f:	5b                   	pop    %ebx
80104c70:	5e                   	pop    %esi
80104c71:	5d                   	pop    %ebp
80104c72:	c3                   	ret    
80104c73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c80 <acquire>:
{
80104c80:	f3 0f 1e fb          	endbr32 
80104c84:	55                   	push   %ebp
80104c85:	89 e5                	mov    %esp,%ebp
80104c87:	56                   	push   %esi
80104c88:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104c89:	e8 f2 fe ff ff       	call   80104b80 <pushcli>
  if(holding(lk))
80104c8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c91:	83 ec 0c             	sub    $0xc,%esp
80104c94:	53                   	push   %ebx
80104c95:	e8 96 ff ff ff       	call   80104c30 <holding>
80104c9a:	83 c4 10             	add    $0x10,%esp
80104c9d:	85 c0                	test   %eax,%eax
80104c9f:	0f 85 7f 00 00 00    	jne    80104d24 <acquire+0xa4>
80104ca5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104ca7:	ba 01 00 00 00       	mov    $0x1,%edx
80104cac:	eb 05                	jmp    80104cb3 <acquire+0x33>
80104cae:	66 90                	xchg   %ax,%ax
80104cb0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104cb3:	89 d0                	mov    %edx,%eax
80104cb5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104cb8:	85 c0                	test   %eax,%eax
80104cba:	75 f4                	jne    80104cb0 <acquire+0x30>
  __sync_synchronize();
80104cbc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104cc1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104cc4:	e8 97 ee ff ff       	call   80103b60 <mycpu>
80104cc9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104ccc:	89 e8                	mov    %ebp,%eax
80104cce:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104cd0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104cd6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104cdc:	77 22                	ja     80104d00 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104cde:	8b 50 04             	mov    0x4(%eax),%edx
80104ce1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104ce5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104ce8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104cea:	83 fe 0a             	cmp    $0xa,%esi
80104ced:	75 e1                	jne    80104cd0 <acquire+0x50>
}
80104cef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cf2:	5b                   	pop    %ebx
80104cf3:	5e                   	pop    %esi
80104cf4:	5d                   	pop    %ebp
80104cf5:	c3                   	ret    
80104cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104d00:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104d04:	83 c3 34             	add    $0x34,%ebx
80104d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104d10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104d16:	83 c0 04             	add    $0x4,%eax
80104d19:	39 d8                	cmp    %ebx,%eax
80104d1b:	75 f3                	jne    80104d10 <acquire+0x90>
}
80104d1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d20:	5b                   	pop    %ebx
80104d21:	5e                   	pop    %esi
80104d22:	5d                   	pop    %ebp
80104d23:	c3                   	ret    
    panic("acquire");
80104d24:	83 ec 0c             	sub    $0xc,%esp
80104d27:	68 d1 7f 10 80       	push   $0x80107fd1
80104d2c:	e8 5f b6 ff ff       	call   80100390 <panic>
80104d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3f:	90                   	nop

80104d40 <release>:
{
80104d40:	f3 0f 1e fb          	endbr32 
80104d44:	55                   	push   %ebp
80104d45:	89 e5                	mov    %esp,%ebp
80104d47:	53                   	push   %ebx
80104d48:	83 ec 10             	sub    $0x10,%esp
80104d4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104d4e:	53                   	push   %ebx
80104d4f:	e8 dc fe ff ff       	call   80104c30 <holding>
80104d54:	83 c4 10             	add    $0x10,%esp
80104d57:	85 c0                	test   %eax,%eax
80104d59:	74 22                	je     80104d7d <release+0x3d>
  lk->pcs[0] = 0;
80104d5b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104d62:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104d69:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d6e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104d74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d77:	c9                   	leave  
  popcli();
80104d78:	e9 53 fe ff ff       	jmp    80104bd0 <popcli>
    panic("release");
80104d7d:	83 ec 0c             	sub    $0xc,%esp
80104d80:	68 d9 7f 10 80       	push   $0x80107fd9
80104d85:	e8 06 b6 ff ff       	call   80100390 <panic>
80104d8a:	66 90                	xchg   %ax,%ax
80104d8c:	66 90                	xchg   %ax,%ax
80104d8e:	66 90                	xchg   %ax,%ax

80104d90 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d90:	f3 0f 1e fb          	endbr32 
80104d94:	55                   	push   %ebp
80104d95:	89 e5                	mov    %esp,%ebp
80104d97:	57                   	push   %edi
80104d98:	8b 55 08             	mov    0x8(%ebp),%edx
80104d9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d9e:	53                   	push   %ebx
80104d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104da2:	89 d7                	mov    %edx,%edi
80104da4:	09 cf                	or     %ecx,%edi
80104da6:	83 e7 03             	and    $0x3,%edi
80104da9:	75 25                	jne    80104dd0 <memset+0x40>
    c &= 0xFF;
80104dab:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104dae:	c1 e0 18             	shl    $0x18,%eax
80104db1:	89 fb                	mov    %edi,%ebx
80104db3:	c1 e9 02             	shr    $0x2,%ecx
80104db6:	c1 e3 10             	shl    $0x10,%ebx
80104db9:	09 d8                	or     %ebx,%eax
80104dbb:	09 f8                	or     %edi,%eax
80104dbd:	c1 e7 08             	shl    $0x8,%edi
80104dc0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104dc2:	89 d7                	mov    %edx,%edi
80104dc4:	fc                   	cld    
80104dc5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104dc7:	5b                   	pop    %ebx
80104dc8:	89 d0                	mov    %edx,%eax
80104dca:	5f                   	pop    %edi
80104dcb:	5d                   	pop    %ebp
80104dcc:	c3                   	ret    
80104dcd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104dd0:	89 d7                	mov    %edx,%edi
80104dd2:	fc                   	cld    
80104dd3:	f3 aa                	rep stos %al,%es:(%edi)
80104dd5:	5b                   	pop    %ebx
80104dd6:	89 d0                	mov    %edx,%eax
80104dd8:	5f                   	pop    %edi
80104dd9:	5d                   	pop    %ebp
80104dda:	c3                   	ret    
80104ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ddf:	90                   	nop

80104de0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
80104de5:	89 e5                	mov    %esp,%ebp
80104de7:	56                   	push   %esi
80104de8:	8b 75 10             	mov    0x10(%ebp),%esi
80104deb:	8b 55 08             	mov    0x8(%ebp),%edx
80104dee:	53                   	push   %ebx
80104def:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104df2:	85 f6                	test   %esi,%esi
80104df4:	74 2a                	je     80104e20 <memcmp+0x40>
80104df6:	01 c6                	add    %eax,%esi
80104df8:	eb 10                	jmp    80104e0a <memcmp+0x2a>
80104dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104e00:	83 c0 01             	add    $0x1,%eax
80104e03:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104e06:	39 f0                	cmp    %esi,%eax
80104e08:	74 16                	je     80104e20 <memcmp+0x40>
    if(*s1 != *s2)
80104e0a:	0f b6 0a             	movzbl (%edx),%ecx
80104e0d:	0f b6 18             	movzbl (%eax),%ebx
80104e10:	38 d9                	cmp    %bl,%cl
80104e12:	74 ec                	je     80104e00 <memcmp+0x20>
      return *s1 - *s2;
80104e14:	0f b6 c1             	movzbl %cl,%eax
80104e17:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104e19:	5b                   	pop    %ebx
80104e1a:	5e                   	pop    %esi
80104e1b:	5d                   	pop    %ebp
80104e1c:	c3                   	ret    
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi
80104e20:	5b                   	pop    %ebx
  return 0;
80104e21:	31 c0                	xor    %eax,%eax
}
80104e23:	5e                   	pop    %esi
80104e24:	5d                   	pop    %ebp
80104e25:	c3                   	ret    
80104e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2d:	8d 76 00             	lea    0x0(%esi),%esi

80104e30 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104e30:	f3 0f 1e fb          	endbr32 
80104e34:	55                   	push   %ebp
80104e35:	89 e5                	mov    %esp,%ebp
80104e37:	57                   	push   %edi
80104e38:	8b 55 08             	mov    0x8(%ebp),%edx
80104e3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e3e:	56                   	push   %esi
80104e3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104e42:	39 d6                	cmp    %edx,%esi
80104e44:	73 2a                	jae    80104e70 <memmove+0x40>
80104e46:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104e49:	39 fa                	cmp    %edi,%edx
80104e4b:	73 23                	jae    80104e70 <memmove+0x40>
80104e4d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104e50:	85 c9                	test   %ecx,%ecx
80104e52:	74 13                	je     80104e67 <memmove+0x37>
80104e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104e58:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104e5c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104e5f:	83 e8 01             	sub    $0x1,%eax
80104e62:	83 f8 ff             	cmp    $0xffffffff,%eax
80104e65:	75 f1                	jne    80104e58 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104e67:	5e                   	pop    %esi
80104e68:	89 d0                	mov    %edx,%eax
80104e6a:	5f                   	pop    %edi
80104e6b:	5d                   	pop    %ebp
80104e6c:	c3                   	ret    
80104e6d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104e70:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104e73:	89 d7                	mov    %edx,%edi
80104e75:	85 c9                	test   %ecx,%ecx
80104e77:	74 ee                	je     80104e67 <memmove+0x37>
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104e80:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104e81:	39 f0                	cmp    %esi,%eax
80104e83:	75 fb                	jne    80104e80 <memmove+0x50>
}
80104e85:	5e                   	pop    %esi
80104e86:	89 d0                	mov    %edx,%eax
80104e88:	5f                   	pop    %edi
80104e89:	5d                   	pop    %ebp
80104e8a:	c3                   	ret    
80104e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e8f:	90                   	nop

80104e90 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e90:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104e94:	eb 9a                	jmp    80104e30 <memmove>
80104e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ea0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104ea0:	f3 0f 1e fb          	endbr32 
80104ea4:	55                   	push   %ebp
80104ea5:	89 e5                	mov    %esp,%ebp
80104ea7:	56                   	push   %esi
80104ea8:	8b 75 10             	mov    0x10(%ebp),%esi
80104eab:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104eae:	53                   	push   %ebx
80104eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104eb2:	85 f6                	test   %esi,%esi
80104eb4:	74 32                	je     80104ee8 <strncmp+0x48>
80104eb6:	01 c6                	add    %eax,%esi
80104eb8:	eb 14                	jmp    80104ece <strncmp+0x2e>
80104eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ec0:	38 da                	cmp    %bl,%dl
80104ec2:	75 14                	jne    80104ed8 <strncmp+0x38>
    n--, p++, q++;
80104ec4:	83 c0 01             	add    $0x1,%eax
80104ec7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104eca:	39 f0                	cmp    %esi,%eax
80104ecc:	74 1a                	je     80104ee8 <strncmp+0x48>
80104ece:	0f b6 11             	movzbl (%ecx),%edx
80104ed1:	0f b6 18             	movzbl (%eax),%ebx
80104ed4:	84 d2                	test   %dl,%dl
80104ed6:	75 e8                	jne    80104ec0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104ed8:	0f b6 c2             	movzbl %dl,%eax
80104edb:	29 d8                	sub    %ebx,%eax
}
80104edd:	5b                   	pop    %ebx
80104ede:	5e                   	pop    %esi
80104edf:	5d                   	pop    %ebp
80104ee0:	c3                   	ret    
80104ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ee8:	5b                   	pop    %ebx
    return 0;
80104ee9:	31 c0                	xor    %eax,%eax
}
80104eeb:	5e                   	pop    %esi
80104eec:	5d                   	pop    %ebp
80104eed:	c3                   	ret    
80104eee:	66 90                	xchg   %ax,%ax

80104ef0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ef0:	f3 0f 1e fb          	endbr32 
80104ef4:	55                   	push   %ebp
80104ef5:	89 e5                	mov    %esp,%ebp
80104ef7:	57                   	push   %edi
80104ef8:	56                   	push   %esi
80104ef9:	8b 75 08             	mov    0x8(%ebp),%esi
80104efc:	53                   	push   %ebx
80104efd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f00:	89 f2                	mov    %esi,%edx
80104f02:	eb 1b                	jmp    80104f1f <strncpy+0x2f>
80104f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f08:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104f0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104f0f:	83 c2 01             	add    $0x1,%edx
80104f12:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104f16:	89 f9                	mov    %edi,%ecx
80104f18:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f1b:	84 c9                	test   %cl,%cl
80104f1d:	74 09                	je     80104f28 <strncpy+0x38>
80104f1f:	89 c3                	mov    %eax,%ebx
80104f21:	83 e8 01             	sub    $0x1,%eax
80104f24:	85 db                	test   %ebx,%ebx
80104f26:	7f e0                	jg     80104f08 <strncpy+0x18>
    ;
  while(n-- > 0)
80104f28:	89 d1                	mov    %edx,%ecx
80104f2a:	85 c0                	test   %eax,%eax
80104f2c:	7e 15                	jle    80104f43 <strncpy+0x53>
80104f2e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104f30:	83 c1 01             	add    $0x1,%ecx
80104f33:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104f37:	89 c8                	mov    %ecx,%eax
80104f39:	f7 d0                	not    %eax
80104f3b:	01 d0                	add    %edx,%eax
80104f3d:	01 d8                	add    %ebx,%eax
80104f3f:	85 c0                	test   %eax,%eax
80104f41:	7f ed                	jg     80104f30 <strncpy+0x40>
  return os;
}
80104f43:	5b                   	pop    %ebx
80104f44:	89 f0                	mov    %esi,%eax
80104f46:	5e                   	pop    %esi
80104f47:	5f                   	pop    %edi
80104f48:	5d                   	pop    %ebp
80104f49:	c3                   	ret    
80104f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
80104f55:	89 e5                	mov    %esp,%ebp
80104f57:	56                   	push   %esi
80104f58:	8b 55 10             	mov    0x10(%ebp),%edx
80104f5b:	8b 75 08             	mov    0x8(%ebp),%esi
80104f5e:	53                   	push   %ebx
80104f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104f62:	85 d2                	test   %edx,%edx
80104f64:	7e 21                	jle    80104f87 <safestrcpy+0x37>
80104f66:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104f6a:	89 f2                	mov    %esi,%edx
80104f6c:	eb 12                	jmp    80104f80 <safestrcpy+0x30>
80104f6e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f70:	0f b6 08             	movzbl (%eax),%ecx
80104f73:	83 c0 01             	add    $0x1,%eax
80104f76:	83 c2 01             	add    $0x1,%edx
80104f79:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f7c:	84 c9                	test   %cl,%cl
80104f7e:	74 04                	je     80104f84 <safestrcpy+0x34>
80104f80:	39 d8                	cmp    %ebx,%eax
80104f82:	75 ec                	jne    80104f70 <safestrcpy+0x20>
    ;
  *s = 0;
80104f84:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104f87:	89 f0                	mov    %esi,%eax
80104f89:	5b                   	pop    %ebx
80104f8a:	5e                   	pop    %esi
80104f8b:	5d                   	pop    %ebp
80104f8c:	c3                   	ret    
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi

80104f90 <strlen>:

int
strlen(const char *s)
{
80104f90:	f3 0f 1e fb          	endbr32 
80104f94:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f95:	31 c0                	xor    %eax,%eax
{
80104f97:	89 e5                	mov    %esp,%ebp
80104f99:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104f9c:	80 3a 00             	cmpb   $0x0,(%edx)
80104f9f:	74 10                	je     80104fb1 <strlen+0x21>
80104fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fa8:	83 c0 01             	add    $0x1,%eax
80104fab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104faf:	75 f7                	jne    80104fa8 <strlen+0x18>
    ;
  return n;
}
80104fb1:	5d                   	pop    %ebp
80104fb2:	c3                   	ret    

80104fb3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104fb3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104fb7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104fbb:	55                   	push   %ebp
  pushl %ebx
80104fbc:	53                   	push   %ebx
  pushl %esi
80104fbd:	56                   	push   %esi
  pushl %edi
80104fbe:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104fbf:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104fc1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104fc3:	5f                   	pop    %edi
  popl %esi
80104fc4:	5e                   	pop    %esi
  popl %ebx
80104fc5:	5b                   	pop    %ebx
  popl %ebp
80104fc6:	5d                   	pop    %ebp
  ret
80104fc7:	c3                   	ret    
80104fc8:	66 90                	xchg   %ax,%ax
80104fca:	66 90                	xchg   %ax,%ax
80104fcc:	66 90                	xchg   %ax,%ax
80104fce:	66 90                	xchg   %ax,%ax

80104fd0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104fd0:	f3 0f 1e fb          	endbr32 
80104fd4:	55                   	push   %ebp
80104fd5:	89 e5                	mov    %esp,%ebp
80104fd7:	53                   	push   %ebx
80104fd8:	83 ec 04             	sub    $0x4,%esp
80104fdb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104fde:	e8 0d ec ff ff       	call   80103bf0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fe3:	8b 00                	mov    (%eax),%eax
80104fe5:	39 d8                	cmp    %ebx,%eax
80104fe7:	76 17                	jbe    80105000 <fetchint+0x30>
80104fe9:	8d 53 04             	lea    0x4(%ebx),%edx
80104fec:	39 d0                	cmp    %edx,%eax
80104fee:	72 10                	jb     80105000 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ff3:	8b 13                	mov    (%ebx),%edx
80104ff5:	89 10                	mov    %edx,(%eax)
  return 0;
80104ff7:	31 c0                	xor    %eax,%eax
}
80104ff9:	83 c4 04             	add    $0x4,%esp
80104ffc:	5b                   	pop    %ebx
80104ffd:	5d                   	pop    %ebp
80104ffe:	c3                   	ret    
80104fff:	90                   	nop
    return -1;
80105000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105005:	eb f2                	jmp    80104ff9 <fetchint+0x29>
80105007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010500e:	66 90                	xchg   %ax,%ax

80105010 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105010:	f3 0f 1e fb          	endbr32 
80105014:	55                   	push   %ebp
80105015:	89 e5                	mov    %esp,%ebp
80105017:	53                   	push   %ebx
80105018:	83 ec 04             	sub    $0x4,%esp
8010501b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010501e:	e8 cd eb ff ff       	call   80103bf0 <myproc>

  if(addr >= curproc->sz)
80105023:	39 18                	cmp    %ebx,(%eax)
80105025:	76 31                	jbe    80105058 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105027:	8b 55 0c             	mov    0xc(%ebp),%edx
8010502a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010502c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010502e:	39 d3                	cmp    %edx,%ebx
80105030:	73 26                	jae    80105058 <fetchstr+0x48>
80105032:	89 d8                	mov    %ebx,%eax
80105034:	eb 11                	jmp    80105047 <fetchstr+0x37>
80105036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503d:	8d 76 00             	lea    0x0(%esi),%esi
80105040:	83 c0 01             	add    $0x1,%eax
80105043:	39 c2                	cmp    %eax,%edx
80105045:	76 11                	jbe    80105058 <fetchstr+0x48>
    if(*s == 0)
80105047:	80 38 00             	cmpb   $0x0,(%eax)
8010504a:	75 f4                	jne    80105040 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010504c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010504f:	29 d8                	sub    %ebx,%eax
}
80105051:	5b                   	pop    %ebx
80105052:	5d                   	pop    %ebp
80105053:	c3                   	ret    
80105054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105058:	83 c4 04             	add    $0x4,%esp
    return -1;
8010505b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105060:	5b                   	pop    %ebx
80105061:	5d                   	pop    %ebp
80105062:	c3                   	ret    
80105063:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010506a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105070 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105070:	f3 0f 1e fb          	endbr32 
80105074:	55                   	push   %ebp
80105075:	89 e5                	mov    %esp,%ebp
80105077:	56                   	push   %esi
80105078:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105079:	e8 72 eb ff ff       	call   80103bf0 <myproc>
8010507e:	8b 55 08             	mov    0x8(%ebp),%edx
80105081:	8b 40 18             	mov    0x18(%eax),%eax
80105084:	8b 40 44             	mov    0x44(%eax),%eax
80105087:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010508a:	e8 61 eb ff ff       	call   80103bf0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010508f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105092:	8b 00                	mov    (%eax),%eax
80105094:	39 c6                	cmp    %eax,%esi
80105096:	73 18                	jae    801050b0 <argint+0x40>
80105098:	8d 53 08             	lea    0x8(%ebx),%edx
8010509b:	39 d0                	cmp    %edx,%eax
8010509d:	72 11                	jb     801050b0 <argint+0x40>
  *ip = *(int*)(addr);
8010509f:	8b 45 0c             	mov    0xc(%ebp),%eax
801050a2:	8b 53 04             	mov    0x4(%ebx),%edx
801050a5:	89 10                	mov    %edx,(%eax)
  return 0;
801050a7:	31 c0                	xor    %eax,%eax
}
801050a9:	5b                   	pop    %ebx
801050aa:	5e                   	pop    %esi
801050ab:	5d                   	pop    %ebp
801050ac:	c3                   	ret    
801050ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050b5:	eb f2                	jmp    801050a9 <argint+0x39>
801050b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050be:	66 90                	xchg   %ax,%ax

801050c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801050c0:	f3 0f 1e fb          	endbr32 
801050c4:	55                   	push   %ebp
801050c5:	89 e5                	mov    %esp,%ebp
801050c7:	56                   	push   %esi
801050c8:	53                   	push   %ebx
801050c9:	83 ec 10             	sub    $0x10,%esp
801050cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801050cf:	e8 1c eb ff ff       	call   80103bf0 <myproc>
 
  if(argint(n, &i) < 0)
801050d4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801050d7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801050d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050dc:	50                   	push   %eax
801050dd:	ff 75 08             	pushl  0x8(%ebp)
801050e0:	e8 8b ff ff ff       	call   80105070 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801050e5:	83 c4 10             	add    $0x10,%esp
801050e8:	85 c0                	test   %eax,%eax
801050ea:	78 24                	js     80105110 <argptr+0x50>
801050ec:	85 db                	test   %ebx,%ebx
801050ee:	78 20                	js     80105110 <argptr+0x50>
801050f0:	8b 16                	mov    (%esi),%edx
801050f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f5:	39 c2                	cmp    %eax,%edx
801050f7:	76 17                	jbe    80105110 <argptr+0x50>
801050f9:	01 c3                	add    %eax,%ebx
801050fb:	39 da                	cmp    %ebx,%edx
801050fd:	72 11                	jb     80105110 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801050ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80105102:	89 02                	mov    %eax,(%edx)
  return 0;
80105104:	31 c0                	xor    %eax,%eax
}
80105106:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105109:	5b                   	pop    %ebx
8010510a:	5e                   	pop    %esi
8010510b:	5d                   	pop    %ebp
8010510c:	c3                   	ret    
8010510d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105115:	eb ef                	jmp    80105106 <argptr+0x46>
80105117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511e:	66 90                	xchg   %ax,%ax

80105120 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105120:	f3 0f 1e fb          	endbr32 
80105124:	55                   	push   %ebp
80105125:	89 e5                	mov    %esp,%ebp
80105127:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010512a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010512d:	50                   	push   %eax
8010512e:	ff 75 08             	pushl  0x8(%ebp)
80105131:	e8 3a ff ff ff       	call   80105070 <argint>
80105136:	83 c4 10             	add    $0x10,%esp
80105139:	85 c0                	test   %eax,%eax
8010513b:	78 13                	js     80105150 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010513d:	83 ec 08             	sub    $0x8,%esp
80105140:	ff 75 0c             	pushl  0xc(%ebp)
80105143:	ff 75 f4             	pushl  -0xc(%ebp)
80105146:	e8 c5 fe ff ff       	call   80105010 <fetchstr>
8010514b:	83 c4 10             	add    $0x10,%esp
}
8010514e:	c9                   	leave  
8010514f:	c3                   	ret    
80105150:	c9                   	leave  
    return -1;
80105151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105156:	c3                   	ret    
80105157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515e:	66 90                	xchg   %ax,%ax

80105160 <syscall>:
[SYS_proc_info] sys_proc_info
};

void
syscall(void)
{
80105160:	f3 0f 1e fb          	endbr32 
80105164:	55                   	push   %ebp
80105165:	89 e5                	mov    %esp,%ebp
80105167:	53                   	push   %ebx
80105168:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010516b:	e8 80 ea ff ff       	call   80103bf0 <myproc>
80105170:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105172:	8b 40 18             	mov    0x18(%eax),%eax
80105175:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105178:	8d 50 ff             	lea    -0x1(%eax),%edx
8010517b:	83 fa 19             	cmp    $0x19,%edx
8010517e:	77 20                	ja     801051a0 <syscall+0x40>
80105180:	8b 14 85 00 80 10 80 	mov    -0x7fef8000(,%eax,4),%edx
80105187:	85 d2                	test   %edx,%edx
80105189:	74 15                	je     801051a0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010518b:	ff d2                	call   *%edx
8010518d:	89 c2                	mov    %eax,%edx
8010518f:	8b 43 18             	mov    0x18(%ebx),%eax
80105192:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105195:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105198:	c9                   	leave  
80105199:	c3                   	ret    
8010519a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801051a0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801051a1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801051a4:	50                   	push   %eax
801051a5:	ff 73 10             	pushl  0x10(%ebx)
801051a8:	68 e1 7f 10 80       	push   $0x80107fe1
801051ad:	e8 fe b4 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801051b2:	8b 43 18             	mov    0x18(%ebx),%eax
801051b5:	83 c4 10             	add    $0x10,%esp
801051b8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801051bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051c2:	c9                   	leave  
801051c3:	c3                   	ret    
801051c4:	66 90                	xchg   %ax,%ax
801051c6:	66 90                	xchg   %ax,%ax
801051c8:	66 90                	xchg   %ax,%ax
801051ca:	66 90                	xchg   %ax,%ax
801051cc:	66 90                	xchg   %ax,%ax
801051ce:	66 90                	xchg   %ax,%ax

801051d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	57                   	push   %edi
801051d4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801051d5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801051d8:	53                   	push   %ebx
801051d9:	83 ec 34             	sub    $0x34,%esp
801051dc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801051df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801051e2:	57                   	push   %edi
801051e3:	50                   	push   %eax
{
801051e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801051e7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801051ea:	e8 61 ce ff ff       	call   80102050 <nameiparent>
801051ef:	83 c4 10             	add    $0x10,%esp
801051f2:	85 c0                	test   %eax,%eax
801051f4:	0f 84 46 01 00 00    	je     80105340 <create+0x170>
    return 0;
  ilock(dp);
801051fa:	83 ec 0c             	sub    $0xc,%esp
801051fd:	89 c3                	mov    %eax,%ebx
801051ff:	50                   	push   %eax
80105200:	e8 5b c5 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105205:	83 c4 0c             	add    $0xc,%esp
80105208:	6a 00                	push   $0x0
8010520a:	57                   	push   %edi
8010520b:	53                   	push   %ebx
8010520c:	e8 9f ca ff ff       	call   80101cb0 <dirlookup>
80105211:	83 c4 10             	add    $0x10,%esp
80105214:	89 c6                	mov    %eax,%esi
80105216:	85 c0                	test   %eax,%eax
80105218:	74 56                	je     80105270 <create+0xa0>
    iunlockput(dp);
8010521a:	83 ec 0c             	sub    $0xc,%esp
8010521d:	53                   	push   %ebx
8010521e:	e8 dd c7 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80105223:	89 34 24             	mov    %esi,(%esp)
80105226:	e8 35 c5 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010522b:	83 c4 10             	add    $0x10,%esp
8010522e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105233:	75 1b                	jne    80105250 <create+0x80>
80105235:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010523a:	75 14                	jne    80105250 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010523c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010523f:	89 f0                	mov    %esi,%eax
80105241:	5b                   	pop    %ebx
80105242:	5e                   	pop    %esi
80105243:	5f                   	pop    %edi
80105244:	5d                   	pop    %ebp
80105245:	c3                   	ret    
80105246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105250:	83 ec 0c             	sub    $0xc,%esp
80105253:	56                   	push   %esi
    return 0;
80105254:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105256:	e8 a5 c7 ff ff       	call   80101a00 <iunlockput>
    return 0;
8010525b:	83 c4 10             	add    $0x10,%esp
}
8010525e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105261:	89 f0                	mov    %esi,%eax
80105263:	5b                   	pop    %ebx
80105264:	5e                   	pop    %esi
80105265:	5f                   	pop    %edi
80105266:	5d                   	pop    %ebp
80105267:	c3                   	ret    
80105268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105270:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105274:	83 ec 08             	sub    $0x8,%esp
80105277:	50                   	push   %eax
80105278:	ff 33                	pushl  (%ebx)
8010527a:	e8 61 c3 ff ff       	call   801015e0 <ialloc>
8010527f:	83 c4 10             	add    $0x10,%esp
80105282:	89 c6                	mov    %eax,%esi
80105284:	85 c0                	test   %eax,%eax
80105286:	0f 84 cd 00 00 00    	je     80105359 <create+0x189>
  ilock(ip);
8010528c:	83 ec 0c             	sub    $0xc,%esp
8010528f:	50                   	push   %eax
80105290:	e8 cb c4 ff ff       	call   80101760 <ilock>
  ip->major = major;
80105295:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105299:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010529d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801052a1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801052a5:	b8 01 00 00 00       	mov    $0x1,%eax
801052aa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801052ae:	89 34 24             	mov    %esi,(%esp)
801052b1:	e8 ea c3 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801052b6:	83 c4 10             	add    $0x10,%esp
801052b9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801052be:	74 30                	je     801052f0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801052c0:	83 ec 04             	sub    $0x4,%esp
801052c3:	ff 76 04             	pushl  0x4(%esi)
801052c6:	57                   	push   %edi
801052c7:	53                   	push   %ebx
801052c8:	e8 a3 cc ff ff       	call   80101f70 <dirlink>
801052cd:	83 c4 10             	add    $0x10,%esp
801052d0:	85 c0                	test   %eax,%eax
801052d2:	78 78                	js     8010534c <create+0x17c>
  iunlockput(dp);
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	53                   	push   %ebx
801052d8:	e8 23 c7 ff ff       	call   80101a00 <iunlockput>
  return ip;
801052dd:	83 c4 10             	add    $0x10,%esp
}
801052e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052e3:	89 f0                	mov    %esi,%eax
801052e5:	5b                   	pop    %ebx
801052e6:	5e                   	pop    %esi
801052e7:	5f                   	pop    %edi
801052e8:	5d                   	pop    %ebp
801052e9:	c3                   	ret    
801052ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801052f0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801052f3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801052f8:	53                   	push   %ebx
801052f9:	e8 a2 c3 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801052fe:	83 c4 0c             	add    $0xc,%esp
80105301:	ff 76 04             	pushl  0x4(%esi)
80105304:	68 88 80 10 80       	push   $0x80108088
80105309:	56                   	push   %esi
8010530a:	e8 61 cc ff ff       	call   80101f70 <dirlink>
8010530f:	83 c4 10             	add    $0x10,%esp
80105312:	85 c0                	test   %eax,%eax
80105314:	78 18                	js     8010532e <create+0x15e>
80105316:	83 ec 04             	sub    $0x4,%esp
80105319:	ff 73 04             	pushl  0x4(%ebx)
8010531c:	68 87 80 10 80       	push   $0x80108087
80105321:	56                   	push   %esi
80105322:	e8 49 cc ff ff       	call   80101f70 <dirlink>
80105327:	83 c4 10             	add    $0x10,%esp
8010532a:	85 c0                	test   %eax,%eax
8010532c:	79 92                	jns    801052c0 <create+0xf0>
      panic("create dots");
8010532e:	83 ec 0c             	sub    $0xc,%esp
80105331:	68 7b 80 10 80       	push   $0x8010807b
80105336:	e8 55 b0 ff ff       	call   80100390 <panic>
8010533b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010533f:	90                   	nop
}
80105340:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105343:	31 f6                	xor    %esi,%esi
}
80105345:	5b                   	pop    %ebx
80105346:	89 f0                	mov    %esi,%eax
80105348:	5e                   	pop    %esi
80105349:	5f                   	pop    %edi
8010534a:	5d                   	pop    %ebp
8010534b:	c3                   	ret    
    panic("create: dirlink");
8010534c:	83 ec 0c             	sub    $0xc,%esp
8010534f:	68 8a 80 10 80       	push   $0x8010808a
80105354:	e8 37 b0 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105359:	83 ec 0c             	sub    $0xc,%esp
8010535c:	68 6c 80 10 80       	push   $0x8010806c
80105361:	e8 2a b0 ff ff       	call   80100390 <panic>
80105366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536d:	8d 76 00             	lea    0x0(%esi),%esi

80105370 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	56                   	push   %esi
80105374:	89 d6                	mov    %edx,%esi
80105376:	53                   	push   %ebx
80105377:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105379:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010537c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010537f:	50                   	push   %eax
80105380:	6a 00                	push   $0x0
80105382:	e8 e9 fc ff ff       	call   80105070 <argint>
80105387:	83 c4 10             	add    $0x10,%esp
8010538a:	85 c0                	test   %eax,%eax
8010538c:	78 2a                	js     801053b8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010538e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105392:	77 24                	ja     801053b8 <argfd.constprop.0+0x48>
80105394:	e8 57 e8 ff ff       	call   80103bf0 <myproc>
80105399:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010539c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801053a0:	85 c0                	test   %eax,%eax
801053a2:	74 14                	je     801053b8 <argfd.constprop.0+0x48>
  if(pfd)
801053a4:	85 db                	test   %ebx,%ebx
801053a6:	74 02                	je     801053aa <argfd.constprop.0+0x3a>
    *pfd = fd;
801053a8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801053aa:	89 06                	mov    %eax,(%esi)
  return 0;
801053ac:	31 c0                	xor    %eax,%eax
}
801053ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053b1:	5b                   	pop    %ebx
801053b2:	5e                   	pop    %esi
801053b3:	5d                   	pop    %ebp
801053b4:	c3                   	ret    
801053b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801053b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053bd:	eb ef                	jmp    801053ae <argfd.constprop.0+0x3e>
801053bf:	90                   	nop

801053c0 <sys_dup>:
{
801053c0:	f3 0f 1e fb          	endbr32 
801053c4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801053c5:	31 c0                	xor    %eax,%eax
{
801053c7:	89 e5                	mov    %esp,%ebp
801053c9:	56                   	push   %esi
801053ca:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801053cb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801053ce:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801053d1:	e8 9a ff ff ff       	call   80105370 <argfd.constprop.0>
801053d6:	85 c0                	test   %eax,%eax
801053d8:	78 1e                	js     801053f8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801053da:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801053dd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801053df:	e8 0c e8 ff ff       	call   80103bf0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801053e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801053e8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053ec:	85 d2                	test   %edx,%edx
801053ee:	74 20                	je     80105410 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801053f0:	83 c3 01             	add    $0x1,%ebx
801053f3:	83 fb 10             	cmp    $0x10,%ebx
801053f6:	75 f0                	jne    801053e8 <sys_dup+0x28>
}
801053f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801053fb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105400:	89 d8                	mov    %ebx,%eax
80105402:	5b                   	pop    %ebx
80105403:	5e                   	pop    %esi
80105404:	5d                   	pop    %ebp
80105405:	c3                   	ret    
80105406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010540d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105410:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105414:	83 ec 0c             	sub    $0xc,%esp
80105417:	ff 75 f4             	pushl  -0xc(%ebp)
8010541a:	e8 51 ba ff ff       	call   80100e70 <filedup>
  return fd;
8010541f:	83 c4 10             	add    $0x10,%esp
}
80105422:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105425:	89 d8                	mov    %ebx,%eax
80105427:	5b                   	pop    %ebx
80105428:	5e                   	pop    %esi
80105429:	5d                   	pop    %ebp
8010542a:	c3                   	ret    
8010542b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010542f:	90                   	nop

80105430 <sys_read>:
{
80105430:	f3 0f 1e fb          	endbr32 
80105434:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105435:	31 c0                	xor    %eax,%eax
{
80105437:	89 e5                	mov    %esp,%ebp
80105439:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010543c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010543f:	e8 2c ff ff ff       	call   80105370 <argfd.constprop.0>
80105444:	85 c0                	test   %eax,%eax
80105446:	78 48                	js     80105490 <sys_read+0x60>
80105448:	83 ec 08             	sub    $0x8,%esp
8010544b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010544e:	50                   	push   %eax
8010544f:	6a 02                	push   $0x2
80105451:	e8 1a fc ff ff       	call   80105070 <argint>
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	85 c0                	test   %eax,%eax
8010545b:	78 33                	js     80105490 <sys_read+0x60>
8010545d:	83 ec 04             	sub    $0x4,%esp
80105460:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105463:	ff 75 f0             	pushl  -0x10(%ebp)
80105466:	50                   	push   %eax
80105467:	6a 01                	push   $0x1
80105469:	e8 52 fc ff ff       	call   801050c0 <argptr>
8010546e:	83 c4 10             	add    $0x10,%esp
80105471:	85 c0                	test   %eax,%eax
80105473:	78 1b                	js     80105490 <sys_read+0x60>
  return fileread(f, p, n);
80105475:	83 ec 04             	sub    $0x4,%esp
80105478:	ff 75 f0             	pushl  -0x10(%ebp)
8010547b:	ff 75 f4             	pushl  -0xc(%ebp)
8010547e:	ff 75 ec             	pushl  -0x14(%ebp)
80105481:	e8 6a bb ff ff       	call   80100ff0 <fileread>
80105486:	83 c4 10             	add    $0x10,%esp
}
80105489:	c9                   	leave  
8010548a:	c3                   	ret    
8010548b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010548f:	90                   	nop
80105490:	c9                   	leave  
    return -1;
80105491:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105496:	c3                   	ret    
80105497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010549e:	66 90                	xchg   %ax,%ax

801054a0 <sys_write>:
{
801054a0:	f3 0f 1e fb          	endbr32 
801054a4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054a5:	31 c0                	xor    %eax,%eax
{
801054a7:	89 e5                	mov    %esp,%ebp
801054a9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054ac:	8d 55 ec             	lea    -0x14(%ebp),%edx
801054af:	e8 bc fe ff ff       	call   80105370 <argfd.constprop.0>
801054b4:	85 c0                	test   %eax,%eax
801054b6:	78 48                	js     80105500 <sys_write+0x60>
801054b8:	83 ec 08             	sub    $0x8,%esp
801054bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054be:	50                   	push   %eax
801054bf:	6a 02                	push   $0x2
801054c1:	e8 aa fb ff ff       	call   80105070 <argint>
801054c6:	83 c4 10             	add    $0x10,%esp
801054c9:	85 c0                	test   %eax,%eax
801054cb:	78 33                	js     80105500 <sys_write+0x60>
801054cd:	83 ec 04             	sub    $0x4,%esp
801054d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054d3:	ff 75 f0             	pushl  -0x10(%ebp)
801054d6:	50                   	push   %eax
801054d7:	6a 01                	push   $0x1
801054d9:	e8 e2 fb ff ff       	call   801050c0 <argptr>
801054de:	83 c4 10             	add    $0x10,%esp
801054e1:	85 c0                	test   %eax,%eax
801054e3:	78 1b                	js     80105500 <sys_write+0x60>
  return filewrite(f, p, n);
801054e5:	83 ec 04             	sub    $0x4,%esp
801054e8:	ff 75 f0             	pushl  -0x10(%ebp)
801054eb:	ff 75 f4             	pushl  -0xc(%ebp)
801054ee:	ff 75 ec             	pushl  -0x14(%ebp)
801054f1:	e8 9a bb ff ff       	call   80101090 <filewrite>
801054f6:	83 c4 10             	add    $0x10,%esp
}
801054f9:	c9                   	leave  
801054fa:	c3                   	ret    
801054fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054ff:	90                   	nop
80105500:	c9                   	leave  
    return -1;
80105501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105506:	c3                   	ret    
80105507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550e:	66 90                	xchg   %ax,%ax

80105510 <sys_close>:
{
80105510:	f3 0f 1e fb          	endbr32 
80105514:	55                   	push   %ebp
80105515:	89 e5                	mov    %esp,%ebp
80105517:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010551a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010551d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105520:	e8 4b fe ff ff       	call   80105370 <argfd.constprop.0>
80105525:	85 c0                	test   %eax,%eax
80105527:	78 27                	js     80105550 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105529:	e8 c2 e6 ff ff       	call   80103bf0 <myproc>
8010552e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105531:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105534:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010553b:	00 
  fileclose(f);
8010553c:	ff 75 f4             	pushl  -0xc(%ebp)
8010553f:	e8 7c b9 ff ff       	call   80100ec0 <fileclose>
  return 0;
80105544:	83 c4 10             	add    $0x10,%esp
80105547:	31 c0                	xor    %eax,%eax
}
80105549:	c9                   	leave  
8010554a:	c3                   	ret    
8010554b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop
80105550:	c9                   	leave  
    return -1;
80105551:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105556:	c3                   	ret    
80105557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010555e:	66 90                	xchg   %ax,%ax

80105560 <sys_fstat>:
{
80105560:	f3 0f 1e fb          	endbr32 
80105564:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105565:	31 c0                	xor    %eax,%eax
{
80105567:	89 e5                	mov    %esp,%ebp
80105569:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010556c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010556f:	e8 fc fd ff ff       	call   80105370 <argfd.constprop.0>
80105574:	85 c0                	test   %eax,%eax
80105576:	78 30                	js     801055a8 <sys_fstat+0x48>
80105578:	83 ec 04             	sub    $0x4,%esp
8010557b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010557e:	6a 14                	push   $0x14
80105580:	50                   	push   %eax
80105581:	6a 01                	push   $0x1
80105583:	e8 38 fb ff ff       	call   801050c0 <argptr>
80105588:	83 c4 10             	add    $0x10,%esp
8010558b:	85 c0                	test   %eax,%eax
8010558d:	78 19                	js     801055a8 <sys_fstat+0x48>
  return filestat(f, st);
8010558f:	83 ec 08             	sub    $0x8,%esp
80105592:	ff 75 f4             	pushl  -0xc(%ebp)
80105595:	ff 75 f0             	pushl  -0x10(%ebp)
80105598:	e8 03 ba ff ff       	call   80100fa0 <filestat>
8010559d:	83 c4 10             	add    $0x10,%esp
}
801055a0:	c9                   	leave  
801055a1:	c3                   	ret    
801055a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055a8:	c9                   	leave  
    return -1;
801055a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ae:	c3                   	ret    
801055af:	90                   	nop

801055b0 <sys_link>:
{
801055b0:	f3 0f 1e fb          	endbr32 
801055b4:	55                   	push   %ebp
801055b5:	89 e5                	mov    %esp,%ebp
801055b7:	57                   	push   %edi
801055b8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055b9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801055bc:	53                   	push   %ebx
801055bd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055c0:	50                   	push   %eax
801055c1:	6a 00                	push   $0x0
801055c3:	e8 58 fb ff ff       	call   80105120 <argstr>
801055c8:	83 c4 10             	add    $0x10,%esp
801055cb:	85 c0                	test   %eax,%eax
801055cd:	0f 88 ff 00 00 00    	js     801056d2 <sys_link+0x122>
801055d3:	83 ec 08             	sub    $0x8,%esp
801055d6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801055d9:	50                   	push   %eax
801055da:	6a 01                	push   $0x1
801055dc:	e8 3f fb ff ff       	call   80105120 <argstr>
801055e1:	83 c4 10             	add    $0x10,%esp
801055e4:	85 c0                	test   %eax,%eax
801055e6:	0f 88 e6 00 00 00    	js     801056d2 <sys_link+0x122>
  begin_op();
801055ec:	e8 3f d7 ff ff       	call   80102d30 <begin_op>
  if((ip = namei(old)) == 0){
801055f1:	83 ec 0c             	sub    $0xc,%esp
801055f4:	ff 75 d4             	pushl  -0x2c(%ebp)
801055f7:	e8 34 ca ff ff       	call   80102030 <namei>
801055fc:	83 c4 10             	add    $0x10,%esp
801055ff:	89 c3                	mov    %eax,%ebx
80105601:	85 c0                	test   %eax,%eax
80105603:	0f 84 e8 00 00 00    	je     801056f1 <sys_link+0x141>
  ilock(ip);
80105609:	83 ec 0c             	sub    $0xc,%esp
8010560c:	50                   	push   %eax
8010560d:	e8 4e c1 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105612:	83 c4 10             	add    $0x10,%esp
80105615:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010561a:	0f 84 b9 00 00 00    	je     801056d9 <sys_link+0x129>
  iupdate(ip);
80105620:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105623:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105628:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010562b:	53                   	push   %ebx
8010562c:	e8 6f c0 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105631:	89 1c 24             	mov    %ebx,(%esp)
80105634:	e8 07 c2 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105639:	58                   	pop    %eax
8010563a:	5a                   	pop    %edx
8010563b:	57                   	push   %edi
8010563c:	ff 75 d0             	pushl  -0x30(%ebp)
8010563f:	e8 0c ca ff ff       	call   80102050 <nameiparent>
80105644:	83 c4 10             	add    $0x10,%esp
80105647:	89 c6                	mov    %eax,%esi
80105649:	85 c0                	test   %eax,%eax
8010564b:	74 5f                	je     801056ac <sys_link+0xfc>
  ilock(dp);
8010564d:	83 ec 0c             	sub    $0xc,%esp
80105650:	50                   	push   %eax
80105651:	e8 0a c1 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105656:	8b 03                	mov    (%ebx),%eax
80105658:	83 c4 10             	add    $0x10,%esp
8010565b:	39 06                	cmp    %eax,(%esi)
8010565d:	75 41                	jne    801056a0 <sys_link+0xf0>
8010565f:	83 ec 04             	sub    $0x4,%esp
80105662:	ff 73 04             	pushl  0x4(%ebx)
80105665:	57                   	push   %edi
80105666:	56                   	push   %esi
80105667:	e8 04 c9 ff ff       	call   80101f70 <dirlink>
8010566c:	83 c4 10             	add    $0x10,%esp
8010566f:	85 c0                	test   %eax,%eax
80105671:	78 2d                	js     801056a0 <sys_link+0xf0>
  iunlockput(dp);
80105673:	83 ec 0c             	sub    $0xc,%esp
80105676:	56                   	push   %esi
80105677:	e8 84 c3 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
8010567c:	89 1c 24             	mov    %ebx,(%esp)
8010567f:	e8 0c c2 ff ff       	call   80101890 <iput>
  end_op();
80105684:	e8 17 d7 ff ff       	call   80102da0 <end_op>
  return 0;
80105689:	83 c4 10             	add    $0x10,%esp
8010568c:	31 c0                	xor    %eax,%eax
}
8010568e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105691:	5b                   	pop    %ebx
80105692:	5e                   	pop    %esi
80105693:	5f                   	pop    %edi
80105694:	5d                   	pop    %ebp
80105695:	c3                   	ret    
80105696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	56                   	push   %esi
801056a4:	e8 57 c3 ff ff       	call   80101a00 <iunlockput>
    goto bad;
801056a9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801056ac:	83 ec 0c             	sub    $0xc,%esp
801056af:	53                   	push   %ebx
801056b0:	e8 ab c0 ff ff       	call   80101760 <ilock>
  ip->nlink--;
801056b5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801056ba:	89 1c 24             	mov    %ebx,(%esp)
801056bd:	e8 de bf ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
801056c2:	89 1c 24             	mov    %ebx,(%esp)
801056c5:	e8 36 c3 ff ff       	call   80101a00 <iunlockput>
  end_op();
801056ca:	e8 d1 d6 ff ff       	call   80102da0 <end_op>
  return -1;
801056cf:	83 c4 10             	add    $0x10,%esp
801056d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d7:	eb b5                	jmp    8010568e <sys_link+0xde>
    iunlockput(ip);
801056d9:	83 ec 0c             	sub    $0xc,%esp
801056dc:	53                   	push   %ebx
801056dd:	e8 1e c3 ff ff       	call   80101a00 <iunlockput>
    end_op();
801056e2:	e8 b9 d6 ff ff       	call   80102da0 <end_op>
    return -1;
801056e7:	83 c4 10             	add    $0x10,%esp
801056ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ef:	eb 9d                	jmp    8010568e <sys_link+0xde>
    end_op();
801056f1:	e8 aa d6 ff ff       	call   80102da0 <end_op>
    return -1;
801056f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056fb:	eb 91                	jmp    8010568e <sys_link+0xde>
801056fd:	8d 76 00             	lea    0x0(%esi),%esi

80105700 <sys_unlink>:
{
80105700:	f3 0f 1e fb          	endbr32 
80105704:	55                   	push   %ebp
80105705:	89 e5                	mov    %esp,%ebp
80105707:	57                   	push   %edi
80105708:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105709:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010570c:	53                   	push   %ebx
8010570d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105710:	50                   	push   %eax
80105711:	6a 00                	push   $0x0
80105713:	e8 08 fa ff ff       	call   80105120 <argstr>
80105718:	83 c4 10             	add    $0x10,%esp
8010571b:	85 c0                	test   %eax,%eax
8010571d:	0f 88 7d 01 00 00    	js     801058a0 <sys_unlink+0x1a0>
  begin_op();
80105723:	e8 08 d6 ff ff       	call   80102d30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105728:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010572b:	83 ec 08             	sub    $0x8,%esp
8010572e:	53                   	push   %ebx
8010572f:	ff 75 c0             	pushl  -0x40(%ebp)
80105732:	e8 19 c9 ff ff       	call   80102050 <nameiparent>
80105737:	83 c4 10             	add    $0x10,%esp
8010573a:	89 c6                	mov    %eax,%esi
8010573c:	85 c0                	test   %eax,%eax
8010573e:	0f 84 66 01 00 00    	je     801058aa <sys_unlink+0x1aa>
  ilock(dp);
80105744:	83 ec 0c             	sub    $0xc,%esp
80105747:	50                   	push   %eax
80105748:	e8 13 c0 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010574d:	58                   	pop    %eax
8010574e:	5a                   	pop    %edx
8010574f:	68 88 80 10 80       	push   $0x80108088
80105754:	53                   	push   %ebx
80105755:	e8 36 c5 ff ff       	call   80101c90 <namecmp>
8010575a:	83 c4 10             	add    $0x10,%esp
8010575d:	85 c0                	test   %eax,%eax
8010575f:	0f 84 03 01 00 00    	je     80105868 <sys_unlink+0x168>
80105765:	83 ec 08             	sub    $0x8,%esp
80105768:	68 87 80 10 80       	push   $0x80108087
8010576d:	53                   	push   %ebx
8010576e:	e8 1d c5 ff ff       	call   80101c90 <namecmp>
80105773:	83 c4 10             	add    $0x10,%esp
80105776:	85 c0                	test   %eax,%eax
80105778:	0f 84 ea 00 00 00    	je     80105868 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010577e:	83 ec 04             	sub    $0x4,%esp
80105781:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105784:	50                   	push   %eax
80105785:	53                   	push   %ebx
80105786:	56                   	push   %esi
80105787:	e8 24 c5 ff ff       	call   80101cb0 <dirlookup>
8010578c:	83 c4 10             	add    $0x10,%esp
8010578f:	89 c3                	mov    %eax,%ebx
80105791:	85 c0                	test   %eax,%eax
80105793:	0f 84 cf 00 00 00    	je     80105868 <sys_unlink+0x168>
  ilock(ip);
80105799:	83 ec 0c             	sub    $0xc,%esp
8010579c:	50                   	push   %eax
8010579d:	e8 be bf ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801057aa:	0f 8e 23 01 00 00    	jle    801058d3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801057b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801057b8:	74 66                	je     80105820 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801057ba:	83 ec 04             	sub    $0x4,%esp
801057bd:	6a 10                	push   $0x10
801057bf:	6a 00                	push   $0x0
801057c1:	57                   	push   %edi
801057c2:	e8 c9 f5 ff ff       	call   80104d90 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057c7:	6a 10                	push   $0x10
801057c9:	ff 75 c4             	pushl  -0x3c(%ebp)
801057cc:	57                   	push   %edi
801057cd:	56                   	push   %esi
801057ce:	e8 8d c3 ff ff       	call   80101b60 <writei>
801057d3:	83 c4 20             	add    $0x20,%esp
801057d6:	83 f8 10             	cmp    $0x10,%eax
801057d9:	0f 85 e7 00 00 00    	jne    801058c6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801057df:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057e4:	0f 84 96 00 00 00    	je     80105880 <sys_unlink+0x180>
  iunlockput(dp);
801057ea:	83 ec 0c             	sub    $0xc,%esp
801057ed:	56                   	push   %esi
801057ee:	e8 0d c2 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
801057f3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057f8:	89 1c 24             	mov    %ebx,(%esp)
801057fb:	e8 a0 be ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105800:	89 1c 24             	mov    %ebx,(%esp)
80105803:	e8 f8 c1 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105808:	e8 93 d5 ff ff       	call   80102da0 <end_op>
  return 0;
8010580d:	83 c4 10             	add    $0x10,%esp
80105810:	31 c0                	xor    %eax,%eax
}
80105812:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105815:	5b                   	pop    %ebx
80105816:	5e                   	pop    %esi
80105817:	5f                   	pop    %edi
80105818:	5d                   	pop    %ebp
80105819:	c3                   	ret    
8010581a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105820:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105824:	76 94                	jbe    801057ba <sys_unlink+0xba>
80105826:	ba 20 00 00 00       	mov    $0x20,%edx
8010582b:	eb 0b                	jmp    80105838 <sys_unlink+0x138>
8010582d:	8d 76 00             	lea    0x0(%esi),%esi
80105830:	83 c2 10             	add    $0x10,%edx
80105833:	39 53 58             	cmp    %edx,0x58(%ebx)
80105836:	76 82                	jbe    801057ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105838:	6a 10                	push   $0x10
8010583a:	52                   	push   %edx
8010583b:	57                   	push   %edi
8010583c:	53                   	push   %ebx
8010583d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105840:	e8 1b c2 ff ff       	call   80101a60 <readi>
80105845:	83 c4 10             	add    $0x10,%esp
80105848:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010584b:	83 f8 10             	cmp    $0x10,%eax
8010584e:	75 69                	jne    801058b9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105850:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105855:	74 d9                	je     80105830 <sys_unlink+0x130>
    iunlockput(ip);
80105857:	83 ec 0c             	sub    $0xc,%esp
8010585a:	53                   	push   %ebx
8010585b:	e8 a0 c1 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105860:	83 c4 10             	add    $0x10,%esp
80105863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105867:	90                   	nop
  iunlockput(dp);
80105868:	83 ec 0c             	sub    $0xc,%esp
8010586b:	56                   	push   %esi
8010586c:	e8 8f c1 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105871:	e8 2a d5 ff ff       	call   80102da0 <end_op>
  return -1;
80105876:	83 c4 10             	add    $0x10,%esp
80105879:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010587e:	eb 92                	jmp    80105812 <sys_unlink+0x112>
    iupdate(dp);
80105880:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105883:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105888:	56                   	push   %esi
80105889:	e8 12 be ff ff       	call   801016a0 <iupdate>
8010588e:	83 c4 10             	add    $0x10,%esp
80105891:	e9 54 ff ff ff       	jmp    801057ea <sys_unlink+0xea>
80105896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801058a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a5:	e9 68 ff ff ff       	jmp    80105812 <sys_unlink+0x112>
    end_op();
801058aa:	e8 f1 d4 ff ff       	call   80102da0 <end_op>
    return -1;
801058af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b4:	e9 59 ff ff ff       	jmp    80105812 <sys_unlink+0x112>
      panic("isdirempty: readi");
801058b9:	83 ec 0c             	sub    $0xc,%esp
801058bc:	68 ac 80 10 80       	push   $0x801080ac
801058c1:	e8 ca aa ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801058c6:	83 ec 0c             	sub    $0xc,%esp
801058c9:	68 be 80 10 80       	push   $0x801080be
801058ce:	e8 bd aa ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801058d3:	83 ec 0c             	sub    $0xc,%esp
801058d6:	68 9a 80 10 80       	push   $0x8010809a
801058db:	e8 b0 aa ff ff       	call   80100390 <panic>

801058e0 <sys_open>:

int
sys_open(void)
{
801058e0:	f3 0f 1e fb          	endbr32 
801058e4:	55                   	push   %ebp
801058e5:	89 e5                	mov    %esp,%ebp
801058e7:	57                   	push   %edi
801058e8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801058ec:	53                   	push   %ebx
801058ed:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801058f0:	50                   	push   %eax
801058f1:	6a 00                	push   $0x0
801058f3:	e8 28 f8 ff ff       	call   80105120 <argstr>
801058f8:	83 c4 10             	add    $0x10,%esp
801058fb:	85 c0                	test   %eax,%eax
801058fd:	0f 88 8a 00 00 00    	js     8010598d <sys_open+0xad>
80105903:	83 ec 08             	sub    $0x8,%esp
80105906:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105909:	50                   	push   %eax
8010590a:	6a 01                	push   $0x1
8010590c:	e8 5f f7 ff ff       	call   80105070 <argint>
80105911:	83 c4 10             	add    $0x10,%esp
80105914:	85 c0                	test   %eax,%eax
80105916:	78 75                	js     8010598d <sys_open+0xad>
    return -1;

  begin_op();
80105918:	e8 13 d4 ff ff       	call   80102d30 <begin_op>

  if(omode & O_CREATE){
8010591d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105921:	75 75                	jne    80105998 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105923:	83 ec 0c             	sub    $0xc,%esp
80105926:	ff 75 e0             	pushl  -0x20(%ebp)
80105929:	e8 02 c7 ff ff       	call   80102030 <namei>
8010592e:	83 c4 10             	add    $0x10,%esp
80105931:	89 c6                	mov    %eax,%esi
80105933:	85 c0                	test   %eax,%eax
80105935:	74 7e                	je     801059b5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105937:	83 ec 0c             	sub    $0xc,%esp
8010593a:	50                   	push   %eax
8010593b:	e8 20 be ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105940:	83 c4 10             	add    $0x10,%esp
80105943:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105948:	0f 84 c2 00 00 00    	je     80105a10 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010594e:	e8 ad b4 ff ff       	call   80100e00 <filealloc>
80105953:	89 c7                	mov    %eax,%edi
80105955:	85 c0                	test   %eax,%eax
80105957:	74 23                	je     8010597c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105959:	e8 92 e2 ff ff       	call   80103bf0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010595e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105960:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105964:	85 d2                	test   %edx,%edx
80105966:	74 60                	je     801059c8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105968:	83 c3 01             	add    $0x1,%ebx
8010596b:	83 fb 10             	cmp    $0x10,%ebx
8010596e:	75 f0                	jne    80105960 <sys_open+0x80>
    if(f)
      fileclose(f);
80105970:	83 ec 0c             	sub    $0xc,%esp
80105973:	57                   	push   %edi
80105974:	e8 47 b5 ff ff       	call   80100ec0 <fileclose>
80105979:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010597c:	83 ec 0c             	sub    $0xc,%esp
8010597f:	56                   	push   %esi
80105980:	e8 7b c0 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105985:	e8 16 d4 ff ff       	call   80102da0 <end_op>
    return -1;
8010598a:	83 c4 10             	add    $0x10,%esp
8010598d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105992:	eb 6d                	jmp    80105a01 <sys_open+0x121>
80105994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105998:	83 ec 0c             	sub    $0xc,%esp
8010599b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010599e:	31 c9                	xor    %ecx,%ecx
801059a0:	ba 02 00 00 00       	mov    $0x2,%edx
801059a5:	6a 00                	push   $0x0
801059a7:	e8 24 f8 ff ff       	call   801051d0 <create>
    if(ip == 0){
801059ac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801059af:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801059b1:	85 c0                	test   %eax,%eax
801059b3:	75 99                	jne    8010594e <sys_open+0x6e>
      end_op();
801059b5:	e8 e6 d3 ff ff       	call   80102da0 <end_op>
      return -1;
801059ba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059bf:	eb 40                	jmp    80105a01 <sys_open+0x121>
801059c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801059c8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801059cb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801059cf:	56                   	push   %esi
801059d0:	e8 6b be ff ff       	call   80101840 <iunlock>
  end_op();
801059d5:	e8 c6 d3 ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
801059da:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801059e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059e3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801059e6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801059e9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801059eb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801059f2:	f7 d0                	not    %eax
801059f4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059f7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801059fa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801059fd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105a01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a04:	89 d8                	mov    %ebx,%eax
80105a06:	5b                   	pop    %ebx
80105a07:	5e                   	pop    %esi
80105a08:	5f                   	pop    %edi
80105a09:	5d                   	pop    %ebp
80105a0a:	c3                   	ret    
80105a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a0f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a10:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105a13:	85 c9                	test   %ecx,%ecx
80105a15:	0f 84 33 ff ff ff    	je     8010594e <sys_open+0x6e>
80105a1b:	e9 5c ff ff ff       	jmp    8010597c <sys_open+0x9c>

80105a20 <sys_mkdir>:

int
sys_mkdir(void)
{
80105a20:	f3 0f 1e fb          	endbr32 
80105a24:	55                   	push   %ebp
80105a25:	89 e5                	mov    %esp,%ebp
80105a27:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105a2a:	e8 01 d3 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105a2f:	83 ec 08             	sub    $0x8,%esp
80105a32:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a35:	50                   	push   %eax
80105a36:	6a 00                	push   $0x0
80105a38:	e8 e3 f6 ff ff       	call   80105120 <argstr>
80105a3d:	83 c4 10             	add    $0x10,%esp
80105a40:	85 c0                	test   %eax,%eax
80105a42:	78 34                	js     80105a78 <sys_mkdir+0x58>
80105a44:	83 ec 0c             	sub    $0xc,%esp
80105a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a4a:	31 c9                	xor    %ecx,%ecx
80105a4c:	ba 01 00 00 00       	mov    $0x1,%edx
80105a51:	6a 00                	push   $0x0
80105a53:	e8 78 f7 ff ff       	call   801051d0 <create>
80105a58:	83 c4 10             	add    $0x10,%esp
80105a5b:	85 c0                	test   %eax,%eax
80105a5d:	74 19                	je     80105a78 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a5f:	83 ec 0c             	sub    $0xc,%esp
80105a62:	50                   	push   %eax
80105a63:	e8 98 bf ff ff       	call   80101a00 <iunlockput>
  end_op();
80105a68:	e8 33 d3 ff ff       	call   80102da0 <end_op>
  return 0;
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	31 c0                	xor    %eax,%eax
}
80105a72:	c9                   	leave  
80105a73:	c3                   	ret    
80105a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105a78:	e8 23 d3 ff ff       	call   80102da0 <end_op>
    return -1;
80105a7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a82:	c9                   	leave  
80105a83:	c3                   	ret    
80105a84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a8f:	90                   	nop

80105a90 <sys_mknod>:

int
sys_mknod(void)
{
80105a90:	f3 0f 1e fb          	endbr32 
80105a94:	55                   	push   %ebp
80105a95:	89 e5                	mov    %esp,%ebp
80105a97:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a9a:	e8 91 d2 ff ff       	call   80102d30 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a9f:	83 ec 08             	sub    $0x8,%esp
80105aa2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105aa5:	50                   	push   %eax
80105aa6:	6a 00                	push   $0x0
80105aa8:	e8 73 f6 ff ff       	call   80105120 <argstr>
80105aad:	83 c4 10             	add    $0x10,%esp
80105ab0:	85 c0                	test   %eax,%eax
80105ab2:	78 64                	js     80105b18 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105ab4:	83 ec 08             	sub    $0x8,%esp
80105ab7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105aba:	50                   	push   %eax
80105abb:	6a 01                	push   $0x1
80105abd:	e8 ae f5 ff ff       	call   80105070 <argint>
  if((argstr(0, &path)) < 0 ||
80105ac2:	83 c4 10             	add    $0x10,%esp
80105ac5:	85 c0                	test   %eax,%eax
80105ac7:	78 4f                	js     80105b18 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105ac9:	83 ec 08             	sub    $0x8,%esp
80105acc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105acf:	50                   	push   %eax
80105ad0:	6a 02                	push   $0x2
80105ad2:	e8 99 f5 ff ff       	call   80105070 <argint>
     argint(1, &major) < 0 ||
80105ad7:	83 c4 10             	add    $0x10,%esp
80105ada:	85 c0                	test   %eax,%eax
80105adc:	78 3a                	js     80105b18 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105ade:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105ae2:	83 ec 0c             	sub    $0xc,%esp
80105ae5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105ae9:	ba 03 00 00 00       	mov    $0x3,%edx
80105aee:	50                   	push   %eax
80105aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105af2:	e8 d9 f6 ff ff       	call   801051d0 <create>
     argint(2, &minor) < 0 ||
80105af7:	83 c4 10             	add    $0x10,%esp
80105afa:	85 c0                	test   %eax,%eax
80105afc:	74 1a                	je     80105b18 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105afe:	83 ec 0c             	sub    $0xc,%esp
80105b01:	50                   	push   %eax
80105b02:	e8 f9 be ff ff       	call   80101a00 <iunlockput>
  end_op();
80105b07:	e8 94 d2 ff ff       	call   80102da0 <end_op>
  return 0;
80105b0c:	83 c4 10             	add    $0x10,%esp
80105b0f:	31 c0                	xor    %eax,%eax
}
80105b11:	c9                   	leave  
80105b12:	c3                   	ret    
80105b13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b17:	90                   	nop
    end_op();
80105b18:	e8 83 d2 ff ff       	call   80102da0 <end_op>
    return -1;
80105b1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b22:	c9                   	leave  
80105b23:	c3                   	ret    
80105b24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b2f:	90                   	nop

80105b30 <sys_chdir>:

int
sys_chdir(void)
{
80105b30:	f3 0f 1e fb          	endbr32 
80105b34:	55                   	push   %ebp
80105b35:	89 e5                	mov    %esp,%ebp
80105b37:	56                   	push   %esi
80105b38:	53                   	push   %ebx
80105b39:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105b3c:	e8 af e0 ff ff       	call   80103bf0 <myproc>
80105b41:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105b43:	e8 e8 d1 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105b48:	83 ec 08             	sub    $0x8,%esp
80105b4b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b4e:	50                   	push   %eax
80105b4f:	6a 00                	push   $0x0
80105b51:	e8 ca f5 ff ff       	call   80105120 <argstr>
80105b56:	83 c4 10             	add    $0x10,%esp
80105b59:	85 c0                	test   %eax,%eax
80105b5b:	78 73                	js     80105bd0 <sys_chdir+0xa0>
80105b5d:	83 ec 0c             	sub    $0xc,%esp
80105b60:	ff 75 f4             	pushl  -0xc(%ebp)
80105b63:	e8 c8 c4 ff ff       	call   80102030 <namei>
80105b68:	83 c4 10             	add    $0x10,%esp
80105b6b:	89 c3                	mov    %eax,%ebx
80105b6d:	85 c0                	test   %eax,%eax
80105b6f:	74 5f                	je     80105bd0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105b71:	83 ec 0c             	sub    $0xc,%esp
80105b74:	50                   	push   %eax
80105b75:	e8 e6 bb ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
80105b7a:	83 c4 10             	add    $0x10,%esp
80105b7d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b82:	75 2c                	jne    80105bb0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b84:	83 ec 0c             	sub    $0xc,%esp
80105b87:	53                   	push   %ebx
80105b88:	e8 b3 bc ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105b8d:	58                   	pop    %eax
80105b8e:	ff 76 68             	pushl  0x68(%esi)
80105b91:	e8 fa bc ff ff       	call   80101890 <iput>
  end_op();
80105b96:	e8 05 d2 ff ff       	call   80102da0 <end_op>
  curproc->cwd = ip;
80105b9b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b9e:	83 c4 10             	add    $0x10,%esp
80105ba1:	31 c0                	xor    %eax,%eax
}
80105ba3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ba6:	5b                   	pop    %ebx
80105ba7:	5e                   	pop    %esi
80105ba8:	5d                   	pop    %ebp
80105ba9:	c3                   	ret    
80105baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105bb0:	83 ec 0c             	sub    $0xc,%esp
80105bb3:	53                   	push   %ebx
80105bb4:	e8 47 be ff ff       	call   80101a00 <iunlockput>
    end_op();
80105bb9:	e8 e2 d1 ff ff       	call   80102da0 <end_op>
    return -1;
80105bbe:	83 c4 10             	add    $0x10,%esp
80105bc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc6:	eb db                	jmp    80105ba3 <sys_chdir+0x73>
80105bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop
    end_op();
80105bd0:	e8 cb d1 ff ff       	call   80102da0 <end_op>
    return -1;
80105bd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bda:	eb c7                	jmp    80105ba3 <sys_chdir+0x73>
80105bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105be0 <sys_exec>:

int
sys_exec(void)
{
80105be0:	f3 0f 1e fb          	endbr32 
80105be4:	55                   	push   %ebp
80105be5:	89 e5                	mov    %esp,%ebp
80105be7:	57                   	push   %edi
80105be8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105be9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105bef:	53                   	push   %ebx
80105bf0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105bf6:	50                   	push   %eax
80105bf7:	6a 00                	push   $0x0
80105bf9:	e8 22 f5 ff ff       	call   80105120 <argstr>
80105bfe:	83 c4 10             	add    $0x10,%esp
80105c01:	85 c0                	test   %eax,%eax
80105c03:	0f 88 8b 00 00 00    	js     80105c94 <sys_exec+0xb4>
80105c09:	83 ec 08             	sub    $0x8,%esp
80105c0c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105c12:	50                   	push   %eax
80105c13:	6a 01                	push   $0x1
80105c15:	e8 56 f4 ff ff       	call   80105070 <argint>
80105c1a:	83 c4 10             	add    $0x10,%esp
80105c1d:	85 c0                	test   %eax,%eax
80105c1f:	78 73                	js     80105c94 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105c21:	83 ec 04             	sub    $0x4,%esp
80105c24:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105c2a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105c2c:	68 80 00 00 00       	push   $0x80
80105c31:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105c37:	6a 00                	push   $0x0
80105c39:	50                   	push   %eax
80105c3a:	e8 51 f1 ff ff       	call   80104d90 <memset>
80105c3f:	83 c4 10             	add    $0x10,%esp
80105c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c48:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c4e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105c55:	83 ec 08             	sub    $0x8,%esp
80105c58:	57                   	push   %edi
80105c59:	01 f0                	add    %esi,%eax
80105c5b:	50                   	push   %eax
80105c5c:	e8 6f f3 ff ff       	call   80104fd0 <fetchint>
80105c61:	83 c4 10             	add    $0x10,%esp
80105c64:	85 c0                	test   %eax,%eax
80105c66:	78 2c                	js     80105c94 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105c68:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105c6e:	85 c0                	test   %eax,%eax
80105c70:	74 36                	je     80105ca8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105c72:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105c78:	83 ec 08             	sub    $0x8,%esp
80105c7b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105c7e:	52                   	push   %edx
80105c7f:	50                   	push   %eax
80105c80:	e8 8b f3 ff ff       	call   80105010 <fetchstr>
80105c85:	83 c4 10             	add    $0x10,%esp
80105c88:	85 c0                	test   %eax,%eax
80105c8a:	78 08                	js     80105c94 <sys_exec+0xb4>
  for(i=0;; i++){
80105c8c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105c8f:	83 fb 20             	cmp    $0x20,%ebx
80105c92:	75 b4                	jne    80105c48 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c9c:	5b                   	pop    %ebx
80105c9d:	5e                   	pop    %esi
80105c9e:	5f                   	pop    %edi
80105c9f:	5d                   	pop    %ebp
80105ca0:	c3                   	ret    
80105ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105ca8:	83 ec 08             	sub    $0x8,%esp
80105cab:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105cb1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105cb8:	00 00 00 00 
  return exec(path, argv);
80105cbc:	50                   	push   %eax
80105cbd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105cc3:	e8 b8 ad ff ff       	call   80100a80 <exec>
80105cc8:	83 c4 10             	add    $0x10,%esp
}
80105ccb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cce:	5b                   	pop    %ebx
80105ccf:	5e                   	pop    %esi
80105cd0:	5f                   	pop    %edi
80105cd1:	5d                   	pop    %ebp
80105cd2:	c3                   	ret    
80105cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ce0 <sys_pipe>:

int
sys_pipe(void)
{
80105ce0:	f3 0f 1e fb          	endbr32 
80105ce4:	55                   	push   %ebp
80105ce5:	89 e5                	mov    %esp,%ebp
80105ce7:	57                   	push   %edi
80105ce8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ce9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105cec:	53                   	push   %ebx
80105ced:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105cf0:	6a 08                	push   $0x8
80105cf2:	50                   	push   %eax
80105cf3:	6a 00                	push   $0x0
80105cf5:	e8 c6 f3 ff ff       	call   801050c0 <argptr>
80105cfa:	83 c4 10             	add    $0x10,%esp
80105cfd:	85 c0                	test   %eax,%eax
80105cff:	78 4e                	js     80105d4f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105d01:	83 ec 08             	sub    $0x8,%esp
80105d04:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d07:	50                   	push   %eax
80105d08:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d0b:	50                   	push   %eax
80105d0c:	e8 ef d6 ff ff       	call   80103400 <pipealloc>
80105d11:	83 c4 10             	add    $0x10,%esp
80105d14:	85 c0                	test   %eax,%eax
80105d16:	78 37                	js     80105d4f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d18:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105d1b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105d1d:	e8 ce de ff ff       	call   80103bf0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105d28:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105d2c:	85 f6                	test   %esi,%esi
80105d2e:	74 30                	je     80105d60 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105d30:	83 c3 01             	add    $0x1,%ebx
80105d33:	83 fb 10             	cmp    $0x10,%ebx
80105d36:	75 f0                	jne    80105d28 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105d38:	83 ec 0c             	sub    $0xc,%esp
80105d3b:	ff 75 e0             	pushl  -0x20(%ebp)
80105d3e:	e8 7d b1 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105d43:	58                   	pop    %eax
80105d44:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d47:	e8 74 b1 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105d4c:	83 c4 10             	add    $0x10,%esp
80105d4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d54:	eb 5b                	jmp    80105db1 <sys_pipe+0xd1>
80105d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105d60:	8d 73 08             	lea    0x8(%ebx),%esi
80105d63:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105d67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105d6a:	e8 81 de ff ff       	call   80103bf0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d6f:	31 d2                	xor    %edx,%edx
80105d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105d78:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105d7c:	85 c9                	test   %ecx,%ecx
80105d7e:	74 20                	je     80105da0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105d80:	83 c2 01             	add    $0x1,%edx
80105d83:	83 fa 10             	cmp    $0x10,%edx
80105d86:	75 f0                	jne    80105d78 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105d88:	e8 63 de ff ff       	call   80103bf0 <myproc>
80105d8d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d94:	00 
80105d95:	eb a1                	jmp    80105d38 <sys_pipe+0x58>
80105d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105da0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105da4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105da7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105da9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105dac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105daf:	31 c0                	xor    %eax,%eax
}
80105db1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105db4:	5b                   	pop    %ebx
80105db5:	5e                   	pop    %esi
80105db6:	5f                   	pop    %edi
80105db7:	5d                   	pop    %ebp
80105db8:	c3                   	ret    
80105db9:	66 90                	xchg   %ax,%ax
80105dbb:	66 90                	xchg   %ax,%ax
80105dbd:	66 90                	xchg   %ax,%ax
80105dbf:	90                   	nop

80105dc0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105dc0:	f3 0f 1e fb          	endbr32 
  return fork();
80105dc4:	e9 67 e0 ff ff       	jmp    80103e30 <fork>
80105dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105dd0 <sys_exit>:
}

int
sys_exit(void)
{
80105dd0:	f3 0f 1e fb          	endbr32 
80105dd4:	55                   	push   %ebp
80105dd5:	89 e5                	mov    %esp,%ebp
80105dd7:	83 ec 20             	sub    $0x20,%esp
  int exit_status;
  argint(0, &exit_status);
80105dda:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ddd:	50                   	push   %eax
80105dde:	6a 00                	push   $0x0
80105de0:	e8 8b f2 ff ff       	call   80105070 <argint>
  exit(exit_status);
80105de5:	58                   	pop    %eax
80105de6:	ff 75 f4             	pushl  -0xc(%ebp)
80105de9:	e8 52 e5 ff ff       	call   80104340 <exit>
  return 0;  // not reached
}
80105dee:	31 c0                	xor    %eax,%eax
80105df0:	c9                   	leave  
80105df1:	c3                   	ret    
80105df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e00 <sys_wait>:

int
sys_wait(void)
{
80105e00:	f3 0f 1e fb          	endbr32 
80105e04:	55                   	push   %ebp
80105e05:	89 e5                	mov    %esp,%ebp
80105e07:	83 ec 1c             	sub    $0x1c,%esp
  char *status_ptr;
  argptr(0, &status_ptr, 4);
80105e0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e0d:	6a 04                	push   $0x4
80105e0f:	50                   	push   %eax
80105e10:	6a 00                	push   $0x0
80105e12:	e8 a9 f2 ff ff       	call   801050c0 <argptr>
  return wait((int*)status_ptr);
80105e17:	58                   	pop    %eax
80105e18:	ff 75 f4             	pushl  -0xc(%ebp)
80105e1b:	e8 c0 e7 ff ff       	call   801045e0 <wait>
}
80105e20:	c9                   	leave  
80105e21:	c3                   	ret    
80105e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e30 <sys_kill>:

int
sys_kill(void)
{
80105e30:	f3 0f 1e fb          	endbr32 
80105e34:	55                   	push   %ebp
80105e35:	89 e5                	mov    %esp,%ebp
80105e37:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105e3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e3d:	50                   	push   %eax
80105e3e:	6a 00                	push   $0x0
80105e40:	e8 2b f2 ff ff       	call   80105070 <argint>
80105e45:	83 c4 10             	add    $0x10,%esp
80105e48:	85 c0                	test   %eax,%eax
80105e4a:	78 14                	js     80105e60 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105e4c:	83 ec 0c             	sub    $0xc,%esp
80105e4f:	ff 75 f4             	pushl  -0xc(%ebp)
80105e52:	e8 d9 e8 ff ff       	call   80104730 <kill>
80105e57:	83 c4 10             	add    $0x10,%esp
}
80105e5a:	c9                   	leave  
80105e5b:	c3                   	ret    
80105e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e60:	c9                   	leave  
    return -1;
80105e61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e66:	c3                   	ret    
80105e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e6e:	66 90                	xchg   %ax,%ax

80105e70 <sys_getpid>:

int
sys_getpid(void)
{
80105e70:	f3 0f 1e fb          	endbr32 
80105e74:	55                   	push   %ebp
80105e75:	89 e5                	mov    %esp,%ebp
80105e77:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105e7a:	e8 71 dd ff ff       	call   80103bf0 <myproc>
80105e7f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105e82:	c9                   	leave  
80105e83:	c3                   	ret    
80105e84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e8f:	90                   	nop

80105e90 <sys_sbrk>:

int
sys_sbrk(void)
{
80105e90:	f3 0f 1e fb          	endbr32 
80105e94:	55                   	push   %ebp
80105e95:	89 e5                	mov    %esp,%ebp
80105e97:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105e98:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e9b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e9e:	50                   	push   %eax
80105e9f:	6a 00                	push   $0x0
80105ea1:	e8 ca f1 ff ff       	call   80105070 <argint>
80105ea6:	83 c4 10             	add    $0x10,%esp
80105ea9:	85 c0                	test   %eax,%eax
80105eab:	78 23                	js     80105ed0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ead:	e8 3e dd ff ff       	call   80103bf0 <myproc>
  if(growproc(n) < 0)
80105eb2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105eb5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105eb7:	ff 75 f4             	pushl  -0xc(%ebp)
80105eba:	e8 f1 de ff ff       	call   80103db0 <growproc>
80105ebf:	83 c4 10             	add    $0x10,%esp
80105ec2:	85 c0                	test   %eax,%eax
80105ec4:	78 0a                	js     80105ed0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ec6:	89 d8                	mov    %ebx,%eax
80105ec8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ecb:	c9                   	leave  
80105ecc:	c3                   	ret    
80105ecd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ed0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ed5:	eb ef                	jmp    80105ec6 <sys_sbrk+0x36>
80105ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ede:	66 90                	xchg   %ax,%ax

80105ee0 <sys_sleep>:

int
sys_sleep(void)
{
80105ee0:	f3 0f 1e fb          	endbr32 
80105ee4:	55                   	push   %ebp
80105ee5:	89 e5                	mov    %esp,%ebp
80105ee7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ee8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105eeb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105eee:	50                   	push   %eax
80105eef:	6a 00                	push   $0x0
80105ef1:	e8 7a f1 ff ff       	call   80105070 <argint>
80105ef6:	83 c4 10             	add    $0x10,%esp
80105ef9:	85 c0                	test   %eax,%eax
80105efb:	0f 88 86 00 00 00    	js     80105f87 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105f01:	83 ec 0c             	sub    $0xc,%esp
80105f04:	68 60 64 11 80       	push   $0x80116460
80105f09:	e8 72 ed ff ff       	call   80104c80 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105f0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105f11:	8b 1d a0 6c 11 80    	mov    0x80116ca0,%ebx
  while(ticks - ticks0 < n){
80105f17:	83 c4 10             	add    $0x10,%esp
80105f1a:	85 d2                	test   %edx,%edx
80105f1c:	75 23                	jne    80105f41 <sys_sleep+0x61>
80105f1e:	eb 50                	jmp    80105f70 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105f20:	83 ec 08             	sub    $0x8,%esp
80105f23:	68 60 64 11 80       	push   $0x80116460
80105f28:	68 a0 6c 11 80       	push   $0x80116ca0
80105f2d:	e8 ee e5 ff ff       	call   80104520 <sleep>
  while(ticks - ticks0 < n){
80105f32:	a1 a0 6c 11 80       	mov    0x80116ca0,%eax
80105f37:	83 c4 10             	add    $0x10,%esp
80105f3a:	29 d8                	sub    %ebx,%eax
80105f3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105f3f:	73 2f                	jae    80105f70 <sys_sleep+0x90>
    if(myproc()->killed){
80105f41:	e8 aa dc ff ff       	call   80103bf0 <myproc>
80105f46:	8b 40 24             	mov    0x24(%eax),%eax
80105f49:	85 c0                	test   %eax,%eax
80105f4b:	74 d3                	je     80105f20 <sys_sleep+0x40>
      release(&tickslock);
80105f4d:	83 ec 0c             	sub    $0xc,%esp
80105f50:	68 60 64 11 80       	push   $0x80116460
80105f55:	e8 e6 ed ff ff       	call   80104d40 <release>
  }
  release(&tickslock);
  return 0;
}
80105f5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105f5d:	83 c4 10             	add    $0x10,%esp
80105f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f65:	c9                   	leave  
80105f66:	c3                   	ret    
80105f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f6e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105f70:	83 ec 0c             	sub    $0xc,%esp
80105f73:	68 60 64 11 80       	push   $0x80116460
80105f78:	e8 c3 ed ff ff       	call   80104d40 <release>
  return 0;
80105f7d:	83 c4 10             	add    $0x10,%esp
80105f80:	31 c0                	xor    %eax,%eax
}
80105f82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f85:	c9                   	leave  
80105f86:	c3                   	ret    
    return -1;
80105f87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f8c:	eb f4                	jmp    80105f82 <sys_sleep+0xa2>
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105f90:	f3 0f 1e fb          	endbr32 
80105f94:	55                   	push   %ebp
80105f95:	89 e5                	mov    %esp,%ebp
80105f97:	53                   	push   %ebx
80105f98:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105f9b:	68 60 64 11 80       	push   $0x80116460
80105fa0:	e8 db ec ff ff       	call   80104c80 <acquire>
  xticks = ticks;
80105fa5:	8b 1d a0 6c 11 80    	mov    0x80116ca0,%ebx
  release(&tickslock);
80105fab:	c7 04 24 60 64 11 80 	movl   $0x80116460,(%esp)
80105fb2:	e8 89 ed ff ff       	call   80104d40 <release>
  return xticks;
}
80105fb7:	89 d8                	mov    %ebx,%eax
80105fb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fbc:	c9                   	leave  
80105fbd:	c3                   	ret    
80105fbe:	66 90                	xchg   %ax,%ax

80105fc0 <sys_memsize>:

int sys_memsize(void){
80105fc0:	f3 0f 1e fb          	endbr32 
80105fc4:	55                   	push   %ebp
80105fc5:	89 e5                	mov    %esp,%ebp
80105fc7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->sz;
80105fca:	e8 21 dc ff ff       	call   80103bf0 <myproc>
80105fcf:	8b 00                	mov    (%eax),%eax
}
80105fd1:	c9                   	leave  
80105fd2:	c3                   	ret    
80105fd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105fe0 <sys_set_ps_priority>:

int sys_set_ps_priority(void)
{
80105fe0:	f3 0f 1e fb          	endbr32 
80105fe4:	55                   	push   %ebp
80105fe5:	89 e5                	mov    %esp,%ebp
80105fe7:	83 ec 20             	sub    $0x20,%esp
  int priority;
  argint(0, &priority);
80105fea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fed:	50                   	push   %eax
80105fee:	6a 00                	push   $0x0
80105ff0:	e8 7b f0 ff ff       	call   80105070 <argint>
  return set_ps_priority(priority);
80105ff5:	58                   	pop    %eax
80105ff6:	ff 75 f4             	pushl  -0xc(%ebp)
80105ff9:	e8 a2 e8 ff ff       	call   801048a0 <set_ps_priority>
}
80105ffe:	c9                   	leave  
80105fff:	c3                   	ret    

80106000 <sys_policy>:

int sys_policy(void)
{
80106000:	f3 0f 1e fb          	endbr32 
80106004:	55                   	push   %ebp
80106005:	89 e5                	mov    %esp,%ebp
80106007:	83 ec 20             	sub    $0x20,%esp
  int policy_type;
  argint(0, &policy_type);
8010600a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010600d:	50                   	push   %eax
8010600e:	6a 00                	push   $0x0
80106010:	e8 5b f0 ff ff       	call   80105070 <argint>
  return policy(policy_type);
80106015:	58                   	pop    %eax
80106016:	ff 75 f4             	pushl  -0xc(%ebp)
80106019:	e8 c2 e8 ff ff       	call   801048e0 <policy>
}
8010601e:	c9                   	leave  
8010601f:	c3                   	ret    

80106020 <sys_set_cfs_priority>:

int sys_set_cfs_priority(void){
80106020:	f3 0f 1e fb          	endbr32 
80106024:	55                   	push   %ebp
80106025:	89 e5                	mov    %esp,%ebp
80106027:	83 ec 20             	sub    $0x20,%esp
  int priority;
  argint(0, &priority);
8010602a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010602d:	50                   	push   %eax
8010602e:	6a 00                	push   $0x0
80106030:	e8 3b f0 ff ff       	call   80105070 <argint>
  return set_cfs_priority(priority);
80106035:	58                   	pop    %eax
80106036:	ff 75 f4             	pushl  -0xc(%ebp)
80106039:	e8 d2 e8 ff ff       	call   80104910 <set_cfs_priority>
}
8010603e:	c9                   	leave  
8010603f:	c3                   	ret    

80106040 <sys_proc_info>:

int sys_proc_info(void){
80106040:	f3 0f 1e fb          	endbr32 
80106044:	55                   	push   %ebp
80106045:	89 e5                	mov    %esp,%ebp
80106047:	83 ec 1c             	sub    $0x1c,%esp
  char* performance;
  argptr(0, &performance, sizeof(struct perf));
8010604a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010604d:	6a 10                	push   $0x10
8010604f:	50                   	push   %eax
80106050:	6a 00                	push   $0x0
80106052:	e8 69 f0 ff ff       	call   801050c0 <argptr>
  return proc_info((struct perf*) performance);
80106057:	58                   	pop    %eax
80106058:	ff 75 f4             	pushl  -0xc(%ebp)
8010605b:	e8 10 e9 ff ff       	call   80104970 <proc_info>
}
80106060:	c9                   	leave  
80106061:	c3                   	ret    

80106062 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106062:	1e                   	push   %ds
  pushl %es
80106063:	06                   	push   %es
  pushl %fs
80106064:	0f a0                	push   %fs
  pushl %gs
80106066:	0f a8                	push   %gs
  pushal
80106068:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106069:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010606d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010606f:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106071:	54                   	push   %esp
  call trap
80106072:	e8 c9 00 00 00       	call   80106140 <trap>
  addl $4, %esp
80106077:	83 c4 04             	add    $0x4,%esp

8010607a <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010607a:	61                   	popa   
  popl %gs
8010607b:	0f a9                	pop    %gs
  popl %fs
8010607d:	0f a1                	pop    %fs
  popl %es
8010607f:	07                   	pop    %es
  popl %ds
80106080:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106081:	83 c4 08             	add    $0x8,%esp
  iret
80106084:	cf                   	iret   
80106085:	66 90                	xchg   %ax,%ax
80106087:	66 90                	xchg   %ax,%ax
80106089:	66 90                	xchg   %ax,%ax
8010608b:	66 90                	xchg   %ax,%ax
8010608d:	66 90                	xchg   %ax,%ax
8010608f:	90                   	nop

80106090 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106090:	f3 0f 1e fb          	endbr32 
80106094:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106095:	31 c0                	xor    %eax,%eax
{
80106097:	89 e5                	mov    %esp,%ebp
80106099:	83 ec 08             	sub    $0x8,%esp
8010609c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801060a0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801060a7:	c7 04 c5 a2 64 11 80 	movl   $0x8e000008,-0x7fee9b5e(,%eax,8)
801060ae:	08 00 00 8e 
801060b2:	66 89 14 c5 a0 64 11 	mov    %dx,-0x7fee9b60(,%eax,8)
801060b9:	80 
801060ba:	c1 ea 10             	shr    $0x10,%edx
801060bd:	66 89 14 c5 a6 64 11 	mov    %dx,-0x7fee9b5a(,%eax,8)
801060c4:	80 
  for(i = 0; i < 256; i++)
801060c5:	83 c0 01             	add    $0x1,%eax
801060c8:	3d 00 01 00 00       	cmp    $0x100,%eax
801060cd:	75 d1                	jne    801060a0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801060cf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060d2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801060d7:	c7 05 a2 66 11 80 08 	movl   $0xef000008,0x801166a2
801060de:	00 00 ef 
  initlock(&tickslock, "time");
801060e1:	68 cd 80 10 80       	push   $0x801080cd
801060e6:	68 60 64 11 80       	push   $0x80116460
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060eb:	66 a3 a0 66 11 80    	mov    %ax,0x801166a0
801060f1:	c1 e8 10             	shr    $0x10,%eax
801060f4:	66 a3 a6 66 11 80    	mov    %ax,0x801166a6
  initlock(&tickslock, "time");
801060fa:	e8 01 ea ff ff       	call   80104b00 <initlock>
}
801060ff:	83 c4 10             	add    $0x10,%esp
80106102:	c9                   	leave  
80106103:	c3                   	ret    
80106104:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010610b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010610f:	90                   	nop

80106110 <idtinit>:

void
idtinit(void)
{
80106110:	f3 0f 1e fb          	endbr32 
80106114:	55                   	push   %ebp
  pd[0] = size-1;
80106115:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010611a:	89 e5                	mov    %esp,%ebp
8010611c:	83 ec 10             	sub    $0x10,%esp
8010611f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106123:	b8 a0 64 11 80       	mov    $0x801164a0,%eax
80106128:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010612c:	c1 e8 10             	shr    $0x10,%eax
8010612f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106133:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106136:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106139:	c9                   	leave  
8010613a:	c3                   	ret    
8010613b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010613f:	90                   	nop

80106140 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106140:	f3 0f 1e fb          	endbr32 
80106144:	55                   	push   %ebp
80106145:	89 e5                	mov    %esp,%ebp
80106147:	57                   	push   %edi
80106148:	56                   	push   %esi
80106149:	53                   	push   %ebx
8010614a:	83 ec 1c             	sub    $0x1c,%esp
8010614d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106150:	8b 43 30             	mov    0x30(%ebx),%eax
80106153:	83 f8 40             	cmp    $0x40,%eax
80106156:	0f 84 e4 01 00 00    	je     80106340 <trap+0x200>
    if(myproc()->killed)
      exit(myproc()->killed); // TODO: verify this
    return;
  }

  switch(tf->trapno){
8010615c:	83 e8 20             	sub    $0x20,%eax
8010615f:	83 f8 1f             	cmp    $0x1f,%eax
80106162:	77 08                	ja     8010616c <trap+0x2c>
80106164:	3e ff 24 85 74 81 10 	notrack jmp *-0x7fef7e8c(,%eax,4)
8010616b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010616c:	e8 7f da ff ff       	call   80103bf0 <myproc>
80106171:	8b 7b 38             	mov    0x38(%ebx),%edi
80106174:	85 c0                	test   %eax,%eax
80106176:	0f 84 39 02 00 00    	je     801063b5 <trap+0x275>
8010617c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106180:	0f 84 2f 02 00 00    	je     801063b5 <trap+0x275>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106186:	0f 20 d1             	mov    %cr2,%ecx
80106189:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010618c:	e8 3f da ff ff       	call   80103bd0 <cpuid>
80106191:	8b 73 30             	mov    0x30(%ebx),%esi
80106194:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106197:	8b 43 34             	mov    0x34(%ebx),%eax
8010619a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010619d:	e8 4e da ff ff       	call   80103bf0 <myproc>
801061a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801061a5:	e8 46 da ff ff       	call   80103bf0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061aa:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801061ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
801061b0:	51                   	push   %ecx
801061b1:	57                   	push   %edi
801061b2:	52                   	push   %edx
801061b3:	ff 75 e4             	pushl  -0x1c(%ebp)
801061b6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801061b7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801061ba:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061bd:	56                   	push   %esi
801061be:	ff 70 10             	pushl  0x10(%eax)
801061c1:	68 30 81 10 80       	push   $0x80108130
801061c6:	e8 e5 a4 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801061cb:	83 c4 20             	add    $0x20,%esp
801061ce:	e8 1d da ff ff       	call   80103bf0 <myproc>
801061d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061da:	e8 11 da ff ff       	call   80103bf0 <myproc>
801061df:	85 c0                	test   %eax,%eax
801061e1:	74 1d                	je     80106200 <trap+0xc0>
801061e3:	e8 08 da ff ff       	call   80103bf0 <myproc>
801061e8:	8b 50 24             	mov    0x24(%eax),%edx
801061eb:	85 d2                	test   %edx,%edx
801061ed:	74 11                	je     80106200 <trap+0xc0>
801061ef:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801061f3:	83 e0 03             	and    $0x3,%eax
801061f6:	66 83 f8 03          	cmp    $0x3,%ax
801061fa:	0f 84 80 01 00 00    	je     80106380 <trap+0x240>
    exit(myproc()->killed);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106200:	e8 eb d9 ff ff       	call   80103bf0 <myproc>
80106205:	85 c0                	test   %eax,%eax
80106207:	74 0f                	je     80106218 <trap+0xd8>
80106209:	e8 e2 d9 ff ff       	call   80103bf0 <myproc>
8010620e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106212:	0f 84 f0 00 00 00    	je     80106308 <trap+0x1c8>
          myproc()->accumulator += myproc()->ps_priority;
          yield();
     }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106218:	e8 d3 d9 ff ff       	call   80103bf0 <myproc>
8010621d:	85 c0                	test   %eax,%eax
8010621f:	74 1d                	je     8010623e <trap+0xfe>
80106221:	e8 ca d9 ff ff       	call   80103bf0 <myproc>
80106226:	8b 40 24             	mov    0x24(%eax),%eax
80106229:	85 c0                	test   %eax,%eax
8010622b:	74 11                	je     8010623e <trap+0xfe>
8010622d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106231:	83 e0 03             	and    $0x3,%eax
80106234:	66 83 f8 03          	cmp    $0x3,%ax
80106238:	0f 84 2b 01 00 00    	je     80106369 <trap+0x229>
    exit(myproc()->killed);
}
8010623e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106241:	5b                   	pop    %ebx
80106242:	5e                   	pop    %esi
80106243:	5f                   	pop    %edi
80106244:	5d                   	pop    %ebp
80106245:	c3                   	ret    
    ideintr();
80106246:	e8 95 bf ff ff       	call   801021e0 <ideintr>
    lapiceoi();
8010624b:	e8 70 c6 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106250:	e8 9b d9 ff ff       	call   80103bf0 <myproc>
80106255:	85 c0                	test   %eax,%eax
80106257:	75 8a                	jne    801061e3 <trap+0xa3>
80106259:	eb a5                	jmp    80106200 <trap+0xc0>
    if(cpuid() == 0){
8010625b:	e8 70 d9 ff ff       	call   80103bd0 <cpuid>
80106260:	85 c0                	test   %eax,%eax
80106262:	75 e7                	jne    8010624b <trap+0x10b>
      acquire(&tickslock);
80106264:	83 ec 0c             	sub    $0xc,%esp
80106267:	68 60 64 11 80       	push   $0x80116460
8010626c:	e8 0f ea ff ff       	call   80104c80 <acquire>
      ticks++;
80106271:	83 05 a0 6c 11 80 01 	addl   $0x1,0x80116ca0
      update_ptable_stats();
80106278:	e8 c3 e1 ff ff       	call   80104440 <update_ptable_stats>
      wakeup(&ticks);
8010627d:	c7 04 24 a0 6c 11 80 	movl   $0x80116ca0,(%esp)
80106284:	e8 67 e4 ff ff       	call   801046f0 <wakeup>
      release(&tickslock);
80106289:	c7 04 24 60 64 11 80 	movl   $0x80116460,(%esp)
80106290:	e8 ab ea ff ff       	call   80104d40 <release>
80106295:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106298:	eb b1                	jmp    8010624b <trap+0x10b>
    kbdintr();
8010629a:	e8 e1 c4 ff ff       	call   80102780 <kbdintr>
    lapiceoi();
8010629f:	e8 1c c6 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062a4:	e8 47 d9 ff ff       	call   80103bf0 <myproc>
801062a9:	85 c0                	test   %eax,%eax
801062ab:	0f 85 32 ff ff ff    	jne    801061e3 <trap+0xa3>
801062b1:	e9 4a ff ff ff       	jmp    80106200 <trap+0xc0>
    uartintr();
801062b6:	e8 95 02 00 00       	call   80106550 <uartintr>
    lapiceoi();
801062bb:	e8 00 c6 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062c0:	e8 2b d9 ff ff       	call   80103bf0 <myproc>
801062c5:	85 c0                	test   %eax,%eax
801062c7:	0f 85 16 ff ff ff    	jne    801061e3 <trap+0xa3>
801062cd:	e9 2e ff ff ff       	jmp    80106200 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801062d2:	8b 7b 38             	mov    0x38(%ebx),%edi
801062d5:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801062d9:	e8 f2 d8 ff ff       	call   80103bd0 <cpuid>
801062de:	57                   	push   %edi
801062df:	56                   	push   %esi
801062e0:	50                   	push   %eax
801062e1:	68 d8 80 10 80       	push   $0x801080d8
801062e6:	e8 c5 a3 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801062eb:	e8 d0 c5 ff ff       	call   801028c0 <lapiceoi>
    break;
801062f0:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062f3:	e8 f8 d8 ff ff       	call   80103bf0 <myproc>
801062f8:	85 c0                	test   %eax,%eax
801062fa:	0f 85 e3 fe ff ff    	jne    801061e3 <trap+0xa3>
80106300:	e9 fb fe ff ff       	jmp    80106200 <trap+0xc0>
80106305:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106308:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010630c:	0f 85 06 ff ff ff    	jne    80106218 <trap+0xd8>
          myproc()->accumulator += myproc()->ps_priority;
80106312:	e8 d9 d8 ff ff       	call   80103bf0 <myproc>
80106317:	8b b0 80 00 00 00    	mov    0x80(%eax),%esi
8010631d:	e8 ce d8 ff ff       	call   80103bf0 <myproc>
80106322:	89 f7                	mov    %esi,%edi
80106324:	c1 ff 1f             	sar    $0x1f,%edi
80106327:	01 b0 84 00 00 00    	add    %esi,0x84(%eax)
8010632d:	11 b8 88 00 00 00    	adc    %edi,0x88(%eax)
          yield();
80106333:	e8 98 e1 ff ff       	call   801044d0 <yield>
80106338:	e9 db fe ff ff       	jmp    80106218 <trap+0xd8>
8010633d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed)
80106340:	e8 ab d8 ff ff       	call   80103bf0 <myproc>
80106345:	8b 70 24             	mov    0x24(%eax),%esi
80106348:	85 f6                	test   %esi,%esi
8010634a:	75 54                	jne    801063a0 <trap+0x260>
    myproc()->tf = tf;
8010634c:	e8 9f d8 ff ff       	call   80103bf0 <myproc>
80106351:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106354:	e8 07 ee ff ff       	call   80105160 <syscall>
    if(myproc()->killed)
80106359:	e8 92 d8 ff ff       	call   80103bf0 <myproc>
8010635e:	8b 48 24             	mov    0x24(%eax),%ecx
80106361:	85 c9                	test   %ecx,%ecx
80106363:	0f 84 d5 fe ff ff    	je     8010623e <trap+0xfe>
    exit(myproc()->killed);
80106369:	e8 82 d8 ff ff       	call   80103bf0 <myproc>
8010636e:	8b 40 24             	mov    0x24(%eax),%eax
80106371:	89 45 08             	mov    %eax,0x8(%ebp)
}
80106374:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106377:	5b                   	pop    %ebx
80106378:	5e                   	pop    %esi
80106379:	5f                   	pop    %edi
8010637a:	5d                   	pop    %ebp
    exit(myproc()->killed);
8010637b:	e9 c0 df ff ff       	jmp    80104340 <exit>
    exit(myproc()->killed);
80106380:	e8 6b d8 ff ff       	call   80103bf0 <myproc>
80106385:	83 ec 0c             	sub    $0xc,%esp
80106388:	ff 70 24             	pushl  0x24(%eax)
8010638b:	e8 b0 df ff ff       	call   80104340 <exit>
80106390:	83 c4 10             	add    $0x10,%esp
80106393:	e9 68 fe ff ff       	jmp    80106200 <trap+0xc0>
80106398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010639f:	90                   	nop
      exit(myproc()->killed); // TODO: verify this
801063a0:	e8 4b d8 ff ff       	call   80103bf0 <myproc>
801063a5:	83 ec 0c             	sub    $0xc,%esp
801063a8:	ff 70 24             	pushl  0x24(%eax)
801063ab:	e8 90 df ff ff       	call   80104340 <exit>
801063b0:	83 c4 10             	add    $0x10,%esp
801063b3:	eb 97                	jmp    8010634c <trap+0x20c>
801063b5:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801063b8:	e8 13 d8 ff ff       	call   80103bd0 <cpuid>
801063bd:	83 ec 0c             	sub    $0xc,%esp
801063c0:	56                   	push   %esi
801063c1:	57                   	push   %edi
801063c2:	50                   	push   %eax
801063c3:	ff 73 30             	pushl  0x30(%ebx)
801063c6:	68 fc 80 10 80       	push   $0x801080fc
801063cb:	e8 e0 a2 ff ff       	call   801006b0 <cprintf>
      panic("trap");
801063d0:	83 c4 14             	add    $0x14,%esp
801063d3:	68 d2 80 10 80       	push   $0x801080d2
801063d8:	e8 b3 9f ff ff       	call   80100390 <panic>
801063dd:	66 90                	xchg   %ax,%ax
801063df:	90                   	nop

801063e0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801063e0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801063e4:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
801063e9:	85 c0                	test   %eax,%eax
801063eb:	74 1b                	je     80106408 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063ed:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063f2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801063f3:	a8 01                	test   $0x1,%al
801063f5:	74 11                	je     80106408 <uartgetc+0x28>
801063f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063fc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801063fd:	0f b6 c0             	movzbl %al,%eax
80106400:	c3                   	ret    
80106401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010640d:	c3                   	ret    
8010640e:	66 90                	xchg   %ax,%ax

80106410 <uartputc.part.0>:
uartputc(int c)
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	57                   	push   %edi
80106414:	89 c7                	mov    %eax,%edi
80106416:	56                   	push   %esi
80106417:	be fd 03 00 00       	mov    $0x3fd,%esi
8010641c:	53                   	push   %ebx
8010641d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106422:	83 ec 0c             	sub    $0xc,%esp
80106425:	eb 1b                	jmp    80106442 <uartputc.part.0+0x32>
80106427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010642e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106430:	83 ec 0c             	sub    $0xc,%esp
80106433:	6a 0a                	push   $0xa
80106435:	e8 a6 c4 ff ff       	call   801028e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010643a:	83 c4 10             	add    $0x10,%esp
8010643d:	83 eb 01             	sub    $0x1,%ebx
80106440:	74 07                	je     80106449 <uartputc.part.0+0x39>
80106442:	89 f2                	mov    %esi,%edx
80106444:	ec                   	in     (%dx),%al
80106445:	a8 20                	test   $0x20,%al
80106447:	74 e7                	je     80106430 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106449:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010644e:	89 f8                	mov    %edi,%eax
80106450:	ee                   	out    %al,(%dx)
}
80106451:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106454:	5b                   	pop    %ebx
80106455:	5e                   	pop    %esi
80106456:	5f                   	pop    %edi
80106457:	5d                   	pop    %ebp
80106458:	c3                   	ret    
80106459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106460 <uartinit>:
{
80106460:	f3 0f 1e fb          	endbr32 
80106464:	55                   	push   %ebp
80106465:	31 c9                	xor    %ecx,%ecx
80106467:	89 c8                	mov    %ecx,%eax
80106469:	89 e5                	mov    %esp,%ebp
8010646b:	57                   	push   %edi
8010646c:	56                   	push   %esi
8010646d:	53                   	push   %ebx
8010646e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106473:	89 da                	mov    %ebx,%edx
80106475:	83 ec 0c             	sub    $0xc,%esp
80106478:	ee                   	out    %al,(%dx)
80106479:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010647e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106483:	89 fa                	mov    %edi,%edx
80106485:	ee                   	out    %al,(%dx)
80106486:	b8 0c 00 00 00       	mov    $0xc,%eax
8010648b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106490:	ee                   	out    %al,(%dx)
80106491:	be f9 03 00 00       	mov    $0x3f9,%esi
80106496:	89 c8                	mov    %ecx,%eax
80106498:	89 f2                	mov    %esi,%edx
8010649a:	ee                   	out    %al,(%dx)
8010649b:	b8 03 00 00 00       	mov    $0x3,%eax
801064a0:	89 fa                	mov    %edi,%edx
801064a2:	ee                   	out    %al,(%dx)
801064a3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801064a8:	89 c8                	mov    %ecx,%eax
801064aa:	ee                   	out    %al,(%dx)
801064ab:	b8 01 00 00 00       	mov    $0x1,%eax
801064b0:	89 f2                	mov    %esi,%edx
801064b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064b3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064b8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801064b9:	3c ff                	cmp    $0xff,%al
801064bb:	74 52                	je     8010650f <uartinit+0xaf>
  uart = 1;
801064bd:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801064c4:	00 00 00 
801064c7:	89 da                	mov    %ebx,%edx
801064c9:	ec                   	in     (%dx),%al
801064ca:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064cf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801064d0:	83 ec 08             	sub    $0x8,%esp
801064d3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
801064d8:	bb f4 81 10 80       	mov    $0x801081f4,%ebx
  ioapicenable(IRQ_COM1, 0);
801064dd:	6a 00                	push   $0x0
801064df:	6a 04                	push   $0x4
801064e1:	e8 4a bf ff ff       	call   80102430 <ioapicenable>
801064e6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801064e9:	b8 78 00 00 00       	mov    $0x78,%eax
801064ee:	eb 04                	jmp    801064f4 <uartinit+0x94>
801064f0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
801064f4:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801064fa:	85 d2                	test   %edx,%edx
801064fc:	74 08                	je     80106506 <uartinit+0xa6>
    uartputc(*p);
801064fe:	0f be c0             	movsbl %al,%eax
80106501:	e8 0a ff ff ff       	call   80106410 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106506:	89 f0                	mov    %esi,%eax
80106508:	83 c3 01             	add    $0x1,%ebx
8010650b:	84 c0                	test   %al,%al
8010650d:	75 e1                	jne    801064f0 <uartinit+0x90>
}
8010650f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106512:	5b                   	pop    %ebx
80106513:	5e                   	pop    %esi
80106514:	5f                   	pop    %edi
80106515:	5d                   	pop    %ebp
80106516:	c3                   	ret    
80106517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010651e:	66 90                	xchg   %ax,%ax

80106520 <uartputc>:
{
80106520:	f3 0f 1e fb          	endbr32 
80106524:	55                   	push   %ebp
  if(!uart)
80106525:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
8010652b:	89 e5                	mov    %esp,%ebp
8010652d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106530:	85 d2                	test   %edx,%edx
80106532:	74 0c                	je     80106540 <uartputc+0x20>
}
80106534:	5d                   	pop    %ebp
80106535:	e9 d6 fe ff ff       	jmp    80106410 <uartputc.part.0>
8010653a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106540:	5d                   	pop    %ebp
80106541:	c3                   	ret    
80106542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106550 <uartintr>:

void
uartintr(void)
{
80106550:	f3 0f 1e fb          	endbr32 
80106554:	55                   	push   %ebp
80106555:	89 e5                	mov    %esp,%ebp
80106557:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010655a:	68 e0 63 10 80       	push   $0x801063e0
8010655f:	e8 fc a2 ff ff       	call   80100860 <consoleintr>
}
80106564:	83 c4 10             	add    $0x10,%esp
80106567:	c9                   	leave  
80106568:	c3                   	ret    

80106569 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106569:	6a 00                	push   $0x0
  pushl $0
8010656b:	6a 00                	push   $0x0
  jmp alltraps
8010656d:	e9 f0 fa ff ff       	jmp    80106062 <alltraps>

80106572 <vector1>:
.globl vector1
vector1:
  pushl $0
80106572:	6a 00                	push   $0x0
  pushl $1
80106574:	6a 01                	push   $0x1
  jmp alltraps
80106576:	e9 e7 fa ff ff       	jmp    80106062 <alltraps>

8010657b <vector2>:
.globl vector2
vector2:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $2
8010657d:	6a 02                	push   $0x2
  jmp alltraps
8010657f:	e9 de fa ff ff       	jmp    80106062 <alltraps>

80106584 <vector3>:
.globl vector3
vector3:
  pushl $0
80106584:	6a 00                	push   $0x0
  pushl $3
80106586:	6a 03                	push   $0x3
  jmp alltraps
80106588:	e9 d5 fa ff ff       	jmp    80106062 <alltraps>

8010658d <vector4>:
.globl vector4
vector4:
  pushl $0
8010658d:	6a 00                	push   $0x0
  pushl $4
8010658f:	6a 04                	push   $0x4
  jmp alltraps
80106591:	e9 cc fa ff ff       	jmp    80106062 <alltraps>

80106596 <vector5>:
.globl vector5
vector5:
  pushl $0
80106596:	6a 00                	push   $0x0
  pushl $5
80106598:	6a 05                	push   $0x5
  jmp alltraps
8010659a:	e9 c3 fa ff ff       	jmp    80106062 <alltraps>

8010659f <vector6>:
.globl vector6
vector6:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $6
801065a1:	6a 06                	push   $0x6
  jmp alltraps
801065a3:	e9 ba fa ff ff       	jmp    80106062 <alltraps>

801065a8 <vector7>:
.globl vector7
vector7:
  pushl $0
801065a8:	6a 00                	push   $0x0
  pushl $7
801065aa:	6a 07                	push   $0x7
  jmp alltraps
801065ac:	e9 b1 fa ff ff       	jmp    80106062 <alltraps>

801065b1 <vector8>:
.globl vector8
vector8:
  pushl $8
801065b1:	6a 08                	push   $0x8
  jmp alltraps
801065b3:	e9 aa fa ff ff       	jmp    80106062 <alltraps>

801065b8 <vector9>:
.globl vector9
vector9:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $9
801065ba:	6a 09                	push   $0x9
  jmp alltraps
801065bc:	e9 a1 fa ff ff       	jmp    80106062 <alltraps>

801065c1 <vector10>:
.globl vector10
vector10:
  pushl $10
801065c1:	6a 0a                	push   $0xa
  jmp alltraps
801065c3:	e9 9a fa ff ff       	jmp    80106062 <alltraps>

801065c8 <vector11>:
.globl vector11
vector11:
  pushl $11
801065c8:	6a 0b                	push   $0xb
  jmp alltraps
801065ca:	e9 93 fa ff ff       	jmp    80106062 <alltraps>

801065cf <vector12>:
.globl vector12
vector12:
  pushl $12
801065cf:	6a 0c                	push   $0xc
  jmp alltraps
801065d1:	e9 8c fa ff ff       	jmp    80106062 <alltraps>

801065d6 <vector13>:
.globl vector13
vector13:
  pushl $13
801065d6:	6a 0d                	push   $0xd
  jmp alltraps
801065d8:	e9 85 fa ff ff       	jmp    80106062 <alltraps>

801065dd <vector14>:
.globl vector14
vector14:
  pushl $14
801065dd:	6a 0e                	push   $0xe
  jmp alltraps
801065df:	e9 7e fa ff ff       	jmp    80106062 <alltraps>

801065e4 <vector15>:
.globl vector15
vector15:
  pushl $0
801065e4:	6a 00                	push   $0x0
  pushl $15
801065e6:	6a 0f                	push   $0xf
  jmp alltraps
801065e8:	e9 75 fa ff ff       	jmp    80106062 <alltraps>

801065ed <vector16>:
.globl vector16
vector16:
  pushl $0
801065ed:	6a 00                	push   $0x0
  pushl $16
801065ef:	6a 10                	push   $0x10
  jmp alltraps
801065f1:	e9 6c fa ff ff       	jmp    80106062 <alltraps>

801065f6 <vector17>:
.globl vector17
vector17:
  pushl $17
801065f6:	6a 11                	push   $0x11
  jmp alltraps
801065f8:	e9 65 fa ff ff       	jmp    80106062 <alltraps>

801065fd <vector18>:
.globl vector18
vector18:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $18
801065ff:	6a 12                	push   $0x12
  jmp alltraps
80106601:	e9 5c fa ff ff       	jmp    80106062 <alltraps>

80106606 <vector19>:
.globl vector19
vector19:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $19
80106608:	6a 13                	push   $0x13
  jmp alltraps
8010660a:	e9 53 fa ff ff       	jmp    80106062 <alltraps>

8010660f <vector20>:
.globl vector20
vector20:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $20
80106611:	6a 14                	push   $0x14
  jmp alltraps
80106613:	e9 4a fa ff ff       	jmp    80106062 <alltraps>

80106618 <vector21>:
.globl vector21
vector21:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $21
8010661a:	6a 15                	push   $0x15
  jmp alltraps
8010661c:	e9 41 fa ff ff       	jmp    80106062 <alltraps>

80106621 <vector22>:
.globl vector22
vector22:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $22
80106623:	6a 16                	push   $0x16
  jmp alltraps
80106625:	e9 38 fa ff ff       	jmp    80106062 <alltraps>

8010662a <vector23>:
.globl vector23
vector23:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $23
8010662c:	6a 17                	push   $0x17
  jmp alltraps
8010662e:	e9 2f fa ff ff       	jmp    80106062 <alltraps>

80106633 <vector24>:
.globl vector24
vector24:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $24
80106635:	6a 18                	push   $0x18
  jmp alltraps
80106637:	e9 26 fa ff ff       	jmp    80106062 <alltraps>

8010663c <vector25>:
.globl vector25
vector25:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $25
8010663e:	6a 19                	push   $0x19
  jmp alltraps
80106640:	e9 1d fa ff ff       	jmp    80106062 <alltraps>

80106645 <vector26>:
.globl vector26
vector26:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $26
80106647:	6a 1a                	push   $0x1a
  jmp alltraps
80106649:	e9 14 fa ff ff       	jmp    80106062 <alltraps>

8010664e <vector27>:
.globl vector27
vector27:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $27
80106650:	6a 1b                	push   $0x1b
  jmp alltraps
80106652:	e9 0b fa ff ff       	jmp    80106062 <alltraps>

80106657 <vector28>:
.globl vector28
vector28:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $28
80106659:	6a 1c                	push   $0x1c
  jmp alltraps
8010665b:	e9 02 fa ff ff       	jmp    80106062 <alltraps>

80106660 <vector29>:
.globl vector29
vector29:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $29
80106662:	6a 1d                	push   $0x1d
  jmp alltraps
80106664:	e9 f9 f9 ff ff       	jmp    80106062 <alltraps>

80106669 <vector30>:
.globl vector30
vector30:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $30
8010666b:	6a 1e                	push   $0x1e
  jmp alltraps
8010666d:	e9 f0 f9 ff ff       	jmp    80106062 <alltraps>

80106672 <vector31>:
.globl vector31
vector31:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $31
80106674:	6a 1f                	push   $0x1f
  jmp alltraps
80106676:	e9 e7 f9 ff ff       	jmp    80106062 <alltraps>

8010667b <vector32>:
.globl vector32
vector32:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $32
8010667d:	6a 20                	push   $0x20
  jmp alltraps
8010667f:	e9 de f9 ff ff       	jmp    80106062 <alltraps>

80106684 <vector33>:
.globl vector33
vector33:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $33
80106686:	6a 21                	push   $0x21
  jmp alltraps
80106688:	e9 d5 f9 ff ff       	jmp    80106062 <alltraps>

8010668d <vector34>:
.globl vector34
vector34:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $34
8010668f:	6a 22                	push   $0x22
  jmp alltraps
80106691:	e9 cc f9 ff ff       	jmp    80106062 <alltraps>

80106696 <vector35>:
.globl vector35
vector35:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $35
80106698:	6a 23                	push   $0x23
  jmp alltraps
8010669a:	e9 c3 f9 ff ff       	jmp    80106062 <alltraps>

8010669f <vector36>:
.globl vector36
vector36:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $36
801066a1:	6a 24                	push   $0x24
  jmp alltraps
801066a3:	e9 ba f9 ff ff       	jmp    80106062 <alltraps>

801066a8 <vector37>:
.globl vector37
vector37:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $37
801066aa:	6a 25                	push   $0x25
  jmp alltraps
801066ac:	e9 b1 f9 ff ff       	jmp    80106062 <alltraps>

801066b1 <vector38>:
.globl vector38
vector38:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $38
801066b3:	6a 26                	push   $0x26
  jmp alltraps
801066b5:	e9 a8 f9 ff ff       	jmp    80106062 <alltraps>

801066ba <vector39>:
.globl vector39
vector39:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $39
801066bc:	6a 27                	push   $0x27
  jmp alltraps
801066be:	e9 9f f9 ff ff       	jmp    80106062 <alltraps>

801066c3 <vector40>:
.globl vector40
vector40:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $40
801066c5:	6a 28                	push   $0x28
  jmp alltraps
801066c7:	e9 96 f9 ff ff       	jmp    80106062 <alltraps>

801066cc <vector41>:
.globl vector41
vector41:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $41
801066ce:	6a 29                	push   $0x29
  jmp alltraps
801066d0:	e9 8d f9 ff ff       	jmp    80106062 <alltraps>

801066d5 <vector42>:
.globl vector42
vector42:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $42
801066d7:	6a 2a                	push   $0x2a
  jmp alltraps
801066d9:	e9 84 f9 ff ff       	jmp    80106062 <alltraps>

801066de <vector43>:
.globl vector43
vector43:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $43
801066e0:	6a 2b                	push   $0x2b
  jmp alltraps
801066e2:	e9 7b f9 ff ff       	jmp    80106062 <alltraps>

801066e7 <vector44>:
.globl vector44
vector44:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $44
801066e9:	6a 2c                	push   $0x2c
  jmp alltraps
801066eb:	e9 72 f9 ff ff       	jmp    80106062 <alltraps>

801066f0 <vector45>:
.globl vector45
vector45:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $45
801066f2:	6a 2d                	push   $0x2d
  jmp alltraps
801066f4:	e9 69 f9 ff ff       	jmp    80106062 <alltraps>

801066f9 <vector46>:
.globl vector46
vector46:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $46
801066fb:	6a 2e                	push   $0x2e
  jmp alltraps
801066fd:	e9 60 f9 ff ff       	jmp    80106062 <alltraps>

80106702 <vector47>:
.globl vector47
vector47:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $47
80106704:	6a 2f                	push   $0x2f
  jmp alltraps
80106706:	e9 57 f9 ff ff       	jmp    80106062 <alltraps>

8010670b <vector48>:
.globl vector48
vector48:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $48
8010670d:	6a 30                	push   $0x30
  jmp alltraps
8010670f:	e9 4e f9 ff ff       	jmp    80106062 <alltraps>

80106714 <vector49>:
.globl vector49
vector49:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $49
80106716:	6a 31                	push   $0x31
  jmp alltraps
80106718:	e9 45 f9 ff ff       	jmp    80106062 <alltraps>

8010671d <vector50>:
.globl vector50
vector50:
  pushl $0
8010671d:	6a 00                	push   $0x0
  pushl $50
8010671f:	6a 32                	push   $0x32
  jmp alltraps
80106721:	e9 3c f9 ff ff       	jmp    80106062 <alltraps>

80106726 <vector51>:
.globl vector51
vector51:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $51
80106728:	6a 33                	push   $0x33
  jmp alltraps
8010672a:	e9 33 f9 ff ff       	jmp    80106062 <alltraps>

8010672f <vector52>:
.globl vector52
vector52:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $52
80106731:	6a 34                	push   $0x34
  jmp alltraps
80106733:	e9 2a f9 ff ff       	jmp    80106062 <alltraps>

80106738 <vector53>:
.globl vector53
vector53:
  pushl $0
80106738:	6a 00                	push   $0x0
  pushl $53
8010673a:	6a 35                	push   $0x35
  jmp alltraps
8010673c:	e9 21 f9 ff ff       	jmp    80106062 <alltraps>

80106741 <vector54>:
.globl vector54
vector54:
  pushl $0
80106741:	6a 00                	push   $0x0
  pushl $54
80106743:	6a 36                	push   $0x36
  jmp alltraps
80106745:	e9 18 f9 ff ff       	jmp    80106062 <alltraps>

8010674a <vector55>:
.globl vector55
vector55:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $55
8010674c:	6a 37                	push   $0x37
  jmp alltraps
8010674e:	e9 0f f9 ff ff       	jmp    80106062 <alltraps>

80106753 <vector56>:
.globl vector56
vector56:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $56
80106755:	6a 38                	push   $0x38
  jmp alltraps
80106757:	e9 06 f9 ff ff       	jmp    80106062 <alltraps>

8010675c <vector57>:
.globl vector57
vector57:
  pushl $0
8010675c:	6a 00                	push   $0x0
  pushl $57
8010675e:	6a 39                	push   $0x39
  jmp alltraps
80106760:	e9 fd f8 ff ff       	jmp    80106062 <alltraps>

80106765 <vector58>:
.globl vector58
vector58:
  pushl $0
80106765:	6a 00                	push   $0x0
  pushl $58
80106767:	6a 3a                	push   $0x3a
  jmp alltraps
80106769:	e9 f4 f8 ff ff       	jmp    80106062 <alltraps>

8010676e <vector59>:
.globl vector59
vector59:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $59
80106770:	6a 3b                	push   $0x3b
  jmp alltraps
80106772:	e9 eb f8 ff ff       	jmp    80106062 <alltraps>

80106777 <vector60>:
.globl vector60
vector60:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $60
80106779:	6a 3c                	push   $0x3c
  jmp alltraps
8010677b:	e9 e2 f8 ff ff       	jmp    80106062 <alltraps>

80106780 <vector61>:
.globl vector61
vector61:
  pushl $0
80106780:	6a 00                	push   $0x0
  pushl $61
80106782:	6a 3d                	push   $0x3d
  jmp alltraps
80106784:	e9 d9 f8 ff ff       	jmp    80106062 <alltraps>

80106789 <vector62>:
.globl vector62
vector62:
  pushl $0
80106789:	6a 00                	push   $0x0
  pushl $62
8010678b:	6a 3e                	push   $0x3e
  jmp alltraps
8010678d:	e9 d0 f8 ff ff       	jmp    80106062 <alltraps>

80106792 <vector63>:
.globl vector63
vector63:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $63
80106794:	6a 3f                	push   $0x3f
  jmp alltraps
80106796:	e9 c7 f8 ff ff       	jmp    80106062 <alltraps>

8010679b <vector64>:
.globl vector64
vector64:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $64
8010679d:	6a 40                	push   $0x40
  jmp alltraps
8010679f:	e9 be f8 ff ff       	jmp    80106062 <alltraps>

801067a4 <vector65>:
.globl vector65
vector65:
  pushl $0
801067a4:	6a 00                	push   $0x0
  pushl $65
801067a6:	6a 41                	push   $0x41
  jmp alltraps
801067a8:	e9 b5 f8 ff ff       	jmp    80106062 <alltraps>

801067ad <vector66>:
.globl vector66
vector66:
  pushl $0
801067ad:	6a 00                	push   $0x0
  pushl $66
801067af:	6a 42                	push   $0x42
  jmp alltraps
801067b1:	e9 ac f8 ff ff       	jmp    80106062 <alltraps>

801067b6 <vector67>:
.globl vector67
vector67:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $67
801067b8:	6a 43                	push   $0x43
  jmp alltraps
801067ba:	e9 a3 f8 ff ff       	jmp    80106062 <alltraps>

801067bf <vector68>:
.globl vector68
vector68:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $68
801067c1:	6a 44                	push   $0x44
  jmp alltraps
801067c3:	e9 9a f8 ff ff       	jmp    80106062 <alltraps>

801067c8 <vector69>:
.globl vector69
vector69:
  pushl $0
801067c8:	6a 00                	push   $0x0
  pushl $69
801067ca:	6a 45                	push   $0x45
  jmp alltraps
801067cc:	e9 91 f8 ff ff       	jmp    80106062 <alltraps>

801067d1 <vector70>:
.globl vector70
vector70:
  pushl $0
801067d1:	6a 00                	push   $0x0
  pushl $70
801067d3:	6a 46                	push   $0x46
  jmp alltraps
801067d5:	e9 88 f8 ff ff       	jmp    80106062 <alltraps>

801067da <vector71>:
.globl vector71
vector71:
  pushl $0
801067da:	6a 00                	push   $0x0
  pushl $71
801067dc:	6a 47                	push   $0x47
  jmp alltraps
801067de:	e9 7f f8 ff ff       	jmp    80106062 <alltraps>

801067e3 <vector72>:
.globl vector72
vector72:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $72
801067e5:	6a 48                	push   $0x48
  jmp alltraps
801067e7:	e9 76 f8 ff ff       	jmp    80106062 <alltraps>

801067ec <vector73>:
.globl vector73
vector73:
  pushl $0
801067ec:	6a 00                	push   $0x0
  pushl $73
801067ee:	6a 49                	push   $0x49
  jmp alltraps
801067f0:	e9 6d f8 ff ff       	jmp    80106062 <alltraps>

801067f5 <vector74>:
.globl vector74
vector74:
  pushl $0
801067f5:	6a 00                	push   $0x0
  pushl $74
801067f7:	6a 4a                	push   $0x4a
  jmp alltraps
801067f9:	e9 64 f8 ff ff       	jmp    80106062 <alltraps>

801067fe <vector75>:
.globl vector75
vector75:
  pushl $0
801067fe:	6a 00                	push   $0x0
  pushl $75
80106800:	6a 4b                	push   $0x4b
  jmp alltraps
80106802:	e9 5b f8 ff ff       	jmp    80106062 <alltraps>

80106807 <vector76>:
.globl vector76
vector76:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $76
80106809:	6a 4c                	push   $0x4c
  jmp alltraps
8010680b:	e9 52 f8 ff ff       	jmp    80106062 <alltraps>

80106810 <vector77>:
.globl vector77
vector77:
  pushl $0
80106810:	6a 00                	push   $0x0
  pushl $77
80106812:	6a 4d                	push   $0x4d
  jmp alltraps
80106814:	e9 49 f8 ff ff       	jmp    80106062 <alltraps>

80106819 <vector78>:
.globl vector78
vector78:
  pushl $0
80106819:	6a 00                	push   $0x0
  pushl $78
8010681b:	6a 4e                	push   $0x4e
  jmp alltraps
8010681d:	e9 40 f8 ff ff       	jmp    80106062 <alltraps>

80106822 <vector79>:
.globl vector79
vector79:
  pushl $0
80106822:	6a 00                	push   $0x0
  pushl $79
80106824:	6a 4f                	push   $0x4f
  jmp alltraps
80106826:	e9 37 f8 ff ff       	jmp    80106062 <alltraps>

8010682b <vector80>:
.globl vector80
vector80:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $80
8010682d:	6a 50                	push   $0x50
  jmp alltraps
8010682f:	e9 2e f8 ff ff       	jmp    80106062 <alltraps>

80106834 <vector81>:
.globl vector81
vector81:
  pushl $0
80106834:	6a 00                	push   $0x0
  pushl $81
80106836:	6a 51                	push   $0x51
  jmp alltraps
80106838:	e9 25 f8 ff ff       	jmp    80106062 <alltraps>

8010683d <vector82>:
.globl vector82
vector82:
  pushl $0
8010683d:	6a 00                	push   $0x0
  pushl $82
8010683f:	6a 52                	push   $0x52
  jmp alltraps
80106841:	e9 1c f8 ff ff       	jmp    80106062 <alltraps>

80106846 <vector83>:
.globl vector83
vector83:
  pushl $0
80106846:	6a 00                	push   $0x0
  pushl $83
80106848:	6a 53                	push   $0x53
  jmp alltraps
8010684a:	e9 13 f8 ff ff       	jmp    80106062 <alltraps>

8010684f <vector84>:
.globl vector84
vector84:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $84
80106851:	6a 54                	push   $0x54
  jmp alltraps
80106853:	e9 0a f8 ff ff       	jmp    80106062 <alltraps>

80106858 <vector85>:
.globl vector85
vector85:
  pushl $0
80106858:	6a 00                	push   $0x0
  pushl $85
8010685a:	6a 55                	push   $0x55
  jmp alltraps
8010685c:	e9 01 f8 ff ff       	jmp    80106062 <alltraps>

80106861 <vector86>:
.globl vector86
vector86:
  pushl $0
80106861:	6a 00                	push   $0x0
  pushl $86
80106863:	6a 56                	push   $0x56
  jmp alltraps
80106865:	e9 f8 f7 ff ff       	jmp    80106062 <alltraps>

8010686a <vector87>:
.globl vector87
vector87:
  pushl $0
8010686a:	6a 00                	push   $0x0
  pushl $87
8010686c:	6a 57                	push   $0x57
  jmp alltraps
8010686e:	e9 ef f7 ff ff       	jmp    80106062 <alltraps>

80106873 <vector88>:
.globl vector88
vector88:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $88
80106875:	6a 58                	push   $0x58
  jmp alltraps
80106877:	e9 e6 f7 ff ff       	jmp    80106062 <alltraps>

8010687c <vector89>:
.globl vector89
vector89:
  pushl $0
8010687c:	6a 00                	push   $0x0
  pushl $89
8010687e:	6a 59                	push   $0x59
  jmp alltraps
80106880:	e9 dd f7 ff ff       	jmp    80106062 <alltraps>

80106885 <vector90>:
.globl vector90
vector90:
  pushl $0
80106885:	6a 00                	push   $0x0
  pushl $90
80106887:	6a 5a                	push   $0x5a
  jmp alltraps
80106889:	e9 d4 f7 ff ff       	jmp    80106062 <alltraps>

8010688e <vector91>:
.globl vector91
vector91:
  pushl $0
8010688e:	6a 00                	push   $0x0
  pushl $91
80106890:	6a 5b                	push   $0x5b
  jmp alltraps
80106892:	e9 cb f7 ff ff       	jmp    80106062 <alltraps>

80106897 <vector92>:
.globl vector92
vector92:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $92
80106899:	6a 5c                	push   $0x5c
  jmp alltraps
8010689b:	e9 c2 f7 ff ff       	jmp    80106062 <alltraps>

801068a0 <vector93>:
.globl vector93
vector93:
  pushl $0
801068a0:	6a 00                	push   $0x0
  pushl $93
801068a2:	6a 5d                	push   $0x5d
  jmp alltraps
801068a4:	e9 b9 f7 ff ff       	jmp    80106062 <alltraps>

801068a9 <vector94>:
.globl vector94
vector94:
  pushl $0
801068a9:	6a 00                	push   $0x0
  pushl $94
801068ab:	6a 5e                	push   $0x5e
  jmp alltraps
801068ad:	e9 b0 f7 ff ff       	jmp    80106062 <alltraps>

801068b2 <vector95>:
.globl vector95
vector95:
  pushl $0
801068b2:	6a 00                	push   $0x0
  pushl $95
801068b4:	6a 5f                	push   $0x5f
  jmp alltraps
801068b6:	e9 a7 f7 ff ff       	jmp    80106062 <alltraps>

801068bb <vector96>:
.globl vector96
vector96:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $96
801068bd:	6a 60                	push   $0x60
  jmp alltraps
801068bf:	e9 9e f7 ff ff       	jmp    80106062 <alltraps>

801068c4 <vector97>:
.globl vector97
vector97:
  pushl $0
801068c4:	6a 00                	push   $0x0
  pushl $97
801068c6:	6a 61                	push   $0x61
  jmp alltraps
801068c8:	e9 95 f7 ff ff       	jmp    80106062 <alltraps>

801068cd <vector98>:
.globl vector98
vector98:
  pushl $0
801068cd:	6a 00                	push   $0x0
  pushl $98
801068cf:	6a 62                	push   $0x62
  jmp alltraps
801068d1:	e9 8c f7 ff ff       	jmp    80106062 <alltraps>

801068d6 <vector99>:
.globl vector99
vector99:
  pushl $0
801068d6:	6a 00                	push   $0x0
  pushl $99
801068d8:	6a 63                	push   $0x63
  jmp alltraps
801068da:	e9 83 f7 ff ff       	jmp    80106062 <alltraps>

801068df <vector100>:
.globl vector100
vector100:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $100
801068e1:	6a 64                	push   $0x64
  jmp alltraps
801068e3:	e9 7a f7 ff ff       	jmp    80106062 <alltraps>

801068e8 <vector101>:
.globl vector101
vector101:
  pushl $0
801068e8:	6a 00                	push   $0x0
  pushl $101
801068ea:	6a 65                	push   $0x65
  jmp alltraps
801068ec:	e9 71 f7 ff ff       	jmp    80106062 <alltraps>

801068f1 <vector102>:
.globl vector102
vector102:
  pushl $0
801068f1:	6a 00                	push   $0x0
  pushl $102
801068f3:	6a 66                	push   $0x66
  jmp alltraps
801068f5:	e9 68 f7 ff ff       	jmp    80106062 <alltraps>

801068fa <vector103>:
.globl vector103
vector103:
  pushl $0
801068fa:	6a 00                	push   $0x0
  pushl $103
801068fc:	6a 67                	push   $0x67
  jmp alltraps
801068fe:	e9 5f f7 ff ff       	jmp    80106062 <alltraps>

80106903 <vector104>:
.globl vector104
vector104:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $104
80106905:	6a 68                	push   $0x68
  jmp alltraps
80106907:	e9 56 f7 ff ff       	jmp    80106062 <alltraps>

8010690c <vector105>:
.globl vector105
vector105:
  pushl $0
8010690c:	6a 00                	push   $0x0
  pushl $105
8010690e:	6a 69                	push   $0x69
  jmp alltraps
80106910:	e9 4d f7 ff ff       	jmp    80106062 <alltraps>

80106915 <vector106>:
.globl vector106
vector106:
  pushl $0
80106915:	6a 00                	push   $0x0
  pushl $106
80106917:	6a 6a                	push   $0x6a
  jmp alltraps
80106919:	e9 44 f7 ff ff       	jmp    80106062 <alltraps>

8010691e <vector107>:
.globl vector107
vector107:
  pushl $0
8010691e:	6a 00                	push   $0x0
  pushl $107
80106920:	6a 6b                	push   $0x6b
  jmp alltraps
80106922:	e9 3b f7 ff ff       	jmp    80106062 <alltraps>

80106927 <vector108>:
.globl vector108
vector108:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $108
80106929:	6a 6c                	push   $0x6c
  jmp alltraps
8010692b:	e9 32 f7 ff ff       	jmp    80106062 <alltraps>

80106930 <vector109>:
.globl vector109
vector109:
  pushl $0
80106930:	6a 00                	push   $0x0
  pushl $109
80106932:	6a 6d                	push   $0x6d
  jmp alltraps
80106934:	e9 29 f7 ff ff       	jmp    80106062 <alltraps>

80106939 <vector110>:
.globl vector110
vector110:
  pushl $0
80106939:	6a 00                	push   $0x0
  pushl $110
8010693b:	6a 6e                	push   $0x6e
  jmp alltraps
8010693d:	e9 20 f7 ff ff       	jmp    80106062 <alltraps>

80106942 <vector111>:
.globl vector111
vector111:
  pushl $0
80106942:	6a 00                	push   $0x0
  pushl $111
80106944:	6a 6f                	push   $0x6f
  jmp alltraps
80106946:	e9 17 f7 ff ff       	jmp    80106062 <alltraps>

8010694b <vector112>:
.globl vector112
vector112:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $112
8010694d:	6a 70                	push   $0x70
  jmp alltraps
8010694f:	e9 0e f7 ff ff       	jmp    80106062 <alltraps>

80106954 <vector113>:
.globl vector113
vector113:
  pushl $0
80106954:	6a 00                	push   $0x0
  pushl $113
80106956:	6a 71                	push   $0x71
  jmp alltraps
80106958:	e9 05 f7 ff ff       	jmp    80106062 <alltraps>

8010695d <vector114>:
.globl vector114
vector114:
  pushl $0
8010695d:	6a 00                	push   $0x0
  pushl $114
8010695f:	6a 72                	push   $0x72
  jmp alltraps
80106961:	e9 fc f6 ff ff       	jmp    80106062 <alltraps>

80106966 <vector115>:
.globl vector115
vector115:
  pushl $0
80106966:	6a 00                	push   $0x0
  pushl $115
80106968:	6a 73                	push   $0x73
  jmp alltraps
8010696a:	e9 f3 f6 ff ff       	jmp    80106062 <alltraps>

8010696f <vector116>:
.globl vector116
vector116:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $116
80106971:	6a 74                	push   $0x74
  jmp alltraps
80106973:	e9 ea f6 ff ff       	jmp    80106062 <alltraps>

80106978 <vector117>:
.globl vector117
vector117:
  pushl $0
80106978:	6a 00                	push   $0x0
  pushl $117
8010697a:	6a 75                	push   $0x75
  jmp alltraps
8010697c:	e9 e1 f6 ff ff       	jmp    80106062 <alltraps>

80106981 <vector118>:
.globl vector118
vector118:
  pushl $0
80106981:	6a 00                	push   $0x0
  pushl $118
80106983:	6a 76                	push   $0x76
  jmp alltraps
80106985:	e9 d8 f6 ff ff       	jmp    80106062 <alltraps>

8010698a <vector119>:
.globl vector119
vector119:
  pushl $0
8010698a:	6a 00                	push   $0x0
  pushl $119
8010698c:	6a 77                	push   $0x77
  jmp alltraps
8010698e:	e9 cf f6 ff ff       	jmp    80106062 <alltraps>

80106993 <vector120>:
.globl vector120
vector120:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $120
80106995:	6a 78                	push   $0x78
  jmp alltraps
80106997:	e9 c6 f6 ff ff       	jmp    80106062 <alltraps>

8010699c <vector121>:
.globl vector121
vector121:
  pushl $0
8010699c:	6a 00                	push   $0x0
  pushl $121
8010699e:	6a 79                	push   $0x79
  jmp alltraps
801069a0:	e9 bd f6 ff ff       	jmp    80106062 <alltraps>

801069a5 <vector122>:
.globl vector122
vector122:
  pushl $0
801069a5:	6a 00                	push   $0x0
  pushl $122
801069a7:	6a 7a                	push   $0x7a
  jmp alltraps
801069a9:	e9 b4 f6 ff ff       	jmp    80106062 <alltraps>

801069ae <vector123>:
.globl vector123
vector123:
  pushl $0
801069ae:	6a 00                	push   $0x0
  pushl $123
801069b0:	6a 7b                	push   $0x7b
  jmp alltraps
801069b2:	e9 ab f6 ff ff       	jmp    80106062 <alltraps>

801069b7 <vector124>:
.globl vector124
vector124:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $124
801069b9:	6a 7c                	push   $0x7c
  jmp alltraps
801069bb:	e9 a2 f6 ff ff       	jmp    80106062 <alltraps>

801069c0 <vector125>:
.globl vector125
vector125:
  pushl $0
801069c0:	6a 00                	push   $0x0
  pushl $125
801069c2:	6a 7d                	push   $0x7d
  jmp alltraps
801069c4:	e9 99 f6 ff ff       	jmp    80106062 <alltraps>

801069c9 <vector126>:
.globl vector126
vector126:
  pushl $0
801069c9:	6a 00                	push   $0x0
  pushl $126
801069cb:	6a 7e                	push   $0x7e
  jmp alltraps
801069cd:	e9 90 f6 ff ff       	jmp    80106062 <alltraps>

801069d2 <vector127>:
.globl vector127
vector127:
  pushl $0
801069d2:	6a 00                	push   $0x0
  pushl $127
801069d4:	6a 7f                	push   $0x7f
  jmp alltraps
801069d6:	e9 87 f6 ff ff       	jmp    80106062 <alltraps>

801069db <vector128>:
.globl vector128
vector128:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $128
801069dd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801069e2:	e9 7b f6 ff ff       	jmp    80106062 <alltraps>

801069e7 <vector129>:
.globl vector129
vector129:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $129
801069e9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801069ee:	e9 6f f6 ff ff       	jmp    80106062 <alltraps>

801069f3 <vector130>:
.globl vector130
vector130:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $130
801069f5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801069fa:	e9 63 f6 ff ff       	jmp    80106062 <alltraps>

801069ff <vector131>:
.globl vector131
vector131:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $131
80106a01:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a06:	e9 57 f6 ff ff       	jmp    80106062 <alltraps>

80106a0b <vector132>:
.globl vector132
vector132:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $132
80106a0d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a12:	e9 4b f6 ff ff       	jmp    80106062 <alltraps>

80106a17 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $133
80106a19:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a1e:	e9 3f f6 ff ff       	jmp    80106062 <alltraps>

80106a23 <vector134>:
.globl vector134
vector134:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $134
80106a25:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a2a:	e9 33 f6 ff ff       	jmp    80106062 <alltraps>

80106a2f <vector135>:
.globl vector135
vector135:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $135
80106a31:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106a36:	e9 27 f6 ff ff       	jmp    80106062 <alltraps>

80106a3b <vector136>:
.globl vector136
vector136:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $136
80106a3d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106a42:	e9 1b f6 ff ff       	jmp    80106062 <alltraps>

80106a47 <vector137>:
.globl vector137
vector137:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $137
80106a49:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106a4e:	e9 0f f6 ff ff       	jmp    80106062 <alltraps>

80106a53 <vector138>:
.globl vector138
vector138:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $138
80106a55:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106a5a:	e9 03 f6 ff ff       	jmp    80106062 <alltraps>

80106a5f <vector139>:
.globl vector139
vector139:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $139
80106a61:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106a66:	e9 f7 f5 ff ff       	jmp    80106062 <alltraps>

80106a6b <vector140>:
.globl vector140
vector140:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $140
80106a6d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106a72:	e9 eb f5 ff ff       	jmp    80106062 <alltraps>

80106a77 <vector141>:
.globl vector141
vector141:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $141
80106a79:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106a7e:	e9 df f5 ff ff       	jmp    80106062 <alltraps>

80106a83 <vector142>:
.globl vector142
vector142:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $142
80106a85:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106a8a:	e9 d3 f5 ff ff       	jmp    80106062 <alltraps>

80106a8f <vector143>:
.globl vector143
vector143:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $143
80106a91:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106a96:	e9 c7 f5 ff ff       	jmp    80106062 <alltraps>

80106a9b <vector144>:
.globl vector144
vector144:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $144
80106a9d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106aa2:	e9 bb f5 ff ff       	jmp    80106062 <alltraps>

80106aa7 <vector145>:
.globl vector145
vector145:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $145
80106aa9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106aae:	e9 af f5 ff ff       	jmp    80106062 <alltraps>

80106ab3 <vector146>:
.globl vector146
vector146:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $146
80106ab5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106aba:	e9 a3 f5 ff ff       	jmp    80106062 <alltraps>

80106abf <vector147>:
.globl vector147
vector147:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $147
80106ac1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ac6:	e9 97 f5 ff ff       	jmp    80106062 <alltraps>

80106acb <vector148>:
.globl vector148
vector148:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $148
80106acd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106ad2:	e9 8b f5 ff ff       	jmp    80106062 <alltraps>

80106ad7 <vector149>:
.globl vector149
vector149:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $149
80106ad9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106ade:	e9 7f f5 ff ff       	jmp    80106062 <alltraps>

80106ae3 <vector150>:
.globl vector150
vector150:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $150
80106ae5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106aea:	e9 73 f5 ff ff       	jmp    80106062 <alltraps>

80106aef <vector151>:
.globl vector151
vector151:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $151
80106af1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106af6:	e9 67 f5 ff ff       	jmp    80106062 <alltraps>

80106afb <vector152>:
.globl vector152
vector152:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $152
80106afd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b02:	e9 5b f5 ff ff       	jmp    80106062 <alltraps>

80106b07 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $153
80106b09:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b0e:	e9 4f f5 ff ff       	jmp    80106062 <alltraps>

80106b13 <vector154>:
.globl vector154
vector154:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $154
80106b15:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b1a:	e9 43 f5 ff ff       	jmp    80106062 <alltraps>

80106b1f <vector155>:
.globl vector155
vector155:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $155
80106b21:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b26:	e9 37 f5 ff ff       	jmp    80106062 <alltraps>

80106b2b <vector156>:
.globl vector156
vector156:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $156
80106b2d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b32:	e9 2b f5 ff ff       	jmp    80106062 <alltraps>

80106b37 <vector157>:
.globl vector157
vector157:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $157
80106b39:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106b3e:	e9 1f f5 ff ff       	jmp    80106062 <alltraps>

80106b43 <vector158>:
.globl vector158
vector158:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $158
80106b45:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106b4a:	e9 13 f5 ff ff       	jmp    80106062 <alltraps>

80106b4f <vector159>:
.globl vector159
vector159:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $159
80106b51:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106b56:	e9 07 f5 ff ff       	jmp    80106062 <alltraps>

80106b5b <vector160>:
.globl vector160
vector160:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $160
80106b5d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106b62:	e9 fb f4 ff ff       	jmp    80106062 <alltraps>

80106b67 <vector161>:
.globl vector161
vector161:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $161
80106b69:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106b6e:	e9 ef f4 ff ff       	jmp    80106062 <alltraps>

80106b73 <vector162>:
.globl vector162
vector162:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $162
80106b75:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106b7a:	e9 e3 f4 ff ff       	jmp    80106062 <alltraps>

80106b7f <vector163>:
.globl vector163
vector163:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $163
80106b81:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106b86:	e9 d7 f4 ff ff       	jmp    80106062 <alltraps>

80106b8b <vector164>:
.globl vector164
vector164:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $164
80106b8d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106b92:	e9 cb f4 ff ff       	jmp    80106062 <alltraps>

80106b97 <vector165>:
.globl vector165
vector165:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $165
80106b99:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106b9e:	e9 bf f4 ff ff       	jmp    80106062 <alltraps>

80106ba3 <vector166>:
.globl vector166
vector166:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $166
80106ba5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106baa:	e9 b3 f4 ff ff       	jmp    80106062 <alltraps>

80106baf <vector167>:
.globl vector167
vector167:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $167
80106bb1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106bb6:	e9 a7 f4 ff ff       	jmp    80106062 <alltraps>

80106bbb <vector168>:
.globl vector168
vector168:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $168
80106bbd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106bc2:	e9 9b f4 ff ff       	jmp    80106062 <alltraps>

80106bc7 <vector169>:
.globl vector169
vector169:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $169
80106bc9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106bce:	e9 8f f4 ff ff       	jmp    80106062 <alltraps>

80106bd3 <vector170>:
.globl vector170
vector170:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $170
80106bd5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106bda:	e9 83 f4 ff ff       	jmp    80106062 <alltraps>

80106bdf <vector171>:
.globl vector171
vector171:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $171
80106be1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106be6:	e9 77 f4 ff ff       	jmp    80106062 <alltraps>

80106beb <vector172>:
.globl vector172
vector172:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $172
80106bed:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106bf2:	e9 6b f4 ff ff       	jmp    80106062 <alltraps>

80106bf7 <vector173>:
.globl vector173
vector173:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $173
80106bf9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106bfe:	e9 5f f4 ff ff       	jmp    80106062 <alltraps>

80106c03 <vector174>:
.globl vector174
vector174:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $174
80106c05:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c0a:	e9 53 f4 ff ff       	jmp    80106062 <alltraps>

80106c0f <vector175>:
.globl vector175
vector175:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $175
80106c11:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c16:	e9 47 f4 ff ff       	jmp    80106062 <alltraps>

80106c1b <vector176>:
.globl vector176
vector176:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $176
80106c1d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c22:	e9 3b f4 ff ff       	jmp    80106062 <alltraps>

80106c27 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $177
80106c29:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c2e:	e9 2f f4 ff ff       	jmp    80106062 <alltraps>

80106c33 <vector178>:
.globl vector178
vector178:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $178
80106c35:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106c3a:	e9 23 f4 ff ff       	jmp    80106062 <alltraps>

80106c3f <vector179>:
.globl vector179
vector179:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $179
80106c41:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106c46:	e9 17 f4 ff ff       	jmp    80106062 <alltraps>

80106c4b <vector180>:
.globl vector180
vector180:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $180
80106c4d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106c52:	e9 0b f4 ff ff       	jmp    80106062 <alltraps>

80106c57 <vector181>:
.globl vector181
vector181:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $181
80106c59:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106c5e:	e9 ff f3 ff ff       	jmp    80106062 <alltraps>

80106c63 <vector182>:
.globl vector182
vector182:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $182
80106c65:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106c6a:	e9 f3 f3 ff ff       	jmp    80106062 <alltraps>

80106c6f <vector183>:
.globl vector183
vector183:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $183
80106c71:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106c76:	e9 e7 f3 ff ff       	jmp    80106062 <alltraps>

80106c7b <vector184>:
.globl vector184
vector184:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $184
80106c7d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106c82:	e9 db f3 ff ff       	jmp    80106062 <alltraps>

80106c87 <vector185>:
.globl vector185
vector185:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $185
80106c89:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106c8e:	e9 cf f3 ff ff       	jmp    80106062 <alltraps>

80106c93 <vector186>:
.globl vector186
vector186:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $186
80106c95:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106c9a:	e9 c3 f3 ff ff       	jmp    80106062 <alltraps>

80106c9f <vector187>:
.globl vector187
vector187:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $187
80106ca1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ca6:	e9 b7 f3 ff ff       	jmp    80106062 <alltraps>

80106cab <vector188>:
.globl vector188
vector188:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $188
80106cad:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106cb2:	e9 ab f3 ff ff       	jmp    80106062 <alltraps>

80106cb7 <vector189>:
.globl vector189
vector189:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $189
80106cb9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106cbe:	e9 9f f3 ff ff       	jmp    80106062 <alltraps>

80106cc3 <vector190>:
.globl vector190
vector190:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $190
80106cc5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106cca:	e9 93 f3 ff ff       	jmp    80106062 <alltraps>

80106ccf <vector191>:
.globl vector191
vector191:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $191
80106cd1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106cd6:	e9 87 f3 ff ff       	jmp    80106062 <alltraps>

80106cdb <vector192>:
.globl vector192
vector192:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $192
80106cdd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106ce2:	e9 7b f3 ff ff       	jmp    80106062 <alltraps>

80106ce7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $193
80106ce9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106cee:	e9 6f f3 ff ff       	jmp    80106062 <alltraps>

80106cf3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $194
80106cf5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106cfa:	e9 63 f3 ff ff       	jmp    80106062 <alltraps>

80106cff <vector195>:
.globl vector195
vector195:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $195
80106d01:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d06:	e9 57 f3 ff ff       	jmp    80106062 <alltraps>

80106d0b <vector196>:
.globl vector196
vector196:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $196
80106d0d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d12:	e9 4b f3 ff ff       	jmp    80106062 <alltraps>

80106d17 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $197
80106d19:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d1e:	e9 3f f3 ff ff       	jmp    80106062 <alltraps>

80106d23 <vector198>:
.globl vector198
vector198:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $198
80106d25:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d2a:	e9 33 f3 ff ff       	jmp    80106062 <alltraps>

80106d2f <vector199>:
.globl vector199
vector199:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $199
80106d31:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106d36:	e9 27 f3 ff ff       	jmp    80106062 <alltraps>

80106d3b <vector200>:
.globl vector200
vector200:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $200
80106d3d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106d42:	e9 1b f3 ff ff       	jmp    80106062 <alltraps>

80106d47 <vector201>:
.globl vector201
vector201:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $201
80106d49:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106d4e:	e9 0f f3 ff ff       	jmp    80106062 <alltraps>

80106d53 <vector202>:
.globl vector202
vector202:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $202
80106d55:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106d5a:	e9 03 f3 ff ff       	jmp    80106062 <alltraps>

80106d5f <vector203>:
.globl vector203
vector203:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $203
80106d61:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106d66:	e9 f7 f2 ff ff       	jmp    80106062 <alltraps>

80106d6b <vector204>:
.globl vector204
vector204:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $204
80106d6d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106d72:	e9 eb f2 ff ff       	jmp    80106062 <alltraps>

80106d77 <vector205>:
.globl vector205
vector205:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $205
80106d79:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106d7e:	e9 df f2 ff ff       	jmp    80106062 <alltraps>

80106d83 <vector206>:
.globl vector206
vector206:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $206
80106d85:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106d8a:	e9 d3 f2 ff ff       	jmp    80106062 <alltraps>

80106d8f <vector207>:
.globl vector207
vector207:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $207
80106d91:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106d96:	e9 c7 f2 ff ff       	jmp    80106062 <alltraps>

80106d9b <vector208>:
.globl vector208
vector208:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $208
80106d9d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106da2:	e9 bb f2 ff ff       	jmp    80106062 <alltraps>

80106da7 <vector209>:
.globl vector209
vector209:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $209
80106da9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106dae:	e9 af f2 ff ff       	jmp    80106062 <alltraps>

80106db3 <vector210>:
.globl vector210
vector210:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $210
80106db5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106dba:	e9 a3 f2 ff ff       	jmp    80106062 <alltraps>

80106dbf <vector211>:
.globl vector211
vector211:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $211
80106dc1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106dc6:	e9 97 f2 ff ff       	jmp    80106062 <alltraps>

80106dcb <vector212>:
.globl vector212
vector212:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $212
80106dcd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106dd2:	e9 8b f2 ff ff       	jmp    80106062 <alltraps>

80106dd7 <vector213>:
.globl vector213
vector213:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $213
80106dd9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106dde:	e9 7f f2 ff ff       	jmp    80106062 <alltraps>

80106de3 <vector214>:
.globl vector214
vector214:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $214
80106de5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106dea:	e9 73 f2 ff ff       	jmp    80106062 <alltraps>

80106def <vector215>:
.globl vector215
vector215:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $215
80106df1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106df6:	e9 67 f2 ff ff       	jmp    80106062 <alltraps>

80106dfb <vector216>:
.globl vector216
vector216:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $216
80106dfd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e02:	e9 5b f2 ff ff       	jmp    80106062 <alltraps>

80106e07 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $217
80106e09:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e0e:	e9 4f f2 ff ff       	jmp    80106062 <alltraps>

80106e13 <vector218>:
.globl vector218
vector218:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $218
80106e15:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e1a:	e9 43 f2 ff ff       	jmp    80106062 <alltraps>

80106e1f <vector219>:
.globl vector219
vector219:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $219
80106e21:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e26:	e9 37 f2 ff ff       	jmp    80106062 <alltraps>

80106e2b <vector220>:
.globl vector220
vector220:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $220
80106e2d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e32:	e9 2b f2 ff ff       	jmp    80106062 <alltraps>

80106e37 <vector221>:
.globl vector221
vector221:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $221
80106e39:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106e3e:	e9 1f f2 ff ff       	jmp    80106062 <alltraps>

80106e43 <vector222>:
.globl vector222
vector222:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $222
80106e45:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106e4a:	e9 13 f2 ff ff       	jmp    80106062 <alltraps>

80106e4f <vector223>:
.globl vector223
vector223:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $223
80106e51:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106e56:	e9 07 f2 ff ff       	jmp    80106062 <alltraps>

80106e5b <vector224>:
.globl vector224
vector224:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $224
80106e5d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106e62:	e9 fb f1 ff ff       	jmp    80106062 <alltraps>

80106e67 <vector225>:
.globl vector225
vector225:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $225
80106e69:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106e6e:	e9 ef f1 ff ff       	jmp    80106062 <alltraps>

80106e73 <vector226>:
.globl vector226
vector226:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $226
80106e75:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106e7a:	e9 e3 f1 ff ff       	jmp    80106062 <alltraps>

80106e7f <vector227>:
.globl vector227
vector227:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $227
80106e81:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106e86:	e9 d7 f1 ff ff       	jmp    80106062 <alltraps>

80106e8b <vector228>:
.globl vector228
vector228:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $228
80106e8d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106e92:	e9 cb f1 ff ff       	jmp    80106062 <alltraps>

80106e97 <vector229>:
.globl vector229
vector229:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $229
80106e99:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106e9e:	e9 bf f1 ff ff       	jmp    80106062 <alltraps>

80106ea3 <vector230>:
.globl vector230
vector230:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $230
80106ea5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106eaa:	e9 b3 f1 ff ff       	jmp    80106062 <alltraps>

80106eaf <vector231>:
.globl vector231
vector231:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $231
80106eb1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106eb6:	e9 a7 f1 ff ff       	jmp    80106062 <alltraps>

80106ebb <vector232>:
.globl vector232
vector232:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $232
80106ebd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ec2:	e9 9b f1 ff ff       	jmp    80106062 <alltraps>

80106ec7 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $233
80106ec9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106ece:	e9 8f f1 ff ff       	jmp    80106062 <alltraps>

80106ed3 <vector234>:
.globl vector234
vector234:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $234
80106ed5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106eda:	e9 83 f1 ff ff       	jmp    80106062 <alltraps>

80106edf <vector235>:
.globl vector235
vector235:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $235
80106ee1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ee6:	e9 77 f1 ff ff       	jmp    80106062 <alltraps>

80106eeb <vector236>:
.globl vector236
vector236:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $236
80106eed:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106ef2:	e9 6b f1 ff ff       	jmp    80106062 <alltraps>

80106ef7 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $237
80106ef9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106efe:	e9 5f f1 ff ff       	jmp    80106062 <alltraps>

80106f03 <vector238>:
.globl vector238
vector238:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $238
80106f05:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f0a:	e9 53 f1 ff ff       	jmp    80106062 <alltraps>

80106f0f <vector239>:
.globl vector239
vector239:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $239
80106f11:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f16:	e9 47 f1 ff ff       	jmp    80106062 <alltraps>

80106f1b <vector240>:
.globl vector240
vector240:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $240
80106f1d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f22:	e9 3b f1 ff ff       	jmp    80106062 <alltraps>

80106f27 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $241
80106f29:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f2e:	e9 2f f1 ff ff       	jmp    80106062 <alltraps>

80106f33 <vector242>:
.globl vector242
vector242:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $242
80106f35:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106f3a:	e9 23 f1 ff ff       	jmp    80106062 <alltraps>

80106f3f <vector243>:
.globl vector243
vector243:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $243
80106f41:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106f46:	e9 17 f1 ff ff       	jmp    80106062 <alltraps>

80106f4b <vector244>:
.globl vector244
vector244:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $244
80106f4d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106f52:	e9 0b f1 ff ff       	jmp    80106062 <alltraps>

80106f57 <vector245>:
.globl vector245
vector245:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $245
80106f59:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106f5e:	e9 ff f0 ff ff       	jmp    80106062 <alltraps>

80106f63 <vector246>:
.globl vector246
vector246:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $246
80106f65:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106f6a:	e9 f3 f0 ff ff       	jmp    80106062 <alltraps>

80106f6f <vector247>:
.globl vector247
vector247:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $247
80106f71:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106f76:	e9 e7 f0 ff ff       	jmp    80106062 <alltraps>

80106f7b <vector248>:
.globl vector248
vector248:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $248
80106f7d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106f82:	e9 db f0 ff ff       	jmp    80106062 <alltraps>

80106f87 <vector249>:
.globl vector249
vector249:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $249
80106f89:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106f8e:	e9 cf f0 ff ff       	jmp    80106062 <alltraps>

80106f93 <vector250>:
.globl vector250
vector250:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $250
80106f95:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106f9a:	e9 c3 f0 ff ff       	jmp    80106062 <alltraps>

80106f9f <vector251>:
.globl vector251
vector251:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $251
80106fa1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106fa6:	e9 b7 f0 ff ff       	jmp    80106062 <alltraps>

80106fab <vector252>:
.globl vector252
vector252:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $252
80106fad:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106fb2:	e9 ab f0 ff ff       	jmp    80106062 <alltraps>

80106fb7 <vector253>:
.globl vector253
vector253:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $253
80106fb9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106fbe:	e9 9f f0 ff ff       	jmp    80106062 <alltraps>

80106fc3 <vector254>:
.globl vector254
vector254:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $254
80106fc5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106fca:	e9 93 f0 ff ff       	jmp    80106062 <alltraps>

80106fcf <vector255>:
.globl vector255
vector255:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $255
80106fd1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106fd6:	e9 87 f0 ff ff       	jmp    80106062 <alltraps>
80106fdb:	66 90                	xchg   %ax,%ax
80106fdd:	66 90                	xchg   %ax,%ax
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
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107020:	85 c9                	test   %ecx,%ecx
80107022:	74 2c                	je     80107050 <walkpgdir+0x70>
80107024:	e8 07 b6 ff ff       	call   80102630 <kalloc>
80107029:	89 c3                	mov    %eax,%ebx
8010702b:	85 c0                	test   %eax,%eax
8010702d:	74 21                	je     80107050 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010702f:	83 ec 04             	sub    $0x4,%esp
80107032:	68 00 10 00 00       	push   $0x1000
80107037:	6a 00                	push   $0x0
80107039:	50                   	push   %eax
8010703a:	e8 51 dd ff ff       	call   80104d90 <memset>
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
801070dd:	68 fc 81 10 80       	push   $0x801081fc
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
  uint a, pa;

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
    else if((*pte & PTE_P) != 0){
8010713c:	8b 00                	mov    (%eax),%eax
8010713e:	a8 01                	test   $0x1,%al
80107140:	74 de                	je     80107120 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107142:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107147:	74 47                	je     80107190 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107149:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010714c:	05 00 00 00 80       	add    $0x80000000,%eax
80107151:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107157:	50                   	push   %eax
80107158:	e8 13 b3 ff ff       	call   80102470 <kfree>
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
        panic("kfree");
80107190:	83 ec 0c             	sub    $0xc,%esp
80107193:	68 86 7b 10 80       	push   $0x80107b86
80107198:	e8 f3 91 ff ff       	call   80100390 <panic>
8010719d:	8d 76 00             	lea    0x0(%esi),%esi

801071a0 <seginit>:
{
801071a0:	f3 0f 1e fb          	endbr32 
801071a4:	55                   	push   %ebp
801071a5:	89 e5                	mov    %esp,%ebp
801071a7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801071aa:	e8 21 ca ff ff       	call   80103bd0 <cpuid>
  pd[0] = size-1;
801071af:	ba 2f 00 00 00       	mov    $0x2f,%edx
801071b4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801071ba:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801071be:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
801071c5:	ff 00 00 
801071c8:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
801071cf:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801071d2:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
801071d9:	ff 00 00 
801071dc:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
801071e3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801071e6:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
801071ed:	ff 00 00 
801071f0:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
801071f7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071fa:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80107201:	ff 00 00 
80107204:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
8010720b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010720e:	05 f0 37 11 80       	add    $0x801137f0,%eax
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

80107230 <switchkvm>:
{
80107230:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107234:	a1 a4 6c 11 80       	mov    0x80116ca4,%eax
80107239:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010723e:	0f 22 d8             	mov    %eax,%cr3
}
80107241:	c3                   	ret    
80107242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107250 <switchuvm>:
{
80107250:	f3 0f 1e fb          	endbr32 
80107254:	55                   	push   %ebp
80107255:	89 e5                	mov    %esp,%ebp
80107257:	57                   	push   %edi
80107258:	56                   	push   %esi
80107259:	53                   	push   %ebx
8010725a:	83 ec 1c             	sub    $0x1c,%esp
8010725d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107260:	85 f6                	test   %esi,%esi
80107262:	0f 84 cb 00 00 00    	je     80107333 <switchuvm+0xe3>
  if(p->kstack == 0)
80107268:	8b 46 08             	mov    0x8(%esi),%eax
8010726b:	85 c0                	test   %eax,%eax
8010726d:	0f 84 da 00 00 00    	je     8010734d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107273:	8b 46 04             	mov    0x4(%esi),%eax
80107276:	85 c0                	test   %eax,%eax
80107278:	0f 84 c2 00 00 00    	je     80107340 <switchuvm+0xf0>
  pushcli();
8010727e:	e8 fd d8 ff ff       	call   80104b80 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107283:	e8 d8 c8 ff ff       	call   80103b60 <mycpu>
80107288:	89 c3                	mov    %eax,%ebx
8010728a:	e8 d1 c8 ff ff       	call   80103b60 <mycpu>
8010728f:	89 c7                	mov    %eax,%edi
80107291:	e8 ca c8 ff ff       	call   80103b60 <mycpu>
80107296:	83 c7 08             	add    $0x8,%edi
80107299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010729c:	e8 bf c8 ff ff       	call   80103b60 <mycpu>
801072a1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801072a4:	ba 67 00 00 00       	mov    $0x67,%edx
801072a9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801072b0:	83 c0 08             	add    $0x8,%eax
801072b3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072ba:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072bf:	83 c1 08             	add    $0x8,%ecx
801072c2:	c1 e8 18             	shr    $0x18,%eax
801072c5:	c1 e9 10             	shr    $0x10,%ecx
801072c8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801072ce:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801072d4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801072d9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072e0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801072e5:	e8 76 c8 ff ff       	call   80103b60 <mycpu>
801072ea:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072f1:	e8 6a c8 ff ff       	call   80103b60 <mycpu>
801072f6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801072fa:	8b 5e 08             	mov    0x8(%esi),%ebx
801072fd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107303:	e8 58 c8 ff ff       	call   80103b60 <mycpu>
80107308:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010730b:	e8 50 c8 ff ff       	call   80103b60 <mycpu>
80107310:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107314:	b8 28 00 00 00       	mov    $0x28,%eax
80107319:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010731c:	8b 46 04             	mov    0x4(%esi),%eax
8010731f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107324:	0f 22 d8             	mov    %eax,%cr3
}
80107327:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010732a:	5b                   	pop    %ebx
8010732b:	5e                   	pop    %esi
8010732c:	5f                   	pop    %edi
8010732d:	5d                   	pop    %ebp
  popcli();
8010732e:	e9 9d d8 ff ff       	jmp    80104bd0 <popcli>
    panic("switchuvm: no process");
80107333:	83 ec 0c             	sub    $0xc,%esp
80107336:	68 02 82 10 80       	push   $0x80108202
8010733b:	e8 50 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107340:	83 ec 0c             	sub    $0xc,%esp
80107343:	68 2d 82 10 80       	push   $0x8010822d
80107348:	e8 43 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010734d:	83 ec 0c             	sub    $0xc,%esp
80107350:	68 18 82 10 80       	push   $0x80108218
80107355:	e8 36 90 ff ff       	call   80100390 <panic>
8010735a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107360 <inituvm>:
{
80107360:	f3 0f 1e fb          	endbr32 
80107364:	55                   	push   %ebp
80107365:	89 e5                	mov    %esp,%ebp
80107367:	57                   	push   %edi
80107368:	56                   	push   %esi
80107369:	53                   	push   %ebx
8010736a:	83 ec 1c             	sub    $0x1c,%esp
8010736d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107370:	8b 75 10             	mov    0x10(%ebp),%esi
80107373:	8b 7d 08             	mov    0x8(%ebp),%edi
80107376:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107379:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010737f:	77 4b                	ja     801073cc <inituvm+0x6c>
  mem = kalloc();
80107381:	e8 aa b2 ff ff       	call   80102630 <kalloc>
  memset(mem, 0, PGSIZE);
80107386:	83 ec 04             	sub    $0x4,%esp
80107389:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010738e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107390:	6a 00                	push   $0x0
80107392:	50                   	push   %eax
80107393:	e8 f8 d9 ff ff       	call   80104d90 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107398:	58                   	pop    %eax
80107399:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010739f:	5a                   	pop    %edx
801073a0:	6a 06                	push   $0x6
801073a2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073a7:	31 d2                	xor    %edx,%edx
801073a9:	50                   	push   %eax
801073aa:	89 f8                	mov    %edi,%eax
801073ac:	e8 af fc ff ff       	call   80107060 <mappages>
  memmove(mem, init, sz);
801073b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073b4:	89 75 10             	mov    %esi,0x10(%ebp)
801073b7:	83 c4 10             	add    $0x10,%esp
801073ba:	89 5d 08             	mov    %ebx,0x8(%ebp)
801073bd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801073c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073c3:	5b                   	pop    %ebx
801073c4:	5e                   	pop    %esi
801073c5:	5f                   	pop    %edi
801073c6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801073c7:	e9 64 da ff ff       	jmp    80104e30 <memmove>
    panic("inituvm: more than a page");
801073cc:	83 ec 0c             	sub    $0xc,%esp
801073cf:	68 41 82 10 80       	push   $0x80108241
801073d4:	e8 b7 8f ff ff       	call   80100390 <panic>
801073d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073e0 <loaduvm>:
{
801073e0:	f3 0f 1e fb          	endbr32 
801073e4:	55                   	push   %ebp
801073e5:	89 e5                	mov    %esp,%ebp
801073e7:	57                   	push   %edi
801073e8:	56                   	push   %esi
801073e9:	53                   	push   %ebx
801073ea:	83 ec 1c             	sub    $0x1c,%esp
801073ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801073f0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801073f3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801073f8:	0f 85 99 00 00 00    	jne    80107497 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
801073fe:	01 f0                	add    %esi,%eax
80107400:	89 f3                	mov    %esi,%ebx
80107402:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107405:	8b 45 14             	mov    0x14(%ebp),%eax
80107408:	01 f0                	add    %esi,%eax
8010740a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010740d:	85 f6                	test   %esi,%esi
8010740f:	75 15                	jne    80107426 <loaduvm+0x46>
80107411:	eb 6d                	jmp    80107480 <loaduvm+0xa0>
80107413:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107417:	90                   	nop
80107418:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010741e:	89 f0                	mov    %esi,%eax
80107420:	29 d8                	sub    %ebx,%eax
80107422:	39 c6                	cmp    %eax,%esi
80107424:	76 5a                	jbe    80107480 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107426:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107429:	8b 45 08             	mov    0x8(%ebp),%eax
8010742c:	31 c9                	xor    %ecx,%ecx
8010742e:	29 da                	sub    %ebx,%edx
80107430:	e8 ab fb ff ff       	call   80106fe0 <walkpgdir>
80107435:	85 c0                	test   %eax,%eax
80107437:	74 51                	je     8010748a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107439:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010743b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010743e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107443:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107448:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010744e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107451:	29 d9                	sub    %ebx,%ecx
80107453:	05 00 00 00 80       	add    $0x80000000,%eax
80107458:	57                   	push   %edi
80107459:	51                   	push   %ecx
8010745a:	50                   	push   %eax
8010745b:	ff 75 10             	pushl  0x10(%ebp)
8010745e:	e8 fd a5 ff ff       	call   80101a60 <readi>
80107463:	83 c4 10             	add    $0x10,%esp
80107466:	39 f8                	cmp    %edi,%eax
80107468:	74 ae                	je     80107418 <loaduvm+0x38>
}
8010746a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010746d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107472:	5b                   	pop    %ebx
80107473:	5e                   	pop    %esi
80107474:	5f                   	pop    %edi
80107475:	5d                   	pop    %ebp
80107476:	c3                   	ret    
80107477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010747e:	66 90                	xchg   %ax,%ax
80107480:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107483:	31 c0                	xor    %eax,%eax
}
80107485:	5b                   	pop    %ebx
80107486:	5e                   	pop    %esi
80107487:	5f                   	pop    %edi
80107488:	5d                   	pop    %ebp
80107489:	c3                   	ret    
      panic("loaduvm: address should exist");
8010748a:	83 ec 0c             	sub    $0xc,%esp
8010748d:	68 5b 82 10 80       	push   $0x8010825b
80107492:	e8 f9 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107497:	83 ec 0c             	sub    $0xc,%esp
8010749a:	68 fc 82 10 80       	push   $0x801082fc
8010749f:	e8 ec 8e ff ff       	call   80100390 <panic>
801074a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074af:	90                   	nop

801074b0 <allocuvm>:
{
801074b0:	f3 0f 1e fb          	endbr32 
801074b4:	55                   	push   %ebp
801074b5:	89 e5                	mov    %esp,%ebp
801074b7:	57                   	push   %edi
801074b8:	56                   	push   %esi
801074b9:	53                   	push   %ebx
801074ba:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801074bd:	8b 45 10             	mov    0x10(%ebp),%eax
{
801074c0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801074c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074c6:	85 c0                	test   %eax,%eax
801074c8:	0f 88 b2 00 00 00    	js     80107580 <allocuvm+0xd0>
  if(newsz < oldsz)
801074ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801074d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801074d4:	0f 82 96 00 00 00    	jb     80107570 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801074da:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801074e0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801074e6:	39 75 10             	cmp    %esi,0x10(%ebp)
801074e9:	77 40                	ja     8010752b <allocuvm+0x7b>
801074eb:	e9 83 00 00 00       	jmp    80107573 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
801074f0:	83 ec 04             	sub    $0x4,%esp
801074f3:	68 00 10 00 00       	push   $0x1000
801074f8:	6a 00                	push   $0x0
801074fa:	50                   	push   %eax
801074fb:	e8 90 d8 ff ff       	call   80104d90 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107500:	58                   	pop    %eax
80107501:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107507:	5a                   	pop    %edx
80107508:	6a 06                	push   $0x6
8010750a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010750f:	89 f2                	mov    %esi,%edx
80107511:	50                   	push   %eax
80107512:	89 f8                	mov    %edi,%eax
80107514:	e8 47 fb ff ff       	call   80107060 <mappages>
80107519:	83 c4 10             	add    $0x10,%esp
8010751c:	85 c0                	test   %eax,%eax
8010751e:	78 78                	js     80107598 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107520:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107526:	39 75 10             	cmp    %esi,0x10(%ebp)
80107529:	76 48                	jbe    80107573 <allocuvm+0xc3>
    mem = kalloc();
8010752b:	e8 00 b1 ff ff       	call   80102630 <kalloc>
80107530:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107532:	85 c0                	test   %eax,%eax
80107534:	75 ba                	jne    801074f0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107536:	83 ec 0c             	sub    $0xc,%esp
80107539:	68 79 82 10 80       	push   $0x80108279
8010753e:	e8 6d 91 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107543:	8b 45 0c             	mov    0xc(%ebp),%eax
80107546:	83 c4 10             	add    $0x10,%esp
80107549:	39 45 10             	cmp    %eax,0x10(%ebp)
8010754c:	74 32                	je     80107580 <allocuvm+0xd0>
8010754e:	8b 55 10             	mov    0x10(%ebp),%edx
80107551:	89 c1                	mov    %eax,%ecx
80107553:	89 f8                	mov    %edi,%eax
80107555:	e8 96 fb ff ff       	call   801070f0 <deallocuvm.part.0>
      return 0;
8010755a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107561:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107564:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107567:	5b                   	pop    %ebx
80107568:	5e                   	pop    %esi
80107569:	5f                   	pop    %edi
8010756a:	5d                   	pop    %ebp
8010756b:	c3                   	ret    
8010756c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107570:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107576:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107579:	5b                   	pop    %ebx
8010757a:	5e                   	pop    %esi
8010757b:	5f                   	pop    %edi
8010757c:	5d                   	pop    %ebp
8010757d:	c3                   	ret    
8010757e:	66 90                	xchg   %ax,%ax
    return 0;
80107580:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010758a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010758d:	5b                   	pop    %ebx
8010758e:	5e                   	pop    %esi
8010758f:	5f                   	pop    %edi
80107590:	5d                   	pop    %ebp
80107591:	c3                   	ret    
80107592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107598:	83 ec 0c             	sub    $0xc,%esp
8010759b:	68 91 82 10 80       	push   $0x80108291
801075a0:	e8 0b 91 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801075a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801075a8:	83 c4 10             	add    $0x10,%esp
801075ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801075ae:	74 0c                	je     801075bc <allocuvm+0x10c>
801075b0:	8b 55 10             	mov    0x10(%ebp),%edx
801075b3:	89 c1                	mov    %eax,%ecx
801075b5:	89 f8                	mov    %edi,%eax
801075b7:	e8 34 fb ff ff       	call   801070f0 <deallocuvm.part.0>
      kfree(mem);
801075bc:	83 ec 0c             	sub    $0xc,%esp
801075bf:	53                   	push   %ebx
801075c0:	e8 ab ae ff ff       	call   80102470 <kfree>
      return 0;
801075c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801075cc:	83 c4 10             	add    $0x10,%esp
}
801075cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075d5:	5b                   	pop    %ebx
801075d6:	5e                   	pop    %esi
801075d7:	5f                   	pop    %edi
801075d8:	5d                   	pop    %ebp
801075d9:	c3                   	ret    
801075da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075e0 <deallocuvm>:
{
801075e0:	f3 0f 1e fb          	endbr32 
801075e4:	55                   	push   %ebp
801075e5:	89 e5                	mov    %esp,%ebp
801075e7:	8b 55 0c             	mov    0xc(%ebp),%edx
801075ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
801075ed:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801075f0:	39 d1                	cmp    %edx,%ecx
801075f2:	73 0c                	jae    80107600 <deallocuvm+0x20>
}
801075f4:	5d                   	pop    %ebp
801075f5:	e9 f6 fa ff ff       	jmp    801070f0 <deallocuvm.part.0>
801075fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107600:	89 d0                	mov    %edx,%eax
80107602:	5d                   	pop    %ebp
80107603:	c3                   	ret    
80107604:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010760b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010760f:	90                   	nop

80107610 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107610:	f3 0f 1e fb          	endbr32 
80107614:	55                   	push   %ebp
80107615:	89 e5                	mov    %esp,%ebp
80107617:	57                   	push   %edi
80107618:	56                   	push   %esi
80107619:	53                   	push   %ebx
8010761a:	83 ec 0c             	sub    $0xc,%esp
8010761d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107620:	85 f6                	test   %esi,%esi
80107622:	74 55                	je     80107679 <freevm+0x69>
  if(newsz >= oldsz)
80107624:	31 c9                	xor    %ecx,%ecx
80107626:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010762b:	89 f0                	mov    %esi,%eax
8010762d:	89 f3                	mov    %esi,%ebx
8010762f:	e8 bc fa ff ff       	call   801070f0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107634:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010763a:	eb 0b                	jmp    80107647 <freevm+0x37>
8010763c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107640:	83 c3 04             	add    $0x4,%ebx
80107643:	39 df                	cmp    %ebx,%edi
80107645:	74 23                	je     8010766a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107647:	8b 03                	mov    (%ebx),%eax
80107649:	a8 01                	test   $0x1,%al
8010764b:	74 f3                	je     80107640 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010764d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107652:	83 ec 0c             	sub    $0xc,%esp
80107655:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107658:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010765d:	50                   	push   %eax
8010765e:	e8 0d ae ff ff       	call   80102470 <kfree>
80107663:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107666:	39 df                	cmp    %ebx,%edi
80107668:	75 dd                	jne    80107647 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010766a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010766d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107670:	5b                   	pop    %ebx
80107671:	5e                   	pop    %esi
80107672:	5f                   	pop    %edi
80107673:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107674:	e9 f7 ad ff ff       	jmp    80102470 <kfree>
    panic("freevm: no pgdir");
80107679:	83 ec 0c             	sub    $0xc,%esp
8010767c:	68 ad 82 10 80       	push   $0x801082ad
80107681:	e8 0a 8d ff ff       	call   80100390 <panic>
80107686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010768d:	8d 76 00             	lea    0x0(%esi),%esi

80107690 <setupkvm>:
{
80107690:	f3 0f 1e fb          	endbr32 
80107694:	55                   	push   %ebp
80107695:	89 e5                	mov    %esp,%ebp
80107697:	56                   	push   %esi
80107698:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107699:	e8 92 af ff ff       	call   80102630 <kalloc>
8010769e:	89 c6                	mov    %eax,%esi
801076a0:	85 c0                	test   %eax,%eax
801076a2:	74 42                	je     801076e6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801076a4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076a7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801076ac:	68 00 10 00 00       	push   $0x1000
801076b1:	6a 00                	push   $0x0
801076b3:	50                   	push   %eax
801076b4:	e8 d7 d6 ff ff       	call   80104d90 <memset>
801076b9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801076bc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801076bf:	83 ec 08             	sub    $0x8,%esp
801076c2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801076c5:	ff 73 0c             	pushl  0xc(%ebx)
801076c8:	8b 13                	mov    (%ebx),%edx
801076ca:	50                   	push   %eax
801076cb:	29 c1                	sub    %eax,%ecx
801076cd:	89 f0                	mov    %esi,%eax
801076cf:	e8 8c f9 ff ff       	call   80107060 <mappages>
801076d4:	83 c4 10             	add    $0x10,%esp
801076d7:	85 c0                	test   %eax,%eax
801076d9:	78 15                	js     801076f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076db:	83 c3 10             	add    $0x10,%ebx
801076de:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801076e4:	75 d6                	jne    801076bc <setupkvm+0x2c>
}
801076e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076e9:	89 f0                	mov    %esi,%eax
801076eb:	5b                   	pop    %ebx
801076ec:	5e                   	pop    %esi
801076ed:	5d                   	pop    %ebp
801076ee:	c3                   	ret    
801076ef:	90                   	nop
      freevm(pgdir);
801076f0:	83 ec 0c             	sub    $0xc,%esp
801076f3:	56                   	push   %esi
      return 0;
801076f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801076f6:	e8 15 ff ff ff       	call   80107610 <freevm>
      return 0;
801076fb:	83 c4 10             	add    $0x10,%esp
}
801076fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107701:	89 f0                	mov    %esi,%eax
80107703:	5b                   	pop    %ebx
80107704:	5e                   	pop    %esi
80107705:	5d                   	pop    %ebp
80107706:	c3                   	ret    
80107707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770e:	66 90                	xchg   %ax,%ax

80107710 <kvmalloc>:
{
80107710:	f3 0f 1e fb          	endbr32 
80107714:	55                   	push   %ebp
80107715:	89 e5                	mov    %esp,%ebp
80107717:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010771a:	e8 71 ff ff ff       	call   80107690 <setupkvm>
8010771f:	a3 a4 6c 11 80       	mov    %eax,0x80116ca4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107724:	05 00 00 00 80       	add    $0x80000000,%eax
80107729:	0f 22 d8             	mov    %eax,%cr3
}
8010772c:	c9                   	leave  
8010772d:	c3                   	ret    
8010772e:	66 90                	xchg   %ax,%ax

80107730 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107730:	f3 0f 1e fb          	endbr32 
80107734:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107735:	31 c9                	xor    %ecx,%ecx
{
80107737:	89 e5                	mov    %esp,%ebp
80107739:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010773c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010773f:	8b 45 08             	mov    0x8(%ebp),%eax
80107742:	e8 99 f8 ff ff       	call   80106fe0 <walkpgdir>
  if(pte == 0)
80107747:	85 c0                	test   %eax,%eax
80107749:	74 05                	je     80107750 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010774b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010774e:	c9                   	leave  
8010774f:	c3                   	ret    
    panic("clearpteu");
80107750:	83 ec 0c             	sub    $0xc,%esp
80107753:	68 be 82 10 80       	push   $0x801082be
80107758:	e8 33 8c ff ff       	call   80100390 <panic>
8010775d:	8d 76 00             	lea    0x0(%esi),%esi

80107760 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107760:	f3 0f 1e fb          	endbr32 
80107764:	55                   	push   %ebp
80107765:	89 e5                	mov    %esp,%ebp
80107767:	57                   	push   %edi
80107768:	56                   	push   %esi
80107769:	53                   	push   %ebx
8010776a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010776d:	e8 1e ff ff ff       	call   80107690 <setupkvm>
80107772:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107775:	85 c0                	test   %eax,%eax
80107777:	0f 84 9b 00 00 00    	je     80107818 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010777d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107780:	85 c9                	test   %ecx,%ecx
80107782:	0f 84 90 00 00 00    	je     80107818 <copyuvm+0xb8>
80107788:	31 f6                	xor    %esi,%esi
8010778a:	eb 46                	jmp    801077d2 <copyuvm+0x72>
8010778c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107790:	83 ec 04             	sub    $0x4,%esp
80107793:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107799:	68 00 10 00 00       	push   $0x1000
8010779e:	57                   	push   %edi
8010779f:	50                   	push   %eax
801077a0:	e8 8b d6 ff ff       	call   80104e30 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801077a5:	58                   	pop    %eax
801077a6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801077ac:	5a                   	pop    %edx
801077ad:	ff 75 e4             	pushl  -0x1c(%ebp)
801077b0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801077b5:	89 f2                	mov    %esi,%edx
801077b7:	50                   	push   %eax
801077b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077bb:	e8 a0 f8 ff ff       	call   80107060 <mappages>
801077c0:	83 c4 10             	add    $0x10,%esp
801077c3:	85 c0                	test   %eax,%eax
801077c5:	78 61                	js     80107828 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801077c7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801077cd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801077d0:	76 46                	jbe    80107818 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801077d2:	8b 45 08             	mov    0x8(%ebp),%eax
801077d5:	31 c9                	xor    %ecx,%ecx
801077d7:	89 f2                	mov    %esi,%edx
801077d9:	e8 02 f8 ff ff       	call   80106fe0 <walkpgdir>
801077de:	85 c0                	test   %eax,%eax
801077e0:	74 61                	je     80107843 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801077e2:	8b 00                	mov    (%eax),%eax
801077e4:	a8 01                	test   $0x1,%al
801077e6:	74 4e                	je     80107836 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801077e8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801077ea:	25 ff 0f 00 00       	and    $0xfff,%eax
801077ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801077f2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801077f8:	e8 33 ae ff ff       	call   80102630 <kalloc>
801077fd:	89 c3                	mov    %eax,%ebx
801077ff:	85 c0                	test   %eax,%eax
80107801:	75 8d                	jne    80107790 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107803:	83 ec 0c             	sub    $0xc,%esp
80107806:	ff 75 e0             	pushl  -0x20(%ebp)
80107809:	e8 02 fe ff ff       	call   80107610 <freevm>
  return 0;
8010780e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107815:	83 c4 10             	add    $0x10,%esp
}
80107818:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010781b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010781e:	5b                   	pop    %ebx
8010781f:	5e                   	pop    %esi
80107820:	5f                   	pop    %edi
80107821:	5d                   	pop    %ebp
80107822:	c3                   	ret    
80107823:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107827:	90                   	nop
      kfree(mem);
80107828:	83 ec 0c             	sub    $0xc,%esp
8010782b:	53                   	push   %ebx
8010782c:	e8 3f ac ff ff       	call   80102470 <kfree>
      goto bad;
80107831:	83 c4 10             	add    $0x10,%esp
80107834:	eb cd                	jmp    80107803 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107836:	83 ec 0c             	sub    $0xc,%esp
80107839:	68 e2 82 10 80       	push   $0x801082e2
8010783e:	e8 4d 8b ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107843:	83 ec 0c             	sub    $0xc,%esp
80107846:	68 c8 82 10 80       	push   $0x801082c8
8010784b:	e8 40 8b ff ff       	call   80100390 <panic>

80107850 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107850:	f3 0f 1e fb          	endbr32 
80107854:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107855:	31 c9                	xor    %ecx,%ecx
{
80107857:	89 e5                	mov    %esp,%ebp
80107859:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010785c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010785f:	8b 45 08             	mov    0x8(%ebp),%eax
80107862:	e8 79 f7 ff ff       	call   80106fe0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107867:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107869:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010786a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010786c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107871:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107874:	05 00 00 00 80       	add    $0x80000000,%eax
80107879:	83 fa 05             	cmp    $0x5,%edx
8010787c:	ba 00 00 00 00       	mov    $0x0,%edx
80107881:	0f 45 c2             	cmovne %edx,%eax
}
80107884:	c3                   	ret    
80107885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010788c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107890 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107890:	f3 0f 1e fb          	endbr32 
80107894:	55                   	push   %ebp
80107895:	89 e5                	mov    %esp,%ebp
80107897:	57                   	push   %edi
80107898:	56                   	push   %esi
80107899:	53                   	push   %ebx
8010789a:	83 ec 0c             	sub    $0xc,%esp
8010789d:	8b 75 14             	mov    0x14(%ebp),%esi
801078a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801078a3:	85 f6                	test   %esi,%esi
801078a5:	75 3c                	jne    801078e3 <copyout+0x53>
801078a7:	eb 67                	jmp    80107910 <copyout+0x80>
801078a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801078b0:	8b 55 0c             	mov    0xc(%ebp),%edx
801078b3:	89 fb                	mov    %edi,%ebx
801078b5:	29 d3                	sub    %edx,%ebx
801078b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801078bd:	39 f3                	cmp    %esi,%ebx
801078bf:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801078c2:	29 fa                	sub    %edi,%edx
801078c4:	83 ec 04             	sub    $0x4,%esp
801078c7:	01 c2                	add    %eax,%edx
801078c9:	53                   	push   %ebx
801078ca:	ff 75 10             	pushl  0x10(%ebp)
801078cd:	52                   	push   %edx
801078ce:	e8 5d d5 ff ff       	call   80104e30 <memmove>
    len -= n;
    buf += n;
801078d3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801078d6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801078dc:	83 c4 10             	add    $0x10,%esp
801078df:	29 de                	sub    %ebx,%esi
801078e1:	74 2d                	je     80107910 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801078e3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801078e5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801078e8:	89 55 0c             	mov    %edx,0xc(%ebp)
801078eb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801078f1:	57                   	push   %edi
801078f2:	ff 75 08             	pushl  0x8(%ebp)
801078f5:	e8 56 ff ff ff       	call   80107850 <uva2ka>
    if(pa0 == 0)
801078fa:	83 c4 10             	add    $0x10,%esp
801078fd:	85 c0                	test   %eax,%eax
801078ff:	75 af                	jne    801078b0 <copyout+0x20>
  }
  return 0;
}
80107901:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107904:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107909:	5b                   	pop    %ebx
8010790a:	5e                   	pop    %esi
8010790b:	5f                   	pop    %edi
8010790c:	5d                   	pop    %ebp
8010790d:	c3                   	ret    
8010790e:	66 90                	xchg   %ax,%ax
80107910:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107913:	31 c0                	xor    %eax,%eax
}
80107915:	5b                   	pop    %ebx
80107916:	5e                   	pop    %esi
80107917:	5f                   	pop    %edi
80107918:	5d                   	pop    %ebp
80107919:	c3                   	ret    
