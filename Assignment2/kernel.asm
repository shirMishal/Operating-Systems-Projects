
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
80100048:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 e0 79 10 80       	push   $0x801079e0
80100055:	68 e0 c5 10 80       	push   $0x8010c5e0
8010005a:	e8 b1 4b 00 00       	call   80104c10 <initlock>
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
80100092:	68 e7 79 10 80       	push   $0x801079e7
80100097:	50                   	push   %eax
80100098:	e8 33 4a 00 00       	call   80104ad0 <initsleeplock>
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
801000e8:	e8 a3 4c 00 00       	call   80104d90 <acquire>
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
80100162:	e8 e9 4c 00 00       	call   80104e50 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 49 00 00       	call   80104b10 <acquiresleep>
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
801001a3:	68 ee 79 10 80       	push   $0x801079ee
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
801001c2:	e8 e9 49 00 00       	call   80104bb0 <holdingsleep>
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
801001e0:	68 ff 79 10 80       	push   $0x801079ff
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
80100203:	e8 a8 49 00 00       	call   80104bb0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 58 49 00 00       	call   80104b70 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010021f:	e8 6c 4b 00 00       	call   80104d90 <acquire>
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
80100270:	e9 db 4b 00 00       	jmp    80104e50 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 06 7a 10 80       	push   $0x80107a06
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
801002b1:	e8 da 4a 00 00       	call   80104d90 <acquire>
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
801002e5:	e8 96 41 00 00       	call   80104480 <sleep>
    while(input.r == input.w){
801002ea:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 31 36 00 00       	call   80103930 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 3d 4b 00 00       	call   80104e50 <release>
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
80100365:	e8 e6 4a 00 00       	call   80104e50 <release>
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
801003ad:	e8 1e 25 00 00       	call   801028d0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 0d 7a 10 80       	push   $0x80107a0d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 c3 84 10 80 	movl   $0x801084c3,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 4f 48 00 00       	call   80104c30 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 21 7a 10 80       	push   $0x80107a21
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
8010042a:	e8 b1 61 00 00       	call   801065e0 <uartputc>
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
80100515:	e8 c6 60 00 00       	call   801065e0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ba 60 00 00       	call   801065e0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ae 60 00 00       	call   801065e0 <uartputc>
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
80100561:	e8 da 49 00 00       	call   80104f40 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 25 49 00 00       	call   80104ea0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 25 7a 10 80       	push   $0x80107a25
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
801005c9:	0f b6 92 50 7a 10 80 	movzbl -0x7fef85b0(%edx),%edx
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
8010065f:	e8 2c 47 00 00       	call   80104d90 <acquire>
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
80100697:	e8 b4 47 00 00       	call   80104e50 <release>
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
8010077d:	bb 38 7a 10 80       	mov    $0x80107a38,%ebx
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
801007bd:	e8 ce 45 00 00       	call   80104d90 <acquire>
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
80100828:	e8 23 46 00 00       	call   80104e50 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 3f 7a 10 80       	push   $0x80107a3f
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
80100877:	e8 14 45 00 00       	call   80104d90 <acquire>
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
801009cf:	e8 7c 44 00 00       	call   80104e50 <release>
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
801009ff:	e9 9c 3c 00 00       	jmp    801046a0 <procdump>
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
80100a20:	e8 3b 3b 00 00       	call   80104560 <wakeup>
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
80100a3a:	68 48 7a 10 80       	push   $0x80107a48
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 c7 41 00 00       	call   80104c10 <initlock>

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
80100b0c:	e8 3f 6c 00 00       	call   80107750 <setupkvm>
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
80100b73:	e8 f8 69 00 00       	call   80107570 <allocuvm>
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
80100ba9:	e8 f2 68 00 00       	call   801074a0 <loaduvm>
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
80100beb:	e8 e0 6a 00 00       	call   801076d0 <freevm>
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
80100c32:	e8 39 69 00 00       	call   80107570 <allocuvm>
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
80100c53:	e8 98 6b 00 00       	call   801077f0 <clearpteu>
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
80100ca3:	e8 f8 43 00 00       	call   801050a0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 e5 43 00 00       	call   801050a0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 84 6c 00 00       	call   80107950 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 ea 69 00 00       	call   801076d0 <freevm>
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
80100d33:	e8 18 6c 00 00       	call   80107950 <copyout>
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
80100d6f:	e8 ec 42 00 00       	call   80105060 <safestrcpy>
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
80100dca:	e8 41 65 00 00       	call   80107310 <switchuvm>
  freevm(oldpgdir);
80100dcf:	89 3c 24             	mov    %edi,(%esp)
80100dd2:	e8 f9 68 00 00       	call   801076d0 <freevm>
  return 0;
80100dd7:	83 c4 10             	add    $0x10,%esp
80100dda:	31 c0                	xor    %eax,%eax
80100ddc:	e9 0f fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100de1:	e8 ea 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de6:	83 ec 0c             	sub    $0xc,%esp
80100de9:	68 61 7a 10 80       	push   $0x80107a61
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
80100e1a:	68 6d 7a 10 80       	push   $0x80107a6d
80100e1f:	68 e0 0f 11 80       	push   $0x80110fe0
80100e24:	e8 e7 3d 00 00       	call   80104c10 <initlock>
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
80100e38:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
80100e3d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e40:	68 e0 0f 11 80       	push   $0x80110fe0
80100e45:	e8 46 3f 00 00       	call   80104d90 <acquire>
80100e4a:	83 c4 10             	add    $0x10,%esp
80100e4d:	eb 0c                	jmp    80100e5b <filealloc+0x2b>
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
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
80100e6c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e71:	e8 da 3f 00 00       	call   80104e50 <release>
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
80100e85:	68 e0 0f 11 80       	push   $0x80110fe0
80100e8a:	e8 c1 3f 00 00       	call   80104e50 <release>
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
80100eae:	68 e0 0f 11 80       	push   $0x80110fe0
80100eb3:	e8 d8 3e 00 00       	call   80104d90 <acquire>
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
80100ecb:	68 e0 0f 11 80       	push   $0x80110fe0
80100ed0:	e8 7b 3f 00 00       	call   80104e50 <release>
  return f;
}
80100ed5:	89 d8                	mov    %ebx,%eax
80100ed7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eda:	c9                   	leave  
80100edb:	c3                   	ret    
    panic("filedup");
80100edc:	83 ec 0c             	sub    $0xc,%esp
80100edf:	68 74 7a 10 80       	push   $0x80107a74
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
80100f00:	68 e0 0f 11 80       	push   $0x80110fe0
80100f05:	e8 86 3e 00 00       	call   80104d90 <acquire>
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
80100f38:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
80100f3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f40:	e8 0b 3f 00 00       	call   80104e50 <release>

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
80100f60:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 dd 3e 00 00       	jmp    80104e50 <release>
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
80100fbc:	68 7c 7a 10 80       	push   $0x80107a7c
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
801010aa:	68 86 7a 10 80       	push   $0x80107a86
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
80101193:	68 8f 7a 10 80       	push   $0x80107a8f
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
801011c9:	68 95 7a 10 80       	push   $0x80107a95
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
801011e8:	03 05 f8 19 11 80    	add    0x801119f8,%eax
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
80101247:	68 9f 7a 10 80       	push   $0x80107a9f
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
80101269:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
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
8010128c:	03 05 f8 19 11 80    	add    0x801119f8,%eax
80101292:	50                   	push   %eax
80101293:	ff 75 d8             	pushl  -0x28(%ebp)
80101296:	e8 35 ee ff ff       	call   801000d0 <bread>
8010129b:	83 c4 10             	add    $0x10,%esp
8010129e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012a1:	a1 e0 19 11 80       	mov    0x801119e0,%eax
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
801012f9:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
801012ff:	77 80                	ja     80101281 <balloc+0x21>
  panic("balloc: out of blocks");
80101301:	83 ec 0c             	sub    $0xc,%esp
80101304:	68 b2 7a 10 80       	push   $0x80107ab2
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
80101345:	e8 56 3b 00 00       	call   80104ea0 <memset>
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
8010137a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
8010137f:	83 ec 28             	sub    $0x28,%esp
80101382:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101385:	68 00 1a 11 80       	push   $0x80111a00
8010138a:	e8 01 3a 00 00       	call   80104d90 <acquire>
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
801013aa:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
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
801013cb:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
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
801013f2:	68 00 1a 11 80       	push   $0x80111a00
801013f7:	e8 54 3a 00 00       	call   80104e50 <release>

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
8010141d:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
80101422:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101425:	e8 26 3a 00 00       	call   80104e50 <release>
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
80101437:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
8010143d:	73 10                	jae    8010144f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010143f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101442:	85 c9                	test   %ecx,%ecx
80101444:	0f 8f 56 ff ff ff    	jg     801013a0 <iget+0x30>
8010144a:	e9 6e ff ff ff       	jmp    801013bd <iget+0x4d>
    panic("iget: no inodes");
8010144f:	83 ec 0c             	sub    $0xc,%esp
80101452:	68 c8 7a 10 80       	push   $0x80107ac8
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
8010151b:	68 d8 7a 10 80       	push   $0x80107ad8
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
80101555:	e8 e6 39 00 00       	call   80104f40 <memmove>
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
80101578:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
8010157d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101580:	68 eb 7a 10 80       	push   $0x80107aeb
80101585:	68 00 1a 11 80       	push   $0x80111a00
8010158a:	e8 81 36 00 00       	call   80104c10 <initlock>
  for(i = 0; i < NINODE; i++) {
8010158f:	83 c4 10             	add    $0x10,%esp
80101592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101598:	83 ec 08             	sub    $0x8,%esp
8010159b:	68 f2 7a 10 80       	push   $0x80107af2
801015a0:	53                   	push   %ebx
801015a1:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015a7:	e8 24 35 00 00       	call   80104ad0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015ac:	83 c4 10             	add    $0x10,%esp
801015af:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
801015b5:	75 e1                	jne    80101598 <iinit+0x28>
  readsb(dev, &sb);
801015b7:	83 ec 08             	sub    $0x8,%esp
801015ba:	68 e0 19 11 80       	push   $0x801119e0
801015bf:	ff 75 08             	pushl  0x8(%ebp)
801015c2:	e8 69 ff ff ff       	call   80101530 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c7:	ff 35 f8 19 11 80    	pushl  0x801119f8
801015cd:	ff 35 f4 19 11 80    	pushl  0x801119f4
801015d3:	ff 35 f0 19 11 80    	pushl  0x801119f0
801015d9:	ff 35 ec 19 11 80    	pushl  0x801119ec
801015df:	ff 35 e8 19 11 80    	pushl  0x801119e8
801015e5:	ff 35 e4 19 11 80    	pushl  0x801119e4
801015eb:	ff 35 e0 19 11 80    	pushl  0x801119e0
801015f1:	68 58 7b 10 80       	push   $0x80107b58
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
80101620:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
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
8010164f:	3b 3d e8 19 11 80    	cmp    0x801119e8,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
8010168e:	e8 0d 38 00 00       	call   80104ea0 <memset>
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
801016c3:	68 f8 7a 10 80       	push   $0x80107af8
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
801016e8:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
80101735:	e8 06 38 00 00       	call   80104f40 <memmove>
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
8010176e:	68 00 1a 11 80       	push   $0x80111a00
80101773:	e8 18 36 00 00       	call   80104d90 <acquire>
  ip->ref++;
80101778:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010177c:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101783:	e8 c8 36 00 00       	call   80104e50 <release>
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
801017b6:	e8 55 33 00 00       	call   80104b10 <acquiresleep>
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
801017d9:	03 05 f4 19 11 80    	add    0x801119f4,%eax
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
80101828:	e8 13 37 00 00       	call   80104f40 <memmove>
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
8010184d:	68 10 7b 10 80       	push   $0x80107b10
80101852:	e8 39 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101857:	83 ec 0c             	sub    $0xc,%esp
8010185a:	68 0a 7b 10 80       	push   $0x80107b0a
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
80101887:	e8 24 33 00 00       	call   80104bb0 <holdingsleep>
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
801018a3:	e9 c8 32 00 00       	jmp    80104b70 <releasesleep>
    panic("iunlock");
801018a8:	83 ec 0c             	sub    $0xc,%esp
801018ab:	68 1f 7b 10 80       	push   $0x80107b1f
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
801018d4:	e8 37 32 00 00       	call   80104b10 <acquiresleep>
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
801018ee:	e8 7d 32 00 00       	call   80104b70 <releasesleep>
  acquire(&icache.lock);
801018f3:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801018fa:	e8 91 34 00 00       	call   80104d90 <acquire>
  ip->ref--;
801018ff:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
8010190d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101910:	5b                   	pop    %ebx
80101911:	5e                   	pop    %esi
80101912:	5f                   	pop    %edi
80101913:	5d                   	pop    %ebp
  release(&icache.lock);
80101914:	e9 37 35 00 00       	jmp    80104e50 <release>
80101919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101920:	83 ec 0c             	sub    $0xc,%esp
80101923:	68 00 1a 11 80       	push   $0x80111a00
80101928:	e8 63 34 00 00       	call   80104d90 <acquire>
    int r = ip->ref;
8010192d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101930:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101937:	e8 14 35 00 00       	call   80104e50 <release>
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
80101b37:	e8 04 34 00 00       	call   80104f40 <memmove>
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
80101b6a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
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
80101c33:	e8 08 33 00 00       	call   80104f40 <memmove>
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
80101c7a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
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
80101cd2:	e8 d9 32 00 00       	call   80104fb0 <strncmp>
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
80101d35:	e8 76 32 00 00       	call   80104fb0 <strncmp>
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
80101d7a:	68 39 7b 10 80       	push   $0x80107b39
80101d7f:	e8 0c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d84:	83 ec 0c             	sub    $0xc,%esp
80101d87:	68 27 7b 10 80       	push   $0x80107b27
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
80101dc7:	68 00 1a 11 80       	push   $0x80111a00
80101dcc:	e8 bf 2f 00 00       	call   80104d90 <acquire>
  ip->ref++;
80101dd1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd5:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101ddc:	e8 6f 30 00 00       	call   80104e50 <release>
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
80101e47:	e8 f4 30 00 00       	call   80104f40 <memmove>
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
80101ed3:	e8 68 30 00 00       	call   80104f40 <memmove>
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
80102005:	e8 f6 2f 00 00       	call   80105000 <strncpy>
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
80102043:	68 48 7b 10 80       	push   $0x80107b48
80102048:	e8 43 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010204d:	83 ec 0c             	sub    $0xc,%esp
80102050:	68 aa 82 10 80       	push   $0x801082aa
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
8010215b:	68 b4 7b 10 80       	push   $0x80107bb4
80102160:	e8 2b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102165:	83 ec 0c             	sub    $0xc,%esp
80102168:	68 ab 7b 10 80       	push   $0x80107bab
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
8010218a:	68 c6 7b 10 80       	push   $0x80107bc6
8010218f:	68 80 b5 10 80       	push   $0x8010b580
80102194:	e8 77 2a 00 00       	call   80104c10 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102199:	58                   	pop    %eax
8010219a:	a1 20 3d 11 80       	mov    0x80113d20,%eax
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
80102222:	e8 69 2b 00 00       	call   80104d90 <acquire>

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
8010227d:	e8 de 22 00 00       	call   80104560 <wakeup>

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
8010229b:	e8 b0 2b 00 00       	call   80104e50 <release>

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
801022c2:	e8 e9 28 00 00       	call   80104bb0 <holdingsleep>
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
801022fc:	e8 8f 2a 00 00       	call   80104d90 <acquire>

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
80102349:	e8 32 21 00 00       	call   80104480 <sleep>
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
80102366:	e9 e5 2a 00 00       	jmp    80104e50 <release>
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
8010238a:	68 f5 7b 10 80       	push   $0x80107bf5
8010238f:	e8 fc df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102394:	83 ec 0c             	sub    $0xc,%esp
80102397:	68 e0 7b 10 80       	push   $0x80107be0
8010239c:	e8 ef df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801023a1:	83 ec 0c             	sub    $0xc,%esp
801023a4:	68 ca 7b 10 80       	push   $0x80107bca
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
801023b5:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
801023bc:	00 c0 fe 
{
801023bf:	89 e5                	mov    %esp,%ebp
801023c1:	56                   	push   %esi
801023c2:	53                   	push   %ebx
  ioapic->reg = reg;
801023c3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023ca:	00 00 00 
  return ioapic->data;
801023cd:	8b 15 54 36 11 80    	mov    0x80113654,%edx
801023d3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023d6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023dc:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023e2:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
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
801023fe:	68 14 7c 10 80       	push   $0x80107c14
80102403:	e8 a8 e2 ff ff       	call   801006b0 <cprintf>
80102408:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
80102424:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
8010243e:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
80102465:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
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
80102479:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010247f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102482:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102485:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102488:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010248a:	a1 54 36 11 80       	mov    0x80113654,%eax
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
801024b6:	81 fb c8 ab 11 80    	cmp    $0x8011abc8,%ebx
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
801024d6:	e8 c5 29 00 00       	call   80104ea0 <memset>

  if(kmem.use_lock)
801024db:	8b 15 94 36 11 80    	mov    0x80113694,%edx
801024e1:	83 c4 10             	add    $0x10,%esp
801024e4:	85 d2                	test   %edx,%edx
801024e6:	75 20                	jne    80102508 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024e8:	a1 98 36 11 80       	mov    0x80113698,%eax
801024ed:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024ef:	a1 94 36 11 80       	mov    0x80113694,%eax
  kmem.freelist = r;
801024f4:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
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
8010250b:	68 60 36 11 80       	push   $0x80113660
80102510:	e8 7b 28 00 00       	call   80104d90 <acquire>
80102515:	83 c4 10             	add    $0x10,%esp
80102518:	eb ce                	jmp    801024e8 <kfree+0x48>
8010251a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102520:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
80102527:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010252a:	c9                   	leave  
    release(&kmem.lock);
8010252b:	e9 20 29 00 00       	jmp    80104e50 <release>
    panic("kfree");
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 46 7c 10 80       	push   $0x80107c46
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
8010259f:	68 4c 7c 10 80       	push   $0x80107c4c
801025a4:	68 60 36 11 80       	push   $0x80113660
801025a9:	e8 62 26 00 00       	call   80104c10 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801025ae:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801025b4:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
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
80102644:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
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
80102664:	a1 94 36 11 80       	mov    0x80113694,%eax
80102669:	85 c0                	test   %eax,%eax
8010266b:	75 1b                	jne    80102688 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010266d:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
80102672:	85 c0                	test   %eax,%eax
80102674:	74 0a                	je     80102680 <kalloc+0x20>
    kmem.freelist = r->next;
80102676:	8b 10                	mov    (%eax),%edx
80102678:	89 15 98 36 11 80    	mov    %edx,0x80113698
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
8010268e:	68 60 36 11 80       	push   $0x80113660
80102693:	e8 f8 26 00 00       	call   80104d90 <acquire>
  r = kmem.freelist;
80102698:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
8010269d:	8b 15 94 36 11 80    	mov    0x80113694,%edx
801026a3:	83 c4 10             	add    $0x10,%esp
801026a6:	85 c0                	test   %eax,%eax
801026a8:	74 08                	je     801026b2 <kalloc+0x52>
    kmem.freelist = r->next;
801026aa:	8b 08                	mov    (%eax),%ecx
801026ac:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  if(kmem.use_lock)
801026b2:	85 d2                	test   %edx,%edx
801026b4:	74 16                	je     801026cc <kalloc+0x6c>
    release(&kmem.lock);
801026b6:	83 ec 0c             	sub    $0xc,%esp
801026b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026bc:	68 60 36 11 80       	push   $0x80113660
801026c1:	e8 8a 27 00 00       	call   80104e50 <release>
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
8010270f:	0f b6 8a 80 7d 10 80 	movzbl -0x7fef8280(%edx),%ecx
  shift ^= togglecode[data];
80102716:	0f b6 82 80 7c 10 80 	movzbl -0x7fef8380(%edx),%eax
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
8010272f:	8b 04 85 60 7c 10 80 	mov    -0x7fef83a0(,%eax,4),%eax
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
8010276a:	0f b6 8a 80 7d 10 80 	movzbl -0x7fef8280(%edx),%ecx
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
801027d4:	a1 9c 36 11 80       	mov    0x8011369c,%eax
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
801028d4:	a1 9c 36 11 80       	mov    0x8011369c,%eax
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
801028f4:	a1 9c 36 11 80       	mov    0x8011369c,%eax
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
80102962:	a1 9c 36 11 80       	mov    0x8011369c,%eax
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
80102aef:	e8 fc 23 00 00       	call   80104ef0 <memcmp>
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
80102bc0:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
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
80102be0:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd ec 36 11 80 	pushl  -0x7feec914(,%edi,4)
80102c04:	ff 35 e4 36 11 80    	pushl  0x801136e4
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
80102c24:	e8 17 23 00 00       	call   80104f40 <memmove>
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
80102c44:	39 3d e8 36 11 80    	cmp    %edi,0x801136e8
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
80102c67:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102c6d:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 e8 36 11 80       	mov    0x801136e8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 ec 36 11 80 	mov    -0x7feec914(,%edx,4),%ecx
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
80102cce:	68 80 7e 10 80       	push   $0x80107e80
80102cd3:	68 a0 36 11 80       	push   $0x801136a0
80102cd8:	e8 33 1f 00 00       	call   80104c10 <initlock>
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
80102ced:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102cf3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf6:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  log.size = sb.nlog;
80102cfb:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  struct buf *buf = bread(log.dev, log.start);
80102d01:	5a                   	pop    %edx
80102d02:	50                   	push   %eax
80102d03:	53                   	push   %ebx
80102d04:	e8 c7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d09:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d0c:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102d0f:	89 0d e8 36 11 80    	mov    %ecx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102d15:	85 c9                	test   %ecx,%ecx
80102d17:	7e 19                	jle    80102d32 <initlog+0x72>
80102d19:	31 d2                	xor    %edx,%edx
80102d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d1f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d20:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d24:	89 1c 95 ec 36 11 80 	mov    %ebx,-0x7feec914(,%edx,4)
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
80102d40:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
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
80102d6a:	68 a0 36 11 80       	push   $0x801136a0
80102d6f:	e8 1c 20 00 00       	call   80104d90 <acquire>
80102d74:	83 c4 10             	add    $0x10,%esp
80102d77:	eb 1c                	jmp    80102d95 <begin_op+0x35>
80102d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d80:	83 ec 08             	sub    $0x8,%esp
80102d83:	68 a0 36 11 80       	push   $0x801136a0
80102d88:	68 a0 36 11 80       	push   $0x801136a0
80102d8d:	e8 ee 16 00 00       	call   80104480 <sleep>
80102d92:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d95:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102d9a:	85 c0                	test   %eax,%eax
80102d9c:	75 e2                	jne    80102d80 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d9e:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102da3:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
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
80102dba:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102dbf:	68 a0 36 11 80       	push   $0x801136a0
80102dc4:	e8 87 20 00 00       	call   80104e50 <release>
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
80102ddd:	68 a0 36 11 80       	push   $0x801136a0
80102de2:	e8 a9 1f 00 00       	call   80104d90 <acquire>
  log.outstanding -= 1;
80102de7:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102dec:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102df2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df8:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
80102dfe:	85 f6                	test   %esi,%esi
80102e00:	0f 85 1e 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e06:	85 db                	test   %ebx,%ebx
80102e08:	0f 85 f2 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0e:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102e15:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e18:	83 ec 0c             	sub    $0xc,%esp
80102e1b:	68 a0 36 11 80       	push   $0x801136a0
80102e20:	e8 2b 20 00 00       	call   80104e50 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e25:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102e2b:	83 c4 10             	add    $0x10,%esp
80102e2e:	85 c9                	test   %ecx,%ecx
80102e30:	7f 3e                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e32:	83 ec 0c             	sub    $0xc,%esp
80102e35:	68 a0 36 11 80       	push   $0x801136a0
80102e3a:	e8 51 1f 00 00       	call   80104d90 <acquire>
    wakeup(&log);
80102e3f:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102e46:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102e4d:	00 00 00 
    wakeup(&log);
80102e50:	e8 0b 17 00 00       	call   80104560 <wakeup>
    release(&log.lock);
80102e55:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102e5c:	e8 ef 1f 00 00       	call   80104e50 <release>
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
80102e70:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102e94:	ff 35 e4 36 11 80    	pushl  0x801136e4
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
80102eb4:	e8 87 20 00 00       	call   80104f40 <memmove>
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
80102ed4:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 38 ff ff ff       	jmp    80102e32 <end_op+0x62>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 a0 36 11 80       	push   $0x801136a0
80102f08:	e8 53 16 00 00       	call   80104560 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102f14:	e8 37 1f 00 00       	call   80104e50 <release>
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
80102f27:	68 84 7e 10 80       	push   $0x80107e84
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
80102f4b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102f51:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f54:	83 fa 1d             	cmp    $0x1d,%edx
80102f57:	0f 8f 91 00 00 00    	jg     80102fee <log_write+0xae>
80102f5d:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102f62:	83 e8 01             	sub    $0x1,%eax
80102f65:	39 c2                	cmp    %eax,%edx
80102f67:	0f 8d 81 00 00 00    	jge    80102fee <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f6d:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102f72:	85 c0                	test   %eax,%eax
80102f74:	0f 8e 81 00 00 00    	jle    80102ffb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f7a:	83 ec 0c             	sub    $0xc,%esp
80102f7d:	68 a0 36 11 80       	push   $0x801136a0
80102f82:	e8 09 1e 00 00       	call   80104d90 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f87:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
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
80102fa7:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
80102fae:	75 f0                	jne    80102fa0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fb7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fbd:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102fc4:	c9                   	leave  
  release(&log.lock);
80102fc5:	e9 86 1e 00 00       	jmp    80104e50 <release>
80102fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fd0:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
    log.lh.n++;
80102fd7:	83 c2 01             	add    $0x1,%edx
80102fda:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
80102fe0:	eb d5                	jmp    80102fb7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fe2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fe5:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102fea:	75 cb                	jne    80102fb7 <log_write+0x77>
80102fec:	eb e9                	jmp    80102fd7 <log_write+0x97>
    panic("too big a transaction");
80102fee:	83 ec 0c             	sub    $0xc,%esp
80102ff1:	68 93 7e 10 80       	push   $0x80107e93
80102ff6:	e8 95 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102ffb:	83 ec 0c             	sub    $0xc,%esp
80102ffe:	68 a9 7e 10 80       	push   $0x80107ea9
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
80103028:	68 c4 7e 10 80       	push   $0x80107ec4
8010302d:	e8 7e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103032:	e8 e9 31 00 00       	call   80106220 <idtinit>
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
8010305a:	e8 91 42 00 00       	call   801072f0 <switchkvm>
  seginit();
8010305f:	e8 fc 41 00 00       	call   80107260 <seginit>
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
8010308b:	68 c8 ab 11 80       	push   $0x8011abc8
80103090:	e8 fb f4 ff ff       	call   80102590 <kinit1>
  kvmalloc();      // kernel page table
80103095:	e8 36 47 00 00       	call   801077d0 <kvmalloc>
  mpinit();        // detect other processors
8010309a:	e8 81 01 00 00       	call   80103220 <mpinit>
  lapicinit();     // interrupt controller
8010309f:	e8 2c f7 ff ff       	call   801027d0 <lapicinit>
  seginit();       // segment descriptors
801030a4:	e8 b7 41 00 00       	call   80107260 <seginit>
  picinit();       // disable pic
801030a9:	e8 52 03 00 00       	call   80103400 <picinit>
  ioapicinit();    // another interrupt controller
801030ae:	e8 fd f2 ff ff       	call   801023b0 <ioapicinit>
  consoleinit();   // console hardware
801030b3:	e8 78 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801030b8:	e8 63 34 00 00       	call   80106520 <uartinit>
  pinit();         // process table
801030bd:	e8 be 07 00 00       	call   80103880 <pinit>
  tvinit();        // trap vectors
801030c2:	e8 d9 30 00 00       	call   801061a0 <tvinit>
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
801030e8:	e8 53 1e 00 00       	call   80104f40 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030ed:	83 c4 10             	add    $0x10,%esp
801030f0:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
801030f7:	00 00 00 
801030fa:	05 a0 37 11 80       	add    $0x801137a0,%eax
801030ff:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
80103104:	76 7a                	jbe    80103180 <main+0x110>
80103106:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
8010310b:	eb 1c                	jmp    80103129 <main+0xb9>
8010310d:	8d 76 00             	lea    0x0(%esi),%esi
80103110:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80103117:	00 00 00 
8010311a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103120:	05 a0 37 11 80       	add    $0x801137a0,%eax
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
801031ce:	68 d8 7e 10 80       	push   $0x80107ed8
801031d3:	56                   	push   %esi
801031d4:	e8 17 1d 00 00       	call   80104ef0 <memcmp>
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
8010328a:	68 dd 7e 10 80       	push   $0x80107edd
8010328f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103290:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103293:	e8 58 1c 00 00       	call   80104ef0 <memcmp>
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
801032ee:	a3 9c 36 11 80       	mov    %eax,0x8011369c
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
8010337f:	88 0d 80 37 11 80    	mov    %cl,0x80113780
      continue;
80103385:	eb 89                	jmp    80103310 <mpinit+0xf0>
80103387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010338e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103390:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
80103396:	83 f9 07             	cmp    $0x7,%ecx
80103399:	7f 19                	jg     801033b4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010339b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033a1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033a5:	83 c1 01             	add    $0x1,%ecx
801033a8:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ae:	88 9f a0 37 11 80    	mov    %bl,-0x7feec860(%edi)
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
801033e3:	68 e2 7e 10 80       	push   $0x80107ee2
801033e8:	e8 a3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033ed:	83 ec 0c             	sub    $0xc,%esp
801033f0:	68 fc 7e 10 80       	push   $0x80107efc
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
80103497:	68 1b 7f 10 80       	push   $0x80107f1b
8010349c:	50                   	push   %eax
8010349d:	e8 6e 17 00 00       	call   80104c10 <initlock>
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
80103543:	e8 48 18 00 00       	call   80104d90 <acquire>
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
80103563:	e8 f8 0f 00 00       	call   80104560 <wakeup>
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
80103588:	e9 c3 18 00 00       	jmp    80104e50 <release>
8010358d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103599:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035a0:	00 00 00 
    wakeup(&p->nwrite);
801035a3:	50                   	push   %eax
801035a4:	e8 b7 0f 00 00       	call   80104560 <wakeup>
801035a9:	83 c4 10             	add    $0x10,%esp
801035ac:	eb bd                	jmp    8010356b <pipeclose+0x3b>
801035ae:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	53                   	push   %ebx
801035b4:	e8 97 18 00 00       	call   80104e50 <release>
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
801035e1:	e8 aa 17 00 00       	call   80104d90 <acquire>
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
80103638:	e8 23 0f 00 00       	call   80104560 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 3a 0e 00 00       	call   80104480 <sleep>
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
8010366c:	e8 df 17 00 00       	call   80104e50 <release>
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
801036ba:	e8 a1 0e 00 00       	call   80104560 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 89 17 00 00       	call   80104e50 <release>
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
801036ea:	e8 a1 16 00 00       	call   80104d90 <acquire>
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
8010371d:	e8 5e 0d 00 00       	call   80104480 <sleep>
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
80103786:	e8 d5 0d 00 00       	call   80104560 <wakeup>
  release(&p->lock);
8010378b:	89 34 24             	mov    %esi,(%esp)
8010378e:	e8 bd 16 00 00       	call   80104e50 <release>
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
801037a9:	e8 a2 16 00 00       	call   80104e50 <release>
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
801037c1:	ba 80 3d 11 80       	mov    $0x80113d80,%edx
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
801037de:	81 fa 80 a3 11 80    	cmp    $0x8011a380,%edx
801037e4:	74 41                	je     80103827 <wakeup1+0x67>
    if(p->chan == chan){
801037e6:	39 7a 14             	cmp    %edi,0x14(%edx)
801037e9:	75 ed                	jne    801037d8 <wakeup1+0x18>
      // int flag = 0
      while ((p->state == SLEEPING || p->state == MINUS_SLEEPING)){
801037eb:	8b 0a                	mov    (%edx),%ecx
801037ed:	be 03 00 00 00       	mov    $0x3,%esi
801037f2:	83 f9 02             	cmp    $0x2,%ecx
801037f5:	0f 94 c3             	sete   %bl
801037f8:	83 f9 08             	cmp    $0x8,%ecx
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
8010381f:	81 fa 80 a3 11 80    	cmp    $0x8011a380,%edx
80103825:	75 bf                	jne    801037e6 <wakeup1+0x26>
          break;
        }
        // cprintf("wakeup boohoo \n");
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
8010383a:	e8 a1 14 00 00       	call   80104ce0 <popcli>
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
8010388a:	68 20 7f 10 80       	push   $0x80107f20
8010388f:	68 40 3d 11 80       	push   $0x80113d40
80103894:	e8 77 13 00 00       	call   80104c10 <initlock>
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
801038b5:	8b 35 20 3d 11 80    	mov    0x80113d20,%esi
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
801038d5:	0f b6 81 a0 37 11 80 	movzbl -0x7feec860(%ecx),%eax
801038dc:	39 d8                	cmp    %ebx,%eax
801038de:	75 e8                	jne    801038c8 <mycpu+0x28>
}
801038e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[signum];
801038e3:	8d 81 a0 37 11 80    	lea    -0x7feec860(%ecx),%eax
}
801038e9:	5b                   	pop    %ebx
801038ea:	5e                   	pop    %esi
801038eb:	5d                   	pop    %ebp
801038ec:	c3                   	ret    
  panic("unknown apicid\n");
801038ed:	83 ec 0c             	sub    $0xc,%esp
801038f0:	68 27 7f 10 80       	push   $0x80107f27
801038f5:	e8 96 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801038fa:	83 ec 0c             	sub    $0xc,%esp
801038fd:	68 34 80 10 80       	push   $0x80108034
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
80103920:	2d a0 37 11 80       	sub    $0x801137a0,%eax
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
8010393b:	e8 50 13 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80103940:	e8 5b ff ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103945:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010394b:	e8 90 13 00 00       	call   80104ce0 <popcli>
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
8010396b:	e8 20 13 00 00       	call   80104c90 <pushcli>
    oldval = nextpid;
80103970:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103975:	b9 b8 b5 10 80       	mov    $0x8010b5b8,%ecx
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
801039a5:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
  pushcli();
801039aa:	e8 e1 12 00 00       	call   80104c90 <pushcli>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
801039af:	31 c0                	xor    %eax,%eax
801039b1:	b9 01 00 00 00       	mov    $0x1,%ecx
801039b6:	eb 1a                	jmp    801039d2 <allocproc+0x32>
801039b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop
    p++;
801039c0:	81 c3 98 01 00 00    	add    $0x198,%ebx
  while (p < &ptable.proc[NPROC] && !cas(&(p->state), UNUSED, EMBRYO)){
801039c6:	81 fb 74 a3 11 80    	cmp    $0x8011a374,%ebx
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
801039ea:	e8 f1 12 00 00       	call   80104ce0 <popcli>
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
80103a26:	c7 46 14 8b 61 10 80 	movl   $0x8010618b,0x14(%esi)
  p->context = (struct context*)sp;
80103a2d:	89 73 1c             	mov    %esi,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a30:	6a 14                	push   $0x14
80103a32:	6a 00                	push   $0x0
80103a34:	56                   	push   %esi
80103a35:	e8 66 14 00 00       	call   80104ea0 <memset>
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
80103aa0:	c7 05 08 a5 11 80 03 	movl   $0x3,0x8011a508
80103aa7:	00 00 00 
  return 0;
80103aaa:	31 db                	xor    %ebx,%ebx
  popcli();
80103aac:	e8 2f 12 00 00       	call   80104ce0 <popcli>
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
80103afc:	68 5c 80 10 80       	push   $0x8010805c
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
80103b32:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
  if((p->pgdir = setupkvm()) == 0)
80103b37:	e8 14 3c 00 00       	call   80107750 <setupkvm>
80103b3c:	89 43 04             	mov    %eax,0x4(%ebx)
80103b3f:	85 c0                	test   %eax,%eax
80103b41:	0f 84 c8 00 00 00    	je     80103c0f <userinit+0xef>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b47:	83 ec 04             	sub    $0x4,%esp
80103b4a:	68 2c 00 00 00       	push   $0x2c
80103b4f:	68 60 b4 10 80       	push   $0x8010b460
80103b54:	50                   	push   %eax
80103b55:	e8 c6 38 00 00       	call   80107420 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b5a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b5d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b63:	6a 4c                	push   $0x4c
80103b65:	6a 00                	push   $0x0
80103b67:	ff 73 18             	pushl  0x18(%ebx)
80103b6a:	e8 31 13 00 00       	call   80104ea0 <memset>
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
80103bc3:	68 50 7f 10 80       	push   $0x80107f50
80103bc8:	50                   	push   %eax
80103bc9:	e8 92 14 00 00       	call   80105060 <safestrcpy>
  p->cwd = namei("/");
80103bce:	c7 04 24 59 7f 10 80 	movl   $0x80107f59,(%esp)
80103bd5:	e8 86 e4 ff ff       	call   80102060 <namei>
80103bda:	89 43 68             	mov    %eax,0x68(%ebx)
  pushcli();
80103bdd:	e8 ae 10 00 00       	call   80104c90 <pushcli>
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
80103c0a:	e9 d1 10 00 00       	jmp    80104ce0 <popcli>
    panic("userinit: out of memory?");
80103c0f:	83 ec 0c             	sub    $0xc,%esp
80103c12:	68 37 7f 10 80       	push   $0x80107f37
80103c17:	e8 74 c7 ff ff       	call   80100390 <panic>
    panic("switch state from embryo to runnable failed in userinit");
80103c1c:	83 ec 0c             	sub    $0xc,%esp
80103c1f:	68 a4 80 10 80       	push   $0x801080a4
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
80103c3c:	e8 4f 10 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80103c41:	e8 5a fc ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103c46:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c4c:	e8 8f 10 00 00       	call   80104ce0 <popcli>
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
80103c5f:	e8 ac 36 00 00       	call   80107310 <switchuvm>
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
80103c7a:	e8 f1 38 00 00       	call   80107570 <allocuvm>
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
80103c9a:	e8 01 3a 00 00       	call   801076a0 <deallocuvm>
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
80103cbd:	e8 ce 0f 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80103cc2:	e8 d9 fb ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80103cc7:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103ccd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  popcli();
80103cd0:	e8 0b 10 00 00       	call   80104ce0 <popcli>
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
80103cef:	e8 2c 3b 00 00       	call   80107820 <copyuvm>
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
80103d6f:	e8 ec 12 00 00       	call   80105060 <safestrcpy>
  pid = np->pid;
80103d74:	8b 73 10             	mov    0x10(%ebx),%esi
  pushcli();
80103d77:	e8 14 0f 00 00       	call   80104c90 <pushcli>
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
80103da4:	e8 37 0f 00 00       	call   80104ce0 <popcli>
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
80103e23:	68 5b 7f 10 80       	push   $0x80107f5b
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
80103ecb:	e8 c0 0d 00 00       	call   80104c90 <pushcli>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ed0:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
80103ed5:	e9 b0 00 00 00       	jmp    80103f8a <scheduler+0xea>
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
80103f0f:	e8 fc 33 00 00       	call   80107310 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f14:	58                   	pop    %eax
80103f15:	5a                   	pop    %edx
80103f16:	ff 73 1c             	pushl  0x1c(%ebx)
80103f19:	ff 75 e0             	pushl  -0x20(%ebp)
80103f1c:	e8 a2 11 00 00       	call   801050c3 <swtch>
      switchkvm();
80103f21:	e8 ca 33 00 00       	call   801072f0 <switchkvm>
      c->proc = 0;
80103f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103f29:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f30:	00 00 00 
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103f33:	b8 09 00 00 00       	mov    $0x9,%eax
80103f38:	f0 0f b1 37          	lock cmpxchg %esi,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f3c:	9c                   	pushf  
80103f3d:	58                   	pop    %eax
      if (cas(&(p->state), MINUS_RUNNABLE, RUNNABLE) || cas(&(p->state), MINUS_SLEEPING, SLEEPING) || cas(&(p->state), MINUS_ZOMBIE, ZOMBIE)){
80103f3e:	83 c4 10             	add    $0x10,%esp
80103f41:	a8 40                	test   $0x40,%al
80103f43:	0f 85 9f 00 00 00    	jne    80103fe8 <scheduler+0x148>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103f49:	b8 08 00 00 00       	mov    $0x8,%eax
80103f4e:	ba 02 00 00 00       	mov    $0x2,%edx
80103f53:	f0 0f b1 17          	lock cmpxchg %edx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f57:	9c                   	pushf  
80103f58:	58                   	pop    %eax
80103f59:	a8 40                	test   $0x40,%al
80103f5b:	0f 85 87 00 00 00    	jne    80103fe8 <scheduler+0x148>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80103f61:	b8 0b 00 00 00       	mov    $0xb,%eax
80103f66:	ba 05 00 00 00       	mov    $0x5,%edx
80103f6b:	f0 0f b1 17          	lock cmpxchg %edx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f6f:	9c                   	pushf  
80103f70:	58                   	pop    %eax
80103f71:	a8 40                	test   $0x40,%al
80103f73:	75 73                	jne    80103fe8 <scheduler+0x148>
80103f75:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f78:	81 c3 98 01 00 00    	add    $0x198,%ebx
80103f7e:	81 fb 74 a3 11 80    	cmp    $0x8011a374,%ebx
80103f84:	0f 84 88 00 00 00    	je     80104012 <scheduler+0x172>
      if (p->flag_frozen && !has_cont_pending(p)){
80103f8a:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
80103f8d:	85 c9                	test   %ecx,%ecx
80103f8f:	0f 84 4b ff ff ff    	je     80103ee0 <scheduler+0x40>
    if (!((1 << i) & p->pending_signals)){
80103f95:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80103f9b:	31 c9                	xor    %ecx,%ecx
80103f9d:	b8 01 00 00 00       	mov    $0x1,%eax
80103fa2:	eb 1a                	jmp    80103fbe <scheduler+0x11e>
80103fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if ((int)(p->signal_handlers[i].sa_handler) == SIGCONT){
80103fa8:	83 bc cb 90 00 00 00 	cmpl   $0x13,0x90(%ebx,%ecx,8)
80103faf:	13 
80103fb0:	0f 84 2a ff ff ff    	je     80103ee0 <scheduler+0x40>
  for (int i = 0; i < 32; i++){
80103fb6:	83 f9 1f             	cmp    $0x1f,%ecx
80103fb9:	74 bd                	je     80103f78 <scheduler+0xd8>
80103fbb:	83 c1 01             	add    $0x1,%ecx
    if (!((1 << i) & p->pending_signals)){
80103fbe:	89 c7                	mov    %eax,%edi
80103fc0:	d3 e7                	shl    %cl,%edi
80103fc2:	85 d7                	test   %edx,%edi
80103fc4:	74 f0                	je     80103fb6 <scheduler+0x116>
    if (i == SIGCONT && p->signal_handlers[i].sa_handler == SIG_DFL){
80103fc6:	83 f9 13             	cmp    $0x13,%ecx
80103fc9:	75 dd                	jne    80103fa8 <scheduler+0x108>
80103fcb:	8b bb 28 01 00 00    	mov    0x128(%ebx),%edi
80103fd1:	85 ff                	test   %edi,%edi
80103fd3:	0f 84 07 ff ff ff    	je     80103ee0 <scheduler+0x40>
    if ((int)(p->signal_handlers[i].sa_handler) == SIGCONT){
80103fd9:	83 ff 13             	cmp    $0x13,%edi
80103fdc:	75 dd                	jne    80103fbb <scheduler+0x11b>
80103fde:	e9 fd fe ff ff       	jmp    80103ee0 <scheduler+0x40>
80103fe3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fe7:	90                   	nop
        p->debug = 12;
80103fe8:	c7 83 94 01 00 00 0c 	movl   $0xc,0x194(%ebx)
80103fef:	00 00 00 
        if (p->state == ZOMBIE){
80103ff2:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103ff6:	75 80                	jne    80103f78 <scheduler+0xd8>
          wakeup1(p->parent);
80103ff8:	8b 43 14             	mov    0x14(%ebx),%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ffb:	81 c3 98 01 00 00    	add    $0x198,%ebx
          wakeup1(p->parent);
80104001:	e8 ba f7 ff ff       	call   801037c0 <wakeup1>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104006:	81 fb 74 a3 11 80    	cmp    $0x8011a374,%ebx
8010400c:	0f 85 78 ff ff ff    	jne    80103f8a <scheduler+0xea>
    popcli();
80104012:	e8 c9 0c 00 00       	call   80104ce0 <popcli>
    sti();
80104017:	e9 ae fe ff ff       	jmp    80103eca <scheduler+0x2a>
8010401c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104020 <sched>:
{
80104020:	f3 0f 1e fb          	endbr32 
80104024:	55                   	push   %ebp
80104025:	89 e5                	mov    %esp,%ebp
80104027:	56                   	push   %esi
80104028:	53                   	push   %ebx
  pushcli();
80104029:	e8 62 0c 00 00       	call   80104c90 <pushcli>
  c = mycpu();
8010402e:	e8 6d f8 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104033:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104039:	e8 a2 0c 00 00       	call   80104ce0 <popcli>
  if((p->state == RUNNING))
8010403e:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104042:	74 3b                	je     8010407f <sched+0x5f>
80104044:	9c                   	pushf  
80104045:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104046:	f6 c4 02             	test   $0x2,%ah
80104049:	75 41                	jne    8010408c <sched+0x6c>
  intena = mycpu()->intena;
8010404b:	e8 50 f8 ff ff       	call   801038a0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104050:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104053:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104059:	e8 42 f8 ff ff       	call   801038a0 <mycpu>
8010405e:	83 ec 08             	sub    $0x8,%esp
80104061:	ff 70 04             	pushl  0x4(%eax)
80104064:	53                   	push   %ebx
80104065:	e8 59 10 00 00       	call   801050c3 <swtch>
  mycpu()->intena = intena;
8010406a:	e8 31 f8 ff ff       	call   801038a0 <mycpu>
}
8010406f:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104072:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104078:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010407b:	5b                   	pop    %ebx
8010407c:	5e                   	pop    %esi
8010407d:	5d                   	pop    %ebp
8010407e:	c3                   	ret    
    panic("sched running");
8010407f:	83 ec 0c             	sub    $0xc,%esp
80104082:	68 79 7f 10 80       	push   $0x80107f79
80104087:	e8 04 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010408c:	83 ec 0c             	sub    $0xc,%esp
8010408f:	68 87 7f 10 80       	push   $0x80107f87
80104094:	e8 f7 c2 ff ff       	call   80100390 <panic>
80104099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040a0 <exit>:
{
801040a0:	f3 0f 1e fb          	endbr32 
801040a4:	55                   	push   %ebp
801040a5:	89 e5                	mov    %esp,%ebp
801040a7:	57                   	push   %edi
801040a8:	56                   	push   %esi
801040a9:	53                   	push   %ebx
801040aa:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801040ad:	e8 de 0b 00 00       	call   80104c90 <pushcli>
  c = mycpu();
801040b2:	e8 e9 f7 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
801040b7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040bd:	e8 1e 0c 00 00       	call   80104ce0 <popcli>
  if(curproc == initproc)
801040c2:	8d 5e 28             	lea    0x28(%esi),%ebx
801040c5:	8d 7e 68             	lea    0x68(%esi),%edi
801040c8:	39 35 bc b5 10 80    	cmp    %esi,0x8010b5bc
801040ce:	0f 84 e0 00 00 00    	je     801041b4 <exit+0x114>
801040d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801040d8:	8b 03                	mov    (%ebx),%eax
801040da:	85 c0                	test   %eax,%eax
801040dc:	74 12                	je     801040f0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801040de:	83 ec 0c             	sub    $0xc,%esp
801040e1:	50                   	push   %eax
801040e2:	e8 09 ce ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
801040e7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801040ed:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801040f0:	83 c3 04             	add    $0x4,%ebx
801040f3:	39 fb                	cmp    %edi,%ebx
801040f5:	75 e1                	jne    801040d8 <exit+0x38>
  begin_op();
801040f7:	e8 64 ec ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
801040fc:	83 ec 0c             	sub    $0xc,%esp
801040ff:	ff 76 68             	pushl  0x68(%esi)
80104102:	e8 b9 d7 ff ff       	call   801018c0 <iput>
  end_op();
80104107:	e8 c4 ec ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
8010410c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  pushcli();
80104113:	e8 78 0b 00 00       	call   80104c90 <pushcli>
  if (!cas(&(curproc->state), RUNNING, MINUS_ZOMBIE)){
80104118:	8d 56 0c             	lea    0xc(%esi),%edx
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
8010411b:	b8 04 00 00 00       	mov    $0x4,%eax
80104120:	b9 0b 00 00 00       	mov    $0xb,%ecx
80104125:	f0 0f b1 0a          	lock cmpxchg %ecx,(%edx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104129:	9c                   	pushf  
8010412a:	58                   	pop    %eax
8010412b:	83 c4 10             	add    $0x10,%esp
8010412e:	a8 40                	test   $0x40,%al
80104130:	74 75                	je     801041a7 <exit+0x107>
  curproc->debug = 6;
80104132:	c7 86 94 01 00 00 06 	movl   $0x6,0x194(%esi)
80104139:	00 00 00 
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010413c:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
80104141:	eb 13                	jmp    80104156 <exit+0xb6>
80104143:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104147:	90                   	nop
80104148:	81 c3 98 01 00 00    	add    $0x198,%ebx
8010414e:	81 fb 74 a3 11 80    	cmp    $0x8011a374,%ebx
80104154:	74 3f                	je     80104195 <exit+0xf5>
    if(p->parent == curproc){
80104156:	39 73 14             	cmp    %esi,0x14(%ebx)
80104159:	75 ed                	jne    80104148 <exit+0xa8>
      p->parent = initproc;
8010415b:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
      if(p->state == ZOMBIE || p->state == MINUS_ZOMBIE){
80104161:	8b 43 0c             	mov    0xc(%ebx),%eax
      p->parent = initproc;
80104164:	89 53 14             	mov    %edx,0x14(%ebx)
      if(p->state == ZOMBIE || p->state == MINUS_ZOMBIE){
80104167:	83 f8 05             	cmp    $0x5,%eax
8010416a:	74 05                	je     80104171 <exit+0xd1>
8010416c:	83 f8 0b             	cmp    $0xb,%eax
8010416f:	75 d7                	jne    80104148 <exit+0xa8>
        while (p->state == MINUS_ZOMBIE) {
80104171:	83 f8 0b             	cmp    $0xb,%eax
80104174:	75 0a                	jne    80104180 <exit+0xe0>
80104176:	eb fe                	jmp    80104176 <exit+0xd6>
80104178:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010417f:	90                   	nop
        wakeup1(initproc);
80104180:	89 d0                	mov    %edx,%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104182:	81 c3 98 01 00 00    	add    $0x198,%ebx
        wakeup1(initproc);
80104188:	e8 33 f6 ff ff       	call   801037c0 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010418d:	81 fb 74 a3 11 80    	cmp    $0x8011a374,%ebx
80104193:	75 c1                	jne    80104156 <exit+0xb6>
  sched();
80104195:	e8 86 fe ff ff       	call   80104020 <sched>
  panic("zombie exit");
8010419a:	83 ec 0c             	sub    $0xc,%esp
8010419d:	68 a8 7f 10 80       	push   $0x80107fa8
801041a2:	e8 e9 c1 ff ff       	call   80100390 <panic>
    panic("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
801041a7:	83 ec 0c             	sub    $0xc,%esp
801041aa:	68 dc 80 10 80       	push   $0x801080dc
801041af:	e8 dc c1 ff ff       	call   80100390 <panic>
    panic("init exiting");
801041b4:	83 ec 0c             	sub    $0xc,%esp
801041b7:	68 9b 7f 10 80       	push   $0x80107f9b
801041bc:	e8 cf c1 ff ff       	call   80100390 <panic>
801041c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041cf:	90                   	nop

801041d0 <wait>:
{
801041d0:	f3 0f 1e fb          	endbr32 
801041d4:	55                   	push   %ebp
801041d5:	89 e5                	mov    %esp,%ebp
801041d7:	57                   	push   %edi
801041d8:	56                   	push   %esi
801041d9:	53                   	push   %ebx
801041da:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801041dd:	e8 ae 0a 00 00       	call   80104c90 <pushcli>
  c = mycpu();
801041e2:	e8 b9 f6 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
801041e7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041ed:	e8 ee 0a 00 00       	call   80104ce0 <popcli>
  pushcli();
801041f2:	e8 99 0a 00 00       	call   80104c90 <pushcli>
801041f7:	8d 7e 0c             	lea    0xc(%esi),%edi
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
801041fa:	ba 08 00 00 00       	mov    $0x8,%edx
801041ff:	b8 04 00 00 00       	mov    $0x4,%eax
80104204:	f0 0f b1 17          	lock cmpxchg %edx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104208:	9c                   	pushf  
80104209:	58                   	pop    %eax
    if (!cas(&(curproc->state), RUNNING, MINUS_SLEEPING) && !cas(&(curproc->state), MINUS_SLEEPING, MINUS_SLEEPING)){
8010420a:	a8 40                	test   $0x40,%al
8010420c:	75 10                	jne    8010421e <wait+0x4e>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
8010420e:	89 d0                	mov    %edx,%eax
80104210:	f0 0f b1 17          	lock cmpxchg %edx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104214:	9c                   	pushf  
80104215:	58                   	pop    %eax
80104216:	a8 40                	test   $0x40,%al
80104218:	0f 84 df 01 00 00    	je     801043fd <wait+0x22d>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
8010421e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    havekids = 0;
80104221:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104223:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
    curproc->debug = 7;
80104228:	c7 86 94 01 00 00 07 	movl   $0x7,0x194(%esi)
8010422f:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104232:	eb 12                	jmp    80104246 <wait+0x76>
80104234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104238:	81 c3 98 01 00 00    	add    $0x198,%ebx
8010423e:	81 fb 74 a3 11 80    	cmp    $0x8011a374,%ebx
80104244:	74 40                	je     80104286 <wait+0xb6>
      if(p->parent != curproc)
80104246:	39 73 14             	cmp    %esi,0x14(%ebx)
80104249:	75 ed                	jne    80104238 <wait+0x68>
      if (p->state == MINUS_ZOMBIE){
8010424b:	31 d2                	xor    %edx,%edx
8010424d:	83 7b 0c 0b          	cmpl   $0xb,0xc(%ebx)
80104251:	74 5d                	je     801042b0 <wait+0xe0>
      if(cas(&(p->state), ZOMBIE, -UNUSED)){
80104253:	8d 4b 0c             	lea    0xc(%ebx),%ecx
80104256:	b8 05 00 00 00       	mov    $0x5,%eax
8010425b:	31 ff                	xor    %edi,%edi
8010425d:	f0 0f b1 39          	lock cmpxchg %edi,(%ecx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104261:	9c                   	pushf  
80104262:	58                   	pop    %eax
80104263:	a8 40                	test   $0x40,%al
80104265:	0f 85 8e 00 00 00    	jne    801042f9 <wait+0x129>
      else if (found){
8010426b:	85 d2                	test   %edx,%edx
8010426d:	0f 85 7d 01 00 00    	jne    801043f0 <wait+0x220>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104273:	81 c3 98 01 00 00    	add    $0x198,%ebx
      havekids = 1;
80104279:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010427e:	81 fb 74 a3 11 80    	cmp    $0x8011a374,%ebx
80104284:	75 c0                	jne    80104246 <wait+0x76>
80104286:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    if(!havekids || curproc->killed){
80104289:	85 c0                	test   %eax,%eax
8010428b:	0f 84 1f 01 00 00    	je     801043b0 <wait+0x1e0>
80104291:	8b 46 24             	mov    0x24(%esi),%eax
80104294:	85 c0                	test   %eax,%eax
80104296:	0f 85 14 01 00 00    	jne    801043b0 <wait+0x1e0>
    curproc->chan = curproc;
8010429c:	89 76 20             	mov    %esi,0x20(%esi)
    sched();
8010429f:	e8 7c fd ff ff       	call   80104020 <sched>
    curproc->chan = 0;
801042a4:	c7 46 20 00 00 00 00 	movl   $0x0,0x20(%esi)
    if (!cas(&(curproc->state), RUNNING, MINUS_SLEEPING) && !cas(&(curproc->state), MINUS_SLEEPING, MINUS_SLEEPING)){
801042ab:	e9 4a ff ff ff       	jmp    801041fa <wait+0x2a>
        switch_state(&(curproc->state), MINUS_SLEEPING, RUNNING);
801042b0:	83 ec 04             	sub    $0x4,%esp
801042b3:	6a 04                	push   $0x4
801042b5:	6a 08                	push   $0x8
801042b7:	ff 75 e4             	pushl  -0x1c(%ebp)
801042ba:	e8 11 f8 ff ff       	call   80103ad0 <switch_state>
      while (p->state == MINUS_ZOMBIE){
801042bf:	83 c4 10             	add    $0x10,%esp
801042c2:	83 7b 0c 0b          	cmpl   $0xb,0xc(%ebx)
801042c6:	75 27                	jne    801042ef <wait+0x11f>
801042c8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801042cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042cf:	90                   	nop
        cprintf("boohoo child pid = %d parent pid = %d\n", p->pid, curproc->pid);
801042d0:	83 ec 04             	sub    $0x4,%esp
801042d3:	ff 76 10             	pushl  0x10(%esi)
801042d6:	ff 73 10             	pushl  0x10(%ebx)
801042d9:	68 0c 81 10 80       	push   $0x8010810c
801042de:	e8 cd c3 ff ff       	call   801006b0 <cprintf>
      while (p->state == MINUS_ZOMBIE){
801042e3:	83 c4 10             	add    $0x10,%esp
801042e6:	83 7b 0c 0b          	cmpl   $0xb,0xc(%ebx)
801042ea:	74 e4                	je     801042d0 <wait+0x100>
801042ec:	89 7d e4             	mov    %edi,-0x1c(%ebp)
        found = 1;
801042ef:	ba 01 00 00 00       	mov    $0x1,%edx
801042f4:	e9 5a ff ff ff       	jmp    80104253 <wait+0x83>
        kfree((char *)p->user_trapframe_backup);
801042f9:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801042fc:	8b 43 10             	mov    0x10(%ebx),%eax
801042ff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        kfree((char *)p->user_trapframe_backup);
80104302:	ff b3 90 01 00 00    	pushl  0x190(%ebx)
80104308:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        pid = p->pid;
8010430b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        p->debug = 8;
8010430e:	c7 83 94 01 00 00 08 	movl   $0x8,0x194(%ebx)
80104315:	00 00 00 
        kfree((char *)p->user_trapframe_backup);
80104318:	e8 83 e1 ff ff       	call   801024a0 <kfree>
        kfree(p->kstack);
8010431d:	5a                   	pop    %edx
8010431e:	ff 73 08             	pushl  0x8(%ebx)
        p->user_trapframe_backup = 0;
80104321:	c7 83 90 01 00 00 00 	movl   $0x0,0x190(%ebx)
80104328:	00 00 00 
        kfree(p->kstack);
8010432b:	e8 70 e1 ff ff       	call   801024a0 <kfree>
        freevm(p->pgdir);
80104330:	59                   	pop    %ecx
80104331:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104334:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010433b:	e8 90 33 00 00       	call   801076d0 <freevm>
        switch_state(&(p->state), -UNUSED, UNUSED);
80104340:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80104343:	83 c4 0c             	add    $0xc,%esp
        p->name[0] = 0;
80104346:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        switch_state(&(p->state), -UNUSED, UNUSED);
8010434a:	6a 00                	push   $0x0
8010434c:	6a 00                	push   $0x0
8010434e:	51                   	push   %ecx
        p->pid = 0;
8010434f:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104356:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->killed = 0;
8010435d:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        switch_state(&(p->state), -UNUSED, UNUSED);
80104364:	e8 67 f7 ff ff       	call   80103ad0 <switch_state>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80104369:	ba 04 00 00 00       	mov    $0x4,%edx
8010436e:	b8 08 00 00 00       	mov    $0x8,%eax
        p->debug = 1;
80104373:	c7 83 94 01 00 00 01 	movl   $0x1,0x194(%ebx)
8010437a:	00 00 00 
8010437d:	f0 0f b1 17          	lock cmpxchg %edx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104381:	9c                   	pushf  
80104382:	58                   	pop    %eax
        if (!cas(&(curproc->state), MINUS_SLEEPING, RUNNING) && !cas(&(curproc->state), RUNNING, RUNNING)){
80104383:	83 c4 10             	add    $0x10,%esp
80104386:	a8 40                	test   $0x40,%al
80104388:	75 0c                	jne    80104396 <wait+0x1c6>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
8010438a:	89 d0                	mov    %edx,%eax
8010438c:	f0 0f b1 17          	lock cmpxchg %edx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104390:	9c                   	pushf  
80104391:	58                   	pop    %eax
80104392:	a8 40                	test   $0x40,%al
80104394:	74 46                	je     801043dc <wait+0x20c>
        curproc->debug = 9;
80104396:	c7 86 94 01 00 00 09 	movl   $0x9,0x194(%esi)
8010439d:	00 00 00 
        popcli();
801043a0:	e8 3b 09 00 00       	call   80104ce0 <popcli>
}
801043a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801043a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043ab:	5b                   	pop    %ebx
801043ac:	5e                   	pop    %esi
801043ad:	5f                   	pop    %edi
801043ae:	5d                   	pop    %ebp
801043af:	c3                   	ret    
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
801043b0:	b8 08 00 00 00       	mov    $0x8,%eax
801043b5:	ba 04 00 00 00       	mov    $0x4,%edx
801043ba:	f0 0f b1 17          	lock cmpxchg %edx,(%edi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043be:	9c                   	pushf  
801043bf:	58                   	pop    %eax
      if (!cas(&(curproc->state), MINUS_SLEEPING, RUNNING)){
801043c0:	a8 40                	test   $0x40,%al
801043c2:	74 18                	je     801043dc <wait+0x20c>
      curproc->debug = 10;
801043c4:	c7 86 94 01 00 00 0a 	movl   $0xa,0x194(%esi)
801043cb:	00 00 00 
      popcli();
801043ce:	e8 0d 09 00 00       	call   80104ce0 <popcli>
      return -1;
801043d3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
801043da:	eb c9                	jmp    801043a5 <wait+0x1d5>
          panic("unable to return to running state in wait\n");
801043dc:	83 ec 0c             	sub    $0xc,%esp
801043df:	68 34 81 10 80       	push   $0x80108134
801043e4:	e8 a7 bf ff ff       	call   80100390 <panic>
801043e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        panic("something is wrong in wait");
801043f0:	83 ec 0c             	sub    $0xc,%esp
801043f3:	68 b7 7f 10 80       	push   $0x80107fb7
801043f8:	e8 93 bf ff ff       	call   80100390 <panic>
      panic("^^");
801043fd:	83 ec 0c             	sub    $0xc,%esp
80104400:	68 b4 7f 10 80       	push   $0x80107fb4
80104405:	e8 86 bf ff ff       	call   80100390 <panic>
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104410 <yield>:
{
80104410:	f3 0f 1e fb          	endbr32 
80104414:	55                   	push   %ebp
80104415:	89 e5                	mov    %esp,%ebp
80104417:	53                   	push   %ebx
80104418:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010441b:	e8 70 08 00 00       	call   80104c90 <pushcli>
  pushcli();
80104420:	e8 6b 08 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80104425:	e8 76 f4 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
8010442a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104430:	e8 ab 08 00 00       	call   80104ce0 <popcli>
  switch_state(&(myproc()->state), RUNNING, MINUS_RUNNABLE);
80104435:	83 ec 04             	sub    $0x4,%esp
80104438:	83 c3 0c             	add    $0xc,%ebx
8010443b:	6a 09                	push   $0x9
8010443d:	6a 04                	push   $0x4
8010443f:	53                   	push   %ebx
80104440:	e8 8b f6 ff ff       	call   80103ad0 <switch_state>
  pushcli();
80104445:	e8 46 08 00 00       	call   80104c90 <pushcli>
  c = mycpu();
8010444a:	e8 51 f4 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
8010444f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104455:	e8 86 08 00 00       	call   80104ce0 <popcli>
  myproc()->debug = 2;
8010445a:	c7 83 94 01 00 00 02 	movl   $0x2,0x194(%ebx)
80104461:	00 00 00 
  sched();
80104464:	e8 b7 fb ff ff       	call   80104020 <sched>
}
80104469:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  popcli();
8010446c:	83 c4 10             	add    $0x10,%esp
}
8010446f:	c9                   	leave  
  popcli();
80104470:	e9 6b 08 00 00       	jmp    80104ce0 <popcli>
80104475:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104480 <sleep>:
{
80104480:	f3 0f 1e fb          	endbr32 
80104484:	55                   	push   %ebp
80104485:	89 e5                	mov    %esp,%ebp
80104487:	57                   	push   %edi
80104488:	56                   	push   %esi
80104489:	53                   	push   %ebx
8010448a:	83 ec 1c             	sub    $0x1c,%esp
8010448d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104490:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104493:	e8 f8 07 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80104498:	e8 03 f4 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
8010449d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044a3:	e8 38 08 00 00       	call   80104ce0 <popcli>
  if(p == 0)
801044a8:	85 db                	test   %ebx,%ebx
801044aa:	0f 84 a2 00 00 00    	je     80104552 <sleep+0xd2>
  if(lk != null){  //DOC: sleeplock0
801044b0:	85 f6                	test   %esi,%esi
801044b2:	74 11                	je     801044c5 <sleep+0x45>
    pushcli();
801044b4:	e8 d7 07 00 00       	call   80104c90 <pushcli>
    release(lk);
801044b9:	83 ec 0c             	sub    $0xc,%esp
801044bc:	56                   	push   %esi
801044bd:	e8 8e 09 00 00       	call   80104e50 <release>
801044c2:	83 c4 10             	add    $0x10,%esp
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
801044c5:	8b 43 20             	mov    0x20(%ebx),%eax
  if (!cas(&(p->chan), (int)p->chan, (int)chan)){
801044c8:	8d 53 20             	lea    0x20(%ebx),%edx
801044cb:	f0 0f b1 3a          	lock cmpxchg %edi,(%edx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044cf:	9c                   	pushf  
801044d0:	58                   	pop    %eax
801044d1:	a8 40                	test   $0x40,%al
801044d3:	74 63                	je     80104538 <sleep+0xb8>
  if (!cas(&(p->state), RUNNING, MINUS_SLEEPING)){
801044d5:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
801044d8:	b8 04 00 00 00       	mov    $0x4,%eax
801044dd:	bf 08 00 00 00       	mov    $0x8,%edi
801044e2:	f0 0f b1 39          	lock cmpxchg %edi,(%ecx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044e6:	9c                   	pushf  
801044e7:	58                   	pop    %eax
801044e8:	a8 40                	test   $0x40,%al
801044ea:	74 59                	je     80104545 <sleep+0xc5>
  p->debug = 13;
801044ec:	c7 83 94 01 00 00 0d 	movl   $0xd,0x194(%ebx)
801044f3:	00 00 00 
801044f6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  sched();
801044f9:	e8 22 fb ff ff       	call   80104020 <sched>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
801044fe:	8b 43 20             	mov    0x20(%ebx),%eax
80104501:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104504:	31 c9                	xor    %ecx,%ecx
80104506:	f0 0f b1 0a          	lock cmpxchg %ecx,(%edx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010450a:	9c                   	pushf  
8010450b:	58                   	pop    %eax
  if (!cas(&(p->chan), (int)p->chan, 0)){
8010450c:	a8 40                	test   $0x40,%al
8010450e:	74 28                	je     80104538 <sleep+0xb8>
  if(lk != null){  //DOC: sleeplock2
80104510:	85 f6                	test   %esi,%esi
80104512:	74 1c                	je     80104530 <sleep+0xb0>
    acquire(lk);
80104514:	83 ec 0c             	sub    $0xc,%esp
80104517:	56                   	push   %esi
80104518:	e8 73 08 00 00       	call   80104d90 <acquire>
    popcli();
8010451d:	83 c4 10             	add    $0x10,%esp
}
80104520:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104523:	5b                   	pop    %ebx
80104524:	5e                   	pop    %esi
80104525:	5f                   	pop    %edi
80104526:	5d                   	pop    %ebp
    popcli();
80104527:	e9 b4 07 00 00       	jmp    80104ce0 <popcli>
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80104530:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104533:	5b                   	pop    %ebx
80104534:	5e                   	pop    %esi
80104535:	5f                   	pop    %edi
80104536:	5d                   	pop    %ebp
80104537:	c3                   	ret    
    panic("sleep wrong");
80104538:	83 ec 0c             	sub    $0xc,%esp
8010453b:	68 d8 7f 10 80       	push   $0x80107fd8
80104540:	e8 4b be ff ff       	call   80100390 <panic>
    panic("sleep change state failed");
80104545:	83 ec 0c             	sub    $0xc,%esp
80104548:	68 e4 7f 10 80       	push   $0x80107fe4
8010454d:	e8 3e be ff ff       	call   80100390 <panic>
    panic("sleep");
80104552:	83 ec 0c             	sub    $0xc,%esp
80104555:	68 d2 7f 10 80       	push   $0x80107fd2
8010455a:	e8 31 be ff ff       	call   80100390 <panic>
8010455f:	90                   	nop

80104560 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104560:	f3 0f 1e fb          	endbr32 
80104564:	55                   	push   %ebp
80104565:	89 e5                	mov    %esp,%ebp
80104567:	53                   	push   %ebx
80104568:	83 ec 04             	sub    $0x4,%esp
8010456b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // possible bug
  // acquire(&ptable.lock);
  pushcli();
8010456e:	e8 1d 07 00 00       	call   80104c90 <pushcli>
  wakeup1(chan);
80104573:	89 d8                	mov    %ebx,%eax
80104575:	e8 46 f2 ff ff       	call   801037c0 <wakeup1>
  popcli();
  // release(&ptable.lock);
}
8010457a:	83 c4 04             	add    $0x4,%esp
8010457d:	5b                   	pop    %ebx
8010457e:	5d                   	pop    %ebp
  popcli();
8010457f:	e9 5c 07 00 00       	jmp    80104ce0 <popcli>
80104584:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010458b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010458f:	90                   	nop

80104590 <is_blocked>:

int is_blocked(uint mask, int signum){
80104590:	f3 0f 1e fb          	endbr32 
80104594:	55                   	push   %ebp
  return (mask & (1 << signum));
80104595:	b8 01 00 00 00       	mov    $0x1,%eax
int is_blocked(uint mask, int signum){
8010459a:	89 e5                	mov    %esp,%ebp
  return (mask & (1 << signum));
8010459c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010459f:	d3 e0                	shl    %cl,%eax
801045a1:	23 45 08             	and    0x8(%ebp),%eax
}
801045a4:	5d                   	pop    %ebp
801045a5:	c3                   	ret    
801045a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ad:	8d 76 00             	lea    0x0(%esi),%esi

801045b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid, int signum)
{
801045b0:	f3 0f 1e fb          	endbr32 
801045b4:	55                   	push   %ebp
801045b5:	89 e5                	mov    %esp,%ebp
801045b7:	57                   	push   %edi
801045b8:	56                   	push   %esi
801045b9:	53                   	push   %ebx
801045ba:	83 ec 0c             	sub    $0xc,%esp
801045bd:	8b 75 0c             	mov    0xc(%ebp),%esi
801045c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (signum < 0 || signum > 31){
801045c3:	83 fe 1f             	cmp    $0x1f,%esi
801045c6:	0f 87 c6 00 00 00    	ja     80104692 <kill+0xe2>
    return -1;
  }
  struct proc *p;
  // acquire(&ptable.lock);
  pushcli();
801045cc:	e8 bf 06 00 00       	call   80104c90 <pushcli>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045d1:	ba 74 3d 11 80       	mov    $0x80113d74,%edx
801045d6:	eb 1a                	jmp    801045f2 <kill+0x42>
801045d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045df:	90                   	nop
801045e0:	81 c2 98 01 00 00    	add    $0x198,%edx
801045e6:	81 fa 74 a3 11 80    	cmp    $0x8011a374,%edx
801045ec:	0f 84 8e 00 00 00    	je     80104680 <kill+0xd0>
    if(p->pid == pid){
801045f2:	39 5a 10             	cmp    %ebx,0x10(%edx)
801045f5:	75 e9                	jne    801045e0 <kill+0x30>
      if ((((int)(p->signal_handlers[signum].sa_handler) == SIGKILL && !is_blocked(p->blocked_signal_mask, signum)) || signum == SIGKILL || signum == SIGSTOP)){
801045f7:	bf 01 00 00 00       	mov    $0x1,%edi
801045fc:	89 f1                	mov    %esi,%ecx
801045fe:	d3 e7                	shl    %cl,%edi
80104600:	83 bc f2 90 00 00 00 	cmpl   $0x9,0x90(%edx,%esi,8)
80104607:	09 
80104608:	74 56                	je     80104660 <kill+0xb0>
8010460a:	83 ee 09             	sub    $0x9,%esi
8010460d:	83 e6 f7             	and    $0xfffffff7,%esi
80104610:	75 32                	jne    80104644 <kill+0x94>
        while (p->state == SLEEPING || p->state == MINUS_SLEEPING){
80104612:	8b 42 0c             	mov    0xc(%edx),%eax
          if (cas(&(p->state), SLEEPING, RUNNABLE)){
80104615:	8d 72 0c             	lea    0xc(%edx),%esi
        while (p->state == SLEEPING || p->state == MINUS_SLEEPING){
80104618:	83 f8 02             	cmp    $0x2,%eax
8010461b:	0f 94 c3             	sete   %bl
8010461e:	83 f8 08             	cmp    $0x8,%eax
80104621:	0f 94 c0             	sete   %al
80104624:	09 c3                	or     %eax,%ebx
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
80104626:	b8 02 00 00 00       	mov    $0x2,%eax
8010462b:	eb 13                	jmp    80104640 <kill+0x90>
8010462d:	8d 76 00             	lea    0x0(%esi),%esi
80104630:	b9 03 00 00 00       	mov    $0x3,%ecx
80104635:	f0 0f b1 0e          	lock cmpxchg %ecx,(%esi)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104639:	9c                   	pushf  
8010463a:	59                   	pop    %ecx
          if (cas(&(p->state), SLEEPING, RUNNABLE)){
8010463b:	83 e1 40             	and    $0x40,%ecx
8010463e:	75 30                	jne    80104670 <kill+0xc0>
        while (p->state == SLEEPING || p->state == MINUS_SLEEPING){
80104640:	84 db                	test   %bl,%bl
80104642:	75 ec                	jne    80104630 <kill+0x80>
          }
          
        }
        
      }
      p->pending_signals = p->pending_signals | (1 << signum);
80104644:	09 ba 84 00 00 00    	or     %edi,0x84(%edx)
      // release(&ptable.lock);
      popcli();
8010464a:	e8 91 06 00 00       	call   80104ce0 <popcli>
      return 0;
8010464f:	31 c0                	xor    %eax,%eax
    }
  }
  // release(&ptable.lock);
  popcli();
  return -1;
}
80104651:	83 c4 0c             	add    $0xc,%esp
80104654:	5b                   	pop    %ebx
80104655:	5e                   	pop    %esi
80104656:	5f                   	pop    %edi
80104657:	5d                   	pop    %ebp
80104658:	c3                   	ret    
80104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if ((((int)(p->signal_handlers[signum].sa_handler) == SIGKILL && !is_blocked(p->blocked_signal_mask, signum)) || signum == SIGKILL || signum == SIGSTOP)){
80104660:	85 ba 88 00 00 00    	test   %edi,0x88(%edx)
80104666:	74 aa                	je     80104612 <kill+0x62>
80104668:	eb a0                	jmp    8010460a <kill+0x5a>
8010466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            p->debug = 15;
80104670:	c7 82 94 01 00 00 0f 	movl   $0xf,0x194(%edx)
80104677:	00 00 00 
            break;
8010467a:	eb c8                	jmp    80104644 <kill+0x94>
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  popcli();
80104680:	e8 5b 06 00 00       	call   80104ce0 <popcli>
}
80104685:	83 c4 0c             	add    $0xc,%esp
  return -1;
80104688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010468d:	5b                   	pop    %ebx
8010468e:	5e                   	pop    %esi
8010468f:	5f                   	pop    %edi
80104690:	5d                   	pop    %ebp
80104691:	c3                   	ret    
    return -1;
80104692:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104697:	eb b8                	jmp    80104651 <kill+0xa1>
80104699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801046a0:	f3 0f 1e fb          	endbr32 
801046a4:	55                   	push   %ebp
801046a5:	89 e5                	mov    %esp,%ebp
801046a7:	57                   	push   %edi
801046a8:	56                   	push   %esi
801046a9:	53                   	push   %ebx
801046aa:	bb e0 3d 11 80       	mov    $0x80113de0,%ebx
801046af:	83 ec 3c             	sub    $0x3c,%esp
801046b2:	eb 26                	jmp    801046da <procdump+0x3a>
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(signum=0; signum<10 && pc[signum] != 0; signum++)
        cprintf(" %p", pc[signum]);
    }
    cprintf("\n");
801046b8:	83 ec 0c             	sub    $0xc,%esp
801046bb:	68 c3 84 10 80       	push   $0x801084c3
801046c0:	e8 eb bf ff ff       	call   801006b0 <cprintf>
801046c5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046c8:	81 c3 98 01 00 00    	add    $0x198,%ebx
801046ce:	81 fb e0 a3 11 80    	cmp    $0x8011a3e0,%ebx
801046d4:	0f 84 a6 00 00 00    	je     80104780 <procdump+0xe0>
    if((p->state == UNUSED) || (p->state == -UNUSED))
801046da:	8b 43 a0             	mov    -0x60(%ebx),%eax
801046dd:	85 c0                	test   %eax,%eax
801046df:	74 e7                	je     801046c8 <procdump+0x28>
      state = "???";
801046e1:	ba fe 7f 10 80       	mov    $0x80107ffe,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046e6:	83 f8 05             	cmp    $0x5,%eax
801046e9:	77 11                	ja     801046fc <procdump+0x5c>
801046eb:	8b 14 85 b0 81 10 80 	mov    -0x7fef7e50(,%eax,4),%edx
      state = "???";
801046f2:	b9 fe 7f 10 80       	mov    $0x80107ffe,%ecx
801046f7:	85 d2                	test   %edx,%edx
801046f9:	0f 44 d1             	cmove  %ecx,%edx
    cprintf("%d %s %s %d", p->pid, state, p->name, (p->state == SLEEPING ? ((struct proc*)(p->chan))->pid : 52684));
801046fc:	b9 cc cd 00 00       	mov    $0xcdcc,%ecx
80104701:	83 f8 02             	cmp    $0x2,%eax
80104704:	75 06                	jne    8010470c <procdump+0x6c>
80104706:	8b 43 b4             	mov    -0x4c(%ebx),%eax
80104709:	8b 48 10             	mov    0x10(%eax),%ecx
8010470c:	83 ec 0c             	sub    $0xc,%esp
8010470f:	51                   	push   %ecx
80104710:	53                   	push   %ebx
80104711:	52                   	push   %edx
80104712:	ff 73 a4             	pushl  -0x5c(%ebx)
80104715:	68 02 80 10 80       	push   $0x80108002
8010471a:	e8 91 bf ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
8010471f:	83 c4 20             	add    $0x20,%esp
80104722:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104726:	75 90                	jne    801046b8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104728:	83 ec 08             	sub    $0x8,%esp
8010472b:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010472e:	8d 75 c0             	lea    -0x40(%ebp),%esi
80104731:	50                   	push   %eax
80104732:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104735:	8d 7d e8             	lea    -0x18(%ebp),%edi
80104738:	8b 40 0c             	mov    0xc(%eax),%eax
8010473b:	83 c0 08             	add    $0x8,%eax
8010473e:	50                   	push   %eax
8010473f:	e8 ec 04 00 00       	call   80104c30 <getcallerpcs>
      for(signum=0; signum<10 && pc[signum] != 0; signum++)
80104744:	83 c4 10             	add    $0x10,%esp
80104747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010474e:	66 90                	xchg   %ax,%ax
80104750:	8b 16                	mov    (%esi),%edx
80104752:	85 d2                	test   %edx,%edx
80104754:	0f 84 5e ff ff ff    	je     801046b8 <procdump+0x18>
        cprintf(" %p", pc[signum]);
8010475a:	83 ec 08             	sub    $0x8,%esp
8010475d:	83 c6 04             	add    $0x4,%esi
80104760:	52                   	push   %edx
80104761:	68 21 7a 10 80       	push   $0x80107a21
80104766:	e8 45 bf ff ff       	call   801006b0 <cprintf>
      for(signum=0; signum<10 && pc[signum] != 0; signum++)
8010476b:	83 c4 10             	add    $0x10,%esp
8010476e:	39 f7                	cmp    %esi,%edi
80104770:	75 de                	jne    80104750 <procdump+0xb0>
80104772:	e9 41 ff ff ff       	jmp    801046b8 <procdump+0x18>
80104777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010477e:	66 90                	xchg   %ax,%ax
  }
}
80104780:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104783:	5b                   	pop    %ebx
80104784:	5e                   	pop    %esi
80104785:	5f                   	pop    %edi
80104786:	5d                   	pop    %ebp
80104787:	c3                   	ret    
80104788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010478f:	90                   	nop

80104790 <sigprocmask>:

uint sigprocmask(uint sigmask){
80104790:	f3 0f 1e fb          	endbr32 
80104794:	55                   	push   %ebp
80104795:	89 e5                	mov    %esp,%ebp
80104797:	56                   	push   %esi
80104798:	53                   	push   %ebx
  pushcli();
80104799:	e8 f2 04 00 00       	call   80104c90 <pushcli>
  c = mycpu();
8010479e:	e8 fd f0 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
801047a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047a9:	e8 32 05 00 00       	call   80104ce0 <popcli>
  uint temp = myproc()->blocked_signal_mask;
801047ae:	8b 9b 88 00 00 00    	mov    0x88(%ebx),%ebx
  pushcli();
801047b4:	e8 d7 04 00 00       	call   80104c90 <pushcli>
  c = mycpu();
801047b9:	e8 e2 f0 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
801047be:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801047c4:	e8 17 05 00 00       	call   80104ce0 <popcli>
  // Ignoring kill, stop, cont signals
  uint kill_mask = 1 << SIGKILL;
  uint cont_mask = 1 << SIGCONT;
  uint stop_mask = 1 << SIGSTOP;
  myproc()->blocked_signal_mask = sigmask & ~(kill_mask | stop_mask | cont_mask);
801047c9:	8b 45 08             	mov    0x8(%ebp),%eax
801047cc:	25 ff fd f5 ff       	and    $0xfff5fdff,%eax
801047d1:	89 86 88 00 00 00    	mov    %eax,0x88(%esi)
  return temp;
}
801047d7:	89 d8                	mov    %ebx,%eax
801047d9:	5b                   	pop    %ebx
801047da:	5e                   	pop    %esi
801047db:	5d                   	pop    %ebp
801047dc:	c3                   	ret    
801047dd:	8d 76 00             	lea    0x0(%esi),%esi

801047e0 <sigaction>:

int sigaction(int signum, const struct sigaction* act, struct sigaction* oldact){
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	57                   	push   %edi
801047e8:	56                   	push   %esi
801047e9:	53                   	push   %ebx
801047ea:	83 ec 0c             	sub    $0xc,%esp
801047ed:	8b 7d 08             	mov    0x8(%ebp),%edi
801047f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  // make sure SIGCONT also here
  if (signum == SIGKILL || signum == SIGSTOP || signum == SIGCONT){
801047f3:	89 f8                	mov    %edi,%eax
801047f5:	83 e0 fd             	and    $0xfffffffd,%eax
801047f8:	83 f8 11             	cmp    $0x11,%eax
801047fb:	74 53                	je     80104850 <sigaction+0x70>
801047fd:	83 ff 09             	cmp    $0x9,%edi
80104800:	74 4e                	je     80104850 <sigaction+0x70>
    return -1;
  }
  if (signum < 0 || signum > 31){
80104802:	83 ff 1f             	cmp    $0x1f,%edi
80104805:	77 49                	ja     80104850 <sigaction+0x70>
  pushcli();
80104807:	e8 84 04 00 00       	call   80104c90 <pushcli>
  c = mycpu();
8010480c:	e8 8f f0 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104811:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104817:	e8 c4 04 00 00       	call   80104ce0 <popcli>
    return -1;
  }
  // 16 bytes struct
  struct proc* p = myproc();
  if (oldact != null){
8010481c:	8d 4f 12             	lea    0x12(%edi),%ecx
8010481f:	85 db                	test   %ebx,%ebx
80104821:	74 0c                	je     8010482f <sigaction+0x4f>
    *oldact = p->signal_handlers[signum];
80104823:	8b 04 ce             	mov    (%esi,%ecx,8),%eax
80104826:	8b 54 ce 04          	mov    0x4(%esi,%ecx,8),%edx
8010482a:	89 03                	mov    %eax,(%ebx)
8010482c:	89 53 04             	mov    %edx,0x4(%ebx)
  }
  p->signal_handlers[signum] = *act;
8010482f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104832:	8b 50 04             	mov    0x4(%eax),%edx
80104835:	8b 00                	mov    (%eax),%eax
80104837:	89 54 ce 04          	mov    %edx,0x4(%esi,%ecx,8)
8010483b:	89 04 ce             	mov    %eax,(%esi,%ecx,8)
  return 0;
8010483e:	31 c0                	xor    %eax,%eax
}
80104840:	83 c4 0c             	add    $0xc,%esp
80104843:	5b                   	pop    %ebx
80104844:	5e                   	pop    %esi
80104845:	5f                   	pop    %edi
80104846:	5d                   	pop    %ebp
80104847:	c3                   	ret    
80104848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484f:	90                   	nop
    return -1;
80104850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104855:	eb e9                	jmp    80104840 <sigaction+0x60>
80104857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485e:	66 90                	xchg   %ax,%ax

80104860 <sigret>:

void sigret(){
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	57                   	push   %edi
80104868:	56                   	push   %esi
80104869:	53                   	push   %ebx
8010486a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010486d:	e8 1e 04 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80104872:	e8 29 f0 ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104877:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010487d:	e8 5e 04 00 00       	call   80104ce0 <popcli>
  struct proc* p = myproc();
  if (p!= null){
80104882:	85 db                	test   %ebx,%ebx
80104884:	74 26                	je     801048ac <sigret+0x4c>
    *(p->tf) = *(p->user_trapframe_backup);
80104886:	8b b3 90 01 00 00    	mov    0x190(%ebx),%esi
8010488c:	8b 7b 18             	mov    0x18(%ebx),%edi
8010488f:	b9 13 00 00 00       	mov    $0x13,%ecx
80104894:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    //memmove( p->tf, p->user_trapframe_backup, sizeof(*p->user_trapframe_backup));
    p->blocked_signal_mask = p->mask_backup;
    p->flag_in_user_handler = 0;
80104896:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010489d:	00 00 00 
    p->blocked_signal_mask = p->mask_backup;
801048a0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801048a6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
    // // cprintf("sigret debug\n");
  }
  return;
 }
801048ac:	83 c4 0c             	add    $0xc,%esp
801048af:	5b                   	pop    %ebx
801048b0:	5e                   	pop    %esi
801048b1:	5f                   	pop    %edi
801048b2:	5d                   	pop    %ebp
801048b3:	c3                   	ret    
801048b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048bf:	90                   	nop

801048c0 <sigkill>:

// Signals implementation
// Assumed that the signal is being clear from the pending signals by the caller
int
sigkill(){
801048c0:	f3 0f 1e fb          	endbr32 
801048c4:	55                   	push   %ebp
801048c5:	89 e5                	mov    %esp,%ebp
801048c7:	53                   	push   %ebx
801048c8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801048cb:	e8 c0 03 00 00       	call   80104c90 <pushcli>
  c = mycpu();
801048d0:	e8 cb ef ff ff       	call   801038a0 <mycpu>
  p = c->proc;
801048d5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048db:	e8 00 04 00 00       	call   80104ce0 <popcli>
  // // cprintf("process with pid %d killed handled\n", myproc()->pid);
  myproc()->killed = 1;
  // release(&ptable.lock);
  return 0;
}
801048e0:	31 c0                	xor    %eax,%eax
  myproc()->killed = 1;
801048e2:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
}
801048e9:	83 c4 04             	add    $0x4,%esp
801048ec:	5b                   	pop    %ebx
801048ed:	5d                   	pop    %ebp
801048ee:	c3                   	ret    
801048ef:	90                   	nop

801048f0 <sigcont>:

int 
sigcont(){
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	53                   	push   %ebx
801048f8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801048fb:	e8 90 03 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80104900:	e8 9b ef ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104905:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010490b:	e8 d0 03 00 00       	call   80104ce0 <popcli>
  myproc()->flag_frozen = 0;
  return 0;
}
80104910:	31 c0                	xor    %eax,%eax
  myproc()->flag_frozen = 0;
80104912:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
}
80104919:	83 c4 04             	add    $0x4,%esp
8010491c:	5b                   	pop    %ebx
8010491d:	5d                   	pop    %ebp
8010491e:	c3                   	ret    
8010491f:	90                   	nop

80104920 <sigstop>:

int 
sigstop(){
80104920:	f3 0f 1e fb          	endbr32 
80104924:	55                   	push   %ebp
80104925:	89 e5                	mov    %esp,%ebp
80104927:	53                   	push   %ebx
80104928:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010492b:	e8 60 03 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80104930:	e8 6b ef ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104935:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010493b:	e8 a0 03 00 00       	call   80104ce0 <popcli>
  myproc()->flag_frozen = 1;
  return 0;
}
80104940:	31 c0                	xor    %eax,%eax
  myproc()->flag_frozen = 1;
80104942:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
}
80104949:	83 c4 04             	add    $0x4,%esp
8010494c:	5b                   	pop    %ebx
8010494d:	5d                   	pop    %ebp
8010494e:	c3                   	ret    
8010494f:	90                   	nop

80104950 <handle_signals>:


void handle_signals(){
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	57                   	push   %edi
80104958:	56                   	push   %esi
80104959:	53                   	push   %ebx
8010495a:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
8010495d:	e8 2e 03 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80104962:	e8 39 ef ff ff       	call   801038a0 <mycpu>
  p = c->proc;
80104967:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010496d:	e8 6e 03 00 00       	call   80104ce0 <popcli>
  struct proc* p = myproc();
  if (p == null){
80104972:	85 db                	test   %ebx,%ebx
80104974:	74 7e                	je     801049f4 <handle_signals+0xa4>
    return;
  }
 
  uint mask = p->blocked_signal_mask;
  uint pending = p->pending_signals;
  uint signals_to_handle = (~mask) & pending;
80104976:	8b bb 88 00 00 00    	mov    0x88(%ebx),%edi
8010497c:	be 01 00 00 00       	mov    $0x1,%esi
80104981:	f7 d7                	not    %edi
80104983:	23 bb 84 00 00 00    	and    0x84(%ebx),%edi
  for (int signum = 0; signum < 32; signum++){
80104989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104990:	8d 4e ff             	lea    -0x1(%esi),%ecx
    if (((signals_to_handle >> signum) & 0x1) == 0){
80104993:	0f a3 cf             	bt     %ecx,%edi
80104996:	73 38                	jae    801049d0 <handle_signals+0x80>
        continue;
    }
    // turning off the bit in pending signals
    p->pending_signals &= ~(1 << signum);
80104998:	b8 01 00 00 00       	mov    $0x1,%eax
8010499d:	d3 e0                	shl    %cl,%eax
8010499f:	f7 d0                	not    %eax
801049a1:	21 83 84 00 00 00    	and    %eax,0x84(%ebx)

    // handle if kernel handler
    int sa_handler = (int)p->signal_handlers[signum].sa_handler;
801049a7:	8b 94 f3 88 00 00 00 	mov    0x88(%ebx,%esi,8),%edx
    switch (sa_handler){
801049ae:	83 fa 13             	cmp    $0x13,%edx
801049b1:	77 0d                	ja     801049c0 <handle_signals+0x70>
801049b3:	3e ff 24 95 60 81 10 	notrack jmp *-0x7fef7ea0(,%edx,4)
801049ba:	80 
801049bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049bf:	90                   	nop
        else{
          sigkill();
        }
        break;
      default:
        if (p->flag_in_user_handler == 0){ 
801049c0:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801049c6:	85 c0                	test   %eax,%eax
801049c8:	74 6d                	je     80104a37 <handle_signals+0xe7>
801049ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (int signum = 0; signum < 32; signum++){
801049d0:	83 fe 20             	cmp    $0x20,%esi
801049d3:	74 1f                	je     801049f4 <handle_signals+0xa4>
801049d5:	83 c6 01             	add    $0x1,%esi
801049d8:	eb b6                	jmp    80104990 <handle_signals+0x40>
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (signum == SIGSTOP){
801049e0:	83 f9 11             	cmp    $0x11,%ecx
801049e3:	74 4b                	je     80104a30 <handle_signals+0xe0>
        else if (signum == SIGCONT){
801049e5:	83 f9 13             	cmp    $0x13,%ecx
801049e8:	74 36                	je     80104a20 <handle_signals+0xd0>
          sigkill();
801049ea:	e8 d1 fe ff ff       	call   801048c0 <sigkill>
  for (int signum = 0; signum < 32; signum++){
801049ef:	83 fe 20             	cmp    $0x20,%esi
801049f2:	75 e1                	jne    801049d5 <handle_signals+0x85>
        }
    } 
    
  }
  return;
}
801049f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049f7:	5b                   	pop    %ebx
801049f8:	5e                   	pop    %esi
801049f9:	5f                   	pop    %edi
801049fa:	5d                   	pop    %ebp
801049fb:	c3                   	ret    
801049fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        sigcont();
80104a00:	e8 eb fe ff ff       	call   801048f0 <sigcont>
        break;
80104a05:	eb c9                	jmp    801049d0 <handle_signals+0x80>
80104a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0e:	66 90                	xchg   %ax,%ax
        sigstop();
80104a10:	e8 0b ff ff ff       	call   80104920 <sigstop>
        break;
80104a15:	eb b9                	jmp    801049d0 <handle_signals+0x80>
80104a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1e:	66 90                	xchg   %ax,%ax
          sigcont();
80104a20:	e8 cb fe ff ff       	call   801048f0 <sigcont>
80104a25:	eb ae                	jmp    801049d5 <handle_signals+0x85>
80104a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a2e:	66 90                	xchg   %ax,%ax
          sigstop();
80104a30:	e8 eb fe ff ff       	call   80104920 <sigstop>
80104a35:	eb 9e                	jmp    801049d5 <handle_signals+0x85>
80104a37:	89 c8                	mov    %ecx,%eax
          p->mask_backup = p->blocked_signal_mask;
80104a39:	8b 8b 88 00 00 00    	mov    0x88(%ebx),%ecx
          *(p->user_trapframe_backup) = *(p->tf);
80104a3f:	8b 73 18             	mov    0x18(%ebx),%esi
80104a42:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104a45:	8b bb 90 01 00 00    	mov    0x190(%ebx),%edi
          char call_sigret[7] = { 0xB8, 0x18, 0x00, 0x00, 0x00, 0xCD, 0x40 };
80104a4b:	ba 00 cd ff ff       	mov    $0xffffcd00,%edx
          memmove((void*)(p->tf->esp + 8), call_sigret, 7);
80104a50:	83 ec 04             	sub    $0x4,%esp
          p->flag_in_user_handler = 1;
80104a53:	c7 83 80 00 00 00 01 	movl   $0x1,0x80(%ebx)
80104a5a:	00 00 00 
          p->mask_backup = p->blocked_signal_mask;
80104a5d:	89 8b 8c 00 00 00    	mov    %ecx,0x8c(%ebx)
          p->blocked_signal_mask = p->signal_handlers[signum].sigmask;
80104a63:	8b 8c c3 94 00 00 00 	mov    0x94(%ebx,%eax,8),%ecx
80104a6a:	89 8b 88 00 00 00    	mov    %ecx,0x88(%ebx)
          *(p->user_trapframe_backup) = *(p->tf);
80104a70:	b9 13 00 00 00       	mov    $0x13,%ecx
80104a75:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
          char call_sigret[7] = { 0xB8, 0x18, 0x00, 0x00, 0x00, 0xCD, 0x40 };
80104a77:	66 89 55 e5          	mov    %dx,-0x1b(%ebp)
80104a7b:	c7 45 e1 b8 18 00 00 	movl   $0x18b8,-0x1f(%ebp)
          p->tf->esp -= 0xF;
80104a82:	8b 4b 18             	mov    0x18(%ebx),%ecx
          char call_sigret[7] = { 0xB8, 0x18, 0x00, 0x00, 0x00, 0xCD, 0x40 };
80104a85:	c6 45 e7 40          	movb   $0x40,-0x19(%ebp)
          p->tf->esp -= 0xF;
80104a89:	83 69 44 0f          	subl   $0xf,0x44(%ecx)
          *((int*)(p->tf->esp)) = p->tf->esp + 0x8;
80104a8d:	8b 4b 18             	mov    0x18(%ebx),%ecx
80104a90:	8b 49 44             	mov    0x44(%ecx),%ecx
80104a93:	8d 71 08             	lea    0x8(%ecx),%esi
80104a96:	89 31                	mov    %esi,(%ecx)
          *((int*)(p->tf->esp + 4)) = signum;
80104a98:	8b 4b 18             	mov    0x18(%ebx),%ecx
80104a9b:	8b 49 44             	mov    0x44(%ecx),%ecx
80104a9e:	89 41 04             	mov    %eax,0x4(%ecx)
          memmove((void*)(p->tf->esp + 8), call_sigret, 7);
80104aa1:	8d 45 e1             	lea    -0x1f(%ebp),%eax
80104aa4:	6a 07                	push   $0x7
80104aa6:	50                   	push   %eax
80104aa7:	8b 43 18             	mov    0x18(%ebx),%eax
80104aaa:	8b 40 44             	mov    0x44(%eax),%eax
80104aad:	83 c0 08             	add    $0x8,%eax
80104ab0:	50                   	push   %eax
80104ab1:	e8 8a 04 00 00       	call   80104f40 <memmove>
          p->tf->eip = sa_handler + 4;
80104ab6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104ab9:	8b 43 18             	mov    0x18(%ebx),%eax
80104abc:	83 c4 10             	add    $0x10,%esp
80104abf:	83 c2 04             	add    $0x4,%edx
80104ac2:	89 50 38             	mov    %edx,0x38(%eax)
}
80104ac5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ac8:	5b                   	pop    %ebx
80104ac9:	5e                   	pop    %esi
80104aca:	5f                   	pop    %edi
80104acb:	5d                   	pop    %ebp
80104acc:	c3                   	ret    
80104acd:	66 90                	xchg   %ax,%ax
80104acf:	90                   	nop

80104ad0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ad0:	f3 0f 1e fb          	endbr32 
80104ad4:	55                   	push   %ebp
80104ad5:	89 e5                	mov    %esp,%ebp
80104ad7:	53                   	push   %ebx
80104ad8:	83 ec 0c             	sub    $0xc,%esp
80104adb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104ade:	68 c8 81 10 80       	push   $0x801081c8
80104ae3:	8d 43 04             	lea    0x4(%ebx),%eax
80104ae6:	50                   	push   %eax
80104ae7:	e8 24 01 00 00       	call   80104c10 <initlock>
  lk->name = name;
80104aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104aef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104af5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104af8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104aff:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104b02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b05:	c9                   	leave  
80104b06:	c3                   	ret    
80104b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0e:	66 90                	xchg   %ax,%ax

80104b10 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104b10:	f3 0f 1e fb          	endbr32 
80104b14:	55                   	push   %ebp
80104b15:	89 e5                	mov    %esp,%ebp
80104b17:	56                   	push   %esi
80104b18:	53                   	push   %ebx
80104b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b1c:	8d 73 04             	lea    0x4(%ebx),%esi
80104b1f:	83 ec 0c             	sub    $0xc,%esp
80104b22:	56                   	push   %esi
80104b23:	e8 68 02 00 00       	call   80104d90 <acquire>
  while (lk->locked) {
80104b28:	8b 13                	mov    (%ebx),%edx
80104b2a:	83 c4 10             	add    $0x10,%esp
80104b2d:	85 d2                	test   %edx,%edx
80104b2f:	74 1a                	je     80104b4b <acquiresleep+0x3b>
80104b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104b38:	83 ec 08             	sub    $0x8,%esp
80104b3b:	56                   	push   %esi
80104b3c:	53                   	push   %ebx
80104b3d:	e8 3e f9 ff ff       	call   80104480 <sleep>
  while (lk->locked) {
80104b42:	8b 03                	mov    (%ebx),%eax
80104b44:	83 c4 10             	add    $0x10,%esp
80104b47:	85 c0                	test   %eax,%eax
80104b49:	75 ed                	jne    80104b38 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104b4b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104b51:	e8 da ed ff ff       	call   80103930 <myproc>
80104b56:	8b 40 10             	mov    0x10(%eax),%eax
80104b59:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104b5c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104b5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b62:	5b                   	pop    %ebx
80104b63:	5e                   	pop    %esi
80104b64:	5d                   	pop    %ebp
  release(&lk->lk);
80104b65:	e9 e6 02 00 00       	jmp    80104e50 <release>
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b70 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104b70:	f3 0f 1e fb          	endbr32 
80104b74:	55                   	push   %ebp
80104b75:	89 e5                	mov    %esp,%ebp
80104b77:	56                   	push   %esi
80104b78:	53                   	push   %ebx
80104b79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b7c:	8d 73 04             	lea    0x4(%ebx),%esi
80104b7f:	83 ec 0c             	sub    $0xc,%esp
80104b82:	56                   	push   %esi
80104b83:	e8 08 02 00 00       	call   80104d90 <acquire>
  lk->locked = 0;
80104b88:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b8e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104b95:	89 1c 24             	mov    %ebx,(%esp)
80104b98:	e8 c3 f9 ff ff       	call   80104560 <wakeup>
  release(&lk->lk);
80104b9d:	89 75 08             	mov    %esi,0x8(%ebp)
80104ba0:	83 c4 10             	add    $0x10,%esp
}
80104ba3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ba6:	5b                   	pop    %ebx
80104ba7:	5e                   	pop    %esi
80104ba8:	5d                   	pop    %ebp
  release(&lk->lk);
80104ba9:	e9 a2 02 00 00       	jmp    80104e50 <release>
80104bae:	66 90                	xchg   %ax,%ax

80104bb0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104bb0:	f3 0f 1e fb          	endbr32 
80104bb4:	55                   	push   %ebp
80104bb5:	89 e5                	mov    %esp,%ebp
80104bb7:	57                   	push   %edi
80104bb8:	31 ff                	xor    %edi,%edi
80104bba:	56                   	push   %esi
80104bbb:	53                   	push   %ebx
80104bbc:	83 ec 18             	sub    $0x18,%esp
80104bbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104bc2:	8d 73 04             	lea    0x4(%ebx),%esi
80104bc5:	56                   	push   %esi
80104bc6:	e8 c5 01 00 00       	call   80104d90 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104bcb:	8b 03                	mov    (%ebx),%eax
80104bcd:	83 c4 10             	add    $0x10,%esp
80104bd0:	85 c0                	test   %eax,%eax
80104bd2:	75 1c                	jne    80104bf0 <holdingsleep+0x40>
  release(&lk->lk);
80104bd4:	83 ec 0c             	sub    $0xc,%esp
80104bd7:	56                   	push   %esi
80104bd8:	e8 73 02 00 00       	call   80104e50 <release>
  return r;
}
80104bdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104be0:	89 f8                	mov    %edi,%eax
80104be2:	5b                   	pop    %ebx
80104be3:	5e                   	pop    %esi
80104be4:	5f                   	pop    %edi
80104be5:	5d                   	pop    %ebp
80104be6:	c3                   	ret    
80104be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bee:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104bf0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104bf3:	e8 38 ed ff ff       	call   80103930 <myproc>
80104bf8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104bfb:	0f 94 c0             	sete   %al
80104bfe:	0f b6 c0             	movzbl %al,%eax
80104c01:	89 c7                	mov    %eax,%edi
80104c03:	eb cf                	jmp    80104bd4 <holdingsleep+0x24>
80104c05:	66 90                	xchg   %ax,%ax
80104c07:	66 90                	xchg   %ax,%ax
80104c09:	66 90                	xchg   %ax,%ax
80104c0b:	66 90                	xchg   %ax,%ax
80104c0d:	66 90                	xchg   %ax,%ax
80104c0f:	90                   	nop

80104c10 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c10:	f3 0f 1e fb          	endbr32 
80104c14:	55                   	push   %ebp
80104c15:	89 e5                	mov    %esp,%ebp
80104c17:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104c1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104c1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104c23:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104c26:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c2d:	5d                   	pop    %ebp
80104c2e:	c3                   	ret    
80104c2f:	90                   	nop

80104c30 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c30:	f3 0f 1e fb          	endbr32 
80104c34:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c35:	31 d2                	xor    %edx,%edx
{
80104c37:	89 e5                	mov    %esp,%ebp
80104c39:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104c3a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c40:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104c43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c47:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c48:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104c4e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c54:	77 1a                	ja     80104c70 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104c56:	8b 58 04             	mov    0x4(%eax),%ebx
80104c59:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104c5c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104c5f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c61:	83 fa 0a             	cmp    $0xa,%edx
80104c64:	75 e2                	jne    80104c48 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104c66:	5b                   	pop    %ebx
80104c67:	5d                   	pop    %ebp
80104c68:	c3                   	ret    
80104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104c70:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104c73:	8d 51 28             	lea    0x28(%ecx),%edx
80104c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104c80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c86:	83 c0 04             	add    $0x4,%eax
80104c89:	39 d0                	cmp    %edx,%eax
80104c8b:	75 f3                	jne    80104c80 <getcallerpcs+0x50>
}
80104c8d:	5b                   	pop    %ebx
80104c8e:	5d                   	pop    %ebp
80104c8f:	c3                   	ret    

80104c90 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c90:	f3 0f 1e fb          	endbr32 
80104c94:	55                   	push   %ebp
80104c95:	89 e5                	mov    %esp,%ebp
80104c97:	53                   	push   %ebx
80104c98:	83 ec 04             	sub    $0x4,%esp
80104c9b:	9c                   	pushf  
80104c9c:	5b                   	pop    %ebx
  asm volatile("cli");
80104c9d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104c9e:	e8 fd eb ff ff       	call   801038a0 <mycpu>
80104ca3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ca9:	85 c0                	test   %eax,%eax
80104cab:	74 13                	je     80104cc0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104cad:	e8 ee eb ff ff       	call   801038a0 <mycpu>
80104cb2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104cb9:	83 c4 04             	add    $0x4,%esp
80104cbc:	5b                   	pop    %ebx
80104cbd:	5d                   	pop    %ebp
80104cbe:	c3                   	ret    
80104cbf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104cc0:	e8 db eb ff ff       	call   801038a0 <mycpu>
80104cc5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104ccb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104cd1:	eb da                	jmp    80104cad <pushcli+0x1d>
80104cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ce0 <popcli>:

void
popcli(void)
{
80104ce0:	f3 0f 1e fb          	endbr32 
80104ce4:	55                   	push   %ebp
80104ce5:	89 e5                	mov    %esp,%ebp
80104ce7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104cea:	9c                   	pushf  
80104ceb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104cec:	f6 c4 02             	test   $0x2,%ah
80104cef:	75 31                	jne    80104d22 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104cf1:	e8 aa eb ff ff       	call   801038a0 <mycpu>
80104cf6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104cfd:	78 30                	js     80104d2f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104cff:	e8 9c eb ff ff       	call   801038a0 <mycpu>
80104d04:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d0a:	85 d2                	test   %edx,%edx
80104d0c:	74 02                	je     80104d10 <popcli+0x30>
    sti();
}
80104d0e:	c9                   	leave  
80104d0f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d10:	e8 8b eb ff ff       	call   801038a0 <mycpu>
80104d15:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d1b:	85 c0                	test   %eax,%eax
80104d1d:	74 ef                	je     80104d0e <popcli+0x2e>
  asm volatile("sti");
80104d1f:	fb                   	sti    
}
80104d20:	c9                   	leave  
80104d21:	c3                   	ret    
    panic("popcli - interruptible");
80104d22:	83 ec 0c             	sub    $0xc,%esp
80104d25:	68 d3 81 10 80       	push   $0x801081d3
80104d2a:	e8 61 b6 ff ff       	call   80100390 <panic>
    panic("popcli");
80104d2f:	83 ec 0c             	sub    $0xc,%esp
80104d32:	68 ea 81 10 80       	push   $0x801081ea
80104d37:	e8 54 b6 ff ff       	call   80100390 <panic>
80104d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d40 <holding>:
{
80104d40:	f3 0f 1e fb          	endbr32 
80104d44:	55                   	push   %ebp
80104d45:	89 e5                	mov    %esp,%ebp
80104d47:	56                   	push   %esi
80104d48:	53                   	push   %ebx
80104d49:	8b 75 08             	mov    0x8(%ebp),%esi
80104d4c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104d4e:	e8 3d ff ff ff       	call   80104c90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d53:	8b 06                	mov    (%esi),%eax
80104d55:	85 c0                	test   %eax,%eax
80104d57:	75 0f                	jne    80104d68 <holding+0x28>
  popcli();
80104d59:	e8 82 ff ff ff       	call   80104ce0 <popcli>
}
80104d5e:	89 d8                	mov    %ebx,%eax
80104d60:	5b                   	pop    %ebx
80104d61:	5e                   	pop    %esi
80104d62:	5d                   	pop    %ebp
80104d63:	c3                   	ret    
80104d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104d68:	8b 5e 08             	mov    0x8(%esi),%ebx
80104d6b:	e8 30 eb ff ff       	call   801038a0 <mycpu>
80104d70:	39 c3                	cmp    %eax,%ebx
80104d72:	0f 94 c3             	sete   %bl
  popcli();
80104d75:	e8 66 ff ff ff       	call   80104ce0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104d7a:	0f b6 db             	movzbl %bl,%ebx
}
80104d7d:	89 d8                	mov    %ebx,%eax
80104d7f:	5b                   	pop    %ebx
80104d80:	5e                   	pop    %esi
80104d81:	5d                   	pop    %ebp
80104d82:	c3                   	ret    
80104d83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d90 <acquire>:
{
80104d90:	f3 0f 1e fb          	endbr32 
80104d94:	55                   	push   %ebp
80104d95:	89 e5                	mov    %esp,%ebp
80104d97:	56                   	push   %esi
80104d98:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104d99:	e8 f2 fe ff ff       	call   80104c90 <pushcli>
  if(holding(lk))
80104d9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104da1:	83 ec 0c             	sub    $0xc,%esp
80104da4:	53                   	push   %ebx
80104da5:	e8 96 ff ff ff       	call   80104d40 <holding>
80104daa:	83 c4 10             	add    $0x10,%esp
80104dad:	85 c0                	test   %eax,%eax
80104daf:	0f 85 7f 00 00 00    	jne    80104e34 <acquire+0xa4>
80104db5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104db7:	ba 01 00 00 00       	mov    $0x1,%edx
80104dbc:	eb 05                	jmp    80104dc3 <acquire+0x33>
80104dbe:	66 90                	xchg   %ax,%ax
80104dc0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104dc3:	89 d0                	mov    %edx,%eax
80104dc5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104dc8:	85 c0                	test   %eax,%eax
80104dca:	75 f4                	jne    80104dc0 <acquire+0x30>
  __sync_synchronize();
80104dcc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104dd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104dd4:	e8 c7 ea ff ff       	call   801038a0 <mycpu>
80104dd9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104ddc:	89 e8                	mov    %ebp,%eax
80104dde:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104de0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104de6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104dec:	77 22                	ja     80104e10 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104dee:	8b 50 04             	mov    0x4(%eax),%edx
80104df1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104df5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104df8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104dfa:	83 fe 0a             	cmp    $0xa,%esi
80104dfd:	75 e1                	jne    80104de0 <acquire+0x50>
}
80104dff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e02:	5b                   	pop    %ebx
80104e03:	5e                   	pop    %esi
80104e04:	5d                   	pop    %ebp
80104e05:	c3                   	ret    
80104e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104e10:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104e14:	83 c3 34             	add    $0x34,%ebx
80104e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104e20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e26:	83 c0 04             	add    $0x4,%eax
80104e29:	39 d8                	cmp    %ebx,%eax
80104e2b:	75 f3                	jne    80104e20 <acquire+0x90>
}
80104e2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e30:	5b                   	pop    %ebx
80104e31:	5e                   	pop    %esi
80104e32:	5d                   	pop    %ebp
80104e33:	c3                   	ret    
    panic("acquire");
80104e34:	83 ec 0c             	sub    $0xc,%esp
80104e37:	68 f1 81 10 80       	push   $0x801081f1
80104e3c:	e8 4f b5 ff ff       	call   80100390 <panic>
80104e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4f:	90                   	nop

80104e50 <release>:
{
80104e50:	f3 0f 1e fb          	endbr32 
80104e54:	55                   	push   %ebp
80104e55:	89 e5                	mov    %esp,%ebp
80104e57:	53                   	push   %ebx
80104e58:	83 ec 10             	sub    $0x10,%esp
80104e5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104e5e:	53                   	push   %ebx
80104e5f:	e8 dc fe ff ff       	call   80104d40 <holding>
80104e64:	83 c4 10             	add    $0x10,%esp
80104e67:	85 c0                	test   %eax,%eax
80104e69:	74 22                	je     80104e8d <release+0x3d>
  lk->pcs[0] = 0;
80104e6b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104e72:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104e79:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104e7e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104e84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e87:	c9                   	leave  
  popcli();
80104e88:	e9 53 fe ff ff       	jmp    80104ce0 <popcli>
    panic("release");
80104e8d:	83 ec 0c             	sub    $0xc,%esp
80104e90:	68 f9 81 10 80       	push   $0x801081f9
80104e95:	e8 f6 b4 ff ff       	call   80100390 <panic>
80104e9a:	66 90                	xchg   %ax,%ax
80104e9c:	66 90                	xchg   %ax,%ax
80104e9e:	66 90                	xchg   %ax,%ax

80104ea0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104ea0:	f3 0f 1e fb          	endbr32 
80104ea4:	55                   	push   %ebp
80104ea5:	89 e5                	mov    %esp,%ebp
80104ea7:	57                   	push   %edi
80104ea8:	8b 55 08             	mov    0x8(%ebp),%edx
80104eab:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104eae:	53                   	push   %ebx
80104eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104eb2:	89 d7                	mov    %edx,%edi
80104eb4:	09 cf                	or     %ecx,%edi
80104eb6:	83 e7 03             	and    $0x3,%edi
80104eb9:	75 25                	jne    80104ee0 <memset+0x40>
    c &= 0xFF;
80104ebb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104ebe:	c1 e0 18             	shl    $0x18,%eax
80104ec1:	89 fb                	mov    %edi,%ebx
80104ec3:	c1 e9 02             	shr    $0x2,%ecx
80104ec6:	c1 e3 10             	shl    $0x10,%ebx
80104ec9:	09 d8                	or     %ebx,%eax
80104ecb:	09 f8                	or     %edi,%eax
80104ecd:	c1 e7 08             	shl    $0x8,%edi
80104ed0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104ed2:	89 d7                	mov    %edx,%edi
80104ed4:	fc                   	cld    
80104ed5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104ed7:	5b                   	pop    %ebx
80104ed8:	89 d0                	mov    %edx,%eax
80104eda:	5f                   	pop    %edi
80104edb:	5d                   	pop    %ebp
80104edc:	c3                   	ret    
80104edd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104ee0:	89 d7                	mov    %edx,%edi
80104ee2:	fc                   	cld    
80104ee3:	f3 aa                	rep stos %al,%es:(%edi)
80104ee5:	5b                   	pop    %ebx
80104ee6:	89 d0                	mov    %edx,%eax
80104ee8:	5f                   	pop    %edi
80104ee9:	5d                   	pop    %ebp
80104eea:	c3                   	ret    
80104eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eef:	90                   	nop

80104ef0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ef0:	f3 0f 1e fb          	endbr32 
80104ef4:	55                   	push   %ebp
80104ef5:	89 e5                	mov    %esp,%ebp
80104ef7:	56                   	push   %esi
80104ef8:	8b 75 10             	mov    0x10(%ebp),%esi
80104efb:	8b 55 08             	mov    0x8(%ebp),%edx
80104efe:	53                   	push   %ebx
80104eff:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f02:	85 f6                	test   %esi,%esi
80104f04:	74 2a                	je     80104f30 <memcmp+0x40>
80104f06:	01 c6                	add    %eax,%esi
80104f08:	eb 10                	jmp    80104f1a <memcmp+0x2a>
80104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104f10:	83 c0 01             	add    $0x1,%eax
80104f13:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104f16:	39 f0                	cmp    %esi,%eax
80104f18:	74 16                	je     80104f30 <memcmp+0x40>
    if(*s1 != *s2)
80104f1a:	0f b6 0a             	movzbl (%edx),%ecx
80104f1d:	0f b6 18             	movzbl (%eax),%ebx
80104f20:	38 d9                	cmp    %bl,%cl
80104f22:	74 ec                	je     80104f10 <memcmp+0x20>
      return *s1 - *s2;
80104f24:	0f b6 c1             	movzbl %cl,%eax
80104f27:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104f29:	5b                   	pop    %ebx
80104f2a:	5e                   	pop    %esi
80104f2b:	5d                   	pop    %ebp
80104f2c:	c3                   	ret    
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
80104f30:	5b                   	pop    %ebx
  return 0;
80104f31:	31 c0                	xor    %eax,%eax
}
80104f33:	5e                   	pop    %esi
80104f34:	5d                   	pop    %ebp
80104f35:	c3                   	ret    
80104f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi

80104f40 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f40:	f3 0f 1e fb          	endbr32 
80104f44:	55                   	push   %ebp
80104f45:	89 e5                	mov    %esp,%ebp
80104f47:	57                   	push   %edi
80104f48:	8b 55 08             	mov    0x8(%ebp),%edx
80104f4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f4e:	56                   	push   %esi
80104f4f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104f52:	39 d6                	cmp    %edx,%esi
80104f54:	73 2a                	jae    80104f80 <memmove+0x40>
80104f56:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104f59:	39 fa                	cmp    %edi,%edx
80104f5b:	73 23                	jae    80104f80 <memmove+0x40>
80104f5d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104f60:	85 c9                	test   %ecx,%ecx
80104f62:	74 13                	je     80104f77 <memmove+0x37>
80104f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104f68:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104f6c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104f6f:	83 e8 01             	sub    $0x1,%eax
80104f72:	83 f8 ff             	cmp    $0xffffffff,%eax
80104f75:	75 f1                	jne    80104f68 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104f77:	5e                   	pop    %esi
80104f78:	89 d0                	mov    %edx,%eax
80104f7a:	5f                   	pop    %edi
80104f7b:	5d                   	pop    %ebp
80104f7c:	c3                   	ret    
80104f7d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104f80:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104f83:	89 d7                	mov    %edx,%edi
80104f85:	85 c9                	test   %ecx,%ecx
80104f87:	74 ee                	je     80104f77 <memmove+0x37>
80104f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104f90:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104f91:	39 f0                	cmp    %esi,%eax
80104f93:	75 fb                	jne    80104f90 <memmove+0x50>
}
80104f95:	5e                   	pop    %esi
80104f96:	89 d0                	mov    %edx,%eax
80104f98:	5f                   	pop    %edi
80104f99:	5d                   	pop    %ebp
80104f9a:	c3                   	ret    
80104f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f9f:	90                   	nop

80104fa0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104fa0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104fa4:	eb 9a                	jmp    80104f40 <memmove>
80104fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fad:	8d 76 00             	lea    0x0(%esi),%esi

80104fb0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104fb0:	f3 0f 1e fb          	endbr32 
80104fb4:	55                   	push   %ebp
80104fb5:	89 e5                	mov    %esp,%ebp
80104fb7:	56                   	push   %esi
80104fb8:	8b 75 10             	mov    0x10(%ebp),%esi
80104fbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104fbe:	53                   	push   %ebx
80104fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104fc2:	85 f6                	test   %esi,%esi
80104fc4:	74 32                	je     80104ff8 <strncmp+0x48>
80104fc6:	01 c6                	add    %eax,%esi
80104fc8:	eb 14                	jmp    80104fde <strncmp+0x2e>
80104fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fd0:	38 da                	cmp    %bl,%dl
80104fd2:	75 14                	jne    80104fe8 <strncmp+0x38>
    n--, p++, q++;
80104fd4:	83 c0 01             	add    $0x1,%eax
80104fd7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104fda:	39 f0                	cmp    %esi,%eax
80104fdc:	74 1a                	je     80104ff8 <strncmp+0x48>
80104fde:	0f b6 11             	movzbl (%ecx),%edx
80104fe1:	0f b6 18             	movzbl (%eax),%ebx
80104fe4:	84 d2                	test   %dl,%dl
80104fe6:	75 e8                	jne    80104fd0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104fe8:	0f b6 c2             	movzbl %dl,%eax
80104feb:	29 d8                	sub    %ebx,%eax
}
80104fed:	5b                   	pop    %ebx
80104fee:	5e                   	pop    %esi
80104fef:	5d                   	pop    %ebp
80104ff0:	c3                   	ret    
80104ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ff8:	5b                   	pop    %ebx
    return 0;
80104ff9:	31 c0                	xor    %eax,%eax
}
80104ffb:	5e                   	pop    %esi
80104ffc:	5d                   	pop    %ebp
80104ffd:	c3                   	ret    
80104ffe:	66 90                	xchg   %ax,%ax

80105000 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105000:	f3 0f 1e fb          	endbr32 
80105004:	55                   	push   %ebp
80105005:	89 e5                	mov    %esp,%ebp
80105007:	57                   	push   %edi
80105008:	56                   	push   %esi
80105009:	8b 75 08             	mov    0x8(%ebp),%esi
8010500c:	53                   	push   %ebx
8010500d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105010:	89 f2                	mov    %esi,%edx
80105012:	eb 1b                	jmp    8010502f <strncpy+0x2f>
80105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105018:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010501c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010501f:	83 c2 01             	add    $0x1,%edx
80105022:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105026:	89 f9                	mov    %edi,%ecx
80105028:	88 4a ff             	mov    %cl,-0x1(%edx)
8010502b:	84 c9                	test   %cl,%cl
8010502d:	74 09                	je     80105038 <strncpy+0x38>
8010502f:	89 c3                	mov    %eax,%ebx
80105031:	83 e8 01             	sub    $0x1,%eax
80105034:	85 db                	test   %ebx,%ebx
80105036:	7f e0                	jg     80105018 <strncpy+0x18>
    ;
  while(n-- > 0)
80105038:	89 d1                	mov    %edx,%ecx
8010503a:	85 c0                	test   %eax,%eax
8010503c:	7e 15                	jle    80105053 <strncpy+0x53>
8010503e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105040:	83 c1 01             	add    $0x1,%ecx
80105043:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105047:	89 c8                	mov    %ecx,%eax
80105049:	f7 d0                	not    %eax
8010504b:	01 d0                	add    %edx,%eax
8010504d:	01 d8                	add    %ebx,%eax
8010504f:	85 c0                	test   %eax,%eax
80105051:	7f ed                	jg     80105040 <strncpy+0x40>
  return os;
}
80105053:	5b                   	pop    %ebx
80105054:	89 f0                	mov    %esi,%eax
80105056:	5e                   	pop    %esi
80105057:	5f                   	pop    %edi
80105058:	5d                   	pop    %ebp
80105059:	c3                   	ret    
8010505a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105060 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105060:	f3 0f 1e fb          	endbr32 
80105064:	55                   	push   %ebp
80105065:	89 e5                	mov    %esp,%ebp
80105067:	56                   	push   %esi
80105068:	8b 55 10             	mov    0x10(%ebp),%edx
8010506b:	8b 75 08             	mov    0x8(%ebp),%esi
8010506e:	53                   	push   %ebx
8010506f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105072:	85 d2                	test   %edx,%edx
80105074:	7e 21                	jle    80105097 <safestrcpy+0x37>
80105076:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010507a:	89 f2                	mov    %esi,%edx
8010507c:	eb 12                	jmp    80105090 <safestrcpy+0x30>
8010507e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105080:	0f b6 08             	movzbl (%eax),%ecx
80105083:	83 c0 01             	add    $0x1,%eax
80105086:	83 c2 01             	add    $0x1,%edx
80105089:	88 4a ff             	mov    %cl,-0x1(%edx)
8010508c:	84 c9                	test   %cl,%cl
8010508e:	74 04                	je     80105094 <safestrcpy+0x34>
80105090:	39 d8                	cmp    %ebx,%eax
80105092:	75 ec                	jne    80105080 <safestrcpy+0x20>
    ;
  *s = 0;
80105094:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105097:	89 f0                	mov    %esi,%eax
80105099:	5b                   	pop    %ebx
8010509a:	5e                   	pop    %esi
8010509b:	5d                   	pop    %ebp
8010509c:	c3                   	ret    
8010509d:	8d 76 00             	lea    0x0(%esi),%esi

801050a0 <strlen>:

int
strlen(const char *s)
{
801050a0:	f3 0f 1e fb          	endbr32 
801050a4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801050a5:	31 c0                	xor    %eax,%eax
{
801050a7:	89 e5                	mov    %esp,%ebp
801050a9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801050ac:	80 3a 00             	cmpb   $0x0,(%edx)
801050af:	74 10                	je     801050c1 <strlen+0x21>
801050b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050b8:	83 c0 01             	add    $0x1,%eax
801050bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801050bf:	75 f7                	jne    801050b8 <strlen+0x18>
    ;
  return n;
}
801050c1:	5d                   	pop    %ebp
801050c2:	c3                   	ret    

801050c3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801050c3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801050c7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801050cb:	55                   	push   %ebp
  pushl %ebx
801050cc:	53                   	push   %ebx
  pushl %esi
801050cd:	56                   	push   %esi
  pushl %edi
801050ce:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801050cf:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801050d1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801050d3:	5f                   	pop    %edi
  popl %esi
801050d4:	5e                   	pop    %esi
  popl %ebx
801050d5:	5b                   	pop    %ebx
  popl %ebp
801050d6:	5d                   	pop    %ebp
  ret
801050d7:	c3                   	ret    
801050d8:	66 90                	xchg   %ax,%ax
801050da:	66 90                	xchg   %ax,%ax
801050dc:	66 90                	xchg   %ax,%ax
801050de:	66 90                	xchg   %ax,%ax

801050e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801050e0:	f3 0f 1e fb          	endbr32 
801050e4:	55                   	push   %ebp
801050e5:	89 e5                	mov    %esp,%ebp
801050e7:	53                   	push   %ebx
801050e8:	83 ec 04             	sub    $0x4,%esp
801050eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801050ee:	e8 3d e8 ff ff       	call   80103930 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050f3:	8b 00                	mov    (%eax),%eax
801050f5:	39 d8                	cmp    %ebx,%eax
801050f7:	76 17                	jbe    80105110 <fetchint+0x30>
801050f9:	8d 53 04             	lea    0x4(%ebx),%edx
801050fc:	39 d0                	cmp    %edx,%eax
801050fe:	72 10                	jb     80105110 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105100:	8b 45 0c             	mov    0xc(%ebp),%eax
80105103:	8b 13                	mov    (%ebx),%edx
80105105:	89 10                	mov    %edx,(%eax)
  return 0;
80105107:	31 c0                	xor    %eax,%eax
}
80105109:	83 c4 04             	add    $0x4,%esp
8010510c:	5b                   	pop    %ebx
8010510d:	5d                   	pop    %ebp
8010510e:	c3                   	ret    
8010510f:	90                   	nop
    return -1;
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105115:	eb f2                	jmp    80105109 <fetchint+0x29>
80105117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511e:	66 90                	xchg   %ax,%ax

80105120 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105120:	f3 0f 1e fb          	endbr32 
80105124:	55                   	push   %ebp
80105125:	89 e5                	mov    %esp,%ebp
80105127:	53                   	push   %ebx
80105128:	83 ec 04             	sub    $0x4,%esp
8010512b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010512e:	e8 fd e7 ff ff       	call   80103930 <myproc>

  if(addr >= curproc->sz)
80105133:	39 18                	cmp    %ebx,(%eax)
80105135:	76 31                	jbe    80105168 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105137:	8b 55 0c             	mov    0xc(%ebp),%edx
8010513a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010513c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010513e:	39 d3                	cmp    %edx,%ebx
80105140:	73 26                	jae    80105168 <fetchstr+0x48>
80105142:	89 d8                	mov    %ebx,%eax
80105144:	eb 11                	jmp    80105157 <fetchstr+0x37>
80105146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514d:	8d 76 00             	lea    0x0(%esi),%esi
80105150:	83 c0 01             	add    $0x1,%eax
80105153:	39 c2                	cmp    %eax,%edx
80105155:	76 11                	jbe    80105168 <fetchstr+0x48>
    if(*s == 0)
80105157:	80 38 00             	cmpb   $0x0,(%eax)
8010515a:	75 f4                	jne    80105150 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010515c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010515f:	29 d8                	sub    %ebx,%eax
}
80105161:	5b                   	pop    %ebx
80105162:	5d                   	pop    %ebp
80105163:	c3                   	ret    
80105164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105168:	83 c4 04             	add    $0x4,%esp
    return -1;
8010516b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105170:	5b                   	pop    %ebx
80105171:	5d                   	pop    %ebp
80105172:	c3                   	ret    
80105173:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010517a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105180 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105180:	f3 0f 1e fb          	endbr32 
80105184:	55                   	push   %ebp
80105185:	89 e5                	mov    %esp,%ebp
80105187:	56                   	push   %esi
80105188:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105189:	e8 a2 e7 ff ff       	call   80103930 <myproc>
8010518e:	8b 55 08             	mov    0x8(%ebp),%edx
80105191:	8b 40 18             	mov    0x18(%eax),%eax
80105194:	8b 40 44             	mov    0x44(%eax),%eax
80105197:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010519a:	e8 91 e7 ff ff       	call   80103930 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010519f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051a2:	8b 00                	mov    (%eax),%eax
801051a4:	39 c6                	cmp    %eax,%esi
801051a6:	73 18                	jae    801051c0 <argint+0x40>
801051a8:	8d 53 08             	lea    0x8(%ebx),%edx
801051ab:	39 d0                	cmp    %edx,%eax
801051ad:	72 11                	jb     801051c0 <argint+0x40>
  *ip = *(int*)(addr);
801051af:	8b 45 0c             	mov    0xc(%ebp),%eax
801051b2:	8b 53 04             	mov    0x4(%ebx),%edx
801051b5:	89 10                	mov    %edx,(%eax)
  return 0;
801051b7:	31 c0                	xor    %eax,%eax
}
801051b9:	5b                   	pop    %ebx
801051ba:	5e                   	pop    %esi
801051bb:	5d                   	pop    %ebp
801051bc:	c3                   	ret    
801051bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051c5:	eb f2                	jmp    801051b9 <argint+0x39>
801051c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ce:	66 90                	xchg   %ax,%ax

801051d0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801051d0:	f3 0f 1e fb          	endbr32 
801051d4:	55                   	push   %ebp
801051d5:	89 e5                	mov    %esp,%ebp
801051d7:	56                   	push   %esi
801051d8:	53                   	push   %ebx
801051d9:	83 ec 10             	sub    $0x10,%esp
801051dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801051df:	e8 4c e7 ff ff       	call   80103930 <myproc>
 
  if(argint(n, &i) < 0)
801051e4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801051e7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801051e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051ec:	50                   	push   %eax
801051ed:	ff 75 08             	pushl  0x8(%ebp)
801051f0:	e8 8b ff ff ff       	call   80105180 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801051f5:	83 c4 10             	add    $0x10,%esp
801051f8:	85 c0                	test   %eax,%eax
801051fa:	78 24                	js     80105220 <argptr+0x50>
801051fc:	85 db                	test   %ebx,%ebx
801051fe:	78 20                	js     80105220 <argptr+0x50>
80105200:	8b 16                	mov    (%esi),%edx
80105202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105205:	39 c2                	cmp    %eax,%edx
80105207:	76 17                	jbe    80105220 <argptr+0x50>
80105209:	01 c3                	add    %eax,%ebx
8010520b:	39 da                	cmp    %ebx,%edx
8010520d:	72 11                	jb     80105220 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010520f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105212:	89 02                	mov    %eax,(%edx)
  return 0;
80105214:	31 c0                	xor    %eax,%eax
}
80105216:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105219:	5b                   	pop    %ebx
8010521a:	5e                   	pop    %esi
8010521b:	5d                   	pop    %ebp
8010521c:	c3                   	ret    
8010521d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105225:	eb ef                	jmp    80105216 <argptr+0x46>
80105227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010522e:	66 90                	xchg   %ax,%ax

80105230 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105230:	f3 0f 1e fb          	endbr32 
80105234:	55                   	push   %ebp
80105235:	89 e5                	mov    %esp,%ebp
80105237:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010523a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010523d:	50                   	push   %eax
8010523e:	ff 75 08             	pushl  0x8(%ebp)
80105241:	e8 3a ff ff ff       	call   80105180 <argint>
80105246:	83 c4 10             	add    $0x10,%esp
80105249:	85 c0                	test   %eax,%eax
8010524b:	78 13                	js     80105260 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010524d:	83 ec 08             	sub    $0x8,%esp
80105250:	ff 75 0c             	pushl  0xc(%ebp)
80105253:	ff 75 f4             	pushl  -0xc(%ebp)
80105256:	e8 c5 fe ff ff       	call   80105120 <fetchstr>
8010525b:	83 c4 10             	add    $0x10,%esp
}
8010525e:	c9                   	leave  
8010525f:	c3                   	ret    
80105260:	c9                   	leave  
    return -1;
80105261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105266:	c3                   	ret    
80105267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526e:	66 90                	xchg   %ax,%ax

80105270 <syscall>:
[SYS_sigret] sys_sigret
};

void
syscall(void)
{
80105270:	f3 0f 1e fb          	endbr32 
80105274:	55                   	push   %ebp
80105275:	89 e5                	mov    %esp,%ebp
80105277:	53                   	push   %ebx
80105278:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010527b:	e8 b0 e6 ff ff       	call   80103930 <myproc>
80105280:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105282:	8b 40 18             	mov    0x18(%eax),%eax
80105285:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105288:	8d 50 ff             	lea    -0x1(%eax),%edx
8010528b:	83 fa 17             	cmp    $0x17,%edx
8010528e:	77 20                	ja     801052b0 <syscall+0x40>
80105290:	8b 14 85 20 82 10 80 	mov    -0x7fef7de0(,%eax,4),%edx
80105297:	85 d2                	test   %edx,%edx
80105299:	74 15                	je     801052b0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010529b:	ff d2                	call   *%edx
8010529d:	89 c2                	mov    %eax,%edx
8010529f:	8b 43 18             	mov    0x18(%ebx),%eax
801052a2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801052a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052a8:	c9                   	leave  
801052a9:	c3                   	ret    
801052aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801052b0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801052b1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801052b4:	50                   	push   %eax
801052b5:	ff 73 10             	pushl  0x10(%ebx)
801052b8:	68 01 82 10 80       	push   $0x80108201
801052bd:	e8 ee b3 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801052c2:	8b 43 18             	mov    0x18(%ebx),%eax
801052c5:	83 c4 10             	add    $0x10,%esp
801052c8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801052cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052d2:	c9                   	leave  
801052d3:	c3                   	ret    
801052d4:	66 90                	xchg   %ax,%ax
801052d6:	66 90                	xchg   %ax,%ax
801052d8:	66 90                	xchg   %ax,%ax
801052da:	66 90                	xchg   %ax,%ax
801052dc:	66 90                	xchg   %ax,%ax
801052de:	66 90                	xchg   %ax,%ax

801052e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	57                   	push   %edi
801052e4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801052e5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801052e8:	53                   	push   %ebx
801052e9:	83 ec 34             	sub    $0x34,%esp
801052ec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801052ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801052f2:	57                   	push   %edi
801052f3:	50                   	push   %eax
{
801052f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801052f7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801052fa:	e8 81 cd ff ff       	call   80102080 <nameiparent>
801052ff:	83 c4 10             	add    $0x10,%esp
80105302:	85 c0                	test   %eax,%eax
80105304:	0f 84 46 01 00 00    	je     80105450 <create+0x170>
    return 0;
  ilock(dp);
8010530a:	83 ec 0c             	sub    $0xc,%esp
8010530d:	89 c3                	mov    %eax,%ebx
8010530f:	50                   	push   %eax
80105310:	e8 7b c4 ff ff       	call   80101790 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105315:	83 c4 0c             	add    $0xc,%esp
80105318:	6a 00                	push   $0x0
8010531a:	57                   	push   %edi
8010531b:	53                   	push   %ebx
8010531c:	e8 bf c9 ff ff       	call   80101ce0 <dirlookup>
80105321:	83 c4 10             	add    $0x10,%esp
80105324:	89 c6                	mov    %eax,%esi
80105326:	85 c0                	test   %eax,%eax
80105328:	74 56                	je     80105380 <create+0xa0>
    iunlockput(dp);
8010532a:	83 ec 0c             	sub    $0xc,%esp
8010532d:	53                   	push   %ebx
8010532e:	e8 fd c6 ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
80105333:	89 34 24             	mov    %esi,(%esp)
80105336:	e8 55 c4 ff ff       	call   80101790 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010533b:	83 c4 10             	add    $0x10,%esp
8010533e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105343:	75 1b                	jne    80105360 <create+0x80>
80105345:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010534a:	75 14                	jne    80105360 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010534c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010534f:	89 f0                	mov    %esi,%eax
80105351:	5b                   	pop    %ebx
80105352:	5e                   	pop    %esi
80105353:	5f                   	pop    %edi
80105354:	5d                   	pop    %ebp
80105355:	c3                   	ret    
80105356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	56                   	push   %esi
    return 0;
80105364:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105366:	e8 c5 c6 ff ff       	call   80101a30 <iunlockput>
    return 0;
8010536b:	83 c4 10             	add    $0x10,%esp
}
8010536e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105371:	89 f0                	mov    %esi,%eax
80105373:	5b                   	pop    %ebx
80105374:	5e                   	pop    %esi
80105375:	5f                   	pop    %edi
80105376:	5d                   	pop    %ebp
80105377:	c3                   	ret    
80105378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010537f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105380:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105384:	83 ec 08             	sub    $0x8,%esp
80105387:	50                   	push   %eax
80105388:	ff 33                	pushl  (%ebx)
8010538a:	e8 81 c2 ff ff       	call   80101610 <ialloc>
8010538f:	83 c4 10             	add    $0x10,%esp
80105392:	89 c6                	mov    %eax,%esi
80105394:	85 c0                	test   %eax,%eax
80105396:	0f 84 cd 00 00 00    	je     80105469 <create+0x189>
  ilock(ip);
8010539c:	83 ec 0c             	sub    $0xc,%esp
8010539f:	50                   	push   %eax
801053a0:	e8 eb c3 ff ff       	call   80101790 <ilock>
  ip->major = major;
801053a5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801053a9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801053ad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801053b1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801053b5:	b8 01 00 00 00       	mov    $0x1,%eax
801053ba:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801053be:	89 34 24             	mov    %esi,(%esp)
801053c1:	e8 0a c3 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801053c6:	83 c4 10             	add    $0x10,%esp
801053c9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801053ce:	74 30                	je     80105400 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801053d0:	83 ec 04             	sub    $0x4,%esp
801053d3:	ff 76 04             	pushl  0x4(%esi)
801053d6:	57                   	push   %edi
801053d7:	53                   	push   %ebx
801053d8:	e8 c3 cb ff ff       	call   80101fa0 <dirlink>
801053dd:	83 c4 10             	add    $0x10,%esp
801053e0:	85 c0                	test   %eax,%eax
801053e2:	78 78                	js     8010545c <create+0x17c>
  iunlockput(dp);
801053e4:	83 ec 0c             	sub    $0xc,%esp
801053e7:	53                   	push   %ebx
801053e8:	e8 43 c6 ff ff       	call   80101a30 <iunlockput>
  return ip;
801053ed:	83 c4 10             	add    $0x10,%esp
}
801053f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053f3:	89 f0                	mov    %esi,%eax
801053f5:	5b                   	pop    %ebx
801053f6:	5e                   	pop    %esi
801053f7:	5f                   	pop    %edi
801053f8:	5d                   	pop    %ebp
801053f9:	c3                   	ret    
801053fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105400:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105403:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105408:	53                   	push   %ebx
80105409:	e8 c2 c2 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010540e:	83 c4 0c             	add    $0xc,%esp
80105411:	ff 76 04             	pushl  0x4(%esi)
80105414:	68 a0 82 10 80       	push   $0x801082a0
80105419:	56                   	push   %esi
8010541a:	e8 81 cb ff ff       	call   80101fa0 <dirlink>
8010541f:	83 c4 10             	add    $0x10,%esp
80105422:	85 c0                	test   %eax,%eax
80105424:	78 18                	js     8010543e <create+0x15e>
80105426:	83 ec 04             	sub    $0x4,%esp
80105429:	ff 73 04             	pushl  0x4(%ebx)
8010542c:	68 9f 82 10 80       	push   $0x8010829f
80105431:	56                   	push   %esi
80105432:	e8 69 cb ff ff       	call   80101fa0 <dirlink>
80105437:	83 c4 10             	add    $0x10,%esp
8010543a:	85 c0                	test   %eax,%eax
8010543c:	79 92                	jns    801053d0 <create+0xf0>
      panic("create dots");
8010543e:	83 ec 0c             	sub    $0xc,%esp
80105441:	68 93 82 10 80       	push   $0x80108293
80105446:	e8 45 af ff ff       	call   80100390 <panic>
8010544b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010544f:	90                   	nop
}
80105450:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105453:	31 f6                	xor    %esi,%esi
}
80105455:	5b                   	pop    %ebx
80105456:	89 f0                	mov    %esi,%eax
80105458:	5e                   	pop    %esi
80105459:	5f                   	pop    %edi
8010545a:	5d                   	pop    %ebp
8010545b:	c3                   	ret    
    panic("create: dirlink");
8010545c:	83 ec 0c             	sub    $0xc,%esp
8010545f:	68 a2 82 10 80       	push   $0x801082a2
80105464:	e8 27 af ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105469:	83 ec 0c             	sub    $0xc,%esp
8010546c:	68 84 82 10 80       	push   $0x80108284
80105471:	e8 1a af ff ff       	call   80100390 <panic>
80105476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010547d:	8d 76 00             	lea    0x0(%esi),%esi

80105480 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	56                   	push   %esi
80105484:	89 d6                	mov    %edx,%esi
80105486:	53                   	push   %ebx
80105487:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105489:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010548c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010548f:	50                   	push   %eax
80105490:	6a 00                	push   $0x0
80105492:	e8 e9 fc ff ff       	call   80105180 <argint>
80105497:	83 c4 10             	add    $0x10,%esp
8010549a:	85 c0                	test   %eax,%eax
8010549c:	78 2a                	js     801054c8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010549e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054a2:	77 24                	ja     801054c8 <argfd.constprop.0+0x48>
801054a4:	e8 87 e4 ff ff       	call   80103930 <myproc>
801054a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054ac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801054b0:	85 c0                	test   %eax,%eax
801054b2:	74 14                	je     801054c8 <argfd.constprop.0+0x48>
  if(pfd)
801054b4:	85 db                	test   %ebx,%ebx
801054b6:	74 02                	je     801054ba <argfd.constprop.0+0x3a>
    *pfd = fd;
801054b8:	89 13                	mov    %edx,(%ebx)
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
{
801054d0:	f3 0f 1e fb          	endbr32 
801054d4:	55                   	push   %ebp
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
  if((fd=fdalloc(f)) < 0)
801054ea:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801054ed:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054ef:	e8 3c e4 ff ff       	call   80103930 <myproc>
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
8010552a:	e8 71 b9 ff ff       	call   80100ea0 <filedup>
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
{
80105540:	f3 0f 1e fb          	endbr32 
80105544:	55                   	push   %ebp
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
80105561:	e8 1a fc ff ff       	call   80105180 <argint>
80105566:	83 c4 10             	add    $0x10,%esp
80105569:	85 c0                	test   %eax,%eax
8010556b:	78 33                	js     801055a0 <sys_read+0x60>
8010556d:	83 ec 04             	sub    $0x4,%esp
80105570:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105573:	ff 75 f0             	pushl  -0x10(%ebp)
80105576:	50                   	push   %eax
80105577:	6a 01                	push   $0x1
80105579:	e8 52 fc ff ff       	call   801051d0 <argptr>
8010557e:	83 c4 10             	add    $0x10,%esp
80105581:	85 c0                	test   %eax,%eax
80105583:	78 1b                	js     801055a0 <sys_read+0x60>
  return fileread(f, p, n);
80105585:	83 ec 04             	sub    $0x4,%esp
80105588:	ff 75 f0             	pushl  -0x10(%ebp)
8010558b:	ff 75 f4             	pushl  -0xc(%ebp)
8010558e:	ff 75 ec             	pushl  -0x14(%ebp)
80105591:	e8 8a ba ff ff       	call   80101020 <fileread>
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
{
801055b0:	f3 0f 1e fb          	endbr32 
801055b4:	55                   	push   %ebp
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
801055d1:	e8 aa fb ff ff       	call   80105180 <argint>
801055d6:	83 c4 10             	add    $0x10,%esp
801055d9:	85 c0                	test   %eax,%eax
801055db:	78 33                	js     80105610 <sys_write+0x60>
801055dd:	83 ec 04             	sub    $0x4,%esp
801055e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055e3:	ff 75 f0             	pushl  -0x10(%ebp)
801055e6:	50                   	push   %eax
801055e7:	6a 01                	push   $0x1
801055e9:	e8 e2 fb ff ff       	call   801051d0 <argptr>
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	85 c0                	test   %eax,%eax
801055f3:	78 1b                	js     80105610 <sys_write+0x60>
  return filewrite(f, p, n);
801055f5:	83 ec 04             	sub    $0x4,%esp
801055f8:	ff 75 f0             	pushl  -0x10(%ebp)
801055fb:	ff 75 f4             	pushl  -0xc(%ebp)
801055fe:	ff 75 ec             	pushl  -0x14(%ebp)
80105601:	e8 ba ba ff ff       	call   801010c0 <filewrite>
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
{
80105620:	f3 0f 1e fb          	endbr32 
80105624:	55                   	push   %ebp
80105625:	89 e5                	mov    %esp,%ebp
80105627:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010562a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010562d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105630:	e8 4b fe ff ff       	call   80105480 <argfd.constprop.0>
80105635:	85 c0                	test   %eax,%eax
80105637:	78 27                	js     80105660 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105639:	e8 f2 e2 ff ff       	call   80103930 <myproc>
8010563e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105641:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105644:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010564b:	00 
  fileclose(f);
8010564c:	ff 75 f4             	pushl  -0xc(%ebp)
8010564f:	e8 9c b8 ff ff       	call   80100ef0 <fileclose>
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
{
80105670:	f3 0f 1e fb          	endbr32 
80105674:	55                   	push   %ebp
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
80105693:	e8 38 fb ff ff       	call   801051d0 <argptr>
80105698:	83 c4 10             	add    $0x10,%esp
8010569b:	85 c0                	test   %eax,%eax
8010569d:	78 19                	js     801056b8 <sys_fstat+0x48>
  return filestat(f, st);
8010569f:	83 ec 08             	sub    $0x8,%esp
801056a2:	ff 75 f4             	pushl  -0xc(%ebp)
801056a5:	ff 75 f0             	pushl  -0x10(%ebp)
801056a8:	e8 23 b9 ff ff       	call   80100fd0 <filestat>
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
{
801056c0:	f3 0f 1e fb          	endbr32 
801056c4:	55                   	push   %ebp
801056c5:	89 e5                	mov    %esp,%ebp
801056c7:	57                   	push   %edi
801056c8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056c9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801056cc:	53                   	push   %ebx
801056cd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056d0:	50                   	push   %eax
801056d1:	6a 00                	push   $0x0
801056d3:	e8 58 fb ff ff       	call   80105230 <argstr>
801056d8:	83 c4 10             	add    $0x10,%esp
801056db:	85 c0                	test   %eax,%eax
801056dd:	0f 88 ff 00 00 00    	js     801057e2 <sys_link+0x122>
801056e3:	83 ec 08             	sub    $0x8,%esp
801056e6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801056e9:	50                   	push   %eax
801056ea:	6a 01                	push   $0x1
801056ec:	e8 3f fb ff ff       	call   80105230 <argstr>
801056f1:	83 c4 10             	add    $0x10,%esp
801056f4:	85 c0                	test   %eax,%eax
801056f6:	0f 88 e6 00 00 00    	js     801057e2 <sys_link+0x122>
  begin_op();
801056fc:	e8 5f d6 ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
80105701:	83 ec 0c             	sub    $0xc,%esp
80105704:	ff 75 d4             	pushl  -0x2c(%ebp)
80105707:	e8 54 c9 ff ff       	call   80102060 <namei>
8010570c:	83 c4 10             	add    $0x10,%esp
8010570f:	89 c3                	mov    %eax,%ebx
80105711:	85 c0                	test   %eax,%eax
80105713:	0f 84 e8 00 00 00    	je     80105801 <sys_link+0x141>
  ilock(ip);
80105719:	83 ec 0c             	sub    $0xc,%esp
8010571c:	50                   	push   %eax
8010571d:	e8 6e c0 ff ff       	call   80101790 <ilock>
  if(ip->type == T_DIR){
80105722:	83 c4 10             	add    $0x10,%esp
80105725:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010572a:	0f 84 b9 00 00 00    	je     801057e9 <sys_link+0x129>
  iupdate(ip);
80105730:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105733:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105738:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010573b:	53                   	push   %ebx
8010573c:	e8 8f bf ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
80105741:	89 1c 24             	mov    %ebx,(%esp)
80105744:	e8 27 c1 ff ff       	call   80101870 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105749:	58                   	pop    %eax
8010574a:	5a                   	pop    %edx
8010574b:	57                   	push   %edi
8010574c:	ff 75 d0             	pushl  -0x30(%ebp)
8010574f:	e8 2c c9 ff ff       	call   80102080 <nameiparent>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	89 c6                	mov    %eax,%esi
80105759:	85 c0                	test   %eax,%eax
8010575b:	74 5f                	je     801057bc <sys_link+0xfc>
  ilock(dp);
8010575d:	83 ec 0c             	sub    $0xc,%esp
80105760:	50                   	push   %eax
80105761:	e8 2a c0 ff ff       	call   80101790 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105766:	8b 03                	mov    (%ebx),%eax
80105768:	83 c4 10             	add    $0x10,%esp
8010576b:	39 06                	cmp    %eax,(%esi)
8010576d:	75 41                	jne    801057b0 <sys_link+0xf0>
8010576f:	83 ec 04             	sub    $0x4,%esp
80105772:	ff 73 04             	pushl  0x4(%ebx)
80105775:	57                   	push   %edi
80105776:	56                   	push   %esi
80105777:	e8 24 c8 ff ff       	call   80101fa0 <dirlink>
8010577c:	83 c4 10             	add    $0x10,%esp
8010577f:	85 c0                	test   %eax,%eax
80105781:	78 2d                	js     801057b0 <sys_link+0xf0>
  iunlockput(dp);
80105783:	83 ec 0c             	sub    $0xc,%esp
80105786:	56                   	push   %esi
80105787:	e8 a4 c2 ff ff       	call   80101a30 <iunlockput>
  iput(ip);
8010578c:	89 1c 24             	mov    %ebx,(%esp)
8010578f:	e8 2c c1 ff ff       	call   801018c0 <iput>
  end_op();
80105794:	e8 37 d6 ff ff       	call   80102dd0 <end_op>
  return 0;
80105799:	83 c4 10             	add    $0x10,%esp
8010579c:	31 c0                	xor    %eax,%eax
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
801057b4:	e8 77 c2 ff ff       	call   80101a30 <iunlockput>
    goto bad;
801057b9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801057bc:	83 ec 0c             	sub    $0xc,%esp
801057bf:	53                   	push   %ebx
801057c0:	e8 cb bf ff ff       	call   80101790 <ilock>
  ip->nlink--;
801057c5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057ca:	89 1c 24             	mov    %ebx,(%esp)
801057cd:	e8 fe be ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801057d2:	89 1c 24             	mov    %ebx,(%esp)
801057d5:	e8 56 c2 ff ff       	call   80101a30 <iunlockput>
  end_op();
801057da:	e8 f1 d5 ff ff       	call   80102dd0 <end_op>
  return -1;
801057df:	83 c4 10             	add    $0x10,%esp
801057e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e7:	eb b5                	jmp    8010579e <sys_link+0xde>
    iunlockput(ip);
801057e9:	83 ec 0c             	sub    $0xc,%esp
801057ec:	53                   	push   %ebx
801057ed:	e8 3e c2 ff ff       	call   80101a30 <iunlockput>
    end_op();
801057f2:	e8 d9 d5 ff ff       	call   80102dd0 <end_op>
    return -1;
801057f7:	83 c4 10             	add    $0x10,%esp
801057fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ff:	eb 9d                	jmp    8010579e <sys_link+0xde>
    end_op();
80105801:	e8 ca d5 ff ff       	call   80102dd0 <end_op>
    return -1;
80105806:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580b:	eb 91                	jmp    8010579e <sys_link+0xde>
8010580d:	8d 76 00             	lea    0x0(%esi),%esi

80105810 <sys_unlink>:
{
80105810:	f3 0f 1e fb          	endbr32 
80105814:	55                   	push   %ebp
80105815:	89 e5                	mov    %esp,%ebp
80105817:	57                   	push   %edi
80105818:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105819:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010581c:	53                   	push   %ebx
8010581d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105820:	50                   	push   %eax
80105821:	6a 00                	push   $0x0
80105823:	e8 08 fa ff ff       	call   80105230 <argstr>
80105828:	83 c4 10             	add    $0x10,%esp
8010582b:	85 c0                	test   %eax,%eax
8010582d:	0f 88 7d 01 00 00    	js     801059b0 <sys_unlink+0x1a0>
  begin_op();
80105833:	e8 28 d5 ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105838:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010583b:	83 ec 08             	sub    $0x8,%esp
8010583e:	53                   	push   %ebx
8010583f:	ff 75 c0             	pushl  -0x40(%ebp)
80105842:	e8 39 c8 ff ff       	call   80102080 <nameiparent>
80105847:	83 c4 10             	add    $0x10,%esp
8010584a:	89 c6                	mov    %eax,%esi
8010584c:	85 c0                	test   %eax,%eax
8010584e:	0f 84 66 01 00 00    	je     801059ba <sys_unlink+0x1aa>
  ilock(dp);
80105854:	83 ec 0c             	sub    $0xc,%esp
80105857:	50                   	push   %eax
80105858:	e8 33 bf ff ff       	call   80101790 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010585d:	58                   	pop    %eax
8010585e:	5a                   	pop    %edx
8010585f:	68 a0 82 10 80       	push   $0x801082a0
80105864:	53                   	push   %ebx
80105865:	e8 56 c4 ff ff       	call   80101cc0 <namecmp>
8010586a:	83 c4 10             	add    $0x10,%esp
8010586d:	85 c0                	test   %eax,%eax
8010586f:	0f 84 03 01 00 00    	je     80105978 <sys_unlink+0x168>
80105875:	83 ec 08             	sub    $0x8,%esp
80105878:	68 9f 82 10 80       	push   $0x8010829f
8010587d:	53                   	push   %ebx
8010587e:	e8 3d c4 ff ff       	call   80101cc0 <namecmp>
80105883:	83 c4 10             	add    $0x10,%esp
80105886:	85 c0                	test   %eax,%eax
80105888:	0f 84 ea 00 00 00    	je     80105978 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010588e:	83 ec 04             	sub    $0x4,%esp
80105891:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105894:	50                   	push   %eax
80105895:	53                   	push   %ebx
80105896:	56                   	push   %esi
80105897:	e8 44 c4 ff ff       	call   80101ce0 <dirlookup>
8010589c:	83 c4 10             	add    $0x10,%esp
8010589f:	89 c3                	mov    %eax,%ebx
801058a1:	85 c0                	test   %eax,%eax
801058a3:	0f 84 cf 00 00 00    	je     80105978 <sys_unlink+0x168>
  ilock(ip);
801058a9:	83 ec 0c             	sub    $0xc,%esp
801058ac:	50                   	push   %eax
801058ad:	e8 de be ff ff       	call   80101790 <ilock>
  if(ip->nlink < 1)
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801058ba:	0f 8e 23 01 00 00    	jle    801059e3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801058c0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058c5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801058c8:	74 66                	je     80105930 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801058ca:	83 ec 04             	sub    $0x4,%esp
801058cd:	6a 10                	push   $0x10
801058cf:	6a 00                	push   $0x0
801058d1:	57                   	push   %edi
801058d2:	e8 c9 f5 ff ff       	call   80104ea0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058d7:	6a 10                	push   $0x10
801058d9:	ff 75 c4             	pushl  -0x3c(%ebp)
801058dc:	57                   	push   %edi
801058dd:	56                   	push   %esi
801058de:	e8 ad c2 ff ff       	call   80101b90 <writei>
801058e3:	83 c4 20             	add    $0x20,%esp
801058e6:	83 f8 10             	cmp    $0x10,%eax
801058e9:	0f 85 e7 00 00 00    	jne    801059d6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801058ef:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058f4:	0f 84 96 00 00 00    	je     80105990 <sys_unlink+0x180>
  iunlockput(dp);
801058fa:	83 ec 0c             	sub    $0xc,%esp
801058fd:	56                   	push   %esi
801058fe:	e8 2d c1 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
80105903:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105908:	89 1c 24             	mov    %ebx,(%esp)
8010590b:	e8 c0 bd ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105910:	89 1c 24             	mov    %ebx,(%esp)
80105913:	e8 18 c1 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105918:	e8 b3 d4 ff ff       	call   80102dd0 <end_op>
  return 0;
8010591d:	83 c4 10             	add    $0x10,%esp
80105920:	31 c0                	xor    %eax,%eax
}
80105922:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105925:	5b                   	pop    %ebx
80105926:	5e                   	pop    %esi
80105927:	5f                   	pop    %edi
80105928:	5d                   	pop    %ebp
80105929:	c3                   	ret    
8010592a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105930:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105934:	76 94                	jbe    801058ca <sys_unlink+0xba>
80105936:	ba 20 00 00 00       	mov    $0x20,%edx
8010593b:	eb 0b                	jmp    80105948 <sys_unlink+0x138>
8010593d:	8d 76 00             	lea    0x0(%esi),%esi
80105940:	83 c2 10             	add    $0x10,%edx
80105943:	39 53 58             	cmp    %edx,0x58(%ebx)
80105946:	76 82                	jbe    801058ca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105948:	6a 10                	push   $0x10
8010594a:	52                   	push   %edx
8010594b:	57                   	push   %edi
8010594c:	53                   	push   %ebx
8010594d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105950:	e8 3b c1 ff ff       	call   80101a90 <readi>
80105955:	83 c4 10             	add    $0x10,%esp
80105958:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010595b:	83 f8 10             	cmp    $0x10,%eax
8010595e:	75 69                	jne    801059c9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105960:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105965:	74 d9                	je     80105940 <sys_unlink+0x130>
    iunlockput(ip);
80105967:	83 ec 0c             	sub    $0xc,%esp
8010596a:	53                   	push   %ebx
8010596b:	e8 c0 c0 ff ff       	call   80101a30 <iunlockput>
    goto bad;
80105970:	83 c4 10             	add    $0x10,%esp
80105973:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105977:	90                   	nop
  iunlockput(dp);
80105978:	83 ec 0c             	sub    $0xc,%esp
8010597b:	56                   	push   %esi
8010597c:	e8 af c0 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105981:	e8 4a d4 ff ff       	call   80102dd0 <end_op>
  return -1;
80105986:	83 c4 10             	add    $0x10,%esp
80105989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010598e:	eb 92                	jmp    80105922 <sys_unlink+0x112>
    iupdate(dp);
80105990:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105993:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105998:	56                   	push   %esi
80105999:	e8 32 bd ff ff       	call   801016d0 <iupdate>
8010599e:	83 c4 10             	add    $0x10,%esp
801059a1:	e9 54 ff ff ff       	jmp    801058fa <sys_unlink+0xea>
801059a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801059b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059b5:	e9 68 ff ff ff       	jmp    80105922 <sys_unlink+0x112>
    end_op();
801059ba:	e8 11 d4 ff ff       	call   80102dd0 <end_op>
    return -1;
801059bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c4:	e9 59 ff ff ff       	jmp    80105922 <sys_unlink+0x112>
      panic("isdirempty: readi");
801059c9:	83 ec 0c             	sub    $0xc,%esp
801059cc:	68 c4 82 10 80       	push   $0x801082c4
801059d1:	e8 ba a9 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801059d6:	83 ec 0c             	sub    $0xc,%esp
801059d9:	68 d6 82 10 80       	push   $0x801082d6
801059de:	e8 ad a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801059e3:	83 ec 0c             	sub    $0xc,%esp
801059e6:	68 b2 82 10 80       	push   $0x801082b2
801059eb:	e8 a0 a9 ff ff       	call   80100390 <panic>

801059f0 <sys_open>:

int
sys_open(void)
{
801059f0:	f3 0f 1e fb          	endbr32 
801059f4:	55                   	push   %ebp
801059f5:	89 e5                	mov    %esp,%ebp
801059f7:	57                   	push   %edi
801059f8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059f9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801059fc:	53                   	push   %ebx
801059fd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a00:	50                   	push   %eax
80105a01:	6a 00                	push   $0x0
80105a03:	e8 28 f8 ff ff       	call   80105230 <argstr>
80105a08:	83 c4 10             	add    $0x10,%esp
80105a0b:	85 c0                	test   %eax,%eax
80105a0d:	0f 88 8a 00 00 00    	js     80105a9d <sys_open+0xad>
80105a13:	83 ec 08             	sub    $0x8,%esp
80105a16:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a19:	50                   	push   %eax
80105a1a:	6a 01                	push   $0x1
80105a1c:	e8 5f f7 ff ff       	call   80105180 <argint>
80105a21:	83 c4 10             	add    $0x10,%esp
80105a24:	85 c0                	test   %eax,%eax
80105a26:	78 75                	js     80105a9d <sys_open+0xad>
    return -1;

  begin_op();
80105a28:	e8 33 d3 ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
80105a2d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a31:	75 75                	jne    80105aa8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a33:	83 ec 0c             	sub    $0xc,%esp
80105a36:	ff 75 e0             	pushl  -0x20(%ebp)
80105a39:	e8 22 c6 ff ff       	call   80102060 <namei>
80105a3e:	83 c4 10             	add    $0x10,%esp
80105a41:	89 c6                	mov    %eax,%esi
80105a43:	85 c0                	test   %eax,%eax
80105a45:	74 7e                	je     80105ac5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105a47:	83 ec 0c             	sub    $0xc,%esp
80105a4a:	50                   	push   %eax
80105a4b:	e8 40 bd ff ff       	call   80101790 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a50:	83 c4 10             	add    $0x10,%esp
80105a53:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105a58:	0f 84 c2 00 00 00    	je     80105b20 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105a5e:	e8 cd b3 ff ff       	call   80100e30 <filealloc>
80105a63:	89 c7                	mov    %eax,%edi
80105a65:	85 c0                	test   %eax,%eax
80105a67:	74 23                	je     80105a8c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105a69:	e8 c2 de ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a6e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105a70:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105a74:	85 d2                	test   %edx,%edx
80105a76:	74 60                	je     80105ad8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105a78:	83 c3 01             	add    $0x1,%ebx
80105a7b:	83 fb 10             	cmp    $0x10,%ebx
80105a7e:	75 f0                	jne    80105a70 <sys_open+0x80>
    if(f)
      fileclose(f);
80105a80:	83 ec 0c             	sub    $0xc,%esp
80105a83:	57                   	push   %edi
80105a84:	e8 67 b4 ff ff       	call   80100ef0 <fileclose>
80105a89:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105a8c:	83 ec 0c             	sub    $0xc,%esp
80105a8f:	56                   	push   %esi
80105a90:	e8 9b bf ff ff       	call   80101a30 <iunlockput>
    end_op();
80105a95:	e8 36 d3 ff ff       	call   80102dd0 <end_op>
    return -1;
80105a9a:	83 c4 10             	add    $0x10,%esp
80105a9d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105aa2:	eb 6d                	jmp    80105b11 <sys_open+0x121>
80105aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105aa8:	83 ec 0c             	sub    $0xc,%esp
80105aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105aae:	31 c9                	xor    %ecx,%ecx
80105ab0:	ba 02 00 00 00       	mov    $0x2,%edx
80105ab5:	6a 00                	push   $0x0
80105ab7:	e8 24 f8 ff ff       	call   801052e0 <create>
    if(ip == 0){
80105abc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105abf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105ac1:	85 c0                	test   %eax,%eax
80105ac3:	75 99                	jne    80105a5e <sys_open+0x6e>
      end_op();
80105ac5:	e8 06 d3 ff ff       	call   80102dd0 <end_op>
      return -1;
80105aca:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105acf:	eb 40                	jmp    80105b11 <sys_open+0x121>
80105ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105ad8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105adb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105adf:	56                   	push   %esi
80105ae0:	e8 8b bd ff ff       	call   80101870 <iunlock>
  end_op();
80105ae5:	e8 e6 d2 ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
80105aea:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105af0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105af3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105af6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105af9:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105afb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b02:	f7 d0                	not    %eax
80105b04:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b07:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b0a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b0d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b14:	89 d8                	mov    %ebx,%eax
80105b16:	5b                   	pop    %ebx
80105b17:	5e                   	pop    %esi
80105b18:	5f                   	pop    %edi
80105b19:	5d                   	pop    %ebp
80105b1a:	c3                   	ret    
80105b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b1f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b20:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b23:	85 c9                	test   %ecx,%ecx
80105b25:	0f 84 33 ff ff ff    	je     80105a5e <sys_open+0x6e>
80105b2b:	e9 5c ff ff ff       	jmp    80105a8c <sys_open+0x9c>

80105b30 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b30:	f3 0f 1e fb          	endbr32 
80105b34:	55                   	push   %ebp
80105b35:	89 e5                	mov    %esp,%ebp
80105b37:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b3a:	e8 21 d2 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b3f:	83 ec 08             	sub    $0x8,%esp
80105b42:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b45:	50                   	push   %eax
80105b46:	6a 00                	push   $0x0
80105b48:	e8 e3 f6 ff ff       	call   80105230 <argstr>
80105b4d:	83 c4 10             	add    $0x10,%esp
80105b50:	85 c0                	test   %eax,%eax
80105b52:	78 34                	js     80105b88 <sys_mkdir+0x58>
80105b54:	83 ec 0c             	sub    $0xc,%esp
80105b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b5a:	31 c9                	xor    %ecx,%ecx
80105b5c:	ba 01 00 00 00       	mov    $0x1,%edx
80105b61:	6a 00                	push   $0x0
80105b63:	e8 78 f7 ff ff       	call   801052e0 <create>
80105b68:	83 c4 10             	add    $0x10,%esp
80105b6b:	85 c0                	test   %eax,%eax
80105b6d:	74 19                	je     80105b88 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b6f:	83 ec 0c             	sub    $0xc,%esp
80105b72:	50                   	push   %eax
80105b73:	e8 b8 be ff ff       	call   80101a30 <iunlockput>
  end_op();
80105b78:	e8 53 d2 ff ff       	call   80102dd0 <end_op>
  return 0;
80105b7d:	83 c4 10             	add    $0x10,%esp
80105b80:	31 c0                	xor    %eax,%eax
}
80105b82:	c9                   	leave  
80105b83:	c3                   	ret    
80105b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b88:	e8 43 d2 ff ff       	call   80102dd0 <end_op>
    return -1;
80105b8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b92:	c9                   	leave  
80105b93:	c3                   	ret    
80105b94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b9f:	90                   	nop

80105ba0 <sys_mknod>:

int
sys_mknod(void)
{
80105ba0:	f3 0f 1e fb          	endbr32 
80105ba4:	55                   	push   %ebp
80105ba5:	89 e5                	mov    %esp,%ebp
80105ba7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105baa:	e8 b1 d1 ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105baf:	83 ec 08             	sub    $0x8,%esp
80105bb2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105bb5:	50                   	push   %eax
80105bb6:	6a 00                	push   $0x0
80105bb8:	e8 73 f6 ff ff       	call   80105230 <argstr>
80105bbd:	83 c4 10             	add    $0x10,%esp
80105bc0:	85 c0                	test   %eax,%eax
80105bc2:	78 64                	js     80105c28 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105bc4:	83 ec 08             	sub    $0x8,%esp
80105bc7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bca:	50                   	push   %eax
80105bcb:	6a 01                	push   $0x1
80105bcd:	e8 ae f5 ff ff       	call   80105180 <argint>
  if((argstr(0, &path)) < 0 ||
80105bd2:	83 c4 10             	add    $0x10,%esp
80105bd5:	85 c0                	test   %eax,%eax
80105bd7:	78 4f                	js     80105c28 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105bd9:	83 ec 08             	sub    $0x8,%esp
80105bdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bdf:	50                   	push   %eax
80105be0:	6a 02                	push   $0x2
80105be2:	e8 99 f5 ff ff       	call   80105180 <argint>
     argint(1, &major) < 0 ||
80105be7:	83 c4 10             	add    $0x10,%esp
80105bea:	85 c0                	test   %eax,%eax
80105bec:	78 3a                	js     80105c28 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105bee:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105bf2:	83 ec 0c             	sub    $0xc,%esp
80105bf5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105bf9:	ba 03 00 00 00       	mov    $0x3,%edx
80105bfe:	50                   	push   %eax
80105bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c02:	e8 d9 f6 ff ff       	call   801052e0 <create>
     argint(2, &minor) < 0 ||
80105c07:	83 c4 10             	add    $0x10,%esp
80105c0a:	85 c0                	test   %eax,%eax
80105c0c:	74 1a                	je     80105c28 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c0e:	83 ec 0c             	sub    $0xc,%esp
80105c11:	50                   	push   %eax
80105c12:	e8 19 be ff ff       	call   80101a30 <iunlockput>
  end_op();
80105c17:	e8 b4 d1 ff ff       	call   80102dd0 <end_op>
  return 0;
80105c1c:	83 c4 10             	add    $0x10,%esp
80105c1f:	31 c0                	xor    %eax,%eax
}
80105c21:	c9                   	leave  
80105c22:	c3                   	ret    
80105c23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c27:	90                   	nop
    end_op();
80105c28:	e8 a3 d1 ff ff       	call   80102dd0 <end_op>
    return -1;
80105c2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c32:	c9                   	leave  
80105c33:	c3                   	ret    
80105c34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c3f:	90                   	nop

80105c40 <sys_chdir>:

int
sys_chdir(void)
{
80105c40:	f3 0f 1e fb          	endbr32 
80105c44:	55                   	push   %ebp
80105c45:	89 e5                	mov    %esp,%ebp
80105c47:	56                   	push   %esi
80105c48:	53                   	push   %ebx
80105c49:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c4c:	e8 df dc ff ff       	call   80103930 <myproc>
80105c51:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c53:	e8 08 d1 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105c58:	83 ec 08             	sub    $0x8,%esp
80105c5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c5e:	50                   	push   %eax
80105c5f:	6a 00                	push   $0x0
80105c61:	e8 ca f5 ff ff       	call   80105230 <argstr>
80105c66:	83 c4 10             	add    $0x10,%esp
80105c69:	85 c0                	test   %eax,%eax
80105c6b:	78 73                	js     80105ce0 <sys_chdir+0xa0>
80105c6d:	83 ec 0c             	sub    $0xc,%esp
80105c70:	ff 75 f4             	pushl  -0xc(%ebp)
80105c73:	e8 e8 c3 ff ff       	call   80102060 <namei>
80105c78:	83 c4 10             	add    $0x10,%esp
80105c7b:	89 c3                	mov    %eax,%ebx
80105c7d:	85 c0                	test   %eax,%eax
80105c7f:	74 5f                	je     80105ce0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105c81:	83 ec 0c             	sub    $0xc,%esp
80105c84:	50                   	push   %eax
80105c85:	e8 06 bb ff ff       	call   80101790 <ilock>
  if(ip->type != T_DIR){
80105c8a:	83 c4 10             	add    $0x10,%esp
80105c8d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c92:	75 2c                	jne    80105cc0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c94:	83 ec 0c             	sub    $0xc,%esp
80105c97:	53                   	push   %ebx
80105c98:	e8 d3 bb ff ff       	call   80101870 <iunlock>
  iput(curproc->cwd);
80105c9d:	58                   	pop    %eax
80105c9e:	ff 76 68             	pushl  0x68(%esi)
80105ca1:	e8 1a bc ff ff       	call   801018c0 <iput>
  end_op();
80105ca6:	e8 25 d1 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80105cab:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105cae:	83 c4 10             	add    $0x10,%esp
80105cb1:	31 c0                	xor    %eax,%eax
}
80105cb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cb6:	5b                   	pop    %ebx
80105cb7:	5e                   	pop    %esi
80105cb8:	5d                   	pop    %ebp
80105cb9:	c3                   	ret    
80105cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105cc0:	83 ec 0c             	sub    $0xc,%esp
80105cc3:	53                   	push   %ebx
80105cc4:	e8 67 bd ff ff       	call   80101a30 <iunlockput>
    end_op();
80105cc9:	e8 02 d1 ff ff       	call   80102dd0 <end_op>
    return -1;
80105cce:	83 c4 10             	add    $0x10,%esp
80105cd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cd6:	eb db                	jmp    80105cb3 <sys_chdir+0x73>
80105cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cdf:	90                   	nop
    end_op();
80105ce0:	e8 eb d0 ff ff       	call   80102dd0 <end_op>
    return -1;
80105ce5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cea:	eb c7                	jmp    80105cb3 <sys_chdir+0x73>
80105cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cf0 <sys_exec>:

int
sys_exec(void)
{
80105cf0:	f3 0f 1e fb          	endbr32 
80105cf4:	55                   	push   %ebp
80105cf5:	89 e5                	mov    %esp,%ebp
80105cf7:	57                   	push   %edi
80105cf8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105cf9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105cff:	53                   	push   %ebx
80105d00:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d06:	50                   	push   %eax
80105d07:	6a 00                	push   $0x0
80105d09:	e8 22 f5 ff ff       	call   80105230 <argstr>
80105d0e:	83 c4 10             	add    $0x10,%esp
80105d11:	85 c0                	test   %eax,%eax
80105d13:	0f 88 8b 00 00 00    	js     80105da4 <sys_exec+0xb4>
80105d19:	83 ec 08             	sub    $0x8,%esp
80105d1c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d22:	50                   	push   %eax
80105d23:	6a 01                	push   $0x1
80105d25:	e8 56 f4 ff ff       	call   80105180 <argint>
80105d2a:	83 c4 10             	add    $0x10,%esp
80105d2d:	85 c0                	test   %eax,%eax
80105d2f:	78 73                	js     80105da4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d31:	83 ec 04             	sub    $0x4,%esp
80105d34:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105d3a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d3c:	68 80 00 00 00       	push   $0x80
80105d41:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105d47:	6a 00                	push   $0x0
80105d49:	50                   	push   %eax
80105d4a:	e8 51 f1 ff ff       	call   80104ea0 <memset>
80105d4f:	83 c4 10             	add    $0x10,%esp
80105d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d58:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d5e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105d65:	83 ec 08             	sub    $0x8,%esp
80105d68:	57                   	push   %edi
80105d69:	01 f0                	add    %esi,%eax
80105d6b:	50                   	push   %eax
80105d6c:	e8 6f f3 ff ff       	call   801050e0 <fetchint>
80105d71:	83 c4 10             	add    $0x10,%esp
80105d74:	85 c0                	test   %eax,%eax
80105d76:	78 2c                	js     80105da4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105d78:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105d7e:	85 c0                	test   %eax,%eax
80105d80:	74 36                	je     80105db8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105d82:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105d88:	83 ec 08             	sub    $0x8,%esp
80105d8b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105d8e:	52                   	push   %edx
80105d8f:	50                   	push   %eax
80105d90:	e8 8b f3 ff ff       	call   80105120 <fetchstr>
80105d95:	83 c4 10             	add    $0x10,%esp
80105d98:	85 c0                	test   %eax,%eax
80105d9a:	78 08                	js     80105da4 <sys_exec+0xb4>
  for(i=0;; i++){
80105d9c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105d9f:	83 fb 20             	cmp    $0x20,%ebx
80105da2:	75 b4                	jne    80105d58 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105da4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105da7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dac:	5b                   	pop    %ebx
80105dad:	5e                   	pop    %esi
80105dae:	5f                   	pop    %edi
80105daf:	5d                   	pop    %ebp
80105db0:	c3                   	ret    
80105db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105db8:	83 ec 08             	sub    $0x8,%esp
80105dbb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105dc1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105dc8:	00 00 00 00 
  return exec(path, argv);
80105dcc:	50                   	push   %eax
80105dcd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105dd3:	e8 a8 ac ff ff       	call   80100a80 <exec>
80105dd8:	83 c4 10             	add    $0x10,%esp
}
80105ddb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dde:	5b                   	pop    %ebx
80105ddf:	5e                   	pop    %esi
80105de0:	5f                   	pop    %edi
80105de1:	5d                   	pop    %ebp
80105de2:	c3                   	ret    
80105de3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105df0 <sys_pipe>:

int
sys_pipe(void)
{
80105df0:	f3 0f 1e fb          	endbr32 
80105df4:	55                   	push   %ebp
80105df5:	89 e5                	mov    %esp,%ebp
80105df7:	57                   	push   %edi
80105df8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105df9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105dfc:	53                   	push   %ebx
80105dfd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e00:	6a 08                	push   $0x8
80105e02:	50                   	push   %eax
80105e03:	6a 00                	push   $0x0
80105e05:	e8 c6 f3 ff ff       	call   801051d0 <argptr>
80105e0a:	83 c4 10             	add    $0x10,%esp
80105e0d:	85 c0                	test   %eax,%eax
80105e0f:	78 4e                	js     80105e5f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e11:	83 ec 08             	sub    $0x8,%esp
80105e14:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e17:	50                   	push   %eax
80105e18:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e1b:	50                   	push   %eax
80105e1c:	e8 ff d5 ff ff       	call   80103420 <pipealloc>
80105e21:	83 c4 10             	add    $0x10,%esp
80105e24:	85 c0                	test   %eax,%eax
80105e26:	78 37                	js     80105e5f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e28:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e2b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e2d:	e8 fe da ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105e38:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e3c:	85 f6                	test   %esi,%esi
80105e3e:	74 30                	je     80105e70 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105e40:	83 c3 01             	add    $0x1,%ebx
80105e43:	83 fb 10             	cmp    $0x10,%ebx
80105e46:	75 f0                	jne    80105e38 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e48:	83 ec 0c             	sub    $0xc,%esp
80105e4b:	ff 75 e0             	pushl  -0x20(%ebp)
80105e4e:	e8 9d b0 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
80105e53:	58                   	pop    %eax
80105e54:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e57:	e8 94 b0 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105e5c:	83 c4 10             	add    $0x10,%esp
80105e5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e64:	eb 5b                	jmp    80105ec1 <sys_pipe+0xd1>
80105e66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e6d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105e70:	8d 73 08             	lea    0x8(%ebx),%esi
80105e73:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105e7a:	e8 b1 da ff ff       	call   80103930 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e7f:	31 d2                	xor    %edx,%edx
80105e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105e88:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105e8c:	85 c9                	test   %ecx,%ecx
80105e8e:	74 20                	je     80105eb0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105e90:	83 c2 01             	add    $0x1,%edx
80105e93:	83 fa 10             	cmp    $0x10,%edx
80105e96:	75 f0                	jne    80105e88 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105e98:	e8 93 da ff ff       	call   80103930 <myproc>
80105e9d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ea4:	00 
80105ea5:	eb a1                	jmp    80105e48 <sys_pipe+0x58>
80105ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105eb0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105eb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105eb7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105eb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ebc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ebf:	31 c0                	xor    %eax,%eax
}
80105ec1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ec4:	5b                   	pop    %ebx
80105ec5:	5e                   	pop    %esi
80105ec6:	5f                   	pop    %edi
80105ec7:	5d                   	pop    %ebp
80105ec8:	c3                   	ret    
80105ec9:	66 90                	xchg   %ax,%ax
80105ecb:	66 90                	xchg   %ax,%ax
80105ecd:	66 90                	xchg   %ax,%ax
80105ecf:	90                   	nop

80105ed0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105ed0:	f3 0f 1e fb          	endbr32 
  return fork();
80105ed4:	e9 d7 dd ff ff       	jmp    80103cb0 <fork>
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ee0 <sys_exit>:
}

int
sys_exit(void)
{
80105ee0:	f3 0f 1e fb          	endbr32 
80105ee4:	55                   	push   %ebp
80105ee5:	89 e5                	mov    %esp,%ebp
80105ee7:	83 ec 08             	sub    $0x8,%esp
  exit();
80105eea:	e8 b1 e1 ff ff       	call   801040a0 <exit>
  return 0;  // not reached
}
80105eef:	31 c0                	xor    %eax,%eax
80105ef1:	c9                   	leave  
80105ef2:	c3                   	ret    
80105ef3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f00 <sys_wait>:

int
sys_wait(void)
{
80105f00:	f3 0f 1e fb          	endbr32 
  return wait();
80105f04:	e9 c7 e2 ff ff       	jmp    801041d0 <wait>
80105f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f10 <sys_kill>:
}

int
sys_kill(void)
{
80105f10:	f3 0f 1e fb          	endbr32 
80105f14:	55                   	push   %ebp
80105f15:	89 e5                	mov    %esp,%ebp
80105f17:	83 ec 20             	sub    $0x20,%esp
  int pid, signum;

  if(argint(0, &pid) < 0 || argint(1, &signum) < 0){
80105f1a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f1d:	50                   	push   %eax
80105f1e:	6a 00                	push   $0x0
80105f20:	e8 5b f2 ff ff       	call   80105180 <argint>
80105f25:	83 c4 10             	add    $0x10,%esp
80105f28:	85 c0                	test   %eax,%eax
80105f2a:	78 2c                	js     80105f58 <sys_kill+0x48>
80105f2c:	83 ec 08             	sub    $0x8,%esp
80105f2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f32:	50                   	push   %eax
80105f33:	6a 01                	push   $0x1
80105f35:	e8 46 f2 ff ff       	call   80105180 <argint>
80105f3a:	83 c4 10             	add    $0x10,%esp
80105f3d:	85 c0                	test   %eax,%eax
80105f3f:	78 17                	js     80105f58 <sys_kill+0x48>
    return -1;
  }
  return kill(pid, signum);
80105f41:	83 ec 08             	sub    $0x8,%esp
80105f44:	ff 75 f4             	pushl  -0xc(%ebp)
80105f47:	ff 75 f0             	pushl  -0x10(%ebp)
80105f4a:	e8 61 e6 ff ff       	call   801045b0 <kill>
80105f4f:	83 c4 10             	add    $0x10,%esp
}
80105f52:	c9                   	leave  
80105f53:	c3                   	ret    
80105f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f58:	c9                   	leave  
    return -1;
80105f59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f5e:	c3                   	ret    
80105f5f:	90                   	nop

80105f60 <sys_getpid>:

int
sys_getpid(void)
{
80105f60:	f3 0f 1e fb          	endbr32 
80105f64:	55                   	push   %ebp
80105f65:	89 e5                	mov    %esp,%ebp
80105f67:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f6a:	e8 c1 d9 ff ff       	call   80103930 <myproc>
80105f6f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f72:	c9                   	leave  
80105f73:	c3                   	ret    
80105f74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f7f:	90                   	nop

80105f80 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f80:	f3 0f 1e fb          	endbr32 
80105f84:	55                   	push   %ebp
80105f85:	89 e5                	mov    %esp,%ebp
80105f87:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f88:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f8b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f8e:	50                   	push   %eax
80105f8f:	6a 00                	push   $0x0
80105f91:	e8 ea f1 ff ff       	call   80105180 <argint>
80105f96:	83 c4 10             	add    $0x10,%esp
80105f99:	85 c0                	test   %eax,%eax
80105f9b:	78 23                	js     80105fc0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f9d:	e8 8e d9 ff ff       	call   80103930 <myproc>
  if(growproc(n) < 0)
80105fa2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105fa5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105fa7:	ff 75 f4             	pushl  -0xc(%ebp)
80105faa:	e8 81 dc ff ff       	call   80103c30 <growproc>
80105faf:	83 c4 10             	add    $0x10,%esp
80105fb2:	85 c0                	test   %eax,%eax
80105fb4:	78 0a                	js     80105fc0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105fb6:	89 d8                	mov    %ebx,%eax
80105fb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fbb:	c9                   	leave  
80105fbc:	c3                   	ret    
80105fbd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105fc0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fc5:	eb ef                	jmp    80105fb6 <sys_sbrk+0x36>
80105fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <sys_sleep>:

int
sys_sleep(void)
{
80105fd0:	f3 0f 1e fb          	endbr32 
80105fd4:	55                   	push   %ebp
80105fd5:	89 e5                	mov    %esp,%ebp
80105fd7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105fd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105fdb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105fde:	50                   	push   %eax
80105fdf:	6a 00                	push   $0x0
80105fe1:	e8 9a f1 ff ff       	call   80105180 <argint>
80105fe6:	83 c4 10             	add    $0x10,%esp
80105fe9:	85 c0                	test   %eax,%eax
80105feb:	0f 88 86 00 00 00    	js     80106077 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105ff1:	83 ec 0c             	sub    $0xc,%esp
80105ff4:	68 80 a3 11 80       	push   $0x8011a380
80105ff9:	e8 92 ed ff ff       	call   80104d90 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105ffe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106001:	8b 1d c0 ab 11 80    	mov    0x8011abc0,%ebx
  while(ticks - ticks0 < n){
80106007:	83 c4 10             	add    $0x10,%esp
8010600a:	85 d2                	test   %edx,%edx
8010600c:	75 23                	jne    80106031 <sys_sleep+0x61>
8010600e:	eb 50                	jmp    80106060 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106010:	83 ec 08             	sub    $0x8,%esp
80106013:	68 80 a3 11 80       	push   $0x8011a380
80106018:	68 c0 ab 11 80       	push   $0x8011abc0
8010601d:	e8 5e e4 ff ff       	call   80104480 <sleep>
  while(ticks - ticks0 < n){
80106022:	a1 c0 ab 11 80       	mov    0x8011abc0,%eax
80106027:	83 c4 10             	add    $0x10,%esp
8010602a:	29 d8                	sub    %ebx,%eax
8010602c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010602f:	73 2f                	jae    80106060 <sys_sleep+0x90>
    if(myproc()->killed){
80106031:	e8 fa d8 ff ff       	call   80103930 <myproc>
80106036:	8b 40 24             	mov    0x24(%eax),%eax
80106039:	85 c0                	test   %eax,%eax
8010603b:	74 d3                	je     80106010 <sys_sleep+0x40>
      release(&tickslock);
8010603d:	83 ec 0c             	sub    $0xc,%esp
80106040:	68 80 a3 11 80       	push   $0x8011a380
80106045:	e8 06 ee ff ff       	call   80104e50 <release>
  }
  release(&tickslock);
  return 0;
}
8010604a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010604d:	83 c4 10             	add    $0x10,%esp
80106050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106055:	c9                   	leave  
80106056:	c3                   	ret    
80106057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106060:	83 ec 0c             	sub    $0xc,%esp
80106063:	68 80 a3 11 80       	push   $0x8011a380
80106068:	e8 e3 ed ff ff       	call   80104e50 <release>
  return 0;
8010606d:	83 c4 10             	add    $0x10,%esp
80106070:	31 c0                	xor    %eax,%eax
}
80106072:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106075:	c9                   	leave  
80106076:	c3                   	ret    
    return -1;
80106077:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010607c:	eb f4                	jmp    80106072 <sys_sleep+0xa2>
8010607e:	66 90                	xchg   %ax,%ax

80106080 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106080:	f3 0f 1e fb          	endbr32 
80106084:	55                   	push   %ebp
80106085:	89 e5                	mov    %esp,%ebp
80106087:	53                   	push   %ebx
80106088:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010608b:	68 80 a3 11 80       	push   $0x8011a380
80106090:	e8 fb ec ff ff       	call   80104d90 <acquire>
  xticks = ticks;
80106095:	8b 1d c0 ab 11 80    	mov    0x8011abc0,%ebx
  release(&tickslock);
8010609b:	c7 04 24 80 a3 11 80 	movl   $0x8011a380,(%esp)
801060a2:	e8 a9 ed ff ff       	call   80104e50 <release>
  return xticks;
}
801060a7:	89 d8                	mov    %ebx,%eax
801060a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060ac:	c9                   	leave  
801060ad:	c3                   	ret    
801060ae:	66 90                	xchg   %ax,%ax

801060b0 <sys_sigprocmask>:

int sys_sigprocmask(void){
801060b0:	f3 0f 1e fb          	endbr32 
801060b4:	55                   	push   %ebp
801060b5:	89 e5                	mov    %esp,%ebp
801060b7:	83 ec 20             	sub    $0x20,%esp
  uint sigmask;
  if (argint(0, (int*)&sigmask) < 0){
801060ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060bd:	50                   	push   %eax
801060be:	6a 00                	push   $0x0
801060c0:	e8 bb f0 ff ff       	call   80105180 <argint>
801060c5:	83 c4 10             	add    $0x10,%esp
801060c8:	85 c0                	test   %eax,%eax
801060ca:	78 14                	js     801060e0 <sys_sigprocmask+0x30>
    return -1;
  }
  return sigprocmask(sigmask);
801060cc:	83 ec 0c             	sub    $0xc,%esp
801060cf:	ff 75 f4             	pushl  -0xc(%ebp)
801060d2:	e8 b9 e6 ff ff       	call   80104790 <sigprocmask>
801060d7:	83 c4 10             	add    $0x10,%esp
}
801060da:	c9                   	leave  
801060db:	c3                   	ret    
801060dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060e0:	c9                   	leave  
    return -1;
801060e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060e6:	c3                   	ret    
801060e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ee:	66 90                	xchg   %ax,%ax

801060f0 <sys_sigaction>:

int sys_sigaction(void){
801060f0:	f3 0f 1e fb          	endbr32 
801060f4:	55                   	push   %ebp
801060f5:	89 e5                	mov    %esp,%ebp
801060f7:	83 ec 20             	sub    $0x20,%esp
  uint signum;
  struct sigaction* act;
  struct sigaction* oldact;
  if (argint(0, (int*)(&signum)) < 0 || argptr(1, (char**)(&act), 16) < 0 || argptr(2, (char**)(&oldact), 16)){
801060fa:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060fd:	50                   	push   %eax
801060fe:	6a 00                	push   $0x0
80106100:	e8 7b f0 ff ff       	call   80105180 <argint>
80106105:	83 c4 10             	add    $0x10,%esp
80106108:	85 c0                	test   %eax,%eax
8010610a:	78 44                	js     80106150 <sys_sigaction+0x60>
8010610c:	83 ec 04             	sub    $0x4,%esp
8010610f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106112:	6a 10                	push   $0x10
80106114:	50                   	push   %eax
80106115:	6a 01                	push   $0x1
80106117:	e8 b4 f0 ff ff       	call   801051d0 <argptr>
8010611c:	83 c4 10             	add    $0x10,%esp
8010611f:	85 c0                	test   %eax,%eax
80106121:	78 2d                	js     80106150 <sys_sigaction+0x60>
80106123:	83 ec 04             	sub    $0x4,%esp
80106126:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106129:	6a 10                	push   $0x10
8010612b:	50                   	push   %eax
8010612c:	6a 02                	push   $0x2
8010612e:	e8 9d f0 ff ff       	call   801051d0 <argptr>
80106133:	83 c4 10             	add    $0x10,%esp
80106136:	85 c0                	test   %eax,%eax
80106138:	75 16                	jne    80106150 <sys_sigaction+0x60>
    return -1;
  }

  return sigaction(signum, act, oldact);
8010613a:	83 ec 04             	sub    $0x4,%esp
8010613d:	ff 75 f4             	pushl  -0xc(%ebp)
80106140:	ff 75 f0             	pushl  -0x10(%ebp)
80106143:	ff 75 ec             	pushl  -0x14(%ebp)
80106146:	e8 95 e6 ff ff       	call   801047e0 <sigaction>
8010614b:	83 c4 10             	add    $0x10,%esp
}
8010614e:	c9                   	leave  
8010614f:	c3                   	ret    
80106150:	c9                   	leave  
    return -1;
80106151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106156:	c3                   	ret    
80106157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010615e:	66 90                	xchg   %ax,%ax

80106160 <sys_sigret>:

int sys_sigret(void){
80106160:	f3 0f 1e fb          	endbr32 
80106164:	55                   	push   %ebp
80106165:	89 e5                	mov    %esp,%ebp
80106167:	83 ec 08             	sub    $0x8,%esp
  sigret();
8010616a:	e8 f1 e6 ff ff       	call   80104860 <sigret>
  return 0;
}
8010616f:	31 c0                	xor    %eax,%eax
80106171:	c9                   	leave  
80106172:	c3                   	ret    

80106173 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106173:	1e                   	push   %ds
  pushl %es
80106174:	06                   	push   %es
  pushl %fs
80106175:	0f a0                	push   %fs
  pushl %gs
80106177:	0f a8                	push   %gs
  pushal
80106179:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010617a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010617e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106180:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106182:	54                   	push   %esp
  call trap
80106183:	e8 c8 00 00 00       	call   80106250 <trap>
  addl $4, %esp
80106188:	83 c4 04             	add    $0x4,%esp

8010618b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:

  call handle_signals
8010618b:	e8 c0 e7 ff ff       	call   80104950 <handle_signals>
  
  popal
80106190:	61                   	popa   
  popl %gs
80106191:	0f a9                	pop    %gs
  popl %fs
80106193:	0f a1                	pop    %fs
  popl %es
80106195:	07                   	pop    %es
  popl %ds
80106196:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106197:	83 c4 08             	add    $0x8,%esp
  iret
8010619a:	cf                   	iret   
8010619b:	66 90                	xchg   %ax,%ax
8010619d:	66 90                	xchg   %ax,%ax
8010619f:	90                   	nop

801061a0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801061a0:	f3 0f 1e fb          	endbr32 
801061a4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801061a5:	31 c0                	xor    %eax,%eax
{
801061a7:	89 e5                	mov    %esp,%ebp
801061a9:	83 ec 08             	sub    $0x8,%esp
801061ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801061b0:	8b 14 85 04 b0 10 80 	mov    -0x7fef4ffc(,%eax,4),%edx
801061b7:	c7 04 c5 c2 a3 11 80 	movl   $0x8e000008,-0x7fee5c3e(,%eax,8)
801061be:	08 00 00 8e 
801061c2:	66 89 14 c5 c0 a3 11 	mov    %dx,-0x7fee5c40(,%eax,8)
801061c9:	80 
801061ca:	c1 ea 10             	shr    $0x10,%edx
801061cd:	66 89 14 c5 c6 a3 11 	mov    %dx,-0x7fee5c3a(,%eax,8)
801061d4:	80 
  for(i = 0; i < 256; i++)
801061d5:	83 c0 01             	add    $0x1,%eax
801061d8:	3d 00 01 00 00       	cmp    $0x100,%eax
801061dd:	75 d1                	jne    801061b0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801061df:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061e2:	a1 04 b1 10 80       	mov    0x8010b104,%eax
801061e7:	c7 05 c2 a5 11 80 08 	movl   $0xef000008,0x8011a5c2
801061ee:	00 00 ef 
  initlock(&tickslock, "time");
801061f1:	68 e5 82 10 80       	push   $0x801082e5
801061f6:	68 80 a3 11 80       	push   $0x8011a380
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061fb:	66 a3 c0 a5 11 80    	mov    %ax,0x8011a5c0
80106201:	c1 e8 10             	shr    $0x10,%eax
80106204:	66 a3 c6 a5 11 80    	mov    %ax,0x8011a5c6
  initlock(&tickslock, "time");
8010620a:	e8 01 ea ff ff       	call   80104c10 <initlock>
}
8010620f:	83 c4 10             	add    $0x10,%esp
80106212:	c9                   	leave  
80106213:	c3                   	ret    
80106214:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010621b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010621f:	90                   	nop

80106220 <idtinit>:

void
idtinit(void)
{
80106220:	f3 0f 1e fb          	endbr32 
80106224:	55                   	push   %ebp
  pd[0] = size-1;
80106225:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010622a:	89 e5                	mov    %esp,%ebp
8010622c:	83 ec 10             	sub    $0x10,%esp
8010622f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106233:	b8 c0 a3 11 80       	mov    $0x8011a3c0,%eax
80106238:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010623c:	c1 e8 10             	shr    $0x10,%eax
8010623f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106243:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106246:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106249:	c9                   	leave  
8010624a:	c3                   	ret    
8010624b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010624f:	90                   	nop

80106250 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe* tf)
{
80106250:	f3 0f 1e fb          	endbr32 
80106254:	55                   	push   %ebp
80106255:	89 e5                	mov    %esp,%ebp
80106257:	57                   	push   %edi
80106258:	56                   	push   %esi
80106259:	53                   	push   %ebx
8010625a:	83 ec 1c             	sub    $0x1c,%esp
8010625d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106260:	8b 43 30             	mov    0x30(%ebx),%eax
80106263:	83 f8 40             	cmp    $0x40,%eax
80106266:	0f 84 bc 01 00 00    	je     80106428 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010626c:	83 e8 20             	sub    $0x20,%eax
8010626f:	83 f8 1f             	cmp    $0x1f,%eax
80106272:	77 08                	ja     8010627c <trap+0x2c>
80106274:	3e ff 24 85 8c 83 10 	notrack jmp *-0x7fef7c74(,%eax,4)
8010627b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010627c:	e8 af d6 ff ff       	call   80103930 <myproc>
80106281:	8b 7b 38             	mov    0x38(%ebx),%edi
80106284:	85 c0                	test   %eax,%eax
80106286:	0f 84 eb 01 00 00    	je     80106477 <trap+0x227>
8010628c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106290:	0f 84 e1 01 00 00    	je     80106477 <trap+0x227>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106296:	0f 20 d1             	mov    %cr2,%ecx
80106299:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010629c:	e8 6f d6 ff ff       	call   80103910 <cpuid>
801062a1:	8b 73 30             	mov    0x30(%ebx),%esi
801062a4:	89 45 dc             	mov    %eax,-0x24(%ebp)
801062a7:	8b 43 34             	mov    0x34(%ebx),%eax
801062aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801062ad:	e8 7e d6 ff ff       	call   80103930 <myproc>
801062b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801062b5:	e8 76 d6 ff ff       	call   80103930 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062ba:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801062bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801062c0:	51                   	push   %ecx
801062c1:	57                   	push   %edi
801062c2:	52                   	push   %edx
801062c3:	ff 75 e4             	pushl  -0x1c(%ebp)
801062c6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801062c7:	8b 75 e0             	mov    -0x20(%ebp),%esi
801062ca:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062cd:	56                   	push   %esi
801062ce:	ff 70 10             	pushl  0x10(%eax)
801062d1:	68 48 83 10 80       	push   $0x80108348
801062d6:	e8 d5 a3 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801062db:	83 c4 20             	add    $0x20,%esp
801062de:	e8 4d d6 ff ff       	call   80103930 <myproc>
801062e3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062ea:	e8 41 d6 ff ff       	call   80103930 <myproc>
801062ef:	85 c0                	test   %eax,%eax
801062f1:	74 1d                	je     80106310 <trap+0xc0>
801062f3:	e8 38 d6 ff ff       	call   80103930 <myproc>
801062f8:	8b 50 24             	mov    0x24(%eax),%edx
801062fb:	85 d2                	test   %edx,%edx
801062fd:	74 11                	je     80106310 <trap+0xc0>
801062ff:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106303:	83 e0 03             	and    $0x3,%eax
80106306:	66 83 f8 03          	cmp    $0x3,%ax
8010630a:	0f 84 50 01 00 00    	je     80106460 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106310:	e8 1b d6 ff ff       	call   80103930 <myproc>
80106315:	85 c0                	test   %eax,%eax
80106317:	74 0f                	je     80106328 <trap+0xd8>
80106319:	e8 12 d6 ff ff       	call   80103930 <myproc>
8010631e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106322:	0f 84 e8 00 00 00    	je     80106410 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106328:	e8 03 d6 ff ff       	call   80103930 <myproc>
8010632d:	85 c0                	test   %eax,%eax
8010632f:	74 1d                	je     8010634e <trap+0xfe>
80106331:	e8 fa d5 ff ff       	call   80103930 <myproc>
80106336:	8b 40 24             	mov    0x24(%eax),%eax
80106339:	85 c0                	test   %eax,%eax
8010633b:	74 11                	je     8010634e <trap+0xfe>
8010633d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106341:	83 e0 03             	and    $0x3,%eax
80106344:	66 83 f8 03          	cmp    $0x3,%ax
80106348:	0f 84 03 01 00 00    	je     80106451 <trap+0x201>
    exit();
}
8010634e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106351:	5b                   	pop    %ebx
80106352:	5e                   	pop    %esi
80106353:	5f                   	pop    %edi
80106354:	5d                   	pop    %ebp
80106355:	c3                   	ret    
    ideintr();
80106356:	e8 b5 be ff ff       	call   80102210 <ideintr>
    lapiceoi();
8010635b:	e8 90 c5 ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106360:	e8 cb d5 ff ff       	call   80103930 <myproc>
80106365:	85 c0                	test   %eax,%eax
80106367:	75 8a                	jne    801062f3 <trap+0xa3>
80106369:	eb a5                	jmp    80106310 <trap+0xc0>
    if(cpuid() == 0){
8010636b:	e8 a0 d5 ff ff       	call   80103910 <cpuid>
80106370:	85 c0                	test   %eax,%eax
80106372:	75 e7                	jne    8010635b <trap+0x10b>
      acquire(&tickslock);
80106374:	83 ec 0c             	sub    $0xc,%esp
80106377:	68 80 a3 11 80       	push   $0x8011a380
8010637c:	e8 0f ea ff ff       	call   80104d90 <acquire>
      wakeup(&ticks);
80106381:	c7 04 24 c0 ab 11 80 	movl   $0x8011abc0,(%esp)
      ticks++;
80106388:	83 05 c0 ab 11 80 01 	addl   $0x1,0x8011abc0
      wakeup(&ticks);
8010638f:	e8 cc e1 ff ff       	call   80104560 <wakeup>
      release(&tickslock);
80106394:	c7 04 24 80 a3 11 80 	movl   $0x8011a380,(%esp)
8010639b:	e8 b0 ea ff ff       	call   80104e50 <release>
801063a0:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801063a3:	eb b6                	jmp    8010635b <trap+0x10b>
    kbdintr();
801063a5:	e8 06 c4 ff ff       	call   801027b0 <kbdintr>
    lapiceoi();
801063aa:	e8 41 c5 ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063af:	e8 7c d5 ff ff       	call   80103930 <myproc>
801063b4:	85 c0                	test   %eax,%eax
801063b6:	0f 85 37 ff ff ff    	jne    801062f3 <trap+0xa3>
801063bc:	e9 4f ff ff ff       	jmp    80106310 <trap+0xc0>
    uartintr();
801063c1:	e8 4a 02 00 00       	call   80106610 <uartintr>
    lapiceoi();
801063c6:	e8 25 c5 ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063cb:	e8 60 d5 ff ff       	call   80103930 <myproc>
801063d0:	85 c0                	test   %eax,%eax
801063d2:	0f 85 1b ff ff ff    	jne    801062f3 <trap+0xa3>
801063d8:	e9 33 ff ff ff       	jmp    80106310 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801063dd:	8b 7b 38             	mov    0x38(%ebx),%edi
801063e0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801063e4:	e8 27 d5 ff ff       	call   80103910 <cpuid>
801063e9:	57                   	push   %edi
801063ea:	56                   	push   %esi
801063eb:	50                   	push   %eax
801063ec:	68 f0 82 10 80       	push   $0x801082f0
801063f1:	e8 ba a2 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801063f6:	e8 f5 c4 ff ff       	call   801028f0 <lapiceoi>
    break;
801063fb:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063fe:	e8 2d d5 ff ff       	call   80103930 <myproc>
80106403:	85 c0                	test   %eax,%eax
80106405:	0f 85 e8 fe ff ff    	jne    801062f3 <trap+0xa3>
8010640b:	e9 00 ff ff ff       	jmp    80106310 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80106410:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106414:	0f 85 0e ff ff ff    	jne    80106328 <trap+0xd8>
    yield();
8010641a:	e8 f1 df ff ff       	call   80104410 <yield>
8010641f:	e9 04 ff ff ff       	jmp    80106328 <trap+0xd8>
80106424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106428:	e8 03 d5 ff ff       	call   80103930 <myproc>
8010642d:	8b 70 24             	mov    0x24(%eax),%esi
80106430:	85 f6                	test   %esi,%esi
80106432:	75 3c                	jne    80106470 <trap+0x220>
    myproc()->tf = tf;
80106434:	e8 f7 d4 ff ff       	call   80103930 <myproc>
80106439:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010643c:	e8 2f ee ff ff       	call   80105270 <syscall>
    if(myproc()->killed)
80106441:	e8 ea d4 ff ff       	call   80103930 <myproc>
80106446:	8b 48 24             	mov    0x24(%eax),%ecx
80106449:	85 c9                	test   %ecx,%ecx
8010644b:	0f 84 fd fe ff ff    	je     8010634e <trap+0xfe>
}
80106451:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106454:	5b                   	pop    %ebx
80106455:	5e                   	pop    %esi
80106456:	5f                   	pop    %edi
80106457:	5d                   	pop    %ebp
      exit();
80106458:	e9 43 dc ff ff       	jmp    801040a0 <exit>
8010645d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106460:	e8 3b dc ff ff       	call   801040a0 <exit>
80106465:	e9 a6 fe ff ff       	jmp    80106310 <trap+0xc0>
8010646a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106470:	e8 2b dc ff ff       	call   801040a0 <exit>
80106475:	eb bd                	jmp    80106434 <trap+0x1e4>
80106477:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010647a:	e8 91 d4 ff ff       	call   80103910 <cpuid>
8010647f:	83 ec 0c             	sub    $0xc,%esp
80106482:	56                   	push   %esi
80106483:	57                   	push   %edi
80106484:	50                   	push   %eax
80106485:	ff 73 30             	pushl  0x30(%ebx)
80106488:	68 14 83 10 80       	push   $0x80108314
8010648d:	e8 1e a2 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106492:	83 c4 14             	add    $0x14,%esp
80106495:	68 ea 82 10 80       	push   $0x801082ea
8010649a:	e8 f1 9e ff ff       	call   80100390 <panic>
8010649f:	90                   	nop

801064a0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801064a0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801064a4:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
801064a9:	85 c0                	test   %eax,%eax
801064ab:	74 1b                	je     801064c8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064ad:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064b2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801064b3:	a8 01                	test   $0x1,%al
801064b5:	74 11                	je     801064c8 <uartgetc+0x28>
801064b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064bc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801064bd:	0f b6 c0             	movzbl %al,%eax
801064c0:	c3                   	ret    
801064c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801064c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064cd:	c3                   	ret    
801064ce:	66 90                	xchg   %ax,%ax

801064d0 <uartputc.part.0>:
uartputc(int c)
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	57                   	push   %edi
801064d4:	89 c7                	mov    %eax,%edi
801064d6:	56                   	push   %esi
801064d7:	be fd 03 00 00       	mov    $0x3fd,%esi
801064dc:	53                   	push   %ebx
801064dd:	bb 80 00 00 00       	mov    $0x80,%ebx
801064e2:	83 ec 0c             	sub    $0xc,%esp
801064e5:	eb 1b                	jmp    80106502 <uartputc.part.0+0x32>
801064e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ee:	66 90                	xchg   %ax,%ax
    microdelay(10);
801064f0:	83 ec 0c             	sub    $0xc,%esp
801064f3:	6a 0a                	push   $0xa
801064f5:	e8 16 c4 ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064fa:	83 c4 10             	add    $0x10,%esp
801064fd:	83 eb 01             	sub    $0x1,%ebx
80106500:	74 07                	je     80106509 <uartputc.part.0+0x39>
80106502:	89 f2                	mov    %esi,%edx
80106504:	ec                   	in     (%dx),%al
80106505:	a8 20                	test   $0x20,%al
80106507:	74 e7                	je     801064f0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106509:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010650e:	89 f8                	mov    %edi,%eax
80106510:	ee                   	out    %al,(%dx)
}
80106511:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106514:	5b                   	pop    %ebx
80106515:	5e                   	pop    %esi
80106516:	5f                   	pop    %edi
80106517:	5d                   	pop    %ebp
80106518:	c3                   	ret    
80106519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106520 <uartinit>:
{
80106520:	f3 0f 1e fb          	endbr32 
80106524:	55                   	push   %ebp
80106525:	31 c9                	xor    %ecx,%ecx
80106527:	89 c8                	mov    %ecx,%eax
80106529:	89 e5                	mov    %esp,%ebp
8010652b:	57                   	push   %edi
8010652c:	56                   	push   %esi
8010652d:	53                   	push   %ebx
8010652e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106533:	89 da                	mov    %ebx,%edx
80106535:	83 ec 0c             	sub    $0xc,%esp
80106538:	ee                   	out    %al,(%dx)
80106539:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010653e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106543:	89 fa                	mov    %edi,%edx
80106545:	ee                   	out    %al,(%dx)
80106546:	b8 0c 00 00 00       	mov    $0xc,%eax
8010654b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106550:	ee                   	out    %al,(%dx)
80106551:	be f9 03 00 00       	mov    $0x3f9,%esi
80106556:	89 c8                	mov    %ecx,%eax
80106558:	89 f2                	mov    %esi,%edx
8010655a:	ee                   	out    %al,(%dx)
8010655b:	b8 03 00 00 00       	mov    $0x3,%eax
80106560:	89 fa                	mov    %edi,%edx
80106562:	ee                   	out    %al,(%dx)
80106563:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106568:	89 c8                	mov    %ecx,%eax
8010656a:	ee                   	out    %al,(%dx)
8010656b:	b8 01 00 00 00       	mov    $0x1,%eax
80106570:	89 f2                	mov    %esi,%edx
80106572:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106573:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106578:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106579:	3c ff                	cmp    $0xff,%al
8010657b:	74 52                	je     801065cf <uartinit+0xaf>
  uart = 1;
8010657d:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
80106584:	00 00 00 
80106587:	89 da                	mov    %ebx,%edx
80106589:	ec                   	in     (%dx),%al
8010658a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010658f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106590:	83 ec 08             	sub    $0x8,%esp
80106593:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106598:	bb 0c 84 10 80       	mov    $0x8010840c,%ebx
  ioapicenable(IRQ_COM1, 0);
8010659d:	6a 00                	push   $0x0
8010659f:	6a 04                	push   $0x4
801065a1:	e8 ba be ff ff       	call   80102460 <ioapicenable>
801065a6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801065a9:	b8 78 00 00 00       	mov    $0x78,%eax
801065ae:	eb 04                	jmp    801065b4 <uartinit+0x94>
801065b0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
801065b4:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
801065ba:	85 d2                	test   %edx,%edx
801065bc:	74 08                	je     801065c6 <uartinit+0xa6>
    uartputc(*p);
801065be:	0f be c0             	movsbl %al,%eax
801065c1:	e8 0a ff ff ff       	call   801064d0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801065c6:	89 f0                	mov    %esi,%eax
801065c8:	83 c3 01             	add    $0x1,%ebx
801065cb:	84 c0                	test   %al,%al
801065cd:	75 e1                	jne    801065b0 <uartinit+0x90>
}
801065cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065d2:	5b                   	pop    %ebx
801065d3:	5e                   	pop    %esi
801065d4:	5f                   	pop    %edi
801065d5:	5d                   	pop    %ebp
801065d6:	c3                   	ret    
801065d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065de:	66 90                	xchg   %ax,%ax

801065e0 <uartputc>:
{
801065e0:	f3 0f 1e fb          	endbr32 
801065e4:	55                   	push   %ebp
  if(!uart)
801065e5:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
{
801065eb:	89 e5                	mov    %esp,%ebp
801065ed:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801065f0:	85 d2                	test   %edx,%edx
801065f2:	74 0c                	je     80106600 <uartputc+0x20>
}
801065f4:	5d                   	pop    %ebp
801065f5:	e9 d6 fe ff ff       	jmp    801064d0 <uartputc.part.0>
801065fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106600:	5d                   	pop    %ebp
80106601:	c3                   	ret    
80106602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106610 <uartintr>:

void
uartintr(void)
{
80106610:	f3 0f 1e fb          	endbr32 
80106614:	55                   	push   %ebp
80106615:	89 e5                	mov    %esp,%ebp
80106617:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010661a:	68 a0 64 10 80       	push   $0x801064a0
8010661f:	e8 3c a2 ff ff       	call   80100860 <consoleintr>
}
80106624:	83 c4 10             	add    $0x10,%esp
80106627:	c9                   	leave  
80106628:	c3                   	ret    

80106629 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106629:	6a 00                	push   $0x0
  pushl $0
8010662b:	6a 00                	push   $0x0
  jmp alltraps
8010662d:	e9 41 fb ff ff       	jmp    80106173 <alltraps>

80106632 <vector1>:
.globl vector1
vector1:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $1
80106634:	6a 01                	push   $0x1
  jmp alltraps
80106636:	e9 38 fb ff ff       	jmp    80106173 <alltraps>

8010663b <vector2>:
.globl vector2
vector2:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $2
8010663d:	6a 02                	push   $0x2
  jmp alltraps
8010663f:	e9 2f fb ff ff       	jmp    80106173 <alltraps>

80106644 <vector3>:
.globl vector3
vector3:
  pushl $0
80106644:	6a 00                	push   $0x0
  pushl $3
80106646:	6a 03                	push   $0x3
  jmp alltraps
80106648:	e9 26 fb ff ff       	jmp    80106173 <alltraps>

8010664d <vector4>:
.globl vector4
vector4:
  pushl $0
8010664d:	6a 00                	push   $0x0
  pushl $4
8010664f:	6a 04                	push   $0x4
  jmp alltraps
80106651:	e9 1d fb ff ff       	jmp    80106173 <alltraps>

80106656 <vector5>:
.globl vector5
vector5:
  pushl $0
80106656:	6a 00                	push   $0x0
  pushl $5
80106658:	6a 05                	push   $0x5
  jmp alltraps
8010665a:	e9 14 fb ff ff       	jmp    80106173 <alltraps>

8010665f <vector6>:
.globl vector6
vector6:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $6
80106661:	6a 06                	push   $0x6
  jmp alltraps
80106663:	e9 0b fb ff ff       	jmp    80106173 <alltraps>

80106668 <vector7>:
.globl vector7
vector7:
  pushl $0
80106668:	6a 00                	push   $0x0
  pushl $7
8010666a:	6a 07                	push   $0x7
  jmp alltraps
8010666c:	e9 02 fb ff ff       	jmp    80106173 <alltraps>

80106671 <vector8>:
.globl vector8
vector8:
  pushl $8
80106671:	6a 08                	push   $0x8
  jmp alltraps
80106673:	e9 fb fa ff ff       	jmp    80106173 <alltraps>

80106678 <vector9>:
.globl vector9
vector9:
  pushl $0
80106678:	6a 00                	push   $0x0
  pushl $9
8010667a:	6a 09                	push   $0x9
  jmp alltraps
8010667c:	e9 f2 fa ff ff       	jmp    80106173 <alltraps>

80106681 <vector10>:
.globl vector10
vector10:
  pushl $10
80106681:	6a 0a                	push   $0xa
  jmp alltraps
80106683:	e9 eb fa ff ff       	jmp    80106173 <alltraps>

80106688 <vector11>:
.globl vector11
vector11:
  pushl $11
80106688:	6a 0b                	push   $0xb
  jmp alltraps
8010668a:	e9 e4 fa ff ff       	jmp    80106173 <alltraps>

8010668f <vector12>:
.globl vector12
vector12:
  pushl $12
8010668f:	6a 0c                	push   $0xc
  jmp alltraps
80106691:	e9 dd fa ff ff       	jmp    80106173 <alltraps>

80106696 <vector13>:
.globl vector13
vector13:
  pushl $13
80106696:	6a 0d                	push   $0xd
  jmp alltraps
80106698:	e9 d6 fa ff ff       	jmp    80106173 <alltraps>

8010669d <vector14>:
.globl vector14
vector14:
  pushl $14
8010669d:	6a 0e                	push   $0xe
  jmp alltraps
8010669f:	e9 cf fa ff ff       	jmp    80106173 <alltraps>

801066a4 <vector15>:
.globl vector15
vector15:
  pushl $0
801066a4:	6a 00                	push   $0x0
  pushl $15
801066a6:	6a 0f                	push   $0xf
  jmp alltraps
801066a8:	e9 c6 fa ff ff       	jmp    80106173 <alltraps>

801066ad <vector16>:
.globl vector16
vector16:
  pushl $0
801066ad:	6a 00                	push   $0x0
  pushl $16
801066af:	6a 10                	push   $0x10
  jmp alltraps
801066b1:	e9 bd fa ff ff       	jmp    80106173 <alltraps>

801066b6 <vector17>:
.globl vector17
vector17:
  pushl $17
801066b6:	6a 11                	push   $0x11
  jmp alltraps
801066b8:	e9 b6 fa ff ff       	jmp    80106173 <alltraps>

801066bd <vector18>:
.globl vector18
vector18:
  pushl $0
801066bd:	6a 00                	push   $0x0
  pushl $18
801066bf:	6a 12                	push   $0x12
  jmp alltraps
801066c1:	e9 ad fa ff ff       	jmp    80106173 <alltraps>

801066c6 <vector19>:
.globl vector19
vector19:
  pushl $0
801066c6:	6a 00                	push   $0x0
  pushl $19
801066c8:	6a 13                	push   $0x13
  jmp alltraps
801066ca:	e9 a4 fa ff ff       	jmp    80106173 <alltraps>

801066cf <vector20>:
.globl vector20
vector20:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $20
801066d1:	6a 14                	push   $0x14
  jmp alltraps
801066d3:	e9 9b fa ff ff       	jmp    80106173 <alltraps>

801066d8 <vector21>:
.globl vector21
vector21:
  pushl $0
801066d8:	6a 00                	push   $0x0
  pushl $21
801066da:	6a 15                	push   $0x15
  jmp alltraps
801066dc:	e9 92 fa ff ff       	jmp    80106173 <alltraps>

801066e1 <vector22>:
.globl vector22
vector22:
  pushl $0
801066e1:	6a 00                	push   $0x0
  pushl $22
801066e3:	6a 16                	push   $0x16
  jmp alltraps
801066e5:	e9 89 fa ff ff       	jmp    80106173 <alltraps>

801066ea <vector23>:
.globl vector23
vector23:
  pushl $0
801066ea:	6a 00                	push   $0x0
  pushl $23
801066ec:	6a 17                	push   $0x17
  jmp alltraps
801066ee:	e9 80 fa ff ff       	jmp    80106173 <alltraps>

801066f3 <vector24>:
.globl vector24
vector24:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $24
801066f5:	6a 18                	push   $0x18
  jmp alltraps
801066f7:	e9 77 fa ff ff       	jmp    80106173 <alltraps>

801066fc <vector25>:
.globl vector25
vector25:
  pushl $0
801066fc:	6a 00                	push   $0x0
  pushl $25
801066fe:	6a 19                	push   $0x19
  jmp alltraps
80106700:	e9 6e fa ff ff       	jmp    80106173 <alltraps>

80106705 <vector26>:
.globl vector26
vector26:
  pushl $0
80106705:	6a 00                	push   $0x0
  pushl $26
80106707:	6a 1a                	push   $0x1a
  jmp alltraps
80106709:	e9 65 fa ff ff       	jmp    80106173 <alltraps>

8010670e <vector27>:
.globl vector27
vector27:
  pushl $0
8010670e:	6a 00                	push   $0x0
  pushl $27
80106710:	6a 1b                	push   $0x1b
  jmp alltraps
80106712:	e9 5c fa ff ff       	jmp    80106173 <alltraps>

80106717 <vector28>:
.globl vector28
vector28:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $28
80106719:	6a 1c                	push   $0x1c
  jmp alltraps
8010671b:	e9 53 fa ff ff       	jmp    80106173 <alltraps>

80106720 <vector29>:
.globl vector29
vector29:
  pushl $0
80106720:	6a 00                	push   $0x0
  pushl $29
80106722:	6a 1d                	push   $0x1d
  jmp alltraps
80106724:	e9 4a fa ff ff       	jmp    80106173 <alltraps>

80106729 <vector30>:
.globl vector30
vector30:
  pushl $0
80106729:	6a 00                	push   $0x0
  pushl $30
8010672b:	6a 1e                	push   $0x1e
  jmp alltraps
8010672d:	e9 41 fa ff ff       	jmp    80106173 <alltraps>

80106732 <vector31>:
.globl vector31
vector31:
  pushl $0
80106732:	6a 00                	push   $0x0
  pushl $31
80106734:	6a 1f                	push   $0x1f
  jmp alltraps
80106736:	e9 38 fa ff ff       	jmp    80106173 <alltraps>

8010673b <vector32>:
.globl vector32
vector32:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $32
8010673d:	6a 20                	push   $0x20
  jmp alltraps
8010673f:	e9 2f fa ff ff       	jmp    80106173 <alltraps>

80106744 <vector33>:
.globl vector33
vector33:
  pushl $0
80106744:	6a 00                	push   $0x0
  pushl $33
80106746:	6a 21                	push   $0x21
  jmp alltraps
80106748:	e9 26 fa ff ff       	jmp    80106173 <alltraps>

8010674d <vector34>:
.globl vector34
vector34:
  pushl $0
8010674d:	6a 00                	push   $0x0
  pushl $34
8010674f:	6a 22                	push   $0x22
  jmp alltraps
80106751:	e9 1d fa ff ff       	jmp    80106173 <alltraps>

80106756 <vector35>:
.globl vector35
vector35:
  pushl $0
80106756:	6a 00                	push   $0x0
  pushl $35
80106758:	6a 23                	push   $0x23
  jmp alltraps
8010675a:	e9 14 fa ff ff       	jmp    80106173 <alltraps>

8010675f <vector36>:
.globl vector36
vector36:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $36
80106761:	6a 24                	push   $0x24
  jmp alltraps
80106763:	e9 0b fa ff ff       	jmp    80106173 <alltraps>

80106768 <vector37>:
.globl vector37
vector37:
  pushl $0
80106768:	6a 00                	push   $0x0
  pushl $37
8010676a:	6a 25                	push   $0x25
  jmp alltraps
8010676c:	e9 02 fa ff ff       	jmp    80106173 <alltraps>

80106771 <vector38>:
.globl vector38
vector38:
  pushl $0
80106771:	6a 00                	push   $0x0
  pushl $38
80106773:	6a 26                	push   $0x26
  jmp alltraps
80106775:	e9 f9 f9 ff ff       	jmp    80106173 <alltraps>

8010677a <vector39>:
.globl vector39
vector39:
  pushl $0
8010677a:	6a 00                	push   $0x0
  pushl $39
8010677c:	6a 27                	push   $0x27
  jmp alltraps
8010677e:	e9 f0 f9 ff ff       	jmp    80106173 <alltraps>

80106783 <vector40>:
.globl vector40
vector40:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $40
80106785:	6a 28                	push   $0x28
  jmp alltraps
80106787:	e9 e7 f9 ff ff       	jmp    80106173 <alltraps>

8010678c <vector41>:
.globl vector41
vector41:
  pushl $0
8010678c:	6a 00                	push   $0x0
  pushl $41
8010678e:	6a 29                	push   $0x29
  jmp alltraps
80106790:	e9 de f9 ff ff       	jmp    80106173 <alltraps>

80106795 <vector42>:
.globl vector42
vector42:
  pushl $0
80106795:	6a 00                	push   $0x0
  pushl $42
80106797:	6a 2a                	push   $0x2a
  jmp alltraps
80106799:	e9 d5 f9 ff ff       	jmp    80106173 <alltraps>

8010679e <vector43>:
.globl vector43
vector43:
  pushl $0
8010679e:	6a 00                	push   $0x0
  pushl $43
801067a0:	6a 2b                	push   $0x2b
  jmp alltraps
801067a2:	e9 cc f9 ff ff       	jmp    80106173 <alltraps>

801067a7 <vector44>:
.globl vector44
vector44:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $44
801067a9:	6a 2c                	push   $0x2c
  jmp alltraps
801067ab:	e9 c3 f9 ff ff       	jmp    80106173 <alltraps>

801067b0 <vector45>:
.globl vector45
vector45:
  pushl $0
801067b0:	6a 00                	push   $0x0
  pushl $45
801067b2:	6a 2d                	push   $0x2d
  jmp alltraps
801067b4:	e9 ba f9 ff ff       	jmp    80106173 <alltraps>

801067b9 <vector46>:
.globl vector46
vector46:
  pushl $0
801067b9:	6a 00                	push   $0x0
  pushl $46
801067bb:	6a 2e                	push   $0x2e
  jmp alltraps
801067bd:	e9 b1 f9 ff ff       	jmp    80106173 <alltraps>

801067c2 <vector47>:
.globl vector47
vector47:
  pushl $0
801067c2:	6a 00                	push   $0x0
  pushl $47
801067c4:	6a 2f                	push   $0x2f
  jmp alltraps
801067c6:	e9 a8 f9 ff ff       	jmp    80106173 <alltraps>

801067cb <vector48>:
.globl vector48
vector48:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $48
801067cd:	6a 30                	push   $0x30
  jmp alltraps
801067cf:	e9 9f f9 ff ff       	jmp    80106173 <alltraps>

801067d4 <vector49>:
.globl vector49
vector49:
  pushl $0
801067d4:	6a 00                	push   $0x0
  pushl $49
801067d6:	6a 31                	push   $0x31
  jmp alltraps
801067d8:	e9 96 f9 ff ff       	jmp    80106173 <alltraps>

801067dd <vector50>:
.globl vector50
vector50:
  pushl $0
801067dd:	6a 00                	push   $0x0
  pushl $50
801067df:	6a 32                	push   $0x32
  jmp alltraps
801067e1:	e9 8d f9 ff ff       	jmp    80106173 <alltraps>

801067e6 <vector51>:
.globl vector51
vector51:
  pushl $0
801067e6:	6a 00                	push   $0x0
  pushl $51
801067e8:	6a 33                	push   $0x33
  jmp alltraps
801067ea:	e9 84 f9 ff ff       	jmp    80106173 <alltraps>

801067ef <vector52>:
.globl vector52
vector52:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $52
801067f1:	6a 34                	push   $0x34
  jmp alltraps
801067f3:	e9 7b f9 ff ff       	jmp    80106173 <alltraps>

801067f8 <vector53>:
.globl vector53
vector53:
  pushl $0
801067f8:	6a 00                	push   $0x0
  pushl $53
801067fa:	6a 35                	push   $0x35
  jmp alltraps
801067fc:	e9 72 f9 ff ff       	jmp    80106173 <alltraps>

80106801 <vector54>:
.globl vector54
vector54:
  pushl $0
80106801:	6a 00                	push   $0x0
  pushl $54
80106803:	6a 36                	push   $0x36
  jmp alltraps
80106805:	e9 69 f9 ff ff       	jmp    80106173 <alltraps>

8010680a <vector55>:
.globl vector55
vector55:
  pushl $0
8010680a:	6a 00                	push   $0x0
  pushl $55
8010680c:	6a 37                	push   $0x37
  jmp alltraps
8010680e:	e9 60 f9 ff ff       	jmp    80106173 <alltraps>

80106813 <vector56>:
.globl vector56
vector56:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $56
80106815:	6a 38                	push   $0x38
  jmp alltraps
80106817:	e9 57 f9 ff ff       	jmp    80106173 <alltraps>

8010681c <vector57>:
.globl vector57
vector57:
  pushl $0
8010681c:	6a 00                	push   $0x0
  pushl $57
8010681e:	6a 39                	push   $0x39
  jmp alltraps
80106820:	e9 4e f9 ff ff       	jmp    80106173 <alltraps>

80106825 <vector58>:
.globl vector58
vector58:
  pushl $0
80106825:	6a 00                	push   $0x0
  pushl $58
80106827:	6a 3a                	push   $0x3a
  jmp alltraps
80106829:	e9 45 f9 ff ff       	jmp    80106173 <alltraps>

8010682e <vector59>:
.globl vector59
vector59:
  pushl $0
8010682e:	6a 00                	push   $0x0
  pushl $59
80106830:	6a 3b                	push   $0x3b
  jmp alltraps
80106832:	e9 3c f9 ff ff       	jmp    80106173 <alltraps>

80106837 <vector60>:
.globl vector60
vector60:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $60
80106839:	6a 3c                	push   $0x3c
  jmp alltraps
8010683b:	e9 33 f9 ff ff       	jmp    80106173 <alltraps>

80106840 <vector61>:
.globl vector61
vector61:
  pushl $0
80106840:	6a 00                	push   $0x0
  pushl $61
80106842:	6a 3d                	push   $0x3d
  jmp alltraps
80106844:	e9 2a f9 ff ff       	jmp    80106173 <alltraps>

80106849 <vector62>:
.globl vector62
vector62:
  pushl $0
80106849:	6a 00                	push   $0x0
  pushl $62
8010684b:	6a 3e                	push   $0x3e
  jmp alltraps
8010684d:	e9 21 f9 ff ff       	jmp    80106173 <alltraps>

80106852 <vector63>:
.globl vector63
vector63:
  pushl $0
80106852:	6a 00                	push   $0x0
  pushl $63
80106854:	6a 3f                	push   $0x3f
  jmp alltraps
80106856:	e9 18 f9 ff ff       	jmp    80106173 <alltraps>

8010685b <vector64>:
.globl vector64
vector64:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $64
8010685d:	6a 40                	push   $0x40
  jmp alltraps
8010685f:	e9 0f f9 ff ff       	jmp    80106173 <alltraps>

80106864 <vector65>:
.globl vector65
vector65:
  pushl $0
80106864:	6a 00                	push   $0x0
  pushl $65
80106866:	6a 41                	push   $0x41
  jmp alltraps
80106868:	e9 06 f9 ff ff       	jmp    80106173 <alltraps>

8010686d <vector66>:
.globl vector66
vector66:
  pushl $0
8010686d:	6a 00                	push   $0x0
  pushl $66
8010686f:	6a 42                	push   $0x42
  jmp alltraps
80106871:	e9 fd f8 ff ff       	jmp    80106173 <alltraps>

80106876 <vector67>:
.globl vector67
vector67:
  pushl $0
80106876:	6a 00                	push   $0x0
  pushl $67
80106878:	6a 43                	push   $0x43
  jmp alltraps
8010687a:	e9 f4 f8 ff ff       	jmp    80106173 <alltraps>

8010687f <vector68>:
.globl vector68
vector68:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $68
80106881:	6a 44                	push   $0x44
  jmp alltraps
80106883:	e9 eb f8 ff ff       	jmp    80106173 <alltraps>

80106888 <vector69>:
.globl vector69
vector69:
  pushl $0
80106888:	6a 00                	push   $0x0
  pushl $69
8010688a:	6a 45                	push   $0x45
  jmp alltraps
8010688c:	e9 e2 f8 ff ff       	jmp    80106173 <alltraps>

80106891 <vector70>:
.globl vector70
vector70:
  pushl $0
80106891:	6a 00                	push   $0x0
  pushl $70
80106893:	6a 46                	push   $0x46
  jmp alltraps
80106895:	e9 d9 f8 ff ff       	jmp    80106173 <alltraps>

8010689a <vector71>:
.globl vector71
vector71:
  pushl $0
8010689a:	6a 00                	push   $0x0
  pushl $71
8010689c:	6a 47                	push   $0x47
  jmp alltraps
8010689e:	e9 d0 f8 ff ff       	jmp    80106173 <alltraps>

801068a3 <vector72>:
.globl vector72
vector72:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $72
801068a5:	6a 48                	push   $0x48
  jmp alltraps
801068a7:	e9 c7 f8 ff ff       	jmp    80106173 <alltraps>

801068ac <vector73>:
.globl vector73
vector73:
  pushl $0
801068ac:	6a 00                	push   $0x0
  pushl $73
801068ae:	6a 49                	push   $0x49
  jmp alltraps
801068b0:	e9 be f8 ff ff       	jmp    80106173 <alltraps>

801068b5 <vector74>:
.globl vector74
vector74:
  pushl $0
801068b5:	6a 00                	push   $0x0
  pushl $74
801068b7:	6a 4a                	push   $0x4a
  jmp alltraps
801068b9:	e9 b5 f8 ff ff       	jmp    80106173 <alltraps>

801068be <vector75>:
.globl vector75
vector75:
  pushl $0
801068be:	6a 00                	push   $0x0
  pushl $75
801068c0:	6a 4b                	push   $0x4b
  jmp alltraps
801068c2:	e9 ac f8 ff ff       	jmp    80106173 <alltraps>

801068c7 <vector76>:
.globl vector76
vector76:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $76
801068c9:	6a 4c                	push   $0x4c
  jmp alltraps
801068cb:	e9 a3 f8 ff ff       	jmp    80106173 <alltraps>

801068d0 <vector77>:
.globl vector77
vector77:
  pushl $0
801068d0:	6a 00                	push   $0x0
  pushl $77
801068d2:	6a 4d                	push   $0x4d
  jmp alltraps
801068d4:	e9 9a f8 ff ff       	jmp    80106173 <alltraps>

801068d9 <vector78>:
.globl vector78
vector78:
  pushl $0
801068d9:	6a 00                	push   $0x0
  pushl $78
801068db:	6a 4e                	push   $0x4e
  jmp alltraps
801068dd:	e9 91 f8 ff ff       	jmp    80106173 <alltraps>

801068e2 <vector79>:
.globl vector79
vector79:
  pushl $0
801068e2:	6a 00                	push   $0x0
  pushl $79
801068e4:	6a 4f                	push   $0x4f
  jmp alltraps
801068e6:	e9 88 f8 ff ff       	jmp    80106173 <alltraps>

801068eb <vector80>:
.globl vector80
vector80:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $80
801068ed:	6a 50                	push   $0x50
  jmp alltraps
801068ef:	e9 7f f8 ff ff       	jmp    80106173 <alltraps>

801068f4 <vector81>:
.globl vector81
vector81:
  pushl $0
801068f4:	6a 00                	push   $0x0
  pushl $81
801068f6:	6a 51                	push   $0x51
  jmp alltraps
801068f8:	e9 76 f8 ff ff       	jmp    80106173 <alltraps>

801068fd <vector82>:
.globl vector82
vector82:
  pushl $0
801068fd:	6a 00                	push   $0x0
  pushl $82
801068ff:	6a 52                	push   $0x52
  jmp alltraps
80106901:	e9 6d f8 ff ff       	jmp    80106173 <alltraps>

80106906 <vector83>:
.globl vector83
vector83:
  pushl $0
80106906:	6a 00                	push   $0x0
  pushl $83
80106908:	6a 53                	push   $0x53
  jmp alltraps
8010690a:	e9 64 f8 ff ff       	jmp    80106173 <alltraps>

8010690f <vector84>:
.globl vector84
vector84:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $84
80106911:	6a 54                	push   $0x54
  jmp alltraps
80106913:	e9 5b f8 ff ff       	jmp    80106173 <alltraps>

80106918 <vector85>:
.globl vector85
vector85:
  pushl $0
80106918:	6a 00                	push   $0x0
  pushl $85
8010691a:	6a 55                	push   $0x55
  jmp alltraps
8010691c:	e9 52 f8 ff ff       	jmp    80106173 <alltraps>

80106921 <vector86>:
.globl vector86
vector86:
  pushl $0
80106921:	6a 00                	push   $0x0
  pushl $86
80106923:	6a 56                	push   $0x56
  jmp alltraps
80106925:	e9 49 f8 ff ff       	jmp    80106173 <alltraps>

8010692a <vector87>:
.globl vector87
vector87:
  pushl $0
8010692a:	6a 00                	push   $0x0
  pushl $87
8010692c:	6a 57                	push   $0x57
  jmp alltraps
8010692e:	e9 40 f8 ff ff       	jmp    80106173 <alltraps>

80106933 <vector88>:
.globl vector88
vector88:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $88
80106935:	6a 58                	push   $0x58
  jmp alltraps
80106937:	e9 37 f8 ff ff       	jmp    80106173 <alltraps>

8010693c <vector89>:
.globl vector89
vector89:
  pushl $0
8010693c:	6a 00                	push   $0x0
  pushl $89
8010693e:	6a 59                	push   $0x59
  jmp alltraps
80106940:	e9 2e f8 ff ff       	jmp    80106173 <alltraps>

80106945 <vector90>:
.globl vector90
vector90:
  pushl $0
80106945:	6a 00                	push   $0x0
  pushl $90
80106947:	6a 5a                	push   $0x5a
  jmp alltraps
80106949:	e9 25 f8 ff ff       	jmp    80106173 <alltraps>

8010694e <vector91>:
.globl vector91
vector91:
  pushl $0
8010694e:	6a 00                	push   $0x0
  pushl $91
80106950:	6a 5b                	push   $0x5b
  jmp alltraps
80106952:	e9 1c f8 ff ff       	jmp    80106173 <alltraps>

80106957 <vector92>:
.globl vector92
vector92:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $92
80106959:	6a 5c                	push   $0x5c
  jmp alltraps
8010695b:	e9 13 f8 ff ff       	jmp    80106173 <alltraps>

80106960 <vector93>:
.globl vector93
vector93:
  pushl $0
80106960:	6a 00                	push   $0x0
  pushl $93
80106962:	6a 5d                	push   $0x5d
  jmp alltraps
80106964:	e9 0a f8 ff ff       	jmp    80106173 <alltraps>

80106969 <vector94>:
.globl vector94
vector94:
  pushl $0
80106969:	6a 00                	push   $0x0
  pushl $94
8010696b:	6a 5e                	push   $0x5e
  jmp alltraps
8010696d:	e9 01 f8 ff ff       	jmp    80106173 <alltraps>

80106972 <vector95>:
.globl vector95
vector95:
  pushl $0
80106972:	6a 00                	push   $0x0
  pushl $95
80106974:	6a 5f                	push   $0x5f
  jmp alltraps
80106976:	e9 f8 f7 ff ff       	jmp    80106173 <alltraps>

8010697b <vector96>:
.globl vector96
vector96:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $96
8010697d:	6a 60                	push   $0x60
  jmp alltraps
8010697f:	e9 ef f7 ff ff       	jmp    80106173 <alltraps>

80106984 <vector97>:
.globl vector97
vector97:
  pushl $0
80106984:	6a 00                	push   $0x0
  pushl $97
80106986:	6a 61                	push   $0x61
  jmp alltraps
80106988:	e9 e6 f7 ff ff       	jmp    80106173 <alltraps>

8010698d <vector98>:
.globl vector98
vector98:
  pushl $0
8010698d:	6a 00                	push   $0x0
  pushl $98
8010698f:	6a 62                	push   $0x62
  jmp alltraps
80106991:	e9 dd f7 ff ff       	jmp    80106173 <alltraps>

80106996 <vector99>:
.globl vector99
vector99:
  pushl $0
80106996:	6a 00                	push   $0x0
  pushl $99
80106998:	6a 63                	push   $0x63
  jmp alltraps
8010699a:	e9 d4 f7 ff ff       	jmp    80106173 <alltraps>

8010699f <vector100>:
.globl vector100
vector100:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $100
801069a1:	6a 64                	push   $0x64
  jmp alltraps
801069a3:	e9 cb f7 ff ff       	jmp    80106173 <alltraps>

801069a8 <vector101>:
.globl vector101
vector101:
  pushl $0
801069a8:	6a 00                	push   $0x0
  pushl $101
801069aa:	6a 65                	push   $0x65
  jmp alltraps
801069ac:	e9 c2 f7 ff ff       	jmp    80106173 <alltraps>

801069b1 <vector102>:
.globl vector102
vector102:
  pushl $0
801069b1:	6a 00                	push   $0x0
  pushl $102
801069b3:	6a 66                	push   $0x66
  jmp alltraps
801069b5:	e9 b9 f7 ff ff       	jmp    80106173 <alltraps>

801069ba <vector103>:
.globl vector103
vector103:
  pushl $0
801069ba:	6a 00                	push   $0x0
  pushl $103
801069bc:	6a 67                	push   $0x67
  jmp alltraps
801069be:	e9 b0 f7 ff ff       	jmp    80106173 <alltraps>

801069c3 <vector104>:
.globl vector104
vector104:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $104
801069c5:	6a 68                	push   $0x68
  jmp alltraps
801069c7:	e9 a7 f7 ff ff       	jmp    80106173 <alltraps>

801069cc <vector105>:
.globl vector105
vector105:
  pushl $0
801069cc:	6a 00                	push   $0x0
  pushl $105
801069ce:	6a 69                	push   $0x69
  jmp alltraps
801069d0:	e9 9e f7 ff ff       	jmp    80106173 <alltraps>

801069d5 <vector106>:
.globl vector106
vector106:
  pushl $0
801069d5:	6a 00                	push   $0x0
  pushl $106
801069d7:	6a 6a                	push   $0x6a
  jmp alltraps
801069d9:	e9 95 f7 ff ff       	jmp    80106173 <alltraps>

801069de <vector107>:
.globl vector107
vector107:
  pushl $0
801069de:	6a 00                	push   $0x0
  pushl $107
801069e0:	6a 6b                	push   $0x6b
  jmp alltraps
801069e2:	e9 8c f7 ff ff       	jmp    80106173 <alltraps>

801069e7 <vector108>:
.globl vector108
vector108:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $108
801069e9:	6a 6c                	push   $0x6c
  jmp alltraps
801069eb:	e9 83 f7 ff ff       	jmp    80106173 <alltraps>

801069f0 <vector109>:
.globl vector109
vector109:
  pushl $0
801069f0:	6a 00                	push   $0x0
  pushl $109
801069f2:	6a 6d                	push   $0x6d
  jmp alltraps
801069f4:	e9 7a f7 ff ff       	jmp    80106173 <alltraps>

801069f9 <vector110>:
.globl vector110
vector110:
  pushl $0
801069f9:	6a 00                	push   $0x0
  pushl $110
801069fb:	6a 6e                	push   $0x6e
  jmp alltraps
801069fd:	e9 71 f7 ff ff       	jmp    80106173 <alltraps>

80106a02 <vector111>:
.globl vector111
vector111:
  pushl $0
80106a02:	6a 00                	push   $0x0
  pushl $111
80106a04:	6a 6f                	push   $0x6f
  jmp alltraps
80106a06:	e9 68 f7 ff ff       	jmp    80106173 <alltraps>

80106a0b <vector112>:
.globl vector112
vector112:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $112
80106a0d:	6a 70                	push   $0x70
  jmp alltraps
80106a0f:	e9 5f f7 ff ff       	jmp    80106173 <alltraps>

80106a14 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a14:	6a 00                	push   $0x0
  pushl $113
80106a16:	6a 71                	push   $0x71
  jmp alltraps
80106a18:	e9 56 f7 ff ff       	jmp    80106173 <alltraps>

80106a1d <vector114>:
.globl vector114
vector114:
  pushl $0
80106a1d:	6a 00                	push   $0x0
  pushl $114
80106a1f:	6a 72                	push   $0x72
  jmp alltraps
80106a21:	e9 4d f7 ff ff       	jmp    80106173 <alltraps>

80106a26 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a26:	6a 00                	push   $0x0
  pushl $115
80106a28:	6a 73                	push   $0x73
  jmp alltraps
80106a2a:	e9 44 f7 ff ff       	jmp    80106173 <alltraps>

80106a2f <vector116>:
.globl vector116
vector116:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $116
80106a31:	6a 74                	push   $0x74
  jmp alltraps
80106a33:	e9 3b f7 ff ff       	jmp    80106173 <alltraps>

80106a38 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a38:	6a 00                	push   $0x0
  pushl $117
80106a3a:	6a 75                	push   $0x75
  jmp alltraps
80106a3c:	e9 32 f7 ff ff       	jmp    80106173 <alltraps>

80106a41 <vector118>:
.globl vector118
vector118:
  pushl $0
80106a41:	6a 00                	push   $0x0
  pushl $118
80106a43:	6a 76                	push   $0x76
  jmp alltraps
80106a45:	e9 29 f7 ff ff       	jmp    80106173 <alltraps>

80106a4a <vector119>:
.globl vector119
vector119:
  pushl $0
80106a4a:	6a 00                	push   $0x0
  pushl $119
80106a4c:	6a 77                	push   $0x77
  jmp alltraps
80106a4e:	e9 20 f7 ff ff       	jmp    80106173 <alltraps>

80106a53 <vector120>:
.globl vector120
vector120:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $120
80106a55:	6a 78                	push   $0x78
  jmp alltraps
80106a57:	e9 17 f7 ff ff       	jmp    80106173 <alltraps>

80106a5c <vector121>:
.globl vector121
vector121:
  pushl $0
80106a5c:	6a 00                	push   $0x0
  pushl $121
80106a5e:	6a 79                	push   $0x79
  jmp alltraps
80106a60:	e9 0e f7 ff ff       	jmp    80106173 <alltraps>

80106a65 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a65:	6a 00                	push   $0x0
  pushl $122
80106a67:	6a 7a                	push   $0x7a
  jmp alltraps
80106a69:	e9 05 f7 ff ff       	jmp    80106173 <alltraps>

80106a6e <vector123>:
.globl vector123
vector123:
  pushl $0
80106a6e:	6a 00                	push   $0x0
  pushl $123
80106a70:	6a 7b                	push   $0x7b
  jmp alltraps
80106a72:	e9 fc f6 ff ff       	jmp    80106173 <alltraps>

80106a77 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $124
80106a79:	6a 7c                	push   $0x7c
  jmp alltraps
80106a7b:	e9 f3 f6 ff ff       	jmp    80106173 <alltraps>

80106a80 <vector125>:
.globl vector125
vector125:
  pushl $0
80106a80:	6a 00                	push   $0x0
  pushl $125
80106a82:	6a 7d                	push   $0x7d
  jmp alltraps
80106a84:	e9 ea f6 ff ff       	jmp    80106173 <alltraps>

80106a89 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a89:	6a 00                	push   $0x0
  pushl $126
80106a8b:	6a 7e                	push   $0x7e
  jmp alltraps
80106a8d:	e9 e1 f6 ff ff       	jmp    80106173 <alltraps>

80106a92 <vector127>:
.globl vector127
vector127:
  pushl $0
80106a92:	6a 00                	push   $0x0
  pushl $127
80106a94:	6a 7f                	push   $0x7f
  jmp alltraps
80106a96:	e9 d8 f6 ff ff       	jmp    80106173 <alltraps>

80106a9b <vector128>:
.globl vector128
vector128:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $128
80106a9d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106aa2:	e9 cc f6 ff ff       	jmp    80106173 <alltraps>

80106aa7 <vector129>:
.globl vector129
vector129:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $129
80106aa9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106aae:	e9 c0 f6 ff ff       	jmp    80106173 <alltraps>

80106ab3 <vector130>:
.globl vector130
vector130:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $130
80106ab5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106aba:	e9 b4 f6 ff ff       	jmp    80106173 <alltraps>

80106abf <vector131>:
.globl vector131
vector131:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $131
80106ac1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ac6:	e9 a8 f6 ff ff       	jmp    80106173 <alltraps>

80106acb <vector132>:
.globl vector132
vector132:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $132
80106acd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ad2:	e9 9c f6 ff ff       	jmp    80106173 <alltraps>

80106ad7 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $133
80106ad9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106ade:	e9 90 f6 ff ff       	jmp    80106173 <alltraps>

80106ae3 <vector134>:
.globl vector134
vector134:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $134
80106ae5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106aea:	e9 84 f6 ff ff       	jmp    80106173 <alltraps>

80106aef <vector135>:
.globl vector135
vector135:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $135
80106af1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106af6:	e9 78 f6 ff ff       	jmp    80106173 <alltraps>

80106afb <vector136>:
.globl vector136
vector136:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $136
80106afd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b02:	e9 6c f6 ff ff       	jmp    80106173 <alltraps>

80106b07 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $137
80106b09:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b0e:	e9 60 f6 ff ff       	jmp    80106173 <alltraps>

80106b13 <vector138>:
.globl vector138
vector138:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $138
80106b15:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b1a:	e9 54 f6 ff ff       	jmp    80106173 <alltraps>

80106b1f <vector139>:
.globl vector139
vector139:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $139
80106b21:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b26:	e9 48 f6 ff ff       	jmp    80106173 <alltraps>

80106b2b <vector140>:
.globl vector140
vector140:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $140
80106b2d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b32:	e9 3c f6 ff ff       	jmp    80106173 <alltraps>

80106b37 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $141
80106b39:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b3e:	e9 30 f6 ff ff       	jmp    80106173 <alltraps>

80106b43 <vector142>:
.globl vector142
vector142:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $142
80106b45:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b4a:	e9 24 f6 ff ff       	jmp    80106173 <alltraps>

80106b4f <vector143>:
.globl vector143
vector143:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $143
80106b51:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b56:	e9 18 f6 ff ff       	jmp    80106173 <alltraps>

80106b5b <vector144>:
.globl vector144
vector144:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $144
80106b5d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b62:	e9 0c f6 ff ff       	jmp    80106173 <alltraps>

80106b67 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $145
80106b69:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b6e:	e9 00 f6 ff ff       	jmp    80106173 <alltraps>

80106b73 <vector146>:
.globl vector146
vector146:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $146
80106b75:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b7a:	e9 f4 f5 ff ff       	jmp    80106173 <alltraps>

80106b7f <vector147>:
.globl vector147
vector147:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $147
80106b81:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b86:	e9 e8 f5 ff ff       	jmp    80106173 <alltraps>

80106b8b <vector148>:
.globl vector148
vector148:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $148
80106b8d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b92:	e9 dc f5 ff ff       	jmp    80106173 <alltraps>

80106b97 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $149
80106b99:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b9e:	e9 d0 f5 ff ff       	jmp    80106173 <alltraps>

80106ba3 <vector150>:
.globl vector150
vector150:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $150
80106ba5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106baa:	e9 c4 f5 ff ff       	jmp    80106173 <alltraps>

80106baf <vector151>:
.globl vector151
vector151:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $151
80106bb1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106bb6:	e9 b8 f5 ff ff       	jmp    80106173 <alltraps>

80106bbb <vector152>:
.globl vector152
vector152:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $152
80106bbd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106bc2:	e9 ac f5 ff ff       	jmp    80106173 <alltraps>

80106bc7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $153
80106bc9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106bce:	e9 a0 f5 ff ff       	jmp    80106173 <alltraps>

80106bd3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $154
80106bd5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106bda:	e9 94 f5 ff ff       	jmp    80106173 <alltraps>

80106bdf <vector155>:
.globl vector155
vector155:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $155
80106be1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106be6:	e9 88 f5 ff ff       	jmp    80106173 <alltraps>

80106beb <vector156>:
.globl vector156
vector156:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $156
80106bed:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106bf2:	e9 7c f5 ff ff       	jmp    80106173 <alltraps>

80106bf7 <vector157>:
.globl vector157
vector157:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $157
80106bf9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bfe:	e9 70 f5 ff ff       	jmp    80106173 <alltraps>

80106c03 <vector158>:
.globl vector158
vector158:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $158
80106c05:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c0a:	e9 64 f5 ff ff       	jmp    80106173 <alltraps>

80106c0f <vector159>:
.globl vector159
vector159:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $159
80106c11:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c16:	e9 58 f5 ff ff       	jmp    80106173 <alltraps>

80106c1b <vector160>:
.globl vector160
vector160:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $160
80106c1d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c22:	e9 4c f5 ff ff       	jmp    80106173 <alltraps>

80106c27 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $161
80106c29:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c2e:	e9 40 f5 ff ff       	jmp    80106173 <alltraps>

80106c33 <vector162>:
.globl vector162
vector162:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $162
80106c35:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c3a:	e9 34 f5 ff ff       	jmp    80106173 <alltraps>

80106c3f <vector163>:
.globl vector163
vector163:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $163
80106c41:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c46:	e9 28 f5 ff ff       	jmp    80106173 <alltraps>

80106c4b <vector164>:
.globl vector164
vector164:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $164
80106c4d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c52:	e9 1c f5 ff ff       	jmp    80106173 <alltraps>

80106c57 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $165
80106c59:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c5e:	e9 10 f5 ff ff       	jmp    80106173 <alltraps>

80106c63 <vector166>:
.globl vector166
vector166:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $166
80106c65:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c6a:	e9 04 f5 ff ff       	jmp    80106173 <alltraps>

80106c6f <vector167>:
.globl vector167
vector167:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $167
80106c71:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c76:	e9 f8 f4 ff ff       	jmp    80106173 <alltraps>

80106c7b <vector168>:
.globl vector168
vector168:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $168
80106c7d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c82:	e9 ec f4 ff ff       	jmp    80106173 <alltraps>

80106c87 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $169
80106c89:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c8e:	e9 e0 f4 ff ff       	jmp    80106173 <alltraps>

80106c93 <vector170>:
.globl vector170
vector170:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $170
80106c95:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c9a:	e9 d4 f4 ff ff       	jmp    80106173 <alltraps>

80106c9f <vector171>:
.globl vector171
vector171:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $171
80106ca1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ca6:	e9 c8 f4 ff ff       	jmp    80106173 <alltraps>

80106cab <vector172>:
.globl vector172
vector172:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $172
80106cad:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106cb2:	e9 bc f4 ff ff       	jmp    80106173 <alltraps>

80106cb7 <vector173>:
.globl vector173
vector173:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $173
80106cb9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106cbe:	e9 b0 f4 ff ff       	jmp    80106173 <alltraps>

80106cc3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $174
80106cc5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106cca:	e9 a4 f4 ff ff       	jmp    80106173 <alltraps>

80106ccf <vector175>:
.globl vector175
vector175:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $175
80106cd1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106cd6:	e9 98 f4 ff ff       	jmp    80106173 <alltraps>

80106cdb <vector176>:
.globl vector176
vector176:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $176
80106cdd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ce2:	e9 8c f4 ff ff       	jmp    80106173 <alltraps>

80106ce7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $177
80106ce9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106cee:	e9 80 f4 ff ff       	jmp    80106173 <alltraps>

80106cf3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $178
80106cf5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106cfa:	e9 74 f4 ff ff       	jmp    80106173 <alltraps>

80106cff <vector179>:
.globl vector179
vector179:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $179
80106d01:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d06:	e9 68 f4 ff ff       	jmp    80106173 <alltraps>

80106d0b <vector180>:
.globl vector180
vector180:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $180
80106d0d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d12:	e9 5c f4 ff ff       	jmp    80106173 <alltraps>

80106d17 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $181
80106d19:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d1e:	e9 50 f4 ff ff       	jmp    80106173 <alltraps>

80106d23 <vector182>:
.globl vector182
vector182:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $182
80106d25:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d2a:	e9 44 f4 ff ff       	jmp    80106173 <alltraps>

80106d2f <vector183>:
.globl vector183
vector183:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $183
80106d31:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d36:	e9 38 f4 ff ff       	jmp    80106173 <alltraps>

80106d3b <vector184>:
.globl vector184
vector184:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $184
80106d3d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d42:	e9 2c f4 ff ff       	jmp    80106173 <alltraps>

80106d47 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $185
80106d49:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d4e:	e9 20 f4 ff ff       	jmp    80106173 <alltraps>

80106d53 <vector186>:
.globl vector186
vector186:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $186
80106d55:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d5a:	e9 14 f4 ff ff       	jmp    80106173 <alltraps>

80106d5f <vector187>:
.globl vector187
vector187:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $187
80106d61:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d66:	e9 08 f4 ff ff       	jmp    80106173 <alltraps>

80106d6b <vector188>:
.globl vector188
vector188:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $188
80106d6d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d72:	e9 fc f3 ff ff       	jmp    80106173 <alltraps>

80106d77 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $189
80106d79:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d7e:	e9 f0 f3 ff ff       	jmp    80106173 <alltraps>

80106d83 <vector190>:
.globl vector190
vector190:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $190
80106d85:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d8a:	e9 e4 f3 ff ff       	jmp    80106173 <alltraps>

80106d8f <vector191>:
.globl vector191
vector191:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $191
80106d91:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d96:	e9 d8 f3 ff ff       	jmp    80106173 <alltraps>

80106d9b <vector192>:
.globl vector192
vector192:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $192
80106d9d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106da2:	e9 cc f3 ff ff       	jmp    80106173 <alltraps>

80106da7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $193
80106da9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106dae:	e9 c0 f3 ff ff       	jmp    80106173 <alltraps>

80106db3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $194
80106db5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106dba:	e9 b4 f3 ff ff       	jmp    80106173 <alltraps>

80106dbf <vector195>:
.globl vector195
vector195:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $195
80106dc1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106dc6:	e9 a8 f3 ff ff       	jmp    80106173 <alltraps>

80106dcb <vector196>:
.globl vector196
vector196:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $196
80106dcd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106dd2:	e9 9c f3 ff ff       	jmp    80106173 <alltraps>

80106dd7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $197
80106dd9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106dde:	e9 90 f3 ff ff       	jmp    80106173 <alltraps>

80106de3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $198
80106de5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106dea:	e9 84 f3 ff ff       	jmp    80106173 <alltraps>

80106def <vector199>:
.globl vector199
vector199:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $199
80106df1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106df6:	e9 78 f3 ff ff       	jmp    80106173 <alltraps>

80106dfb <vector200>:
.globl vector200
vector200:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $200
80106dfd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e02:	e9 6c f3 ff ff       	jmp    80106173 <alltraps>

80106e07 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $201
80106e09:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e0e:	e9 60 f3 ff ff       	jmp    80106173 <alltraps>

80106e13 <vector202>:
.globl vector202
vector202:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $202
80106e15:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e1a:	e9 54 f3 ff ff       	jmp    80106173 <alltraps>

80106e1f <vector203>:
.globl vector203
vector203:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $203
80106e21:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e26:	e9 48 f3 ff ff       	jmp    80106173 <alltraps>

80106e2b <vector204>:
.globl vector204
vector204:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $204
80106e2d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e32:	e9 3c f3 ff ff       	jmp    80106173 <alltraps>

80106e37 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $205
80106e39:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e3e:	e9 30 f3 ff ff       	jmp    80106173 <alltraps>

80106e43 <vector206>:
.globl vector206
vector206:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $206
80106e45:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e4a:	e9 24 f3 ff ff       	jmp    80106173 <alltraps>

80106e4f <vector207>:
.globl vector207
vector207:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $207
80106e51:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e56:	e9 18 f3 ff ff       	jmp    80106173 <alltraps>

80106e5b <vector208>:
.globl vector208
vector208:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $208
80106e5d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e62:	e9 0c f3 ff ff       	jmp    80106173 <alltraps>

80106e67 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $209
80106e69:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e6e:	e9 00 f3 ff ff       	jmp    80106173 <alltraps>

80106e73 <vector210>:
.globl vector210
vector210:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $210
80106e75:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e7a:	e9 f4 f2 ff ff       	jmp    80106173 <alltraps>

80106e7f <vector211>:
.globl vector211
vector211:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $211
80106e81:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e86:	e9 e8 f2 ff ff       	jmp    80106173 <alltraps>

80106e8b <vector212>:
.globl vector212
vector212:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $212
80106e8d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e92:	e9 dc f2 ff ff       	jmp    80106173 <alltraps>

80106e97 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $213
80106e99:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e9e:	e9 d0 f2 ff ff       	jmp    80106173 <alltraps>

80106ea3 <vector214>:
.globl vector214
vector214:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $214
80106ea5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106eaa:	e9 c4 f2 ff ff       	jmp    80106173 <alltraps>

80106eaf <vector215>:
.globl vector215
vector215:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $215
80106eb1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106eb6:	e9 b8 f2 ff ff       	jmp    80106173 <alltraps>

80106ebb <vector216>:
.globl vector216
vector216:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $216
80106ebd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ec2:	e9 ac f2 ff ff       	jmp    80106173 <alltraps>

80106ec7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $217
80106ec9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106ece:	e9 a0 f2 ff ff       	jmp    80106173 <alltraps>

80106ed3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $218
80106ed5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106eda:	e9 94 f2 ff ff       	jmp    80106173 <alltraps>

80106edf <vector219>:
.globl vector219
vector219:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $219
80106ee1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ee6:	e9 88 f2 ff ff       	jmp    80106173 <alltraps>

80106eeb <vector220>:
.globl vector220
vector220:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $220
80106eed:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ef2:	e9 7c f2 ff ff       	jmp    80106173 <alltraps>

80106ef7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $221
80106ef9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106efe:	e9 70 f2 ff ff       	jmp    80106173 <alltraps>

80106f03 <vector222>:
.globl vector222
vector222:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $222
80106f05:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f0a:	e9 64 f2 ff ff       	jmp    80106173 <alltraps>

80106f0f <vector223>:
.globl vector223
vector223:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $223
80106f11:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f16:	e9 58 f2 ff ff       	jmp    80106173 <alltraps>

80106f1b <vector224>:
.globl vector224
vector224:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $224
80106f1d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f22:	e9 4c f2 ff ff       	jmp    80106173 <alltraps>

80106f27 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $225
80106f29:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f2e:	e9 40 f2 ff ff       	jmp    80106173 <alltraps>

80106f33 <vector226>:
.globl vector226
vector226:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $226
80106f35:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f3a:	e9 34 f2 ff ff       	jmp    80106173 <alltraps>

80106f3f <vector227>:
.globl vector227
vector227:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $227
80106f41:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f46:	e9 28 f2 ff ff       	jmp    80106173 <alltraps>

80106f4b <vector228>:
.globl vector228
vector228:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $228
80106f4d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f52:	e9 1c f2 ff ff       	jmp    80106173 <alltraps>

80106f57 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $229
80106f59:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f5e:	e9 10 f2 ff ff       	jmp    80106173 <alltraps>

80106f63 <vector230>:
.globl vector230
vector230:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $230
80106f65:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f6a:	e9 04 f2 ff ff       	jmp    80106173 <alltraps>

80106f6f <vector231>:
.globl vector231
vector231:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $231
80106f71:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f76:	e9 f8 f1 ff ff       	jmp    80106173 <alltraps>

80106f7b <vector232>:
.globl vector232
vector232:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $232
80106f7d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f82:	e9 ec f1 ff ff       	jmp    80106173 <alltraps>

80106f87 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $233
80106f89:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f8e:	e9 e0 f1 ff ff       	jmp    80106173 <alltraps>

80106f93 <vector234>:
.globl vector234
vector234:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $234
80106f95:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f9a:	e9 d4 f1 ff ff       	jmp    80106173 <alltraps>

80106f9f <vector235>:
.globl vector235
vector235:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $235
80106fa1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106fa6:	e9 c8 f1 ff ff       	jmp    80106173 <alltraps>

80106fab <vector236>:
.globl vector236
vector236:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $236
80106fad:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106fb2:	e9 bc f1 ff ff       	jmp    80106173 <alltraps>

80106fb7 <vector237>:
.globl vector237
vector237:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $237
80106fb9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106fbe:	e9 b0 f1 ff ff       	jmp    80106173 <alltraps>

80106fc3 <vector238>:
.globl vector238
vector238:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $238
80106fc5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106fca:	e9 a4 f1 ff ff       	jmp    80106173 <alltraps>

80106fcf <vector239>:
.globl vector239
vector239:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $239
80106fd1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106fd6:	e9 98 f1 ff ff       	jmp    80106173 <alltraps>

80106fdb <vector240>:
.globl vector240
vector240:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $240
80106fdd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106fe2:	e9 8c f1 ff ff       	jmp    80106173 <alltraps>

80106fe7 <vector241>:
.globl vector241
vector241:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $241
80106fe9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106fee:	e9 80 f1 ff ff       	jmp    80106173 <alltraps>

80106ff3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $242
80106ff5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ffa:	e9 74 f1 ff ff       	jmp    80106173 <alltraps>

80106fff <vector243>:
.globl vector243
vector243:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $243
80107001:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107006:	e9 68 f1 ff ff       	jmp    80106173 <alltraps>

8010700b <vector244>:
.globl vector244
vector244:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $244
8010700d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107012:	e9 5c f1 ff ff       	jmp    80106173 <alltraps>

80107017 <vector245>:
.globl vector245
vector245:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $245
80107019:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010701e:	e9 50 f1 ff ff       	jmp    80106173 <alltraps>

80107023 <vector246>:
.globl vector246
vector246:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $246
80107025:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010702a:	e9 44 f1 ff ff       	jmp    80106173 <alltraps>

8010702f <vector247>:
.globl vector247
vector247:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $247
80107031:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107036:	e9 38 f1 ff ff       	jmp    80106173 <alltraps>

8010703b <vector248>:
.globl vector248
vector248:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $248
8010703d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107042:	e9 2c f1 ff ff       	jmp    80106173 <alltraps>

80107047 <vector249>:
.globl vector249
vector249:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $249
80107049:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010704e:	e9 20 f1 ff ff       	jmp    80106173 <alltraps>

80107053 <vector250>:
.globl vector250
vector250:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $250
80107055:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010705a:	e9 14 f1 ff ff       	jmp    80106173 <alltraps>

8010705f <vector251>:
.globl vector251
vector251:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $251
80107061:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107066:	e9 08 f1 ff ff       	jmp    80106173 <alltraps>

8010706b <vector252>:
.globl vector252
vector252:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $252
8010706d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107072:	e9 fc f0 ff ff       	jmp    80106173 <alltraps>

80107077 <vector253>:
.globl vector253
vector253:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $253
80107079:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010707e:	e9 f0 f0 ff ff       	jmp    80106173 <alltraps>

80107083 <vector254>:
.globl vector254
vector254:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $254
80107085:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010708a:	e9 e4 f0 ff ff       	jmp    80106173 <alltraps>

8010708f <vector255>:
.globl vector255
vector255:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $255
80107091:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107096:	e9 d8 f0 ff ff       	jmp    80106173 <alltraps>
8010709b:	66 90                	xchg   %ax,%ax
8010709d:	66 90                	xchg   %ax,%ax
8010709f:	90                   	nop

801070a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	56                   	push   %esi
801070a5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801070a7:	c1 ea 16             	shr    $0x16,%edx
{
801070aa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801070ab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801070ae:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801070b1:	8b 1f                	mov    (%edi),%ebx
801070b3:	f6 c3 01             	test   $0x1,%bl
801070b6:	74 28                	je     801070e0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801070be:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801070c4:	89 f0                	mov    %esi,%eax
}
801070c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801070c9:	c1 e8 0a             	shr    $0xa,%eax
801070cc:	25 fc 0f 00 00       	and    $0xffc,%eax
801070d1:	01 d8                	add    %ebx,%eax
}
801070d3:	5b                   	pop    %ebx
801070d4:	5e                   	pop    %esi
801070d5:	5f                   	pop    %edi
801070d6:	5d                   	pop    %ebp
801070d7:	c3                   	ret    
801070d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070df:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801070e0:	85 c9                	test   %ecx,%ecx
801070e2:	74 2c                	je     80107110 <walkpgdir+0x70>
801070e4:	e8 77 b5 ff ff       	call   80102660 <kalloc>
801070e9:	89 c3                	mov    %eax,%ebx
801070eb:	85 c0                	test   %eax,%eax
801070ed:	74 21                	je     80107110 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801070ef:	83 ec 04             	sub    $0x4,%esp
801070f2:	68 00 10 00 00       	push   $0x1000
801070f7:	6a 00                	push   $0x0
801070f9:	50                   	push   %eax
801070fa:	e8 a1 dd ff ff       	call   80104ea0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801070ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107105:	83 c4 10             	add    $0x10,%esp
80107108:	83 c8 07             	or     $0x7,%eax
8010710b:	89 07                	mov    %eax,(%edi)
8010710d:	eb b5                	jmp    801070c4 <walkpgdir+0x24>
8010710f:	90                   	nop
}
80107110:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107113:	31 c0                	xor    %eax,%eax
}
80107115:	5b                   	pop    %ebx
80107116:	5e                   	pop    %esi
80107117:	5f                   	pop    %edi
80107118:	5d                   	pop    %ebp
80107119:	c3                   	ret    
8010711a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107120 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107126:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010712a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010712b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107130:	89 d6                	mov    %edx,%esi
{
80107132:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107133:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107139:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010713c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010713f:	8b 45 08             	mov    0x8(%ebp),%eax
80107142:	29 f0                	sub    %esi,%eax
80107144:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107147:	eb 1f                	jmp    80107168 <mappages+0x48>
80107149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107150:	f6 00 01             	testb  $0x1,(%eax)
80107153:	75 45                	jne    8010719a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107155:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107158:	83 cb 01             	or     $0x1,%ebx
8010715b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010715d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107160:	74 2e                	je     80107190 <mappages+0x70>
      break;
    a += PGSIZE;
80107162:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107168:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010716b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107170:	89 f2                	mov    %esi,%edx
80107172:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107175:	89 f8                	mov    %edi,%eax
80107177:	e8 24 ff ff ff       	call   801070a0 <walkpgdir>
8010717c:	85 c0                	test   %eax,%eax
8010717e:	75 d0                	jne    80107150 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107180:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107183:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107188:	5b                   	pop    %ebx
80107189:	5e                   	pop    %esi
8010718a:	5f                   	pop    %edi
8010718b:	5d                   	pop    %ebp
8010718c:	c3                   	ret    
8010718d:	8d 76 00             	lea    0x0(%esi),%esi
80107190:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107193:	31 c0                	xor    %eax,%eax
}
80107195:	5b                   	pop    %ebx
80107196:	5e                   	pop    %esi
80107197:	5f                   	pop    %edi
80107198:	5d                   	pop    %ebp
80107199:	c3                   	ret    
      panic("remap");
8010719a:	83 ec 0c             	sub    $0xc,%esp
8010719d:	68 14 84 10 80       	push   $0x80108414
801071a2:	e8 e9 91 ff ff       	call   80100390 <panic>
801071a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ae:	66 90                	xchg   %ax,%ax

801071b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	89 c6                	mov    %eax,%esi
801071b7:	53                   	push   %ebx
801071b8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801071ba:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801071c0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801071c6:	83 ec 1c             	sub    $0x1c,%esp
801071c9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801071cc:	39 da                	cmp    %ebx,%edx
801071ce:	73 5b                	jae    8010722b <deallocuvm.part.0+0x7b>
801071d0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801071d3:	89 d7                	mov    %edx,%edi
801071d5:	eb 14                	jmp    801071eb <deallocuvm.part.0+0x3b>
801071d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071de:	66 90                	xchg   %ax,%ax
801071e0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801071e6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801071e9:	76 40                	jbe    8010722b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
801071eb:	31 c9                	xor    %ecx,%ecx
801071ed:	89 fa                	mov    %edi,%edx
801071ef:	89 f0                	mov    %esi,%eax
801071f1:	e8 aa fe ff ff       	call   801070a0 <walkpgdir>
801071f6:	89 c3                	mov    %eax,%ebx
    if(!pte)
801071f8:	85 c0                	test   %eax,%eax
801071fa:	74 44                	je     80107240 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801071fc:	8b 00                	mov    (%eax),%eax
801071fe:	a8 01                	test   $0x1,%al
80107200:	74 de                	je     801071e0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107202:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107207:	74 47                	je     80107250 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107209:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010720c:	05 00 00 00 80       	add    $0x80000000,%eax
80107211:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107217:	50                   	push   %eax
80107218:	e8 83 b2 ff ff       	call   801024a0 <kfree>
      *pte = 0;
8010721d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107223:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107226:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107229:	77 c0                	ja     801071eb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010722b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010722e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107231:	5b                   	pop    %ebx
80107232:	5e                   	pop    %esi
80107233:	5f                   	pop    %edi
80107234:	5d                   	pop    %ebp
80107235:	c3                   	ret    
80107236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010723d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107240:	89 fa                	mov    %edi,%edx
80107242:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107248:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010724e:	eb 96                	jmp    801071e6 <deallocuvm.part.0+0x36>
        panic("kfree");
80107250:	83 ec 0c             	sub    $0xc,%esp
80107253:	68 46 7c 10 80       	push   $0x80107c46
80107258:	e8 33 91 ff ff       	call   80100390 <panic>
8010725d:	8d 76 00             	lea    0x0(%esi),%esi

80107260 <seginit>:
{
80107260:	f3 0f 1e fb          	endbr32 
80107264:	55                   	push   %ebp
80107265:	89 e5                	mov    %esp,%ebp
80107267:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010726a:	e8 a1 c6 ff ff       	call   80103910 <cpuid>
  pd[0] = size-1;
8010726f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107274:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010727a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010727e:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80107285:	ff 00 00 
80107288:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
8010728f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107292:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80107299:	ff 00 00 
8010729c:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
801072a3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801072a6:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
801072ad:	ff 00 00 
801072b0:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
801072b7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072ba:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
801072c1:	ff 00 00 
801072c4:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
801072cb:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801072ce:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
801072d3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801072d7:	c1 e8 10             	shr    $0x10,%eax
801072da:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801072de:	8d 45 f2             	lea    -0xe(%ebp),%eax
801072e1:	0f 01 10             	lgdtl  (%eax)
}
801072e4:	c9                   	leave  
801072e5:	c3                   	ret    
801072e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072ed:	8d 76 00             	lea    0x0(%esi),%esi

801072f0 <switchkvm>:
{
801072f0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072f4:	a1 c4 ab 11 80       	mov    0x8011abc4,%eax
801072f9:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072fe:	0f 22 d8             	mov    %eax,%cr3
}
80107301:	c3                   	ret    
80107302:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107310 <switchuvm>:
{
80107310:	f3 0f 1e fb          	endbr32 
80107314:	55                   	push   %ebp
80107315:	89 e5                	mov    %esp,%ebp
80107317:	57                   	push   %edi
80107318:	56                   	push   %esi
80107319:	53                   	push   %ebx
8010731a:	83 ec 1c             	sub    $0x1c,%esp
8010731d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107320:	85 f6                	test   %esi,%esi
80107322:	0f 84 cb 00 00 00    	je     801073f3 <switchuvm+0xe3>
  if(p->kstack == 0)
80107328:	8b 46 08             	mov    0x8(%esi),%eax
8010732b:	85 c0                	test   %eax,%eax
8010732d:	0f 84 da 00 00 00    	je     8010740d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107333:	8b 46 04             	mov    0x4(%esi),%eax
80107336:	85 c0                	test   %eax,%eax
80107338:	0f 84 c2 00 00 00    	je     80107400 <switchuvm+0xf0>
  pushcli();
8010733e:	e8 4d d9 ff ff       	call   80104c90 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107343:	e8 58 c5 ff ff       	call   801038a0 <mycpu>
80107348:	89 c3                	mov    %eax,%ebx
8010734a:	e8 51 c5 ff ff       	call   801038a0 <mycpu>
8010734f:	89 c7                	mov    %eax,%edi
80107351:	e8 4a c5 ff ff       	call   801038a0 <mycpu>
80107356:	83 c7 08             	add    $0x8,%edi
80107359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010735c:	e8 3f c5 ff ff       	call   801038a0 <mycpu>
80107361:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107364:	ba 67 00 00 00       	mov    $0x67,%edx
80107369:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107370:	83 c0 08             	add    $0x8,%eax
80107373:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010737a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010737f:	83 c1 08             	add    $0x8,%ecx
80107382:	c1 e8 18             	shr    $0x18,%eax
80107385:	c1 e9 10             	shr    $0x10,%ecx
80107388:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010738e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107394:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107399:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073a0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801073a5:	e8 f6 c4 ff ff       	call   801038a0 <mycpu>
801073aa:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073b1:	e8 ea c4 ff ff       	call   801038a0 <mycpu>
801073b6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801073ba:	8b 5e 08             	mov    0x8(%esi),%ebx
801073bd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073c3:	e8 d8 c4 ff ff       	call   801038a0 <mycpu>
801073c8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073cb:	e8 d0 c4 ff ff       	call   801038a0 <mycpu>
801073d0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801073d4:	b8 28 00 00 00       	mov    $0x28,%eax
801073d9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801073dc:	8b 46 04             	mov    0x4(%esi),%eax
801073df:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073e4:	0f 22 d8             	mov    %eax,%cr3
}
801073e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ea:	5b                   	pop    %ebx
801073eb:	5e                   	pop    %esi
801073ec:	5f                   	pop    %edi
801073ed:	5d                   	pop    %ebp
  popcli();
801073ee:	e9 ed d8 ff ff       	jmp    80104ce0 <popcli>
    panic("switchuvm: no process");
801073f3:	83 ec 0c             	sub    $0xc,%esp
801073f6:	68 1a 84 10 80       	push   $0x8010841a
801073fb:	e8 90 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107400:	83 ec 0c             	sub    $0xc,%esp
80107403:	68 45 84 10 80       	push   $0x80108445
80107408:	e8 83 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010740d:	83 ec 0c             	sub    $0xc,%esp
80107410:	68 30 84 10 80       	push   $0x80108430
80107415:	e8 76 8f ff ff       	call   80100390 <panic>
8010741a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107420 <inituvm>:
{
80107420:	f3 0f 1e fb          	endbr32 
80107424:	55                   	push   %ebp
80107425:	89 e5                	mov    %esp,%ebp
80107427:	57                   	push   %edi
80107428:	56                   	push   %esi
80107429:	53                   	push   %ebx
8010742a:	83 ec 1c             	sub    $0x1c,%esp
8010742d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107430:	8b 75 10             	mov    0x10(%ebp),%esi
80107433:	8b 7d 08             	mov    0x8(%ebp),%edi
80107436:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107439:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010743f:	77 4b                	ja     8010748c <inituvm+0x6c>
  mem = kalloc();
80107441:	e8 1a b2 ff ff       	call   80102660 <kalloc>
  memset(mem, 0, PGSIZE);
80107446:	83 ec 04             	sub    $0x4,%esp
80107449:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010744e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107450:	6a 00                	push   $0x0
80107452:	50                   	push   %eax
80107453:	e8 48 da ff ff       	call   80104ea0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107458:	58                   	pop    %eax
80107459:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010745f:	5a                   	pop    %edx
80107460:	6a 06                	push   $0x6
80107462:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107467:	31 d2                	xor    %edx,%edx
80107469:	50                   	push   %eax
8010746a:	89 f8                	mov    %edi,%eax
8010746c:	e8 af fc ff ff       	call   80107120 <mappages>
  memmove(mem, init, sz);
80107471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107474:	89 75 10             	mov    %esi,0x10(%ebp)
80107477:	83 c4 10             	add    $0x10,%esp
8010747a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010747d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107480:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107483:	5b                   	pop    %ebx
80107484:	5e                   	pop    %esi
80107485:	5f                   	pop    %edi
80107486:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107487:	e9 b4 da ff ff       	jmp    80104f40 <memmove>
    panic("inituvm: more than a page");
8010748c:	83 ec 0c             	sub    $0xc,%esp
8010748f:	68 59 84 10 80       	push   $0x80108459
80107494:	e8 f7 8e ff ff       	call   80100390 <panic>
80107499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074a0 <loaduvm>:
{
801074a0:	f3 0f 1e fb          	endbr32 
801074a4:	55                   	push   %ebp
801074a5:	89 e5                	mov    %esp,%ebp
801074a7:	57                   	push   %edi
801074a8:	56                   	push   %esi
801074a9:	53                   	push   %ebx
801074aa:	83 ec 1c             	sub    $0x1c,%esp
801074ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801074b0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801074b3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801074b8:	0f 85 99 00 00 00    	jne    80107557 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
801074be:	01 f0                	add    %esi,%eax
801074c0:	89 f3                	mov    %esi,%ebx
801074c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074c5:	8b 45 14             	mov    0x14(%ebp),%eax
801074c8:	01 f0                	add    %esi,%eax
801074ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801074cd:	85 f6                	test   %esi,%esi
801074cf:	75 15                	jne    801074e6 <loaduvm+0x46>
801074d1:	eb 6d                	jmp    80107540 <loaduvm+0xa0>
801074d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074d7:	90                   	nop
801074d8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801074de:	89 f0                	mov    %esi,%eax
801074e0:	29 d8                	sub    %ebx,%eax
801074e2:	39 c6                	cmp    %eax,%esi
801074e4:	76 5a                	jbe    80107540 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801074e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074e9:	8b 45 08             	mov    0x8(%ebp),%eax
801074ec:	31 c9                	xor    %ecx,%ecx
801074ee:	29 da                	sub    %ebx,%edx
801074f0:	e8 ab fb ff ff       	call   801070a0 <walkpgdir>
801074f5:	85 c0                	test   %eax,%eax
801074f7:	74 51                	je     8010754a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801074f9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074fb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801074fe:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107503:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107508:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010750e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107511:	29 d9                	sub    %ebx,%ecx
80107513:	05 00 00 00 80       	add    $0x80000000,%eax
80107518:	57                   	push   %edi
80107519:	51                   	push   %ecx
8010751a:	50                   	push   %eax
8010751b:	ff 75 10             	pushl  0x10(%ebp)
8010751e:	e8 6d a5 ff ff       	call   80101a90 <readi>
80107523:	83 c4 10             	add    $0x10,%esp
80107526:	39 f8                	cmp    %edi,%eax
80107528:	74 ae                	je     801074d8 <loaduvm+0x38>
}
8010752a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010752d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107532:	5b                   	pop    %ebx
80107533:	5e                   	pop    %esi
80107534:	5f                   	pop    %edi
80107535:	5d                   	pop    %ebp
80107536:	c3                   	ret    
80107537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010753e:	66 90                	xchg   %ax,%ax
80107540:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107543:	31 c0                	xor    %eax,%eax
}
80107545:	5b                   	pop    %ebx
80107546:	5e                   	pop    %esi
80107547:	5f                   	pop    %edi
80107548:	5d                   	pop    %ebp
80107549:	c3                   	ret    
      panic("loaduvm: address should exist");
8010754a:	83 ec 0c             	sub    $0xc,%esp
8010754d:	68 73 84 10 80       	push   $0x80108473
80107552:	e8 39 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107557:	83 ec 0c             	sub    $0xc,%esp
8010755a:	68 14 85 10 80       	push   $0x80108514
8010755f:	e8 2c 8e ff ff       	call   80100390 <panic>
80107564:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010756b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010756f:	90                   	nop

80107570 <allocuvm>:
{
80107570:	f3 0f 1e fb          	endbr32 
80107574:	55                   	push   %ebp
80107575:	89 e5                	mov    %esp,%ebp
80107577:	57                   	push   %edi
80107578:	56                   	push   %esi
80107579:	53                   	push   %ebx
8010757a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010757d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107580:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107583:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107586:	85 c0                	test   %eax,%eax
80107588:	0f 88 b2 00 00 00    	js     80107640 <allocuvm+0xd0>
  if(newsz < oldsz)
8010758e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107591:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107594:	0f 82 96 00 00 00    	jb     80107630 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010759a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801075a0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801075a6:	39 75 10             	cmp    %esi,0x10(%ebp)
801075a9:	77 40                	ja     801075eb <allocuvm+0x7b>
801075ab:	e9 83 00 00 00       	jmp    80107633 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
801075b0:	83 ec 04             	sub    $0x4,%esp
801075b3:	68 00 10 00 00       	push   $0x1000
801075b8:	6a 00                	push   $0x0
801075ba:	50                   	push   %eax
801075bb:	e8 e0 d8 ff ff       	call   80104ea0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801075c0:	58                   	pop    %eax
801075c1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075c7:	5a                   	pop    %edx
801075c8:	6a 06                	push   $0x6
801075ca:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075cf:	89 f2                	mov    %esi,%edx
801075d1:	50                   	push   %eax
801075d2:	89 f8                	mov    %edi,%eax
801075d4:	e8 47 fb ff ff       	call   80107120 <mappages>
801075d9:	83 c4 10             	add    $0x10,%esp
801075dc:	85 c0                	test   %eax,%eax
801075de:	78 78                	js     80107658 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801075e0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801075e6:	39 75 10             	cmp    %esi,0x10(%ebp)
801075e9:	76 48                	jbe    80107633 <allocuvm+0xc3>
    mem = kalloc();
801075eb:	e8 70 b0 ff ff       	call   80102660 <kalloc>
801075f0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801075f2:	85 c0                	test   %eax,%eax
801075f4:	75 ba                	jne    801075b0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801075f6:	83 ec 0c             	sub    $0xc,%esp
801075f9:	68 91 84 10 80       	push   $0x80108491
801075fe:	e8 ad 90 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107603:	8b 45 0c             	mov    0xc(%ebp),%eax
80107606:	83 c4 10             	add    $0x10,%esp
80107609:	39 45 10             	cmp    %eax,0x10(%ebp)
8010760c:	74 32                	je     80107640 <allocuvm+0xd0>
8010760e:	8b 55 10             	mov    0x10(%ebp),%edx
80107611:	89 c1                	mov    %eax,%ecx
80107613:	89 f8                	mov    %edi,%eax
80107615:	e8 96 fb ff ff       	call   801071b0 <deallocuvm.part.0>
      return 0;
8010761a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107624:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107627:	5b                   	pop    %ebx
80107628:	5e                   	pop    %esi
80107629:	5f                   	pop    %edi
8010762a:	5d                   	pop    %ebp
8010762b:	c3                   	ret    
8010762c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107630:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107636:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107639:	5b                   	pop    %ebx
8010763a:	5e                   	pop    %esi
8010763b:	5f                   	pop    %edi
8010763c:	5d                   	pop    %ebp
8010763d:	c3                   	ret    
8010763e:	66 90                	xchg   %ax,%ax
    return 0;
80107640:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010764a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010764d:	5b                   	pop    %ebx
8010764e:	5e                   	pop    %esi
8010764f:	5f                   	pop    %edi
80107650:	5d                   	pop    %ebp
80107651:	c3                   	ret    
80107652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107658:	83 ec 0c             	sub    $0xc,%esp
8010765b:	68 a9 84 10 80       	push   $0x801084a9
80107660:	e8 4b 90 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107665:	8b 45 0c             	mov    0xc(%ebp),%eax
80107668:	83 c4 10             	add    $0x10,%esp
8010766b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010766e:	74 0c                	je     8010767c <allocuvm+0x10c>
80107670:	8b 55 10             	mov    0x10(%ebp),%edx
80107673:	89 c1                	mov    %eax,%ecx
80107675:	89 f8                	mov    %edi,%eax
80107677:	e8 34 fb ff ff       	call   801071b0 <deallocuvm.part.0>
      kfree(mem);
8010767c:	83 ec 0c             	sub    $0xc,%esp
8010767f:	53                   	push   %ebx
80107680:	e8 1b ae ff ff       	call   801024a0 <kfree>
      return 0;
80107685:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010768c:	83 c4 10             	add    $0x10,%esp
}
8010768f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107692:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107695:	5b                   	pop    %ebx
80107696:	5e                   	pop    %esi
80107697:	5f                   	pop    %edi
80107698:	5d                   	pop    %ebp
80107699:	c3                   	ret    
8010769a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076a0 <deallocuvm>:
{
801076a0:	f3 0f 1e fb          	endbr32 
801076a4:	55                   	push   %ebp
801076a5:	89 e5                	mov    %esp,%ebp
801076a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801076aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
801076ad:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801076b0:	39 d1                	cmp    %edx,%ecx
801076b2:	73 0c                	jae    801076c0 <deallocuvm+0x20>
}
801076b4:	5d                   	pop    %ebp
801076b5:	e9 f6 fa ff ff       	jmp    801071b0 <deallocuvm.part.0>
801076ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801076c0:	89 d0                	mov    %edx,%eax
801076c2:	5d                   	pop    %ebp
801076c3:	c3                   	ret    
801076c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076cf:	90                   	nop

801076d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801076d0:	f3 0f 1e fb          	endbr32 
801076d4:	55                   	push   %ebp
801076d5:	89 e5                	mov    %esp,%ebp
801076d7:	57                   	push   %edi
801076d8:	56                   	push   %esi
801076d9:	53                   	push   %ebx
801076da:	83 ec 0c             	sub    $0xc,%esp
801076dd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801076e0:	85 f6                	test   %esi,%esi
801076e2:	74 55                	je     80107739 <freevm+0x69>
  if(newsz >= oldsz)
801076e4:	31 c9                	xor    %ecx,%ecx
801076e6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801076eb:	89 f0                	mov    %esi,%eax
801076ed:	89 f3                	mov    %esi,%ebx
801076ef:	e8 bc fa ff ff       	call   801071b0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801076f4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801076fa:	eb 0b                	jmp    80107707 <freevm+0x37>
801076fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107700:	83 c3 04             	add    $0x4,%ebx
80107703:	39 df                	cmp    %ebx,%edi
80107705:	74 23                	je     8010772a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107707:	8b 03                	mov    (%ebx),%eax
80107709:	a8 01                	test   $0x1,%al
8010770b:	74 f3                	je     80107700 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010770d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107712:	83 ec 0c             	sub    $0xc,%esp
80107715:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107718:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010771d:	50                   	push   %eax
8010771e:	e8 7d ad ff ff       	call   801024a0 <kfree>
80107723:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107726:	39 df                	cmp    %ebx,%edi
80107728:	75 dd                	jne    80107707 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010772a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010772d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107730:	5b                   	pop    %ebx
80107731:	5e                   	pop    %esi
80107732:	5f                   	pop    %edi
80107733:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107734:	e9 67 ad ff ff       	jmp    801024a0 <kfree>
    panic("freevm: no pgdir");
80107739:	83 ec 0c             	sub    $0xc,%esp
8010773c:	68 c5 84 10 80       	push   $0x801084c5
80107741:	e8 4a 8c ff ff       	call   80100390 <panic>
80107746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010774d:	8d 76 00             	lea    0x0(%esi),%esi

80107750 <setupkvm>:
{
80107750:	f3 0f 1e fb          	endbr32 
80107754:	55                   	push   %ebp
80107755:	89 e5                	mov    %esp,%ebp
80107757:	56                   	push   %esi
80107758:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107759:	e8 02 af ff ff       	call   80102660 <kalloc>
8010775e:	89 c6                	mov    %eax,%esi
80107760:	85 c0                	test   %eax,%eax
80107762:	74 42                	je     801077a6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107764:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107767:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010776c:	68 00 10 00 00       	push   $0x1000
80107771:	6a 00                	push   $0x0
80107773:	50                   	push   %eax
80107774:	e8 27 d7 ff ff       	call   80104ea0 <memset>
80107779:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010777c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010777f:	83 ec 08             	sub    $0x8,%esp
80107782:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107785:	ff 73 0c             	pushl  0xc(%ebx)
80107788:	8b 13                	mov    (%ebx),%edx
8010778a:	50                   	push   %eax
8010778b:	29 c1                	sub    %eax,%ecx
8010778d:	89 f0                	mov    %esi,%eax
8010778f:	e8 8c f9 ff ff       	call   80107120 <mappages>
80107794:	83 c4 10             	add    $0x10,%esp
80107797:	85 c0                	test   %eax,%eax
80107799:	78 15                	js     801077b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010779b:	83 c3 10             	add    $0x10,%ebx
8010779e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801077a4:	75 d6                	jne    8010777c <setupkvm+0x2c>
}
801077a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077a9:	89 f0                	mov    %esi,%eax
801077ab:	5b                   	pop    %ebx
801077ac:	5e                   	pop    %esi
801077ad:	5d                   	pop    %ebp
801077ae:	c3                   	ret    
801077af:	90                   	nop
      freevm(pgdir);
801077b0:	83 ec 0c             	sub    $0xc,%esp
801077b3:	56                   	push   %esi
      return 0;
801077b4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801077b6:	e8 15 ff ff ff       	call   801076d0 <freevm>
      return 0;
801077bb:	83 c4 10             	add    $0x10,%esp
}
801077be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077c1:	89 f0                	mov    %esi,%eax
801077c3:	5b                   	pop    %ebx
801077c4:	5e                   	pop    %esi
801077c5:	5d                   	pop    %ebp
801077c6:	c3                   	ret    
801077c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ce:	66 90                	xchg   %ax,%ax

801077d0 <kvmalloc>:
{
801077d0:	f3 0f 1e fb          	endbr32 
801077d4:	55                   	push   %ebp
801077d5:	89 e5                	mov    %esp,%ebp
801077d7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801077da:	e8 71 ff ff ff       	call   80107750 <setupkvm>
801077df:	a3 c4 ab 11 80       	mov    %eax,0x8011abc4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077e4:	05 00 00 00 80       	add    $0x80000000,%eax
801077e9:	0f 22 d8             	mov    %eax,%cr3
}
801077ec:	c9                   	leave  
801077ed:	c3                   	ret    
801077ee:	66 90                	xchg   %ax,%ax

801077f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801077f0:	f3 0f 1e fb          	endbr32 
801077f4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077f5:	31 c9                	xor    %ecx,%ecx
{
801077f7:	89 e5                	mov    %esp,%ebp
801077f9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801077fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801077ff:	8b 45 08             	mov    0x8(%ebp),%eax
80107802:	e8 99 f8 ff ff       	call   801070a0 <walkpgdir>
  if(pte == 0)
80107807:	85 c0                	test   %eax,%eax
80107809:	74 05                	je     80107810 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010780b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010780e:	c9                   	leave  
8010780f:	c3                   	ret    
    panic("clearpteu");
80107810:	83 ec 0c             	sub    $0xc,%esp
80107813:	68 d6 84 10 80       	push   $0x801084d6
80107818:	e8 73 8b ff ff       	call   80100390 <panic>
8010781d:	8d 76 00             	lea    0x0(%esi),%esi

80107820 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107820:	f3 0f 1e fb          	endbr32 
80107824:	55                   	push   %ebp
80107825:	89 e5                	mov    %esp,%ebp
80107827:	57                   	push   %edi
80107828:	56                   	push   %esi
80107829:	53                   	push   %ebx
8010782a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010782d:	e8 1e ff ff ff       	call   80107750 <setupkvm>
80107832:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107835:	85 c0                	test   %eax,%eax
80107837:	0f 84 9b 00 00 00    	je     801078d8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010783d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107840:	85 c9                	test   %ecx,%ecx
80107842:	0f 84 90 00 00 00    	je     801078d8 <copyuvm+0xb8>
80107848:	31 f6                	xor    %esi,%esi
8010784a:	eb 46                	jmp    80107892 <copyuvm+0x72>
8010784c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107850:	83 ec 04             	sub    $0x4,%esp
80107853:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107859:	68 00 10 00 00       	push   $0x1000
8010785e:	57                   	push   %edi
8010785f:	50                   	push   %eax
80107860:	e8 db d6 ff ff       	call   80104f40 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107865:	58                   	pop    %eax
80107866:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010786c:	5a                   	pop    %edx
8010786d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107870:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107875:	89 f2                	mov    %esi,%edx
80107877:	50                   	push   %eax
80107878:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010787b:	e8 a0 f8 ff ff       	call   80107120 <mappages>
80107880:	83 c4 10             	add    $0x10,%esp
80107883:	85 c0                	test   %eax,%eax
80107885:	78 61                	js     801078e8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107887:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010788d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107890:	76 46                	jbe    801078d8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107892:	8b 45 08             	mov    0x8(%ebp),%eax
80107895:	31 c9                	xor    %ecx,%ecx
80107897:	89 f2                	mov    %esi,%edx
80107899:	e8 02 f8 ff ff       	call   801070a0 <walkpgdir>
8010789e:	85 c0                	test   %eax,%eax
801078a0:	74 61                	je     80107903 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801078a2:	8b 00                	mov    (%eax),%eax
801078a4:	a8 01                	test   $0x1,%al
801078a6:	74 4e                	je     801078f6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801078a8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801078aa:	25 ff 0f 00 00       	and    $0xfff,%eax
801078af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801078b2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801078b8:	e8 a3 ad ff ff       	call   80102660 <kalloc>
801078bd:	89 c3                	mov    %eax,%ebx
801078bf:	85 c0                	test   %eax,%eax
801078c1:	75 8d                	jne    80107850 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801078c3:	83 ec 0c             	sub    $0xc,%esp
801078c6:	ff 75 e0             	pushl  -0x20(%ebp)
801078c9:	e8 02 fe ff ff       	call   801076d0 <freevm>
  return 0;
801078ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801078d5:	83 c4 10             	add    $0x10,%esp
}
801078d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078de:	5b                   	pop    %ebx
801078df:	5e                   	pop    %esi
801078e0:	5f                   	pop    %edi
801078e1:	5d                   	pop    %ebp
801078e2:	c3                   	ret    
801078e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078e7:	90                   	nop
      kfree(mem);
801078e8:	83 ec 0c             	sub    $0xc,%esp
801078eb:	53                   	push   %ebx
801078ec:	e8 af ab ff ff       	call   801024a0 <kfree>
      goto bad;
801078f1:	83 c4 10             	add    $0x10,%esp
801078f4:	eb cd                	jmp    801078c3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801078f6:	83 ec 0c             	sub    $0xc,%esp
801078f9:	68 fa 84 10 80       	push   $0x801084fa
801078fe:	e8 8d 8a ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107903:	83 ec 0c             	sub    $0xc,%esp
80107906:	68 e0 84 10 80       	push   $0x801084e0
8010790b:	e8 80 8a ff ff       	call   80100390 <panic>

80107910 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107910:	f3 0f 1e fb          	endbr32 
80107914:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107915:	31 c9                	xor    %ecx,%ecx
{
80107917:	89 e5                	mov    %esp,%ebp
80107919:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010791c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010791f:	8b 45 08             	mov    0x8(%ebp),%eax
80107922:	e8 79 f7 ff ff       	call   801070a0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107927:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107929:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010792a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010792c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107931:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107934:	05 00 00 00 80       	add    $0x80000000,%eax
80107939:	83 fa 05             	cmp    $0x5,%edx
8010793c:	ba 00 00 00 00       	mov    $0x0,%edx
80107941:	0f 45 c2             	cmovne %edx,%eax
}
80107944:	c3                   	ret    
80107945:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010794c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107950 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107950:	f3 0f 1e fb          	endbr32 
80107954:	55                   	push   %ebp
80107955:	89 e5                	mov    %esp,%ebp
80107957:	57                   	push   %edi
80107958:	56                   	push   %esi
80107959:	53                   	push   %ebx
8010795a:	83 ec 0c             	sub    $0xc,%esp
8010795d:	8b 75 14             	mov    0x14(%ebp),%esi
80107960:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107963:	85 f6                	test   %esi,%esi
80107965:	75 3c                	jne    801079a3 <copyout+0x53>
80107967:	eb 67                	jmp    801079d0 <copyout+0x80>
80107969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107970:	8b 55 0c             	mov    0xc(%ebp),%edx
80107973:	89 fb                	mov    %edi,%ebx
80107975:	29 d3                	sub    %edx,%ebx
80107977:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010797d:	39 f3                	cmp    %esi,%ebx
8010797f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107982:	29 fa                	sub    %edi,%edx
80107984:	83 ec 04             	sub    $0x4,%esp
80107987:	01 c2                	add    %eax,%edx
80107989:	53                   	push   %ebx
8010798a:	ff 75 10             	pushl  0x10(%ebp)
8010798d:	52                   	push   %edx
8010798e:	e8 ad d5 ff ff       	call   80104f40 <memmove>
    len -= n;
    buf += n;
80107993:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107996:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010799c:	83 c4 10             	add    $0x10,%esp
8010799f:	29 de                	sub    %ebx,%esi
801079a1:	74 2d                	je     801079d0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801079a3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801079a5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801079a8:	89 55 0c             	mov    %edx,0xc(%ebp)
801079ab:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801079b1:	57                   	push   %edi
801079b2:	ff 75 08             	pushl  0x8(%ebp)
801079b5:	e8 56 ff ff ff       	call   80107910 <uva2ka>
    if(pa0 == 0)
801079ba:	83 c4 10             	add    $0x10,%esp
801079bd:	85 c0                	test   %eax,%eax
801079bf:	75 af                	jne    80107970 <copyout+0x20>
  }
  return 0;
}
801079c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079c9:	5b                   	pop    %ebx
801079ca:	5e                   	pop    %esi
801079cb:	5f                   	pop    %edi
801079cc:	5d                   	pop    %ebp
801079cd:	c3                   	ret    
801079ce:	66 90                	xchg   %ax,%ax
801079d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079d3:	31 c0                	xor    %eax,%eax
}
801079d5:	5b                   	pop    %ebx
801079d6:	5e                   	pop    %esi
801079d7:	5f                   	pop    %edi
801079d8:	5d                   	pop    %ebp
801079d9:	c3                   	ret    
