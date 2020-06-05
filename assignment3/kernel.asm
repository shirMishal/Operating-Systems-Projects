
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
8010002d:	b8 70 37 10 80       	mov    $0x80103770,%eax
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
80100050:	68 a0 81 10 80       	push   $0x801081a0
80100055:	68 e0 c5 10 80       	push   $0x8010c5e0
8010005a:	e8 51 4d 00 00       	call   80104db0 <initlock>
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
80100092:	68 a7 81 10 80       	push   $0x801081a7
80100097:	50                   	push   %eax
80100098:	e8 d3 4b 00 00       	call   80104c70 <initsleeplock>
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
801000e8:	e8 43 4e 00 00       	call   80104f30 <acquire>
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
80100162:	e8 89 4e 00 00       	call   80104ff0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 4b 00 00       	call   80104cb0 <acquiresleep>
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
8010018c:	e8 1f 28 00 00       	call   801029b0 <iderw>
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
801001a3:	68 ae 81 10 80       	push   $0x801081ae
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
801001c2:	e8 89 4b 00 00       	call   80104d50 <holdingsleep>
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
801001d8:	e9 d3 27 00 00       	jmp    801029b0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 bf 81 10 80       	push   $0x801081bf
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
80100203:	e8 48 4b 00 00       	call   80104d50 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 f8 4a 00 00       	call   80104d10 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010021f:	e8 0c 4d 00 00       	call   80104f30 <acquire>
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
80100270:	e9 7b 4d 00 00       	jmp    80104ff0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 c6 81 10 80       	push   $0x801081c6
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
801002a5:	e8 46 19 00 00       	call   80101bf0 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 7a 4c 00 00       	call   80104f30 <acquire>
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
801002e5:	e8 36 45 00 00       	call   80104820 <sleep>
    while(input.r == input.w){
801002ea:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 01 3e 00 00       	call   80104100 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 dd 4c 00 00       	call   80104ff0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 f4 17 00 00       	call   80101b10 <ilock>
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
80100365:	e8 86 4c 00 00       	call   80104ff0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 9d 17 00 00       	call   80101b10 <ilock>
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
801003ad:	e8 1e 2c 00 00       	call   80102fd0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 cd 81 10 80       	push   $0x801081cd
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 ea 8b 10 80 	movl   $0x80108bea,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ef 49 00 00       	call   80104dd0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 e1 81 10 80       	push   $0x801081e1
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
8010042a:	e8 31 63 00 00       	call   80106760 <uartputc>
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
80100515:	e8 46 62 00 00       	call   80106760 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 3a 62 00 00       	call   80106760 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 2e 62 00 00       	call   80106760 <uartputc>
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
80100561:	e8 7a 4b 00 00       	call   801050e0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 c5 4a 00 00       	call   80105040 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 e5 81 10 80       	push   $0x801081e5
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
801005c9:	0f b6 92 10 82 10 80 	movzbl -0x7fef7df0(%edx),%edx
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
80100653:	e8 98 15 00 00       	call   80101bf0 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 cc 48 00 00       	call   80104f30 <acquire>
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
80100697:	e8 54 49 00 00       	call   80104ff0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 6b 14 00 00       	call   80101b10 <ilock>

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
8010077d:	bb f8 81 10 80       	mov    $0x801081f8,%ebx
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
801007bd:	e8 6e 47 00 00       	call   80104f30 <acquire>
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
80100828:	e8 c3 47 00 00       	call   80104ff0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 ff 81 10 80       	push   $0x801081ff
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
80100877:	e8 b4 46 00 00       	call   80104f30 <acquire>
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
801009cf:	e8 1c 46 00 00       	call   80104ff0 <release>
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
801009ff:	e9 7c 41 00 00       	jmp    80104b80 <procdump>
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
80100a20:	e8 5b 40 00 00       	call   80104a80 <wakeup>
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
80100a3a:	68 08 82 10 80       	push   $0x80108208
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 67 43 00 00       	call   80104db0 <initlock>

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
80100a6d:	e8 ee 20 00 00       	call   80102b60 <ioapicenable>
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
80100b20:	e8 db 35 00 00       	call   80104100 <myproc>
80100b25:	89 c7                	mov    %eax,%edi
  struct pageinfo mem_pginfo_bu[MAX_PYSC_PAGES];
  struct pageinfo swp_pginfo_bu[MAX_PYSC_PAGES];
  struct file* swap_file_bu = 0;
  struct file* temp_swap_file = 0;

  begin_op();
80100b27:	e8 34 29 00 00       	call   80103460 <begin_op>

  if((ip = namei(path)) == 0){
80100b2c:	83 ec 0c             	sub    $0xc,%esp
80100b2f:	ff 75 08             	pushl  0x8(%ebp)
80100b32:	e8 a9 18 00 00       	call   801023e0 <namei>
80100b37:	83 c4 10             	add    $0x10,%esp
80100b3a:	85 c0                	test   %eax,%eax
80100b3c:	0f 84 1a 05 00 00    	je     8010105c <exec+0x54c>
    end_op();
    // cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b42:	83 ec 0c             	sub    $0xc,%esp
80100b45:	89 c6                	mov    %eax,%esi
80100b47:	50                   	push   %eax
80100b48:	e8 c3 0f 00 00       	call   80101b10 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b4d:	8d 85 24 fc ff ff    	lea    -0x3dc(%ebp),%eax
80100b53:	6a 34                	push   $0x34
80100b55:	6a 00                	push   $0x0
80100b57:	50                   	push   %eax
80100b58:	56                   	push   %esi
80100b59:	e8 b2 12 00 00       	call   80101e10 <readi>
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
80100b6a:	e8 41 12 00 00       	call   80101db0 <iunlockput>
    end_op();
80100b6f:	e8 5c 29 00 00       	call   801034d0 <end_op>
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
80100ba7:	0f 8f 29 02 00 00    	jg     80100dd6 <exec+0x2c6>
  struct file* swap_file_bu = 0;
80100bad:	c7 85 ec fb ff ff 00 	movl   $0x0,-0x414(%ebp)
80100bb4:	00 00 00 
  uint pg_out_bu = 0, pg_flt_bu = 0, pg_mem_bu = 0, pg_swp_bu = 0;
80100bb7:	c7 85 dc fb ff ff 00 	movl   $0x0,-0x424(%ebp)
80100bbe:	00 00 00 
80100bc1:	c7 85 e0 fb ff ff 00 	movl   $0x0,-0x420(%ebp)
80100bc8:	00 00 00 
80100bcb:	c7 85 e4 fb ff ff 00 	movl   $0x0,-0x41c(%ebp)
80100bd2:	00 00 00 
80100bd5:	c7 85 e8 fb ff ff 00 	movl   $0x0,-0x418(%ebp)
80100bdc:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bdf:	66 83 bd 50 fc ff ff 	cmpw   $0x0,-0x3b0(%ebp)
80100be6:	00 
80100be7:	8b 9d 40 fc ff ff    	mov    -0x3c0(%ebp),%ebx
80100bed:	0f 84 43 05 00 00    	je     80101136 <exec+0x626>
80100bf3:	31 c0                	xor    %eax,%eax
80100bf5:	89 bd d8 fb ff ff    	mov    %edi,-0x428(%ebp)
  sz = 0;
80100bfb:	c7 85 f0 fb ff ff 00 	movl   $0x0,-0x410(%ebp)
80100c02:	00 00 00 
80100c05:	89 c7                	mov    %eax,%edi
80100c07:	e9 92 00 00 00       	jmp    80100c9e <exec+0x18e>
80100c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100c10:	83 bd 04 fc ff ff 01 	cmpl   $0x1,-0x3fc(%ebp)
80100c17:	75 70                	jne    80100c89 <exec+0x179>
    if(ph.memsz < ph.filesz)
80100c19:	8b 85 18 fc ff ff    	mov    -0x3e8(%ebp),%eax
80100c1f:	3b 85 14 fc ff ff    	cmp    -0x3ec(%ebp),%eax
80100c25:	0f 82 8f 00 00 00    	jb     80100cba <exec+0x1aa>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c2b:	03 85 0c fc ff ff    	add    -0x3f4(%ebp),%eax
80100c31:	0f 82 83 00 00 00    	jb     80100cba <exec+0x1aa>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c37:	83 ec 04             	sub    $0x4,%esp
80100c3a:	50                   	push   %eax
80100c3b:	ff b5 f0 fb ff ff    	pushl  -0x410(%ebp)
80100c41:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80100c47:	e8 a4 70 00 00       	call   80107cf0 <allocuvm>
80100c4c:	83 c4 10             	add    $0x10,%esp
80100c4f:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
80100c55:	85 c0                	test   %eax,%eax
80100c57:	74 61                	je     80100cba <exec+0x1aa>
    if(ph.vaddr % PGSIZE != 0)
80100c59:	8b 85 0c fc ff ff    	mov    -0x3f4(%ebp),%eax
80100c5f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c64:	75 54                	jne    80100cba <exec+0x1aa>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c66:	83 ec 0c             	sub    $0xc,%esp
80100c69:	ff b5 14 fc ff ff    	pushl  -0x3ec(%ebp)
80100c6f:	ff b5 08 fc ff ff    	pushl  -0x3f8(%ebp)
80100c75:	56                   	push   %esi
80100c76:	50                   	push   %eax
80100c77:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80100c7d:	e8 ce 69 00 00       	call   80107650 <loaduvm>
80100c82:	83 c4 20             	add    $0x20,%esp
80100c85:	85 c0                	test   %eax,%eax
80100c87:	78 31                	js     80100cba <exec+0x1aa>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c89:	0f b7 85 50 fc ff ff 	movzwl -0x3b0(%ebp),%eax
80100c90:	83 c7 01             	add    $0x1,%edi
80100c93:	83 c3 20             	add    $0x20,%ebx
80100c96:	39 f8                	cmp    %edi,%eax
80100c98:	0f 8e b6 02 00 00    	jle    80100f54 <exec+0x444>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c9e:	8d 85 04 fc ff ff    	lea    -0x3fc(%ebp),%eax
80100ca4:	6a 20                	push   $0x20
80100ca6:	53                   	push   %ebx
80100ca7:	50                   	push   %eax
80100ca8:	56                   	push   %esi
80100ca9:	e8 62 11 00 00       	call   80101e10 <readi>
80100cae:	83 c4 10             	add    $0x10,%esp
80100cb1:	83 f8 20             	cmp    $0x20,%eax
80100cb4:	0f 84 56 ff ff ff    	je     80100c10 <exec+0x100>
80100cba:	8b bd d8 fb ff ff    	mov    -0x428(%ebp),%edi
    if (curproc->pid > 2){
80100cc0:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80100cc4:	0f 8e a6 04 00 00    	jle    80101170 <exec+0x660>
      curproc->num_of_pagefaults_occurs = pg_flt_bu;
80100cca:	8b 85 e4 fb ff ff    	mov    -0x41c(%ebp),%eax
80100cd0:	8d 9d e8 fc ff ff    	lea    -0x318(%ebp),%ebx
80100cd6:	8d 8d 68 fe ff ff    	lea    -0x198(%ebp),%ecx
80100cdc:	89 87 88 03 00 00    	mov    %eax,0x388(%edi)
      curproc->num_of_actual_pages_in_mem = pg_mem_bu;
80100ce2:	8b 85 e0 fb ff ff    	mov    -0x420(%ebp),%eax
80100ce8:	89 87 84 03 00 00    	mov    %eax,0x384(%edi)
      curproc->num_of_pages_in_swap_file = pg_swp_bu;
80100cee:	8b 85 dc fb ff ff    	mov    -0x424(%ebp),%eax
80100cf4:	89 87 80 03 00 00    	mov    %eax,0x380(%edi)
      curproc->num_of_pageOut_occured = pg_out_bu;
80100cfa:	8b 85 e8 fb ff ff    	mov    -0x418(%ebp),%eax
80100d00:	89 87 8c 03 00 00    	mov    %eax,0x38c(%edi)
80100d06:	31 c0                	xor    %eax,%eax
80100d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d0f:	90                   	nop
        curproc->ram_pages[i] = mem_pginfo_bu[i];
80100d10:	8b 14 03             	mov    (%ebx,%eax,1),%edx
80100d13:	89 94 07 00 02 00 00 	mov    %edx,0x200(%edi,%eax,1)
80100d1a:	8b 54 03 04          	mov    0x4(%ebx,%eax,1),%edx
80100d1e:	89 94 07 04 02 00 00 	mov    %edx,0x204(%edi,%eax,1)
80100d25:	8b 54 03 08          	mov    0x8(%ebx,%eax,1),%edx
80100d29:	89 94 07 08 02 00 00 	mov    %edx,0x208(%edi,%eax,1)
80100d30:	8b 54 03 0c          	mov    0xc(%ebx,%eax,1),%edx
80100d34:	89 94 07 0c 02 00 00 	mov    %edx,0x20c(%edi,%eax,1)
80100d3b:	8b 54 03 10          	mov    0x10(%ebx,%eax,1),%edx
80100d3f:	89 94 07 10 02 00 00 	mov    %edx,0x210(%edi,%eax,1)
80100d46:	8b 54 03 14          	mov    0x14(%ebx,%eax,1),%edx
80100d4a:	89 94 07 14 02 00 00 	mov    %edx,0x214(%edi,%eax,1)
        curproc->swapped_out_pages[i] = swp_pginfo_bu[i];
80100d51:	8b 14 01             	mov    (%ecx,%eax,1),%edx
80100d54:	89 94 07 80 00 00 00 	mov    %edx,0x80(%edi,%eax,1)
80100d5b:	8b 54 01 04          	mov    0x4(%ecx,%eax,1),%edx
80100d5f:	89 94 07 84 00 00 00 	mov    %edx,0x84(%edi,%eax,1)
80100d66:	8b 54 01 08          	mov    0x8(%ecx,%eax,1),%edx
80100d6a:	89 94 07 88 00 00 00 	mov    %edx,0x88(%edi,%eax,1)
80100d71:	8b 54 01 0c          	mov    0xc(%ecx,%eax,1),%edx
80100d75:	89 94 07 8c 00 00 00 	mov    %edx,0x8c(%edi,%eax,1)
80100d7c:	8b 54 01 10          	mov    0x10(%ecx,%eax,1),%edx
80100d80:	89 94 07 90 00 00 00 	mov    %edx,0x90(%edi,%eax,1)
80100d87:	8b 54 01 14          	mov    0x14(%ecx,%eax,1),%edx
80100d8b:	89 94 07 94 00 00 00 	mov    %edx,0x94(%edi,%eax,1)
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100d92:	83 c0 18             	add    $0x18,%eax
80100d95:	3d 80 01 00 00       	cmp    $0x180,%eax
80100d9a:	0f 85 70 ff ff ff    	jne    80100d10 <exec+0x200>
      removeSwapFile(curproc);
80100da0:	83 ec 0c             	sub    $0xc,%esp
80100da3:	57                   	push   %edi
80100da4:	e8 07 17 00 00       	call   801024b0 <removeSwapFile>
      curproc->swapFile = swap_file_bu;
80100da9:	8b 85 ec fb ff ff    	mov    -0x414(%ebp),%eax
80100daf:	89 47 7c             	mov    %eax,0x7c(%edi)
    freevm(pgdir);
80100db2:	58                   	pop    %eax
80100db3:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80100db9:	e8 72 6a 00 00       	call   80107830 <freevm>
  if(ip){
80100dbe:	83 c4 10             	add    $0x10,%esp
80100dc1:	85 f6                	test   %esi,%esi
80100dc3:	0f 85 9d fd ff ff    	jne    80100b66 <exec+0x56>
}
80100dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80100dcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100dd1:	5b                   	pop    %ebx
80100dd2:	5e                   	pop    %esi
80100dd3:	5f                   	pop    %edi
80100dd4:	5d                   	pop    %ebp
80100dd5:	c3                   	ret    
    cprintf("EXEC HERE\n");
80100dd6:	83 ec 0c             	sub    $0xc,%esp
80100dd9:	8d 9d e8 fc ff ff    	lea    -0x318(%ebp),%ebx
80100ddf:	68 21 82 10 80       	push   $0x80108221
80100de4:	e8 c7 f8 ff ff       	call   801006b0 <cprintf>
    pg_flt_bu = curproc->num_of_pagefaults_occurs;
80100de9:	8b 87 88 03 00 00    	mov    0x388(%edi),%eax
    pg_out_bu = curproc->num_of_pageOut_occured;
80100def:	83 c4 10             	add    $0x10,%esp
80100df2:	8d 8d 68 fe ff ff    	lea    -0x198(%ebp),%ecx
    pg_flt_bu = curproc->num_of_pagefaults_occurs;
80100df8:	89 85 e4 fb ff ff    	mov    %eax,-0x41c(%ebp)
    pg_mem_bu = curproc->num_of_actual_pages_in_mem;
80100dfe:	8b 87 84 03 00 00    	mov    0x384(%edi),%eax
80100e04:	89 85 e0 fb ff ff    	mov    %eax,-0x420(%ebp)
    pg_swp_bu = curproc->num_of_pages_in_swap_file;
80100e0a:	8b 87 80 03 00 00    	mov    0x380(%edi),%eax
80100e10:	89 85 dc fb ff ff    	mov    %eax,-0x424(%ebp)
    pg_out_bu = curproc->num_of_pageOut_occured;
80100e16:	8b 87 8c 03 00 00    	mov    0x38c(%edi),%eax
80100e1c:	89 85 e8 fb ff ff    	mov    %eax,-0x418(%ebp)
80100e22:	31 c0                	xor    %eax,%eax
80100e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      mem_pginfo_bu[i] = curproc->ram_pages[i];
80100e28:	8b 94 07 00 02 00 00 	mov    0x200(%edi,%eax,1),%edx
80100e2f:	89 14 03             	mov    %edx,(%ebx,%eax,1)
80100e32:	8b 94 07 04 02 00 00 	mov    0x204(%edi,%eax,1),%edx
80100e39:	89 54 03 04          	mov    %edx,0x4(%ebx,%eax,1)
80100e3d:	8b 94 07 08 02 00 00 	mov    0x208(%edi,%eax,1),%edx
80100e44:	89 54 03 08          	mov    %edx,0x8(%ebx,%eax,1)
80100e48:	8b 94 07 0c 02 00 00 	mov    0x20c(%edi,%eax,1),%edx
80100e4f:	89 54 03 0c          	mov    %edx,0xc(%ebx,%eax,1)
80100e53:	8b 94 07 10 02 00 00 	mov    0x210(%edi,%eax,1),%edx
80100e5a:	89 54 03 10          	mov    %edx,0x10(%ebx,%eax,1)
80100e5e:	8b 94 07 14 02 00 00 	mov    0x214(%edi,%eax,1),%edx
80100e65:	89 54 03 14          	mov    %edx,0x14(%ebx,%eax,1)
      swp_pginfo_bu[i] = curproc->swapped_out_pages[i];
80100e69:	8b 94 07 80 00 00 00 	mov    0x80(%edi,%eax,1),%edx
80100e70:	89 14 01             	mov    %edx,(%ecx,%eax,1)
80100e73:	8b 94 07 84 00 00 00 	mov    0x84(%edi,%eax,1),%edx
80100e7a:	89 54 01 04          	mov    %edx,0x4(%ecx,%eax,1)
80100e7e:	8b 94 07 88 00 00 00 	mov    0x88(%edi,%eax,1),%edx
80100e85:	89 54 01 08          	mov    %edx,0x8(%ecx,%eax,1)
80100e89:	8b 94 07 8c 00 00 00 	mov    0x8c(%edi,%eax,1),%edx
80100e90:	89 54 01 0c          	mov    %edx,0xc(%ecx,%eax,1)
80100e94:	8b 94 07 90 00 00 00 	mov    0x90(%edi,%eax,1),%edx
80100e9b:	89 54 01 10          	mov    %edx,0x10(%ecx,%eax,1)
80100e9f:	8b 94 07 94 00 00 00 	mov    0x94(%edi,%eax,1),%edx
80100ea6:	89 54 01 14          	mov    %edx,0x14(%ecx,%eax,1)
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100eaa:	83 c0 18             	add    $0x18,%eax
80100ead:	3d 80 01 00 00       	cmp    $0x180,%eax
80100eb2:	0f 85 70 ff ff ff    	jne    80100e28 <exec+0x318>
  p->num_of_pageOut_occured = 0;
80100eb8:	c7 87 8c 03 00 00 00 	movl   $0x0,0x38c(%edi)
80100ebf:	00 00 00 
  p->num_of_pagefaults_occurs = 0;
80100ec2:	8d 87 80 00 00 00    	lea    0x80(%edi),%eax
80100ec8:	8d 8f 00 02 00 00    	lea    0x200(%edi),%ecx
80100ece:	c7 87 88 03 00 00 00 	movl   $0x0,0x388(%edi)
80100ed5:	00 00 00 
  p->num_of_actual_pages_in_mem = 0;
80100ed8:	c7 87 84 03 00 00 00 	movl   $0x0,0x384(%edi)
80100edf:	00 00 00 
  p->num_of_pages_in_swap_file = 0;
80100ee2:	c7 87 80 03 00 00 00 	movl   $0x0,0x380(%edi)
80100ee9:	00 00 00 
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80100ef0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80100ef6:	83 c0 18             	add    $0x18,%eax
80100ef9:	c7 80 68 01 00 00 01 	movl   $0x1,0x168(%eax)
80100f00:	00 00 00 
    p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
80100f03:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
80100f0a:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
80100f11:	00 00 00 
    p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80100f14:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
80100f1b:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
80100f22:	00 00 00 
    p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80100f25:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80100f2c:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
80100f33:	00 00 00 
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100f36:	39 c8                	cmp    %ecx,%eax
80100f38:	75 b6                	jne    80100ef0 <exec+0x3e0>
    createSwapFile(curproc);
80100f3a:	83 ec 0c             	sub    $0xc,%esp
    swap_file_bu = curproc->swapFile;
80100f3d:	8b 47 7c             	mov    0x7c(%edi),%eax
    createSwapFile(curproc);
80100f40:	57                   	push   %edi
    swap_file_bu = curproc->swapFile;
80100f41:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
    createSwapFile(curproc);
80100f47:	e8 54 17 00 00       	call   801026a0 <createSwapFile>
80100f4c:	83 c4 10             	add    $0x10,%esp
80100f4f:	e9 8b fc ff ff       	jmp    80100bdf <exec+0xcf>
80100f54:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
80100f5a:	8b bd d8 fb ff ff    	mov    -0x428(%ebp),%edi
80100f60:	05 ff 0f 00 00       	add    $0xfff,%eax
80100f65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100f6a:	8d 98 00 20 00 00    	lea    0x2000(%eax),%ebx
  iunlockput(ip);
80100f70:	83 ec 0c             	sub    $0xc,%esp
80100f73:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
80100f79:	56                   	push   %esi
80100f7a:	e8 31 0e 00 00       	call   80101db0 <iunlockput>
  end_op();
80100f7f:	e8 4c 25 00 00       	call   801034d0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100f84:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
80100f8a:	8b b5 f4 fb ff ff    	mov    -0x40c(%ebp),%esi
80100f90:	83 c4 0c             	add    $0xc,%esp
80100f93:	53                   	push   %ebx
80100f94:	50                   	push   %eax
80100f95:	56                   	push   %esi
80100f96:	e8 55 6d 00 00       	call   80107cf0 <allocuvm>
80100f9b:	83 c4 10             	add    $0x10,%esp
80100f9e:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
80100fa4:	89 c3                	mov    %eax,%ebx
80100fa6:	85 c0                	test   %eax,%eax
80100fa8:	0f 84 8b 00 00 00    	je     80101039 <exec+0x529>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100fae:	83 ec 08             	sub    $0x8,%esp
80100fb1:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100fb7:	50                   	push   %eax
80100fb8:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100fb9:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100fbb:	e8 20 6a 00 00       	call   801079e0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fc3:	83 c4 10             	add    $0x10,%esp
80100fc6:	8b 00                	mov    (%eax),%eax
80100fc8:	85 c0                	test   %eax,%eax
80100fca:	0f 84 8f 01 00 00    	je     8010115f <exec+0x64f>
80100fd0:	89 bd d8 fb ff ff    	mov    %edi,-0x428(%ebp)
80100fd6:	89 f7                	mov    %esi,%edi
80100fd8:	8b b5 f4 fb ff ff    	mov    -0x40c(%ebp),%esi
80100fde:	eb 1f                	jmp    80100fff <exec+0x4ef>
80100fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100fe3:	89 9c bd 64 fc ff ff 	mov    %ebx,-0x39c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100fea:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100fed:	8d 8d 58 fc ff ff    	lea    -0x3a8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100ff3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100ff6:	85 c0                	test   %eax,%eax
80100ff8:	74 71                	je     8010106b <exec+0x55b>
    if(argc >= MAXARG)
80100ffa:	83 ff 20             	cmp    $0x20,%edi
80100ffd:	74 34                	je     80101033 <exec+0x523>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	50                   	push   %eax
80101003:	e8 38 42 00 00       	call   80105240 <strlen>
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101008:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101009:	f7 d0                	not    %eax
8010100b:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010100d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101010:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101013:	ff 34 b8             	pushl  (%eax,%edi,4)
80101016:	e8 25 42 00 00       	call   80105240 <strlen>
8010101b:	83 c0 01             	add    $0x1,%eax
8010101e:	50                   	push   %eax
8010101f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101022:	ff 34 b8             	pushl  (%eax,%edi,4)
80101025:	53                   	push   %ebx
80101026:	56                   	push   %esi
80101027:	e8 24 6b 00 00       	call   80107b50 <copyout>
8010102c:	83 c4 20             	add    $0x20,%esp
8010102f:	85 c0                	test   %eax,%eax
80101031:	79 ad                	jns    80100fe0 <exec+0x4d0>
80101033:	8b bd d8 fb ff ff    	mov    -0x428(%ebp),%edi
    if (curproc->pid > 2){
80101039:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
8010103d:	7f 16                	jg     80101055 <exec+0x545>
    freevm(pgdir);
8010103f:	83 ec 0c             	sub    $0xc,%esp
80101042:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80101048:	e8 e3 67 00 00       	call   80107830 <freevm>
8010104d:	83 c4 10             	add    $0x10,%esp
80101050:	e9 74 fd ff ff       	jmp    80100dc9 <exec+0x2b9>
  ip = 0;
80101055:	31 f6                	xor    %esi,%esi
80101057:	e9 6e fc ff ff       	jmp    80100cca <exec+0x1ba>
    end_op();
8010105c:	e8 6f 24 00 00       	call   801034d0 <end_op>
    return -1;
80101061:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101066:	e9 11 fb ff ff       	jmp    80100b7c <exec+0x6c>
8010106b:	89 fe                	mov    %edi,%esi
8010106d:	8b bd d8 fb ff ff    	mov    -0x428(%ebp),%edi
  ustack[3+argc] = 0;
80101073:	c7 84 b5 64 fc ff ff 	movl   $0x0,-0x39c(%ebp,%esi,4)
8010107a:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010107e:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
  ustack[1] = argc;
80101085:	89 b5 5c fc ff ff    	mov    %esi,-0x3a4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010108b:	89 de                	mov    %ebx,%esi
  ustack[0] = 0xffffffff;  // fake return PC
8010108d:	c7 85 58 fc ff ff ff 	movl   $0xffffffff,-0x3a8(%ebp)
80101094:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101097:	29 c6                	sub    %eax,%esi
  sp -= (3+argc+1) * 4;
80101099:	83 c0 0c             	add    $0xc,%eax
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010109c:	89 b5 60 fc ff ff    	mov    %esi,-0x3a0(%ebp)
  sp -= (3+argc+1) * 4;
801010a2:	89 de                	mov    %ebx,%esi
801010a4:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801010a6:	50                   	push   %eax
801010a7:	51                   	push   %ecx
801010a8:	56                   	push   %esi
801010a9:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
801010af:	e8 9c 6a 00 00       	call   80107b50 <copyout>
801010b4:	83 c4 10             	add    $0x10,%esp
801010b7:	85 c0                	test   %eax,%eax
801010b9:	0f 88 7a ff ff ff    	js     80101039 <exec+0x529>
  for(last=s=path; *s; s++)
801010bf:	8b 45 08             	mov    0x8(%ebp),%eax
801010c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801010c5:	0f b6 00             	movzbl (%eax),%eax
801010c8:	84 c0                	test   %al,%al
801010ca:	74 11                	je     801010dd <exec+0x5cd>
801010cc:	89 ca                	mov    %ecx,%edx
    if(*s == '/')
801010ce:	83 c2 01             	add    $0x1,%edx
801010d1:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801010d3:	0f b6 02             	movzbl (%edx),%eax
    if(*s == '/')
801010d6:	0f 44 ca             	cmove  %edx,%ecx
  for(last=s=path; *s; s++)
801010d9:	84 c0                	test   %al,%al
801010db:	75 f1                	jne    801010ce <exec+0x5be>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801010dd:	83 ec 04             	sub    $0x4,%esp
801010e0:	8d 47 6c             	lea    0x6c(%edi),%eax
801010e3:	6a 10                	push   $0x10
801010e5:	51                   	push   %ecx
801010e6:	50                   	push   %eax
801010e7:	e8 14 41 00 00       	call   80105200 <safestrcpy>
  curproc->pgdir = pgdir;
801010ec:	8b 85 f4 fb ff ff    	mov    -0x40c(%ebp),%eax
  oldpgdir = curproc->pgdir;
801010f2:	8b 5f 04             	mov    0x4(%edi),%ebx
  if (curproc->pid > 2){
801010f5:	83 c4 10             	add    $0x10,%esp
  curproc->pgdir = pgdir;
801010f8:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
801010fb:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
80101101:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80101103:	8b 47 18             	mov    0x18(%edi),%eax
80101106:	8b 8d 3c fc ff ff    	mov    -0x3c4(%ebp),%ecx
8010110c:	89 48 38             	mov    %ecx,0x38(%eax)
  curproc->tf->esp = sp;
8010110f:	8b 47 18             	mov    0x18(%edi),%eax
80101112:	89 70 44             	mov    %esi,0x44(%eax)
  if (curproc->pid > 2){
80101115:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80101119:	7f 27                	jg     80101142 <exec+0x632>
  switchuvm(curproc);
8010111b:	83 ec 0c             	sub    $0xc,%esp
8010111e:	57                   	push   %edi
8010111f:	e8 9c 63 00 00       	call   801074c0 <switchuvm>
  freevm(oldpgdir);
80101124:	89 1c 24             	mov    %ebx,(%esp)
80101127:	e8 04 67 00 00       	call   80107830 <freevm>
  return 0;
8010112c:	83 c4 10             	add    $0x10,%esp
8010112f:	31 c0                	xor    %eax,%eax
80101131:	e9 46 fa ff ff       	jmp    80100b7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101136:	31 c0                	xor    %eax,%eax
80101138:	bb 00 20 00 00       	mov    $0x2000,%ebx
8010113d:	e9 2e fe ff ff       	jmp    80100f70 <exec+0x460>
    curproc->swapFile = swap_file_bu;
80101142:	8b 85 ec fb ff ff    	mov    -0x414(%ebp),%eax
    removeSwapFile(curproc);
80101148:	83 ec 0c             	sub    $0xc,%esp
    temp_swap_file = curproc->swapFile;
8010114b:	8b 77 7c             	mov    0x7c(%edi),%esi
    curproc->swapFile = swap_file_bu;
8010114e:	89 47 7c             	mov    %eax,0x7c(%edi)
    removeSwapFile(curproc);
80101151:	57                   	push   %edi
80101152:	e8 59 13 00 00       	call   801024b0 <removeSwapFile>
    curproc->swapFile = temp_swap_file;
80101157:	89 77 7c             	mov    %esi,0x7c(%edi)
8010115a:	83 c4 10             	add    $0x10,%esp
8010115d:	eb bc                	jmp    8010111b <exec+0x60b>
  for(argc = 0; argv[argc]; argc++) {
8010115f:	8b 9d f0 fb ff ff    	mov    -0x410(%ebp),%ebx
80101165:	8d 8d 58 fc ff ff    	lea    -0x3a8(%ebp),%ecx
8010116b:	e9 03 ff ff ff       	jmp    80101073 <exec+0x563>
    freevm(pgdir);
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80101179:	e8 b2 66 00 00       	call   80107830 <freevm>
8010117e:	83 c4 10             	add    $0x10,%esp
80101181:	e9 e0 f9 ff ff       	jmp    80100b66 <exec+0x56>
80101186:	66 90                	xchg   %ax,%ax
80101188:	66 90                	xchg   %ax,%ax
8010118a:	66 90                	xchg   %ax,%ax
8010118c:	66 90                	xchg   %ax,%ax
8010118e:	66 90                	xchg   %ax,%ax

80101190 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101190:	f3 0f 1e fb          	endbr32 
80101194:	55                   	push   %ebp
80101195:	89 e5                	mov    %esp,%ebp
80101197:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
8010119a:	68 2c 82 10 80       	push   $0x8010822c
8010119f:	68 e0 0f 11 80       	push   $0x80110fe0
801011a4:	e8 07 3c 00 00       	call   80104db0 <initlock>
}
801011a9:	83 c4 10             	add    $0x10,%esp
801011ac:	c9                   	leave  
801011ad:	c3                   	ret    
801011ae:	66 90                	xchg   %ax,%ax

801011b0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801011b0:	f3 0f 1e fb          	endbr32 
801011b4:	55                   	push   %ebp
801011b5:	89 e5                	mov    %esp,%ebp
801011b7:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011b8:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
801011bd:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801011c0:	68 e0 0f 11 80       	push   $0x80110fe0
801011c5:	e8 66 3d 00 00       	call   80104f30 <acquire>
801011ca:	83 c4 10             	add    $0x10,%esp
801011cd:	eb 0c                	jmp    801011db <filealloc+0x2b>
801011cf:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011d0:	83 c3 18             	add    $0x18,%ebx
801011d3:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
801011d9:	74 25                	je     80101200 <filealloc+0x50>
    if(f->ref == 0){
801011db:	8b 43 04             	mov    0x4(%ebx),%eax
801011de:	85 c0                	test   %eax,%eax
801011e0:	75 ee                	jne    801011d0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801011e2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801011e5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801011ec:	68 e0 0f 11 80       	push   $0x80110fe0
801011f1:	e8 fa 3d 00 00       	call   80104ff0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801011f6:	89 d8                	mov    %ebx,%eax
      return f;
801011f8:	83 c4 10             	add    $0x10,%esp
}
801011fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011fe:	c9                   	leave  
801011ff:	c3                   	ret    
  release(&ftable.lock);
80101200:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101203:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101205:	68 e0 0f 11 80       	push   $0x80110fe0
8010120a:	e8 e1 3d 00 00       	call   80104ff0 <release>
}
8010120f:	89 d8                	mov    %ebx,%eax
  return 0;
80101211:	83 c4 10             	add    $0x10,%esp
}
80101214:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101217:	c9                   	leave  
80101218:	c3                   	ret    
80101219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101220 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101220:	f3 0f 1e fb          	endbr32 
80101224:	55                   	push   %ebp
80101225:	89 e5                	mov    %esp,%ebp
80101227:	53                   	push   %ebx
80101228:	83 ec 10             	sub    $0x10,%esp
8010122b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010122e:	68 e0 0f 11 80       	push   $0x80110fe0
80101233:	e8 f8 3c 00 00       	call   80104f30 <acquire>
  if(f->ref < 1)
80101238:	8b 43 04             	mov    0x4(%ebx),%eax
8010123b:	83 c4 10             	add    $0x10,%esp
8010123e:	85 c0                	test   %eax,%eax
80101240:	7e 1a                	jle    8010125c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80101242:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101245:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101248:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
8010124b:	68 e0 0f 11 80       	push   $0x80110fe0
80101250:	e8 9b 3d 00 00       	call   80104ff0 <release>
  return f;
}
80101255:	89 d8                	mov    %ebx,%eax
80101257:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010125a:	c9                   	leave  
8010125b:	c3                   	ret    
    panic("filedup");
8010125c:	83 ec 0c             	sub    $0xc,%esp
8010125f:	68 33 82 10 80       	push   $0x80108233
80101264:	e8 27 f1 ff ff       	call   80100390 <panic>
80101269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101270 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101270:	f3 0f 1e fb          	endbr32 
80101274:	55                   	push   %ebp
80101275:	89 e5                	mov    %esp,%ebp
80101277:	57                   	push   %edi
80101278:	56                   	push   %esi
80101279:	53                   	push   %ebx
8010127a:	83 ec 28             	sub    $0x28,%esp
8010127d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101280:	68 e0 0f 11 80       	push   $0x80110fe0
80101285:	e8 a6 3c 00 00       	call   80104f30 <acquire>
  if(f->ref < 1)
8010128a:	8b 53 04             	mov    0x4(%ebx),%edx
8010128d:	83 c4 10             	add    $0x10,%esp
80101290:	85 d2                	test   %edx,%edx
80101292:	0f 8e a1 00 00 00    	jle    80101339 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101298:	83 ea 01             	sub    $0x1,%edx
8010129b:	89 53 04             	mov    %edx,0x4(%ebx)
8010129e:	75 40                	jne    801012e0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801012a0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801012a4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801012a7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801012a9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801012af:	8b 73 0c             	mov    0xc(%ebx),%esi
801012b2:	88 45 e7             	mov    %al,-0x19(%ebp)
801012b5:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801012b8:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
801012bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801012c0:	e8 2b 3d 00 00       	call   80104ff0 <release>

  if(ff.type == FD_PIPE)
801012c5:	83 c4 10             	add    $0x10,%esp
801012c8:	83 ff 01             	cmp    $0x1,%edi
801012cb:	74 53                	je     80101320 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801012cd:	83 ff 02             	cmp    $0x2,%edi
801012d0:	74 26                	je     801012f8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801012d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d5:	5b                   	pop    %ebx
801012d6:	5e                   	pop    %esi
801012d7:	5f                   	pop    %edi
801012d8:	5d                   	pop    %ebp
801012d9:	c3                   	ret    
801012da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
801012e0:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
}
801012e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ea:	5b                   	pop    %ebx
801012eb:	5e                   	pop    %esi
801012ec:	5f                   	pop    %edi
801012ed:	5d                   	pop    %ebp
    release(&ftable.lock);
801012ee:	e9 fd 3c 00 00       	jmp    80104ff0 <release>
801012f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012f7:	90                   	nop
    begin_op();
801012f8:	e8 63 21 00 00       	call   80103460 <begin_op>
    iput(ff.ip);
801012fd:	83 ec 0c             	sub    $0xc,%esp
80101300:	ff 75 e0             	pushl  -0x20(%ebp)
80101303:	e8 38 09 00 00       	call   80101c40 <iput>
    end_op();
80101308:	83 c4 10             	add    $0x10,%esp
}
8010130b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130e:	5b                   	pop    %ebx
8010130f:	5e                   	pop    %esi
80101310:	5f                   	pop    %edi
80101311:	5d                   	pop    %ebp
    end_op();
80101312:	e9 b9 21 00 00       	jmp    801034d0 <end_op>
80101317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010131e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101320:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101324:	83 ec 08             	sub    $0x8,%esp
80101327:	53                   	push   %ebx
80101328:	56                   	push   %esi
80101329:	e8 02 29 00 00       	call   80103c30 <pipeclose>
8010132e:	83 c4 10             	add    $0x10,%esp
}
80101331:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101334:	5b                   	pop    %ebx
80101335:	5e                   	pop    %esi
80101336:	5f                   	pop    %edi
80101337:	5d                   	pop    %ebp
80101338:	c3                   	ret    
    panic("fileclose");
80101339:	83 ec 0c             	sub    $0xc,%esp
8010133c:	68 3b 82 10 80       	push   $0x8010823b
80101341:	e8 4a f0 ff ff       	call   80100390 <panic>
80101346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134d:	8d 76 00             	lea    0x0(%esi),%esi

80101350 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101350:	f3 0f 1e fb          	endbr32 
80101354:	55                   	push   %ebp
80101355:	89 e5                	mov    %esp,%ebp
80101357:	53                   	push   %ebx
80101358:	83 ec 04             	sub    $0x4,%esp
8010135b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010135e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101361:	75 2d                	jne    80101390 <filestat+0x40>
    ilock(f->ip);
80101363:	83 ec 0c             	sub    $0xc,%esp
80101366:	ff 73 10             	pushl  0x10(%ebx)
80101369:	e8 a2 07 00 00       	call   80101b10 <ilock>
    stati(f->ip, st);
8010136e:	58                   	pop    %eax
8010136f:	5a                   	pop    %edx
80101370:	ff 75 0c             	pushl  0xc(%ebp)
80101373:	ff 73 10             	pushl  0x10(%ebx)
80101376:	e8 65 0a 00 00       	call   80101de0 <stati>
    iunlock(f->ip);
8010137b:	59                   	pop    %ecx
8010137c:	ff 73 10             	pushl  0x10(%ebx)
8010137f:	e8 6c 08 00 00       	call   80101bf0 <iunlock>
    return 0;
  }
  return -1;
}
80101384:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101387:	83 c4 10             	add    $0x10,%esp
8010138a:	31 c0                	xor    %eax,%eax
}
8010138c:	c9                   	leave  
8010138d:	c3                   	ret    
8010138e:	66 90                	xchg   %ax,%ax
80101390:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101398:	c9                   	leave  
80101399:	c3                   	ret    
8010139a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013a0 <fileread>:

// Read from file f.
int
fileread(struct file* f, char *addr, int n)
{
801013a0:	f3 0f 1e fb          	endbr32 
801013a4:	55                   	push   %ebp
801013a5:	89 e5                	mov    %esp,%ebp
801013a7:	57                   	push   %edi
801013a8:	56                   	push   %esi
801013a9:	53                   	push   %ebx
801013aa:	83 ec 0c             	sub    $0xc,%esp
801013ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
801013b0:	8b 75 0c             	mov    0xc(%ebp),%esi
801013b3:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801013b6:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801013ba:	74 64                	je     80101420 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
801013bc:	8b 03                	mov    (%ebx),%eax
801013be:	83 f8 01             	cmp    $0x1,%eax
801013c1:	74 45                	je     80101408 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801013c3:	83 f8 02             	cmp    $0x2,%eax
801013c6:	75 5f                	jne    80101427 <fileread+0x87>
    ilock(f->ip);
801013c8:	83 ec 0c             	sub    $0xc,%esp
801013cb:	ff 73 10             	pushl  0x10(%ebx)
801013ce:	e8 3d 07 00 00       	call   80101b10 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801013d3:	57                   	push   %edi
801013d4:	ff 73 14             	pushl  0x14(%ebx)
801013d7:	56                   	push   %esi
801013d8:	ff 73 10             	pushl  0x10(%ebx)
801013db:	e8 30 0a 00 00       	call   80101e10 <readi>
801013e0:	83 c4 20             	add    $0x20,%esp
801013e3:	89 c6                	mov    %eax,%esi
801013e5:	85 c0                	test   %eax,%eax
801013e7:	7e 03                	jle    801013ec <fileread+0x4c>
      f->off += r;
801013e9:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801013ec:	83 ec 0c             	sub    $0xc,%esp
801013ef:	ff 73 10             	pushl  0x10(%ebx)
801013f2:	e8 f9 07 00 00       	call   80101bf0 <iunlock>
    return r;
801013f7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013fd:	89 f0                	mov    %esi,%eax
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5f                   	pop    %edi
80101402:	5d                   	pop    %ebp
80101403:	c3                   	ret    
80101404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101408:	8b 43 0c             	mov    0xc(%ebx),%eax
8010140b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010140e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101411:	5b                   	pop    %ebx
80101412:	5e                   	pop    %esi
80101413:	5f                   	pop    %edi
80101414:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101415:	e9 b6 29 00 00       	jmp    80103dd0 <piperead>
8010141a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101420:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101425:	eb d3                	jmp    801013fa <fileread+0x5a>
  panic("fileread");
80101427:	83 ec 0c             	sub    $0xc,%esp
8010142a:	68 45 82 10 80       	push   $0x80108245
8010142f:	e8 5c ef ff ff       	call   80100390 <panic>
80101434:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010143b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010143f:	90                   	nop

80101440 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101440:	f3 0f 1e fb          	endbr32 
80101444:	55                   	push   %ebp
80101445:	89 e5                	mov    %esp,%ebp
80101447:	57                   	push   %edi
80101448:	56                   	push   %esi
80101449:	53                   	push   %ebx
8010144a:	83 ec 1c             	sub    $0x1c,%esp
8010144d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101450:	8b 75 08             	mov    0x8(%ebp),%esi
80101453:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101456:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101459:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010145d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101460:	0f 84 c1 00 00 00    	je     80101527 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101466:	8b 06                	mov    (%esi),%eax
80101468:	83 f8 01             	cmp    $0x1,%eax
8010146b:	0f 84 c3 00 00 00    	je     80101534 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101471:	83 f8 02             	cmp    $0x2,%eax
80101474:	0f 85 cc 00 00 00    	jne    80101546 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010147a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010147d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010147f:	85 c0                	test   %eax,%eax
80101481:	7f 34                	jg     801014b7 <filewrite+0x77>
80101483:	e9 98 00 00 00       	jmp    80101520 <filewrite+0xe0>
80101488:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101490:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101493:	83 ec 0c             	sub    $0xc,%esp
80101496:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101499:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010149c:	e8 4f 07 00 00       	call   80101bf0 <iunlock>
      end_op();
801014a1:	e8 2a 20 00 00       	call   801034d0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801014a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801014a9:	83 c4 10             	add    $0x10,%esp
801014ac:	39 c3                	cmp    %eax,%ebx
801014ae:	75 60                	jne    80101510 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
801014b0:	01 df                	add    %ebx,%edi
    while(i < n){
801014b2:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801014b5:	7e 69                	jle    80101520 <filewrite+0xe0>
      int n1 = n - i;
801014b7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801014ba:	b8 00 06 00 00       	mov    $0x600,%eax
801014bf:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
801014c1:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801014c7:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801014ca:	e8 91 1f 00 00       	call   80103460 <begin_op>
      ilock(f->ip);
801014cf:	83 ec 0c             	sub    $0xc,%esp
801014d2:	ff 76 10             	pushl  0x10(%esi)
801014d5:	e8 36 06 00 00       	call   80101b10 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801014da:	8b 45 dc             	mov    -0x24(%ebp),%eax
801014dd:	53                   	push   %ebx
801014de:	ff 76 14             	pushl  0x14(%esi)
801014e1:	01 f8                	add    %edi,%eax
801014e3:	50                   	push   %eax
801014e4:	ff 76 10             	pushl  0x10(%esi)
801014e7:	e8 24 0a 00 00       	call   80101f10 <writei>
801014ec:	83 c4 20             	add    $0x20,%esp
801014ef:	85 c0                	test   %eax,%eax
801014f1:	7f 9d                	jg     80101490 <filewrite+0x50>
      iunlock(f->ip);
801014f3:	83 ec 0c             	sub    $0xc,%esp
801014f6:	ff 76 10             	pushl  0x10(%esi)
801014f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801014fc:	e8 ef 06 00 00       	call   80101bf0 <iunlock>
      end_op();
80101501:	e8 ca 1f 00 00       	call   801034d0 <end_op>
      if(r < 0)
80101506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101509:	83 c4 10             	add    $0x10,%esp
8010150c:	85 c0                	test   %eax,%eax
8010150e:	75 17                	jne    80101527 <filewrite+0xe7>
        panic("short filewrite");
80101510:	83 ec 0c             	sub    $0xc,%esp
80101513:	68 4e 82 10 80       	push   $0x8010824e
80101518:	e8 73 ee ff ff       	call   80100390 <panic>
8010151d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101520:	89 f8                	mov    %edi,%eax
80101522:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101525:	74 05                	je     8010152c <filewrite+0xec>
80101527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010152c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152f:	5b                   	pop    %ebx
80101530:	5e                   	pop    %esi
80101531:	5f                   	pop    %edi
80101532:	5d                   	pop    %ebp
80101533:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101534:	8b 46 0c             	mov    0xc(%esi),%eax
80101537:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010153a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010153d:	5b                   	pop    %ebx
8010153e:	5e                   	pop    %esi
8010153f:	5f                   	pop    %edi
80101540:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101541:	e9 8a 27 00 00       	jmp    80103cd0 <pipewrite>
  panic("filewrite");
80101546:	83 ec 0c             	sub    $0xc,%esp
80101549:	68 54 82 10 80       	push   $0x80108254
8010154e:	e8 3d ee ff ff       	call   80100390 <panic>
80101553:	66 90                	xchg   %ax,%ax
80101555:	66 90                	xchg   %ax,%ax
80101557:	66 90                	xchg   %ax,%ax
80101559:	66 90                	xchg   %ax,%ax
8010155b:	66 90                	xchg   %ax,%ax
8010155d:	66 90                	xchg   %ax,%ax
8010155f:	90                   	nop

80101560 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101560:	55                   	push   %ebp
80101561:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101563:	89 d0                	mov    %edx,%eax
80101565:	c1 e8 0c             	shr    $0xc,%eax
80101568:	03 05 f8 19 11 80    	add    0x801119f8,%eax
{
8010156e:	89 e5                	mov    %esp,%ebp
80101570:	56                   	push   %esi
80101571:	53                   	push   %ebx
80101572:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101574:	83 ec 08             	sub    $0x8,%esp
80101577:	50                   	push   %eax
80101578:	51                   	push   %ecx
80101579:	e8 52 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010157e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101580:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101583:	ba 01 00 00 00       	mov    $0x1,%edx
80101588:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010158b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101591:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101594:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101596:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010159b:	85 d1                	test   %edx,%ecx
8010159d:	74 25                	je     801015c4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010159f:	f7 d2                	not    %edx
  log_write(bp);
801015a1:	83 ec 0c             	sub    $0xc,%esp
801015a4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801015a6:	21 ca                	and    %ecx,%edx
801015a8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801015ac:	50                   	push   %eax
801015ad:	e8 8e 20 00 00       	call   80103640 <log_write>
  brelse(bp);
801015b2:	89 34 24             	mov    %esi,(%esp)
801015b5:	e8 36 ec ff ff       	call   801001f0 <brelse>
}
801015ba:	83 c4 10             	add    $0x10,%esp
801015bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015c0:	5b                   	pop    %ebx
801015c1:	5e                   	pop    %esi
801015c2:	5d                   	pop    %ebp
801015c3:	c3                   	ret    
    panic("freeing free block");
801015c4:	83 ec 0c             	sub    $0xc,%esp
801015c7:	68 5e 82 10 80       	push   $0x8010825e
801015cc:	e8 bf ed ff ff       	call   80100390 <panic>
801015d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015df:	90                   	nop

801015e0 <balloc>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	57                   	push   %edi
801015e4:	56                   	push   %esi
801015e5:	53                   	push   %ebx
801015e6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801015e9:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
{
801015ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801015f2:	85 c9                	test   %ecx,%ecx
801015f4:	0f 84 87 00 00 00    	je     80101681 <balloc+0xa1>
801015fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101601:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101604:	83 ec 08             	sub    $0x8,%esp
80101607:	89 f0                	mov    %esi,%eax
80101609:	c1 f8 0c             	sar    $0xc,%eax
8010160c:	03 05 f8 19 11 80    	add    0x801119f8,%eax
80101612:	50                   	push   %eax
80101613:	ff 75 d8             	pushl  -0x28(%ebp)
80101616:	e8 b5 ea ff ff       	call   801000d0 <bread>
8010161b:	83 c4 10             	add    $0x10,%esp
8010161e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101621:	a1 e0 19 11 80       	mov    0x801119e0,%eax
80101626:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101629:	31 c0                	xor    %eax,%eax
8010162b:	eb 2f                	jmp    8010165c <balloc+0x7c>
8010162d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101630:	89 c1                	mov    %eax,%ecx
80101632:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101637:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010163a:	83 e1 07             	and    $0x7,%ecx
8010163d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010163f:	89 c1                	mov    %eax,%ecx
80101641:	c1 f9 03             	sar    $0x3,%ecx
80101644:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101649:	89 fa                	mov    %edi,%edx
8010164b:	85 df                	test   %ebx,%edi
8010164d:	74 41                	je     80101690 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010164f:	83 c0 01             	add    $0x1,%eax
80101652:	83 c6 01             	add    $0x1,%esi
80101655:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010165a:	74 05                	je     80101661 <balloc+0x81>
8010165c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010165f:	77 cf                	ja     80101630 <balloc+0x50>
    brelse(bp);
80101661:	83 ec 0c             	sub    $0xc,%esp
80101664:	ff 75 e4             	pushl  -0x1c(%ebp)
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010166c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101673:	83 c4 10             	add    $0x10,%esp
80101676:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101679:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
8010167f:	77 80                	ja     80101601 <balloc+0x21>
  panic("balloc: out of blocks");
80101681:	83 ec 0c             	sub    $0xc,%esp
80101684:	68 71 82 10 80       	push   $0x80108271
80101689:	e8 02 ed ff ff       	call   80100390 <panic>
8010168e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101690:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101693:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101696:	09 da                	or     %ebx,%edx
80101698:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010169c:	57                   	push   %edi
8010169d:	e8 9e 1f 00 00       	call   80103640 <log_write>
        brelse(bp);
801016a2:	89 3c 24             	mov    %edi,(%esp)
801016a5:	e8 46 eb ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801016aa:	58                   	pop    %eax
801016ab:	5a                   	pop    %edx
801016ac:	56                   	push   %esi
801016ad:	ff 75 d8             	pushl  -0x28(%ebp)
801016b0:	e8 1b ea ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801016b5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801016b8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801016ba:	8d 40 5c             	lea    0x5c(%eax),%eax
801016bd:	68 00 02 00 00       	push   $0x200
801016c2:	6a 00                	push   $0x0
801016c4:	50                   	push   %eax
801016c5:	e8 76 39 00 00       	call   80105040 <memset>
  log_write(bp);
801016ca:	89 1c 24             	mov    %ebx,(%esp)
801016cd:	e8 6e 1f 00 00       	call   80103640 <log_write>
  brelse(bp);
801016d2:	89 1c 24             	mov    %ebx,(%esp)
801016d5:	e8 16 eb ff ff       	call   801001f0 <brelse>
}
801016da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016dd:	89 f0                	mov    %esi,%eax
801016df:	5b                   	pop    %ebx
801016e0:	5e                   	pop    %esi
801016e1:	5f                   	pop    %edi
801016e2:	5d                   	pop    %ebp
801016e3:	c3                   	ret    
801016e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801016ef:	90                   	nop

801016f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	57                   	push   %edi
801016f4:	89 c7                	mov    %eax,%edi
801016f6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801016f7:	31 f6                	xor    %esi,%esi
{
801016f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016fa:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
801016ff:	83 ec 28             	sub    $0x28,%esp
80101702:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101705:	68 00 1a 11 80       	push   $0x80111a00
8010170a:	e8 21 38 00 00       	call   80104f30 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010170f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101712:	83 c4 10             	add    $0x10,%esp
80101715:	eb 1b                	jmp    80101732 <iget+0x42>
80101717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010171e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101720:	39 3b                	cmp    %edi,(%ebx)
80101722:	74 6c                	je     80101790 <iget+0xa0>
80101724:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010172a:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
80101730:	73 26                	jae    80101758 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101732:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101735:	85 c9                	test   %ecx,%ecx
80101737:	7f e7                	jg     80101720 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101739:	85 f6                	test   %esi,%esi
8010173b:	75 e7                	jne    80101724 <iget+0x34>
8010173d:	89 d8                	mov    %ebx,%eax
8010173f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101745:	85 c9                	test   %ecx,%ecx
80101747:	75 6e                	jne    801017b7 <iget+0xc7>
80101749:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010174b:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
80101751:	72 df                	jb     80101732 <iget+0x42>
80101753:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101757:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101758:	85 f6                	test   %esi,%esi
8010175a:	74 73                	je     801017cf <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010175c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010175f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101761:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101764:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010176b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101772:	68 00 1a 11 80       	push   $0x80111a00
80101777:	e8 74 38 00 00       	call   80104ff0 <release>

  return ip;
8010177c:	83 c4 10             	add    $0x10,%esp
}
8010177f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101782:	89 f0                	mov    %esi,%eax
80101784:	5b                   	pop    %ebx
80101785:	5e                   	pop    %esi
80101786:	5f                   	pop    %edi
80101787:	5d                   	pop    %ebp
80101788:	c3                   	ret    
80101789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101790:	39 53 04             	cmp    %edx,0x4(%ebx)
80101793:	75 8f                	jne    80101724 <iget+0x34>
      release(&icache.lock);
80101795:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101798:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010179b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010179d:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
801017a2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801017a5:	e8 46 38 00 00       	call   80104ff0 <release>
      return ip;
801017aa:	83 c4 10             	add    $0x10,%esp
}
801017ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017b0:	89 f0                	mov    %esi,%eax
801017b2:	5b                   	pop    %ebx
801017b3:	5e                   	pop    %esi
801017b4:	5f                   	pop    %edi
801017b5:	5d                   	pop    %ebp
801017b6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017b7:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801017bd:	73 10                	jae    801017cf <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017bf:	8b 4b 08             	mov    0x8(%ebx),%ecx
801017c2:	85 c9                	test   %ecx,%ecx
801017c4:	0f 8f 56 ff ff ff    	jg     80101720 <iget+0x30>
801017ca:	e9 6e ff ff ff       	jmp    8010173d <iget+0x4d>
    panic("iget: no inodes");
801017cf:	83 ec 0c             	sub    $0xc,%esp
801017d2:	68 87 82 10 80       	push   $0x80108287
801017d7:	e8 b4 eb ff ff       	call   80100390 <panic>
801017dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	89 c6                	mov    %eax,%esi
801017e7:	53                   	push   %ebx
801017e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801017eb:	83 fa 0b             	cmp    $0xb,%edx
801017ee:	0f 86 84 00 00 00    	jbe    80101878 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801017f4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801017f7:	83 fb 7f             	cmp    $0x7f,%ebx
801017fa:	0f 87 98 00 00 00    	ja     80101898 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101800:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101806:	8b 16                	mov    (%esi),%edx
80101808:	85 c0                	test   %eax,%eax
8010180a:	74 54                	je     80101860 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010180c:	83 ec 08             	sub    $0x8,%esp
8010180f:	50                   	push   %eax
80101810:	52                   	push   %edx
80101811:	e8 ba e8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101816:	83 c4 10             	add    $0x10,%esp
80101819:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010181d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010181f:	8b 1a                	mov    (%edx),%ebx
80101821:	85 db                	test   %ebx,%ebx
80101823:	74 1b                	je     80101840 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101825:	83 ec 0c             	sub    $0xc,%esp
80101828:	57                   	push   %edi
80101829:	e8 c2 e9 ff ff       	call   801001f0 <brelse>
    return addr;
8010182e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101831:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101834:	89 d8                	mov    %ebx,%eax
80101836:	5b                   	pop    %ebx
80101837:	5e                   	pop    %esi
80101838:	5f                   	pop    %edi
80101839:	5d                   	pop    %ebp
8010183a:	c3                   	ret    
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101840:	8b 06                	mov    (%esi),%eax
80101842:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101845:	e8 96 fd ff ff       	call   801015e0 <balloc>
8010184a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010184d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101850:	89 c3                	mov    %eax,%ebx
80101852:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101854:	57                   	push   %edi
80101855:	e8 e6 1d 00 00       	call   80103640 <log_write>
8010185a:	83 c4 10             	add    $0x10,%esp
8010185d:	eb c6                	jmp    80101825 <bmap+0x45>
8010185f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101860:	89 d0                	mov    %edx,%eax
80101862:	e8 79 fd ff ff       	call   801015e0 <balloc>
80101867:	8b 16                	mov    (%esi),%edx
80101869:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010186f:	eb 9b                	jmp    8010180c <bmap+0x2c>
80101871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101878:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010187b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010187e:	85 db                	test   %ebx,%ebx
80101880:	75 af                	jne    80101831 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101882:	8b 00                	mov    (%eax),%eax
80101884:	e8 57 fd ff ff       	call   801015e0 <balloc>
80101889:	89 47 5c             	mov    %eax,0x5c(%edi)
8010188c:	89 c3                	mov    %eax,%ebx
}
8010188e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101891:	89 d8                	mov    %ebx,%eax
80101893:	5b                   	pop    %ebx
80101894:	5e                   	pop    %esi
80101895:	5f                   	pop    %edi
80101896:	5d                   	pop    %ebp
80101897:	c3                   	ret    
  panic("bmap: out of range");
80101898:	83 ec 0c             	sub    $0xc,%esp
8010189b:	68 97 82 10 80       	push   $0x80108297
801018a0:	e8 eb ea ff ff       	call   80100390 <panic>
801018a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018b0 <readsb>:
{
801018b0:	f3 0f 1e fb          	endbr32 
801018b4:	55                   	push   %ebp
801018b5:	89 e5                	mov    %esp,%ebp
801018b7:	56                   	push   %esi
801018b8:	53                   	push   %ebx
801018b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801018bc:	83 ec 08             	sub    $0x8,%esp
801018bf:	6a 01                	push   $0x1
801018c1:	ff 75 08             	pushl  0x8(%ebp)
801018c4:	e8 07 e8 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801018c9:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801018cc:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801018ce:	8d 40 5c             	lea    0x5c(%eax),%eax
801018d1:	6a 1c                	push   $0x1c
801018d3:	50                   	push   %eax
801018d4:	56                   	push   %esi
801018d5:	e8 06 38 00 00       	call   801050e0 <memmove>
  brelse(bp);
801018da:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018dd:	83 c4 10             	add    $0x10,%esp
}
801018e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018e3:	5b                   	pop    %ebx
801018e4:	5e                   	pop    %esi
801018e5:	5d                   	pop    %ebp
  brelse(bp);
801018e6:	e9 05 e9 ff ff       	jmp    801001f0 <brelse>
801018eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018ef:	90                   	nop

801018f0 <iinit>:
{
801018f0:	f3 0f 1e fb          	endbr32 
801018f4:	55                   	push   %ebp
801018f5:	89 e5                	mov    %esp,%ebp
801018f7:	53                   	push   %ebx
801018f8:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
801018fd:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101900:	68 aa 82 10 80       	push   $0x801082aa
80101905:	68 00 1a 11 80       	push   $0x80111a00
8010190a:	e8 a1 34 00 00       	call   80104db0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101918:	83 ec 08             	sub    $0x8,%esp
8010191b:	68 b1 82 10 80       	push   $0x801082b1
80101920:	53                   	push   %ebx
80101921:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101927:	e8 44 33 00 00       	call   80104c70 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010192c:	83 c4 10             	add    $0x10,%esp
8010192f:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
80101935:	75 e1                	jne    80101918 <iinit+0x28>
  readsb(dev, &sb);
80101937:	83 ec 08             	sub    $0x8,%esp
8010193a:	68 e0 19 11 80       	push   $0x801119e0
8010193f:	ff 75 08             	pushl  0x8(%ebp)
80101942:	e8 69 ff ff ff       	call   801018b0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101947:	ff 35 f8 19 11 80    	pushl  0x801119f8
8010194d:	ff 35 f4 19 11 80    	pushl  0x801119f4
80101953:	ff 35 f0 19 11 80    	pushl  0x801119f0
80101959:	ff 35 ec 19 11 80    	pushl  0x801119ec
8010195f:	ff 35 e8 19 11 80    	pushl  0x801119e8
80101965:	ff 35 e4 19 11 80    	pushl  0x801119e4
8010196b:	ff 35 e0 19 11 80    	pushl  0x801119e0
80101971:	68 5c 83 10 80       	push   $0x8010835c
80101976:	e8 35 ed ff ff       	call   801006b0 <cprintf>
}
8010197b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010197e:	83 c4 30             	add    $0x30,%esp
80101981:	c9                   	leave  
80101982:	c3                   	ret    
80101983:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010198a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101990 <ialloc>:
{
80101990:	f3 0f 1e fb          	endbr32 
80101994:	55                   	push   %ebp
80101995:	89 e5                	mov    %esp,%ebp
80101997:	57                   	push   %edi
80101998:	56                   	push   %esi
80101999:	53                   	push   %ebx
8010199a:	83 ec 1c             	sub    $0x1c,%esp
8010199d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801019a0:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
{
801019a7:	8b 75 08             	mov    0x8(%ebp),%esi
801019aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801019ad:	0f 86 8d 00 00 00    	jbe    80101a40 <ialloc+0xb0>
801019b3:	bf 01 00 00 00       	mov    $0x1,%edi
801019b8:	eb 1d                	jmp    801019d7 <ialloc+0x47>
801019ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
801019c0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801019c3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801019c6:	53                   	push   %ebx
801019c7:	e8 24 e8 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801019cc:	83 c4 10             	add    $0x10,%esp
801019cf:	3b 3d e8 19 11 80    	cmp    0x801119e8,%edi
801019d5:	73 69                	jae    80101a40 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801019d7:	89 f8                	mov    %edi,%eax
801019d9:	83 ec 08             	sub    $0x8,%esp
801019dc:	c1 e8 03             	shr    $0x3,%eax
801019df:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801019e5:	50                   	push   %eax
801019e6:	56                   	push   %esi
801019e7:	e8 e4 e6 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801019ec:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801019ef:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801019f1:	89 f8                	mov    %edi,%eax
801019f3:	83 e0 07             	and    $0x7,%eax
801019f6:	c1 e0 06             	shl    $0x6,%eax
801019f9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801019fd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101a01:	75 bd                	jne    801019c0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101a03:	83 ec 04             	sub    $0x4,%esp
80101a06:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101a09:	6a 40                	push   $0x40
80101a0b:	6a 00                	push   $0x0
80101a0d:	51                   	push   %ecx
80101a0e:	e8 2d 36 00 00       	call   80105040 <memset>
      dip->type = type;
80101a13:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101a17:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a1a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101a1d:	89 1c 24             	mov    %ebx,(%esp)
80101a20:	e8 1b 1c 00 00       	call   80103640 <log_write>
      brelse(bp);
80101a25:	89 1c 24             	mov    %ebx,(%esp)
80101a28:	e8 c3 e7 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101a2d:	83 c4 10             	add    $0x10,%esp
}
80101a30:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101a33:	89 fa                	mov    %edi,%edx
}
80101a35:	5b                   	pop    %ebx
      return iget(dev, inum);
80101a36:	89 f0                	mov    %esi,%eax
}
80101a38:	5e                   	pop    %esi
80101a39:	5f                   	pop    %edi
80101a3a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101a3b:	e9 b0 fc ff ff       	jmp    801016f0 <iget>
  panic("ialloc: no inodes");
80101a40:	83 ec 0c             	sub    $0xc,%esp
80101a43:	68 b7 82 10 80       	push   $0x801082b7
80101a48:	e8 43 e9 ff ff       	call   80100390 <panic>
80101a4d:	8d 76 00             	lea    0x0(%esi),%esi

80101a50 <iupdate>:
{
80101a50:	f3 0f 1e fb          	endbr32 
80101a54:	55                   	push   %ebp
80101a55:	89 e5                	mov    %esp,%ebp
80101a57:	56                   	push   %esi
80101a58:	53                   	push   %ebx
80101a59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a5c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a5f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a62:	83 ec 08             	sub    $0x8,%esp
80101a65:	c1 e8 03             	shr    $0x3,%eax
80101a68:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101a6e:	50                   	push   %eax
80101a6f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101a72:	e8 59 e6 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101a77:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a7b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a7e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a80:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101a83:	83 e0 07             	and    $0x7,%eax
80101a86:	c1 e0 06             	shl    $0x6,%eax
80101a89:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101a8d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101a90:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a94:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101a97:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101a9b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101a9f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101aa3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101aa7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101aab:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101aae:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101ab1:	6a 34                	push   $0x34
80101ab3:	53                   	push   %ebx
80101ab4:	50                   	push   %eax
80101ab5:	e8 26 36 00 00       	call   801050e0 <memmove>
  log_write(bp);
80101aba:	89 34 24             	mov    %esi,(%esp)
80101abd:	e8 7e 1b 00 00       	call   80103640 <log_write>
  brelse(bp);
80101ac2:	89 75 08             	mov    %esi,0x8(%ebp)
80101ac5:	83 c4 10             	add    $0x10,%esp
}
80101ac8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101acb:	5b                   	pop    %ebx
80101acc:	5e                   	pop    %esi
80101acd:	5d                   	pop    %ebp
  brelse(bp);
80101ace:	e9 1d e7 ff ff       	jmp    801001f0 <brelse>
80101ad3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ae0 <idup>:
{
80101ae0:	f3 0f 1e fb          	endbr32 
80101ae4:	55                   	push   %ebp
80101ae5:	89 e5                	mov    %esp,%ebp
80101ae7:	53                   	push   %ebx
80101ae8:	83 ec 10             	sub    $0x10,%esp
80101aeb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101aee:	68 00 1a 11 80       	push   $0x80111a00
80101af3:	e8 38 34 00 00       	call   80104f30 <acquire>
  ip->ref++;
80101af8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101afc:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101b03:	e8 e8 34 00 00       	call   80104ff0 <release>
}
80101b08:	89 d8                	mov    %ebx,%eax
80101b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b0d:	c9                   	leave  
80101b0e:	c3                   	ret    
80101b0f:	90                   	nop

80101b10 <ilock>:
{
80101b10:	f3 0f 1e fb          	endbr32 
80101b14:	55                   	push   %ebp
80101b15:	89 e5                	mov    %esp,%ebp
80101b17:	56                   	push   %esi
80101b18:	53                   	push   %ebx
80101b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101b1c:	85 db                	test   %ebx,%ebx
80101b1e:	0f 84 b3 00 00 00    	je     80101bd7 <ilock+0xc7>
80101b24:	8b 53 08             	mov    0x8(%ebx),%edx
80101b27:	85 d2                	test   %edx,%edx
80101b29:	0f 8e a8 00 00 00    	jle    80101bd7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101b2f:	83 ec 0c             	sub    $0xc,%esp
80101b32:	8d 43 0c             	lea    0xc(%ebx),%eax
80101b35:	50                   	push   %eax
80101b36:	e8 75 31 00 00       	call   80104cb0 <acquiresleep>
  if(ip->valid == 0){
80101b3b:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101b3e:	83 c4 10             	add    $0x10,%esp
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0b                	je     80101b50 <ilock+0x40>
}
80101b45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b48:	5b                   	pop    %ebx
80101b49:	5e                   	pop    %esi
80101b4a:	5d                   	pop    %ebp
80101b4b:	c3                   	ret    
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b50:	8b 43 04             	mov    0x4(%ebx),%eax
80101b53:	83 ec 08             	sub    $0x8,%esp
80101b56:	c1 e8 03             	shr    $0x3,%eax
80101b59:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101b5f:	50                   	push   %eax
80101b60:	ff 33                	pushl  (%ebx)
80101b62:	e8 69 e5 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b67:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b6a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b6c:	8b 43 04             	mov    0x4(%ebx),%eax
80101b6f:	83 e0 07             	and    $0x7,%eax
80101b72:	c1 e0 06             	shl    $0x6,%eax
80101b75:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101b79:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b7c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101b7f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101b83:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101b87:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101b8b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101b8f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101b93:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101b97:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101b9b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101b9e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ba1:	6a 34                	push   $0x34
80101ba3:	50                   	push   %eax
80101ba4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101ba7:	50                   	push   %eax
80101ba8:	e8 33 35 00 00       	call   801050e0 <memmove>
    brelse(bp);
80101bad:	89 34 24             	mov    %esi,(%esp)
80101bb0:	e8 3b e6 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101bb5:	83 c4 10             	add    $0x10,%esp
80101bb8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101bbd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101bc4:	0f 85 7b ff ff ff    	jne    80101b45 <ilock+0x35>
      panic("ilock: no type");
80101bca:	83 ec 0c             	sub    $0xc,%esp
80101bcd:	68 cf 82 10 80       	push   $0x801082cf
80101bd2:	e8 b9 e7 ff ff       	call   80100390 <panic>
    panic("ilock");
80101bd7:	83 ec 0c             	sub    $0xc,%esp
80101bda:	68 c9 82 10 80       	push   $0x801082c9
80101bdf:	e8 ac e7 ff ff       	call   80100390 <panic>
80101be4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bef:	90                   	nop

80101bf0 <iunlock>:
{
80101bf0:	f3 0f 1e fb          	endbr32 
80101bf4:	55                   	push   %ebp
80101bf5:	89 e5                	mov    %esp,%ebp
80101bf7:	56                   	push   %esi
80101bf8:	53                   	push   %ebx
80101bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101bfc:	85 db                	test   %ebx,%ebx
80101bfe:	74 28                	je     80101c28 <iunlock+0x38>
80101c00:	83 ec 0c             	sub    $0xc,%esp
80101c03:	8d 73 0c             	lea    0xc(%ebx),%esi
80101c06:	56                   	push   %esi
80101c07:	e8 44 31 00 00       	call   80104d50 <holdingsleep>
80101c0c:	83 c4 10             	add    $0x10,%esp
80101c0f:	85 c0                	test   %eax,%eax
80101c11:	74 15                	je     80101c28 <iunlock+0x38>
80101c13:	8b 43 08             	mov    0x8(%ebx),%eax
80101c16:	85 c0                	test   %eax,%eax
80101c18:	7e 0e                	jle    80101c28 <iunlock+0x38>
  releasesleep(&ip->lock);
80101c1a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101c1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c20:	5b                   	pop    %ebx
80101c21:	5e                   	pop    %esi
80101c22:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101c23:	e9 e8 30 00 00       	jmp    80104d10 <releasesleep>
    panic("iunlock");
80101c28:	83 ec 0c             	sub    $0xc,%esp
80101c2b:	68 de 82 10 80       	push   $0x801082de
80101c30:	e8 5b e7 ff ff       	call   80100390 <panic>
80101c35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c40 <iput>:
{
80101c40:	f3 0f 1e fb          	endbr32 
80101c44:	55                   	push   %ebp
80101c45:	89 e5                	mov    %esp,%ebp
80101c47:	57                   	push   %edi
80101c48:	56                   	push   %esi
80101c49:	53                   	push   %ebx
80101c4a:	83 ec 28             	sub    $0x28,%esp
80101c4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101c50:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101c53:	57                   	push   %edi
80101c54:	e8 57 30 00 00       	call   80104cb0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101c59:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101c5c:	83 c4 10             	add    $0x10,%esp
80101c5f:	85 d2                	test   %edx,%edx
80101c61:	74 07                	je     80101c6a <iput+0x2a>
80101c63:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101c68:	74 36                	je     80101ca0 <iput+0x60>
  releasesleep(&ip->lock);
80101c6a:	83 ec 0c             	sub    $0xc,%esp
80101c6d:	57                   	push   %edi
80101c6e:	e8 9d 30 00 00       	call   80104d10 <releasesleep>
  acquire(&icache.lock);
80101c73:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101c7a:	e8 b1 32 00 00       	call   80104f30 <acquire>
  ip->ref--;
80101c7f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c83:	83 c4 10             	add    $0x10,%esp
80101c86:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
80101c8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c90:	5b                   	pop    %ebx
80101c91:	5e                   	pop    %esi
80101c92:	5f                   	pop    %edi
80101c93:	5d                   	pop    %ebp
  release(&icache.lock);
80101c94:	e9 57 33 00 00       	jmp    80104ff0 <release>
80101c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101ca0:	83 ec 0c             	sub    $0xc,%esp
80101ca3:	68 00 1a 11 80       	push   $0x80111a00
80101ca8:	e8 83 32 00 00       	call   80104f30 <acquire>
    int r = ip->ref;
80101cad:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101cb0:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101cb7:	e8 34 33 00 00       	call   80104ff0 <release>
    if(r == 1){
80101cbc:	83 c4 10             	add    $0x10,%esp
80101cbf:	83 fe 01             	cmp    $0x1,%esi
80101cc2:	75 a6                	jne    80101c6a <iput+0x2a>
80101cc4:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101cca:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ccd:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101cd0:	89 cf                	mov    %ecx,%edi
80101cd2:	eb 0b                	jmp    80101cdf <iput+0x9f>
80101cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101cd8:	83 c6 04             	add    $0x4,%esi
80101cdb:	39 fe                	cmp    %edi,%esi
80101cdd:	74 19                	je     80101cf8 <iput+0xb8>
    if(ip->addrs[i]){
80101cdf:	8b 16                	mov    (%esi),%edx
80101ce1:	85 d2                	test   %edx,%edx
80101ce3:	74 f3                	je     80101cd8 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101ce5:	8b 03                	mov    (%ebx),%eax
80101ce7:	e8 74 f8 ff ff       	call   80101560 <bfree>
      ip->addrs[i] = 0;
80101cec:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101cf2:	eb e4                	jmp    80101cd8 <iput+0x98>
80101cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101cf8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101cfe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101d01:	85 c0                	test   %eax,%eax
80101d03:	75 33                	jne    80101d38 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101d05:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101d08:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101d0f:	53                   	push   %ebx
80101d10:	e8 3b fd ff ff       	call   80101a50 <iupdate>
      ip->type = 0;
80101d15:	31 c0                	xor    %eax,%eax
80101d17:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101d1b:	89 1c 24             	mov    %ebx,(%esp)
80101d1e:	e8 2d fd ff ff       	call   80101a50 <iupdate>
      ip->valid = 0;
80101d23:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101d2a:	83 c4 10             	add    $0x10,%esp
80101d2d:	e9 38 ff ff ff       	jmp    80101c6a <iput+0x2a>
80101d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d38:	83 ec 08             	sub    $0x8,%esp
80101d3b:	50                   	push   %eax
80101d3c:	ff 33                	pushl  (%ebx)
80101d3e:	e8 8d e3 ff ff       	call   801000d0 <bread>
80101d43:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101d46:	83 c4 10             	add    $0x10,%esp
80101d49:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101d4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d52:	8d 70 5c             	lea    0x5c(%eax),%esi
80101d55:	89 cf                	mov    %ecx,%edi
80101d57:	eb 0e                	jmp    80101d67 <iput+0x127>
80101d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d60:	83 c6 04             	add    $0x4,%esi
80101d63:	39 f7                	cmp    %esi,%edi
80101d65:	74 19                	je     80101d80 <iput+0x140>
      if(a[j])
80101d67:	8b 16                	mov    (%esi),%edx
80101d69:	85 d2                	test   %edx,%edx
80101d6b:	74 f3                	je     80101d60 <iput+0x120>
        bfree(ip->dev, a[j]);
80101d6d:	8b 03                	mov    (%ebx),%eax
80101d6f:	e8 ec f7 ff ff       	call   80101560 <bfree>
80101d74:	eb ea                	jmp    80101d60 <iput+0x120>
80101d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101d80:	83 ec 0c             	sub    $0xc,%esp
80101d83:	ff 75 e4             	pushl  -0x1c(%ebp)
80101d86:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d89:	e8 62 e4 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d8e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101d94:	8b 03                	mov    (%ebx),%eax
80101d96:	e8 c5 f7 ff ff       	call   80101560 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d9b:	83 c4 10             	add    $0x10,%esp
80101d9e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101da5:	00 00 00 
80101da8:	e9 58 ff ff ff       	jmp    80101d05 <iput+0xc5>
80101dad:	8d 76 00             	lea    0x0(%esi),%esi

80101db0 <iunlockput>:
{
80101db0:	f3 0f 1e fb          	endbr32 
80101db4:	55                   	push   %ebp
80101db5:	89 e5                	mov    %esp,%ebp
80101db7:	53                   	push   %ebx
80101db8:	83 ec 10             	sub    $0x10,%esp
80101dbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101dbe:	53                   	push   %ebx
80101dbf:	e8 2c fe ff ff       	call   80101bf0 <iunlock>
  iput(ip);
80101dc4:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101dc7:	83 c4 10             	add    $0x10,%esp
}
80101dca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101dcd:	c9                   	leave  
  iput(ip);
80101dce:	e9 6d fe ff ff       	jmp    80101c40 <iput>
80101dd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101de0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101de0:	f3 0f 1e fb          	endbr32 
80101de4:	55                   	push   %ebp
80101de5:	89 e5                	mov    %esp,%ebp
80101de7:	8b 55 08             	mov    0x8(%ebp),%edx
80101dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ded:	8b 0a                	mov    (%edx),%ecx
80101def:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101df2:	8b 4a 04             	mov    0x4(%edx),%ecx
80101df5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101df8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101dfc:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101dff:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101e03:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101e07:	8b 52 58             	mov    0x58(%edx),%edx
80101e0a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e0d:	5d                   	pop    %ebp
80101e0e:	c3                   	ret    
80101e0f:	90                   	nop

80101e10 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e10:	f3 0f 1e fb          	endbr32 
80101e14:	55                   	push   %ebp
80101e15:	89 e5                	mov    %esp,%ebp
80101e17:	57                   	push   %edi
80101e18:	56                   	push   %esi
80101e19:	53                   	push   %ebx
80101e1a:	83 ec 1c             	sub    $0x1c,%esp
80101e1d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101e20:	8b 45 08             	mov    0x8(%ebp),%eax
80101e23:	8b 75 10             	mov    0x10(%ebp),%esi
80101e26:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101e29:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e2c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101e31:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e34:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101e37:	0f 84 a3 00 00 00    	je     80101ee0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101e3d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e40:	8b 40 58             	mov    0x58(%eax),%eax
80101e43:	39 c6                	cmp    %eax,%esi
80101e45:	0f 87 b6 00 00 00    	ja     80101f01 <readi+0xf1>
80101e4b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101e4e:	31 c9                	xor    %ecx,%ecx
80101e50:	89 da                	mov    %ebx,%edx
80101e52:	01 f2                	add    %esi,%edx
80101e54:	0f 92 c1             	setb   %cl
80101e57:	89 cf                	mov    %ecx,%edi
80101e59:	0f 82 a2 00 00 00    	jb     80101f01 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101e5f:	89 c1                	mov    %eax,%ecx
80101e61:	29 f1                	sub    %esi,%ecx
80101e63:	39 d0                	cmp    %edx,%eax
80101e65:	0f 43 cb             	cmovae %ebx,%ecx
80101e68:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e6b:	85 c9                	test   %ecx,%ecx
80101e6d:	74 63                	je     80101ed2 <readi+0xc2>
80101e6f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e70:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101e73:	89 f2                	mov    %esi,%edx
80101e75:	c1 ea 09             	shr    $0x9,%edx
80101e78:	89 d8                	mov    %ebx,%eax
80101e7a:	e8 61 f9 ff ff       	call   801017e0 <bmap>
80101e7f:	83 ec 08             	sub    $0x8,%esp
80101e82:	50                   	push   %eax
80101e83:	ff 33                	pushl  (%ebx)
80101e85:	e8 46 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e8a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101e8d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101e92:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e95:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101e97:	89 f0                	mov    %esi,%eax
80101e99:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e9e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ea0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ea3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ea5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ea9:	39 d9                	cmp    %ebx,%ecx
80101eab:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101eae:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101eaf:	01 df                	add    %ebx,%edi
80101eb1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101eb3:	50                   	push   %eax
80101eb4:	ff 75 e0             	pushl  -0x20(%ebp)
80101eb7:	e8 24 32 00 00       	call   801050e0 <memmove>
    brelse(bp);
80101ebc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101ebf:	89 14 24             	mov    %edx,(%esp)
80101ec2:	e8 29 e3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ec7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101eca:	83 c4 10             	add    $0x10,%esp
80101ecd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ed0:	77 9e                	ja     80101e70 <readi+0x60>
  }
  return n;
80101ed2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ed5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ed8:	5b                   	pop    %ebx
80101ed9:	5e                   	pop    %esi
80101eda:	5f                   	pop    %edi
80101edb:	5d                   	pop    %ebp
80101edc:	c3                   	ret    
80101edd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ee0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ee4:	66 83 f8 09          	cmp    $0x9,%ax
80101ee8:	77 17                	ja     80101f01 <readi+0xf1>
80101eea:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
80101ef1:	85 c0                	test   %eax,%eax
80101ef3:	74 0c                	je     80101f01 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ef5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ef8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efb:	5b                   	pop    %ebx
80101efc:	5e                   	pop    %esi
80101efd:	5f                   	pop    %edi
80101efe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101eff:	ff e0                	jmp    *%eax
      return -1;
80101f01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f06:	eb cd                	jmp    80101ed5 <readi+0xc5>
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop

80101f10 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f10:	f3 0f 1e fb          	endbr32 
80101f14:	55                   	push   %ebp
80101f15:	89 e5                	mov    %esp,%ebp
80101f17:	57                   	push   %edi
80101f18:	56                   	push   %esi
80101f19:	53                   	push   %ebx
80101f1a:	83 ec 1c             	sub    $0x1c,%esp
80101f1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f20:	8b 75 0c             	mov    0xc(%ebp),%esi
80101f23:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f26:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101f2b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101f2e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101f31:	8b 75 10             	mov    0x10(%ebp),%esi
80101f34:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101f37:	0f 84 b3 00 00 00    	je     80101ff0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101f3d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f40:	39 70 58             	cmp    %esi,0x58(%eax)
80101f43:	0f 82 e3 00 00 00    	jb     8010202c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101f49:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101f4c:	89 f8                	mov    %edi,%eax
80101f4e:	01 f0                	add    %esi,%eax
80101f50:	0f 82 d6 00 00 00    	jb     8010202c <writei+0x11c>
80101f56:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f5b:	0f 87 cb 00 00 00    	ja     8010202c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f61:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101f68:	85 ff                	test   %edi,%edi
80101f6a:	74 75                	je     80101fe1 <writei+0xd1>
80101f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f70:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101f73:	89 f2                	mov    %esi,%edx
80101f75:	c1 ea 09             	shr    $0x9,%edx
80101f78:	89 f8                	mov    %edi,%eax
80101f7a:	e8 61 f8 ff ff       	call   801017e0 <bmap>
80101f7f:	83 ec 08             	sub    $0x8,%esp
80101f82:	50                   	push   %eax
80101f83:	ff 37                	pushl  (%edi)
80101f85:	e8 46 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101f8a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101f8f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101f92:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f95:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101f97:	89 f0                	mov    %esi,%eax
80101f99:	83 c4 0c             	add    $0xc,%esp
80101f9c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fa1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101fa3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101fa7:	39 d9                	cmp    %ebx,%ecx
80101fa9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101fac:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fad:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101faf:	ff 75 dc             	pushl  -0x24(%ebp)
80101fb2:	50                   	push   %eax
80101fb3:	e8 28 31 00 00       	call   801050e0 <memmove>
    log_write(bp);
80101fb8:	89 3c 24             	mov    %edi,(%esp)
80101fbb:	e8 80 16 00 00       	call   80103640 <log_write>
    brelse(bp);
80101fc0:	89 3c 24             	mov    %edi,(%esp)
80101fc3:	e8 28 e2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fc8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101fcb:	83 c4 10             	add    $0x10,%esp
80101fce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101fd1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101fd4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101fd7:	77 97                	ja     80101f70 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101fd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101fdc:	3b 70 58             	cmp    0x58(%eax),%esi
80101fdf:	77 37                	ja     80102018 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101fe1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fe7:	5b                   	pop    %ebx
80101fe8:	5e                   	pop    %esi
80101fe9:	5f                   	pop    %edi
80101fea:	5d                   	pop    %ebp
80101feb:	c3                   	ret    
80101fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ff0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ff4:	66 83 f8 09          	cmp    $0x9,%ax
80101ff8:	77 32                	ja     8010202c <writei+0x11c>
80101ffa:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
80102001:	85 c0                	test   %eax,%eax
80102003:	74 27                	je     8010202c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102005:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102008:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010200b:	5b                   	pop    %ebx
8010200c:	5e                   	pop    %esi
8010200d:	5f                   	pop    %edi
8010200e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010200f:	ff e0                	jmp    *%eax
80102011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102018:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010201b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010201e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102021:	50                   	push   %eax
80102022:	e8 29 fa ff ff       	call   80101a50 <iupdate>
80102027:	83 c4 10             	add    $0x10,%esp
8010202a:	eb b5                	jmp    80101fe1 <writei+0xd1>
      return -1;
8010202c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102031:	eb b1                	jmp    80101fe4 <writei+0xd4>
80102033:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010203a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102040 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102040:	f3 0f 1e fb          	endbr32 
80102044:	55                   	push   %ebp
80102045:	89 e5                	mov    %esp,%ebp
80102047:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010204a:	6a 0e                	push   $0xe
8010204c:	ff 75 0c             	pushl  0xc(%ebp)
8010204f:	ff 75 08             	pushl  0x8(%ebp)
80102052:	e8 f9 30 00 00       	call   80105150 <strncmp>
}
80102057:	c9                   	leave  
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102060 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102060:	f3 0f 1e fb          	endbr32 
80102064:	55                   	push   %ebp
80102065:	89 e5                	mov    %esp,%ebp
80102067:	57                   	push   %edi
80102068:	56                   	push   %esi
80102069:	53                   	push   %ebx
8010206a:	83 ec 1c             	sub    $0x1c,%esp
8010206d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102070:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102075:	0f 85 89 00 00 00    	jne    80102104 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010207b:	8b 53 58             	mov    0x58(%ebx),%edx
8010207e:	31 ff                	xor    %edi,%edi
80102080:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102083:	85 d2                	test   %edx,%edx
80102085:	74 42                	je     801020c9 <dirlookup+0x69>
80102087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010208e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102090:	6a 10                	push   $0x10
80102092:	57                   	push   %edi
80102093:	56                   	push   %esi
80102094:	53                   	push   %ebx
80102095:	e8 76 fd ff ff       	call   80101e10 <readi>
8010209a:	83 c4 10             	add    $0x10,%esp
8010209d:	83 f8 10             	cmp    $0x10,%eax
801020a0:	75 55                	jne    801020f7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
801020a2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020a7:	74 18                	je     801020c1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
801020a9:	83 ec 04             	sub    $0x4,%esp
801020ac:	8d 45 da             	lea    -0x26(%ebp),%eax
801020af:	6a 0e                	push   $0xe
801020b1:	50                   	push   %eax
801020b2:	ff 75 0c             	pushl  0xc(%ebp)
801020b5:	e8 96 30 00 00       	call   80105150 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801020ba:	83 c4 10             	add    $0x10,%esp
801020bd:	85 c0                	test   %eax,%eax
801020bf:	74 17                	je     801020d8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020c1:	83 c7 10             	add    $0x10,%edi
801020c4:	3b 7b 58             	cmp    0x58(%ebx),%edi
801020c7:	72 c7                	jb     80102090 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801020c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801020cc:	31 c0                	xor    %eax,%eax
}
801020ce:	5b                   	pop    %ebx
801020cf:	5e                   	pop    %esi
801020d0:	5f                   	pop    %edi
801020d1:	5d                   	pop    %ebp
801020d2:	c3                   	ret    
801020d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020d7:	90                   	nop
      if(poff)
801020d8:	8b 45 10             	mov    0x10(%ebp),%eax
801020db:	85 c0                	test   %eax,%eax
801020dd:	74 05                	je     801020e4 <dirlookup+0x84>
        *poff = off;
801020df:	8b 45 10             	mov    0x10(%ebp),%eax
801020e2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801020e4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801020e8:	8b 03                	mov    (%ebx),%eax
801020ea:	e8 01 f6 ff ff       	call   801016f0 <iget>
}
801020ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020f2:	5b                   	pop    %ebx
801020f3:	5e                   	pop    %esi
801020f4:	5f                   	pop    %edi
801020f5:	5d                   	pop    %ebp
801020f6:	c3                   	ret    
      panic("dirlookup read");
801020f7:	83 ec 0c             	sub    $0xc,%esp
801020fa:	68 f8 82 10 80       	push   $0x801082f8
801020ff:	e8 8c e2 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80102104:	83 ec 0c             	sub    $0xc,%esp
80102107:	68 e6 82 10 80       	push   $0x801082e6
8010210c:	e8 7f e2 ff ff       	call   80100390 <panic>
80102111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010211f:	90                   	nop

80102120 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	57                   	push   %edi
80102124:	56                   	push   %esi
80102125:	53                   	push   %ebx
80102126:	89 c3                	mov    %eax,%ebx
80102128:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010212b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010212e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102131:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102134:	0f 84 86 01 00 00    	je     801022c0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010213a:	e8 c1 1f 00 00       	call   80104100 <myproc>
  acquire(&icache.lock);
8010213f:	83 ec 0c             	sub    $0xc,%esp
80102142:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102144:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102147:	68 00 1a 11 80       	push   $0x80111a00
8010214c:	e8 df 2d 00 00       	call   80104f30 <acquire>
  ip->ref++;
80102151:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102155:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010215c:	e8 8f 2e 00 00       	call   80104ff0 <release>
80102161:	83 c4 10             	add    $0x10,%esp
80102164:	eb 0d                	jmp    80102173 <namex+0x53>
80102166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010216d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102170:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102173:	0f b6 07             	movzbl (%edi),%eax
80102176:	3c 2f                	cmp    $0x2f,%al
80102178:	74 f6                	je     80102170 <namex+0x50>
  if(*path == 0)
8010217a:	84 c0                	test   %al,%al
8010217c:	0f 84 ee 00 00 00    	je     80102270 <namex+0x150>
  while(*path != '/' && *path != 0)
80102182:	0f b6 07             	movzbl (%edi),%eax
80102185:	84 c0                	test   %al,%al
80102187:	0f 84 fb 00 00 00    	je     80102288 <namex+0x168>
8010218d:	89 fb                	mov    %edi,%ebx
8010218f:	3c 2f                	cmp    $0x2f,%al
80102191:	0f 84 f1 00 00 00    	je     80102288 <namex+0x168>
80102197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010219e:	66 90                	xchg   %ax,%ax
801021a0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
801021a4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
801021a7:	3c 2f                	cmp    $0x2f,%al
801021a9:	74 04                	je     801021af <namex+0x8f>
801021ab:	84 c0                	test   %al,%al
801021ad:	75 f1                	jne    801021a0 <namex+0x80>
  len = path - s;
801021af:	89 d8                	mov    %ebx,%eax
801021b1:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
801021b3:	83 f8 0d             	cmp    $0xd,%eax
801021b6:	0f 8e 84 00 00 00    	jle    80102240 <namex+0x120>
    memmove(name, s, DIRSIZ);
801021bc:	83 ec 04             	sub    $0x4,%esp
801021bf:	6a 0e                	push   $0xe
801021c1:	57                   	push   %edi
    path++;
801021c2:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
801021c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801021c7:	e8 14 2f 00 00       	call   801050e0 <memmove>
801021cc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801021cf:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801021d2:	75 0c                	jne    801021e0 <namex+0xc0>
801021d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801021d8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
801021db:	80 3f 2f             	cmpb   $0x2f,(%edi)
801021de:	74 f8                	je     801021d8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801021e0:	83 ec 0c             	sub    $0xc,%esp
801021e3:	56                   	push   %esi
801021e4:	e8 27 f9 ff ff       	call   80101b10 <ilock>
    if(ip->type != T_DIR){
801021e9:	83 c4 10             	add    $0x10,%esp
801021ec:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801021f1:	0f 85 a1 00 00 00    	jne    80102298 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801021f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801021fa:	85 d2                	test   %edx,%edx
801021fc:	74 09                	je     80102207 <namex+0xe7>
801021fe:	80 3f 00             	cmpb   $0x0,(%edi)
80102201:	0f 84 d9 00 00 00    	je     801022e0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102207:	83 ec 04             	sub    $0x4,%esp
8010220a:	6a 00                	push   $0x0
8010220c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010220f:	56                   	push   %esi
80102210:	e8 4b fe ff ff       	call   80102060 <dirlookup>
80102215:	83 c4 10             	add    $0x10,%esp
80102218:	89 c3                	mov    %eax,%ebx
8010221a:	85 c0                	test   %eax,%eax
8010221c:	74 7a                	je     80102298 <namex+0x178>
  iunlock(ip);
8010221e:	83 ec 0c             	sub    $0xc,%esp
80102221:	56                   	push   %esi
80102222:	e8 c9 f9 ff ff       	call   80101bf0 <iunlock>
  iput(ip);
80102227:	89 34 24             	mov    %esi,(%esp)
8010222a:	89 de                	mov    %ebx,%esi
8010222c:	e8 0f fa ff ff       	call   80101c40 <iput>
80102231:	83 c4 10             	add    $0x10,%esp
80102234:	e9 3a ff ff ff       	jmp    80102173 <namex+0x53>
80102239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102240:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102243:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102246:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102249:	83 ec 04             	sub    $0x4,%esp
8010224c:	50                   	push   %eax
8010224d:	57                   	push   %edi
    name[len] = 0;
8010224e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102250:	ff 75 e4             	pushl  -0x1c(%ebp)
80102253:	e8 88 2e 00 00       	call   801050e0 <memmove>
    name[len] = 0;
80102258:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010225b:	83 c4 10             	add    $0x10,%esp
8010225e:	c6 00 00             	movb   $0x0,(%eax)
80102261:	e9 69 ff ff ff       	jmp    801021cf <namex+0xaf>
80102266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010226d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102270:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102273:	85 c0                	test   %eax,%eax
80102275:	0f 85 85 00 00 00    	jne    80102300 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010227b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010227e:	89 f0                	mov    %esi,%eax
80102280:	5b                   	pop    %ebx
80102281:	5e                   	pop    %esi
80102282:	5f                   	pop    %edi
80102283:	5d                   	pop    %ebp
80102284:	c3                   	ret    
80102285:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010228b:	89 fb                	mov    %edi,%ebx
8010228d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102290:	31 c0                	xor    %eax,%eax
80102292:	eb b5                	jmp    80102249 <namex+0x129>
80102294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102298:	83 ec 0c             	sub    $0xc,%esp
8010229b:	56                   	push   %esi
8010229c:	e8 4f f9 ff ff       	call   80101bf0 <iunlock>
  iput(ip);
801022a1:	89 34 24             	mov    %esi,(%esp)
      return 0;
801022a4:	31 f6                	xor    %esi,%esi
  iput(ip);
801022a6:	e8 95 f9 ff ff       	call   80101c40 <iput>
      return 0;
801022ab:	83 c4 10             	add    $0x10,%esp
}
801022ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022b1:	89 f0                	mov    %esi,%eax
801022b3:	5b                   	pop    %ebx
801022b4:	5e                   	pop    %esi
801022b5:	5f                   	pop    %edi
801022b6:	5d                   	pop    %ebp
801022b7:	c3                   	ret    
801022b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022bf:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
801022c0:	ba 01 00 00 00       	mov    $0x1,%edx
801022c5:	b8 01 00 00 00       	mov    $0x1,%eax
801022ca:	89 df                	mov    %ebx,%edi
801022cc:	e8 1f f4 ff ff       	call   801016f0 <iget>
801022d1:	89 c6                	mov    %eax,%esi
801022d3:	e9 9b fe ff ff       	jmp    80102173 <namex+0x53>
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop
      iunlock(ip);
801022e0:	83 ec 0c             	sub    $0xc,%esp
801022e3:	56                   	push   %esi
801022e4:	e8 07 f9 ff ff       	call   80101bf0 <iunlock>
      return ip;
801022e9:	83 c4 10             	add    $0x10,%esp
}
801022ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022ef:	89 f0                	mov    %esi,%eax
801022f1:	5b                   	pop    %ebx
801022f2:	5e                   	pop    %esi
801022f3:	5f                   	pop    %edi
801022f4:	5d                   	pop    %ebp
801022f5:	c3                   	ret    
801022f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022fd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80102300:	83 ec 0c             	sub    $0xc,%esp
80102303:	56                   	push   %esi
    return 0;
80102304:	31 f6                	xor    %esi,%esi
    iput(ip);
80102306:	e8 35 f9 ff ff       	call   80101c40 <iput>
    return 0;
8010230b:	83 c4 10             	add    $0x10,%esp
8010230e:	e9 68 ff ff ff       	jmp    8010227b <namex+0x15b>
80102313:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102320 <dirlink>:
{
80102320:	f3 0f 1e fb          	endbr32 
80102324:	55                   	push   %ebp
80102325:	89 e5                	mov    %esp,%ebp
80102327:	57                   	push   %edi
80102328:	56                   	push   %esi
80102329:	53                   	push   %ebx
8010232a:	83 ec 20             	sub    $0x20,%esp
8010232d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102330:	6a 00                	push   $0x0
80102332:	ff 75 0c             	pushl  0xc(%ebp)
80102335:	53                   	push   %ebx
80102336:	e8 25 fd ff ff       	call   80102060 <dirlookup>
8010233b:	83 c4 10             	add    $0x10,%esp
8010233e:	85 c0                	test   %eax,%eax
80102340:	75 6b                	jne    801023ad <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102342:	8b 7b 58             	mov    0x58(%ebx),%edi
80102345:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102348:	85 ff                	test   %edi,%edi
8010234a:	74 2d                	je     80102379 <dirlink+0x59>
8010234c:	31 ff                	xor    %edi,%edi
8010234e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102351:	eb 0d                	jmp    80102360 <dirlink+0x40>
80102353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102357:	90                   	nop
80102358:	83 c7 10             	add    $0x10,%edi
8010235b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010235e:	73 19                	jae    80102379 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102360:	6a 10                	push   $0x10
80102362:	57                   	push   %edi
80102363:	56                   	push   %esi
80102364:	53                   	push   %ebx
80102365:	e8 a6 fa ff ff       	call   80101e10 <readi>
8010236a:	83 c4 10             	add    $0x10,%esp
8010236d:	83 f8 10             	cmp    $0x10,%eax
80102370:	75 4e                	jne    801023c0 <dirlink+0xa0>
    if(de.inum == 0)
80102372:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102377:	75 df                	jne    80102358 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102379:	83 ec 04             	sub    $0x4,%esp
8010237c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010237f:	6a 0e                	push   $0xe
80102381:	ff 75 0c             	pushl  0xc(%ebp)
80102384:	50                   	push   %eax
80102385:	e8 16 2e 00 00       	call   801051a0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010238a:	6a 10                	push   $0x10
  de.inum = inum;
8010238c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010238f:	57                   	push   %edi
80102390:	56                   	push   %esi
80102391:	53                   	push   %ebx
  de.inum = inum;
80102392:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102396:	e8 75 fb ff ff       	call   80101f10 <writei>
8010239b:	83 c4 20             	add    $0x20,%esp
8010239e:	83 f8 10             	cmp    $0x10,%eax
801023a1:	75 2a                	jne    801023cd <dirlink+0xad>
  return 0;
801023a3:	31 c0                	xor    %eax,%eax
}
801023a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023a8:	5b                   	pop    %ebx
801023a9:	5e                   	pop    %esi
801023aa:	5f                   	pop    %edi
801023ab:	5d                   	pop    %ebp
801023ac:	c3                   	ret    
    iput(ip);
801023ad:	83 ec 0c             	sub    $0xc,%esp
801023b0:	50                   	push   %eax
801023b1:	e8 8a f8 ff ff       	call   80101c40 <iput>
    return -1;
801023b6:	83 c4 10             	add    $0x10,%esp
801023b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801023be:	eb e5                	jmp    801023a5 <dirlink+0x85>
      panic("dirlink read");
801023c0:	83 ec 0c             	sub    $0xc,%esp
801023c3:	68 07 83 10 80       	push   $0x80108307
801023c8:	e8 c3 df ff ff       	call   80100390 <panic>
    panic("dirlink");
801023cd:	83 ec 0c             	sub    $0xc,%esp
801023d0:	68 4d 89 10 80       	push   $0x8010894d
801023d5:	e8 b6 df ff ff       	call   80100390 <panic>
801023da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023e0 <namei>:

struct inode*
namei(char *path)
{
801023e0:	f3 0f 1e fb          	endbr32 
801023e4:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801023e5:	31 d2                	xor    %edx,%edx
{
801023e7:	89 e5                	mov    %esp,%ebp
801023e9:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801023ec:	8b 45 08             	mov    0x8(%ebp),%eax
801023ef:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801023f2:	e8 29 fd ff ff       	call   80102120 <namex>
}
801023f7:	c9                   	leave  
801023f8:	c3                   	ret    
801023f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102400 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102400:	f3 0f 1e fb          	endbr32 
80102404:	55                   	push   %ebp
  return namex(path, 1, name);
80102405:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010240a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010240c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010240f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102412:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102413:	e9 08 fd ff ff       	jmp    80102120 <namex>
80102418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010241f:	90                   	nop

80102420 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80102420:	f3 0f 1e fb          	endbr32 
80102424:	55                   	push   %ebp
    char const digit[] = "0123456789";
80102425:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
8010242a:	89 e5                	mov    %esp,%ebp
8010242c:	57                   	push   %edi
8010242d:	56                   	push   %esi
8010242e:	53                   	push   %ebx
8010242f:	83 ec 10             	sub    $0x10,%esp
80102432:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102435:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80102438:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
8010243f:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80102446:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
8010244a:	89 fb                	mov    %edi,%ebx
8010244c:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
    char* p = b;
    if(i<0){
80102450:	85 c9                	test   %ecx,%ecx
80102452:	79 08                	jns    8010245c <itoa+0x3c>
        *p++ = '-';
80102454:	c6 07 2d             	movb   $0x2d,(%edi)
80102457:	8d 5f 01             	lea    0x1(%edi),%ebx
        i *= -1;
8010245a:	f7 d9                	neg    %ecx
    }
    int shifter = i;
8010245c:	89 ca                	mov    %ecx,%edx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
8010245e:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80102463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102467:	90                   	nop
80102468:	89 d0                	mov    %edx,%eax
        ++p;
8010246a:	83 c3 01             	add    $0x1,%ebx
        shifter = shifter/10;
8010246d:	f7 e6                	mul    %esi
    }while(shifter);
8010246f:	c1 ea 03             	shr    $0x3,%edx
80102472:	75 f4                	jne    80102468 <itoa+0x48>
    *p = '\0';
80102474:	c6 03 00             	movb   $0x0,(%ebx)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102477:	be cd cc cc cc       	mov    $0xcccccccd,%esi
8010247c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102480:	89 c8                	mov    %ecx,%eax
80102482:	83 eb 01             	sub    $0x1,%ebx
80102485:	f7 e6                	mul    %esi
80102487:	c1 ea 03             	shr    $0x3,%edx
8010248a:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010248d:	01 c0                	add    %eax,%eax
8010248f:	29 c1                	sub    %eax,%ecx
80102491:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80102496:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102498:	88 03                	mov    %al,(%ebx)
    }while(i);
8010249a:	85 d2                	test   %edx,%edx
8010249c:	75 e2                	jne    80102480 <itoa+0x60>
    return b;
}
8010249e:	83 c4 10             	add    $0x10,%esp
801024a1:	89 f8                	mov    %edi,%eax
801024a3:	5b                   	pop    %ebx
801024a4:	5e                   	pop    %esi
801024a5:	5f                   	pop    %edi
801024a6:	5d                   	pop    %ebp
801024a7:	c3                   	ret    
801024a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024af:	90                   	nop

801024b0 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
801024b0:	f3 0f 1e fb          	endbr32 
801024b4:	55                   	push   %ebp
801024b5:	89 e5                	mov    %esp,%ebp
801024b7:	57                   	push   %edi
801024b8:	56                   	push   %esi
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
801024b9:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
801024bc:	53                   	push   %ebx
801024bd:	83 ec 40             	sub    $0x40,%esp
801024c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801024c3:	6a 06                	push   $0x6
801024c5:	68 14 83 10 80       	push   $0x80108314
801024ca:	56                   	push   %esi
801024cb:	e8 10 2c 00 00       	call   801050e0 <memmove>
  itoa(p->pid, path+ 6);
801024d0:	58                   	pop    %eax
801024d1:	8d 45 c2             	lea    -0x3e(%ebp),%eax
801024d4:	5a                   	pop    %edx
801024d5:	50                   	push   %eax
801024d6:	ff 73 10             	pushl  0x10(%ebx)
801024d9:	e8 42 ff ff ff       	call   80102420 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
801024de:	8b 43 7c             	mov    0x7c(%ebx),%eax
801024e1:	83 c4 10             	add    $0x10,%esp
801024e4:	85 c0                	test   %eax,%eax
801024e6:	0f 84 7a 01 00 00    	je     80102666 <removeSwapFile+0x1b6>
  {
    return -1;
  }
  fileclose(p->swapFile);
801024ec:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
801024ef:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
801024f2:	50                   	push   %eax
801024f3:	e8 78 ed ff ff       	call   80101270 <fileclose>

  begin_op();
801024f8:	e8 63 0f 00 00       	call   80103460 <begin_op>
  return namex(path, 1, name);
801024fd:	89 f0                	mov    %esi,%eax
801024ff:	89 d9                	mov    %ebx,%ecx
80102501:	ba 01 00 00 00       	mov    $0x1,%edx
80102506:	e8 15 fc ff ff       	call   80102120 <namex>
  if((dp = nameiparent(path, name)) == 0)
8010250b:	83 c4 10             	add    $0x10,%esp
  return namex(path, 1, name);
8010250e:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
80102510:	85 c0                	test   %eax,%eax
80102512:	0f 84 55 01 00 00    	je     8010266d <removeSwapFile+0x1bd>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102518:	83 ec 0c             	sub    $0xc,%esp
8010251b:	50                   	push   %eax
8010251c:	e8 ef f5 ff ff       	call   80101b10 <ilock>
  return strncmp(s, t, DIRSIZ);
80102521:	83 c4 0c             	add    $0xc,%esp
80102524:	6a 0e                	push   $0xe
80102526:	68 1c 83 10 80       	push   $0x8010831c
8010252b:	53                   	push   %ebx
8010252c:	e8 1f 2c 00 00       	call   80105150 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102531:	83 c4 10             	add    $0x10,%esp
80102534:	85 c0                	test   %eax,%eax
80102536:	0f 84 f4 00 00 00    	je     80102630 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
8010253c:	83 ec 04             	sub    $0x4,%esp
8010253f:	6a 0e                	push   $0xe
80102541:	68 1b 83 10 80       	push   $0x8010831b
80102546:	53                   	push   %ebx
80102547:	e8 04 2c 00 00       	call   80105150 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010254c:	83 c4 10             	add    $0x10,%esp
8010254f:	85 c0                	test   %eax,%eax
80102551:	0f 84 d9 00 00 00    	je     80102630 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102557:	83 ec 04             	sub    $0x4,%esp
8010255a:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010255d:	50                   	push   %eax
8010255e:	53                   	push   %ebx
8010255f:	56                   	push   %esi
80102560:	e8 fb fa ff ff       	call   80102060 <dirlookup>
80102565:	83 c4 10             	add    $0x10,%esp
80102568:	89 c3                	mov    %eax,%ebx
8010256a:	85 c0                	test   %eax,%eax
8010256c:	0f 84 be 00 00 00    	je     80102630 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
80102572:	83 ec 0c             	sub    $0xc,%esp
80102575:	50                   	push   %eax
80102576:	e8 95 f5 ff ff       	call   80101b10 <ilock>

  if(ip->nlink < 1)
8010257b:	83 c4 10             	add    $0x10,%esp
8010257e:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102583:	0f 8e 00 01 00 00    	jle    80102689 <removeSwapFile+0x1d9>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102589:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010258e:	74 78                	je     80102608 <removeSwapFile+0x158>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80102590:	83 ec 04             	sub    $0x4,%esp
80102593:	8d 7d d8             	lea    -0x28(%ebp),%edi
80102596:	6a 10                	push   $0x10
80102598:	6a 00                	push   $0x0
8010259a:	57                   	push   %edi
8010259b:	e8 a0 2a 00 00       	call   80105040 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801025a0:	6a 10                	push   $0x10
801025a2:	ff 75 b8             	pushl  -0x48(%ebp)
801025a5:	57                   	push   %edi
801025a6:	56                   	push   %esi
801025a7:	e8 64 f9 ff ff       	call   80101f10 <writei>
801025ac:	83 c4 20             	add    $0x20,%esp
801025af:	83 f8 10             	cmp    $0x10,%eax
801025b2:	0f 85 c4 00 00 00    	jne    8010267c <removeSwapFile+0x1cc>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801025b8:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801025bd:	0f 84 8d 00 00 00    	je     80102650 <removeSwapFile+0x1a0>
  iunlock(ip);
801025c3:	83 ec 0c             	sub    $0xc,%esp
801025c6:	56                   	push   %esi
801025c7:	e8 24 f6 ff ff       	call   80101bf0 <iunlock>
  iput(ip);
801025cc:	89 34 24             	mov    %esi,(%esp)
801025cf:	e8 6c f6 ff ff       	call   80101c40 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
801025d4:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801025d9:	89 1c 24             	mov    %ebx,(%esp)
801025dc:	e8 6f f4 ff ff       	call   80101a50 <iupdate>
  iunlock(ip);
801025e1:	89 1c 24             	mov    %ebx,(%esp)
801025e4:	e8 07 f6 ff ff       	call   80101bf0 <iunlock>
  iput(ip);
801025e9:	89 1c 24             	mov    %ebx,(%esp)
801025ec:	e8 4f f6 ff ff       	call   80101c40 <iput>
  iunlockput(ip);

  end_op();
801025f1:	e8 da 0e 00 00       	call   801034d0 <end_op>

  return 0;
801025f6:	83 c4 10             	add    $0x10,%esp
801025f9:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
801025fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025fe:	5b                   	pop    %ebx
801025ff:	5e                   	pop    %esi
80102600:	5f                   	pop    %edi
80102601:	5d                   	pop    %ebp
80102602:	c3                   	ret    
80102603:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102607:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	53                   	push   %ebx
8010260c:	e8 ff 31 00 00       	call   80105810 <isdirempty>
80102611:	83 c4 10             	add    $0x10,%esp
80102614:	85 c0                	test   %eax,%eax
80102616:	0f 85 74 ff ff ff    	jne    80102590 <removeSwapFile+0xe0>
  iunlock(ip);
8010261c:	83 ec 0c             	sub    $0xc,%esp
8010261f:	53                   	push   %ebx
80102620:	e8 cb f5 ff ff       	call   80101bf0 <iunlock>
  iput(ip);
80102625:	89 1c 24             	mov    %ebx,(%esp)
80102628:	e8 13 f6 ff ff       	call   80101c40 <iput>
    goto bad;
8010262d:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	56                   	push   %esi
80102634:	e8 b7 f5 ff ff       	call   80101bf0 <iunlock>
  iput(ip);
80102639:	89 34 24             	mov    %esi,(%esp)
8010263c:	e8 ff f5 ff ff       	call   80101c40 <iput>
    end_op();
80102641:	e8 8a 0e 00 00       	call   801034d0 <end_op>
    return -1;
80102646:	83 c4 10             	add    $0x10,%esp
80102649:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010264e:	eb ab                	jmp    801025fb <removeSwapFile+0x14b>
    iupdate(dp);
80102650:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80102653:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102658:	56                   	push   %esi
80102659:	e8 f2 f3 ff ff       	call   80101a50 <iupdate>
8010265e:	83 c4 10             	add    $0x10,%esp
80102661:	e9 5d ff ff ff       	jmp    801025c3 <removeSwapFile+0x113>
    return -1;
80102666:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010266b:	eb 8e                	jmp    801025fb <removeSwapFile+0x14b>
    end_op();
8010266d:	e8 5e 0e 00 00       	call   801034d0 <end_op>
    return -1;
80102672:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102677:	e9 7f ff ff ff       	jmp    801025fb <removeSwapFile+0x14b>
    panic("unlink: writei");
8010267c:	83 ec 0c             	sub    $0xc,%esp
8010267f:	68 30 83 10 80       	push   $0x80108330
80102684:	e8 07 dd ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102689:	83 ec 0c             	sub    $0xc,%esp
8010268c:	68 1e 83 10 80       	push   $0x8010831e
80102691:	e8 fa dc ff ff       	call   80100390 <panic>
80102696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010269d:	8d 76 00             	lea    0x0(%esi),%esi

801026a0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
801026a0:	f3 0f 1e fb          	endbr32 
801026a4:	55                   	push   %ebp
801026a5:	89 e5                	mov    %esp,%ebp
801026a7:	56                   	push   %esi
801026a8:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
801026a9:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
801026ac:	83 ec 14             	sub    $0x14,%esp
801026af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801026b2:	6a 06                	push   $0x6
801026b4:	68 14 83 10 80       	push   $0x80108314
801026b9:	56                   	push   %esi
801026ba:	e8 21 2a 00 00       	call   801050e0 <memmove>
  itoa(p->pid, path+ 6);
801026bf:	58                   	pop    %eax
801026c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801026c3:	5a                   	pop    %edx
801026c4:	50                   	push   %eax
801026c5:	ff 73 10             	pushl  0x10(%ebx)
801026c8:	e8 53 fd ff ff       	call   80102420 <itoa>

    begin_op();
801026cd:	e8 8e 0d 00 00       	call   80103460 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
801026d2:	6a 00                	push   $0x0
801026d4:	6a 00                	push   $0x0
801026d6:	6a 02                	push   $0x2
801026d8:	56                   	push   %esi
801026d9:	e8 52 33 00 00       	call   80105a30 <create>
  iunlock(in);
801026de:	83 c4 14             	add    $0x14,%esp
801026e1:	50                   	push   %eax
    struct inode * in = create(path, T_FILE, 0, 0);
801026e2:	89 c6                	mov    %eax,%esi
  iunlock(in);
801026e4:	e8 07 f5 ff ff       	call   80101bf0 <iunlock>

  p->swapFile = filealloc();
801026e9:	e8 c2 ea ff ff       	call   801011b0 <filealloc>
  if (p->swapFile == 0)
801026ee:	83 c4 10             	add    $0x10,%esp
  p->swapFile = filealloc();
801026f1:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
801026f4:	85 c0                	test   %eax,%eax
801026f6:	74 32                	je     8010272a <createSwapFile+0x8a>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
801026f8:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
801026fb:	8b 43 7c             	mov    0x7c(%ebx),%eax
801026fe:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102704:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102707:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010270e:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102711:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102715:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102718:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
8010271c:	e8 af 0d 00 00       	call   801034d0 <end_op>

    return 0;
}
80102721:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102724:	31 c0                	xor    %eax,%eax
80102726:	5b                   	pop    %ebx
80102727:	5e                   	pop    %esi
80102728:	5d                   	pop    %ebp
80102729:	c3                   	ret    
    panic("no slot for files on /store");
8010272a:	83 ec 0c             	sub    $0xc,%esp
8010272d:	68 3f 83 10 80       	push   $0x8010833f
80102732:	e8 59 dc ff ff       	call   80100390 <panic>
80102737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273e:	66 90                	xchg   %ax,%ax

80102740 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc* p, char* buffer, uint placeOnFile, uint size)
{
80102740:	f3 0f 1e fb          	endbr32 
80102744:	55                   	push   %ebp
80102745:	89 e5                	mov    %esp,%ebp
80102747:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
8010274a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010274d:	8b 50 7c             	mov    0x7c(%eax),%edx
80102750:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
80102753:	8b 55 14             	mov    0x14(%ebp),%edx
80102756:	89 55 10             	mov    %edx,0x10(%ebp)
80102759:	8b 40 7c             	mov    0x7c(%eax),%eax
8010275c:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010275f:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
80102760:	e9 db ec ff ff       	jmp    80101440 <filewrite>
80102765:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102770:	f3 0f 1e fb          	endbr32 
80102774:	55                   	push   %ebp
80102775:	89 e5                	mov    %esp,%ebp
80102777:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
8010277a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010277d:	8b 50 7c             	mov    0x7c(%eax),%edx
80102780:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
80102783:	8b 55 14             	mov    0x14(%ebp),%edx
80102786:	89 55 10             	mov    %edx,0x10(%ebp)
80102789:	8b 40 7c             	mov    0x7c(%eax),%eax
8010278c:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010278f:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
80102790:	e9 0b ec ff ff       	jmp    801013a0 <fileread>
80102795:	66 90                	xchg   %ax,%ax
80102797:	66 90                	xchg   %ax,%ax
80102799:	66 90                	xchg   %ax,%ax
8010279b:	66 90                	xchg   %ax,%ax
8010279d:	66 90                	xchg   %ax,%ax
8010279f:	90                   	nop

801027a0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	57                   	push   %edi
801027a4:	56                   	push   %esi
801027a5:	53                   	push   %ebx
801027a6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801027a9:	85 c0                	test   %eax,%eax
801027ab:	0f 84 b4 00 00 00    	je     80102865 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801027b1:	8b 70 08             	mov    0x8(%eax),%esi
801027b4:	89 c3                	mov    %eax,%ebx
801027b6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801027bc:	0f 87 96 00 00 00    	ja     80102858 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027c2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801027c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ce:	66 90                	xchg   %ax,%ax
801027d0:	89 ca                	mov    %ecx,%edx
801027d2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801027d3:	83 e0 c0             	and    $0xffffffc0,%eax
801027d6:	3c 40                	cmp    $0x40,%al
801027d8:	75 f6                	jne    801027d0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027da:	31 ff                	xor    %edi,%edi
801027dc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801027e1:	89 f8                	mov    %edi,%eax
801027e3:	ee                   	out    %al,(%dx)
801027e4:	b8 01 00 00 00       	mov    $0x1,%eax
801027e9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801027ee:	ee                   	out    %al,(%dx)
801027ef:	ba f3 01 00 00       	mov    $0x1f3,%edx
801027f4:	89 f0                	mov    %esi,%eax
801027f6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801027f7:	89 f0                	mov    %esi,%eax
801027f9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801027fe:	c1 f8 08             	sar    $0x8,%eax
80102801:	ee                   	out    %al,(%dx)
80102802:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102807:	89 f8                	mov    %edi,%eax
80102809:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010280a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010280e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102813:	c1 e0 04             	shl    $0x4,%eax
80102816:	83 e0 10             	and    $0x10,%eax
80102819:	83 c8 e0             	or     $0xffffffe0,%eax
8010281c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010281d:	f6 03 04             	testb  $0x4,(%ebx)
80102820:	75 16                	jne    80102838 <idestart+0x98>
80102822:	b8 20 00 00 00       	mov    $0x20,%eax
80102827:	89 ca                	mov    %ecx,%edx
80102829:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010282a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010282d:	5b                   	pop    %ebx
8010282e:	5e                   	pop    %esi
8010282f:	5f                   	pop    %edi
80102830:	5d                   	pop    %ebp
80102831:	c3                   	ret    
80102832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102838:	b8 30 00 00 00       	mov    $0x30,%eax
8010283d:	89 ca                	mov    %ecx,%edx
8010283f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102840:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102848:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010284d:	fc                   	cld    
8010284e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102850:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102853:	5b                   	pop    %ebx
80102854:	5e                   	pop    %esi
80102855:	5f                   	pop    %edi
80102856:	5d                   	pop    %ebp
80102857:	c3                   	ret    
    panic("incorrect blockno");
80102858:	83 ec 0c             	sub    $0xc,%esp
8010285b:	68 b8 83 10 80       	push   $0x801083b8
80102860:	e8 2b db ff ff       	call   80100390 <panic>
    panic("idestart");
80102865:	83 ec 0c             	sub    $0xc,%esp
80102868:	68 af 83 10 80       	push   $0x801083af
8010286d:	e8 1e db ff ff       	call   80100390 <panic>
80102872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102880 <ideinit>:
{
80102880:	f3 0f 1e fb          	endbr32 
80102884:	55                   	push   %ebp
80102885:	89 e5                	mov    %esp,%ebp
80102887:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010288a:	68 ca 83 10 80       	push   $0x801083ca
8010288f:	68 80 b5 10 80       	push   $0x8010b580
80102894:	e8 17 25 00 00       	call   80104db0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102899:	58                   	pop    %eax
8010289a:	a1 20 3d 11 80       	mov    0x80113d20,%eax
8010289f:	5a                   	pop    %edx
801028a0:	83 e8 01             	sub    $0x1,%eax
801028a3:	50                   	push   %eax
801028a4:	6a 0e                	push   $0xe
801028a6:	e8 b5 02 00 00       	call   80102b60 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801028ab:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ae:	ba f7 01 00 00       	mov    $0x1f7,%edx
801028b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028b7:	90                   	nop
801028b8:	ec                   	in     (%dx),%al
801028b9:	83 e0 c0             	and    $0xffffffc0,%eax
801028bc:	3c 40                	cmp    $0x40,%al
801028be:	75 f8                	jne    801028b8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801028c5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801028ca:	ee                   	out    %al,(%dx)
801028cb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801028d5:	eb 0e                	jmp    801028e5 <ideinit+0x65>
801028d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028de:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801028e0:	83 e9 01             	sub    $0x1,%ecx
801028e3:	74 0f                	je     801028f4 <ideinit+0x74>
801028e5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801028e6:	84 c0                	test   %al,%al
801028e8:	74 f6                	je     801028e0 <ideinit+0x60>
      havedisk1 = 1;
801028ea:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801028f1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801028f9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801028fe:	ee                   	out    %al,(%dx)
}
801028ff:	c9                   	leave  
80102900:	c3                   	ret    
80102901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102908:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290f:	90                   	nop

80102910 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102910:	f3 0f 1e fb          	endbr32 
80102914:	55                   	push   %ebp
80102915:	89 e5                	mov    %esp,%ebp
80102917:	57                   	push   %edi
80102918:	56                   	push   %esi
80102919:	53                   	push   %ebx
8010291a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010291d:	68 80 b5 10 80       	push   $0x8010b580
80102922:	e8 09 26 00 00       	call   80104f30 <acquire>

  if((b = idequeue) == 0){
80102927:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010292d:	83 c4 10             	add    $0x10,%esp
80102930:	85 db                	test   %ebx,%ebx
80102932:	74 5f                	je     80102993 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102934:	8b 43 58             	mov    0x58(%ebx),%eax
80102937:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010293c:	8b 33                	mov    (%ebx),%esi
8010293e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102944:	75 2b                	jne    80102971 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102946:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010294b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010294f:	90                   	nop
80102950:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102951:	89 c1                	mov    %eax,%ecx
80102953:	83 e1 c0             	and    $0xffffffc0,%ecx
80102956:	80 f9 40             	cmp    $0x40,%cl
80102959:	75 f5                	jne    80102950 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010295b:	a8 21                	test   $0x21,%al
8010295d:	75 12                	jne    80102971 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010295f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102962:	b9 80 00 00 00       	mov    $0x80,%ecx
80102967:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010296c:	fc                   	cld    
8010296d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010296f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102971:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102974:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102977:	83 ce 02             	or     $0x2,%esi
8010297a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010297c:	53                   	push   %ebx
8010297d:	e8 fe 20 00 00       	call   80104a80 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102982:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102987:	83 c4 10             	add    $0x10,%esp
8010298a:	85 c0                	test   %eax,%eax
8010298c:	74 05                	je     80102993 <ideintr+0x83>
    idestart(idequeue);
8010298e:	e8 0d fe ff ff       	call   801027a0 <idestart>
    release(&idelock);
80102993:	83 ec 0c             	sub    $0xc,%esp
80102996:	68 80 b5 10 80       	push   $0x8010b580
8010299b:	e8 50 26 00 00       	call   80104ff0 <release>

  release(&idelock);
}
801029a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029a3:	5b                   	pop    %ebx
801029a4:	5e                   	pop    %esi
801029a5:	5f                   	pop    %edi
801029a6:	5d                   	pop    %ebp
801029a7:	c3                   	ret    
801029a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029af:	90                   	nop

801029b0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801029b0:	f3 0f 1e fb          	endbr32 
801029b4:	55                   	push   %ebp
801029b5:	89 e5                	mov    %esp,%ebp
801029b7:	53                   	push   %ebx
801029b8:	83 ec 10             	sub    $0x10,%esp
801029bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801029be:	8d 43 0c             	lea    0xc(%ebx),%eax
801029c1:	50                   	push   %eax
801029c2:	e8 89 23 00 00       	call   80104d50 <holdingsleep>
801029c7:	83 c4 10             	add    $0x10,%esp
801029ca:	85 c0                	test   %eax,%eax
801029cc:	0f 84 cf 00 00 00    	je     80102aa1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029d2:	8b 03                	mov    (%ebx),%eax
801029d4:	83 e0 06             	and    $0x6,%eax
801029d7:	83 f8 02             	cmp    $0x2,%eax
801029da:	0f 84 b4 00 00 00    	je     80102a94 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801029e0:	8b 53 04             	mov    0x4(%ebx),%edx
801029e3:	85 d2                	test   %edx,%edx
801029e5:	74 0d                	je     801029f4 <iderw+0x44>
801029e7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801029ec:	85 c0                	test   %eax,%eax
801029ee:	0f 84 93 00 00 00    	je     80102a87 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801029f4:	83 ec 0c             	sub    $0xc,%esp
801029f7:	68 80 b5 10 80       	push   $0x8010b580
801029fc:	e8 2f 25 00 00       	call   80104f30 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a01:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
80102a06:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a0d:	83 c4 10             	add    $0x10,%esp
80102a10:	85 c0                	test   %eax,%eax
80102a12:	74 6c                	je     80102a80 <iderw+0xd0>
80102a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a18:	89 c2                	mov    %eax,%edx
80102a1a:	8b 40 58             	mov    0x58(%eax),%eax
80102a1d:	85 c0                	test   %eax,%eax
80102a1f:	75 f7                	jne    80102a18 <iderw+0x68>
80102a21:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102a24:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102a26:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
80102a2c:	74 42                	je     80102a70 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a2e:	8b 03                	mov    (%ebx),%eax
80102a30:	83 e0 06             	and    $0x6,%eax
80102a33:	83 f8 02             	cmp    $0x2,%eax
80102a36:	74 23                	je     80102a5b <iderw+0xab>
80102a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a3f:	90                   	nop
    sleep(b, &idelock);
80102a40:	83 ec 08             	sub    $0x8,%esp
80102a43:	68 80 b5 10 80       	push   $0x8010b580
80102a48:	53                   	push   %ebx
80102a49:	e8 d2 1d 00 00       	call   80104820 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a4e:	8b 03                	mov    (%ebx),%eax
80102a50:	83 c4 10             	add    $0x10,%esp
80102a53:	83 e0 06             	and    $0x6,%eax
80102a56:	83 f8 02             	cmp    $0x2,%eax
80102a59:	75 e5                	jne    80102a40 <iderw+0x90>
  }


  release(&idelock);
80102a5b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102a62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a65:	c9                   	leave  
  release(&idelock);
80102a66:	e9 85 25 00 00       	jmp    80104ff0 <release>
80102a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a6f:	90                   	nop
    idestart(b);
80102a70:	89 d8                	mov    %ebx,%eax
80102a72:	e8 29 fd ff ff       	call   801027a0 <idestart>
80102a77:	eb b5                	jmp    80102a2e <iderw+0x7e>
80102a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a80:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102a85:	eb 9d                	jmp    80102a24 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102a87:	83 ec 0c             	sub    $0xc,%esp
80102a8a:	68 f9 83 10 80       	push   $0x801083f9
80102a8f:	e8 fc d8 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102a94:	83 ec 0c             	sub    $0xc,%esp
80102a97:	68 e4 83 10 80       	push   $0x801083e4
80102a9c:	e8 ef d8 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102aa1:	83 ec 0c             	sub    $0xc,%esp
80102aa4:	68 ce 83 10 80       	push   $0x801083ce
80102aa9:	e8 e2 d8 ff ff       	call   80100390 <panic>
80102aae:	66 90                	xchg   %ax,%ax

80102ab0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102ab0:	f3 0f 1e fb          	endbr32 
80102ab4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102ab5:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
80102abc:	00 c0 fe 
{
80102abf:	89 e5                	mov    %esp,%ebp
80102ac1:	56                   	push   %esi
80102ac2:	53                   	push   %ebx
  ioapic->reg = reg;
80102ac3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102aca:	00 00 00 
  return ioapic->data;
80102acd:	8b 15 54 36 11 80    	mov    0x80113654,%edx
80102ad3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102ad6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102adc:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102ae2:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102ae9:	c1 ee 10             	shr    $0x10,%esi
80102aec:	89 f0                	mov    %esi,%eax
80102aee:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102af1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102af4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102af7:	39 c2                	cmp    %eax,%edx
80102af9:	74 16                	je     80102b11 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102afb:	83 ec 0c             	sub    $0xc,%esp
80102afe:	68 18 84 10 80       	push   $0x80108418
80102b03:	e8 a8 db ff ff       	call   801006b0 <cprintf>
80102b08:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102b0e:	83 c4 10             	add    $0x10,%esp
80102b11:	83 c6 21             	add    $0x21,%esi
{
80102b14:	ba 10 00 00 00       	mov    $0x10,%edx
80102b19:	b8 20 00 00 00       	mov    $0x20,%eax
80102b1e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102b20:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b22:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102b24:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102b2a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b2d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102b33:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102b36:	8d 5a 01             	lea    0x1(%edx),%ebx
80102b39:	83 c2 02             	add    $0x2,%edx
80102b3c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102b3e:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102b44:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102b4b:	39 f0                	cmp    %esi,%eax
80102b4d:	75 d1                	jne    80102b20 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b52:	5b                   	pop    %ebx
80102b53:	5e                   	pop    %esi
80102b54:	5d                   	pop    %ebp
80102b55:	c3                   	ret    
80102b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b5d:	8d 76 00             	lea    0x0(%esi),%esi

80102b60 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b60:	f3 0f 1e fb          	endbr32 
80102b64:	55                   	push   %ebp
  ioapic->reg = reg;
80102b65:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
{
80102b6b:	89 e5                	mov    %esp,%ebp
80102b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b70:	8d 50 20             	lea    0x20(%eax),%edx
80102b73:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102b77:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102b79:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b7f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102b82:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b85:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102b88:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102b8a:	a1 54 36 11 80       	mov    0x80113654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b8f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102b92:	89 50 10             	mov    %edx,0x10(%eax)
}
80102b95:	5d                   	pop    %ebp
80102b96:	c3                   	ret    
80102b97:	66 90                	xchg   %ax,%ax
80102b99:	66 90                	xchg   %ax,%ax
80102b9b:	66 90                	xchg   %ax,%ax
80102b9d:	66 90                	xchg   %ax,%ax
80102b9f:	90                   	nop

80102ba0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102ba0:	f3 0f 1e fb          	endbr32 
80102ba4:	55                   	push   %ebp
80102ba5:	89 e5                	mov    %esp,%ebp
80102ba7:	53                   	push   %ebx
80102ba8:	83 ec 04             	sub    $0x4,%esp
80102bab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102bae:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102bb4:	75 7a                	jne    80102c30 <kfree+0x90>
80102bb6:	81 fb c8 29 12 80    	cmp    $0x801229c8,%ebx
80102bbc:	72 72                	jb     80102c30 <kfree+0x90>
80102bbe:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102bc4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102bc9:	77 65                	ja     80102c30 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102bcb:	83 ec 04             	sub    $0x4,%esp
80102bce:	68 00 10 00 00       	push   $0x1000
80102bd3:	6a 01                	push   $0x1
80102bd5:	53                   	push   %ebx
80102bd6:	e8 65 24 00 00       	call   80105040 <memset>

  if(kmem.use_lock)
80102bdb:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102be1:	83 c4 10             	add    $0x10,%esp
80102be4:	85 d2                	test   %edx,%edx
80102be6:	75 20                	jne    80102c08 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102be8:	a1 98 36 11 80       	mov    0x80113698,%eax
80102bed:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102bef:	a1 94 36 11 80       	mov    0x80113694,%eax
  kmem.freelist = r;
80102bf4:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock)
80102bfa:	85 c0                	test   %eax,%eax
80102bfc:	75 22                	jne    80102c20 <kfree+0x80>
    release(&kmem.lock);
}
80102bfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c01:	c9                   	leave  
80102c02:	c3                   	ret    
80102c03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c07:	90                   	nop
    acquire(&kmem.lock);
80102c08:	83 ec 0c             	sub    $0xc,%esp
80102c0b:	68 60 36 11 80       	push   $0x80113660
80102c10:	e8 1b 23 00 00       	call   80104f30 <acquire>
80102c15:	83 c4 10             	add    $0x10,%esp
80102c18:	eb ce                	jmp    80102be8 <kfree+0x48>
80102c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102c20:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
80102c27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c2a:	c9                   	leave  
    release(&kmem.lock);
80102c2b:	e9 c0 23 00 00       	jmp    80104ff0 <release>
    panic("kfree");
80102c30:	83 ec 0c             	sub    $0xc,%esp
80102c33:	68 4a 84 10 80       	push   $0x8010844a
80102c38:	e8 53 d7 ff ff       	call   80100390 <panic>
80102c3d:	8d 76 00             	lea    0x0(%esi),%esi

80102c40 <freerange>:
{
80102c40:	f3 0f 1e fb          	endbr32 
80102c44:	55                   	push   %ebp
80102c45:	89 e5                	mov    %esp,%ebp
80102c47:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102c48:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102c4b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102c4e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102c4f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c55:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c5b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c61:	39 de                	cmp    %ebx,%esi
80102c63:	72 1f                	jb     80102c84 <freerange+0x44>
80102c65:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102c68:	83 ec 0c             	sub    $0xc,%esp
80102c6b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c71:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102c77:	50                   	push   %eax
80102c78:	e8 23 ff ff ff       	call   80102ba0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c7d:	83 c4 10             	add    $0x10,%esp
80102c80:	39 f3                	cmp    %esi,%ebx
80102c82:	76 e4                	jbe    80102c68 <freerange+0x28>
}
80102c84:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c87:	5b                   	pop    %ebx
80102c88:	5e                   	pop    %esi
80102c89:	5d                   	pop    %ebp
80102c8a:	c3                   	ret    
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop

80102c90 <kinit1>:
{
80102c90:	f3 0f 1e fb          	endbr32 
80102c94:	55                   	push   %ebp
80102c95:	89 e5                	mov    %esp,%ebp
80102c97:	56                   	push   %esi
80102c98:	53                   	push   %ebx
80102c99:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102c9c:	83 ec 08             	sub    $0x8,%esp
80102c9f:	68 50 84 10 80       	push   $0x80108450
80102ca4:	68 60 36 11 80       	push   $0x80113660
80102ca9:	e8 02 21 00 00       	call   80104db0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102cae:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cb1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102cb4:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102cbb:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102cbe:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102cc4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102cd0:	39 de                	cmp    %ebx,%esi
80102cd2:	72 20                	jb     80102cf4 <kinit1+0x64>
80102cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102cd8:	83 ec 0c             	sub    $0xc,%esp
80102cdb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ce1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ce7:	50                   	push   %eax
80102ce8:	e8 b3 fe ff ff       	call   80102ba0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ced:	83 c4 10             	add    $0x10,%esp
80102cf0:	39 de                	cmp    %ebx,%esi
80102cf2:	73 e4                	jae    80102cd8 <kinit1+0x48>
}
80102cf4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102cf7:	5b                   	pop    %ebx
80102cf8:	5e                   	pop    %esi
80102cf9:	5d                   	pop    %ebp
80102cfa:	c3                   	ret    
80102cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cff:	90                   	nop

80102d00 <kinit2>:
{
80102d00:	f3 0f 1e fb          	endbr32 
80102d04:	55                   	push   %ebp
80102d05:	89 e5                	mov    %esp,%ebp
80102d07:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102d08:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102d0b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102d0e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102d0f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102d15:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d1b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102d21:	39 de                	cmp    %ebx,%esi
80102d23:	72 1f                	jb     80102d44 <kinit2+0x44>
80102d25:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102d28:	83 ec 0c             	sub    $0xc,%esp
80102d2b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d31:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102d37:	50                   	push   %eax
80102d38:	e8 63 fe ff ff       	call   80102ba0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d3d:	83 c4 10             	add    $0x10,%esp
80102d40:	39 de                	cmp    %ebx,%esi
80102d42:	73 e4                	jae    80102d28 <kinit2+0x28>
  kmem.use_lock = 1;
80102d44:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
80102d4b:	00 00 00 
}
80102d4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d51:	5b                   	pop    %ebx
80102d52:	5e                   	pop    %esi
80102d53:	5d                   	pop    %ebp
80102d54:	c3                   	ret    
80102d55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102d60 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d60:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102d64:	a1 94 36 11 80       	mov    0x80113694,%eax
80102d69:	85 c0                	test   %eax,%eax
80102d6b:	75 1b                	jne    80102d88 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102d6d:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
80102d72:	85 c0                	test   %eax,%eax
80102d74:	74 0a                	je     80102d80 <kalloc+0x20>
    kmem.freelist = r->next;
80102d76:	8b 10                	mov    (%eax),%edx
80102d78:	89 15 98 36 11 80    	mov    %edx,0x80113698
  if(kmem.use_lock)
80102d7e:	c3                   	ret    
80102d7f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102d80:	c3                   	ret    
80102d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102d88:	55                   	push   %ebp
80102d89:	89 e5                	mov    %esp,%ebp
80102d8b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102d8e:	68 60 36 11 80       	push   $0x80113660
80102d93:	e8 98 21 00 00       	call   80104f30 <acquire>
  r = kmem.freelist;
80102d98:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
80102d9d:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102da3:	83 c4 10             	add    $0x10,%esp
80102da6:	85 c0                	test   %eax,%eax
80102da8:	74 08                	je     80102db2 <kalloc+0x52>
    kmem.freelist = r->next;
80102daa:	8b 08                	mov    (%eax),%ecx
80102dac:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  if(kmem.use_lock)
80102db2:	85 d2                	test   %edx,%edx
80102db4:	74 16                	je     80102dcc <kalloc+0x6c>
    release(&kmem.lock);
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102dbc:	68 60 36 11 80       	push   $0x80113660
80102dc1:	e8 2a 22 00 00       	call   80104ff0 <release>
  return (char*)r;
80102dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102dc9:	83 c4 10             	add    $0x10,%esp
}
80102dcc:	c9                   	leave  
80102dcd:	c3                   	ret    
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102dd0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dd4:	ba 64 00 00 00       	mov    $0x64,%edx
80102dd9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102dda:	a8 01                	test   $0x1,%al
80102ddc:	0f 84 be 00 00 00    	je     80102ea0 <kbdgetc+0xd0>
{
80102de2:	55                   	push   %ebp
80102de3:	ba 60 00 00 00       	mov    $0x60,%edx
80102de8:	89 e5                	mov    %esp,%ebp
80102dea:	53                   	push   %ebx
80102deb:	ec                   	in     (%dx),%al
  return data;
80102dec:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102df2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102df5:	3c e0                	cmp    $0xe0,%al
80102df7:	74 57                	je     80102e50 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102df9:	89 d9                	mov    %ebx,%ecx
80102dfb:	83 e1 40             	and    $0x40,%ecx
80102dfe:	84 c0                	test   %al,%al
80102e00:	78 5e                	js     80102e60 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102e02:	85 c9                	test   %ecx,%ecx
80102e04:	74 09                	je     80102e0f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e06:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102e09:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102e0c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102e0f:	0f b6 8a 80 85 10 80 	movzbl -0x7fef7a80(%edx),%ecx
  shift ^= togglecode[data];
80102e16:	0f b6 82 80 84 10 80 	movzbl -0x7fef7b80(%edx),%eax
  shift |= shiftcode[data];
80102e1d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102e1f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102e21:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102e23:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102e29:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102e2c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102e2f:	8b 04 85 60 84 10 80 	mov    -0x7fef7ba0(,%eax,4),%eax
80102e36:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102e3a:	74 0b                	je     80102e47 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102e3c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102e3f:	83 fa 19             	cmp    $0x19,%edx
80102e42:	77 44                	ja     80102e88 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102e44:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102e47:	5b                   	pop    %ebx
80102e48:	5d                   	pop    %ebp
80102e49:	c3                   	ret    
80102e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102e50:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102e53:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102e55:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
80102e5b:	5b                   	pop    %ebx
80102e5c:	5d                   	pop    %ebp
80102e5d:	c3                   	ret    
80102e5e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102e60:	83 e0 7f             	and    $0x7f,%eax
80102e63:	85 c9                	test   %ecx,%ecx
80102e65:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102e68:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102e6a:	0f b6 8a 80 85 10 80 	movzbl -0x7fef7a80(%edx),%ecx
80102e71:	83 c9 40             	or     $0x40,%ecx
80102e74:	0f b6 c9             	movzbl %cl,%ecx
80102e77:	f7 d1                	not    %ecx
80102e79:	21 d9                	and    %ebx,%ecx
}
80102e7b:	5b                   	pop    %ebx
80102e7c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102e7d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102e83:	c3                   	ret    
80102e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102e88:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102e8b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102e8e:	5b                   	pop    %ebx
80102e8f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102e90:	83 f9 1a             	cmp    $0x1a,%ecx
80102e93:	0f 42 c2             	cmovb  %edx,%eax
}
80102e96:	c3                   	ret    
80102e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e9e:	66 90                	xchg   %ax,%ax
    return -1;
80102ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ea5:	c3                   	ret    
80102ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ead:	8d 76 00             	lea    0x0(%esi),%esi

80102eb0 <kbdintr>:

void
kbdintr(void)
{
80102eb0:	f3 0f 1e fb          	endbr32 
80102eb4:	55                   	push   %ebp
80102eb5:	89 e5                	mov    %esp,%ebp
80102eb7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102eba:	68 d0 2d 10 80       	push   $0x80102dd0
80102ebf:	e8 9c d9 ff ff       	call   80100860 <consoleintr>
}
80102ec4:	83 c4 10             	add    $0x10,%esp
80102ec7:	c9                   	leave  
80102ec8:	c3                   	ret    
80102ec9:	66 90                	xchg   %ax,%ax
80102ecb:	66 90                	xchg   %ax,%ax
80102ecd:	66 90                	xchg   %ax,%ax
80102ecf:	90                   	nop

80102ed0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102ed0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102ed4:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80102ed9:	85 c0                	test   %eax,%eax
80102edb:	0f 84 c7 00 00 00    	je     80102fa8 <lapicinit+0xd8>
  lapic[index] = value;
80102ee1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102ee8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102eeb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eee:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ef5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ef8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102efb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102f02:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102f05:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f08:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102f0f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102f12:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f15:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102f1c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f1f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f22:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102f29:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f2c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f2f:	8b 50 30             	mov    0x30(%eax),%edx
80102f32:	c1 ea 10             	shr    $0x10,%edx
80102f35:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102f3b:	75 73                	jne    80102fb0 <lapicinit+0xe0>
  lapic[index] = value;
80102f3d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102f44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f47:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f4a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f51:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f54:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f57:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f5e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f61:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f64:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f6b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f6e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f71:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102f78:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f7b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f7e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102f85:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102f88:	8b 50 20             	mov    0x20(%eax),%edx
80102f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f8f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102f90:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102f96:	80 e6 10             	and    $0x10,%dh
80102f99:	75 f5                	jne    80102f90 <lapicinit+0xc0>
  lapic[index] = value;
80102f9b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102fa2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fa5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102fa8:	c3                   	ret    
80102fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102fb0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102fb7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102fba:	8b 50 20             	mov    0x20(%eax),%edx
}
80102fbd:	e9 7b ff ff ff       	jmp    80102f3d <lapicinit+0x6d>
80102fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fd0 <lapicid>:

int
lapicid(void)
{
80102fd0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102fd4:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80102fd9:	85 c0                	test   %eax,%eax
80102fdb:	74 0b                	je     80102fe8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102fdd:	8b 40 20             	mov    0x20(%eax),%eax
80102fe0:	c1 e8 18             	shr    $0x18,%eax
80102fe3:	c3                   	ret    
80102fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102fe8:	31 c0                	xor    %eax,%eax
}
80102fea:	c3                   	ret    
80102feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fef:	90                   	nop

80102ff0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ff0:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102ff4:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80102ff9:	85 c0                	test   %eax,%eax
80102ffb:	74 0d                	je     8010300a <lapiceoi+0x1a>
  lapic[index] = value;
80102ffd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103004:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103007:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010300a:	c3                   	ret    
8010300b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010300f:	90                   	nop

80103010 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103010:	f3 0f 1e fb          	endbr32 
}
80103014:	c3                   	ret    
80103015:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010301c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103020 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103020:	f3 0f 1e fb          	endbr32 
80103024:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103025:	b8 0f 00 00 00       	mov    $0xf,%eax
8010302a:	ba 70 00 00 00       	mov    $0x70,%edx
8010302f:	89 e5                	mov    %esp,%ebp
80103031:	53                   	push   %ebx
80103032:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103035:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103038:	ee                   	out    %al,(%dx)
80103039:	b8 0a 00 00 00       	mov    $0xa,%eax
8010303e:	ba 71 00 00 00       	mov    $0x71,%edx
80103043:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103044:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103046:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103049:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010304f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103051:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103054:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103056:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103059:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010305c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103062:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80103067:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010306d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103070:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103077:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010307a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010307d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103084:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103087:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010308a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103090:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103093:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103099:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010309c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801030a2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030a5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801030ab:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801030ac:	8b 40 20             	mov    0x20(%eax),%eax
}
801030af:	5d                   	pop    %ebp
801030b0:	c3                   	ret    
801030b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030bf:	90                   	nop

801030c0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801030c0:	f3 0f 1e fb          	endbr32 
801030c4:	55                   	push   %ebp
801030c5:	b8 0b 00 00 00       	mov    $0xb,%eax
801030ca:	ba 70 00 00 00       	mov    $0x70,%edx
801030cf:	89 e5                	mov    %esp,%ebp
801030d1:	57                   	push   %edi
801030d2:	56                   	push   %esi
801030d3:	53                   	push   %ebx
801030d4:	83 ec 4c             	sub    $0x4c,%esp
801030d7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030d8:	ba 71 00 00 00       	mov    $0x71,%edx
801030dd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801030de:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030e1:	bb 70 00 00 00       	mov    $0x70,%ebx
801030e6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801030e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030f0:	31 c0                	xor    %eax,%eax
801030f2:	89 da                	mov    %ebx,%edx
801030f4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030f5:	b9 71 00 00 00       	mov    $0x71,%ecx
801030fa:	89 ca                	mov    %ecx,%edx
801030fc:	ec                   	in     (%dx),%al
801030fd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103100:	89 da                	mov    %ebx,%edx
80103102:	b8 02 00 00 00       	mov    $0x2,%eax
80103107:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103108:	89 ca                	mov    %ecx,%edx
8010310a:	ec                   	in     (%dx),%al
8010310b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010310e:	89 da                	mov    %ebx,%edx
80103110:	b8 04 00 00 00       	mov    $0x4,%eax
80103115:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103116:	89 ca                	mov    %ecx,%edx
80103118:	ec                   	in     (%dx),%al
80103119:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010311c:	89 da                	mov    %ebx,%edx
8010311e:	b8 07 00 00 00       	mov    $0x7,%eax
80103123:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103124:	89 ca                	mov    %ecx,%edx
80103126:	ec                   	in     (%dx),%al
80103127:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010312a:	89 da                	mov    %ebx,%edx
8010312c:	b8 08 00 00 00       	mov    $0x8,%eax
80103131:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103132:	89 ca                	mov    %ecx,%edx
80103134:	ec                   	in     (%dx),%al
80103135:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103137:	89 da                	mov    %ebx,%edx
80103139:	b8 09 00 00 00       	mov    $0x9,%eax
8010313e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010313f:	89 ca                	mov    %ecx,%edx
80103141:	ec                   	in     (%dx),%al
80103142:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103144:	89 da                	mov    %ebx,%edx
80103146:	b8 0a 00 00 00       	mov    $0xa,%eax
8010314b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010314c:	89 ca                	mov    %ecx,%edx
8010314e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010314f:	84 c0                	test   %al,%al
80103151:	78 9d                	js     801030f0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80103153:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103157:	89 fa                	mov    %edi,%edx
80103159:	0f b6 fa             	movzbl %dl,%edi
8010315c:	89 f2                	mov    %esi,%edx
8010315e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103161:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103165:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103168:	89 da                	mov    %ebx,%edx
8010316a:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010316d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103170:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103174:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103177:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010317a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
8010317e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103181:	31 c0                	xor    %eax,%eax
80103183:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103184:	89 ca                	mov    %ecx,%edx
80103186:	ec                   	in     (%dx),%al
80103187:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010318a:	89 da                	mov    %ebx,%edx
8010318c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010318f:	b8 02 00 00 00       	mov    $0x2,%eax
80103194:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103195:	89 ca                	mov    %ecx,%edx
80103197:	ec                   	in     (%dx),%al
80103198:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010319b:	89 da                	mov    %ebx,%edx
8010319d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801031a0:	b8 04 00 00 00       	mov    $0x4,%eax
801031a5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031a6:	89 ca                	mov    %ecx,%edx
801031a8:	ec                   	in     (%dx),%al
801031a9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ac:	89 da                	mov    %ebx,%edx
801031ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
801031b1:	b8 07 00 00 00       	mov    $0x7,%eax
801031b6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b7:	89 ca                	mov    %ecx,%edx
801031b9:	ec                   	in     (%dx),%al
801031ba:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031bd:	89 da                	mov    %ebx,%edx
801031bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801031c2:	b8 08 00 00 00       	mov    $0x8,%eax
801031c7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031c8:	89 ca                	mov    %ecx,%edx
801031ca:	ec                   	in     (%dx),%al
801031cb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ce:	89 da                	mov    %ebx,%edx
801031d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801031d3:	b8 09 00 00 00       	mov    $0x9,%eax
801031d8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031d9:	89 ca                	mov    %ecx,%edx
801031db:	ec                   	in     (%dx),%al
801031dc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801031df:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801031e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801031e5:	8d 45 d0             	lea    -0x30(%ebp),%eax
801031e8:	6a 18                	push   $0x18
801031ea:	50                   	push   %eax
801031eb:	8d 45 b8             	lea    -0x48(%ebp),%eax
801031ee:	50                   	push   %eax
801031ef:	e8 9c 1e 00 00       	call   80105090 <memcmp>
801031f4:	83 c4 10             	add    $0x10,%esp
801031f7:	85 c0                	test   %eax,%eax
801031f9:	0f 85 f1 fe ff ff    	jne    801030f0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801031ff:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103203:	75 78                	jne    8010327d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103205:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103208:	89 c2                	mov    %eax,%edx
8010320a:	83 e0 0f             	and    $0xf,%eax
8010320d:	c1 ea 04             	shr    $0x4,%edx
80103210:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103213:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103216:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103219:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010321c:	89 c2                	mov    %eax,%edx
8010321e:	83 e0 0f             	and    $0xf,%eax
80103221:	c1 ea 04             	shr    $0x4,%edx
80103224:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103227:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010322a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010322d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103230:	89 c2                	mov    %eax,%edx
80103232:	83 e0 0f             	and    $0xf,%eax
80103235:	c1 ea 04             	shr    $0x4,%edx
80103238:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010323b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010323e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103241:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103244:	89 c2                	mov    %eax,%edx
80103246:	83 e0 0f             	and    $0xf,%eax
80103249:	c1 ea 04             	shr    $0x4,%edx
8010324c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010324f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103252:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103255:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103258:	89 c2                	mov    %eax,%edx
8010325a:	83 e0 0f             	and    $0xf,%eax
8010325d:	c1 ea 04             	shr    $0x4,%edx
80103260:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103263:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103266:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103269:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010326c:	89 c2                	mov    %eax,%edx
8010326e:	83 e0 0f             	and    $0xf,%eax
80103271:	c1 ea 04             	shr    $0x4,%edx
80103274:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103277:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010327a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010327d:	8b 75 08             	mov    0x8(%ebp),%esi
80103280:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103283:	89 06                	mov    %eax,(%esi)
80103285:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103288:	89 46 04             	mov    %eax,0x4(%esi)
8010328b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010328e:	89 46 08             	mov    %eax,0x8(%esi)
80103291:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103294:	89 46 0c             	mov    %eax,0xc(%esi)
80103297:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010329a:	89 46 10             	mov    %eax,0x10(%esi)
8010329d:	8b 45 cc             	mov    -0x34(%ebp),%eax
801032a0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801032a3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801032aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032ad:	5b                   	pop    %ebx
801032ae:	5e                   	pop    %esi
801032af:	5f                   	pop    %edi
801032b0:	5d                   	pop    %ebp
801032b1:	c3                   	ret    
801032b2:	66 90                	xchg   %ax,%ax
801032b4:	66 90                	xchg   %ax,%ax
801032b6:	66 90                	xchg   %ax,%ax
801032b8:	66 90                	xchg   %ax,%ax
801032ba:	66 90                	xchg   %ax,%ax
801032bc:	66 90                	xchg   %ax,%ax
801032be:	66 90                	xchg   %ax,%ax

801032c0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032c0:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
801032c6:	85 c9                	test   %ecx,%ecx
801032c8:	0f 8e 8a 00 00 00    	jle    80103358 <install_trans+0x98>
{
801032ce:	55                   	push   %ebp
801032cf:	89 e5                	mov    %esp,%ebp
801032d1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
801032d2:	31 ff                	xor    %edi,%edi
{
801032d4:	56                   	push   %esi
801032d5:	53                   	push   %ebx
801032d6:	83 ec 0c             	sub    $0xc,%esp
801032d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032e0:	a1 d4 36 11 80       	mov    0x801136d4,%eax
801032e5:	83 ec 08             	sub    $0x8,%esp
801032e8:	01 f8                	add    %edi,%eax
801032ea:	83 c0 01             	add    $0x1,%eax
801032ed:	50                   	push   %eax
801032ee:	ff 35 e4 36 11 80    	pushl  0x801136e4
801032f4:	e8 d7 cd ff ff       	call   801000d0 <bread>
801032f9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801032fb:	58                   	pop    %eax
801032fc:	5a                   	pop    %edx
801032fd:	ff 34 bd ec 36 11 80 	pushl  -0x7feec914(,%edi,4)
80103304:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010330a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010330d:	e8 be cd ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103312:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103315:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103317:	8d 46 5c             	lea    0x5c(%esi),%eax
8010331a:	68 00 02 00 00       	push   $0x200
8010331f:	50                   	push   %eax
80103320:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103323:	50                   	push   %eax
80103324:	e8 b7 1d 00 00       	call   801050e0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103329:	89 1c 24             	mov    %ebx,(%esp)
8010332c:	e8 7f ce ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103331:	89 34 24             	mov    %esi,(%esp)
80103334:	e8 b7 ce ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103339:	89 1c 24             	mov    %ebx,(%esp)
8010333c:	e8 af ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103341:	83 c4 10             	add    $0x10,%esp
80103344:	39 3d e8 36 11 80    	cmp    %edi,0x801136e8
8010334a:	7f 94                	jg     801032e0 <install_trans+0x20>
  }
}
8010334c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010334f:	5b                   	pop    %ebx
80103350:	5e                   	pop    %esi
80103351:	5f                   	pop    %edi
80103352:	5d                   	pop    %ebp
80103353:	c3                   	ret    
80103354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103358:	c3                   	ret    
80103359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103360 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	53                   	push   %ebx
80103364:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103367:	ff 35 d4 36 11 80    	pushl  0x801136d4
8010336d:	ff 35 e4 36 11 80    	pushl  0x801136e4
80103373:	e8 58 cd ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103378:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010337b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010337d:	a1 e8 36 11 80       	mov    0x801136e8,%eax
80103382:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103385:	85 c0                	test   %eax,%eax
80103387:	7e 19                	jle    801033a2 <write_head+0x42>
80103389:	31 d2                	xor    %edx,%edx
8010338b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010338f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103390:	8b 0c 95 ec 36 11 80 	mov    -0x7feec914(,%edx,4),%ecx
80103397:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010339b:	83 c2 01             	add    $0x1,%edx
8010339e:	39 d0                	cmp    %edx,%eax
801033a0:	75 ee                	jne    80103390 <write_head+0x30>
  }
  bwrite(buf);
801033a2:	83 ec 0c             	sub    $0xc,%esp
801033a5:	53                   	push   %ebx
801033a6:	e8 05 ce ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801033ab:	89 1c 24             	mov    %ebx,(%esp)
801033ae:	e8 3d ce ff ff       	call   801001f0 <brelse>
}
801033b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033b6:	83 c4 10             	add    $0x10,%esp
801033b9:	c9                   	leave  
801033ba:	c3                   	ret    
801033bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033bf:	90                   	nop

801033c0 <initlog>:
{
801033c0:	f3 0f 1e fb          	endbr32 
801033c4:	55                   	push   %ebp
801033c5:	89 e5                	mov    %esp,%ebp
801033c7:	53                   	push   %ebx
801033c8:	83 ec 2c             	sub    $0x2c,%esp
801033cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801033ce:	68 80 86 10 80       	push   $0x80108680
801033d3:	68 a0 36 11 80       	push   $0x801136a0
801033d8:	e8 d3 19 00 00       	call   80104db0 <initlock>
  readsb(dev, &sb);
801033dd:	58                   	pop    %eax
801033de:	8d 45 dc             	lea    -0x24(%ebp),%eax
801033e1:	5a                   	pop    %edx
801033e2:	50                   	push   %eax
801033e3:	53                   	push   %ebx
801033e4:	e8 c7 e4 ff ff       	call   801018b0 <readsb>
  log.start = sb.logstart;
801033e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801033ec:	59                   	pop    %ecx
  log.dev = dev;
801033ed:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
801033f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801033f6:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  log.size = sb.nlog;
801033fb:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  struct buf *buf = bread(log.dev, log.start);
80103401:	5a                   	pop    %edx
80103402:	50                   	push   %eax
80103403:	53                   	push   %ebx
80103404:	e8 c7 cc ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103409:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010340c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010340f:	89 0d e8 36 11 80    	mov    %ecx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80103415:	85 c9                	test   %ecx,%ecx
80103417:	7e 19                	jle    80103432 <initlog+0x72>
80103419:	31 d2                	xor    %edx,%edx
8010341b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010341f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103420:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103424:	89 1c 95 ec 36 11 80 	mov    %ebx,-0x7feec914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010342b:	83 c2 01             	add    $0x1,%edx
8010342e:	39 d1                	cmp    %edx,%ecx
80103430:	75 ee                	jne    80103420 <initlog+0x60>
  brelse(buf);
80103432:	83 ec 0c             	sub    $0xc,%esp
80103435:	50                   	push   %eax
80103436:	e8 b5 cd ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010343b:	e8 80 fe ff ff       	call   801032c0 <install_trans>
  log.lh.n = 0;
80103440:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80103447:	00 00 00 
  write_head(); // clear the log
8010344a:	e8 11 ff ff ff       	call   80103360 <write_head>
}
8010344f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103452:	83 c4 10             	add    $0x10,%esp
80103455:	c9                   	leave  
80103456:	c3                   	ret    
80103457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010345e:	66 90                	xchg   %ax,%ax

80103460 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103460:	f3 0f 1e fb          	endbr32 
80103464:	55                   	push   %ebp
80103465:	89 e5                	mov    %esp,%ebp
80103467:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010346a:	68 a0 36 11 80       	push   $0x801136a0
8010346f:	e8 bc 1a 00 00       	call   80104f30 <acquire>
80103474:	83 c4 10             	add    $0x10,%esp
80103477:	eb 1c                	jmp    80103495 <begin_op+0x35>
80103479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103480:	83 ec 08             	sub    $0x8,%esp
80103483:	68 a0 36 11 80       	push   $0x801136a0
80103488:	68 a0 36 11 80       	push   $0x801136a0
8010348d:	e8 8e 13 00 00       	call   80104820 <sleep>
80103492:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103495:	a1 e0 36 11 80       	mov    0x801136e0,%eax
8010349a:	85 c0                	test   %eax,%eax
8010349c:	75 e2                	jne    80103480 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010349e:	a1 dc 36 11 80       	mov    0x801136dc,%eax
801034a3:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
801034a9:	83 c0 01             	add    $0x1,%eax
801034ac:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801034af:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801034b2:	83 fa 1e             	cmp    $0x1e,%edx
801034b5:	7f c9                	jg     80103480 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801034b7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801034ba:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
801034bf:	68 a0 36 11 80       	push   $0x801136a0
801034c4:	e8 27 1b 00 00       	call   80104ff0 <release>
      break;
    }
  }
}
801034c9:	83 c4 10             	add    $0x10,%esp
801034cc:	c9                   	leave  
801034cd:	c3                   	ret    
801034ce:	66 90                	xchg   %ax,%ax

801034d0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801034d0:	f3 0f 1e fb          	endbr32 
801034d4:	55                   	push   %ebp
801034d5:	89 e5                	mov    %esp,%ebp
801034d7:	57                   	push   %edi
801034d8:	56                   	push   %esi
801034d9:	53                   	push   %ebx
801034da:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801034dd:	68 a0 36 11 80       	push   $0x801136a0
801034e2:	e8 49 1a 00 00       	call   80104f30 <acquire>
  log.outstanding -= 1;
801034e7:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
801034ec:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
801034f2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801034f5:	8d 58 ff             	lea    -0x1(%eax),%ebx
801034f8:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
801034fe:	85 f6                	test   %esi,%esi
80103500:	0f 85 1e 01 00 00    	jne    80103624 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103506:	85 db                	test   %ebx,%ebx
80103508:	0f 85 f2 00 00 00    	jne    80103600 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010350e:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80103515:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103518:	83 ec 0c             	sub    $0xc,%esp
8010351b:	68 a0 36 11 80       	push   $0x801136a0
80103520:	e8 cb 1a 00 00       	call   80104ff0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103525:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
8010352b:	83 c4 10             	add    $0x10,%esp
8010352e:	85 c9                	test   %ecx,%ecx
80103530:	7f 3e                	jg     80103570 <end_op+0xa0>
    acquire(&log.lock);
80103532:	83 ec 0c             	sub    $0xc,%esp
80103535:	68 a0 36 11 80       	push   $0x801136a0
8010353a:	e8 f1 19 00 00       	call   80104f30 <acquire>
    wakeup(&log);
8010353f:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80103546:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
8010354d:	00 00 00 
    wakeup(&log);
80103550:	e8 2b 15 00 00       	call   80104a80 <wakeup>
    release(&log.lock);
80103555:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
8010355c:	e8 8f 1a 00 00       	call   80104ff0 <release>
80103561:	83 c4 10             	add    $0x10,%esp
}
80103564:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103567:	5b                   	pop    %ebx
80103568:	5e                   	pop    %esi
80103569:	5f                   	pop    %edi
8010356a:	5d                   	pop    %ebp
8010356b:	c3                   	ret    
8010356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103570:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80103575:	83 ec 08             	sub    $0x8,%esp
80103578:	01 d8                	add    %ebx,%eax
8010357a:	83 c0 01             	add    $0x1,%eax
8010357d:	50                   	push   %eax
8010357e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80103584:	e8 47 cb ff ff       	call   801000d0 <bread>
80103589:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010358b:	58                   	pop    %eax
8010358c:	5a                   	pop    %edx
8010358d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80103594:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010359a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010359d:	e8 2e cb ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801035a2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801035a5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801035a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801035aa:	68 00 02 00 00       	push   $0x200
801035af:	50                   	push   %eax
801035b0:	8d 46 5c             	lea    0x5c(%esi),%eax
801035b3:	50                   	push   %eax
801035b4:	e8 27 1b 00 00       	call   801050e0 <memmove>
    bwrite(to);  // write the log
801035b9:	89 34 24             	mov    %esi,(%esp)
801035bc:	e8 ef cb ff ff       	call   801001b0 <bwrite>
    brelse(from);
801035c1:	89 3c 24             	mov    %edi,(%esp)
801035c4:	e8 27 cc ff ff       	call   801001f0 <brelse>
    brelse(to);
801035c9:	89 34 24             	mov    %esi,(%esp)
801035cc:	e8 1f cc ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801035d1:	83 c4 10             	add    $0x10,%esp
801035d4:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
801035da:	7c 94                	jl     80103570 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801035dc:	e8 7f fd ff ff       	call   80103360 <write_head>
    install_trans(); // Now install writes to home locations
801035e1:	e8 da fc ff ff       	call   801032c0 <install_trans>
    log.lh.n = 0;
801035e6:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
801035ed:	00 00 00 
    write_head();    // Erase the transaction from the log
801035f0:	e8 6b fd ff ff       	call   80103360 <write_head>
801035f5:	e9 38 ff ff ff       	jmp    80103532 <end_op+0x62>
801035fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103600:	83 ec 0c             	sub    $0xc,%esp
80103603:	68 a0 36 11 80       	push   $0x801136a0
80103608:	e8 73 14 00 00       	call   80104a80 <wakeup>
  release(&log.lock);
8010360d:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80103614:	e8 d7 19 00 00       	call   80104ff0 <release>
80103619:	83 c4 10             	add    $0x10,%esp
}
8010361c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010361f:	5b                   	pop    %ebx
80103620:	5e                   	pop    %esi
80103621:	5f                   	pop    %edi
80103622:	5d                   	pop    %ebp
80103623:	c3                   	ret    
    panic("log.committing");
80103624:	83 ec 0c             	sub    $0xc,%esp
80103627:	68 84 86 10 80       	push   $0x80108684
8010362c:	e8 5f cd ff ff       	call   80100390 <panic>
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010363f:	90                   	nop

80103640 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103640:	f3 0f 1e fb          	endbr32 
80103644:	55                   	push   %ebp
80103645:	89 e5                	mov    %esp,%ebp
80103647:	53                   	push   %ebx
80103648:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010364b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80103651:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103654:	83 fa 1d             	cmp    $0x1d,%edx
80103657:	0f 8f 91 00 00 00    	jg     801036ee <log_write+0xae>
8010365d:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80103662:	83 e8 01             	sub    $0x1,%eax
80103665:	39 c2                	cmp    %eax,%edx
80103667:	0f 8d 81 00 00 00    	jge    801036ee <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010366d:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80103672:	85 c0                	test   %eax,%eax
80103674:	0f 8e 81 00 00 00    	jle    801036fb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010367a:	83 ec 0c             	sub    $0xc,%esp
8010367d:	68 a0 36 11 80       	push   $0x801136a0
80103682:	e8 a9 18 00 00       	call   80104f30 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103687:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
8010368d:	83 c4 10             	add    $0x10,%esp
80103690:	85 d2                	test   %edx,%edx
80103692:	7e 4e                	jle    801036e2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103694:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103697:	31 c0                	xor    %eax,%eax
80103699:	eb 0c                	jmp    801036a7 <log_write+0x67>
8010369b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010369f:	90                   	nop
801036a0:	83 c0 01             	add    $0x1,%eax
801036a3:	39 c2                	cmp    %eax,%edx
801036a5:	74 29                	je     801036d0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801036a7:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
801036ae:	75 f0                	jne    801036a0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801036b0:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801036b7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801036ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801036bd:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
801036c4:	c9                   	leave  
  release(&log.lock);
801036c5:	e9 26 19 00 00       	jmp    80104ff0 <release>
801036ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801036d0:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
    log.lh.n++;
801036d7:	83 c2 01             	add    $0x1,%edx
801036da:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
801036e0:	eb d5                	jmp    801036b7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
801036e2:	8b 43 08             	mov    0x8(%ebx),%eax
801036e5:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
801036ea:	75 cb                	jne    801036b7 <log_write+0x77>
801036ec:	eb e9                	jmp    801036d7 <log_write+0x97>
    panic("too big a transaction");
801036ee:	83 ec 0c             	sub    $0xc,%esp
801036f1:	68 93 86 10 80       	push   $0x80108693
801036f6:	e8 95 cc ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801036fb:	83 ec 0c             	sub    $0xc,%esp
801036fe:	68 a9 86 10 80       	push   $0x801086a9
80103703:	e8 88 cc ff ff       	call   80100390 <panic>
80103708:	66 90                	xchg   %ax,%ax
8010370a:	66 90                	xchg   %ax,%ax
8010370c:	66 90                	xchg   %ax,%ax
8010370e:	66 90                	xchg   %ax,%ax

80103710 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	53                   	push   %ebx
80103714:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103717:	e8 c4 09 00 00       	call   801040e0 <cpuid>
8010371c:	89 c3                	mov    %eax,%ebx
8010371e:	e8 bd 09 00 00       	call   801040e0 <cpuid>
80103723:	83 ec 04             	sub    $0x4,%esp
80103726:	53                   	push   %ebx
80103727:	50                   	push   %eax
80103728:	68 c4 86 10 80       	push   $0x801086c4
8010372d:	e8 7e cf ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103732:	e8 d9 2b 00 00       	call   80106310 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103737:	e8 34 09 00 00       	call   80104070 <mycpu>
8010373c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010373e:	b8 01 00 00 00       	mov    $0x1,%eax
80103743:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010374a:	e8 e1 0d 00 00       	call   80104530 <scheduler>
8010374f:	90                   	nop

80103750 <mpenter>:
{
80103750:	f3 0f 1e fb          	endbr32 
80103754:	55                   	push   %ebp
80103755:	89 e5                	mov    %esp,%ebp
80103757:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010375a:	e8 41 3d 00 00       	call   801074a0 <switchkvm>
  seginit();
8010375f:	e8 8c 3c 00 00       	call   801073f0 <seginit>
  lapicinit();
80103764:	e8 67 f7 ff ff       	call   80102ed0 <lapicinit>
  mpmain();
80103769:	e8 a2 ff ff ff       	call   80103710 <mpmain>
8010376e:	66 90                	xchg   %ax,%ax

80103770 <main>:
{
80103770:	f3 0f 1e fb          	endbr32 
80103774:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103778:	83 e4 f0             	and    $0xfffffff0,%esp
8010377b:	ff 71 fc             	pushl  -0x4(%ecx)
8010377e:	55                   	push   %ebp
8010377f:	89 e5                	mov    %esp,%ebp
80103781:	53                   	push   %ebx
80103782:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103783:	83 ec 08             	sub    $0x8,%esp
80103786:	68 00 00 40 80       	push   $0x80400000
8010378b:	68 c8 29 12 80       	push   $0x801229c8
80103790:	e8 fb f4 ff ff       	call   80102c90 <kinit1>
  kvmalloc();      // kernel page table
80103795:	e8 26 42 00 00       	call   801079c0 <kvmalloc>
  mpinit();        // detect other processors
8010379a:	e8 81 01 00 00       	call   80103920 <mpinit>
  lapicinit();     // interrupt controller
8010379f:	e8 2c f7 ff ff       	call   80102ed0 <lapicinit>
  seginit();       // segment descriptors
801037a4:	e8 47 3c 00 00       	call   801073f0 <seginit>
  picinit();       // disable pic
801037a9:	e8 52 03 00 00       	call   80103b00 <picinit>
  ioapicinit();    // another interrupt controller
801037ae:	e8 fd f2 ff ff       	call   80102ab0 <ioapicinit>
  consoleinit();   // console hardware
801037b3:	e8 78 d2 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801037b8:	e8 e3 2e 00 00       	call   801066a0 <uartinit>
  pinit();         // process table
801037bd:	e8 8e 08 00 00       	call   80104050 <pinit>
  tvinit();        // trap vectors
801037c2:	e8 c9 2a 00 00       	call   80106290 <tvinit>
  binit();         // buffer cache
801037c7:	e8 74 c8 ff ff       	call   80100040 <binit>
  fileinit();      // file table
801037cc:	e8 bf d9 ff ff       	call   80101190 <fileinit>
  ideinit();       // disk 
801037d1:	e8 aa f0 ff ff       	call   80102880 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801037d6:	83 c4 0c             	add    $0xc,%esp
801037d9:	68 8a 00 00 00       	push   $0x8a
801037de:	68 8c b4 10 80       	push   $0x8010b48c
801037e3:	68 00 70 00 80       	push   $0x80007000
801037e8:	e8 f3 18 00 00       	call   801050e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801037ed:	83 c4 10             	add    $0x10,%esp
801037f0:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
801037f7:	00 00 00 
801037fa:	05 a0 37 11 80       	add    $0x801137a0,%eax
801037ff:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
80103804:	76 7a                	jbe    80103880 <main+0x110>
80103806:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
8010380b:	eb 1c                	jmp    80103829 <main+0xb9>
8010380d:	8d 76 00             	lea    0x0(%esi),%esi
80103810:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80103817:	00 00 00 
8010381a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103820:	05 a0 37 11 80       	add    $0x801137a0,%eax
80103825:	39 c3                	cmp    %eax,%ebx
80103827:	73 57                	jae    80103880 <main+0x110>
    if(c == mycpu())  // We've started already.
80103829:	e8 42 08 00 00       	call   80104070 <mycpu>
8010382e:	39 c3                	cmp    %eax,%ebx
80103830:	74 de                	je     80103810 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103832:	e8 29 f5 ff ff       	call   80102d60 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103837:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010383a:	c7 05 f8 6f 00 80 50 	movl   $0x80103750,0x80006ff8
80103841:	37 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103844:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010384b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010384e:	05 00 10 00 00       	add    $0x1000,%eax
80103853:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103858:	0f b6 03             	movzbl (%ebx),%eax
8010385b:	68 00 70 00 00       	push   $0x7000
80103860:	50                   	push   %eax
80103861:	e8 ba f7 ff ff       	call   80103020 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103866:	83 c4 10             	add    $0x10,%esp
80103869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103870:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103876:	85 c0                	test   %eax,%eax
80103878:	74 f6                	je     80103870 <main+0x100>
8010387a:	eb 94                	jmp    80103810 <main+0xa0>
8010387c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103880:	83 ec 08             	sub    $0x8,%esp
80103883:	68 00 00 00 8e       	push   $0x8e000000
80103888:	68 00 00 40 80       	push   $0x80400000
8010388d:	e8 6e f4 ff ff       	call   80102d00 <kinit2>
  userinit();      // first user process
80103892:	e8 99 08 00 00       	call   80104130 <userinit>
  mpmain();        // finish this processor's setup
80103897:	e8 74 fe ff ff       	call   80103710 <mpmain>
8010389c:	66 90                	xchg   %ax,%ax
8010389e:	66 90                	xchg   %ax,%ax

801038a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	57                   	push   %edi
801038a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801038a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801038ab:	53                   	push   %ebx
  e = addr+len;
801038ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801038af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801038b2:	39 de                	cmp    %ebx,%esi
801038b4:	72 10                	jb     801038c6 <mpsearch1+0x26>
801038b6:	eb 50                	jmp    80103908 <mpsearch1+0x68>
801038b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038bf:	90                   	nop
801038c0:	89 fe                	mov    %edi,%esi
801038c2:	39 fb                	cmp    %edi,%ebx
801038c4:	76 42                	jbe    80103908 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801038c6:	83 ec 04             	sub    $0x4,%esp
801038c9:	8d 7e 10             	lea    0x10(%esi),%edi
801038cc:	6a 04                	push   $0x4
801038ce:	68 d8 86 10 80       	push   $0x801086d8
801038d3:	56                   	push   %esi
801038d4:	e8 b7 17 00 00       	call   80105090 <memcmp>
801038d9:	83 c4 10             	add    $0x10,%esp
801038dc:	85 c0                	test   %eax,%eax
801038de:	75 e0                	jne    801038c0 <mpsearch1+0x20>
801038e0:	89 f2                	mov    %esi,%edx
801038e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801038e8:	0f b6 0a             	movzbl (%edx),%ecx
801038eb:	83 c2 01             	add    $0x1,%edx
801038ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801038f0:	39 fa                	cmp    %edi,%edx
801038f2:	75 f4                	jne    801038e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801038f4:	84 c0                	test   %al,%al
801038f6:	75 c8                	jne    801038c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801038f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038fb:	89 f0                	mov    %esi,%eax
801038fd:	5b                   	pop    %ebx
801038fe:	5e                   	pop    %esi
801038ff:	5f                   	pop    %edi
80103900:	5d                   	pop    %ebp
80103901:	c3                   	ret    
80103902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103908:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010390b:	31 f6                	xor    %esi,%esi
}
8010390d:	5b                   	pop    %ebx
8010390e:	89 f0                	mov    %esi,%eax
80103910:	5e                   	pop    %esi
80103911:	5f                   	pop    %edi
80103912:	5d                   	pop    %ebp
80103913:	c3                   	ret    
80103914:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010391b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010391f:	90                   	nop

80103920 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103920:	f3 0f 1e fb          	endbr32 
80103924:	55                   	push   %ebp
80103925:	89 e5                	mov    %esp,%ebp
80103927:	57                   	push   %edi
80103928:	56                   	push   %esi
80103929:	53                   	push   %ebx
8010392a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010392d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103934:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010393b:	c1 e0 08             	shl    $0x8,%eax
8010393e:	09 d0                	or     %edx,%eax
80103940:	c1 e0 04             	shl    $0x4,%eax
80103943:	75 1b                	jne    80103960 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103945:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010394c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103953:	c1 e0 08             	shl    $0x8,%eax
80103956:	09 d0                	or     %edx,%eax
80103958:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010395b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103960:	ba 00 04 00 00       	mov    $0x400,%edx
80103965:	e8 36 ff ff ff       	call   801038a0 <mpsearch1>
8010396a:	89 c6                	mov    %eax,%esi
8010396c:	85 c0                	test   %eax,%eax
8010396e:	0f 84 4c 01 00 00    	je     80103ac0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103974:	8b 5e 04             	mov    0x4(%esi),%ebx
80103977:	85 db                	test   %ebx,%ebx
80103979:	0f 84 61 01 00 00    	je     80103ae0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010397f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103982:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103988:	6a 04                	push   $0x4
8010398a:	68 dd 86 10 80       	push   $0x801086dd
8010398f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103990:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103993:	e8 f8 16 00 00       	call   80105090 <memcmp>
80103998:	83 c4 10             	add    $0x10,%esp
8010399b:	85 c0                	test   %eax,%eax
8010399d:	0f 85 3d 01 00 00    	jne    80103ae0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801039a3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801039aa:	3c 01                	cmp    $0x1,%al
801039ac:	74 08                	je     801039b6 <mpinit+0x96>
801039ae:	3c 04                	cmp    $0x4,%al
801039b0:	0f 85 2a 01 00 00    	jne    80103ae0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801039b6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801039bd:	66 85 d2             	test   %dx,%dx
801039c0:	74 26                	je     801039e8 <mpinit+0xc8>
801039c2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801039c5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801039c7:	31 d2                	xor    %edx,%edx
801039c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801039d0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801039d7:	83 c0 01             	add    $0x1,%eax
801039da:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801039dc:	39 f8                	cmp    %edi,%eax
801039de:	75 f0                	jne    801039d0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801039e0:	84 d2                	test   %dl,%dl
801039e2:	0f 85 f8 00 00 00    	jne    80103ae0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801039e8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801039ee:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039f3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801039f9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103a00:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a05:	03 55 e4             	add    -0x1c(%ebp),%edx
80103a08:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a0f:	90                   	nop
80103a10:	39 c2                	cmp    %eax,%edx
80103a12:	76 15                	jbe    80103a29 <mpinit+0x109>
    switch(*p){
80103a14:	0f b6 08             	movzbl (%eax),%ecx
80103a17:	80 f9 02             	cmp    $0x2,%cl
80103a1a:	74 5c                	je     80103a78 <mpinit+0x158>
80103a1c:	77 42                	ja     80103a60 <mpinit+0x140>
80103a1e:	84 c9                	test   %cl,%cl
80103a20:	74 6e                	je     80103a90 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103a22:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a25:	39 c2                	cmp    %eax,%edx
80103a27:	77 eb                	ja     80103a14 <mpinit+0xf4>
80103a29:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103a2c:	85 db                	test   %ebx,%ebx
80103a2e:	0f 84 b9 00 00 00    	je     80103aed <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103a34:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103a38:	74 15                	je     80103a4f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a3a:	b8 70 00 00 00       	mov    $0x70,%eax
80103a3f:	ba 22 00 00 00       	mov    $0x22,%edx
80103a44:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a45:	ba 23 00 00 00       	mov    $0x23,%edx
80103a4a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103a4b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a4e:	ee                   	out    %al,(%dx)
  }
}
80103a4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a52:	5b                   	pop    %ebx
80103a53:	5e                   	pop    %esi
80103a54:	5f                   	pop    %edi
80103a55:	5d                   	pop    %ebp
80103a56:	c3                   	ret    
80103a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a5e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103a60:	83 e9 03             	sub    $0x3,%ecx
80103a63:	80 f9 01             	cmp    $0x1,%cl
80103a66:	76 ba                	jbe    80103a22 <mpinit+0x102>
80103a68:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103a6f:	eb 9f                	jmp    80103a10 <mpinit+0xf0>
80103a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103a78:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103a7c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103a7f:	88 0d 80 37 11 80    	mov    %cl,0x80113780
      continue;
80103a85:	eb 89                	jmp    80103a10 <mpinit+0xf0>
80103a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a8e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103a90:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
80103a96:	83 f9 07             	cmp    $0x7,%ecx
80103a99:	7f 19                	jg     80103ab4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103a9b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103aa1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103aa5:	83 c1 01             	add    $0x1,%ecx
80103aa8:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103aae:	88 9f a0 37 11 80    	mov    %bl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
80103ab4:	83 c0 14             	add    $0x14,%eax
      continue;
80103ab7:	e9 54 ff ff ff       	jmp    80103a10 <mpinit+0xf0>
80103abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103ac0:	ba 00 00 01 00       	mov    $0x10000,%edx
80103ac5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103aca:	e8 d1 fd ff ff       	call   801038a0 <mpsearch1>
80103acf:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103ad1:	85 c0                	test   %eax,%eax
80103ad3:	0f 85 9b fe ff ff    	jne    80103974 <mpinit+0x54>
80103ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103ae0:	83 ec 0c             	sub    $0xc,%esp
80103ae3:	68 e2 86 10 80       	push   $0x801086e2
80103ae8:	e8 a3 c8 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103aed:	83 ec 0c             	sub    $0xc,%esp
80103af0:	68 fc 86 10 80       	push   $0x801086fc
80103af5:	e8 96 c8 ff ff       	call   80100390 <panic>
80103afa:	66 90                	xchg   %ax,%ax
80103afc:	66 90                	xchg   %ax,%ax
80103afe:	66 90                	xchg   %ax,%ax

80103b00 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103b00:	f3 0f 1e fb          	endbr32 
80103b04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b09:	ba 21 00 00 00       	mov    $0x21,%edx
80103b0e:	ee                   	out    %al,(%dx)
80103b0f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103b14:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103b15:	c3                   	ret    
80103b16:	66 90                	xchg   %ax,%ax
80103b18:	66 90                	xchg   %ax,%ax
80103b1a:	66 90                	xchg   %ax,%ax
80103b1c:	66 90                	xchg   %ax,%ax
80103b1e:	66 90                	xchg   %ax,%ax

80103b20 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103b20:	f3 0f 1e fb          	endbr32 
80103b24:	55                   	push   %ebp
80103b25:	89 e5                	mov    %esp,%ebp
80103b27:	57                   	push   %edi
80103b28:	56                   	push   %esi
80103b29:	53                   	push   %ebx
80103b2a:	83 ec 0c             	sub    $0xc,%esp
80103b2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b30:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103b33:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103b39:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103b3f:	e8 6c d6 ff ff       	call   801011b0 <filealloc>
80103b44:	89 03                	mov    %eax,(%ebx)
80103b46:	85 c0                	test   %eax,%eax
80103b48:	0f 84 ac 00 00 00    	je     80103bfa <pipealloc+0xda>
80103b4e:	e8 5d d6 ff ff       	call   801011b0 <filealloc>
80103b53:	89 06                	mov    %eax,(%esi)
80103b55:	85 c0                	test   %eax,%eax
80103b57:	0f 84 8b 00 00 00    	je     80103be8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103b5d:	e8 fe f1 ff ff       	call   80102d60 <kalloc>
80103b62:	89 c7                	mov    %eax,%edi
80103b64:	85 c0                	test   %eax,%eax
80103b66:	0f 84 b4 00 00 00    	je     80103c20 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103b6c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103b73:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103b76:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103b79:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103b80:	00 00 00 
  p->nwrite = 0;
80103b83:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103b8a:	00 00 00 
  p->nread = 0;
80103b8d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103b94:	00 00 00 
  initlock(&p->lock, "pipe");
80103b97:	68 1b 87 10 80       	push   $0x8010871b
80103b9c:	50                   	push   %eax
80103b9d:	e8 0e 12 00 00       	call   80104db0 <initlock>
  (*f0)->type = FD_PIPE;
80103ba2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103ba4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103ba7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103bad:	8b 03                	mov    (%ebx),%eax
80103baf:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103bb3:	8b 03                	mov    (%ebx),%eax
80103bb5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103bb9:	8b 03                	mov    (%ebx),%eax
80103bbb:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103bbe:	8b 06                	mov    (%esi),%eax
80103bc0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103bc6:	8b 06                	mov    (%esi),%eax
80103bc8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103bcc:	8b 06                	mov    (%esi),%eax
80103bce:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103bd2:	8b 06                	mov    (%esi),%eax
80103bd4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103bd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103bda:	31 c0                	xor    %eax,%eax
}
80103bdc:	5b                   	pop    %ebx
80103bdd:	5e                   	pop    %esi
80103bde:	5f                   	pop    %edi
80103bdf:	5d                   	pop    %ebp
80103be0:	c3                   	ret    
80103be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103be8:	8b 03                	mov    (%ebx),%eax
80103bea:	85 c0                	test   %eax,%eax
80103bec:	74 1e                	je     80103c0c <pipealloc+0xec>
    fileclose(*f0);
80103bee:	83 ec 0c             	sub    $0xc,%esp
80103bf1:	50                   	push   %eax
80103bf2:	e8 79 d6 ff ff       	call   80101270 <fileclose>
80103bf7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103bfa:	8b 06                	mov    (%esi),%eax
80103bfc:	85 c0                	test   %eax,%eax
80103bfe:	74 0c                	je     80103c0c <pipealloc+0xec>
    fileclose(*f1);
80103c00:	83 ec 0c             	sub    $0xc,%esp
80103c03:	50                   	push   %eax
80103c04:	e8 67 d6 ff ff       	call   80101270 <fileclose>
80103c09:	83 c4 10             	add    $0x10,%esp
}
80103c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103c0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103c14:	5b                   	pop    %ebx
80103c15:	5e                   	pop    %esi
80103c16:	5f                   	pop    %edi
80103c17:	5d                   	pop    %ebp
80103c18:	c3                   	ret    
80103c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103c20:	8b 03                	mov    (%ebx),%eax
80103c22:	85 c0                	test   %eax,%eax
80103c24:	75 c8                	jne    80103bee <pipealloc+0xce>
80103c26:	eb d2                	jmp    80103bfa <pipealloc+0xda>
80103c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c2f:	90                   	nop

80103c30 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103c30:	f3 0f 1e fb          	endbr32 
80103c34:	55                   	push   %ebp
80103c35:	89 e5                	mov    %esp,%ebp
80103c37:	56                   	push   %esi
80103c38:	53                   	push   %ebx
80103c39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103c3f:	83 ec 0c             	sub    $0xc,%esp
80103c42:	53                   	push   %ebx
80103c43:	e8 e8 12 00 00       	call   80104f30 <acquire>
  if(writable){
80103c48:	83 c4 10             	add    $0x10,%esp
80103c4b:	85 f6                	test   %esi,%esi
80103c4d:	74 41                	je     80103c90 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103c4f:	83 ec 0c             	sub    $0xc,%esp
80103c52:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103c58:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103c5f:	00 00 00 
    wakeup(&p->nread);
80103c62:	50                   	push   %eax
80103c63:	e8 18 0e 00 00       	call   80104a80 <wakeup>
80103c68:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103c6b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103c71:	85 d2                	test   %edx,%edx
80103c73:	75 0a                	jne    80103c7f <pipeclose+0x4f>
80103c75:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103c7b:	85 c0                	test   %eax,%eax
80103c7d:	74 31                	je     80103cb0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103c7f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103c82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c85:	5b                   	pop    %ebx
80103c86:	5e                   	pop    %esi
80103c87:	5d                   	pop    %ebp
    release(&p->lock);
80103c88:	e9 63 13 00 00       	jmp    80104ff0 <release>
80103c8d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103c90:	83 ec 0c             	sub    $0xc,%esp
80103c93:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103c99:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103ca0:	00 00 00 
    wakeup(&p->nwrite);
80103ca3:	50                   	push   %eax
80103ca4:	e8 d7 0d 00 00       	call   80104a80 <wakeup>
80103ca9:	83 c4 10             	add    $0x10,%esp
80103cac:	eb bd                	jmp    80103c6b <pipeclose+0x3b>
80103cae:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103cb0:	83 ec 0c             	sub    $0xc,%esp
80103cb3:	53                   	push   %ebx
80103cb4:	e8 37 13 00 00       	call   80104ff0 <release>
    kfree((char*)p);
80103cb9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103cbc:	83 c4 10             	add    $0x10,%esp
}
80103cbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cc2:	5b                   	pop    %ebx
80103cc3:	5e                   	pop    %esi
80103cc4:	5d                   	pop    %ebp
    kfree((char*)p);
80103cc5:	e9 d6 ee ff ff       	jmp    80102ba0 <kfree>
80103cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103cd0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103cd0:	f3 0f 1e fb          	endbr32 
80103cd4:	55                   	push   %ebp
80103cd5:	89 e5                	mov    %esp,%ebp
80103cd7:	57                   	push   %edi
80103cd8:	56                   	push   %esi
80103cd9:	53                   	push   %ebx
80103cda:	83 ec 28             	sub    $0x28,%esp
80103cdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103ce0:	53                   	push   %ebx
80103ce1:	e8 4a 12 00 00       	call   80104f30 <acquire>
  for(i = 0; i < n; i++){
80103ce6:	8b 45 10             	mov    0x10(%ebp),%eax
80103ce9:	83 c4 10             	add    $0x10,%esp
80103cec:	85 c0                	test   %eax,%eax
80103cee:	0f 8e bc 00 00 00    	jle    80103db0 <pipewrite+0xe0>
80103cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cf7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103cfd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103d03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d06:	03 45 10             	add    0x10(%ebp),%eax
80103d09:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103d0c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103d12:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103d18:	89 ca                	mov    %ecx,%edx
80103d1a:	05 00 02 00 00       	add    $0x200,%eax
80103d1f:	39 c1                	cmp    %eax,%ecx
80103d21:	74 3b                	je     80103d5e <pipewrite+0x8e>
80103d23:	eb 63                	jmp    80103d88 <pipewrite+0xb8>
80103d25:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103d28:	e8 d3 03 00 00       	call   80104100 <myproc>
80103d2d:	8b 48 24             	mov    0x24(%eax),%ecx
80103d30:	85 c9                	test   %ecx,%ecx
80103d32:	75 34                	jne    80103d68 <pipewrite+0x98>
      wakeup(&p->nread);
80103d34:	83 ec 0c             	sub    $0xc,%esp
80103d37:	57                   	push   %edi
80103d38:	e8 43 0d 00 00       	call   80104a80 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103d3d:	58                   	pop    %eax
80103d3e:	5a                   	pop    %edx
80103d3f:	53                   	push   %ebx
80103d40:	56                   	push   %esi
80103d41:	e8 da 0a 00 00       	call   80104820 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103d46:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103d4c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103d52:	83 c4 10             	add    $0x10,%esp
80103d55:	05 00 02 00 00       	add    $0x200,%eax
80103d5a:	39 c2                	cmp    %eax,%edx
80103d5c:	75 2a                	jne    80103d88 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103d5e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103d64:	85 c0                	test   %eax,%eax
80103d66:	75 c0                	jne    80103d28 <pipewrite+0x58>
        release(&p->lock);
80103d68:	83 ec 0c             	sub    $0xc,%esp
80103d6b:	53                   	push   %ebx
80103d6c:	e8 7f 12 00 00       	call   80104ff0 <release>
        return -1;
80103d71:	83 c4 10             	add    $0x10,%esp
80103d74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103d79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d7c:	5b                   	pop    %ebx
80103d7d:	5e                   	pop    %esi
80103d7e:	5f                   	pop    %edi
80103d7f:	5d                   	pop    %ebp
80103d80:	c3                   	ret    
80103d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103d88:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103d8b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103d8e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103d94:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103d9a:	0f b6 06             	movzbl (%esi),%eax
80103d9d:	83 c6 01             	add    $0x1,%esi
80103da0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103da3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103da7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103daa:	0f 85 5c ff ff ff    	jne    80103d0c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103db0:	83 ec 0c             	sub    $0xc,%esp
80103db3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103db9:	50                   	push   %eax
80103dba:	e8 c1 0c 00 00       	call   80104a80 <wakeup>
  release(&p->lock);
80103dbf:	89 1c 24             	mov    %ebx,(%esp)
80103dc2:	e8 29 12 00 00       	call   80104ff0 <release>
  return n;
80103dc7:	8b 45 10             	mov    0x10(%ebp),%eax
80103dca:	83 c4 10             	add    $0x10,%esp
80103dcd:	eb aa                	jmp    80103d79 <pipewrite+0xa9>
80103dcf:	90                   	nop

80103dd0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103dd0:	f3 0f 1e fb          	endbr32 
80103dd4:	55                   	push   %ebp
80103dd5:	89 e5                	mov    %esp,%ebp
80103dd7:	57                   	push   %edi
80103dd8:	56                   	push   %esi
80103dd9:	53                   	push   %ebx
80103dda:	83 ec 18             	sub    $0x18,%esp
80103ddd:	8b 75 08             	mov    0x8(%ebp),%esi
80103de0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103de3:	56                   	push   %esi
80103de4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103dea:	e8 41 11 00 00       	call   80104f30 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103def:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103df5:	83 c4 10             	add    $0x10,%esp
80103df8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103dfe:	74 33                	je     80103e33 <piperead+0x63>
80103e00:	eb 3b                	jmp    80103e3d <piperead+0x6d>
80103e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103e08:	e8 f3 02 00 00       	call   80104100 <myproc>
80103e0d:	8b 48 24             	mov    0x24(%eax),%ecx
80103e10:	85 c9                	test   %ecx,%ecx
80103e12:	0f 85 88 00 00 00    	jne    80103ea0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103e18:	83 ec 08             	sub    $0x8,%esp
80103e1b:	56                   	push   %esi
80103e1c:	53                   	push   %ebx
80103e1d:	e8 fe 09 00 00       	call   80104820 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103e22:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103e28:	83 c4 10             	add    $0x10,%esp
80103e2b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103e31:	75 0a                	jne    80103e3d <piperead+0x6d>
80103e33:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103e39:	85 c0                	test   %eax,%eax
80103e3b:	75 cb                	jne    80103e08 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103e3d:	8b 55 10             	mov    0x10(%ebp),%edx
80103e40:	31 db                	xor    %ebx,%ebx
80103e42:	85 d2                	test   %edx,%edx
80103e44:	7f 28                	jg     80103e6e <piperead+0x9e>
80103e46:	eb 34                	jmp    80103e7c <piperead+0xac>
80103e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e4f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103e50:	8d 48 01             	lea    0x1(%eax),%ecx
80103e53:	25 ff 01 00 00       	and    $0x1ff,%eax
80103e58:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103e5e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103e63:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103e66:	83 c3 01             	add    $0x1,%ebx
80103e69:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103e6c:	74 0e                	je     80103e7c <piperead+0xac>
    if(p->nread == p->nwrite)
80103e6e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103e74:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103e7a:	75 d4                	jne    80103e50 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103e7c:	83 ec 0c             	sub    $0xc,%esp
80103e7f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103e85:	50                   	push   %eax
80103e86:	e8 f5 0b 00 00       	call   80104a80 <wakeup>
  release(&p->lock);
80103e8b:	89 34 24             	mov    %esi,(%esp)
80103e8e:	e8 5d 11 00 00       	call   80104ff0 <release>
  return i;
80103e93:	83 c4 10             	add    $0x10,%esp
}
80103e96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e99:	89 d8                	mov    %ebx,%eax
80103e9b:	5b                   	pop    %ebx
80103e9c:	5e                   	pop    %esi
80103e9d:	5f                   	pop    %edi
80103e9e:	5d                   	pop    %ebp
80103e9f:	c3                   	ret    
      release(&p->lock);
80103ea0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ea3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103ea8:	56                   	push   %esi
80103ea9:	e8 42 11 00 00       	call   80104ff0 <release>
      return -1;
80103eae:	83 c4 10             	add    $0x10,%esp
}
80103eb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103eb4:	89 d8                	mov    %ebx,%eax
80103eb6:	5b                   	pop    %ebx
80103eb7:	5e                   	pop    %esi
80103eb8:	5f                   	pop    %edi
80103eb9:	5d                   	pop    %ebp
80103eba:	c3                   	ret    
80103ebb:	66 90                	xchg   %ax,%ax
80103ebd:	66 90                	xchg   %ax,%ax
80103ebf:	90                   	nop

80103ec0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ec4:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
80103ec9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103ecc:	68 40 3d 11 80       	push   $0x80113d40
80103ed1:	e8 5a 10 00 00       	call   80104f30 <acquire>
80103ed6:	83 c4 10             	add    $0x10,%esp
80103ed9:	eb 17                	jmp    80103ef2 <allocproc+0x32>
80103edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103edf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ee0:	81 c3 90 03 00 00    	add    $0x390,%ebx
80103ee6:	81 fb 74 21 12 80    	cmp    $0x80122174,%ebx
80103eec:	0f 84 de 00 00 00    	je     80103fd0 <allocproc+0x110>
    if(p->state == UNUSED)
80103ef2:	8b 43 0c             	mov    0xc(%ebx),%eax
80103ef5:	85 c0                	test   %eax,%eax
80103ef7:	75 e7                	jne    80103ee0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103ef9:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103efe:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103f01:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103f08:	89 43 10             	mov    %eax,0x10(%ebx)
80103f0b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103f0e:	68 40 3d 11 80       	push   $0x80113d40
  p->pid = nextpid++;
80103f13:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103f19:	e8 d2 10 00 00       	call   80104ff0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103f1e:	e8 3d ee ff ff       	call   80102d60 <kalloc>
80103f23:	83 c4 10             	add    $0x10,%esp
80103f26:	89 43 08             	mov    %eax,0x8(%ebx)
80103f29:	85 c0                	test   %eax,%eax
80103f2b:	0f 84 b8 00 00 00    	je     80103fe9 <allocproc+0x129>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103f31:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103f37:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103f3a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103f3f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103f42:	c7 40 14 76 62 10 80 	movl   $0x80106276,0x14(%eax)
  p->context = (struct context*)sp;
80103f49:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103f4c:	6a 14                	push   $0x14
80103f4e:	6a 00                	push   $0x0
80103f50:	50                   	push   %eax
80103f51:	e8 ea 10 00 00       	call   80105040 <memset>
  p->context->eip = (uint)forkret;
80103f56:	8b 43 1c             	mov    0x1c(%ebx),%eax

 if (p->pid > 2){
80103f59:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103f5c:	c7 40 10 00 40 10 80 	movl   $0x80104000,0x10(%eax)
 if (p->pid > 2){
80103f63:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103f67:	7f 07                	jg     80103f70 <allocproc+0xb0>
    for (int i = 0; i < 16; i++){
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
  }
 }
  return p;
}
80103f69:	89 d8                	mov    %ebx,%eax
80103f6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f6e:	c9                   	leave  
80103f6f:	c3                   	ret    
    p->num_of_actual_pages_in_mem = 0;
80103f70:	c7 83 84 03 00 00 00 	movl   $0x0,0x384(%ebx)
80103f77:	00 00 00 
    createSwapFile(p);
80103f7a:	83 ec 0c             	sub    $0xc,%esp
    p->num_of_pagefaults_occurs = 0;
80103f7d:	c7 83 88 03 00 00 00 	movl   $0x0,0x388(%ebx)
80103f84:	00 00 00 
    p->num_of_pageOut_occured = 0;
80103f87:	c7 83 8c 03 00 00 00 	movl   $0x0,0x38c(%ebx)
80103f8e:	00 00 00 
    p->num_of_pages_in_swap_file = 0;
80103f91:	c7 83 80 03 00 00 00 	movl   $0x0,0x380(%ebx)
80103f98:	00 00 00 
    createSwapFile(p);
80103f9b:	53                   	push   %ebx
80103f9c:	e8 ff e6 ff ff       	call   801026a0 <createSwapFile>
    for (int i = 0; i < 16; i++){
80103fa1:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103fa7:	8d 93 00 02 00 00    	lea    0x200(%ebx),%edx
80103fad:	83 c4 10             	add    $0x10,%esp
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80103fb0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103fb6:	83 c0 18             	add    $0x18,%eax
80103fb9:	c7 80 68 01 00 00 01 	movl   $0x1,0x168(%eax)
80103fc0:	00 00 00 
    for (int i = 0; i < 16; i++){
80103fc3:	39 c2                	cmp    %eax,%edx
80103fc5:	75 e9                	jne    80103fb0 <allocproc+0xf0>
}
80103fc7:	89 d8                	mov    %ebx,%eax
80103fc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fcc:	c9                   	leave  
80103fcd:	c3                   	ret    
80103fce:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103fd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103fd3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103fd5:	68 40 3d 11 80       	push   $0x80113d40
80103fda:	e8 11 10 00 00       	call   80104ff0 <release>
}
80103fdf:	89 d8                	mov    %ebx,%eax
  return 0;
80103fe1:	83 c4 10             	add    $0x10,%esp
}
80103fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fe7:	c9                   	leave  
80103fe8:	c3                   	ret    
    p->state = UNUSED;
80103fe9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103ff0:	31 db                	xor    %ebx,%ebx
}
80103ff2:	89 d8                	mov    %ebx,%eax
80103ff4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ff7:	c9                   	leave  
80103ff8:	c3                   	ret    
80103ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104000 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104000:	f3 0f 1e fb          	endbr32 
80104004:	55                   	push   %ebp
80104005:	89 e5                	mov    %esp,%ebp
80104007:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010400a:	68 40 3d 11 80       	push   $0x80113d40
8010400f:	e8 dc 0f 00 00       	call   80104ff0 <release>

  if (first) {
80104014:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104019:	83 c4 10             	add    $0x10,%esp
8010401c:	85 c0                	test   %eax,%eax
8010401e:	75 08                	jne    80104028 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104020:	c9                   	leave  
80104021:	c3                   	ret    
80104022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80104028:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010402f:	00 00 00 
    iinit(ROOTDEV);
80104032:	83 ec 0c             	sub    $0xc,%esp
80104035:	6a 01                	push   $0x1
80104037:	e8 b4 d8 ff ff       	call   801018f0 <iinit>
    initlog(ROOTDEV);
8010403c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104043:	e8 78 f3 ff ff       	call   801033c0 <initlog>
}
80104048:	83 c4 10             	add    $0x10,%esp
8010404b:	c9                   	leave  
8010404c:	c3                   	ret    
8010404d:	8d 76 00             	lea    0x0(%esi),%esi

80104050 <pinit>:
{
80104050:	f3 0f 1e fb          	endbr32 
80104054:	55                   	push   %ebp
80104055:	89 e5                	mov    %esp,%ebp
80104057:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010405a:	68 20 87 10 80       	push   $0x80108720
8010405f:	68 40 3d 11 80       	push   $0x80113d40
80104064:	e8 47 0d 00 00       	call   80104db0 <initlock>
}
80104069:	83 c4 10             	add    $0x10,%esp
8010406c:	c9                   	leave  
8010406d:	c3                   	ret    
8010406e:	66 90                	xchg   %ax,%ax

80104070 <mycpu>:
{
80104070:	f3 0f 1e fb          	endbr32 
80104074:	55                   	push   %ebp
80104075:	89 e5                	mov    %esp,%ebp
80104077:	56                   	push   %esi
80104078:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104079:	9c                   	pushf  
8010407a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010407b:	f6 c4 02             	test   $0x2,%ah
8010407e:	75 4a                	jne    801040ca <mycpu+0x5a>
  apicid = lapicid();
80104080:	e8 4b ef ff ff       	call   80102fd0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104085:	8b 35 20 3d 11 80    	mov    0x80113d20,%esi
  apicid = lapicid();
8010408b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010408d:	85 f6                	test   %esi,%esi
8010408f:	7e 2c                	jle    801040bd <mycpu+0x4d>
80104091:	31 d2                	xor    %edx,%edx
80104093:	eb 0a                	jmp    8010409f <mycpu+0x2f>
80104095:	8d 76 00             	lea    0x0(%esi),%esi
80104098:	83 c2 01             	add    $0x1,%edx
8010409b:	39 f2                	cmp    %esi,%edx
8010409d:	74 1e                	je     801040bd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010409f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801040a5:	0f b6 81 a0 37 11 80 	movzbl -0x7feec860(%ecx),%eax
801040ac:	39 d8                	cmp    %ebx,%eax
801040ae:	75 e8                	jne    80104098 <mycpu+0x28>
}
801040b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801040b3:	8d 81 a0 37 11 80    	lea    -0x7feec860(%ecx),%eax
}
801040b9:	5b                   	pop    %ebx
801040ba:	5e                   	pop    %esi
801040bb:	5d                   	pop    %ebp
801040bc:	c3                   	ret    
  panic("unknown apicid\n");
801040bd:	83 ec 0c             	sub    $0xc,%esp
801040c0:	68 27 87 10 80       	push   $0x80108727
801040c5:	e8 c6 c2 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801040ca:	83 ec 0c             	sub    $0xc,%esp
801040cd:	68 14 88 10 80       	push   $0x80108814
801040d2:	e8 b9 c2 ff ff       	call   80100390 <panic>
801040d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040de:	66 90                	xchg   %ax,%ax

801040e0 <cpuid>:
cpuid() {
801040e0:	f3 0f 1e fb          	endbr32 
801040e4:	55                   	push   %ebp
801040e5:	89 e5                	mov    %esp,%ebp
801040e7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801040ea:	e8 81 ff ff ff       	call   80104070 <mycpu>
}
801040ef:	c9                   	leave  
  return mycpu()-cpus;
801040f0:	2d a0 37 11 80       	sub    $0x801137a0,%eax
801040f5:	c1 f8 04             	sar    $0x4,%eax
801040f8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801040fe:	c3                   	ret    
801040ff:	90                   	nop

80104100 <myproc>:
myproc(void) {
80104100:	f3 0f 1e fb          	endbr32 
80104104:	55                   	push   %ebp
80104105:	89 e5                	mov    %esp,%ebp
80104107:	53                   	push   %ebx
80104108:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010410b:	e8 20 0d 00 00       	call   80104e30 <pushcli>
  c = mycpu();
80104110:	e8 5b ff ff ff       	call   80104070 <mycpu>
  p = c->proc;
80104115:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010411b:	e8 60 0d 00 00       	call   80104e80 <popcli>
}
80104120:	83 c4 04             	add    $0x4,%esp
80104123:	89 d8                	mov    %ebx,%eax
80104125:	5b                   	pop    %ebx
80104126:	5d                   	pop    %ebp
80104127:	c3                   	ret    
80104128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010412f:	90                   	nop

80104130 <userinit>:
{
80104130:	f3 0f 1e fb          	endbr32 
80104134:	55                   	push   %ebp
80104135:	89 e5                	mov    %esp,%ebp
80104137:	53                   	push   %ebx
80104138:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010413b:	e8 80 fd ff ff       	call   80103ec0 <allocproc>
80104140:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104142:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80104147:	e8 f4 37 00 00       	call   80107940 <setupkvm>
8010414c:	89 43 04             	mov    %eax,0x4(%ebx)
8010414f:	85 c0                	test   %eax,%eax
80104151:	0f 84 bd 00 00 00    	je     80104214 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104157:	83 ec 04             	sub    $0x4,%esp
8010415a:	68 2c 00 00 00       	push   $0x2c
8010415f:	68 60 b4 10 80       	push   $0x8010b460
80104164:	50                   	push   %eax
80104165:	e8 66 34 00 00       	call   801075d0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010416a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010416d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104173:	6a 4c                	push   $0x4c
80104175:	6a 00                	push   $0x0
80104177:	ff 73 18             	pushl  0x18(%ebx)
8010417a:	e8 c1 0e 00 00       	call   80105040 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010417f:	8b 43 18             	mov    0x18(%ebx),%eax
80104182:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104187:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010418a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010418f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104193:	8b 43 18             	mov    0x18(%ebx),%eax
80104196:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010419a:	8b 43 18             	mov    0x18(%ebx),%eax
8010419d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801041a1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801041a5:	8b 43 18             	mov    0x18(%ebx),%eax
801041a8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801041ac:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801041b0:	8b 43 18             	mov    0x18(%ebx),%eax
801041b3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801041ba:	8b 43 18             	mov    0x18(%ebx),%eax
801041bd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801041c4:	8b 43 18             	mov    0x18(%ebx),%eax
801041c7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801041ce:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041d1:	6a 10                	push   $0x10
801041d3:	68 50 87 10 80       	push   $0x80108750
801041d8:	50                   	push   %eax
801041d9:	e8 22 10 00 00       	call   80105200 <safestrcpy>
  p->cwd = namei("/");
801041de:	c7 04 24 59 87 10 80 	movl   $0x80108759,(%esp)
801041e5:	e8 f6 e1 ff ff       	call   801023e0 <namei>
801041ea:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801041ed:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
801041f4:	e8 37 0d 00 00       	call   80104f30 <acquire>
  p->state = RUNNABLE;
801041f9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104200:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104207:	e8 e4 0d 00 00       	call   80104ff0 <release>
}
8010420c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010420f:	83 c4 10             	add    $0x10,%esp
80104212:	c9                   	leave  
80104213:	c3                   	ret    
    panic("userinit: out of memory?");
80104214:	83 ec 0c             	sub    $0xc,%esp
80104217:	68 37 87 10 80       	push   $0x80108737
8010421c:	e8 6f c1 ff ff       	call   80100390 <panic>
80104221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010422f:	90                   	nop

80104230 <growproc>:
{
80104230:	f3 0f 1e fb          	endbr32 
80104234:	55                   	push   %ebp
80104235:	89 e5                	mov    %esp,%ebp
80104237:	56                   	push   %esi
80104238:	53                   	push   %ebx
80104239:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010423c:	e8 ef 0b 00 00       	call   80104e30 <pushcli>
  c = mycpu();
80104241:	e8 2a fe ff ff       	call   80104070 <mycpu>
  p = c->proc;
80104246:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010424c:	e8 2f 0c 00 00       	call   80104e80 <popcli>
  sz = curproc->sz;
80104251:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104253:	85 f6                	test   %esi,%esi
80104255:	7f 19                	jg     80104270 <growproc+0x40>
  } else if(n < 0){
80104257:	75 37                	jne    80104290 <growproc+0x60>
  switchuvm(curproc);
80104259:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010425c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010425e:	53                   	push   %ebx
8010425f:	e8 5c 32 00 00       	call   801074c0 <switchuvm>
  return 0;
80104264:	83 c4 10             	add    $0x10,%esp
80104267:	31 c0                	xor    %eax,%eax
}
80104269:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010426c:	5b                   	pop    %ebx
8010426d:	5e                   	pop    %esi
8010426e:	5d                   	pop    %ebp
8010426f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104270:	83 ec 04             	sub    $0x4,%esp
80104273:	01 c6                	add    %eax,%esi
80104275:	56                   	push   %esi
80104276:	50                   	push   %eax
80104277:	ff 73 04             	pushl  0x4(%ebx)
8010427a:	e8 71 3a 00 00       	call   80107cf0 <allocuvm>
8010427f:	83 c4 10             	add    $0x10,%esp
80104282:	85 c0                	test   %eax,%eax
80104284:	75 d3                	jne    80104259 <growproc+0x29>
      return -1;
80104286:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010428b:	eb dc                	jmp    80104269 <growproc+0x39>
8010428d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104290:	83 ec 04             	sub    $0x4,%esp
80104293:	01 c6                	add    %eax,%esi
80104295:	56                   	push   %esi
80104296:	50                   	push   %eax
80104297:	ff 73 04             	pushl  0x4(%ebx)
8010429a:	e8 81 34 00 00       	call   80107720 <deallocuvm>
8010429f:	83 c4 10             	add    $0x10,%esp
801042a2:	85 c0                	test   %eax,%eax
801042a4:	75 b3                	jne    80104259 <growproc+0x29>
801042a6:	eb de                	jmp    80104286 <growproc+0x56>
801042a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042af:	90                   	nop

801042b0 <fork>:
{
801042b0:	f3 0f 1e fb          	endbr32 
801042b4:	55                   	push   %ebp
801042b5:	89 e5                	mov    %esp,%ebp
801042b7:	57                   	push   %edi
801042b8:	56                   	push   %esi
801042b9:	53                   	push   %ebx
801042ba:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801042bd:	e8 6e 0b 00 00       	call   80104e30 <pushcli>
  c = mycpu();
801042c2:	e8 a9 fd ff ff       	call   80104070 <mycpu>
  p = c->proc;
801042c7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042cd:	e8 ae 0b 00 00       	call   80104e80 <popcli>
  if((np = allocproc()) == 0){
801042d2:	e8 e9 fb ff ff       	call   80103ec0 <allocproc>
801042d7:	85 c0                	test   %eax,%eax
801042d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801042dc:	0f 84 13 02 00 00    	je     801044f5 <fork+0x245>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801042e2:	83 ec 08             	sub    $0x8,%esp
801042e5:	ff 33                	pushl  (%ebx)
801042e7:	ff 73 04             	pushl  0x4(%ebx)
801042ea:	e8 21 37 00 00       	call   80107a10 <copyuvm>
801042ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042f2:	83 c4 10             	add    $0x10,%esp
801042f5:	89 42 04             	mov    %eax,0x4(%edx)
801042f8:	85 c0                	test   %eax,%eax
801042fa:	0f 84 01 02 00 00    	je     80104501 <fork+0x251>
  np->sz = curproc->sz;
80104300:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
80104302:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
80104305:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80104308:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
8010430d:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
8010430f:	8b 73 18             	mov    0x18(%ebx),%esi
80104312:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104314:	31 f6                	xor    %esi,%esi
80104316:	89 d7                	mov    %edx,%edi
  np->tf->eax = 0;
80104318:	8b 42 18             	mov    0x18(%edx),%eax
8010431b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80104328:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010432c:	85 c0                	test   %eax,%eax
8010432e:	74 10                	je     80104340 <fork+0x90>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104330:	83 ec 0c             	sub    $0xc,%esp
80104333:	50                   	push   %eax
80104334:	e8 e7 ce ff ff       	call   80101220 <filedup>
80104339:	83 c4 10             	add    $0x10,%esp
8010433c:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104340:	83 c6 01             	add    $0x1,%esi
80104343:	83 fe 10             	cmp    $0x10,%esi
80104346:	75 e0                	jne    80104328 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80104348:	83 ec 0c             	sub    $0xc,%esp
8010434b:	ff 73 68             	pushl  0x68(%ebx)
8010434e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80104351:	e8 8a d7 ff ff       	call   80101ae0 <idup>
80104356:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104359:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010435c:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010435f:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104362:	6a 10                	push   $0x10
80104364:	50                   	push   %eax
80104365:	8d 42 6c             	lea    0x6c(%edx),%eax
80104368:	50                   	push   %eax
80104369:	e8 92 0e 00 00       	call   80105200 <safestrcpy>
  pid = np->pid;
8010436e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  if (curproc->pid > 2 && np->pid > 2){
80104371:	83 c4 10             	add    $0x10,%esp
80104374:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  pid = np->pid;
80104378:	8b 42 10             	mov    0x10(%edx),%eax
8010437b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (curproc->pid > 2 && np->pid > 2){
8010437e:	7e 05                	jle    80104385 <fork+0xd5>
80104380:	83 f8 02             	cmp    $0x2,%eax
80104383:	7f 3b                	jg     801043c0 <fork+0x110>
  acquire(&ptable.lock);
80104385:	83 ec 0c             	sub    $0xc,%esp
80104388:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010438b:	68 40 3d 11 80       	push   $0x80113d40
80104390:	e8 9b 0b 00 00       	call   80104f30 <acquire>
  np->state = RUNNABLE;
80104395:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104398:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
8010439f:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
801043a6:	e8 45 0c 00 00       	call   80104ff0 <release>
  return pid;
801043ab:	83 c4 10             	add    $0x10,%esp
}
801043ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
801043b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043b4:	5b                   	pop    %ebx
801043b5:	5e                   	pop    %esi
801043b6:	5f                   	pop    %edi
801043b7:	5d                   	pop    %ebp
801043b8:	c3                   	ret    
801043b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043c0:	8d 83 e8 01 00 00    	lea    0x1e8(%ebx),%eax
    int last_not_free_in_file = MAX_PYSC_PAGES - 1;
801043c6:	b9 0f 00 00 00       	mov    $0xf,%ecx
801043cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043cf:	90                   	nop
    while (last_not_free_in_file >= 0 && curproc->swapped_out_pages[last_not_free_in_file].is_free){ last_not_free_in_file--; }
801043d0:	8b 30                	mov    (%eax),%esi
801043d2:	85 f6                	test   %esi,%esi
801043d4:	74 1a                	je     801043f0 <fork+0x140>
801043d6:	83 e9 01             	sub    $0x1,%ecx
801043d9:	83 e8 18             	sub    $0x18,%eax
801043dc:	83 f9 ff             	cmp    $0xffffffff,%ecx
801043df:	75 ef                	jne    801043d0 <fork+0x120>
801043e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    void* pg_buffer = kalloc();
801043e4:	e8 77 e9 ff ff       	call   80102d60 <kalloc>
801043e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043ec:	89 c7                	mov    %eax,%edi
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
801043ee:	eb 57                	jmp    80104447 <fork+0x197>
801043f0:	89 55 d8             	mov    %edx,-0x28(%ebp)
801043f3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    void* pg_buffer = kalloc();
801043f6:	e8 65 e9 ff ff       	call   80102d60 <kalloc>
    last_not_free_in_file++;
801043fb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
801043fe:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104401:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    void* pg_buffer = kalloc();
80104404:	89 c7                	mov    %eax,%edi
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
80104406:	89 f3                	mov    %esi,%ebx
    last_not_free_in_file++;
80104408:	83 c1 01             	add    $0x1,%ecx
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
8010440b:	89 d6                	mov    %edx,%esi
8010440d:	c1 e1 0c             	shl    $0xc,%ecx
80104410:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80104413:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104417:	90                   	nop
      readFromSwapFile(curproc, pg_buffer, i, PGSIZE);
80104418:	68 00 10 00 00       	push   $0x1000
8010441d:	53                   	push   %ebx
8010441e:	57                   	push   %edi
8010441f:	ff 75 e4             	pushl  -0x1c(%ebp)
80104422:	e8 49 e3 ff ff       	call   80102770 <readFromSwapFile>
      writeToSwapFile(np, pg_buffer, i, PGSIZE);
80104427:	68 00 10 00 00       	push   $0x1000
8010442c:	53                   	push   %ebx
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
8010442d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      writeToSwapFile(np, pg_buffer, i, PGSIZE);
80104433:	57                   	push   %edi
80104434:	56                   	push   %esi
80104435:	e8 06 e3 ff ff       	call   80102740 <writeToSwapFile>
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
8010443a:	83 c4 20             	add    $0x20,%esp
8010443d:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
80104440:	7f d6                	jg     80104418 <fork+0x168>
80104442:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104445:	89 f2                	mov    %esi,%edx
    kfree(pg_buffer);
80104447:	83 ec 0c             	sub    $0xc,%esp
8010444a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010444d:	57                   	push   %edi
8010444e:	e8 4d e7 ff ff       	call   80102ba0 <kfree>
80104453:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104456:	83 c4 10             	add    $0x10,%esp
80104459:	b8 80 00 00 00       	mov    $0x80,%eax
8010445e:	66 90                	xchg   %ax,%ax
      np->ram_pages[i] = curproc->ram_pages[i];
80104460:	8b 8c 03 80 01 00 00 	mov    0x180(%ebx,%eax,1),%ecx
80104467:	89 8c 02 80 01 00 00 	mov    %ecx,0x180(%edx,%eax,1)
8010446e:	8b 8c 03 84 01 00 00 	mov    0x184(%ebx,%eax,1),%ecx
80104475:	89 8c 02 84 01 00 00 	mov    %ecx,0x184(%edx,%eax,1)
8010447c:	8b 8c 03 88 01 00 00 	mov    0x188(%ebx,%eax,1),%ecx
80104483:	89 8c 02 88 01 00 00 	mov    %ecx,0x188(%edx,%eax,1)
8010448a:	8b 8c 03 8c 01 00 00 	mov    0x18c(%ebx,%eax,1),%ecx
80104491:	89 8c 02 8c 01 00 00 	mov    %ecx,0x18c(%edx,%eax,1)
80104498:	8b 8c 03 90 01 00 00 	mov    0x190(%ebx,%eax,1),%ecx
8010449f:	89 8c 02 90 01 00 00 	mov    %ecx,0x190(%edx,%eax,1)
801044a6:	8b 8c 03 94 01 00 00 	mov    0x194(%ebx,%eax,1),%ecx
801044ad:	89 8c 02 94 01 00 00 	mov    %ecx,0x194(%edx,%eax,1)
      np->swapped_out_pages[i] = curproc->swapped_out_pages[i];
801044b4:	8b 0c 03             	mov    (%ebx,%eax,1),%ecx
801044b7:	89 0c 02             	mov    %ecx,(%edx,%eax,1)
801044ba:	8b 4c 03 04          	mov    0x4(%ebx,%eax,1),%ecx
801044be:	89 4c 02 04          	mov    %ecx,0x4(%edx,%eax,1)
801044c2:	8b 4c 03 08          	mov    0x8(%ebx,%eax,1),%ecx
801044c6:	89 4c 02 08          	mov    %ecx,0x8(%edx,%eax,1)
801044ca:	8b 4c 03 0c          	mov    0xc(%ebx,%eax,1),%ecx
801044ce:	89 4c 02 0c          	mov    %ecx,0xc(%edx,%eax,1)
801044d2:	8b 4c 03 10          	mov    0x10(%ebx,%eax,1),%ecx
801044d6:	89 4c 02 10          	mov    %ecx,0x10(%edx,%eax,1)
801044da:	8b 4c 03 14          	mov    0x14(%ebx,%eax,1),%ecx
801044de:	89 4c 02 14          	mov    %ecx,0x14(%edx,%eax,1)
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
801044e2:	83 c0 18             	add    $0x18,%eax
801044e5:	3d 00 02 00 00       	cmp    $0x200,%eax
801044ea:	0f 85 70 ff ff ff    	jne    80104460 <fork+0x1b0>
801044f0:	e9 90 fe ff ff       	jmp    80104385 <fork+0xd5>
    return -1;
801044f5:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
801044fc:	e9 ad fe ff ff       	jmp    801043ae <fork+0xfe>
    kfree(np->kstack);
80104501:	83 ec 0c             	sub    $0xc,%esp
80104504:	ff 72 08             	pushl  0x8(%edx)
80104507:	e8 94 e6 ff ff       	call   80102ba0 <kfree>
    np->kstack = 0;
8010450c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
8010450f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
80104516:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104519:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
80104520:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80104527:	e9 82 fe ff ff       	jmp    801043ae <fork+0xfe>
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104530 <scheduler>:
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	57                   	push   %edi
80104538:	56                   	push   %esi
80104539:	53                   	push   %ebx
8010453a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010453d:	e8 2e fb ff ff       	call   80104070 <mycpu>
  c->proc = 0;
80104542:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104549:	00 00 00 
  struct cpu *c = mycpu();
8010454c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010454e:	8d 78 04             	lea    0x4(%eax),%edi
80104551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104558:	fb                   	sti    
    acquire(&ptable.lock);
80104559:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010455c:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
    acquire(&ptable.lock);
80104561:	68 40 3d 11 80       	push   $0x80113d40
80104566:	e8 c5 09 00 00       	call   80104f30 <acquire>
8010456b:	83 c4 10             	add    $0x10,%esp
8010456e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104570:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104574:	75 33                	jne    801045a9 <scheduler+0x79>
      switchuvm(p);
80104576:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104579:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010457f:	53                   	push   %ebx
80104580:	e8 3b 2f 00 00       	call   801074c0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104585:	58                   	pop    %eax
80104586:	5a                   	pop    %edx
80104587:	ff 73 1c             	pushl  0x1c(%ebx)
8010458a:	57                   	push   %edi
      p->state = RUNNING;
8010458b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104592:	e8 cc 0c 00 00       	call   80105263 <swtch>
      switchkvm();
80104597:	e8 04 2f 00 00       	call   801074a0 <switchkvm>
      c->proc = 0;
8010459c:	83 c4 10             	add    $0x10,%esp
8010459f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801045a6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045a9:	81 c3 90 03 00 00    	add    $0x390,%ebx
801045af:	81 fb 74 21 12 80    	cmp    $0x80122174,%ebx
801045b5:	75 b9                	jne    80104570 <scheduler+0x40>
    release(&ptable.lock);
801045b7:	83 ec 0c             	sub    $0xc,%esp
801045ba:	68 40 3d 11 80       	push   $0x80113d40
801045bf:	e8 2c 0a 00 00       	call   80104ff0 <release>
    sti();
801045c4:	83 c4 10             	add    $0x10,%esp
801045c7:	eb 8f                	jmp    80104558 <scheduler+0x28>
801045c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045d0 <sched>:
{
801045d0:	f3 0f 1e fb          	endbr32 
801045d4:	55                   	push   %ebp
801045d5:	89 e5                	mov    %esp,%ebp
801045d7:	56                   	push   %esi
801045d8:	53                   	push   %ebx
  pushcli();
801045d9:	e8 52 08 00 00       	call   80104e30 <pushcli>
  c = mycpu();
801045de:	e8 8d fa ff ff       	call   80104070 <mycpu>
  p = c->proc;
801045e3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045e9:	e8 92 08 00 00       	call   80104e80 <popcli>
  if(!holding(&ptable.lock))
801045ee:	83 ec 0c             	sub    $0xc,%esp
801045f1:	68 40 3d 11 80       	push   $0x80113d40
801045f6:	e8 e5 08 00 00       	call   80104ee0 <holding>
801045fb:	83 c4 10             	add    $0x10,%esp
801045fe:	85 c0                	test   %eax,%eax
80104600:	74 4f                	je     80104651 <sched+0x81>
  if(mycpu()->ncli != 1)
80104602:	e8 69 fa ff ff       	call   80104070 <mycpu>
80104607:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010460e:	75 68                	jne    80104678 <sched+0xa8>
  if(p->state == RUNNING)
80104610:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104614:	74 55                	je     8010466b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104616:	9c                   	pushf  
80104617:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104618:	f6 c4 02             	test   $0x2,%ah
8010461b:	75 41                	jne    8010465e <sched+0x8e>
  intena = mycpu()->intena;
8010461d:	e8 4e fa ff ff       	call   80104070 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104622:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104625:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010462b:	e8 40 fa ff ff       	call   80104070 <mycpu>
80104630:	83 ec 08             	sub    $0x8,%esp
80104633:	ff 70 04             	pushl  0x4(%eax)
80104636:	53                   	push   %ebx
80104637:	e8 27 0c 00 00       	call   80105263 <swtch>
  mycpu()->intena = intena;
8010463c:	e8 2f fa ff ff       	call   80104070 <mycpu>
}
80104641:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104644:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010464a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010464d:	5b                   	pop    %ebx
8010464e:	5e                   	pop    %esi
8010464f:	5d                   	pop    %ebp
80104650:	c3                   	ret    
    panic("sched ptable.lock");
80104651:	83 ec 0c             	sub    $0xc,%esp
80104654:	68 5b 87 10 80       	push   $0x8010875b
80104659:	e8 32 bd ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010465e:	83 ec 0c             	sub    $0xc,%esp
80104661:	68 87 87 10 80       	push   $0x80108787
80104666:	e8 25 bd ff ff       	call   80100390 <panic>
    panic("sched running");
8010466b:	83 ec 0c             	sub    $0xc,%esp
8010466e:	68 79 87 10 80       	push   $0x80108779
80104673:	e8 18 bd ff ff       	call   80100390 <panic>
    panic("sched locks");
80104678:	83 ec 0c             	sub    $0xc,%esp
8010467b:	68 6d 87 10 80       	push   $0x8010876d
80104680:	e8 0b bd ff ff       	call   80100390 <panic>
80104685:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104690 <exit>:
{
80104690:	f3 0f 1e fb          	endbr32 
80104694:	55                   	push   %ebp
80104695:	89 e5                	mov    %esp,%ebp
80104697:	57                   	push   %edi
80104698:	56                   	push   %esi
80104699:	53                   	push   %ebx
8010469a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010469d:	e8 8e 07 00 00       	call   80104e30 <pushcli>
  c = mycpu();
801046a2:	e8 c9 f9 ff ff       	call   80104070 <mycpu>
  p = c->proc;
801046a7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046ad:	e8 ce 07 00 00       	call   80104e80 <popcli>
  if(curproc == initproc)
801046b2:	8d 73 28             	lea    0x28(%ebx),%esi
801046b5:	8d 7b 68             	lea    0x68(%ebx),%edi
801046b8:	39 1d b8 b5 10 80    	cmp    %ebx,0x8010b5b8
801046be:	0f 84 fd 00 00 00    	je     801047c1 <exit+0x131>
801046c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801046c8:	8b 06                	mov    (%esi),%eax
801046ca:	85 c0                	test   %eax,%eax
801046cc:	74 12                	je     801046e0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801046ce:	83 ec 0c             	sub    $0xc,%esp
801046d1:	50                   	push   %eax
801046d2:	e8 99 cb ff ff       	call   80101270 <fileclose>
      curproc->ofile[fd] = 0;
801046d7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801046dd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801046e0:	83 c6 04             	add    $0x4,%esi
801046e3:	39 f7                	cmp    %esi,%edi
801046e5:	75 e1                	jne    801046c8 <exit+0x38>
  begin_op();
801046e7:	e8 74 ed ff ff       	call   80103460 <begin_op>
  iput(curproc->cwd);
801046ec:	83 ec 0c             	sub    $0xc,%esp
801046ef:	ff 73 68             	pushl  0x68(%ebx)
801046f2:	e8 49 d5 ff ff       	call   80101c40 <iput>
  end_op();
801046f7:	e8 d4 ed ff ff       	call   801034d0 <end_op>
  curproc->cwd = 0;
801046fc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  removeSwapFile(curproc);
80104703:	89 1c 24             	mov    %ebx,(%esp)
80104706:	e8 a5 dd ff ff       	call   801024b0 <removeSwapFile>
  acquire(&ptable.lock);
8010470b:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104712:	e8 19 08 00 00       	call   80104f30 <acquire>
  wakeup1(curproc->parent);
80104717:	8b 53 14             	mov    0x14(%ebx),%edx
8010471a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010471d:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104722:	eb 10                	jmp    80104734 <exit+0xa4>
80104724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104728:	05 90 03 00 00       	add    $0x390,%eax
8010472d:	3d 74 21 12 80       	cmp    $0x80122174,%eax
80104732:	74 1e                	je     80104752 <exit+0xc2>
    if(p->state == SLEEPING && p->chan == chan)
80104734:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104738:	75 ee                	jne    80104728 <exit+0x98>
8010473a:	3b 50 20             	cmp    0x20(%eax),%edx
8010473d:	75 e9                	jne    80104728 <exit+0x98>
      p->state = RUNNABLE;
8010473f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104746:	05 90 03 00 00       	add    $0x390,%eax
8010474b:	3d 74 21 12 80       	cmp    $0x80122174,%eax
80104750:	75 e2                	jne    80104734 <exit+0xa4>
      p->parent = initproc;
80104752:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104758:	ba 74 3d 11 80       	mov    $0x80113d74,%edx
8010475d:	eb 0f                	jmp    8010476e <exit+0xde>
8010475f:	90                   	nop
80104760:	81 c2 90 03 00 00    	add    $0x390,%edx
80104766:	81 fa 74 21 12 80    	cmp    $0x80122174,%edx
8010476c:	74 3a                	je     801047a8 <exit+0x118>
    if(p->parent == curproc){
8010476e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104771:	75 ed                	jne    80104760 <exit+0xd0>
      if(p->state == ZOMBIE)
80104773:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104777:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010477a:	75 e4                	jne    80104760 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010477c:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104781:	eb 11                	jmp    80104794 <exit+0x104>
80104783:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104787:	90                   	nop
80104788:	05 90 03 00 00       	add    $0x390,%eax
8010478d:	3d 74 21 12 80       	cmp    $0x80122174,%eax
80104792:	74 cc                	je     80104760 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104794:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104798:	75 ee                	jne    80104788 <exit+0xf8>
8010479a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010479d:	75 e9                	jne    80104788 <exit+0xf8>
      p->state = RUNNABLE;
8010479f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801047a6:	eb e0                	jmp    80104788 <exit+0xf8>
  curproc->state = ZOMBIE;
801047a8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801047af:	e8 1c fe ff ff       	call   801045d0 <sched>
  panic("zombie exit");
801047b4:	83 ec 0c             	sub    $0xc,%esp
801047b7:	68 a8 87 10 80       	push   $0x801087a8
801047bc:	e8 cf bb ff ff       	call   80100390 <panic>
    panic("init exiting");
801047c1:	83 ec 0c             	sub    $0xc,%esp
801047c4:	68 9b 87 10 80       	push   $0x8010879b
801047c9:	e8 c2 bb ff ff       	call   80100390 <panic>
801047ce:	66 90                	xchg   %ax,%ax

801047d0 <yield>:
{
801047d0:	f3 0f 1e fb          	endbr32 
801047d4:	55                   	push   %ebp
801047d5:	89 e5                	mov    %esp,%ebp
801047d7:	53                   	push   %ebx
801047d8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801047db:	68 40 3d 11 80       	push   $0x80113d40
801047e0:	e8 4b 07 00 00       	call   80104f30 <acquire>
  pushcli();
801047e5:	e8 46 06 00 00       	call   80104e30 <pushcli>
  c = mycpu();
801047ea:	e8 81 f8 ff ff       	call   80104070 <mycpu>
  p = c->proc;
801047ef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047f5:	e8 86 06 00 00       	call   80104e80 <popcli>
  myproc()->state = RUNNABLE;
801047fa:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104801:	e8 ca fd ff ff       	call   801045d0 <sched>
  release(&ptable.lock);
80104806:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010480d:	e8 de 07 00 00       	call   80104ff0 <release>
}
80104812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104815:	83 c4 10             	add    $0x10,%esp
80104818:	c9                   	leave  
80104819:	c3                   	ret    
8010481a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104820 <sleep>:
{
80104820:	f3 0f 1e fb          	endbr32 
80104824:	55                   	push   %ebp
80104825:	89 e5                	mov    %esp,%ebp
80104827:	57                   	push   %edi
80104828:	56                   	push   %esi
80104829:	53                   	push   %ebx
8010482a:	83 ec 0c             	sub    $0xc,%esp
8010482d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104830:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104833:	e8 f8 05 00 00       	call   80104e30 <pushcli>
  c = mycpu();
80104838:	e8 33 f8 ff ff       	call   80104070 <mycpu>
  p = c->proc;
8010483d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104843:	e8 38 06 00 00       	call   80104e80 <popcli>
  if(p == 0)
80104848:	85 db                	test   %ebx,%ebx
8010484a:	0f 84 83 00 00 00    	je     801048d3 <sleep+0xb3>
  if(lk == 0)
80104850:	85 f6                	test   %esi,%esi
80104852:	74 72                	je     801048c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104854:	81 fe 40 3d 11 80    	cmp    $0x80113d40,%esi
8010485a:	74 4c                	je     801048a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010485c:	83 ec 0c             	sub    $0xc,%esp
8010485f:	68 40 3d 11 80       	push   $0x80113d40
80104864:	e8 c7 06 00 00       	call   80104f30 <acquire>
    release(lk);
80104869:	89 34 24             	mov    %esi,(%esp)
8010486c:	e8 7f 07 00 00       	call   80104ff0 <release>
  p->chan = chan;
80104871:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104874:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010487b:	e8 50 fd ff ff       	call   801045d0 <sched>
  p->chan = 0;
80104880:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104887:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010488e:	e8 5d 07 00 00       	call   80104ff0 <release>
    acquire(lk);
80104893:	89 75 08             	mov    %esi,0x8(%ebp)
80104896:	83 c4 10             	add    $0x10,%esp
}
80104899:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010489c:	5b                   	pop    %ebx
8010489d:	5e                   	pop    %esi
8010489e:	5f                   	pop    %edi
8010489f:	5d                   	pop    %ebp
    acquire(lk);
801048a0:	e9 8b 06 00 00       	jmp    80104f30 <acquire>
801048a5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801048a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801048ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801048b2:	e8 19 fd ff ff       	call   801045d0 <sched>
  p->chan = 0;
801048b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801048be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048c1:	5b                   	pop    %ebx
801048c2:	5e                   	pop    %esi
801048c3:	5f                   	pop    %edi
801048c4:	5d                   	pop    %ebp
801048c5:	c3                   	ret    
    panic("sleep without lk");
801048c6:	83 ec 0c             	sub    $0xc,%esp
801048c9:	68 ba 87 10 80       	push   $0x801087ba
801048ce:	e8 bd ba ff ff       	call   80100390 <panic>
    panic("sleep");
801048d3:	83 ec 0c             	sub    $0xc,%esp
801048d6:	68 b4 87 10 80       	push   $0x801087b4
801048db:	e8 b0 ba ff ff       	call   80100390 <panic>

801048e0 <wait>:
{
801048e0:	f3 0f 1e fb          	endbr32 
801048e4:	55                   	push   %ebp
801048e5:	89 e5                	mov    %esp,%ebp
801048e7:	56                   	push   %esi
801048e8:	53                   	push   %ebx
  pushcli();
801048e9:	e8 42 05 00 00       	call   80104e30 <pushcli>
  c = mycpu();
801048ee:	e8 7d f7 ff ff       	call   80104070 <mycpu>
  p = c->proc;
801048f3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801048f9:	e8 82 05 00 00       	call   80104e80 <popcli>
  acquire(&ptable.lock);
801048fe:	83 ec 0c             	sub    $0xc,%esp
80104901:	68 40 3d 11 80       	push   $0x80113d40
80104906:	e8 25 06 00 00       	call   80104f30 <acquire>
8010490b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010490e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104910:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
80104915:	eb 17                	jmp    8010492e <wait+0x4e>
80104917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010491e:	66 90                	xchg   %ax,%ax
80104920:	81 c3 90 03 00 00    	add    $0x390,%ebx
80104926:	81 fb 74 21 12 80    	cmp    $0x80122174,%ebx
8010492c:	74 1e                	je     8010494c <wait+0x6c>
      if(p->parent != curproc)
8010492e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104931:	75 ed                	jne    80104920 <wait+0x40>
      if(p->state == ZOMBIE){
80104933:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104937:	74 3f                	je     80104978 <wait+0x98>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104939:	81 c3 90 03 00 00    	add    $0x390,%ebx
      havekids = 1;
8010493f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104944:	81 fb 74 21 12 80    	cmp    $0x80122174,%ebx
8010494a:	75 e2                	jne    8010492e <wait+0x4e>
    if(!havekids || curproc->killed){
8010494c:	85 c0                	test   %eax,%eax
8010494e:	0f 84 09 01 00 00    	je     80104a5d <wait+0x17d>
80104954:	8b 46 24             	mov    0x24(%esi),%eax
80104957:	85 c0                	test   %eax,%eax
80104959:	0f 85 fe 00 00 00    	jne    80104a5d <wait+0x17d>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010495f:	83 ec 08             	sub    $0x8,%esp
80104962:	68 40 3d 11 80       	push   $0x80113d40
80104967:	56                   	push   %esi
80104968:	e8 b3 fe ff ff       	call   80104820 <sleep>
    havekids = 0;
8010496d:	83 c4 10             	add    $0x10,%esp
80104970:	eb 9c                	jmp    8010490e <wait+0x2e>
80104972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (p->pid > 2){
80104978:	8b 73 10             	mov    0x10(%ebx),%esi
8010497b:	83 fe 02             	cmp    $0x2,%esi
8010497e:	0f 8e 86 00 00 00    	jle    80104a0a <wait+0x12a>
          p->num_of_pagefaults_occurs = 0;
80104984:	c7 83 88 03 00 00 00 	movl   $0x0,0x388(%ebx)
8010498b:	00 00 00 
          p->num_of_actual_pages_in_mem = 0;
8010498e:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80104994:	8d 93 00 02 00 00    	lea    0x200(%ebx),%edx
8010499a:	c7 83 84 03 00 00 00 	movl   $0x0,0x384(%ebx)
801049a1:	00 00 00 
          p->num_of_pageOut_occured = 0;
801049a4:	c7 83 8c 03 00 00 00 	movl   $0x0,0x38c(%ebx)
801049ab:	00 00 00 
          p->num_of_pages_in_swap_file = 0;
801049ae:	c7 83 80 03 00 00 00 	movl   $0x0,0x380(%ebx)
801049b5:	00 00 00 
          for (int i = 0; i < MAX_PYSC_PAGES; i++){
801049b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049bf:	90                   	nop
            p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
801049c0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
801049c6:	83 c0 18             	add    $0x18,%eax
801049c9:	c7 80 68 01 00 00 01 	movl   $0x1,0x168(%eax)
801049d0:	00 00 00 
            p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
801049d3:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
801049da:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
801049e1:	00 00 00 
            p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
801049e4:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
801049eb:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
801049f2:	00 00 00 
            p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
801049f5:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
801049fc:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
80104a03:	00 00 00 
          for (int i = 0; i < MAX_PYSC_PAGES; i++){
80104a06:	39 d0                	cmp    %edx,%eax
80104a08:	75 b6                	jne    801049c0 <wait+0xe0>
        kfree(p->kstack);
80104a0a:	83 ec 0c             	sub    $0xc,%esp
80104a0d:	ff 73 08             	pushl  0x8(%ebx)
80104a10:	e8 8b e1 ff ff       	call   80102ba0 <kfree>
        freevm(p->pgdir);
80104a15:	5a                   	pop    %edx
80104a16:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104a19:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104a20:	e8 0b 2e 00 00       	call   80107830 <freevm>
        release(&ptable.lock);
80104a25:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
        p->pid = 0;
80104a2c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104a33:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104a3a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104a3e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104a45:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104a4c:	e8 9f 05 00 00       	call   80104ff0 <release>
        return pid;
80104a51:	83 c4 10             	add    $0x10,%esp
}
80104a54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a57:	89 f0                	mov    %esi,%eax
80104a59:	5b                   	pop    %ebx
80104a5a:	5e                   	pop    %esi
80104a5b:	5d                   	pop    %ebp
80104a5c:	c3                   	ret    
      release(&ptable.lock);
80104a5d:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104a60:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104a65:	68 40 3d 11 80       	push   $0x80113d40
80104a6a:	e8 81 05 00 00       	call   80104ff0 <release>
      return -1;
80104a6f:	83 c4 10             	add    $0x10,%esp
80104a72:	eb e0                	jmp    80104a54 <wait+0x174>
80104a74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a7f:	90                   	nop

80104a80 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104a80:	f3 0f 1e fb          	endbr32 
80104a84:	55                   	push   %ebp
80104a85:	89 e5                	mov    %esp,%ebp
80104a87:	53                   	push   %ebx
80104a88:	83 ec 10             	sub    $0x10,%esp
80104a8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104a8e:	68 40 3d 11 80       	push   $0x80113d40
80104a93:	e8 98 04 00 00       	call   80104f30 <acquire>
80104a98:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a9b:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104aa0:	eb 12                	jmp    80104ab4 <wakeup+0x34>
80104aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aa8:	05 90 03 00 00       	add    $0x390,%eax
80104aad:	3d 74 21 12 80       	cmp    $0x80122174,%eax
80104ab2:	74 1e                	je     80104ad2 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104ab4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104ab8:	75 ee                	jne    80104aa8 <wakeup+0x28>
80104aba:	3b 58 20             	cmp    0x20(%eax),%ebx
80104abd:	75 e9                	jne    80104aa8 <wakeup+0x28>
      p->state = RUNNABLE;
80104abf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ac6:	05 90 03 00 00       	add    $0x390,%eax
80104acb:	3d 74 21 12 80       	cmp    $0x80122174,%eax
80104ad0:	75 e2                	jne    80104ab4 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104ad2:	c7 45 08 40 3d 11 80 	movl   $0x80113d40,0x8(%ebp)
}
80104ad9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104adc:	c9                   	leave  
  release(&ptable.lock);
80104add:	e9 0e 05 00 00       	jmp    80104ff0 <release>
80104ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104af0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104af0:	f3 0f 1e fb          	endbr32 
80104af4:	55                   	push   %ebp
80104af5:	89 e5                	mov    %esp,%ebp
80104af7:	53                   	push   %ebx
80104af8:	83 ec 10             	sub    $0x10,%esp
80104afb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104afe:	68 40 3d 11 80       	push   $0x80113d40
80104b03:	e8 28 04 00 00       	call   80104f30 <acquire>
80104b08:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b0b:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104b10:	eb 12                	jmp    80104b24 <kill+0x34>
80104b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b18:	05 90 03 00 00       	add    $0x390,%eax
80104b1d:	3d 74 21 12 80       	cmp    $0x80122174,%eax
80104b22:	74 34                	je     80104b58 <kill+0x68>
    if(p->pid == pid){
80104b24:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b27:	75 ef                	jne    80104b18 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104b29:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104b2d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104b34:	75 07                	jne    80104b3d <kill+0x4d>
        p->state = RUNNABLE;
80104b36:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104b3d:	83 ec 0c             	sub    $0xc,%esp
80104b40:	68 40 3d 11 80       	push   $0x80113d40
80104b45:	e8 a6 04 00 00       	call   80104ff0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104b4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104b4d:	83 c4 10             	add    $0x10,%esp
80104b50:	31 c0                	xor    %eax,%eax
}
80104b52:	c9                   	leave  
80104b53:	c3                   	ret    
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104b58:	83 ec 0c             	sub    $0xc,%esp
80104b5b:	68 40 3d 11 80       	push   $0x80113d40
80104b60:	e8 8b 04 00 00       	call   80104ff0 <release>
}
80104b65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104b68:	83 c4 10             	add    $0x10,%esp
80104b6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b70:	c9                   	leave  
80104b71:	c3                   	ret    
80104b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b80 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104b80:	f3 0f 1e fb          	endbr32 
80104b84:	55                   	push   %ebp
80104b85:	89 e5                	mov    %esp,%ebp
80104b87:	57                   	push   %edi
80104b88:	56                   	push   %esi
80104b89:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104b8c:	53                   	push   %ebx
80104b8d:	bb e0 3d 11 80       	mov    $0x80113de0,%ebx
80104b92:	83 ec 3c             	sub    $0x3c,%esp
80104b95:	eb 2b                	jmp    80104bc2 <procdump+0x42>
80104b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b9e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104ba0:	83 ec 0c             	sub    $0xc,%esp
80104ba3:	68 ea 8b 10 80       	push   $0x80108bea
80104ba8:	e8 03 bb ff ff       	call   801006b0 <cprintf>
80104bad:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bb0:	81 c3 90 03 00 00    	add    $0x390,%ebx
80104bb6:	81 fb e0 21 12 80    	cmp    $0x801221e0,%ebx
80104bbc:	0f 84 9e 00 00 00    	je     80104c60 <procdump+0xe0>
    if(p->state == UNUSED)
80104bc2:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104bc5:	85 c0                	test   %eax,%eax
80104bc7:	74 e7                	je     80104bb0 <procdump+0x30>
      state = "???";
80104bc9:	ba cb 87 10 80       	mov    $0x801087cb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104bce:	83 f8 05             	cmp    $0x5,%eax
80104bd1:	77 11                	ja     80104be4 <procdump+0x64>
80104bd3:	8b 14 85 3c 88 10 80 	mov    -0x7fef77c4(,%eax,4),%edx
      state = "???";
80104bda:	b8 cb 87 10 80       	mov    $0x801087cb,%eax
80104bdf:	85 d2                	test   %edx,%edx
80104be1:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s RAM: %d SWAP: %d", p->pid, state, p->name, p->num_of_actual_pages_in_mem, p->num_of_pages_in_swap_file);
80104be4:	83 ec 08             	sub    $0x8,%esp
80104be7:	ff b3 14 03 00 00    	pushl  0x314(%ebx)
80104bed:	ff b3 18 03 00 00    	pushl  0x318(%ebx)
80104bf3:	53                   	push   %ebx
80104bf4:	52                   	push   %edx
80104bf5:	ff 73 a4             	pushl  -0x5c(%ebx)
80104bf8:	68 cf 87 10 80       	push   $0x801087cf
80104bfd:	e8 ae ba ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104c02:	83 c4 20             	add    $0x20,%esp
80104c05:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104c09:	75 95                	jne    80104ba0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104c0b:	83 ec 08             	sub    $0x8,%esp
80104c0e:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104c11:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104c14:	50                   	push   %eax
80104c15:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104c18:	8b 40 0c             	mov    0xc(%eax),%eax
80104c1b:	83 c0 08             	add    $0x8,%eax
80104c1e:	50                   	push   %eax
80104c1f:	e8 ac 01 00 00       	call   80104dd0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c24:	83 c4 10             	add    $0x10,%esp
80104c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2e:	66 90                	xchg   %ax,%ax
80104c30:	8b 17                	mov    (%edi),%edx
80104c32:	85 d2                	test   %edx,%edx
80104c34:	0f 84 66 ff ff ff    	je     80104ba0 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104c3a:	83 ec 08             	sub    $0x8,%esp
80104c3d:	83 c7 04             	add    $0x4,%edi
80104c40:	52                   	push   %edx
80104c41:	68 e1 81 10 80       	push   $0x801081e1
80104c46:	e8 65 ba ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c4b:	83 c4 10             	add    $0x10,%esp
80104c4e:	39 fe                	cmp    %edi,%esi
80104c50:	75 de                	jne    80104c30 <procdump+0xb0>
80104c52:	e9 49 ff ff ff       	jmp    80104ba0 <procdump+0x20>
80104c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5e:	66 90                	xchg   %ax,%ax
  }
}
80104c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c63:	5b                   	pop    %ebx
80104c64:	5e                   	pop    %esi
80104c65:	5f                   	pop    %edi
80104c66:	5d                   	pop    %ebp
80104c67:	c3                   	ret    
80104c68:	66 90                	xchg   %ax,%ax
80104c6a:	66 90                	xchg   %ax,%ax
80104c6c:	66 90                	xchg   %ax,%ax
80104c6e:	66 90                	xchg   %ax,%ax

80104c70 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	53                   	push   %ebx
80104c78:	83 ec 0c             	sub    $0xc,%esp
80104c7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104c7e:	68 54 88 10 80       	push   $0x80108854
80104c83:	8d 43 04             	lea    0x4(%ebx),%eax
80104c86:	50                   	push   %eax
80104c87:	e8 24 01 00 00       	call   80104db0 <initlock>
  lk->name = name;
80104c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104c8f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104c95:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104c98:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104c9f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104ca2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca5:	c9                   	leave  
80104ca6:	c3                   	ret    
80104ca7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cae:	66 90                	xchg   %ax,%ax

80104cb0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104cb0:	f3 0f 1e fb          	endbr32 
80104cb4:	55                   	push   %ebp
80104cb5:	89 e5                	mov    %esp,%ebp
80104cb7:	56                   	push   %esi
80104cb8:	53                   	push   %ebx
80104cb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104cbc:	8d 73 04             	lea    0x4(%ebx),%esi
80104cbf:	83 ec 0c             	sub    $0xc,%esp
80104cc2:	56                   	push   %esi
80104cc3:	e8 68 02 00 00       	call   80104f30 <acquire>
  while (lk->locked) {
80104cc8:	8b 13                	mov    (%ebx),%edx
80104cca:	83 c4 10             	add    $0x10,%esp
80104ccd:	85 d2                	test   %edx,%edx
80104ccf:	74 1a                	je     80104ceb <acquiresleep+0x3b>
80104cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104cd8:	83 ec 08             	sub    $0x8,%esp
80104cdb:	56                   	push   %esi
80104cdc:	53                   	push   %ebx
80104cdd:	e8 3e fb ff ff       	call   80104820 <sleep>
  while (lk->locked) {
80104ce2:	8b 03                	mov    (%ebx),%eax
80104ce4:	83 c4 10             	add    $0x10,%esp
80104ce7:	85 c0                	test   %eax,%eax
80104ce9:	75 ed                	jne    80104cd8 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104ceb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104cf1:	e8 0a f4 ff ff       	call   80104100 <myproc>
80104cf6:	8b 40 10             	mov    0x10(%eax),%eax
80104cf9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104cfc:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104cff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d02:	5b                   	pop    %ebx
80104d03:	5e                   	pop    %esi
80104d04:	5d                   	pop    %ebp
  release(&lk->lk);
80104d05:	e9 e6 02 00 00       	jmp    80104ff0 <release>
80104d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d10 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104d10:	f3 0f 1e fb          	endbr32 
80104d14:	55                   	push   %ebp
80104d15:	89 e5                	mov    %esp,%ebp
80104d17:	56                   	push   %esi
80104d18:	53                   	push   %ebx
80104d19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d1c:	8d 73 04             	lea    0x4(%ebx),%esi
80104d1f:	83 ec 0c             	sub    $0xc,%esp
80104d22:	56                   	push   %esi
80104d23:	e8 08 02 00 00       	call   80104f30 <acquire>
  lk->locked = 0;
80104d28:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104d2e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104d35:	89 1c 24             	mov    %ebx,(%esp)
80104d38:	e8 43 fd ff ff       	call   80104a80 <wakeup>
  release(&lk->lk);
80104d3d:	89 75 08             	mov    %esi,0x8(%ebp)
80104d40:	83 c4 10             	add    $0x10,%esp
}
80104d43:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d46:	5b                   	pop    %ebx
80104d47:	5e                   	pop    %esi
80104d48:	5d                   	pop    %ebp
  release(&lk->lk);
80104d49:	e9 a2 02 00 00       	jmp    80104ff0 <release>
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104d50:	f3 0f 1e fb          	endbr32 
80104d54:	55                   	push   %ebp
80104d55:	89 e5                	mov    %esp,%ebp
80104d57:	57                   	push   %edi
80104d58:	31 ff                	xor    %edi,%edi
80104d5a:	56                   	push   %esi
80104d5b:	53                   	push   %ebx
80104d5c:	83 ec 18             	sub    $0x18,%esp
80104d5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104d62:	8d 73 04             	lea    0x4(%ebx),%esi
80104d65:	56                   	push   %esi
80104d66:	e8 c5 01 00 00       	call   80104f30 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104d6b:	8b 03                	mov    (%ebx),%eax
80104d6d:	83 c4 10             	add    $0x10,%esp
80104d70:	85 c0                	test   %eax,%eax
80104d72:	75 1c                	jne    80104d90 <holdingsleep+0x40>
  release(&lk->lk);
80104d74:	83 ec 0c             	sub    $0xc,%esp
80104d77:	56                   	push   %esi
80104d78:	e8 73 02 00 00       	call   80104ff0 <release>
  return r;
}
80104d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d80:	89 f8                	mov    %edi,%eax
80104d82:	5b                   	pop    %ebx
80104d83:	5e                   	pop    %esi
80104d84:	5f                   	pop    %edi
80104d85:	5d                   	pop    %ebp
80104d86:	c3                   	ret    
80104d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104d90:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104d93:	e8 68 f3 ff ff       	call   80104100 <myproc>
80104d98:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d9b:	0f 94 c0             	sete   %al
80104d9e:	0f b6 c0             	movzbl %al,%eax
80104da1:	89 c7                	mov    %eax,%edi
80104da3:	eb cf                	jmp    80104d74 <holdingsleep+0x24>
80104da5:	66 90                	xchg   %ax,%ax
80104da7:	66 90                	xchg   %ax,%ax
80104da9:	66 90                	xchg   %ax,%ax
80104dab:	66 90                	xchg   %ax,%ax
80104dad:	66 90                	xchg   %ax,%ax
80104daf:	90                   	nop

80104db0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104db0:	f3 0f 1e fb          	endbr32 
80104db4:	55                   	push   %ebp
80104db5:	89 e5                	mov    %esp,%ebp
80104db7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104dba:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104dbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104dc3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104dc6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104dcd:	5d                   	pop    %ebp
80104dce:	c3                   	ret    
80104dcf:	90                   	nop

80104dd0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104dd0:	f3 0f 1e fb          	endbr32 
80104dd4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104dd5:	31 d2                	xor    %edx,%edx
{
80104dd7:	89 e5                	mov    %esp,%ebp
80104dd9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104dda:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ddd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104de0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104de3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104de7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104de8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104dee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104df4:	77 1a                	ja     80104e10 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104df6:	8b 58 04             	mov    0x4(%eax),%ebx
80104df9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104dfc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104dff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e01:	83 fa 0a             	cmp    $0xa,%edx
80104e04:	75 e2                	jne    80104de8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104e06:	5b                   	pop    %ebx
80104e07:	5d                   	pop    %ebp
80104e08:	c3                   	ret    
80104e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104e10:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104e13:	8d 51 28             	lea    0x28(%ecx),%edx
80104e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104e20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e26:	83 c0 04             	add    $0x4,%eax
80104e29:	39 d0                	cmp    %edx,%eax
80104e2b:	75 f3                	jne    80104e20 <getcallerpcs+0x50>
}
80104e2d:	5b                   	pop    %ebx
80104e2e:	5d                   	pop    %ebp
80104e2f:	c3                   	ret    

80104e30 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104e30:	f3 0f 1e fb          	endbr32 
80104e34:	55                   	push   %ebp
80104e35:	89 e5                	mov    %esp,%ebp
80104e37:	53                   	push   %ebx
80104e38:	83 ec 04             	sub    $0x4,%esp
80104e3b:	9c                   	pushf  
80104e3c:	5b                   	pop    %ebx
  asm volatile("cli");
80104e3d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104e3e:	e8 2d f2 ff ff       	call   80104070 <mycpu>
80104e43:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104e49:	85 c0                	test   %eax,%eax
80104e4b:	74 13                	je     80104e60 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104e4d:	e8 1e f2 ff ff       	call   80104070 <mycpu>
80104e52:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104e59:	83 c4 04             	add    $0x4,%esp
80104e5c:	5b                   	pop    %ebx
80104e5d:	5d                   	pop    %ebp
80104e5e:	c3                   	ret    
80104e5f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104e60:	e8 0b f2 ff ff       	call   80104070 <mycpu>
80104e65:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104e6b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104e71:	eb da                	jmp    80104e4d <pushcli+0x1d>
80104e73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e80 <popcli>:

void
popcli(void)
{
80104e80:	f3 0f 1e fb          	endbr32 
80104e84:	55                   	push   %ebp
80104e85:	89 e5                	mov    %esp,%ebp
80104e87:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e8a:	9c                   	pushf  
80104e8b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104e8c:	f6 c4 02             	test   $0x2,%ah
80104e8f:	75 31                	jne    80104ec2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104e91:	e8 da f1 ff ff       	call   80104070 <mycpu>
80104e96:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104e9d:	78 30                	js     80104ecf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e9f:	e8 cc f1 ff ff       	call   80104070 <mycpu>
80104ea4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104eaa:	85 d2                	test   %edx,%edx
80104eac:	74 02                	je     80104eb0 <popcli+0x30>
    sti();
}
80104eae:	c9                   	leave  
80104eaf:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104eb0:	e8 bb f1 ff ff       	call   80104070 <mycpu>
80104eb5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104ebb:	85 c0                	test   %eax,%eax
80104ebd:	74 ef                	je     80104eae <popcli+0x2e>
  asm volatile("sti");
80104ebf:	fb                   	sti    
}
80104ec0:	c9                   	leave  
80104ec1:	c3                   	ret    
    panic("popcli - interruptible");
80104ec2:	83 ec 0c             	sub    $0xc,%esp
80104ec5:	68 5f 88 10 80       	push   $0x8010885f
80104eca:	e8 c1 b4 ff ff       	call   80100390 <panic>
    panic("popcli");
80104ecf:	83 ec 0c             	sub    $0xc,%esp
80104ed2:	68 76 88 10 80       	push   $0x80108876
80104ed7:	e8 b4 b4 ff ff       	call   80100390 <panic>
80104edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ee0 <holding>:
{
80104ee0:	f3 0f 1e fb          	endbr32 
80104ee4:	55                   	push   %ebp
80104ee5:	89 e5                	mov    %esp,%ebp
80104ee7:	56                   	push   %esi
80104ee8:	53                   	push   %ebx
80104ee9:	8b 75 08             	mov    0x8(%ebp),%esi
80104eec:	31 db                	xor    %ebx,%ebx
  pushcli();
80104eee:	e8 3d ff ff ff       	call   80104e30 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104ef3:	8b 06                	mov    (%esi),%eax
80104ef5:	85 c0                	test   %eax,%eax
80104ef7:	75 0f                	jne    80104f08 <holding+0x28>
  popcli();
80104ef9:	e8 82 ff ff ff       	call   80104e80 <popcli>
}
80104efe:	89 d8                	mov    %ebx,%eax
80104f00:	5b                   	pop    %ebx
80104f01:	5e                   	pop    %esi
80104f02:	5d                   	pop    %ebp
80104f03:	c3                   	ret    
80104f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104f08:	8b 5e 08             	mov    0x8(%esi),%ebx
80104f0b:	e8 60 f1 ff ff       	call   80104070 <mycpu>
80104f10:	39 c3                	cmp    %eax,%ebx
80104f12:	0f 94 c3             	sete   %bl
  popcli();
80104f15:	e8 66 ff ff ff       	call   80104e80 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104f1a:	0f b6 db             	movzbl %bl,%ebx
}
80104f1d:	89 d8                	mov    %ebx,%eax
80104f1f:	5b                   	pop    %ebx
80104f20:	5e                   	pop    %esi
80104f21:	5d                   	pop    %ebp
80104f22:	c3                   	ret    
80104f23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f30 <acquire>:
{
80104f30:	f3 0f 1e fb          	endbr32 
80104f34:	55                   	push   %ebp
80104f35:	89 e5                	mov    %esp,%ebp
80104f37:	56                   	push   %esi
80104f38:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104f39:	e8 f2 fe ff ff       	call   80104e30 <pushcli>
  if(holding(lk))
80104f3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f41:	83 ec 0c             	sub    $0xc,%esp
80104f44:	53                   	push   %ebx
80104f45:	e8 96 ff ff ff       	call   80104ee0 <holding>
80104f4a:	83 c4 10             	add    $0x10,%esp
80104f4d:	85 c0                	test   %eax,%eax
80104f4f:	0f 85 7f 00 00 00    	jne    80104fd4 <acquire+0xa4>
80104f55:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104f57:	ba 01 00 00 00       	mov    $0x1,%edx
80104f5c:	eb 05                	jmp    80104f63 <acquire+0x33>
80104f5e:	66 90                	xchg   %ax,%ax
80104f60:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f63:	89 d0                	mov    %edx,%eax
80104f65:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104f68:	85 c0                	test   %eax,%eax
80104f6a:	75 f4                	jne    80104f60 <acquire+0x30>
  __sync_synchronize();
80104f6c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104f71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f74:	e8 f7 f0 ff ff       	call   80104070 <mycpu>
80104f79:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104f7c:	89 e8                	mov    %ebp,%eax
80104f7e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f80:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104f86:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104f8c:	77 22                	ja     80104fb0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104f8e:	8b 50 04             	mov    0x4(%eax),%edx
80104f91:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104f95:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104f98:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104f9a:	83 fe 0a             	cmp    $0xa,%esi
80104f9d:	75 e1                	jne    80104f80 <acquire+0x50>
}
80104f9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fa2:	5b                   	pop    %ebx
80104fa3:	5e                   	pop    %esi
80104fa4:	5d                   	pop    %ebp
80104fa5:	c3                   	ret    
80104fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fad:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104fb0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104fb4:	83 c3 34             	add    $0x34,%ebx
80104fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fbe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104fc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104fc6:	83 c0 04             	add    $0x4,%eax
80104fc9:	39 d8                	cmp    %ebx,%eax
80104fcb:	75 f3                	jne    80104fc0 <acquire+0x90>
}
80104fcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fd0:	5b                   	pop    %ebx
80104fd1:	5e                   	pop    %esi
80104fd2:	5d                   	pop    %ebp
80104fd3:	c3                   	ret    
    panic("acquire");
80104fd4:	83 ec 0c             	sub    $0xc,%esp
80104fd7:	68 7d 88 10 80       	push   $0x8010887d
80104fdc:	e8 af b3 ff ff       	call   80100390 <panic>
80104fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fef:	90                   	nop

80104ff0 <release>:
{
80104ff0:	f3 0f 1e fb          	endbr32 
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	53                   	push   %ebx
80104ff8:	83 ec 10             	sub    $0x10,%esp
80104ffb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104ffe:	53                   	push   %ebx
80104fff:	e8 dc fe ff ff       	call   80104ee0 <holding>
80105004:	83 c4 10             	add    $0x10,%esp
80105007:	85 c0                	test   %eax,%eax
80105009:	74 22                	je     8010502d <release+0x3d>
  lk->pcs[0] = 0;
8010500b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105012:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105019:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010501e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105024:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105027:	c9                   	leave  
  popcli();
80105028:	e9 53 fe ff ff       	jmp    80104e80 <popcli>
    panic("release");
8010502d:	83 ec 0c             	sub    $0xc,%esp
80105030:	68 85 88 10 80       	push   $0x80108885
80105035:	e8 56 b3 ff ff       	call   80100390 <panic>
8010503a:	66 90                	xchg   %ax,%ax
8010503c:	66 90                	xchg   %ax,%ax
8010503e:	66 90                	xchg   %ax,%ax

80105040 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105040:	f3 0f 1e fb          	endbr32 
80105044:	55                   	push   %ebp
80105045:	89 e5                	mov    %esp,%ebp
80105047:	57                   	push   %edi
80105048:	8b 55 08             	mov    0x8(%ebp),%edx
8010504b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010504e:	53                   	push   %ebx
8010504f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105052:	89 d7                	mov    %edx,%edi
80105054:	09 cf                	or     %ecx,%edi
80105056:	83 e7 03             	and    $0x3,%edi
80105059:	75 25                	jne    80105080 <memset+0x40>
    c &= 0xFF;
8010505b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010505e:	c1 e0 18             	shl    $0x18,%eax
80105061:	89 fb                	mov    %edi,%ebx
80105063:	c1 e9 02             	shr    $0x2,%ecx
80105066:	c1 e3 10             	shl    $0x10,%ebx
80105069:	09 d8                	or     %ebx,%eax
8010506b:	09 f8                	or     %edi,%eax
8010506d:	c1 e7 08             	shl    $0x8,%edi
80105070:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105072:	89 d7                	mov    %edx,%edi
80105074:	fc                   	cld    
80105075:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105077:	5b                   	pop    %ebx
80105078:	89 d0                	mov    %edx,%eax
8010507a:	5f                   	pop    %edi
8010507b:	5d                   	pop    %ebp
8010507c:	c3                   	ret    
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105080:	89 d7                	mov    %edx,%edi
80105082:	fc                   	cld    
80105083:	f3 aa                	rep stos %al,%es:(%edi)
80105085:	5b                   	pop    %ebx
80105086:	89 d0                	mov    %edx,%eax
80105088:	5f                   	pop    %edi
80105089:	5d                   	pop    %ebp
8010508a:	c3                   	ret    
8010508b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010508f:	90                   	nop

80105090 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105090:	f3 0f 1e fb          	endbr32 
80105094:	55                   	push   %ebp
80105095:	89 e5                	mov    %esp,%ebp
80105097:	56                   	push   %esi
80105098:	8b 75 10             	mov    0x10(%ebp),%esi
8010509b:	8b 55 08             	mov    0x8(%ebp),%edx
8010509e:	53                   	push   %ebx
8010509f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801050a2:	85 f6                	test   %esi,%esi
801050a4:	74 2a                	je     801050d0 <memcmp+0x40>
801050a6:	01 c6                	add    %eax,%esi
801050a8:	eb 10                	jmp    801050ba <memcmp+0x2a>
801050aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801050b0:	83 c0 01             	add    $0x1,%eax
801050b3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801050b6:	39 f0                	cmp    %esi,%eax
801050b8:	74 16                	je     801050d0 <memcmp+0x40>
    if(*s1 != *s2)
801050ba:	0f b6 0a             	movzbl (%edx),%ecx
801050bd:	0f b6 18             	movzbl (%eax),%ebx
801050c0:	38 d9                	cmp    %bl,%cl
801050c2:	74 ec                	je     801050b0 <memcmp+0x20>
      return *s1 - *s2;
801050c4:	0f b6 c1             	movzbl %cl,%eax
801050c7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801050c9:	5b                   	pop    %ebx
801050ca:	5e                   	pop    %esi
801050cb:	5d                   	pop    %ebp
801050cc:	c3                   	ret    
801050cd:	8d 76 00             	lea    0x0(%esi),%esi
801050d0:	5b                   	pop    %ebx
  return 0;
801050d1:	31 c0                	xor    %eax,%eax
}
801050d3:	5e                   	pop    %esi
801050d4:	5d                   	pop    %ebp
801050d5:	c3                   	ret    
801050d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050dd:	8d 76 00             	lea    0x0(%esi),%esi

801050e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801050e0:	f3 0f 1e fb          	endbr32 
801050e4:	55                   	push   %ebp
801050e5:	89 e5                	mov    %esp,%ebp
801050e7:	57                   	push   %edi
801050e8:	8b 55 08             	mov    0x8(%ebp),%edx
801050eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801050ee:	56                   	push   %esi
801050ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801050f2:	39 d6                	cmp    %edx,%esi
801050f4:	73 2a                	jae    80105120 <memmove+0x40>
801050f6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801050f9:	39 fa                	cmp    %edi,%edx
801050fb:	73 23                	jae    80105120 <memmove+0x40>
801050fd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105100:	85 c9                	test   %ecx,%ecx
80105102:	74 13                	je     80105117 <memmove+0x37>
80105104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105108:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010510c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010510f:	83 e8 01             	sub    $0x1,%eax
80105112:	83 f8 ff             	cmp    $0xffffffff,%eax
80105115:	75 f1                	jne    80105108 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105117:	5e                   	pop    %esi
80105118:	89 d0                	mov    %edx,%eax
8010511a:	5f                   	pop    %edi
8010511b:	5d                   	pop    %ebp
8010511c:	c3                   	ret    
8010511d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105120:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105123:	89 d7                	mov    %edx,%edi
80105125:	85 c9                	test   %ecx,%ecx
80105127:	74 ee                	je     80105117 <memmove+0x37>
80105129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105130:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105131:	39 f0                	cmp    %esi,%eax
80105133:	75 fb                	jne    80105130 <memmove+0x50>
}
80105135:	5e                   	pop    %esi
80105136:	89 d0                	mov    %edx,%eax
80105138:	5f                   	pop    %edi
80105139:	5d                   	pop    %ebp
8010513a:	c3                   	ret    
8010513b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010513f:	90                   	nop

80105140 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105140:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105144:	eb 9a                	jmp    801050e0 <memmove>
80105146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514d:	8d 76 00             	lea    0x0(%esi),%esi

80105150 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105150:	f3 0f 1e fb          	endbr32 
80105154:	55                   	push   %ebp
80105155:	89 e5                	mov    %esp,%ebp
80105157:	56                   	push   %esi
80105158:	8b 75 10             	mov    0x10(%ebp),%esi
8010515b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010515e:	53                   	push   %ebx
8010515f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105162:	85 f6                	test   %esi,%esi
80105164:	74 32                	je     80105198 <strncmp+0x48>
80105166:	01 c6                	add    %eax,%esi
80105168:	eb 14                	jmp    8010517e <strncmp+0x2e>
8010516a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105170:	38 da                	cmp    %bl,%dl
80105172:	75 14                	jne    80105188 <strncmp+0x38>
    n--, p++, q++;
80105174:	83 c0 01             	add    $0x1,%eax
80105177:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010517a:	39 f0                	cmp    %esi,%eax
8010517c:	74 1a                	je     80105198 <strncmp+0x48>
8010517e:	0f b6 11             	movzbl (%ecx),%edx
80105181:	0f b6 18             	movzbl (%eax),%ebx
80105184:	84 d2                	test   %dl,%dl
80105186:	75 e8                	jne    80105170 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105188:	0f b6 c2             	movzbl %dl,%eax
8010518b:	29 d8                	sub    %ebx,%eax
}
8010518d:	5b                   	pop    %ebx
8010518e:	5e                   	pop    %esi
8010518f:	5d                   	pop    %ebp
80105190:	c3                   	ret    
80105191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105198:	5b                   	pop    %ebx
    return 0;
80105199:	31 c0                	xor    %eax,%eax
}
8010519b:	5e                   	pop    %esi
8010519c:	5d                   	pop    %ebp
8010519d:	c3                   	ret    
8010519e:	66 90                	xchg   %ax,%ax

801051a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801051a0:	f3 0f 1e fb          	endbr32 
801051a4:	55                   	push   %ebp
801051a5:	89 e5                	mov    %esp,%ebp
801051a7:	57                   	push   %edi
801051a8:	56                   	push   %esi
801051a9:	8b 75 08             	mov    0x8(%ebp),%esi
801051ac:	53                   	push   %ebx
801051ad:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801051b0:	89 f2                	mov    %esi,%edx
801051b2:	eb 1b                	jmp    801051cf <strncpy+0x2f>
801051b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051b8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801051bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801051bf:	83 c2 01             	add    $0x1,%edx
801051c2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801051c6:	89 f9                	mov    %edi,%ecx
801051c8:	88 4a ff             	mov    %cl,-0x1(%edx)
801051cb:	84 c9                	test   %cl,%cl
801051cd:	74 09                	je     801051d8 <strncpy+0x38>
801051cf:	89 c3                	mov    %eax,%ebx
801051d1:	83 e8 01             	sub    $0x1,%eax
801051d4:	85 db                	test   %ebx,%ebx
801051d6:	7f e0                	jg     801051b8 <strncpy+0x18>
    ;
  while(n-- > 0)
801051d8:	89 d1                	mov    %edx,%ecx
801051da:	85 c0                	test   %eax,%eax
801051dc:	7e 15                	jle    801051f3 <strncpy+0x53>
801051de:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801051e0:	83 c1 01             	add    $0x1,%ecx
801051e3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801051e7:	89 c8                	mov    %ecx,%eax
801051e9:	f7 d0                	not    %eax
801051eb:	01 d0                	add    %edx,%eax
801051ed:	01 d8                	add    %ebx,%eax
801051ef:	85 c0                	test   %eax,%eax
801051f1:	7f ed                	jg     801051e0 <strncpy+0x40>
  return os;
}
801051f3:	5b                   	pop    %ebx
801051f4:	89 f0                	mov    %esi,%eax
801051f6:	5e                   	pop    %esi
801051f7:	5f                   	pop    %edi
801051f8:	5d                   	pop    %ebp
801051f9:	c3                   	ret    
801051fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105200 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
80105205:	89 e5                	mov    %esp,%ebp
80105207:	56                   	push   %esi
80105208:	8b 55 10             	mov    0x10(%ebp),%edx
8010520b:	8b 75 08             	mov    0x8(%ebp),%esi
8010520e:	53                   	push   %ebx
8010520f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105212:	85 d2                	test   %edx,%edx
80105214:	7e 21                	jle    80105237 <safestrcpy+0x37>
80105216:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010521a:	89 f2                	mov    %esi,%edx
8010521c:	eb 12                	jmp    80105230 <safestrcpy+0x30>
8010521e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105220:	0f b6 08             	movzbl (%eax),%ecx
80105223:	83 c0 01             	add    $0x1,%eax
80105226:	83 c2 01             	add    $0x1,%edx
80105229:	88 4a ff             	mov    %cl,-0x1(%edx)
8010522c:	84 c9                	test   %cl,%cl
8010522e:	74 04                	je     80105234 <safestrcpy+0x34>
80105230:	39 d8                	cmp    %ebx,%eax
80105232:	75 ec                	jne    80105220 <safestrcpy+0x20>
    ;
  *s = 0;
80105234:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105237:	89 f0                	mov    %esi,%eax
80105239:	5b                   	pop    %ebx
8010523a:	5e                   	pop    %esi
8010523b:	5d                   	pop    %ebp
8010523c:	c3                   	ret    
8010523d:	8d 76 00             	lea    0x0(%esi),%esi

80105240 <strlen>:

int
strlen(const char *s)
{
80105240:	f3 0f 1e fb          	endbr32 
80105244:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105245:	31 c0                	xor    %eax,%eax
{
80105247:	89 e5                	mov    %esp,%ebp
80105249:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010524c:	80 3a 00             	cmpb   $0x0,(%edx)
8010524f:	74 10                	je     80105261 <strlen+0x21>
80105251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105258:	83 c0 01             	add    $0x1,%eax
8010525b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010525f:	75 f7                	jne    80105258 <strlen+0x18>
    ;
  return n;
}
80105261:	5d                   	pop    %ebp
80105262:	c3                   	ret    

80105263 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105263:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105267:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010526b:	55                   	push   %ebp
  pushl %ebx
8010526c:	53                   	push   %ebx
  pushl %esi
8010526d:	56                   	push   %esi
  pushl %edi
8010526e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010526f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105271:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105273:	5f                   	pop    %edi
  popl %esi
80105274:	5e                   	pop    %esi
  popl %ebx
80105275:	5b                   	pop    %ebx
  popl %ebp
80105276:	5d                   	pop    %ebp
  ret
80105277:	c3                   	ret    
80105278:	66 90                	xchg   %ax,%ax
8010527a:	66 90                	xchg   %ax,%ax
8010527c:	66 90                	xchg   %ax,%ax
8010527e:	66 90                	xchg   %ax,%ax

80105280 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105280:	f3 0f 1e fb          	endbr32 
80105284:	55                   	push   %ebp
80105285:	89 e5                	mov    %esp,%ebp
80105287:	53                   	push   %ebx
80105288:	83 ec 04             	sub    $0x4,%esp
8010528b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010528e:	e8 6d ee ff ff       	call   80104100 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105293:	8b 00                	mov    (%eax),%eax
80105295:	39 d8                	cmp    %ebx,%eax
80105297:	76 17                	jbe    801052b0 <fetchint+0x30>
80105299:	8d 53 04             	lea    0x4(%ebx),%edx
8010529c:	39 d0                	cmp    %edx,%eax
8010529e:	72 10                	jb     801052b0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801052a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801052a3:	8b 13                	mov    (%ebx),%edx
801052a5:	89 10                	mov    %edx,(%eax)
  return 0;
801052a7:	31 c0                	xor    %eax,%eax
}
801052a9:	83 c4 04             	add    $0x4,%esp
801052ac:	5b                   	pop    %ebx
801052ad:	5d                   	pop    %ebp
801052ae:	c3                   	ret    
801052af:	90                   	nop
    return -1;
801052b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b5:	eb f2                	jmp    801052a9 <fetchint+0x29>
801052b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052be:	66 90                	xchg   %ax,%ax

801052c0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801052c0:	f3 0f 1e fb          	endbr32 
801052c4:	55                   	push   %ebp
801052c5:	89 e5                	mov    %esp,%ebp
801052c7:	53                   	push   %ebx
801052c8:	83 ec 04             	sub    $0x4,%esp
801052cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801052ce:	e8 2d ee ff ff       	call   80104100 <myproc>

  if(addr >= curproc->sz)
801052d3:	39 18                	cmp    %ebx,(%eax)
801052d5:	76 31                	jbe    80105308 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801052d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801052da:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801052dc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801052de:	39 d3                	cmp    %edx,%ebx
801052e0:	73 26                	jae    80105308 <fetchstr+0x48>
801052e2:	89 d8                	mov    %ebx,%eax
801052e4:	eb 11                	jmp    801052f7 <fetchstr+0x37>
801052e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ed:	8d 76 00             	lea    0x0(%esi),%esi
801052f0:	83 c0 01             	add    $0x1,%eax
801052f3:	39 c2                	cmp    %eax,%edx
801052f5:	76 11                	jbe    80105308 <fetchstr+0x48>
    if(*s == 0)
801052f7:	80 38 00             	cmpb   $0x0,(%eax)
801052fa:	75 f4                	jne    801052f0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801052fc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801052ff:	29 d8                	sub    %ebx,%eax
}
80105301:	5b                   	pop    %ebx
80105302:	5d                   	pop    %ebp
80105303:	c3                   	ret    
80105304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105308:	83 c4 04             	add    $0x4,%esp
    return -1;
8010530b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105310:	5b                   	pop    %ebx
80105311:	5d                   	pop    %ebp
80105312:	c3                   	ret    
80105313:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105320 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105320:	f3 0f 1e fb          	endbr32 
80105324:	55                   	push   %ebp
80105325:	89 e5                	mov    %esp,%ebp
80105327:	56                   	push   %esi
80105328:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105329:	e8 d2 ed ff ff       	call   80104100 <myproc>
8010532e:	8b 55 08             	mov    0x8(%ebp),%edx
80105331:	8b 40 18             	mov    0x18(%eax),%eax
80105334:	8b 40 44             	mov    0x44(%eax),%eax
80105337:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010533a:	e8 c1 ed ff ff       	call   80104100 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010533f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105342:	8b 00                	mov    (%eax),%eax
80105344:	39 c6                	cmp    %eax,%esi
80105346:	73 18                	jae    80105360 <argint+0x40>
80105348:	8d 53 08             	lea    0x8(%ebx),%edx
8010534b:	39 d0                	cmp    %edx,%eax
8010534d:	72 11                	jb     80105360 <argint+0x40>
  *ip = *(int*)(addr);
8010534f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105352:	8b 53 04             	mov    0x4(%ebx),%edx
80105355:	89 10                	mov    %edx,(%eax)
  return 0;
80105357:	31 c0                	xor    %eax,%eax
}
80105359:	5b                   	pop    %ebx
8010535a:	5e                   	pop    %esi
8010535b:	5d                   	pop    %ebp
8010535c:	c3                   	ret    
8010535d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105365:	eb f2                	jmp    80105359 <argint+0x39>
80105367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536e:	66 90                	xchg   %ax,%ax

80105370 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105370:	f3 0f 1e fb          	endbr32 
80105374:	55                   	push   %ebp
80105375:	89 e5                	mov    %esp,%ebp
80105377:	56                   	push   %esi
80105378:	53                   	push   %ebx
80105379:	83 ec 10             	sub    $0x10,%esp
8010537c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010537f:	e8 7c ed ff ff       	call   80104100 <myproc>
 
  if(argint(n, &i) < 0)
80105384:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105387:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105389:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010538c:	50                   	push   %eax
8010538d:	ff 75 08             	pushl  0x8(%ebp)
80105390:	e8 8b ff ff ff       	call   80105320 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105395:	83 c4 10             	add    $0x10,%esp
80105398:	85 c0                	test   %eax,%eax
8010539a:	78 24                	js     801053c0 <argptr+0x50>
8010539c:	85 db                	test   %ebx,%ebx
8010539e:	78 20                	js     801053c0 <argptr+0x50>
801053a0:	8b 16                	mov    (%esi),%edx
801053a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053a5:	39 c2                	cmp    %eax,%edx
801053a7:	76 17                	jbe    801053c0 <argptr+0x50>
801053a9:	01 c3                	add    %eax,%ebx
801053ab:	39 da                	cmp    %ebx,%edx
801053ad:	72 11                	jb     801053c0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801053af:	8b 55 0c             	mov    0xc(%ebp),%edx
801053b2:	89 02                	mov    %eax,(%edx)
  return 0;
801053b4:	31 c0                	xor    %eax,%eax
}
801053b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053b9:	5b                   	pop    %ebx
801053ba:	5e                   	pop    %esi
801053bb:	5d                   	pop    %ebp
801053bc:	c3                   	ret    
801053bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801053c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053c5:	eb ef                	jmp    801053b6 <argptr+0x46>
801053c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ce:	66 90                	xchg   %ax,%ax

801053d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801053d0:	f3 0f 1e fb          	endbr32 
801053d4:	55                   	push   %ebp
801053d5:	89 e5                	mov    %esp,%ebp
801053d7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801053da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053dd:	50                   	push   %eax
801053de:	ff 75 08             	pushl  0x8(%ebp)
801053e1:	e8 3a ff ff ff       	call   80105320 <argint>
801053e6:	83 c4 10             	add    $0x10,%esp
801053e9:	85 c0                	test   %eax,%eax
801053eb:	78 13                	js     80105400 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801053ed:	83 ec 08             	sub    $0x8,%esp
801053f0:	ff 75 0c             	pushl  0xc(%ebp)
801053f3:	ff 75 f4             	pushl  -0xc(%ebp)
801053f6:	e8 c5 fe ff ff       	call   801052c0 <fetchstr>
801053fb:	83 c4 10             	add    $0x10,%esp
}
801053fe:	c9                   	leave  
801053ff:	c3                   	ret    
80105400:	c9                   	leave  
    return -1;
80105401:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105406:	c3                   	ret    
80105407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010540e:	66 90                	xchg   %ax,%ax

80105410 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105410:	f3 0f 1e fb          	endbr32 
80105414:	55                   	push   %ebp
80105415:	89 e5                	mov    %esp,%ebp
80105417:	53                   	push   %ebx
80105418:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010541b:	e8 e0 ec ff ff       	call   80104100 <myproc>
80105420:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105422:	8b 40 18             	mov    0x18(%eax),%eax
80105425:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105428:	8d 50 ff             	lea    -0x1(%eax),%edx
8010542b:	83 fa 14             	cmp    $0x14,%edx
8010542e:	77 20                	ja     80105450 <syscall+0x40>
80105430:	8b 14 85 c0 88 10 80 	mov    -0x7fef7740(,%eax,4),%edx
80105437:	85 d2                	test   %edx,%edx
80105439:	74 15                	je     80105450 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010543b:	ff d2                	call   *%edx
8010543d:	89 c2                	mov    %eax,%edx
8010543f:	8b 43 18             	mov    0x18(%ebx),%eax
80105442:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105445:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105448:	c9                   	leave  
80105449:	c3                   	ret    
8010544a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105450:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105451:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105454:	50                   	push   %eax
80105455:	ff 73 10             	pushl  0x10(%ebx)
80105458:	68 8d 88 10 80       	push   $0x8010888d
8010545d:	e8 4e b2 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105462:	8b 43 18             	mov    0x18(%ebx),%eax
80105465:	83 c4 10             	add    $0x10,%esp
80105468:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010546f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105472:	c9                   	leave  
80105473:	c3                   	ret    
80105474:	66 90                	xchg   %ax,%ax
80105476:	66 90                	xchg   %ax,%ax
80105478:	66 90                	xchg   %ax,%ax
8010547a:	66 90                	xchg   %ax,%ax
8010547c:	66 90                	xchg   %ax,%ax
8010547e:	66 90                	xchg   %ax,%ax

80105480 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	56                   	push   %esi
80105484:	89 d6                	mov    %edx,%esi
80105486:	53                   	push   %ebx
80105487:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105489:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010548c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010548f:	50                   	push   %eax
80105490:	6a 00                	push   $0x0
80105492:	e8 89 fe ff ff       	call   80105320 <argint>
80105497:	83 c4 10             	add    $0x10,%esp
8010549a:	85 c0                	test   %eax,%eax
8010549c:	78 2a                	js     801054c8 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010549e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054a2:	77 24                	ja     801054c8 <argfd.constprop.0+0x48>
801054a4:	e8 57 ec ff ff       	call   80104100 <myproc>
801054a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054ac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801054b0:	85 c0                	test   %eax,%eax
801054b2:	74 14                	je     801054c8 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
801054b4:	85 db                	test   %ebx,%ebx
801054b6:	74 02                	je     801054ba <argfd.constprop.0+0x3a>
    *pfd = fd;
801054b8:	89 13                	mov    %edx,(%ebx)
  if(pf)
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
  return -1;
}

int
sys_dup(void)
{
801054d0:	f3 0f 1e fb          	endbr32 
801054d4:	55                   	push   %ebp
  struct file *f;
  int fd;

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
    return -1;
  if((fd=fdalloc(f)) < 0)
801054ea:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801054ed:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054ef:	e8 0c ec ff ff       	call   80104100 <myproc>
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
    return -1;
  filedup(f);
  return fd;
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
8010552a:	e8 f1 bc ff ff       	call   80101220 <filedup>
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

int
sys_read(void)
{
80105540:	f3 0f 1e fb          	endbr32 
80105544:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

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
80105561:	e8 ba fd ff ff       	call   80105320 <argint>
80105566:	83 c4 10             	add    $0x10,%esp
80105569:	85 c0                	test   %eax,%eax
8010556b:	78 33                	js     801055a0 <sys_read+0x60>
8010556d:	83 ec 04             	sub    $0x4,%esp
80105570:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105573:	ff 75 f0             	pushl  -0x10(%ebp)
80105576:	50                   	push   %eax
80105577:	6a 01                	push   $0x1
80105579:	e8 f2 fd ff ff       	call   80105370 <argptr>
8010557e:	83 c4 10             	add    $0x10,%esp
80105581:	85 c0                	test   %eax,%eax
80105583:	78 1b                	js     801055a0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105585:	83 ec 04             	sub    $0x4,%esp
80105588:	ff 75 f0             	pushl  -0x10(%ebp)
8010558b:	ff 75 f4             	pushl  -0xc(%ebp)
8010558e:	ff 75 ec             	pushl  -0x14(%ebp)
80105591:	e8 0a be ff ff       	call   801013a0 <fileread>
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

int
sys_write(void)
{
801055b0:	f3 0f 1e fb          	endbr32 
801055b4:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

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
801055d1:	e8 4a fd ff ff       	call   80105320 <argint>
801055d6:	83 c4 10             	add    $0x10,%esp
801055d9:	85 c0                	test   %eax,%eax
801055db:	78 33                	js     80105610 <sys_write+0x60>
801055dd:	83 ec 04             	sub    $0x4,%esp
801055e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055e3:	ff 75 f0             	pushl  -0x10(%ebp)
801055e6:	50                   	push   %eax
801055e7:	6a 01                	push   $0x1
801055e9:	e8 82 fd ff ff       	call   80105370 <argptr>
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	85 c0                	test   %eax,%eax
801055f3:	78 1b                	js     80105610 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801055f5:	83 ec 04             	sub    $0x4,%esp
801055f8:	ff 75 f0             	pushl  -0x10(%ebp)
801055fb:	ff 75 f4             	pushl  -0xc(%ebp)
801055fe:	ff 75 ec             	pushl  -0x14(%ebp)
80105601:	e8 3a be ff ff       	call   80101440 <filewrite>
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

int
sys_close(void)
{
80105620:	f3 0f 1e fb          	endbr32 
80105624:	55                   	push   %ebp
80105625:	89 e5                	mov    %esp,%ebp
80105627:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010562a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010562d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105630:	e8 4b fe ff ff       	call   80105480 <argfd.constprop.0>
80105635:	85 c0                	test   %eax,%eax
80105637:	78 27                	js     80105660 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105639:	e8 c2 ea ff ff       	call   80104100 <myproc>
8010563e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105641:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105644:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010564b:	00 
  fileclose(f);
8010564c:	ff 75 f4             	pushl  -0xc(%ebp)
8010564f:	e8 1c bc ff ff       	call   80101270 <fileclose>
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

int
sys_fstat(void)
{
80105670:	f3 0f 1e fb          	endbr32 
80105674:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

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
80105693:	e8 d8 fc ff ff       	call   80105370 <argptr>
80105698:	83 c4 10             	add    $0x10,%esp
8010569b:	85 c0                	test   %eax,%eax
8010569d:	78 19                	js     801056b8 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
8010569f:	83 ec 08             	sub    $0x8,%esp
801056a2:	ff 75 f4             	pushl  -0xc(%ebp)
801056a5:	ff 75 f0             	pushl  -0x10(%ebp)
801056a8:	e8 a3 bc ff ff       	call   80101350 <filestat>
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

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801056c0:	f3 0f 1e fb          	endbr32 
801056c4:	55                   	push   %ebp
801056c5:	89 e5                	mov    %esp,%ebp
801056c7:	57                   	push   %edi
801056c8:	56                   	push   %esi
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056c9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801056cc:	53                   	push   %ebx
801056cd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056d0:	50                   	push   %eax
801056d1:	6a 00                	push   $0x0
801056d3:	e8 f8 fc ff ff       	call   801053d0 <argstr>
801056d8:	83 c4 10             	add    $0x10,%esp
801056db:	85 c0                	test   %eax,%eax
801056dd:	0f 88 ff 00 00 00    	js     801057e2 <sys_link+0x122>
801056e3:	83 ec 08             	sub    $0x8,%esp
801056e6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801056e9:	50                   	push   %eax
801056ea:	6a 01                	push   $0x1
801056ec:	e8 df fc ff ff       	call   801053d0 <argstr>
801056f1:	83 c4 10             	add    $0x10,%esp
801056f4:	85 c0                	test   %eax,%eax
801056f6:	0f 88 e6 00 00 00    	js     801057e2 <sys_link+0x122>
    return -1;

  begin_op();
801056fc:	e8 5f dd ff ff       	call   80103460 <begin_op>
  if((ip = namei(old)) == 0){
80105701:	83 ec 0c             	sub    $0xc,%esp
80105704:	ff 75 d4             	pushl  -0x2c(%ebp)
80105707:	e8 d4 cc ff ff       	call   801023e0 <namei>
8010570c:	83 c4 10             	add    $0x10,%esp
8010570f:	89 c3                	mov    %eax,%ebx
80105711:	85 c0                	test   %eax,%eax
80105713:	0f 84 e8 00 00 00    	je     80105801 <sys_link+0x141>
    end_op();
    return -1;
  }

  ilock(ip);
80105719:	83 ec 0c             	sub    $0xc,%esp
8010571c:	50                   	push   %eax
8010571d:	e8 ee c3 ff ff       	call   80101b10 <ilock>
  if(ip->type == T_DIR){
80105722:	83 c4 10             	add    $0x10,%esp
80105725:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010572a:	0f 84 b9 00 00 00    	je     801057e9 <sys_link+0x129>
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105730:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105733:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105738:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010573b:	53                   	push   %ebx
8010573c:	e8 0f c3 ff ff       	call   80101a50 <iupdate>
  iunlock(ip);
80105741:	89 1c 24             	mov    %ebx,(%esp)
80105744:	e8 a7 c4 ff ff       	call   80101bf0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105749:	58                   	pop    %eax
8010574a:	5a                   	pop    %edx
8010574b:	57                   	push   %edi
8010574c:	ff 75 d0             	pushl  -0x30(%ebp)
8010574f:	e8 ac cc ff ff       	call   80102400 <nameiparent>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	89 c6                	mov    %eax,%esi
80105759:	85 c0                	test   %eax,%eax
8010575b:	74 5f                	je     801057bc <sys_link+0xfc>
    goto bad;
  ilock(dp);
8010575d:	83 ec 0c             	sub    $0xc,%esp
80105760:	50                   	push   %eax
80105761:	e8 aa c3 ff ff       	call   80101b10 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105766:	8b 03                	mov    (%ebx),%eax
80105768:	83 c4 10             	add    $0x10,%esp
8010576b:	39 06                	cmp    %eax,(%esi)
8010576d:	75 41                	jne    801057b0 <sys_link+0xf0>
8010576f:	83 ec 04             	sub    $0x4,%esp
80105772:	ff 73 04             	pushl  0x4(%ebx)
80105775:	57                   	push   %edi
80105776:	56                   	push   %esi
80105777:	e8 a4 cb ff ff       	call   80102320 <dirlink>
8010577c:	83 c4 10             	add    $0x10,%esp
8010577f:	85 c0                	test   %eax,%eax
80105781:	78 2d                	js     801057b0 <sys_link+0xf0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105783:	83 ec 0c             	sub    $0xc,%esp
80105786:	56                   	push   %esi
80105787:	e8 24 c6 ff ff       	call   80101db0 <iunlockput>
  iput(ip);
8010578c:	89 1c 24             	mov    %ebx,(%esp)
8010578f:	e8 ac c4 ff ff       	call   80101c40 <iput>

  end_op();
80105794:	e8 37 dd ff ff       	call   801034d0 <end_op>

  return 0;
80105799:	83 c4 10             	add    $0x10,%esp
8010579c:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
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
801057b4:	e8 f7 c5 ff ff       	call   80101db0 <iunlockput>
    goto bad;
801057b9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801057bc:	83 ec 0c             	sub    $0xc,%esp
801057bf:	53                   	push   %ebx
801057c0:	e8 4b c3 ff ff       	call   80101b10 <ilock>
  ip->nlink--;
801057c5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057ca:	89 1c 24             	mov    %ebx,(%esp)
801057cd:	e8 7e c2 ff ff       	call   80101a50 <iupdate>
  iunlockput(ip);
801057d2:	89 1c 24             	mov    %ebx,(%esp)
801057d5:	e8 d6 c5 ff ff       	call   80101db0 <iunlockput>
  end_op();
801057da:	e8 f1 dc ff ff       	call   801034d0 <end_op>
  return -1;
801057df:	83 c4 10             	add    $0x10,%esp
801057e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e7:	eb b5                	jmp    8010579e <sys_link+0xde>
    iunlockput(ip);
801057e9:	83 ec 0c             	sub    $0xc,%esp
801057ec:	53                   	push   %ebx
801057ed:	e8 be c5 ff ff       	call   80101db0 <iunlockput>
    end_op();
801057f2:	e8 d9 dc ff ff       	call   801034d0 <end_op>
    return -1;
801057f7:	83 c4 10             	add    $0x10,%esp
801057fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ff:	eb 9d                	jmp    8010579e <sys_link+0xde>
    end_op();
80105801:	e8 ca dc ff ff       	call   801034d0 <end_op>
    return -1;
80105806:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580b:	eb 91                	jmp    8010579e <sys_link+0xde>
8010580d:	8d 76 00             	lea    0x0(%esi),%esi

80105810 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105810:	f3 0f 1e fb          	endbr32 
80105814:	55                   	push   %ebp
80105815:	89 e5                	mov    %esp,%ebp
80105817:	57                   	push   %edi
80105818:	56                   	push   %esi
80105819:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010581c:	53                   	push   %ebx
8010581d:	bb 20 00 00 00       	mov    $0x20,%ebx
80105822:	83 ec 1c             	sub    $0x1c,%esp
80105825:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105828:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
8010582c:	77 0a                	ja     80105838 <isdirempty+0x28>
8010582e:	eb 30                	jmp    80105860 <isdirempty+0x50>
80105830:	83 c3 10             	add    $0x10,%ebx
80105833:	39 5e 58             	cmp    %ebx,0x58(%esi)
80105836:	76 28                	jbe    80105860 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105838:	6a 10                	push   $0x10
8010583a:	53                   	push   %ebx
8010583b:	57                   	push   %edi
8010583c:	56                   	push   %esi
8010583d:	e8 ce c5 ff ff       	call   80101e10 <readi>
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	83 f8 10             	cmp    $0x10,%eax
80105848:	75 23                	jne    8010586d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010584a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010584f:	74 df                	je     80105830 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105851:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105854:	31 c0                	xor    %eax,%eax
}
80105856:	5b                   	pop    %ebx
80105857:	5e                   	pop    %esi
80105858:	5f                   	pop    %edi
80105859:	5d                   	pop    %ebp
8010585a:	c3                   	ret    
8010585b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010585f:	90                   	nop
80105860:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105863:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105868:	5b                   	pop    %ebx
80105869:	5e                   	pop    %esi
8010586a:	5f                   	pop    %edi
8010586b:	5d                   	pop    %ebp
8010586c:	c3                   	ret    
      panic("isdirempty: readi");
8010586d:	83 ec 0c             	sub    $0xc,%esp
80105870:	68 18 89 10 80       	push   $0x80108918
80105875:	e8 16 ab ff ff       	call   80100390 <panic>
8010587a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105880 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105880:	f3 0f 1e fb          	endbr32 
80105884:	55                   	push   %ebp
80105885:	89 e5                	mov    %esp,%ebp
80105887:	57                   	push   %edi
80105888:	56                   	push   %esi
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105889:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010588c:	53                   	push   %ebx
8010588d:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105890:	50                   	push   %eax
80105891:	6a 00                	push   $0x0
80105893:	e8 38 fb ff ff       	call   801053d0 <argstr>
80105898:	83 c4 10             	add    $0x10,%esp
8010589b:	85 c0                	test   %eax,%eax
8010589d:	0f 88 5d 01 00 00    	js     80105a00 <sys_unlink+0x180>
    return -1;

  begin_op();
801058a3:	e8 b8 db ff ff       	call   80103460 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801058a8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801058ab:	83 ec 08             	sub    $0x8,%esp
801058ae:	53                   	push   %ebx
801058af:	ff 75 c0             	pushl  -0x40(%ebp)
801058b2:	e8 49 cb ff ff       	call   80102400 <nameiparent>
801058b7:	83 c4 10             	add    $0x10,%esp
801058ba:	89 c6                	mov    %eax,%esi
801058bc:	85 c0                	test   %eax,%eax
801058be:	0f 84 43 01 00 00    	je     80105a07 <sys_unlink+0x187>
    end_op();
    return -1;
  }

  ilock(dp);
801058c4:	83 ec 0c             	sub    $0xc,%esp
801058c7:	50                   	push   %eax
801058c8:	e8 43 c2 ff ff       	call   80101b10 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801058cd:	58                   	pop    %eax
801058ce:	5a                   	pop    %edx
801058cf:	68 1c 83 10 80       	push   $0x8010831c
801058d4:	53                   	push   %ebx
801058d5:	e8 66 c7 ff ff       	call   80102040 <namecmp>
801058da:	83 c4 10             	add    $0x10,%esp
801058dd:	85 c0                	test   %eax,%eax
801058df:	0f 84 db 00 00 00    	je     801059c0 <sys_unlink+0x140>
801058e5:	83 ec 08             	sub    $0x8,%esp
801058e8:	68 1b 83 10 80       	push   $0x8010831b
801058ed:	53                   	push   %ebx
801058ee:	e8 4d c7 ff ff       	call   80102040 <namecmp>
801058f3:	83 c4 10             	add    $0x10,%esp
801058f6:	85 c0                	test   %eax,%eax
801058f8:	0f 84 c2 00 00 00    	je     801059c0 <sys_unlink+0x140>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801058fe:	83 ec 04             	sub    $0x4,%esp
80105901:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105904:	50                   	push   %eax
80105905:	53                   	push   %ebx
80105906:	56                   	push   %esi
80105907:	e8 54 c7 ff ff       	call   80102060 <dirlookup>
8010590c:	83 c4 10             	add    $0x10,%esp
8010590f:	89 c3                	mov    %eax,%ebx
80105911:	85 c0                	test   %eax,%eax
80105913:	0f 84 a7 00 00 00    	je     801059c0 <sys_unlink+0x140>
    goto bad;
  ilock(ip);
80105919:	83 ec 0c             	sub    $0xc,%esp
8010591c:	50                   	push   %eax
8010591d:	e8 ee c1 ff ff       	call   80101b10 <ilock>

  if(ip->nlink < 1)
80105922:	83 c4 10             	add    $0x10,%esp
80105925:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010592a:	0f 8e f3 00 00 00    	jle    80105a23 <sys_unlink+0x1a3>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105930:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105935:	74 69                	je     801059a0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105937:	83 ec 04             	sub    $0x4,%esp
8010593a:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010593d:	6a 10                	push   $0x10
8010593f:	6a 00                	push   $0x0
80105941:	57                   	push   %edi
80105942:	e8 f9 f6 ff ff       	call   80105040 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105947:	6a 10                	push   $0x10
80105949:	ff 75 c4             	pushl  -0x3c(%ebp)
8010594c:	57                   	push   %edi
8010594d:	56                   	push   %esi
8010594e:	e8 bd c5 ff ff       	call   80101f10 <writei>
80105953:	83 c4 20             	add    $0x20,%esp
80105956:	83 f8 10             	cmp    $0x10,%eax
80105959:	0f 85 b7 00 00 00    	jne    80105a16 <sys_unlink+0x196>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010595f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105964:	74 7a                	je     801059e0 <sys_unlink+0x160>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105966:	83 ec 0c             	sub    $0xc,%esp
80105969:	56                   	push   %esi
8010596a:	e8 41 c4 ff ff       	call   80101db0 <iunlockput>

  ip->nlink--;
8010596f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105974:	89 1c 24             	mov    %ebx,(%esp)
80105977:	e8 d4 c0 ff ff       	call   80101a50 <iupdate>
  iunlockput(ip);
8010597c:	89 1c 24             	mov    %ebx,(%esp)
8010597f:	e8 2c c4 ff ff       	call   80101db0 <iunlockput>

  end_op();
80105984:	e8 47 db ff ff       	call   801034d0 <end_op>

  return 0;
80105989:	83 c4 10             	add    $0x10,%esp
8010598c:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010598e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105991:	5b                   	pop    %ebx
80105992:	5e                   	pop    %esi
80105993:	5f                   	pop    %edi
80105994:	5d                   	pop    %ebp
80105995:	c3                   	ret    
80105996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599d:	8d 76 00             	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
801059a0:	83 ec 0c             	sub    $0xc,%esp
801059a3:	53                   	push   %ebx
801059a4:	e8 67 fe ff ff       	call   80105810 <isdirempty>
801059a9:	83 c4 10             	add    $0x10,%esp
801059ac:	85 c0                	test   %eax,%eax
801059ae:	75 87                	jne    80105937 <sys_unlink+0xb7>
    iunlockput(ip);
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	53                   	push   %ebx
801059b4:	e8 f7 c3 ff ff       	call   80101db0 <iunlockput>
    goto bad;
801059b9:	83 c4 10             	add    $0x10,%esp
801059bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801059c0:	83 ec 0c             	sub    $0xc,%esp
801059c3:	56                   	push   %esi
801059c4:	e8 e7 c3 ff ff       	call   80101db0 <iunlockput>
  end_op();
801059c9:	e8 02 db ff ff       	call   801034d0 <end_op>
  return -1;
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059d6:	eb b6                	jmp    8010598e <sys_unlink+0x10e>
801059d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059df:	90                   	nop
    iupdate(dp);
801059e0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801059e3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801059e8:	56                   	push   %esi
801059e9:	e8 62 c0 ff ff       	call   80101a50 <iupdate>
801059ee:	83 c4 10             	add    $0x10,%esp
801059f1:	e9 70 ff ff ff       	jmp    80105966 <sys_unlink+0xe6>
801059f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a05:	eb 87                	jmp    8010598e <sys_unlink+0x10e>
    end_op();
80105a07:	e8 c4 da ff ff       	call   801034d0 <end_op>
    return -1;
80105a0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a11:	e9 78 ff ff ff       	jmp    8010598e <sys_unlink+0x10e>
    panic("unlink: writei");
80105a16:	83 ec 0c             	sub    $0xc,%esp
80105a19:	68 30 83 10 80       	push   $0x80108330
80105a1e:	e8 6d a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105a23:	83 ec 0c             	sub    $0xc,%esp
80105a26:	68 1e 83 10 80       	push   $0x8010831e
80105a2b:	e8 60 a9 ff ff       	call   80100390 <panic>

80105a30 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105a30:	f3 0f 1e fb          	endbr32 
80105a34:	55                   	push   %ebp
80105a35:	89 e5                	mov    %esp,%ebp
80105a37:	57                   	push   %edi
80105a38:	56                   	push   %esi
80105a39:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105a3a:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80105a3d:	83 ec 34             	sub    $0x34,%esp
80105a40:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a43:	8b 55 10             	mov    0x10(%ebp),%edx
  if((dp = nameiparent(path, name)) == 0)
80105a46:	53                   	push   %ebx
{
80105a47:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105a4a:	ff 75 08             	pushl  0x8(%ebp)
{
80105a4d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105a50:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105a53:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105a56:	e8 a5 c9 ff ff       	call   80102400 <nameiparent>
80105a5b:	83 c4 10             	add    $0x10,%esp
80105a5e:	85 c0                	test   %eax,%eax
80105a60:	0f 84 3a 01 00 00    	je     80105ba0 <create+0x170>
    return 0;
  ilock(dp);
80105a66:	83 ec 0c             	sub    $0xc,%esp
80105a69:	89 c6                	mov    %eax,%esi
80105a6b:	50                   	push   %eax
80105a6c:	e8 9f c0 ff ff       	call   80101b10 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105a71:	83 c4 0c             	add    $0xc,%esp
80105a74:	6a 00                	push   $0x0
80105a76:	53                   	push   %ebx
80105a77:	56                   	push   %esi
80105a78:	e8 e3 c5 ff ff       	call   80102060 <dirlookup>
80105a7d:	83 c4 10             	add    $0x10,%esp
80105a80:	89 c7                	mov    %eax,%edi
80105a82:	85 c0                	test   %eax,%eax
80105a84:	74 4a                	je     80105ad0 <create+0xa0>
    iunlockput(dp);
80105a86:	83 ec 0c             	sub    $0xc,%esp
80105a89:	56                   	push   %esi
80105a8a:	e8 21 c3 ff ff       	call   80101db0 <iunlockput>
    ilock(ip);
80105a8f:	89 3c 24             	mov    %edi,(%esp)
80105a92:	e8 79 c0 ff ff       	call   80101b10 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105a97:	83 c4 10             	add    $0x10,%esp
80105a9a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105a9f:	75 17                	jne    80105ab8 <create+0x88>
80105aa1:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105aa6:	75 10                	jne    80105ab8 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105aa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aab:	89 f8                	mov    %edi,%eax
80105aad:	5b                   	pop    %ebx
80105aae:	5e                   	pop    %esi
80105aaf:	5f                   	pop    %edi
80105ab0:	5d                   	pop    %ebp
80105ab1:	c3                   	ret    
80105ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105ab8:	83 ec 0c             	sub    $0xc,%esp
80105abb:	57                   	push   %edi
    return 0;
80105abc:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105abe:	e8 ed c2 ff ff       	call   80101db0 <iunlockput>
    return 0;
80105ac3:	83 c4 10             	add    $0x10,%esp
}
80105ac6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ac9:	89 f8                	mov    %edi,%eax
80105acb:	5b                   	pop    %ebx
80105acc:	5e                   	pop    %esi
80105acd:	5f                   	pop    %edi
80105ace:	5d                   	pop    %ebp
80105acf:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105ad0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105ad4:	83 ec 08             	sub    $0x8,%esp
80105ad7:	50                   	push   %eax
80105ad8:	ff 36                	pushl  (%esi)
80105ada:	e8 b1 be ff ff       	call   80101990 <ialloc>
80105adf:	83 c4 10             	add    $0x10,%esp
80105ae2:	89 c7                	mov    %eax,%edi
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	0f 84 cd 00 00 00    	je     80105bb9 <create+0x189>
  ilock(ip);
80105aec:	83 ec 0c             	sub    $0xc,%esp
80105aef:	50                   	push   %eax
80105af0:	e8 1b c0 ff ff       	call   80101b10 <ilock>
  ip->major = major;
80105af5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105af9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105afd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105b01:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105b05:	b8 01 00 00 00       	mov    $0x1,%eax
80105b0a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105b0e:	89 3c 24             	mov    %edi,(%esp)
80105b11:	e8 3a bf ff ff       	call   80101a50 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105b16:	83 c4 10             	add    $0x10,%esp
80105b19:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105b1e:	74 30                	je     80105b50 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105b20:	83 ec 04             	sub    $0x4,%esp
80105b23:	ff 77 04             	pushl  0x4(%edi)
80105b26:	53                   	push   %ebx
80105b27:	56                   	push   %esi
80105b28:	e8 f3 c7 ff ff       	call   80102320 <dirlink>
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	85 c0                	test   %eax,%eax
80105b32:	78 78                	js     80105bac <create+0x17c>
  iunlockput(dp);
80105b34:	83 ec 0c             	sub    $0xc,%esp
80105b37:	56                   	push   %esi
80105b38:	e8 73 c2 ff ff       	call   80101db0 <iunlockput>
  return ip;
80105b3d:	83 c4 10             	add    $0x10,%esp
}
80105b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b43:	89 f8                	mov    %edi,%eax
80105b45:	5b                   	pop    %ebx
80105b46:	5e                   	pop    %esi
80105b47:	5f                   	pop    %edi
80105b48:	5d                   	pop    %ebp
80105b49:	c3                   	ret    
80105b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105b50:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105b53:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80105b58:	56                   	push   %esi
80105b59:	e8 f2 be ff ff       	call   80101a50 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105b5e:	83 c4 0c             	add    $0xc,%esp
80105b61:	ff 77 04             	pushl  0x4(%edi)
80105b64:	68 1c 83 10 80       	push   $0x8010831c
80105b69:	57                   	push   %edi
80105b6a:	e8 b1 c7 ff ff       	call   80102320 <dirlink>
80105b6f:	83 c4 10             	add    $0x10,%esp
80105b72:	85 c0                	test   %eax,%eax
80105b74:	78 18                	js     80105b8e <create+0x15e>
80105b76:	83 ec 04             	sub    $0x4,%esp
80105b79:	ff 76 04             	pushl  0x4(%esi)
80105b7c:	68 1b 83 10 80       	push   $0x8010831b
80105b81:	57                   	push   %edi
80105b82:	e8 99 c7 ff ff       	call   80102320 <dirlink>
80105b87:	83 c4 10             	add    $0x10,%esp
80105b8a:	85 c0                	test   %eax,%eax
80105b8c:	79 92                	jns    80105b20 <create+0xf0>
      panic("create dots");
80105b8e:	83 ec 0c             	sub    $0xc,%esp
80105b91:	68 39 89 10 80       	push   $0x80108939
80105b96:	e8 f5 a7 ff ff       	call   80100390 <panic>
80105b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b9f:	90                   	nop
}
80105ba0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105ba3:	31 ff                	xor    %edi,%edi
}
80105ba5:	5b                   	pop    %ebx
80105ba6:	89 f8                	mov    %edi,%eax
80105ba8:	5e                   	pop    %esi
80105ba9:	5f                   	pop    %edi
80105baa:	5d                   	pop    %ebp
80105bab:	c3                   	ret    
    panic("create: dirlink");
80105bac:	83 ec 0c             	sub    $0xc,%esp
80105baf:	68 45 89 10 80       	push   $0x80108945
80105bb4:	e8 d7 a7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105bb9:	83 ec 0c             	sub    $0xc,%esp
80105bbc:	68 2a 89 10 80       	push   $0x8010892a
80105bc1:	e8 ca a7 ff ff       	call   80100390 <panic>
80105bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bcd:	8d 76 00             	lea    0x0(%esi),%esi

80105bd0 <sys_open>:

int
sys_open(void)
{
80105bd0:	f3 0f 1e fb          	endbr32 
80105bd4:	55                   	push   %ebp
80105bd5:	89 e5                	mov    %esp,%ebp
80105bd7:	57                   	push   %edi
80105bd8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105bd9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105bdc:	53                   	push   %ebx
80105bdd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105be0:	50                   	push   %eax
80105be1:	6a 00                	push   $0x0
80105be3:	e8 e8 f7 ff ff       	call   801053d0 <argstr>
80105be8:	83 c4 10             	add    $0x10,%esp
80105beb:	85 c0                	test   %eax,%eax
80105bed:	0f 88 8a 00 00 00    	js     80105c7d <sys_open+0xad>
80105bf3:	83 ec 08             	sub    $0x8,%esp
80105bf6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bf9:	50                   	push   %eax
80105bfa:	6a 01                	push   $0x1
80105bfc:	e8 1f f7 ff ff       	call   80105320 <argint>
80105c01:	83 c4 10             	add    $0x10,%esp
80105c04:	85 c0                	test   %eax,%eax
80105c06:	78 75                	js     80105c7d <sys_open+0xad>
    return -1;

  begin_op();
80105c08:	e8 53 d8 ff ff       	call   80103460 <begin_op>

  if(omode & O_CREATE){
80105c0d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105c11:	75 75                	jne    80105c88 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105c13:	83 ec 0c             	sub    $0xc,%esp
80105c16:	ff 75 e0             	pushl  -0x20(%ebp)
80105c19:	e8 c2 c7 ff ff       	call   801023e0 <namei>
80105c1e:	83 c4 10             	add    $0x10,%esp
80105c21:	89 c6                	mov    %eax,%esi
80105c23:	85 c0                	test   %eax,%eax
80105c25:	74 78                	je     80105c9f <sys_open+0xcf>
      end_op();
      return -1;
    }
    ilock(ip);
80105c27:	83 ec 0c             	sub    $0xc,%esp
80105c2a:	50                   	push   %eax
80105c2b:	e8 e0 be ff ff       	call   80101b10 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c30:	83 c4 10             	add    $0x10,%esp
80105c33:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105c38:	0f 84 ba 00 00 00    	je     80105cf8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105c3e:	e8 6d b5 ff ff       	call   801011b0 <filealloc>
80105c43:	89 c7                	mov    %eax,%edi
80105c45:	85 c0                	test   %eax,%eax
80105c47:	74 23                	je     80105c6c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105c49:	e8 b2 e4 ff ff       	call   80104100 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c4e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105c50:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105c54:	85 d2                	test   %edx,%edx
80105c56:	74 58                	je     80105cb0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105c58:	83 c3 01             	add    $0x1,%ebx
80105c5b:	83 fb 10             	cmp    $0x10,%ebx
80105c5e:	75 f0                	jne    80105c50 <sys_open+0x80>
    if(f)
      fileclose(f);
80105c60:	83 ec 0c             	sub    $0xc,%esp
80105c63:	57                   	push   %edi
80105c64:	e8 07 b6 ff ff       	call   80101270 <fileclose>
80105c69:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105c6c:	83 ec 0c             	sub    $0xc,%esp
80105c6f:	56                   	push   %esi
80105c70:	e8 3b c1 ff ff       	call   80101db0 <iunlockput>
    end_op();
80105c75:	e8 56 d8 ff ff       	call   801034d0 <end_op>
    return -1;
80105c7a:	83 c4 10             	add    $0x10,%esp
80105c7d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c82:	eb 65                	jmp    80105ce9 <sys_open+0x119>
80105c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105c88:	6a 00                	push   $0x0
80105c8a:	6a 00                	push   $0x0
80105c8c:	6a 02                	push   $0x2
80105c8e:	ff 75 e0             	pushl  -0x20(%ebp)
80105c91:	e8 9a fd ff ff       	call   80105a30 <create>
    if(ip == 0){
80105c96:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105c99:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105c9b:	85 c0                	test   %eax,%eax
80105c9d:	75 9f                	jne    80105c3e <sys_open+0x6e>
      end_op();
80105c9f:	e8 2c d8 ff ff       	call   801034d0 <end_op>
      return -1;
80105ca4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ca9:	eb 3e                	jmp    80105ce9 <sys_open+0x119>
80105cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105caf:	90                   	nop
  }
  iunlock(ip);
80105cb0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105cb3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105cb7:	56                   	push   %esi
80105cb8:	e8 33 bf ff ff       	call   80101bf0 <iunlock>
  end_op();
80105cbd:	e8 0e d8 ff ff       	call   801034d0 <end_op>

  f->type = FD_INODE;
80105cc2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105cc8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ccb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105cce:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105cd1:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105cd3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105cda:	f7 d0                	not    %eax
80105cdc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105cdf:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105ce2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ce5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cec:	89 d8                	mov    %ebx,%eax
80105cee:	5b                   	pop    %ebx
80105cef:	5e                   	pop    %esi
80105cf0:	5f                   	pop    %edi
80105cf1:	5d                   	pop    %ebp
80105cf2:	c3                   	ret    
80105cf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cf7:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105cf8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105cfb:	85 c9                	test   %ecx,%ecx
80105cfd:	0f 84 3b ff ff ff    	je     80105c3e <sys_open+0x6e>
80105d03:	e9 64 ff ff ff       	jmp    80105c6c <sys_open+0x9c>
80105d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0f:	90                   	nop

80105d10 <sys_mkdir>:

int
sys_mkdir(void)
{
80105d10:	f3 0f 1e fb          	endbr32 
80105d14:	55                   	push   %ebp
80105d15:	89 e5                	mov    %esp,%ebp
80105d17:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105d1a:	e8 41 d7 ff ff       	call   80103460 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105d1f:	83 ec 08             	sub    $0x8,%esp
80105d22:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d25:	50                   	push   %eax
80105d26:	6a 00                	push   $0x0
80105d28:	e8 a3 f6 ff ff       	call   801053d0 <argstr>
80105d2d:	83 c4 10             	add    $0x10,%esp
80105d30:	85 c0                	test   %eax,%eax
80105d32:	78 2c                	js     80105d60 <sys_mkdir+0x50>
80105d34:	6a 00                	push   $0x0
80105d36:	6a 00                	push   $0x0
80105d38:	6a 01                	push   $0x1
80105d3a:	ff 75 f4             	pushl  -0xc(%ebp)
80105d3d:	e8 ee fc ff ff       	call   80105a30 <create>
80105d42:	83 c4 10             	add    $0x10,%esp
80105d45:	85 c0                	test   %eax,%eax
80105d47:	74 17                	je     80105d60 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d49:	83 ec 0c             	sub    $0xc,%esp
80105d4c:	50                   	push   %eax
80105d4d:	e8 5e c0 ff ff       	call   80101db0 <iunlockput>
  end_op();
80105d52:	e8 79 d7 ff ff       	call   801034d0 <end_op>
  return 0;
80105d57:	83 c4 10             	add    $0x10,%esp
80105d5a:	31 c0                	xor    %eax,%eax
}
80105d5c:	c9                   	leave  
80105d5d:	c3                   	ret    
80105d5e:	66 90                	xchg   %ax,%ax
    end_op();
80105d60:	e8 6b d7 ff ff       	call   801034d0 <end_op>
    return -1;
80105d65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d6a:	c9                   	leave  
80105d6b:	c3                   	ret    
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_mknod>:

int
sys_mknod(void)
{
80105d70:	f3 0f 1e fb          	endbr32 
80105d74:	55                   	push   %ebp
80105d75:	89 e5                	mov    %esp,%ebp
80105d77:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105d7a:	e8 e1 d6 ff ff       	call   80103460 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105d7f:	83 ec 08             	sub    $0x8,%esp
80105d82:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d85:	50                   	push   %eax
80105d86:	6a 00                	push   $0x0
80105d88:	e8 43 f6 ff ff       	call   801053d0 <argstr>
80105d8d:	83 c4 10             	add    $0x10,%esp
80105d90:	85 c0                	test   %eax,%eax
80105d92:	78 5c                	js     80105df0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105d94:	83 ec 08             	sub    $0x8,%esp
80105d97:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d9a:	50                   	push   %eax
80105d9b:	6a 01                	push   $0x1
80105d9d:	e8 7e f5 ff ff       	call   80105320 <argint>
  if((argstr(0, &path)) < 0 ||
80105da2:	83 c4 10             	add    $0x10,%esp
80105da5:	85 c0                	test   %eax,%eax
80105da7:	78 47                	js     80105df0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105da9:	83 ec 08             	sub    $0x8,%esp
80105dac:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105daf:	50                   	push   %eax
80105db0:	6a 02                	push   $0x2
80105db2:	e8 69 f5 ff ff       	call   80105320 <argint>
     argint(1, &major) < 0 ||
80105db7:	83 c4 10             	add    $0x10,%esp
80105dba:	85 c0                	test   %eax,%eax
80105dbc:	78 32                	js     80105df0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105dbe:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105dc2:	50                   	push   %eax
80105dc3:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80105dc7:	50                   	push   %eax
80105dc8:	6a 03                	push   $0x3
80105dca:	ff 75 ec             	pushl  -0x14(%ebp)
80105dcd:	e8 5e fc ff ff       	call   80105a30 <create>
     argint(2, &minor) < 0 ||
80105dd2:	83 c4 10             	add    $0x10,%esp
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	74 17                	je     80105df0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105dd9:	83 ec 0c             	sub    $0xc,%esp
80105ddc:	50                   	push   %eax
80105ddd:	e8 ce bf ff ff       	call   80101db0 <iunlockput>
  end_op();
80105de2:	e8 e9 d6 ff ff       	call   801034d0 <end_op>
  return 0;
80105de7:	83 c4 10             	add    $0x10,%esp
80105dea:	31 c0                	xor    %eax,%eax
}
80105dec:	c9                   	leave  
80105ded:	c3                   	ret    
80105dee:	66 90                	xchg   %ax,%ax
    end_op();
80105df0:	e8 db d6 ff ff       	call   801034d0 <end_op>
    return -1;
80105df5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dfa:	c9                   	leave  
80105dfb:	c3                   	ret    
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e00 <sys_chdir>:

int
sys_chdir(void)
{
80105e00:	f3 0f 1e fb          	endbr32 
80105e04:	55                   	push   %ebp
80105e05:	89 e5                	mov    %esp,%ebp
80105e07:	56                   	push   %esi
80105e08:	53                   	push   %ebx
80105e09:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105e0c:	e8 ef e2 ff ff       	call   80104100 <myproc>
80105e11:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105e13:	e8 48 d6 ff ff       	call   80103460 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105e18:	83 ec 08             	sub    $0x8,%esp
80105e1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e1e:	50                   	push   %eax
80105e1f:	6a 00                	push   $0x0
80105e21:	e8 aa f5 ff ff       	call   801053d0 <argstr>
80105e26:	83 c4 10             	add    $0x10,%esp
80105e29:	85 c0                	test   %eax,%eax
80105e2b:	78 73                	js     80105ea0 <sys_chdir+0xa0>
80105e2d:	83 ec 0c             	sub    $0xc,%esp
80105e30:	ff 75 f4             	pushl  -0xc(%ebp)
80105e33:	e8 a8 c5 ff ff       	call   801023e0 <namei>
80105e38:	83 c4 10             	add    $0x10,%esp
80105e3b:	89 c3                	mov    %eax,%ebx
80105e3d:	85 c0                	test   %eax,%eax
80105e3f:	74 5f                	je     80105ea0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105e41:	83 ec 0c             	sub    $0xc,%esp
80105e44:	50                   	push   %eax
80105e45:	e8 c6 bc ff ff       	call   80101b10 <ilock>
  if(ip->type != T_DIR){
80105e4a:	83 c4 10             	add    $0x10,%esp
80105e4d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e52:	75 2c                	jne    80105e80 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105e54:	83 ec 0c             	sub    $0xc,%esp
80105e57:	53                   	push   %ebx
80105e58:	e8 93 bd ff ff       	call   80101bf0 <iunlock>
  iput(curproc->cwd);
80105e5d:	58                   	pop    %eax
80105e5e:	ff 76 68             	pushl  0x68(%esi)
80105e61:	e8 da bd ff ff       	call   80101c40 <iput>
  end_op();
80105e66:	e8 65 d6 ff ff       	call   801034d0 <end_op>
  curproc->cwd = ip;
80105e6b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105e6e:	83 c4 10             	add    $0x10,%esp
80105e71:	31 c0                	xor    %eax,%eax
}
80105e73:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e76:	5b                   	pop    %ebx
80105e77:	5e                   	pop    %esi
80105e78:	5d                   	pop    %ebp
80105e79:	c3                   	ret    
80105e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105e80:	83 ec 0c             	sub    $0xc,%esp
80105e83:	53                   	push   %ebx
80105e84:	e8 27 bf ff ff       	call   80101db0 <iunlockput>
    end_op();
80105e89:	e8 42 d6 ff ff       	call   801034d0 <end_op>
    return -1;
80105e8e:	83 c4 10             	add    $0x10,%esp
80105e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e96:	eb db                	jmp    80105e73 <sys_chdir+0x73>
80105e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9f:	90                   	nop
    end_op();
80105ea0:	e8 2b d6 ff ff       	call   801034d0 <end_op>
    return -1;
80105ea5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eaa:	eb c7                	jmp    80105e73 <sys_chdir+0x73>
80105eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <sys_exec>:

int
sys_exec(void)
{
80105eb0:	f3 0f 1e fb          	endbr32 
80105eb4:	55                   	push   %ebp
80105eb5:	89 e5                	mov    %esp,%ebp
80105eb7:	57                   	push   %edi
80105eb8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105eb9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105ebf:	53                   	push   %ebx
80105ec0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ec6:	50                   	push   %eax
80105ec7:	6a 00                	push   $0x0
80105ec9:	e8 02 f5 ff ff       	call   801053d0 <argstr>
80105ece:	83 c4 10             	add    $0x10,%esp
80105ed1:	85 c0                	test   %eax,%eax
80105ed3:	0f 88 8b 00 00 00    	js     80105f64 <sys_exec+0xb4>
80105ed9:	83 ec 08             	sub    $0x8,%esp
80105edc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105ee2:	50                   	push   %eax
80105ee3:	6a 01                	push   $0x1
80105ee5:	e8 36 f4 ff ff       	call   80105320 <argint>
80105eea:	83 c4 10             	add    $0x10,%esp
80105eed:	85 c0                	test   %eax,%eax
80105eef:	78 73                	js     80105f64 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105ef1:	83 ec 04             	sub    $0x4,%esp
80105ef4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105efa:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105efc:	68 80 00 00 00       	push   $0x80
80105f01:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105f07:	6a 00                	push   $0x0
80105f09:	50                   	push   %eax
80105f0a:	e8 31 f1 ff ff       	call   80105040 <memset>
80105f0f:	83 c4 10             	add    $0x10,%esp
80105f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105f18:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105f1e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105f25:	83 ec 08             	sub    $0x8,%esp
80105f28:	57                   	push   %edi
80105f29:	01 f0                	add    %esi,%eax
80105f2b:	50                   	push   %eax
80105f2c:	e8 4f f3 ff ff       	call   80105280 <fetchint>
80105f31:	83 c4 10             	add    $0x10,%esp
80105f34:	85 c0                	test   %eax,%eax
80105f36:	78 2c                	js     80105f64 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105f38:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105f3e:	85 c0                	test   %eax,%eax
80105f40:	74 36                	je     80105f78 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105f42:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105f48:	83 ec 08             	sub    $0x8,%esp
80105f4b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105f4e:	52                   	push   %edx
80105f4f:	50                   	push   %eax
80105f50:	e8 6b f3 ff ff       	call   801052c0 <fetchstr>
80105f55:	83 c4 10             	add    $0x10,%esp
80105f58:	85 c0                	test   %eax,%eax
80105f5a:	78 08                	js     80105f64 <sys_exec+0xb4>
  for(i=0;; i++){
80105f5c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105f5f:	83 fb 20             	cmp    $0x20,%ebx
80105f62:	75 b4                	jne    80105f18 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105f64:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105f67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f6c:	5b                   	pop    %ebx
80105f6d:	5e                   	pop    %esi
80105f6e:	5f                   	pop    %edi
80105f6f:	5d                   	pop    %ebp
80105f70:	c3                   	ret    
80105f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105f78:	83 ec 08             	sub    $0x8,%esp
80105f7b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105f81:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105f88:	00 00 00 00 
  return exec(path, argv);
80105f8c:	50                   	push   %eax
80105f8d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105f93:	e8 78 ab ff ff       	call   80100b10 <exec>
80105f98:	83 c4 10             	add    $0x10,%esp
}
80105f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f9e:	5b                   	pop    %ebx
80105f9f:	5e                   	pop    %esi
80105fa0:	5f                   	pop    %edi
80105fa1:	5d                   	pop    %ebp
80105fa2:	c3                   	ret    
80105fa3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105fb0 <sys_pipe>:

int
sys_pipe(void)
{
80105fb0:	f3 0f 1e fb          	endbr32 
80105fb4:	55                   	push   %ebp
80105fb5:	89 e5                	mov    %esp,%ebp
80105fb7:	57                   	push   %edi
80105fb8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105fb9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105fbc:	53                   	push   %ebx
80105fbd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105fc0:	6a 08                	push   $0x8
80105fc2:	50                   	push   %eax
80105fc3:	6a 00                	push   $0x0
80105fc5:	e8 a6 f3 ff ff       	call   80105370 <argptr>
80105fca:	83 c4 10             	add    $0x10,%esp
80105fcd:	85 c0                	test   %eax,%eax
80105fcf:	78 4e                	js     8010601f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105fd1:	83 ec 08             	sub    $0x8,%esp
80105fd4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105fd7:	50                   	push   %eax
80105fd8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105fdb:	50                   	push   %eax
80105fdc:	e8 3f db ff ff       	call   80103b20 <pipealloc>
80105fe1:	83 c4 10             	add    $0x10,%esp
80105fe4:	85 c0                	test   %eax,%eax
80105fe6:	78 37                	js     8010601f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105fe8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105feb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105fed:	e8 0e e1 ff ff       	call   80104100 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105ff8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105ffc:	85 f6                	test   %esi,%esi
80105ffe:	74 30                	je     80106030 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80106000:	83 c3 01             	add    $0x1,%ebx
80106003:	83 fb 10             	cmp    $0x10,%ebx
80106006:	75 f0                	jne    80105ff8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106008:	83 ec 0c             	sub    $0xc,%esp
8010600b:	ff 75 e0             	pushl  -0x20(%ebp)
8010600e:	e8 5d b2 ff ff       	call   80101270 <fileclose>
    fileclose(wf);
80106013:	58                   	pop    %eax
80106014:	ff 75 e4             	pushl  -0x1c(%ebp)
80106017:	e8 54 b2 ff ff       	call   80101270 <fileclose>
    return -1;
8010601c:	83 c4 10             	add    $0x10,%esp
8010601f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106024:	eb 5b                	jmp    80106081 <sys_pipe+0xd1>
80106026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010602d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106030:	8d 73 08             	lea    0x8(%ebx),%esi
80106033:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106037:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010603a:	e8 c1 e0 ff ff       	call   80104100 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010603f:	31 d2                	xor    %edx,%edx
80106041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106048:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010604c:	85 c9                	test   %ecx,%ecx
8010604e:	74 20                	je     80106070 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80106050:	83 c2 01             	add    $0x1,%edx
80106053:	83 fa 10             	cmp    $0x10,%edx
80106056:	75 f0                	jne    80106048 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106058:	e8 a3 e0 ff ff       	call   80104100 <myproc>
8010605d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106064:	00 
80106065:	eb a1                	jmp    80106008 <sys_pipe+0x58>
80106067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010606e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106070:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106074:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106077:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106079:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010607c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010607f:	31 c0                	xor    %eax,%eax
}
80106081:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106084:	5b                   	pop    %ebx
80106085:	5e                   	pop    %esi
80106086:	5f                   	pop    %edi
80106087:	5d                   	pop    %ebp
80106088:	c3                   	ret    
80106089:	66 90                	xchg   %ax,%ax
8010608b:	66 90                	xchg   %ax,%ax
8010608d:	66 90                	xchg   %ax,%ax
8010608f:	90                   	nop

80106090 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106090:	f3 0f 1e fb          	endbr32 
  return fork();
80106094:	e9 17 e2 ff ff       	jmp    801042b0 <fork>
80106099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060a0 <sys_exit>:
}

int
sys_exit(void)
{
801060a0:	f3 0f 1e fb          	endbr32 
801060a4:	55                   	push   %ebp
801060a5:	89 e5                	mov    %esp,%ebp
801060a7:	83 ec 08             	sub    $0x8,%esp
  exit();
801060aa:	e8 e1 e5 ff ff       	call   80104690 <exit>
  return 0;  // not reached
}
801060af:	31 c0                	xor    %eax,%eax
801060b1:	c9                   	leave  
801060b2:	c3                   	ret    
801060b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801060c0 <sys_wait>:

int
sys_wait(void)
{
801060c0:	f3 0f 1e fb          	endbr32 
  return wait();
801060c4:	e9 17 e8 ff ff       	jmp    801048e0 <wait>
801060c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060d0 <sys_kill>:
}

int
sys_kill(void)
{
801060d0:	f3 0f 1e fb          	endbr32 
801060d4:	55                   	push   %ebp
801060d5:	89 e5                	mov    %esp,%ebp
801060d7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801060da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060dd:	50                   	push   %eax
801060de:	6a 00                	push   $0x0
801060e0:	e8 3b f2 ff ff       	call   80105320 <argint>
801060e5:	83 c4 10             	add    $0x10,%esp
801060e8:	85 c0                	test   %eax,%eax
801060ea:	78 14                	js     80106100 <sys_kill+0x30>
    return -1;
  return kill(pid);
801060ec:	83 ec 0c             	sub    $0xc,%esp
801060ef:	ff 75 f4             	pushl  -0xc(%ebp)
801060f2:	e8 f9 e9 ff ff       	call   80104af0 <kill>
801060f7:	83 c4 10             	add    $0x10,%esp
}
801060fa:	c9                   	leave  
801060fb:	c3                   	ret    
801060fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106100:	c9                   	leave  
    return -1;
80106101:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106106:	c3                   	ret    
80106107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010610e:	66 90                	xchg   %ax,%ax

80106110 <sys_getpid>:

int
sys_getpid(void)
{
80106110:	f3 0f 1e fb          	endbr32 
80106114:	55                   	push   %ebp
80106115:	89 e5                	mov    %esp,%ebp
80106117:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010611a:	e8 e1 df ff ff       	call   80104100 <myproc>
8010611f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106122:	c9                   	leave  
80106123:	c3                   	ret    
80106124:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010612b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010612f:	90                   	nop

80106130 <sys_sbrk>:

int
sys_sbrk(void)
{
80106130:	f3 0f 1e fb          	endbr32 
80106134:	55                   	push   %ebp
80106135:	89 e5                	mov    %esp,%ebp
80106137:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106138:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010613b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010613e:	50                   	push   %eax
8010613f:	6a 00                	push   $0x0
80106141:	e8 da f1 ff ff       	call   80105320 <argint>
80106146:	83 c4 10             	add    $0x10,%esp
80106149:	85 c0                	test   %eax,%eax
8010614b:	78 23                	js     80106170 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010614d:	e8 ae df ff ff       	call   80104100 <myproc>
  if(growproc(n) < 0)
80106152:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106155:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106157:	ff 75 f4             	pushl  -0xc(%ebp)
8010615a:	e8 d1 e0 ff ff       	call   80104230 <growproc>
8010615f:	83 c4 10             	add    $0x10,%esp
80106162:	85 c0                	test   %eax,%eax
80106164:	78 0a                	js     80106170 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106166:	89 d8                	mov    %ebx,%eax
80106168:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010616b:	c9                   	leave  
8010616c:	c3                   	ret    
8010616d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106170:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106175:	eb ef                	jmp    80106166 <sys_sbrk+0x36>
80106177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010617e:	66 90                	xchg   %ax,%ax

80106180 <sys_sleep>:

int
sys_sleep(void)
{
80106180:	f3 0f 1e fb          	endbr32 
80106184:	55                   	push   %ebp
80106185:	89 e5                	mov    %esp,%ebp
80106187:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106188:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010618b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010618e:	50                   	push   %eax
8010618f:	6a 00                	push   $0x0
80106191:	e8 8a f1 ff ff       	call   80105320 <argint>
80106196:	83 c4 10             	add    $0x10,%esp
80106199:	85 c0                	test   %eax,%eax
8010619b:	0f 88 86 00 00 00    	js     80106227 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801061a1:	83 ec 0c             	sub    $0xc,%esp
801061a4:	68 80 21 12 80       	push   $0x80122180
801061a9:	e8 82 ed ff ff       	call   80104f30 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801061ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801061b1:	8b 1d c0 29 12 80    	mov    0x801229c0,%ebx
  while(ticks - ticks0 < n){
801061b7:	83 c4 10             	add    $0x10,%esp
801061ba:	85 d2                	test   %edx,%edx
801061bc:	75 23                	jne    801061e1 <sys_sleep+0x61>
801061be:	eb 50                	jmp    80106210 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801061c0:	83 ec 08             	sub    $0x8,%esp
801061c3:	68 80 21 12 80       	push   $0x80122180
801061c8:	68 c0 29 12 80       	push   $0x801229c0
801061cd:	e8 4e e6 ff ff       	call   80104820 <sleep>
  while(ticks - ticks0 < n){
801061d2:	a1 c0 29 12 80       	mov    0x801229c0,%eax
801061d7:	83 c4 10             	add    $0x10,%esp
801061da:	29 d8                	sub    %ebx,%eax
801061dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801061df:	73 2f                	jae    80106210 <sys_sleep+0x90>
    if(myproc()->killed){
801061e1:	e8 1a df ff ff       	call   80104100 <myproc>
801061e6:	8b 40 24             	mov    0x24(%eax),%eax
801061e9:	85 c0                	test   %eax,%eax
801061eb:	74 d3                	je     801061c0 <sys_sleep+0x40>
      release(&tickslock);
801061ed:	83 ec 0c             	sub    $0xc,%esp
801061f0:	68 80 21 12 80       	push   $0x80122180
801061f5:	e8 f6 ed ff ff       	call   80104ff0 <release>
  }
  release(&tickslock);
  return 0;
}
801061fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801061fd:	83 c4 10             	add    $0x10,%esp
80106200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106205:	c9                   	leave  
80106206:	c3                   	ret    
80106207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106210:	83 ec 0c             	sub    $0xc,%esp
80106213:	68 80 21 12 80       	push   $0x80122180
80106218:	e8 d3 ed ff ff       	call   80104ff0 <release>
  return 0;
8010621d:	83 c4 10             	add    $0x10,%esp
80106220:	31 c0                	xor    %eax,%eax
}
80106222:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106225:	c9                   	leave  
80106226:	c3                   	ret    
    return -1;
80106227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010622c:	eb f4                	jmp    80106222 <sys_sleep+0xa2>
8010622e:	66 90                	xchg   %ax,%ax

80106230 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106230:	f3 0f 1e fb          	endbr32 
80106234:	55                   	push   %ebp
80106235:	89 e5                	mov    %esp,%ebp
80106237:	53                   	push   %ebx
80106238:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010623b:	68 80 21 12 80       	push   $0x80122180
80106240:	e8 eb ec ff ff       	call   80104f30 <acquire>
  xticks = ticks;
80106245:	8b 1d c0 29 12 80    	mov    0x801229c0,%ebx
  release(&tickslock);
8010624b:	c7 04 24 80 21 12 80 	movl   $0x80122180,(%esp)
80106252:	e8 99 ed ff ff       	call   80104ff0 <release>
  return xticks;
}
80106257:	89 d8                	mov    %ebx,%eax
80106259:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010625c:	c9                   	leave  
8010625d:	c3                   	ret    

8010625e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010625e:	1e                   	push   %ds
  pushl %es
8010625f:	06                   	push   %es
  pushl %fs
80106260:	0f a0                	push   %fs
  pushl %gs
80106262:	0f a8                	push   %gs
  pushal
80106264:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106265:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106269:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010626b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010626d:	54                   	push   %esp
  call trap
8010626e:	e8 cd 00 00 00       	call   80106340 <trap>
  addl $4, %esp
80106273:	83 c4 04             	add    $0x4,%esp

80106276 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106276:	61                   	popa   
  popl %gs
80106277:	0f a9                	pop    %gs
  popl %fs
80106279:	0f a1                	pop    %fs
  popl %es
8010627b:	07                   	pop    %es
  popl %ds
8010627c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010627d:	83 c4 08             	add    $0x8,%esp
  iret
80106280:	cf                   	iret   
80106281:	66 90                	xchg   %ax,%ax
80106283:	66 90                	xchg   %ax,%ax
80106285:	66 90                	xchg   %ax,%ax
80106287:	66 90                	xchg   %ax,%ax
80106289:	66 90                	xchg   %ax,%ax
8010628b:	66 90                	xchg   %ax,%ax
8010628d:	66 90                	xchg   %ax,%ax
8010628f:	90                   	nop

80106290 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106290:	f3 0f 1e fb          	endbr32 
80106294:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106295:	31 c0                	xor    %eax,%eax
{
80106297:	89 e5                	mov    %esp,%ebp
80106299:	83 ec 08             	sub    $0x8,%esp
8010629c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801062a0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801062a7:	c7 04 c5 c2 21 12 80 	movl   $0x8e000008,-0x7fedde3e(,%eax,8)
801062ae:	08 00 00 8e 
801062b2:	66 89 14 c5 c0 21 12 	mov    %dx,-0x7fedde40(,%eax,8)
801062b9:	80 
801062ba:	c1 ea 10             	shr    $0x10,%edx
801062bd:	66 89 14 c5 c6 21 12 	mov    %dx,-0x7fedde3a(,%eax,8)
801062c4:	80 
  for(i = 0; i < 256; i++)
801062c5:	83 c0 01             	add    $0x1,%eax
801062c8:	3d 00 01 00 00       	cmp    $0x100,%eax
801062cd:	75 d1                	jne    801062a0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801062cf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801062d2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801062d7:	c7 05 c2 23 12 80 08 	movl   $0xef000008,0x801223c2
801062de:	00 00 ef 
  initlock(&tickslock, "time");
801062e1:	68 55 89 10 80       	push   $0x80108955
801062e6:	68 80 21 12 80       	push   $0x80122180
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801062eb:	66 a3 c0 23 12 80    	mov    %ax,0x801223c0
801062f1:	c1 e8 10             	shr    $0x10,%eax
801062f4:	66 a3 c6 23 12 80    	mov    %ax,0x801223c6
  initlock(&tickslock, "time");
801062fa:	e8 b1 ea ff ff       	call   80104db0 <initlock>
}
801062ff:	83 c4 10             	add    $0x10,%esp
80106302:	c9                   	leave  
80106303:	c3                   	ret    
80106304:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010630b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010630f:	90                   	nop

80106310 <idtinit>:

void
idtinit(void)
{
80106310:	f3 0f 1e fb          	endbr32 
80106314:	55                   	push   %ebp
  pd[0] = size-1;
80106315:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010631a:	89 e5                	mov    %esp,%ebp
8010631c:	83 ec 10             	sub    $0x10,%esp
8010631f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106323:	b8 c0 21 12 80       	mov    $0x801221c0,%eax
80106328:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010632c:	c1 e8 10             	shr    $0x10,%eax
8010632f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106333:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106336:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106339:	c9                   	leave  
8010633a:	c3                   	ret    
8010633b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010633f:	90                   	nop

80106340 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106340:	f3 0f 1e fb          	endbr32 
80106344:	55                   	push   %ebp
80106345:	89 e5                	mov    %esp,%ebp
80106347:	57                   	push   %edi
80106348:	56                   	push   %esi
80106349:	53                   	push   %ebx
8010634a:	83 ec 1c             	sub    $0x1c,%esp
8010634d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106350:	8b 43 30             	mov    0x30(%ebx),%eax
80106353:	83 f8 40             	cmp    $0x40,%eax
80106356:	0f 84 c4 01 00 00    	je     80106520 <trap+0x1e0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010635c:	83 e8 0e             	sub    $0xe,%eax
8010635f:	83 f8 31             	cmp    $0x31,%eax
80106362:	77 39                	ja     8010639d <trap+0x5d>
80106364:	3e ff 24 85 fc 89 10 	notrack jmp *-0x7fef7604(,%eax,4)
8010636b:	80 

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010636c:	0f 20 d7             	mov    %cr2,%edi
    break;

  case T_PGFLT:
  ;
    uint faulting_addr = rcr2();
    struct proc* p = myproc();
8010636f:	e8 8c dd ff ff       	call   80104100 <myproc>
    // p->tf->eip
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80106374:	83 ec 04             	sub    $0x4,%esp
80106377:	6a 00                	push   $0x0
    struct proc* p = myproc();
80106379:	89 c6                	mov    %eax,%esi
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
8010637b:	57                   	push   %edi
8010637c:	ff 70 04             	pushl  0x4(%eax)
8010637f:	e8 fc 10 00 00       	call   80107480 <public_walkpgdir>
    if (!(pte_ptr == 0) && (*pte_ptr & PTE_U) && (*pte_ptr & PTE_PG)){
80106384:	83 c4 10             	add    $0x10,%esp
80106387:	85 c0                	test   %eax,%eax
80106389:	74 12                	je     8010639d <trap+0x5d>
8010638b:	8b 00                	mov    (%eax),%eax
8010638d:	25 04 02 00 00       	and    $0x204,%eax
80106392:	3d 04 02 00 00       	cmp    $0x204,%eax
80106397:	0f 84 cb 01 00 00    	je     80106568 <trap+0x228>
      break;
    }

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010639d:	e8 5e dd ff ff       	call   80104100 <myproc>
801063a2:	8b 7b 38             	mov    0x38(%ebx),%edi
801063a5:	85 c0                	test   %eax,%eax
801063a7:	0f 84 44 02 00 00    	je     801065f1 <trap+0x2b1>
801063ad:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801063b1:	0f 84 3a 02 00 00    	je     801065f1 <trap+0x2b1>
801063b7:	0f 20 d1             	mov    %cr2,%ecx
801063ba:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063bd:	e8 1e dd ff ff       	call   801040e0 <cpuid>
801063c2:	8b 73 30             	mov    0x30(%ebx),%esi
801063c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801063c8:	8b 43 34             	mov    0x34(%ebx),%eax
801063cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801063ce:	e8 2d dd ff ff       	call   80104100 <myproc>
801063d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801063d6:	e8 25 dd ff ff       	call   80104100 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063db:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801063de:	8b 55 dc             	mov    -0x24(%ebp),%edx
801063e1:	51                   	push   %ecx
801063e2:	57                   	push   %edi
801063e3:	52                   	push   %edx
801063e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801063e7:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801063e8:	8b 75 e0             	mov    -0x20(%ebp),%esi
801063eb:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063ee:	56                   	push   %esi
801063ef:	ff 70 10             	pushl  0x10(%eax)
801063f2:	68 b8 89 10 80       	push   $0x801089b8
801063f7:	e8 b4 a2 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801063fc:	83 c4 20             	add    $0x20,%esp
801063ff:	e8 fc dc ff ff       	call   80104100 <myproc>
80106404:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010640b:	e8 f0 dc ff ff       	call   80104100 <myproc>
80106410:	85 c0                	test   %eax,%eax
80106412:	74 1d                	je     80106431 <trap+0xf1>
80106414:	e8 e7 dc ff ff       	call   80104100 <myproc>
80106419:	8b 50 24             	mov    0x24(%eax),%edx
8010641c:	85 d2                	test   %edx,%edx
8010641e:	74 11                	je     80106431 <trap+0xf1>
80106420:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106424:	83 e0 03             	and    $0x3,%eax
80106427:	66 83 f8 03          	cmp    $0x3,%ax
8010642b:	0f 84 27 01 00 00    	je     80106558 <trap+0x218>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106431:	e8 ca dc ff ff       	call   80104100 <myproc>
80106436:	85 c0                	test   %eax,%eax
80106438:	74 0f                	je     80106449 <trap+0x109>
8010643a:	e8 c1 dc ff ff       	call   80104100 <myproc>
8010643f:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106443:	0f 84 bf 00 00 00    	je     80106508 <trap+0x1c8>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106449:	e8 b2 dc ff ff       	call   80104100 <myproc>
8010644e:	85 c0                	test   %eax,%eax
80106450:	74 1d                	je     8010646f <trap+0x12f>
80106452:	e8 a9 dc ff ff       	call   80104100 <myproc>
80106457:	8b 40 24             	mov    0x24(%eax),%eax
8010645a:	85 c0                	test   %eax,%eax
8010645c:	74 11                	je     8010646f <trap+0x12f>
8010645e:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106462:	83 e0 03             	and    $0x3,%eax
80106465:	66 83 f8 03          	cmp    $0x3,%ax
80106469:	0f 84 da 00 00 00    	je     80106549 <trap+0x209>
    exit();
}
8010646f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106472:	5b                   	pop    %ebx
80106473:	5e                   	pop    %esi
80106474:	5f                   	pop    %edi
80106475:	5d                   	pop    %ebp
80106476:	c3                   	ret    
    if(cpuid() == 0){
80106477:	e8 64 dc ff ff       	call   801040e0 <cpuid>
8010647c:	85 c0                	test   %eax,%eax
8010647e:	0f 84 1c 01 00 00    	je     801065a0 <trap+0x260>
    lapiceoi();
80106484:	e8 67 cb ff ff       	call   80102ff0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106489:	e8 72 dc ff ff       	call   80104100 <myproc>
8010648e:	85 c0                	test   %eax,%eax
80106490:	75 82                	jne    80106414 <trap+0xd4>
80106492:	eb 9d                	jmp    80106431 <trap+0xf1>
    kbdintr();
80106494:	e8 17 ca ff ff       	call   80102eb0 <kbdintr>
    lapiceoi();
80106499:	e8 52 cb ff ff       	call   80102ff0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010649e:	e8 5d dc ff ff       	call   80104100 <myproc>
801064a3:	85 c0                	test   %eax,%eax
801064a5:	0f 85 69 ff ff ff    	jne    80106414 <trap+0xd4>
801064ab:	eb 84                	jmp    80106431 <trap+0xf1>
    uartintr();
801064ad:	e8 de 02 00 00       	call   80106790 <uartintr>
    lapiceoi();
801064b2:	e8 39 cb ff ff       	call   80102ff0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064b7:	e8 44 dc ff ff       	call   80104100 <myproc>
801064bc:	85 c0                	test   %eax,%eax
801064be:	0f 85 50 ff ff ff    	jne    80106414 <trap+0xd4>
801064c4:	e9 68 ff ff ff       	jmp    80106431 <trap+0xf1>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801064c9:	8b 7b 38             	mov    0x38(%ebx),%edi
801064cc:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801064d0:	e8 0b dc ff ff       	call   801040e0 <cpuid>
801064d5:	57                   	push   %edi
801064d6:	56                   	push   %esi
801064d7:	50                   	push   %eax
801064d8:	68 60 89 10 80       	push   $0x80108960
801064dd:	e8 ce a1 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801064e2:	e8 09 cb ff ff       	call   80102ff0 <lapiceoi>
    break;
801064e7:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064ea:	e8 11 dc ff ff       	call   80104100 <myproc>
801064ef:	85 c0                	test   %eax,%eax
801064f1:	0f 85 1d ff ff ff    	jne    80106414 <trap+0xd4>
801064f7:	e9 35 ff ff ff       	jmp    80106431 <trap+0xf1>
    ideintr();
801064fc:	e8 0f c4 ff ff       	call   80102910 <ideintr>
80106501:	eb 81                	jmp    80106484 <trap+0x144>
80106503:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106507:	90                   	nop
  if(myproc() && myproc()->state == RUNNING &&
80106508:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010650c:	0f 85 37 ff ff ff    	jne    80106449 <trap+0x109>
    yield();
80106512:	e8 b9 e2 ff ff       	call   801047d0 <yield>
80106517:	e9 2d ff ff ff       	jmp    80106449 <trap+0x109>
8010651c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106520:	e8 db db ff ff       	call   80104100 <myproc>
80106525:	8b 70 24             	mov    0x24(%eax),%esi
80106528:	85 f6                	test   %esi,%esi
8010652a:	75 6c                	jne    80106598 <trap+0x258>
    myproc()->tf = tf;
8010652c:	e8 cf db ff ff       	call   80104100 <myproc>
80106531:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106534:	e8 d7 ee ff ff       	call   80105410 <syscall>
    if(myproc()->killed)
80106539:	e8 c2 db ff ff       	call   80104100 <myproc>
8010653e:	8b 48 24             	mov    0x24(%eax),%ecx
80106541:	85 c9                	test   %ecx,%ecx
80106543:	0f 84 26 ff ff ff    	je     8010646f <trap+0x12f>
}
80106549:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010654c:	5b                   	pop    %ebx
8010654d:	5e                   	pop    %esi
8010654e:	5f                   	pop    %edi
8010654f:	5d                   	pop    %ebp
      exit();
80106550:	e9 3b e1 ff ff       	jmp    80104690 <exit>
80106555:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106558:	e8 33 e1 ff ff       	call   80104690 <exit>
8010655d:	e9 cf fe ff ff       	jmp    80106431 <trap+0xf1>
80106562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106568:	8d 96 90 00 00 00    	lea    0x90(%esi),%edx
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
8010656e:	31 c0                	xor    %eax,%eax
        if (PGROUNDDOWN((uint)(p->swapped_out_pages[i].va)) == PGROUNDDOWN(faulting_addr)){
80106570:	8b 0a                	mov    (%edx),%ecx
80106572:	31 f9                	xor    %edi,%ecx
80106574:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
8010657a:	74 5c                	je     801065d8 <trap+0x298>
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
8010657c:	83 c0 01             	add    $0x1,%eax
8010657f:	83 c2 18             	add    $0x18,%edx
80106582:	83 f8 10             	cmp    $0x10,%eax
80106585:	75 e9                	jne    80106570 <trap+0x230>
      p->num_of_pagefaults_occurs++;
80106587:	83 86 88 03 00 00 01 	addl   $0x1,0x388(%esi)
      break;
8010658e:	e9 78 fe ff ff       	jmp    8010640b <trap+0xcb>
80106593:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106597:	90                   	nop
      exit();
80106598:	e8 f3 e0 ff ff       	call   80104690 <exit>
8010659d:	eb 8d                	jmp    8010652c <trap+0x1ec>
8010659f:	90                   	nop
      acquire(&tickslock);
801065a0:	83 ec 0c             	sub    $0xc,%esp
801065a3:	68 80 21 12 80       	push   $0x80122180
801065a8:	e8 83 e9 ff ff       	call   80104f30 <acquire>
      wakeup(&ticks);
801065ad:	c7 04 24 c0 29 12 80 	movl   $0x801229c0,(%esp)
      ticks++;
801065b4:	83 05 c0 29 12 80 01 	addl   $0x1,0x801229c0
      wakeup(&ticks);
801065bb:	e8 c0 e4 ff ff       	call   80104a80 <wakeup>
      release(&tickslock);
801065c0:	c7 04 24 80 21 12 80 	movl   $0x80122180,(%esp)
801065c7:	e8 24 ea ff ff       	call   80104ff0 <release>
801065cc:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801065cf:	e9 b0 fe ff ff       	jmp    80106484 <trap+0x144>
801065d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          swap_page_back(p, &(p->swapped_out_pages[i]));
801065d8:	8d 04 40             	lea    (%eax,%eax,2),%eax
801065db:	83 ec 08             	sub    $0x8,%esp
801065de:	8d 84 c6 80 00 00 00 	lea    0x80(%esi,%eax,8),%eax
801065e5:	50                   	push   %eax
801065e6:	56                   	push   %esi
801065e7:	e8 54 1a 00 00       	call   80108040 <swap_page_back>
          break;
801065ec:	83 c4 10             	add    $0x10,%esp
801065ef:	eb 96                	jmp    80106587 <trap+0x247>
801065f1:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801065f4:	e8 e7 da ff ff       	call   801040e0 <cpuid>
801065f9:	83 ec 0c             	sub    $0xc,%esp
801065fc:	56                   	push   %esi
801065fd:	57                   	push   %edi
801065fe:	50                   	push   %eax
801065ff:	ff 73 30             	pushl  0x30(%ebx)
80106602:	68 84 89 10 80       	push   $0x80108984
80106607:	e8 a4 a0 ff ff       	call   801006b0 <cprintf>
      panic("trap");
8010660c:	83 c4 14             	add    $0x14,%esp
8010660f:	68 5a 89 10 80       	push   $0x8010895a
80106614:	e8 77 9d ff ff       	call   80100390 <panic>
80106619:	66 90                	xchg   %ax,%ax
8010661b:	66 90                	xchg   %ax,%ax
8010661d:	66 90                	xchg   %ax,%ax
8010661f:	90                   	nop

80106620 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106620:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106624:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106629:	85 c0                	test   %eax,%eax
8010662b:	74 1b                	je     80106648 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010662d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106632:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106633:	a8 01                	test   $0x1,%al
80106635:	74 11                	je     80106648 <uartgetc+0x28>
80106637:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010663c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010663d:	0f b6 c0             	movzbl %al,%eax
80106640:	c3                   	ret    
80106641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106648:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010664d:	c3                   	ret    
8010664e:	66 90                	xchg   %ax,%ax

80106650 <uartputc.part.0>:
uartputc(int c)
80106650:	55                   	push   %ebp
80106651:	89 e5                	mov    %esp,%ebp
80106653:	57                   	push   %edi
80106654:	89 c7                	mov    %eax,%edi
80106656:	56                   	push   %esi
80106657:	be fd 03 00 00       	mov    $0x3fd,%esi
8010665c:	53                   	push   %ebx
8010665d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106662:	83 ec 0c             	sub    $0xc,%esp
80106665:	eb 1b                	jmp    80106682 <uartputc.part.0+0x32>
80106667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010666e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106670:	83 ec 0c             	sub    $0xc,%esp
80106673:	6a 0a                	push   $0xa
80106675:	e8 96 c9 ff ff       	call   80103010 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010667a:	83 c4 10             	add    $0x10,%esp
8010667d:	83 eb 01             	sub    $0x1,%ebx
80106680:	74 07                	je     80106689 <uartputc.part.0+0x39>
80106682:	89 f2                	mov    %esi,%edx
80106684:	ec                   	in     (%dx),%al
80106685:	a8 20                	test   $0x20,%al
80106687:	74 e7                	je     80106670 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106689:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010668e:	89 f8                	mov    %edi,%eax
80106690:	ee                   	out    %al,(%dx)
}
80106691:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106694:	5b                   	pop    %ebx
80106695:	5e                   	pop    %esi
80106696:	5f                   	pop    %edi
80106697:	5d                   	pop    %ebp
80106698:	c3                   	ret    
80106699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801066a0 <uartinit>:
{
801066a0:	f3 0f 1e fb          	endbr32 
801066a4:	55                   	push   %ebp
801066a5:	31 c9                	xor    %ecx,%ecx
801066a7:	89 c8                	mov    %ecx,%eax
801066a9:	89 e5                	mov    %esp,%ebp
801066ab:	57                   	push   %edi
801066ac:	56                   	push   %esi
801066ad:	53                   	push   %ebx
801066ae:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801066b3:	89 da                	mov    %ebx,%edx
801066b5:	83 ec 0c             	sub    $0xc,%esp
801066b8:	ee                   	out    %al,(%dx)
801066b9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801066be:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801066c3:	89 fa                	mov    %edi,%edx
801066c5:	ee                   	out    %al,(%dx)
801066c6:	b8 0c 00 00 00       	mov    $0xc,%eax
801066cb:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066d0:	ee                   	out    %al,(%dx)
801066d1:	be f9 03 00 00       	mov    $0x3f9,%esi
801066d6:	89 c8                	mov    %ecx,%eax
801066d8:	89 f2                	mov    %esi,%edx
801066da:	ee                   	out    %al,(%dx)
801066db:	b8 03 00 00 00       	mov    $0x3,%eax
801066e0:	89 fa                	mov    %edi,%edx
801066e2:	ee                   	out    %al,(%dx)
801066e3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801066e8:	89 c8                	mov    %ecx,%eax
801066ea:	ee                   	out    %al,(%dx)
801066eb:	b8 01 00 00 00       	mov    $0x1,%eax
801066f0:	89 f2                	mov    %esi,%edx
801066f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801066f3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801066f8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801066f9:	3c ff                	cmp    $0xff,%al
801066fb:	74 52                	je     8010674f <uartinit+0xaf>
  uart = 1;
801066fd:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106704:	00 00 00 
80106707:	89 da                	mov    %ebx,%edx
80106709:	ec                   	in     (%dx),%al
8010670a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010670f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106710:	83 ec 08             	sub    $0x8,%esp
80106713:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106718:	bb c4 8a 10 80       	mov    $0x80108ac4,%ebx
  ioapicenable(IRQ_COM1, 0);
8010671d:	6a 00                	push   $0x0
8010671f:	6a 04                	push   $0x4
80106721:	e8 3a c4 ff ff       	call   80102b60 <ioapicenable>
80106726:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106729:	b8 78 00 00 00       	mov    $0x78,%eax
8010672e:	eb 04                	jmp    80106734 <uartinit+0x94>
80106730:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106734:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010673a:	85 d2                	test   %edx,%edx
8010673c:	74 08                	je     80106746 <uartinit+0xa6>
    uartputc(*p);
8010673e:	0f be c0             	movsbl %al,%eax
80106741:	e8 0a ff ff ff       	call   80106650 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106746:	89 f0                	mov    %esi,%eax
80106748:	83 c3 01             	add    $0x1,%ebx
8010674b:	84 c0                	test   %al,%al
8010674d:	75 e1                	jne    80106730 <uartinit+0x90>
}
8010674f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106752:	5b                   	pop    %ebx
80106753:	5e                   	pop    %esi
80106754:	5f                   	pop    %edi
80106755:	5d                   	pop    %ebp
80106756:	c3                   	ret    
80106757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010675e:	66 90                	xchg   %ax,%ax

80106760 <uartputc>:
{
80106760:	f3 0f 1e fb          	endbr32 
80106764:	55                   	push   %ebp
  if(!uart)
80106765:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
8010676b:	89 e5                	mov    %esp,%ebp
8010676d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106770:	85 d2                	test   %edx,%edx
80106772:	74 0c                	je     80106780 <uartputc+0x20>
}
80106774:	5d                   	pop    %ebp
80106775:	e9 d6 fe ff ff       	jmp    80106650 <uartputc.part.0>
8010677a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106780:	5d                   	pop    %ebp
80106781:	c3                   	ret    
80106782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106790 <uartintr>:

void
uartintr(void)
{
80106790:	f3 0f 1e fb          	endbr32 
80106794:	55                   	push   %ebp
80106795:	89 e5                	mov    %esp,%ebp
80106797:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010679a:	68 20 66 10 80       	push   $0x80106620
8010679f:	e8 bc a0 ff ff       	call   80100860 <consoleintr>
}
801067a4:	83 c4 10             	add    $0x10,%esp
801067a7:	c9                   	leave  
801067a8:	c3                   	ret    

801067a9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $0
801067ab:	6a 00                	push   $0x0
  jmp alltraps
801067ad:	e9 ac fa ff ff       	jmp    8010625e <alltraps>

801067b2 <vector1>:
.globl vector1
vector1:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $1
801067b4:	6a 01                	push   $0x1
  jmp alltraps
801067b6:	e9 a3 fa ff ff       	jmp    8010625e <alltraps>

801067bb <vector2>:
.globl vector2
vector2:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $2
801067bd:	6a 02                	push   $0x2
  jmp alltraps
801067bf:	e9 9a fa ff ff       	jmp    8010625e <alltraps>

801067c4 <vector3>:
.globl vector3
vector3:
  pushl $0
801067c4:	6a 00                	push   $0x0
  pushl $3
801067c6:	6a 03                	push   $0x3
  jmp alltraps
801067c8:	e9 91 fa ff ff       	jmp    8010625e <alltraps>

801067cd <vector4>:
.globl vector4
vector4:
  pushl $0
801067cd:	6a 00                	push   $0x0
  pushl $4
801067cf:	6a 04                	push   $0x4
  jmp alltraps
801067d1:	e9 88 fa ff ff       	jmp    8010625e <alltraps>

801067d6 <vector5>:
.globl vector5
vector5:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $5
801067d8:	6a 05                	push   $0x5
  jmp alltraps
801067da:	e9 7f fa ff ff       	jmp    8010625e <alltraps>

801067df <vector6>:
.globl vector6
vector6:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $6
801067e1:	6a 06                	push   $0x6
  jmp alltraps
801067e3:	e9 76 fa ff ff       	jmp    8010625e <alltraps>

801067e8 <vector7>:
.globl vector7
vector7:
  pushl $0
801067e8:	6a 00                	push   $0x0
  pushl $7
801067ea:	6a 07                	push   $0x7
  jmp alltraps
801067ec:	e9 6d fa ff ff       	jmp    8010625e <alltraps>

801067f1 <vector8>:
.globl vector8
vector8:
  pushl $8
801067f1:	6a 08                	push   $0x8
  jmp alltraps
801067f3:	e9 66 fa ff ff       	jmp    8010625e <alltraps>

801067f8 <vector9>:
.globl vector9
vector9:
  pushl $0
801067f8:	6a 00                	push   $0x0
  pushl $9
801067fa:	6a 09                	push   $0x9
  jmp alltraps
801067fc:	e9 5d fa ff ff       	jmp    8010625e <alltraps>

80106801 <vector10>:
.globl vector10
vector10:
  pushl $10
80106801:	6a 0a                	push   $0xa
  jmp alltraps
80106803:	e9 56 fa ff ff       	jmp    8010625e <alltraps>

80106808 <vector11>:
.globl vector11
vector11:
  pushl $11
80106808:	6a 0b                	push   $0xb
  jmp alltraps
8010680a:	e9 4f fa ff ff       	jmp    8010625e <alltraps>

8010680f <vector12>:
.globl vector12
vector12:
  pushl $12
8010680f:	6a 0c                	push   $0xc
  jmp alltraps
80106811:	e9 48 fa ff ff       	jmp    8010625e <alltraps>

80106816 <vector13>:
.globl vector13
vector13:
  pushl $13
80106816:	6a 0d                	push   $0xd
  jmp alltraps
80106818:	e9 41 fa ff ff       	jmp    8010625e <alltraps>

8010681d <vector14>:
.globl vector14
vector14:
  pushl $14
8010681d:	6a 0e                	push   $0xe
  jmp alltraps
8010681f:	e9 3a fa ff ff       	jmp    8010625e <alltraps>

80106824 <vector15>:
.globl vector15
vector15:
  pushl $0
80106824:	6a 00                	push   $0x0
  pushl $15
80106826:	6a 0f                	push   $0xf
  jmp alltraps
80106828:	e9 31 fa ff ff       	jmp    8010625e <alltraps>

8010682d <vector16>:
.globl vector16
vector16:
  pushl $0
8010682d:	6a 00                	push   $0x0
  pushl $16
8010682f:	6a 10                	push   $0x10
  jmp alltraps
80106831:	e9 28 fa ff ff       	jmp    8010625e <alltraps>

80106836 <vector17>:
.globl vector17
vector17:
  pushl $17
80106836:	6a 11                	push   $0x11
  jmp alltraps
80106838:	e9 21 fa ff ff       	jmp    8010625e <alltraps>

8010683d <vector18>:
.globl vector18
vector18:
  pushl $0
8010683d:	6a 00                	push   $0x0
  pushl $18
8010683f:	6a 12                	push   $0x12
  jmp alltraps
80106841:	e9 18 fa ff ff       	jmp    8010625e <alltraps>

80106846 <vector19>:
.globl vector19
vector19:
  pushl $0
80106846:	6a 00                	push   $0x0
  pushl $19
80106848:	6a 13                	push   $0x13
  jmp alltraps
8010684a:	e9 0f fa ff ff       	jmp    8010625e <alltraps>

8010684f <vector20>:
.globl vector20
vector20:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $20
80106851:	6a 14                	push   $0x14
  jmp alltraps
80106853:	e9 06 fa ff ff       	jmp    8010625e <alltraps>

80106858 <vector21>:
.globl vector21
vector21:
  pushl $0
80106858:	6a 00                	push   $0x0
  pushl $21
8010685a:	6a 15                	push   $0x15
  jmp alltraps
8010685c:	e9 fd f9 ff ff       	jmp    8010625e <alltraps>

80106861 <vector22>:
.globl vector22
vector22:
  pushl $0
80106861:	6a 00                	push   $0x0
  pushl $22
80106863:	6a 16                	push   $0x16
  jmp alltraps
80106865:	e9 f4 f9 ff ff       	jmp    8010625e <alltraps>

8010686a <vector23>:
.globl vector23
vector23:
  pushl $0
8010686a:	6a 00                	push   $0x0
  pushl $23
8010686c:	6a 17                	push   $0x17
  jmp alltraps
8010686e:	e9 eb f9 ff ff       	jmp    8010625e <alltraps>

80106873 <vector24>:
.globl vector24
vector24:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $24
80106875:	6a 18                	push   $0x18
  jmp alltraps
80106877:	e9 e2 f9 ff ff       	jmp    8010625e <alltraps>

8010687c <vector25>:
.globl vector25
vector25:
  pushl $0
8010687c:	6a 00                	push   $0x0
  pushl $25
8010687e:	6a 19                	push   $0x19
  jmp alltraps
80106880:	e9 d9 f9 ff ff       	jmp    8010625e <alltraps>

80106885 <vector26>:
.globl vector26
vector26:
  pushl $0
80106885:	6a 00                	push   $0x0
  pushl $26
80106887:	6a 1a                	push   $0x1a
  jmp alltraps
80106889:	e9 d0 f9 ff ff       	jmp    8010625e <alltraps>

8010688e <vector27>:
.globl vector27
vector27:
  pushl $0
8010688e:	6a 00                	push   $0x0
  pushl $27
80106890:	6a 1b                	push   $0x1b
  jmp alltraps
80106892:	e9 c7 f9 ff ff       	jmp    8010625e <alltraps>

80106897 <vector28>:
.globl vector28
vector28:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $28
80106899:	6a 1c                	push   $0x1c
  jmp alltraps
8010689b:	e9 be f9 ff ff       	jmp    8010625e <alltraps>

801068a0 <vector29>:
.globl vector29
vector29:
  pushl $0
801068a0:	6a 00                	push   $0x0
  pushl $29
801068a2:	6a 1d                	push   $0x1d
  jmp alltraps
801068a4:	e9 b5 f9 ff ff       	jmp    8010625e <alltraps>

801068a9 <vector30>:
.globl vector30
vector30:
  pushl $0
801068a9:	6a 00                	push   $0x0
  pushl $30
801068ab:	6a 1e                	push   $0x1e
  jmp alltraps
801068ad:	e9 ac f9 ff ff       	jmp    8010625e <alltraps>

801068b2 <vector31>:
.globl vector31
vector31:
  pushl $0
801068b2:	6a 00                	push   $0x0
  pushl $31
801068b4:	6a 1f                	push   $0x1f
  jmp alltraps
801068b6:	e9 a3 f9 ff ff       	jmp    8010625e <alltraps>

801068bb <vector32>:
.globl vector32
vector32:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $32
801068bd:	6a 20                	push   $0x20
  jmp alltraps
801068bf:	e9 9a f9 ff ff       	jmp    8010625e <alltraps>

801068c4 <vector33>:
.globl vector33
vector33:
  pushl $0
801068c4:	6a 00                	push   $0x0
  pushl $33
801068c6:	6a 21                	push   $0x21
  jmp alltraps
801068c8:	e9 91 f9 ff ff       	jmp    8010625e <alltraps>

801068cd <vector34>:
.globl vector34
vector34:
  pushl $0
801068cd:	6a 00                	push   $0x0
  pushl $34
801068cf:	6a 22                	push   $0x22
  jmp alltraps
801068d1:	e9 88 f9 ff ff       	jmp    8010625e <alltraps>

801068d6 <vector35>:
.globl vector35
vector35:
  pushl $0
801068d6:	6a 00                	push   $0x0
  pushl $35
801068d8:	6a 23                	push   $0x23
  jmp alltraps
801068da:	e9 7f f9 ff ff       	jmp    8010625e <alltraps>

801068df <vector36>:
.globl vector36
vector36:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $36
801068e1:	6a 24                	push   $0x24
  jmp alltraps
801068e3:	e9 76 f9 ff ff       	jmp    8010625e <alltraps>

801068e8 <vector37>:
.globl vector37
vector37:
  pushl $0
801068e8:	6a 00                	push   $0x0
  pushl $37
801068ea:	6a 25                	push   $0x25
  jmp alltraps
801068ec:	e9 6d f9 ff ff       	jmp    8010625e <alltraps>

801068f1 <vector38>:
.globl vector38
vector38:
  pushl $0
801068f1:	6a 00                	push   $0x0
  pushl $38
801068f3:	6a 26                	push   $0x26
  jmp alltraps
801068f5:	e9 64 f9 ff ff       	jmp    8010625e <alltraps>

801068fa <vector39>:
.globl vector39
vector39:
  pushl $0
801068fa:	6a 00                	push   $0x0
  pushl $39
801068fc:	6a 27                	push   $0x27
  jmp alltraps
801068fe:	e9 5b f9 ff ff       	jmp    8010625e <alltraps>

80106903 <vector40>:
.globl vector40
vector40:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $40
80106905:	6a 28                	push   $0x28
  jmp alltraps
80106907:	e9 52 f9 ff ff       	jmp    8010625e <alltraps>

8010690c <vector41>:
.globl vector41
vector41:
  pushl $0
8010690c:	6a 00                	push   $0x0
  pushl $41
8010690e:	6a 29                	push   $0x29
  jmp alltraps
80106910:	e9 49 f9 ff ff       	jmp    8010625e <alltraps>

80106915 <vector42>:
.globl vector42
vector42:
  pushl $0
80106915:	6a 00                	push   $0x0
  pushl $42
80106917:	6a 2a                	push   $0x2a
  jmp alltraps
80106919:	e9 40 f9 ff ff       	jmp    8010625e <alltraps>

8010691e <vector43>:
.globl vector43
vector43:
  pushl $0
8010691e:	6a 00                	push   $0x0
  pushl $43
80106920:	6a 2b                	push   $0x2b
  jmp alltraps
80106922:	e9 37 f9 ff ff       	jmp    8010625e <alltraps>

80106927 <vector44>:
.globl vector44
vector44:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $44
80106929:	6a 2c                	push   $0x2c
  jmp alltraps
8010692b:	e9 2e f9 ff ff       	jmp    8010625e <alltraps>

80106930 <vector45>:
.globl vector45
vector45:
  pushl $0
80106930:	6a 00                	push   $0x0
  pushl $45
80106932:	6a 2d                	push   $0x2d
  jmp alltraps
80106934:	e9 25 f9 ff ff       	jmp    8010625e <alltraps>

80106939 <vector46>:
.globl vector46
vector46:
  pushl $0
80106939:	6a 00                	push   $0x0
  pushl $46
8010693b:	6a 2e                	push   $0x2e
  jmp alltraps
8010693d:	e9 1c f9 ff ff       	jmp    8010625e <alltraps>

80106942 <vector47>:
.globl vector47
vector47:
  pushl $0
80106942:	6a 00                	push   $0x0
  pushl $47
80106944:	6a 2f                	push   $0x2f
  jmp alltraps
80106946:	e9 13 f9 ff ff       	jmp    8010625e <alltraps>

8010694b <vector48>:
.globl vector48
vector48:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $48
8010694d:	6a 30                	push   $0x30
  jmp alltraps
8010694f:	e9 0a f9 ff ff       	jmp    8010625e <alltraps>

80106954 <vector49>:
.globl vector49
vector49:
  pushl $0
80106954:	6a 00                	push   $0x0
  pushl $49
80106956:	6a 31                	push   $0x31
  jmp alltraps
80106958:	e9 01 f9 ff ff       	jmp    8010625e <alltraps>

8010695d <vector50>:
.globl vector50
vector50:
  pushl $0
8010695d:	6a 00                	push   $0x0
  pushl $50
8010695f:	6a 32                	push   $0x32
  jmp alltraps
80106961:	e9 f8 f8 ff ff       	jmp    8010625e <alltraps>

80106966 <vector51>:
.globl vector51
vector51:
  pushl $0
80106966:	6a 00                	push   $0x0
  pushl $51
80106968:	6a 33                	push   $0x33
  jmp alltraps
8010696a:	e9 ef f8 ff ff       	jmp    8010625e <alltraps>

8010696f <vector52>:
.globl vector52
vector52:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $52
80106971:	6a 34                	push   $0x34
  jmp alltraps
80106973:	e9 e6 f8 ff ff       	jmp    8010625e <alltraps>

80106978 <vector53>:
.globl vector53
vector53:
  pushl $0
80106978:	6a 00                	push   $0x0
  pushl $53
8010697a:	6a 35                	push   $0x35
  jmp alltraps
8010697c:	e9 dd f8 ff ff       	jmp    8010625e <alltraps>

80106981 <vector54>:
.globl vector54
vector54:
  pushl $0
80106981:	6a 00                	push   $0x0
  pushl $54
80106983:	6a 36                	push   $0x36
  jmp alltraps
80106985:	e9 d4 f8 ff ff       	jmp    8010625e <alltraps>

8010698a <vector55>:
.globl vector55
vector55:
  pushl $0
8010698a:	6a 00                	push   $0x0
  pushl $55
8010698c:	6a 37                	push   $0x37
  jmp alltraps
8010698e:	e9 cb f8 ff ff       	jmp    8010625e <alltraps>

80106993 <vector56>:
.globl vector56
vector56:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $56
80106995:	6a 38                	push   $0x38
  jmp alltraps
80106997:	e9 c2 f8 ff ff       	jmp    8010625e <alltraps>

8010699c <vector57>:
.globl vector57
vector57:
  pushl $0
8010699c:	6a 00                	push   $0x0
  pushl $57
8010699e:	6a 39                	push   $0x39
  jmp alltraps
801069a0:	e9 b9 f8 ff ff       	jmp    8010625e <alltraps>

801069a5 <vector58>:
.globl vector58
vector58:
  pushl $0
801069a5:	6a 00                	push   $0x0
  pushl $58
801069a7:	6a 3a                	push   $0x3a
  jmp alltraps
801069a9:	e9 b0 f8 ff ff       	jmp    8010625e <alltraps>

801069ae <vector59>:
.globl vector59
vector59:
  pushl $0
801069ae:	6a 00                	push   $0x0
  pushl $59
801069b0:	6a 3b                	push   $0x3b
  jmp alltraps
801069b2:	e9 a7 f8 ff ff       	jmp    8010625e <alltraps>

801069b7 <vector60>:
.globl vector60
vector60:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $60
801069b9:	6a 3c                	push   $0x3c
  jmp alltraps
801069bb:	e9 9e f8 ff ff       	jmp    8010625e <alltraps>

801069c0 <vector61>:
.globl vector61
vector61:
  pushl $0
801069c0:	6a 00                	push   $0x0
  pushl $61
801069c2:	6a 3d                	push   $0x3d
  jmp alltraps
801069c4:	e9 95 f8 ff ff       	jmp    8010625e <alltraps>

801069c9 <vector62>:
.globl vector62
vector62:
  pushl $0
801069c9:	6a 00                	push   $0x0
  pushl $62
801069cb:	6a 3e                	push   $0x3e
  jmp alltraps
801069cd:	e9 8c f8 ff ff       	jmp    8010625e <alltraps>

801069d2 <vector63>:
.globl vector63
vector63:
  pushl $0
801069d2:	6a 00                	push   $0x0
  pushl $63
801069d4:	6a 3f                	push   $0x3f
  jmp alltraps
801069d6:	e9 83 f8 ff ff       	jmp    8010625e <alltraps>

801069db <vector64>:
.globl vector64
vector64:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $64
801069dd:	6a 40                	push   $0x40
  jmp alltraps
801069df:	e9 7a f8 ff ff       	jmp    8010625e <alltraps>

801069e4 <vector65>:
.globl vector65
vector65:
  pushl $0
801069e4:	6a 00                	push   $0x0
  pushl $65
801069e6:	6a 41                	push   $0x41
  jmp alltraps
801069e8:	e9 71 f8 ff ff       	jmp    8010625e <alltraps>

801069ed <vector66>:
.globl vector66
vector66:
  pushl $0
801069ed:	6a 00                	push   $0x0
  pushl $66
801069ef:	6a 42                	push   $0x42
  jmp alltraps
801069f1:	e9 68 f8 ff ff       	jmp    8010625e <alltraps>

801069f6 <vector67>:
.globl vector67
vector67:
  pushl $0
801069f6:	6a 00                	push   $0x0
  pushl $67
801069f8:	6a 43                	push   $0x43
  jmp alltraps
801069fa:	e9 5f f8 ff ff       	jmp    8010625e <alltraps>

801069ff <vector68>:
.globl vector68
vector68:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $68
80106a01:	6a 44                	push   $0x44
  jmp alltraps
80106a03:	e9 56 f8 ff ff       	jmp    8010625e <alltraps>

80106a08 <vector69>:
.globl vector69
vector69:
  pushl $0
80106a08:	6a 00                	push   $0x0
  pushl $69
80106a0a:	6a 45                	push   $0x45
  jmp alltraps
80106a0c:	e9 4d f8 ff ff       	jmp    8010625e <alltraps>

80106a11 <vector70>:
.globl vector70
vector70:
  pushl $0
80106a11:	6a 00                	push   $0x0
  pushl $70
80106a13:	6a 46                	push   $0x46
  jmp alltraps
80106a15:	e9 44 f8 ff ff       	jmp    8010625e <alltraps>

80106a1a <vector71>:
.globl vector71
vector71:
  pushl $0
80106a1a:	6a 00                	push   $0x0
  pushl $71
80106a1c:	6a 47                	push   $0x47
  jmp alltraps
80106a1e:	e9 3b f8 ff ff       	jmp    8010625e <alltraps>

80106a23 <vector72>:
.globl vector72
vector72:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $72
80106a25:	6a 48                	push   $0x48
  jmp alltraps
80106a27:	e9 32 f8 ff ff       	jmp    8010625e <alltraps>

80106a2c <vector73>:
.globl vector73
vector73:
  pushl $0
80106a2c:	6a 00                	push   $0x0
  pushl $73
80106a2e:	6a 49                	push   $0x49
  jmp alltraps
80106a30:	e9 29 f8 ff ff       	jmp    8010625e <alltraps>

80106a35 <vector74>:
.globl vector74
vector74:
  pushl $0
80106a35:	6a 00                	push   $0x0
  pushl $74
80106a37:	6a 4a                	push   $0x4a
  jmp alltraps
80106a39:	e9 20 f8 ff ff       	jmp    8010625e <alltraps>

80106a3e <vector75>:
.globl vector75
vector75:
  pushl $0
80106a3e:	6a 00                	push   $0x0
  pushl $75
80106a40:	6a 4b                	push   $0x4b
  jmp alltraps
80106a42:	e9 17 f8 ff ff       	jmp    8010625e <alltraps>

80106a47 <vector76>:
.globl vector76
vector76:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $76
80106a49:	6a 4c                	push   $0x4c
  jmp alltraps
80106a4b:	e9 0e f8 ff ff       	jmp    8010625e <alltraps>

80106a50 <vector77>:
.globl vector77
vector77:
  pushl $0
80106a50:	6a 00                	push   $0x0
  pushl $77
80106a52:	6a 4d                	push   $0x4d
  jmp alltraps
80106a54:	e9 05 f8 ff ff       	jmp    8010625e <alltraps>

80106a59 <vector78>:
.globl vector78
vector78:
  pushl $0
80106a59:	6a 00                	push   $0x0
  pushl $78
80106a5b:	6a 4e                	push   $0x4e
  jmp alltraps
80106a5d:	e9 fc f7 ff ff       	jmp    8010625e <alltraps>

80106a62 <vector79>:
.globl vector79
vector79:
  pushl $0
80106a62:	6a 00                	push   $0x0
  pushl $79
80106a64:	6a 4f                	push   $0x4f
  jmp alltraps
80106a66:	e9 f3 f7 ff ff       	jmp    8010625e <alltraps>

80106a6b <vector80>:
.globl vector80
vector80:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $80
80106a6d:	6a 50                	push   $0x50
  jmp alltraps
80106a6f:	e9 ea f7 ff ff       	jmp    8010625e <alltraps>

80106a74 <vector81>:
.globl vector81
vector81:
  pushl $0
80106a74:	6a 00                	push   $0x0
  pushl $81
80106a76:	6a 51                	push   $0x51
  jmp alltraps
80106a78:	e9 e1 f7 ff ff       	jmp    8010625e <alltraps>

80106a7d <vector82>:
.globl vector82
vector82:
  pushl $0
80106a7d:	6a 00                	push   $0x0
  pushl $82
80106a7f:	6a 52                	push   $0x52
  jmp alltraps
80106a81:	e9 d8 f7 ff ff       	jmp    8010625e <alltraps>

80106a86 <vector83>:
.globl vector83
vector83:
  pushl $0
80106a86:	6a 00                	push   $0x0
  pushl $83
80106a88:	6a 53                	push   $0x53
  jmp alltraps
80106a8a:	e9 cf f7 ff ff       	jmp    8010625e <alltraps>

80106a8f <vector84>:
.globl vector84
vector84:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $84
80106a91:	6a 54                	push   $0x54
  jmp alltraps
80106a93:	e9 c6 f7 ff ff       	jmp    8010625e <alltraps>

80106a98 <vector85>:
.globl vector85
vector85:
  pushl $0
80106a98:	6a 00                	push   $0x0
  pushl $85
80106a9a:	6a 55                	push   $0x55
  jmp alltraps
80106a9c:	e9 bd f7 ff ff       	jmp    8010625e <alltraps>

80106aa1 <vector86>:
.globl vector86
vector86:
  pushl $0
80106aa1:	6a 00                	push   $0x0
  pushl $86
80106aa3:	6a 56                	push   $0x56
  jmp alltraps
80106aa5:	e9 b4 f7 ff ff       	jmp    8010625e <alltraps>

80106aaa <vector87>:
.globl vector87
vector87:
  pushl $0
80106aaa:	6a 00                	push   $0x0
  pushl $87
80106aac:	6a 57                	push   $0x57
  jmp alltraps
80106aae:	e9 ab f7 ff ff       	jmp    8010625e <alltraps>

80106ab3 <vector88>:
.globl vector88
vector88:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $88
80106ab5:	6a 58                	push   $0x58
  jmp alltraps
80106ab7:	e9 a2 f7 ff ff       	jmp    8010625e <alltraps>

80106abc <vector89>:
.globl vector89
vector89:
  pushl $0
80106abc:	6a 00                	push   $0x0
  pushl $89
80106abe:	6a 59                	push   $0x59
  jmp alltraps
80106ac0:	e9 99 f7 ff ff       	jmp    8010625e <alltraps>

80106ac5 <vector90>:
.globl vector90
vector90:
  pushl $0
80106ac5:	6a 00                	push   $0x0
  pushl $90
80106ac7:	6a 5a                	push   $0x5a
  jmp alltraps
80106ac9:	e9 90 f7 ff ff       	jmp    8010625e <alltraps>

80106ace <vector91>:
.globl vector91
vector91:
  pushl $0
80106ace:	6a 00                	push   $0x0
  pushl $91
80106ad0:	6a 5b                	push   $0x5b
  jmp alltraps
80106ad2:	e9 87 f7 ff ff       	jmp    8010625e <alltraps>

80106ad7 <vector92>:
.globl vector92
vector92:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $92
80106ad9:	6a 5c                	push   $0x5c
  jmp alltraps
80106adb:	e9 7e f7 ff ff       	jmp    8010625e <alltraps>

80106ae0 <vector93>:
.globl vector93
vector93:
  pushl $0
80106ae0:	6a 00                	push   $0x0
  pushl $93
80106ae2:	6a 5d                	push   $0x5d
  jmp alltraps
80106ae4:	e9 75 f7 ff ff       	jmp    8010625e <alltraps>

80106ae9 <vector94>:
.globl vector94
vector94:
  pushl $0
80106ae9:	6a 00                	push   $0x0
  pushl $94
80106aeb:	6a 5e                	push   $0x5e
  jmp alltraps
80106aed:	e9 6c f7 ff ff       	jmp    8010625e <alltraps>

80106af2 <vector95>:
.globl vector95
vector95:
  pushl $0
80106af2:	6a 00                	push   $0x0
  pushl $95
80106af4:	6a 5f                	push   $0x5f
  jmp alltraps
80106af6:	e9 63 f7 ff ff       	jmp    8010625e <alltraps>

80106afb <vector96>:
.globl vector96
vector96:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $96
80106afd:	6a 60                	push   $0x60
  jmp alltraps
80106aff:	e9 5a f7 ff ff       	jmp    8010625e <alltraps>

80106b04 <vector97>:
.globl vector97
vector97:
  pushl $0
80106b04:	6a 00                	push   $0x0
  pushl $97
80106b06:	6a 61                	push   $0x61
  jmp alltraps
80106b08:	e9 51 f7 ff ff       	jmp    8010625e <alltraps>

80106b0d <vector98>:
.globl vector98
vector98:
  pushl $0
80106b0d:	6a 00                	push   $0x0
  pushl $98
80106b0f:	6a 62                	push   $0x62
  jmp alltraps
80106b11:	e9 48 f7 ff ff       	jmp    8010625e <alltraps>

80106b16 <vector99>:
.globl vector99
vector99:
  pushl $0
80106b16:	6a 00                	push   $0x0
  pushl $99
80106b18:	6a 63                	push   $0x63
  jmp alltraps
80106b1a:	e9 3f f7 ff ff       	jmp    8010625e <alltraps>

80106b1f <vector100>:
.globl vector100
vector100:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $100
80106b21:	6a 64                	push   $0x64
  jmp alltraps
80106b23:	e9 36 f7 ff ff       	jmp    8010625e <alltraps>

80106b28 <vector101>:
.globl vector101
vector101:
  pushl $0
80106b28:	6a 00                	push   $0x0
  pushl $101
80106b2a:	6a 65                	push   $0x65
  jmp alltraps
80106b2c:	e9 2d f7 ff ff       	jmp    8010625e <alltraps>

80106b31 <vector102>:
.globl vector102
vector102:
  pushl $0
80106b31:	6a 00                	push   $0x0
  pushl $102
80106b33:	6a 66                	push   $0x66
  jmp alltraps
80106b35:	e9 24 f7 ff ff       	jmp    8010625e <alltraps>

80106b3a <vector103>:
.globl vector103
vector103:
  pushl $0
80106b3a:	6a 00                	push   $0x0
  pushl $103
80106b3c:	6a 67                	push   $0x67
  jmp alltraps
80106b3e:	e9 1b f7 ff ff       	jmp    8010625e <alltraps>

80106b43 <vector104>:
.globl vector104
vector104:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $104
80106b45:	6a 68                	push   $0x68
  jmp alltraps
80106b47:	e9 12 f7 ff ff       	jmp    8010625e <alltraps>

80106b4c <vector105>:
.globl vector105
vector105:
  pushl $0
80106b4c:	6a 00                	push   $0x0
  pushl $105
80106b4e:	6a 69                	push   $0x69
  jmp alltraps
80106b50:	e9 09 f7 ff ff       	jmp    8010625e <alltraps>

80106b55 <vector106>:
.globl vector106
vector106:
  pushl $0
80106b55:	6a 00                	push   $0x0
  pushl $106
80106b57:	6a 6a                	push   $0x6a
  jmp alltraps
80106b59:	e9 00 f7 ff ff       	jmp    8010625e <alltraps>

80106b5e <vector107>:
.globl vector107
vector107:
  pushl $0
80106b5e:	6a 00                	push   $0x0
  pushl $107
80106b60:	6a 6b                	push   $0x6b
  jmp alltraps
80106b62:	e9 f7 f6 ff ff       	jmp    8010625e <alltraps>

80106b67 <vector108>:
.globl vector108
vector108:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $108
80106b69:	6a 6c                	push   $0x6c
  jmp alltraps
80106b6b:	e9 ee f6 ff ff       	jmp    8010625e <alltraps>

80106b70 <vector109>:
.globl vector109
vector109:
  pushl $0
80106b70:	6a 00                	push   $0x0
  pushl $109
80106b72:	6a 6d                	push   $0x6d
  jmp alltraps
80106b74:	e9 e5 f6 ff ff       	jmp    8010625e <alltraps>

80106b79 <vector110>:
.globl vector110
vector110:
  pushl $0
80106b79:	6a 00                	push   $0x0
  pushl $110
80106b7b:	6a 6e                	push   $0x6e
  jmp alltraps
80106b7d:	e9 dc f6 ff ff       	jmp    8010625e <alltraps>

80106b82 <vector111>:
.globl vector111
vector111:
  pushl $0
80106b82:	6a 00                	push   $0x0
  pushl $111
80106b84:	6a 6f                	push   $0x6f
  jmp alltraps
80106b86:	e9 d3 f6 ff ff       	jmp    8010625e <alltraps>

80106b8b <vector112>:
.globl vector112
vector112:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $112
80106b8d:	6a 70                	push   $0x70
  jmp alltraps
80106b8f:	e9 ca f6 ff ff       	jmp    8010625e <alltraps>

80106b94 <vector113>:
.globl vector113
vector113:
  pushl $0
80106b94:	6a 00                	push   $0x0
  pushl $113
80106b96:	6a 71                	push   $0x71
  jmp alltraps
80106b98:	e9 c1 f6 ff ff       	jmp    8010625e <alltraps>

80106b9d <vector114>:
.globl vector114
vector114:
  pushl $0
80106b9d:	6a 00                	push   $0x0
  pushl $114
80106b9f:	6a 72                	push   $0x72
  jmp alltraps
80106ba1:	e9 b8 f6 ff ff       	jmp    8010625e <alltraps>

80106ba6 <vector115>:
.globl vector115
vector115:
  pushl $0
80106ba6:	6a 00                	push   $0x0
  pushl $115
80106ba8:	6a 73                	push   $0x73
  jmp alltraps
80106baa:	e9 af f6 ff ff       	jmp    8010625e <alltraps>

80106baf <vector116>:
.globl vector116
vector116:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $116
80106bb1:	6a 74                	push   $0x74
  jmp alltraps
80106bb3:	e9 a6 f6 ff ff       	jmp    8010625e <alltraps>

80106bb8 <vector117>:
.globl vector117
vector117:
  pushl $0
80106bb8:	6a 00                	push   $0x0
  pushl $117
80106bba:	6a 75                	push   $0x75
  jmp alltraps
80106bbc:	e9 9d f6 ff ff       	jmp    8010625e <alltraps>

80106bc1 <vector118>:
.globl vector118
vector118:
  pushl $0
80106bc1:	6a 00                	push   $0x0
  pushl $118
80106bc3:	6a 76                	push   $0x76
  jmp alltraps
80106bc5:	e9 94 f6 ff ff       	jmp    8010625e <alltraps>

80106bca <vector119>:
.globl vector119
vector119:
  pushl $0
80106bca:	6a 00                	push   $0x0
  pushl $119
80106bcc:	6a 77                	push   $0x77
  jmp alltraps
80106bce:	e9 8b f6 ff ff       	jmp    8010625e <alltraps>

80106bd3 <vector120>:
.globl vector120
vector120:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $120
80106bd5:	6a 78                	push   $0x78
  jmp alltraps
80106bd7:	e9 82 f6 ff ff       	jmp    8010625e <alltraps>

80106bdc <vector121>:
.globl vector121
vector121:
  pushl $0
80106bdc:	6a 00                	push   $0x0
  pushl $121
80106bde:	6a 79                	push   $0x79
  jmp alltraps
80106be0:	e9 79 f6 ff ff       	jmp    8010625e <alltraps>

80106be5 <vector122>:
.globl vector122
vector122:
  pushl $0
80106be5:	6a 00                	push   $0x0
  pushl $122
80106be7:	6a 7a                	push   $0x7a
  jmp alltraps
80106be9:	e9 70 f6 ff ff       	jmp    8010625e <alltraps>

80106bee <vector123>:
.globl vector123
vector123:
  pushl $0
80106bee:	6a 00                	push   $0x0
  pushl $123
80106bf0:	6a 7b                	push   $0x7b
  jmp alltraps
80106bf2:	e9 67 f6 ff ff       	jmp    8010625e <alltraps>

80106bf7 <vector124>:
.globl vector124
vector124:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $124
80106bf9:	6a 7c                	push   $0x7c
  jmp alltraps
80106bfb:	e9 5e f6 ff ff       	jmp    8010625e <alltraps>

80106c00 <vector125>:
.globl vector125
vector125:
  pushl $0
80106c00:	6a 00                	push   $0x0
  pushl $125
80106c02:	6a 7d                	push   $0x7d
  jmp alltraps
80106c04:	e9 55 f6 ff ff       	jmp    8010625e <alltraps>

80106c09 <vector126>:
.globl vector126
vector126:
  pushl $0
80106c09:	6a 00                	push   $0x0
  pushl $126
80106c0b:	6a 7e                	push   $0x7e
  jmp alltraps
80106c0d:	e9 4c f6 ff ff       	jmp    8010625e <alltraps>

80106c12 <vector127>:
.globl vector127
vector127:
  pushl $0
80106c12:	6a 00                	push   $0x0
  pushl $127
80106c14:	6a 7f                	push   $0x7f
  jmp alltraps
80106c16:	e9 43 f6 ff ff       	jmp    8010625e <alltraps>

80106c1b <vector128>:
.globl vector128
vector128:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $128
80106c1d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106c22:	e9 37 f6 ff ff       	jmp    8010625e <alltraps>

80106c27 <vector129>:
.globl vector129
vector129:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $129
80106c29:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106c2e:	e9 2b f6 ff ff       	jmp    8010625e <alltraps>

80106c33 <vector130>:
.globl vector130
vector130:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $130
80106c35:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106c3a:	e9 1f f6 ff ff       	jmp    8010625e <alltraps>

80106c3f <vector131>:
.globl vector131
vector131:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $131
80106c41:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106c46:	e9 13 f6 ff ff       	jmp    8010625e <alltraps>

80106c4b <vector132>:
.globl vector132
vector132:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $132
80106c4d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106c52:	e9 07 f6 ff ff       	jmp    8010625e <alltraps>

80106c57 <vector133>:
.globl vector133
vector133:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $133
80106c59:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106c5e:	e9 fb f5 ff ff       	jmp    8010625e <alltraps>

80106c63 <vector134>:
.globl vector134
vector134:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $134
80106c65:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106c6a:	e9 ef f5 ff ff       	jmp    8010625e <alltraps>

80106c6f <vector135>:
.globl vector135
vector135:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $135
80106c71:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106c76:	e9 e3 f5 ff ff       	jmp    8010625e <alltraps>

80106c7b <vector136>:
.globl vector136
vector136:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $136
80106c7d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106c82:	e9 d7 f5 ff ff       	jmp    8010625e <alltraps>

80106c87 <vector137>:
.globl vector137
vector137:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $137
80106c89:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106c8e:	e9 cb f5 ff ff       	jmp    8010625e <alltraps>

80106c93 <vector138>:
.globl vector138
vector138:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $138
80106c95:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106c9a:	e9 bf f5 ff ff       	jmp    8010625e <alltraps>

80106c9f <vector139>:
.globl vector139
vector139:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $139
80106ca1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ca6:	e9 b3 f5 ff ff       	jmp    8010625e <alltraps>

80106cab <vector140>:
.globl vector140
vector140:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $140
80106cad:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106cb2:	e9 a7 f5 ff ff       	jmp    8010625e <alltraps>

80106cb7 <vector141>:
.globl vector141
vector141:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $141
80106cb9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106cbe:	e9 9b f5 ff ff       	jmp    8010625e <alltraps>

80106cc3 <vector142>:
.globl vector142
vector142:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $142
80106cc5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106cca:	e9 8f f5 ff ff       	jmp    8010625e <alltraps>

80106ccf <vector143>:
.globl vector143
vector143:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $143
80106cd1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106cd6:	e9 83 f5 ff ff       	jmp    8010625e <alltraps>

80106cdb <vector144>:
.globl vector144
vector144:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $144
80106cdd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106ce2:	e9 77 f5 ff ff       	jmp    8010625e <alltraps>

80106ce7 <vector145>:
.globl vector145
vector145:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $145
80106ce9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106cee:	e9 6b f5 ff ff       	jmp    8010625e <alltraps>

80106cf3 <vector146>:
.globl vector146
vector146:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $146
80106cf5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106cfa:	e9 5f f5 ff ff       	jmp    8010625e <alltraps>

80106cff <vector147>:
.globl vector147
vector147:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $147
80106d01:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106d06:	e9 53 f5 ff ff       	jmp    8010625e <alltraps>

80106d0b <vector148>:
.globl vector148
vector148:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $148
80106d0d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106d12:	e9 47 f5 ff ff       	jmp    8010625e <alltraps>

80106d17 <vector149>:
.globl vector149
vector149:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $149
80106d19:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106d1e:	e9 3b f5 ff ff       	jmp    8010625e <alltraps>

80106d23 <vector150>:
.globl vector150
vector150:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $150
80106d25:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106d2a:	e9 2f f5 ff ff       	jmp    8010625e <alltraps>

80106d2f <vector151>:
.globl vector151
vector151:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $151
80106d31:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106d36:	e9 23 f5 ff ff       	jmp    8010625e <alltraps>

80106d3b <vector152>:
.globl vector152
vector152:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $152
80106d3d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d42:	e9 17 f5 ff ff       	jmp    8010625e <alltraps>

80106d47 <vector153>:
.globl vector153
vector153:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $153
80106d49:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106d4e:	e9 0b f5 ff ff       	jmp    8010625e <alltraps>

80106d53 <vector154>:
.globl vector154
vector154:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $154
80106d55:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106d5a:	e9 ff f4 ff ff       	jmp    8010625e <alltraps>

80106d5f <vector155>:
.globl vector155
vector155:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $155
80106d61:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106d66:	e9 f3 f4 ff ff       	jmp    8010625e <alltraps>

80106d6b <vector156>:
.globl vector156
vector156:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $156
80106d6d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d72:	e9 e7 f4 ff ff       	jmp    8010625e <alltraps>

80106d77 <vector157>:
.globl vector157
vector157:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $157
80106d79:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106d7e:	e9 db f4 ff ff       	jmp    8010625e <alltraps>

80106d83 <vector158>:
.globl vector158
vector158:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $158
80106d85:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106d8a:	e9 cf f4 ff ff       	jmp    8010625e <alltraps>

80106d8f <vector159>:
.globl vector159
vector159:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $159
80106d91:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106d96:	e9 c3 f4 ff ff       	jmp    8010625e <alltraps>

80106d9b <vector160>:
.globl vector160
vector160:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $160
80106d9d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106da2:	e9 b7 f4 ff ff       	jmp    8010625e <alltraps>

80106da7 <vector161>:
.globl vector161
vector161:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $161
80106da9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106dae:	e9 ab f4 ff ff       	jmp    8010625e <alltraps>

80106db3 <vector162>:
.globl vector162
vector162:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $162
80106db5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106dba:	e9 9f f4 ff ff       	jmp    8010625e <alltraps>

80106dbf <vector163>:
.globl vector163
vector163:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $163
80106dc1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106dc6:	e9 93 f4 ff ff       	jmp    8010625e <alltraps>

80106dcb <vector164>:
.globl vector164
vector164:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $164
80106dcd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106dd2:	e9 87 f4 ff ff       	jmp    8010625e <alltraps>

80106dd7 <vector165>:
.globl vector165
vector165:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $165
80106dd9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106dde:	e9 7b f4 ff ff       	jmp    8010625e <alltraps>

80106de3 <vector166>:
.globl vector166
vector166:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $166
80106de5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106dea:	e9 6f f4 ff ff       	jmp    8010625e <alltraps>

80106def <vector167>:
.globl vector167
vector167:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $167
80106df1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106df6:	e9 63 f4 ff ff       	jmp    8010625e <alltraps>

80106dfb <vector168>:
.globl vector168
vector168:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $168
80106dfd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106e02:	e9 57 f4 ff ff       	jmp    8010625e <alltraps>

80106e07 <vector169>:
.globl vector169
vector169:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $169
80106e09:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106e0e:	e9 4b f4 ff ff       	jmp    8010625e <alltraps>

80106e13 <vector170>:
.globl vector170
vector170:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $170
80106e15:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106e1a:	e9 3f f4 ff ff       	jmp    8010625e <alltraps>

80106e1f <vector171>:
.globl vector171
vector171:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $171
80106e21:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106e26:	e9 33 f4 ff ff       	jmp    8010625e <alltraps>

80106e2b <vector172>:
.globl vector172
vector172:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $172
80106e2d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106e32:	e9 27 f4 ff ff       	jmp    8010625e <alltraps>

80106e37 <vector173>:
.globl vector173
vector173:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $173
80106e39:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106e3e:	e9 1b f4 ff ff       	jmp    8010625e <alltraps>

80106e43 <vector174>:
.globl vector174
vector174:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $174
80106e45:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106e4a:	e9 0f f4 ff ff       	jmp    8010625e <alltraps>

80106e4f <vector175>:
.globl vector175
vector175:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $175
80106e51:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106e56:	e9 03 f4 ff ff       	jmp    8010625e <alltraps>

80106e5b <vector176>:
.globl vector176
vector176:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $176
80106e5d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106e62:	e9 f7 f3 ff ff       	jmp    8010625e <alltraps>

80106e67 <vector177>:
.globl vector177
vector177:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $177
80106e69:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106e6e:	e9 eb f3 ff ff       	jmp    8010625e <alltraps>

80106e73 <vector178>:
.globl vector178
vector178:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $178
80106e75:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106e7a:	e9 df f3 ff ff       	jmp    8010625e <alltraps>

80106e7f <vector179>:
.globl vector179
vector179:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $179
80106e81:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106e86:	e9 d3 f3 ff ff       	jmp    8010625e <alltraps>

80106e8b <vector180>:
.globl vector180
vector180:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $180
80106e8d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106e92:	e9 c7 f3 ff ff       	jmp    8010625e <alltraps>

80106e97 <vector181>:
.globl vector181
vector181:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $181
80106e99:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106e9e:	e9 bb f3 ff ff       	jmp    8010625e <alltraps>

80106ea3 <vector182>:
.globl vector182
vector182:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $182
80106ea5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106eaa:	e9 af f3 ff ff       	jmp    8010625e <alltraps>

80106eaf <vector183>:
.globl vector183
vector183:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $183
80106eb1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106eb6:	e9 a3 f3 ff ff       	jmp    8010625e <alltraps>

80106ebb <vector184>:
.globl vector184
vector184:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $184
80106ebd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106ec2:	e9 97 f3 ff ff       	jmp    8010625e <alltraps>

80106ec7 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $185
80106ec9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106ece:	e9 8b f3 ff ff       	jmp    8010625e <alltraps>

80106ed3 <vector186>:
.globl vector186
vector186:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $186
80106ed5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106eda:	e9 7f f3 ff ff       	jmp    8010625e <alltraps>

80106edf <vector187>:
.globl vector187
vector187:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $187
80106ee1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ee6:	e9 73 f3 ff ff       	jmp    8010625e <alltraps>

80106eeb <vector188>:
.globl vector188
vector188:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $188
80106eed:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106ef2:	e9 67 f3 ff ff       	jmp    8010625e <alltraps>

80106ef7 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $189
80106ef9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106efe:	e9 5b f3 ff ff       	jmp    8010625e <alltraps>

80106f03 <vector190>:
.globl vector190
vector190:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $190
80106f05:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106f0a:	e9 4f f3 ff ff       	jmp    8010625e <alltraps>

80106f0f <vector191>:
.globl vector191
vector191:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $191
80106f11:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106f16:	e9 43 f3 ff ff       	jmp    8010625e <alltraps>

80106f1b <vector192>:
.globl vector192
vector192:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $192
80106f1d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106f22:	e9 37 f3 ff ff       	jmp    8010625e <alltraps>

80106f27 <vector193>:
.globl vector193
vector193:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $193
80106f29:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106f2e:	e9 2b f3 ff ff       	jmp    8010625e <alltraps>

80106f33 <vector194>:
.globl vector194
vector194:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $194
80106f35:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106f3a:	e9 1f f3 ff ff       	jmp    8010625e <alltraps>

80106f3f <vector195>:
.globl vector195
vector195:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $195
80106f41:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106f46:	e9 13 f3 ff ff       	jmp    8010625e <alltraps>

80106f4b <vector196>:
.globl vector196
vector196:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $196
80106f4d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106f52:	e9 07 f3 ff ff       	jmp    8010625e <alltraps>

80106f57 <vector197>:
.globl vector197
vector197:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $197
80106f59:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106f5e:	e9 fb f2 ff ff       	jmp    8010625e <alltraps>

80106f63 <vector198>:
.globl vector198
vector198:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $198
80106f65:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106f6a:	e9 ef f2 ff ff       	jmp    8010625e <alltraps>

80106f6f <vector199>:
.globl vector199
vector199:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $199
80106f71:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106f76:	e9 e3 f2 ff ff       	jmp    8010625e <alltraps>

80106f7b <vector200>:
.globl vector200
vector200:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $200
80106f7d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106f82:	e9 d7 f2 ff ff       	jmp    8010625e <alltraps>

80106f87 <vector201>:
.globl vector201
vector201:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $201
80106f89:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106f8e:	e9 cb f2 ff ff       	jmp    8010625e <alltraps>

80106f93 <vector202>:
.globl vector202
vector202:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $202
80106f95:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106f9a:	e9 bf f2 ff ff       	jmp    8010625e <alltraps>

80106f9f <vector203>:
.globl vector203
vector203:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $203
80106fa1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106fa6:	e9 b3 f2 ff ff       	jmp    8010625e <alltraps>

80106fab <vector204>:
.globl vector204
vector204:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $204
80106fad:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106fb2:	e9 a7 f2 ff ff       	jmp    8010625e <alltraps>

80106fb7 <vector205>:
.globl vector205
vector205:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $205
80106fb9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106fbe:	e9 9b f2 ff ff       	jmp    8010625e <alltraps>

80106fc3 <vector206>:
.globl vector206
vector206:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $206
80106fc5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106fca:	e9 8f f2 ff ff       	jmp    8010625e <alltraps>

80106fcf <vector207>:
.globl vector207
vector207:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $207
80106fd1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106fd6:	e9 83 f2 ff ff       	jmp    8010625e <alltraps>

80106fdb <vector208>:
.globl vector208
vector208:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $208
80106fdd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106fe2:	e9 77 f2 ff ff       	jmp    8010625e <alltraps>

80106fe7 <vector209>:
.globl vector209
vector209:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $209
80106fe9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106fee:	e9 6b f2 ff ff       	jmp    8010625e <alltraps>

80106ff3 <vector210>:
.globl vector210
vector210:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $210
80106ff5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ffa:	e9 5f f2 ff ff       	jmp    8010625e <alltraps>

80106fff <vector211>:
.globl vector211
vector211:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $211
80107001:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107006:	e9 53 f2 ff ff       	jmp    8010625e <alltraps>

8010700b <vector212>:
.globl vector212
vector212:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $212
8010700d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107012:	e9 47 f2 ff ff       	jmp    8010625e <alltraps>

80107017 <vector213>:
.globl vector213
vector213:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $213
80107019:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010701e:	e9 3b f2 ff ff       	jmp    8010625e <alltraps>

80107023 <vector214>:
.globl vector214
vector214:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $214
80107025:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010702a:	e9 2f f2 ff ff       	jmp    8010625e <alltraps>

8010702f <vector215>:
.globl vector215
vector215:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $215
80107031:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107036:	e9 23 f2 ff ff       	jmp    8010625e <alltraps>

8010703b <vector216>:
.globl vector216
vector216:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $216
8010703d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107042:	e9 17 f2 ff ff       	jmp    8010625e <alltraps>

80107047 <vector217>:
.globl vector217
vector217:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $217
80107049:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010704e:	e9 0b f2 ff ff       	jmp    8010625e <alltraps>

80107053 <vector218>:
.globl vector218
vector218:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $218
80107055:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010705a:	e9 ff f1 ff ff       	jmp    8010625e <alltraps>

8010705f <vector219>:
.globl vector219
vector219:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $219
80107061:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107066:	e9 f3 f1 ff ff       	jmp    8010625e <alltraps>

8010706b <vector220>:
.globl vector220
vector220:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $220
8010706d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107072:	e9 e7 f1 ff ff       	jmp    8010625e <alltraps>

80107077 <vector221>:
.globl vector221
vector221:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $221
80107079:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010707e:	e9 db f1 ff ff       	jmp    8010625e <alltraps>

80107083 <vector222>:
.globl vector222
vector222:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $222
80107085:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010708a:	e9 cf f1 ff ff       	jmp    8010625e <alltraps>

8010708f <vector223>:
.globl vector223
vector223:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $223
80107091:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107096:	e9 c3 f1 ff ff       	jmp    8010625e <alltraps>

8010709b <vector224>:
.globl vector224
vector224:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $224
8010709d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801070a2:	e9 b7 f1 ff ff       	jmp    8010625e <alltraps>

801070a7 <vector225>:
.globl vector225
vector225:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $225
801070a9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801070ae:	e9 ab f1 ff ff       	jmp    8010625e <alltraps>

801070b3 <vector226>:
.globl vector226
vector226:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $226
801070b5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801070ba:	e9 9f f1 ff ff       	jmp    8010625e <alltraps>

801070bf <vector227>:
.globl vector227
vector227:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $227
801070c1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801070c6:	e9 93 f1 ff ff       	jmp    8010625e <alltraps>

801070cb <vector228>:
.globl vector228
vector228:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $228
801070cd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801070d2:	e9 87 f1 ff ff       	jmp    8010625e <alltraps>

801070d7 <vector229>:
.globl vector229
vector229:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $229
801070d9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801070de:	e9 7b f1 ff ff       	jmp    8010625e <alltraps>

801070e3 <vector230>:
.globl vector230
vector230:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $230
801070e5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801070ea:	e9 6f f1 ff ff       	jmp    8010625e <alltraps>

801070ef <vector231>:
.globl vector231
vector231:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $231
801070f1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801070f6:	e9 63 f1 ff ff       	jmp    8010625e <alltraps>

801070fb <vector232>:
.globl vector232
vector232:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $232
801070fd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107102:	e9 57 f1 ff ff       	jmp    8010625e <alltraps>

80107107 <vector233>:
.globl vector233
vector233:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $233
80107109:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010710e:	e9 4b f1 ff ff       	jmp    8010625e <alltraps>

80107113 <vector234>:
.globl vector234
vector234:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $234
80107115:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010711a:	e9 3f f1 ff ff       	jmp    8010625e <alltraps>

8010711f <vector235>:
.globl vector235
vector235:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $235
80107121:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107126:	e9 33 f1 ff ff       	jmp    8010625e <alltraps>

8010712b <vector236>:
.globl vector236
vector236:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $236
8010712d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107132:	e9 27 f1 ff ff       	jmp    8010625e <alltraps>

80107137 <vector237>:
.globl vector237
vector237:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $237
80107139:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010713e:	e9 1b f1 ff ff       	jmp    8010625e <alltraps>

80107143 <vector238>:
.globl vector238
vector238:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $238
80107145:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010714a:	e9 0f f1 ff ff       	jmp    8010625e <alltraps>

8010714f <vector239>:
.globl vector239
vector239:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $239
80107151:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107156:	e9 03 f1 ff ff       	jmp    8010625e <alltraps>

8010715b <vector240>:
.globl vector240
vector240:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $240
8010715d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107162:	e9 f7 f0 ff ff       	jmp    8010625e <alltraps>

80107167 <vector241>:
.globl vector241
vector241:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $241
80107169:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010716e:	e9 eb f0 ff ff       	jmp    8010625e <alltraps>

80107173 <vector242>:
.globl vector242
vector242:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $242
80107175:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010717a:	e9 df f0 ff ff       	jmp    8010625e <alltraps>

8010717f <vector243>:
.globl vector243
vector243:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $243
80107181:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107186:	e9 d3 f0 ff ff       	jmp    8010625e <alltraps>

8010718b <vector244>:
.globl vector244
vector244:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $244
8010718d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107192:	e9 c7 f0 ff ff       	jmp    8010625e <alltraps>

80107197 <vector245>:
.globl vector245
vector245:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $245
80107199:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010719e:	e9 bb f0 ff ff       	jmp    8010625e <alltraps>

801071a3 <vector246>:
.globl vector246
vector246:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $246
801071a5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801071aa:	e9 af f0 ff ff       	jmp    8010625e <alltraps>

801071af <vector247>:
.globl vector247
vector247:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $247
801071b1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801071b6:	e9 a3 f0 ff ff       	jmp    8010625e <alltraps>

801071bb <vector248>:
.globl vector248
vector248:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $248
801071bd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801071c2:	e9 97 f0 ff ff       	jmp    8010625e <alltraps>

801071c7 <vector249>:
.globl vector249
vector249:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $249
801071c9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801071ce:	e9 8b f0 ff ff       	jmp    8010625e <alltraps>

801071d3 <vector250>:
.globl vector250
vector250:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $250
801071d5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801071da:	e9 7f f0 ff ff       	jmp    8010625e <alltraps>

801071df <vector251>:
.globl vector251
vector251:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $251
801071e1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801071e6:	e9 73 f0 ff ff       	jmp    8010625e <alltraps>

801071eb <vector252>:
.globl vector252
vector252:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $252
801071ed:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801071f2:	e9 67 f0 ff ff       	jmp    8010625e <alltraps>

801071f7 <vector253>:
.globl vector253
vector253:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $253
801071f9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801071fe:	e9 5b f0 ff ff       	jmp    8010625e <alltraps>

80107203 <vector254>:
.globl vector254
vector254:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $254
80107205:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010720a:	e9 4f f0 ff ff       	jmp    8010625e <alltraps>

8010720f <vector255>:
.globl vector255
vector255:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $255
80107211:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107216:	e9 43 f0 ff ff       	jmp    8010625e <alltraps>
8010721b:	66 90                	xchg   %ax,%ax
8010721d:	66 90                	xchg   %ax,%ax
8010721f:	90                   	nop

80107220 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	57                   	push   %edi
80107224:	56                   	push   %esi
80107225:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107227:	c1 ea 16             	shr    $0x16,%edx
{
8010722a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010722b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010722e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107231:	8b 1f                	mov    (%edi),%ebx
80107233:	f6 c3 01             	test   $0x1,%bl
80107236:	74 28                	je     80107260 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107238:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010723e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107244:	89 f0                	mov    %esi,%eax
}
80107246:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107249:	c1 e8 0a             	shr    $0xa,%eax
8010724c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107251:	01 d8                	add    %ebx,%eax
}
80107253:	5b                   	pop    %ebx
80107254:	5e                   	pop    %esi
80107255:	5f                   	pop    %edi
80107256:	5d                   	pop    %ebp
80107257:	c3                   	ret    
80107258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010725f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107260:	85 c9                	test   %ecx,%ecx
80107262:	74 2c                	je     80107290 <walkpgdir+0x70>
80107264:	e8 f7 ba ff ff       	call   80102d60 <kalloc>
80107269:	89 c3                	mov    %eax,%ebx
8010726b:	85 c0                	test   %eax,%eax
8010726d:	74 21                	je     80107290 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010726f:	83 ec 04             	sub    $0x4,%esp
80107272:	68 00 10 00 00       	push   $0x1000
80107277:	6a 00                	push   $0x0
80107279:	50                   	push   %eax
8010727a:	e8 c1 dd ff ff       	call   80105040 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010727f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107285:	83 c4 10             	add    $0x10,%esp
80107288:	83 c8 07             	or     $0x7,%eax
8010728b:	89 07                	mov    %eax,(%edi)
8010728d:	eb b5                	jmp    80107244 <walkpgdir+0x24>
8010728f:	90                   	nop
}
80107290:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107293:	31 c0                	xor    %eax,%eax
}
80107295:	5b                   	pop    %ebx
80107296:	5e                   	pop    %esi
80107297:	5f                   	pop    %edi
80107298:	5d                   	pop    %ebp
80107299:	c3                   	ret    
8010729a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072a0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072a6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801072aa:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801072b0:	89 d6                	mov    %edx,%esi
{
801072b2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801072b3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801072b9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072bf:	8b 45 08             	mov    0x8(%ebp),%eax
801072c2:	29 f0                	sub    %esi,%eax
801072c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072c7:	eb 1f                	jmp    801072e8 <mappages+0x48>
801072c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801072d0:	f6 00 01             	testb  $0x1,(%eax)
801072d3:	75 45                	jne    8010731a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801072d5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801072d8:	83 cb 01             	or     $0x1,%ebx
801072db:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801072dd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801072e0:	74 2e                	je     80107310 <mappages+0x70>
      break;
    a += PGSIZE;
801072e2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801072e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801072eb:	b9 01 00 00 00       	mov    $0x1,%ecx
801072f0:	89 f2                	mov    %esi,%edx
801072f2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801072f5:	89 f8                	mov    %edi,%eax
801072f7:	e8 24 ff ff ff       	call   80107220 <walkpgdir>
801072fc:	85 c0                	test   %eax,%eax
801072fe:	75 d0                	jne    801072d0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107300:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107308:	5b                   	pop    %ebx
80107309:	5e                   	pop    %esi
8010730a:	5f                   	pop    %edi
8010730b:	5d                   	pop    %ebp
8010730c:	c3                   	ret    
8010730d:	8d 76 00             	lea    0x0(%esi),%esi
80107310:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107313:	31 c0                	xor    %eax,%eax
}
80107315:	5b                   	pop    %ebx
80107316:	5e                   	pop    %esi
80107317:	5f                   	pop    %edi
80107318:	5d                   	pop    %ebp
80107319:	c3                   	ret    
      panic("remap");
8010731a:	83 ec 0c             	sub    $0xc,%esp
8010731d:	68 cc 8a 10 80       	push   $0x80108acc
80107322:	e8 69 90 ff ff       	call   80100390 <panic>
80107327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010732e:	66 90                	xchg   %ax,%ax

80107330 <find_page_to_swap1>:
struct pageinfo* find_page_to_swap1(struct proc* p){
80107330:	f3 0f 1e fb          	endbr32 
80107334:	55                   	push   %ebp
80107335:	89 e5                	mov    %esp,%ebp
80107337:	57                   	push   %edi
80107338:	56                   	push   %esi
80107339:	53                   	push   %ebx
8010733a:	83 ec 1c             	sub    $0x1c,%esp
8010733d:	8b 75 08             	mov    0x8(%ebp),%esi
80107340:	8d 86 00 02 00 00    	lea    0x200(%esi),%eax
80107346:	8d 9e 80 03 00 00    	lea    0x380(%esi),%ebx
8010734c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010734f:	90                   	nop
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107350:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    struct pageinfo* min_pi = 0;
80107353:	31 ff                	xor    %edi,%edi
    uint min = 0xFFFFFFFF;
80107355:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
8010735a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (!pi->is_free && pi->page_index < min){
80107360:	8b 10                	mov    (%eax),%edx
80107362:	85 d2                	test   %edx,%edx
80107364:	75 0b                	jne    80107371 <find_page_to_swap1+0x41>
80107366:	8b 50 0c             	mov    0xc(%eax),%edx
80107369:	39 ca                	cmp    %ecx,%edx
8010736b:	73 04                	jae    80107371 <find_page_to_swap1+0x41>
8010736d:	89 c7                	mov    %eax,%edi
8010736f:	89 d1                	mov    %edx,%ecx
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107371:	83 c0 18             	add    $0x18,%eax
80107374:	39 c3                	cmp    %eax,%ebx
80107376:	75 e8                	jne    80107360 <find_page_to_swap1+0x30>
    pte_t* pte = walkpgdir(p->pgdir, min_pi, 0);
80107378:	8b 46 04             	mov    0x4(%esi),%eax
8010737b:	31 c9                	xor    %ecx,%ecx
8010737d:	89 fa                	mov    %edi,%edx
8010737f:	e8 9c fe ff ff       	call   80107220 <walkpgdir>
    if (*pte & PTE_A){
80107384:	f6 00 20             	testb  $0x20,(%eax)
80107387:	74 17                	je     801073a0 <find_page_to_swap1+0x70>
      min_pi->page_index = (++page_counter);
80107389:	8b 0d c0 b5 10 80    	mov    0x8010b5c0,%ecx
8010738f:	8d 51 01             	lea    0x1(%ecx),%edx
80107392:	89 15 c0 b5 10 80    	mov    %edx,0x8010b5c0
80107398:	89 57 0c             	mov    %edx,0xc(%edi)
      *pte &= ~PTE_A;
8010739b:	83 20 df             	andl   $0xffffffdf,(%eax)
  while(1){
8010739e:	eb b0                	jmp    80107350 <find_page_to_swap1+0x20>
}
801073a0:	83 c4 1c             	add    $0x1c,%esp
801073a3:	89 f8                	mov    %edi,%eax
801073a5:	5b                   	pop    %ebx
801073a6:	5e                   	pop    %esi
801073a7:	5f                   	pop    %edi
801073a8:	5d                   	pop    %ebp
801073a9:	c3                   	ret    
801073aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073b0 <find_page_to_swap>:
struct pageinfo* find_page_to_swap(struct proc* p){
801073b0:	f3 0f 1e fb          	endbr32 
801073b4:	55                   	push   %ebp
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
801073b5:	31 c0                	xor    %eax,%eax
struct pageinfo* find_page_to_swap(struct proc* p){
801073b7:	89 e5                	mov    %esp,%ebp
801073b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801073bc:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801073c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (!p->ram_pages[i].is_free){
801073c8:	83 3a 00             	cmpl   $0x0,(%edx)
801073cb:	74 13                	je     801073e0 <find_page_to_swap+0x30>
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
801073cd:	83 c0 01             	add    $0x1,%eax
801073d0:	83 c2 18             	add    $0x18,%edx
801073d3:	83 f8 10             	cmp    $0x10,%eax
801073d6:	75 f0                	jne    801073c8 <find_page_to_swap+0x18>
  return 0;
801073d8:	31 c0                	xor    %eax,%eax
}
801073da:	5d                   	pop    %ebp
801073db:	c3                   	ret    
801073dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return &p->ram_pages[i];
801073e0:	8d 04 40             	lea    (%eax,%eax,2),%eax
}
801073e3:	5d                   	pop    %ebp
      return &p->ram_pages[i];
801073e4:	8d 84 c1 00 02 00 00 	lea    0x200(%ecx,%eax,8),%eax
}
801073eb:	c3                   	ret    
801073ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801073f0 <seginit>:
{
801073f0:	f3 0f 1e fb          	endbr32 
801073f4:	55                   	push   %ebp
801073f5:	89 e5                	mov    %esp,%ebp
801073f7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801073fa:	e8 e1 cc ff ff       	call   801040e0 <cpuid>
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
80107491:	e9 8a fd ff ff       	jmp    80107220 <walkpgdir>
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
801074ee:	e8 3d d9 ff ff       	call   80104e30 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801074f3:	e8 78 cb ff ff       	call   80104070 <mycpu>
801074f8:	89 c3                	mov    %eax,%ebx
801074fa:	e8 71 cb ff ff       	call   80104070 <mycpu>
801074ff:	89 c7                	mov    %eax,%edi
80107501:	e8 6a cb ff ff       	call   80104070 <mycpu>
80107506:	83 c7 08             	add    $0x8,%edi
80107509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010750c:	e8 5f cb ff ff       	call   80104070 <mycpu>
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
80107555:	e8 16 cb ff ff       	call   80104070 <mycpu>
8010755a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107561:	e8 0a cb ff ff       	call   80104070 <mycpu>
80107566:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010756a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010756d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107573:	e8 f8 ca ff ff       	call   80104070 <mycpu>
80107578:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010757b:	e8 f0 ca ff ff       	call   80104070 <mycpu>
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
8010759e:	e9 dd d8 ff ff       	jmp    80104e80 <popcli>
    panic("switchuvm: no process");
801075a3:	83 ec 0c             	sub    $0xc,%esp
801075a6:	68 d2 8a 10 80       	push   $0x80108ad2
801075ab:	e8 e0 8d ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801075b0:	83 ec 0c             	sub    $0xc,%esp
801075b3:	68 fd 8a 10 80       	push   $0x80108afd
801075b8:	e8 d3 8d ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801075bd:	83 ec 0c             	sub    $0xc,%esp
801075c0:	68 e8 8a 10 80       	push   $0x80108ae8
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
801075f1:	e8 6a b7 ff ff       	call   80102d60 <kalloc>
  memset(mem, 0, PGSIZE);
801075f6:	83 ec 04             	sub    $0x4,%esp
801075f9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801075fe:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107600:	6a 00                	push   $0x0
80107602:	50                   	push   %eax
80107603:	e8 38 da ff ff       	call   80105040 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107608:	58                   	pop    %eax
80107609:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010760f:	5a                   	pop    %edx
80107610:	6a 06                	push   $0x6
80107612:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107617:	31 d2                	xor    %edx,%edx
80107619:	50                   	push   %eax
8010761a:	89 f8                	mov    %edi,%eax
8010761c:	e8 7f fc ff ff       	call   801072a0 <mappages>
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
80107637:	e9 a4 da ff ff       	jmp    801050e0 <memmove>
    panic("inituvm: more than a page");
8010763c:	83 ec 0c             	sub    $0xc,%esp
8010763f:	68 11 8b 10 80       	push   $0x80108b11
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
801076a0:	e8 7b fb ff ff       	call   80107220 <walkpgdir>
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
801076ce:	e8 3d a7 ff ff       	call   80101e10 <readi>
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
801076fd:	68 2b 8b 10 80       	push   $0x80108b2b
80107702:	e8 89 8c ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107707:	83 ec 0c             	sub    $0xc,%esp
8010770a:	68 14 8c 10 80       	push   $0x80108c14
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
80107730:	e8 cb c9 ff ff       	call   80104100 <myproc>
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
8010777a:	e8 21 b4 ff ff       	call   80102ba0 <kfree>
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
801077a7:	e8 74 fa ff ff       	call   80107220 <walkpgdir>
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
80107825:	68 4a 84 10 80       	push   $0x8010844a
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
80107840:	e8 bb c8 ff ff       	call   80104100 <myproc>
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
80107896:	e8 05 b3 ff ff       	call   80102ba0 <kfree>
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
801078ac:	e9 ef b2 ff ff       	jmp    80102ba0 <kfree>
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
80107932:	68 49 8b 10 80       	push   $0x80108b49
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
80107949:	e8 12 b4 ff ff       	call   80102d60 <kalloc>
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
80107964:	e8 d7 d6 ff ff       	call   80105040 <memset>
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
8010797f:	e8 1c f9 ff ff       	call   801072a0 <mappages>
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
801079f2:	e8 29 f8 ff ff       	call   80107220 <walkpgdir>
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
80107a03:	68 5a 8b 10 80       	push   $0x80108b5a
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
80107a27:	0f 84 9e 00 00 00    	je     80107acb <copyuvm+0xbb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107a2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107a30:	85 c9                	test   %ecx,%ecx
80107a32:	0f 84 93 00 00 00    	je     80107acb <copyuvm+0xbb>
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
80107a50:	e8 8b d6 ff ff       	call   801050e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107a55:	58                   	pop    %eax
80107a56:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a5c:	5a                   	pop    %edx
80107a5d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107a60:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a65:	89 f2                	mov    %esi,%edx
80107a67:	50                   	push   %eax
80107a68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a6b:	e8 30 f8 ff ff       	call   801072a0 <mappages>
80107a70:	83 c4 10             	add    $0x10,%esp
80107a73:	85 c0                	test   %eax,%eax
80107a75:	78 69                	js     80107ae0 <copyuvm+0xd0>
  for(i = 0; i < sz; i += PGSIZE){
80107a77:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a7d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107a80:	76 49                	jbe    80107acb <copyuvm+0xbb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a82:	8b 45 08             	mov    0x8(%ebp),%eax
80107a85:	31 c9                	xor    %ecx,%ecx
80107a87:	89 f2                	mov    %esi,%edx
80107a89:	e8 92 f7 ff ff       	call   80107220 <walkpgdir>
80107a8e:	85 c0                	test   %eax,%eax
80107a90:	74 69                	je     80107afb <copyuvm+0xeb>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80107a92:	8b 00                	mov    (%eax),%eax
80107a94:	a9 01 02 00 00       	test   $0x201,%eax
80107a99:	74 53                	je     80107aee <copyuvm+0xde>
    pa = PTE_ADDR(*pte);
80107a9b:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107a9d:	25 ff 0f 00 00       	and    $0xfff,%eax
80107aa2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107aa5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107aab:	e8 b0 b2 ff ff       	call   80102d60 <kalloc>
80107ab0:	89 c3                	mov    %eax,%ebx
80107ab2:	85 c0                	test   %eax,%eax
80107ab4:	75 8a                	jne    80107a40 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107ab6:	83 ec 0c             	sub    $0xc,%esp
80107ab9:	ff 75 e0             	pushl  -0x20(%ebp)
80107abc:	e8 6f fd ff ff       	call   80107830 <freevm>
  return 0;
80107ac1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107ac8:	83 c4 10             	add    $0x10,%esp
}
80107acb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ace:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ad1:	5b                   	pop    %ebx
80107ad2:	5e                   	pop    %esi
80107ad3:	5f                   	pop    %edi
80107ad4:	5d                   	pop    %ebp
80107ad5:	c3                   	ret    
80107ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107add:	8d 76 00             	lea    0x0(%esi),%esi
      kfree(mem);
80107ae0:	83 ec 0c             	sub    $0xc,%esp
80107ae3:	53                   	push   %ebx
80107ae4:	e8 b7 b0 ff ff       	call   80102ba0 <kfree>
      goto bad;
80107ae9:	83 c4 10             	add    $0x10,%esp
80107aec:	eb c8                	jmp    80107ab6 <copyuvm+0xa6>
      panic("copyuvm: page not present");
80107aee:	83 ec 0c             	sub    $0xc,%esp
80107af1:	68 7e 8b 10 80       	push   $0x80108b7e
80107af6:	e8 95 88 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107afb:	83 ec 0c             	sub    $0xc,%esp
80107afe:	68 64 8b 10 80       	push   $0x80108b64
80107b03:	e8 88 88 ff ff       	call   80100390 <panic>
80107b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b0f:	90                   	nop

80107b10 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107b10:	f3 0f 1e fb          	endbr32 
80107b14:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b15:	31 c9                	xor    %ecx,%ecx
{
80107b17:	89 e5                	mov    %esp,%ebp
80107b19:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80107b22:	e8 f9 f6 ff ff       	call   80107220 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107b27:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107b29:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107b2a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107b31:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b34:	05 00 00 00 80       	add    $0x80000000,%eax
80107b39:	83 fa 05             	cmp    $0x5,%edx
80107b3c:	ba 00 00 00 00       	mov    $0x0,%edx
80107b41:	0f 45 c2             	cmovne %edx,%eax
}
80107b44:	c3                   	ret    
80107b45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107b50 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107b50:	f3 0f 1e fb          	endbr32 
80107b54:	55                   	push   %ebp
80107b55:	89 e5                	mov    %esp,%ebp
80107b57:	57                   	push   %edi
80107b58:	56                   	push   %esi
80107b59:	53                   	push   %ebx
80107b5a:	83 ec 0c             	sub    $0xc,%esp
80107b5d:	8b 75 14             	mov    0x14(%ebp),%esi
80107b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107b63:	85 f6                	test   %esi,%esi
80107b65:	75 3c                	jne    80107ba3 <copyout+0x53>
80107b67:	eb 67                	jmp    80107bd0 <copyout+0x80>
80107b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107b70:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b73:	89 fb                	mov    %edi,%ebx
80107b75:	29 d3                	sub    %edx,%ebx
80107b77:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107b7d:	39 f3                	cmp    %esi,%ebx
80107b7f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107b82:	29 fa                	sub    %edi,%edx
80107b84:	83 ec 04             	sub    $0x4,%esp
80107b87:	01 c2                	add    %eax,%edx
80107b89:	53                   	push   %ebx
80107b8a:	ff 75 10             	pushl  0x10(%ebp)
80107b8d:	52                   	push   %edx
80107b8e:	e8 4d d5 ff ff       	call   801050e0 <memmove>
    len -= n;
    buf += n;
80107b93:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107b96:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107b9c:	83 c4 10             	add    $0x10,%esp
80107b9f:	29 de                	sub    %ebx,%esi
80107ba1:	74 2d                	je     80107bd0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107ba3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ba5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107ba8:	89 55 0c             	mov    %edx,0xc(%ebp)
80107bab:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107bb1:	57                   	push   %edi
80107bb2:	ff 75 08             	pushl  0x8(%ebp)
80107bb5:	e8 56 ff ff ff       	call   80107b10 <uva2ka>
    if(pa0 == 0)
80107bba:	83 c4 10             	add    $0x10,%esp
80107bbd:	85 c0                	test   %eax,%eax
80107bbf:	75 af                	jne    80107b70 <copyout+0x20>
  }
  return 0;
}
80107bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bc9:	5b                   	pop    %ebx
80107bca:	5e                   	pop    %esi
80107bcb:	5f                   	pop    %edi
80107bcc:	5d                   	pop    %ebp
80107bcd:	c3                   	ret    
80107bce:	66 90                	xchg   %ax,%ax
80107bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107bd3:	31 c0                	xor    %eax,%eax
}
80107bd5:	5b                   	pop    %ebx
80107bd6:	5e                   	pop    %esi
80107bd7:	5f                   	pop    %edi
80107bd8:	5d                   	pop    %ebp
80107bd9:	c3                   	ret    
80107bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107be0 <swap_out>:
//  if buffer == 0 then we put buffer <-- kernel_va(page_to_swap->va)  // p2v(phiscal(va))
//  and use buffer to swap out from
//  we assume that if buffer is not 0, it is kernel virtual address
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir){
80107be0:	f3 0f 1e fb          	endbr32 
80107be4:	55                   	push   %ebp
80107be5:	89 e5                	mov    %esp,%ebp
80107be7:	57                   	push   %edi
80107be8:	56                   	push   %esi
80107be9:	53                   	push   %ebx
80107bea:	83 ec 1c             	sub    $0x1c,%esp
80107bed:	8b 7d 10             	mov    0x10(%ebp),%edi
80107bf0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80107bf3:	8b 75 0c             	mov    0xc(%ebp),%esi
  if (buffer == 0){
80107bf6:	85 ff                	test   %edi,%edi
80107bf8:	0f 84 c2 00 00 00    	je     80107cc0 <swap_out+0xe0>
    buffer = P2V((PTE_ADDR(*(walkpgdir(pgdir, page_to_swap->va, 0)))));
  }
  // swap page
  // INV  : cell swapped_out_pages[i] is free iff there isnt a page that is written in offset i * PGSIZE in the swap file
  int index;
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107bfe:	8d 93 80 00 00 00    	lea    0x80(%ebx),%edx
80107c04:	31 c0                	xor    %eax,%eax
80107c06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c0d:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->swapped_out_pages[index].is_free){
80107c10:	8b 0a                	mov    (%edx),%ecx
80107c12:	85 c9                	test   %ecx,%ecx
80107c14:	75 1a                	jne    80107c30 <swap_out+0x50>
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107c16:	83 c0 01             	add    $0x1,%eax
80107c19:	83 c2 18             	add    $0x18,%edx
80107c1c:	83 f8 10             	cmp    $0x10,%eax
80107c1f:	75 ef                	jne    80107c10 <swap_out+0x30>
      p->swapped_out_pages[index].swap_file_offset = index * PGSIZE;
      break;
    }
  }
  if (index < 0 || index > 15){
    panic("we have a bug\n");
80107c21:	83 ec 0c             	sub    $0xc,%esp
80107c24:	68 a9 8b 10 80       	push   $0x80108ba9
80107c29:	e8 62 87 ff ff       	call   80100390 <panic>
80107c2e:	66 90                	xchg   %ax,%ax
      p->swapped_out_pages[index].is_free = 0;
80107c30:	8d 14 40             	lea    (%eax,%eax,2),%edx
      p->swapped_out_pages[index].swap_file_offset = index * PGSIZE;
80107c33:	c1 e0 0c             	shl    $0xc,%eax
      p->swapped_out_pages[index].is_free = 0;
80107c36:	8d 14 d3             	lea    (%ebx,%edx,8),%edx
80107c39:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
80107c40:	00 00 00 
      p->swapped_out_pages[index].va = page_to_swap->va;
80107c43:	8b 4e 10             	mov    0x10(%esi),%ecx
      p->swapped_out_pages[index].swap_file_offset = index * PGSIZE;
80107c46:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
      p->swapped_out_pages[index].va = page_to_swap->va;
80107c4c:	89 8a 90 00 00 00    	mov    %ecx,0x90(%edx)
  }
  int result = writeToSwapFile(p, buffer, index * PGSIZE, PGSIZE);
80107c52:	68 00 10 00 00       	push   $0x1000
80107c57:	50                   	push   %eax
80107c58:	57                   	push   %edi
80107c59:	53                   	push   %ebx
80107c5a:	e8 e1 aa ff ff       	call   80102740 <writeToSwapFile>


  
  // update flags in PTE
  pte_t* pte_ptr = walkpgdir(pgdir, page_to_swap->va, 0);
80107c5f:	8b 56 10             	mov    0x10(%esi),%edx
80107c62:	31 c9                	xor    %ecx,%ecx
  int result = writeToSwapFile(p, buffer, index * PGSIZE, PGSIZE);
80107c64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pte_t* pte_ptr = walkpgdir(pgdir, page_to_swap->va, 0);
80107c67:	8b 45 14             	mov    0x14(%ebp),%eax
80107c6a:	e8 b1 f5 ff ff       	call   80107220 <walkpgdir>
  *pte_ptr |= PTE_PG;
  *pte_ptr &= ~PTE_P;
  *pte_ptr |= PTE_U;
80107c6f:	8b 10                	mov    (%eax),%edx
80107c71:	83 e2 fe             	and    $0xfffffffe,%edx
80107c74:	81 ca 04 02 00 00    	or     $0x204,%edx
80107c7a:	89 10                	mov    %edx,(%eax)
  kfree(buffer);
80107c7c:	89 3c 24             	mov    %edi,(%esp)
80107c7f:	e8 1c af ff ff       	call   80102ba0 <kfree>
  // refresh cr3
  lcr3(V2P(p->pgdir));
80107c84:	8b 4b 04             	mov    0x4(%ebx),%ecx
80107c87:	8d 81 00 00 00 80    	lea    -0x80000000(%ecx),%eax
80107c8d:	0f 22 d8             	mov    %eax,%cr3
  page_to_swap->is_free = 1;
  if (result < 0){
80107c90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  page_to_swap->is_free = 1;
80107c93:	c7 06 01 00 00 00    	movl   $0x1,(%esi)
  if (result < 0){
80107c99:	83 c4 10             	add    $0x10,%esp
80107c9c:	85 c0                	test   %eax,%eax
80107c9e:	78 3f                	js     80107cdf <swap_out+0xff>
    panic("swap out failed\n");
  }
  p->num_of_pages_in_swap_file++;
80107ca0:	83 83 80 03 00 00 01 	addl   $0x1,0x380(%ebx)
  p->num_of_pageOut_occured++;
80107ca7:	83 83 8c 03 00 00 01 	addl   $0x1,0x38c(%ebx)
  p->num_of_actual_pages_in_mem--;
80107cae:	83 ab 84 03 00 00 01 	subl   $0x1,0x384(%ebx)
}
80107cb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cb8:	5b                   	pop    %ebx
80107cb9:	5e                   	pop    %esi
80107cba:	5f                   	pop    %edi
80107cbb:	5d                   	pop    %ebp
80107cbc:	c3                   	ret    
80107cbd:	8d 76 00             	lea    0x0(%esi),%esi
    buffer = P2V((PTE_ADDR(*(walkpgdir(pgdir, page_to_swap->va, 0)))));
80107cc0:	8b 56 10             	mov    0x10(%esi),%edx
80107cc3:	8b 45 14             	mov    0x14(%ebp),%eax
80107cc6:	31 c9                	xor    %ecx,%ecx
80107cc8:	e8 53 f5 ff ff       	call   80107220 <walkpgdir>
80107ccd:	8b 00                	mov    (%eax),%eax
80107ccf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cd4:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
80107cda:	e9 1f ff ff ff       	jmp    80107bfe <swap_out+0x1e>
    panic("swap out failed\n");
80107cdf:	83 ec 0c             	sub    $0xc,%esp
80107ce2:	68 98 8b 10 80       	push   $0x80108b98
80107ce7:	e8 a4 86 ff ff       	call   80100390 <panic>
80107cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107cf0 <allocuvm>:
{
80107cf0:	f3 0f 1e fb          	endbr32 
80107cf4:	55                   	push   %ebp
80107cf5:	89 e5                	mov    %esp,%ebp
80107cf7:	57                   	push   %edi
80107cf8:	56                   	push   %esi
80107cf9:	53                   	push   %ebx
80107cfa:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* p = myproc();
80107cfd:	e8 fe c3 ff ff       	call   80104100 <myproc>
80107d02:	89 c7                	mov    %eax,%edi
  if(newsz >= KERNBASE)
80107d04:	8b 45 10             	mov    0x10(%ebp),%eax
80107d07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107d0a:	85 c0                	test   %eax,%eax
80107d0c:	0f 88 96 01 00 00    	js     80107ea8 <allocuvm+0x1b8>
  if(newsz < oldsz)
80107d12:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107d18:	0f 82 f2 00 00 00    	jb     80107e10 <allocuvm+0x120>
  a = PGROUNDUP(oldsz);
80107d1e:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107d24:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107d2a:	39 75 10             	cmp    %esi,0x10(%ebp)
80107d2d:	0f 86 e0 00 00 00    	jbe    80107e13 <allocuvm+0x123>
80107d33:	8b 4f 10             	mov    0x10(%edi),%ecx
80107d36:	eb 17                	jmp    80107d4f <allocuvm+0x5f>
80107d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d3f:	90                   	nop
80107d40:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107d46:	39 75 10             	cmp    %esi,0x10(%ebp)
80107d49:	0f 86 c4 00 00 00    	jbe    80107e13 <allocuvm+0x123>
    if (p->pid > 2){
80107d4f:	83 f9 02             	cmp    $0x2,%ecx
80107d52:	7e 18                	jle    80107d6c <allocuvm+0x7c>
      p->num_of_actual_pages_in_mem++;
80107d54:	8b 87 84 03 00 00    	mov    0x384(%edi),%eax
80107d5a:	83 c0 01             	add    $0x1,%eax
80107d5d:	89 87 84 03 00 00    	mov    %eax,0x384(%edi)
      if (p->num_of_actual_pages_in_mem >= 16){
80107d63:	83 f8 0f             	cmp    $0xf,%eax
80107d66:	0f 87 b4 00 00 00    	ja     80107e20 <allocuvm+0x130>
    mem = kalloc();
80107d6c:	e8 ef af ff ff       	call   80102d60 <kalloc>
80107d71:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107d73:	85 c0                	test   %eax,%eax
80107d75:	0f 84 e6 00 00 00    	je     80107e61 <allocuvm+0x171>
    memset(mem, 0, PGSIZE);
80107d7b:	83 ec 04             	sub    $0x4,%esp
80107d7e:	68 00 10 00 00       	push   $0x1000
80107d83:	6a 00                	push   $0x0
80107d85:	50                   	push   %eax
80107d86:	e8 b5 d2 ff ff       	call   80105040 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107d8b:	58                   	pop    %eax
80107d8c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107d92:	5a                   	pop    %edx
80107d93:	6a 06                	push   $0x6
80107d95:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d9a:	89 f2                	mov    %esi,%edx
80107d9c:	50                   	push   %eax
80107d9d:	8b 45 08             	mov    0x8(%ebp),%eax
80107da0:	e8 fb f4 ff ff       	call   801072a0 <mappages>
80107da5:	83 c4 10             	add    $0x10,%esp
80107da8:	85 c0                	test   %eax,%eax
80107daa:	0f 88 10 01 00 00    	js     80107ec0 <allocuvm+0x1d0>
    if (p->pid > 2){
80107db0:	8b 4f 10             	mov    0x10(%edi),%ecx
80107db3:	83 f9 02             	cmp    $0x2,%ecx
80107db6:	7e 88                	jle    80107d40 <allocuvm+0x50>
80107db8:	8d 97 00 02 00 00    	lea    0x200(%edi),%edx
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107dbe:	31 c0                	xor    %eax,%eax
80107dc0:	eb 15                	jmp    80107dd7 <allocuvm+0xe7>
80107dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107dc8:	83 c0 01             	add    $0x1,%eax
80107dcb:	83 c2 18             	add    $0x18,%edx
80107dce:	83 f8 10             	cmp    $0x10,%eax
80107dd1:	0f 84 69 ff ff ff    	je     80107d40 <allocuvm+0x50>
        if (p->ram_pages[i].is_free){
80107dd7:	8b 1a                	mov    (%edx),%ebx
80107dd9:	85 db                	test   %ebx,%ebx
80107ddb:	74 eb                	je     80107dc8 <allocuvm+0xd8>
          p->ram_pages[i].is_free = 0;
80107ddd:	8d 04 40             	lea    (%eax,%eax,2),%eax
80107de0:	8d 14 c7             	lea    (%edi,%eax,8),%edx
          p->ram_pages[i].page_index = ++page_counter;
80107de3:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
          p->ram_pages[i].is_free = 0;
80107de8:	c7 82 00 02 00 00 00 	movl   $0x0,0x200(%edx)
80107def:	00 00 00 
          p->ram_pages[i].page_index = ++page_counter;
80107df2:	83 c0 01             	add    $0x1,%eax
          p->ram_pages[i].va = (void *)a;
80107df5:	89 b2 10 02 00 00    	mov    %esi,0x210(%edx)
          p->ram_pages[i].page_index = ++page_counter;
80107dfb:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
80107e00:	89 82 0c 02 00 00    	mov    %eax,0x20c(%edx)
          break;
80107e06:	e9 35 ff ff ff       	jmp    80107d40 <allocuvm+0x50>
80107e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107e0f:	90                   	nop
    return oldsz;
80107e10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107e13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e19:	5b                   	pop    %ebx
80107e1a:	5e                   	pop    %esi
80107e1b:	5f                   	pop    %edi
80107e1c:	5d                   	pop    %ebp
80107e1d:	c3                   	ret    
80107e1e:	66 90                	xchg   %ax,%ax
80107e20:	8d 97 00 02 00 00    	lea    0x200(%edi),%edx
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107e26:	31 c0                	xor    %eax,%eax
80107e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e2f:	90                   	nop
    if (!p->ram_pages[i].is_free){
80107e30:	8b 0a                	mov    (%edx),%ecx
80107e32:	85 c9                	test   %ecx,%ecx
80107e34:	74 62                	je     80107e98 <allocuvm+0x1a8>
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107e36:	83 c0 01             	add    $0x1,%eax
80107e39:	83 c2 18             	add    $0x18,%edx
80107e3c:	83 f8 10             	cmp    $0x10,%eax
80107e3f:	75 ef                	jne    80107e30 <allocuvm+0x140>
  return 0;
80107e41:	31 c0                	xor    %eax,%eax
        swap_out(p, page_to_swap, 0, pgdir);
80107e43:	ff 75 08             	pushl  0x8(%ebp)
80107e46:	6a 00                	push   $0x0
80107e48:	50                   	push   %eax
80107e49:	57                   	push   %edi
80107e4a:	e8 91 fd ff ff       	call   80107be0 <swap_out>
80107e4f:	83 c4 10             	add    $0x10,%esp
    mem = kalloc();
80107e52:	e8 09 af ff ff       	call   80102d60 <kalloc>
80107e57:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107e59:	85 c0                	test   %eax,%eax
80107e5b:	0f 85 1a ff ff ff    	jne    80107d7b <allocuvm+0x8b>
      cprintf("allocuvm out of memory\n");
80107e61:	83 ec 0c             	sub    $0xc,%esp
80107e64:	68 b8 8b 10 80       	push   $0x80108bb8
80107e69:	e8 42 88 ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107e6e:	83 c4 0c             	add    $0xc,%esp
80107e71:	ff 75 0c             	pushl  0xc(%ebp)
80107e74:	ff 75 10             	pushl  0x10(%ebp)
80107e77:	ff 75 08             	pushl  0x8(%ebp)
80107e7a:	e8 a1 f8 ff ff       	call   80107720 <deallocuvm>
      return 0;
80107e7f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107e86:	83 c4 10             	add    $0x10,%esp
}
80107e89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e8f:	5b                   	pop    %ebx
80107e90:	5e                   	pop    %esi
80107e91:	5f                   	pop    %edi
80107e92:	5d                   	pop    %ebp
80107e93:	c3                   	ret    
80107e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return &p->ram_pages[i];
80107e98:	8d 04 40             	lea    (%eax,%eax,2),%eax
80107e9b:	8d 84 c7 00 02 00 00 	lea    0x200(%edi,%eax,8),%eax
80107ea2:	eb 9f                	jmp    80107e43 <allocuvm+0x153>
80107ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80107ea8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107eaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107eb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107eb5:	5b                   	pop    %ebx
80107eb6:	5e                   	pop    %esi
80107eb7:	5f                   	pop    %edi
80107eb8:	5d                   	pop    %ebp
80107eb9:	c3                   	ret    
80107eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107ec0:	83 ec 0c             	sub    $0xc,%esp
80107ec3:	68 d0 8b 10 80       	push   $0x80108bd0
80107ec8:	e8 e3 87 ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107ecd:	83 c4 0c             	add    $0xc,%esp
80107ed0:	ff 75 0c             	pushl  0xc(%ebp)
80107ed3:	ff 75 10             	pushl  0x10(%ebp)
80107ed6:	ff 75 08             	pushl  0x8(%ebp)
80107ed9:	e8 42 f8 ff ff       	call   80107720 <deallocuvm>
      kfree(mem);
80107ede:	89 1c 24             	mov    %ebx,(%esp)
80107ee1:	e8 ba ac ff ff       	call   80102ba0 <kfree>
      return 0;
80107ee6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107eed:	83 c4 10             	add    $0x10,%esp
}
80107ef0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ef6:	5b                   	pop    %ebx
80107ef7:	5e                   	pop    %esi
80107ef8:	5f                   	pop    %edi
80107ef9:	5d                   	pop    %ebp
80107efa:	c3                   	ret    
80107efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107eff:	90                   	nop

80107f00 <swap_in>:

// we assume there are at most MAX_PYSC_PAGES in the RAM 
int swap_in(struct proc* p, struct pageinfo* pi){
80107f00:	f3 0f 1e fb          	endbr32 
80107f04:	55                   	push   %ebp
80107f05:	89 e5                	mov    %esp,%ebp
80107f07:	57                   	push   %edi
80107f08:	56                   	push   %esi
80107f09:	53                   	push   %ebx
  pde_t* pgdir = p->pgdir;
  uint offset = pi->swap_file_offset;
  int index;
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107f0a:	31 db                	xor    %ebx,%ebx
int swap_in(struct proc* p, struct pageinfo* pi){
80107f0c:	83 ec 1c             	sub    $0x1c,%esp
80107f0f:	8b 75 08             	mov    0x8(%ebp),%esi
80107f12:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t* pgdir = p->pgdir;
80107f15:	8b 46 04             	mov    0x4(%esi),%eax
80107f18:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint offset = pi->swap_file_offset;
80107f1b:	8b 47 04             	mov    0x4(%edi),%eax
80107f1e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107f21:	8d 86 00 02 00 00    	lea    0x200(%esi),%eax
80107f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f2e:	66 90                	xchg   %ax,%ax
    if (p->ram_pages[index].is_free){
80107f30:	8b 10                	mov    (%eax),%edx
80107f32:	85 d2                	test   %edx,%edx
80107f34:	0f 85 c6 00 00 00    	jne    80108000 <swap_in+0x100>
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107f3a:	83 c3 01             	add    $0x1,%ebx
80107f3d:	83 c0 18             	add    $0x18,%eax
80107f40:	83 fb 10             	cmp    $0x10,%ebx
80107f43:	75 eb                	jne    80107f30 <swap_in+0x30>
      p->ram_pages[index].is_free = 0;
      break;
    }
  }
  void* mem = kalloc();
80107f45:	e8 16 ae ff ff       	call   80102d60 <kalloc>
80107f4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  // mem = kalloc();
  if(mem == 0){
80107f4d:	85 c0                	test   %eax,%eax
80107f4f:	0f 84 be 00 00 00    	je     80108013 <swap_in+0x113>
    cprintf("swap in - out of memory\n");
    // deallocuvm(pgdir, newsz, oldsz);
    return -1;
  }

  void* va = pi->va;
80107f55:	8b 47 10             	mov    0x10(%edi),%eax
  pte_t* pte_ptr = walkpgdir(pgdir, va, 0);
80107f58:	31 c9                	xor    %ecx,%ecx
80107f5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107f5d:	89 c2                	mov    %eax,%edx
80107f5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f62:	e8 b9 f2 ff ff       	call   80107220 <walkpgdir>
  *pte_ptr &= ~PTE_PG;
  *pte_ptr |= (PTE_P | PTE_U | PTE_W);

  // updating physical address written in the page table entry
  *pte_ptr = PTE_FLAGS(*pte_ptr);
  *pte_ptr |= PTE_ADDR(V2P(mem));
80107f67:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107f6a:	8d 91 00 00 00 80    	lea    -0x80000000(%ecx),%edx
80107f70:	8b 08                	mov    (%eax),%ecx
80107f72:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107f78:	81 e1 ff 0d 00 00    	and    $0xdff,%ecx
80107f7e:	09 ca                	or     %ecx,%edx
80107f80:	83 ca 07             	or     $0x7,%edx
80107f83:	89 10                	mov    %edx,(%eax)

  p->ram_pages[index].page_index = ++page_counter;
80107f85:	8b 0d c0 b5 10 80    	mov    0x8010b5c0,%ecx
80107f8b:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
80107f8e:	8d 14 d6             	lea    (%esi,%edx,8),%edx
80107f91:	8d 41 01             	lea    0x1(%ecx),%eax
80107f94:	89 82 0c 02 00 00    	mov    %eax,0x20c(%edx)
80107f9a:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
  p->ram_pages[index].va = va;
80107f9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80107fa2:	89 82 10 02 00 00    	mov    %eax,0x210(%edx)
  int result = readFromSwapFile(p, mem, offset, PGSIZE);
80107fa8:	68 00 10 00 00       	push   $0x1000
80107fad:	ff 75 dc             	pushl  -0x24(%ebp)
80107fb0:	ff 75 e4             	pushl  -0x1c(%ebp)
80107fb3:	56                   	push   %esi
80107fb4:	e8 b7 a7 ff ff       	call   80102770 <readFromSwapFile>

  // clean the struct
  pi->is_free = 1;
80107fb9:	c7 07 01 00 00 00    	movl   $0x1,(%edi)
  pi->va = 0;
80107fbf:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  pi->swap_file_offset = 0;
80107fc6:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)

  // refresh rc3
  lcr3(V2P(p->pgdir));
80107fcd:	8b 7e 04             	mov    0x4(%esi),%edi
80107fd0:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
80107fd6:	0f 22 da             	mov    %edx,%cr3

  p->num_of_actual_pages_in_mem++;
80107fd9:	83 86 84 03 00 00 01 	addl   $0x1,0x384(%esi)
  p->num_of_pages_in_swap_file--;

  if (result < 0){
80107fe0:	83 c4 10             	add    $0x10,%esp
  p->num_of_pages_in_swap_file--;
80107fe3:	83 ae 80 03 00 00 01 	subl   $0x1,0x380(%esi)
  if (result < 0){
80107fea:	85 c0                	test   %eax,%eax
80107fec:	78 3c                	js     8010802a <swap_in+0x12a>
    panic("swap in failed");
  }
  return result;
}
80107fee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ff1:	5b                   	pop    %ebx
80107ff2:	5e                   	pop    %esi
80107ff3:	5f                   	pop    %edi
80107ff4:	5d                   	pop    %ebp
80107ff5:	c3                   	ret    
80107ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ffd:	8d 76 00             	lea    0x0(%esi),%esi
      p->ram_pages[index].is_free = 0;
80108000:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
80108003:	c7 84 c6 00 02 00 00 	movl   $0x0,0x200(%esi,%eax,8)
8010800a:	00 00 00 00 
      break;
8010800e:	e9 32 ff ff ff       	jmp    80107f45 <swap_in+0x45>
    cprintf("swap in - out of memory\n");
80108013:	83 ec 0c             	sub    $0xc,%esp
80108016:	68 ec 8b 10 80       	push   $0x80108bec
8010801b:	e8 90 86 ff ff       	call   801006b0 <cprintf>
    return -1;
80108020:	83 c4 10             	add    $0x10,%esp
80108023:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108028:	eb c4                	jmp    80107fee <swap_in+0xee>
    panic("swap in failed");
8010802a:	83 ec 0c             	sub    $0xc,%esp
8010802d:	68 05 8c 10 80       	push   $0x80108c05
80108032:	e8 59 83 ff ff       	call   80100390 <panic>
80108037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010803e:	66 90                	xchg   %ax,%ax

80108040 <swap_page_back>:
 * 3. ram not full - swap in
 * 
 * 
 * */

void swap_page_back(struct proc* p, struct pageinfo* pi_to_swapin){
80108040:	f3 0f 1e fb          	endbr32 
80108044:	55                   	push   %ebp
80108045:	89 e5                	mov    %esp,%ebp
80108047:	57                   	push   %edi
80108048:	56                   	push   %esi
80108049:	53                   	push   %ebx
8010804a:	83 ec 3c             	sub    $0x3c,%esp
8010804d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //   if (!p->swapped_out_pages[i].is_free){
  //     swap++;
  //   }
  // }
  // cprintf("RAM: %d SWAP: %d\n", ram, swap);
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
80108050:	83 bb 84 03 00 00 10 	cmpl   $0x10,0x384(%ebx)
80108057:	74 17                	je     80108070 <swap_page_back+0x30>
    struct pageinfo* page_to_swap = find_page_to_swap(p);
    swap_out(p, page_to_swap, 0, p->pgdir);
    swap_in(p, pi_to_swapin);
  }
  else{
    swap_in(p, pi_to_swapin);
80108059:	83 ec 08             	sub    $0x8,%esp
8010805c:	ff 75 0c             	pushl  0xc(%ebp)
8010805f:	53                   	push   %ebx
80108060:	e8 9b fe ff ff       	call   80107f00 <swap_in>
80108065:	83 c4 10             	add    $0x10,%esp
  }
}
80108068:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010806b:	5b                   	pop    %ebx
8010806c:	5e                   	pop    %esi
8010806d:	5f                   	pop    %edi
8010806e:	5d                   	pop    %ebp
8010806f:	c3                   	ret    
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
80108070:	8b 83 80 03 00 00    	mov    0x380(%ebx),%eax
80108076:	83 f8 10             	cmp    $0x10,%eax
80108079:	74 5d                	je     801080d8 <swap_page_back+0x98>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
8010807b:	83 f8 0f             	cmp    $0xf,%eax
8010807e:	77 d9                	ja     80108059 <swap_page_back+0x19>
80108080:	8d 93 00 02 00 00    	lea    0x200(%ebx),%edx
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80108086:	31 c0                	xor    %eax,%eax
80108088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010808f:	90                   	nop
    if (!p->ram_pages[i].is_free){
80108090:	8b 0a                	mov    (%edx),%ecx
80108092:	85 c9                	test   %ecx,%ecx
80108094:	74 32                	je     801080c8 <swap_page_back+0x88>
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80108096:	83 c0 01             	add    $0x1,%eax
80108099:	83 c2 18             	add    $0x18,%edx
8010809c:	83 f8 10             	cmp    $0x10,%eax
8010809f:	75 ef                	jne    80108090 <swap_page_back+0x50>
  return 0;
801080a1:	31 c0                	xor    %eax,%eax
    swap_out(p, page_to_swap, 0, p->pgdir);
801080a3:	ff 73 04             	pushl  0x4(%ebx)
801080a6:	6a 00                	push   $0x0
801080a8:	50                   	push   %eax
801080a9:	53                   	push   %ebx
801080aa:	e8 31 fb ff ff       	call   80107be0 <swap_out>
    swap_in(p, pi_to_swapin);
801080af:	58                   	pop    %eax
801080b0:	5a                   	pop    %edx
801080b1:	ff 75 0c             	pushl  0xc(%ebp)
801080b4:	53                   	push   %ebx
801080b5:	e8 46 fe ff ff       	call   80107f00 <swap_in>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
801080ba:	83 c4 10             	add    $0x10,%esp
}
801080bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080c0:	5b                   	pop    %ebx
801080c1:	5e                   	pop    %esi
801080c2:	5f                   	pop    %edi
801080c3:	5d                   	pop    %ebp
801080c4:	c3                   	ret    
801080c5:	8d 76 00             	lea    0x0(%esi),%esi
      return &p->ram_pages[i];
801080c8:	8d 04 40             	lea    (%eax,%eax,2),%eax
801080cb:	8d 84 c3 00 02 00 00 	lea    0x200(%ebx,%eax,8),%eax
801080d2:	eb cf                	jmp    801080a3 <swap_page_back+0x63>
801080d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    char* buffer = kalloc();
801080d8:	e8 83 ac ff ff       	call   80102d60 <kalloc>
801080dd:	8d 93 00 02 00 00    	lea    0x200(%ebx),%edx
801080e3:	89 c7                	mov    %eax,%edi
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
801080e5:	31 c0                	xor    %eax,%eax
801080e7:	eb 16                	jmp    801080ff <swap_page_back+0xbf>
801080e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801080f0:	83 c0 01             	add    $0x1,%eax
801080f3:	83 c2 18             	add    $0x18,%edx
801080f6:	83 f8 10             	cmp    $0x10,%eax
801080f9:	0f 84 8e 00 00 00    	je     8010818d <swap_page_back+0x14d>
    if (!p->ram_pages[i].is_free){
801080ff:	8b 0a                	mov    (%edx),%ecx
80108101:	85 c9                	test   %ecx,%ecx
80108103:	75 eb                	jne    801080f0 <swap_page_back+0xb0>
      return &p->ram_pages[i];
80108105:	8d 34 40             	lea    (%eax,%eax,2),%esi
    memmove(buffer, page_to_swap->va, PGSIZE);
80108108:	83 ec 04             	sub    $0x4,%esp
      return &p->ram_pages[i];
8010810b:	c1 e6 03             	shl    $0x3,%esi
    memmove(buffer, page_to_swap->va, PGSIZE);
8010810e:	68 00 10 00 00       	push   $0x1000
      return &p->ram_pages[i];
80108113:	8d 94 33 00 02 00 00 	lea    0x200(%ebx,%esi,1),%edx
    memmove(buffer, page_to_swap->va, PGSIZE);
8010811a:	01 de                	add    %ebx,%esi
8010811c:	ff b6 10 02 00 00    	pushl  0x210(%esi)
80108122:	57                   	push   %edi
      return &p->ram_pages[i];
80108123:	89 55 c4             	mov    %edx,-0x3c(%ebp)
    memmove(buffer, page_to_swap->va, PGSIZE);
80108126:	e8 b5 cf ff ff       	call   801050e0 <memmove>
    pi = *page_to_swap;
8010812b:	8b 8e 00 02 00 00    	mov    0x200(%esi),%ecx
80108131:	8b 86 14 02 00 00    	mov    0x214(%esi),%eax
    page_to_swap->is_free = 1;
80108137:	c7 86 00 02 00 00 01 	movl   $0x1,0x200(%esi)
8010813e:	00 00 00 
    swap_in(p, page_to_swap);
80108141:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    pi = *page_to_swap;
80108144:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80108147:	8b 8e 04 02 00 00    	mov    0x204(%esi),%ecx
8010814d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108150:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80108153:	8b 8e 08 02 00 00    	mov    0x208(%esi),%ecx
80108159:	89 4d d8             	mov    %ecx,-0x28(%ebp)
8010815c:	8b 8e 0c 02 00 00    	mov    0x20c(%esi),%ecx
80108162:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80108165:	8b 8e 10 02 00 00    	mov    0x210(%esi),%ecx
    swap_in(p, page_to_swap);
8010816b:	5e                   	pop    %esi
8010816c:	58                   	pop    %eax
8010816d:	52                   	push   %edx
8010816e:	53                   	push   %ebx
    pi = *page_to_swap;
8010816f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    swap_in(p, page_to_swap);
80108172:	e8 89 fd ff ff       	call   80107f00 <swap_in>
    swap_out(p, &pi, buffer, p->pgdir);
80108177:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010817a:	ff 73 04             	pushl  0x4(%ebx)
8010817d:	57                   	push   %edi
8010817e:	50                   	push   %eax
8010817f:	53                   	push   %ebx
80108180:	e8 5b fa ff ff       	call   80107be0 <swap_out>
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
80108185:	83 c4 20             	add    $0x20,%esp
80108188:	e9 db fe ff ff       	jmp    80108068 <swap_page_back+0x28>
8010818d:	e9 00 00 00 00       	jmp    80108192 <swap_page_back.cold>

80108192 <swap_page_back.cold>:
    memmove(buffer, page_to_swap->va, PGSIZE);
80108192:	a1 10 00 00 00       	mov    0x10,%eax
80108197:	0f 0b                	ud2    
