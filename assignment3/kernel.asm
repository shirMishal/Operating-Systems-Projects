
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
80100050:	68 00 81 10 80       	push   $0x80108100
80100055:	68 e0 c5 10 80       	push   $0x8010c5e0
8010005a:	e8 61 4d 00 00       	call   80104dc0 <initlock>
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
80100092:	68 07 81 10 80       	push   $0x80108107
80100097:	50                   	push   %eax
80100098:	e8 e3 4b 00 00       	call   80104c80 <initsleeplock>
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
801000e8:	e8 53 4e 00 00       	call   80104f40 <acquire>
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
80100162:	e8 99 4e 00 00       	call   80105000 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 4b 00 00       	call   80104cc0 <acquiresleep>
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
801001a3:	68 0e 81 10 80       	push   $0x8010810e
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
801001c2:	e8 99 4b 00 00       	call   80104d60 <holdingsleep>
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
801001e0:	68 1f 81 10 80       	push   $0x8010811f
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
80100203:	e8 58 4b 00 00       	call   80104d60 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 08 4b 00 00       	call   80104d20 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010021f:	e8 1c 4d 00 00       	call   80104f40 <acquire>
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
80100270:	e9 8b 4d 00 00       	jmp    80105000 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 26 81 10 80       	push   $0x80108126
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
801002b1:	e8 8a 4c 00 00       	call   80104f40 <acquire>
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
8010030e:	e8 ed 4c 00 00       	call   80105000 <release>
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
80100365:	e8 96 4c 00 00       	call   80105000 <release>
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
801003b6:	68 2d 81 10 80       	push   $0x8010812d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 4f 8b 10 80 	movl   $0x80108b4f,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ff 49 00 00       	call   80104de0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 41 81 10 80       	push   $0x80108141
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
8010042a:	e8 71 63 00 00       	call   801067a0 <uartputc>
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
80100515:	e8 86 62 00 00       	call   801067a0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 7a 62 00 00       	call   801067a0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 6e 62 00 00       	call   801067a0 <uartputc>
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
80100561:	e8 8a 4b 00 00       	call   801050f0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 d5 4a 00 00       	call   80105050 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 45 81 10 80       	push   $0x80108145
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
801005c9:	0f b6 92 70 81 10 80 	movzbl -0x7fef7e90(%edx),%edx
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
8010065f:	e8 dc 48 00 00       	call   80104f40 <acquire>
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
80100697:	e8 64 49 00 00       	call   80105000 <release>
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
8010077d:	bb 58 81 10 80       	mov    $0x80108158,%ebx
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
801007bd:	e8 7e 47 00 00       	call   80104f40 <acquire>
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
80100828:	e8 d3 47 00 00       	call   80105000 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 5f 81 10 80       	push   $0x8010815f
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
80100877:	e8 c4 46 00 00       	call   80104f40 <acquire>
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
801009cf:	e8 2c 46 00 00       	call   80105000 <release>
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
80100a3a:	68 68 81 10 80       	push   $0x80108168
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 77 43 00 00       	call   80104dc0 <initlock>

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
80100b94:	e8 a7 6d 00 00       	call   80107940 <setupkvm>
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
80100d7f:	e8 5c 6f 00 00       	call   80107ce0 <allocuvm>
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
80100db5:	e8 96 68 00 00       	call   80107650 <loaduvm>
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
80100ee9:	e8 42 69 00 00       	call   80107830 <freevm>
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
80100f89:	e8 52 6d 00 00       	call   80107ce0 <allocuvm>
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
80100fae:	e8 2d 6a 00 00       	call   801079e0 <clearpteu>
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
80100fff:	e8 4c 42 00 00       	call   80105250 <strlen>
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
80101012:	e8 39 42 00 00       	call   80105250 <strlen>
80101017:	83 c0 01             	add    $0x1,%eax
8010101a:	50                   	push   %eax
8010101b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010101e:	ff 34 b8             	pushl  (%eax,%edi,4)
80101021:	53                   	push   %ebx
80101022:	56                   	push   %esi
80101023:	e8 18 6b 00 00       	call   80107b40 <copyout>
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
80101044:	e8 e7 67 00 00       	call   80107830 <freevm>
80101049:	83 c4 10             	add    $0x10,%esp
8010104c:	e9 a8 fe ff ff       	jmp    80100ef9 <exec+0x3e9>
  ip = 0;
80101051:	31 f6                	xor    %esi,%esi
80101053:	e9 aa fd ff ff       	jmp    80100e02 <exec+0x2f2>
    end_op();
80101058:	e8 83 24 00 00       	call   801034e0 <end_op>
    cprintf("exec: fail\n");
8010105d:	83 ec 0c             	sub    $0xc,%esp
80101060:	68 81 81 10 80       	push   $0x80108181
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
801010bb:	e8 80 6a 00 00       	call   80107b40 <copyout>
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
801010f3:	e8 18 41 00 00       	call   80105210 <safestrcpy>
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
8010112b:	e8 90 63 00 00       	call   801074c0 <switchuvm>
  freevm(oldpgdir);
80101130:	89 1c 24             	mov    %ebx,(%esp)
80101133:	e8 f8 66 00 00       	call   80107830 <freevm>
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
80101185:	e8 a6 66 00 00       	call   80107830 <freevm>
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
801011aa:	68 8d 81 10 80       	push   $0x8010818d
801011af:	68 e0 0f 11 80       	push   $0x80110fe0
801011b4:	e8 07 3c 00 00       	call   80104dc0 <initlock>
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
801011d5:	e8 66 3d 00 00       	call   80104f40 <acquire>
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
80101201:	e8 fa 3d 00 00       	call   80105000 <release>
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
8010121a:	e8 e1 3d 00 00       	call   80105000 <release>
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
80101243:	e8 f8 3c 00 00       	call   80104f40 <acquire>
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
80101260:	e8 9b 3d 00 00       	call   80105000 <release>
  return f;
}
80101265:	89 d8                	mov    %ebx,%eax
80101267:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010126a:	c9                   	leave  
8010126b:	c3                   	ret    
    panic("filedup");
8010126c:	83 ec 0c             	sub    $0xc,%esp
8010126f:	68 94 81 10 80       	push   $0x80108194
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
80101295:	e8 a6 3c 00 00       	call   80104f40 <acquire>
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
801012d0:	e8 2b 3d 00 00       	call   80105000 <release>

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
801012fe:	e9 fd 3c 00 00       	jmp    80105000 <release>
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
8010134c:	68 9c 81 10 80       	push   $0x8010819c
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
8010143a:	68 a6 81 10 80       	push   $0x801081a6
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
80101523:	68 af 81 10 80       	push   $0x801081af
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
80101559:	68 b5 81 10 80       	push   $0x801081b5
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
801015d7:	68 bf 81 10 80       	push   $0x801081bf
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
80101694:	68 d2 81 10 80       	push   $0x801081d2
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
801016d5:	e8 76 39 00 00       	call   80105050 <memset>
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
8010171a:	e8 21 38 00 00       	call   80104f40 <acquire>
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
80101787:	e8 74 38 00 00       	call   80105000 <release>

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
801017b5:	e8 46 38 00 00       	call   80105000 <release>
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
801017e2:	68 e8 81 10 80       	push   $0x801081e8
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
801018ab:	68 f8 81 10 80       	push   $0x801081f8
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
801018e5:	e8 06 38 00 00       	call   801050f0 <memmove>
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
80101910:	68 0b 82 10 80       	push   $0x8010820b
80101915:	68 00 1a 11 80       	push   $0x80111a00
8010191a:	e8 a1 34 00 00       	call   80104dc0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010191f:	83 c4 10             	add    $0x10,%esp
80101922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101928:	83 ec 08             	sub    $0x8,%esp
8010192b:	68 12 82 10 80       	push   $0x80108212
80101930:	53                   	push   %ebx
80101931:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101937:	e8 44 33 00 00       	call   80104c80 <initsleeplock>
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
80101981:	68 bc 82 10 80       	push   $0x801082bc
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
80101a1e:	e8 2d 36 00 00       	call   80105050 <memset>
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
80101a53:	68 18 82 10 80       	push   $0x80108218
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
80101ac5:	e8 26 36 00 00       	call   801050f0 <memmove>
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
80101b03:	e8 38 34 00 00       	call   80104f40 <acquire>
  ip->ref++;
80101b08:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101b0c:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101b13:	e8 e8 34 00 00       	call   80105000 <release>
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
80101b46:	e8 75 31 00 00       	call   80104cc0 <acquiresleep>
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
80101bb8:	e8 33 35 00 00       	call   801050f0 <memmove>
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
80101bdd:	68 30 82 10 80       	push   $0x80108230
80101be2:	e8 a9 e7 ff ff       	call   80100390 <panic>
    panic("ilock");
80101be7:	83 ec 0c             	sub    $0xc,%esp
80101bea:	68 2a 82 10 80       	push   $0x8010822a
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
80101c17:	e8 44 31 00 00       	call   80104d60 <holdingsleep>
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
80101c33:	e9 e8 30 00 00       	jmp    80104d20 <releasesleep>
    panic("iunlock");
80101c38:	83 ec 0c             	sub    $0xc,%esp
80101c3b:	68 3f 82 10 80       	push   $0x8010823f
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
80101c64:	e8 57 30 00 00       	call   80104cc0 <acquiresleep>
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
80101c7e:	e8 9d 30 00 00       	call   80104d20 <releasesleep>
  acquire(&icache.lock);
80101c83:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101c8a:	e8 b1 32 00 00       	call   80104f40 <acquire>
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
80101ca4:	e9 57 33 00 00       	jmp    80105000 <release>
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101cb0:	83 ec 0c             	sub    $0xc,%esp
80101cb3:	68 00 1a 11 80       	push   $0x80111a00
80101cb8:	e8 83 32 00 00       	call   80104f40 <acquire>
    int r = ip->ref;
80101cbd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101cc0:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101cc7:	e8 34 33 00 00       	call   80105000 <release>
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
80101ec7:	e8 24 32 00 00       	call   801050f0 <memmove>
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
80101fc3:	e8 28 31 00 00       	call   801050f0 <memmove>
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
80102062:	e8 f9 30 00 00       	call   80105160 <strncmp>
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
801020c5:	e8 96 30 00 00       	call   80105160 <strncmp>
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
8010210a:	68 59 82 10 80       	push   $0x80108259
8010210f:	e8 7c e2 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80102114:	83 ec 0c             	sub    $0xc,%esp
80102117:	68 47 82 10 80       	push   $0x80108247
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
8010215c:	e8 df 2d 00 00       	call   80104f40 <acquire>
  ip->ref++;
80102161:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102165:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010216c:	e8 8f 2e 00 00       	call   80105000 <release>
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
801021d7:	e8 14 2f 00 00       	call   801050f0 <memmove>
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
80102263:	e8 88 2e 00 00       	call   801050f0 <memmove>
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
80102395:	e8 16 2e 00 00       	call   801051b0 <strncpy>
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
801023d3:	68 68 82 10 80       	push   $0x80108268
801023d8:	e8 b3 df ff ff       	call   80100390 <panic>
    panic("dirlink");
801023dd:	83 ec 0c             	sub    $0xc,%esp
801023e0:	68 ad 88 10 80       	push   $0x801088ad
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
801024d5:	68 75 82 10 80       	push   $0x80108275
801024da:	56                   	push   %esi
801024db:	e8 10 2c 00 00       	call   801050f0 <memmove>
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
80102536:	68 7d 82 10 80       	push   $0x8010827d
8010253b:	53                   	push   %ebx
8010253c:	e8 1f 2c 00 00       	call   80105160 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102541:	83 c4 10             	add    $0x10,%esp
80102544:	85 c0                	test   %eax,%eax
80102546:	0f 84 f4 00 00 00    	je     80102640 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
8010254c:	83 ec 04             	sub    $0x4,%esp
8010254f:	6a 0e                	push   $0xe
80102551:	68 7c 82 10 80       	push   $0x8010827c
80102556:	53                   	push   %ebx
80102557:	e8 04 2c 00 00       	call   80105160 <strncmp>
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
801025ab:	e8 a0 2a 00 00       	call   80105050 <memset>
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
8010261c:	e8 ff 31 00 00       	call   80105820 <isdirempty>
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
8010268f:	68 91 82 10 80       	push   $0x80108291
80102694:	e8 f7 dc ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102699:	83 ec 0c             	sub    $0xc,%esp
8010269c:	68 7f 82 10 80       	push   $0x8010827f
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
801026c4:	68 75 82 10 80       	push   $0x80108275
801026c9:	56                   	push   %esi
801026ca:	e8 21 2a 00 00       	call   801050f0 <memmove>
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
801026e9:	e8 52 33 00 00       	call   80105a40 <create>
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
8010273d:	68 a0 82 10 80       	push   $0x801082a0
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
8010286b:	68 18 83 10 80       	push   $0x80108318
80102870:	e8 1b db ff ff       	call   80100390 <panic>
    panic("idestart");
80102875:	83 ec 0c             	sub    $0xc,%esp
80102878:	68 0f 83 10 80       	push   $0x8010830f
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
8010289a:	68 2a 83 10 80       	push   $0x8010832a
8010289f:	68 80 b5 10 80       	push   $0x8010b580
801028a4:	e8 17 25 00 00       	call   80104dc0 <initlock>
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
80102932:	e8 09 26 00 00       	call   80104f40 <acquire>

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
801029ab:	e8 50 26 00 00       	call   80105000 <release>

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
801029d2:	e8 89 23 00 00       	call   80104d60 <holdingsleep>
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
80102a0c:	e8 2f 25 00 00       	call   80104f40 <acquire>

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
80102a76:	e9 85 25 00 00       	jmp    80105000 <release>
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
80102a9a:	68 59 83 10 80       	push   $0x80108359
80102a9f:	e8 ec d8 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102aa4:	83 ec 0c             	sub    $0xc,%esp
80102aa7:	68 44 83 10 80       	push   $0x80108344
80102aac:	e8 df d8 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102ab1:	83 ec 0c             	sub    $0xc,%esp
80102ab4:	68 2e 83 10 80       	push   $0x8010832e
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
80102b0e:	68 78 83 10 80       	push   $0x80108378
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
80102be6:	e8 65 24 00 00       	call   80105050 <memset>

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
80102c20:	e8 1b 23 00 00       	call   80104f40 <acquire>
80102c25:	83 c4 10             	add    $0x10,%esp
80102c28:	eb ce                	jmp    80102bf8 <kfree+0x48>
80102c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102c30:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
80102c37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c3a:	c9                   	leave  
    release(&kmem.lock);
80102c3b:	e9 c0 23 00 00       	jmp    80105000 <release>
    panic("kfree");
80102c40:	83 ec 0c             	sub    $0xc,%esp
80102c43:	68 aa 83 10 80       	push   $0x801083aa
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
80102caf:	68 b0 83 10 80       	push   $0x801083b0
80102cb4:	68 60 36 11 80       	push   $0x80113660
80102cb9:	e8 02 21 00 00       	call   80104dc0 <initlock>
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
80102da3:	e8 98 21 00 00       	call   80104f40 <acquire>
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
80102dd1:	e8 2a 22 00 00       	call   80105000 <release>
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
80102e1f:	0f b6 8a e0 84 10 80 	movzbl -0x7fef7b20(%edx),%ecx
  shift ^= togglecode[data];
80102e26:	0f b6 82 e0 83 10 80 	movzbl -0x7fef7c20(%edx),%eax
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
80102e3f:	8b 04 85 c0 83 10 80 	mov    -0x7fef7c40(,%eax,4),%eax
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
80102e7a:	0f b6 8a e0 84 10 80 	movzbl -0x7fef7b20(%edx),%ecx
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
801031ff:	e8 9c 1e 00 00       	call   801050a0 <memcmp>
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
80103334:	e8 b7 1d 00 00       	call   801050f0 <memmove>
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
801033de:	68 e0 85 10 80       	push   $0x801085e0
801033e3:	68 a0 36 11 80       	push   $0x801136a0
801033e8:	e8 d3 19 00 00       	call   80104dc0 <initlock>
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
8010347f:	e8 bc 1a 00 00       	call   80104f40 <acquire>
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
801034d4:	e8 27 1b 00 00       	call   80105000 <release>
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
801034f2:	e8 49 1a 00 00       	call   80104f40 <acquire>
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
80103530:	e8 cb 1a 00 00       	call   80105000 <release>
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
8010354a:	e8 f1 19 00 00       	call   80104f40 <acquire>
    wakeup(&log);
8010354f:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80103556:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
8010355d:	00 00 00 
    wakeup(&log);
80103560:	e8 2b 15 00 00       	call   80104a90 <wakeup>
    release(&log.lock);
80103565:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
8010356c:	e8 8f 1a 00 00       	call   80105000 <release>
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
801035c4:	e8 27 1b 00 00       	call   801050f0 <memmove>
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
80103624:	e8 d7 19 00 00       	call   80105000 <release>
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
80103637:	68 e4 85 10 80       	push   $0x801085e4
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
80103692:	e8 a9 18 00 00       	call   80104f40 <acquire>
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
801036d5:	e9 26 19 00 00       	jmp    80105000 <release>
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
80103701:	68 f3 85 10 80       	push   $0x801085f3
80103706:	e8 85 cc ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010370b:	83 ec 0c             	sub    $0xc,%esp
8010370e:	68 09 86 10 80       	push   $0x80108609
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
80103738:	68 24 86 10 80       	push   $0x80108624
8010373d:	e8 6e cf ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103742:	e8 d9 2b 00 00       	call   80106320 <idtinit>
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
8010376a:	e8 31 3d 00 00       	call   801074a0 <switchkvm>
  seginit();
8010376f:	e8 7c 3c 00 00       	call   801073f0 <seginit>
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
801037a5:	e8 16 42 00 00       	call   801079c0 <kvmalloc>
  mpinit();        // detect other processors
801037aa:	e8 81 01 00 00       	call   80103930 <mpinit>
  lapicinit();     // interrupt controller
801037af:	e8 2c f7 ff ff       	call   80102ee0 <lapicinit>
  seginit();       // segment descriptors
801037b4:	e8 37 3c 00 00       	call   801073f0 <seginit>
  picinit();       // disable pic
801037b9:	e8 52 03 00 00       	call   80103b10 <picinit>
  ioapicinit();    // another interrupt controller
801037be:	e8 fd f2 ff ff       	call   80102ac0 <ioapicinit>
  consoleinit();   // console hardware
801037c3:	e8 68 d2 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801037c8:	e8 13 2f 00 00       	call   801066e0 <uartinit>
  pinit();         // process table
801037cd:	e8 8e 08 00 00       	call   80104060 <pinit>
  tvinit();        // trap vectors
801037d2:	e8 c9 2a 00 00       	call   801062a0 <tvinit>
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
801037f8:	e8 f3 18 00 00       	call   801050f0 <memmove>

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
801038de:	68 38 86 10 80       	push   $0x80108638
801038e3:	56                   	push   %esi
801038e4:	e8 b7 17 00 00       	call   801050a0 <memcmp>
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
8010399a:	68 3d 86 10 80       	push   $0x8010863d
8010399f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801039a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801039a3:	e8 f8 16 00 00       	call   801050a0 <memcmp>
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
80103af3:	68 42 86 10 80       	push   $0x80108642
80103af8:	e8 93 c8 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103afd:	83 ec 0c             	sub    $0xc,%esp
80103b00:	68 5c 86 10 80       	push   $0x8010865c
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
80103ba7:	68 7b 86 10 80       	push   $0x8010867b
80103bac:	50                   	push   %eax
80103bad:	e8 0e 12 00 00       	call   80104dc0 <initlock>
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
80103c53:	e8 e8 12 00 00       	call   80104f40 <acquire>
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
80103c98:	e9 63 13 00 00       	jmp    80105000 <release>
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
80103cc4:	e8 37 13 00 00       	call   80105000 <release>
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
80103cf1:	e8 4a 12 00 00       	call   80104f40 <acquire>
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
80103d7c:	e8 7f 12 00 00       	call   80105000 <release>
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
80103dd2:	e8 29 12 00 00       	call   80105000 <release>
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
80103dfa:	e8 41 11 00 00       	call   80104f40 <acquire>
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
80103e9e:	e8 5d 11 00 00       	call   80105000 <release>
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
80103eb9:	e8 42 11 00 00       	call   80105000 <release>
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
80103ee1:	e8 5a 10 00 00       	call   80104f40 <acquire>
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
80103f29:	e8 d2 10 00 00       	call   80105000 <release>

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
80103f52:	c7 40 14 86 62 10 80 	movl   $0x80106286,0x14(%eax)
  p->context = (struct context*)sp;
80103f59:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103f5c:	6a 14                	push   $0x14
80103f5e:	6a 00                	push   $0x0
80103f60:	50                   	push   %eax
80103f61:	e8 ea 10 00 00       	call   80105050 <memset>
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
80103fea:	e8 11 10 00 00       	call   80105000 <release>
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
8010401f:	e8 dc 0f 00 00       	call   80105000 <release>

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
8010406a:	68 80 86 10 80       	push   $0x80108680
8010406f:	68 40 3d 11 80       	push   $0x80113d40
80104074:	e8 47 0d 00 00       	call   80104dc0 <initlock>
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
801040d0:	68 87 86 10 80       	push   $0x80108687
801040d5:	e8 b6 c2 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801040da:	83 ec 0c             	sub    $0xc,%esp
801040dd:	68 74 87 10 80       	push   $0x80108774
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
8010411b:	e8 20 0d 00 00       	call   80104e40 <pushcli>
  c = mycpu();
80104120:	e8 5b ff ff ff       	call   80104080 <mycpu>
  p = c->proc;
80104125:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010412b:	e8 60 0d 00 00       	call   80104e90 <popcli>
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
80104157:	e8 e4 37 00 00       	call   80107940 <setupkvm>
8010415c:	89 43 04             	mov    %eax,0x4(%ebx)
8010415f:	85 c0                	test   %eax,%eax
80104161:	0f 84 bd 00 00 00    	je     80104224 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104167:	83 ec 04             	sub    $0x4,%esp
8010416a:	68 2c 00 00 00       	push   $0x2c
8010416f:	68 60 b4 10 80       	push   $0x8010b460
80104174:	50                   	push   %eax
80104175:	e8 56 34 00 00       	call   801075d0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010417a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010417d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104183:	6a 4c                	push   $0x4c
80104185:	6a 00                	push   $0x0
80104187:	ff 73 18             	pushl  0x18(%ebx)
8010418a:	e8 c1 0e 00 00       	call   80105050 <memset>
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
801041e3:	68 b0 86 10 80       	push   $0x801086b0
801041e8:	50                   	push   %eax
801041e9:	e8 22 10 00 00       	call   80105210 <safestrcpy>
  p->cwd = namei("/");
801041ee:	c7 04 24 b9 86 10 80 	movl   $0x801086b9,(%esp)
801041f5:	e8 f6 e1 ff ff       	call   801023f0 <namei>
801041fa:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801041fd:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104204:	e8 37 0d 00 00       	call   80104f40 <acquire>
  p->state = RUNNABLE;
80104209:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104210:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104217:	e8 e4 0d 00 00       	call   80105000 <release>
}
8010421c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010421f:	83 c4 10             	add    $0x10,%esp
80104222:	c9                   	leave  
80104223:	c3                   	ret    
    panic("userinit: out of memory?");
80104224:	83 ec 0c             	sub    $0xc,%esp
80104227:	68 97 86 10 80       	push   $0x80108697
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
8010424c:	e8 ef 0b 00 00       	call   80104e40 <pushcli>
  c = mycpu();
80104251:	e8 2a fe ff ff       	call   80104080 <mycpu>
  p = c->proc;
80104256:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010425c:	e8 2f 0c 00 00       	call   80104e90 <popcli>
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
8010426f:	e8 4c 32 00 00       	call   801074c0 <switchuvm>
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
8010428a:	e8 51 3a 00 00       	call   80107ce0 <allocuvm>
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
801042aa:	e8 71 34 00 00       	call   80107720 <deallocuvm>
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
801042cd:	e8 6e 0b 00 00       	call   80104e40 <pushcli>
  c = mycpu();
801042d2:	e8 a9 fd ff ff       	call   80104080 <mycpu>
  p = c->proc;
801042d7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042dd:	e8 ae 0b 00 00       	call   80104e90 <popcli>
  if((np = allocproc()) == 0){
801042e2:	e8 e9 fb ff ff       	call   80103ed0 <allocproc>
801042e7:	85 c0                	test   %eax,%eax
801042e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801042ec:	0f 84 13 02 00 00    	je     80104505 <fork+0x245>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801042f2:	83 ec 08             	sub    $0x8,%esp
801042f5:	ff 33                	pushl  (%ebx)
801042f7:	ff 73 04             	pushl  0x4(%ebx)
801042fa:	e8 11 37 00 00       	call   80107a10 <copyuvm>
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
80104379:	e8 92 0e 00 00       	call   80105210 <safestrcpy>
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
801043a0:	e8 9b 0b 00 00       	call   80104f40 <acquire>
  np->state = RUNNABLE;
801043a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043a8:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
801043af:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
801043b6:	e8 45 0c 00 00       	call   80105000 <release>
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
80104576:	e8 c5 09 00 00       	call   80104f40 <acquire>
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
80104590:	e8 2b 2f 00 00       	call   801074c0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104595:	58                   	pop    %eax
80104596:	5a                   	pop    %edx
80104597:	ff 73 1c             	pushl  0x1c(%ebx)
8010459a:	57                   	push   %edi
      p->state = RUNNING;
8010459b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801045a2:	e8 cc 0c 00 00       	call   80105273 <swtch>
      switchkvm();
801045a7:	e8 f4 2e 00 00       	call   801074a0 <switchkvm>
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
801045cf:	e8 2c 0a 00 00       	call   80105000 <release>
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
801045e9:	e8 52 08 00 00       	call   80104e40 <pushcli>
  c = mycpu();
801045ee:	e8 8d fa ff ff       	call   80104080 <mycpu>
  p = c->proc;
801045f3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045f9:	e8 92 08 00 00       	call   80104e90 <popcli>
  if(!holding(&ptable.lock))
801045fe:	83 ec 0c             	sub    $0xc,%esp
80104601:	68 40 3d 11 80       	push   $0x80113d40
80104606:	e8 e5 08 00 00       	call   80104ef0 <holding>
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
80104647:	e8 27 0c 00 00       	call   80105273 <swtch>
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
80104664:	68 bb 86 10 80       	push   $0x801086bb
80104669:	e8 22 bd ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010466e:	83 ec 0c             	sub    $0xc,%esp
80104671:	68 e7 86 10 80       	push   $0x801086e7
80104676:	e8 15 bd ff ff       	call   80100390 <panic>
    panic("sched running");
8010467b:	83 ec 0c             	sub    $0xc,%esp
8010467e:	68 d9 86 10 80       	push   $0x801086d9
80104683:	e8 08 bd ff ff       	call   80100390 <panic>
    panic("sched locks");
80104688:	83 ec 0c             	sub    $0xc,%esp
8010468b:	68 cd 86 10 80       	push   $0x801086cd
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
801046ad:	e8 8e 07 00 00       	call   80104e40 <pushcli>
  c = mycpu();
801046b2:	e8 c9 f9 ff ff       	call   80104080 <mycpu>
  p = c->proc;
801046b7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046bd:	e8 ce 07 00 00       	call   80104e90 <popcli>
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
80104722:	e8 19 08 00 00       	call   80104f40 <acquire>
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
801047c7:	68 08 87 10 80       	push   $0x80108708
801047cc:	e8 bf bb ff ff       	call   80100390 <panic>
    panic("init exiting");
801047d1:	83 ec 0c             	sub    $0xc,%esp
801047d4:	68 fb 86 10 80       	push   $0x801086fb
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
801047f0:	e8 4b 07 00 00       	call   80104f40 <acquire>
  pushcli();
801047f5:	e8 46 06 00 00       	call   80104e40 <pushcli>
  c = mycpu();
801047fa:	e8 81 f8 ff ff       	call   80104080 <mycpu>
  p = c->proc;
801047ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104805:	e8 86 06 00 00       	call   80104e90 <popcli>
  myproc()->state = RUNNABLE;
8010480a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104811:	e8 ca fd ff ff       	call   801045e0 <sched>
  release(&ptable.lock);
80104816:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010481d:	e8 de 07 00 00       	call   80105000 <release>
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
80104843:	e8 f8 05 00 00       	call   80104e40 <pushcli>
  c = mycpu();
80104848:	e8 33 f8 ff ff       	call   80104080 <mycpu>
  p = c->proc;
8010484d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104853:	e8 38 06 00 00       	call   80104e90 <popcli>
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
80104874:	e8 c7 06 00 00       	call   80104f40 <acquire>
    release(lk);
80104879:	89 34 24             	mov    %esi,(%esp)
8010487c:	e8 7f 07 00 00       	call   80105000 <release>
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
8010489e:	e8 5d 07 00 00       	call   80105000 <release>
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
801048b0:	e9 8b 06 00 00       	jmp    80104f40 <acquire>
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
801048d9:	68 1a 87 10 80       	push   $0x8010871a
801048de:	e8 ad ba ff ff       	call   80100390 <panic>
    panic("sleep");
801048e3:	83 ec 0c             	sub    $0xc,%esp
801048e6:	68 14 87 10 80       	push   $0x80108714
801048eb:	e8 a0 ba ff ff       	call   80100390 <panic>

801048f0 <wait>:
{
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	56                   	push   %esi
801048f8:	53                   	push   %ebx
  pushcli();
801048f9:	e8 42 05 00 00       	call   80104e40 <pushcli>
  c = mycpu();
801048fe:	e8 7d f7 ff ff       	call   80104080 <mycpu>
  p = c->proc;
80104903:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104909:	e8 82 05 00 00       	call   80104e90 <popcli>
  acquire(&ptable.lock);
8010490e:	83 ec 0c             	sub    $0xc,%esp
80104911:	68 40 3d 11 80       	push   $0x80113d40
80104916:	e8 25 06 00 00       	call   80104f40 <acquire>
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
80104a30:	e8 fb 2d 00 00       	call   80107830 <freevm>
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
80104a5c:	e8 9f 05 00 00       	call   80105000 <release>
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
80104a7a:	e8 81 05 00 00       	call   80105000 <release>
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
80104aa3:	e8 98 04 00 00       	call   80104f40 <acquire>
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
80104aed:	e9 0e 05 00 00       	jmp    80105000 <release>
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
80104b13:	e8 28 04 00 00       	call   80104f40 <acquire>
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
80104b55:	e8 a6 04 00 00       	call   80105000 <release>
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
80104b70:	e8 8b 04 00 00       	call   80105000 <release>
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
80104bb3:	68 4f 8b 10 80       	push   $0x80108b4f
80104bb8:	e8 f3 ba ff ff       	call   801006b0 <cprintf>
80104bbd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bc0:	81 c3 90 03 00 00    	add    $0x390,%ebx
80104bc6:	81 fb e0 21 12 80    	cmp    $0x801221e0,%ebx
80104bcc:	0f 84 9e 00 00 00    	je     80104c70 <procdump+0xe0>
    if(p->state == UNUSED)
80104bd2:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104bd5:	85 c0                	test   %eax,%eax
80104bd7:	74 e7                	je     80104bc0 <procdump+0x30>
      state = "???";
80104bd9:	ba 2b 87 10 80       	mov    $0x8010872b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104bde:	83 f8 05             	cmp    $0x5,%eax
80104be1:	77 11                	ja     80104bf4 <procdump+0x64>
80104be3:	8b 14 85 9c 87 10 80 	mov    -0x7fef7864(,%eax,4),%edx
      state = "???";
80104bea:	b8 2b 87 10 80       	mov    $0x8010872b,%eax
80104bef:	85 d2                	test   %edx,%edx
80104bf1:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s RAM: %d SWAP: %d", p->pid, state, p->name, p->num_of_actual_pages_in_mem, p->num_of_pages_in_swap_file);
80104bf4:	83 ec 08             	sub    $0x8,%esp
80104bf7:	ff b3 14 03 00 00    	pushl  0x314(%ebx)
80104bfd:	ff b3 18 03 00 00    	pushl  0x318(%ebx)
80104c03:	53                   	push   %ebx
80104c04:	52                   	push   %edx
80104c05:	ff 73 a4             	pushl  -0x5c(%ebx)
80104c08:	68 2f 87 10 80       	push   $0x8010872f
80104c0d:	e8 9e ba ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104c12:	83 c4 20             	add    $0x20,%esp
80104c15:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104c19:	75 95                	jne    80104bb0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104c1b:	83 ec 08             	sub    $0x8,%esp
80104c1e:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104c21:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104c24:	50                   	push   %eax
80104c25:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104c28:	8b 40 0c             	mov    0xc(%eax),%eax
80104c2b:	83 c0 08             	add    $0x8,%eax
80104c2e:	50                   	push   %eax
80104c2f:	e8 ac 01 00 00       	call   80104de0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c34:	83 c4 10             	add    $0x10,%esp
80104c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3e:	66 90                	xchg   %ax,%ax
80104c40:	8b 17                	mov    (%edi),%edx
80104c42:	85 d2                	test   %edx,%edx
80104c44:	0f 84 66 ff ff ff    	je     80104bb0 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104c4a:	83 ec 08             	sub    $0x8,%esp
80104c4d:	83 c7 04             	add    $0x4,%edi
80104c50:	52                   	push   %edx
80104c51:	68 41 81 10 80       	push   $0x80108141
80104c56:	e8 55 ba ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c5b:	83 c4 10             	add    $0x10,%esp
80104c5e:	39 fe                	cmp    %edi,%esi
80104c60:	75 de                	jne    80104c40 <procdump+0xb0>
80104c62:	e9 49 ff ff ff       	jmp    80104bb0 <procdump+0x20>
80104c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6e:	66 90                	xchg   %ax,%ax
  }
}
80104c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c73:	5b                   	pop    %ebx
80104c74:	5e                   	pop    %esi
80104c75:	5f                   	pop    %edi
80104c76:	5d                   	pop    %ebp
80104c77:	c3                   	ret    
80104c78:	66 90                	xchg   %ax,%ax
80104c7a:	66 90                	xchg   %ax,%ax
80104c7c:	66 90                	xchg   %ax,%ax
80104c7e:	66 90                	xchg   %ax,%ax

80104c80 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104c80:	f3 0f 1e fb          	endbr32 
80104c84:	55                   	push   %ebp
80104c85:	89 e5                	mov    %esp,%ebp
80104c87:	53                   	push   %ebx
80104c88:	83 ec 0c             	sub    $0xc,%esp
80104c8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104c8e:	68 b4 87 10 80       	push   $0x801087b4
80104c93:	8d 43 04             	lea    0x4(%ebx),%eax
80104c96:	50                   	push   %eax
80104c97:	e8 24 01 00 00       	call   80104dc0 <initlock>
  lk->name = name;
80104c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104c9f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104ca5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104ca8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104caf:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104cb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cb5:	c9                   	leave  
80104cb6:	c3                   	ret    
80104cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104cc0:	f3 0f 1e fb          	endbr32 
80104cc4:	55                   	push   %ebp
80104cc5:	89 e5                	mov    %esp,%ebp
80104cc7:	56                   	push   %esi
80104cc8:	53                   	push   %ebx
80104cc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ccc:	8d 73 04             	lea    0x4(%ebx),%esi
80104ccf:	83 ec 0c             	sub    $0xc,%esp
80104cd2:	56                   	push   %esi
80104cd3:	e8 68 02 00 00       	call   80104f40 <acquire>
  while (lk->locked) {
80104cd8:	8b 13                	mov    (%ebx),%edx
80104cda:	83 c4 10             	add    $0x10,%esp
80104cdd:	85 d2                	test   %edx,%edx
80104cdf:	74 1a                	je     80104cfb <acquiresleep+0x3b>
80104ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104ce8:	83 ec 08             	sub    $0x8,%esp
80104ceb:	56                   	push   %esi
80104cec:	53                   	push   %ebx
80104ced:	e8 3e fb ff ff       	call   80104830 <sleep>
  while (lk->locked) {
80104cf2:	8b 03                	mov    (%ebx),%eax
80104cf4:	83 c4 10             	add    $0x10,%esp
80104cf7:	85 c0                	test   %eax,%eax
80104cf9:	75 ed                	jne    80104ce8 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104cfb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104d01:	e8 0a f4 ff ff       	call   80104110 <myproc>
80104d06:	8b 40 10             	mov    0x10(%eax),%eax
80104d09:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104d0c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104d0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d12:	5b                   	pop    %ebx
80104d13:	5e                   	pop    %esi
80104d14:	5d                   	pop    %ebp
  release(&lk->lk);
80104d15:	e9 e6 02 00 00       	jmp    80105000 <release>
80104d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d20 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104d20:	f3 0f 1e fb          	endbr32 
80104d24:	55                   	push   %ebp
80104d25:	89 e5                	mov    %esp,%ebp
80104d27:	56                   	push   %esi
80104d28:	53                   	push   %ebx
80104d29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d2c:	8d 73 04             	lea    0x4(%ebx),%esi
80104d2f:	83 ec 0c             	sub    $0xc,%esp
80104d32:	56                   	push   %esi
80104d33:	e8 08 02 00 00       	call   80104f40 <acquire>
  lk->locked = 0;
80104d38:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104d3e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104d45:	89 1c 24             	mov    %ebx,(%esp)
80104d48:	e8 43 fd ff ff       	call   80104a90 <wakeup>
  release(&lk->lk);
80104d4d:	89 75 08             	mov    %esi,0x8(%ebp)
80104d50:	83 c4 10             	add    $0x10,%esp
}
80104d53:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d56:	5b                   	pop    %ebx
80104d57:	5e                   	pop    %esi
80104d58:	5d                   	pop    %ebp
  release(&lk->lk);
80104d59:	e9 a2 02 00 00       	jmp    80105000 <release>
80104d5e:	66 90                	xchg   %ax,%ax

80104d60 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104d60:	f3 0f 1e fb          	endbr32 
80104d64:	55                   	push   %ebp
80104d65:	89 e5                	mov    %esp,%ebp
80104d67:	57                   	push   %edi
80104d68:	31 ff                	xor    %edi,%edi
80104d6a:	56                   	push   %esi
80104d6b:	53                   	push   %ebx
80104d6c:	83 ec 18             	sub    $0x18,%esp
80104d6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104d72:	8d 73 04             	lea    0x4(%ebx),%esi
80104d75:	56                   	push   %esi
80104d76:	e8 c5 01 00 00       	call   80104f40 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104d7b:	8b 03                	mov    (%ebx),%eax
80104d7d:	83 c4 10             	add    $0x10,%esp
80104d80:	85 c0                	test   %eax,%eax
80104d82:	75 1c                	jne    80104da0 <holdingsleep+0x40>
  release(&lk->lk);
80104d84:	83 ec 0c             	sub    $0xc,%esp
80104d87:	56                   	push   %esi
80104d88:	e8 73 02 00 00       	call   80105000 <release>
  return r;
}
80104d8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d90:	89 f8                	mov    %edi,%eax
80104d92:	5b                   	pop    %ebx
80104d93:	5e                   	pop    %esi
80104d94:	5f                   	pop    %edi
80104d95:	5d                   	pop    %ebp
80104d96:	c3                   	ret    
80104d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104da0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104da3:	e8 68 f3 ff ff       	call   80104110 <myproc>
80104da8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104dab:	0f 94 c0             	sete   %al
80104dae:	0f b6 c0             	movzbl %al,%eax
80104db1:	89 c7                	mov    %eax,%edi
80104db3:	eb cf                	jmp    80104d84 <holdingsleep+0x24>
80104db5:	66 90                	xchg   %ax,%ax
80104db7:	66 90                	xchg   %ax,%ax
80104db9:	66 90                	xchg   %ax,%ax
80104dbb:	66 90                	xchg   %ax,%ax
80104dbd:	66 90                	xchg   %ax,%ax
80104dbf:	90                   	nop

80104dc0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104dc0:	f3 0f 1e fb          	endbr32 
80104dc4:	55                   	push   %ebp
80104dc5:	89 e5                	mov    %esp,%ebp
80104dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104dca:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104dcd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104dd3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104dd6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104ddd:	5d                   	pop    %ebp
80104dde:	c3                   	ret    
80104ddf:	90                   	nop

80104de0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104de5:	31 d2                	xor    %edx,%edx
{
80104de7:	89 e5                	mov    %esp,%ebp
80104de9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104dea:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ded:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104df0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104df3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104df7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104df8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104dfe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104e04:	77 1a                	ja     80104e20 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104e06:	8b 58 04             	mov    0x4(%eax),%ebx
80104e09:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104e0c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104e0f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e11:	83 fa 0a             	cmp    $0xa,%edx
80104e14:	75 e2                	jne    80104df8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104e16:	5b                   	pop    %ebx
80104e17:	5d                   	pop    %ebp
80104e18:	c3                   	ret    
80104e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104e20:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104e23:	8d 51 28             	lea    0x28(%ecx),%edx
80104e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104e30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e36:	83 c0 04             	add    $0x4,%eax
80104e39:	39 d0                	cmp    %edx,%eax
80104e3b:	75 f3                	jne    80104e30 <getcallerpcs+0x50>
}
80104e3d:	5b                   	pop    %ebx
80104e3e:	5d                   	pop    %ebp
80104e3f:	c3                   	ret    

80104e40 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104e40:	f3 0f 1e fb          	endbr32 
80104e44:	55                   	push   %ebp
80104e45:	89 e5                	mov    %esp,%ebp
80104e47:	53                   	push   %ebx
80104e48:	83 ec 04             	sub    $0x4,%esp
80104e4b:	9c                   	pushf  
80104e4c:	5b                   	pop    %ebx
  asm volatile("cli");
80104e4d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104e4e:	e8 2d f2 ff ff       	call   80104080 <mycpu>
80104e53:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104e59:	85 c0                	test   %eax,%eax
80104e5b:	74 13                	je     80104e70 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104e5d:	e8 1e f2 ff ff       	call   80104080 <mycpu>
80104e62:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104e69:	83 c4 04             	add    $0x4,%esp
80104e6c:	5b                   	pop    %ebx
80104e6d:	5d                   	pop    %ebp
80104e6e:	c3                   	ret    
80104e6f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104e70:	e8 0b f2 ff ff       	call   80104080 <mycpu>
80104e75:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104e7b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104e81:	eb da                	jmp    80104e5d <pushcli+0x1d>
80104e83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e90 <popcli>:

void
popcli(void)
{
80104e90:	f3 0f 1e fb          	endbr32 
80104e94:	55                   	push   %ebp
80104e95:	89 e5                	mov    %esp,%ebp
80104e97:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e9a:	9c                   	pushf  
80104e9b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104e9c:	f6 c4 02             	test   $0x2,%ah
80104e9f:	75 31                	jne    80104ed2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104ea1:	e8 da f1 ff ff       	call   80104080 <mycpu>
80104ea6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104ead:	78 30                	js     80104edf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104eaf:	e8 cc f1 ff ff       	call   80104080 <mycpu>
80104eb4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104eba:	85 d2                	test   %edx,%edx
80104ebc:	74 02                	je     80104ec0 <popcli+0x30>
    sti();
}
80104ebe:	c9                   	leave  
80104ebf:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ec0:	e8 bb f1 ff ff       	call   80104080 <mycpu>
80104ec5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104ecb:	85 c0                	test   %eax,%eax
80104ecd:	74 ef                	je     80104ebe <popcli+0x2e>
  asm volatile("sti");
80104ecf:	fb                   	sti    
}
80104ed0:	c9                   	leave  
80104ed1:	c3                   	ret    
    panic("popcli - interruptible");
80104ed2:	83 ec 0c             	sub    $0xc,%esp
80104ed5:	68 bf 87 10 80       	push   $0x801087bf
80104eda:	e8 b1 b4 ff ff       	call   80100390 <panic>
    panic("popcli");
80104edf:	83 ec 0c             	sub    $0xc,%esp
80104ee2:	68 d6 87 10 80       	push   $0x801087d6
80104ee7:	e8 a4 b4 ff ff       	call   80100390 <panic>
80104eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ef0 <holding>:
{
80104ef0:	f3 0f 1e fb          	endbr32 
80104ef4:	55                   	push   %ebp
80104ef5:	89 e5                	mov    %esp,%ebp
80104ef7:	56                   	push   %esi
80104ef8:	53                   	push   %ebx
80104ef9:	8b 75 08             	mov    0x8(%ebp),%esi
80104efc:	31 db                	xor    %ebx,%ebx
  pushcli();
80104efe:	e8 3d ff ff ff       	call   80104e40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104f03:	8b 06                	mov    (%esi),%eax
80104f05:	85 c0                	test   %eax,%eax
80104f07:	75 0f                	jne    80104f18 <holding+0x28>
  popcli();
80104f09:	e8 82 ff ff ff       	call   80104e90 <popcli>
}
80104f0e:	89 d8                	mov    %ebx,%eax
80104f10:	5b                   	pop    %ebx
80104f11:	5e                   	pop    %esi
80104f12:	5d                   	pop    %ebp
80104f13:	c3                   	ret    
80104f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104f18:	8b 5e 08             	mov    0x8(%esi),%ebx
80104f1b:	e8 60 f1 ff ff       	call   80104080 <mycpu>
80104f20:	39 c3                	cmp    %eax,%ebx
80104f22:	0f 94 c3             	sete   %bl
  popcli();
80104f25:	e8 66 ff ff ff       	call   80104e90 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104f2a:	0f b6 db             	movzbl %bl,%ebx
}
80104f2d:	89 d8                	mov    %ebx,%eax
80104f2f:	5b                   	pop    %ebx
80104f30:	5e                   	pop    %esi
80104f31:	5d                   	pop    %ebp
80104f32:	c3                   	ret    
80104f33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f40 <acquire>:
{
80104f40:	f3 0f 1e fb          	endbr32 
80104f44:	55                   	push   %ebp
80104f45:	89 e5                	mov    %esp,%ebp
80104f47:	56                   	push   %esi
80104f48:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104f49:	e8 f2 fe ff ff       	call   80104e40 <pushcli>
  if(holding(lk))
80104f4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f51:	83 ec 0c             	sub    $0xc,%esp
80104f54:	53                   	push   %ebx
80104f55:	e8 96 ff ff ff       	call   80104ef0 <holding>
80104f5a:	83 c4 10             	add    $0x10,%esp
80104f5d:	85 c0                	test   %eax,%eax
80104f5f:	0f 85 7f 00 00 00    	jne    80104fe4 <acquire+0xa4>
80104f65:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104f67:	ba 01 00 00 00       	mov    $0x1,%edx
80104f6c:	eb 05                	jmp    80104f73 <acquire+0x33>
80104f6e:	66 90                	xchg   %ax,%ax
80104f70:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f73:	89 d0                	mov    %edx,%eax
80104f75:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104f78:	85 c0                	test   %eax,%eax
80104f7a:	75 f4                	jne    80104f70 <acquire+0x30>
  __sync_synchronize();
80104f7c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104f81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f84:	e8 f7 f0 ff ff       	call   80104080 <mycpu>
80104f89:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104f8c:	89 e8                	mov    %ebp,%eax
80104f8e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f90:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104f96:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104f9c:	77 22                	ja     80104fc0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104f9e:	8b 50 04             	mov    0x4(%eax),%edx
80104fa1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104fa5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104fa8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104faa:	83 fe 0a             	cmp    $0xa,%esi
80104fad:	75 e1                	jne    80104f90 <acquire+0x50>
}
80104faf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fb2:	5b                   	pop    %ebx
80104fb3:	5e                   	pop    %esi
80104fb4:	5d                   	pop    %ebp
80104fb5:	c3                   	ret    
80104fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fbd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104fc0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104fc4:	83 c3 34             	add    $0x34,%ebx
80104fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104fd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104fd6:	83 c0 04             	add    $0x4,%eax
80104fd9:	39 d8                	cmp    %ebx,%eax
80104fdb:	75 f3                	jne    80104fd0 <acquire+0x90>
}
80104fdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fe0:	5b                   	pop    %ebx
80104fe1:	5e                   	pop    %esi
80104fe2:	5d                   	pop    %ebp
80104fe3:	c3                   	ret    
    panic("acquire");
80104fe4:	83 ec 0c             	sub    $0xc,%esp
80104fe7:	68 dd 87 10 80       	push   $0x801087dd
80104fec:	e8 9f b3 ff ff       	call   80100390 <panic>
80104ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ff8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fff:	90                   	nop

80105000 <release>:
{
80105000:	f3 0f 1e fb          	endbr32 
80105004:	55                   	push   %ebp
80105005:	89 e5                	mov    %esp,%ebp
80105007:	53                   	push   %ebx
80105008:	83 ec 10             	sub    $0x10,%esp
8010500b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010500e:	53                   	push   %ebx
8010500f:	e8 dc fe ff ff       	call   80104ef0 <holding>
80105014:	83 c4 10             	add    $0x10,%esp
80105017:	85 c0                	test   %eax,%eax
80105019:	74 22                	je     8010503d <release+0x3d>
  lk->pcs[0] = 0;
8010501b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105022:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105029:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010502e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105034:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105037:	c9                   	leave  
  popcli();
80105038:	e9 53 fe ff ff       	jmp    80104e90 <popcli>
    panic("release");
8010503d:	83 ec 0c             	sub    $0xc,%esp
80105040:	68 e5 87 10 80       	push   $0x801087e5
80105045:	e8 46 b3 ff ff       	call   80100390 <panic>
8010504a:	66 90                	xchg   %ax,%ax
8010504c:	66 90                	xchg   %ax,%ax
8010504e:	66 90                	xchg   %ax,%ax

80105050 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105050:	f3 0f 1e fb          	endbr32 
80105054:	55                   	push   %ebp
80105055:	89 e5                	mov    %esp,%ebp
80105057:	57                   	push   %edi
80105058:	8b 55 08             	mov    0x8(%ebp),%edx
8010505b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010505e:	53                   	push   %ebx
8010505f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105062:	89 d7                	mov    %edx,%edi
80105064:	09 cf                	or     %ecx,%edi
80105066:	83 e7 03             	and    $0x3,%edi
80105069:	75 25                	jne    80105090 <memset+0x40>
    c &= 0xFF;
8010506b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010506e:	c1 e0 18             	shl    $0x18,%eax
80105071:	89 fb                	mov    %edi,%ebx
80105073:	c1 e9 02             	shr    $0x2,%ecx
80105076:	c1 e3 10             	shl    $0x10,%ebx
80105079:	09 d8                	or     %ebx,%eax
8010507b:	09 f8                	or     %edi,%eax
8010507d:	c1 e7 08             	shl    $0x8,%edi
80105080:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105082:	89 d7                	mov    %edx,%edi
80105084:	fc                   	cld    
80105085:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105087:	5b                   	pop    %ebx
80105088:	89 d0                	mov    %edx,%eax
8010508a:	5f                   	pop    %edi
8010508b:	5d                   	pop    %ebp
8010508c:	c3                   	ret    
8010508d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105090:	89 d7                	mov    %edx,%edi
80105092:	fc                   	cld    
80105093:	f3 aa                	rep stos %al,%es:(%edi)
80105095:	5b                   	pop    %ebx
80105096:	89 d0                	mov    %edx,%eax
80105098:	5f                   	pop    %edi
80105099:	5d                   	pop    %ebp
8010509a:	c3                   	ret    
8010509b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010509f:	90                   	nop

801050a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801050a0:	f3 0f 1e fb          	endbr32 
801050a4:	55                   	push   %ebp
801050a5:	89 e5                	mov    %esp,%ebp
801050a7:	56                   	push   %esi
801050a8:	8b 75 10             	mov    0x10(%ebp),%esi
801050ab:	8b 55 08             	mov    0x8(%ebp),%edx
801050ae:	53                   	push   %ebx
801050af:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801050b2:	85 f6                	test   %esi,%esi
801050b4:	74 2a                	je     801050e0 <memcmp+0x40>
801050b6:	01 c6                	add    %eax,%esi
801050b8:	eb 10                	jmp    801050ca <memcmp+0x2a>
801050ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801050c0:	83 c0 01             	add    $0x1,%eax
801050c3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801050c6:	39 f0                	cmp    %esi,%eax
801050c8:	74 16                	je     801050e0 <memcmp+0x40>
    if(*s1 != *s2)
801050ca:	0f b6 0a             	movzbl (%edx),%ecx
801050cd:	0f b6 18             	movzbl (%eax),%ebx
801050d0:	38 d9                	cmp    %bl,%cl
801050d2:	74 ec                	je     801050c0 <memcmp+0x20>
      return *s1 - *s2;
801050d4:	0f b6 c1             	movzbl %cl,%eax
801050d7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801050d9:	5b                   	pop    %ebx
801050da:	5e                   	pop    %esi
801050db:	5d                   	pop    %ebp
801050dc:	c3                   	ret    
801050dd:	8d 76 00             	lea    0x0(%esi),%esi
801050e0:	5b                   	pop    %ebx
  return 0;
801050e1:	31 c0                	xor    %eax,%eax
}
801050e3:	5e                   	pop    %esi
801050e4:	5d                   	pop    %ebp
801050e5:	c3                   	ret    
801050e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ed:	8d 76 00             	lea    0x0(%esi),%esi

801050f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801050f0:	f3 0f 1e fb          	endbr32 
801050f4:	55                   	push   %ebp
801050f5:	89 e5                	mov    %esp,%ebp
801050f7:	57                   	push   %edi
801050f8:	8b 55 08             	mov    0x8(%ebp),%edx
801050fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801050fe:	56                   	push   %esi
801050ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105102:	39 d6                	cmp    %edx,%esi
80105104:	73 2a                	jae    80105130 <memmove+0x40>
80105106:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105109:	39 fa                	cmp    %edi,%edx
8010510b:	73 23                	jae    80105130 <memmove+0x40>
8010510d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105110:	85 c9                	test   %ecx,%ecx
80105112:	74 13                	je     80105127 <memmove+0x37>
80105114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105118:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010511c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010511f:	83 e8 01             	sub    $0x1,%eax
80105122:	83 f8 ff             	cmp    $0xffffffff,%eax
80105125:	75 f1                	jne    80105118 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105127:	5e                   	pop    %esi
80105128:	89 d0                	mov    %edx,%eax
8010512a:	5f                   	pop    %edi
8010512b:	5d                   	pop    %ebp
8010512c:	c3                   	ret    
8010512d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105130:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105133:	89 d7                	mov    %edx,%edi
80105135:	85 c9                	test   %ecx,%ecx
80105137:	74 ee                	je     80105127 <memmove+0x37>
80105139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105140:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105141:	39 f0                	cmp    %esi,%eax
80105143:	75 fb                	jne    80105140 <memmove+0x50>
}
80105145:	5e                   	pop    %esi
80105146:	89 d0                	mov    %edx,%eax
80105148:	5f                   	pop    %edi
80105149:	5d                   	pop    %ebp
8010514a:	c3                   	ret    
8010514b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010514f:	90                   	nop

80105150 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105150:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105154:	eb 9a                	jmp    801050f0 <memmove>
80105156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515d:	8d 76 00             	lea    0x0(%esi),%esi

80105160 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105160:	f3 0f 1e fb          	endbr32 
80105164:	55                   	push   %ebp
80105165:	89 e5                	mov    %esp,%ebp
80105167:	56                   	push   %esi
80105168:	8b 75 10             	mov    0x10(%ebp),%esi
8010516b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010516e:	53                   	push   %ebx
8010516f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105172:	85 f6                	test   %esi,%esi
80105174:	74 32                	je     801051a8 <strncmp+0x48>
80105176:	01 c6                	add    %eax,%esi
80105178:	eb 14                	jmp    8010518e <strncmp+0x2e>
8010517a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105180:	38 da                	cmp    %bl,%dl
80105182:	75 14                	jne    80105198 <strncmp+0x38>
    n--, p++, q++;
80105184:	83 c0 01             	add    $0x1,%eax
80105187:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010518a:	39 f0                	cmp    %esi,%eax
8010518c:	74 1a                	je     801051a8 <strncmp+0x48>
8010518e:	0f b6 11             	movzbl (%ecx),%edx
80105191:	0f b6 18             	movzbl (%eax),%ebx
80105194:	84 d2                	test   %dl,%dl
80105196:	75 e8                	jne    80105180 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105198:	0f b6 c2             	movzbl %dl,%eax
8010519b:	29 d8                	sub    %ebx,%eax
}
8010519d:	5b                   	pop    %ebx
8010519e:	5e                   	pop    %esi
8010519f:	5d                   	pop    %ebp
801051a0:	c3                   	ret    
801051a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051a8:	5b                   	pop    %ebx
    return 0;
801051a9:	31 c0                	xor    %eax,%eax
}
801051ab:	5e                   	pop    %esi
801051ac:	5d                   	pop    %ebp
801051ad:	c3                   	ret    
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801051b0:	f3 0f 1e fb          	endbr32 
801051b4:	55                   	push   %ebp
801051b5:	89 e5                	mov    %esp,%ebp
801051b7:	57                   	push   %edi
801051b8:	56                   	push   %esi
801051b9:	8b 75 08             	mov    0x8(%ebp),%esi
801051bc:	53                   	push   %ebx
801051bd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801051c0:	89 f2                	mov    %esi,%edx
801051c2:	eb 1b                	jmp    801051df <strncpy+0x2f>
801051c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051c8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801051cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801051cf:	83 c2 01             	add    $0x1,%edx
801051d2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801051d6:	89 f9                	mov    %edi,%ecx
801051d8:	88 4a ff             	mov    %cl,-0x1(%edx)
801051db:	84 c9                	test   %cl,%cl
801051dd:	74 09                	je     801051e8 <strncpy+0x38>
801051df:	89 c3                	mov    %eax,%ebx
801051e1:	83 e8 01             	sub    $0x1,%eax
801051e4:	85 db                	test   %ebx,%ebx
801051e6:	7f e0                	jg     801051c8 <strncpy+0x18>
    ;
  while(n-- > 0)
801051e8:	89 d1                	mov    %edx,%ecx
801051ea:	85 c0                	test   %eax,%eax
801051ec:	7e 15                	jle    80105203 <strncpy+0x53>
801051ee:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801051f0:	83 c1 01             	add    $0x1,%ecx
801051f3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801051f7:	89 c8                	mov    %ecx,%eax
801051f9:	f7 d0                	not    %eax
801051fb:	01 d0                	add    %edx,%eax
801051fd:	01 d8                	add    %ebx,%eax
801051ff:	85 c0                	test   %eax,%eax
80105201:	7f ed                	jg     801051f0 <strncpy+0x40>
  return os;
}
80105203:	5b                   	pop    %ebx
80105204:	89 f0                	mov    %esi,%eax
80105206:	5e                   	pop    %esi
80105207:	5f                   	pop    %edi
80105208:	5d                   	pop    %ebp
80105209:	c3                   	ret    
8010520a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105210 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105210:	f3 0f 1e fb          	endbr32 
80105214:	55                   	push   %ebp
80105215:	89 e5                	mov    %esp,%ebp
80105217:	56                   	push   %esi
80105218:	8b 55 10             	mov    0x10(%ebp),%edx
8010521b:	8b 75 08             	mov    0x8(%ebp),%esi
8010521e:	53                   	push   %ebx
8010521f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105222:	85 d2                	test   %edx,%edx
80105224:	7e 21                	jle    80105247 <safestrcpy+0x37>
80105226:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010522a:	89 f2                	mov    %esi,%edx
8010522c:	eb 12                	jmp    80105240 <safestrcpy+0x30>
8010522e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105230:	0f b6 08             	movzbl (%eax),%ecx
80105233:	83 c0 01             	add    $0x1,%eax
80105236:	83 c2 01             	add    $0x1,%edx
80105239:	88 4a ff             	mov    %cl,-0x1(%edx)
8010523c:	84 c9                	test   %cl,%cl
8010523e:	74 04                	je     80105244 <safestrcpy+0x34>
80105240:	39 d8                	cmp    %ebx,%eax
80105242:	75 ec                	jne    80105230 <safestrcpy+0x20>
    ;
  *s = 0;
80105244:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105247:	89 f0                	mov    %esi,%eax
80105249:	5b                   	pop    %ebx
8010524a:	5e                   	pop    %esi
8010524b:	5d                   	pop    %ebp
8010524c:	c3                   	ret    
8010524d:	8d 76 00             	lea    0x0(%esi),%esi

80105250 <strlen>:

int
strlen(const char *s)
{
80105250:	f3 0f 1e fb          	endbr32 
80105254:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105255:	31 c0                	xor    %eax,%eax
{
80105257:	89 e5                	mov    %esp,%ebp
80105259:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010525c:	80 3a 00             	cmpb   $0x0,(%edx)
8010525f:	74 10                	je     80105271 <strlen+0x21>
80105261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105268:	83 c0 01             	add    $0x1,%eax
8010526b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010526f:	75 f7                	jne    80105268 <strlen+0x18>
    ;
  return n;
}
80105271:	5d                   	pop    %ebp
80105272:	c3                   	ret    

80105273 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105273:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105277:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010527b:	55                   	push   %ebp
  pushl %ebx
8010527c:	53                   	push   %ebx
  pushl %esi
8010527d:	56                   	push   %esi
  pushl %edi
8010527e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010527f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105281:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105283:	5f                   	pop    %edi
  popl %esi
80105284:	5e                   	pop    %esi
  popl %ebx
80105285:	5b                   	pop    %ebx
  popl %ebp
80105286:	5d                   	pop    %ebp
  ret
80105287:	c3                   	ret    
80105288:	66 90                	xchg   %ax,%ax
8010528a:	66 90                	xchg   %ax,%ax
8010528c:	66 90                	xchg   %ax,%ax
8010528e:	66 90                	xchg   %ax,%ax

80105290 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105290:	f3 0f 1e fb          	endbr32 
80105294:	55                   	push   %ebp
80105295:	89 e5                	mov    %esp,%ebp
80105297:	53                   	push   %ebx
80105298:	83 ec 04             	sub    $0x4,%esp
8010529b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010529e:	e8 6d ee ff ff       	call   80104110 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801052a3:	8b 00                	mov    (%eax),%eax
801052a5:	39 d8                	cmp    %ebx,%eax
801052a7:	76 17                	jbe    801052c0 <fetchint+0x30>
801052a9:	8d 53 04             	lea    0x4(%ebx),%edx
801052ac:	39 d0                	cmp    %edx,%eax
801052ae:	72 10                	jb     801052c0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801052b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801052b3:	8b 13                	mov    (%ebx),%edx
801052b5:	89 10                	mov    %edx,(%eax)
  return 0;
801052b7:	31 c0                	xor    %eax,%eax
}
801052b9:	83 c4 04             	add    $0x4,%esp
801052bc:	5b                   	pop    %ebx
801052bd:	5d                   	pop    %ebp
801052be:	c3                   	ret    
801052bf:	90                   	nop
    return -1;
801052c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052c5:	eb f2                	jmp    801052b9 <fetchint+0x29>
801052c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ce:	66 90                	xchg   %ax,%ax

801052d0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801052d0:	f3 0f 1e fb          	endbr32 
801052d4:	55                   	push   %ebp
801052d5:	89 e5                	mov    %esp,%ebp
801052d7:	53                   	push   %ebx
801052d8:	83 ec 04             	sub    $0x4,%esp
801052db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801052de:	e8 2d ee ff ff       	call   80104110 <myproc>

  if(addr >= curproc->sz)
801052e3:	39 18                	cmp    %ebx,(%eax)
801052e5:	76 31                	jbe    80105318 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801052e7:	8b 55 0c             	mov    0xc(%ebp),%edx
801052ea:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801052ec:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801052ee:	39 d3                	cmp    %edx,%ebx
801052f0:	73 26                	jae    80105318 <fetchstr+0x48>
801052f2:	89 d8                	mov    %ebx,%eax
801052f4:	eb 11                	jmp    80105307 <fetchstr+0x37>
801052f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052fd:	8d 76 00             	lea    0x0(%esi),%esi
80105300:	83 c0 01             	add    $0x1,%eax
80105303:	39 c2                	cmp    %eax,%edx
80105305:	76 11                	jbe    80105318 <fetchstr+0x48>
    if(*s == 0)
80105307:	80 38 00             	cmpb   $0x0,(%eax)
8010530a:	75 f4                	jne    80105300 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010530c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010530f:	29 d8                	sub    %ebx,%eax
}
80105311:	5b                   	pop    %ebx
80105312:	5d                   	pop    %ebp
80105313:	c3                   	ret    
80105314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105318:	83 c4 04             	add    $0x4,%esp
    return -1;
8010531b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105320:	5b                   	pop    %ebx
80105321:	5d                   	pop    %ebp
80105322:	c3                   	ret    
80105323:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105330 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105330:	f3 0f 1e fb          	endbr32 
80105334:	55                   	push   %ebp
80105335:	89 e5                	mov    %esp,%ebp
80105337:	56                   	push   %esi
80105338:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105339:	e8 d2 ed ff ff       	call   80104110 <myproc>
8010533e:	8b 55 08             	mov    0x8(%ebp),%edx
80105341:	8b 40 18             	mov    0x18(%eax),%eax
80105344:	8b 40 44             	mov    0x44(%eax),%eax
80105347:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010534a:	e8 c1 ed ff ff       	call   80104110 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010534f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105352:	8b 00                	mov    (%eax),%eax
80105354:	39 c6                	cmp    %eax,%esi
80105356:	73 18                	jae    80105370 <argint+0x40>
80105358:	8d 53 08             	lea    0x8(%ebx),%edx
8010535b:	39 d0                	cmp    %edx,%eax
8010535d:	72 11                	jb     80105370 <argint+0x40>
  *ip = *(int*)(addr);
8010535f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105362:	8b 53 04             	mov    0x4(%ebx),%edx
80105365:	89 10                	mov    %edx,(%eax)
  return 0;
80105367:	31 c0                	xor    %eax,%eax
}
80105369:	5b                   	pop    %ebx
8010536a:	5e                   	pop    %esi
8010536b:	5d                   	pop    %ebp
8010536c:	c3                   	ret    
8010536d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105375:	eb f2                	jmp    80105369 <argint+0x39>
80105377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010537e:	66 90                	xchg   %ax,%ax

80105380 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105380:	f3 0f 1e fb          	endbr32 
80105384:	55                   	push   %ebp
80105385:	89 e5                	mov    %esp,%ebp
80105387:	56                   	push   %esi
80105388:	53                   	push   %ebx
80105389:	83 ec 10             	sub    $0x10,%esp
8010538c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010538f:	e8 7c ed ff ff       	call   80104110 <myproc>
 
  if(argint(n, &i) < 0)
80105394:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105397:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105399:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010539c:	50                   	push   %eax
8010539d:	ff 75 08             	pushl  0x8(%ebp)
801053a0:	e8 8b ff ff ff       	call   80105330 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801053a5:	83 c4 10             	add    $0x10,%esp
801053a8:	85 c0                	test   %eax,%eax
801053aa:	78 24                	js     801053d0 <argptr+0x50>
801053ac:	85 db                	test   %ebx,%ebx
801053ae:	78 20                	js     801053d0 <argptr+0x50>
801053b0:	8b 16                	mov    (%esi),%edx
801053b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b5:	39 c2                	cmp    %eax,%edx
801053b7:	76 17                	jbe    801053d0 <argptr+0x50>
801053b9:	01 c3                	add    %eax,%ebx
801053bb:	39 da                	cmp    %ebx,%edx
801053bd:	72 11                	jb     801053d0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801053bf:	8b 55 0c             	mov    0xc(%ebp),%edx
801053c2:	89 02                	mov    %eax,(%edx)
  return 0;
801053c4:	31 c0                	xor    %eax,%eax
}
801053c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053c9:	5b                   	pop    %ebx
801053ca:	5e                   	pop    %esi
801053cb:	5d                   	pop    %ebp
801053cc:	c3                   	ret    
801053cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801053d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053d5:	eb ef                	jmp    801053c6 <argptr+0x46>
801053d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053de:	66 90                	xchg   %ax,%ax

801053e0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801053e0:	f3 0f 1e fb          	endbr32 
801053e4:	55                   	push   %ebp
801053e5:	89 e5                	mov    %esp,%ebp
801053e7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801053ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053ed:	50                   	push   %eax
801053ee:	ff 75 08             	pushl  0x8(%ebp)
801053f1:	e8 3a ff ff ff       	call   80105330 <argint>
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	85 c0                	test   %eax,%eax
801053fb:	78 13                	js     80105410 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801053fd:	83 ec 08             	sub    $0x8,%esp
80105400:	ff 75 0c             	pushl  0xc(%ebp)
80105403:	ff 75 f4             	pushl  -0xc(%ebp)
80105406:	e8 c5 fe ff ff       	call   801052d0 <fetchstr>
8010540b:	83 c4 10             	add    $0x10,%esp
}
8010540e:	c9                   	leave  
8010540f:	c3                   	ret    
80105410:	c9                   	leave  
    return -1;
80105411:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105416:	c3                   	ret    
80105417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010541e:	66 90                	xchg   %ax,%ax

80105420 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105420:	f3 0f 1e fb          	endbr32 
80105424:	55                   	push   %ebp
80105425:	89 e5                	mov    %esp,%ebp
80105427:	53                   	push   %ebx
80105428:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010542b:	e8 e0 ec ff ff       	call   80104110 <myproc>
80105430:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105432:	8b 40 18             	mov    0x18(%eax),%eax
80105435:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105438:	8d 50 ff             	lea    -0x1(%eax),%edx
8010543b:	83 fa 14             	cmp    $0x14,%edx
8010543e:	77 20                	ja     80105460 <syscall+0x40>
80105440:	8b 14 85 20 88 10 80 	mov    -0x7fef77e0(,%eax,4),%edx
80105447:	85 d2                	test   %edx,%edx
80105449:	74 15                	je     80105460 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010544b:	ff d2                	call   *%edx
8010544d:	89 c2                	mov    %eax,%edx
8010544f:	8b 43 18             	mov    0x18(%ebx),%eax
80105452:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105455:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105458:	c9                   	leave  
80105459:	c3                   	ret    
8010545a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105460:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105461:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105464:	50                   	push   %eax
80105465:	ff 73 10             	pushl  0x10(%ebx)
80105468:	68 ed 87 10 80       	push   $0x801087ed
8010546d:	e8 3e b2 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105472:	8b 43 18             	mov    0x18(%ebx),%eax
80105475:	83 c4 10             	add    $0x10,%esp
80105478:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010547f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105482:	c9                   	leave  
80105483:	c3                   	ret    
80105484:	66 90                	xchg   %ax,%ax
80105486:	66 90                	xchg   %ax,%ax
80105488:	66 90                	xchg   %ax,%ax
8010548a:	66 90                	xchg   %ax,%ax
8010548c:	66 90                	xchg   %ax,%ax
8010548e:	66 90                	xchg   %ax,%ax

80105490 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	56                   	push   %esi
80105494:	89 d6                	mov    %edx,%esi
80105496:	53                   	push   %ebx
80105497:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105499:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010549c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010549f:	50                   	push   %eax
801054a0:	6a 00                	push   $0x0
801054a2:	e8 89 fe ff ff       	call   80105330 <argint>
801054a7:	83 c4 10             	add    $0x10,%esp
801054aa:	85 c0                	test   %eax,%eax
801054ac:	78 2a                	js     801054d8 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054ae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054b2:	77 24                	ja     801054d8 <argfd.constprop.0+0x48>
801054b4:	e8 57 ec ff ff       	call   80104110 <myproc>
801054b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054bc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801054c0:	85 c0                	test   %eax,%eax
801054c2:	74 14                	je     801054d8 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
801054c4:	85 db                	test   %ebx,%ebx
801054c6:	74 02                	je     801054ca <argfd.constprop.0+0x3a>
    *pfd = fd;
801054c8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
801054ca:	89 06                	mov    %eax,(%esi)
  return 0;
801054cc:	31 c0                	xor    %eax,%eax
}
801054ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054d1:	5b                   	pop    %ebx
801054d2:	5e                   	pop    %esi
801054d3:	5d                   	pop    %ebp
801054d4:	c3                   	ret    
801054d5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054dd:	eb ef                	jmp    801054ce <argfd.constprop.0+0x3e>
801054df:	90                   	nop

801054e0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801054e5:	31 c0                	xor    %eax,%eax
{
801054e7:	89 e5                	mov    %esp,%ebp
801054e9:	56                   	push   %esi
801054ea:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801054eb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801054ee:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801054f1:	e8 9a ff ff ff       	call   80105490 <argfd.constprop.0>
801054f6:	85 c0                	test   %eax,%eax
801054f8:	78 1e                	js     80105518 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
801054fa:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801054fd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054ff:	e8 0c ec ff ff       	call   80104110 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105508:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010550c:	85 d2                	test   %edx,%edx
8010550e:	74 20                	je     80105530 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105510:	83 c3 01             	add    $0x1,%ebx
80105513:	83 fb 10             	cmp    $0x10,%ebx
80105516:	75 f0                	jne    80105508 <sys_dup+0x28>
    return -1;
  filedup(f);
  return fd;
}
80105518:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010551b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105520:	89 d8                	mov    %ebx,%eax
80105522:	5b                   	pop    %ebx
80105523:	5e                   	pop    %esi
80105524:	5d                   	pop    %ebp
80105525:	c3                   	ret    
80105526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105530:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105534:	83 ec 0c             	sub    $0xc,%esp
80105537:	ff 75 f4             	pushl  -0xc(%ebp)
8010553a:	e8 f1 bc ff ff       	call   80101230 <filedup>
  return fd;
8010553f:	83 c4 10             	add    $0x10,%esp
}
80105542:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105545:	89 d8                	mov    %ebx,%eax
80105547:	5b                   	pop    %ebx
80105548:	5e                   	pop    %esi
80105549:	5d                   	pop    %ebp
8010554a:	c3                   	ret    
8010554b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop

80105550 <sys_read>:

int
sys_read(void)
{
80105550:	f3 0f 1e fb          	endbr32 
80105554:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105555:	31 c0                	xor    %eax,%eax
{
80105557:	89 e5                	mov    %esp,%ebp
80105559:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010555c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010555f:	e8 2c ff ff ff       	call   80105490 <argfd.constprop.0>
80105564:	85 c0                	test   %eax,%eax
80105566:	78 48                	js     801055b0 <sys_read+0x60>
80105568:	83 ec 08             	sub    $0x8,%esp
8010556b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010556e:	50                   	push   %eax
8010556f:	6a 02                	push   $0x2
80105571:	e8 ba fd ff ff       	call   80105330 <argint>
80105576:	83 c4 10             	add    $0x10,%esp
80105579:	85 c0                	test   %eax,%eax
8010557b:	78 33                	js     801055b0 <sys_read+0x60>
8010557d:	83 ec 04             	sub    $0x4,%esp
80105580:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105583:	ff 75 f0             	pushl  -0x10(%ebp)
80105586:	50                   	push   %eax
80105587:	6a 01                	push   $0x1
80105589:	e8 f2 fd ff ff       	call   80105380 <argptr>
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	85 c0                	test   %eax,%eax
80105593:	78 1b                	js     801055b0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105595:	83 ec 04             	sub    $0x4,%esp
80105598:	ff 75 f0             	pushl  -0x10(%ebp)
8010559b:	ff 75 f4             	pushl  -0xc(%ebp)
8010559e:	ff 75 ec             	pushl  -0x14(%ebp)
801055a1:	e8 0a be ff ff       	call   801013b0 <fileread>
801055a6:	83 c4 10             	add    $0x10,%esp
}
801055a9:	c9                   	leave  
801055aa:	c3                   	ret    
801055ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055af:	90                   	nop
801055b0:	c9                   	leave  
    return -1;
801055b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055b6:	c3                   	ret    
801055b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055be:	66 90                	xchg   %ax,%ax

801055c0 <sys_write>:

int
sys_write(void)
{
801055c0:	f3 0f 1e fb          	endbr32 
801055c4:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055c5:	31 c0                	xor    %eax,%eax
{
801055c7:	89 e5                	mov    %esp,%ebp
801055c9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055cc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801055cf:	e8 bc fe ff ff       	call   80105490 <argfd.constprop.0>
801055d4:	85 c0                	test   %eax,%eax
801055d6:	78 48                	js     80105620 <sys_write+0x60>
801055d8:	83 ec 08             	sub    $0x8,%esp
801055db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055de:	50                   	push   %eax
801055df:	6a 02                	push   $0x2
801055e1:	e8 4a fd ff ff       	call   80105330 <argint>
801055e6:	83 c4 10             	add    $0x10,%esp
801055e9:	85 c0                	test   %eax,%eax
801055eb:	78 33                	js     80105620 <sys_write+0x60>
801055ed:	83 ec 04             	sub    $0x4,%esp
801055f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055f3:	ff 75 f0             	pushl  -0x10(%ebp)
801055f6:	50                   	push   %eax
801055f7:	6a 01                	push   $0x1
801055f9:	e8 82 fd ff ff       	call   80105380 <argptr>
801055fe:	83 c4 10             	add    $0x10,%esp
80105601:	85 c0                	test   %eax,%eax
80105603:	78 1b                	js     80105620 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105605:	83 ec 04             	sub    $0x4,%esp
80105608:	ff 75 f0             	pushl  -0x10(%ebp)
8010560b:	ff 75 f4             	pushl  -0xc(%ebp)
8010560e:	ff 75 ec             	pushl  -0x14(%ebp)
80105611:	e8 3a be ff ff       	call   80101450 <filewrite>
80105616:	83 c4 10             	add    $0x10,%esp
}
80105619:	c9                   	leave  
8010561a:	c3                   	ret    
8010561b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010561f:	90                   	nop
80105620:	c9                   	leave  
    return -1;
80105621:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105626:	c3                   	ret    
80105627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562e:	66 90                	xchg   %ax,%ax

80105630 <sys_close>:

int
sys_close(void)
{
80105630:	f3 0f 1e fb          	endbr32 
80105634:	55                   	push   %ebp
80105635:	89 e5                	mov    %esp,%ebp
80105637:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010563a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010563d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105640:	e8 4b fe ff ff       	call   80105490 <argfd.constprop.0>
80105645:	85 c0                	test   %eax,%eax
80105647:	78 27                	js     80105670 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105649:	e8 c2 ea ff ff       	call   80104110 <myproc>
8010564e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105651:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105654:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010565b:	00 
  fileclose(f);
8010565c:	ff 75 f4             	pushl  -0xc(%ebp)
8010565f:	e8 1c bc ff ff       	call   80101280 <fileclose>
  return 0;
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	31 c0                	xor    %eax,%eax
}
80105669:	c9                   	leave  
8010566a:	c3                   	ret    
8010566b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010566f:	90                   	nop
80105670:	c9                   	leave  
    return -1;
80105671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105676:	c3                   	ret    
80105677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567e:	66 90                	xchg   %ax,%ax

80105680 <sys_fstat>:

int
sys_fstat(void)
{
80105680:	f3 0f 1e fb          	endbr32 
80105684:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105685:	31 c0                	xor    %eax,%eax
{
80105687:	89 e5                	mov    %esp,%ebp
80105689:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010568c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010568f:	e8 fc fd ff ff       	call   80105490 <argfd.constprop.0>
80105694:	85 c0                	test   %eax,%eax
80105696:	78 30                	js     801056c8 <sys_fstat+0x48>
80105698:	83 ec 04             	sub    $0x4,%esp
8010569b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010569e:	6a 14                	push   $0x14
801056a0:	50                   	push   %eax
801056a1:	6a 01                	push   $0x1
801056a3:	e8 d8 fc ff ff       	call   80105380 <argptr>
801056a8:	83 c4 10             	add    $0x10,%esp
801056ab:	85 c0                	test   %eax,%eax
801056ad:	78 19                	js     801056c8 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
801056af:	83 ec 08             	sub    $0x8,%esp
801056b2:	ff 75 f4             	pushl  -0xc(%ebp)
801056b5:	ff 75 f0             	pushl  -0x10(%ebp)
801056b8:	e8 a3 bc ff ff       	call   80101360 <filestat>
801056bd:	83 c4 10             	add    $0x10,%esp
}
801056c0:	c9                   	leave  
801056c1:	c3                   	ret    
801056c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056c8:	c9                   	leave  
    return -1;
801056c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ce:	c3                   	ret    
801056cf:	90                   	nop

801056d0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801056d0:	f3 0f 1e fb          	endbr32 
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	57                   	push   %edi
801056d8:	56                   	push   %esi
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056d9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801056dc:	53                   	push   %ebx
801056dd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056e0:	50                   	push   %eax
801056e1:	6a 00                	push   $0x0
801056e3:	e8 f8 fc ff ff       	call   801053e0 <argstr>
801056e8:	83 c4 10             	add    $0x10,%esp
801056eb:	85 c0                	test   %eax,%eax
801056ed:	0f 88 ff 00 00 00    	js     801057f2 <sys_link+0x122>
801056f3:	83 ec 08             	sub    $0x8,%esp
801056f6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801056f9:	50                   	push   %eax
801056fa:	6a 01                	push   $0x1
801056fc:	e8 df fc ff ff       	call   801053e0 <argstr>
80105701:	83 c4 10             	add    $0x10,%esp
80105704:	85 c0                	test   %eax,%eax
80105706:	0f 88 e6 00 00 00    	js     801057f2 <sys_link+0x122>
    return -1;

  begin_op();
8010570c:	e8 5f dd ff ff       	call   80103470 <begin_op>
  if((ip = namei(old)) == 0){
80105711:	83 ec 0c             	sub    $0xc,%esp
80105714:	ff 75 d4             	pushl  -0x2c(%ebp)
80105717:	e8 d4 cc ff ff       	call   801023f0 <namei>
8010571c:	83 c4 10             	add    $0x10,%esp
8010571f:	89 c3                	mov    %eax,%ebx
80105721:	85 c0                	test   %eax,%eax
80105723:	0f 84 e8 00 00 00    	je     80105811 <sys_link+0x141>
    end_op();
    return -1;
  }

  ilock(ip);
80105729:	83 ec 0c             	sub    $0xc,%esp
8010572c:	50                   	push   %eax
8010572d:	e8 ee c3 ff ff       	call   80101b20 <ilock>
  if(ip->type == T_DIR){
80105732:	83 c4 10             	add    $0x10,%esp
80105735:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010573a:	0f 84 b9 00 00 00    	je     801057f9 <sys_link+0x129>
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105740:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105743:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105748:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010574b:	53                   	push   %ebx
8010574c:	e8 0f c3 ff ff       	call   80101a60 <iupdate>
  iunlock(ip);
80105751:	89 1c 24             	mov    %ebx,(%esp)
80105754:	e8 a7 c4 ff ff       	call   80101c00 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105759:	58                   	pop    %eax
8010575a:	5a                   	pop    %edx
8010575b:	57                   	push   %edi
8010575c:	ff 75 d0             	pushl  -0x30(%ebp)
8010575f:	e8 ac cc ff ff       	call   80102410 <nameiparent>
80105764:	83 c4 10             	add    $0x10,%esp
80105767:	89 c6                	mov    %eax,%esi
80105769:	85 c0                	test   %eax,%eax
8010576b:	74 5f                	je     801057cc <sys_link+0xfc>
    goto bad;
  ilock(dp);
8010576d:	83 ec 0c             	sub    $0xc,%esp
80105770:	50                   	push   %eax
80105771:	e8 aa c3 ff ff       	call   80101b20 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105776:	8b 03                	mov    (%ebx),%eax
80105778:	83 c4 10             	add    $0x10,%esp
8010577b:	39 06                	cmp    %eax,(%esi)
8010577d:	75 41                	jne    801057c0 <sys_link+0xf0>
8010577f:	83 ec 04             	sub    $0x4,%esp
80105782:	ff 73 04             	pushl  0x4(%ebx)
80105785:	57                   	push   %edi
80105786:	56                   	push   %esi
80105787:	e8 a4 cb ff ff       	call   80102330 <dirlink>
8010578c:	83 c4 10             	add    $0x10,%esp
8010578f:	85 c0                	test   %eax,%eax
80105791:	78 2d                	js     801057c0 <sys_link+0xf0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105793:	83 ec 0c             	sub    $0xc,%esp
80105796:	56                   	push   %esi
80105797:	e8 24 c6 ff ff       	call   80101dc0 <iunlockput>
  iput(ip);
8010579c:	89 1c 24             	mov    %ebx,(%esp)
8010579f:	e8 ac c4 ff ff       	call   80101c50 <iput>

  end_op();
801057a4:	e8 37 dd ff ff       	call   801034e0 <end_op>

  return 0;
801057a9:	83 c4 10             	add    $0x10,%esp
801057ac:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801057ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b1:	5b                   	pop    %ebx
801057b2:	5e                   	pop    %esi
801057b3:	5f                   	pop    %edi
801057b4:	5d                   	pop    %ebp
801057b5:	c3                   	ret    
801057b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057bd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	56                   	push   %esi
801057c4:	e8 f7 c5 ff ff       	call   80101dc0 <iunlockput>
    goto bad;
801057c9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801057cc:	83 ec 0c             	sub    $0xc,%esp
801057cf:	53                   	push   %ebx
801057d0:	e8 4b c3 ff ff       	call   80101b20 <ilock>
  ip->nlink--;
801057d5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057da:	89 1c 24             	mov    %ebx,(%esp)
801057dd:	e8 7e c2 ff ff       	call   80101a60 <iupdate>
  iunlockput(ip);
801057e2:	89 1c 24             	mov    %ebx,(%esp)
801057e5:	e8 d6 c5 ff ff       	call   80101dc0 <iunlockput>
  end_op();
801057ea:	e8 f1 dc ff ff       	call   801034e0 <end_op>
  return -1;
801057ef:	83 c4 10             	add    $0x10,%esp
801057f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f7:	eb b5                	jmp    801057ae <sys_link+0xde>
    iunlockput(ip);
801057f9:	83 ec 0c             	sub    $0xc,%esp
801057fc:	53                   	push   %ebx
801057fd:	e8 be c5 ff ff       	call   80101dc0 <iunlockput>
    end_op();
80105802:	e8 d9 dc ff ff       	call   801034e0 <end_op>
    return -1;
80105807:	83 c4 10             	add    $0x10,%esp
8010580a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580f:	eb 9d                	jmp    801057ae <sys_link+0xde>
    end_op();
80105811:	e8 ca dc ff ff       	call   801034e0 <end_op>
    return -1;
80105816:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581b:	eb 91                	jmp    801057ae <sys_link+0xde>
8010581d:	8d 76 00             	lea    0x0(%esi),%esi

80105820 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105820:	f3 0f 1e fb          	endbr32 
80105824:	55                   	push   %ebp
80105825:	89 e5                	mov    %esp,%ebp
80105827:	57                   	push   %edi
80105828:	56                   	push   %esi
80105829:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010582c:	53                   	push   %ebx
8010582d:	bb 20 00 00 00       	mov    $0x20,%ebx
80105832:	83 ec 1c             	sub    $0x1c,%esp
80105835:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105838:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
8010583c:	77 0a                	ja     80105848 <isdirempty+0x28>
8010583e:	eb 30                	jmp    80105870 <isdirempty+0x50>
80105840:	83 c3 10             	add    $0x10,%ebx
80105843:	39 5e 58             	cmp    %ebx,0x58(%esi)
80105846:	76 28                	jbe    80105870 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105848:	6a 10                	push   $0x10
8010584a:	53                   	push   %ebx
8010584b:	57                   	push   %edi
8010584c:	56                   	push   %esi
8010584d:	e8 ce c5 ff ff       	call   80101e20 <readi>
80105852:	83 c4 10             	add    $0x10,%esp
80105855:	83 f8 10             	cmp    $0x10,%eax
80105858:	75 23                	jne    8010587d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010585a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010585f:	74 df                	je     80105840 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105861:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105864:	31 c0                	xor    %eax,%eax
}
80105866:	5b                   	pop    %ebx
80105867:	5e                   	pop    %esi
80105868:	5f                   	pop    %edi
80105869:	5d                   	pop    %ebp
8010586a:	c3                   	ret    
8010586b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010586f:	90                   	nop
80105870:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105873:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105878:	5b                   	pop    %ebx
80105879:	5e                   	pop    %esi
8010587a:	5f                   	pop    %edi
8010587b:	5d                   	pop    %ebp
8010587c:	c3                   	ret    
      panic("isdirempty: readi");
8010587d:	83 ec 0c             	sub    $0xc,%esp
80105880:	68 78 88 10 80       	push   $0x80108878
80105885:	e8 06 ab ff ff       	call   80100390 <panic>
8010588a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105890 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105890:	f3 0f 1e fb          	endbr32 
80105894:	55                   	push   %ebp
80105895:	89 e5                	mov    %esp,%ebp
80105897:	57                   	push   %edi
80105898:	56                   	push   %esi
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105899:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010589c:	53                   	push   %ebx
8010589d:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801058a0:	50                   	push   %eax
801058a1:	6a 00                	push   $0x0
801058a3:	e8 38 fb ff ff       	call   801053e0 <argstr>
801058a8:	83 c4 10             	add    $0x10,%esp
801058ab:	85 c0                	test   %eax,%eax
801058ad:	0f 88 5d 01 00 00    	js     80105a10 <sys_unlink+0x180>
    return -1;

  begin_op();
801058b3:	e8 b8 db ff ff       	call   80103470 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801058b8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801058bb:	83 ec 08             	sub    $0x8,%esp
801058be:	53                   	push   %ebx
801058bf:	ff 75 c0             	pushl  -0x40(%ebp)
801058c2:	e8 49 cb ff ff       	call   80102410 <nameiparent>
801058c7:	83 c4 10             	add    $0x10,%esp
801058ca:	89 c6                	mov    %eax,%esi
801058cc:	85 c0                	test   %eax,%eax
801058ce:	0f 84 43 01 00 00    	je     80105a17 <sys_unlink+0x187>
    end_op();
    return -1;
  }

  ilock(dp);
801058d4:	83 ec 0c             	sub    $0xc,%esp
801058d7:	50                   	push   %eax
801058d8:	e8 43 c2 ff ff       	call   80101b20 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801058dd:	58                   	pop    %eax
801058de:	5a                   	pop    %edx
801058df:	68 7d 82 10 80       	push   $0x8010827d
801058e4:	53                   	push   %ebx
801058e5:	e8 66 c7 ff ff       	call   80102050 <namecmp>
801058ea:	83 c4 10             	add    $0x10,%esp
801058ed:	85 c0                	test   %eax,%eax
801058ef:	0f 84 db 00 00 00    	je     801059d0 <sys_unlink+0x140>
801058f5:	83 ec 08             	sub    $0x8,%esp
801058f8:	68 7c 82 10 80       	push   $0x8010827c
801058fd:	53                   	push   %ebx
801058fe:	e8 4d c7 ff ff       	call   80102050 <namecmp>
80105903:	83 c4 10             	add    $0x10,%esp
80105906:	85 c0                	test   %eax,%eax
80105908:	0f 84 c2 00 00 00    	je     801059d0 <sys_unlink+0x140>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010590e:	83 ec 04             	sub    $0x4,%esp
80105911:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105914:	50                   	push   %eax
80105915:	53                   	push   %ebx
80105916:	56                   	push   %esi
80105917:	e8 54 c7 ff ff       	call   80102070 <dirlookup>
8010591c:	83 c4 10             	add    $0x10,%esp
8010591f:	89 c3                	mov    %eax,%ebx
80105921:	85 c0                	test   %eax,%eax
80105923:	0f 84 a7 00 00 00    	je     801059d0 <sys_unlink+0x140>
    goto bad;
  ilock(ip);
80105929:	83 ec 0c             	sub    $0xc,%esp
8010592c:	50                   	push   %eax
8010592d:	e8 ee c1 ff ff       	call   80101b20 <ilock>

  if(ip->nlink < 1)
80105932:	83 c4 10             	add    $0x10,%esp
80105935:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010593a:	0f 8e f3 00 00 00    	jle    80105a33 <sys_unlink+0x1a3>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105940:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105945:	74 69                	je     801059b0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105947:	83 ec 04             	sub    $0x4,%esp
8010594a:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010594d:	6a 10                	push   $0x10
8010594f:	6a 00                	push   $0x0
80105951:	57                   	push   %edi
80105952:	e8 f9 f6 ff ff       	call   80105050 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105957:	6a 10                	push   $0x10
80105959:	ff 75 c4             	pushl  -0x3c(%ebp)
8010595c:	57                   	push   %edi
8010595d:	56                   	push   %esi
8010595e:	e8 bd c5 ff ff       	call   80101f20 <writei>
80105963:	83 c4 20             	add    $0x20,%esp
80105966:	83 f8 10             	cmp    $0x10,%eax
80105969:	0f 85 b7 00 00 00    	jne    80105a26 <sys_unlink+0x196>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010596f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105974:	74 7a                	je     801059f0 <sys_unlink+0x160>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105976:	83 ec 0c             	sub    $0xc,%esp
80105979:	56                   	push   %esi
8010597a:	e8 41 c4 ff ff       	call   80101dc0 <iunlockput>

  ip->nlink--;
8010597f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105984:	89 1c 24             	mov    %ebx,(%esp)
80105987:	e8 d4 c0 ff ff       	call   80101a60 <iupdate>
  iunlockput(ip);
8010598c:	89 1c 24             	mov    %ebx,(%esp)
8010598f:	e8 2c c4 ff ff       	call   80101dc0 <iunlockput>

  end_op();
80105994:	e8 47 db ff ff       	call   801034e0 <end_op>

  return 0;
80105999:	83 c4 10             	add    $0x10,%esp
8010599c:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010599e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059a1:	5b                   	pop    %ebx
801059a2:	5e                   	pop    %esi
801059a3:	5f                   	pop    %edi
801059a4:	5d                   	pop    %ebp
801059a5:	c3                   	ret    
801059a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	53                   	push   %ebx
801059b4:	e8 67 fe ff ff       	call   80105820 <isdirempty>
801059b9:	83 c4 10             	add    $0x10,%esp
801059bc:	85 c0                	test   %eax,%eax
801059be:	75 87                	jne    80105947 <sys_unlink+0xb7>
    iunlockput(ip);
801059c0:	83 ec 0c             	sub    $0xc,%esp
801059c3:	53                   	push   %ebx
801059c4:	e8 f7 c3 ff ff       	call   80101dc0 <iunlockput>
    goto bad;
801059c9:	83 c4 10             	add    $0x10,%esp
801059cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801059d0:	83 ec 0c             	sub    $0xc,%esp
801059d3:	56                   	push   %esi
801059d4:	e8 e7 c3 ff ff       	call   80101dc0 <iunlockput>
  end_op();
801059d9:	e8 02 db ff ff       	call   801034e0 <end_op>
  return -1;
801059de:	83 c4 10             	add    $0x10,%esp
801059e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059e6:	eb b6                	jmp    8010599e <sys_unlink+0x10e>
801059e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ef:	90                   	nop
    iupdate(dp);
801059f0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801059f3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801059f8:	56                   	push   %esi
801059f9:	e8 62 c0 ff ff       	call   80101a60 <iupdate>
801059fe:	83 c4 10             	add    $0x10,%esp
80105a01:	e9 70 ff ff ff       	jmp    80105976 <sys_unlink+0xe6>
80105a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a15:	eb 87                	jmp    8010599e <sys_unlink+0x10e>
    end_op();
80105a17:	e8 c4 da ff ff       	call   801034e0 <end_op>
    return -1;
80105a1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a21:	e9 78 ff ff ff       	jmp    8010599e <sys_unlink+0x10e>
    panic("unlink: writei");
80105a26:	83 ec 0c             	sub    $0xc,%esp
80105a29:	68 91 82 10 80       	push   $0x80108291
80105a2e:	e8 5d a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105a33:	83 ec 0c             	sub    $0xc,%esp
80105a36:	68 7f 82 10 80       	push   $0x8010827f
80105a3b:	e8 50 a9 ff ff       	call   80100390 <panic>

80105a40 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105a40:	f3 0f 1e fb          	endbr32 
80105a44:	55                   	push   %ebp
80105a45:	89 e5                	mov    %esp,%ebp
80105a47:	57                   	push   %edi
80105a48:	56                   	push   %esi
80105a49:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105a4a:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80105a4d:	83 ec 34             	sub    $0x34,%esp
80105a50:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a53:	8b 55 10             	mov    0x10(%ebp),%edx
  if((dp = nameiparent(path, name)) == 0)
80105a56:	53                   	push   %ebx
{
80105a57:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105a5a:	ff 75 08             	pushl  0x8(%ebp)
{
80105a5d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105a60:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105a63:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105a66:	e8 a5 c9 ff ff       	call   80102410 <nameiparent>
80105a6b:	83 c4 10             	add    $0x10,%esp
80105a6e:	85 c0                	test   %eax,%eax
80105a70:	0f 84 3a 01 00 00    	je     80105bb0 <create+0x170>
    return 0;
  ilock(dp);
80105a76:	83 ec 0c             	sub    $0xc,%esp
80105a79:	89 c6                	mov    %eax,%esi
80105a7b:	50                   	push   %eax
80105a7c:	e8 9f c0 ff ff       	call   80101b20 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105a81:	83 c4 0c             	add    $0xc,%esp
80105a84:	6a 00                	push   $0x0
80105a86:	53                   	push   %ebx
80105a87:	56                   	push   %esi
80105a88:	e8 e3 c5 ff ff       	call   80102070 <dirlookup>
80105a8d:	83 c4 10             	add    $0x10,%esp
80105a90:	89 c7                	mov    %eax,%edi
80105a92:	85 c0                	test   %eax,%eax
80105a94:	74 4a                	je     80105ae0 <create+0xa0>
    iunlockput(dp);
80105a96:	83 ec 0c             	sub    $0xc,%esp
80105a99:	56                   	push   %esi
80105a9a:	e8 21 c3 ff ff       	call   80101dc0 <iunlockput>
    ilock(ip);
80105a9f:	89 3c 24             	mov    %edi,(%esp)
80105aa2:	e8 79 c0 ff ff       	call   80101b20 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105aa7:	83 c4 10             	add    $0x10,%esp
80105aaa:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105aaf:	75 17                	jne    80105ac8 <create+0x88>
80105ab1:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105ab6:	75 10                	jne    80105ac8 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105ab8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105abb:	89 f8                	mov    %edi,%eax
80105abd:	5b                   	pop    %ebx
80105abe:	5e                   	pop    %esi
80105abf:	5f                   	pop    %edi
80105ac0:	5d                   	pop    %ebp
80105ac1:	c3                   	ret    
80105ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105ac8:	83 ec 0c             	sub    $0xc,%esp
80105acb:	57                   	push   %edi
    return 0;
80105acc:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105ace:	e8 ed c2 ff ff       	call   80101dc0 <iunlockput>
    return 0;
80105ad3:	83 c4 10             	add    $0x10,%esp
}
80105ad6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ad9:	89 f8                	mov    %edi,%eax
80105adb:	5b                   	pop    %ebx
80105adc:	5e                   	pop    %esi
80105add:	5f                   	pop    %edi
80105ade:	5d                   	pop    %ebp
80105adf:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105ae0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105ae4:	83 ec 08             	sub    $0x8,%esp
80105ae7:	50                   	push   %eax
80105ae8:	ff 36                	pushl  (%esi)
80105aea:	e8 b1 be ff ff       	call   801019a0 <ialloc>
80105aef:	83 c4 10             	add    $0x10,%esp
80105af2:	89 c7                	mov    %eax,%edi
80105af4:	85 c0                	test   %eax,%eax
80105af6:	0f 84 cd 00 00 00    	je     80105bc9 <create+0x189>
  ilock(ip);
80105afc:	83 ec 0c             	sub    $0xc,%esp
80105aff:	50                   	push   %eax
80105b00:	e8 1b c0 ff ff       	call   80101b20 <ilock>
  ip->major = major;
80105b05:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105b09:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105b0d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105b11:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105b15:	b8 01 00 00 00       	mov    $0x1,%eax
80105b1a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105b1e:	89 3c 24             	mov    %edi,(%esp)
80105b21:	e8 3a bf ff ff       	call   80101a60 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105b26:	83 c4 10             	add    $0x10,%esp
80105b29:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105b2e:	74 30                	je     80105b60 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105b30:	83 ec 04             	sub    $0x4,%esp
80105b33:	ff 77 04             	pushl  0x4(%edi)
80105b36:	53                   	push   %ebx
80105b37:	56                   	push   %esi
80105b38:	e8 f3 c7 ff ff       	call   80102330 <dirlink>
80105b3d:	83 c4 10             	add    $0x10,%esp
80105b40:	85 c0                	test   %eax,%eax
80105b42:	78 78                	js     80105bbc <create+0x17c>
  iunlockput(dp);
80105b44:	83 ec 0c             	sub    $0xc,%esp
80105b47:	56                   	push   %esi
80105b48:	e8 73 c2 ff ff       	call   80101dc0 <iunlockput>
  return ip;
80105b4d:	83 c4 10             	add    $0x10,%esp
}
80105b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b53:	89 f8                	mov    %edi,%eax
80105b55:	5b                   	pop    %ebx
80105b56:	5e                   	pop    %esi
80105b57:	5f                   	pop    %edi
80105b58:	5d                   	pop    %ebp
80105b59:	c3                   	ret    
80105b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105b60:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105b63:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80105b68:	56                   	push   %esi
80105b69:	e8 f2 be ff ff       	call   80101a60 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105b6e:	83 c4 0c             	add    $0xc,%esp
80105b71:	ff 77 04             	pushl  0x4(%edi)
80105b74:	68 7d 82 10 80       	push   $0x8010827d
80105b79:	57                   	push   %edi
80105b7a:	e8 b1 c7 ff ff       	call   80102330 <dirlink>
80105b7f:	83 c4 10             	add    $0x10,%esp
80105b82:	85 c0                	test   %eax,%eax
80105b84:	78 18                	js     80105b9e <create+0x15e>
80105b86:	83 ec 04             	sub    $0x4,%esp
80105b89:	ff 76 04             	pushl  0x4(%esi)
80105b8c:	68 7c 82 10 80       	push   $0x8010827c
80105b91:	57                   	push   %edi
80105b92:	e8 99 c7 ff ff       	call   80102330 <dirlink>
80105b97:	83 c4 10             	add    $0x10,%esp
80105b9a:	85 c0                	test   %eax,%eax
80105b9c:	79 92                	jns    80105b30 <create+0xf0>
      panic("create dots");
80105b9e:	83 ec 0c             	sub    $0xc,%esp
80105ba1:	68 99 88 10 80       	push   $0x80108899
80105ba6:	e8 e5 a7 ff ff       	call   80100390 <panic>
80105bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105baf:	90                   	nop
}
80105bb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105bb3:	31 ff                	xor    %edi,%edi
}
80105bb5:	5b                   	pop    %ebx
80105bb6:	89 f8                	mov    %edi,%eax
80105bb8:	5e                   	pop    %esi
80105bb9:	5f                   	pop    %edi
80105bba:	5d                   	pop    %ebp
80105bbb:	c3                   	ret    
    panic("create: dirlink");
80105bbc:	83 ec 0c             	sub    $0xc,%esp
80105bbf:	68 a5 88 10 80       	push   $0x801088a5
80105bc4:	e8 c7 a7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105bc9:	83 ec 0c             	sub    $0xc,%esp
80105bcc:	68 8a 88 10 80       	push   $0x8010888a
80105bd1:	e8 ba a7 ff ff       	call   80100390 <panic>
80105bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bdd:	8d 76 00             	lea    0x0(%esi),%esi

80105be0 <sys_open>:

int
sys_open(void)
{
80105be0:	f3 0f 1e fb          	endbr32 
80105be4:	55                   	push   %ebp
80105be5:	89 e5                	mov    %esp,%ebp
80105be7:	57                   	push   %edi
80105be8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105be9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105bec:	53                   	push   %ebx
80105bed:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105bf0:	50                   	push   %eax
80105bf1:	6a 00                	push   $0x0
80105bf3:	e8 e8 f7 ff ff       	call   801053e0 <argstr>
80105bf8:	83 c4 10             	add    $0x10,%esp
80105bfb:	85 c0                	test   %eax,%eax
80105bfd:	0f 88 8a 00 00 00    	js     80105c8d <sys_open+0xad>
80105c03:	83 ec 08             	sub    $0x8,%esp
80105c06:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c09:	50                   	push   %eax
80105c0a:	6a 01                	push   $0x1
80105c0c:	e8 1f f7 ff ff       	call   80105330 <argint>
80105c11:	83 c4 10             	add    $0x10,%esp
80105c14:	85 c0                	test   %eax,%eax
80105c16:	78 75                	js     80105c8d <sys_open+0xad>
    return -1;

  begin_op();
80105c18:	e8 53 d8 ff ff       	call   80103470 <begin_op>

  if(omode & O_CREATE){
80105c1d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105c21:	75 75                	jne    80105c98 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105c23:	83 ec 0c             	sub    $0xc,%esp
80105c26:	ff 75 e0             	pushl  -0x20(%ebp)
80105c29:	e8 c2 c7 ff ff       	call   801023f0 <namei>
80105c2e:	83 c4 10             	add    $0x10,%esp
80105c31:	89 c6                	mov    %eax,%esi
80105c33:	85 c0                	test   %eax,%eax
80105c35:	74 78                	je     80105caf <sys_open+0xcf>
      end_op();
      return -1;
    }
    ilock(ip);
80105c37:	83 ec 0c             	sub    $0xc,%esp
80105c3a:	50                   	push   %eax
80105c3b:	e8 e0 be ff ff       	call   80101b20 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c40:	83 c4 10             	add    $0x10,%esp
80105c43:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105c48:	0f 84 ba 00 00 00    	je     80105d08 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105c4e:	e8 6d b5 ff ff       	call   801011c0 <filealloc>
80105c53:	89 c7                	mov    %eax,%edi
80105c55:	85 c0                	test   %eax,%eax
80105c57:	74 23                	je     80105c7c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105c59:	e8 b2 e4 ff ff       	call   80104110 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c5e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105c60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105c64:	85 d2                	test   %edx,%edx
80105c66:	74 58                	je     80105cc0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105c68:	83 c3 01             	add    $0x1,%ebx
80105c6b:	83 fb 10             	cmp    $0x10,%ebx
80105c6e:	75 f0                	jne    80105c60 <sys_open+0x80>
    if(f)
      fileclose(f);
80105c70:	83 ec 0c             	sub    $0xc,%esp
80105c73:	57                   	push   %edi
80105c74:	e8 07 b6 ff ff       	call   80101280 <fileclose>
80105c79:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105c7c:	83 ec 0c             	sub    $0xc,%esp
80105c7f:	56                   	push   %esi
80105c80:	e8 3b c1 ff ff       	call   80101dc0 <iunlockput>
    end_op();
80105c85:	e8 56 d8 ff ff       	call   801034e0 <end_op>
    return -1;
80105c8a:	83 c4 10             	add    $0x10,%esp
80105c8d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c92:	eb 65                	jmp    80105cf9 <sys_open+0x119>
80105c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105c98:	6a 00                	push   $0x0
80105c9a:	6a 00                	push   $0x0
80105c9c:	6a 02                	push   $0x2
80105c9e:	ff 75 e0             	pushl  -0x20(%ebp)
80105ca1:	e8 9a fd ff ff       	call   80105a40 <create>
    if(ip == 0){
80105ca6:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105ca9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105cab:	85 c0                	test   %eax,%eax
80105cad:	75 9f                	jne    80105c4e <sys_open+0x6e>
      end_op();
80105caf:	e8 2c d8 ff ff       	call   801034e0 <end_op>
      return -1;
80105cb4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105cb9:	eb 3e                	jmp    80105cf9 <sys_open+0x119>
80105cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cbf:	90                   	nop
  }
  iunlock(ip);
80105cc0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105cc3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105cc7:	56                   	push   %esi
80105cc8:	e8 33 bf ff ff       	call   80101c00 <iunlock>
  end_op();
80105ccd:	e8 0e d8 ff ff       	call   801034e0 <end_op>

  f->type = FD_INODE;
80105cd2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105cd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105cdb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105cde:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105ce1:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105ce3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105cea:	f7 d0                	not    %eax
80105cec:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105cef:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105cf2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105cf5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105cf9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cfc:	89 d8                	mov    %ebx,%eax
80105cfe:	5b                   	pop    %ebx
80105cff:	5e                   	pop    %esi
80105d00:	5f                   	pop    %edi
80105d01:	5d                   	pop    %ebp
80105d02:	c3                   	ret    
80105d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d07:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105d08:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105d0b:	85 c9                	test   %ecx,%ecx
80105d0d:	0f 84 3b ff ff ff    	je     80105c4e <sys_open+0x6e>
80105d13:	e9 64 ff ff ff       	jmp    80105c7c <sys_open+0x9c>
80105d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1f:	90                   	nop

80105d20 <sys_mkdir>:

int
sys_mkdir(void)
{
80105d20:	f3 0f 1e fb          	endbr32 
80105d24:	55                   	push   %ebp
80105d25:	89 e5                	mov    %esp,%ebp
80105d27:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105d2a:	e8 41 d7 ff ff       	call   80103470 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105d2f:	83 ec 08             	sub    $0x8,%esp
80105d32:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d35:	50                   	push   %eax
80105d36:	6a 00                	push   $0x0
80105d38:	e8 a3 f6 ff ff       	call   801053e0 <argstr>
80105d3d:	83 c4 10             	add    $0x10,%esp
80105d40:	85 c0                	test   %eax,%eax
80105d42:	78 2c                	js     80105d70 <sys_mkdir+0x50>
80105d44:	6a 00                	push   $0x0
80105d46:	6a 00                	push   $0x0
80105d48:	6a 01                	push   $0x1
80105d4a:	ff 75 f4             	pushl  -0xc(%ebp)
80105d4d:	e8 ee fc ff ff       	call   80105a40 <create>
80105d52:	83 c4 10             	add    $0x10,%esp
80105d55:	85 c0                	test   %eax,%eax
80105d57:	74 17                	je     80105d70 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d59:	83 ec 0c             	sub    $0xc,%esp
80105d5c:	50                   	push   %eax
80105d5d:	e8 5e c0 ff ff       	call   80101dc0 <iunlockput>
  end_op();
80105d62:	e8 79 d7 ff ff       	call   801034e0 <end_op>
  return 0;
80105d67:	83 c4 10             	add    $0x10,%esp
80105d6a:	31 c0                	xor    %eax,%eax
}
80105d6c:	c9                   	leave  
80105d6d:	c3                   	ret    
80105d6e:	66 90                	xchg   %ax,%ax
    end_op();
80105d70:	e8 6b d7 ff ff       	call   801034e0 <end_op>
    return -1;
80105d75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d7a:	c9                   	leave  
80105d7b:	c3                   	ret    
80105d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d80 <sys_mknod>:

int
sys_mknod(void)
{
80105d80:	f3 0f 1e fb          	endbr32 
80105d84:	55                   	push   %ebp
80105d85:	89 e5                	mov    %esp,%ebp
80105d87:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105d8a:	e8 e1 d6 ff ff       	call   80103470 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105d8f:	83 ec 08             	sub    $0x8,%esp
80105d92:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d95:	50                   	push   %eax
80105d96:	6a 00                	push   $0x0
80105d98:	e8 43 f6 ff ff       	call   801053e0 <argstr>
80105d9d:	83 c4 10             	add    $0x10,%esp
80105da0:	85 c0                	test   %eax,%eax
80105da2:	78 5c                	js     80105e00 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105da4:	83 ec 08             	sub    $0x8,%esp
80105da7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105daa:	50                   	push   %eax
80105dab:	6a 01                	push   $0x1
80105dad:	e8 7e f5 ff ff       	call   80105330 <argint>
  if((argstr(0, &path)) < 0 ||
80105db2:	83 c4 10             	add    $0x10,%esp
80105db5:	85 c0                	test   %eax,%eax
80105db7:	78 47                	js     80105e00 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105db9:	83 ec 08             	sub    $0x8,%esp
80105dbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dbf:	50                   	push   %eax
80105dc0:	6a 02                	push   $0x2
80105dc2:	e8 69 f5 ff ff       	call   80105330 <argint>
     argint(1, &major) < 0 ||
80105dc7:	83 c4 10             	add    $0x10,%esp
80105dca:	85 c0                	test   %eax,%eax
80105dcc:	78 32                	js     80105e00 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105dce:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105dd2:	50                   	push   %eax
80105dd3:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80105dd7:	50                   	push   %eax
80105dd8:	6a 03                	push   $0x3
80105dda:	ff 75 ec             	pushl  -0x14(%ebp)
80105ddd:	e8 5e fc ff ff       	call   80105a40 <create>
     argint(2, &minor) < 0 ||
80105de2:	83 c4 10             	add    $0x10,%esp
80105de5:	85 c0                	test   %eax,%eax
80105de7:	74 17                	je     80105e00 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105de9:	83 ec 0c             	sub    $0xc,%esp
80105dec:	50                   	push   %eax
80105ded:	e8 ce bf ff ff       	call   80101dc0 <iunlockput>
  end_op();
80105df2:	e8 e9 d6 ff ff       	call   801034e0 <end_op>
  return 0;
80105df7:	83 c4 10             	add    $0x10,%esp
80105dfa:	31 c0                	xor    %eax,%eax
}
80105dfc:	c9                   	leave  
80105dfd:	c3                   	ret    
80105dfe:	66 90                	xchg   %ax,%ax
    end_op();
80105e00:	e8 db d6 ff ff       	call   801034e0 <end_op>
    return -1;
80105e05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e0a:	c9                   	leave  
80105e0b:	c3                   	ret    
80105e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e10 <sys_chdir>:

int
sys_chdir(void)
{
80105e10:	f3 0f 1e fb          	endbr32 
80105e14:	55                   	push   %ebp
80105e15:	89 e5                	mov    %esp,%ebp
80105e17:	56                   	push   %esi
80105e18:	53                   	push   %ebx
80105e19:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105e1c:	e8 ef e2 ff ff       	call   80104110 <myproc>
80105e21:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105e23:	e8 48 d6 ff ff       	call   80103470 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105e28:	83 ec 08             	sub    $0x8,%esp
80105e2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e2e:	50                   	push   %eax
80105e2f:	6a 00                	push   $0x0
80105e31:	e8 aa f5 ff ff       	call   801053e0 <argstr>
80105e36:	83 c4 10             	add    $0x10,%esp
80105e39:	85 c0                	test   %eax,%eax
80105e3b:	78 73                	js     80105eb0 <sys_chdir+0xa0>
80105e3d:	83 ec 0c             	sub    $0xc,%esp
80105e40:	ff 75 f4             	pushl  -0xc(%ebp)
80105e43:	e8 a8 c5 ff ff       	call   801023f0 <namei>
80105e48:	83 c4 10             	add    $0x10,%esp
80105e4b:	89 c3                	mov    %eax,%ebx
80105e4d:	85 c0                	test   %eax,%eax
80105e4f:	74 5f                	je     80105eb0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105e51:	83 ec 0c             	sub    $0xc,%esp
80105e54:	50                   	push   %eax
80105e55:	e8 c6 bc ff ff       	call   80101b20 <ilock>
  if(ip->type != T_DIR){
80105e5a:	83 c4 10             	add    $0x10,%esp
80105e5d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e62:	75 2c                	jne    80105e90 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105e64:	83 ec 0c             	sub    $0xc,%esp
80105e67:	53                   	push   %ebx
80105e68:	e8 93 bd ff ff       	call   80101c00 <iunlock>
  iput(curproc->cwd);
80105e6d:	58                   	pop    %eax
80105e6e:	ff 76 68             	pushl  0x68(%esi)
80105e71:	e8 da bd ff ff       	call   80101c50 <iput>
  end_op();
80105e76:	e8 65 d6 ff ff       	call   801034e0 <end_op>
  curproc->cwd = ip;
80105e7b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105e7e:	83 c4 10             	add    $0x10,%esp
80105e81:	31 c0                	xor    %eax,%eax
}
80105e83:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e86:	5b                   	pop    %ebx
80105e87:	5e                   	pop    %esi
80105e88:	5d                   	pop    %ebp
80105e89:	c3                   	ret    
80105e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105e90:	83 ec 0c             	sub    $0xc,%esp
80105e93:	53                   	push   %ebx
80105e94:	e8 27 bf ff ff       	call   80101dc0 <iunlockput>
    end_op();
80105e99:	e8 42 d6 ff ff       	call   801034e0 <end_op>
    return -1;
80105e9e:	83 c4 10             	add    $0x10,%esp
80105ea1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ea6:	eb db                	jmp    80105e83 <sys_chdir+0x73>
80105ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eaf:	90                   	nop
    end_op();
80105eb0:	e8 2b d6 ff ff       	call   801034e0 <end_op>
    return -1;
80105eb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eba:	eb c7                	jmp    80105e83 <sys_chdir+0x73>
80105ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ec0 <sys_exec>:

int
sys_exec(void)
{
80105ec0:	f3 0f 1e fb          	endbr32 
80105ec4:	55                   	push   %ebp
80105ec5:	89 e5                	mov    %esp,%ebp
80105ec7:	57                   	push   %edi
80105ec8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ec9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105ecf:	53                   	push   %ebx
80105ed0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ed6:	50                   	push   %eax
80105ed7:	6a 00                	push   $0x0
80105ed9:	e8 02 f5 ff ff       	call   801053e0 <argstr>
80105ede:	83 c4 10             	add    $0x10,%esp
80105ee1:	85 c0                	test   %eax,%eax
80105ee3:	0f 88 8b 00 00 00    	js     80105f74 <sys_exec+0xb4>
80105ee9:	83 ec 08             	sub    $0x8,%esp
80105eec:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105ef2:	50                   	push   %eax
80105ef3:	6a 01                	push   $0x1
80105ef5:	e8 36 f4 ff ff       	call   80105330 <argint>
80105efa:	83 c4 10             	add    $0x10,%esp
80105efd:	85 c0                	test   %eax,%eax
80105eff:	78 73                	js     80105f74 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105f01:	83 ec 04             	sub    $0x4,%esp
80105f04:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105f0a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105f0c:	68 80 00 00 00       	push   $0x80
80105f11:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105f17:	6a 00                	push   $0x0
80105f19:	50                   	push   %eax
80105f1a:	e8 31 f1 ff ff       	call   80105050 <memset>
80105f1f:	83 c4 10             	add    $0x10,%esp
80105f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105f28:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105f2e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105f35:	83 ec 08             	sub    $0x8,%esp
80105f38:	57                   	push   %edi
80105f39:	01 f0                	add    %esi,%eax
80105f3b:	50                   	push   %eax
80105f3c:	e8 4f f3 ff ff       	call   80105290 <fetchint>
80105f41:	83 c4 10             	add    $0x10,%esp
80105f44:	85 c0                	test   %eax,%eax
80105f46:	78 2c                	js     80105f74 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105f48:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105f4e:	85 c0                	test   %eax,%eax
80105f50:	74 36                	je     80105f88 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105f52:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105f58:	83 ec 08             	sub    $0x8,%esp
80105f5b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105f5e:	52                   	push   %edx
80105f5f:	50                   	push   %eax
80105f60:	e8 6b f3 ff ff       	call   801052d0 <fetchstr>
80105f65:	83 c4 10             	add    $0x10,%esp
80105f68:	85 c0                	test   %eax,%eax
80105f6a:	78 08                	js     80105f74 <sys_exec+0xb4>
  for(i=0;; i++){
80105f6c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105f6f:	83 fb 20             	cmp    $0x20,%ebx
80105f72:	75 b4                	jne    80105f28 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105f77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f7c:	5b                   	pop    %ebx
80105f7d:	5e                   	pop    %esi
80105f7e:	5f                   	pop    %edi
80105f7f:	5d                   	pop    %ebp
80105f80:	c3                   	ret    
80105f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105f88:	83 ec 08             	sub    $0x8,%esp
80105f8b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105f91:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105f98:	00 00 00 00 
  return exec(path, argv);
80105f9c:	50                   	push   %eax
80105f9d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105fa3:	e8 68 ab ff ff       	call   80100b10 <exec>
80105fa8:	83 c4 10             	add    $0x10,%esp
}
80105fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fae:	5b                   	pop    %ebx
80105faf:	5e                   	pop    %esi
80105fb0:	5f                   	pop    %edi
80105fb1:	5d                   	pop    %ebp
80105fb2:	c3                   	ret    
80105fb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105fc0 <sys_pipe>:

int
sys_pipe(void)
{
80105fc0:	f3 0f 1e fb          	endbr32 
80105fc4:	55                   	push   %ebp
80105fc5:	89 e5                	mov    %esp,%ebp
80105fc7:	57                   	push   %edi
80105fc8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105fc9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105fcc:	53                   	push   %ebx
80105fcd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105fd0:	6a 08                	push   $0x8
80105fd2:	50                   	push   %eax
80105fd3:	6a 00                	push   $0x0
80105fd5:	e8 a6 f3 ff ff       	call   80105380 <argptr>
80105fda:	83 c4 10             	add    $0x10,%esp
80105fdd:	85 c0                	test   %eax,%eax
80105fdf:	78 4e                	js     8010602f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105fe1:	83 ec 08             	sub    $0x8,%esp
80105fe4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105fe7:	50                   	push   %eax
80105fe8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105feb:	50                   	push   %eax
80105fec:	e8 3f db ff ff       	call   80103b30 <pipealloc>
80105ff1:	83 c4 10             	add    $0x10,%esp
80105ff4:	85 c0                	test   %eax,%eax
80105ff6:	78 37                	js     8010602f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ff8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105ffb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105ffd:	e8 0e e1 ff ff       	call   80104110 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80106008:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010600c:	85 f6                	test   %esi,%esi
8010600e:	74 30                	je     80106040 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80106010:	83 c3 01             	add    $0x1,%ebx
80106013:	83 fb 10             	cmp    $0x10,%ebx
80106016:	75 f0                	jne    80106008 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106018:	83 ec 0c             	sub    $0xc,%esp
8010601b:	ff 75 e0             	pushl  -0x20(%ebp)
8010601e:	e8 5d b2 ff ff       	call   80101280 <fileclose>
    fileclose(wf);
80106023:	58                   	pop    %eax
80106024:	ff 75 e4             	pushl  -0x1c(%ebp)
80106027:	e8 54 b2 ff ff       	call   80101280 <fileclose>
    return -1;
8010602c:	83 c4 10             	add    $0x10,%esp
8010602f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106034:	eb 5b                	jmp    80106091 <sys_pipe+0xd1>
80106036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010603d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106040:	8d 73 08             	lea    0x8(%ebx),%esi
80106043:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106047:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010604a:	e8 c1 e0 ff ff       	call   80104110 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010604f:	31 d2                	xor    %edx,%edx
80106051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106058:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010605c:	85 c9                	test   %ecx,%ecx
8010605e:	74 20                	je     80106080 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80106060:	83 c2 01             	add    $0x1,%edx
80106063:	83 fa 10             	cmp    $0x10,%edx
80106066:	75 f0                	jne    80106058 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106068:	e8 a3 e0 ff ff       	call   80104110 <myproc>
8010606d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106074:	00 
80106075:	eb a1                	jmp    80106018 <sys_pipe+0x58>
80106077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010607e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106080:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106084:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106087:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106089:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010608c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010608f:	31 c0                	xor    %eax,%eax
}
80106091:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106094:	5b                   	pop    %ebx
80106095:	5e                   	pop    %esi
80106096:	5f                   	pop    %edi
80106097:	5d                   	pop    %ebp
80106098:	c3                   	ret    
80106099:	66 90                	xchg   %ax,%ax
8010609b:	66 90                	xchg   %ax,%ax
8010609d:	66 90                	xchg   %ax,%ax
8010609f:	90                   	nop

801060a0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801060a0:	f3 0f 1e fb          	endbr32 
  return fork();
801060a4:	e9 17 e2 ff ff       	jmp    801042c0 <fork>
801060a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060b0 <sys_exit>:
}

int
sys_exit(void)
{
801060b0:	f3 0f 1e fb          	endbr32 
801060b4:	55                   	push   %ebp
801060b5:	89 e5                	mov    %esp,%ebp
801060b7:	83 ec 08             	sub    $0x8,%esp
  exit();
801060ba:	e8 e1 e5 ff ff       	call   801046a0 <exit>
  return 0;  // not reached
}
801060bf:	31 c0                	xor    %eax,%eax
801060c1:	c9                   	leave  
801060c2:	c3                   	ret    
801060c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801060d0 <sys_wait>:

int
sys_wait(void)
{
801060d0:	f3 0f 1e fb          	endbr32 
  return wait();
801060d4:	e9 17 e8 ff ff       	jmp    801048f0 <wait>
801060d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060e0 <sys_kill>:
}

int
sys_kill(void)
{
801060e0:	f3 0f 1e fb          	endbr32 
801060e4:	55                   	push   %ebp
801060e5:	89 e5                	mov    %esp,%ebp
801060e7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801060ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060ed:	50                   	push   %eax
801060ee:	6a 00                	push   $0x0
801060f0:	e8 3b f2 ff ff       	call   80105330 <argint>
801060f5:	83 c4 10             	add    $0x10,%esp
801060f8:	85 c0                	test   %eax,%eax
801060fa:	78 14                	js     80106110 <sys_kill+0x30>
    return -1;
  return kill(pid);
801060fc:	83 ec 0c             	sub    $0xc,%esp
801060ff:	ff 75 f4             	pushl  -0xc(%ebp)
80106102:	e8 f9 e9 ff ff       	call   80104b00 <kill>
80106107:	83 c4 10             	add    $0x10,%esp
}
8010610a:	c9                   	leave  
8010610b:	c3                   	ret    
8010610c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106110:	c9                   	leave  
    return -1;
80106111:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106116:	c3                   	ret    
80106117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010611e:	66 90                	xchg   %ax,%ax

80106120 <sys_getpid>:

int
sys_getpid(void)
{
80106120:	f3 0f 1e fb          	endbr32 
80106124:	55                   	push   %ebp
80106125:	89 e5                	mov    %esp,%ebp
80106127:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010612a:	e8 e1 df ff ff       	call   80104110 <myproc>
8010612f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106132:	c9                   	leave  
80106133:	c3                   	ret    
80106134:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010613b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010613f:	90                   	nop

80106140 <sys_sbrk>:

int
sys_sbrk(void)
{
80106140:	f3 0f 1e fb          	endbr32 
80106144:	55                   	push   %ebp
80106145:	89 e5                	mov    %esp,%ebp
80106147:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106148:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010614b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010614e:	50                   	push   %eax
8010614f:	6a 00                	push   $0x0
80106151:	e8 da f1 ff ff       	call   80105330 <argint>
80106156:	83 c4 10             	add    $0x10,%esp
80106159:	85 c0                	test   %eax,%eax
8010615b:	78 23                	js     80106180 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010615d:	e8 ae df ff ff       	call   80104110 <myproc>
  if(growproc(n) < 0)
80106162:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106165:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106167:	ff 75 f4             	pushl  -0xc(%ebp)
8010616a:	e8 d1 e0 ff ff       	call   80104240 <growproc>
8010616f:	83 c4 10             	add    $0x10,%esp
80106172:	85 c0                	test   %eax,%eax
80106174:	78 0a                	js     80106180 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106176:	89 d8                	mov    %ebx,%eax
80106178:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010617b:	c9                   	leave  
8010617c:	c3                   	ret    
8010617d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106180:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106185:	eb ef                	jmp    80106176 <sys_sbrk+0x36>
80106187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010618e:	66 90                	xchg   %ax,%ax

80106190 <sys_sleep>:

int
sys_sleep(void)
{
80106190:	f3 0f 1e fb          	endbr32 
80106194:	55                   	push   %ebp
80106195:	89 e5                	mov    %esp,%ebp
80106197:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106198:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010619b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010619e:	50                   	push   %eax
8010619f:	6a 00                	push   $0x0
801061a1:	e8 8a f1 ff ff       	call   80105330 <argint>
801061a6:	83 c4 10             	add    $0x10,%esp
801061a9:	85 c0                	test   %eax,%eax
801061ab:	0f 88 86 00 00 00    	js     80106237 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801061b1:	83 ec 0c             	sub    $0xc,%esp
801061b4:	68 80 21 12 80       	push   $0x80122180
801061b9:	e8 82 ed ff ff       	call   80104f40 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801061be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801061c1:	8b 1d c0 29 12 80    	mov    0x801229c0,%ebx
  while(ticks - ticks0 < n){
801061c7:	83 c4 10             	add    $0x10,%esp
801061ca:	85 d2                	test   %edx,%edx
801061cc:	75 23                	jne    801061f1 <sys_sleep+0x61>
801061ce:	eb 50                	jmp    80106220 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801061d0:	83 ec 08             	sub    $0x8,%esp
801061d3:	68 80 21 12 80       	push   $0x80122180
801061d8:	68 c0 29 12 80       	push   $0x801229c0
801061dd:	e8 4e e6 ff ff       	call   80104830 <sleep>
  while(ticks - ticks0 < n){
801061e2:	a1 c0 29 12 80       	mov    0x801229c0,%eax
801061e7:	83 c4 10             	add    $0x10,%esp
801061ea:	29 d8                	sub    %ebx,%eax
801061ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801061ef:	73 2f                	jae    80106220 <sys_sleep+0x90>
    if(myproc()->killed){
801061f1:	e8 1a df ff ff       	call   80104110 <myproc>
801061f6:	8b 40 24             	mov    0x24(%eax),%eax
801061f9:	85 c0                	test   %eax,%eax
801061fb:	74 d3                	je     801061d0 <sys_sleep+0x40>
      release(&tickslock);
801061fd:	83 ec 0c             	sub    $0xc,%esp
80106200:	68 80 21 12 80       	push   $0x80122180
80106205:	e8 f6 ed ff ff       	call   80105000 <release>
  }
  release(&tickslock);
  return 0;
}
8010620a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010620d:	83 c4 10             	add    $0x10,%esp
80106210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106215:	c9                   	leave  
80106216:	c3                   	ret    
80106217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010621e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106220:	83 ec 0c             	sub    $0xc,%esp
80106223:	68 80 21 12 80       	push   $0x80122180
80106228:	e8 d3 ed ff ff       	call   80105000 <release>
  return 0;
8010622d:	83 c4 10             	add    $0x10,%esp
80106230:	31 c0                	xor    %eax,%eax
}
80106232:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106235:	c9                   	leave  
80106236:	c3                   	ret    
    return -1;
80106237:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010623c:	eb f4                	jmp    80106232 <sys_sleep+0xa2>
8010623e:	66 90                	xchg   %ax,%ax

80106240 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106240:	f3 0f 1e fb          	endbr32 
80106244:	55                   	push   %ebp
80106245:	89 e5                	mov    %esp,%ebp
80106247:	53                   	push   %ebx
80106248:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010624b:	68 80 21 12 80       	push   $0x80122180
80106250:	e8 eb ec ff ff       	call   80104f40 <acquire>
  xticks = ticks;
80106255:	8b 1d c0 29 12 80    	mov    0x801229c0,%ebx
  release(&tickslock);
8010625b:	c7 04 24 80 21 12 80 	movl   $0x80122180,(%esp)
80106262:	e8 99 ed ff ff       	call   80105000 <release>
  return xticks;
}
80106267:	89 d8                	mov    %ebx,%eax
80106269:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010626c:	c9                   	leave  
8010626d:	c3                   	ret    

8010626e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010626e:	1e                   	push   %ds
  pushl %es
8010626f:	06                   	push   %es
  pushl %fs
80106270:	0f a0                	push   %fs
  pushl %gs
80106272:	0f a8                	push   %gs
  pushal
80106274:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106275:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106279:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010627b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010627d:	54                   	push   %esp
  call trap
8010627e:	e8 cd 00 00 00       	call   80106350 <trap>
  addl $4, %esp
80106283:	83 c4 04             	add    $0x4,%esp

80106286 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106286:	61                   	popa   
  popl %gs
80106287:	0f a9                	pop    %gs
  popl %fs
80106289:	0f a1                	pop    %fs
  popl %es
8010628b:	07                   	pop    %es
  popl %ds
8010628c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010628d:	83 c4 08             	add    $0x8,%esp
  iret
80106290:	cf                   	iret   
80106291:	66 90                	xchg   %ax,%ax
80106293:	66 90                	xchg   %ax,%ax
80106295:	66 90                	xchg   %ax,%ax
80106297:	66 90                	xchg   %ax,%ax
80106299:	66 90                	xchg   %ax,%ax
8010629b:	66 90                	xchg   %ax,%ax
8010629d:	66 90                	xchg   %ax,%ax
8010629f:	90                   	nop

801062a0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801062a0:	f3 0f 1e fb          	endbr32 
801062a4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801062a5:	31 c0                	xor    %eax,%eax
{
801062a7:	89 e5                	mov    %esp,%ebp
801062a9:	83 ec 08             	sub    $0x8,%esp
801062ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801062b0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801062b7:	c7 04 c5 c2 21 12 80 	movl   $0x8e000008,-0x7fedde3e(,%eax,8)
801062be:	08 00 00 8e 
801062c2:	66 89 14 c5 c0 21 12 	mov    %dx,-0x7fedde40(,%eax,8)
801062c9:	80 
801062ca:	c1 ea 10             	shr    $0x10,%edx
801062cd:	66 89 14 c5 c6 21 12 	mov    %dx,-0x7fedde3a(,%eax,8)
801062d4:	80 
  for(i = 0; i < 256; i++)
801062d5:	83 c0 01             	add    $0x1,%eax
801062d8:	3d 00 01 00 00       	cmp    $0x100,%eax
801062dd:	75 d1                	jne    801062b0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801062df:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801062e2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801062e7:	c7 05 c2 23 12 80 08 	movl   $0xef000008,0x801223c2
801062ee:	00 00 ef 
  initlock(&tickslock, "time");
801062f1:	68 b5 88 10 80       	push   $0x801088b5
801062f6:	68 80 21 12 80       	push   $0x80122180
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801062fb:	66 a3 c0 23 12 80    	mov    %ax,0x801223c0
80106301:	c1 e8 10             	shr    $0x10,%eax
80106304:	66 a3 c6 23 12 80    	mov    %ax,0x801223c6
  initlock(&tickslock, "time");
8010630a:	e8 b1 ea ff ff       	call   80104dc0 <initlock>
}
8010630f:	83 c4 10             	add    $0x10,%esp
80106312:	c9                   	leave  
80106313:	c3                   	ret    
80106314:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010631b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010631f:	90                   	nop

80106320 <idtinit>:

void
idtinit(void)
{
80106320:	f3 0f 1e fb          	endbr32 
80106324:	55                   	push   %ebp
  pd[0] = size-1;
80106325:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010632a:	89 e5                	mov    %esp,%ebp
8010632c:	83 ec 10             	sub    $0x10,%esp
8010632f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106333:	b8 c0 21 12 80       	mov    $0x801221c0,%eax
80106338:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010633c:	c1 e8 10             	shr    $0x10,%eax
8010633f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106343:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106346:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106349:	c9                   	leave  
8010634a:	c3                   	ret    
8010634b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010634f:	90                   	nop

80106350 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106350:	f3 0f 1e fb          	endbr32 
80106354:	55                   	push   %ebp
80106355:	89 e5                	mov    %esp,%ebp
80106357:	57                   	push   %edi
80106358:	56                   	push   %esi
80106359:	53                   	push   %ebx
8010635a:	83 ec 1c             	sub    $0x1c,%esp
8010635d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106360:	8b 43 30             	mov    0x30(%ebx),%eax
80106363:	83 f8 40             	cmp    $0x40,%eax
80106366:	0f 84 cc 01 00 00    	je     80106538 <trap+0x1e8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010636c:	83 e8 0e             	sub    $0xe,%eax
8010636f:	83 f8 31             	cmp    $0x31,%eax
80106372:	77 3d                	ja     801063b1 <trap+0x61>
80106374:	3e ff 24 85 70 89 10 	notrack jmp *-0x7fef7690(,%eax,4)
8010637b:	80 

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010637c:	0f 20 d7             	mov    %cr2,%edi
    break;

  case T_PGFLT:
  ;
    uint faulting_addr = rcr2();
    struct proc* p = myproc();
8010637f:	e8 8c dd ff ff       	call   80104110 <myproc>
    // p->tf->eip
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80106384:	83 ec 04             	sub    $0x4,%esp
80106387:	6a 00                	push   $0x0
80106389:	57                   	push   %edi
8010638a:	ff 70 04             	pushl  0x4(%eax)
8010638d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106390:	e8 eb 10 00 00       	call   80107480 <public_walkpgdir>
    if (!(pte_ptr == 0) && (*pte_ptr & PTE_U) && (*pte_ptr & PTE_PG)){
80106395:	83 c4 10             	add    $0x10,%esp
80106398:	85 c0                	test   %eax,%eax
8010639a:	74 15                	je     801063b1 <trap+0x61>
8010639c:	8b 00                	mov    (%eax),%eax
8010639e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801063a1:	25 04 02 00 00       	and    $0x204,%eax
801063a6:	3d 04 02 00 00       	cmp    $0x204,%eax
801063ab:	0f 84 cf 01 00 00    	je     80106580 <trap+0x230>
      break;
    }

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801063b1:	e8 5a dd ff ff       	call   80104110 <myproc>
801063b6:	8b 7b 38             	mov    0x38(%ebx),%edi
801063b9:	85 c0                	test   %eax,%eax
801063bb:	0f 84 6b 02 00 00    	je     8010662c <trap+0x2dc>
801063c1:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801063c5:	0f 84 61 02 00 00    	je     8010662c <trap+0x2dc>
801063cb:	0f 20 d1             	mov    %cr2,%ecx
801063ce:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063d1:	e8 1a dd ff ff       	call   801040f0 <cpuid>
801063d6:	8b 73 30             	mov    0x30(%ebx),%esi
801063d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
801063dc:	8b 43 34             	mov    0x34(%ebx),%eax
801063df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801063e2:	e8 29 dd ff ff       	call   80104110 <myproc>
801063e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
801063ea:	e8 21 dd ff ff       	call   80104110 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063ef:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801063f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801063f5:	51                   	push   %ecx
801063f6:	57                   	push   %edi
801063f7:	52                   	push   %edx
801063f8:	ff 75 e4             	pushl  -0x1c(%ebp)
801063fb:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801063fc:	8b 75 e0             	mov    -0x20(%ebp),%esi
801063ff:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106402:	56                   	push   %esi
80106403:	ff 70 10             	pushl  0x10(%eax)
80106406:	68 2c 89 10 80       	push   $0x8010892c
8010640b:	e8 a0 a2 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106410:	83 c4 20             	add    $0x20,%esp
80106413:	e8 f8 dc ff ff       	call   80104110 <myproc>
80106418:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010641f:	e8 ec dc ff ff       	call   80104110 <myproc>
80106424:	85 c0                	test   %eax,%eax
80106426:	74 1d                	je     80106445 <trap+0xf5>
80106428:	e8 e3 dc ff ff       	call   80104110 <myproc>
8010642d:	8b 50 24             	mov    0x24(%eax),%edx
80106430:	85 d2                	test   %edx,%edx
80106432:	74 11                	je     80106445 <trap+0xf5>
80106434:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106438:	83 e0 03             	and    $0x3,%eax
8010643b:	66 83 f8 03          	cmp    $0x3,%ax
8010643f:	0f 84 2b 01 00 00    	je     80106570 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106445:	e8 c6 dc ff ff       	call   80104110 <myproc>
8010644a:	85 c0                	test   %eax,%eax
8010644c:	74 0f                	je     8010645d <trap+0x10d>
8010644e:	e8 bd dc ff ff       	call   80104110 <myproc>
80106453:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106457:	0f 84 c3 00 00 00    	je     80106520 <trap+0x1d0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010645d:	e8 ae dc ff ff       	call   80104110 <myproc>
80106462:	85 c0                	test   %eax,%eax
80106464:	74 1d                	je     80106483 <trap+0x133>
80106466:	e8 a5 dc ff ff       	call   80104110 <myproc>
8010646b:	8b 40 24             	mov    0x24(%eax),%eax
8010646e:	85 c0                	test   %eax,%eax
80106470:	74 11                	je     80106483 <trap+0x133>
80106472:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106476:	83 e0 03             	and    $0x3,%eax
80106479:	66 83 f8 03          	cmp    $0x3,%ax
8010647d:	0f 84 de 00 00 00    	je     80106561 <trap+0x211>
    exit();
}
80106483:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106486:	5b                   	pop    %ebx
80106487:	5e                   	pop    %esi
80106488:	5f                   	pop    %edi
80106489:	5d                   	pop    %ebp
8010648a:	c3                   	ret    
    if(cpuid() == 0){
8010648b:	e8 60 dc ff ff       	call   801040f0 <cpuid>
80106490:	85 c0                	test   %eax,%eax
80106492:	0f 84 28 01 00 00    	je     801065c0 <trap+0x270>
    lapiceoi();
80106498:	e8 63 cb ff ff       	call   80103000 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010649d:	e8 6e dc ff ff       	call   80104110 <myproc>
801064a2:	85 c0                	test   %eax,%eax
801064a4:	75 82                	jne    80106428 <trap+0xd8>
801064a6:	eb 9d                	jmp    80106445 <trap+0xf5>
    kbdintr();
801064a8:	e8 13 ca ff ff       	call   80102ec0 <kbdintr>
    lapiceoi();
801064ad:	e8 4e cb ff ff       	call   80103000 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064b2:	e8 59 dc ff ff       	call   80104110 <myproc>
801064b7:	85 c0                	test   %eax,%eax
801064b9:	0f 85 69 ff ff ff    	jne    80106428 <trap+0xd8>
801064bf:	eb 84                	jmp    80106445 <trap+0xf5>
    uartintr();
801064c1:	e8 0a 03 00 00       	call   801067d0 <uartintr>
    lapiceoi();
801064c6:	e8 35 cb ff ff       	call   80103000 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064cb:	e8 40 dc ff ff       	call   80104110 <myproc>
801064d0:	85 c0                	test   %eax,%eax
801064d2:	0f 85 50 ff ff ff    	jne    80106428 <trap+0xd8>
801064d8:	e9 68 ff ff ff       	jmp    80106445 <trap+0xf5>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801064dd:	8b 7b 38             	mov    0x38(%ebx),%edi
801064e0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801064e4:	e8 07 dc ff ff       	call   801040f0 <cpuid>
801064e9:	57                   	push   %edi
801064ea:	56                   	push   %esi
801064eb:	50                   	push   %eax
801064ec:	68 d4 88 10 80       	push   $0x801088d4
801064f1:	e8 ba a1 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801064f6:	e8 05 cb ff ff       	call   80103000 <lapiceoi>
    break;
801064fb:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064fe:	e8 0d dc ff ff       	call   80104110 <myproc>
80106503:	85 c0                	test   %eax,%eax
80106505:	0f 85 1d ff ff ff    	jne    80106428 <trap+0xd8>
8010650b:	e9 35 ff ff ff       	jmp    80106445 <trap+0xf5>
    ideintr();
80106510:	e8 0b c4 ff ff       	call   80102920 <ideintr>
80106515:	eb 81                	jmp    80106498 <trap+0x148>
80106517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010651e:	66 90                	xchg   %ax,%ax
  if(myproc() && myproc()->state == RUNNING &&
80106520:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106524:	0f 85 33 ff ff ff    	jne    8010645d <trap+0x10d>
    yield();
8010652a:	e8 b1 e2 ff ff       	call   801047e0 <yield>
8010652f:	e9 29 ff ff ff       	jmp    8010645d <trap+0x10d>
80106534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106538:	e8 d3 db ff ff       	call   80104110 <myproc>
8010653d:	8b 40 24             	mov    0x24(%eax),%eax
80106540:	85 c0                	test   %eax,%eax
80106542:	75 74                	jne    801065b8 <trap+0x268>
    myproc()->tf = tf;
80106544:	e8 c7 db ff ff       	call   80104110 <myproc>
80106549:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010654c:	e8 cf ee ff ff       	call   80105420 <syscall>
    if(myproc()->killed)
80106551:	e8 ba db ff ff       	call   80104110 <myproc>
80106556:	8b 40 24             	mov    0x24(%eax),%eax
80106559:	85 c0                	test   %eax,%eax
8010655b:	0f 84 22 ff ff ff    	je     80106483 <trap+0x133>
}
80106561:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106564:	5b                   	pop    %ebx
80106565:	5e                   	pop    %esi
80106566:	5f                   	pop    %edi
80106567:	5d                   	pop    %ebp
      exit();
80106568:	e9 33 e1 ff ff       	jmp    801046a0 <exit>
8010656d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106570:	e8 2b e1 ff ff       	call   801046a0 <exit>
80106575:	e9 cb fe ff ff       	jmp    80106445 <trap+0xf5>
8010657a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106580:	8d 82 90 00 00 00    	lea    0x90(%edx),%eax
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
80106586:	31 f6                	xor    %esi,%esi
80106588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010658f:	90                   	nop
        if (PGROUNDDOWN((uint)(p->swapped_out_pages[i].va)) == PGROUNDDOWN(faulting_addr)){
80106590:	8b 08                	mov    (%eax),%ecx
80106592:	31 f9                	xor    %edi,%ecx
80106594:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
8010659a:	74 5c                	je     801065f8 <trap+0x2a8>
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
8010659c:	83 c6 01             	add    $0x1,%esi
8010659f:	83 c0 18             	add    $0x18,%eax
801065a2:	83 fe 10             	cmp    $0x10,%esi
801065a5:	75 e9                	jne    80106590 <trap+0x240>
      p->num_of_pagefaults_occurs++;
801065a7:	83 82 88 03 00 00 01 	addl   $0x1,0x388(%edx)
      break;
801065ae:	e9 6c fe ff ff       	jmp    8010641f <trap+0xcf>
801065b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065b7:	90                   	nop
      exit();
801065b8:	e8 e3 e0 ff ff       	call   801046a0 <exit>
801065bd:	eb 85                	jmp    80106544 <trap+0x1f4>
801065bf:	90                   	nop
      acquire(&tickslock);
801065c0:	83 ec 0c             	sub    $0xc,%esp
801065c3:	68 80 21 12 80       	push   $0x80122180
801065c8:	e8 73 e9 ff ff       	call   80104f40 <acquire>
      wakeup(&ticks);
801065cd:	c7 04 24 c0 29 12 80 	movl   $0x801229c0,(%esp)
      ticks++;
801065d4:	83 05 c0 29 12 80 01 	addl   $0x1,0x801229c0
      wakeup(&ticks);
801065db:	e8 b0 e4 ff ff       	call   80104a90 <wakeup>
      release(&tickslock);
801065e0:	c7 04 24 80 21 12 80 	movl   $0x80122180,(%esp)
801065e7:	e8 14 ea ff ff       	call   80105000 <release>
801065ec:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801065ef:	e9 a4 fe ff ff       	jmp    80106498 <trap+0x148>
801065f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          cprintf("\nPGFAULT pid = %d\n", p->pid);
801065f8:	83 ec 08             	sub    $0x8,%esp
801065fb:	ff 72 10             	pushl  0x10(%edx)
801065fe:	68 ba 88 10 80       	push   $0x801088ba
80106603:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106606:	e8 a5 a0 ff ff       	call   801006b0 <cprintf>
          swap_page_back(p, &(p->swapped_out_pages[i]));
8010660b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010660e:	8d 04 76             	lea    (%esi,%esi,2),%eax
80106611:	59                   	pop    %ecx
80106612:	5f                   	pop    %edi
80106613:	8d 84 c2 80 00 00 00 	lea    0x80(%edx,%eax,8),%eax
8010661a:	50                   	push   %eax
8010661b:	52                   	push   %edx
8010661c:	e8 ef 19 00 00       	call   80108010 <swap_page_back>
          break;
80106621:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106624:	83 c4 10             	add    $0x10,%esp
80106627:	e9 7b ff ff ff       	jmp    801065a7 <trap+0x257>
8010662c:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010662f:	e8 bc da ff ff       	call   801040f0 <cpuid>
80106634:	83 ec 0c             	sub    $0xc,%esp
80106637:	56                   	push   %esi
80106638:	57                   	push   %edi
80106639:	50                   	push   %eax
8010663a:	ff 73 30             	pushl  0x30(%ebx)
8010663d:	68 f8 88 10 80       	push   $0x801088f8
80106642:	e8 69 a0 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106647:	83 c4 14             	add    $0x14,%esp
8010664a:	68 cd 88 10 80       	push   $0x801088cd
8010664f:	e8 3c 9d ff ff       	call   80100390 <panic>
80106654:	66 90                	xchg   %ax,%ax
80106656:	66 90                	xchg   %ax,%ax
80106658:	66 90                	xchg   %ax,%ax
8010665a:	66 90                	xchg   %ax,%ax
8010665c:	66 90                	xchg   %ax,%ax
8010665e:	66 90                	xchg   %ax,%ax

80106660 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106660:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106664:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106669:	85 c0                	test   %eax,%eax
8010666b:	74 1b                	je     80106688 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010666d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106672:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106673:	a8 01                	test   $0x1,%al
80106675:	74 11                	je     80106688 <uartgetc+0x28>
80106677:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010667c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010667d:	0f b6 c0             	movzbl %al,%eax
80106680:	c3                   	ret    
80106681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010668d:	c3                   	ret    
8010668e:	66 90                	xchg   %ax,%ax

80106690 <uartputc.part.0>:
uartputc(int c)
80106690:	55                   	push   %ebp
80106691:	89 e5                	mov    %esp,%ebp
80106693:	57                   	push   %edi
80106694:	89 c7                	mov    %eax,%edi
80106696:	56                   	push   %esi
80106697:	be fd 03 00 00       	mov    $0x3fd,%esi
8010669c:	53                   	push   %ebx
8010669d:	bb 80 00 00 00       	mov    $0x80,%ebx
801066a2:	83 ec 0c             	sub    $0xc,%esp
801066a5:	eb 1b                	jmp    801066c2 <uartputc.part.0+0x32>
801066a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ae:	66 90                	xchg   %ax,%ax
    microdelay(10);
801066b0:	83 ec 0c             	sub    $0xc,%esp
801066b3:	6a 0a                	push   $0xa
801066b5:	e8 66 c9 ff ff       	call   80103020 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801066ba:	83 c4 10             	add    $0x10,%esp
801066bd:	83 eb 01             	sub    $0x1,%ebx
801066c0:	74 07                	je     801066c9 <uartputc.part.0+0x39>
801066c2:	89 f2                	mov    %esi,%edx
801066c4:	ec                   	in     (%dx),%al
801066c5:	a8 20                	test   $0x20,%al
801066c7:	74 e7                	je     801066b0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801066c9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066ce:	89 f8                	mov    %edi,%eax
801066d0:	ee                   	out    %al,(%dx)
}
801066d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066d4:	5b                   	pop    %ebx
801066d5:	5e                   	pop    %esi
801066d6:	5f                   	pop    %edi
801066d7:	5d                   	pop    %ebp
801066d8:	c3                   	ret    
801066d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801066e0 <uartinit>:
{
801066e0:	f3 0f 1e fb          	endbr32 
801066e4:	55                   	push   %ebp
801066e5:	31 c9                	xor    %ecx,%ecx
801066e7:	89 c8                	mov    %ecx,%eax
801066e9:	89 e5                	mov    %esp,%ebp
801066eb:	57                   	push   %edi
801066ec:	56                   	push   %esi
801066ed:	53                   	push   %ebx
801066ee:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801066f3:	89 da                	mov    %ebx,%edx
801066f5:	83 ec 0c             	sub    $0xc,%esp
801066f8:	ee                   	out    %al,(%dx)
801066f9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801066fe:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106703:	89 fa                	mov    %edi,%edx
80106705:	ee                   	out    %al,(%dx)
80106706:	b8 0c 00 00 00       	mov    $0xc,%eax
8010670b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106710:	ee                   	out    %al,(%dx)
80106711:	be f9 03 00 00       	mov    $0x3f9,%esi
80106716:	89 c8                	mov    %ecx,%eax
80106718:	89 f2                	mov    %esi,%edx
8010671a:	ee                   	out    %al,(%dx)
8010671b:	b8 03 00 00 00       	mov    $0x3,%eax
80106720:	89 fa                	mov    %edi,%edx
80106722:	ee                   	out    %al,(%dx)
80106723:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106728:	89 c8                	mov    %ecx,%eax
8010672a:	ee                   	out    %al,(%dx)
8010672b:	b8 01 00 00 00       	mov    $0x1,%eax
80106730:	89 f2                	mov    %esi,%edx
80106732:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106733:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106738:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106739:	3c ff                	cmp    $0xff,%al
8010673b:	74 52                	je     8010678f <uartinit+0xaf>
  uart = 1;
8010673d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106744:	00 00 00 
80106747:	89 da                	mov    %ebx,%edx
80106749:	ec                   	in     (%dx),%al
8010674a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010674f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106750:	83 ec 08             	sub    $0x8,%esp
80106753:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106758:	bb 38 8a 10 80       	mov    $0x80108a38,%ebx
  ioapicenable(IRQ_COM1, 0);
8010675d:	6a 00                	push   $0x0
8010675f:	6a 04                	push   $0x4
80106761:	e8 0a c4 ff ff       	call   80102b70 <ioapicenable>
80106766:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106769:	b8 78 00 00 00       	mov    $0x78,%eax
8010676e:	eb 04                	jmp    80106774 <uartinit+0x94>
80106770:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106774:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010677a:	85 d2                	test   %edx,%edx
8010677c:	74 08                	je     80106786 <uartinit+0xa6>
    uartputc(*p);
8010677e:	0f be c0             	movsbl %al,%eax
80106781:	e8 0a ff ff ff       	call   80106690 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106786:	89 f0                	mov    %esi,%eax
80106788:	83 c3 01             	add    $0x1,%ebx
8010678b:	84 c0                	test   %al,%al
8010678d:	75 e1                	jne    80106770 <uartinit+0x90>
}
8010678f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106792:	5b                   	pop    %ebx
80106793:	5e                   	pop    %esi
80106794:	5f                   	pop    %edi
80106795:	5d                   	pop    %ebp
80106796:	c3                   	ret    
80106797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010679e:	66 90                	xchg   %ax,%ax

801067a0 <uartputc>:
{
801067a0:	f3 0f 1e fb          	endbr32 
801067a4:	55                   	push   %ebp
  if(!uart)
801067a5:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801067ab:	89 e5                	mov    %esp,%ebp
801067ad:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801067b0:	85 d2                	test   %edx,%edx
801067b2:	74 0c                	je     801067c0 <uartputc+0x20>
}
801067b4:	5d                   	pop    %ebp
801067b5:	e9 d6 fe ff ff       	jmp    80106690 <uartputc.part.0>
801067ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801067c0:	5d                   	pop    %ebp
801067c1:	c3                   	ret    
801067c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067d0 <uartintr>:

void
uartintr(void)
{
801067d0:	f3 0f 1e fb          	endbr32 
801067d4:	55                   	push   %ebp
801067d5:	89 e5                	mov    %esp,%ebp
801067d7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801067da:	68 60 66 10 80       	push   $0x80106660
801067df:	e8 7c a0 ff ff       	call   80100860 <consoleintr>
}
801067e4:	83 c4 10             	add    $0x10,%esp
801067e7:	c9                   	leave  
801067e8:	c3                   	ret    

801067e9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801067e9:	6a 00                	push   $0x0
  pushl $0
801067eb:	6a 00                	push   $0x0
  jmp alltraps
801067ed:	e9 7c fa ff ff       	jmp    8010626e <alltraps>

801067f2 <vector1>:
.globl vector1
vector1:
  pushl $0
801067f2:	6a 00                	push   $0x0
  pushl $1
801067f4:	6a 01                	push   $0x1
  jmp alltraps
801067f6:	e9 73 fa ff ff       	jmp    8010626e <alltraps>

801067fb <vector2>:
.globl vector2
vector2:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $2
801067fd:	6a 02                	push   $0x2
  jmp alltraps
801067ff:	e9 6a fa ff ff       	jmp    8010626e <alltraps>

80106804 <vector3>:
.globl vector3
vector3:
  pushl $0
80106804:	6a 00                	push   $0x0
  pushl $3
80106806:	6a 03                	push   $0x3
  jmp alltraps
80106808:	e9 61 fa ff ff       	jmp    8010626e <alltraps>

8010680d <vector4>:
.globl vector4
vector4:
  pushl $0
8010680d:	6a 00                	push   $0x0
  pushl $4
8010680f:	6a 04                	push   $0x4
  jmp alltraps
80106811:	e9 58 fa ff ff       	jmp    8010626e <alltraps>

80106816 <vector5>:
.globl vector5
vector5:
  pushl $0
80106816:	6a 00                	push   $0x0
  pushl $5
80106818:	6a 05                	push   $0x5
  jmp alltraps
8010681a:	e9 4f fa ff ff       	jmp    8010626e <alltraps>

8010681f <vector6>:
.globl vector6
vector6:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $6
80106821:	6a 06                	push   $0x6
  jmp alltraps
80106823:	e9 46 fa ff ff       	jmp    8010626e <alltraps>

80106828 <vector7>:
.globl vector7
vector7:
  pushl $0
80106828:	6a 00                	push   $0x0
  pushl $7
8010682a:	6a 07                	push   $0x7
  jmp alltraps
8010682c:	e9 3d fa ff ff       	jmp    8010626e <alltraps>

80106831 <vector8>:
.globl vector8
vector8:
  pushl $8
80106831:	6a 08                	push   $0x8
  jmp alltraps
80106833:	e9 36 fa ff ff       	jmp    8010626e <alltraps>

80106838 <vector9>:
.globl vector9
vector9:
  pushl $0
80106838:	6a 00                	push   $0x0
  pushl $9
8010683a:	6a 09                	push   $0x9
  jmp alltraps
8010683c:	e9 2d fa ff ff       	jmp    8010626e <alltraps>

80106841 <vector10>:
.globl vector10
vector10:
  pushl $10
80106841:	6a 0a                	push   $0xa
  jmp alltraps
80106843:	e9 26 fa ff ff       	jmp    8010626e <alltraps>

80106848 <vector11>:
.globl vector11
vector11:
  pushl $11
80106848:	6a 0b                	push   $0xb
  jmp alltraps
8010684a:	e9 1f fa ff ff       	jmp    8010626e <alltraps>

8010684f <vector12>:
.globl vector12
vector12:
  pushl $12
8010684f:	6a 0c                	push   $0xc
  jmp alltraps
80106851:	e9 18 fa ff ff       	jmp    8010626e <alltraps>

80106856 <vector13>:
.globl vector13
vector13:
  pushl $13
80106856:	6a 0d                	push   $0xd
  jmp alltraps
80106858:	e9 11 fa ff ff       	jmp    8010626e <alltraps>

8010685d <vector14>:
.globl vector14
vector14:
  pushl $14
8010685d:	6a 0e                	push   $0xe
  jmp alltraps
8010685f:	e9 0a fa ff ff       	jmp    8010626e <alltraps>

80106864 <vector15>:
.globl vector15
vector15:
  pushl $0
80106864:	6a 00                	push   $0x0
  pushl $15
80106866:	6a 0f                	push   $0xf
  jmp alltraps
80106868:	e9 01 fa ff ff       	jmp    8010626e <alltraps>

8010686d <vector16>:
.globl vector16
vector16:
  pushl $0
8010686d:	6a 00                	push   $0x0
  pushl $16
8010686f:	6a 10                	push   $0x10
  jmp alltraps
80106871:	e9 f8 f9 ff ff       	jmp    8010626e <alltraps>

80106876 <vector17>:
.globl vector17
vector17:
  pushl $17
80106876:	6a 11                	push   $0x11
  jmp alltraps
80106878:	e9 f1 f9 ff ff       	jmp    8010626e <alltraps>

8010687d <vector18>:
.globl vector18
vector18:
  pushl $0
8010687d:	6a 00                	push   $0x0
  pushl $18
8010687f:	6a 12                	push   $0x12
  jmp alltraps
80106881:	e9 e8 f9 ff ff       	jmp    8010626e <alltraps>

80106886 <vector19>:
.globl vector19
vector19:
  pushl $0
80106886:	6a 00                	push   $0x0
  pushl $19
80106888:	6a 13                	push   $0x13
  jmp alltraps
8010688a:	e9 df f9 ff ff       	jmp    8010626e <alltraps>

8010688f <vector20>:
.globl vector20
vector20:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $20
80106891:	6a 14                	push   $0x14
  jmp alltraps
80106893:	e9 d6 f9 ff ff       	jmp    8010626e <alltraps>

80106898 <vector21>:
.globl vector21
vector21:
  pushl $0
80106898:	6a 00                	push   $0x0
  pushl $21
8010689a:	6a 15                	push   $0x15
  jmp alltraps
8010689c:	e9 cd f9 ff ff       	jmp    8010626e <alltraps>

801068a1 <vector22>:
.globl vector22
vector22:
  pushl $0
801068a1:	6a 00                	push   $0x0
  pushl $22
801068a3:	6a 16                	push   $0x16
  jmp alltraps
801068a5:	e9 c4 f9 ff ff       	jmp    8010626e <alltraps>

801068aa <vector23>:
.globl vector23
vector23:
  pushl $0
801068aa:	6a 00                	push   $0x0
  pushl $23
801068ac:	6a 17                	push   $0x17
  jmp alltraps
801068ae:	e9 bb f9 ff ff       	jmp    8010626e <alltraps>

801068b3 <vector24>:
.globl vector24
vector24:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $24
801068b5:	6a 18                	push   $0x18
  jmp alltraps
801068b7:	e9 b2 f9 ff ff       	jmp    8010626e <alltraps>

801068bc <vector25>:
.globl vector25
vector25:
  pushl $0
801068bc:	6a 00                	push   $0x0
  pushl $25
801068be:	6a 19                	push   $0x19
  jmp alltraps
801068c0:	e9 a9 f9 ff ff       	jmp    8010626e <alltraps>

801068c5 <vector26>:
.globl vector26
vector26:
  pushl $0
801068c5:	6a 00                	push   $0x0
  pushl $26
801068c7:	6a 1a                	push   $0x1a
  jmp alltraps
801068c9:	e9 a0 f9 ff ff       	jmp    8010626e <alltraps>

801068ce <vector27>:
.globl vector27
vector27:
  pushl $0
801068ce:	6a 00                	push   $0x0
  pushl $27
801068d0:	6a 1b                	push   $0x1b
  jmp alltraps
801068d2:	e9 97 f9 ff ff       	jmp    8010626e <alltraps>

801068d7 <vector28>:
.globl vector28
vector28:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $28
801068d9:	6a 1c                	push   $0x1c
  jmp alltraps
801068db:	e9 8e f9 ff ff       	jmp    8010626e <alltraps>

801068e0 <vector29>:
.globl vector29
vector29:
  pushl $0
801068e0:	6a 00                	push   $0x0
  pushl $29
801068e2:	6a 1d                	push   $0x1d
  jmp alltraps
801068e4:	e9 85 f9 ff ff       	jmp    8010626e <alltraps>

801068e9 <vector30>:
.globl vector30
vector30:
  pushl $0
801068e9:	6a 00                	push   $0x0
  pushl $30
801068eb:	6a 1e                	push   $0x1e
  jmp alltraps
801068ed:	e9 7c f9 ff ff       	jmp    8010626e <alltraps>

801068f2 <vector31>:
.globl vector31
vector31:
  pushl $0
801068f2:	6a 00                	push   $0x0
  pushl $31
801068f4:	6a 1f                	push   $0x1f
  jmp alltraps
801068f6:	e9 73 f9 ff ff       	jmp    8010626e <alltraps>

801068fb <vector32>:
.globl vector32
vector32:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $32
801068fd:	6a 20                	push   $0x20
  jmp alltraps
801068ff:	e9 6a f9 ff ff       	jmp    8010626e <alltraps>

80106904 <vector33>:
.globl vector33
vector33:
  pushl $0
80106904:	6a 00                	push   $0x0
  pushl $33
80106906:	6a 21                	push   $0x21
  jmp alltraps
80106908:	e9 61 f9 ff ff       	jmp    8010626e <alltraps>

8010690d <vector34>:
.globl vector34
vector34:
  pushl $0
8010690d:	6a 00                	push   $0x0
  pushl $34
8010690f:	6a 22                	push   $0x22
  jmp alltraps
80106911:	e9 58 f9 ff ff       	jmp    8010626e <alltraps>

80106916 <vector35>:
.globl vector35
vector35:
  pushl $0
80106916:	6a 00                	push   $0x0
  pushl $35
80106918:	6a 23                	push   $0x23
  jmp alltraps
8010691a:	e9 4f f9 ff ff       	jmp    8010626e <alltraps>

8010691f <vector36>:
.globl vector36
vector36:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $36
80106921:	6a 24                	push   $0x24
  jmp alltraps
80106923:	e9 46 f9 ff ff       	jmp    8010626e <alltraps>

80106928 <vector37>:
.globl vector37
vector37:
  pushl $0
80106928:	6a 00                	push   $0x0
  pushl $37
8010692a:	6a 25                	push   $0x25
  jmp alltraps
8010692c:	e9 3d f9 ff ff       	jmp    8010626e <alltraps>

80106931 <vector38>:
.globl vector38
vector38:
  pushl $0
80106931:	6a 00                	push   $0x0
  pushl $38
80106933:	6a 26                	push   $0x26
  jmp alltraps
80106935:	e9 34 f9 ff ff       	jmp    8010626e <alltraps>

8010693a <vector39>:
.globl vector39
vector39:
  pushl $0
8010693a:	6a 00                	push   $0x0
  pushl $39
8010693c:	6a 27                	push   $0x27
  jmp alltraps
8010693e:	e9 2b f9 ff ff       	jmp    8010626e <alltraps>

80106943 <vector40>:
.globl vector40
vector40:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $40
80106945:	6a 28                	push   $0x28
  jmp alltraps
80106947:	e9 22 f9 ff ff       	jmp    8010626e <alltraps>

8010694c <vector41>:
.globl vector41
vector41:
  pushl $0
8010694c:	6a 00                	push   $0x0
  pushl $41
8010694e:	6a 29                	push   $0x29
  jmp alltraps
80106950:	e9 19 f9 ff ff       	jmp    8010626e <alltraps>

80106955 <vector42>:
.globl vector42
vector42:
  pushl $0
80106955:	6a 00                	push   $0x0
  pushl $42
80106957:	6a 2a                	push   $0x2a
  jmp alltraps
80106959:	e9 10 f9 ff ff       	jmp    8010626e <alltraps>

8010695e <vector43>:
.globl vector43
vector43:
  pushl $0
8010695e:	6a 00                	push   $0x0
  pushl $43
80106960:	6a 2b                	push   $0x2b
  jmp alltraps
80106962:	e9 07 f9 ff ff       	jmp    8010626e <alltraps>

80106967 <vector44>:
.globl vector44
vector44:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $44
80106969:	6a 2c                	push   $0x2c
  jmp alltraps
8010696b:	e9 fe f8 ff ff       	jmp    8010626e <alltraps>

80106970 <vector45>:
.globl vector45
vector45:
  pushl $0
80106970:	6a 00                	push   $0x0
  pushl $45
80106972:	6a 2d                	push   $0x2d
  jmp alltraps
80106974:	e9 f5 f8 ff ff       	jmp    8010626e <alltraps>

80106979 <vector46>:
.globl vector46
vector46:
  pushl $0
80106979:	6a 00                	push   $0x0
  pushl $46
8010697b:	6a 2e                	push   $0x2e
  jmp alltraps
8010697d:	e9 ec f8 ff ff       	jmp    8010626e <alltraps>

80106982 <vector47>:
.globl vector47
vector47:
  pushl $0
80106982:	6a 00                	push   $0x0
  pushl $47
80106984:	6a 2f                	push   $0x2f
  jmp alltraps
80106986:	e9 e3 f8 ff ff       	jmp    8010626e <alltraps>

8010698b <vector48>:
.globl vector48
vector48:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $48
8010698d:	6a 30                	push   $0x30
  jmp alltraps
8010698f:	e9 da f8 ff ff       	jmp    8010626e <alltraps>

80106994 <vector49>:
.globl vector49
vector49:
  pushl $0
80106994:	6a 00                	push   $0x0
  pushl $49
80106996:	6a 31                	push   $0x31
  jmp alltraps
80106998:	e9 d1 f8 ff ff       	jmp    8010626e <alltraps>

8010699d <vector50>:
.globl vector50
vector50:
  pushl $0
8010699d:	6a 00                	push   $0x0
  pushl $50
8010699f:	6a 32                	push   $0x32
  jmp alltraps
801069a1:	e9 c8 f8 ff ff       	jmp    8010626e <alltraps>

801069a6 <vector51>:
.globl vector51
vector51:
  pushl $0
801069a6:	6a 00                	push   $0x0
  pushl $51
801069a8:	6a 33                	push   $0x33
  jmp alltraps
801069aa:	e9 bf f8 ff ff       	jmp    8010626e <alltraps>

801069af <vector52>:
.globl vector52
vector52:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $52
801069b1:	6a 34                	push   $0x34
  jmp alltraps
801069b3:	e9 b6 f8 ff ff       	jmp    8010626e <alltraps>

801069b8 <vector53>:
.globl vector53
vector53:
  pushl $0
801069b8:	6a 00                	push   $0x0
  pushl $53
801069ba:	6a 35                	push   $0x35
  jmp alltraps
801069bc:	e9 ad f8 ff ff       	jmp    8010626e <alltraps>

801069c1 <vector54>:
.globl vector54
vector54:
  pushl $0
801069c1:	6a 00                	push   $0x0
  pushl $54
801069c3:	6a 36                	push   $0x36
  jmp alltraps
801069c5:	e9 a4 f8 ff ff       	jmp    8010626e <alltraps>

801069ca <vector55>:
.globl vector55
vector55:
  pushl $0
801069ca:	6a 00                	push   $0x0
  pushl $55
801069cc:	6a 37                	push   $0x37
  jmp alltraps
801069ce:	e9 9b f8 ff ff       	jmp    8010626e <alltraps>

801069d3 <vector56>:
.globl vector56
vector56:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $56
801069d5:	6a 38                	push   $0x38
  jmp alltraps
801069d7:	e9 92 f8 ff ff       	jmp    8010626e <alltraps>

801069dc <vector57>:
.globl vector57
vector57:
  pushl $0
801069dc:	6a 00                	push   $0x0
  pushl $57
801069de:	6a 39                	push   $0x39
  jmp alltraps
801069e0:	e9 89 f8 ff ff       	jmp    8010626e <alltraps>

801069e5 <vector58>:
.globl vector58
vector58:
  pushl $0
801069e5:	6a 00                	push   $0x0
  pushl $58
801069e7:	6a 3a                	push   $0x3a
  jmp alltraps
801069e9:	e9 80 f8 ff ff       	jmp    8010626e <alltraps>

801069ee <vector59>:
.globl vector59
vector59:
  pushl $0
801069ee:	6a 00                	push   $0x0
  pushl $59
801069f0:	6a 3b                	push   $0x3b
  jmp alltraps
801069f2:	e9 77 f8 ff ff       	jmp    8010626e <alltraps>

801069f7 <vector60>:
.globl vector60
vector60:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $60
801069f9:	6a 3c                	push   $0x3c
  jmp alltraps
801069fb:	e9 6e f8 ff ff       	jmp    8010626e <alltraps>

80106a00 <vector61>:
.globl vector61
vector61:
  pushl $0
80106a00:	6a 00                	push   $0x0
  pushl $61
80106a02:	6a 3d                	push   $0x3d
  jmp alltraps
80106a04:	e9 65 f8 ff ff       	jmp    8010626e <alltraps>

80106a09 <vector62>:
.globl vector62
vector62:
  pushl $0
80106a09:	6a 00                	push   $0x0
  pushl $62
80106a0b:	6a 3e                	push   $0x3e
  jmp alltraps
80106a0d:	e9 5c f8 ff ff       	jmp    8010626e <alltraps>

80106a12 <vector63>:
.globl vector63
vector63:
  pushl $0
80106a12:	6a 00                	push   $0x0
  pushl $63
80106a14:	6a 3f                	push   $0x3f
  jmp alltraps
80106a16:	e9 53 f8 ff ff       	jmp    8010626e <alltraps>

80106a1b <vector64>:
.globl vector64
vector64:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $64
80106a1d:	6a 40                	push   $0x40
  jmp alltraps
80106a1f:	e9 4a f8 ff ff       	jmp    8010626e <alltraps>

80106a24 <vector65>:
.globl vector65
vector65:
  pushl $0
80106a24:	6a 00                	push   $0x0
  pushl $65
80106a26:	6a 41                	push   $0x41
  jmp alltraps
80106a28:	e9 41 f8 ff ff       	jmp    8010626e <alltraps>

80106a2d <vector66>:
.globl vector66
vector66:
  pushl $0
80106a2d:	6a 00                	push   $0x0
  pushl $66
80106a2f:	6a 42                	push   $0x42
  jmp alltraps
80106a31:	e9 38 f8 ff ff       	jmp    8010626e <alltraps>

80106a36 <vector67>:
.globl vector67
vector67:
  pushl $0
80106a36:	6a 00                	push   $0x0
  pushl $67
80106a38:	6a 43                	push   $0x43
  jmp alltraps
80106a3a:	e9 2f f8 ff ff       	jmp    8010626e <alltraps>

80106a3f <vector68>:
.globl vector68
vector68:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $68
80106a41:	6a 44                	push   $0x44
  jmp alltraps
80106a43:	e9 26 f8 ff ff       	jmp    8010626e <alltraps>

80106a48 <vector69>:
.globl vector69
vector69:
  pushl $0
80106a48:	6a 00                	push   $0x0
  pushl $69
80106a4a:	6a 45                	push   $0x45
  jmp alltraps
80106a4c:	e9 1d f8 ff ff       	jmp    8010626e <alltraps>

80106a51 <vector70>:
.globl vector70
vector70:
  pushl $0
80106a51:	6a 00                	push   $0x0
  pushl $70
80106a53:	6a 46                	push   $0x46
  jmp alltraps
80106a55:	e9 14 f8 ff ff       	jmp    8010626e <alltraps>

80106a5a <vector71>:
.globl vector71
vector71:
  pushl $0
80106a5a:	6a 00                	push   $0x0
  pushl $71
80106a5c:	6a 47                	push   $0x47
  jmp alltraps
80106a5e:	e9 0b f8 ff ff       	jmp    8010626e <alltraps>

80106a63 <vector72>:
.globl vector72
vector72:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $72
80106a65:	6a 48                	push   $0x48
  jmp alltraps
80106a67:	e9 02 f8 ff ff       	jmp    8010626e <alltraps>

80106a6c <vector73>:
.globl vector73
vector73:
  pushl $0
80106a6c:	6a 00                	push   $0x0
  pushl $73
80106a6e:	6a 49                	push   $0x49
  jmp alltraps
80106a70:	e9 f9 f7 ff ff       	jmp    8010626e <alltraps>

80106a75 <vector74>:
.globl vector74
vector74:
  pushl $0
80106a75:	6a 00                	push   $0x0
  pushl $74
80106a77:	6a 4a                	push   $0x4a
  jmp alltraps
80106a79:	e9 f0 f7 ff ff       	jmp    8010626e <alltraps>

80106a7e <vector75>:
.globl vector75
vector75:
  pushl $0
80106a7e:	6a 00                	push   $0x0
  pushl $75
80106a80:	6a 4b                	push   $0x4b
  jmp alltraps
80106a82:	e9 e7 f7 ff ff       	jmp    8010626e <alltraps>

80106a87 <vector76>:
.globl vector76
vector76:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $76
80106a89:	6a 4c                	push   $0x4c
  jmp alltraps
80106a8b:	e9 de f7 ff ff       	jmp    8010626e <alltraps>

80106a90 <vector77>:
.globl vector77
vector77:
  pushl $0
80106a90:	6a 00                	push   $0x0
  pushl $77
80106a92:	6a 4d                	push   $0x4d
  jmp alltraps
80106a94:	e9 d5 f7 ff ff       	jmp    8010626e <alltraps>

80106a99 <vector78>:
.globl vector78
vector78:
  pushl $0
80106a99:	6a 00                	push   $0x0
  pushl $78
80106a9b:	6a 4e                	push   $0x4e
  jmp alltraps
80106a9d:	e9 cc f7 ff ff       	jmp    8010626e <alltraps>

80106aa2 <vector79>:
.globl vector79
vector79:
  pushl $0
80106aa2:	6a 00                	push   $0x0
  pushl $79
80106aa4:	6a 4f                	push   $0x4f
  jmp alltraps
80106aa6:	e9 c3 f7 ff ff       	jmp    8010626e <alltraps>

80106aab <vector80>:
.globl vector80
vector80:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $80
80106aad:	6a 50                	push   $0x50
  jmp alltraps
80106aaf:	e9 ba f7 ff ff       	jmp    8010626e <alltraps>

80106ab4 <vector81>:
.globl vector81
vector81:
  pushl $0
80106ab4:	6a 00                	push   $0x0
  pushl $81
80106ab6:	6a 51                	push   $0x51
  jmp alltraps
80106ab8:	e9 b1 f7 ff ff       	jmp    8010626e <alltraps>

80106abd <vector82>:
.globl vector82
vector82:
  pushl $0
80106abd:	6a 00                	push   $0x0
  pushl $82
80106abf:	6a 52                	push   $0x52
  jmp alltraps
80106ac1:	e9 a8 f7 ff ff       	jmp    8010626e <alltraps>

80106ac6 <vector83>:
.globl vector83
vector83:
  pushl $0
80106ac6:	6a 00                	push   $0x0
  pushl $83
80106ac8:	6a 53                	push   $0x53
  jmp alltraps
80106aca:	e9 9f f7 ff ff       	jmp    8010626e <alltraps>

80106acf <vector84>:
.globl vector84
vector84:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $84
80106ad1:	6a 54                	push   $0x54
  jmp alltraps
80106ad3:	e9 96 f7 ff ff       	jmp    8010626e <alltraps>

80106ad8 <vector85>:
.globl vector85
vector85:
  pushl $0
80106ad8:	6a 00                	push   $0x0
  pushl $85
80106ada:	6a 55                	push   $0x55
  jmp alltraps
80106adc:	e9 8d f7 ff ff       	jmp    8010626e <alltraps>

80106ae1 <vector86>:
.globl vector86
vector86:
  pushl $0
80106ae1:	6a 00                	push   $0x0
  pushl $86
80106ae3:	6a 56                	push   $0x56
  jmp alltraps
80106ae5:	e9 84 f7 ff ff       	jmp    8010626e <alltraps>

80106aea <vector87>:
.globl vector87
vector87:
  pushl $0
80106aea:	6a 00                	push   $0x0
  pushl $87
80106aec:	6a 57                	push   $0x57
  jmp alltraps
80106aee:	e9 7b f7 ff ff       	jmp    8010626e <alltraps>

80106af3 <vector88>:
.globl vector88
vector88:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $88
80106af5:	6a 58                	push   $0x58
  jmp alltraps
80106af7:	e9 72 f7 ff ff       	jmp    8010626e <alltraps>

80106afc <vector89>:
.globl vector89
vector89:
  pushl $0
80106afc:	6a 00                	push   $0x0
  pushl $89
80106afe:	6a 59                	push   $0x59
  jmp alltraps
80106b00:	e9 69 f7 ff ff       	jmp    8010626e <alltraps>

80106b05 <vector90>:
.globl vector90
vector90:
  pushl $0
80106b05:	6a 00                	push   $0x0
  pushl $90
80106b07:	6a 5a                	push   $0x5a
  jmp alltraps
80106b09:	e9 60 f7 ff ff       	jmp    8010626e <alltraps>

80106b0e <vector91>:
.globl vector91
vector91:
  pushl $0
80106b0e:	6a 00                	push   $0x0
  pushl $91
80106b10:	6a 5b                	push   $0x5b
  jmp alltraps
80106b12:	e9 57 f7 ff ff       	jmp    8010626e <alltraps>

80106b17 <vector92>:
.globl vector92
vector92:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $92
80106b19:	6a 5c                	push   $0x5c
  jmp alltraps
80106b1b:	e9 4e f7 ff ff       	jmp    8010626e <alltraps>

80106b20 <vector93>:
.globl vector93
vector93:
  pushl $0
80106b20:	6a 00                	push   $0x0
  pushl $93
80106b22:	6a 5d                	push   $0x5d
  jmp alltraps
80106b24:	e9 45 f7 ff ff       	jmp    8010626e <alltraps>

80106b29 <vector94>:
.globl vector94
vector94:
  pushl $0
80106b29:	6a 00                	push   $0x0
  pushl $94
80106b2b:	6a 5e                	push   $0x5e
  jmp alltraps
80106b2d:	e9 3c f7 ff ff       	jmp    8010626e <alltraps>

80106b32 <vector95>:
.globl vector95
vector95:
  pushl $0
80106b32:	6a 00                	push   $0x0
  pushl $95
80106b34:	6a 5f                	push   $0x5f
  jmp alltraps
80106b36:	e9 33 f7 ff ff       	jmp    8010626e <alltraps>

80106b3b <vector96>:
.globl vector96
vector96:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $96
80106b3d:	6a 60                	push   $0x60
  jmp alltraps
80106b3f:	e9 2a f7 ff ff       	jmp    8010626e <alltraps>

80106b44 <vector97>:
.globl vector97
vector97:
  pushl $0
80106b44:	6a 00                	push   $0x0
  pushl $97
80106b46:	6a 61                	push   $0x61
  jmp alltraps
80106b48:	e9 21 f7 ff ff       	jmp    8010626e <alltraps>

80106b4d <vector98>:
.globl vector98
vector98:
  pushl $0
80106b4d:	6a 00                	push   $0x0
  pushl $98
80106b4f:	6a 62                	push   $0x62
  jmp alltraps
80106b51:	e9 18 f7 ff ff       	jmp    8010626e <alltraps>

80106b56 <vector99>:
.globl vector99
vector99:
  pushl $0
80106b56:	6a 00                	push   $0x0
  pushl $99
80106b58:	6a 63                	push   $0x63
  jmp alltraps
80106b5a:	e9 0f f7 ff ff       	jmp    8010626e <alltraps>

80106b5f <vector100>:
.globl vector100
vector100:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $100
80106b61:	6a 64                	push   $0x64
  jmp alltraps
80106b63:	e9 06 f7 ff ff       	jmp    8010626e <alltraps>

80106b68 <vector101>:
.globl vector101
vector101:
  pushl $0
80106b68:	6a 00                	push   $0x0
  pushl $101
80106b6a:	6a 65                	push   $0x65
  jmp alltraps
80106b6c:	e9 fd f6 ff ff       	jmp    8010626e <alltraps>

80106b71 <vector102>:
.globl vector102
vector102:
  pushl $0
80106b71:	6a 00                	push   $0x0
  pushl $102
80106b73:	6a 66                	push   $0x66
  jmp alltraps
80106b75:	e9 f4 f6 ff ff       	jmp    8010626e <alltraps>

80106b7a <vector103>:
.globl vector103
vector103:
  pushl $0
80106b7a:	6a 00                	push   $0x0
  pushl $103
80106b7c:	6a 67                	push   $0x67
  jmp alltraps
80106b7e:	e9 eb f6 ff ff       	jmp    8010626e <alltraps>

80106b83 <vector104>:
.globl vector104
vector104:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $104
80106b85:	6a 68                	push   $0x68
  jmp alltraps
80106b87:	e9 e2 f6 ff ff       	jmp    8010626e <alltraps>

80106b8c <vector105>:
.globl vector105
vector105:
  pushl $0
80106b8c:	6a 00                	push   $0x0
  pushl $105
80106b8e:	6a 69                	push   $0x69
  jmp alltraps
80106b90:	e9 d9 f6 ff ff       	jmp    8010626e <alltraps>

80106b95 <vector106>:
.globl vector106
vector106:
  pushl $0
80106b95:	6a 00                	push   $0x0
  pushl $106
80106b97:	6a 6a                	push   $0x6a
  jmp alltraps
80106b99:	e9 d0 f6 ff ff       	jmp    8010626e <alltraps>

80106b9e <vector107>:
.globl vector107
vector107:
  pushl $0
80106b9e:	6a 00                	push   $0x0
  pushl $107
80106ba0:	6a 6b                	push   $0x6b
  jmp alltraps
80106ba2:	e9 c7 f6 ff ff       	jmp    8010626e <alltraps>

80106ba7 <vector108>:
.globl vector108
vector108:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $108
80106ba9:	6a 6c                	push   $0x6c
  jmp alltraps
80106bab:	e9 be f6 ff ff       	jmp    8010626e <alltraps>

80106bb0 <vector109>:
.globl vector109
vector109:
  pushl $0
80106bb0:	6a 00                	push   $0x0
  pushl $109
80106bb2:	6a 6d                	push   $0x6d
  jmp alltraps
80106bb4:	e9 b5 f6 ff ff       	jmp    8010626e <alltraps>

80106bb9 <vector110>:
.globl vector110
vector110:
  pushl $0
80106bb9:	6a 00                	push   $0x0
  pushl $110
80106bbb:	6a 6e                	push   $0x6e
  jmp alltraps
80106bbd:	e9 ac f6 ff ff       	jmp    8010626e <alltraps>

80106bc2 <vector111>:
.globl vector111
vector111:
  pushl $0
80106bc2:	6a 00                	push   $0x0
  pushl $111
80106bc4:	6a 6f                	push   $0x6f
  jmp alltraps
80106bc6:	e9 a3 f6 ff ff       	jmp    8010626e <alltraps>

80106bcb <vector112>:
.globl vector112
vector112:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $112
80106bcd:	6a 70                	push   $0x70
  jmp alltraps
80106bcf:	e9 9a f6 ff ff       	jmp    8010626e <alltraps>

80106bd4 <vector113>:
.globl vector113
vector113:
  pushl $0
80106bd4:	6a 00                	push   $0x0
  pushl $113
80106bd6:	6a 71                	push   $0x71
  jmp alltraps
80106bd8:	e9 91 f6 ff ff       	jmp    8010626e <alltraps>

80106bdd <vector114>:
.globl vector114
vector114:
  pushl $0
80106bdd:	6a 00                	push   $0x0
  pushl $114
80106bdf:	6a 72                	push   $0x72
  jmp alltraps
80106be1:	e9 88 f6 ff ff       	jmp    8010626e <alltraps>

80106be6 <vector115>:
.globl vector115
vector115:
  pushl $0
80106be6:	6a 00                	push   $0x0
  pushl $115
80106be8:	6a 73                	push   $0x73
  jmp alltraps
80106bea:	e9 7f f6 ff ff       	jmp    8010626e <alltraps>

80106bef <vector116>:
.globl vector116
vector116:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $116
80106bf1:	6a 74                	push   $0x74
  jmp alltraps
80106bf3:	e9 76 f6 ff ff       	jmp    8010626e <alltraps>

80106bf8 <vector117>:
.globl vector117
vector117:
  pushl $0
80106bf8:	6a 00                	push   $0x0
  pushl $117
80106bfa:	6a 75                	push   $0x75
  jmp alltraps
80106bfc:	e9 6d f6 ff ff       	jmp    8010626e <alltraps>

80106c01 <vector118>:
.globl vector118
vector118:
  pushl $0
80106c01:	6a 00                	push   $0x0
  pushl $118
80106c03:	6a 76                	push   $0x76
  jmp alltraps
80106c05:	e9 64 f6 ff ff       	jmp    8010626e <alltraps>

80106c0a <vector119>:
.globl vector119
vector119:
  pushl $0
80106c0a:	6a 00                	push   $0x0
  pushl $119
80106c0c:	6a 77                	push   $0x77
  jmp alltraps
80106c0e:	e9 5b f6 ff ff       	jmp    8010626e <alltraps>

80106c13 <vector120>:
.globl vector120
vector120:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $120
80106c15:	6a 78                	push   $0x78
  jmp alltraps
80106c17:	e9 52 f6 ff ff       	jmp    8010626e <alltraps>

80106c1c <vector121>:
.globl vector121
vector121:
  pushl $0
80106c1c:	6a 00                	push   $0x0
  pushl $121
80106c1e:	6a 79                	push   $0x79
  jmp alltraps
80106c20:	e9 49 f6 ff ff       	jmp    8010626e <alltraps>

80106c25 <vector122>:
.globl vector122
vector122:
  pushl $0
80106c25:	6a 00                	push   $0x0
  pushl $122
80106c27:	6a 7a                	push   $0x7a
  jmp alltraps
80106c29:	e9 40 f6 ff ff       	jmp    8010626e <alltraps>

80106c2e <vector123>:
.globl vector123
vector123:
  pushl $0
80106c2e:	6a 00                	push   $0x0
  pushl $123
80106c30:	6a 7b                	push   $0x7b
  jmp alltraps
80106c32:	e9 37 f6 ff ff       	jmp    8010626e <alltraps>

80106c37 <vector124>:
.globl vector124
vector124:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $124
80106c39:	6a 7c                	push   $0x7c
  jmp alltraps
80106c3b:	e9 2e f6 ff ff       	jmp    8010626e <alltraps>

80106c40 <vector125>:
.globl vector125
vector125:
  pushl $0
80106c40:	6a 00                	push   $0x0
  pushl $125
80106c42:	6a 7d                	push   $0x7d
  jmp alltraps
80106c44:	e9 25 f6 ff ff       	jmp    8010626e <alltraps>

80106c49 <vector126>:
.globl vector126
vector126:
  pushl $0
80106c49:	6a 00                	push   $0x0
  pushl $126
80106c4b:	6a 7e                	push   $0x7e
  jmp alltraps
80106c4d:	e9 1c f6 ff ff       	jmp    8010626e <alltraps>

80106c52 <vector127>:
.globl vector127
vector127:
  pushl $0
80106c52:	6a 00                	push   $0x0
  pushl $127
80106c54:	6a 7f                	push   $0x7f
  jmp alltraps
80106c56:	e9 13 f6 ff ff       	jmp    8010626e <alltraps>

80106c5b <vector128>:
.globl vector128
vector128:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $128
80106c5d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106c62:	e9 07 f6 ff ff       	jmp    8010626e <alltraps>

80106c67 <vector129>:
.globl vector129
vector129:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $129
80106c69:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106c6e:	e9 fb f5 ff ff       	jmp    8010626e <alltraps>

80106c73 <vector130>:
.globl vector130
vector130:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $130
80106c75:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106c7a:	e9 ef f5 ff ff       	jmp    8010626e <alltraps>

80106c7f <vector131>:
.globl vector131
vector131:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $131
80106c81:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106c86:	e9 e3 f5 ff ff       	jmp    8010626e <alltraps>

80106c8b <vector132>:
.globl vector132
vector132:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $132
80106c8d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106c92:	e9 d7 f5 ff ff       	jmp    8010626e <alltraps>

80106c97 <vector133>:
.globl vector133
vector133:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $133
80106c99:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106c9e:	e9 cb f5 ff ff       	jmp    8010626e <alltraps>

80106ca3 <vector134>:
.globl vector134
vector134:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $134
80106ca5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106caa:	e9 bf f5 ff ff       	jmp    8010626e <alltraps>

80106caf <vector135>:
.globl vector135
vector135:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $135
80106cb1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106cb6:	e9 b3 f5 ff ff       	jmp    8010626e <alltraps>

80106cbb <vector136>:
.globl vector136
vector136:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $136
80106cbd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106cc2:	e9 a7 f5 ff ff       	jmp    8010626e <alltraps>

80106cc7 <vector137>:
.globl vector137
vector137:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $137
80106cc9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106cce:	e9 9b f5 ff ff       	jmp    8010626e <alltraps>

80106cd3 <vector138>:
.globl vector138
vector138:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $138
80106cd5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106cda:	e9 8f f5 ff ff       	jmp    8010626e <alltraps>

80106cdf <vector139>:
.globl vector139
vector139:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $139
80106ce1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ce6:	e9 83 f5 ff ff       	jmp    8010626e <alltraps>

80106ceb <vector140>:
.globl vector140
vector140:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $140
80106ced:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106cf2:	e9 77 f5 ff ff       	jmp    8010626e <alltraps>

80106cf7 <vector141>:
.globl vector141
vector141:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $141
80106cf9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106cfe:	e9 6b f5 ff ff       	jmp    8010626e <alltraps>

80106d03 <vector142>:
.globl vector142
vector142:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $142
80106d05:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106d0a:	e9 5f f5 ff ff       	jmp    8010626e <alltraps>

80106d0f <vector143>:
.globl vector143
vector143:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $143
80106d11:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106d16:	e9 53 f5 ff ff       	jmp    8010626e <alltraps>

80106d1b <vector144>:
.globl vector144
vector144:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $144
80106d1d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106d22:	e9 47 f5 ff ff       	jmp    8010626e <alltraps>

80106d27 <vector145>:
.globl vector145
vector145:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $145
80106d29:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106d2e:	e9 3b f5 ff ff       	jmp    8010626e <alltraps>

80106d33 <vector146>:
.globl vector146
vector146:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $146
80106d35:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106d3a:	e9 2f f5 ff ff       	jmp    8010626e <alltraps>

80106d3f <vector147>:
.globl vector147
vector147:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $147
80106d41:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106d46:	e9 23 f5 ff ff       	jmp    8010626e <alltraps>

80106d4b <vector148>:
.globl vector148
vector148:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $148
80106d4d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106d52:	e9 17 f5 ff ff       	jmp    8010626e <alltraps>

80106d57 <vector149>:
.globl vector149
vector149:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $149
80106d59:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106d5e:	e9 0b f5 ff ff       	jmp    8010626e <alltraps>

80106d63 <vector150>:
.globl vector150
vector150:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $150
80106d65:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106d6a:	e9 ff f4 ff ff       	jmp    8010626e <alltraps>

80106d6f <vector151>:
.globl vector151
vector151:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $151
80106d71:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106d76:	e9 f3 f4 ff ff       	jmp    8010626e <alltraps>

80106d7b <vector152>:
.globl vector152
vector152:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $152
80106d7d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d82:	e9 e7 f4 ff ff       	jmp    8010626e <alltraps>

80106d87 <vector153>:
.globl vector153
vector153:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $153
80106d89:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106d8e:	e9 db f4 ff ff       	jmp    8010626e <alltraps>

80106d93 <vector154>:
.globl vector154
vector154:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $154
80106d95:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106d9a:	e9 cf f4 ff ff       	jmp    8010626e <alltraps>

80106d9f <vector155>:
.globl vector155
vector155:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $155
80106da1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106da6:	e9 c3 f4 ff ff       	jmp    8010626e <alltraps>

80106dab <vector156>:
.globl vector156
vector156:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $156
80106dad:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106db2:	e9 b7 f4 ff ff       	jmp    8010626e <alltraps>

80106db7 <vector157>:
.globl vector157
vector157:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $157
80106db9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106dbe:	e9 ab f4 ff ff       	jmp    8010626e <alltraps>

80106dc3 <vector158>:
.globl vector158
vector158:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $158
80106dc5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106dca:	e9 9f f4 ff ff       	jmp    8010626e <alltraps>

80106dcf <vector159>:
.globl vector159
vector159:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $159
80106dd1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106dd6:	e9 93 f4 ff ff       	jmp    8010626e <alltraps>

80106ddb <vector160>:
.globl vector160
vector160:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $160
80106ddd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106de2:	e9 87 f4 ff ff       	jmp    8010626e <alltraps>

80106de7 <vector161>:
.globl vector161
vector161:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $161
80106de9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106dee:	e9 7b f4 ff ff       	jmp    8010626e <alltraps>

80106df3 <vector162>:
.globl vector162
vector162:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $162
80106df5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106dfa:	e9 6f f4 ff ff       	jmp    8010626e <alltraps>

80106dff <vector163>:
.globl vector163
vector163:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $163
80106e01:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106e06:	e9 63 f4 ff ff       	jmp    8010626e <alltraps>

80106e0b <vector164>:
.globl vector164
vector164:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $164
80106e0d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106e12:	e9 57 f4 ff ff       	jmp    8010626e <alltraps>

80106e17 <vector165>:
.globl vector165
vector165:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $165
80106e19:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106e1e:	e9 4b f4 ff ff       	jmp    8010626e <alltraps>

80106e23 <vector166>:
.globl vector166
vector166:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $166
80106e25:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106e2a:	e9 3f f4 ff ff       	jmp    8010626e <alltraps>

80106e2f <vector167>:
.globl vector167
vector167:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $167
80106e31:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106e36:	e9 33 f4 ff ff       	jmp    8010626e <alltraps>

80106e3b <vector168>:
.globl vector168
vector168:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $168
80106e3d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106e42:	e9 27 f4 ff ff       	jmp    8010626e <alltraps>

80106e47 <vector169>:
.globl vector169
vector169:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $169
80106e49:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106e4e:	e9 1b f4 ff ff       	jmp    8010626e <alltraps>

80106e53 <vector170>:
.globl vector170
vector170:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $170
80106e55:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106e5a:	e9 0f f4 ff ff       	jmp    8010626e <alltraps>

80106e5f <vector171>:
.globl vector171
vector171:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $171
80106e61:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106e66:	e9 03 f4 ff ff       	jmp    8010626e <alltraps>

80106e6b <vector172>:
.globl vector172
vector172:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $172
80106e6d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106e72:	e9 f7 f3 ff ff       	jmp    8010626e <alltraps>

80106e77 <vector173>:
.globl vector173
vector173:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $173
80106e79:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106e7e:	e9 eb f3 ff ff       	jmp    8010626e <alltraps>

80106e83 <vector174>:
.globl vector174
vector174:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $174
80106e85:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106e8a:	e9 df f3 ff ff       	jmp    8010626e <alltraps>

80106e8f <vector175>:
.globl vector175
vector175:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $175
80106e91:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106e96:	e9 d3 f3 ff ff       	jmp    8010626e <alltraps>

80106e9b <vector176>:
.globl vector176
vector176:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $176
80106e9d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ea2:	e9 c7 f3 ff ff       	jmp    8010626e <alltraps>

80106ea7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $177
80106ea9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106eae:	e9 bb f3 ff ff       	jmp    8010626e <alltraps>

80106eb3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $178
80106eb5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106eba:	e9 af f3 ff ff       	jmp    8010626e <alltraps>

80106ebf <vector179>:
.globl vector179
vector179:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $179
80106ec1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ec6:	e9 a3 f3 ff ff       	jmp    8010626e <alltraps>

80106ecb <vector180>:
.globl vector180
vector180:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $180
80106ecd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106ed2:	e9 97 f3 ff ff       	jmp    8010626e <alltraps>

80106ed7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $181
80106ed9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106ede:	e9 8b f3 ff ff       	jmp    8010626e <alltraps>

80106ee3 <vector182>:
.globl vector182
vector182:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $182
80106ee5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106eea:	e9 7f f3 ff ff       	jmp    8010626e <alltraps>

80106eef <vector183>:
.globl vector183
vector183:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $183
80106ef1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ef6:	e9 73 f3 ff ff       	jmp    8010626e <alltraps>

80106efb <vector184>:
.globl vector184
vector184:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $184
80106efd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106f02:	e9 67 f3 ff ff       	jmp    8010626e <alltraps>

80106f07 <vector185>:
.globl vector185
vector185:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $185
80106f09:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106f0e:	e9 5b f3 ff ff       	jmp    8010626e <alltraps>

80106f13 <vector186>:
.globl vector186
vector186:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $186
80106f15:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106f1a:	e9 4f f3 ff ff       	jmp    8010626e <alltraps>

80106f1f <vector187>:
.globl vector187
vector187:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $187
80106f21:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106f26:	e9 43 f3 ff ff       	jmp    8010626e <alltraps>

80106f2b <vector188>:
.globl vector188
vector188:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $188
80106f2d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106f32:	e9 37 f3 ff ff       	jmp    8010626e <alltraps>

80106f37 <vector189>:
.globl vector189
vector189:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $189
80106f39:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106f3e:	e9 2b f3 ff ff       	jmp    8010626e <alltraps>

80106f43 <vector190>:
.globl vector190
vector190:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $190
80106f45:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106f4a:	e9 1f f3 ff ff       	jmp    8010626e <alltraps>

80106f4f <vector191>:
.globl vector191
vector191:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $191
80106f51:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106f56:	e9 13 f3 ff ff       	jmp    8010626e <alltraps>

80106f5b <vector192>:
.globl vector192
vector192:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $192
80106f5d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106f62:	e9 07 f3 ff ff       	jmp    8010626e <alltraps>

80106f67 <vector193>:
.globl vector193
vector193:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $193
80106f69:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106f6e:	e9 fb f2 ff ff       	jmp    8010626e <alltraps>

80106f73 <vector194>:
.globl vector194
vector194:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $194
80106f75:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106f7a:	e9 ef f2 ff ff       	jmp    8010626e <alltraps>

80106f7f <vector195>:
.globl vector195
vector195:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $195
80106f81:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106f86:	e9 e3 f2 ff ff       	jmp    8010626e <alltraps>

80106f8b <vector196>:
.globl vector196
vector196:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $196
80106f8d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106f92:	e9 d7 f2 ff ff       	jmp    8010626e <alltraps>

80106f97 <vector197>:
.globl vector197
vector197:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $197
80106f99:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106f9e:	e9 cb f2 ff ff       	jmp    8010626e <alltraps>

80106fa3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $198
80106fa5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106faa:	e9 bf f2 ff ff       	jmp    8010626e <alltraps>

80106faf <vector199>:
.globl vector199
vector199:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $199
80106fb1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106fb6:	e9 b3 f2 ff ff       	jmp    8010626e <alltraps>

80106fbb <vector200>:
.globl vector200
vector200:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $200
80106fbd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106fc2:	e9 a7 f2 ff ff       	jmp    8010626e <alltraps>

80106fc7 <vector201>:
.globl vector201
vector201:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $201
80106fc9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106fce:	e9 9b f2 ff ff       	jmp    8010626e <alltraps>

80106fd3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $202
80106fd5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106fda:	e9 8f f2 ff ff       	jmp    8010626e <alltraps>

80106fdf <vector203>:
.globl vector203
vector203:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $203
80106fe1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106fe6:	e9 83 f2 ff ff       	jmp    8010626e <alltraps>

80106feb <vector204>:
.globl vector204
vector204:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $204
80106fed:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106ff2:	e9 77 f2 ff ff       	jmp    8010626e <alltraps>

80106ff7 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $205
80106ff9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106ffe:	e9 6b f2 ff ff       	jmp    8010626e <alltraps>

80107003 <vector206>:
.globl vector206
vector206:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $206
80107005:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010700a:	e9 5f f2 ff ff       	jmp    8010626e <alltraps>

8010700f <vector207>:
.globl vector207
vector207:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $207
80107011:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107016:	e9 53 f2 ff ff       	jmp    8010626e <alltraps>

8010701b <vector208>:
.globl vector208
vector208:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $208
8010701d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107022:	e9 47 f2 ff ff       	jmp    8010626e <alltraps>

80107027 <vector209>:
.globl vector209
vector209:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $209
80107029:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010702e:	e9 3b f2 ff ff       	jmp    8010626e <alltraps>

80107033 <vector210>:
.globl vector210
vector210:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $210
80107035:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010703a:	e9 2f f2 ff ff       	jmp    8010626e <alltraps>

8010703f <vector211>:
.globl vector211
vector211:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $211
80107041:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107046:	e9 23 f2 ff ff       	jmp    8010626e <alltraps>

8010704b <vector212>:
.globl vector212
vector212:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $212
8010704d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107052:	e9 17 f2 ff ff       	jmp    8010626e <alltraps>

80107057 <vector213>:
.globl vector213
vector213:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $213
80107059:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010705e:	e9 0b f2 ff ff       	jmp    8010626e <alltraps>

80107063 <vector214>:
.globl vector214
vector214:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $214
80107065:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010706a:	e9 ff f1 ff ff       	jmp    8010626e <alltraps>

8010706f <vector215>:
.globl vector215
vector215:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $215
80107071:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107076:	e9 f3 f1 ff ff       	jmp    8010626e <alltraps>

8010707b <vector216>:
.globl vector216
vector216:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $216
8010707d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107082:	e9 e7 f1 ff ff       	jmp    8010626e <alltraps>

80107087 <vector217>:
.globl vector217
vector217:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $217
80107089:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010708e:	e9 db f1 ff ff       	jmp    8010626e <alltraps>

80107093 <vector218>:
.globl vector218
vector218:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $218
80107095:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010709a:	e9 cf f1 ff ff       	jmp    8010626e <alltraps>

8010709f <vector219>:
.globl vector219
vector219:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $219
801070a1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801070a6:	e9 c3 f1 ff ff       	jmp    8010626e <alltraps>

801070ab <vector220>:
.globl vector220
vector220:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $220
801070ad:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801070b2:	e9 b7 f1 ff ff       	jmp    8010626e <alltraps>

801070b7 <vector221>:
.globl vector221
vector221:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $221
801070b9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801070be:	e9 ab f1 ff ff       	jmp    8010626e <alltraps>

801070c3 <vector222>:
.globl vector222
vector222:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $222
801070c5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801070ca:	e9 9f f1 ff ff       	jmp    8010626e <alltraps>

801070cf <vector223>:
.globl vector223
vector223:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $223
801070d1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801070d6:	e9 93 f1 ff ff       	jmp    8010626e <alltraps>

801070db <vector224>:
.globl vector224
vector224:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $224
801070dd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801070e2:	e9 87 f1 ff ff       	jmp    8010626e <alltraps>

801070e7 <vector225>:
.globl vector225
vector225:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $225
801070e9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801070ee:	e9 7b f1 ff ff       	jmp    8010626e <alltraps>

801070f3 <vector226>:
.globl vector226
vector226:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $226
801070f5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801070fa:	e9 6f f1 ff ff       	jmp    8010626e <alltraps>

801070ff <vector227>:
.globl vector227
vector227:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $227
80107101:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107106:	e9 63 f1 ff ff       	jmp    8010626e <alltraps>

8010710b <vector228>:
.globl vector228
vector228:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $228
8010710d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107112:	e9 57 f1 ff ff       	jmp    8010626e <alltraps>

80107117 <vector229>:
.globl vector229
vector229:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $229
80107119:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010711e:	e9 4b f1 ff ff       	jmp    8010626e <alltraps>

80107123 <vector230>:
.globl vector230
vector230:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $230
80107125:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010712a:	e9 3f f1 ff ff       	jmp    8010626e <alltraps>

8010712f <vector231>:
.globl vector231
vector231:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $231
80107131:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107136:	e9 33 f1 ff ff       	jmp    8010626e <alltraps>

8010713b <vector232>:
.globl vector232
vector232:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $232
8010713d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107142:	e9 27 f1 ff ff       	jmp    8010626e <alltraps>

80107147 <vector233>:
.globl vector233
vector233:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $233
80107149:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010714e:	e9 1b f1 ff ff       	jmp    8010626e <alltraps>

80107153 <vector234>:
.globl vector234
vector234:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $234
80107155:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010715a:	e9 0f f1 ff ff       	jmp    8010626e <alltraps>

8010715f <vector235>:
.globl vector235
vector235:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $235
80107161:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107166:	e9 03 f1 ff ff       	jmp    8010626e <alltraps>

8010716b <vector236>:
.globl vector236
vector236:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $236
8010716d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107172:	e9 f7 f0 ff ff       	jmp    8010626e <alltraps>

80107177 <vector237>:
.globl vector237
vector237:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $237
80107179:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010717e:	e9 eb f0 ff ff       	jmp    8010626e <alltraps>

80107183 <vector238>:
.globl vector238
vector238:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $238
80107185:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010718a:	e9 df f0 ff ff       	jmp    8010626e <alltraps>

8010718f <vector239>:
.globl vector239
vector239:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $239
80107191:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107196:	e9 d3 f0 ff ff       	jmp    8010626e <alltraps>

8010719b <vector240>:
.globl vector240
vector240:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $240
8010719d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801071a2:	e9 c7 f0 ff ff       	jmp    8010626e <alltraps>

801071a7 <vector241>:
.globl vector241
vector241:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $241
801071a9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801071ae:	e9 bb f0 ff ff       	jmp    8010626e <alltraps>

801071b3 <vector242>:
.globl vector242
vector242:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $242
801071b5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801071ba:	e9 af f0 ff ff       	jmp    8010626e <alltraps>

801071bf <vector243>:
.globl vector243
vector243:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $243
801071c1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801071c6:	e9 a3 f0 ff ff       	jmp    8010626e <alltraps>

801071cb <vector244>:
.globl vector244
vector244:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $244
801071cd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801071d2:	e9 97 f0 ff ff       	jmp    8010626e <alltraps>

801071d7 <vector245>:
.globl vector245
vector245:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $245
801071d9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801071de:	e9 8b f0 ff ff       	jmp    8010626e <alltraps>

801071e3 <vector246>:
.globl vector246
vector246:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $246
801071e5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801071ea:	e9 7f f0 ff ff       	jmp    8010626e <alltraps>

801071ef <vector247>:
.globl vector247
vector247:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $247
801071f1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801071f6:	e9 73 f0 ff ff       	jmp    8010626e <alltraps>

801071fb <vector248>:
.globl vector248
vector248:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $248
801071fd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107202:	e9 67 f0 ff ff       	jmp    8010626e <alltraps>

80107207 <vector249>:
.globl vector249
vector249:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $249
80107209:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010720e:	e9 5b f0 ff ff       	jmp    8010626e <alltraps>

80107213 <vector250>:
.globl vector250
vector250:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $250
80107215:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010721a:	e9 4f f0 ff ff       	jmp    8010626e <alltraps>

8010721f <vector251>:
.globl vector251
vector251:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $251
80107221:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107226:	e9 43 f0 ff ff       	jmp    8010626e <alltraps>

8010722b <vector252>:
.globl vector252
vector252:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $252
8010722d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107232:	e9 37 f0 ff ff       	jmp    8010626e <alltraps>

80107237 <vector253>:
.globl vector253
vector253:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $253
80107239:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010723e:	e9 2b f0 ff ff       	jmp    8010626e <alltraps>

80107243 <vector254>:
.globl vector254
vector254:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $254
80107245:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010724a:	e9 1f f0 ff ff       	jmp    8010626e <alltraps>

8010724f <vector255>:
.globl vector255
vector255:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $255
80107251:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107256:	e9 13 f0 ff ff       	jmp    8010626e <alltraps>
8010725b:	66 90                	xchg   %ax,%ax
8010725d:	66 90                	xchg   %ax,%ax
8010725f:	90                   	nop

80107260 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	57                   	push   %edi
80107264:	56                   	push   %esi
80107265:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107267:	c1 ea 16             	shr    $0x16,%edx
{
8010726a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010726b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010726e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107271:	8b 1f                	mov    (%edi),%ebx
80107273:	f6 c3 01             	test   $0x1,%bl
80107276:	74 28                	je     801072a0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107278:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010727e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107284:	89 f0                	mov    %esi,%eax
}
80107286:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107289:	c1 e8 0a             	shr    $0xa,%eax
8010728c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107291:	01 d8                	add    %ebx,%eax
}
80107293:	5b                   	pop    %ebx
80107294:	5e                   	pop    %esi
80107295:	5f                   	pop    %edi
80107296:	5d                   	pop    %ebp
80107297:	c3                   	ret    
80107298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801072a0:	85 c9                	test   %ecx,%ecx
801072a2:	74 2c                	je     801072d0 <walkpgdir+0x70>
801072a4:	e8 c7 ba ff ff       	call   80102d70 <kalloc>
801072a9:	89 c3                	mov    %eax,%ebx
801072ab:	85 c0                	test   %eax,%eax
801072ad:	74 21                	je     801072d0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801072af:	83 ec 04             	sub    $0x4,%esp
801072b2:	68 00 10 00 00       	push   $0x1000
801072b7:	6a 00                	push   $0x0
801072b9:	50                   	push   %eax
801072ba:	e8 91 dd ff ff       	call   80105050 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801072bf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072c5:	83 c4 10             	add    $0x10,%esp
801072c8:	83 c8 07             	or     $0x7,%eax
801072cb:	89 07                	mov    %eax,(%edi)
801072cd:	eb b5                	jmp    80107284 <walkpgdir+0x24>
801072cf:	90                   	nop
}
801072d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801072d3:	31 c0                	xor    %eax,%eax
}
801072d5:	5b                   	pop    %ebx
801072d6:	5e                   	pop    %esi
801072d7:	5f                   	pop    %edi
801072d8:	5d                   	pop    %ebp
801072d9:	c3                   	ret    
801072da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072e0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	57                   	push   %edi
801072e4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072e6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801072ea:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801072f0:	89 d6                	mov    %edx,%esi
{
801072f2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801072f3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801072f9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072ff:	8b 45 08             	mov    0x8(%ebp),%eax
80107302:	29 f0                	sub    %esi,%eax
80107304:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107307:	eb 1f                	jmp    80107328 <mappages+0x48>
80107309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107310:	f6 00 01             	testb  $0x1,(%eax)
80107313:	75 45                	jne    8010735a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107315:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107318:	83 cb 01             	or     $0x1,%ebx
8010731b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010731d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107320:	74 2e                	je     80107350 <mappages+0x70>
      break;
    a += PGSIZE;
80107322:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107328:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010732b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107330:	89 f2                	mov    %esi,%edx
80107332:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107335:	89 f8                	mov    %edi,%eax
80107337:	e8 24 ff ff ff       	call   80107260 <walkpgdir>
8010733c:	85 c0                	test   %eax,%eax
8010733e:	75 d0                	jne    80107310 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107340:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107343:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107348:	5b                   	pop    %ebx
80107349:	5e                   	pop    %esi
8010734a:	5f                   	pop    %edi
8010734b:	5d                   	pop    %ebp
8010734c:	c3                   	ret    
8010734d:	8d 76 00             	lea    0x0(%esi),%esi
80107350:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107353:	31 c0                	xor    %eax,%eax
}
80107355:	5b                   	pop    %ebx
80107356:	5e                   	pop    %esi
80107357:	5f                   	pop    %edi
80107358:	5d                   	pop    %ebp
80107359:	c3                   	ret    
      panic("remap");
8010735a:	83 ec 0c             	sub    $0xc,%esp
8010735d:	68 40 8a 10 80       	push   $0x80108a40
80107362:	e8 29 90 ff ff       	call   80100390 <panic>
80107367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010736e:	66 90                	xchg   %ax,%ax

80107370 <find_page_to_swap>:
struct pageinfo* find_page_to_swap(struct proc* p){
80107370:	f3 0f 1e fb          	endbr32 
80107374:	55                   	push   %ebp
80107375:	89 e5                	mov    %esp,%ebp
80107377:	57                   	push   %edi
80107378:	56                   	push   %esi
80107379:	53                   	push   %ebx
8010737a:	83 ec 1c             	sub    $0x1c,%esp
8010737d:	8b 75 08             	mov    0x8(%ebp),%esi
80107380:	8d 86 00 02 00 00    	lea    0x200(%esi),%eax
80107386:	8d 9e 80 03 00 00    	lea    0x380(%esi),%ebx
8010738c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010738f:	90                   	nop
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107390:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    struct pageinfo* min_pi = 0;
80107393:	31 ff                	xor    %edi,%edi
    uint min = 0xFFFFFFFF;
80107395:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
8010739a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (!pi->is_free && pi->page_index < min){
801073a0:	8b 10                	mov    (%eax),%edx
801073a2:	85 d2                	test   %edx,%edx
801073a4:	75 0b                	jne    801073b1 <find_page_to_swap+0x41>
801073a6:	8b 50 0c             	mov    0xc(%eax),%edx
801073a9:	39 ca                	cmp    %ecx,%edx
801073ab:	73 04                	jae    801073b1 <find_page_to_swap+0x41>
801073ad:	89 c7                	mov    %eax,%edi
801073af:	89 d1                	mov    %edx,%ecx
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
801073b1:	83 c0 18             	add    $0x18,%eax
801073b4:	39 c3                	cmp    %eax,%ebx
801073b6:	75 e8                	jne    801073a0 <find_page_to_swap+0x30>
    pte_t* pte = walkpgdir(p->pgdir, min_pi, 0);\
801073b8:	8b 46 04             	mov    0x4(%esi),%eax
801073bb:	31 c9                	xor    %ecx,%ecx
801073bd:	89 fa                	mov    %edi,%edx
801073bf:	e8 9c fe ff ff       	call   80107260 <walkpgdir>
    if (*pte & PTE_A){
801073c4:	f6 00 20             	testb  $0x20,(%eax)
801073c7:	74 17                	je     801073e0 <find_page_to_swap+0x70>
      min_pi->page_index = (++page_counter);
801073c9:	8b 0d c0 b5 10 80    	mov    0x8010b5c0,%ecx
801073cf:	8d 51 01             	lea    0x1(%ecx),%edx
801073d2:	89 15 c0 b5 10 80    	mov    %edx,0x8010b5c0
801073d8:	89 57 0c             	mov    %edx,0xc(%edi)
      *pte &= ~PTE_A;
801073db:	83 20 df             	andl   $0xffffffdf,(%eax)
  while(1){
801073de:	eb b0                	jmp    80107390 <find_page_to_swap+0x20>
}
801073e0:	83 c4 1c             	add    $0x1c,%esp
801073e3:	89 f8                	mov    %edi,%eax
801073e5:	5b                   	pop    %ebx
801073e6:	5e                   	pop    %esi
801073e7:	5f                   	pop    %edi
801073e8:	5d                   	pop    %ebp
801073e9:	c3                   	ret    
801073ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073f0 <seginit>:
{
801073f0:	f3 0f 1e fb          	endbr32 
801073f4:	55                   	push   %ebp
801073f5:	89 e5                	mov    %esp,%ebp
801073f7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801073fa:	e8 f1 cc ff ff       	call   801040f0 <cpuid>
  pd[0] = size-1;
801073ff:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107404:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010740a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010740e:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80107415:	ff 00 00 
80107418:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
8010741f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107422:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80107429:	ff 00 00 
8010742c:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
80107433:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107436:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
8010743d:	ff 00 00 
80107440:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80107447:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010744a:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
80107451:	ff 00 00 
80107454:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
8010745b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010745e:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
80107463:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107467:	c1 e8 10             	shr    $0x10,%eax
8010746a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010746e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107471:	0f 01 10             	lgdtl  (%eax)
}
80107474:	c9                   	leave  
80107475:	c3                   	ret    
80107476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010747d:	8d 76 00             	lea    0x0(%esi),%esi

80107480 <public_walkpgdir>:
public_walkpgdir(pde_t *pgdir, const void *va, int alloc){
80107480:	f3 0f 1e fb          	endbr32 
80107484:	55                   	push   %ebp
80107485:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, va, alloc);
80107487:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010748a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010748d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80107490:	5d                   	pop    %ebp
  return walkpgdir(pgdir, va, alloc);
80107491:	e9 ca fd ff ff       	jmp    80107260 <walkpgdir>
80107496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010749d:	8d 76 00             	lea    0x0(%esi),%esi

801074a0 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801074a0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801074a4:	a1 c4 29 12 80       	mov    0x801229c4,%eax
801074a9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801074ae:	0f 22 d8             	mov    %eax,%cr3
}
801074b1:	c3                   	ret    
801074b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074c0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801074c0:	f3 0f 1e fb          	endbr32 
801074c4:	55                   	push   %ebp
801074c5:	89 e5                	mov    %esp,%ebp
801074c7:	57                   	push   %edi
801074c8:	56                   	push   %esi
801074c9:	53                   	push   %ebx
801074ca:	83 ec 1c             	sub    $0x1c,%esp
801074cd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801074d0:	85 f6                	test   %esi,%esi
801074d2:	0f 84 cb 00 00 00    	je     801075a3 <switchuvm+0xe3>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801074d8:	8b 46 08             	mov    0x8(%esi),%eax
801074db:	85 c0                	test   %eax,%eax
801074dd:	0f 84 da 00 00 00    	je     801075bd <switchuvm+0xfd>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801074e3:	8b 46 04             	mov    0x4(%esi),%eax
801074e6:	85 c0                	test   %eax,%eax
801074e8:	0f 84 c2 00 00 00    	je     801075b0 <switchuvm+0xf0>
    panic("switchuvm: no pgdir");

  pushcli();
801074ee:	e8 4d d9 ff ff       	call   80104e40 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801074f3:	e8 88 cb ff ff       	call   80104080 <mycpu>
801074f8:	89 c3                	mov    %eax,%ebx
801074fa:	e8 81 cb ff ff       	call   80104080 <mycpu>
801074ff:	89 c7                	mov    %eax,%edi
80107501:	e8 7a cb ff ff       	call   80104080 <mycpu>
80107506:	83 c7 08             	add    $0x8,%edi
80107509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010750c:	e8 6f cb ff ff       	call   80104080 <mycpu>
80107511:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107514:	ba 67 00 00 00       	mov    $0x67,%edx
80107519:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107520:	83 c0 08             	add    $0x8,%eax
80107523:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010752a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010752f:	83 c1 08             	add    $0x8,%ecx
80107532:	c1 e8 18             	shr    $0x18,%eax
80107535:	c1 e9 10             	shr    $0x10,%ecx
80107538:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010753e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107544:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107549:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107550:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107555:	e8 26 cb ff ff       	call   80104080 <mycpu>
8010755a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107561:	e8 1a cb ff ff       	call   80104080 <mycpu>
80107566:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010756a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010756d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107573:	e8 08 cb ff ff       	call   80104080 <mycpu>
80107578:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010757b:	e8 00 cb ff ff       	call   80104080 <mycpu>
80107580:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107584:	b8 28 00 00 00       	mov    $0x28,%eax
80107589:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010758c:	8b 46 04             	mov    0x4(%esi),%eax
8010758f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107594:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107597:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010759a:	5b                   	pop    %ebx
8010759b:	5e                   	pop    %esi
8010759c:	5f                   	pop    %edi
8010759d:	5d                   	pop    %ebp
  popcli();
8010759e:	e9 ed d8 ff ff       	jmp    80104e90 <popcli>
    panic("switchuvm: no process");
801075a3:	83 ec 0c             	sub    $0xc,%esp
801075a6:	68 46 8a 10 80       	push   $0x80108a46
801075ab:	e8 e0 8d ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801075b0:	83 ec 0c             	sub    $0xc,%esp
801075b3:	68 71 8a 10 80       	push   $0x80108a71
801075b8:	e8 d3 8d ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801075bd:	83 ec 0c             	sub    $0xc,%esp
801075c0:	68 5c 8a 10 80       	push   $0x80108a5c
801075c5:	e8 c6 8d ff ff       	call   80100390 <panic>
801075ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075d0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801075d0:	f3 0f 1e fb          	endbr32 
801075d4:	55                   	push   %ebp
801075d5:	89 e5                	mov    %esp,%ebp
801075d7:	57                   	push   %edi
801075d8:	56                   	push   %esi
801075d9:	53                   	push   %ebx
801075da:	83 ec 1c             	sub    $0x1c,%esp
801075dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801075e0:	8b 75 10             	mov    0x10(%ebp),%esi
801075e3:	8b 7d 08             	mov    0x8(%ebp),%edi
801075e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801075e9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801075ef:	77 4b                	ja     8010763c <inituvm+0x6c>
    panic("inituvm: more than a page");
  mem = kalloc();
801075f1:	e8 7a b7 ff ff       	call   80102d70 <kalloc>
  memset(mem, 0, PGSIZE);
801075f6:	83 ec 04             	sub    $0x4,%esp
801075f9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801075fe:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107600:	6a 00                	push   $0x0
80107602:	50                   	push   %eax
80107603:	e8 48 da ff ff       	call   80105050 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107608:	58                   	pop    %eax
80107609:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010760f:	5a                   	pop    %edx
80107610:	6a 06                	push   $0x6
80107612:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107617:	31 d2                	xor    %edx,%edx
80107619:	50                   	push   %eax
8010761a:	89 f8                	mov    %edi,%eax
8010761c:	e8 bf fc ff ff       	call   801072e0 <mappages>
  memmove(mem, init, sz);
80107621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107624:	89 75 10             	mov    %esi,0x10(%ebp)
80107627:	83 c4 10             	add    $0x10,%esp
8010762a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010762d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107630:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107633:	5b                   	pop    %ebx
80107634:	5e                   	pop    %esi
80107635:	5f                   	pop    %edi
80107636:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107637:	e9 b4 da ff ff       	jmp    801050f0 <memmove>
    panic("inituvm: more than a page");
8010763c:	83 ec 0c             	sub    $0xc,%esp
8010763f:	68 85 8a 10 80       	push   $0x80108a85
80107644:	e8 47 8d ff ff       	call   80100390 <panic>
80107649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107650 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107650:	f3 0f 1e fb          	endbr32 
80107654:	55                   	push   %ebp
80107655:	89 e5                	mov    %esp,%ebp
80107657:	57                   	push   %edi
80107658:	56                   	push   %esi
80107659:	53                   	push   %ebx
8010765a:	83 ec 1c             	sub    $0x1c,%esp
8010765d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107660:	8b 75 18             	mov    0x18(%ebp),%esi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107663:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107668:	0f 85 99 00 00 00    	jne    80107707 <loaduvm+0xb7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010766e:	01 f0                	add    %esi,%eax
80107670:	89 f3                	mov    %esi,%ebx
80107672:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107675:	8b 45 14             	mov    0x14(%ebp),%eax
80107678:	01 f0                	add    %esi,%eax
8010767a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010767d:	85 f6                	test   %esi,%esi
8010767f:	75 15                	jne    80107696 <loaduvm+0x46>
80107681:	eb 6d                	jmp    801076f0 <loaduvm+0xa0>
80107683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107687:	90                   	nop
80107688:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010768e:	89 f0                	mov    %esi,%eax
80107690:	29 d8                	sub    %ebx,%eax
80107692:	39 c6                	cmp    %eax,%esi
80107694:	76 5a                	jbe    801076f0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107696:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107699:	8b 45 08             	mov    0x8(%ebp),%eax
8010769c:	31 c9                	xor    %ecx,%ecx
8010769e:	29 da                	sub    %ebx,%edx
801076a0:	e8 bb fb ff ff       	call   80107260 <walkpgdir>
801076a5:	85 c0                	test   %eax,%eax
801076a7:	74 51                	je     801076fa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801076a9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801076ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801076ae:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801076b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801076b8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801076be:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801076c1:	29 d9                	sub    %ebx,%ecx
801076c3:	05 00 00 00 80       	add    $0x80000000,%eax
801076c8:	57                   	push   %edi
801076c9:	51                   	push   %ecx
801076ca:	50                   	push   %eax
801076cb:	ff 75 10             	pushl  0x10(%ebp)
801076ce:	e8 4d a7 ff ff       	call   80101e20 <readi>
801076d3:	83 c4 10             	add    $0x10,%esp
801076d6:	39 f8                	cmp    %edi,%eax
801076d8:	74 ae                	je     80107688 <loaduvm+0x38>
      return -1;
  }
  return 0;
}
801076da:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076e2:	5b                   	pop    %ebx
801076e3:	5e                   	pop    %esi
801076e4:	5f                   	pop    %edi
801076e5:	5d                   	pop    %ebp
801076e6:	c3                   	ret    
801076e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ee:	66 90                	xchg   %ax,%ax
801076f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076f3:	31 c0                	xor    %eax,%eax
}
801076f5:	5b                   	pop    %ebx
801076f6:	5e                   	pop    %esi
801076f7:	5f                   	pop    %edi
801076f8:	5d                   	pop    %ebp
801076f9:	c3                   	ret    
      panic("loaduvm: address should exist");
801076fa:	83 ec 0c             	sub    $0xc,%esp
801076fd:	68 9f 8a 10 80       	push   $0x80108a9f
80107702:	e8 89 8c ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107707:	83 ec 0c             	sub    $0xc,%esp
8010770a:	68 7c 8b 10 80       	push   $0x80108b7c
8010770f:	e8 7c 8c ff ff       	call   80100390 <panic>
80107714:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010771b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010771f:	90                   	nop

80107720 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107720:	f3 0f 1e fb          	endbr32 
80107724:	55                   	push   %ebp
80107725:	89 e5                	mov    %esp,%ebp
80107727:	57                   	push   %edi
80107728:	56                   	push   %esi
80107729:	53                   	push   %ebx
8010772a:	83 ec 1c             	sub    $0x1c,%esp
8010772d:	8b 7d 08             	mov    0x8(%ebp),%edi
  pte_t *pte;
  uint a, pa;
  struct proc* p = myproc();
80107730:	e8 db c9 ff ff       	call   80104110 <myproc>
80107735:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  if(newsz >= oldsz)
80107738:	8b 45 0c             	mov    0xc(%ebp),%eax
8010773b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010773e:	0f 83 84 00 00 00    	jae    801077c8 <deallocuvm+0xa8>
    return oldsz;

  a = PGROUNDUP(newsz);
80107744:	8b 45 10             	mov    0x10(%ebp),%eax
80107747:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010774d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107753:	89 d6                	mov    %edx,%esi
  for(; a  < oldsz; a += PGSIZE){
80107755:	39 55 0c             	cmp    %edx,0xc(%ebp)
80107758:	77 47                	ja     801077a1 <deallocuvm+0x81>
8010775a:	eb 69                	jmp    801077c5 <deallocuvm+0xa5>
8010775c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107760:	8b 00                	mov    (%eax),%eax
80107762:	a8 01                	test   $0x1,%al
80107764:	74 30                	je     80107796 <deallocuvm+0x76>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107766:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010776b:	0f 84 b1 00 00 00    	je     80107822 <deallocuvm+0x102>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107771:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107774:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107779:	50                   	push   %eax
8010777a:	e8 31 b4 ff ff       	call   80102bb0 <kfree>
      if (p->pid > 2 && pgdir == p->pgdir){
8010777f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107782:	83 c4 10             	add    $0x10,%esp
80107785:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107789:	7e 05                	jle    80107790 <deallocuvm+0x70>
8010778b:	39 78 04             	cmp    %edi,0x4(%eax)
8010778e:	74 40                	je     801077d0 <deallocuvm+0xb0>
            p->ram_pages[i].va = 0;
            break;
          }
        }
      }
      *pte = 0;
80107790:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107796:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(; a  < oldsz; a += PGSIZE){
8010779c:	3b 75 0c             	cmp    0xc(%ebp),%esi
8010779f:	73 24                	jae    801077c5 <deallocuvm+0xa5>
    pte = walkpgdir(pgdir, (char*)a, 0);
801077a1:	31 c9                	xor    %ecx,%ecx
801077a3:	89 f2                	mov    %esi,%edx
801077a5:	89 f8                	mov    %edi,%eax
801077a7:	e8 b4 fa ff ff       	call   80107260 <walkpgdir>
801077ac:	89 c3                	mov    %eax,%ebx
    if(!pte)
801077ae:	85 c0                	test   %eax,%eax
801077b0:	75 ae                	jne    80107760 <deallocuvm+0x40>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801077b2:	89 f2                	mov    %esi,%edx
801077b4:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801077ba:	8d b2 00 00 40 00    	lea    0x400000(%edx),%esi
  for(; a  < oldsz; a += PGSIZE){
801077c0:	3b 75 0c             	cmp    0xc(%ebp),%esi
801077c3:	72 dc                	jb     801077a1 <deallocuvm+0x81>
    }
  }

  return newsz;
801077c5:	8b 45 10             	mov    0x10(%ebp),%eax
}
801077c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077cb:	5b                   	pop    %ebx
801077cc:	5e                   	pop    %esi
801077cd:	5f                   	pop    %edi
801077ce:	5d                   	pop    %ebp
801077cf:	c3                   	ret    
801077d0:	8d 88 10 02 00 00    	lea    0x210(%eax),%ecx
        for (int i = 0; i < MAX_PYSC_PAGES; i++){
801077d6:	31 c0                	xor    %eax,%eax
801077d8:	eb 11                	jmp    801077eb <deallocuvm+0xcb>
801077da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801077e0:	83 c0 01             	add    $0x1,%eax
801077e3:	83 c1 18             	add    $0x18,%ecx
801077e6:	83 f8 10             	cmp    $0x10,%eax
801077e9:	74 a5                	je     80107790 <deallocuvm+0x70>
          if (p->ram_pages[i].va == (void*)a){
801077eb:	3b 31                	cmp    (%ecx),%esi
801077ed:	75 f1                	jne    801077e0 <deallocuvm+0xc0>
            p->num_of_actual_pages_in_mem--;
801077ef:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
            p->ram_pages[i].is_free = 1;
801077f2:	8d 04 40             	lea    (%eax,%eax,2),%eax
801077f5:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
            p->num_of_actual_pages_in_mem--;
801077f8:	83 a9 84 03 00 00 01 	subl   $0x1,0x384(%ecx)
            p->ram_pages[i].is_free = 1;
801077ff:	c7 80 00 02 00 00 01 	movl   $0x1,0x200(%eax)
80107806:	00 00 00 
            p->ram_pages[i].aging_counter = 0;
80107809:	c7 80 08 02 00 00 00 	movl   $0x0,0x208(%eax)
80107810:	00 00 00 
            p->ram_pages[i].va = 0;
80107813:	c7 80 10 02 00 00 00 	movl   $0x0,0x210(%eax)
8010781a:	00 00 00 
            break;
8010781d:	e9 6e ff ff ff       	jmp    80107790 <deallocuvm+0x70>
        panic("kfree");
80107822:	83 ec 0c             	sub    $0xc,%esp
80107825:	68 aa 83 10 80       	push   $0x801083aa
8010782a:	e8 61 8b ff ff       	call   80100390 <panic>
8010782f:	90                   	nop

80107830 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107830:	f3 0f 1e fb          	endbr32 
80107834:	55                   	push   %ebp
80107835:	89 e5                	mov    %esp,%ebp
80107837:	57                   	push   %edi
80107838:	56                   	push   %esi
80107839:	53                   	push   %ebx
8010783a:	83 ec 0c             	sub    $0xc,%esp
8010783d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;
  struct proc* p = myproc();
80107840:	e8 cb c8 ff ff       	call   80104110 <myproc>
  if(pgdir == 0)
80107845:	85 f6                	test   %esi,%esi
80107847:	0f 84 e2 00 00 00    	je     8010792f <freevm+0xff>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
8010784d:	83 ec 04             	sub    $0x4,%esp
80107850:	89 c3                	mov    %eax,%ebx
80107852:	6a 00                	push   $0x0
80107854:	68 00 00 00 80       	push   $0x80000000
80107859:	56                   	push   %esi
8010785a:	e8 c1 fe ff ff       	call   80107720 <deallocuvm>
  if (p->pid > 2 && p->pgdir == pgdir){
8010785f:	83 c4 10             	add    $0x10,%esp
80107862:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80107866:	7f 49                	jg     801078b1 <freevm+0x81>
80107868:	89 f3                	mov    %esi,%ebx
8010786a:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107870:	eb 0d                	jmp    8010787f <freevm+0x4f>
80107872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
    }
  }
  for(i = 0; i < NPDENTRIES; i++){
80107878:	83 c3 04             	add    $0x4,%ebx
8010787b:	39 fb                	cmp    %edi,%ebx
8010787d:	74 23                	je     801078a2 <freevm+0x72>
    if(pgdir[i] & PTE_P){
8010787f:	8b 03                	mov    (%ebx),%eax
80107881:	a8 01                	test   $0x1,%al
80107883:	74 f3                	je     80107878 <freevm+0x48>
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
8010789e:	39 fb                	cmp    %edi,%ebx
801078a0:	75 dd                	jne    8010787f <freevm+0x4f>
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
  if (p->pid > 2 && p->pgdir == pgdir){
801078b1:	39 73 04             	cmp    %esi,0x4(%ebx)
801078b4:	75 b2                	jne    80107868 <freevm+0x38>
    p->num_of_actual_pages_in_mem = 0;
801078b6:	c7 83 84 03 00 00 00 	movl   $0x0,0x384(%ebx)
801078bd:	00 00 00 
    p->num_of_pages_in_swap_file = 0;
801078c0:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
801078c6:	81 c3 00 02 00 00    	add    $0x200,%ebx
801078cc:	c7 83 80 01 00 00 00 	movl   $0x0,0x180(%ebx)
801078d3:	00 00 00 
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
801078d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078dd:	8d 76 00             	lea    0x0(%esi),%esi
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
801078e0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
801078e6:	83 c0 18             	add    $0x18,%eax
801078e9:	c7 80 68 01 00 00 01 	movl   $0x1,0x168(%eax)
801078f0:	00 00 00 
      p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
801078f3:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
801078fa:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
80107901:	00 00 00 
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80107904:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
8010790b:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
80107912:	00 00 00 
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80107915:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
8010791c:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
80107923:	00 00 00 
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107926:	39 d8                	cmp    %ebx,%eax
80107928:	75 b6                	jne    801078e0 <freevm+0xb0>
8010792a:	e9 39 ff ff ff       	jmp    80107868 <freevm+0x38>
    panic("freevm: no pgdir");
8010792f:	83 ec 0c             	sub    $0xc,%esp
80107932:	68 bd 8a 10 80       	push   $0x80108abd
80107937:	e8 54 8a ff ff       	call   80100390 <panic>
8010793c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107940 <setupkvm>:
{
80107940:	f3 0f 1e fb          	endbr32 
80107944:	55                   	push   %ebp
80107945:	89 e5                	mov    %esp,%ebp
80107947:	56                   	push   %esi
80107948:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107949:	e8 22 b4 ff ff       	call   80102d70 <kalloc>
8010794e:	89 c6                	mov    %eax,%esi
80107950:	85 c0                	test   %eax,%eax
80107952:	74 42                	je     80107996 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107954:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107957:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010795c:	68 00 10 00 00       	push   $0x1000
80107961:	6a 00                	push   $0x0
80107963:	50                   	push   %eax
80107964:	e8 e7 d6 ff ff       	call   80105050 <memset>
80107969:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010796c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010796f:	83 ec 08             	sub    $0x8,%esp
80107972:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107975:	ff 73 0c             	pushl  0xc(%ebx)
80107978:	8b 13                	mov    (%ebx),%edx
8010797a:	50                   	push   %eax
8010797b:	29 c1                	sub    %eax,%ecx
8010797d:	89 f0                	mov    %esi,%eax
8010797f:	e8 5c f9 ff ff       	call   801072e0 <mappages>
80107984:	83 c4 10             	add    $0x10,%esp
80107987:	85 c0                	test   %eax,%eax
80107989:	78 15                	js     801079a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010798b:	83 c3 10             	add    $0x10,%ebx
8010798e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107994:	75 d6                	jne    8010796c <setupkvm+0x2c>
}
80107996:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107999:	89 f0                	mov    %esi,%eax
8010799b:	5b                   	pop    %ebx
8010799c:	5e                   	pop    %esi
8010799d:	5d                   	pop    %ebp
8010799e:	c3                   	ret    
8010799f:	90                   	nop
      freevm(pgdir);
801079a0:	83 ec 0c             	sub    $0xc,%esp
801079a3:	56                   	push   %esi
      return 0;
801079a4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801079a6:	e8 85 fe ff ff       	call   80107830 <freevm>
      return 0;
801079ab:	83 c4 10             	add    $0x10,%esp
}
801079ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801079b1:	89 f0                	mov    %esi,%eax
801079b3:	5b                   	pop    %ebx
801079b4:	5e                   	pop    %esi
801079b5:	5d                   	pop    %ebp
801079b6:	c3                   	ret    
801079b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079be:	66 90                	xchg   %ax,%ax

801079c0 <kvmalloc>:
{
801079c0:	f3 0f 1e fb          	endbr32 
801079c4:	55                   	push   %ebp
801079c5:	89 e5                	mov    %esp,%ebp
801079c7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801079ca:	e8 71 ff ff ff       	call   80107940 <setupkvm>
801079cf:	a3 c4 29 12 80       	mov    %eax,0x801229c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801079d4:	05 00 00 00 80       	add    $0x80000000,%eax
801079d9:	0f 22 d8             	mov    %eax,%cr3
}
801079dc:	c9                   	leave  
801079dd:	c3                   	ret    
801079de:	66 90                	xchg   %ax,%ax

801079e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801079e0:	f3 0f 1e fb          	endbr32 
801079e4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801079e5:	31 c9                	xor    %ecx,%ecx
{
801079e7:	89 e5                	mov    %esp,%ebp
801079e9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801079ec:	8b 55 0c             	mov    0xc(%ebp),%edx
801079ef:	8b 45 08             	mov    0x8(%ebp),%eax
801079f2:	e8 69 f8 ff ff       	call   80107260 <walkpgdir>
  if(pte == 0)
801079f7:	85 c0                	test   %eax,%eax
801079f9:	74 05                	je     80107a00 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801079fb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801079fe:	c9                   	leave  
801079ff:	c3                   	ret    
    panic("clearpteu");
80107a00:	83 ec 0c             	sub    $0xc,%esp
80107a03:	68 ce 8a 10 80       	push   $0x80108ace
80107a08:	e8 83 89 ff ff       	call   80100390 <panic>
80107a0d:	8d 76 00             	lea    0x0(%esi),%esi

80107a10 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107a10:	f3 0f 1e fb          	endbr32 
80107a14:	55                   	push   %ebp
80107a15:	89 e5                	mov    %esp,%ebp
80107a17:	57                   	push   %edi
80107a18:	56                   	push   %esi
80107a19:	53                   	push   %ebx
80107a1a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107a1d:	e8 1e ff ff ff       	call   80107940 <setupkvm>
80107a22:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a25:	85 c0                	test   %eax,%eax
80107a27:	0f 84 9b 00 00 00    	je     80107ac8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107a2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107a30:	85 c9                	test   %ecx,%ecx
80107a32:	0f 84 90 00 00 00    	je     80107ac8 <copyuvm+0xb8>
80107a38:	31 f6                	xor    %esi,%esi
80107a3a:	eb 46                	jmp    80107a82 <copyuvm+0x72>
80107a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107a40:	83 ec 04             	sub    $0x4,%esp
80107a43:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107a49:	68 00 10 00 00       	push   $0x1000
80107a4e:	57                   	push   %edi
80107a4f:	50                   	push   %eax
80107a50:	e8 9b d6 ff ff       	call   801050f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107a55:	58                   	pop    %eax
80107a56:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a5c:	5a                   	pop    %edx
80107a5d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107a60:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a65:	89 f2                	mov    %esi,%edx
80107a67:	50                   	push   %eax
80107a68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a6b:	e8 70 f8 ff ff       	call   801072e0 <mappages>
80107a70:	83 c4 10             	add    $0x10,%esp
80107a73:	85 c0                	test   %eax,%eax
80107a75:	78 61                	js     80107ad8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107a77:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a7d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107a80:	76 46                	jbe    80107ac8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a82:	8b 45 08             	mov    0x8(%ebp),%eax
80107a85:	31 c9                	xor    %ecx,%ecx
80107a87:	89 f2                	mov    %esi,%edx
80107a89:	e8 d2 f7 ff ff       	call   80107260 <walkpgdir>
80107a8e:	85 c0                	test   %eax,%eax
80107a90:	74 61                	je     80107af3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107a92:	8b 00                	mov    (%eax),%eax
80107a94:	a8 01                	test   $0x1,%al
80107a96:	74 4e                	je     80107ae6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107a98:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107a9a:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107aa2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107aa8:	e8 c3 b2 ff ff       	call   80102d70 <kalloc>
80107aad:	89 c3                	mov    %eax,%ebx
80107aaf:	85 c0                	test   %eax,%eax
80107ab1:	75 8d                	jne    80107a40 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107ab3:	83 ec 0c             	sub    $0xc,%esp
80107ab6:	ff 75 e0             	pushl  -0x20(%ebp)
80107ab9:	e8 72 fd ff ff       	call   80107830 <freevm>
  return 0;
80107abe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107ac5:	83 c4 10             	add    $0x10,%esp
}
80107ac8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107acb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ace:	5b                   	pop    %ebx
80107acf:	5e                   	pop    %esi
80107ad0:	5f                   	pop    %edi
80107ad1:	5d                   	pop    %ebp
80107ad2:	c3                   	ret    
80107ad3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ad7:	90                   	nop
      kfree(mem);
80107ad8:	83 ec 0c             	sub    $0xc,%esp
80107adb:	53                   	push   %ebx
80107adc:	e8 cf b0 ff ff       	call   80102bb0 <kfree>
      goto bad;
80107ae1:	83 c4 10             	add    $0x10,%esp
80107ae4:	eb cd                	jmp    80107ab3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107ae6:	83 ec 0c             	sub    $0xc,%esp
80107ae9:	68 f2 8a 10 80       	push   $0x80108af2
80107aee:	e8 9d 88 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107af3:	83 ec 0c             	sub    $0xc,%esp
80107af6:	68 d8 8a 10 80       	push   $0x80108ad8
80107afb:	e8 90 88 ff ff       	call   80100390 <panic>

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
80107b12:	e8 49 f7 ff ff       	call   80107260 <walkpgdir>
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
80107b7e:	e8 6d d5 ff ff       	call   801050f0 <memmove>
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
80107bda:	83 ec 1c             	sub    $0x1c,%esp
80107bdd:	8b 75 10             	mov    0x10(%ebp),%esi
80107be0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80107be3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if (buffer == 0){
80107be6:	85 f6                	test   %esi,%esi
80107be8:	0f 84 ba 00 00 00    	je     80107ca8 <swap_out+0xd8>
    buffer = P2V((PTE_ADDR(*(walkpgdir(pgdir, page_to_swap->va, 0)))));
  }
  // swap page
  // INV  : cell swapped_out_pages[i] is free iff there isnt a page that is written in offset i * PGSIZE in the swap file
  int index;
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107bee:	8d 93 80 00 00 00    	lea    0x80(%ebx),%edx
80107bf4:	31 c0                	xor    %eax,%eax
80107bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bfd:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->swapped_out_pages[index].is_free){
80107c00:	8b 0a                	mov    (%edx),%ecx
80107c02:	85 c9                	test   %ecx,%ecx
80107c04:	75 7a                	jne    80107c80 <swap_out+0xb0>
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107c06:	83 c0 01             	add    $0x1,%eax
80107c09:	83 c2 18             	add    $0x18,%edx
80107c0c:	83 f8 10             	cmp    $0x10,%eax
80107c0f:	75 ef                	jne    80107c00 <swap_out+0x30>
80107c11:	b8 00 00 01 00       	mov    $0x10000,%eax
      p->swapped_out_pages[index].is_free = 0;
      p->swapped_out_pages[index].va = page_to_swap->va;
      break;
    }
  }
  int result = writeToSwapFile(p, buffer, index * PGSIZE, PGSIZE);
80107c16:	68 00 10 00 00       	push   $0x1000
80107c1b:	50                   	push   %eax
80107c1c:	56                   	push   %esi
80107c1d:	53                   	push   %ebx
80107c1e:	e8 2d ab ff ff       	call   80102750 <writeToSwapFile>


  
  // update flags in PTE
  pte_t* pte_ptr = walkpgdir(pgdir, page_to_swap->va, 0);
80107c23:	8b 57 10             	mov    0x10(%edi),%edx
80107c26:	31 c9                	xor    %ecx,%ecx
  int result = writeToSwapFile(p, buffer, index * PGSIZE, PGSIZE);
80107c28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pte_t* pte_ptr = walkpgdir(pgdir, page_to_swap->va, 0);
80107c2b:	8b 45 14             	mov    0x14(%ebp),%eax
80107c2e:	e8 2d f6 ff ff       	call   80107260 <walkpgdir>
  *pte_ptr |= PTE_PG;
  *pte_ptr &= ~PTE_P;
80107c33:	8b 10                	mov    (%eax),%edx
80107c35:	83 e2 fe             	and    $0xfffffffe,%edx
80107c38:	80 ce 02             	or     $0x2,%dh
80107c3b:	89 10                	mov    %edx,(%eax)
  kfree(buffer);
80107c3d:	89 34 24             	mov    %esi,(%esp)
80107c40:	e8 6b af ff ff       	call   80102bb0 <kfree>
  // refresh cr3
  lcr3(V2P(p->pgdir));
80107c45:	8b 4b 04             	mov    0x4(%ebx),%ecx
80107c48:	8d 81 00 00 00 80    	lea    -0x80000000(%ecx),%eax
80107c4e:	0f 22 d8             	mov    %eax,%cr3
  page_to_swap->is_free = 1;
  if (result < 0){
80107c51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  page_to_swap->is_free = 1;
80107c54:	c7 07 01 00 00 00    	movl   $0x1,(%edi)
  if (result < 0){
80107c5a:	83 c4 10             	add    $0x10,%esp
80107c5d:	85 c0                	test   %eax,%eax
80107c5f:	78 66                	js     80107cc7 <swap_out+0xf7>
    panic("swap out failed\n");
  }
  p->num_of_pages_in_swap_file++;
80107c61:	83 83 80 03 00 00 01 	addl   $0x1,0x380(%ebx)
  p->num_of_pageOut_occured++;
80107c68:	83 83 8c 03 00 00 01 	addl   $0x1,0x38c(%ebx)
  p->num_of_actual_pages_in_mem--;
80107c6f:	83 ab 84 03 00 00 01 	subl   $0x1,0x384(%ebx)
}
80107c76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c79:	5b                   	pop    %ebx
80107c7a:	5e                   	pop    %esi
80107c7b:	5f                   	pop    %edi
80107c7c:	5d                   	pop    %ebp
80107c7d:	c3                   	ret    
80107c7e:	66 90                	xchg   %ax,%ax
      p->swapped_out_pages[index].is_free = 0;
80107c80:	8d 14 40             	lea    (%eax,%eax,2),%edx
80107c83:	c1 e0 0c             	shl    $0xc,%eax
80107c86:	8d 14 d3             	lea    (%ebx,%edx,8),%edx
80107c89:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
80107c90:	00 00 00 
      p->swapped_out_pages[index].va = page_to_swap->va;
80107c93:	8b 4f 10             	mov    0x10(%edi),%ecx
80107c96:	89 8a 90 00 00 00    	mov    %ecx,0x90(%edx)
      break;
80107c9c:	e9 75 ff ff ff       	jmp    80107c16 <swap_out+0x46>
80107ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    buffer = P2V((PTE_ADDR(*(walkpgdir(pgdir, page_to_swap->va, 0)))));
80107ca8:	8b 57 10             	mov    0x10(%edi),%edx
80107cab:	8b 45 14             	mov    0x14(%ebp),%eax
80107cae:	31 c9                	xor    %ecx,%ecx
80107cb0:	e8 ab f5 ff ff       	call   80107260 <walkpgdir>
80107cb5:	8b 00                	mov    (%eax),%eax
80107cb7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cbc:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80107cc2:	e9 27 ff ff ff       	jmp    80107bee <swap_out+0x1e>
    panic("swap out failed\n");
80107cc7:	83 ec 0c             	sub    $0xc,%esp
80107cca:	68 0c 8b 10 80       	push   $0x80108b0c
80107ccf:	e8 bc 86 ff ff       	call   80100390 <panic>
80107cd4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107cdf:	90                   	nop

80107ce0 <allocuvm>:
{
80107ce0:	f3 0f 1e fb          	endbr32 
80107ce4:	55                   	push   %ebp
80107ce5:	89 e5                	mov    %esp,%ebp
80107ce7:	57                   	push   %edi
80107ce8:	56                   	push   %esi
80107ce9:	53                   	push   %ebx
80107cea:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* p = myproc();
80107ced:	e8 1e c4 ff ff       	call   80104110 <myproc>
80107cf2:	89 c7                	mov    %eax,%edi
  if(newsz >= KERNBASE)
80107cf4:	8b 45 10             	mov    0x10(%ebp),%eax
80107cf7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107cfa:	85 c0                	test   %eax,%eax
80107cfc:	0f 88 6e 01 00 00    	js     80107e70 <allocuvm+0x190>
  if(newsz < oldsz)
80107d02:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107d05:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107d08:	0f 82 f2 00 00 00    	jb     80107e00 <allocuvm+0x120>
  a = PGROUNDUP(oldsz);
80107d0e:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107d14:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107d1a:	39 75 10             	cmp    %esi,0x10(%ebp)
80107d1d:	0f 86 e0 00 00 00    	jbe    80107e03 <allocuvm+0x123>
80107d23:	8b 4f 10             	mov    0x10(%edi),%ecx
80107d26:	eb 17                	jmp    80107d3f <allocuvm+0x5f>
80107d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d2f:	90                   	nop
80107d30:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107d36:	39 75 10             	cmp    %esi,0x10(%ebp)
80107d39:	0f 86 c4 00 00 00    	jbe    80107e03 <allocuvm+0x123>
    if (p->pid > 2){
80107d3f:	83 f9 02             	cmp    $0x2,%ecx
80107d42:	7e 18                	jle    80107d5c <allocuvm+0x7c>
      p->num_of_actual_pages_in_mem++;
80107d44:	8b 87 84 03 00 00    	mov    0x384(%edi),%eax
80107d4a:	83 c0 01             	add    $0x1,%eax
80107d4d:	89 87 84 03 00 00    	mov    %eax,0x384(%edi)
      if (p->num_of_actual_pages_in_mem >= 16){
80107d53:	83 f8 0f             	cmp    $0xf,%eax
80107d56:	0f 87 b4 00 00 00    	ja     80107e10 <allocuvm+0x130>
    mem = kalloc();
80107d5c:	e8 0f b0 ff ff       	call   80102d70 <kalloc>
80107d61:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107d63:	85 c0                	test   %eax,%eax
80107d65:	0f 84 cc 00 00 00    	je     80107e37 <allocuvm+0x157>
    memset(mem, 0, PGSIZE);
80107d6b:	83 ec 04             	sub    $0x4,%esp
80107d6e:	68 00 10 00 00       	push   $0x1000
80107d73:	6a 00                	push   $0x0
80107d75:	50                   	push   %eax
80107d76:	e8 d5 d2 ff ff       	call   80105050 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107d7b:	58                   	pop    %eax
80107d7c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107d82:	5a                   	pop    %edx
80107d83:	6a 06                	push   $0x6
80107d85:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d8a:	89 f2                	mov    %esi,%edx
80107d8c:	50                   	push   %eax
80107d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80107d90:	e8 4b f5 ff ff       	call   801072e0 <mappages>
80107d95:	83 c4 10             	add    $0x10,%esp
80107d98:	85 c0                	test   %eax,%eax
80107d9a:	0f 88 e8 00 00 00    	js     80107e88 <allocuvm+0x1a8>
    if (p->pid > 2){
80107da0:	8b 4f 10             	mov    0x10(%edi),%ecx
80107da3:	83 f9 02             	cmp    $0x2,%ecx
80107da6:	7e 88                	jle    80107d30 <allocuvm+0x50>
80107da8:	8d 97 00 02 00 00    	lea    0x200(%edi),%edx
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107dae:	31 c0                	xor    %eax,%eax
80107db0:	eb 15                	jmp    80107dc7 <allocuvm+0xe7>
80107db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107db8:	83 c0 01             	add    $0x1,%eax
80107dbb:	83 c2 18             	add    $0x18,%edx
80107dbe:	83 f8 10             	cmp    $0x10,%eax
80107dc1:	0f 84 69 ff ff ff    	je     80107d30 <allocuvm+0x50>
        if (p->ram_pages[i].is_free){
80107dc7:	8b 1a                	mov    (%edx),%ebx
80107dc9:	85 db                	test   %ebx,%ebx
80107dcb:	74 eb                	je     80107db8 <allocuvm+0xd8>
          p->ram_pages[i].is_free = 0;
80107dcd:	8d 04 40             	lea    (%eax,%eax,2),%eax
80107dd0:	8d 14 c7             	lea    (%edi,%eax,8),%edx
          p->ram_pages[i].page_index = ++page_counter;
80107dd3:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
          p->ram_pages[i].is_free = 0;
80107dd8:	c7 82 00 02 00 00 00 	movl   $0x0,0x200(%edx)
80107ddf:	00 00 00 
          p->ram_pages[i].page_index = ++page_counter;
80107de2:	83 c0 01             	add    $0x1,%eax
          p->ram_pages[i].va = (void *)a;
80107de5:	89 b2 10 02 00 00    	mov    %esi,0x210(%edx)
          p->ram_pages[i].page_index = ++page_counter;
80107deb:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
80107df0:	89 82 0c 02 00 00    	mov    %eax,0x20c(%edx)
          break;
80107df6:	e9 35 ff ff ff       	jmp    80107d30 <allocuvm+0x50>
80107dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107dff:	90                   	nop
    return oldsz;
80107e00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e09:	5b                   	pop    %ebx
80107e0a:	5e                   	pop    %esi
80107e0b:	5f                   	pop    %edi
80107e0c:	5d                   	pop    %ebp
80107e0d:	c3                   	ret    
80107e0e:	66 90                	xchg   %ax,%ax
        struct pageinfo* page_to_swap = find_page_to_swap(p);
80107e10:	83 ec 0c             	sub    $0xc,%esp
80107e13:	57                   	push   %edi
80107e14:	e8 57 f5 ff ff       	call   80107370 <find_page_to_swap>
        swap_out(p, page_to_swap, 0, pgdir);
80107e19:	ff 75 08             	pushl  0x8(%ebp)
80107e1c:	6a 00                	push   $0x0
80107e1e:	50                   	push   %eax
80107e1f:	57                   	push   %edi
80107e20:	e8 ab fd ff ff       	call   80107bd0 <swap_out>
80107e25:	83 c4 20             	add    $0x20,%esp
    mem = kalloc();
80107e28:	e8 43 af ff ff       	call   80102d70 <kalloc>
80107e2d:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107e2f:	85 c0                	test   %eax,%eax
80107e31:	0f 85 34 ff ff ff    	jne    80107d6b <allocuvm+0x8b>
      cprintf("allocuvm out of memory\n");
80107e37:	83 ec 0c             	sub    $0xc,%esp
80107e3a:	68 1d 8b 10 80       	push   $0x80108b1d
80107e3f:	e8 6c 88 ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107e44:	83 c4 0c             	add    $0xc,%esp
80107e47:	ff 75 0c             	pushl  0xc(%ebp)
80107e4a:	ff 75 10             	pushl  0x10(%ebp)
80107e4d:	ff 75 08             	pushl  0x8(%ebp)
80107e50:	e8 cb f8 ff ff       	call   80107720 <deallocuvm>
      return 0;
80107e55:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107e5c:	83 c4 10             	add    $0x10,%esp
}
80107e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e65:	5b                   	pop    %ebx
80107e66:	5e                   	pop    %esi
80107e67:	5f                   	pop    %edi
80107e68:	5d                   	pop    %ebp
80107e69:	c3                   	ret    
80107e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return 0;
80107e70:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107e77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e7d:	5b                   	pop    %ebx
80107e7e:	5e                   	pop    %esi
80107e7f:	5f                   	pop    %edi
80107e80:	5d                   	pop    %ebp
80107e81:	c3                   	ret    
80107e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107e88:	83 ec 0c             	sub    $0xc,%esp
80107e8b:	68 35 8b 10 80       	push   $0x80108b35
80107e90:	e8 1b 88 ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107e95:	83 c4 0c             	add    $0xc,%esp
80107e98:	ff 75 0c             	pushl  0xc(%ebp)
80107e9b:	ff 75 10             	pushl  0x10(%ebp)
80107e9e:	ff 75 08             	pushl  0x8(%ebp)
80107ea1:	e8 7a f8 ff ff       	call   80107720 <deallocuvm>
      kfree(mem);
80107ea6:	89 1c 24             	mov    %ebx,(%esp)
80107ea9:	e8 02 ad ff ff       	call   80102bb0 <kfree>
      return 0;
80107eae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107eb5:	83 c4 10             	add    $0x10,%esp
}
80107eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ebb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ebe:	5b                   	pop    %ebx
80107ebf:	5e                   	pop    %esi
80107ec0:	5f                   	pop    %edi
80107ec1:	5d                   	pop    %ebp
80107ec2:	c3                   	ret    
80107ec3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ed0 <swap_in>:

// we assume there are at most MAX_PYSC_PAGES in the RAM 
int swap_in(struct proc* p, struct pageinfo* pi){
80107ed0:	f3 0f 1e fb          	endbr32 
80107ed4:	55                   	push   %ebp
80107ed5:	89 e5                	mov    %esp,%ebp
80107ed7:	57                   	push   %edi
80107ed8:	56                   	push   %esi
80107ed9:	53                   	push   %ebx
  pde_t* pgdir = p->pgdir;
  uint offset = pi->swap_file_offset;
  int index;
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107eda:	31 db                	xor    %ebx,%ebx
int swap_in(struct proc* p, struct pageinfo* pi){
80107edc:	83 ec 1c             	sub    $0x1c,%esp
80107edf:	8b 75 08             	mov    0x8(%ebp),%esi
80107ee2:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t* pgdir = p->pgdir;
80107ee5:	8b 46 04             	mov    0x4(%esi),%eax
80107ee8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint offset = pi->swap_file_offset;
80107eeb:	8b 47 04             	mov    0x4(%edi),%eax
80107eee:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107ef1:	8d 86 00 02 00 00    	lea    0x200(%esi),%eax
80107ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107efe:	66 90                	xchg   %ax,%ax
    if (p->ram_pages[index].is_free){
80107f00:	8b 10                	mov    (%eax),%edx
80107f02:	85 d2                	test   %edx,%edx
80107f04:	0f 85 c6 00 00 00    	jne    80107fd0 <swap_in+0x100>
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107f0a:	83 c3 01             	add    $0x1,%ebx
80107f0d:	83 c0 18             	add    $0x18,%eax
80107f10:	83 fb 10             	cmp    $0x10,%ebx
80107f13:	75 eb                	jne    80107f00 <swap_in+0x30>
      p->ram_pages[index].is_free = 0;
      break;
    }
  }
  void* mem = kalloc();
80107f15:	e8 56 ae ff ff       	call   80102d70 <kalloc>
  mem = kalloc();
80107f1a:	e8 51 ae ff ff       	call   80102d70 <kalloc>
80107f1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(mem == 0){
80107f22:	85 c0                	test   %eax,%eax
80107f24:	0f 84 b9 00 00 00    	je     80107fe3 <swap_in+0x113>
    cprintf("swap in - out of memory\n");
    // deallocuvm(pgdir, newsz, oldsz);
    return -1;
  }

  void* va = pi->va;
80107f2a:	8b 47 10             	mov    0x10(%edi),%eax
  pte_t* pte_ptr = walkpgdir(pgdir, va, 0);
80107f2d:	31 c9                	xor    %ecx,%ecx
80107f2f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107f32:	89 c2                	mov    %eax,%edx
80107f34:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f37:	e8 24 f3 ff ff       	call   80107260 <walkpgdir>
  *pte_ptr &= ~PTE_PG;
  *pte_ptr |= PTE_P;

  // updating physical address written in the page table entry
  *pte_ptr = PTE_FLAGS(*pte_ptr);
  *pte_ptr |= PTE_ADDR(V2P(mem));
80107f3c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107f3f:	8d 91 00 00 00 80    	lea    -0x80000000(%ecx),%edx
80107f45:	8b 08                	mov    (%eax),%ecx
80107f47:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107f4d:	81 e1 ff 0d 00 00    	and    $0xdff,%ecx
80107f53:	09 ca                	or     %ecx,%edx
80107f55:	83 ca 01             	or     $0x1,%edx
80107f58:	89 10                	mov    %edx,(%eax)

  p->ram_pages[index].page_index = ++page_counter;
80107f5a:	8b 0d c0 b5 10 80    	mov    0x8010b5c0,%ecx
80107f60:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
80107f63:	8d 14 d6             	lea    (%esi,%edx,8),%edx
80107f66:	8d 41 01             	lea    0x1(%ecx),%eax
80107f69:	89 82 0c 02 00 00    	mov    %eax,0x20c(%edx)
80107f6f:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
  p->ram_pages[index].va = va;
80107f74:	8b 45 d8             	mov    -0x28(%ebp),%eax
80107f77:	89 82 10 02 00 00    	mov    %eax,0x210(%edx)
  int result = readFromSwapFile(p, mem, offset, PGSIZE);
80107f7d:	68 00 10 00 00       	push   $0x1000
80107f82:	ff 75 dc             	pushl  -0x24(%ebp)
80107f85:	ff 75 e4             	pushl  -0x1c(%ebp)
80107f88:	56                   	push   %esi
80107f89:	e8 f2 a7 ff ff       	call   80102780 <readFromSwapFile>

  // clean the struct
  pi->is_free = 1;
80107f8e:	c7 07 01 00 00 00    	movl   $0x1,(%edi)
  pi->va = 0;
80107f94:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  pi->swap_file_offset = 0;
80107f9b:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)

  // refresh rc3
  lcr3(V2P(p->pgdir));
80107fa2:	8b 7e 04             	mov    0x4(%esi),%edi
80107fa5:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
80107fab:	0f 22 da             	mov    %edx,%cr3

  p->num_of_actual_pages_in_mem++;
80107fae:	83 86 84 03 00 00 01 	addl   $0x1,0x384(%esi)
  p->num_of_pages_in_swap_file--;

  if (result < 0){
80107fb5:	83 c4 10             	add    $0x10,%esp
  p->num_of_pages_in_swap_file--;
80107fb8:	83 ae 80 03 00 00 01 	subl   $0x1,0x380(%esi)
  if (result < 0){
80107fbf:	85 c0                	test   %eax,%eax
80107fc1:	78 37                	js     80107ffa <swap_in+0x12a>
    panic("swap in failed");
  }
  return result;
}
80107fc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fc6:	5b                   	pop    %ebx
80107fc7:	5e                   	pop    %esi
80107fc8:	5f                   	pop    %edi
80107fc9:	5d                   	pop    %ebp
80107fca:	c3                   	ret    
80107fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107fcf:	90                   	nop
      p->ram_pages[index].is_free = 0;
80107fd0:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
80107fd3:	c7 84 c6 00 02 00 00 	movl   $0x0,0x200(%esi,%eax,8)
80107fda:	00 00 00 00 
      break;
80107fde:	e9 32 ff ff ff       	jmp    80107f15 <swap_in+0x45>
    cprintf("swap in - out of memory\n");
80107fe3:	83 ec 0c             	sub    $0xc,%esp
80107fe6:	68 51 8b 10 80       	push   $0x80108b51
80107feb:	e8 c0 86 ff ff       	call   801006b0 <cprintf>
    return -1;
80107ff0:	83 c4 10             	add    $0x10,%esp
80107ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ff8:	eb c9                	jmp    80107fc3 <swap_in+0xf3>
    panic("swap in failed");
80107ffa:	83 ec 0c             	sub    $0xc,%esp
80107ffd:	68 6a 8b 10 80       	push   $0x80108b6a
80108002:	e8 89 83 ff ff       	call   80100390 <panic>
80108007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010800e:	66 90                	xchg   %ax,%ax

80108010 <swap_page_back>:
 * 3. ram not full - swap in
 * 
 * 
 * */

void swap_page_back(struct proc* p, struct pageinfo* pi_to_swapin){
80108010:	f3 0f 1e fb          	endbr32 
80108014:	55                   	push   %ebp
80108015:	89 e5                	mov    %esp,%ebp
80108017:	57                   	push   %edi
80108018:	56                   	push   %esi
80108019:	53                   	push   %ebx
8010801a:	83 ec 2c             	sub    $0x2c,%esp
8010801d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
80108020:	83 bb 84 03 00 00 10 	cmpl   $0x10,0x384(%ebx)
80108027:	74 17                	je     80108040 <swap_page_back+0x30>
    struct pageinfo* page_to_swap = find_page_to_swap(p);
    swap_out(p, page_to_swap, 0, p->pgdir);
    swap_in(p, pi_to_swapin);
  }
  else{
    swap_in(p, pi_to_swapin);
80108029:	83 ec 08             	sub    $0x8,%esp
8010802c:	ff 75 0c             	pushl  0xc(%ebp)
8010802f:	53                   	push   %ebx
80108030:	e8 9b fe ff ff       	call   80107ed0 <swap_in>
80108035:	83 c4 10             	add    $0x10,%esp
  }
}
80108038:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010803b:	5b                   	pop    %ebx
8010803c:	5e                   	pop    %esi
8010803d:	5f                   	pop    %edi
8010803e:	5d                   	pop    %ebp
8010803f:	c3                   	ret    
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
80108040:	8b 83 80 03 00 00    	mov    0x380(%ebx),%eax
80108046:	83 f8 10             	cmp    $0x10,%eax
80108049:	74 35                	je     80108080 <swap_page_back+0x70>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
8010804b:	83 f8 0f             	cmp    $0xf,%eax
8010804e:	77 d9                	ja     80108029 <swap_page_back+0x19>
    struct pageinfo* page_to_swap = find_page_to_swap(p);
80108050:	83 ec 0c             	sub    $0xc,%esp
80108053:	53                   	push   %ebx
80108054:	e8 17 f3 ff ff       	call   80107370 <find_page_to_swap>
    swap_out(p, page_to_swap, 0, p->pgdir);
80108059:	ff 73 04             	pushl  0x4(%ebx)
8010805c:	6a 00                	push   $0x0
8010805e:	50                   	push   %eax
8010805f:	53                   	push   %ebx
80108060:	e8 6b fb ff ff       	call   80107bd0 <swap_out>
    swap_in(p, pi_to_swapin);
80108065:	83 c4 18             	add    $0x18,%esp
80108068:	ff 75 0c             	pushl  0xc(%ebp)
8010806b:	53                   	push   %ebx
8010806c:	e8 5f fe ff ff       	call   80107ed0 <swap_in>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
80108071:	83 c4 10             	add    $0x10,%esp
}
80108074:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108077:	5b                   	pop    %ebx
80108078:	5e                   	pop    %esi
80108079:	5f                   	pop    %edi
8010807a:	5d                   	pop    %ebp
8010807b:	c3                   	ret    
8010807c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    char* buffer = kalloc();
80108080:	e8 eb ac ff ff       	call   80102d70 <kalloc>
    struct pageinfo* page_to_swap = find_page_to_swap(p);
80108085:	83 ec 0c             	sub    $0xc,%esp
80108088:	53                   	push   %ebx
    char* buffer = kalloc();
80108089:	89 c7                	mov    %eax,%edi
    struct pageinfo* page_to_swap = find_page_to_swap(p);
8010808b:	e8 e0 f2 ff ff       	call   80107370 <find_page_to_swap>
    memmove(buffer, page_to_swap->va, PGSIZE);
80108090:	83 c4 0c             	add    $0xc,%esp
80108093:	68 00 10 00 00       	push   $0x1000
    struct pageinfo* page_to_swap = find_page_to_swap(p);
80108098:	89 c6                	mov    %eax,%esi
    memmove(buffer, page_to_swap->va, PGSIZE);
8010809a:	ff 70 10             	pushl  0x10(%eax)
8010809d:	57                   	push   %edi
8010809e:	e8 4d d0 ff ff       	call   801050f0 <memmove>
    pi = *page_to_swap;
801080a3:	8b 06                	mov    (%esi),%eax
801080a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
801080a8:	8b 46 04             	mov    0x4(%esi),%eax
801080ab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801080ae:	8b 46 08             	mov    0x8(%esi),%eax
801080b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
801080b4:	8b 46 0c             	mov    0xc(%esi),%eax
801080b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801080ba:	8b 46 10             	mov    0x10(%esi),%eax
801080bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
801080c0:	8b 46 14             	mov    0x14(%esi),%eax
801080c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    page_to_swap->is_free = 1;
801080c6:	c7 06 01 00 00 00    	movl   $0x1,(%esi)
    swap_in(p, page_to_swap);
801080cc:	58                   	pop    %eax
801080cd:	5a                   	pop    %edx
801080ce:	56                   	push   %esi
801080cf:	53                   	push   %ebx
801080d0:	e8 fb fd ff ff       	call   80107ed0 <swap_in>
    swap_out(p, &pi, buffer, p->pgdir);
801080d5:	8d 45 d0             	lea    -0x30(%ebp),%eax
801080d8:	ff 73 04             	pushl  0x4(%ebx)
801080db:	57                   	push   %edi
801080dc:	50                   	push   %eax
801080dd:	53                   	push   %ebx
801080de:	e8 ed fa ff ff       	call   80107bd0 <swap_out>
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
801080e3:	83 c4 20             	add    $0x20,%esp
801080e6:	e9 4d ff ff ff       	jmp    80108038 <swap_page_back+0x28>
