
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
8010002d:	b8 50 36 10 80       	mov    $0x80103650,%eax
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
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 d6 10 80       	mov    $0x8010d614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 86 10 80       	push   $0x80108600
80100051:	68 e0 d5 10 80       	push   $0x8010d5e0
80100056:	e8 55 4c 00 00       	call   80104cb0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 1d 11 80 dc 	movl   $0x80111cdc,0x80111d2c
80100062:	1c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 1d 11 80 dc 	movl   $0x80111cdc,0x80111d30
8010006c:	1c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 1c 11 80       	mov    $0x80111cdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 86 10 80       	push   $0x80108607
80100097:	50                   	push   %eax
80100098:	e8 e3 4a 00 00       	call   80104b80 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 1d 11 80       	mov    0x80111d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 1c 11 80       	cmp    $0x80111cdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 d5 10 80       	push   $0x8010d5e0
801000e4:	e8 07 4d 00 00       	call   80104df0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 1d 11 80    	mov    0x80111d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 1d 11 80    	mov    0x80111d2c,%ebx
80100126:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 d5 10 80       	push   $0x8010d5e0
80100162:	e8 49 4d 00 00       	call   80104eb0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 4a 00 00       	call   80104bc0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 cd 26 00 00       	call   80102850 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 0e 86 10 80       	push   $0x8010860e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 ad 4a 00 00       	call   80104c60 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 87 26 00 00       	jmp    80102850 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 86 10 80       	push   $0x8010861f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 6c 4a 00 00       	call   80104c60 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 1c 4a 00 00       	call   80104c20 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
8010020b:	e8 e0 4b 00 00       	call   80104df0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 1d 11 80       	mov    0x80111d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 1d 11 80       	mov    0x80111d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 d5 10 80 	movl   $0x8010d5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 4f 4c 00 00       	jmp    80104eb0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 86 10 80       	push   $0x80108626
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 7b 18 00 00       	call   80101b00 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 5f 4b 00 00       	call   80104df0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 e0 ff 11 80    	mov    0x8011ffe0,%edx
801002a7:	39 15 e4 ff 11 80    	cmp    %edx,0x8011ffe4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 c5 10 80       	push   $0x8010c520
801002c0:	68 e0 ff 11 80       	push   $0x8011ffe0
801002c5:	e8 a6 44 00 00       	call   80104770 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 e0 ff 11 80    	mov    0x8011ffe0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 e4 ff 11 80    	cmp    0x8011ffe4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 30 3d 00 00       	call   80104010 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 bc 4b 00 00       	call   80104eb0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 24 17 00 00       	call   80101a20 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 e0 ff 11 80       	mov    %eax,0x8011ffe0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 60 ff 11 80 	movsbl -0x7fee00a0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 c5 10 80       	push   $0x8010c520
8010034d:	e8 5e 4b 00 00       	call   80104eb0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 c6 16 00 00       	call   80101a20 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 e0 ff 11 80    	mov    %edx,0x8011ffe0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 32 2b 00 00       	call   80102ee0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 2d 86 10 80       	push   $0x8010862d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 08 92 10 80 	movl   $0x80109208,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 f3 48 00 00       	call   80104cd0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 41 86 10 80       	push   $0x80108641
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 a1 62 00 00       	call   801066e0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 ef 61 00 00       	call   801066e0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 e3 61 00 00       	call   801066e0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 d7 61 00 00       	call   801066e0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 87 4a 00 00       	call   80104fb0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 ba 49 00 00       	call   80104f00 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 45 86 10 80       	push   $0x80108645
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 70 86 10 80 	movzbl -0x7fef7990(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 ec 14 00 00       	call   80101b00 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010061b:	e8 d0 47 00 00       	call   80104df0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 c5 10 80       	push   $0x8010c520
80100647:	e8 64 48 00 00       	call   80104eb0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 cb 13 00 00       	call   80101a20 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 c5 10 80       	mov    0x8010c554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 c5 10 80       	push   $0x8010c520
8010071f:	e8 8c 47 00 00       	call   80104eb0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 58 86 10 80       	mov    $0x80108658,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 fb 45 00 00       	call   80104df0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 5f 86 10 80       	push   $0x8010865f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 c5 10 80       	push   $0x8010c520
80100823:	e8 c8 45 00 00       	call   80104df0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 e8 ff 11 80       	mov    0x8011ffe8,%eax
80100856:	3b 05 e4 ff 11 80    	cmp    0x8011ffe4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 e8 ff 11 80       	mov    %eax,0x8011ffe8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 c5 10 80       	push   $0x8010c520
80100888:	e8 23 46 00 00       	call   80104eb0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 e8 ff 11 80       	mov    0x8011ffe8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 e0 ff 11 80    	sub    0x8011ffe0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 e8 ff 11 80    	mov    %edx,0x8011ffe8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 60 ff 11 80    	mov    %cl,-0x7fee00a0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 e0 ff 11 80       	mov    0x8011ffe0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 e8 ff 11 80    	cmp    %eax,0x8011ffe8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 e4 ff 11 80       	mov    %eax,0x8011ffe4
          wakeup(&input.r);
80100911:	68 e0 ff 11 80       	push   $0x8011ffe0
80100916:	e8 a5 40 00 00       	call   801049c0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 e8 ff 11 80       	mov    0x8011ffe8,%eax
8010093d:	39 05 e4 ff 11 80    	cmp    %eax,0x8011ffe4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 e8 ff 11 80       	mov    %eax,0x8011ffe8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 e8 ff 11 80       	mov    0x8011ffe8,%eax
80100964:	3b 05 e4 ff 11 80    	cmp    0x8011ffe4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 60 ff 11 80 0a 	cmpb   $0xa,-0x7fee00a0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 04 41 00 00       	jmp    80104aa0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 60 ff 11 80 0a 	movb   $0xa,-0x7fee00a0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 e8 ff 11 80       	mov    0x8011ffe8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 68 86 10 80       	push   $0x80108668
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 db 42 00 00       	call   80104cb0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 ac 09 12 80 00 	movl   $0x80100600,0x801209ac
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 a8 09 12 80 70 	movl   $0x80100270,0x801209a8
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 02 20 00 00       	call   80102a00 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <intiate_pg_info>:
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

void intiate_pg_info(struct proc* p){
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	8b 55 08             	mov    0x8(%ebp),%edx
  p->num_of_pageOut_occured = 0;
80100a16:	c7 82 8c 03 00 00 00 	movl   $0x0,0x38c(%edx)
80100a1d:	00 00 00 
  p->num_of_pagefaults_occurs = 0;
80100a20:	c7 82 88 03 00 00 00 	movl   $0x0,0x388(%edx)
80100a27:	00 00 00 
80100a2a:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
  p->num_of_actual_pages_in_mem = 0;
80100a30:	c7 82 84 03 00 00 00 	movl   $0x0,0x384(%edx)
80100a37:	00 00 00 
  p->num_of_pages_in_swap_file = 0;
80100a3a:	c7 82 80 03 00 00 00 	movl   $0x0,0x380(%edx)
80100a41:	00 00 00 
80100a44:	81 c2 00 02 00 00    	add    $0x200,%edx
80100a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
    p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80100a50:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80100a56:	c7 80 80 01 00 00 01 	movl   $0x1,0x180(%eax)
80100a5d:	00 00 00 
80100a60:	83 c0 18             	add    $0x18,%eax
    p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
80100a63:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
80100a6a:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
80100a71:	00 00 00 
    p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80100a74:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
80100a7b:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
80100a82:	00 00 00 
    p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80100a85:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80100a8c:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
80100a93:	00 00 00 
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100a96:	39 d0                	cmp    %edx,%eax
80100a98:	75 b6                	jne    80100a50 <intiate_pg_info+0x40>
  }
}
80100a9a:	5d                   	pop    %ebp
80100a9b:	c3                   	ret    
80100a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100aa0 <exec>:


int
exec(char *path, char **argv)
{
80100aa0:	55                   	push   %ebp
80100aa1:	89 e5                	mov    %esp,%ebp
80100aa3:	57                   	push   %edi
80100aa4:	56                   	push   %esi
80100aa5:	53                   	push   %ebx
80100aa6:	81 ec 1c 04 00 00    	sub    $0x41c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100aac:	e8 5f 35 00 00       	call   80104010 <myproc>
80100ab1:	89 c7                	mov    %eax,%edi
  struct pageinfo mem_pginfo_bu[MAX_PYSC_PAGES];
  struct pageinfo swp_pginfo_bu[MAX_PYSC_PAGES];
  struct file* swap_file_bu = 0;
  struct file* temp_swap_file = 0;

  begin_op();
80100ab3:	e8 98 28 00 00       	call   80103350 <begin_op>

  if((ip = namei(path)) == 0){
80100ab8:	83 ec 0c             	sub    $0xc,%esp
80100abb:	ff 75 08             	pushl  0x8(%ebp)
80100abe:	e8 bd 17 00 00       	call   80102280 <namei>
80100ac3:	83 c4 10             	add    $0x10,%esp
80100ac6:	85 c0                	test   %eax,%eax
80100ac8:	0f 84 81 04 00 00    	je     80100f4f <exec+0x4af>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ace:	83 ec 0c             	sub    $0xc,%esp
80100ad1:	89 c3                	mov    %eax,%ebx
80100ad3:	50                   	push   %eax
80100ad4:	e8 47 0f 00 00       	call   80101a20 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ad9:	8d 85 24 fc ff ff    	lea    -0x3dc(%ebp),%eax
80100adf:	6a 34                	push   $0x34
80100ae1:	6a 00                	push   $0x0
80100ae3:	50                   	push   %eax
80100ae4:	53                   	push   %ebx
80100ae5:	e8 16 12 00 00       	call   80101d00 <readi>
80100aea:	83 c4 20             	add    $0x20,%esp
80100aed:	83 f8 34             	cmp    $0x34,%eax
80100af0:	74 1e                	je     80100b10 <exec+0x70>
      curproc->swapFile = swap_file_bu;
    }
    freevm(pgdir);
  }
  if(ip){
    iunlockput(ip);
80100af2:	83 ec 0c             	sub    $0xc,%esp
80100af5:	53                   	push   %ebx
80100af6:	e8 b5 11 00 00       	call   80101cb0 <iunlockput>
    end_op();
80100afb:	e8 c0 28 00 00       	call   801033c0 <end_op>
80100b00:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b0b:	5b                   	pop    %ebx
80100b0c:	5e                   	pop    %esi
80100b0d:	5f                   	pop    %edi
80100b0e:	5d                   	pop    %ebp
80100b0f:	c3                   	ret    
  if(elf.magic != ELF_MAGIC)
80100b10:	81 bd 24 fc ff ff 7f 	cmpl   $0x464c457f,-0x3dc(%ebp)
80100b17:	45 4c 46 
80100b1a:	75 d6                	jne    80100af2 <exec+0x52>
  if((pgdir = setupkvm()) == 0)
80100b1c:	e8 af 70 00 00       	call   80107bd0 <setupkvm>
80100b21:	85 c0                	test   %eax,%eax
80100b23:	89 85 f4 fb ff ff    	mov    %eax,-0x40c(%ebp)
80100b29:	74 c7                	je     80100af2 <exec+0x52>
  if (curproc->pid > 2){
80100b2b:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80100b2f:	0f 8e 71 03 00 00    	jle    80100ea6 <exec+0x406>
    pg_flt_bu = curproc->num_of_pagefaults_occurs;
80100b35:	8b 87 88 03 00 00    	mov    0x388(%edi),%eax
80100b3b:	8d b5 e8 fc ff ff    	lea    -0x318(%ebp),%esi
80100b41:	8d 8d 68 fe ff ff    	lea    -0x198(%ebp),%ecx
80100b47:	89 85 e0 fb ff ff    	mov    %eax,-0x420(%ebp)
    pg_mem_bu = curproc->num_of_actual_pages_in_mem;
80100b4d:	8b 87 84 03 00 00    	mov    0x384(%edi),%eax
80100b53:	89 85 dc fb ff ff    	mov    %eax,-0x424(%ebp)
    pg_swp_bu = curproc->num_of_pages_in_swap_file;
80100b59:	8b 87 80 03 00 00    	mov    0x380(%edi),%eax
80100b5f:	89 85 d8 fb ff ff    	mov    %eax,-0x428(%ebp)
    pg_out_bu = curproc->num_of_pageOut_occured;
80100b65:	8b 87 8c 03 00 00    	mov    0x38c(%edi),%eax
80100b6b:	89 85 e4 fb ff ff    	mov    %eax,-0x41c(%ebp)
80100b71:	31 c0                	xor    %eax,%eax
80100b73:	90                   	nop
80100b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      mem_pginfo_bu[i] = curproc->ram_pages[i];
80100b78:	8b 94 07 00 02 00 00 	mov    0x200(%edi,%eax,1),%edx
80100b7f:	89 14 06             	mov    %edx,(%esi,%eax,1)
80100b82:	8b 94 07 04 02 00 00 	mov    0x204(%edi,%eax,1),%edx
80100b89:	89 54 06 04          	mov    %edx,0x4(%esi,%eax,1)
80100b8d:	8b 94 07 08 02 00 00 	mov    0x208(%edi,%eax,1),%edx
80100b94:	89 54 06 08          	mov    %edx,0x8(%esi,%eax,1)
80100b98:	8b 94 07 0c 02 00 00 	mov    0x20c(%edi,%eax,1),%edx
80100b9f:	89 54 06 0c          	mov    %edx,0xc(%esi,%eax,1)
80100ba3:	8b 94 07 10 02 00 00 	mov    0x210(%edi,%eax,1),%edx
80100baa:	89 54 06 10          	mov    %edx,0x10(%esi,%eax,1)
80100bae:	8b 94 07 14 02 00 00 	mov    0x214(%edi,%eax,1),%edx
80100bb5:	89 54 06 14          	mov    %edx,0x14(%esi,%eax,1)
      swp_pginfo_bu[i] = curproc->swapped_out_pages[i];
80100bb9:	8b 94 07 80 00 00 00 	mov    0x80(%edi,%eax,1),%edx
80100bc0:	89 14 01             	mov    %edx,(%ecx,%eax,1)
80100bc3:	8b 94 07 84 00 00 00 	mov    0x84(%edi,%eax,1),%edx
80100bca:	89 54 01 04          	mov    %edx,0x4(%ecx,%eax,1)
80100bce:	8b 94 07 88 00 00 00 	mov    0x88(%edi,%eax,1),%edx
80100bd5:	89 54 01 08          	mov    %edx,0x8(%ecx,%eax,1)
80100bd9:	8b 94 07 8c 00 00 00 	mov    0x8c(%edi,%eax,1),%edx
80100be0:	89 54 01 0c          	mov    %edx,0xc(%ecx,%eax,1)
80100be4:	8b 94 07 90 00 00 00 	mov    0x90(%edi,%eax,1),%edx
80100beb:	89 54 01 10          	mov    %edx,0x10(%ecx,%eax,1)
80100bef:	8b 94 07 94 00 00 00 	mov    0x94(%edi,%eax,1),%edx
80100bf6:	89 54 01 14          	mov    %edx,0x14(%ecx,%eax,1)
80100bfa:	83 c0 18             	add    $0x18,%eax
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100bfd:	3d 80 01 00 00       	cmp    $0x180,%eax
80100c02:	0f 85 70 ff ff ff    	jne    80100b78 <exec+0xd8>
80100c08:	8d 87 80 00 00 00    	lea    0x80(%edi),%eax
80100c0e:	8d 8f 00 02 00 00    	lea    0x200(%edi),%ecx
  p->num_of_pageOut_occured = 0;
80100c14:	c7 87 8c 03 00 00 00 	movl   $0x0,0x38c(%edi)
80100c1b:	00 00 00 
  p->num_of_pagefaults_occurs = 0;
80100c1e:	c7 87 88 03 00 00 00 	movl   $0x0,0x388(%edi)
80100c25:	00 00 00 
  p->num_of_actual_pages_in_mem = 0;
80100c28:	c7 87 84 03 00 00 00 	movl   $0x0,0x384(%edi)
80100c2f:	00 00 00 
  p->num_of_pages_in_swap_file = 0;
80100c32:	c7 87 80 03 00 00 00 	movl   $0x0,0x380(%edi)
80100c39:	00 00 00 
80100c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80100c40:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80100c46:	c7 80 80 01 00 00 01 	movl   $0x1,0x180(%eax)
80100c4d:	00 00 00 
80100c50:	83 c0 18             	add    $0x18,%eax
    p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
80100c53:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
80100c5a:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
80100c61:	00 00 00 
    p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80100c64:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
80100c6b:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
80100c72:	00 00 00 
    p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80100c75:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80100c7c:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
80100c83:	00 00 00 
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100c86:	39 c8                	cmp    %ecx,%eax
80100c88:	75 b6                	jne    80100c40 <exec+0x1a0>
    swap_file_bu = curproc->swapFile;
80100c8a:	8b 47 7c             	mov    0x7c(%edi),%eax
    createSwapFile(curproc);
80100c8d:	83 ec 0c             	sub    $0xc,%esp
80100c90:	57                   	push   %edi
    swap_file_bu = curproc->swapFile;
80100c91:	89 85 e8 fb ff ff    	mov    %eax,-0x418(%ebp)
    createSwapFile(curproc);
80100c97:	e8 b4 18 00 00       	call   80102550 <createSwapFile>
80100c9c:	83 c4 10             	add    $0x10,%esp
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c9f:	66 83 bd 50 fc ff ff 	cmpw   $0x0,-0x3b0(%ebp)
80100ca6:	00 
80100ca7:	8b 85 40 fc ff ff    	mov    -0x3c0(%ebp),%eax
80100cad:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
80100cb3:	0f 84 24 04 00 00    	je     801010dd <exec+0x63d>
  sz = 0;
80100cb9:	31 c0                	xor    %eax,%eax
80100cbb:	89 bd f0 fb ff ff    	mov    %edi,-0x410(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cc1:	31 f6                	xor    %esi,%esi
80100cc3:	89 c7                	mov    %eax,%edi
80100cc5:	e9 88 00 00 00       	jmp    80100d52 <exec+0x2b2>
80100cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ph.type != ELF_PROG_LOAD)
80100cd0:	83 bd 04 fc ff ff 01 	cmpl   $0x1,-0x3fc(%ebp)
80100cd7:	75 67                	jne    80100d40 <exec+0x2a0>
    if(ph.memsz < ph.filesz)
80100cd9:	8b 85 18 fc ff ff    	mov    -0x3e8(%ebp),%eax
80100cdf:	3b 85 14 fc ff ff    	cmp    -0x3ec(%ebp),%eax
80100ce5:	0f 82 8e 00 00 00    	jb     80100d79 <exec+0x2d9>
80100ceb:	03 85 0c fc ff ff    	add    -0x3f4(%ebp),%eax
80100cf1:	0f 82 82 00 00 00    	jb     80100d79 <exec+0x2d9>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cf7:	83 ec 04             	sub    $0x4,%esp
80100cfa:	50                   	push   %eax
80100cfb:	57                   	push   %edi
80100cfc:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80100d02:	e8 f9 73 00 00       	call   80108100 <allocuvm>
80100d07:	83 c4 10             	add    $0x10,%esp
80100d0a:	85 c0                	test   %eax,%eax
80100d0c:	89 c7                	mov    %eax,%edi
80100d0e:	74 69                	je     80100d79 <exec+0x2d9>
    if(ph.vaddr % PGSIZE != 0)
80100d10:	8b 85 0c fc ff ff    	mov    -0x3f4(%ebp),%eax
80100d16:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100d1b:	75 5c                	jne    80100d79 <exec+0x2d9>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d1d:	83 ec 0c             	sub    $0xc,%esp
80100d20:	ff b5 14 fc ff ff    	pushl  -0x3ec(%ebp)
80100d26:	ff b5 08 fc ff ff    	pushl  -0x3f8(%ebp)
80100d2c:	53                   	push   %ebx
80100d2d:	50                   	push   %eax
80100d2e:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80100d34:	e8 a7 6b 00 00       	call   801078e0 <loaduvm>
80100d39:	83 c4 20             	add    $0x20,%esp
80100d3c:	85 c0                	test   %eax,%eax
80100d3e:	78 39                	js     80100d79 <exec+0x2d9>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d40:	0f b7 85 50 fc ff ff 	movzwl -0x3b0(%ebp),%eax
80100d47:	83 c6 01             	add    $0x1,%esi
80100d4a:	39 f0                	cmp    %esi,%eax
80100d4c:	0f 8e 8b 01 00 00    	jle    80100edd <exec+0x43d>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d52:	89 f0                	mov    %esi,%eax
80100d54:	6a 20                	push   $0x20
80100d56:	c1 e0 05             	shl    $0x5,%eax
80100d59:	03 85 ec fb ff ff    	add    -0x414(%ebp),%eax
80100d5f:	50                   	push   %eax
80100d60:	8d 85 04 fc ff ff    	lea    -0x3fc(%ebp),%eax
80100d66:	50                   	push   %eax
80100d67:	53                   	push   %ebx
80100d68:	e8 93 0f 00 00       	call   80101d00 <readi>
80100d6d:	83 c4 10             	add    $0x10,%esp
80100d70:	83 f8 20             	cmp    $0x20,%eax
80100d73:	0f 84 57 ff ff ff    	je     80100cd0 <exec+0x230>
80100d79:	8b bd f0 fb ff ff    	mov    -0x410(%ebp),%edi
    if (curproc->pid > 2){
80100d7f:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80100d83:	7f 1b                	jg     80100da0 <exec+0x300>
    freevm(pgdir);
80100d85:	83 ec 0c             	sub    $0xc,%esp
80100d88:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80100d8e:	e8 2d 6d 00 00       	call   80107ac0 <freevm>
80100d93:	83 c4 10             	add    $0x10,%esp
80100d96:	e9 57 fd ff ff       	jmp    80100af2 <exec+0x52>
  ip = 0;
80100d9b:	31 db                	xor    %ebx,%ebx
80100d9d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->num_of_pagefaults_occurs = pg_flt_bu;
80100da0:	8b 85 e0 fb ff ff    	mov    -0x420(%ebp),%eax
80100da6:	8d b5 e8 fc ff ff    	lea    -0x318(%ebp),%esi
80100dac:	8d 8d 68 fe ff ff    	lea    -0x198(%ebp),%ecx
80100db2:	89 87 88 03 00 00    	mov    %eax,0x388(%edi)
      curproc->num_of_actual_pages_in_mem = pg_mem_bu;
80100db8:	8b 85 dc fb ff ff    	mov    -0x424(%ebp),%eax
80100dbe:	89 87 84 03 00 00    	mov    %eax,0x384(%edi)
      curproc->num_of_pages_in_swap_file = pg_swp_bu;
80100dc4:	8b 85 d8 fb ff ff    	mov    -0x428(%ebp),%eax
80100dca:	89 87 80 03 00 00    	mov    %eax,0x380(%edi)
      curproc->num_of_pageOut_occured = pg_out_bu;
80100dd0:	8b 85 e4 fb ff ff    	mov    -0x41c(%ebp),%eax
80100dd6:	89 87 8c 03 00 00    	mov    %eax,0x38c(%edi)
80100ddc:	31 c0                	xor    %eax,%eax
80100dde:	66 90                	xchg   %ax,%ax
        curproc->ram_pages[i] = mem_pginfo_bu[i];
80100de0:	8b 14 06             	mov    (%esi,%eax,1),%edx
80100de3:	89 94 07 00 02 00 00 	mov    %edx,0x200(%edi,%eax,1)
80100dea:	8b 54 06 04          	mov    0x4(%esi,%eax,1),%edx
80100dee:	89 94 07 04 02 00 00 	mov    %edx,0x204(%edi,%eax,1)
80100df5:	8b 54 06 08          	mov    0x8(%esi,%eax,1),%edx
80100df9:	89 94 07 08 02 00 00 	mov    %edx,0x208(%edi,%eax,1)
80100e00:	8b 54 06 0c          	mov    0xc(%esi,%eax,1),%edx
80100e04:	89 94 07 0c 02 00 00 	mov    %edx,0x20c(%edi,%eax,1)
80100e0b:	8b 54 06 10          	mov    0x10(%esi,%eax,1),%edx
80100e0f:	89 94 07 10 02 00 00 	mov    %edx,0x210(%edi,%eax,1)
80100e16:	8b 54 06 14          	mov    0x14(%esi,%eax,1),%edx
80100e1a:	89 94 07 14 02 00 00 	mov    %edx,0x214(%edi,%eax,1)
        curproc->swapped_out_pages[i] = swp_pginfo_bu[i];
80100e21:	8b 14 01             	mov    (%ecx,%eax,1),%edx
80100e24:	89 94 07 80 00 00 00 	mov    %edx,0x80(%edi,%eax,1)
80100e2b:	8b 54 01 04          	mov    0x4(%ecx,%eax,1),%edx
80100e2f:	89 94 07 84 00 00 00 	mov    %edx,0x84(%edi,%eax,1)
80100e36:	8b 54 01 08          	mov    0x8(%ecx,%eax,1),%edx
80100e3a:	89 94 07 88 00 00 00 	mov    %edx,0x88(%edi,%eax,1)
80100e41:	8b 54 01 0c          	mov    0xc(%ecx,%eax,1),%edx
80100e45:	89 94 07 8c 00 00 00 	mov    %edx,0x8c(%edi,%eax,1)
80100e4c:	8b 54 01 10          	mov    0x10(%ecx,%eax,1),%edx
80100e50:	89 94 07 90 00 00 00 	mov    %edx,0x90(%edi,%eax,1)
80100e57:	8b 54 01 14          	mov    0x14(%ecx,%eax,1),%edx
80100e5b:	89 94 07 94 00 00 00 	mov    %edx,0x94(%edi,%eax,1)
80100e62:	83 c0 18             	add    $0x18,%eax
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100e65:	3d 80 01 00 00       	cmp    $0x180,%eax
80100e6a:	0f 85 70 ff ff ff    	jne    80100de0 <exec+0x340>
      removeSwapFile(curproc);
80100e70:	83 ec 0c             	sub    $0xc,%esp
80100e73:	57                   	push   %edi
80100e74:	e8 d7 14 00 00       	call   80102350 <removeSwapFile>
      curproc->swapFile = swap_file_bu;
80100e79:	8b 85 e8 fb ff ff    	mov    -0x418(%ebp),%eax
80100e7f:	89 47 7c             	mov    %eax,0x7c(%edi)
    freevm(pgdir);
80100e82:	58                   	pop    %eax
80100e83:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80100e89:	e8 32 6c 00 00       	call   80107ac0 <freevm>
  if(ip){
80100e8e:	83 c4 10             	add    $0x10,%esp
80100e91:	85 db                	test   %ebx,%ebx
80100e93:	0f 85 59 fc ff ff    	jne    80100af2 <exec+0x52>
}
80100e99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80100e9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ea1:	5b                   	pop    %ebx
80100ea2:	5e                   	pop    %esi
80100ea3:	5f                   	pop    %edi
80100ea4:	5d                   	pop    %ebp
80100ea5:	c3                   	ret    
  struct file* swap_file_bu = 0;
80100ea6:	c7 85 e8 fb ff ff 00 	movl   $0x0,-0x418(%ebp)
80100ead:	00 00 00 
  uint pg_out_bu = 0, pg_flt_bu = 0, pg_mem_bu = 0, pg_swp_bu = 0;
80100eb0:	c7 85 d8 fb ff ff 00 	movl   $0x0,-0x428(%ebp)
80100eb7:	00 00 00 
80100eba:	c7 85 dc fb ff ff 00 	movl   $0x0,-0x424(%ebp)
80100ec1:	00 00 00 
80100ec4:	c7 85 e0 fb ff ff 00 	movl   $0x0,-0x420(%ebp)
80100ecb:	00 00 00 
80100ece:	c7 85 e4 fb ff ff 00 	movl   $0x0,-0x41c(%ebp)
80100ed5:	00 00 00 
80100ed8:	e9 c2 fd ff ff       	jmp    80100c9f <exec+0x1ff>
80100edd:	89 f8                	mov    %edi,%eax
80100edf:	8b bd f0 fb ff ff    	mov    -0x410(%ebp),%edi
80100ee5:	05 ff 0f 00 00       	add    $0xfff,%eax
80100eea:	89 c6                	mov    %eax,%esi
80100eec:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80100ef2:	8d 86 00 20 00 00    	lea    0x2000(%esi),%eax
  iunlockput(ip);
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
80100f01:	53                   	push   %ebx
80100f02:	e8 a9 0d 00 00       	call   80101cb0 <iunlockput>
  end_op();
80100f07:	e8 b4 24 00 00       	call   801033c0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100f0c:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
80100f12:	83 c4 0c             	add    $0xc,%esp
80100f15:	50                   	push   %eax
80100f16:	56                   	push   %esi
80100f17:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80100f1d:	e8 de 71 00 00       	call   80108100 <allocuvm>
80100f22:	83 c4 10             	add    $0x10,%esp
80100f25:	85 c0                	test   %eax,%eax
80100f27:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
80100f2d:	75 3f                	jne    80100f6e <exec+0x4ce>
    if (curproc->pid > 2){
80100f2f:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80100f33:	0f 8f 62 fe ff ff    	jg     80100d9b <exec+0x2fb>
    freevm(pgdir);
80100f39:	83 ec 0c             	sub    $0xc,%esp
80100f3c:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80100f42:	e8 79 6b 00 00       	call   80107ac0 <freevm>
80100f47:	83 c4 10             	add    $0x10,%esp
80100f4a:	e9 4a ff ff ff       	jmp    80100e99 <exec+0x3f9>
    end_op();
80100f4f:	e8 6c 24 00 00       	call   801033c0 <end_op>
    cprintf("exec: fail\n");
80100f54:	83 ec 0c             	sub    $0xc,%esp
80100f57:	68 81 86 10 80       	push   $0x80108681
80100f5c:	e8 ff f6 ff ff       	call   80100660 <cprintf>
    return -1;
80100f61:	83 c4 10             	add    $0x10,%esp
80100f64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f69:	e9 9a fb ff ff       	jmp    80100b08 <exec+0x68>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f6e:	89 c3                	mov    %eax,%ebx
80100f70:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100f76:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100f79:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f7b:	50                   	push   %eax
80100f7c:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80100f82:	e8 e9 6c 00 00       	call   80107c70 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100f87:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f8a:	83 c4 10             	add    $0x10,%esp
80100f8d:	8b 00                	mov    (%eax),%eax
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	75 12                	jne    80100fa5 <exec+0x505>
80100f93:	e9 51 01 00 00       	jmp    801010e9 <exec+0x649>
80100f98:	90                   	nop
80100f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100fa0:	83 fe 20             	cmp    $0x20,%esi
80100fa3:	74 8a                	je     80100f2f <exec+0x48f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100fa5:	83 ec 0c             	sub    $0xc,%esp
80100fa8:	50                   	push   %eax
80100fa9:	e8 72 41 00 00       	call   80105120 <strlen>
80100fae:	f7 d0                	not    %eax
80100fb0:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fb5:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100fb6:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fb9:	ff 34 b0             	pushl  (%eax,%esi,4)
80100fbc:	e8 5f 41 00 00       	call   80105120 <strlen>
80100fc1:	83 c0 01             	add    $0x1,%eax
80100fc4:	50                   	push   %eax
80100fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fc8:	ff 34 b0             	pushl  (%eax,%esi,4)
80100fcb:	53                   	push   %ebx
80100fcc:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80100fd2:	e8 19 6f 00 00       	call   80107ef0 <copyout>
80100fd7:	83 c4 20             	add    $0x20,%esp
80100fda:	85 c0                	test   %eax,%eax
80100fdc:	0f 88 4d ff ff ff    	js     80100f2f <exec+0x48f>
  for(argc = 0; argv[argc]; argc++) {
80100fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100fe5:	89 9c b5 64 fc ff ff 	mov    %ebx,-0x39c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100fec:	83 c6 01             	add    $0x1,%esi
    ustack[3+argc] = sp;
80100fef:	8d 95 58 fc ff ff    	lea    -0x3a8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100ff5:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100ff8:	85 c0                	test   %eax,%eax
80100ffa:	75 a4                	jne    80100fa0 <exec+0x500>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ffc:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80101003:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101005:	c7 84 b5 64 fc ff ff 	movl   $0x0,-0x39c(%ebp,%esi,4)
8010100c:	00 00 00 00 
  ustack[1] = argc;
80101010:	89 b5 5c fc ff ff    	mov    %esi,-0x3a4(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101016:	c7 85 58 fc ff ff ff 	movl   $0xffffffff,-0x3a8(%ebp)
8010101d:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101020:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80101022:	83 c0 0c             	add    $0xc,%eax
80101025:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101027:	50                   	push   %eax
80101028:	52                   	push   %edx
80101029:	53                   	push   %ebx
8010102a:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  sp -= (3+argc+1) * 4;
80101030:	89 de                	mov    %ebx,%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101032:	89 8d 60 fc ff ff    	mov    %ecx,-0x3a0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101038:	e8 b3 6e 00 00       	call   80107ef0 <copyout>
8010103d:	83 c4 10             	add    $0x10,%esp
80101040:	85 c0                	test   %eax,%eax
80101042:	0f 88 e7 fe ff ff    	js     80100f2f <exec+0x48f>
  for(last=s=path; *s; s++)
80101048:	8b 45 08             	mov    0x8(%ebp),%eax
8010104b:	0f b6 08             	movzbl (%eax),%ecx
8010104e:	84 c9                	test   %cl,%cl
80101050:	74 15                	je     80101067 <exec+0x5c7>
80101052:	89 c2                	mov    %eax,%edx
80101054:	83 c0 01             	add    $0x1,%eax
80101057:	80 f9 2f             	cmp    $0x2f,%cl
8010105a:	0f b6 08             	movzbl (%eax),%ecx
8010105d:	0f 44 d0             	cmove  %eax,%edx
80101060:	84 c9                	test   %cl,%cl
80101062:	75 f0                	jne    80101054 <exec+0x5b4>
80101064:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101067:	8d 47 6c             	lea    0x6c(%edi),%eax
8010106a:	83 ec 04             	sub    $0x4,%esp
8010106d:	6a 10                	push   $0x10
8010106f:	ff 75 08             	pushl  0x8(%ebp)
80101072:	50                   	push   %eax
80101073:	e8 68 40 00 00       	call   801050e0 <safestrcpy>
  curproc->pgdir = pgdir;
80101078:	8b 85 f4 fb ff ff    	mov    -0x40c(%ebp),%eax
  oldpgdir = curproc->pgdir;
8010107e:	8b 5f 04             	mov    0x4(%edi),%ebx
  if (curproc->pid > 2){
80101081:	83 c4 10             	add    $0x10,%esp
  curproc->pgdir = pgdir;
80101084:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
80101087:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
8010108d:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
8010108f:	8b 47 18             	mov    0x18(%edi),%eax
80101092:	8b 8d 3c fc ff ff    	mov    -0x3c4(%ebp),%ecx
80101098:	89 48 38             	mov    %ecx,0x38(%eax)
  curproc->tf->esp = sp;
8010109b:	8b 47 18             	mov    0x18(%edi),%eax
8010109e:	89 70 44             	mov    %esi,0x44(%eax)
  if (curproc->pid > 2){
801010a1:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
801010a5:	7e 1b                	jle    801010c2 <exec+0x622>
    curproc->swapFile = swap_file_bu;
801010a7:	8b 85 e8 fb ff ff    	mov    -0x418(%ebp),%eax
    temp_swap_file = curproc->swapFile;
801010ad:	8b 77 7c             	mov    0x7c(%edi),%esi
    removeSwapFile(curproc);
801010b0:	83 ec 0c             	sub    $0xc,%esp
    curproc->swapFile = swap_file_bu;
801010b3:	89 47 7c             	mov    %eax,0x7c(%edi)
    removeSwapFile(curproc);
801010b6:	57                   	push   %edi
801010b7:	e8 94 12 00 00       	call   80102350 <removeSwapFile>
    curproc->swapFile = temp_swap_file;
801010bc:	89 77 7c             	mov    %esi,0x7c(%edi)
801010bf:	83 c4 10             	add    $0x10,%esp
  switchuvm(curproc);
801010c2:	83 ec 0c             	sub    $0xc,%esp
801010c5:	57                   	push   %edi
801010c6:	e8 85 66 00 00       	call   80107750 <switchuvm>
  freevm(oldpgdir);
801010cb:	89 1c 24             	mov    %ebx,(%esp)
801010ce:	e8 ed 69 00 00       	call   80107ac0 <freevm>
  return 0;
801010d3:	83 c4 10             	add    $0x10,%esp
801010d6:	31 c0                	xor    %eax,%eax
801010d8:	e9 2b fa ff ff       	jmp    80100b08 <exec+0x68>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010dd:	31 f6                	xor    %esi,%esi
801010df:	b8 00 20 00 00       	mov    $0x2000,%eax
801010e4:	e9 0f fe ff ff       	jmp    80100ef8 <exec+0x458>
  for(argc = 0; argv[argc]; argc++) {
801010e9:	8b 9d f0 fb ff ff    	mov    -0x410(%ebp),%ebx
801010ef:	8d 95 58 fc ff ff    	lea    -0x3a8(%ebp),%edx
801010f5:	e9 02 ff ff ff       	jmp    80100ffc <exec+0x55c>
801010fa:	66 90                	xchg   %ax,%ax
801010fc:	66 90                	xchg   %ax,%ax
801010fe:	66 90                	xchg   %ax,%ax

80101100 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101106:	68 8d 86 10 80       	push   $0x8010868d
8010110b:	68 00 00 12 80       	push   $0x80120000
80101110:	e8 9b 3b 00 00       	call   80104cb0 <initlock>
}
80101115:	83 c4 10             	add    $0x10,%esp
80101118:	c9                   	leave  
80101119:	c3                   	ret    
8010111a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101120 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101124:	bb 34 00 12 80       	mov    $0x80120034,%ebx
{
80101129:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010112c:	68 00 00 12 80       	push   $0x80120000
80101131:	e8 ba 3c 00 00       	call   80104df0 <acquire>
80101136:	83 c4 10             	add    $0x10,%esp
80101139:	eb 10                	jmp    8010114b <filealloc+0x2b>
8010113b:	90                   	nop
8010113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101140:	83 c3 18             	add    $0x18,%ebx
80101143:	81 fb 94 09 12 80    	cmp    $0x80120994,%ebx
80101149:	73 25                	jae    80101170 <filealloc+0x50>
    if(f->ref == 0){
8010114b:	8b 43 04             	mov    0x4(%ebx),%eax
8010114e:	85 c0                	test   %eax,%eax
80101150:	75 ee                	jne    80101140 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101152:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101155:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010115c:	68 00 00 12 80       	push   $0x80120000
80101161:	e8 4a 3d 00 00       	call   80104eb0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101166:	89 d8                	mov    %ebx,%eax
      return f;
80101168:	83 c4 10             	add    $0x10,%esp
}
8010116b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010116e:	c9                   	leave  
8010116f:	c3                   	ret    
  release(&ftable.lock);
80101170:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101173:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101175:	68 00 00 12 80       	push   $0x80120000
8010117a:	e8 31 3d 00 00       	call   80104eb0 <release>
}
8010117f:	89 d8                	mov    %ebx,%eax
  return 0;
80101181:	83 c4 10             	add    $0x10,%esp
}
80101184:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101187:	c9                   	leave  
80101188:	c3                   	ret    
80101189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101190 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	53                   	push   %ebx
80101194:	83 ec 10             	sub    $0x10,%esp
80101197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010119a:	68 00 00 12 80       	push   $0x80120000
8010119f:	e8 4c 3c 00 00       	call   80104df0 <acquire>
  if(f->ref < 1)
801011a4:	8b 43 04             	mov    0x4(%ebx),%eax
801011a7:	83 c4 10             	add    $0x10,%esp
801011aa:	85 c0                	test   %eax,%eax
801011ac:	7e 1a                	jle    801011c8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801011ae:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801011b1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801011b4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801011b7:	68 00 00 12 80       	push   $0x80120000
801011bc:	e8 ef 3c 00 00       	call   80104eb0 <release>
  return f;
}
801011c1:	89 d8                	mov    %ebx,%eax
801011c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011c6:	c9                   	leave  
801011c7:	c3                   	ret    
    panic("filedup");
801011c8:	83 ec 0c             	sub    $0xc,%esp
801011cb:	68 94 86 10 80       	push   $0x80108694
801011d0:	e8 bb f1 ff ff       	call   80100390 <panic>
801011d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801011e0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 28             	sub    $0x28,%esp
801011e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801011ec:	68 00 00 12 80       	push   $0x80120000
801011f1:	e8 fa 3b 00 00       	call   80104df0 <acquire>
  if(f->ref < 1)
801011f6:	8b 43 04             	mov    0x4(%ebx),%eax
801011f9:	83 c4 10             	add    $0x10,%esp
801011fc:	85 c0                	test   %eax,%eax
801011fe:	0f 8e 9b 00 00 00    	jle    8010129f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101204:	83 e8 01             	sub    $0x1,%eax
80101207:	85 c0                	test   %eax,%eax
80101209:	89 43 04             	mov    %eax,0x4(%ebx)
8010120c:	74 1a                	je     80101228 <fileclose+0x48>
    release(&ftable.lock);
8010120e:	c7 45 08 00 00 12 80 	movl   $0x80120000,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101215:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101218:	5b                   	pop    %ebx
80101219:	5e                   	pop    %esi
8010121a:	5f                   	pop    %edi
8010121b:	5d                   	pop    %ebp
    release(&ftable.lock);
8010121c:	e9 8f 3c 00 00       	jmp    80104eb0 <release>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80101228:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
8010122c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
8010122e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101231:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80101234:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010123a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010123d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101240:	68 00 00 12 80       	push   $0x80120000
  ff = *f;
80101245:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101248:	e8 63 3c 00 00       	call   80104eb0 <release>
  if(ff.type == FD_PIPE)
8010124d:	83 c4 10             	add    $0x10,%esp
80101250:	83 ff 01             	cmp    $0x1,%edi
80101253:	74 13                	je     80101268 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80101255:	83 ff 02             	cmp    $0x2,%edi
80101258:	74 26                	je     80101280 <fileclose+0xa0>
}
8010125a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010125d:	5b                   	pop    %ebx
8010125e:	5e                   	pop    %esi
8010125f:	5f                   	pop    %edi
80101260:	5d                   	pop    %ebp
80101261:	c3                   	ret    
80101262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80101268:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010126c:	83 ec 08             	sub    $0x8,%esp
8010126f:	53                   	push   %ebx
80101270:	56                   	push   %esi
80101271:	e8 8a 28 00 00       	call   80103b00 <pipeclose>
80101276:	83 c4 10             	add    $0x10,%esp
80101279:	eb df                	jmp    8010125a <fileclose+0x7a>
8010127b:	90                   	nop
8010127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101280:	e8 cb 20 00 00       	call   80103350 <begin_op>
    iput(ff.ip);
80101285:	83 ec 0c             	sub    $0xc,%esp
80101288:	ff 75 e0             	pushl  -0x20(%ebp)
8010128b:	e8 c0 08 00 00       	call   80101b50 <iput>
    end_op();
80101290:	83 c4 10             	add    $0x10,%esp
}
80101293:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101296:	5b                   	pop    %ebx
80101297:	5e                   	pop    %esi
80101298:	5f                   	pop    %edi
80101299:	5d                   	pop    %ebp
    end_op();
8010129a:	e9 21 21 00 00       	jmp    801033c0 <end_op>
    panic("fileclose");
8010129f:	83 ec 0c             	sub    $0xc,%esp
801012a2:	68 9c 86 10 80       	push   $0x8010869c
801012a7:	e8 e4 f0 ff ff       	call   80100390 <panic>
801012ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012b0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	53                   	push   %ebx
801012b4:	83 ec 04             	sub    $0x4,%esp
801012b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801012ba:	83 3b 02             	cmpl   $0x2,(%ebx)
801012bd:	75 31                	jne    801012f0 <filestat+0x40>
    ilock(f->ip);
801012bf:	83 ec 0c             	sub    $0xc,%esp
801012c2:	ff 73 10             	pushl  0x10(%ebx)
801012c5:	e8 56 07 00 00       	call   80101a20 <ilock>
    stati(f->ip, st);
801012ca:	58                   	pop    %eax
801012cb:	5a                   	pop    %edx
801012cc:	ff 75 0c             	pushl  0xc(%ebp)
801012cf:	ff 73 10             	pushl  0x10(%ebx)
801012d2:	e8 f9 09 00 00       	call   80101cd0 <stati>
    iunlock(f->ip);
801012d7:	59                   	pop    %ecx
801012d8:	ff 73 10             	pushl  0x10(%ebx)
801012db:	e8 20 08 00 00       	call   80101b00 <iunlock>
    return 0;
801012e0:	83 c4 10             	add    $0x10,%esp
801012e3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
801012e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012e8:	c9                   	leave  
801012e9:	c3                   	ret    
801012ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
801012f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012f5:	eb ee                	jmp    801012e5 <filestat+0x35>
801012f7:	89 f6                	mov    %esi,%esi
801012f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101300 <fileread>:

// Read from file f.
int
fileread(struct file* f, char *addr, int n)
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	57                   	push   %edi
80101304:	56                   	push   %esi
80101305:	53                   	push   %ebx
80101306:	83 ec 0c             	sub    $0xc,%esp
80101309:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010130c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010130f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101312:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101316:	74 60                	je     80101378 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101318:	8b 03                	mov    (%ebx),%eax
8010131a:	83 f8 01             	cmp    $0x1,%eax
8010131d:	74 41                	je     80101360 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010131f:	83 f8 02             	cmp    $0x2,%eax
80101322:	75 5b                	jne    8010137f <fileread+0x7f>
    ilock(f->ip);
80101324:	83 ec 0c             	sub    $0xc,%esp
80101327:	ff 73 10             	pushl  0x10(%ebx)
8010132a:	e8 f1 06 00 00       	call   80101a20 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010132f:	57                   	push   %edi
80101330:	ff 73 14             	pushl  0x14(%ebx)
80101333:	56                   	push   %esi
80101334:	ff 73 10             	pushl  0x10(%ebx)
80101337:	e8 c4 09 00 00       	call   80101d00 <readi>
8010133c:	83 c4 20             	add    $0x20,%esp
8010133f:	85 c0                	test   %eax,%eax
80101341:	89 c6                	mov    %eax,%esi
80101343:	7e 03                	jle    80101348 <fileread+0x48>
      f->off += r;
80101345:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101348:	83 ec 0c             	sub    $0xc,%esp
8010134b:	ff 73 10             	pushl  0x10(%ebx)
8010134e:	e8 ad 07 00 00       	call   80101b00 <iunlock>
    return r;
80101353:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101356:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101359:	89 f0                	mov    %esi,%eax
8010135b:	5b                   	pop    %ebx
8010135c:	5e                   	pop    %esi
8010135d:	5f                   	pop    %edi
8010135e:	5d                   	pop    %ebp
8010135f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101360:	8b 43 0c             	mov    0xc(%ebx),%eax
80101363:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101366:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101369:	5b                   	pop    %ebx
8010136a:	5e                   	pop    %esi
8010136b:	5f                   	pop    %edi
8010136c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010136d:	e9 3e 29 00 00       	jmp    80103cb0 <piperead>
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101378:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010137d:	eb d7                	jmp    80101356 <fileread+0x56>
  panic("fileread");
8010137f:	83 ec 0c             	sub    $0xc,%esp
80101382:	68 a6 86 10 80       	push   $0x801086a6
80101387:	e8 04 f0 ff ff       	call   80100390 <panic>
8010138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101390 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	53                   	push   %ebx
80101396:	83 ec 1c             	sub    $0x1c,%esp
80101399:	8b 75 08             	mov    0x8(%ebp),%esi
8010139c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010139f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801013a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801013a6:	8b 45 10             	mov    0x10(%ebp),%eax
801013a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801013ac:	0f 84 aa 00 00 00    	je     8010145c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801013b2:	8b 06                	mov    (%esi),%eax
801013b4:	83 f8 01             	cmp    $0x1,%eax
801013b7:	0f 84 c3 00 00 00    	je     80101480 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801013bd:	83 f8 02             	cmp    $0x2,%eax
801013c0:	0f 85 d9 00 00 00    	jne    8010149f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801013c9:	31 ff                	xor    %edi,%edi
    while(i < n){
801013cb:	85 c0                	test   %eax,%eax
801013cd:	7f 34                	jg     80101403 <filewrite+0x73>
801013cf:	e9 9c 00 00 00       	jmp    80101470 <filewrite+0xe0>
801013d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801013d8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801013db:	83 ec 0c             	sub    $0xc,%esp
801013de:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801013e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801013e4:	e8 17 07 00 00       	call   80101b00 <iunlock>
      end_op();
801013e9:	e8 d2 1f 00 00       	call   801033c0 <end_op>
801013ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801013f1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801013f4:	39 c3                	cmp    %eax,%ebx
801013f6:	0f 85 96 00 00 00    	jne    80101492 <filewrite+0x102>
        panic("short filewrite");
      i += r;
801013fc:	01 df                	add    %ebx,%edi
    while(i < n){
801013fe:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101401:	7e 6d                	jle    80101470 <filewrite+0xe0>
      int n1 = n - i;
80101403:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101406:	b8 00 06 00 00       	mov    $0x600,%eax
8010140b:	29 fb                	sub    %edi,%ebx
8010140d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101413:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101416:	e8 35 1f 00 00       	call   80103350 <begin_op>
      ilock(f->ip);
8010141b:	83 ec 0c             	sub    $0xc,%esp
8010141e:	ff 76 10             	pushl  0x10(%esi)
80101421:	e8 fa 05 00 00       	call   80101a20 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101426:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101429:	53                   	push   %ebx
8010142a:	ff 76 14             	pushl  0x14(%esi)
8010142d:	01 f8                	add    %edi,%eax
8010142f:	50                   	push   %eax
80101430:	ff 76 10             	pushl  0x10(%esi)
80101433:	e8 c8 09 00 00       	call   80101e00 <writei>
80101438:	83 c4 20             	add    $0x20,%esp
8010143b:	85 c0                	test   %eax,%eax
8010143d:	7f 99                	jg     801013d8 <filewrite+0x48>
      iunlock(f->ip);
8010143f:	83 ec 0c             	sub    $0xc,%esp
80101442:	ff 76 10             	pushl  0x10(%esi)
80101445:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101448:	e8 b3 06 00 00       	call   80101b00 <iunlock>
      end_op();
8010144d:	e8 6e 1f 00 00       	call   801033c0 <end_op>
      if(r < 0)
80101452:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101455:	83 c4 10             	add    $0x10,%esp
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 98                	je     801013f4 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010145c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010145f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101464:	89 f8                	mov    %edi,%eax
80101466:	5b                   	pop    %ebx
80101467:	5e                   	pop    %esi
80101468:	5f                   	pop    %edi
80101469:	5d                   	pop    %ebp
8010146a:	c3                   	ret    
8010146b:	90                   	nop
8010146c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101470:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101473:	75 e7                	jne    8010145c <filewrite+0xcc>
}
80101475:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101478:	89 f8                	mov    %edi,%eax
8010147a:	5b                   	pop    %ebx
8010147b:	5e                   	pop    %esi
8010147c:	5f                   	pop    %edi
8010147d:	5d                   	pop    %ebp
8010147e:	c3                   	ret    
8010147f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101480:	8b 46 0c             	mov    0xc(%esi),%eax
80101483:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101486:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101489:	5b                   	pop    %ebx
8010148a:	5e                   	pop    %esi
8010148b:	5f                   	pop    %edi
8010148c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010148d:	e9 0e 27 00 00       	jmp    80103ba0 <pipewrite>
        panic("short filewrite");
80101492:	83 ec 0c             	sub    $0xc,%esp
80101495:	68 af 86 10 80       	push   $0x801086af
8010149a:	e8 f1 ee ff ff       	call   80100390 <panic>
  panic("filewrite");
8010149f:	83 ec 0c             	sub    $0xc,%esp
801014a2:	68 b5 86 10 80       	push   $0x801086b5
801014a7:	e8 e4 ee ff ff       	call   80100390 <panic>
801014ac:	66 90                	xchg   %ax,%ax
801014ae:	66 90                	xchg   %ax,%ax

801014b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	56                   	push   %esi
801014b4:	53                   	push   %ebx
801014b5:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801014b7:	c1 ea 0c             	shr    $0xc,%edx
801014ba:	03 15 18 0a 12 80    	add    0x80120a18,%edx
801014c0:	83 ec 08             	sub    $0x8,%esp
801014c3:	52                   	push   %edx
801014c4:	50                   	push   %eax
801014c5:	e8 06 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801014ca:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014cc:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014cf:	ba 01 00 00 00       	mov    $0x1,%edx
801014d4:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014d7:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014dd:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801014e0:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014e2:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014e7:	85 d1                	test   %edx,%ecx
801014e9:	74 25                	je     80101510 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801014eb:	f7 d2                	not    %edx
801014ed:	89 c6                	mov    %eax,%esi
  log_write(bp);
801014ef:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014f2:	21 ca                	and    %ecx,%edx
801014f4:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801014f8:	56                   	push   %esi
801014f9:	e8 22 20 00 00       	call   80103520 <log_write>
  brelse(bp);
801014fe:	89 34 24             	mov    %esi,(%esp)
80101501:	e8 da ec ff ff       	call   801001e0 <brelse>
}
80101506:	83 c4 10             	add    $0x10,%esp
80101509:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010150c:	5b                   	pop    %ebx
8010150d:	5e                   	pop    %esi
8010150e:	5d                   	pop    %ebp
8010150f:	c3                   	ret    
    panic("freeing free block");
80101510:	83 ec 0c             	sub    $0xc,%esp
80101513:	68 bf 86 10 80       	push   $0x801086bf
80101518:	e8 73 ee ff ff       	call   80100390 <panic>
8010151d:	8d 76 00             	lea    0x0(%esi),%esi

80101520 <balloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101529:	8b 0d 00 0a 12 80    	mov    0x80120a00,%ecx
{
8010152f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101532:	85 c9                	test   %ecx,%ecx
80101534:	0f 84 87 00 00 00    	je     801015c1 <balloc+0xa1>
8010153a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101541:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101544:	83 ec 08             	sub    $0x8,%esp
80101547:	89 f0                	mov    %esi,%eax
80101549:	c1 f8 0c             	sar    $0xc,%eax
8010154c:	03 05 18 0a 12 80    	add    0x80120a18,%eax
80101552:	50                   	push   %eax
80101553:	ff 75 d8             	pushl  -0x28(%ebp)
80101556:	e8 75 eb ff ff       	call   801000d0 <bread>
8010155b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010155e:	a1 00 0a 12 80       	mov    0x80120a00,%eax
80101563:	83 c4 10             	add    $0x10,%esp
80101566:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101569:	31 c0                	xor    %eax,%eax
8010156b:	eb 2f                	jmp    8010159c <balloc+0x7c>
8010156d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101570:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101572:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101575:	bb 01 00 00 00       	mov    $0x1,%ebx
8010157a:	83 e1 07             	and    $0x7,%ecx
8010157d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010157f:	89 c1                	mov    %eax,%ecx
80101581:	c1 f9 03             	sar    $0x3,%ecx
80101584:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101589:	85 df                	test   %ebx,%edi
8010158b:	89 fa                	mov    %edi,%edx
8010158d:	74 41                	je     801015d0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010158f:	83 c0 01             	add    $0x1,%eax
80101592:	83 c6 01             	add    $0x1,%esi
80101595:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010159a:	74 05                	je     801015a1 <balloc+0x81>
8010159c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010159f:	77 cf                	ja     80101570 <balloc+0x50>
    brelse(bp);
801015a1:	83 ec 0c             	sub    $0xc,%esp
801015a4:	ff 75 e4             	pushl  -0x1c(%ebp)
801015a7:	e8 34 ec ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801015ac:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801015b3:	83 c4 10             	add    $0x10,%esp
801015b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801015b9:	39 05 00 0a 12 80    	cmp    %eax,0x80120a00
801015bf:	77 80                	ja     80101541 <balloc+0x21>
  panic("balloc: out of blocks");
801015c1:	83 ec 0c             	sub    $0xc,%esp
801015c4:	68 d2 86 10 80       	push   $0x801086d2
801015c9:	e8 c2 ed ff ff       	call   80100390 <panic>
801015ce:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801015d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801015d3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801015d6:	09 da                	or     %ebx,%edx
801015d8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801015dc:	57                   	push   %edi
801015dd:	e8 3e 1f 00 00       	call   80103520 <log_write>
        brelse(bp);
801015e2:	89 3c 24             	mov    %edi,(%esp)
801015e5:	e8 f6 eb ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801015ea:	58                   	pop    %eax
801015eb:	5a                   	pop    %edx
801015ec:	56                   	push   %esi
801015ed:	ff 75 d8             	pushl  -0x28(%ebp)
801015f0:	e8 db ea ff ff       	call   801000d0 <bread>
801015f5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801015f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801015fa:	83 c4 0c             	add    $0xc,%esp
801015fd:	68 00 02 00 00       	push   $0x200
80101602:	6a 00                	push   $0x0
80101604:	50                   	push   %eax
80101605:	e8 f6 38 00 00       	call   80104f00 <memset>
  log_write(bp);
8010160a:	89 1c 24             	mov    %ebx,(%esp)
8010160d:	e8 0e 1f 00 00       	call   80103520 <log_write>
  brelse(bp);
80101612:	89 1c 24             	mov    %ebx,(%esp)
80101615:	e8 c6 eb ff ff       	call   801001e0 <brelse>
}
8010161a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010161d:	89 f0                	mov    %esi,%eax
8010161f:	5b                   	pop    %ebx
80101620:	5e                   	pop    %esi
80101621:	5f                   	pop    %edi
80101622:	5d                   	pop    %ebp
80101623:	c3                   	ret    
80101624:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010162a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101630 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101638:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010163a:	bb 54 0a 12 80       	mov    $0x80120a54,%ebx
{
8010163f:	83 ec 28             	sub    $0x28,%esp
80101642:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101645:	68 20 0a 12 80       	push   $0x80120a20
8010164a:	e8 a1 37 00 00       	call   80104df0 <acquire>
8010164f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101652:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101655:	eb 17                	jmp    8010166e <iget+0x3e>
80101657:	89 f6                	mov    %esi,%esi
80101659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101660:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101666:	81 fb 74 26 12 80    	cmp    $0x80122674,%ebx
8010166c:	73 22                	jae    80101690 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010166e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101671:	85 c9                	test   %ecx,%ecx
80101673:	7e 04                	jle    80101679 <iget+0x49>
80101675:	39 3b                	cmp    %edi,(%ebx)
80101677:	74 4f                	je     801016c8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101679:	85 f6                	test   %esi,%esi
8010167b:	75 e3                	jne    80101660 <iget+0x30>
8010167d:	85 c9                	test   %ecx,%ecx
8010167f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101682:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101688:	81 fb 74 26 12 80    	cmp    $0x80122674,%ebx
8010168e:	72 de                	jb     8010166e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101690:	85 f6                	test   %esi,%esi
80101692:	74 5b                	je     801016ef <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101694:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101697:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101699:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010169c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801016a3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801016aa:	68 20 0a 12 80       	push   $0x80120a20
801016af:	e8 fc 37 00 00       	call   80104eb0 <release>

  return ip;
801016b4:	83 c4 10             	add    $0x10,%esp
}
801016b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016ba:	89 f0                	mov    %esi,%eax
801016bc:	5b                   	pop    %ebx
801016bd:	5e                   	pop    %esi
801016be:	5f                   	pop    %edi
801016bf:	5d                   	pop    %ebp
801016c0:	c3                   	ret    
801016c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801016c8:	39 53 04             	cmp    %edx,0x4(%ebx)
801016cb:	75 ac                	jne    80101679 <iget+0x49>
      release(&icache.lock);
801016cd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801016d0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801016d3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801016d5:	68 20 0a 12 80       	push   $0x80120a20
      ip->ref++;
801016da:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801016dd:	e8 ce 37 00 00       	call   80104eb0 <release>
      return ip;
801016e2:	83 c4 10             	add    $0x10,%esp
}
801016e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016e8:	89 f0                	mov    %esi,%eax
801016ea:	5b                   	pop    %ebx
801016eb:	5e                   	pop    %esi
801016ec:	5f                   	pop    %edi
801016ed:	5d                   	pop    %ebp
801016ee:	c3                   	ret    
    panic("iget: no inodes");
801016ef:	83 ec 0c             	sub    $0xc,%esp
801016f2:	68 e8 86 10 80       	push   $0x801086e8
801016f7:	e8 94 ec ff ff       	call   80100390 <panic>
801016fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101700 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	57                   	push   %edi
80101704:	56                   	push   %esi
80101705:	53                   	push   %ebx
80101706:	89 c6                	mov    %eax,%esi
80101708:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010170b:	83 fa 0b             	cmp    $0xb,%edx
8010170e:	77 18                	ja     80101728 <bmap+0x28>
80101710:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101713:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101716:	85 db                	test   %ebx,%ebx
80101718:	74 76                	je     80101790 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010171a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010171d:	89 d8                	mov    %ebx,%eax
8010171f:	5b                   	pop    %ebx
80101720:	5e                   	pop    %esi
80101721:	5f                   	pop    %edi
80101722:	5d                   	pop    %ebp
80101723:	c3                   	ret    
80101724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101728:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010172b:	83 fb 7f             	cmp    $0x7f,%ebx
8010172e:	0f 87 90 00 00 00    	ja     801017c4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101734:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010173a:	8b 00                	mov    (%eax),%eax
8010173c:	85 d2                	test   %edx,%edx
8010173e:	74 70                	je     801017b0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101740:	83 ec 08             	sub    $0x8,%esp
80101743:	52                   	push   %edx
80101744:	50                   	push   %eax
80101745:	e8 86 e9 ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010174a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010174e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101751:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101753:	8b 1a                	mov    (%edx),%ebx
80101755:	85 db                	test   %ebx,%ebx
80101757:	75 1d                	jne    80101776 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101759:	8b 06                	mov    (%esi),%eax
8010175b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010175e:	e8 bd fd ff ff       	call   80101520 <balloc>
80101763:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101766:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101769:	89 c3                	mov    %eax,%ebx
8010176b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010176d:	57                   	push   %edi
8010176e:	e8 ad 1d 00 00       	call   80103520 <log_write>
80101773:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101776:	83 ec 0c             	sub    $0xc,%esp
80101779:	57                   	push   %edi
8010177a:	e8 61 ea ff ff       	call   801001e0 <brelse>
8010177f:	83 c4 10             	add    $0x10,%esp
}
80101782:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101785:	89 d8                	mov    %ebx,%eax
80101787:	5b                   	pop    %ebx
80101788:	5e                   	pop    %esi
80101789:	5f                   	pop    %edi
8010178a:	5d                   	pop    %ebp
8010178b:	c3                   	ret    
8010178c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101790:	8b 00                	mov    (%eax),%eax
80101792:	e8 89 fd ff ff       	call   80101520 <balloc>
80101797:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010179a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010179d:	89 c3                	mov    %eax,%ebx
}
8010179f:	89 d8                	mov    %ebx,%eax
801017a1:	5b                   	pop    %ebx
801017a2:	5e                   	pop    %esi
801017a3:	5f                   	pop    %edi
801017a4:	5d                   	pop    %ebp
801017a5:	c3                   	ret    
801017a6:	8d 76 00             	lea    0x0(%esi),%esi
801017a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801017b0:	e8 6b fd ff ff       	call   80101520 <balloc>
801017b5:	89 c2                	mov    %eax,%edx
801017b7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801017bd:	8b 06                	mov    (%esi),%eax
801017bf:	e9 7c ff ff ff       	jmp    80101740 <bmap+0x40>
  panic("bmap: out of range");
801017c4:	83 ec 0c             	sub    $0xc,%esp
801017c7:	68 f8 86 10 80       	push   $0x801086f8
801017cc:	e8 bf eb ff ff       	call   80100390 <panic>
801017d1:	eb 0d                	jmp    801017e0 <readsb>
801017d3:	90                   	nop
801017d4:	90                   	nop
801017d5:	90                   	nop
801017d6:	90                   	nop
801017d7:	90                   	nop
801017d8:	90                   	nop
801017d9:	90                   	nop
801017da:	90                   	nop
801017db:	90                   	nop
801017dc:	90                   	nop
801017dd:	90                   	nop
801017de:	90                   	nop
801017df:	90                   	nop

801017e0 <readsb>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	56                   	push   %esi
801017e4:	53                   	push   %ebx
801017e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801017e8:	83 ec 08             	sub    $0x8,%esp
801017eb:	6a 01                	push   $0x1
801017ed:	ff 75 08             	pushl  0x8(%ebp)
801017f0:	e8 db e8 ff ff       	call   801000d0 <bread>
801017f5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801017f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801017fa:	83 c4 0c             	add    $0xc,%esp
801017fd:	6a 1c                	push   $0x1c
801017ff:	50                   	push   %eax
80101800:	56                   	push   %esi
80101801:	e8 aa 37 00 00       	call   80104fb0 <memmove>
  brelse(bp);
80101806:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101809:	83 c4 10             	add    $0x10,%esp
}
8010180c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010180f:	5b                   	pop    %ebx
80101810:	5e                   	pop    %esi
80101811:	5d                   	pop    %ebp
  brelse(bp);
80101812:	e9 c9 e9 ff ff       	jmp    801001e0 <brelse>
80101817:	89 f6                	mov    %esi,%esi
80101819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101820 <iinit>:
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	53                   	push   %ebx
80101824:	bb 60 0a 12 80       	mov    $0x80120a60,%ebx
80101829:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010182c:	68 0b 87 10 80       	push   $0x8010870b
80101831:	68 20 0a 12 80       	push   $0x80120a20
80101836:	e8 75 34 00 00       	call   80104cb0 <initlock>
8010183b:	83 c4 10             	add    $0x10,%esp
8010183e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101840:	83 ec 08             	sub    $0x8,%esp
80101843:	68 12 87 10 80       	push   $0x80108712
80101848:	53                   	push   %ebx
80101849:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010184f:	e8 2c 33 00 00       	call   80104b80 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101854:	83 c4 10             	add    $0x10,%esp
80101857:	81 fb 80 26 12 80    	cmp    $0x80122680,%ebx
8010185d:	75 e1                	jne    80101840 <iinit+0x20>
  readsb(dev, &sb);
8010185f:	83 ec 08             	sub    $0x8,%esp
80101862:	68 00 0a 12 80       	push   $0x80120a00
80101867:	ff 75 08             	pushl  0x8(%ebp)
8010186a:	e8 71 ff ff ff       	call   801017e0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010186f:	ff 35 18 0a 12 80    	pushl  0x80120a18
80101875:	ff 35 14 0a 12 80    	pushl  0x80120a14
8010187b:	ff 35 10 0a 12 80    	pushl  0x80120a10
80101881:	ff 35 0c 0a 12 80    	pushl  0x80120a0c
80101887:	ff 35 08 0a 12 80    	pushl  0x80120a08
8010188d:	ff 35 04 0a 12 80    	pushl  0x80120a04
80101893:	ff 35 00 0a 12 80    	pushl  0x80120a00
80101899:	68 bc 87 10 80       	push   $0x801087bc
8010189e:	e8 bd ed ff ff       	call   80100660 <cprintf>
}
801018a3:	83 c4 30             	add    $0x30,%esp
801018a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018a9:	c9                   	leave  
801018aa:	c3                   	ret    
801018ab:	90                   	nop
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018b0 <ialloc>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801018b9:	83 3d 08 0a 12 80 01 	cmpl   $0x1,0x80120a08
{
801018c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801018c3:	8b 75 08             	mov    0x8(%ebp),%esi
801018c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801018c9:	0f 86 91 00 00 00    	jbe    80101960 <ialloc+0xb0>
801018cf:	bb 01 00 00 00       	mov    $0x1,%ebx
801018d4:	eb 21                	jmp    801018f7 <ialloc+0x47>
801018d6:	8d 76 00             	lea    0x0(%esi),%esi
801018d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801018e0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801018e3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801018e6:	57                   	push   %edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801018ec:	83 c4 10             	add    $0x10,%esp
801018ef:	39 1d 08 0a 12 80    	cmp    %ebx,0x80120a08
801018f5:	76 69                	jbe    80101960 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801018f7:	89 d8                	mov    %ebx,%eax
801018f9:	83 ec 08             	sub    $0x8,%esp
801018fc:	c1 e8 03             	shr    $0x3,%eax
801018ff:	03 05 14 0a 12 80    	add    0x80120a14,%eax
80101905:	50                   	push   %eax
80101906:	56                   	push   %esi
80101907:	e8 c4 e7 ff ff       	call   801000d0 <bread>
8010190c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010190e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101910:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101913:	83 e0 07             	and    $0x7,%eax
80101916:	c1 e0 06             	shl    $0x6,%eax
80101919:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010191d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101921:	75 bd                	jne    801018e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101923:	83 ec 04             	sub    $0x4,%esp
80101926:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101929:	6a 40                	push   $0x40
8010192b:	6a 00                	push   $0x0
8010192d:	51                   	push   %ecx
8010192e:	e8 cd 35 00 00       	call   80104f00 <memset>
      dip->type = type;
80101933:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101937:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010193a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010193d:	89 3c 24             	mov    %edi,(%esp)
80101940:	e8 db 1b 00 00       	call   80103520 <log_write>
      brelse(bp);
80101945:	89 3c 24             	mov    %edi,(%esp)
80101948:	e8 93 e8 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010194d:	83 c4 10             	add    $0x10,%esp
}
80101950:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101953:	89 da                	mov    %ebx,%edx
80101955:	89 f0                	mov    %esi,%eax
}
80101957:	5b                   	pop    %ebx
80101958:	5e                   	pop    %esi
80101959:	5f                   	pop    %edi
8010195a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010195b:	e9 d0 fc ff ff       	jmp    80101630 <iget>
  panic("ialloc: no inodes");
80101960:	83 ec 0c             	sub    $0xc,%esp
80101963:	68 18 87 10 80       	push   $0x80108718
80101968:	e8 23 ea ff ff       	call   80100390 <panic>
8010196d:	8d 76 00             	lea    0x0(%esi),%esi

80101970 <iupdate>:
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	56                   	push   %esi
80101974:	53                   	push   %ebx
80101975:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101978:	83 ec 08             	sub    $0x8,%esp
8010197b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010197e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101981:	c1 e8 03             	shr    $0x3,%eax
80101984:	03 05 14 0a 12 80    	add    0x80120a14,%eax
8010198a:	50                   	push   %eax
8010198b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101995:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101998:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010199c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010199f:	83 e0 07             	and    $0x7,%eax
801019a2:	c1 e0 06             	shl    $0x6,%eax
801019a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801019a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801019ac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019b0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801019b3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801019b7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801019bb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801019bf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801019c3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801019c7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801019ca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019cd:	6a 34                	push   $0x34
801019cf:	53                   	push   %ebx
801019d0:	50                   	push   %eax
801019d1:	e8 da 35 00 00       	call   80104fb0 <memmove>
  log_write(bp);
801019d6:	89 34 24             	mov    %esi,(%esp)
801019d9:	e8 42 1b 00 00       	call   80103520 <log_write>
  brelse(bp);
801019de:	89 75 08             	mov    %esi,0x8(%ebp)
801019e1:	83 c4 10             	add    $0x10,%esp
}
801019e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019e7:	5b                   	pop    %ebx
801019e8:	5e                   	pop    %esi
801019e9:	5d                   	pop    %ebp
  brelse(bp);
801019ea:	e9 f1 e7 ff ff       	jmp    801001e0 <brelse>
801019ef:	90                   	nop

801019f0 <idup>:
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	53                   	push   %ebx
801019f4:	83 ec 10             	sub    $0x10,%esp
801019f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801019fa:	68 20 0a 12 80       	push   $0x80120a20
801019ff:	e8 ec 33 00 00       	call   80104df0 <acquire>
  ip->ref++;
80101a04:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a08:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
80101a0f:	e8 9c 34 00 00       	call   80104eb0 <release>
}
80101a14:	89 d8                	mov    %ebx,%eax
80101a16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a19:	c9                   	leave  
80101a1a:	c3                   	ret    
80101a1b:	90                   	nop
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a20 <ilock>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101a28:	85 db                	test   %ebx,%ebx
80101a2a:	0f 84 b7 00 00 00    	je     80101ae7 <ilock+0xc7>
80101a30:	8b 53 08             	mov    0x8(%ebx),%edx
80101a33:	85 d2                	test   %edx,%edx
80101a35:	0f 8e ac 00 00 00    	jle    80101ae7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101a3b:	8d 43 0c             	lea    0xc(%ebx),%eax
80101a3e:	83 ec 0c             	sub    $0xc,%esp
80101a41:	50                   	push   %eax
80101a42:	e8 79 31 00 00       	call   80104bc0 <acquiresleep>
  if(ip->valid == 0){
80101a47:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101a4a:	83 c4 10             	add    $0x10,%esp
80101a4d:	85 c0                	test   %eax,%eax
80101a4f:	74 0f                	je     80101a60 <ilock+0x40>
}
80101a51:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a54:	5b                   	pop    %ebx
80101a55:	5e                   	pop    %esi
80101a56:	5d                   	pop    %ebp
80101a57:	c3                   	ret    
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a60:	8b 43 04             	mov    0x4(%ebx),%eax
80101a63:	83 ec 08             	sub    $0x8,%esp
80101a66:	c1 e8 03             	shr    $0x3,%eax
80101a69:	03 05 14 0a 12 80    	add    0x80120a14,%eax
80101a6f:	50                   	push   %eax
80101a70:	ff 33                	pushl  (%ebx)
80101a72:	e8 59 e6 ff ff       	call   801000d0 <bread>
80101a77:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a79:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a7c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a7f:	83 e0 07             	and    $0x7,%eax
80101a82:	c1 e0 06             	shl    $0x6,%eax
80101a85:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101a89:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a8c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101a8f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101a93:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101a97:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101a9b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101a9f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101aa3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101aa7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101aab:	8b 50 fc             	mov    -0x4(%eax),%edx
80101aae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ab1:	6a 34                	push   $0x34
80101ab3:	50                   	push   %eax
80101ab4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101ab7:	50                   	push   %eax
80101ab8:	e8 f3 34 00 00       	call   80104fb0 <memmove>
    brelse(bp);
80101abd:	89 34 24             	mov    %esi,(%esp)
80101ac0:	e8 1b e7 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101ac5:	83 c4 10             	add    $0x10,%esp
80101ac8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101acd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101ad4:	0f 85 77 ff ff ff    	jne    80101a51 <ilock+0x31>
      panic("ilock: no type");
80101ada:	83 ec 0c             	sub    $0xc,%esp
80101add:	68 30 87 10 80       	push   $0x80108730
80101ae2:	e8 a9 e8 ff ff       	call   80100390 <panic>
    panic("ilock");
80101ae7:	83 ec 0c             	sub    $0xc,%esp
80101aea:	68 2a 87 10 80       	push   $0x8010872a
80101aef:	e8 9c e8 ff ff       	call   80100390 <panic>
80101af4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101afa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101b00 <iunlock>:
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	56                   	push   %esi
80101b04:	53                   	push   %ebx
80101b05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b08:	85 db                	test   %ebx,%ebx
80101b0a:	74 28                	je     80101b34 <iunlock+0x34>
80101b0c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b0f:	83 ec 0c             	sub    $0xc,%esp
80101b12:	56                   	push   %esi
80101b13:	e8 48 31 00 00       	call   80104c60 <holdingsleep>
80101b18:	83 c4 10             	add    $0x10,%esp
80101b1b:	85 c0                	test   %eax,%eax
80101b1d:	74 15                	je     80101b34 <iunlock+0x34>
80101b1f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b22:	85 c0                	test   %eax,%eax
80101b24:	7e 0e                	jle    80101b34 <iunlock+0x34>
  releasesleep(&ip->lock);
80101b26:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101b29:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b2c:	5b                   	pop    %ebx
80101b2d:	5e                   	pop    %esi
80101b2e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101b2f:	e9 ec 30 00 00       	jmp    80104c20 <releasesleep>
    panic("iunlock");
80101b34:	83 ec 0c             	sub    $0xc,%esp
80101b37:	68 3f 87 10 80       	push   $0x8010873f
80101b3c:	e8 4f e8 ff ff       	call   80100390 <panic>
80101b41:	eb 0d                	jmp    80101b50 <iput>
80101b43:	90                   	nop
80101b44:	90                   	nop
80101b45:	90                   	nop
80101b46:	90                   	nop
80101b47:	90                   	nop
80101b48:	90                   	nop
80101b49:	90                   	nop
80101b4a:	90                   	nop
80101b4b:	90                   	nop
80101b4c:	90                   	nop
80101b4d:	90                   	nop
80101b4e:	90                   	nop
80101b4f:	90                   	nop

80101b50 <iput>:
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	57                   	push   %edi
80101b54:	56                   	push   %esi
80101b55:	53                   	push   %ebx
80101b56:	83 ec 28             	sub    $0x28,%esp
80101b59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101b5c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101b5f:	57                   	push   %edi
80101b60:	e8 5b 30 00 00       	call   80104bc0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101b65:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101b68:	83 c4 10             	add    $0x10,%esp
80101b6b:	85 d2                	test   %edx,%edx
80101b6d:	74 07                	je     80101b76 <iput+0x26>
80101b6f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101b74:	74 32                	je     80101ba8 <iput+0x58>
  releasesleep(&ip->lock);
80101b76:	83 ec 0c             	sub    $0xc,%esp
80101b79:	57                   	push   %edi
80101b7a:	e8 a1 30 00 00       	call   80104c20 <releasesleep>
  acquire(&icache.lock);
80101b7f:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
80101b86:	e8 65 32 00 00       	call   80104df0 <acquire>
  ip->ref--;
80101b8b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101b8f:	83 c4 10             	add    $0x10,%esp
80101b92:	c7 45 08 20 0a 12 80 	movl   $0x80120a20,0x8(%ebp)
}
80101b99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9c:	5b                   	pop    %ebx
80101b9d:	5e                   	pop    %esi
80101b9e:	5f                   	pop    %edi
80101b9f:	5d                   	pop    %ebp
  release(&icache.lock);
80101ba0:	e9 0b 33 00 00       	jmp    80104eb0 <release>
80101ba5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101ba8:	83 ec 0c             	sub    $0xc,%esp
80101bab:	68 20 0a 12 80       	push   $0x80120a20
80101bb0:	e8 3b 32 00 00       	call   80104df0 <acquire>
    int r = ip->ref;
80101bb5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101bb8:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
80101bbf:	e8 ec 32 00 00       	call   80104eb0 <release>
    if(r == 1){
80101bc4:	83 c4 10             	add    $0x10,%esp
80101bc7:	83 fe 01             	cmp    $0x1,%esi
80101bca:	75 aa                	jne    80101b76 <iput+0x26>
80101bcc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101bd2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101bd5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101bd8:	89 cf                	mov    %ecx,%edi
80101bda:	eb 0b                	jmp    80101be7 <iput+0x97>
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101be0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101be3:	39 fe                	cmp    %edi,%esi
80101be5:	74 19                	je     80101c00 <iput+0xb0>
    if(ip->addrs[i]){
80101be7:	8b 16                	mov    (%esi),%edx
80101be9:	85 d2                	test   %edx,%edx
80101beb:	74 f3                	je     80101be0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101bed:	8b 03                	mov    (%ebx),%eax
80101bef:	e8 bc f8 ff ff       	call   801014b0 <bfree>
      ip->addrs[i] = 0;
80101bf4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101bfa:	eb e4                	jmp    80101be0 <iput+0x90>
80101bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101c00:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101c06:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c09:	85 c0                	test   %eax,%eax
80101c0b:	75 33                	jne    80101c40 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101c0d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101c10:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101c17:	53                   	push   %ebx
80101c18:	e8 53 fd ff ff       	call   80101970 <iupdate>
      ip->type = 0;
80101c1d:	31 c0                	xor    %eax,%eax
80101c1f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101c23:	89 1c 24             	mov    %ebx,(%esp)
80101c26:	e8 45 fd ff ff       	call   80101970 <iupdate>
      ip->valid = 0;
80101c2b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101c32:	83 c4 10             	add    $0x10,%esp
80101c35:	e9 3c ff ff ff       	jmp    80101b76 <iput+0x26>
80101c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c40:	83 ec 08             	sub    $0x8,%esp
80101c43:	50                   	push   %eax
80101c44:	ff 33                	pushl  (%ebx)
80101c46:	e8 85 e4 ff ff       	call   801000d0 <bread>
80101c4b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101c51:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101c57:	8d 70 5c             	lea    0x5c(%eax),%esi
80101c5a:	83 c4 10             	add    $0x10,%esp
80101c5d:	89 cf                	mov    %ecx,%edi
80101c5f:	eb 0e                	jmp    80101c6f <iput+0x11f>
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c68:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101c6b:	39 fe                	cmp    %edi,%esi
80101c6d:	74 0f                	je     80101c7e <iput+0x12e>
      if(a[j])
80101c6f:	8b 16                	mov    (%esi),%edx
80101c71:	85 d2                	test   %edx,%edx
80101c73:	74 f3                	je     80101c68 <iput+0x118>
        bfree(ip->dev, a[j]);
80101c75:	8b 03                	mov    (%ebx),%eax
80101c77:	e8 34 f8 ff ff       	call   801014b0 <bfree>
80101c7c:	eb ea                	jmp    80101c68 <iput+0x118>
    brelse(bp);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
80101c81:	ff 75 e4             	pushl  -0x1c(%ebp)
80101c84:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c87:	e8 54 e5 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101c8c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101c92:	8b 03                	mov    (%ebx),%eax
80101c94:	e8 17 f8 ff ff       	call   801014b0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101c99:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101ca0:	00 00 00 
80101ca3:	83 c4 10             	add    $0x10,%esp
80101ca6:	e9 62 ff ff ff       	jmp    80101c0d <iput+0xbd>
80101cab:	90                   	nop
80101cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <iunlockput>:
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	53                   	push   %ebx
80101cb4:	83 ec 10             	sub    $0x10,%esp
80101cb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101cba:	53                   	push   %ebx
80101cbb:	e8 40 fe ff ff       	call   80101b00 <iunlock>
  iput(ip);
80101cc0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101cc3:	83 c4 10             	add    $0x10,%esp
}
80101cc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101cc9:	c9                   	leave  
  iput(ip);
80101cca:	e9 81 fe ff ff       	jmp    80101b50 <iput>
80101ccf:	90                   	nop

80101cd0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	8b 55 08             	mov    0x8(%ebp),%edx
80101cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101cd9:	8b 0a                	mov    (%edx),%ecx
80101cdb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101cde:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ce1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ce4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ce8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101ceb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101cef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101cf3:	8b 52 58             	mov    0x58(%edx),%edx
80101cf6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101cf9:	5d                   	pop    %ebp
80101cfa:	c3                   	ret    
80101cfb:	90                   	nop
80101cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	83 ec 1c             	sub    $0x1c,%esp
80101d09:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d17:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101d1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101d20:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101d23:	0f 84 a7 00 00 00    	je     80101dd0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101d29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d2c:	8b 40 58             	mov    0x58(%eax),%eax
80101d2f:	39 c6                	cmp    %eax,%esi
80101d31:	0f 87 ba 00 00 00    	ja     80101df1 <readi+0xf1>
80101d37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101d3a:	89 f9                	mov    %edi,%ecx
80101d3c:	01 f1                	add    %esi,%ecx
80101d3e:	0f 82 ad 00 00 00    	jb     80101df1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101d44:	89 c2                	mov    %eax,%edx
80101d46:	29 f2                	sub    %esi,%edx
80101d48:	39 c8                	cmp    %ecx,%eax
80101d4a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d4d:	31 ff                	xor    %edi,%edi
80101d4f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101d51:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d54:	74 6c                	je     80101dc2 <readi+0xc2>
80101d56:	8d 76 00             	lea    0x0(%esi),%esi
80101d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101d63:	89 f2                	mov    %esi,%edx
80101d65:	c1 ea 09             	shr    $0x9,%edx
80101d68:	89 d8                	mov    %ebx,%eax
80101d6a:	e8 91 f9 ff ff       	call   80101700 <bmap>
80101d6f:	83 ec 08             	sub    $0x8,%esp
80101d72:	50                   	push   %eax
80101d73:	ff 33                	pushl  (%ebx)
80101d75:	e8 56 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d7d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101d7f:	89 f0                	mov    %esi,%eax
80101d81:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d86:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d8b:	83 c4 0c             	add    $0xc,%esp
80101d8e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101d90:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101d94:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101d97:	29 fb                	sub    %edi,%ebx
80101d99:	39 d9                	cmp    %ebx,%ecx
80101d9b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101d9e:	53                   	push   %ebx
80101d9f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101da0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101da2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101da5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101da7:	e8 04 32 00 00       	call   80104fb0 <memmove>
    brelse(bp);
80101dac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101daf:	89 14 24             	mov    %edx,(%esp)
80101db2:	e8 29 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101db7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101dba:	83 c4 10             	add    $0x10,%esp
80101dbd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101dc0:	77 9e                	ja     80101d60 <readi+0x60>
  }
  return n;
80101dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101dc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc8:	5b                   	pop    %ebx
80101dc9:	5e                   	pop    %esi
80101dca:	5f                   	pop    %edi
80101dcb:	5d                   	pop    %ebp
80101dcc:	c3                   	ret    
80101dcd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101dd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101dd4:	66 83 f8 09          	cmp    $0x9,%ax
80101dd8:	77 17                	ja     80101df1 <readi+0xf1>
80101dda:	8b 04 c5 a0 09 12 80 	mov    -0x7fedf660(,%eax,8),%eax
80101de1:	85 c0                	test   %eax,%eax
80101de3:	74 0c                	je     80101df1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101de5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101def:	ff e0                	jmp    *%eax
      return -1;
80101df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101df6:	eb cd                	jmp    80101dc5 <readi+0xc5>
80101df8:	90                   	nop
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 1c             	sub    $0x1c,%esp
80101e09:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101e0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101e17:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101e1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101e20:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101e23:	0f 84 b7 00 00 00    	je     80101ee0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101e29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e2c:	39 70 58             	cmp    %esi,0x58(%eax)
80101e2f:	0f 82 eb 00 00 00    	jb     80101f20 <writei+0x120>
80101e35:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101e38:	31 d2                	xor    %edx,%edx
80101e3a:	89 f8                	mov    %edi,%eax
80101e3c:	01 f0                	add    %esi,%eax
80101e3e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101e41:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101e46:	0f 87 d4 00 00 00    	ja     80101f20 <writei+0x120>
80101e4c:	85 d2                	test   %edx,%edx
80101e4e:	0f 85 cc 00 00 00    	jne    80101f20 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e54:	85 ff                	test   %edi,%edi
80101e56:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101e5d:	74 72                	je     80101ed1 <writei+0xd1>
80101e5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e60:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101e63:	89 f2                	mov    %esi,%edx
80101e65:	c1 ea 09             	shr    $0x9,%edx
80101e68:	89 f8                	mov    %edi,%eax
80101e6a:	e8 91 f8 ff ff       	call   80101700 <bmap>
80101e6f:	83 ec 08             	sub    $0x8,%esp
80101e72:	50                   	push   %eax
80101e73:	ff 37                	pushl  (%edi)
80101e75:	e8 56 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e7a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101e7d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e80:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101e82:	89 f0                	mov    %esi,%eax
80101e84:	b9 00 02 00 00       	mov    $0x200,%ecx
80101e89:	83 c4 0c             	add    $0xc,%esp
80101e8c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e91:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101e93:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101e97:	39 d9                	cmp    %ebx,%ecx
80101e99:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101e9c:	53                   	push   %ebx
80101e9d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ea0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101ea2:	50                   	push   %eax
80101ea3:	e8 08 31 00 00       	call   80104fb0 <memmove>
    log_write(bp);
80101ea8:	89 3c 24             	mov    %edi,(%esp)
80101eab:	e8 70 16 00 00       	call   80103520 <log_write>
    brelse(bp);
80101eb0:	89 3c 24             	mov    %edi,(%esp)
80101eb3:	e8 28 e3 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101eb8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ebb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ec4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101ec7:	77 97                	ja     80101e60 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101ec9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ecc:	3b 70 58             	cmp    0x58(%eax),%esi
80101ecf:	77 37                	ja     80101f08 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ed1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ed4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ed7:	5b                   	pop    %ebx
80101ed8:	5e                   	pop    %esi
80101ed9:	5f                   	pop    %edi
80101eda:	5d                   	pop    %ebp
80101edb:	c3                   	ret    
80101edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ee0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ee4:	66 83 f8 09          	cmp    $0x9,%ax
80101ee8:	77 36                	ja     80101f20 <writei+0x120>
80101eea:	8b 04 c5 a4 09 12 80 	mov    -0x7fedf65c(,%eax,8),%eax
80101ef1:	85 c0                	test   %eax,%eax
80101ef3:	74 2b                	je     80101f20 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101ef5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ef8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efb:	5b                   	pop    %ebx
80101efc:	5e                   	pop    %esi
80101efd:	5f                   	pop    %edi
80101efe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101eff:	ff e0                	jmp    *%eax
80101f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101f08:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101f0b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101f0e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101f11:	50                   	push   %eax
80101f12:	e8 59 fa ff ff       	call   80101970 <iupdate>
80101f17:	83 c4 10             	add    $0x10,%esp
80101f1a:	eb b5                	jmp    80101ed1 <writei+0xd1>
80101f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f25:	eb ad                	jmp    80101ed4 <writei+0xd4>
80101f27:	89 f6                	mov    %esi,%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101f36:	6a 0e                	push   $0xe
80101f38:	ff 75 0c             	pushl  0xc(%ebp)
80101f3b:	ff 75 08             	pushl  0x8(%ebp)
80101f3e:	e8 dd 30 00 00       	call   80105020 <strncmp>
}
80101f43:	c9                   	leave  
80101f44:	c3                   	ret    
80101f45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	57                   	push   %edi
80101f54:	56                   	push   %esi
80101f55:	53                   	push   %ebx
80101f56:	83 ec 1c             	sub    $0x1c,%esp
80101f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101f5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101f61:	0f 85 85 00 00 00    	jne    80101fec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101f67:	8b 53 58             	mov    0x58(%ebx),%edx
80101f6a:	31 ff                	xor    %edi,%edi
80101f6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f6f:	85 d2                	test   %edx,%edx
80101f71:	74 3e                	je     80101fb1 <dirlookup+0x61>
80101f73:	90                   	nop
80101f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f78:	6a 10                	push   $0x10
80101f7a:	57                   	push   %edi
80101f7b:	56                   	push   %esi
80101f7c:	53                   	push   %ebx
80101f7d:	e8 7e fd ff ff       	call   80101d00 <readi>
80101f82:	83 c4 10             	add    $0x10,%esp
80101f85:	83 f8 10             	cmp    $0x10,%eax
80101f88:	75 55                	jne    80101fdf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101f8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f8f:	74 18                	je     80101fa9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101f91:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f94:	83 ec 04             	sub    $0x4,%esp
80101f97:	6a 0e                	push   $0xe
80101f99:	50                   	push   %eax
80101f9a:	ff 75 0c             	pushl  0xc(%ebp)
80101f9d:	e8 7e 30 00 00       	call   80105020 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101fa2:	83 c4 10             	add    $0x10,%esp
80101fa5:	85 c0                	test   %eax,%eax
80101fa7:	74 17                	je     80101fc0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fa9:	83 c7 10             	add    $0x10,%edi
80101fac:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101faf:	72 c7                	jb     80101f78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101fb4:	31 c0                	xor    %eax,%eax
}
80101fb6:	5b                   	pop    %ebx
80101fb7:	5e                   	pop    %esi
80101fb8:	5f                   	pop    %edi
80101fb9:	5d                   	pop    %ebp
80101fba:	c3                   	ret    
80101fbb:	90                   	nop
80101fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101fc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc3:	85 c0                	test   %eax,%eax
80101fc5:	74 05                	je     80101fcc <dirlookup+0x7c>
        *poff = off;
80101fc7:	8b 45 10             	mov    0x10(%ebp),%eax
80101fca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101fcc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101fd0:	8b 03                	mov    (%ebx),%eax
80101fd2:	e8 59 f6 ff ff       	call   80101630 <iget>
}
80101fd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fda:	5b                   	pop    %ebx
80101fdb:	5e                   	pop    %esi
80101fdc:	5f                   	pop    %edi
80101fdd:	5d                   	pop    %ebp
80101fde:	c3                   	ret    
      panic("dirlookup read");
80101fdf:	83 ec 0c             	sub    $0xc,%esp
80101fe2:	68 59 87 10 80       	push   $0x80108759
80101fe7:	e8 a4 e3 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101fec:	83 ec 0c             	sub    $0xc,%esp
80101fef:	68 47 87 10 80       	push   $0x80108747
80101ff4:	e8 97 e3 ff ff       	call   80100390 <panic>
80101ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102000 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	57                   	push   %edi
80102004:	56                   	push   %esi
80102005:	53                   	push   %ebx
80102006:	89 cf                	mov    %ecx,%edi
80102008:	89 c3                	mov    %eax,%ebx
8010200a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010200d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80102010:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80102013:	0f 84 67 01 00 00    	je     80102180 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80102019:	e8 f2 1f 00 00       	call   80104010 <myproc>
  acquire(&icache.lock);
8010201e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102021:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102024:	68 20 0a 12 80       	push   $0x80120a20
80102029:	e8 c2 2d 00 00       	call   80104df0 <acquire>
  ip->ref++;
8010202e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102032:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
80102039:	e8 72 2e 00 00       	call   80104eb0 <release>
8010203e:	83 c4 10             	add    $0x10,%esp
80102041:	eb 08                	jmp    8010204b <namex+0x4b>
80102043:	90                   	nop
80102044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102048:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010204b:	0f b6 03             	movzbl (%ebx),%eax
8010204e:	3c 2f                	cmp    $0x2f,%al
80102050:	74 f6                	je     80102048 <namex+0x48>
  if(*path == 0)
80102052:	84 c0                	test   %al,%al
80102054:	0f 84 ee 00 00 00    	je     80102148 <namex+0x148>
  while(*path != '/' && *path != 0)
8010205a:	0f b6 03             	movzbl (%ebx),%eax
8010205d:	3c 2f                	cmp    $0x2f,%al
8010205f:	0f 84 b3 00 00 00    	je     80102118 <namex+0x118>
80102065:	84 c0                	test   %al,%al
80102067:	89 da                	mov    %ebx,%edx
80102069:	75 09                	jne    80102074 <namex+0x74>
8010206b:	e9 a8 00 00 00       	jmp    80102118 <namex+0x118>
80102070:	84 c0                	test   %al,%al
80102072:	74 0a                	je     8010207e <namex+0x7e>
    path++;
80102074:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80102077:	0f b6 02             	movzbl (%edx),%eax
8010207a:	3c 2f                	cmp    $0x2f,%al
8010207c:	75 f2                	jne    80102070 <namex+0x70>
8010207e:	89 d1                	mov    %edx,%ecx
80102080:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80102082:	83 f9 0d             	cmp    $0xd,%ecx
80102085:	0f 8e 91 00 00 00    	jle    8010211c <namex+0x11c>
    memmove(name, s, DIRSIZ);
8010208b:	83 ec 04             	sub    $0x4,%esp
8010208e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102091:	6a 0e                	push   $0xe
80102093:	53                   	push   %ebx
80102094:	57                   	push   %edi
80102095:	e8 16 2f 00 00       	call   80104fb0 <memmove>
    path++;
8010209a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
8010209d:	83 c4 10             	add    $0x10,%esp
    path++;
801020a0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
801020a2:	80 3a 2f             	cmpb   $0x2f,(%edx)
801020a5:	75 11                	jne    801020b8 <namex+0xb8>
801020a7:	89 f6                	mov    %esi,%esi
801020a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
801020b0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801020b3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801020b6:	74 f8                	je     801020b0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801020b8:	83 ec 0c             	sub    $0xc,%esp
801020bb:	56                   	push   %esi
801020bc:	e8 5f f9 ff ff       	call   80101a20 <ilock>
    if(ip->type != T_DIR){
801020c1:	83 c4 10             	add    $0x10,%esp
801020c4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801020c9:	0f 85 91 00 00 00    	jne    80102160 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801020cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
801020d2:	85 d2                	test   %edx,%edx
801020d4:	74 09                	je     801020df <namex+0xdf>
801020d6:	80 3b 00             	cmpb   $0x0,(%ebx)
801020d9:	0f 84 b7 00 00 00    	je     80102196 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801020df:	83 ec 04             	sub    $0x4,%esp
801020e2:	6a 00                	push   $0x0
801020e4:	57                   	push   %edi
801020e5:	56                   	push   %esi
801020e6:	e8 65 fe ff ff       	call   80101f50 <dirlookup>
801020eb:	83 c4 10             	add    $0x10,%esp
801020ee:	85 c0                	test   %eax,%eax
801020f0:	74 6e                	je     80102160 <namex+0x160>
  iunlock(ip);
801020f2:	83 ec 0c             	sub    $0xc,%esp
801020f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801020f8:	56                   	push   %esi
801020f9:	e8 02 fa ff ff       	call   80101b00 <iunlock>
  iput(ip);
801020fe:	89 34 24             	mov    %esi,(%esp)
80102101:	e8 4a fa ff ff       	call   80101b50 <iput>
80102106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102109:	83 c4 10             	add    $0x10,%esp
8010210c:	89 c6                	mov    %eax,%esi
8010210e:	e9 38 ff ff ff       	jmp    8010204b <namex+0x4b>
80102113:	90                   	nop
80102114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80102118:	89 da                	mov    %ebx,%edx
8010211a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
8010211c:	83 ec 04             	sub    $0x4,%esp
8010211f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102122:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102125:	51                   	push   %ecx
80102126:	53                   	push   %ebx
80102127:	57                   	push   %edi
80102128:	e8 83 2e 00 00       	call   80104fb0 <memmove>
    name[len] = 0;
8010212d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102130:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010213a:	89 d3                	mov    %edx,%ebx
8010213c:	e9 61 ff ff ff       	jmp    801020a2 <namex+0xa2>
80102141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102148:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010214b:	85 c0                	test   %eax,%eax
8010214d:	75 5d                	jne    801021ac <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
8010214f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102152:	89 f0                	mov    %esi,%eax
80102154:	5b                   	pop    %ebx
80102155:	5e                   	pop    %esi
80102156:	5f                   	pop    %edi
80102157:	5d                   	pop    %ebp
80102158:	c3                   	ret    
80102159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	56                   	push   %esi
80102164:	e8 97 f9 ff ff       	call   80101b00 <iunlock>
  iput(ip);
80102169:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010216c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010216e:	e8 dd f9 ff ff       	call   80101b50 <iput>
      return 0;
80102173:	83 c4 10             	add    $0x10,%esp
}
80102176:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102179:	89 f0                	mov    %esi,%eax
8010217b:	5b                   	pop    %ebx
8010217c:	5e                   	pop    %esi
8010217d:	5f                   	pop    %edi
8010217e:	5d                   	pop    %ebp
8010217f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102180:	ba 01 00 00 00       	mov    $0x1,%edx
80102185:	b8 01 00 00 00       	mov    $0x1,%eax
8010218a:	e8 a1 f4 ff ff       	call   80101630 <iget>
8010218f:	89 c6                	mov    %eax,%esi
80102191:	e9 b5 fe ff ff       	jmp    8010204b <namex+0x4b>
      iunlock(ip);
80102196:	83 ec 0c             	sub    $0xc,%esp
80102199:	56                   	push   %esi
8010219a:	e8 61 f9 ff ff       	call   80101b00 <iunlock>
      return ip;
8010219f:	83 c4 10             	add    $0x10,%esp
}
801021a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021a5:	89 f0                	mov    %esi,%eax
801021a7:	5b                   	pop    %ebx
801021a8:	5e                   	pop    %esi
801021a9:	5f                   	pop    %edi
801021aa:	5d                   	pop    %ebp
801021ab:	c3                   	ret    
    iput(ip);
801021ac:	83 ec 0c             	sub    $0xc,%esp
801021af:	56                   	push   %esi
    return 0;
801021b0:	31 f6                	xor    %esi,%esi
    iput(ip);
801021b2:	e8 99 f9 ff ff       	call   80101b50 <iput>
    return 0;
801021b7:	83 c4 10             	add    $0x10,%esp
801021ba:	eb 93                	jmp    8010214f <namex+0x14f>
801021bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021c0 <dirlink>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	57                   	push   %edi
801021c4:	56                   	push   %esi
801021c5:	53                   	push   %ebx
801021c6:	83 ec 20             	sub    $0x20,%esp
801021c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801021cc:	6a 00                	push   $0x0
801021ce:	ff 75 0c             	pushl  0xc(%ebp)
801021d1:	53                   	push   %ebx
801021d2:	e8 79 fd ff ff       	call   80101f50 <dirlookup>
801021d7:	83 c4 10             	add    $0x10,%esp
801021da:	85 c0                	test   %eax,%eax
801021dc:	75 67                	jne    80102245 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801021de:	8b 7b 58             	mov    0x58(%ebx),%edi
801021e1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021e4:	85 ff                	test   %edi,%edi
801021e6:	74 29                	je     80102211 <dirlink+0x51>
801021e8:	31 ff                	xor    %edi,%edi
801021ea:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021ed:	eb 09                	jmp    801021f8 <dirlink+0x38>
801021ef:	90                   	nop
801021f0:	83 c7 10             	add    $0x10,%edi
801021f3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801021f6:	73 19                	jae    80102211 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021f8:	6a 10                	push   $0x10
801021fa:	57                   	push   %edi
801021fb:	56                   	push   %esi
801021fc:	53                   	push   %ebx
801021fd:	e8 fe fa ff ff       	call   80101d00 <readi>
80102202:	83 c4 10             	add    $0x10,%esp
80102205:	83 f8 10             	cmp    $0x10,%eax
80102208:	75 4e                	jne    80102258 <dirlink+0x98>
    if(de.inum == 0)
8010220a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010220f:	75 df                	jne    801021f0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102211:	8d 45 da             	lea    -0x26(%ebp),%eax
80102214:	83 ec 04             	sub    $0x4,%esp
80102217:	6a 0e                	push   $0xe
80102219:	ff 75 0c             	pushl  0xc(%ebp)
8010221c:	50                   	push   %eax
8010221d:	e8 5e 2e 00 00       	call   80105080 <strncpy>
  de.inum = inum;
80102222:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102225:	6a 10                	push   $0x10
80102227:	57                   	push   %edi
80102228:	56                   	push   %esi
80102229:	53                   	push   %ebx
  de.inum = inum;
8010222a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010222e:	e8 cd fb ff ff       	call   80101e00 <writei>
80102233:	83 c4 20             	add    $0x20,%esp
80102236:	83 f8 10             	cmp    $0x10,%eax
80102239:	75 2a                	jne    80102265 <dirlink+0xa5>
  return 0;
8010223b:	31 c0                	xor    %eax,%eax
}
8010223d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102240:	5b                   	pop    %ebx
80102241:	5e                   	pop    %esi
80102242:	5f                   	pop    %edi
80102243:	5d                   	pop    %ebp
80102244:	c3                   	ret    
    iput(ip);
80102245:	83 ec 0c             	sub    $0xc,%esp
80102248:	50                   	push   %eax
80102249:	e8 02 f9 ff ff       	call   80101b50 <iput>
    return -1;
8010224e:	83 c4 10             	add    $0x10,%esp
80102251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102256:	eb e5                	jmp    8010223d <dirlink+0x7d>
      panic("dirlink read");
80102258:	83 ec 0c             	sub    $0xc,%esp
8010225b:	68 68 87 10 80       	push   $0x80108768
80102260:	e8 2b e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102265:	83 ec 0c             	sub    $0xc,%esp
80102268:	68 f1 8d 10 80       	push   $0x80108df1
8010226d:	e8 1e e1 ff ff       	call   80100390 <panic>
80102272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102280 <namei>:

struct inode*
namei(char *path)
{
80102280:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102281:	31 d2                	xor    %edx,%edx
{
80102283:	89 e5                	mov    %esp,%ebp
80102285:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102288:	8b 45 08             	mov    0x8(%ebp),%eax
8010228b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010228e:	e8 6d fd ff ff       	call   80102000 <namex>
}
80102293:	c9                   	leave  
80102294:	c3                   	ret    
80102295:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801022a0:	55                   	push   %ebp
  return namex(path, 1, name);
801022a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801022a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801022a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801022ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801022af:	e9 4c fd ff ff       	jmp    80102000 <namex>
801022b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801022c0 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
801022c0:	55                   	push   %ebp
    char const digit[] = "0123456789";
801022c1:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
801022c6:	89 e5                	mov    %esp,%ebp
801022c8:	57                   	push   %edi
801022c9:	56                   	push   %esi
801022ca:	53                   	push   %ebx
801022cb:	83 ec 10             	sub    $0x10,%esp
801022ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
801022d1:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
801022d8:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
801022df:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
801022e3:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
801022e7:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
801022ea:	85 c9                	test   %ecx,%ecx
801022ec:	79 0a                	jns    801022f8 <itoa+0x38>
801022ee:	89 f0                	mov    %esi,%eax
801022f0:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
801022f3:	f7 d9                	neg    %ecx
        *p++ = '-';
801022f5:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
801022f8:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
801022fa:	bf 67 66 66 66       	mov    $0x66666667,%edi
801022ff:	90                   	nop
80102300:	89 d8                	mov    %ebx,%eax
80102302:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80102305:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80102308:	f7 ef                	imul   %edi
8010230a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
8010230d:	29 da                	sub    %ebx,%edx
8010230f:	89 d3                	mov    %edx,%ebx
80102311:	75 ed                	jne    80102300 <itoa+0x40>
    *p = '\0';
80102313:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102316:	bb 67 66 66 66       	mov    $0x66666667,%ebx
8010231b:	90                   	nop
8010231c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102320:	89 c8                	mov    %ecx,%eax
80102322:	83 ee 01             	sub    $0x1,%esi
80102325:	f7 eb                	imul   %ebx
80102327:	89 c8                	mov    %ecx,%eax
80102329:	c1 f8 1f             	sar    $0x1f,%eax
8010232c:	c1 fa 02             	sar    $0x2,%edx
8010232f:	29 c2                	sub    %eax,%edx
80102331:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102334:	01 c0                	add    %eax,%eax
80102336:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80102338:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
8010233a:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
8010233f:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102341:	88 06                	mov    %al,(%esi)
    }while(i);
80102343:	75 db                	jne    80102320 <itoa+0x60>
    return b;
}
80102345:	8b 45 0c             	mov    0xc(%ebp),%eax
80102348:	83 c4 10             	add    $0x10,%esp
8010234b:	5b                   	pop    %ebx
8010234c:	5e                   	pop    %esi
8010234d:	5f                   	pop    %edi
8010234e:	5d                   	pop    %ebp
8010234f:	c3                   	ret    

80102350 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	57                   	push   %edi
80102354:	56                   	push   %esi
80102355:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102356:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80102359:	83 ec 40             	sub    $0x40,%esp
8010235c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010235f:	6a 06                	push   $0x6
80102361:	68 75 87 10 80       	push   $0x80108775
80102366:	56                   	push   %esi
80102367:	e8 44 2c 00 00       	call   80104fb0 <memmove>
  itoa(p->pid, path+ 6);
8010236c:	58                   	pop    %eax
8010236d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102370:	5a                   	pop    %edx
80102371:	50                   	push   %eax
80102372:	ff 73 10             	pushl  0x10(%ebx)
80102375:	e8 46 ff ff ff       	call   801022c0 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010237a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010237d:	83 c4 10             	add    $0x10,%esp
80102380:	85 c0                	test   %eax,%eax
80102382:	0f 84 88 01 00 00    	je     80102510 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102388:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010238b:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
8010238e:	50                   	push   %eax
8010238f:	e8 4c ee ff ff       	call   801011e0 <fileclose>

  begin_op();
80102394:	e8 b7 0f 00 00       	call   80103350 <begin_op>
  return namex(path, 1, name);
80102399:	89 f0                	mov    %esi,%eax
8010239b:	89 d9                	mov    %ebx,%ecx
8010239d:	ba 01 00 00 00       	mov    $0x1,%edx
801023a2:	e8 59 fc ff ff       	call   80102000 <namex>
  if((dp = nameiparent(path, name)) == 0)
801023a7:	83 c4 10             	add    $0x10,%esp
801023aa:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
801023ac:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
801023ae:	0f 84 66 01 00 00    	je     8010251a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	50                   	push   %eax
801023b8:	e8 63 f6 ff ff       	call   80101a20 <ilock>
  return strncmp(s, t, DIRSIZ);
801023bd:	83 c4 0c             	add    $0xc,%esp
801023c0:	6a 0e                	push   $0xe
801023c2:	68 7d 87 10 80       	push   $0x8010877d
801023c7:	53                   	push   %ebx
801023c8:	e8 53 2c 00 00       	call   80105020 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801023cd:	83 c4 10             	add    $0x10,%esp
801023d0:	85 c0                	test   %eax,%eax
801023d2:	0f 84 f8 00 00 00    	je     801024d0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801023d8:	83 ec 04             	sub    $0x4,%esp
801023db:	6a 0e                	push   $0xe
801023dd:	68 7c 87 10 80       	push   $0x8010877c
801023e2:	53                   	push   %ebx
801023e3:	e8 38 2c 00 00       	call   80105020 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801023e8:	83 c4 10             	add    $0x10,%esp
801023eb:	85 c0                	test   %eax,%eax
801023ed:	0f 84 dd 00 00 00    	je     801024d0 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801023f3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801023f6:	83 ec 04             	sub    $0x4,%esp
801023f9:	50                   	push   %eax
801023fa:	53                   	push   %ebx
801023fb:	56                   	push   %esi
801023fc:	e8 4f fb ff ff       	call   80101f50 <dirlookup>
80102401:	83 c4 10             	add    $0x10,%esp
80102404:	85 c0                	test   %eax,%eax
80102406:	89 c3                	mov    %eax,%ebx
80102408:	0f 84 c2 00 00 00    	je     801024d0 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010240e:	83 ec 0c             	sub    $0xc,%esp
80102411:	50                   	push   %eax
80102412:	e8 09 f6 ff ff       	call   80101a20 <ilock>

  if(ip->nlink < 1)
80102417:	83 c4 10             	add    $0x10,%esp
8010241a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010241f:	0f 8e 11 01 00 00    	jle    80102536 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102425:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010242a:	74 74                	je     801024a0 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010242c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010242f:	83 ec 04             	sub    $0x4,%esp
80102432:	6a 10                	push   $0x10
80102434:	6a 00                	push   $0x0
80102436:	57                   	push   %edi
80102437:	e8 c4 2a 00 00       	call   80104f00 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010243c:	6a 10                	push   $0x10
8010243e:	ff 75 b8             	pushl  -0x48(%ebp)
80102441:	57                   	push   %edi
80102442:	56                   	push   %esi
80102443:	e8 b8 f9 ff ff       	call   80101e00 <writei>
80102448:	83 c4 20             	add    $0x20,%esp
8010244b:	83 f8 10             	cmp    $0x10,%eax
8010244e:	0f 85 d5 00 00 00    	jne    80102529 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102454:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102459:	0f 84 91 00 00 00    	je     801024f0 <removeSwapFile+0x1a0>
  iunlock(ip);
8010245f:	83 ec 0c             	sub    $0xc,%esp
80102462:	56                   	push   %esi
80102463:	e8 98 f6 ff ff       	call   80101b00 <iunlock>
  iput(ip);
80102468:	89 34 24             	mov    %esi,(%esp)
8010246b:	e8 e0 f6 ff ff       	call   80101b50 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102470:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102475:	89 1c 24             	mov    %ebx,(%esp)
80102478:	e8 f3 f4 ff ff       	call   80101970 <iupdate>
  iunlock(ip);
8010247d:	89 1c 24             	mov    %ebx,(%esp)
80102480:	e8 7b f6 ff ff       	call   80101b00 <iunlock>
  iput(ip);
80102485:	89 1c 24             	mov    %ebx,(%esp)
80102488:	e8 c3 f6 ff ff       	call   80101b50 <iput>
  iunlockput(ip);

  end_op();
8010248d:	e8 2e 0f 00 00       	call   801033c0 <end_op>

  return 0;
80102492:	83 c4 10             	add    $0x10,%esp
80102495:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102497:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010249a:	5b                   	pop    %ebx
8010249b:	5e                   	pop    %esi
8010249c:	5f                   	pop    %edi
8010249d:	5d                   	pop    %ebp
8010249e:	c3                   	ret    
8010249f:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
801024a0:	83 ec 0c             	sub    $0xc,%esp
801024a3:	53                   	push   %ebx
801024a4:	e8 37 32 00 00       	call   801056e0 <isdirempty>
801024a9:	83 c4 10             	add    $0x10,%esp
801024ac:	85 c0                	test   %eax,%eax
801024ae:	0f 85 78 ff ff ff    	jne    8010242c <removeSwapFile+0xdc>
  iunlock(ip);
801024b4:	83 ec 0c             	sub    $0xc,%esp
801024b7:	53                   	push   %ebx
801024b8:	e8 43 f6 ff ff       	call   80101b00 <iunlock>
  iput(ip);
801024bd:	89 1c 24             	mov    %ebx,(%esp)
801024c0:	e8 8b f6 ff ff       	call   80101b50 <iput>
801024c5:	83 c4 10             	add    $0x10,%esp
801024c8:	90                   	nop
801024c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801024d0:	83 ec 0c             	sub    $0xc,%esp
801024d3:	56                   	push   %esi
801024d4:	e8 27 f6 ff ff       	call   80101b00 <iunlock>
  iput(ip);
801024d9:	89 34 24             	mov    %esi,(%esp)
801024dc:	e8 6f f6 ff ff       	call   80101b50 <iput>
    end_op();
801024e1:	e8 da 0e 00 00       	call   801033c0 <end_op>
    return -1;
801024e6:	83 c4 10             	add    $0x10,%esp
801024e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024ee:	eb a7                	jmp    80102497 <removeSwapFile+0x147>
    dp->nlink--;
801024f0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801024f5:	83 ec 0c             	sub    $0xc,%esp
801024f8:	56                   	push   %esi
801024f9:	e8 72 f4 ff ff       	call   80101970 <iupdate>
801024fe:	83 c4 10             	add    $0x10,%esp
80102501:	e9 59 ff ff ff       	jmp    8010245f <removeSwapFile+0x10f>
80102506:	8d 76 00             	lea    0x0(%esi),%esi
80102509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102515:	e9 7d ff ff ff       	jmp    80102497 <removeSwapFile+0x147>
    end_op();
8010251a:	e8 a1 0e 00 00       	call   801033c0 <end_op>
    return -1;
8010251f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102524:	e9 6e ff ff ff       	jmp    80102497 <removeSwapFile+0x147>
    panic("unlink: writei");
80102529:	83 ec 0c             	sub    $0xc,%esp
8010252c:	68 91 87 10 80       	push   $0x80108791
80102531:	e8 5a de ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102536:	83 ec 0c             	sub    $0xc,%esp
80102539:	68 7f 87 10 80       	push   $0x8010877f
8010253e:	e8 4d de ff ff       	call   80100390 <panic>
80102543:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102550 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	56                   	push   %esi
80102554:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102555:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
80102558:	83 ec 14             	sub    $0x14,%esp
8010255b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010255e:	6a 06                	push   $0x6
80102560:	68 75 87 10 80       	push   $0x80108775
80102565:	56                   	push   %esi
80102566:	e8 45 2a 00 00       	call   80104fb0 <memmove>
  itoa(p->pid, path+ 6);
8010256b:	58                   	pop    %eax
8010256c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010256f:	5a                   	pop    %edx
80102570:	50                   	push   %eax
80102571:	ff 73 10             	pushl  0x10(%ebx)
80102574:	e8 47 fd ff ff       	call   801022c0 <itoa>

    begin_op();
80102579:	e8 d2 0d 00 00       	call   80103350 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010257e:	6a 00                	push   $0x0
80102580:	6a 00                	push   $0x0
80102582:	6a 02                	push   $0x2
80102584:	56                   	push   %esi
80102585:	e8 66 33 00 00       	call   801058f0 <create>
  iunlock(in);
8010258a:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
8010258d:	89 c6                	mov    %eax,%esi
  iunlock(in);
8010258f:	50                   	push   %eax
80102590:	e8 6b f5 ff ff       	call   80101b00 <iunlock>

  p->swapFile = filealloc();
80102595:	e8 86 eb ff ff       	call   80101120 <filealloc>
  if (p->swapFile == 0)
8010259a:	83 c4 10             	add    $0x10,%esp
8010259d:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
8010259f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
801025a2:	74 32                	je     801025d6 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
801025a4:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
801025a7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025aa:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
801025b0:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025b3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
801025ba:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025bd:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
801025c1:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025c4:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
801025c8:	e8 f3 0d 00 00       	call   801033c0 <end_op>

    return 0;
}
801025cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d0:	31 c0                	xor    %eax,%eax
801025d2:	5b                   	pop    %ebx
801025d3:	5e                   	pop    %esi
801025d4:	5d                   	pop    %ebp
801025d5:	c3                   	ret    
    panic("no slot for files on /store");
801025d6:	83 ec 0c             	sub    $0xc,%esp
801025d9:	68 a0 87 10 80       	push   $0x801087a0
801025de:	e8 ad dd ff ff       	call   80100390 <panic>
801025e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025f0 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc* p, char* buffer, uint placeOnFile, uint size)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801025f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801025f9:	8b 50 7c             	mov    0x7c(%eax),%edx
801025fc:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
801025ff:	8b 55 14             	mov    0x14(%ebp),%edx
80102602:	89 55 10             	mov    %edx,0x10(%ebp)
80102605:	8b 40 7c             	mov    0x7c(%eax),%eax
80102608:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010260b:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
8010260c:	e9 7f ed ff ff       	jmp    80101390 <filewrite>
80102611:	eb 0d                	jmp    80102620 <readFromSwapFile>
80102613:	90                   	nop
80102614:	90                   	nop
80102615:	90                   	nop
80102616:	90                   	nop
80102617:	90                   	nop
80102618:	90                   	nop
80102619:	90                   	nop
8010261a:	90                   	nop
8010261b:	90                   	nop
8010261c:	90                   	nop
8010261d:	90                   	nop
8010261e:	90                   	nop
8010261f:	90                   	nop

80102620 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102626:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102629:	8b 50 7c             	mov    0x7c(%eax),%edx
8010262c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010262f:	8b 55 14             	mov    0x14(%ebp),%edx
80102632:	89 55 10             	mov    %edx,0x10(%ebp)
80102635:	8b 40 7c             	mov    0x7c(%eax),%eax
80102638:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010263b:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
8010263c:	e9 bf ec ff ff       	jmp    80101300 <fileread>
80102641:	66 90                	xchg   %ax,%ax
80102643:	66 90                	xchg   %ax,%ax
80102645:	66 90                	xchg   %ax,%ax
80102647:	66 90                	xchg   %ax,%ax
80102649:	66 90                	xchg   %ax,%ax
8010264b:	66 90                	xchg   %ax,%ax
8010264d:	66 90                	xchg   %ax,%ax
8010264f:	90                   	nop

80102650 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	57                   	push   %edi
80102654:	56                   	push   %esi
80102655:	53                   	push   %ebx
80102656:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102659:	85 c0                	test   %eax,%eax
8010265b:	0f 84 b4 00 00 00    	je     80102715 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102661:	8b 58 08             	mov    0x8(%eax),%ebx
80102664:	89 c6                	mov    %eax,%esi
80102666:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010266c:	0f 87 96 00 00 00    	ja     80102708 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102672:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102677:	89 f6                	mov    %esi,%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102680:	89 ca                	mov    %ecx,%edx
80102682:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102683:	83 e0 c0             	and    $0xffffffc0,%eax
80102686:	3c 40                	cmp    $0x40,%al
80102688:	75 f6                	jne    80102680 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010268a:	31 ff                	xor    %edi,%edi
8010268c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102691:	89 f8                	mov    %edi,%eax
80102693:	ee                   	out    %al,(%dx)
80102694:	b8 01 00 00 00       	mov    $0x1,%eax
80102699:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010269e:	ee                   	out    %al,(%dx)
8010269f:	ba f3 01 00 00       	mov    $0x1f3,%edx
801026a4:	89 d8                	mov    %ebx,%eax
801026a6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801026a7:	89 d8                	mov    %ebx,%eax
801026a9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801026ae:	c1 f8 08             	sar    $0x8,%eax
801026b1:	ee                   	out    %al,(%dx)
801026b2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801026b7:	89 f8                	mov    %edi,%eax
801026b9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801026ba:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801026be:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026c3:	c1 e0 04             	shl    $0x4,%eax
801026c6:	83 e0 10             	and    $0x10,%eax
801026c9:	83 c8 e0             	or     $0xffffffe0,%eax
801026cc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801026cd:	f6 06 04             	testb  $0x4,(%esi)
801026d0:	75 16                	jne    801026e8 <idestart+0x98>
801026d2:	b8 20 00 00 00       	mov    $0x20,%eax
801026d7:	89 ca                	mov    %ecx,%edx
801026d9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801026da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026dd:	5b                   	pop    %ebx
801026de:	5e                   	pop    %esi
801026df:	5f                   	pop    %edi
801026e0:	5d                   	pop    %ebp
801026e1:	c3                   	ret    
801026e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026e8:	b8 30 00 00 00       	mov    $0x30,%eax
801026ed:	89 ca                	mov    %ecx,%edx
801026ef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801026f0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801026f5:	83 c6 5c             	add    $0x5c,%esi
801026f8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801026fd:	fc                   	cld    
801026fe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102700:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102703:	5b                   	pop    %ebx
80102704:	5e                   	pop    %esi
80102705:	5f                   	pop    %edi
80102706:	5d                   	pop    %ebp
80102707:	c3                   	ret    
    panic("incorrect blockno");
80102708:	83 ec 0c             	sub    $0xc,%esp
8010270b:	68 18 88 10 80       	push   $0x80108818
80102710:	e8 7b dc ff ff       	call   80100390 <panic>
    panic("idestart");
80102715:	83 ec 0c             	sub    $0xc,%esp
80102718:	68 0f 88 10 80       	push   $0x8010880f
8010271d:	e8 6e dc ff ff       	call   80100390 <panic>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <ideinit>:
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102736:	68 2a 88 10 80       	push   $0x8010882a
8010273b:	68 80 c5 10 80       	push   $0x8010c580
80102740:	e8 6b 25 00 00       	call   80104cb0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102745:	58                   	pop    %eax
80102746:	a1 80 2d 12 80       	mov    0x80122d80,%eax
8010274b:	5a                   	pop    %edx
8010274c:	83 e8 01             	sub    $0x1,%eax
8010274f:	50                   	push   %eax
80102750:	6a 0e                	push   $0xe
80102752:	e8 a9 02 00 00       	call   80102a00 <ioapicenable>
80102757:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010275a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010275f:	90                   	nop
80102760:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102761:	83 e0 c0             	and    $0xffffffc0,%eax
80102764:	3c 40                	cmp    $0x40,%al
80102766:	75 f8                	jne    80102760 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102768:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010276d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102772:	ee                   	out    %al,(%dx)
80102773:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102778:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010277d:	eb 06                	jmp    80102785 <ideinit+0x55>
8010277f:	90                   	nop
  for(i=0; i<1000; i++){
80102780:	83 e9 01             	sub    $0x1,%ecx
80102783:	74 0f                	je     80102794 <ideinit+0x64>
80102785:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102786:	84 c0                	test   %al,%al
80102788:	74 f6                	je     80102780 <ideinit+0x50>
      havedisk1 = 1;
8010278a:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
80102791:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102794:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102799:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010279e:	ee                   	out    %al,(%dx)
}
8010279f:	c9                   	leave  
801027a0:	c3                   	ret    
801027a1:	eb 0d                	jmp    801027b0 <ideintr>
801027a3:	90                   	nop
801027a4:	90                   	nop
801027a5:	90                   	nop
801027a6:	90                   	nop
801027a7:	90                   	nop
801027a8:	90                   	nop
801027a9:	90                   	nop
801027aa:	90                   	nop
801027ab:	90                   	nop
801027ac:	90                   	nop
801027ad:	90                   	nop
801027ae:	90                   	nop
801027af:	90                   	nop

801027b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	57                   	push   %edi
801027b4:	56                   	push   %esi
801027b5:	53                   	push   %ebx
801027b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027b9:	68 80 c5 10 80       	push   $0x8010c580
801027be:	e8 2d 26 00 00       	call   80104df0 <acquire>

  if((b = idequeue) == 0){
801027c3:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
801027c9:	83 c4 10             	add    $0x10,%esp
801027cc:	85 db                	test   %ebx,%ebx
801027ce:	74 67                	je     80102837 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801027d0:	8b 43 58             	mov    0x58(%ebx),%eax
801027d3:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027d8:	8b 3b                	mov    (%ebx),%edi
801027da:	f7 c7 04 00 00 00    	test   $0x4,%edi
801027e0:	75 31                	jne    80102813 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801027e7:	89 f6                	mov    %esi,%esi
801027e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801027f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801027f1:	89 c6                	mov    %eax,%esi
801027f3:	83 e6 c0             	and    $0xffffffc0,%esi
801027f6:	89 f1                	mov    %esi,%ecx
801027f8:	80 f9 40             	cmp    $0x40,%cl
801027fb:	75 f3                	jne    801027f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801027fd:	a8 21                	test   $0x21,%al
801027ff:	75 12                	jne    80102813 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102801:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102804:	b9 80 00 00 00       	mov    $0x80,%ecx
80102809:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010280e:	fc                   	cld    
8010280f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102811:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102813:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102816:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102819:	89 f9                	mov    %edi,%ecx
8010281b:	83 c9 02             	or     $0x2,%ecx
8010281e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102820:	53                   	push   %ebx
80102821:	e8 9a 21 00 00       	call   801049c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102826:	a1 64 c5 10 80       	mov    0x8010c564,%eax
8010282b:	83 c4 10             	add    $0x10,%esp
8010282e:	85 c0                	test   %eax,%eax
80102830:	74 05                	je     80102837 <ideintr+0x87>
    idestart(idequeue);
80102832:	e8 19 fe ff ff       	call   80102650 <idestart>
    release(&idelock);
80102837:	83 ec 0c             	sub    $0xc,%esp
8010283a:	68 80 c5 10 80       	push   $0x8010c580
8010283f:	e8 6c 26 00 00       	call   80104eb0 <release>

  release(&idelock);
}
80102844:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102847:	5b                   	pop    %ebx
80102848:	5e                   	pop    %esi
80102849:	5f                   	pop    %edi
8010284a:	5d                   	pop    %ebp
8010284b:	c3                   	ret    
8010284c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102850 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	53                   	push   %ebx
80102854:	83 ec 10             	sub    $0x10,%esp
80102857:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010285a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010285d:	50                   	push   %eax
8010285e:	e8 fd 23 00 00       	call   80104c60 <holdingsleep>
80102863:	83 c4 10             	add    $0x10,%esp
80102866:	85 c0                	test   %eax,%eax
80102868:	0f 84 c6 00 00 00    	je     80102934 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010286e:	8b 03                	mov    (%ebx),%eax
80102870:	83 e0 06             	and    $0x6,%eax
80102873:	83 f8 02             	cmp    $0x2,%eax
80102876:	0f 84 ab 00 00 00    	je     80102927 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010287c:	8b 53 04             	mov    0x4(%ebx),%edx
8010287f:	85 d2                	test   %edx,%edx
80102881:	74 0d                	je     80102890 <iderw+0x40>
80102883:	a1 60 c5 10 80       	mov    0x8010c560,%eax
80102888:	85 c0                	test   %eax,%eax
8010288a:	0f 84 b1 00 00 00    	je     80102941 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102890:	83 ec 0c             	sub    $0xc,%esp
80102893:	68 80 c5 10 80       	push   $0x8010c580
80102898:	e8 53 25 00 00       	call   80104df0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010289d:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
801028a3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801028a6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028ad:	85 d2                	test   %edx,%edx
801028af:	75 09                	jne    801028ba <iderw+0x6a>
801028b1:	eb 6d                	jmp    80102920 <iderw+0xd0>
801028b3:	90                   	nop
801028b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028b8:	89 c2                	mov    %eax,%edx
801028ba:	8b 42 58             	mov    0x58(%edx),%eax
801028bd:	85 c0                	test   %eax,%eax
801028bf:	75 f7                	jne    801028b8 <iderw+0x68>
801028c1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801028c4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801028c6:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
801028cc:	74 42                	je     80102910 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028ce:	8b 03                	mov    (%ebx),%eax
801028d0:	83 e0 06             	and    $0x6,%eax
801028d3:	83 f8 02             	cmp    $0x2,%eax
801028d6:	74 23                	je     801028fb <iderw+0xab>
801028d8:	90                   	nop
801028d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801028e0:	83 ec 08             	sub    $0x8,%esp
801028e3:	68 80 c5 10 80       	push   $0x8010c580
801028e8:	53                   	push   %ebx
801028e9:	e8 82 1e 00 00       	call   80104770 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028ee:	8b 03                	mov    (%ebx),%eax
801028f0:	83 c4 10             	add    $0x10,%esp
801028f3:	83 e0 06             	and    $0x6,%eax
801028f6:	83 f8 02             	cmp    $0x2,%eax
801028f9:	75 e5                	jne    801028e0 <iderw+0x90>
  }


  release(&idelock);
801028fb:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102902:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102905:	c9                   	leave  
  release(&idelock);
80102906:	e9 a5 25 00 00       	jmp    80104eb0 <release>
8010290b:	90                   	nop
8010290c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102910:	89 d8                	mov    %ebx,%eax
80102912:	e8 39 fd ff ff       	call   80102650 <idestart>
80102917:	eb b5                	jmp    801028ce <iderw+0x7e>
80102919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102920:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102925:	eb 9d                	jmp    801028c4 <iderw+0x74>
    panic("iderw: nothing to do");
80102927:	83 ec 0c             	sub    $0xc,%esp
8010292a:	68 44 88 10 80       	push   $0x80108844
8010292f:	e8 5c da ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102934:	83 ec 0c             	sub    $0xc,%esp
80102937:	68 2e 88 10 80       	push   $0x8010882e
8010293c:	e8 4f da ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102941:	83 ec 0c             	sub    $0xc,%esp
80102944:	68 59 88 10 80       	push   $0x80108859
80102949:	e8 42 da ff ff       	call   80100390 <panic>
8010294e:	66 90                	xchg   %ax,%ax

80102950 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102950:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102951:	c7 05 74 26 12 80 00 	movl   $0xfec00000,0x80122674
80102958:	00 c0 fe 
{
8010295b:	89 e5                	mov    %esp,%ebp
8010295d:	56                   	push   %esi
8010295e:	53                   	push   %ebx
  ioapic->reg = reg;
8010295f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102966:	00 00 00 
  return ioapic->data;
80102969:	a1 74 26 12 80       	mov    0x80122674,%eax
8010296e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102971:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102977:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010297d:	0f b6 15 e0 27 12 80 	movzbl 0x801227e0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102984:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102987:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010298a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010298d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102990:	39 c2                	cmp    %eax,%edx
80102992:	74 16                	je     801029aa <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102994:	83 ec 0c             	sub    $0xc,%esp
80102997:	68 78 88 10 80       	push   $0x80108878
8010299c:	e8 bf dc ff ff       	call   80100660 <cprintf>
801029a1:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
801029a7:	83 c4 10             	add    $0x10,%esp
801029aa:	83 c3 21             	add    $0x21,%ebx
{
801029ad:	ba 10 00 00 00       	mov    $0x10,%edx
801029b2:	b8 20 00 00 00       	mov    $0x20,%eax
801029b7:	89 f6                	mov    %esi,%esi
801029b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801029c0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801029c2:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029c8:	89 c6                	mov    %eax,%esi
801029ca:	81 ce 00 00 01 00    	or     $0x10000,%esi
801029d0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801029d3:	89 71 10             	mov    %esi,0x10(%ecx)
801029d6:	8d 72 01             	lea    0x1(%edx),%esi
801029d9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801029dc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801029de:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801029e0:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
801029e6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801029ed:	75 d1                	jne    801029c0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801029ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029f2:	5b                   	pop    %ebx
801029f3:	5e                   	pop    %esi
801029f4:	5d                   	pop    %ebp
801029f5:	c3                   	ret    
801029f6:	8d 76 00             	lea    0x0(%esi),%esi
801029f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a00 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a00:	55                   	push   %ebp
  ioapic->reg = reg;
80102a01:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
{
80102a07:	89 e5                	mov    %esp,%ebp
80102a09:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a0c:	8d 50 20             	lea    0x20(%eax),%edx
80102a0f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102a13:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102a15:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a1b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102a1e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102a24:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102a26:	a1 74 26 12 80       	mov    0x80122674,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a2b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102a2e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a31:	5d                   	pop    %ebp
80102a32:	c3                   	ret    
80102a33:	66 90                	xchg   %ax,%ax
80102a35:	66 90                	xchg   %ax,%ax
80102a37:	66 90                	xchg   %ax,%ax
80102a39:	66 90                	xchg   %ax,%ax
80102a3b:	66 90                	xchg   %ax,%ax
80102a3d:	66 90                	xchg   %ax,%ax
80102a3f:	90                   	nop

80102a40 <init_cow>:



struct spinlock r_cow_lock;

void init_cow(){
80102a40:	55                   	push   %ebp
80102a41:	89 e5                	mov    %esp,%ebp
80102a43:	83 ec 14             	sub    $0x14,%esp
  cprintf("initing cow\n");
80102a46:	68 aa 88 10 80       	push   $0x801088aa
80102a4b:	e8 10 dc ff ff       	call   80100660 <cprintf>
  memset((void*)pg_ref_counts, 0, sizeof(pg_ref_counts));
80102a50:	83 c4 0c             	add    $0xc,%esp
80102a53:	68 00 e0 00 00       	push   $0xe000
80102a58:	6a 00                	push   $0x0
80102a5a:	68 40 1f 11 80       	push   $0x80111f40
80102a5f:	e8 9c 24 00 00       	call   80104f00 <memset>
  initlock(&r_cow_lock, "cow lock");
80102a64:	58                   	pop    %eax
80102a65:	5a                   	pop    %edx
80102a66:	68 b7 88 10 80       	push   $0x801088b7
80102a6b:	68 c0 26 12 80       	push   $0x801226c0
80102a70:	e8 3b 22 00 00       	call   80104cb0 <initlock>
  cow_lock = &r_cow_lock;
  cprintf("initing cow end\n");
80102a75:	c7 04 24 c0 88 10 80 	movl   $0x801088c0,(%esp)
  cow_lock = &r_cow_lock;
80102a7c:	c7 05 40 ff 11 80 c0 	movl   $0x801226c0,0x8011ff40
80102a83:	26 12 80 
  cprintf("initing cow end\n");
80102a86:	e8 d5 db ff ff       	call   80100660 <cprintf>
}
80102a8b:	83 c4 10             	add    $0x10,%esp
80102a8e:	c9                   	leave  
80102a8f:	c3                   	ret    

80102a90 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
80102a93:	53                   	push   %ebx
80102a94:	83 ec 04             	sub    $0x4,%esp
80102a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102a9a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102aa0:	75 70                	jne    80102b12 <kfree+0x82>
80102aa2:	81 fb 28 1a 13 80    	cmp    $0x80131a28,%ebx
80102aa8:	72 68                	jb     80102b12 <kfree+0x82>
80102aaa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102ab0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102ab5:	77 5b                	ja     80102b12 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ab7:	83 ec 04             	sub    $0x4,%esp
80102aba:	68 00 10 00 00       	push   $0x1000
80102abf:	6a 01                	push   $0x1
80102ac1:	53                   	push   %ebx
80102ac2:	e8 39 24 00 00       	call   80104f00 <memset>

  if(kmem.use_lock)
80102ac7:	8b 15 b4 26 12 80    	mov    0x801226b4,%edx
80102acd:	83 c4 10             	add    $0x10,%esp
80102ad0:	85 d2                	test   %edx,%edx
80102ad2:	75 2c                	jne    80102b00 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102ad4:	a1 b8 26 12 80       	mov    0x801226b8,%eax
80102ad9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102adb:	a1 b4 26 12 80       	mov    0x801226b4,%eax
  kmem.freelist = r;
80102ae0:	89 1d b8 26 12 80    	mov    %ebx,0x801226b8
  if(kmem.use_lock)
80102ae6:	85 c0                	test   %eax,%eax
80102ae8:	75 06                	jne    80102af0 <kfree+0x60>
    release(&kmem.lock);
}
80102aea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102aed:	c9                   	leave  
80102aee:	c3                   	ret    
80102aef:	90                   	nop
    release(&kmem.lock);
80102af0:	c7 45 08 80 26 12 80 	movl   $0x80122680,0x8(%ebp)
}
80102af7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102afa:	c9                   	leave  
    release(&kmem.lock);
80102afb:	e9 b0 23 00 00       	jmp    80104eb0 <release>
    acquire(&kmem.lock);
80102b00:	83 ec 0c             	sub    $0xc,%esp
80102b03:	68 80 26 12 80       	push   $0x80122680
80102b08:	e8 e3 22 00 00       	call   80104df0 <acquire>
80102b0d:	83 c4 10             	add    $0x10,%esp
80102b10:	eb c2                	jmp    80102ad4 <kfree+0x44>
    panic("kfree");
80102b12:	83 ec 0c             	sub    $0xc,%esp
80102b15:	68 61 91 10 80       	push   $0x80109161
80102b1a:	e8 71 d8 ff ff       	call   80100390 <panic>
80102b1f:	90                   	nop

80102b20 <freerange>:
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	56                   	push   %esi
80102b24:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102b25:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102b28:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102b2b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b31:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102b37:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b3d:	39 de                	cmp    %ebx,%esi
80102b3f:	72 33                	jb     80102b74 <freerange+0x54>
80102b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102b48:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102b4e:	83 ec 0c             	sub    $0xc,%esp
80102b51:	50                   	push   %eax
80102b52:	e8 39 ff ff ff       	call   80102a90 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102b57:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102b5d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b63:	83 c4 10             	add    $0x10,%esp
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102b66:	c1 e8 0c             	shr    $0xc,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102b69:	39 f3                	cmp    %esi,%ebx
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102b6b:	c6 80 40 1f 11 80 00 	movb   $0x0,-0x7feee0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102b72:	76 d4                	jbe    80102b48 <freerange+0x28>
}
80102b74:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b77:	5b                   	pop    %ebx
80102b78:	5e                   	pop    %esi
80102b79:	5d                   	pop    %ebp
80102b7a:	c3                   	ret    
80102b7b:	90                   	nop
80102b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b80 <kinit1>:
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	56                   	push   %esi
80102b84:	53                   	push   %ebx
80102b85:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102b88:	83 ec 08             	sub    $0x8,%esp
80102b8b:	68 d1 88 10 80       	push   $0x801088d1
80102b90:	68 80 26 12 80       	push   $0x80122680
80102b95:	e8 16 21 00 00       	call   80104cb0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102b9d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102ba0:	c7 05 b4 26 12 80 00 	movl   $0x0,0x801226b4
80102ba7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102baa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102bb0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102bb6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102bbc:	39 de                	cmp    %ebx,%esi
80102bbe:	72 2c                	jb     80102bec <kinit1+0x6c>
    kfree(p);
80102bc0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102bc6:	83 ec 0c             	sub    $0xc,%esp
80102bc9:	50                   	push   %eax
80102bca:	e8 c1 fe ff ff       	call   80102a90 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102bcf:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102bd5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102bdb:	83 c4 10             	add    $0x10,%esp
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102bde:	c1 e8 0c             	shr    $0xc,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102be1:	39 de                	cmp    %ebx,%esi
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102be3:	c6 80 40 1f 11 80 00 	movb   $0x0,-0x7feee0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102bea:	73 d4                	jae    80102bc0 <kinit1+0x40>
}
80102bec:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102bef:	5b                   	pop    %ebx
80102bf0:	5e                   	pop    %esi
80102bf1:	5d                   	pop    %ebp
80102bf2:	c3                   	ret    
80102bf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c00 <kinit2>:
{
80102c00:	55                   	push   %ebp
80102c01:	89 e5                	mov    %esp,%ebp
80102c03:	56                   	push   %esi
80102c04:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102c05:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102c08:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102c0b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c11:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c17:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c1d:	39 de                	cmp    %ebx,%esi
80102c1f:	72 33                	jb     80102c54 <kinit2+0x54>
80102c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102c28:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102c2e:	83 ec 0c             	sub    $0xc,%esp
80102c31:	50                   	push   %eax
80102c32:	e8 59 fe ff ff       	call   80102a90 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102c37:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c3d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c43:	83 c4 10             	add    $0x10,%esp
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102c46:	c1 e8 0c             	shr    $0xc,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c49:	39 de                	cmp    %ebx,%esi
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102c4b:	c6 80 40 1f 11 80 00 	movb   $0x0,-0x7feee0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102c52:	73 d4                	jae    80102c28 <kinit2+0x28>
  kmem.use_lock = 1;
80102c54:	c7 05 b4 26 12 80 01 	movl   $0x1,0x801226b4
80102c5b:	00 00 00 
}
80102c5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c61:	5b                   	pop    %ebx
80102c62:	5e                   	pop    %esi
80102c63:	5d                   	pop    %ebp
80102c64:	c3                   	ret    
80102c65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c70 <kalloc>:
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;
  if(kmem.use_lock)
80102c70:	a1 b4 26 12 80       	mov    0x801226b4,%eax
80102c75:	85 c0                	test   %eax,%eax
80102c77:	75 1f                	jne    80102c98 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102c79:	a1 b8 26 12 80       	mov    0x801226b8,%eax
  if(r)
80102c7e:	85 c0                	test   %eax,%eax
80102c80:	74 0e                	je     80102c90 <kalloc+0x20>
    kmem.freelist = r->next;
80102c82:	8b 10                	mov    (%eax),%edx
80102c84:	89 15 b8 26 12 80    	mov    %edx,0x801226b8
80102c8a:	c3                   	ret    
80102c8b:	90                   	nop
80102c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102c90:	f3 c3                	repz ret 
80102c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102c98:	55                   	push   %ebp
80102c99:	89 e5                	mov    %esp,%ebp
80102c9b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102c9e:	68 80 26 12 80       	push   $0x80122680
80102ca3:	e8 48 21 00 00       	call   80104df0 <acquire>
  r = kmem.freelist;
80102ca8:	a1 b8 26 12 80       	mov    0x801226b8,%eax
  if(r)
80102cad:	83 c4 10             	add    $0x10,%esp
80102cb0:	8b 15 b4 26 12 80    	mov    0x801226b4,%edx
80102cb6:	85 c0                	test   %eax,%eax
80102cb8:	74 08                	je     80102cc2 <kalloc+0x52>
    kmem.freelist = r->next;
80102cba:	8b 08                	mov    (%eax),%ecx
80102cbc:	89 0d b8 26 12 80    	mov    %ecx,0x801226b8
  if(kmem.use_lock)
80102cc2:	85 d2                	test   %edx,%edx
80102cc4:	74 16                	je     80102cdc <kalloc+0x6c>
    release(&kmem.lock);
80102cc6:	83 ec 0c             	sub    $0xc,%esp
80102cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102ccc:	68 80 26 12 80       	push   $0x80122680
80102cd1:	e8 da 21 00 00       	call   80104eb0 <release>
  return (char*)r;
80102cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102cd9:	83 c4 10             	add    $0x10,%esp
}
80102cdc:	c9                   	leave  
80102cdd:	c3                   	ret    
80102cde:	66 90                	xchg   %ax,%ax

80102ce0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce0:	ba 64 00 00 00       	mov    $0x64,%edx
80102ce5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102ce6:	a8 01                	test   $0x1,%al
80102ce8:	0f 84 c2 00 00 00    	je     80102db0 <kbdgetc+0xd0>
80102cee:	ba 60 00 00 00       	mov    $0x60,%edx
80102cf3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102cf4:	0f b6 d0             	movzbl %al,%edx
80102cf7:	8b 0d b4 c5 10 80    	mov    0x8010c5b4,%ecx

  if(data == 0xE0){
80102cfd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102d03:	0f 84 7f 00 00 00    	je     80102d88 <kbdgetc+0xa8>
{
80102d09:	55                   	push   %ebp
80102d0a:	89 e5                	mov    %esp,%ebp
80102d0c:	53                   	push   %ebx
80102d0d:	89 cb                	mov    %ecx,%ebx
80102d0f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102d12:	84 c0                	test   %al,%al
80102d14:	78 4a                	js     80102d60 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102d16:	85 db                	test   %ebx,%ebx
80102d18:	74 09                	je     80102d23 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d1a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102d1d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102d20:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102d23:	0f b6 82 00 8a 10 80 	movzbl -0x7fef7600(%edx),%eax
80102d2a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102d2c:	0f b6 82 00 89 10 80 	movzbl -0x7fef7700(%edx),%eax
80102d33:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d35:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102d37:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102d3d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102d40:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102d43:	8b 04 85 e0 88 10 80 	mov    -0x7fef7720(,%eax,4),%eax
80102d4a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102d4e:	74 31                	je     80102d81 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102d50:	8d 50 9f             	lea    -0x61(%eax),%edx
80102d53:	83 fa 19             	cmp    $0x19,%edx
80102d56:	77 40                	ja     80102d98 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102d58:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102d5b:	5b                   	pop    %ebx
80102d5c:	5d                   	pop    %ebp
80102d5d:	c3                   	ret    
80102d5e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102d60:	83 e0 7f             	and    $0x7f,%eax
80102d63:	85 db                	test   %ebx,%ebx
80102d65:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102d68:	0f b6 82 00 8a 10 80 	movzbl -0x7fef7600(%edx),%eax
80102d6f:	83 c8 40             	or     $0x40,%eax
80102d72:	0f b6 c0             	movzbl %al,%eax
80102d75:	f7 d0                	not    %eax
80102d77:	21 c1                	and    %eax,%ecx
    return 0;
80102d79:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102d7b:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102d81:	5b                   	pop    %ebx
80102d82:	5d                   	pop    %ebp
80102d83:	c3                   	ret    
80102d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102d88:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102d8b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102d8d:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
    return 0;
80102d93:	c3                   	ret    
80102d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102d98:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102d9b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102d9e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102d9f:	83 f9 1a             	cmp    $0x1a,%ecx
80102da2:	0f 42 c2             	cmovb  %edx,%eax
}
80102da5:	5d                   	pop    %ebp
80102da6:	c3                   	ret    
80102da7:	89 f6                	mov    %esi,%esi
80102da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102db5:	c3                   	ret    
80102db6:	8d 76 00             	lea    0x0(%esi),%esi
80102db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102dc0 <kbdintr>:

void
kbdintr(void)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102dc6:	68 e0 2c 10 80       	push   $0x80102ce0
80102dcb:	e8 40 da ff ff       	call   80100810 <consoleintr>
}
80102dd0:	83 c4 10             	add    $0x10,%esp
80102dd3:	c9                   	leave  
80102dd4:	c3                   	ret    
80102dd5:	66 90                	xchg   %ax,%ax
80102dd7:	66 90                	xchg   %ax,%ax
80102dd9:	66 90                	xchg   %ax,%ax
80102ddb:	66 90                	xchg   %ax,%ax
80102ddd:	66 90                	xchg   %ax,%ax
80102ddf:	90                   	nop

80102de0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102de0:	a1 f4 26 12 80       	mov    0x801226f4,%eax
{
80102de5:	55                   	push   %ebp
80102de6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102de8:	85 c0                	test   %eax,%eax
80102dea:	0f 84 c8 00 00 00    	je     80102eb8 <lapicinit+0xd8>
  lapic[index] = value;
80102df0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102df7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102dfa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102dfd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102e04:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e07:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e0a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102e11:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102e14:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e17:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102e1e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102e21:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e24:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102e2b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e31:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102e38:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102e3b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e3e:	8b 50 30             	mov    0x30(%eax),%edx
80102e41:	c1 ea 10             	shr    $0x10,%edx
80102e44:	80 fa 03             	cmp    $0x3,%dl
80102e47:	77 77                	ja     80102ec0 <lapicinit+0xe0>
  lapic[index] = value;
80102e49:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102e50:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e53:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e56:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102e5d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e60:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e63:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102e6a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e6d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e70:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102e77:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e7a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e7d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102e84:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e87:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e8a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102e91:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102e94:	8b 50 20             	mov    0x20(%eax),%edx
80102e97:	89 f6                	mov    %esi,%esi
80102e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102ea0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102ea6:	80 e6 10             	and    $0x10,%dh
80102ea9:	75 f5                	jne    80102ea0 <lapicinit+0xc0>
  lapic[index] = value;
80102eab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102eb2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102eb5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102eb8:	5d                   	pop    %ebp
80102eb9:	c3                   	ret    
80102eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102ec0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102ec7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102eca:	8b 50 20             	mov    0x20(%eax),%edx
80102ecd:	e9 77 ff ff ff       	jmp    80102e49 <lapicinit+0x69>
80102ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ee0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102ee0:	8b 15 f4 26 12 80    	mov    0x801226f4,%edx
{
80102ee6:	55                   	push   %ebp
80102ee7:	31 c0                	xor    %eax,%eax
80102ee9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102eeb:	85 d2                	test   %edx,%edx
80102eed:	74 06                	je     80102ef5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102eef:	8b 42 20             	mov    0x20(%edx),%eax
80102ef2:	c1 e8 18             	shr    $0x18,%eax
}
80102ef5:	5d                   	pop    %ebp
80102ef6:	c3                   	ret    
80102ef7:	89 f6                	mov    %esi,%esi
80102ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f00 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102f00:	a1 f4 26 12 80       	mov    0x801226f4,%eax
{
80102f05:	55                   	push   %ebp
80102f06:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102f08:	85 c0                	test   %eax,%eax
80102f0a:	74 0d                	je     80102f19 <lapiceoi+0x19>
  lapic[index] = value;
80102f0c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f13:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f16:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102f19:	5d                   	pop    %ebp
80102f1a:	c3                   	ret    
80102f1b:	90                   	nop
80102f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102f20 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
}
80102f23:	5d                   	pop    %ebp
80102f24:	c3                   	ret    
80102f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f30 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f30:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f31:	b8 0f 00 00 00       	mov    $0xf,%eax
80102f36:	ba 70 00 00 00       	mov    $0x70,%edx
80102f3b:	89 e5                	mov    %esp,%ebp
80102f3d:	53                   	push   %ebx
80102f3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102f41:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f44:	ee                   	out    %al,(%dx)
80102f45:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f4a:	ba 71 00 00 00       	mov    $0x71,%edx
80102f4f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102f50:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f52:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102f55:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102f5b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f5d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102f60:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102f63:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f65:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102f68:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102f6e:	a1 f4 26 12 80       	mov    0x801226f4,%eax
80102f73:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f79:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f7c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102f83:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f86:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f89:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102f90:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f93:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f96:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102f9c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102f9f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fa5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102fa8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fb1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102fb7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102fba:	5b                   	pop    %ebx
80102fbb:	5d                   	pop    %ebp
80102fbc:	c3                   	ret    
80102fbd:	8d 76 00             	lea    0x0(%esi),%esi

80102fc0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102fc0:	55                   	push   %ebp
80102fc1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102fc6:	ba 70 00 00 00       	mov    $0x70,%edx
80102fcb:	89 e5                	mov    %esp,%ebp
80102fcd:	57                   	push   %edi
80102fce:	56                   	push   %esi
80102fcf:	53                   	push   %ebx
80102fd0:	83 ec 4c             	sub    $0x4c,%esp
80102fd3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fd4:	ba 71 00 00 00       	mov    $0x71,%edx
80102fd9:	ec                   	in     (%dx),%al
80102fda:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fdd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102fe2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102fe5:	8d 76 00             	lea    0x0(%esi),%esi
80102fe8:	31 c0                	xor    %eax,%eax
80102fea:	89 da                	mov    %ebx,%edx
80102fec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fed:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ff2:	89 ca                	mov    %ecx,%edx
80102ff4:	ec                   	in     (%dx),%al
80102ff5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ff8:	89 da                	mov    %ebx,%edx
80102ffa:	b8 02 00 00 00       	mov    $0x2,%eax
80102fff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103000:	89 ca                	mov    %ecx,%edx
80103002:	ec                   	in     (%dx),%al
80103003:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103006:	89 da                	mov    %ebx,%edx
80103008:	b8 04 00 00 00       	mov    $0x4,%eax
8010300d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010300e:	89 ca                	mov    %ecx,%edx
80103010:	ec                   	in     (%dx),%al
80103011:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103014:	89 da                	mov    %ebx,%edx
80103016:	b8 07 00 00 00       	mov    $0x7,%eax
8010301b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010301c:	89 ca                	mov    %ecx,%edx
8010301e:	ec                   	in     (%dx),%al
8010301f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103022:	89 da                	mov    %ebx,%edx
80103024:	b8 08 00 00 00       	mov    $0x8,%eax
80103029:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010302a:	89 ca                	mov    %ecx,%edx
8010302c:	ec                   	in     (%dx),%al
8010302d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010302f:	89 da                	mov    %ebx,%edx
80103031:	b8 09 00 00 00       	mov    $0x9,%eax
80103036:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103037:	89 ca                	mov    %ecx,%edx
80103039:	ec                   	in     (%dx),%al
8010303a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010303c:	89 da                	mov    %ebx,%edx
8010303e:	b8 0a 00 00 00       	mov    $0xa,%eax
80103043:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103044:	89 ca                	mov    %ecx,%edx
80103046:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103047:	84 c0                	test   %al,%al
80103049:	78 9d                	js     80102fe8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010304b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010304f:	89 fa                	mov    %edi,%edx
80103051:	0f b6 fa             	movzbl %dl,%edi
80103054:	89 f2                	mov    %esi,%edx
80103056:	0f b6 f2             	movzbl %dl,%esi
80103059:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010305c:	89 da                	mov    %ebx,%edx
8010305e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103061:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103064:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103068:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010306b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010306f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103072:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103076:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103079:	31 c0                	xor    %eax,%eax
8010307b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010307c:	89 ca                	mov    %ecx,%edx
8010307e:	ec                   	in     (%dx),%al
8010307f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103082:	89 da                	mov    %ebx,%edx
80103084:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103087:	b8 02 00 00 00       	mov    $0x2,%eax
8010308c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010308d:	89 ca                	mov    %ecx,%edx
8010308f:	ec                   	in     (%dx),%al
80103090:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103093:	89 da                	mov    %ebx,%edx
80103095:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103098:	b8 04 00 00 00       	mov    $0x4,%eax
8010309d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010309e:	89 ca                	mov    %ecx,%edx
801030a0:	ec                   	in     (%dx),%al
801030a1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030a4:	89 da                	mov    %ebx,%edx
801030a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801030a9:	b8 07 00 00 00       	mov    $0x7,%eax
801030ae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030af:	89 ca                	mov    %ecx,%edx
801030b1:	ec                   	in     (%dx),%al
801030b2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030b5:	89 da                	mov    %ebx,%edx
801030b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801030ba:	b8 08 00 00 00       	mov    $0x8,%eax
801030bf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030c0:	89 ca                	mov    %ecx,%edx
801030c2:	ec                   	in     (%dx),%al
801030c3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030c6:	89 da                	mov    %ebx,%edx
801030c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801030cb:	b8 09 00 00 00       	mov    $0x9,%eax
801030d0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030d1:	89 ca                	mov    %ecx,%edx
801030d3:	ec                   	in     (%dx),%al
801030d4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801030d7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801030da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801030dd:	8d 45 d0             	lea    -0x30(%ebp),%eax
801030e0:	6a 18                	push   $0x18
801030e2:	50                   	push   %eax
801030e3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801030e6:	50                   	push   %eax
801030e7:	e8 64 1e 00 00       	call   80104f50 <memcmp>
801030ec:	83 c4 10             	add    $0x10,%esp
801030ef:	85 c0                	test   %eax,%eax
801030f1:	0f 85 f1 fe ff ff    	jne    80102fe8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801030f7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801030fb:	75 78                	jne    80103175 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801030fd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103100:	89 c2                	mov    %eax,%edx
80103102:	83 e0 0f             	and    $0xf,%eax
80103105:	c1 ea 04             	shr    $0x4,%edx
80103108:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010310b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010310e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103111:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103114:	89 c2                	mov    %eax,%edx
80103116:	83 e0 0f             	and    $0xf,%eax
80103119:	c1 ea 04             	shr    $0x4,%edx
8010311c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010311f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103122:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103125:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103128:	89 c2                	mov    %eax,%edx
8010312a:	83 e0 0f             	and    $0xf,%eax
8010312d:	c1 ea 04             	shr    $0x4,%edx
80103130:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103133:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103136:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103139:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010313c:	89 c2                	mov    %eax,%edx
8010313e:	83 e0 0f             	and    $0xf,%eax
80103141:	c1 ea 04             	shr    $0x4,%edx
80103144:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103147:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010314a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010314d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103150:	89 c2                	mov    %eax,%edx
80103152:	83 e0 0f             	and    $0xf,%eax
80103155:	c1 ea 04             	shr    $0x4,%edx
80103158:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010315b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010315e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103161:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103164:	89 c2                	mov    %eax,%edx
80103166:	83 e0 0f             	and    $0xf,%eax
80103169:	c1 ea 04             	shr    $0x4,%edx
8010316c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010316f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103172:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103175:	8b 75 08             	mov    0x8(%ebp),%esi
80103178:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010317b:	89 06                	mov    %eax,(%esi)
8010317d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103180:	89 46 04             	mov    %eax,0x4(%esi)
80103183:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103186:	89 46 08             	mov    %eax,0x8(%esi)
80103189:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010318c:	89 46 0c             	mov    %eax,0xc(%esi)
8010318f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103192:	89 46 10             	mov    %eax,0x10(%esi)
80103195:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103198:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010319b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801031a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031a5:	5b                   	pop    %ebx
801031a6:	5e                   	pop    %esi
801031a7:	5f                   	pop    %edi
801031a8:	5d                   	pop    %ebp
801031a9:	c3                   	ret    
801031aa:	66 90                	xchg   %ax,%ax
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801031b0:	8b 0d 48 27 12 80    	mov    0x80122748,%ecx
801031b6:	85 c9                	test   %ecx,%ecx
801031b8:	0f 8e 8a 00 00 00    	jle    80103248 <install_trans+0x98>
{
801031be:	55                   	push   %ebp
801031bf:	89 e5                	mov    %esp,%ebp
801031c1:	57                   	push   %edi
801031c2:	56                   	push   %esi
801031c3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
801031c4:	31 db                	xor    %ebx,%ebx
{
801031c6:	83 ec 0c             	sub    $0xc,%esp
801031c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801031d0:	a1 34 27 12 80       	mov    0x80122734,%eax
801031d5:	83 ec 08             	sub    $0x8,%esp
801031d8:	01 d8                	add    %ebx,%eax
801031da:	83 c0 01             	add    $0x1,%eax
801031dd:	50                   	push   %eax
801031de:	ff 35 44 27 12 80    	pushl  0x80122744
801031e4:	e8 e7 ce ff ff       	call   801000d0 <bread>
801031e9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801031eb:	58                   	pop    %eax
801031ec:	5a                   	pop    %edx
801031ed:	ff 34 9d 4c 27 12 80 	pushl  -0x7fedd8b4(,%ebx,4)
801031f4:	ff 35 44 27 12 80    	pushl  0x80122744
  for (tail = 0; tail < log.lh.n; tail++) {
801031fa:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801031fd:	e8 ce ce ff ff       	call   801000d0 <bread>
80103202:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103204:	8d 47 5c             	lea    0x5c(%edi),%eax
80103207:	83 c4 0c             	add    $0xc,%esp
8010320a:	68 00 02 00 00       	push   $0x200
8010320f:	50                   	push   %eax
80103210:	8d 46 5c             	lea    0x5c(%esi),%eax
80103213:	50                   	push   %eax
80103214:	e8 97 1d 00 00       	call   80104fb0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103219:	89 34 24             	mov    %esi,(%esp)
8010321c:	e8 7f cf ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80103221:	89 3c 24             	mov    %edi,(%esp)
80103224:	e8 b7 cf ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80103229:	89 34 24             	mov    %esi,(%esp)
8010322c:	e8 af cf ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103231:	83 c4 10             	add    $0x10,%esp
80103234:	39 1d 48 27 12 80    	cmp    %ebx,0x80122748
8010323a:	7f 94                	jg     801031d0 <install_trans+0x20>
  }
}
8010323c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010323f:	5b                   	pop    %ebx
80103240:	5e                   	pop    %esi
80103241:	5f                   	pop    %edi
80103242:	5d                   	pop    %ebp
80103243:	c3                   	ret    
80103244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103248:	f3 c3                	repz ret 
8010324a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103250 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	56                   	push   %esi
80103254:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80103255:	83 ec 08             	sub    $0x8,%esp
80103258:	ff 35 34 27 12 80    	pushl  0x80122734
8010325e:	ff 35 44 27 12 80    	pushl  0x80122744
80103264:	e8 67 ce ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103269:	8b 1d 48 27 12 80    	mov    0x80122748,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010326f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103272:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103274:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103276:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103279:	7e 16                	jle    80103291 <write_head+0x41>
8010327b:	c1 e3 02             	shl    $0x2,%ebx
8010327e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103280:	8b 8a 4c 27 12 80    	mov    -0x7fedd8b4(%edx),%ecx
80103286:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010328a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010328d:	39 da                	cmp    %ebx,%edx
8010328f:	75 ef                	jne    80103280 <write_head+0x30>
  }
  bwrite(buf);
80103291:	83 ec 0c             	sub    $0xc,%esp
80103294:	56                   	push   %esi
80103295:	e8 06 cf ff ff       	call   801001a0 <bwrite>
  brelse(buf);
8010329a:	89 34 24             	mov    %esi,(%esp)
8010329d:	e8 3e cf ff ff       	call   801001e0 <brelse>
}
801032a2:	83 c4 10             	add    $0x10,%esp
801032a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801032a8:	5b                   	pop    %ebx
801032a9:	5e                   	pop    %esi
801032aa:	5d                   	pop    %ebp
801032ab:	c3                   	ret    
801032ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032b0 <initlog>:
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	53                   	push   %ebx
801032b4:	83 ec 2c             	sub    $0x2c,%esp
801032b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801032ba:	68 00 8b 10 80       	push   $0x80108b00
801032bf:	68 00 27 12 80       	push   $0x80122700
801032c4:	e8 e7 19 00 00       	call   80104cb0 <initlock>
  readsb(dev, &sb);
801032c9:	58                   	pop    %eax
801032ca:	8d 45 dc             	lea    -0x24(%ebp),%eax
801032cd:	5a                   	pop    %edx
801032ce:	50                   	push   %eax
801032cf:	53                   	push   %ebx
801032d0:	e8 0b e5 ff ff       	call   801017e0 <readsb>
  log.size = sb.nlog;
801032d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801032d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801032db:	59                   	pop    %ecx
  log.dev = dev;
801032dc:	89 1d 44 27 12 80    	mov    %ebx,0x80122744
  log.size = sb.nlog;
801032e2:	89 15 38 27 12 80    	mov    %edx,0x80122738
  log.start = sb.logstart;
801032e8:	a3 34 27 12 80       	mov    %eax,0x80122734
  struct buf *buf = bread(log.dev, log.start);
801032ed:	5a                   	pop    %edx
801032ee:	50                   	push   %eax
801032ef:	53                   	push   %ebx
801032f0:	e8 db cd ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
801032f5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
801032f8:	83 c4 10             	add    $0x10,%esp
801032fb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
801032fd:	89 1d 48 27 12 80    	mov    %ebx,0x80122748
  for (i = 0; i < log.lh.n; i++) {
80103303:	7e 1c                	jle    80103321 <initlog+0x71>
80103305:	c1 e3 02             	shl    $0x2,%ebx
80103308:	31 d2                	xor    %edx,%edx
8010330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103310:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103314:	83 c2 04             	add    $0x4,%edx
80103317:	89 8a 48 27 12 80    	mov    %ecx,-0x7fedd8b8(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010331d:	39 d3                	cmp    %edx,%ebx
8010331f:	75 ef                	jne    80103310 <initlog+0x60>
  brelse(buf);
80103321:	83 ec 0c             	sub    $0xc,%esp
80103324:	50                   	push   %eax
80103325:	e8 b6 ce ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010332a:	e8 81 fe ff ff       	call   801031b0 <install_trans>
  log.lh.n = 0;
8010332f:	c7 05 48 27 12 80 00 	movl   $0x0,0x80122748
80103336:	00 00 00 
  write_head(); // clear the log
80103339:	e8 12 ff ff ff       	call   80103250 <write_head>
}
8010333e:	83 c4 10             	add    $0x10,%esp
80103341:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103344:	c9                   	leave  
80103345:	c3                   	ret    
80103346:	8d 76 00             	lea    0x0(%esi),%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103350 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103356:	68 00 27 12 80       	push   $0x80122700
8010335b:	e8 90 1a 00 00       	call   80104df0 <acquire>
80103360:	83 c4 10             	add    $0x10,%esp
80103363:	eb 18                	jmp    8010337d <begin_op+0x2d>
80103365:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103368:	83 ec 08             	sub    $0x8,%esp
8010336b:	68 00 27 12 80       	push   $0x80122700
80103370:	68 00 27 12 80       	push   $0x80122700
80103375:	e8 f6 13 00 00       	call   80104770 <sleep>
8010337a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010337d:	a1 40 27 12 80       	mov    0x80122740,%eax
80103382:	85 c0                	test   %eax,%eax
80103384:	75 e2                	jne    80103368 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103386:	a1 3c 27 12 80       	mov    0x8012273c,%eax
8010338b:	8b 15 48 27 12 80    	mov    0x80122748,%edx
80103391:	83 c0 01             	add    $0x1,%eax
80103394:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103397:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010339a:	83 fa 1e             	cmp    $0x1e,%edx
8010339d:	7f c9                	jg     80103368 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010339f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801033a2:	a3 3c 27 12 80       	mov    %eax,0x8012273c
      release(&log.lock);
801033a7:	68 00 27 12 80       	push   $0x80122700
801033ac:	e8 ff 1a 00 00       	call   80104eb0 <release>
      break;
    }
  }
}
801033b1:	83 c4 10             	add    $0x10,%esp
801033b4:	c9                   	leave  
801033b5:	c3                   	ret    
801033b6:	8d 76 00             	lea    0x0(%esi),%esi
801033b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033c0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	57                   	push   %edi
801033c4:	56                   	push   %esi
801033c5:	53                   	push   %ebx
801033c6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801033c9:	68 00 27 12 80       	push   $0x80122700
801033ce:	e8 1d 1a 00 00       	call   80104df0 <acquire>
  log.outstanding -= 1;
801033d3:	a1 3c 27 12 80       	mov    0x8012273c,%eax
  if(log.committing)
801033d8:	8b 35 40 27 12 80    	mov    0x80122740,%esi
801033de:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801033e1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
801033e4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
801033e6:	89 1d 3c 27 12 80    	mov    %ebx,0x8012273c
  if(log.committing)
801033ec:	0f 85 1a 01 00 00    	jne    8010350c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
801033f2:	85 db                	test   %ebx,%ebx
801033f4:	0f 85 ee 00 00 00    	jne    801034e8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801033fa:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
801033fd:	c7 05 40 27 12 80 01 	movl   $0x1,0x80122740
80103404:	00 00 00 
  release(&log.lock);
80103407:	68 00 27 12 80       	push   $0x80122700
8010340c:	e8 9f 1a 00 00       	call   80104eb0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103411:	8b 0d 48 27 12 80    	mov    0x80122748,%ecx
80103417:	83 c4 10             	add    $0x10,%esp
8010341a:	85 c9                	test   %ecx,%ecx
8010341c:	0f 8e 85 00 00 00    	jle    801034a7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103422:	a1 34 27 12 80       	mov    0x80122734,%eax
80103427:	83 ec 08             	sub    $0x8,%esp
8010342a:	01 d8                	add    %ebx,%eax
8010342c:	83 c0 01             	add    $0x1,%eax
8010342f:	50                   	push   %eax
80103430:	ff 35 44 27 12 80    	pushl  0x80122744
80103436:	e8 95 cc ff ff       	call   801000d0 <bread>
8010343b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010343d:	58                   	pop    %eax
8010343e:	5a                   	pop    %edx
8010343f:	ff 34 9d 4c 27 12 80 	pushl  -0x7fedd8b4(,%ebx,4)
80103446:	ff 35 44 27 12 80    	pushl  0x80122744
  for (tail = 0; tail < log.lh.n; tail++) {
8010344c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010344f:	e8 7c cc ff ff       	call   801000d0 <bread>
80103454:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103456:	8d 40 5c             	lea    0x5c(%eax),%eax
80103459:	83 c4 0c             	add    $0xc,%esp
8010345c:	68 00 02 00 00       	push   $0x200
80103461:	50                   	push   %eax
80103462:	8d 46 5c             	lea    0x5c(%esi),%eax
80103465:	50                   	push   %eax
80103466:	e8 45 1b 00 00       	call   80104fb0 <memmove>
    bwrite(to);  // write the log
8010346b:	89 34 24             	mov    %esi,(%esp)
8010346e:	e8 2d cd ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103473:	89 3c 24             	mov    %edi,(%esp)
80103476:	e8 65 cd ff ff       	call   801001e0 <brelse>
    brelse(to);
8010347b:	89 34 24             	mov    %esi,(%esp)
8010347e:	e8 5d cd ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103483:	83 c4 10             	add    $0x10,%esp
80103486:	3b 1d 48 27 12 80    	cmp    0x80122748,%ebx
8010348c:	7c 94                	jl     80103422 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010348e:	e8 bd fd ff ff       	call   80103250 <write_head>
    install_trans(); // Now install writes to home locations
80103493:	e8 18 fd ff ff       	call   801031b0 <install_trans>
    log.lh.n = 0;
80103498:	c7 05 48 27 12 80 00 	movl   $0x0,0x80122748
8010349f:	00 00 00 
    write_head();    // Erase the transaction from the log
801034a2:	e8 a9 fd ff ff       	call   80103250 <write_head>
    acquire(&log.lock);
801034a7:	83 ec 0c             	sub    $0xc,%esp
801034aa:	68 00 27 12 80       	push   $0x80122700
801034af:	e8 3c 19 00 00       	call   80104df0 <acquire>
    wakeup(&log);
801034b4:	c7 04 24 00 27 12 80 	movl   $0x80122700,(%esp)
    log.committing = 0;
801034bb:	c7 05 40 27 12 80 00 	movl   $0x0,0x80122740
801034c2:	00 00 00 
    wakeup(&log);
801034c5:	e8 f6 14 00 00       	call   801049c0 <wakeup>
    release(&log.lock);
801034ca:	c7 04 24 00 27 12 80 	movl   $0x80122700,(%esp)
801034d1:	e8 da 19 00 00       	call   80104eb0 <release>
801034d6:	83 c4 10             	add    $0x10,%esp
}
801034d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034dc:	5b                   	pop    %ebx
801034dd:	5e                   	pop    %esi
801034de:	5f                   	pop    %edi
801034df:	5d                   	pop    %ebp
801034e0:	c3                   	ret    
801034e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
801034e8:	83 ec 0c             	sub    $0xc,%esp
801034eb:	68 00 27 12 80       	push   $0x80122700
801034f0:	e8 cb 14 00 00       	call   801049c0 <wakeup>
  release(&log.lock);
801034f5:	c7 04 24 00 27 12 80 	movl   $0x80122700,(%esp)
801034fc:	e8 af 19 00 00       	call   80104eb0 <release>
80103501:	83 c4 10             	add    $0x10,%esp
}
80103504:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103507:	5b                   	pop    %ebx
80103508:	5e                   	pop    %esi
80103509:	5f                   	pop    %edi
8010350a:	5d                   	pop    %ebp
8010350b:	c3                   	ret    
    panic("log.committing");
8010350c:	83 ec 0c             	sub    $0xc,%esp
8010350f:	68 04 8b 10 80       	push   $0x80108b04
80103514:	e8 77 ce ff ff       	call   80100390 <panic>
80103519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103520 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103520:	55                   	push   %ebp
80103521:	89 e5                	mov    %esp,%ebp
80103523:	53                   	push   %ebx
80103524:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103527:	8b 15 48 27 12 80    	mov    0x80122748,%edx
{
8010352d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103530:	83 fa 1d             	cmp    $0x1d,%edx
80103533:	0f 8f 9d 00 00 00    	jg     801035d6 <log_write+0xb6>
80103539:	a1 38 27 12 80       	mov    0x80122738,%eax
8010353e:	83 e8 01             	sub    $0x1,%eax
80103541:	39 c2                	cmp    %eax,%edx
80103543:	0f 8d 8d 00 00 00    	jge    801035d6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103549:	a1 3c 27 12 80       	mov    0x8012273c,%eax
8010354e:	85 c0                	test   %eax,%eax
80103550:	0f 8e 8d 00 00 00    	jle    801035e3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103556:	83 ec 0c             	sub    $0xc,%esp
80103559:	68 00 27 12 80       	push   $0x80122700
8010355e:	e8 8d 18 00 00       	call   80104df0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103563:	8b 0d 48 27 12 80    	mov    0x80122748,%ecx
80103569:	83 c4 10             	add    $0x10,%esp
8010356c:	83 f9 00             	cmp    $0x0,%ecx
8010356f:	7e 57                	jle    801035c8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103571:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103574:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103576:	3b 15 4c 27 12 80    	cmp    0x8012274c,%edx
8010357c:	75 0b                	jne    80103589 <log_write+0x69>
8010357e:	eb 38                	jmp    801035b8 <log_write+0x98>
80103580:	39 14 85 4c 27 12 80 	cmp    %edx,-0x7fedd8b4(,%eax,4)
80103587:	74 2f                	je     801035b8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103589:	83 c0 01             	add    $0x1,%eax
8010358c:	39 c1                	cmp    %eax,%ecx
8010358e:	75 f0                	jne    80103580 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103590:	89 14 85 4c 27 12 80 	mov    %edx,-0x7fedd8b4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103597:	83 c0 01             	add    $0x1,%eax
8010359a:	a3 48 27 12 80       	mov    %eax,0x80122748
  b->flags |= B_DIRTY; // prevent eviction
8010359f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801035a2:	c7 45 08 00 27 12 80 	movl   $0x80122700,0x8(%ebp)
}
801035a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801035ac:	c9                   	leave  
  release(&log.lock);
801035ad:	e9 fe 18 00 00       	jmp    80104eb0 <release>
801035b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801035b8:	89 14 85 4c 27 12 80 	mov    %edx,-0x7fedd8b4(,%eax,4)
801035bf:	eb de                	jmp    8010359f <log_write+0x7f>
801035c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035c8:	8b 43 08             	mov    0x8(%ebx),%eax
801035cb:	a3 4c 27 12 80       	mov    %eax,0x8012274c
  if (i == log.lh.n)
801035d0:	75 cd                	jne    8010359f <log_write+0x7f>
801035d2:	31 c0                	xor    %eax,%eax
801035d4:	eb c1                	jmp    80103597 <log_write+0x77>
    panic("too big a transaction");
801035d6:	83 ec 0c             	sub    $0xc,%esp
801035d9:	68 13 8b 10 80       	push   $0x80108b13
801035de:	e8 ad cd ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801035e3:	83 ec 0c             	sub    $0xc,%esp
801035e6:	68 29 8b 10 80       	push   $0x80108b29
801035eb:	e8 a0 cd ff ff       	call   80100390 <panic>

801035f0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	53                   	push   %ebx
801035f4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801035f7:	e8 f4 09 00 00       	call   80103ff0 <cpuid>
801035fc:	89 c3                	mov    %eax,%ebx
801035fe:	e8 ed 09 00 00       	call   80103ff0 <cpuid>
80103603:	83 ec 04             	sub    $0x4,%esp
80103606:	53                   	push   %ebx
80103607:	50                   	push   %eax
80103608:	68 44 8b 10 80       	push   $0x80108b44
8010360d:	e8 4e d0 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103612:	e8 b9 2b 00 00       	call   801061d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103617:	e8 44 09 00 00       	call   80103f60 <mycpu>
8010361c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010361e:	b8 01 00 00 00       	mov    $0x1,%eax
80103623:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010362a:	e8 51 0e 00 00       	call   80104480 <scheduler>
8010362f:	90                   	nop

80103630 <mpenter>:
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103636:	e8 f5 40 00 00       	call   80107730 <switchkvm>
  seginit();
8010363b:	e8 40 40 00 00       	call   80107680 <seginit>
  lapicinit();
80103640:	e8 9b f7 ff ff       	call   80102de0 <lapicinit>
  mpmain();
80103645:	e8 a6 ff ff ff       	call   801035f0 <mpmain>
8010364a:	66 90                	xchg   %ax,%ax
8010364c:	66 90                	xchg   %ax,%ax
8010364e:	66 90                	xchg   %ax,%ax

80103650 <main>:
{
80103650:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103654:	83 e4 f0             	and    $0xfffffff0,%esp
80103657:	ff 71 fc             	pushl  -0x4(%ecx)
8010365a:	55                   	push   %ebp
8010365b:	89 e5                	mov    %esp,%ebp
8010365d:	53                   	push   %ebx
8010365e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010365f:	83 ec 08             	sub    $0x8,%esp
80103662:	68 00 00 40 80       	push   $0x80400000
80103667:	68 28 1a 13 80       	push   $0x80131a28
8010366c:	e8 0f f5 ff ff       	call   80102b80 <kinit1>
  kvmalloc();      // kernel page table
80103671:	e8 da 45 00 00       	call   80107c50 <kvmalloc>
  mpinit();        // detect other processors
80103676:	e8 75 01 00 00       	call   801037f0 <mpinit>
  lapicinit();     // interrupt controller
8010367b:	e8 60 f7 ff ff       	call   80102de0 <lapicinit>
  init_cow();
80103680:	e8 bb f3 ff ff       	call   80102a40 <init_cow>
  seginit();       // segment descriptors
80103685:	e8 f6 3f 00 00       	call   80107680 <seginit>
  picinit();       // disable pic
8010368a:	e8 41 03 00 00       	call   801039d0 <picinit>
  ioapicinit();    // another interrupt controller
8010368f:	e8 bc f2 ff ff       	call   80102950 <ioapicinit>
  consoleinit();   // console hardware
80103694:	e8 27 d3 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103699:	e8 82 2f 00 00       	call   80106620 <uartinit>
  pinit();         // process table
8010369e:	e8 9d 08 00 00       	call   80103f40 <pinit>
  tvinit();        // trap vectors
801036a3:	e8 a8 2a 00 00       	call   80106150 <tvinit>
  binit();         // buffer cache
801036a8:	e8 93 c9 ff ff       	call   80100040 <binit>
  fileinit();      // file table
801036ad:	e8 4e da ff ff       	call   80101100 <fileinit>
  ideinit();       // disk 
801036b2:	e8 79 f0 ff ff       	call   80102730 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801036b7:	83 c4 0c             	add    $0xc,%esp
801036ba:	68 8a 00 00 00       	push   $0x8a
801036bf:	68 8c c4 10 80       	push   $0x8010c48c
801036c4:	68 00 70 00 80       	push   $0x80007000
801036c9:	e8 e2 18 00 00       	call   80104fb0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801036ce:	69 05 80 2d 12 80 b0 	imul   $0xb0,0x80122d80,%eax
801036d5:	00 00 00 
801036d8:	83 c4 10             	add    $0x10,%esp
801036db:	05 00 28 12 80       	add    $0x80122800,%eax
801036e0:	3d 00 28 12 80       	cmp    $0x80122800,%eax
801036e5:	76 6c                	jbe    80103753 <main+0x103>
801036e7:	bb 00 28 12 80       	mov    $0x80122800,%ebx
801036ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
801036f0:	e8 6b 08 00 00       	call   80103f60 <mycpu>
801036f5:	39 d8                	cmp    %ebx,%eax
801036f7:	74 41                	je     8010373a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = cow_kalloc();
801036f9:	e8 32 3b 00 00       	call   80107230 <cow_kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801036fe:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103703:	c7 05 f8 6f 00 80 30 	movl   $0x80103630,0x80006ff8
8010370a:	36 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010370d:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103714:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103717:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010371c:	0f b6 03             	movzbl (%ebx),%eax
8010371f:	83 ec 08             	sub    $0x8,%esp
80103722:	68 00 70 00 00       	push   $0x7000
80103727:	50                   	push   %eax
80103728:	e8 03 f8 ff ff       	call   80102f30 <lapicstartap>
8010372d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103730:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103736:	85 c0                	test   %eax,%eax
80103738:	74 f6                	je     80103730 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010373a:	69 05 80 2d 12 80 b0 	imul   $0xb0,0x80122d80,%eax
80103741:	00 00 00 
80103744:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010374a:	05 00 28 12 80       	add    $0x80122800,%eax
8010374f:	39 c3                	cmp    %eax,%ebx
80103751:	72 9d                	jb     801036f0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103753:	83 ec 08             	sub    $0x8,%esp
80103756:	68 00 00 00 8e       	push   $0x8e000000
8010375b:	68 00 00 40 80       	push   $0x80400000
80103760:	e8 9b f4 ff ff       	call   80102c00 <kinit2>
  userinit();      // first user process
80103765:	e8 d6 08 00 00       	call   80104040 <userinit>
  mpmain();        // finish this processor's setup
8010376a:	e8 81 fe ff ff       	call   801035f0 <mpmain>
8010376f:	90                   	nop

80103770 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	57                   	push   %edi
80103774:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103775:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010377b:	53                   	push   %ebx
  e = addr+len;
8010377c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010377f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103782:	39 de                	cmp    %ebx,%esi
80103784:	72 10                	jb     80103796 <mpsearch1+0x26>
80103786:	eb 50                	jmp    801037d8 <mpsearch1+0x68>
80103788:	90                   	nop
80103789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103790:	39 fb                	cmp    %edi,%ebx
80103792:	89 fe                	mov    %edi,%esi
80103794:	76 42                	jbe    801037d8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103796:	83 ec 04             	sub    $0x4,%esp
80103799:	8d 7e 10             	lea    0x10(%esi),%edi
8010379c:	6a 04                	push   $0x4
8010379e:	68 58 8b 10 80       	push   $0x80108b58
801037a3:	56                   	push   %esi
801037a4:	e8 a7 17 00 00       	call   80104f50 <memcmp>
801037a9:	83 c4 10             	add    $0x10,%esp
801037ac:	85 c0                	test   %eax,%eax
801037ae:	75 e0                	jne    80103790 <mpsearch1+0x20>
801037b0:	89 f1                	mov    %esi,%ecx
801037b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801037b8:	0f b6 11             	movzbl (%ecx),%edx
801037bb:	83 c1 01             	add    $0x1,%ecx
801037be:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801037c0:	39 f9                	cmp    %edi,%ecx
801037c2:	75 f4                	jne    801037b8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801037c4:	84 c0                	test   %al,%al
801037c6:	75 c8                	jne    80103790 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801037c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037cb:	89 f0                	mov    %esi,%eax
801037cd:	5b                   	pop    %ebx
801037ce:	5e                   	pop    %esi
801037cf:	5f                   	pop    %edi
801037d0:	5d                   	pop    %ebp
801037d1:	c3                   	ret    
801037d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801037db:	31 f6                	xor    %esi,%esi
}
801037dd:	89 f0                	mov    %esi,%eax
801037df:	5b                   	pop    %ebx
801037e0:	5e                   	pop    %esi
801037e1:	5f                   	pop    %edi
801037e2:	5d                   	pop    %ebp
801037e3:	c3                   	ret    
801037e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801037f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	57                   	push   %edi
801037f4:	56                   	push   %esi
801037f5:	53                   	push   %ebx
801037f6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801037f9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103800:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103807:	c1 e0 08             	shl    $0x8,%eax
8010380a:	09 d0                	or     %edx,%eax
8010380c:	c1 e0 04             	shl    $0x4,%eax
8010380f:	85 c0                	test   %eax,%eax
80103811:	75 1b                	jne    8010382e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103813:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010381a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103821:	c1 e0 08             	shl    $0x8,%eax
80103824:	09 d0                	or     %edx,%eax
80103826:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103829:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010382e:	ba 00 04 00 00       	mov    $0x400,%edx
80103833:	e8 38 ff ff ff       	call   80103770 <mpsearch1>
80103838:	85 c0                	test   %eax,%eax
8010383a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010383d:	0f 84 3d 01 00 00    	je     80103980 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103843:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103846:	8b 58 04             	mov    0x4(%eax),%ebx
80103849:	85 db                	test   %ebx,%ebx
8010384b:	0f 84 4f 01 00 00    	je     801039a0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103851:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103857:	83 ec 04             	sub    $0x4,%esp
8010385a:	6a 04                	push   $0x4
8010385c:	68 75 8b 10 80       	push   $0x80108b75
80103861:	56                   	push   %esi
80103862:	e8 e9 16 00 00       	call   80104f50 <memcmp>
80103867:	83 c4 10             	add    $0x10,%esp
8010386a:	85 c0                	test   %eax,%eax
8010386c:	0f 85 2e 01 00 00    	jne    801039a0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103872:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103879:	3c 01                	cmp    $0x1,%al
8010387b:	0f 95 c2             	setne  %dl
8010387e:	3c 04                	cmp    $0x4,%al
80103880:	0f 95 c0             	setne  %al
80103883:	20 c2                	and    %al,%dl
80103885:	0f 85 15 01 00 00    	jne    801039a0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010388b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103892:	66 85 ff             	test   %di,%di
80103895:	74 1a                	je     801038b1 <mpinit+0xc1>
80103897:	89 f0                	mov    %esi,%eax
80103899:	01 f7                	add    %esi,%edi
  sum = 0;
8010389b:	31 d2                	xor    %edx,%edx
8010389d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801038a0:	0f b6 08             	movzbl (%eax),%ecx
801038a3:	83 c0 01             	add    $0x1,%eax
801038a6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801038a8:	39 c7                	cmp    %eax,%edi
801038aa:	75 f4                	jne    801038a0 <mpinit+0xb0>
801038ac:	84 d2                	test   %dl,%dl
801038ae:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801038b1:	85 f6                	test   %esi,%esi
801038b3:	0f 84 e7 00 00 00    	je     801039a0 <mpinit+0x1b0>
801038b9:	84 d2                	test   %dl,%dl
801038bb:	0f 85 df 00 00 00    	jne    801039a0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801038c1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801038c7:	a3 f4 26 12 80       	mov    %eax,0x801226f4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801038cc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801038d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801038d9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801038de:	01 d6                	add    %edx,%esi
801038e0:	39 c6                	cmp    %eax,%esi
801038e2:	76 23                	jbe    80103907 <mpinit+0x117>
    switch(*p){
801038e4:	0f b6 10             	movzbl (%eax),%edx
801038e7:	80 fa 04             	cmp    $0x4,%dl
801038ea:	0f 87 ca 00 00 00    	ja     801039ba <mpinit+0x1ca>
801038f0:	ff 24 95 9c 8b 10 80 	jmp    *-0x7fef7464(,%edx,4)
801038f7:	89 f6                	mov    %esi,%esi
801038f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103900:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103903:	39 c6                	cmp    %eax,%esi
80103905:	77 dd                	ja     801038e4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103907:	85 db                	test   %ebx,%ebx
80103909:	0f 84 9e 00 00 00    	je     801039ad <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010390f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103912:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103916:	74 15                	je     8010392d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103918:	b8 70 00 00 00       	mov    $0x70,%eax
8010391d:	ba 22 00 00 00       	mov    $0x22,%edx
80103922:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103923:	ba 23 00 00 00       	mov    $0x23,%edx
80103928:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103929:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010392c:	ee                   	out    %al,(%dx)
  }
}
8010392d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103930:	5b                   	pop    %ebx
80103931:	5e                   	pop    %esi
80103932:	5f                   	pop    %edi
80103933:	5d                   	pop    %ebp
80103934:	c3                   	ret    
80103935:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103938:	8b 0d 80 2d 12 80    	mov    0x80122d80,%ecx
8010393e:	83 f9 07             	cmp    $0x7,%ecx
80103941:	7f 19                	jg     8010395c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103943:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103947:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010394d:	83 c1 01             	add    $0x1,%ecx
80103950:	89 0d 80 2d 12 80    	mov    %ecx,0x80122d80
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103956:	88 97 00 28 12 80    	mov    %dl,-0x7fedd800(%edi)
      p += sizeof(struct mpproc);
8010395c:	83 c0 14             	add    $0x14,%eax
      continue;
8010395f:	e9 7c ff ff ff       	jmp    801038e0 <mpinit+0xf0>
80103964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103968:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010396c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010396f:	88 15 e0 27 12 80    	mov    %dl,0x801227e0
      continue;
80103975:	e9 66 ff ff ff       	jmp    801038e0 <mpinit+0xf0>
8010397a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103980:	ba 00 00 01 00       	mov    $0x10000,%edx
80103985:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010398a:	e8 e1 fd ff ff       	call   80103770 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010398f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103991:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103994:	0f 85 a9 fe ff ff    	jne    80103843 <mpinit+0x53>
8010399a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801039a0:	83 ec 0c             	sub    $0xc,%esp
801039a3:	68 5d 8b 10 80       	push   $0x80108b5d
801039a8:	e8 e3 c9 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801039ad:	83 ec 0c             	sub    $0xc,%esp
801039b0:	68 7c 8b 10 80       	push   $0x80108b7c
801039b5:	e8 d6 c9 ff ff       	call   80100390 <panic>
      ismp = 0;
801039ba:	31 db                	xor    %ebx,%ebx
801039bc:	e9 26 ff ff ff       	jmp    801038e7 <mpinit+0xf7>
801039c1:	66 90                	xchg   %ax,%ax
801039c3:	66 90                	xchg   %ax,%ax
801039c5:	66 90                	xchg   %ax,%ax
801039c7:	66 90                	xchg   %ax,%ax
801039c9:	66 90                	xchg   %ax,%ax
801039cb:	66 90                	xchg   %ax,%ax
801039cd:	66 90                	xchg   %ax,%ax
801039cf:	90                   	nop

801039d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801039d0:	55                   	push   %ebp
801039d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039d6:	ba 21 00 00 00       	mov    $0x21,%edx
801039db:	89 e5                	mov    %esp,%ebp
801039dd:	ee                   	out    %al,(%dx)
801039de:	ba a1 00 00 00       	mov    $0xa1,%edx
801039e3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801039e4:	5d                   	pop    %ebp
801039e5:	c3                   	ret    
801039e6:	66 90                	xchg   %ax,%ax
801039e8:	66 90                	xchg   %ax,%ax
801039ea:	66 90                	xchg   %ax,%ax
801039ec:	66 90                	xchg   %ax,%ax
801039ee:	66 90                	xchg   %ax,%ax

801039f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	57                   	push   %edi
801039f4:	56                   	push   %esi
801039f5:	53                   	push   %ebx
801039f6:	83 ec 0c             	sub    $0xc,%esp
801039f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801039fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801039ff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103a05:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103a0b:	e8 10 d7 ff ff       	call   80101120 <filealloc>
80103a10:	85 c0                	test   %eax,%eax
80103a12:	89 03                	mov    %eax,(%ebx)
80103a14:	74 22                	je     80103a38 <pipealloc+0x48>
80103a16:	e8 05 d7 ff ff       	call   80101120 <filealloc>
80103a1b:	85 c0                	test   %eax,%eax
80103a1d:	89 06                	mov    %eax,(%esi)
80103a1f:	74 3f                	je     80103a60 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)cow_kalloc()) == 0)
80103a21:	e8 0a 38 00 00       	call   80107230 <cow_kalloc>
80103a26:	85 c0                	test   %eax,%eax
80103a28:	89 c7                	mov    %eax,%edi
80103a2a:	75 54                	jne    80103a80 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    cow_kfree((char*)p);
  if(*f0)
80103a2c:	8b 03                	mov    (%ebx),%eax
80103a2e:	85 c0                	test   %eax,%eax
80103a30:	75 34                	jne    80103a66 <pipealloc+0x76>
80103a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103a38:	8b 06                	mov    (%esi),%eax
80103a3a:	85 c0                	test   %eax,%eax
80103a3c:	74 0c                	je     80103a4a <pipealloc+0x5a>
    fileclose(*f1);
80103a3e:	83 ec 0c             	sub    $0xc,%esp
80103a41:	50                   	push   %eax
80103a42:	e8 99 d7 ff ff       	call   801011e0 <fileclose>
80103a47:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103a4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103a4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103a52:	5b                   	pop    %ebx
80103a53:	5e                   	pop    %esi
80103a54:	5f                   	pop    %edi
80103a55:	5d                   	pop    %ebp
80103a56:	c3                   	ret    
80103a57:	89 f6                	mov    %esi,%esi
80103a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103a60:	8b 03                	mov    (%ebx),%eax
80103a62:	85 c0                	test   %eax,%eax
80103a64:	74 e4                	je     80103a4a <pipealloc+0x5a>
    fileclose(*f0);
80103a66:	83 ec 0c             	sub    $0xc,%esp
80103a69:	50                   	push   %eax
80103a6a:	e8 71 d7 ff ff       	call   801011e0 <fileclose>
  if(*f1)
80103a6f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103a71:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103a74:	85 c0                	test   %eax,%eax
80103a76:	75 c6                	jne    80103a3e <pipealloc+0x4e>
80103a78:	eb d0                	jmp    80103a4a <pipealloc+0x5a>
80103a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103a80:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103a83:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103a8a:	00 00 00 
  p->writeopen = 1;
80103a8d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103a94:	00 00 00 
  p->nwrite = 0;
80103a97:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103a9e:	00 00 00 
  p->nread = 0;
80103aa1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103aa8:	00 00 00 
  initlock(&p->lock, "pipe");
80103aab:	68 b0 8b 10 80       	push   $0x80108bb0
80103ab0:	50                   	push   %eax
80103ab1:	e8 fa 11 00 00       	call   80104cb0 <initlock>
  (*f0)->type = FD_PIPE;
80103ab6:	8b 03                	mov    (%ebx),%eax
  return 0;
80103ab8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103abb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103ac1:	8b 03                	mov    (%ebx),%eax
80103ac3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103ac7:	8b 03                	mov    (%ebx),%eax
80103ac9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103acd:	8b 03                	mov    (%ebx),%eax
80103acf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103ad2:	8b 06                	mov    (%esi),%eax
80103ad4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103ada:	8b 06                	mov    (%esi),%eax
80103adc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103ae0:	8b 06                	mov    (%esi),%eax
80103ae2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103ae6:	8b 06                	mov    (%esi),%eax
80103ae8:	89 78 0c             	mov    %edi,0xc(%eax)
}
80103aeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103aee:	31 c0                	xor    %eax,%eax
}
80103af0:	5b                   	pop    %ebx
80103af1:	5e                   	pop    %esi
80103af2:	5f                   	pop    %edi
80103af3:	5d                   	pop    %ebp
80103af4:	c3                   	ret    
80103af5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b00 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	56                   	push   %esi
80103b04:	53                   	push   %ebx
80103b05:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b08:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103b0b:	83 ec 0c             	sub    $0xc,%esp
80103b0e:	53                   	push   %ebx
80103b0f:	e8 dc 12 00 00       	call   80104df0 <acquire>
  if(writable){
80103b14:	83 c4 10             	add    $0x10,%esp
80103b17:	85 f6                	test   %esi,%esi
80103b19:	74 45                	je     80103b60 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103b1b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b21:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103b24:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103b2b:	00 00 00 
    wakeup(&p->nread);
80103b2e:	50                   	push   %eax
80103b2f:	e8 8c 0e 00 00       	call   801049c0 <wakeup>
80103b34:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103b37:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103b3d:	85 d2                	test   %edx,%edx
80103b3f:	75 0a                	jne    80103b4b <pipeclose+0x4b>
80103b41:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103b47:	85 c0                	test   %eax,%eax
80103b49:	74 35                	je     80103b80 <pipeclose+0x80>
    release(&p->lock);
    cow_kfree((char*)p);
  } else
    release(&p->lock);
80103b4b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103b4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b51:	5b                   	pop    %ebx
80103b52:	5e                   	pop    %esi
80103b53:	5d                   	pop    %ebp
    release(&p->lock);
80103b54:	e9 57 13 00 00       	jmp    80104eb0 <release>
80103b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103b60:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103b66:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103b69:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103b70:	00 00 00 
    wakeup(&p->nwrite);
80103b73:	50                   	push   %eax
80103b74:	e8 47 0e 00 00       	call   801049c0 <wakeup>
80103b79:	83 c4 10             	add    $0x10,%esp
80103b7c:	eb b9                	jmp    80103b37 <pipeclose+0x37>
80103b7e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103b80:	83 ec 0c             	sub    $0xc,%esp
80103b83:	53                   	push   %ebx
80103b84:	e8 27 13 00 00       	call   80104eb0 <release>
    cow_kfree((char*)p);
80103b89:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103b8c:	83 c4 10             	add    $0x10,%esp
}
80103b8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b92:	5b                   	pop    %ebx
80103b93:	5e                   	pop    %esi
80103b94:	5d                   	pop    %ebp
    cow_kfree((char*)p);
80103b95:	e9 06 36 00 00       	jmp    801071a0 <cow_kfree>
80103b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ba0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	57                   	push   %edi
80103ba4:	56                   	push   %esi
80103ba5:	53                   	push   %ebx
80103ba6:	83 ec 28             	sub    $0x28,%esp
80103ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103bac:	53                   	push   %ebx
80103bad:	e8 3e 12 00 00       	call   80104df0 <acquire>
  for(i = 0; i < n; i++){
80103bb2:	8b 45 10             	mov    0x10(%ebp),%eax
80103bb5:	83 c4 10             	add    $0x10,%esp
80103bb8:	85 c0                	test   %eax,%eax
80103bba:	0f 8e c9 00 00 00    	jle    80103c89 <pipewrite+0xe9>
80103bc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103bc3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103bc9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103bcf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103bd2:	03 4d 10             	add    0x10(%ebp),%ecx
80103bd5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103bd8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103bde:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103be4:	39 d0                	cmp    %edx,%eax
80103be6:	75 71                	jne    80103c59 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103be8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103bee:	85 c0                	test   %eax,%eax
80103bf0:	74 4e                	je     80103c40 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103bf2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103bf8:	eb 3a                	jmp    80103c34 <pipewrite+0x94>
80103bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103c00:	83 ec 0c             	sub    $0xc,%esp
80103c03:	57                   	push   %edi
80103c04:	e8 b7 0d 00 00       	call   801049c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c09:	5a                   	pop    %edx
80103c0a:	59                   	pop    %ecx
80103c0b:	53                   	push   %ebx
80103c0c:	56                   	push   %esi
80103c0d:	e8 5e 0b 00 00       	call   80104770 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c12:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103c18:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103c1e:	83 c4 10             	add    $0x10,%esp
80103c21:	05 00 02 00 00       	add    $0x200,%eax
80103c26:	39 c2                	cmp    %eax,%edx
80103c28:	75 36                	jne    80103c60 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103c2a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103c30:	85 c0                	test   %eax,%eax
80103c32:	74 0c                	je     80103c40 <pipewrite+0xa0>
80103c34:	e8 d7 03 00 00       	call   80104010 <myproc>
80103c39:	8b 40 24             	mov    0x24(%eax),%eax
80103c3c:	85 c0                	test   %eax,%eax
80103c3e:	74 c0                	je     80103c00 <pipewrite+0x60>
        release(&p->lock);
80103c40:	83 ec 0c             	sub    $0xc,%esp
80103c43:	53                   	push   %ebx
80103c44:	e8 67 12 00 00       	call   80104eb0 <release>
        return -1;
80103c49:	83 c4 10             	add    $0x10,%esp
80103c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c54:	5b                   	pop    %ebx
80103c55:	5e                   	pop    %esi
80103c56:	5f                   	pop    %edi
80103c57:	5d                   	pop    %ebp
80103c58:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c59:	89 c2                	mov    %eax,%edx
80103c5b:	90                   	nop
80103c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103c60:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103c63:	8d 42 01             	lea    0x1(%edx),%eax
80103c66:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103c6c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103c72:	83 c6 01             	add    $0x1,%esi
80103c75:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103c79:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103c7c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103c7f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103c83:	0f 85 4f ff ff ff    	jne    80103bd8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103c89:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103c8f:	83 ec 0c             	sub    $0xc,%esp
80103c92:	50                   	push   %eax
80103c93:	e8 28 0d 00 00       	call   801049c0 <wakeup>
  release(&p->lock);
80103c98:	89 1c 24             	mov    %ebx,(%esp)
80103c9b:	e8 10 12 00 00       	call   80104eb0 <release>
  return n;
80103ca0:	83 c4 10             	add    $0x10,%esp
80103ca3:	8b 45 10             	mov    0x10(%ebp),%eax
80103ca6:	eb a9                	jmp    80103c51 <pipewrite+0xb1>
80103ca8:	90                   	nop
80103ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cb0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	57                   	push   %edi
80103cb4:	56                   	push   %esi
80103cb5:	53                   	push   %ebx
80103cb6:	83 ec 18             	sub    $0x18,%esp
80103cb9:	8b 75 08             	mov    0x8(%ebp),%esi
80103cbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103cbf:	56                   	push   %esi
80103cc0:	e8 2b 11 00 00       	call   80104df0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103cc5:	83 c4 10             	add    $0x10,%esp
80103cc8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103cce:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103cd4:	75 6a                	jne    80103d40 <piperead+0x90>
80103cd6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103cdc:	85 db                	test   %ebx,%ebx
80103cde:	0f 84 c4 00 00 00    	je     80103da8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ce4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103cea:	eb 2d                	jmp    80103d19 <piperead+0x69>
80103cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cf0:	83 ec 08             	sub    $0x8,%esp
80103cf3:	56                   	push   %esi
80103cf4:	53                   	push   %ebx
80103cf5:	e8 76 0a 00 00       	call   80104770 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103cfa:	83 c4 10             	add    $0x10,%esp
80103cfd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103d03:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103d09:	75 35                	jne    80103d40 <piperead+0x90>
80103d0b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103d11:	85 d2                	test   %edx,%edx
80103d13:	0f 84 8f 00 00 00    	je     80103da8 <piperead+0xf8>
    if(myproc()->killed){
80103d19:	e8 f2 02 00 00       	call   80104010 <myproc>
80103d1e:	8b 48 24             	mov    0x24(%eax),%ecx
80103d21:	85 c9                	test   %ecx,%ecx
80103d23:	74 cb                	je     80103cf0 <piperead+0x40>
      release(&p->lock);
80103d25:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103d28:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103d2d:	56                   	push   %esi
80103d2e:	e8 7d 11 00 00       	call   80104eb0 <release>
      return -1;
80103d33:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d39:	89 d8                	mov    %ebx,%eax
80103d3b:	5b                   	pop    %ebx
80103d3c:	5e                   	pop    %esi
80103d3d:	5f                   	pop    %edi
80103d3e:	5d                   	pop    %ebp
80103d3f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103d40:	8b 45 10             	mov    0x10(%ebp),%eax
80103d43:	85 c0                	test   %eax,%eax
80103d45:	7e 61                	jle    80103da8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103d47:	31 db                	xor    %ebx,%ebx
80103d49:	eb 13                	jmp    80103d5e <piperead+0xae>
80103d4b:	90                   	nop
80103d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d50:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103d56:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103d5c:	74 1f                	je     80103d7d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103d5e:	8d 41 01             	lea    0x1(%ecx),%eax
80103d61:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103d67:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103d6d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103d72:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103d75:	83 c3 01             	add    $0x1,%ebx
80103d78:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103d7b:	75 d3                	jne    80103d50 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103d7d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103d83:	83 ec 0c             	sub    $0xc,%esp
80103d86:	50                   	push   %eax
80103d87:	e8 34 0c 00 00       	call   801049c0 <wakeup>
  release(&p->lock);
80103d8c:	89 34 24             	mov    %esi,(%esp)
80103d8f:	e8 1c 11 00 00       	call   80104eb0 <release>
  return i;
80103d94:	83 c4 10             	add    $0x10,%esp
}
80103d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d9a:	89 d8                	mov    %ebx,%eax
80103d9c:	5b                   	pop    %ebx
80103d9d:	5e                   	pop    %esi
80103d9e:	5f                   	pop    %edi
80103d9f:	5d                   	pop    %ebp
80103da0:	c3                   	ret    
80103da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103da8:	31 db                	xor    %ebx,%ebx
80103daa:	eb d1                	jmp    80103d7d <piperead+0xcd>
80103dac:	66 90                	xchg   %ax,%ax
80103dae:	66 90                	xchg   %ax,%ax

80103db0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103db4:	bb d4 2d 12 80       	mov    $0x80122dd4,%ebx
{
80103db9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103dbc:	68 a0 2d 12 80       	push   $0x80122da0
80103dc1:	e8 2a 10 00 00       	call   80104df0 <acquire>
80103dc6:	83 c4 10             	add    $0x10,%esp
80103dc9:	eb 17                	jmp    80103de2 <allocproc+0x32>
80103dcb:	90                   	nop
80103dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dd0:	81 c3 90 03 00 00    	add    $0x390,%ebx
80103dd6:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
80103ddc:	0f 83 de 00 00 00    	jae    80103ec0 <allocproc+0x110>
    if(p->state == UNUSED)
80103de2:	8b 43 0c             	mov    0xc(%ebx),%eax
80103de5:	85 c0                	test   %eax,%eax
80103de7:	75 e7                	jne    80103dd0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103de9:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80103dee:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103df1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103df8:	8d 50 01             	lea    0x1(%eax),%edx
80103dfb:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103dfe:	68 a0 2d 12 80       	push   $0x80122da0
  p->pid = nextpid++;
80103e03:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103e09:	e8 a2 10 00 00       	call   80104eb0 <release>

  // Allocate kernel stack.
  if((p->kstack = cow_kalloc()) == 0){
80103e0e:	e8 1d 34 00 00       	call   80107230 <cow_kalloc>
80103e13:	83 c4 10             	add    $0x10,%esp
80103e16:	85 c0                	test   %eax,%eax
80103e18:	89 43 08             	mov    %eax,0x8(%ebx)
80103e1b:	0f 84 b8 00 00 00    	je     80103ed9 <allocproc+0x129>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103e21:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103e27:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103e2a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103e2f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103e32:	c7 40 14 41 61 10 80 	movl   $0x80106141,0x14(%eax)
  p->context = (struct context*)sp;
80103e39:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103e3c:	6a 14                	push   $0x14
80103e3e:	6a 00                	push   $0x0
80103e40:	50                   	push   %eax
80103e41:	e8 ba 10 00 00       	call   80104f00 <memset>
  p->context->eip = (uint)forkret;
80103e46:	8b 43 1c             	mov    0x1c(%ebx),%eax

 if (p->pid > 2){
80103e49:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103e4c:	c7 40 10 f0 3e 10 80 	movl   $0x80103ef0,0x10(%eax)
 if (p->pid > 2){
80103e53:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103e57:	7f 07                	jg     80103e60 <allocproc+0xb0>
    for (int i = 0; i < 16; i++){
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
  }
 }
  return p;
}
80103e59:	89 d8                	mov    %ebx,%eax
80103e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e5e:	c9                   	leave  
80103e5f:	c3                   	ret    
    createSwapFile(p);
80103e60:	83 ec 0c             	sub    $0xc,%esp
    p->num_of_actual_pages_in_mem = 0;
80103e63:	c7 83 84 03 00 00 00 	movl   $0x0,0x384(%ebx)
80103e6a:	00 00 00 
    p->num_of_pagefaults_occurs = 0;
80103e6d:	c7 83 88 03 00 00 00 	movl   $0x0,0x388(%ebx)
80103e74:	00 00 00 
    p->num_of_pageOut_occured = 0;
80103e77:	c7 83 8c 03 00 00 00 	movl   $0x0,0x38c(%ebx)
80103e7e:	00 00 00 
    p->num_of_pages_in_swap_file = 0;
80103e81:	c7 83 80 03 00 00 00 	movl   $0x0,0x380(%ebx)
80103e88:	00 00 00 
    createSwapFile(p);
80103e8b:	53                   	push   %ebx
80103e8c:	e8 bf e6 ff ff       	call   80102550 <createSwapFile>
80103e91:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103e97:	8d 93 00 02 00 00    	lea    0x200(%ebx),%edx
80103e9d:	83 c4 10             	add    $0x10,%esp
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80103ea0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103ea6:	c7 80 80 01 00 00 01 	movl   $0x1,0x180(%eax)
80103ead:	00 00 00 
80103eb0:	83 c0 18             	add    $0x18,%eax
    for (int i = 0; i < 16; i++){
80103eb3:	39 c2                	cmp    %eax,%edx
80103eb5:	75 e9                	jne    80103ea0 <allocproc+0xf0>
}
80103eb7:	89 d8                	mov    %ebx,%eax
80103eb9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ebc:	c9                   	leave  
80103ebd:	c3                   	ret    
80103ebe:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103ec0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103ec3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103ec5:	68 a0 2d 12 80       	push   $0x80122da0
80103eca:	e8 e1 0f 00 00       	call   80104eb0 <release>
}
80103ecf:	89 d8                	mov    %ebx,%eax
  return 0;
80103ed1:	83 c4 10             	add    $0x10,%esp
}
80103ed4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ed7:	c9                   	leave  
80103ed8:	c3                   	ret    
    p->state = UNUSED;
80103ed9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103ee0:	31 db                	xor    %ebx,%ebx
80103ee2:	e9 72 ff ff ff       	jmp    80103e59 <allocproc+0xa9>
80103ee7:	89 f6                	mov    %esi,%esi
80103ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ef0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103ef6:	68 a0 2d 12 80       	push   $0x80122da0
80103efb:	e8 b0 0f 00 00       	call   80104eb0 <release>

  if (first) {
80103f00:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103f05:	83 c4 10             	add    $0x10,%esp
80103f08:	85 c0                	test   %eax,%eax
80103f0a:	75 04                	jne    80103f10 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103f0c:	c9                   	leave  
80103f0d:	c3                   	ret    
80103f0e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103f10:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103f13:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103f1a:	00 00 00 
    iinit(ROOTDEV);
80103f1d:	6a 01                	push   $0x1
80103f1f:	e8 fc d8 ff ff       	call   80101820 <iinit>
    initlog(ROOTDEV);
80103f24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103f2b:	e8 80 f3 ff ff       	call   801032b0 <initlog>
80103f30:	83 c4 10             	add    $0x10,%esp
}
80103f33:	c9                   	leave  
80103f34:	c3                   	ret    
80103f35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f40 <pinit>:
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103f46:	68 b5 8b 10 80       	push   $0x80108bb5
80103f4b:	68 a0 2d 12 80       	push   $0x80122da0
80103f50:	e8 5b 0d 00 00       	call   80104cb0 <initlock>
}
80103f55:	83 c4 10             	add    $0x10,%esp
80103f58:	c9                   	leave  
80103f59:	c3                   	ret    
80103f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f60 <mycpu>:
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	56                   	push   %esi
80103f64:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f65:	9c                   	pushf  
80103f66:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f67:	f6 c4 02             	test   $0x2,%ah
80103f6a:	75 6b                	jne    80103fd7 <mycpu+0x77>
  apicid = lapicid();
80103f6c:	e8 6f ef ff ff       	call   80102ee0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103f71:	8b 35 80 2d 12 80    	mov    0x80122d80,%esi
80103f77:	85 f6                	test   %esi,%esi
80103f79:	7e 42                	jle    80103fbd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103f7b:	0f b6 15 00 28 12 80 	movzbl 0x80122800,%edx
80103f82:	39 d0                	cmp    %edx,%eax
80103f84:	74 30                	je     80103fb6 <mycpu+0x56>
80103f86:	b9 b0 28 12 80       	mov    $0x801228b0,%ecx
  for (i = 0; i < ncpu; ++i) {
80103f8b:	31 d2                	xor    %edx,%edx
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi
80103f90:	83 c2 01             	add    $0x1,%edx
80103f93:	39 f2                	cmp    %esi,%edx
80103f95:	74 26                	je     80103fbd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103f97:	0f b6 19             	movzbl (%ecx),%ebx
80103f9a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103fa0:	39 c3                	cmp    %eax,%ebx
80103fa2:	75 ec                	jne    80103f90 <mycpu+0x30>
80103fa4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103faa:	05 00 28 12 80       	add    $0x80122800,%eax
}
80103faf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fb2:	5b                   	pop    %ebx
80103fb3:	5e                   	pop    %esi
80103fb4:	5d                   	pop    %ebp
80103fb5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103fb6:	b8 00 28 12 80       	mov    $0x80122800,%eax
      return &cpus[i];
80103fbb:	eb f2                	jmp    80103faf <mycpu+0x4f>
  cprintf("The unknown apicid is %d\n", apicid);
80103fbd:	83 ec 08             	sub    $0x8,%esp
80103fc0:	50                   	push   %eax
80103fc1:	68 bc 8b 10 80       	push   $0x80108bbc
80103fc6:	e8 95 c6 ff ff       	call   80100660 <cprintf>
  panic("unknown apicid\n");
80103fcb:	c7 04 24 d6 8b 10 80 	movl   $0x80108bd6,(%esp)
80103fd2:	e8 b9 c3 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103fd7:	83 ec 0c             	sub    $0xc,%esp
80103fda:	68 c4 8c 10 80       	push   $0x80108cc4
80103fdf:	e8 ac c3 ff ff       	call   80100390 <panic>
80103fe4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103fea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ff0 <cpuid>:
cpuid() {
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ff6:	e8 65 ff ff ff       	call   80103f60 <mycpu>
80103ffb:	2d 00 28 12 80       	sub    $0x80122800,%eax
}
80104000:	c9                   	leave  
  return mycpu()-cpus;
80104001:	c1 f8 04             	sar    $0x4,%eax
80104004:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010400a:	c3                   	ret    
8010400b:	90                   	nop
8010400c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104010 <myproc>:
myproc(void) {
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	53                   	push   %ebx
80104014:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104017:	e8 04 0d 00 00       	call   80104d20 <pushcli>
  c = mycpu();
8010401c:	e8 3f ff ff ff       	call   80103f60 <mycpu>
  p = c->proc;
80104021:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104027:	e8 34 0d 00 00       	call   80104d60 <popcli>
}
8010402c:	83 c4 04             	add    $0x4,%esp
8010402f:	89 d8                	mov    %ebx,%eax
80104031:	5b                   	pop    %ebx
80104032:	5d                   	pop    %ebp
80104033:	c3                   	ret    
80104034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010403a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104040 <userinit>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104047:	e8 64 fd ff ff       	call   80103db0 <allocproc>
8010404c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010404e:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
  if((p->pgdir = setupkvm()) == 0)
80104053:	e8 78 3b 00 00       	call   80107bd0 <setupkvm>
80104058:	85 c0                	test   %eax,%eax
8010405a:	89 43 04             	mov    %eax,0x4(%ebx)
8010405d:	0f 84 bd 00 00 00    	je     80104120 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104063:	83 ec 04             	sub    $0x4,%esp
80104066:	68 2c 00 00 00       	push   $0x2c
8010406b:	68 60 c4 10 80       	push   $0x8010c460
80104070:	50                   	push   %eax
80104071:	e8 ea 37 00 00       	call   80107860 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104076:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104079:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010407f:	6a 4c                	push   $0x4c
80104081:	6a 00                	push   $0x0
80104083:	ff 73 18             	pushl  0x18(%ebx)
80104086:	e8 75 0e 00 00       	call   80104f00 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010408b:	8b 43 18             	mov    0x18(%ebx),%eax
8010408e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104093:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104098:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010409b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010409f:	8b 43 18             	mov    0x18(%ebx),%eax
801040a2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801040a6:	8b 43 18             	mov    0x18(%ebx),%eax
801040a9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801040ad:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801040b1:	8b 43 18             	mov    0x18(%ebx),%eax
801040b4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801040b8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801040bc:	8b 43 18             	mov    0x18(%ebx),%eax
801040bf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801040c6:	8b 43 18             	mov    0x18(%ebx),%eax
801040c9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801040d0:	8b 43 18             	mov    0x18(%ebx),%eax
801040d3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801040da:	8d 43 6c             	lea    0x6c(%ebx),%eax
801040dd:	6a 10                	push   $0x10
801040df:	68 ff 8b 10 80       	push   $0x80108bff
801040e4:	50                   	push   %eax
801040e5:	e8 f6 0f 00 00       	call   801050e0 <safestrcpy>
  p->cwd = namei("/");
801040ea:	c7 04 24 08 8c 10 80 	movl   $0x80108c08,(%esp)
801040f1:	e8 8a e1 ff ff       	call   80102280 <namei>
801040f6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801040f9:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
80104100:	e8 eb 0c 00 00       	call   80104df0 <acquire>
  p->state = RUNNABLE;
80104105:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010410c:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
80104113:	e8 98 0d 00 00       	call   80104eb0 <release>
}
80104118:	83 c4 10             	add    $0x10,%esp
8010411b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010411e:	c9                   	leave  
8010411f:	c3                   	ret    
    panic("userinit: out of memory?");
80104120:	83 ec 0c             	sub    $0xc,%esp
80104123:	68 e6 8b 10 80       	push   $0x80108be6
80104128:	e8 63 c2 ff ff       	call   80100390 <panic>
8010412d:	8d 76 00             	lea    0x0(%esi),%esi

80104130 <growproc>:
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	56                   	push   %esi
80104134:	53                   	push   %ebx
80104135:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104138:	e8 e3 0b 00 00       	call   80104d20 <pushcli>
  c = mycpu();
8010413d:	e8 1e fe ff ff       	call   80103f60 <mycpu>
  p = c->proc;
80104142:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104148:	e8 13 0c 00 00       	call   80104d60 <popcli>
  if(n > 0){
8010414d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80104150:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104152:	7f 1c                	jg     80104170 <growproc+0x40>
  } else if(n < 0){
80104154:	75 3a                	jne    80104190 <growproc+0x60>
  switchuvm(curproc);
80104156:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104159:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010415b:	53                   	push   %ebx
8010415c:	e8 ef 35 00 00       	call   80107750 <switchuvm>
  return 0;
80104161:	83 c4 10             	add    $0x10,%esp
80104164:	31 c0                	xor    %eax,%eax
}
80104166:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104169:	5b                   	pop    %ebx
8010416a:	5e                   	pop    %esi
8010416b:	5d                   	pop    %ebp
8010416c:	c3                   	ret    
8010416d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104170:	83 ec 04             	sub    $0x4,%esp
80104173:	01 c6                	add    %eax,%esi
80104175:	56                   	push   %esi
80104176:	50                   	push   %eax
80104177:	ff 73 04             	pushl  0x4(%ebx)
8010417a:	e8 81 3f 00 00       	call   80108100 <allocuvm>
8010417f:	83 c4 10             	add    $0x10,%esp
80104182:	85 c0                	test   %eax,%eax
80104184:	75 d0                	jne    80104156 <growproc+0x26>
      return -1;
80104186:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010418b:	eb d9                	jmp    80104166 <growproc+0x36>
8010418d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104190:	83 ec 04             	sub    $0x4,%esp
80104193:	01 c6                	add    %eax,%esi
80104195:	56                   	push   %esi
80104196:	50                   	push   %eax
80104197:	ff 73 04             	pushl  0x4(%ebx)
8010419a:	e8 01 38 00 00       	call   801079a0 <deallocuvm>
8010419f:	83 c4 10             	add    $0x10,%esp
801041a2:	85 c0                	test   %eax,%eax
801041a4:	75 b0                	jne    80104156 <growproc+0x26>
801041a6:	eb de                	jmp    80104186 <growproc+0x56>
801041a8:	90                   	nop
801041a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041b0 <sys_get_number_of_free_pages_impl>:
int sys_get_number_of_free_pages_impl(void){
801041b0:	55                   	push   %ebp
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
801041b1:	31 c0                	xor    %eax,%eax
  int count = 0;
801041b3:	31 d2                	xor    %edx,%edx
int sys_get_number_of_free_pages_impl(void){
801041b5:	89 e5                	mov    %esp,%ebp
801041b7:	89 f6                	mov    %esi,%esi
801041b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      count++;
801041c0:	80 b8 40 1f 11 80 01 	cmpb   $0x1,-0x7feee0c0(%eax)
801041c7:	83 da ff             	sbb    $0xffffffff,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
801041ca:	83 c0 01             	add    $0x1,%eax
801041cd:	3d 00 e0 00 00       	cmp    $0xe000,%eax
801041d2:	75 ec                	jne    801041c0 <sys_get_number_of_free_pages_impl+0x10>
  return (PHYSTOP/PGSIZE) - count;
801041d4:	29 d0                	sub    %edx,%eax
}
801041d6:	5d                   	pop    %ebp
801041d7:	c3                   	ret    
801041d8:	90                   	nop
801041d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041e0 <fork>:
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	53                   	push   %ebx
801041e6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801041e9:	e8 32 0b 00 00       	call   80104d20 <pushcli>
  c = mycpu();
801041ee:	e8 6d fd ff ff       	call   80103f60 <mycpu>
  p = c->proc;
801041f3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041f9:	e8 62 0b 00 00       	call   80104d60 <popcli>
  if((np = allocproc()) == 0){
801041fe:	e8 ad fb ff ff       	call   80103db0 <allocproc>
80104203:	85 c0                	test   %eax,%eax
80104205:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104208:	0f 84 31 02 00 00    	je     8010443f <fork+0x25f>
  if((np->pgdir = cow_copyuvm(curproc->pgdir, curproc->sz)) == 0){ // (np->pid > 2 ? cow_copyuvm : copyuvm)
8010420e:	83 ec 08             	sub    $0x8,%esp
80104211:	ff 33                	pushl  (%ebx)
80104213:	ff 73 04             	pushl  0x4(%ebx)
80104216:	e8 85 3a 00 00       	call   80107ca0 <cow_copyuvm>
8010421b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010421e:	83 c4 10             	add    $0x10,%esp
80104221:	85 c0                	test   %eax,%eax
80104223:	89 42 04             	mov    %eax,0x4(%edx)
80104226:	0f 84 1f 02 00 00    	je     8010444b <fork+0x26b>
  np->sz = curproc->sz;
8010422c:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
8010422e:	8b 7a 18             	mov    0x18(%edx),%edi
80104231:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
80104236:	89 5a 14             	mov    %ebx,0x14(%edx)
  np->sz = curproc->sz;
80104239:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
8010423b:	8b 73 18             	mov    0x18(%ebx),%esi
8010423e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104240:	31 f6                	xor    %esi,%esi
80104242:	89 d7                	mov    %edx,%edi
  np->tf->eax = 0;
80104244:	8b 42 18             	mov    0x18(%edx),%eax
80104247:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
8010424e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80104250:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104254:	85 c0                	test   %eax,%eax
80104256:	74 10                	je     80104268 <fork+0x88>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	50                   	push   %eax
8010425c:	e8 2f cf ff ff       	call   80101190 <filedup>
80104261:	83 c4 10             	add    $0x10,%esp
80104264:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104268:	83 c6 01             	add    $0x1,%esi
8010426b:	83 fe 10             	cmp    $0x10,%esi
8010426e:	75 e0                	jne    80104250 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104270:	83 ec 0c             	sub    $0xc,%esp
80104273:	ff 73 68             	pushl  0x68(%ebx)
80104276:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80104279:	e8 72 d7 ff ff       	call   801019f0 <idup>
8010427e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104281:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104284:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104287:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010428a:	6a 10                	push   $0x10
8010428c:	50                   	push   %eax
8010428d:	8d 42 6c             	lea    0x6c(%edx),%eax
80104290:	50                   	push   %eax
80104291:	e8 4a 0e 00 00       	call   801050e0 <safestrcpy>
  pid = np->pid;
80104296:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  if (curproc->pid > 2 && np->pid > 2){
80104299:	83 c4 10             	add    $0x10,%esp
8010429c:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  pid = np->pid;
801042a0:	8b 42 10             	mov    0x10(%edx),%eax
801042a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (curproc->pid > 2 && np->pid > 2){
801042a6:	7e 05                	jle    801042ad <fork+0xcd>
801042a8:	83 f8 02             	cmp    $0x2,%eax
801042ab:	7f 3b                	jg     801042e8 <fork+0x108>
  acquire(&ptable.lock);
801042ad:	83 ec 0c             	sub    $0xc,%esp
801042b0:	89 55 e0             	mov    %edx,-0x20(%ebp)
801042b3:	68 a0 2d 12 80       	push   $0x80122da0
801042b8:	e8 33 0b 00 00       	call   80104df0 <acquire>
  np->state = RUNNABLE;
801042bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
801042c0:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
801042c7:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
801042ce:	e8 dd 0b 00 00       	call   80104eb0 <release>
  return pid;
801042d3:	83 c4 10             	add    $0x10,%esp
}
801042d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801042d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042dc:	5b                   	pop    %ebx
801042dd:	5e                   	pop    %esi
801042de:	5f                   	pop    %edi
801042df:	5d                   	pop    %ebp
801042e0:	c3                   	ret    
801042e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042e8:	8d 83 e8 01 00 00    	lea    0x1e8(%ebx),%eax
    int last_not_free_in_file = MAX_PYSC_PAGES - 1;
801042ee:	b9 0f 00 00 00       	mov    $0xf,%ecx
801042f3:	eb 12                	jmp    80104307 <fork+0x127>
801042f5:	8d 76 00             	lea    0x0(%esi),%esi
    while (last_not_free_in_file >= 0 && curproc->swapped_out_pages[last_not_free_in_file].is_free){ last_not_free_in_file--; }
801042f8:	83 e9 01             	sub    $0x1,%ecx
801042fb:	83 e8 18             	sub    $0x18,%eax
801042fe:	83 f9 ff             	cmp    $0xffffffff,%ecx
80104301:	0f 84 26 01 00 00    	je     8010442d <fork+0x24d>
80104307:	8b 30                	mov    (%eax),%esi
80104309:	85 f6                	test   %esi,%esi
8010430b:	75 eb                	jne    801042f8 <fork+0x118>
8010430d:	89 55 d8             	mov    %edx,-0x28(%ebp)
80104310:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    void* pg_buffer = cow_kalloc();
80104313:	e8 18 2f 00 00       	call   80107230 <cow_kalloc>
80104318:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010431b:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010431e:	89 c7                	mov    %eax,%edi
80104320:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80104323:	89 f3                	mov    %esi,%ebx
80104325:	c1 e1 0c             	shl    $0xc,%ecx
80104328:	89 d6                	mov    %edx,%esi
8010432a:	8d 81 00 10 00 00    	lea    0x1000(%ecx),%eax
80104330:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104333:	90                   	nop
80104334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      readFromSwapFile(curproc, pg_buffer, i, PGSIZE);
80104338:	68 00 10 00 00       	push   $0x1000
8010433d:	53                   	push   %ebx
8010433e:	57                   	push   %edi
8010433f:	ff 75 e0             	pushl  -0x20(%ebp)
80104342:	e8 d9 e2 ff ff       	call   80102620 <readFromSwapFile>
      writeToSwapFile(np, pg_buffer, i, PGSIZE);
80104347:	68 00 10 00 00       	push   $0x1000
8010434c:	53                   	push   %ebx
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
8010434d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      writeToSwapFile(np, pg_buffer, i, PGSIZE);
80104353:	57                   	push   %edi
80104354:	56                   	push   %esi
80104355:	e8 96 e2 ff ff       	call   801025f0 <writeToSwapFile>
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
8010435a:	83 c4 20             	add    $0x20,%esp
8010435d:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80104360:	75 d6                	jne    80104338 <fork+0x158>
80104362:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80104365:	89 f2                	mov    %esi,%edx
    cow_kfree(pg_buffer);
80104367:	83 ec 0c             	sub    $0xc,%esp
8010436a:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010436d:	57                   	push   %edi
8010436e:	e8 2d 2e 00 00       	call   801071a0 <cow_kfree>
80104373:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104376:	83 c4 10             	add    $0x10,%esp
80104379:	b8 80 00 00 00       	mov    $0x80,%eax
8010437e:	66 90                	xchg   %ax,%ax
      np->ram_pages[i] = curproc->ram_pages[i];
80104380:	8b 8c 03 80 01 00 00 	mov    0x180(%ebx,%eax,1),%ecx
80104387:	89 8c 02 80 01 00 00 	mov    %ecx,0x180(%edx,%eax,1)
8010438e:	8b 8c 03 84 01 00 00 	mov    0x184(%ebx,%eax,1),%ecx
80104395:	89 8c 02 84 01 00 00 	mov    %ecx,0x184(%edx,%eax,1)
8010439c:	8b 8c 03 88 01 00 00 	mov    0x188(%ebx,%eax,1),%ecx
801043a3:	89 8c 02 88 01 00 00 	mov    %ecx,0x188(%edx,%eax,1)
801043aa:	8b 8c 03 8c 01 00 00 	mov    0x18c(%ebx,%eax,1),%ecx
801043b1:	89 8c 02 8c 01 00 00 	mov    %ecx,0x18c(%edx,%eax,1)
801043b8:	8b 8c 03 90 01 00 00 	mov    0x190(%ebx,%eax,1),%ecx
801043bf:	89 8c 02 90 01 00 00 	mov    %ecx,0x190(%edx,%eax,1)
801043c6:	8b 8c 03 94 01 00 00 	mov    0x194(%ebx,%eax,1),%ecx
801043cd:	89 8c 02 94 01 00 00 	mov    %ecx,0x194(%edx,%eax,1)
      np->swapped_out_pages[i] = curproc->swapped_out_pages[i];
801043d4:	8b 0c 03             	mov    (%ebx,%eax,1),%ecx
801043d7:	89 0c 02             	mov    %ecx,(%edx,%eax,1)
801043da:	8b 4c 03 04          	mov    0x4(%ebx,%eax,1),%ecx
801043de:	89 4c 02 04          	mov    %ecx,0x4(%edx,%eax,1)
801043e2:	8b 4c 03 08          	mov    0x8(%ebx,%eax,1),%ecx
801043e6:	89 4c 02 08          	mov    %ecx,0x8(%edx,%eax,1)
801043ea:	8b 4c 03 0c          	mov    0xc(%ebx,%eax,1),%ecx
801043ee:	89 4c 02 0c          	mov    %ecx,0xc(%edx,%eax,1)
801043f2:	8b 4c 03 10          	mov    0x10(%ebx,%eax,1),%ecx
801043f6:	89 4c 02 10          	mov    %ecx,0x10(%edx,%eax,1)
801043fa:	8b 4c 03 14          	mov    0x14(%ebx,%eax,1),%ecx
801043fe:	89 4c 02 14          	mov    %ecx,0x14(%edx,%eax,1)
80104402:	83 c0 18             	add    $0x18,%eax
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80104405:	3d 00 02 00 00       	cmp    $0x200,%eax
8010440a:	0f 85 70 ff ff ff    	jne    80104380 <fork+0x1a0>
    np->num_of_actual_pages_in_mem = curproc->num_of_actual_pages_in_mem;
80104410:	8b 83 84 03 00 00    	mov    0x384(%ebx),%eax
80104416:	89 82 84 03 00 00    	mov    %eax,0x384(%edx)
    np->num_of_pages_in_swap_file = curproc->num_of_pages_in_swap_file;
8010441c:	8b 83 80 03 00 00    	mov    0x380(%ebx),%eax
80104422:	89 82 80 03 00 00    	mov    %eax,0x380(%edx)
80104428:	e9 80 fe ff ff       	jmp    801042ad <fork+0xcd>
8010442d:	89 55 e0             	mov    %edx,-0x20(%ebp)
    void* pg_buffer = cow_kalloc();
80104430:	e8 fb 2d 00 00       	call   80107230 <cow_kalloc>
80104435:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104438:	89 c7                	mov    %eax,%edi
8010443a:	e9 28 ff ff ff       	jmp    80104367 <fork+0x187>
    return -1;
8010443f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80104446:	e9 8b fe ff ff       	jmp    801042d6 <fork+0xf6>
    cow_kfree(np->kstack);
8010444b:	83 ec 0c             	sub    $0xc,%esp
8010444e:	ff 72 08             	pushl  0x8(%edx)
80104451:	e8 4a 2d 00 00       	call   801071a0 <cow_kfree>
    np->kstack = 0;
80104456:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
80104459:	83 c4 10             	add    $0x10,%esp
8010445c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
    np->kstack = 0;
80104463:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
8010446a:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80104471:	e9 60 fe ff ff       	jmp    801042d6 <fork+0xf6>
80104476:	8d 76 00             	lea    0x0(%esi),%esi
80104479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104480 <scheduler>:
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	57                   	push   %edi
80104484:	56                   	push   %esi
80104485:	53                   	push   %ebx
80104486:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104489:	e8 d2 fa ff ff       	call   80103f60 <mycpu>
8010448e:	8d 78 04             	lea    0x4(%eax),%edi
80104491:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104493:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010449a:	00 00 00 
8010449d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801044a0:	fb                   	sti    
    acquire(&ptable.lock);
801044a1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044a4:	bb d4 2d 12 80       	mov    $0x80122dd4,%ebx
    acquire(&ptable.lock);
801044a9:	68 a0 2d 12 80       	push   $0x80122da0
801044ae:	e8 3d 09 00 00       	call   80104df0 <acquire>
801044b3:	83 c4 10             	add    $0x10,%esp
801044b6:	8d 76 00             	lea    0x0(%esi),%esi
801044b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
801044c0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801044c4:	75 33                	jne    801044f9 <scheduler+0x79>
      switchuvm(p);
801044c6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801044c9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801044cf:	53                   	push   %ebx
801044d0:	e8 7b 32 00 00       	call   80107750 <switchuvm>
      swtch(&(c->scheduler), p->context);
801044d5:	58                   	pop    %eax
801044d6:	5a                   	pop    %edx
801044d7:	ff 73 1c             	pushl  0x1c(%ebx)
801044da:	57                   	push   %edi
      p->state = RUNNING;
801044db:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801044e2:	e8 54 0c 00 00       	call   8010513b <swtch>
      switchkvm();
801044e7:	e8 44 32 00 00       	call   80107730 <switchkvm>
      c->proc = 0;
801044ec:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801044f3:	00 00 00 
801044f6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044f9:	81 c3 90 03 00 00    	add    $0x390,%ebx
801044ff:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
80104505:	72 b9                	jb     801044c0 <scheduler+0x40>
    release(&ptable.lock);
80104507:	83 ec 0c             	sub    $0xc,%esp
8010450a:	68 a0 2d 12 80       	push   $0x80122da0
8010450f:	e8 9c 09 00 00       	call   80104eb0 <release>
    sti();
80104514:	83 c4 10             	add    $0x10,%esp
80104517:	eb 87                	jmp    801044a0 <scheduler+0x20>
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104520 <sched>:
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	56                   	push   %esi
80104524:	53                   	push   %ebx
  pushcli();
80104525:	e8 f6 07 00 00       	call   80104d20 <pushcli>
  c = mycpu();
8010452a:	e8 31 fa ff ff       	call   80103f60 <mycpu>
  p = c->proc;
8010452f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104535:	e8 26 08 00 00       	call   80104d60 <popcli>
  if(!holding(&ptable.lock))
8010453a:	83 ec 0c             	sub    $0xc,%esp
8010453d:	68 a0 2d 12 80       	push   $0x80122da0
80104542:	e8 79 08 00 00       	call   80104dc0 <holding>
80104547:	83 c4 10             	add    $0x10,%esp
8010454a:	85 c0                	test   %eax,%eax
8010454c:	74 4f                	je     8010459d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010454e:	e8 0d fa ff ff       	call   80103f60 <mycpu>
80104553:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010455a:	75 68                	jne    801045c4 <sched+0xa4>
  if(p->state == RUNNING)
8010455c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104560:	74 55                	je     801045b7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104562:	9c                   	pushf  
80104563:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104564:	f6 c4 02             	test   $0x2,%ah
80104567:	75 41                	jne    801045aa <sched+0x8a>
  intena = mycpu()->intena;
80104569:	e8 f2 f9 ff ff       	call   80103f60 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010456e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104571:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104577:	e8 e4 f9 ff ff       	call   80103f60 <mycpu>
8010457c:	83 ec 08             	sub    $0x8,%esp
8010457f:	ff 70 04             	pushl  0x4(%eax)
80104582:	53                   	push   %ebx
80104583:	e8 b3 0b 00 00       	call   8010513b <swtch>
  mycpu()->intena = intena;
80104588:	e8 d3 f9 ff ff       	call   80103f60 <mycpu>
}
8010458d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104590:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104596:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104599:	5b                   	pop    %ebx
8010459a:	5e                   	pop    %esi
8010459b:	5d                   	pop    %ebp
8010459c:	c3                   	ret    
    panic("sched ptable.lock");
8010459d:	83 ec 0c             	sub    $0xc,%esp
801045a0:	68 0a 8c 10 80       	push   $0x80108c0a
801045a5:	e8 e6 bd ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801045aa:	83 ec 0c             	sub    $0xc,%esp
801045ad:	68 36 8c 10 80       	push   $0x80108c36
801045b2:	e8 d9 bd ff ff       	call   80100390 <panic>
    panic("sched running");
801045b7:	83 ec 0c             	sub    $0xc,%esp
801045ba:	68 28 8c 10 80       	push   $0x80108c28
801045bf:	e8 cc bd ff ff       	call   80100390 <panic>
    panic("sched locks");
801045c4:	83 ec 0c             	sub    $0xc,%esp
801045c7:	68 1c 8c 10 80       	push   $0x80108c1c
801045cc:	e8 bf bd ff ff       	call   80100390 <panic>
801045d1:	eb 0d                	jmp    801045e0 <exit>
801045d3:	90                   	nop
801045d4:	90                   	nop
801045d5:	90                   	nop
801045d6:	90                   	nop
801045d7:	90                   	nop
801045d8:	90                   	nop
801045d9:	90                   	nop
801045da:	90                   	nop
801045db:	90                   	nop
801045dc:	90                   	nop
801045dd:	90                   	nop
801045de:	90                   	nop
801045df:	90                   	nop

801045e0 <exit>:
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	57                   	push   %edi
801045e4:	56                   	push   %esi
801045e5:	53                   	push   %ebx
801045e6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801045e9:	e8 32 07 00 00       	call   80104d20 <pushcli>
  c = mycpu();
801045ee:	e8 6d f9 ff ff       	call   80103f60 <mycpu>
  p = c->proc;
801045f3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045f9:	e8 62 07 00 00       	call   80104d60 <popcli>
  if(curproc == initproc)
801045fe:	39 1d b8 c5 10 80    	cmp    %ebx,0x8010c5b8
80104604:	8d 73 28             	lea    0x28(%ebx),%esi
80104607:	8d 7b 68             	lea    0x68(%ebx),%edi
8010460a:	0f 84 01 01 00 00    	je     80104711 <exit+0x131>
    if(curproc->ofile[fd]){
80104610:	8b 06                	mov    (%esi),%eax
80104612:	85 c0                	test   %eax,%eax
80104614:	74 12                	je     80104628 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104616:	83 ec 0c             	sub    $0xc,%esp
80104619:	50                   	push   %eax
8010461a:	e8 c1 cb ff ff       	call   801011e0 <fileclose>
      curproc->ofile[fd] = 0;
8010461f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104625:	83 c4 10             	add    $0x10,%esp
80104628:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010462b:	39 fe                	cmp    %edi,%esi
8010462d:	75 e1                	jne    80104610 <exit+0x30>
  begin_op();
8010462f:	e8 1c ed ff ff       	call   80103350 <begin_op>
  iput(curproc->cwd);
80104634:	83 ec 0c             	sub    $0xc,%esp
80104637:	ff 73 68             	pushl  0x68(%ebx)
8010463a:	e8 11 d5 ff ff       	call   80101b50 <iput>
  end_op();
8010463f:	e8 7c ed ff ff       	call   801033c0 <end_op>
  curproc->cwd = 0;
80104644:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  removeSwapFile(curproc);
8010464b:	89 1c 24             	mov    %ebx,(%esp)
8010464e:	e8 fd dc ff ff       	call   80102350 <removeSwapFile>
  acquire(&ptable.lock);
80104653:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
8010465a:	e8 91 07 00 00       	call   80104df0 <acquire>
  wakeup1(curproc->parent);
8010465f:	8b 53 14             	mov    0x14(%ebx),%edx
80104662:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104665:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
8010466a:	eb 10                	jmp    8010467c <exit+0x9c>
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104670:	05 90 03 00 00       	add    $0x390,%eax
80104675:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
8010467a:	73 1e                	jae    8010469a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
8010467c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104680:	75 ee                	jne    80104670 <exit+0x90>
80104682:	3b 50 20             	cmp    0x20(%eax),%edx
80104685:	75 e9                	jne    80104670 <exit+0x90>
      p->state = RUNNABLE;
80104687:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010468e:	05 90 03 00 00       	add    $0x390,%eax
80104693:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
80104698:	72 e2                	jb     8010467c <exit+0x9c>
      p->parent = initproc;
8010469a:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046a0:	ba d4 2d 12 80       	mov    $0x80122dd4,%edx
801046a5:	eb 17                	jmp    801046be <exit+0xde>
801046a7:	89 f6                	mov    %esi,%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801046b0:	81 c2 90 03 00 00    	add    $0x390,%edx
801046b6:	81 fa d4 11 13 80    	cmp    $0x801311d4,%edx
801046bc:	73 3a                	jae    801046f8 <exit+0x118>
    if(p->parent == curproc){
801046be:	39 5a 14             	cmp    %ebx,0x14(%edx)
801046c1:	75 ed                	jne    801046b0 <exit+0xd0>
      if(p->state == ZOMBIE)
801046c3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801046c7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801046ca:	75 e4                	jne    801046b0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046cc:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
801046d1:	eb 11                	jmp    801046e4 <exit+0x104>
801046d3:	90                   	nop
801046d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046d8:	05 90 03 00 00       	add    $0x390,%eax
801046dd:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
801046e2:	73 cc                	jae    801046b0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
801046e4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046e8:	75 ee                	jne    801046d8 <exit+0xf8>
801046ea:	3b 48 20             	cmp    0x20(%eax),%ecx
801046ed:	75 e9                	jne    801046d8 <exit+0xf8>
      p->state = RUNNABLE;
801046ef:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801046f6:	eb e0                	jmp    801046d8 <exit+0xf8>
  curproc->state = ZOMBIE;
801046f8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801046ff:	e8 1c fe ff ff       	call   80104520 <sched>
  panic("zombie exit");
80104704:	83 ec 0c             	sub    $0xc,%esp
80104707:	68 57 8c 10 80       	push   $0x80108c57
8010470c:	e8 7f bc ff ff       	call   80100390 <panic>
    panic("init exiting");
80104711:	83 ec 0c             	sub    $0xc,%esp
80104714:	68 4a 8c 10 80       	push   $0x80108c4a
80104719:	e8 72 bc ff ff       	call   80100390 <panic>
8010471e:	66 90                	xchg   %ax,%ax

80104720 <yield>:
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104727:	68 a0 2d 12 80       	push   $0x80122da0
8010472c:	e8 bf 06 00 00       	call   80104df0 <acquire>
  pushcli();
80104731:	e8 ea 05 00 00       	call   80104d20 <pushcli>
  c = mycpu();
80104736:	e8 25 f8 ff ff       	call   80103f60 <mycpu>
  p = c->proc;
8010473b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104741:	e8 1a 06 00 00       	call   80104d60 <popcli>
  myproc()->state = RUNNABLE;
80104746:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010474d:	e8 ce fd ff ff       	call   80104520 <sched>
  release(&ptable.lock);
80104752:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
80104759:	e8 52 07 00 00       	call   80104eb0 <release>
}
8010475e:	83 c4 10             	add    $0x10,%esp
80104761:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104764:	c9                   	leave  
80104765:	c3                   	ret    
80104766:	8d 76 00             	lea    0x0(%esi),%esi
80104769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104770 <sleep>:
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	57                   	push   %edi
80104774:	56                   	push   %esi
80104775:	53                   	push   %ebx
80104776:	83 ec 0c             	sub    $0xc,%esp
80104779:	8b 7d 08             	mov    0x8(%ebp),%edi
8010477c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010477f:	e8 9c 05 00 00       	call   80104d20 <pushcli>
  c = mycpu();
80104784:	e8 d7 f7 ff ff       	call   80103f60 <mycpu>
  p = c->proc;
80104789:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010478f:	e8 cc 05 00 00       	call   80104d60 <popcli>
  if(p == 0)
80104794:	85 db                	test   %ebx,%ebx
80104796:	0f 84 87 00 00 00    	je     80104823 <sleep+0xb3>
  if(lk == 0)
8010479c:	85 f6                	test   %esi,%esi
8010479e:	74 76                	je     80104816 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801047a0:	81 fe a0 2d 12 80    	cmp    $0x80122da0,%esi
801047a6:	74 50                	je     801047f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801047a8:	83 ec 0c             	sub    $0xc,%esp
801047ab:	68 a0 2d 12 80       	push   $0x80122da0
801047b0:	e8 3b 06 00 00       	call   80104df0 <acquire>
    release(lk);
801047b5:	89 34 24             	mov    %esi,(%esp)
801047b8:	e8 f3 06 00 00       	call   80104eb0 <release>
  p->chan = chan;
801047bd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801047c0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801047c7:	e8 54 fd ff ff       	call   80104520 <sched>
  p->chan = 0;
801047cc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801047d3:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
801047da:	e8 d1 06 00 00       	call   80104eb0 <release>
    acquire(lk);
801047df:	89 75 08             	mov    %esi,0x8(%ebp)
801047e2:	83 c4 10             	add    $0x10,%esp
}
801047e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047e8:	5b                   	pop    %ebx
801047e9:	5e                   	pop    %esi
801047ea:	5f                   	pop    %edi
801047eb:	5d                   	pop    %ebp
    acquire(lk);
801047ec:	e9 ff 05 00 00       	jmp    80104df0 <acquire>
801047f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801047f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801047fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104802:	e8 19 fd ff ff       	call   80104520 <sched>
  p->chan = 0;
80104807:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010480e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104811:	5b                   	pop    %ebx
80104812:	5e                   	pop    %esi
80104813:	5f                   	pop    %edi
80104814:	5d                   	pop    %ebp
80104815:	c3                   	ret    
    panic("sleep without lk");
80104816:	83 ec 0c             	sub    $0xc,%esp
80104819:	68 69 8c 10 80       	push   $0x80108c69
8010481e:	e8 6d bb ff ff       	call   80100390 <panic>
    panic("sleep");
80104823:	83 ec 0c             	sub    $0xc,%esp
80104826:	68 63 8c 10 80       	push   $0x80108c63
8010482b:	e8 60 bb ff ff       	call   80100390 <panic>

80104830 <wait>:
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
  pushcli();
80104835:	e8 e6 04 00 00       	call   80104d20 <pushcli>
  c = mycpu();
8010483a:	e8 21 f7 ff ff       	call   80103f60 <mycpu>
  p = c->proc;
8010483f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104845:	e8 16 05 00 00       	call   80104d60 <popcli>
  acquire(&ptable.lock);
8010484a:	83 ec 0c             	sub    $0xc,%esp
8010484d:	68 a0 2d 12 80       	push   $0x80122da0
80104852:	e8 99 05 00 00       	call   80104df0 <acquire>
80104857:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010485a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010485c:	bb d4 2d 12 80       	mov    $0x80122dd4,%ebx
80104861:	eb 13                	jmp    80104876 <wait+0x46>
80104863:	90                   	nop
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104868:	81 c3 90 03 00 00    	add    $0x390,%ebx
8010486e:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
80104874:	73 1e                	jae    80104894 <wait+0x64>
      if(p->parent != curproc)
80104876:	39 73 14             	cmp    %esi,0x14(%ebx)
80104879:	75 ed                	jne    80104868 <wait+0x38>
      if(p->state == ZOMBIE){
8010487b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010487f:	74 3f                	je     801048c0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104881:	81 c3 90 03 00 00    	add    $0x390,%ebx
      havekids = 1;
80104887:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010488c:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
80104892:	72 e2                	jb     80104876 <wait+0x46>
    if(!havekids || curproc->killed){
80104894:	85 c0                	test   %eax,%eax
80104896:	0f 84 01 01 00 00    	je     8010499d <wait+0x16d>
8010489c:	8b 46 24             	mov    0x24(%esi),%eax
8010489f:	85 c0                	test   %eax,%eax
801048a1:	0f 85 f6 00 00 00    	jne    8010499d <wait+0x16d>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801048a7:	83 ec 08             	sub    $0x8,%esp
801048aa:	68 a0 2d 12 80       	push   $0x80122da0
801048af:	56                   	push   %esi
801048b0:	e8 bb fe ff ff       	call   80104770 <sleep>
    havekids = 0;
801048b5:	83 c4 10             	add    $0x10,%esp
801048b8:	eb a0                	jmp    8010485a <wait+0x2a>
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (p->pid > 2){
801048c0:	8b 73 10             	mov    0x10(%ebx),%esi
801048c3:	83 fe 02             	cmp    $0x2,%esi
801048c6:	0f 8e 7e 00 00 00    	jle    8010494a <wait+0x11a>
801048cc:	8d 93 80 00 00 00    	lea    0x80(%ebx),%edx
801048d2:	8d 8b 00 02 00 00    	lea    0x200(%ebx),%ecx
          p->num_of_pagefaults_occurs = 0;
801048d8:	c7 83 88 03 00 00 00 	movl   $0x0,0x388(%ebx)
801048df:	00 00 00 
          p->num_of_actual_pages_in_mem = 0;
801048e2:	c7 83 84 03 00 00 00 	movl   $0x0,0x384(%ebx)
801048e9:	00 00 00 
          p->num_of_pageOut_occured = 0;
801048ec:	c7 83 8c 03 00 00 00 	movl   $0x0,0x38c(%ebx)
801048f3:	00 00 00 
          p->num_of_pages_in_swap_file = 0;
801048f6:	c7 83 80 03 00 00 00 	movl   $0x0,0x380(%ebx)
801048fd:	00 00 00 
            p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80104900:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
80104906:	c7 82 80 01 00 00 01 	movl   $0x1,0x180(%edx)
8010490d:	00 00 00 
80104910:	83 c2 18             	add    $0x18,%edx
            p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
80104913:	c7 42 f0 00 00 00 00 	movl   $0x0,-0x10(%edx)
8010491a:	c7 82 70 01 00 00 00 	movl   $0x0,0x170(%edx)
80104921:	00 00 00 
            p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80104924:	c7 42 ec 00 00 00 00 	movl   $0x0,-0x14(%edx)
8010492b:	c7 82 6c 01 00 00 00 	movl   $0x0,0x16c(%edx)
80104932:	00 00 00 
            p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80104935:	c7 42 f8 00 00 00 00 	movl   $0x0,-0x8(%edx)
8010493c:	c7 82 78 01 00 00 00 	movl   $0x0,0x178(%edx)
80104943:	00 00 00 
          for (int i = 0; i < MAX_PYSC_PAGES; i++){
80104946:	39 d1                	cmp    %edx,%ecx
80104948:	75 b6                	jne    80104900 <wait+0xd0>
        cow_kfree(p->kstack);
8010494a:	83 ec 0c             	sub    $0xc,%esp
8010494d:	ff 73 08             	pushl  0x8(%ebx)
80104950:	e8 4b 28 00 00       	call   801071a0 <cow_kfree>
        freevm(p->pgdir);
80104955:	5a                   	pop    %edx
80104956:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104959:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104960:	e8 5b 31 00 00       	call   80107ac0 <freevm>
        release(&ptable.lock);
80104965:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
        p->pid = 0;
8010496c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104973:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010497a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010497e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104985:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010498c:	e8 1f 05 00 00       	call   80104eb0 <release>
        return pid;
80104991:	83 c4 10             	add    $0x10,%esp
}
80104994:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104997:	89 f0                	mov    %esi,%eax
80104999:	5b                   	pop    %ebx
8010499a:	5e                   	pop    %esi
8010499b:	5d                   	pop    %ebp
8010499c:	c3                   	ret    
      release(&ptable.lock);
8010499d:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801049a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801049a5:	68 a0 2d 12 80       	push   $0x80122da0
801049aa:	e8 01 05 00 00       	call   80104eb0 <release>
      return -1;
801049af:	83 c4 10             	add    $0x10,%esp
801049b2:	eb e0                	jmp    80104994 <wait+0x164>
801049b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801049c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	53                   	push   %ebx
801049c4:	83 ec 10             	sub    $0x10,%esp
801049c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801049ca:	68 a0 2d 12 80       	push   $0x80122da0
801049cf:	e8 1c 04 00 00       	call   80104df0 <acquire>
801049d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049d7:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
801049dc:	eb 0e                	jmp    801049ec <wakeup+0x2c>
801049de:	66 90                	xchg   %ax,%ax
801049e0:	05 90 03 00 00       	add    $0x390,%eax
801049e5:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
801049ea:	73 1e                	jae    80104a0a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801049ec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801049f0:	75 ee                	jne    801049e0 <wakeup+0x20>
801049f2:	3b 58 20             	cmp    0x20(%eax),%ebx
801049f5:	75 e9                	jne    801049e0 <wakeup+0x20>
      p->state = RUNNABLE;
801049f7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049fe:	05 90 03 00 00       	add    $0x390,%eax
80104a03:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
80104a08:	72 e2                	jb     801049ec <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104a0a:	c7 45 08 a0 2d 12 80 	movl   $0x80122da0,0x8(%ebp)
}
80104a11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a14:	c9                   	leave  
  release(&ptable.lock);
80104a15:	e9 96 04 00 00       	jmp    80104eb0 <release>
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a20 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	53                   	push   %ebx
80104a24:	83 ec 10             	sub    $0x10,%esp
80104a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104a2a:	68 a0 2d 12 80       	push   $0x80122da0
80104a2f:	e8 bc 03 00 00       	call   80104df0 <acquire>
80104a34:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a37:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
80104a3c:	eb 0e                	jmp    80104a4c <kill+0x2c>
80104a3e:	66 90                	xchg   %ax,%ax
80104a40:	05 90 03 00 00       	add    $0x390,%eax
80104a45:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
80104a4a:	73 34                	jae    80104a80 <kill+0x60>
    if(p->pid == pid){
80104a4c:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a4f:	75 ef                	jne    80104a40 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104a51:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104a55:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104a5c:	75 07                	jne    80104a65 <kill+0x45>
        p->state = RUNNABLE;
80104a5e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104a65:	83 ec 0c             	sub    $0xc,%esp
80104a68:	68 a0 2d 12 80       	push   $0x80122da0
80104a6d:	e8 3e 04 00 00       	call   80104eb0 <release>
      return 0;
80104a72:	83 c4 10             	add    $0x10,%esp
80104a75:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104a77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a7a:	c9                   	leave  
80104a7b:	c3                   	ret    
80104a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104a80:	83 ec 0c             	sub    $0xc,%esp
80104a83:	68 a0 2d 12 80       	push   $0x80122da0
80104a88:	e8 23 04 00 00       	call   80104eb0 <release>
  return -1;
80104a8d:	83 c4 10             	add    $0x10,%esp
80104a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a98:	c9                   	leave  
80104a99:	c3                   	ret    
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104aa0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	57                   	push   %edi
80104aa4:	56                   	push   %esi
80104aa5:	53                   	push   %ebx
80104aa6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104aa9:	bb d4 2d 12 80       	mov    $0x80122dd4,%ebx
{
80104aae:	83 ec 3c             	sub    $0x3c,%esp
80104ab1:	eb 27                	jmp    80104ada <procdump+0x3a>
80104ab3:	90                   	nop
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104ab8:	83 ec 0c             	sub    $0xc,%esp
80104abb:	68 08 92 10 80       	push   $0x80109208
80104ac0:	e8 9b bb ff ff       	call   80100660 <cprintf>
80104ac5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ac8:	81 c3 90 03 00 00    	add    $0x390,%ebx
80104ace:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
80104ad4:	0f 83 96 00 00 00    	jae    80104b70 <procdump+0xd0>
    if(p->state == UNUSED)
80104ada:	8b 43 0c             	mov    0xc(%ebx),%eax
80104add:	85 c0                	test   %eax,%eax
80104adf:	74 e7                	je     80104ac8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104ae1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104ae4:	ba 7a 8c 10 80       	mov    $0x80108c7a,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104ae9:	77 11                	ja     80104afc <procdump+0x5c>
80104aeb:	8b 14 85 ec 8c 10 80 	mov    -0x7fef7314(,%eax,4),%edx
      state = "???";
80104af2:	b8 7a 8c 10 80       	mov    $0x80108c7a,%eax
80104af7:	85 d2                	test   %edx,%edx
80104af9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s RAM: %d SWAP: %d", p->pid, state, p->name, p->num_of_actual_pages_in_mem, p->num_of_pages_in_swap_file);
80104afc:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104aff:	83 ec 08             	sub    $0x8,%esp
80104b02:	ff b3 80 03 00 00    	pushl  0x380(%ebx)
80104b08:	ff b3 84 03 00 00    	pushl  0x384(%ebx)
80104b0e:	50                   	push   %eax
80104b0f:	52                   	push   %edx
80104b10:	ff 73 10             	pushl  0x10(%ebx)
80104b13:	68 7e 8c 10 80       	push   $0x80108c7e
80104b18:	e8 43 bb ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104b1d:	83 c4 20             	add    $0x20,%esp
80104b20:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104b24:	75 92                	jne    80104ab8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104b26:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b29:	83 ec 08             	sub    $0x8,%esp
80104b2c:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104b2f:	50                   	push   %eax
80104b30:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104b33:	8b 40 0c             	mov    0xc(%eax),%eax
80104b36:	83 c0 08             	add    $0x8,%eax
80104b39:	50                   	push   %eax
80104b3a:	e8 91 01 00 00       	call   80104cd0 <getcallerpcs>
80104b3f:	83 c4 10             	add    $0x10,%esp
80104b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104b48:	8b 17                	mov    (%edi),%edx
80104b4a:	85 d2                	test   %edx,%edx
80104b4c:	0f 84 66 ff ff ff    	je     80104ab8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104b52:	83 ec 08             	sub    $0x8,%esp
80104b55:	83 c7 04             	add    $0x4,%edi
80104b58:	52                   	push   %edx
80104b59:	68 41 86 10 80       	push   $0x80108641
80104b5e:	e8 fd ba ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104b63:	83 c4 10             	add    $0x10,%esp
80104b66:	39 fe                	cmp    %edi,%esi
80104b68:	75 de                	jne    80104b48 <procdump+0xa8>
80104b6a:	e9 49 ff ff ff       	jmp    80104ab8 <procdump+0x18>
80104b6f:	90                   	nop
  }
}
80104b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b73:	5b                   	pop    %ebx
80104b74:	5e                   	pop    %esi
80104b75:	5f                   	pop    %edi
80104b76:	5d                   	pop    %ebp
80104b77:	c3                   	ret    
80104b78:	66 90                	xchg   %ax,%ax
80104b7a:	66 90                	xchg   %ax,%ax
80104b7c:	66 90                	xchg   %ax,%ax
80104b7e:	66 90                	xchg   %ax,%ax

80104b80 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	53                   	push   %ebx
80104b84:	83 ec 0c             	sub    $0xc,%esp
80104b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104b8a:	68 04 8d 10 80       	push   $0x80108d04
80104b8f:	8d 43 04             	lea    0x4(%ebx),%eax
80104b92:	50                   	push   %eax
80104b93:	e8 18 01 00 00       	call   80104cb0 <initlock>
  lk->name = name;
80104b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104b9b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104ba1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104ba4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104bab:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104bae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb1:	c9                   	leave  
80104bb2:	c3                   	ret    
80104bb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
80104bc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104bc8:	83 ec 0c             	sub    $0xc,%esp
80104bcb:	8d 73 04             	lea    0x4(%ebx),%esi
80104bce:	56                   	push   %esi
80104bcf:	e8 1c 02 00 00       	call   80104df0 <acquire>
  while (lk->locked) {
80104bd4:	8b 13                	mov    (%ebx),%edx
80104bd6:	83 c4 10             	add    $0x10,%esp
80104bd9:	85 d2                	test   %edx,%edx
80104bdb:	74 16                	je     80104bf3 <acquiresleep+0x33>
80104bdd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104be0:	83 ec 08             	sub    $0x8,%esp
80104be3:	56                   	push   %esi
80104be4:	53                   	push   %ebx
80104be5:	e8 86 fb ff ff       	call   80104770 <sleep>
  while (lk->locked) {
80104bea:	8b 03                	mov    (%ebx),%eax
80104bec:	83 c4 10             	add    $0x10,%esp
80104bef:	85 c0                	test   %eax,%eax
80104bf1:	75 ed                	jne    80104be0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104bf3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104bf9:	e8 12 f4 ff ff       	call   80104010 <myproc>
80104bfe:	8b 40 10             	mov    0x10(%eax),%eax
80104c01:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104c04:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c07:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c0a:	5b                   	pop    %ebx
80104c0b:	5e                   	pop    %esi
80104c0c:	5d                   	pop    %ebp
  release(&lk->lk);
80104c0d:	e9 9e 02 00 00       	jmp    80104eb0 <release>
80104c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c20 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
80104c25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c28:	83 ec 0c             	sub    $0xc,%esp
80104c2b:	8d 73 04             	lea    0x4(%ebx),%esi
80104c2e:	56                   	push   %esi
80104c2f:	e8 bc 01 00 00       	call   80104df0 <acquire>
  lk->locked = 0;
80104c34:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104c3a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104c41:	89 1c 24             	mov    %ebx,(%esp)
80104c44:	e8 77 fd ff ff       	call   801049c0 <wakeup>
  release(&lk->lk);
80104c49:	89 75 08             	mov    %esi,0x8(%ebp)
80104c4c:	83 c4 10             	add    $0x10,%esp
}
80104c4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c52:	5b                   	pop    %ebx
80104c53:	5e                   	pop    %esi
80104c54:	5d                   	pop    %ebp
  release(&lk->lk);
80104c55:	e9 56 02 00 00       	jmp    80104eb0 <release>
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c60 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	57                   	push   %edi
80104c64:	56                   	push   %esi
80104c65:	53                   	push   %ebx
80104c66:	31 ff                	xor    %edi,%edi
80104c68:	83 ec 18             	sub    $0x18,%esp
80104c6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104c6e:	8d 73 04             	lea    0x4(%ebx),%esi
80104c71:	56                   	push   %esi
80104c72:	e8 79 01 00 00       	call   80104df0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104c77:	8b 03                	mov    (%ebx),%eax
80104c79:	83 c4 10             	add    $0x10,%esp
80104c7c:	85 c0                	test   %eax,%eax
80104c7e:	74 13                	je     80104c93 <holdingsleep+0x33>
80104c80:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104c83:	e8 88 f3 ff ff       	call   80104010 <myproc>
80104c88:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c8b:	0f 94 c0             	sete   %al
80104c8e:	0f b6 c0             	movzbl %al,%eax
80104c91:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104c93:	83 ec 0c             	sub    $0xc,%esp
80104c96:	56                   	push   %esi
80104c97:	e8 14 02 00 00       	call   80104eb0 <release>
  return r;
}
80104c9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c9f:	89 f8                	mov    %edi,%eax
80104ca1:	5b                   	pop    %ebx
80104ca2:	5e                   	pop    %esi
80104ca3:	5f                   	pop    %edi
80104ca4:	5d                   	pop    %ebp
80104ca5:	c3                   	ret    
80104ca6:	66 90                	xchg   %ax,%ax
80104ca8:	66 90                	xchg   %ax,%ax
80104caa:	66 90                	xchg   %ax,%ax
80104cac:	66 90                	xchg   %ax,%ax
80104cae:	66 90                	xchg   %ax,%ax

80104cb0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104cb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104cb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104cbf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104cc2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104cc9:	5d                   	pop    %ebp
80104cca:	c3                   	ret    
80104ccb:	90                   	nop
80104ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cd0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104cd0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104cd1:	31 d2                	xor    %edx,%edx
{
80104cd3:	89 e5                	mov    %esp,%ebp
80104cd5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104cd6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104cd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104cdc:	83 e8 08             	sub    $0x8,%eax
80104cdf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ce0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104ce6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cec:	77 1a                	ja     80104d08 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104cee:	8b 58 04             	mov    0x4(%eax),%ebx
80104cf1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104cf4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104cf7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104cf9:	83 fa 0a             	cmp    $0xa,%edx
80104cfc:	75 e2                	jne    80104ce0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104cfe:	5b                   	pop    %ebx
80104cff:	5d                   	pop    %ebp
80104d00:	c3                   	ret    
80104d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d08:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104d0b:	83 c1 28             	add    $0x28,%ecx
80104d0e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104d10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104d16:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104d19:	39 c1                	cmp    %eax,%ecx
80104d1b:	75 f3                	jne    80104d10 <getcallerpcs+0x40>
}
80104d1d:	5b                   	pop    %ebx
80104d1e:	5d                   	pop    %ebp
80104d1f:	c3                   	ret    

80104d20 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	53                   	push   %ebx
80104d24:	83 ec 04             	sub    $0x4,%esp
80104d27:	9c                   	pushf  
80104d28:	5b                   	pop    %ebx
  asm volatile("cli");
80104d29:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104d2a:	e8 31 f2 ff ff       	call   80103f60 <mycpu>
80104d2f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d35:	85 c0                	test   %eax,%eax
80104d37:	75 11                	jne    80104d4a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104d39:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d3f:	e8 1c f2 ff ff       	call   80103f60 <mycpu>
80104d44:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104d4a:	e8 11 f2 ff ff       	call   80103f60 <mycpu>
80104d4f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104d56:	83 c4 04             	add    $0x4,%esp
80104d59:	5b                   	pop    %ebx
80104d5a:	5d                   	pop    %ebp
80104d5b:	c3                   	ret    
80104d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d60 <popcli>:

void
popcli(void)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d66:	9c                   	pushf  
80104d67:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104d68:	f6 c4 02             	test   $0x2,%ah
80104d6b:	75 35                	jne    80104da2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104d6d:	e8 ee f1 ff ff       	call   80103f60 <mycpu>
80104d72:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104d79:	78 34                	js     80104daf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d7b:	e8 e0 f1 ff ff       	call   80103f60 <mycpu>
80104d80:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d86:	85 d2                	test   %edx,%edx
80104d88:	74 06                	je     80104d90 <popcli+0x30>
    sti();
}
80104d8a:	c9                   	leave  
80104d8b:	c3                   	ret    
80104d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d90:	e8 cb f1 ff ff       	call   80103f60 <mycpu>
80104d95:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d9b:	85 c0                	test   %eax,%eax
80104d9d:	74 eb                	je     80104d8a <popcli+0x2a>
  asm volatile("sti");
80104d9f:	fb                   	sti    
}
80104da0:	c9                   	leave  
80104da1:	c3                   	ret    
    panic("popcli - interruptible");
80104da2:	83 ec 0c             	sub    $0xc,%esp
80104da5:	68 0f 8d 10 80       	push   $0x80108d0f
80104daa:	e8 e1 b5 ff ff       	call   80100390 <panic>
    panic("popcli");
80104daf:	83 ec 0c             	sub    $0xc,%esp
80104db2:	68 26 8d 10 80       	push   $0x80108d26
80104db7:	e8 d4 b5 ff ff       	call   80100390 <panic>
80104dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104dc0 <holding>:
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	56                   	push   %esi
80104dc4:	53                   	push   %ebx
80104dc5:	8b 75 08             	mov    0x8(%ebp),%esi
80104dc8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104dca:	e8 51 ff ff ff       	call   80104d20 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104dcf:	8b 06                	mov    (%esi),%eax
80104dd1:	85 c0                	test   %eax,%eax
80104dd3:	74 10                	je     80104de5 <holding+0x25>
80104dd5:	8b 5e 08             	mov    0x8(%esi),%ebx
80104dd8:	e8 83 f1 ff ff       	call   80103f60 <mycpu>
80104ddd:	39 c3                	cmp    %eax,%ebx
80104ddf:	0f 94 c3             	sete   %bl
80104de2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104de5:	e8 76 ff ff ff       	call   80104d60 <popcli>
}
80104dea:	89 d8                	mov    %ebx,%eax
80104dec:	5b                   	pop    %ebx
80104ded:	5e                   	pop    %esi
80104dee:	5d                   	pop    %ebp
80104def:	c3                   	ret    

80104df0 <acquire>:
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	56                   	push   %esi
80104df4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104df5:	e8 26 ff ff ff       	call   80104d20 <pushcli>
  if(holding(lk))
80104dfa:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104dfd:	83 ec 0c             	sub    $0xc,%esp
80104e00:	53                   	push   %ebx
80104e01:	e8 ba ff ff ff       	call   80104dc0 <holding>
80104e06:	83 c4 10             	add    $0x10,%esp
80104e09:	85 c0                	test   %eax,%eax
80104e0b:	0f 85 83 00 00 00    	jne    80104e94 <acquire+0xa4>
80104e11:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104e13:	ba 01 00 00 00       	mov    $0x1,%edx
80104e18:	eb 09                	jmp    80104e23 <acquire+0x33>
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e20:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e23:	89 d0                	mov    %edx,%eax
80104e25:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104e28:	85 c0                	test   %eax,%eax
80104e2a:	75 f4                	jne    80104e20 <acquire+0x30>
  __sync_synchronize();
80104e2c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e34:	e8 27 f1 ff ff       	call   80103f60 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104e39:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104e3c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104e3f:	89 e8                	mov    %ebp,%eax
80104e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e48:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104e4e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104e54:	77 1a                	ja     80104e70 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104e56:	8b 48 04             	mov    0x4(%eax),%ecx
80104e59:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104e5c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104e5f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e61:	83 fe 0a             	cmp    $0xa,%esi
80104e64:	75 e2                	jne    80104e48 <acquire+0x58>
}
80104e66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e69:	5b                   	pop    %ebx
80104e6a:	5e                   	pop    %esi
80104e6b:	5d                   	pop    %ebp
80104e6c:	c3                   	ret    
80104e6d:	8d 76 00             	lea    0x0(%esi),%esi
80104e70:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104e73:	83 c2 28             	add    $0x28,%edx
80104e76:	8d 76 00             	lea    0x0(%esi),%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104e80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104e86:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104e89:	39 d0                	cmp    %edx,%eax
80104e8b:	75 f3                	jne    80104e80 <acquire+0x90>
}
80104e8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e90:	5b                   	pop    %ebx
80104e91:	5e                   	pop    %esi
80104e92:	5d                   	pop    %ebp
80104e93:	c3                   	ret    
    panic("acquire");
80104e94:	83 ec 0c             	sub    $0xc,%esp
80104e97:	68 2d 8d 10 80       	push   $0x80108d2d
80104e9c:	e8 ef b4 ff ff       	call   80100390 <panic>
80104ea1:	eb 0d                	jmp    80104eb0 <release>
80104ea3:	90                   	nop
80104ea4:	90                   	nop
80104ea5:	90                   	nop
80104ea6:	90                   	nop
80104ea7:	90                   	nop
80104ea8:	90                   	nop
80104ea9:	90                   	nop
80104eaa:	90                   	nop
80104eab:	90                   	nop
80104eac:	90                   	nop
80104ead:	90                   	nop
80104eae:	90                   	nop
80104eaf:	90                   	nop

80104eb0 <release>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	53                   	push   %ebx
80104eb4:	83 ec 10             	sub    $0x10,%esp
80104eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104eba:	53                   	push   %ebx
80104ebb:	e8 00 ff ff ff       	call   80104dc0 <holding>
80104ec0:	83 c4 10             	add    $0x10,%esp
80104ec3:	85 c0                	test   %eax,%eax
80104ec5:	74 22                	je     80104ee9 <release+0x39>
  lk->pcs[0] = 0;
80104ec7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104ece:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104ed5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104eda:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104ee0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ee3:	c9                   	leave  
  popcli();
80104ee4:	e9 77 fe ff ff       	jmp    80104d60 <popcli>
    panic("release");
80104ee9:	83 ec 0c             	sub    $0xc,%esp
80104eec:	68 35 8d 10 80       	push   $0x80108d35
80104ef1:	e8 9a b4 ff ff       	call   80100390 <panic>
80104ef6:	66 90                	xchg   %ax,%ax
80104ef8:	66 90                	xchg   %ax,%ax
80104efa:	66 90                	xchg   %ax,%ax
80104efc:	66 90                	xchg   %ax,%ax
80104efe:	66 90                	xchg   %ax,%ax

80104f00 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	57                   	push   %edi
80104f04:	53                   	push   %ebx
80104f05:	8b 55 08             	mov    0x8(%ebp),%edx
80104f08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104f0b:	f6 c2 03             	test   $0x3,%dl
80104f0e:	75 05                	jne    80104f15 <memset+0x15>
80104f10:	f6 c1 03             	test   $0x3,%cl
80104f13:	74 13                	je     80104f28 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104f15:	89 d7                	mov    %edx,%edi
80104f17:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f1a:	fc                   	cld    
80104f1b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104f1d:	5b                   	pop    %ebx
80104f1e:	89 d0                	mov    %edx,%eax
80104f20:	5f                   	pop    %edi
80104f21:	5d                   	pop    %ebp
80104f22:	c3                   	ret    
80104f23:	90                   	nop
80104f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104f28:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f2c:	c1 e9 02             	shr    $0x2,%ecx
80104f2f:	89 f8                	mov    %edi,%eax
80104f31:	89 fb                	mov    %edi,%ebx
80104f33:	c1 e0 18             	shl    $0x18,%eax
80104f36:	c1 e3 10             	shl    $0x10,%ebx
80104f39:	09 d8                	or     %ebx,%eax
80104f3b:	09 f8                	or     %edi,%eax
80104f3d:	c1 e7 08             	shl    $0x8,%edi
80104f40:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f42:	89 d7                	mov    %edx,%edi
80104f44:	fc                   	cld    
80104f45:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104f47:	5b                   	pop    %ebx
80104f48:	89 d0                	mov    %edx,%eax
80104f4a:	5f                   	pop    %edi
80104f4b:	5d                   	pop    %ebp
80104f4c:	c3                   	ret    
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi

80104f50 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	57                   	push   %edi
80104f54:	56                   	push   %esi
80104f55:	53                   	push   %ebx
80104f56:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104f59:	8b 75 08             	mov    0x8(%ebp),%esi
80104f5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f5f:	85 db                	test   %ebx,%ebx
80104f61:	74 29                	je     80104f8c <memcmp+0x3c>
    if(*s1 != *s2)
80104f63:	0f b6 16             	movzbl (%esi),%edx
80104f66:	0f b6 0f             	movzbl (%edi),%ecx
80104f69:	38 d1                	cmp    %dl,%cl
80104f6b:	75 2b                	jne    80104f98 <memcmp+0x48>
80104f6d:	b8 01 00 00 00       	mov    $0x1,%eax
80104f72:	eb 14                	jmp    80104f88 <memcmp+0x38>
80104f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f78:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104f7c:	83 c0 01             	add    $0x1,%eax
80104f7f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104f84:	38 ca                	cmp    %cl,%dl
80104f86:	75 10                	jne    80104f98 <memcmp+0x48>
  while(n-- > 0){
80104f88:	39 d8                	cmp    %ebx,%eax
80104f8a:	75 ec                	jne    80104f78 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104f8c:	5b                   	pop    %ebx
  return 0;
80104f8d:	31 c0                	xor    %eax,%eax
}
80104f8f:	5e                   	pop    %esi
80104f90:	5f                   	pop    %edi
80104f91:	5d                   	pop    %ebp
80104f92:	c3                   	ret    
80104f93:	90                   	nop
80104f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104f98:	0f b6 c2             	movzbl %dl,%eax
}
80104f9b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104f9c:	29 c8                	sub    %ecx,%eax
}
80104f9e:	5e                   	pop    %esi
80104f9f:	5f                   	pop    %edi
80104fa0:	5d                   	pop    %ebp
80104fa1:	c3                   	ret    
80104fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fb0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	56                   	push   %esi
80104fb4:	53                   	push   %ebx
80104fb5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104fbb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104fbe:	39 c3                	cmp    %eax,%ebx
80104fc0:	73 26                	jae    80104fe8 <memmove+0x38>
80104fc2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104fc5:	39 c8                	cmp    %ecx,%eax
80104fc7:	73 1f                	jae    80104fe8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104fc9:	85 f6                	test   %esi,%esi
80104fcb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104fce:	74 0f                	je     80104fdf <memmove+0x2f>
      *--d = *--s;
80104fd0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104fd4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104fd7:	83 ea 01             	sub    $0x1,%edx
80104fda:	83 fa ff             	cmp    $0xffffffff,%edx
80104fdd:	75 f1                	jne    80104fd0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104fdf:	5b                   	pop    %ebx
80104fe0:	5e                   	pop    %esi
80104fe1:	5d                   	pop    %ebp
80104fe2:	c3                   	ret    
80104fe3:	90                   	nop
80104fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104fe8:	31 d2                	xor    %edx,%edx
80104fea:	85 f6                	test   %esi,%esi
80104fec:	74 f1                	je     80104fdf <memmove+0x2f>
80104fee:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104ff0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ff4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ff7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104ffa:	39 d6                	cmp    %edx,%esi
80104ffc:	75 f2                	jne    80104ff0 <memmove+0x40>
}
80104ffe:	5b                   	pop    %ebx
80104fff:	5e                   	pop    %esi
80105000:	5d                   	pop    %ebp
80105001:	c3                   	ret    
80105002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105010 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105013:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105014:	eb 9a                	jmp    80104fb0 <memmove>
80105016:	8d 76 00             	lea    0x0(%esi),%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	57                   	push   %edi
80105024:	56                   	push   %esi
80105025:	8b 7d 10             	mov    0x10(%ebp),%edi
80105028:	53                   	push   %ebx
80105029:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010502c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010502f:	85 ff                	test   %edi,%edi
80105031:	74 2f                	je     80105062 <strncmp+0x42>
80105033:	0f b6 01             	movzbl (%ecx),%eax
80105036:	0f b6 1e             	movzbl (%esi),%ebx
80105039:	84 c0                	test   %al,%al
8010503b:	74 37                	je     80105074 <strncmp+0x54>
8010503d:	38 c3                	cmp    %al,%bl
8010503f:	75 33                	jne    80105074 <strncmp+0x54>
80105041:	01 f7                	add    %esi,%edi
80105043:	eb 13                	jmp    80105058 <strncmp+0x38>
80105045:	8d 76 00             	lea    0x0(%esi),%esi
80105048:	0f b6 01             	movzbl (%ecx),%eax
8010504b:	84 c0                	test   %al,%al
8010504d:	74 21                	je     80105070 <strncmp+0x50>
8010504f:	0f b6 1a             	movzbl (%edx),%ebx
80105052:	89 d6                	mov    %edx,%esi
80105054:	38 d8                	cmp    %bl,%al
80105056:	75 1c                	jne    80105074 <strncmp+0x54>
    n--, p++, q++;
80105058:	8d 56 01             	lea    0x1(%esi),%edx
8010505b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010505e:	39 fa                	cmp    %edi,%edx
80105060:	75 e6                	jne    80105048 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105062:	5b                   	pop    %ebx
    return 0;
80105063:	31 c0                	xor    %eax,%eax
}
80105065:	5e                   	pop    %esi
80105066:	5f                   	pop    %edi
80105067:	5d                   	pop    %ebp
80105068:	c3                   	ret    
80105069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105070:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105074:	29 d8                	sub    %ebx,%eax
}
80105076:	5b                   	pop    %ebx
80105077:	5e                   	pop    %esi
80105078:	5f                   	pop    %edi
80105079:	5d                   	pop    %ebp
8010507a:	c3                   	ret    
8010507b:	90                   	nop
8010507c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105080 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
80105085:	8b 45 08             	mov    0x8(%ebp),%eax
80105088:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010508b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010508e:	89 c2                	mov    %eax,%edx
80105090:	eb 19                	jmp    801050ab <strncpy+0x2b>
80105092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105098:	83 c3 01             	add    $0x1,%ebx
8010509b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010509f:	83 c2 01             	add    $0x1,%edx
801050a2:	84 c9                	test   %cl,%cl
801050a4:	88 4a ff             	mov    %cl,-0x1(%edx)
801050a7:	74 09                	je     801050b2 <strncpy+0x32>
801050a9:	89 f1                	mov    %esi,%ecx
801050ab:	85 c9                	test   %ecx,%ecx
801050ad:	8d 71 ff             	lea    -0x1(%ecx),%esi
801050b0:	7f e6                	jg     80105098 <strncpy+0x18>
    ;
  while(n-- > 0)
801050b2:	31 c9                	xor    %ecx,%ecx
801050b4:	85 f6                	test   %esi,%esi
801050b6:	7e 17                	jle    801050cf <strncpy+0x4f>
801050b8:	90                   	nop
801050b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801050c0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801050c4:	89 f3                	mov    %esi,%ebx
801050c6:	83 c1 01             	add    $0x1,%ecx
801050c9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801050cb:	85 db                	test   %ebx,%ebx
801050cd:	7f f1                	jg     801050c0 <strncpy+0x40>
  return os;
}
801050cf:	5b                   	pop    %ebx
801050d0:	5e                   	pop    %esi
801050d1:	5d                   	pop    %ebp
801050d2:	c3                   	ret    
801050d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	56                   	push   %esi
801050e4:	53                   	push   %ebx
801050e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801050e8:	8b 45 08             	mov    0x8(%ebp),%eax
801050eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801050ee:	85 c9                	test   %ecx,%ecx
801050f0:	7e 26                	jle    80105118 <safestrcpy+0x38>
801050f2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801050f6:	89 c1                	mov    %eax,%ecx
801050f8:	eb 17                	jmp    80105111 <safestrcpy+0x31>
801050fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105100:	83 c2 01             	add    $0x1,%edx
80105103:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105107:	83 c1 01             	add    $0x1,%ecx
8010510a:	84 db                	test   %bl,%bl
8010510c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010510f:	74 04                	je     80105115 <safestrcpy+0x35>
80105111:	39 f2                	cmp    %esi,%edx
80105113:	75 eb                	jne    80105100 <safestrcpy+0x20>
    ;
  *s = 0;
80105115:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105118:	5b                   	pop    %ebx
80105119:	5e                   	pop    %esi
8010511a:	5d                   	pop    %ebp
8010511b:	c3                   	ret    
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105120 <strlen>:

int
strlen(const char *s)
{
80105120:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105121:	31 c0                	xor    %eax,%eax
{
80105123:	89 e5                	mov    %esp,%ebp
80105125:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105128:	80 3a 00             	cmpb   $0x0,(%edx)
8010512b:	74 0c                	je     80105139 <strlen+0x19>
8010512d:	8d 76 00             	lea    0x0(%esi),%esi
80105130:	83 c0 01             	add    $0x1,%eax
80105133:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105137:	75 f7                	jne    80105130 <strlen+0x10>
    ;
  return n;
}
80105139:	5d                   	pop    %ebp
8010513a:	c3                   	ret    

8010513b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010513b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010513f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105143:	55                   	push   %ebp
  pushl %ebx
80105144:	53                   	push   %ebx
  pushl %esi
80105145:	56                   	push   %esi
  pushl %edi
80105146:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105147:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105149:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010514b:	5f                   	pop    %edi
  popl %esi
8010514c:	5e                   	pop    %esi
  popl %ebx
8010514d:	5b                   	pop    %ebx
  popl %ebp
8010514e:	5d                   	pop    %ebp
  ret
8010514f:	c3                   	ret    

80105150 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	53                   	push   %ebx
80105154:	83 ec 04             	sub    $0x4,%esp
80105157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010515a:	e8 b1 ee ff ff       	call   80104010 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010515f:	8b 00                	mov    (%eax),%eax
80105161:	39 d8                	cmp    %ebx,%eax
80105163:	76 1b                	jbe    80105180 <fetchint+0x30>
80105165:	8d 53 04             	lea    0x4(%ebx),%edx
80105168:	39 d0                	cmp    %edx,%eax
8010516a:	72 14                	jb     80105180 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010516c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010516f:	8b 13                	mov    (%ebx),%edx
80105171:	89 10                	mov    %edx,(%eax)
  return 0;
80105173:	31 c0                	xor    %eax,%eax
}
80105175:	83 c4 04             	add    $0x4,%esp
80105178:	5b                   	pop    %ebx
80105179:	5d                   	pop    %ebp
8010517a:	c3                   	ret    
8010517b:	90                   	nop
8010517c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105185:	eb ee                	jmp    80105175 <fetchint+0x25>
80105187:	89 f6                	mov    %esi,%esi
80105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105190 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	53                   	push   %ebx
80105194:	83 ec 04             	sub    $0x4,%esp
80105197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010519a:	e8 71 ee ff ff       	call   80104010 <myproc>

  if(addr >= curproc->sz)
8010519f:	39 18                	cmp    %ebx,(%eax)
801051a1:	76 29                	jbe    801051cc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801051a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801051a6:	89 da                	mov    %ebx,%edx
801051a8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801051aa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801051ac:	39 c3                	cmp    %eax,%ebx
801051ae:	73 1c                	jae    801051cc <fetchstr+0x3c>
    if(*s == 0)
801051b0:	80 3b 00             	cmpb   $0x0,(%ebx)
801051b3:	75 10                	jne    801051c5 <fetchstr+0x35>
801051b5:	eb 39                	jmp    801051f0 <fetchstr+0x60>
801051b7:	89 f6                	mov    %esi,%esi
801051b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801051c0:	80 3a 00             	cmpb   $0x0,(%edx)
801051c3:	74 1b                	je     801051e0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801051c5:	83 c2 01             	add    $0x1,%edx
801051c8:	39 d0                	cmp    %edx,%eax
801051ca:	77 f4                	ja     801051c0 <fetchstr+0x30>
    return -1;
801051cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801051d1:	83 c4 04             	add    $0x4,%esp
801051d4:	5b                   	pop    %ebx
801051d5:	5d                   	pop    %ebp
801051d6:	c3                   	ret    
801051d7:	89 f6                	mov    %esi,%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801051e0:	83 c4 04             	add    $0x4,%esp
801051e3:	89 d0                	mov    %edx,%eax
801051e5:	29 d8                	sub    %ebx,%eax
801051e7:	5b                   	pop    %ebx
801051e8:	5d                   	pop    %ebp
801051e9:	c3                   	ret    
801051ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801051f0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801051f2:	eb dd                	jmp    801051d1 <fetchstr+0x41>
801051f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105200 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	56                   	push   %esi
80105204:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105205:	e8 06 ee ff ff       	call   80104010 <myproc>
8010520a:	8b 40 18             	mov    0x18(%eax),%eax
8010520d:	8b 55 08             	mov    0x8(%ebp),%edx
80105210:	8b 40 44             	mov    0x44(%eax),%eax
80105213:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105216:	e8 f5 ed ff ff       	call   80104010 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010521b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010521d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105220:	39 c6                	cmp    %eax,%esi
80105222:	73 1c                	jae    80105240 <argint+0x40>
80105224:	8d 53 08             	lea    0x8(%ebx),%edx
80105227:	39 d0                	cmp    %edx,%eax
80105229:	72 15                	jb     80105240 <argint+0x40>
  *ip = *(int*)(addr);
8010522b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010522e:	8b 53 04             	mov    0x4(%ebx),%edx
80105231:	89 10                	mov    %edx,(%eax)
  return 0;
80105233:	31 c0                	xor    %eax,%eax
}
80105235:	5b                   	pop    %ebx
80105236:	5e                   	pop    %esi
80105237:	5d                   	pop    %ebp
80105238:	c3                   	ret    
80105239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105245:	eb ee                	jmp    80105235 <argint+0x35>
80105247:	89 f6                	mov    %esi,%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105250 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	56                   	push   %esi
80105254:	53                   	push   %ebx
80105255:	83 ec 10             	sub    $0x10,%esp
80105258:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010525b:	e8 b0 ed ff ff       	call   80104010 <myproc>
80105260:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105262:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105265:	83 ec 08             	sub    $0x8,%esp
80105268:	50                   	push   %eax
80105269:	ff 75 08             	pushl  0x8(%ebp)
8010526c:	e8 8f ff ff ff       	call   80105200 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105271:	83 c4 10             	add    $0x10,%esp
80105274:	85 c0                	test   %eax,%eax
80105276:	78 28                	js     801052a0 <argptr+0x50>
80105278:	85 db                	test   %ebx,%ebx
8010527a:	78 24                	js     801052a0 <argptr+0x50>
8010527c:	8b 16                	mov    (%esi),%edx
8010527e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105281:	39 c2                	cmp    %eax,%edx
80105283:	76 1b                	jbe    801052a0 <argptr+0x50>
80105285:	01 c3                	add    %eax,%ebx
80105287:	39 da                	cmp    %ebx,%edx
80105289:	72 15                	jb     801052a0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010528b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010528e:	89 02                	mov    %eax,(%edx)
  return 0;
80105290:	31 c0                	xor    %eax,%eax
}
80105292:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105295:	5b                   	pop    %ebx
80105296:	5e                   	pop    %esi
80105297:	5d                   	pop    %ebp
80105298:	c3                   	ret    
80105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801052a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a5:	eb eb                	jmp    80105292 <argptr+0x42>
801052a7:	89 f6                	mov    %esi,%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052b0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801052b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052b9:	50                   	push   %eax
801052ba:	ff 75 08             	pushl  0x8(%ebp)
801052bd:	e8 3e ff ff ff       	call   80105200 <argint>
801052c2:	83 c4 10             	add    $0x10,%esp
801052c5:	85 c0                	test   %eax,%eax
801052c7:	78 17                	js     801052e0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801052c9:	83 ec 08             	sub    $0x8,%esp
801052cc:	ff 75 0c             	pushl  0xc(%ebp)
801052cf:	ff 75 f4             	pushl  -0xc(%ebp)
801052d2:	e8 b9 fe ff ff       	call   80105190 <fetchstr>
801052d7:	83 c4 10             	add    $0x10,%esp
}
801052da:	c9                   	leave  
801052db:	c3                   	ret    
801052dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801052e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052e5:	c9                   	leave  
801052e6:	c3                   	ret    
801052e7:	89 f6                	mov    %esi,%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052f0 <syscall>:
[SYS_get_number_of_free_pages] sys_get_number_of_free_pages
};

void
syscall(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	53                   	push   %ebx
801052f4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801052f7:	e8 14 ed ff ff       	call   80104010 <myproc>
801052fc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801052fe:	8b 40 18             	mov    0x18(%eax),%eax
80105301:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105304:	8d 50 ff             	lea    -0x1(%eax),%edx
80105307:	83 fa 15             	cmp    $0x15,%edx
8010530a:	77 1c                	ja     80105328 <syscall+0x38>
8010530c:	8b 14 85 60 8d 10 80 	mov    -0x7fef72a0(,%eax,4),%edx
80105313:	85 d2                	test   %edx,%edx
80105315:	74 11                	je     80105328 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105317:	ff d2                	call   *%edx
80105319:	8b 53 18             	mov    0x18(%ebx),%edx
8010531c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010531f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105322:	c9                   	leave  
80105323:	c3                   	ret    
80105324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105328:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105329:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010532c:	50                   	push   %eax
8010532d:	ff 73 10             	pushl  0x10(%ebx)
80105330:	68 3d 8d 10 80       	push   $0x80108d3d
80105335:	e8 26 b3 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010533a:	8b 43 18             	mov    0x18(%ebx),%eax
8010533d:	83 c4 10             	add    $0x10,%esp
80105340:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105347:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010534a:	c9                   	leave  
8010534b:	c3                   	ret    
8010534c:	66 90                	xchg   %ax,%ax
8010534e:	66 90                	xchg   %ax,%ax

80105350 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	56                   	push   %esi
80105354:	53                   	push   %ebx
80105355:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105357:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010535a:	89 d6                	mov    %edx,%esi
8010535c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010535f:	50                   	push   %eax
80105360:	6a 00                	push   $0x0
80105362:	e8 99 fe ff ff       	call   80105200 <argint>
80105367:	83 c4 10             	add    $0x10,%esp
8010536a:	85 c0                	test   %eax,%eax
8010536c:	78 2a                	js     80105398 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010536e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105372:	77 24                	ja     80105398 <argfd.constprop.0+0x48>
80105374:	e8 97 ec ff ff       	call   80104010 <myproc>
80105379:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010537c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105380:	85 c0                	test   %eax,%eax
80105382:	74 14                	je     80105398 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105384:	85 db                	test   %ebx,%ebx
80105386:	74 02                	je     8010538a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105388:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010538a:	89 06                	mov    %eax,(%esi)
  return 0;
8010538c:	31 c0                	xor    %eax,%eax
}
8010538e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105391:	5b                   	pop    %ebx
80105392:	5e                   	pop    %esi
80105393:	5d                   	pop    %ebp
80105394:	c3                   	ret    
80105395:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105398:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010539d:	eb ef                	jmp    8010538e <argfd.constprop.0+0x3e>
8010539f:	90                   	nop

801053a0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801053a0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801053a1:	31 c0                	xor    %eax,%eax
{
801053a3:	89 e5                	mov    %esp,%ebp
801053a5:	56                   	push   %esi
801053a6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801053a7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801053aa:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801053ad:	e8 9e ff ff ff       	call   80105350 <argfd.constprop.0>
801053b2:	85 c0                	test   %eax,%eax
801053b4:	78 42                	js     801053f8 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
801053b6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801053b9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801053bb:	e8 50 ec ff ff       	call   80104010 <myproc>
801053c0:	eb 0e                	jmp    801053d0 <sys_dup+0x30>
801053c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801053c8:	83 c3 01             	add    $0x1,%ebx
801053cb:	83 fb 10             	cmp    $0x10,%ebx
801053ce:	74 28                	je     801053f8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801053d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053d4:	85 d2                	test   %edx,%edx
801053d6:	75 f0                	jne    801053c8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801053d8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
801053dc:	83 ec 0c             	sub    $0xc,%esp
801053df:	ff 75 f4             	pushl  -0xc(%ebp)
801053e2:	e8 a9 bd ff ff       	call   80101190 <filedup>
  return fd;
801053e7:	83 c4 10             	add    $0x10,%esp
}
801053ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053ed:	89 d8                	mov    %ebx,%eax
801053ef:	5b                   	pop    %ebx
801053f0:	5e                   	pop    %esi
801053f1:	5d                   	pop    %ebp
801053f2:	c3                   	ret    
801053f3:	90                   	nop
801053f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801053fb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105400:	89 d8                	mov    %ebx,%eax
80105402:	5b                   	pop    %ebx
80105403:	5e                   	pop    %esi
80105404:	5d                   	pop    %ebp
80105405:	c3                   	ret    
80105406:	8d 76 00             	lea    0x0(%esi),%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105410 <sys_read>:

int
sys_read(void)
{
80105410:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105411:	31 c0                	xor    %eax,%eax
{
80105413:	89 e5                	mov    %esp,%ebp
80105415:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105418:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010541b:	e8 30 ff ff ff       	call   80105350 <argfd.constprop.0>
80105420:	85 c0                	test   %eax,%eax
80105422:	78 4c                	js     80105470 <sys_read+0x60>
80105424:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105427:	83 ec 08             	sub    $0x8,%esp
8010542a:	50                   	push   %eax
8010542b:	6a 02                	push   $0x2
8010542d:	e8 ce fd ff ff       	call   80105200 <argint>
80105432:	83 c4 10             	add    $0x10,%esp
80105435:	85 c0                	test   %eax,%eax
80105437:	78 37                	js     80105470 <sys_read+0x60>
80105439:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010543c:	83 ec 04             	sub    $0x4,%esp
8010543f:	ff 75 f0             	pushl  -0x10(%ebp)
80105442:	50                   	push   %eax
80105443:	6a 01                	push   $0x1
80105445:	e8 06 fe ff ff       	call   80105250 <argptr>
8010544a:	83 c4 10             	add    $0x10,%esp
8010544d:	85 c0                	test   %eax,%eax
8010544f:	78 1f                	js     80105470 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105451:	83 ec 04             	sub    $0x4,%esp
80105454:	ff 75 f0             	pushl  -0x10(%ebp)
80105457:	ff 75 f4             	pushl  -0xc(%ebp)
8010545a:	ff 75 ec             	pushl  -0x14(%ebp)
8010545d:	e8 9e be ff ff       	call   80101300 <fileread>
80105462:	83 c4 10             	add    $0x10,%esp
}
80105465:	c9                   	leave  
80105466:	c3                   	ret    
80105467:	89 f6                	mov    %esi,%esi
80105469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105470:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105475:	c9                   	leave  
80105476:	c3                   	ret    
80105477:	89 f6                	mov    %esi,%esi
80105479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105480 <sys_write>:

int
sys_write(void)
{
80105480:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105481:	31 c0                	xor    %eax,%eax
{
80105483:	89 e5                	mov    %esp,%ebp
80105485:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105488:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010548b:	e8 c0 fe ff ff       	call   80105350 <argfd.constprop.0>
80105490:	85 c0                	test   %eax,%eax
80105492:	78 4c                	js     801054e0 <sys_write+0x60>
80105494:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105497:	83 ec 08             	sub    $0x8,%esp
8010549a:	50                   	push   %eax
8010549b:	6a 02                	push   $0x2
8010549d:	e8 5e fd ff ff       	call   80105200 <argint>
801054a2:	83 c4 10             	add    $0x10,%esp
801054a5:	85 c0                	test   %eax,%eax
801054a7:	78 37                	js     801054e0 <sys_write+0x60>
801054a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ac:	83 ec 04             	sub    $0x4,%esp
801054af:	ff 75 f0             	pushl  -0x10(%ebp)
801054b2:	50                   	push   %eax
801054b3:	6a 01                	push   $0x1
801054b5:	e8 96 fd ff ff       	call   80105250 <argptr>
801054ba:	83 c4 10             	add    $0x10,%esp
801054bd:	85 c0                	test   %eax,%eax
801054bf:	78 1f                	js     801054e0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801054c1:	83 ec 04             	sub    $0x4,%esp
801054c4:	ff 75 f0             	pushl  -0x10(%ebp)
801054c7:	ff 75 f4             	pushl  -0xc(%ebp)
801054ca:	ff 75 ec             	pushl  -0x14(%ebp)
801054cd:	e8 be be ff ff       	call   80101390 <filewrite>
801054d2:	83 c4 10             	add    $0x10,%esp
}
801054d5:	c9                   	leave  
801054d6:	c3                   	ret    
801054d7:	89 f6                	mov    %esi,%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801054e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054e5:	c9                   	leave  
801054e6:	c3                   	ret    
801054e7:	89 f6                	mov    %esi,%esi
801054e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054f0 <sys_close>:

int
sys_close(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801054f6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801054f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054fc:	e8 4f fe ff ff       	call   80105350 <argfd.constprop.0>
80105501:	85 c0                	test   %eax,%eax
80105503:	78 2b                	js     80105530 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105505:	e8 06 eb ff ff       	call   80104010 <myproc>
8010550a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010550d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105510:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105517:	00 
  fileclose(f);
80105518:	ff 75 f4             	pushl  -0xc(%ebp)
8010551b:	e8 c0 bc ff ff       	call   801011e0 <fileclose>
  return 0;
80105520:	83 c4 10             	add    $0x10,%esp
80105523:	31 c0                	xor    %eax,%eax
}
80105525:	c9                   	leave  
80105526:	c3                   	ret    
80105527:	89 f6                	mov    %esi,%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105530:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105535:	c9                   	leave  
80105536:	c3                   	ret    
80105537:	89 f6                	mov    %esi,%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105540 <sys_fstat>:

int
sys_fstat(void)
{
80105540:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105541:	31 c0                	xor    %eax,%eax
{
80105543:	89 e5                	mov    %esp,%ebp
80105545:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105548:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010554b:	e8 00 fe ff ff       	call   80105350 <argfd.constprop.0>
80105550:	85 c0                	test   %eax,%eax
80105552:	78 2c                	js     80105580 <sys_fstat+0x40>
80105554:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105557:	83 ec 04             	sub    $0x4,%esp
8010555a:	6a 14                	push   $0x14
8010555c:	50                   	push   %eax
8010555d:	6a 01                	push   $0x1
8010555f:	e8 ec fc ff ff       	call   80105250 <argptr>
80105564:	83 c4 10             	add    $0x10,%esp
80105567:	85 c0                	test   %eax,%eax
80105569:	78 15                	js     80105580 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010556b:	83 ec 08             	sub    $0x8,%esp
8010556e:	ff 75 f4             	pushl  -0xc(%ebp)
80105571:	ff 75 f0             	pushl  -0x10(%ebp)
80105574:	e8 37 bd ff ff       	call   801012b0 <filestat>
80105579:	83 c4 10             	add    $0x10,%esp
}
8010557c:	c9                   	leave  
8010557d:	c3                   	ret    
8010557e:	66 90                	xchg   %ax,%ax
    return -1;
80105580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105585:	c9                   	leave  
80105586:	c3                   	ret    
80105587:	89 f6                	mov    %esi,%esi
80105589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105590 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	57                   	push   %edi
80105594:	56                   	push   %esi
80105595:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105596:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105599:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010559c:	50                   	push   %eax
8010559d:	6a 00                	push   $0x0
8010559f:	e8 0c fd ff ff       	call   801052b0 <argstr>
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	85 c0                	test   %eax,%eax
801055a9:	0f 88 fb 00 00 00    	js     801056aa <sys_link+0x11a>
801055af:	8d 45 d0             	lea    -0x30(%ebp),%eax
801055b2:	83 ec 08             	sub    $0x8,%esp
801055b5:	50                   	push   %eax
801055b6:	6a 01                	push   $0x1
801055b8:	e8 f3 fc ff ff       	call   801052b0 <argstr>
801055bd:	83 c4 10             	add    $0x10,%esp
801055c0:	85 c0                	test   %eax,%eax
801055c2:	0f 88 e2 00 00 00    	js     801056aa <sys_link+0x11a>
    return -1;

  begin_op();
801055c8:	e8 83 dd ff ff       	call   80103350 <begin_op>
  if((ip = namei(old)) == 0){
801055cd:	83 ec 0c             	sub    $0xc,%esp
801055d0:	ff 75 d4             	pushl  -0x2c(%ebp)
801055d3:	e8 a8 cc ff ff       	call   80102280 <namei>
801055d8:	83 c4 10             	add    $0x10,%esp
801055db:	85 c0                	test   %eax,%eax
801055dd:	89 c3                	mov    %eax,%ebx
801055df:	0f 84 ea 00 00 00    	je     801056cf <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
801055e5:	83 ec 0c             	sub    $0xc,%esp
801055e8:	50                   	push   %eax
801055e9:	e8 32 c4 ff ff       	call   80101a20 <ilock>
  if(ip->type == T_DIR){
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055f6:	0f 84 bb 00 00 00    	je     801056b7 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801055fc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105601:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105604:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105607:	53                   	push   %ebx
80105608:	e8 63 c3 ff ff       	call   80101970 <iupdate>
  iunlock(ip);
8010560d:	89 1c 24             	mov    %ebx,(%esp)
80105610:	e8 eb c4 ff ff       	call   80101b00 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105615:	58                   	pop    %eax
80105616:	5a                   	pop    %edx
80105617:	57                   	push   %edi
80105618:	ff 75 d0             	pushl  -0x30(%ebp)
8010561b:	e8 80 cc ff ff       	call   801022a0 <nameiparent>
80105620:	83 c4 10             	add    $0x10,%esp
80105623:	85 c0                	test   %eax,%eax
80105625:	89 c6                	mov    %eax,%esi
80105627:	74 5b                	je     80105684 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105629:	83 ec 0c             	sub    $0xc,%esp
8010562c:	50                   	push   %eax
8010562d:	e8 ee c3 ff ff       	call   80101a20 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105632:	83 c4 10             	add    $0x10,%esp
80105635:	8b 03                	mov    (%ebx),%eax
80105637:	39 06                	cmp    %eax,(%esi)
80105639:	75 3d                	jne    80105678 <sys_link+0xe8>
8010563b:	83 ec 04             	sub    $0x4,%esp
8010563e:	ff 73 04             	pushl  0x4(%ebx)
80105641:	57                   	push   %edi
80105642:	56                   	push   %esi
80105643:	e8 78 cb ff ff       	call   801021c0 <dirlink>
80105648:	83 c4 10             	add    $0x10,%esp
8010564b:	85 c0                	test   %eax,%eax
8010564d:	78 29                	js     80105678 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010564f:	83 ec 0c             	sub    $0xc,%esp
80105652:	56                   	push   %esi
80105653:	e8 58 c6 ff ff       	call   80101cb0 <iunlockput>
  iput(ip);
80105658:	89 1c 24             	mov    %ebx,(%esp)
8010565b:	e8 f0 c4 ff ff       	call   80101b50 <iput>

  end_op();
80105660:	e8 5b dd ff ff       	call   801033c0 <end_op>

  return 0;
80105665:	83 c4 10             	add    $0x10,%esp
80105668:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010566a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010566d:	5b                   	pop    %ebx
8010566e:	5e                   	pop    %esi
8010566f:	5f                   	pop    %edi
80105670:	5d                   	pop    %ebp
80105671:	c3                   	ret    
80105672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105678:	83 ec 0c             	sub    $0xc,%esp
8010567b:	56                   	push   %esi
8010567c:	e8 2f c6 ff ff       	call   80101cb0 <iunlockput>
    goto bad;
80105681:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105684:	83 ec 0c             	sub    $0xc,%esp
80105687:	53                   	push   %ebx
80105688:	e8 93 c3 ff ff       	call   80101a20 <ilock>
  ip->nlink--;
8010568d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105692:	89 1c 24             	mov    %ebx,(%esp)
80105695:	e8 d6 c2 ff ff       	call   80101970 <iupdate>
  iunlockput(ip);
8010569a:	89 1c 24             	mov    %ebx,(%esp)
8010569d:	e8 0e c6 ff ff       	call   80101cb0 <iunlockput>
  end_op();
801056a2:	e8 19 dd ff ff       	call   801033c0 <end_op>
  return -1;
801056a7:	83 c4 10             	add    $0x10,%esp
}
801056aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801056ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056b2:	5b                   	pop    %ebx
801056b3:	5e                   	pop    %esi
801056b4:	5f                   	pop    %edi
801056b5:	5d                   	pop    %ebp
801056b6:	c3                   	ret    
    iunlockput(ip);
801056b7:	83 ec 0c             	sub    $0xc,%esp
801056ba:	53                   	push   %ebx
801056bb:	e8 f0 c5 ff ff       	call   80101cb0 <iunlockput>
    end_op();
801056c0:	e8 fb dc ff ff       	call   801033c0 <end_op>
    return -1;
801056c5:	83 c4 10             	add    $0x10,%esp
801056c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056cd:	eb 9b                	jmp    8010566a <sys_link+0xda>
    end_op();
801056cf:	e8 ec dc ff ff       	call   801033c0 <end_op>
    return -1;
801056d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d9:	eb 8f                	jmp    8010566a <sys_link+0xda>
801056db:	90                   	nop
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056e0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	57                   	push   %edi
801056e4:	56                   	push   %esi
801056e5:	53                   	push   %ebx
801056e6:	83 ec 1c             	sub    $0x1c,%esp
801056e9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801056ec:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801056f0:	76 3e                	jbe    80105730 <isdirempty+0x50>
801056f2:	bb 20 00 00 00       	mov    $0x20,%ebx
801056f7:	8d 7d d8             	lea    -0x28(%ebp),%edi
801056fa:	eb 0c                	jmp    80105708 <isdirempty+0x28>
801056fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105700:	83 c3 10             	add    $0x10,%ebx
80105703:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105706:	73 28                	jae    80105730 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105708:	6a 10                	push   $0x10
8010570a:	53                   	push   %ebx
8010570b:	57                   	push   %edi
8010570c:	56                   	push   %esi
8010570d:	e8 ee c5 ff ff       	call   80101d00 <readi>
80105712:	83 c4 10             	add    $0x10,%esp
80105715:	83 f8 10             	cmp    $0x10,%eax
80105718:	75 23                	jne    8010573d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010571a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010571f:	74 df                	je     80105700 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105721:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105724:	31 c0                	xor    %eax,%eax
}
80105726:	5b                   	pop    %ebx
80105727:	5e                   	pop    %esi
80105728:	5f                   	pop    %edi
80105729:	5d                   	pop    %ebp
8010572a:	c3                   	ret    
8010572b:	90                   	nop
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105730:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105733:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105738:	5b                   	pop    %ebx
80105739:	5e                   	pop    %esi
8010573a:	5f                   	pop    %edi
8010573b:	5d                   	pop    %ebp
8010573c:	c3                   	ret    
      panic("isdirempty: readi");
8010573d:	83 ec 0c             	sub    $0xc,%esp
80105740:	68 bc 8d 10 80       	push   $0x80108dbc
80105745:	e8 46 ac ff ff       	call   80100390 <panic>
8010574a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105750 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	57                   	push   %edi
80105754:	56                   	push   %esi
80105755:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105756:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105759:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010575c:	50                   	push   %eax
8010575d:	6a 00                	push   $0x0
8010575f:	e8 4c fb ff ff       	call   801052b0 <argstr>
80105764:	83 c4 10             	add    $0x10,%esp
80105767:	85 c0                	test   %eax,%eax
80105769:	0f 88 51 01 00 00    	js     801058c0 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010576f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105772:	e8 d9 db ff ff       	call   80103350 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105777:	83 ec 08             	sub    $0x8,%esp
8010577a:	53                   	push   %ebx
8010577b:	ff 75 c0             	pushl  -0x40(%ebp)
8010577e:	e8 1d cb ff ff       	call   801022a0 <nameiparent>
80105783:	83 c4 10             	add    $0x10,%esp
80105786:	85 c0                	test   %eax,%eax
80105788:	89 c6                	mov    %eax,%esi
8010578a:	0f 84 37 01 00 00    	je     801058c7 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	50                   	push   %eax
80105794:	e8 87 c2 ff ff       	call   80101a20 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105799:	58                   	pop    %eax
8010579a:	5a                   	pop    %edx
8010579b:	68 7d 87 10 80       	push   $0x8010877d
801057a0:	53                   	push   %ebx
801057a1:	e8 8a c7 ff ff       	call   80101f30 <namecmp>
801057a6:	83 c4 10             	add    $0x10,%esp
801057a9:	85 c0                	test   %eax,%eax
801057ab:	0f 84 d7 00 00 00    	je     80105888 <sys_unlink+0x138>
801057b1:	83 ec 08             	sub    $0x8,%esp
801057b4:	68 7c 87 10 80       	push   $0x8010877c
801057b9:	53                   	push   %ebx
801057ba:	e8 71 c7 ff ff       	call   80101f30 <namecmp>
801057bf:	83 c4 10             	add    $0x10,%esp
801057c2:	85 c0                	test   %eax,%eax
801057c4:	0f 84 be 00 00 00    	je     80105888 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801057ca:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801057cd:	83 ec 04             	sub    $0x4,%esp
801057d0:	50                   	push   %eax
801057d1:	53                   	push   %ebx
801057d2:	56                   	push   %esi
801057d3:	e8 78 c7 ff ff       	call   80101f50 <dirlookup>
801057d8:	83 c4 10             	add    $0x10,%esp
801057db:	85 c0                	test   %eax,%eax
801057dd:	89 c3                	mov    %eax,%ebx
801057df:	0f 84 a3 00 00 00    	je     80105888 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
801057e5:	83 ec 0c             	sub    $0xc,%esp
801057e8:	50                   	push   %eax
801057e9:	e8 32 c2 ff ff       	call   80101a20 <ilock>

  if(ip->nlink < 1)
801057ee:	83 c4 10             	add    $0x10,%esp
801057f1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801057f6:	0f 8e e4 00 00 00    	jle    801058e0 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801057fc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105801:	74 65                	je     80105868 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105803:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105806:	83 ec 04             	sub    $0x4,%esp
80105809:	6a 10                	push   $0x10
8010580b:	6a 00                	push   $0x0
8010580d:	57                   	push   %edi
8010580e:	e8 ed f6 ff ff       	call   80104f00 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105813:	6a 10                	push   $0x10
80105815:	ff 75 c4             	pushl  -0x3c(%ebp)
80105818:	57                   	push   %edi
80105819:	56                   	push   %esi
8010581a:	e8 e1 c5 ff ff       	call   80101e00 <writei>
8010581f:	83 c4 20             	add    $0x20,%esp
80105822:	83 f8 10             	cmp    $0x10,%eax
80105825:	0f 85 a8 00 00 00    	jne    801058d3 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010582b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105830:	74 6e                	je     801058a0 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105832:	83 ec 0c             	sub    $0xc,%esp
80105835:	56                   	push   %esi
80105836:	e8 75 c4 ff ff       	call   80101cb0 <iunlockput>

  ip->nlink--;
8010583b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105840:	89 1c 24             	mov    %ebx,(%esp)
80105843:	e8 28 c1 ff ff       	call   80101970 <iupdate>
  iunlockput(ip);
80105848:	89 1c 24             	mov    %ebx,(%esp)
8010584b:	e8 60 c4 ff ff       	call   80101cb0 <iunlockput>

  end_op();
80105850:	e8 6b db ff ff       	call   801033c0 <end_op>

  return 0;
80105855:	83 c4 10             	add    $0x10,%esp
80105858:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010585a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010585d:	5b                   	pop    %ebx
8010585e:	5e                   	pop    %esi
8010585f:	5f                   	pop    %edi
80105860:	5d                   	pop    %ebp
80105861:	c3                   	ret    
80105862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105868:	83 ec 0c             	sub    $0xc,%esp
8010586b:	53                   	push   %ebx
8010586c:	e8 6f fe ff ff       	call   801056e0 <isdirempty>
80105871:	83 c4 10             	add    $0x10,%esp
80105874:	85 c0                	test   %eax,%eax
80105876:	75 8b                	jne    80105803 <sys_unlink+0xb3>
    iunlockput(ip);
80105878:	83 ec 0c             	sub    $0xc,%esp
8010587b:	53                   	push   %ebx
8010587c:	e8 2f c4 ff ff       	call   80101cb0 <iunlockput>
    goto bad;
80105881:	83 c4 10             	add    $0x10,%esp
80105884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105888:	83 ec 0c             	sub    $0xc,%esp
8010588b:	56                   	push   %esi
8010588c:	e8 1f c4 ff ff       	call   80101cb0 <iunlockput>
  end_op();
80105891:	e8 2a db ff ff       	call   801033c0 <end_op>
  return -1;
80105896:	83 c4 10             	add    $0x10,%esp
80105899:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589e:	eb ba                	jmp    8010585a <sys_unlink+0x10a>
    dp->nlink--;
801058a0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801058a5:	83 ec 0c             	sub    $0xc,%esp
801058a8:	56                   	push   %esi
801058a9:	e8 c2 c0 ff ff       	call   80101970 <iupdate>
801058ae:	83 c4 10             	add    $0x10,%esp
801058b1:	e9 7c ff ff ff       	jmp    80105832 <sys_unlink+0xe2>
801058b6:	8d 76 00             	lea    0x0(%esi),%esi
801058b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801058c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c5:	eb 93                	jmp    8010585a <sys_unlink+0x10a>
    end_op();
801058c7:	e8 f4 da ff ff       	call   801033c0 <end_op>
    return -1;
801058cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d1:	eb 87                	jmp    8010585a <sys_unlink+0x10a>
    panic("unlink: writei");
801058d3:	83 ec 0c             	sub    $0xc,%esp
801058d6:	68 91 87 10 80       	push   $0x80108791
801058db:	e8 b0 aa ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801058e0:	83 ec 0c             	sub    $0xc,%esp
801058e3:	68 7f 87 10 80       	push   $0x8010877f
801058e8:	e8 a3 aa ff ff       	call   80100390 <panic>
801058ed:	8d 76 00             	lea    0x0(%esi),%esi

801058f0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	57                   	push   %edi
801058f4:	56                   	push   %esi
801058f5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801058f6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801058f9:	83 ec 34             	sub    $0x34,%esp
801058fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801058ff:	8b 55 10             	mov    0x10(%ebp),%edx
80105902:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105905:	56                   	push   %esi
80105906:	ff 75 08             	pushl  0x8(%ebp)
{
80105909:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010590c:	89 55 d0             	mov    %edx,-0x30(%ebp)
8010590f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105912:	e8 89 c9 ff ff       	call   801022a0 <nameiparent>
80105917:	83 c4 10             	add    $0x10,%esp
8010591a:	85 c0                	test   %eax,%eax
8010591c:	0f 84 4e 01 00 00    	je     80105a70 <create+0x180>
    return 0;
  ilock(dp);
80105922:	83 ec 0c             	sub    $0xc,%esp
80105925:	89 c3                	mov    %eax,%ebx
80105927:	50                   	push   %eax
80105928:	e8 f3 c0 ff ff       	call   80101a20 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
8010592d:	83 c4 0c             	add    $0xc,%esp
80105930:	6a 00                	push   $0x0
80105932:	56                   	push   %esi
80105933:	53                   	push   %ebx
80105934:	e8 17 c6 ff ff       	call   80101f50 <dirlookup>
80105939:	83 c4 10             	add    $0x10,%esp
8010593c:	85 c0                	test   %eax,%eax
8010593e:	89 c7                	mov    %eax,%edi
80105940:	74 3e                	je     80105980 <create+0x90>
    iunlockput(dp);
80105942:	83 ec 0c             	sub    $0xc,%esp
80105945:	53                   	push   %ebx
80105946:	e8 65 c3 ff ff       	call   80101cb0 <iunlockput>
    ilock(ip);
8010594b:	89 3c 24             	mov    %edi,(%esp)
8010594e:	e8 cd c0 ff ff       	call   80101a20 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105953:	83 c4 10             	add    $0x10,%esp
80105956:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010595b:	0f 85 9f 00 00 00    	jne    80105a00 <create+0x110>
80105961:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105966:	0f 85 94 00 00 00    	jne    80105a00 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010596c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010596f:	89 f8                	mov    %edi,%eax
80105971:	5b                   	pop    %ebx
80105972:	5e                   	pop    %esi
80105973:	5f                   	pop    %edi
80105974:	5d                   	pop    %ebp
80105975:	c3                   	ret    
80105976:	8d 76 00             	lea    0x0(%esi),%esi
80105979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105980:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105984:	83 ec 08             	sub    $0x8,%esp
80105987:	50                   	push   %eax
80105988:	ff 33                	pushl  (%ebx)
8010598a:	e8 21 bf ff ff       	call   801018b0 <ialloc>
8010598f:	83 c4 10             	add    $0x10,%esp
80105992:	85 c0                	test   %eax,%eax
80105994:	89 c7                	mov    %eax,%edi
80105996:	0f 84 e8 00 00 00    	je     80105a84 <create+0x194>
  ilock(ip);
8010599c:	83 ec 0c             	sub    $0xc,%esp
8010599f:	50                   	push   %eax
801059a0:	e8 7b c0 ff ff       	call   80101a20 <ilock>
  ip->major = major;
801059a5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801059a9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801059ad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801059b1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801059b5:	b8 01 00 00 00       	mov    $0x1,%eax
801059ba:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801059be:	89 3c 24             	mov    %edi,(%esp)
801059c1:	e8 aa bf ff ff       	call   80101970 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801059c6:	83 c4 10             	add    $0x10,%esp
801059c9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801059ce:	74 50                	je     80105a20 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
801059d0:	83 ec 04             	sub    $0x4,%esp
801059d3:	ff 77 04             	pushl  0x4(%edi)
801059d6:	56                   	push   %esi
801059d7:	53                   	push   %ebx
801059d8:	e8 e3 c7 ff ff       	call   801021c0 <dirlink>
801059dd:	83 c4 10             	add    $0x10,%esp
801059e0:	85 c0                	test   %eax,%eax
801059e2:	0f 88 8f 00 00 00    	js     80105a77 <create+0x187>
  iunlockput(dp);
801059e8:	83 ec 0c             	sub    $0xc,%esp
801059eb:	53                   	push   %ebx
801059ec:	e8 bf c2 ff ff       	call   80101cb0 <iunlockput>
  return ip;
801059f1:	83 c4 10             	add    $0x10,%esp
}
801059f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059f7:	89 f8                	mov    %edi,%eax
801059f9:	5b                   	pop    %ebx
801059fa:	5e                   	pop    %esi
801059fb:	5f                   	pop    %edi
801059fc:	5d                   	pop    %ebp
801059fd:	c3                   	ret    
801059fe:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105a00:	83 ec 0c             	sub    $0xc,%esp
80105a03:	57                   	push   %edi
    return 0;
80105a04:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105a06:	e8 a5 c2 ff ff       	call   80101cb0 <iunlockput>
    return 0;
80105a0b:	83 c4 10             	add    $0x10,%esp
}
80105a0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a11:	89 f8                	mov    %edi,%eax
80105a13:	5b                   	pop    %ebx
80105a14:	5e                   	pop    %esi
80105a15:	5f                   	pop    %edi
80105a16:	5d                   	pop    %ebp
80105a17:	c3                   	ret    
80105a18:	90                   	nop
80105a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105a20:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105a25:	83 ec 0c             	sub    $0xc,%esp
80105a28:	53                   	push   %ebx
80105a29:	e8 42 bf ff ff       	call   80101970 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105a2e:	83 c4 0c             	add    $0xc,%esp
80105a31:	ff 77 04             	pushl  0x4(%edi)
80105a34:	68 7d 87 10 80       	push   $0x8010877d
80105a39:	57                   	push   %edi
80105a3a:	e8 81 c7 ff ff       	call   801021c0 <dirlink>
80105a3f:	83 c4 10             	add    $0x10,%esp
80105a42:	85 c0                	test   %eax,%eax
80105a44:	78 1c                	js     80105a62 <create+0x172>
80105a46:	83 ec 04             	sub    $0x4,%esp
80105a49:	ff 73 04             	pushl  0x4(%ebx)
80105a4c:	68 7c 87 10 80       	push   $0x8010877c
80105a51:	57                   	push   %edi
80105a52:	e8 69 c7 ff ff       	call   801021c0 <dirlink>
80105a57:	83 c4 10             	add    $0x10,%esp
80105a5a:	85 c0                	test   %eax,%eax
80105a5c:	0f 89 6e ff ff ff    	jns    801059d0 <create+0xe0>
      panic("create dots");
80105a62:	83 ec 0c             	sub    $0xc,%esp
80105a65:	68 dd 8d 10 80       	push   $0x80108ddd
80105a6a:	e8 21 a9 ff ff       	call   80100390 <panic>
80105a6f:	90                   	nop
    return 0;
80105a70:	31 ff                	xor    %edi,%edi
80105a72:	e9 f5 fe ff ff       	jmp    8010596c <create+0x7c>
    panic("create: dirlink");
80105a77:	83 ec 0c             	sub    $0xc,%esp
80105a7a:	68 e9 8d 10 80       	push   $0x80108de9
80105a7f:	e8 0c a9 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105a84:	83 ec 0c             	sub    $0xc,%esp
80105a87:	68 ce 8d 10 80       	push   $0x80108dce
80105a8c:	e8 ff a8 ff ff       	call   80100390 <panic>
80105a91:	eb 0d                	jmp    80105aa0 <sys_open>
80105a93:	90                   	nop
80105a94:	90                   	nop
80105a95:	90                   	nop
80105a96:	90                   	nop
80105a97:	90                   	nop
80105a98:	90                   	nop
80105a99:	90                   	nop
80105a9a:	90                   	nop
80105a9b:	90                   	nop
80105a9c:	90                   	nop
80105a9d:	90                   	nop
80105a9e:	90                   	nop
80105a9f:	90                   	nop

80105aa0 <sys_open>:

int
sys_open(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	57                   	push   %edi
80105aa4:	56                   	push   %esi
80105aa5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105aa6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105aa9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105aac:	50                   	push   %eax
80105aad:	6a 00                	push   $0x0
80105aaf:	e8 fc f7 ff ff       	call   801052b0 <argstr>
80105ab4:	83 c4 10             	add    $0x10,%esp
80105ab7:	85 c0                	test   %eax,%eax
80105ab9:	0f 88 1d 01 00 00    	js     80105bdc <sys_open+0x13c>
80105abf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ac2:	83 ec 08             	sub    $0x8,%esp
80105ac5:	50                   	push   %eax
80105ac6:	6a 01                	push   $0x1
80105ac8:	e8 33 f7 ff ff       	call   80105200 <argint>
80105acd:	83 c4 10             	add    $0x10,%esp
80105ad0:	85 c0                	test   %eax,%eax
80105ad2:	0f 88 04 01 00 00    	js     80105bdc <sys_open+0x13c>
    return -1;

  begin_op();
80105ad8:	e8 73 d8 ff ff       	call   80103350 <begin_op>

  if(omode & O_CREATE){
80105add:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105ae1:	0f 85 a9 00 00 00    	jne    80105b90 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105ae7:	83 ec 0c             	sub    $0xc,%esp
80105aea:	ff 75 e0             	pushl  -0x20(%ebp)
80105aed:	e8 8e c7 ff ff       	call   80102280 <namei>
80105af2:	83 c4 10             	add    $0x10,%esp
80105af5:	85 c0                	test   %eax,%eax
80105af7:	89 c6                	mov    %eax,%esi
80105af9:	0f 84 ac 00 00 00    	je     80105bab <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
80105aff:	83 ec 0c             	sub    $0xc,%esp
80105b02:	50                   	push   %eax
80105b03:	e8 18 bf ff ff       	call   80101a20 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b08:	83 c4 10             	add    $0x10,%esp
80105b0b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105b10:	0f 84 aa 00 00 00    	je     80105bc0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b16:	e8 05 b6 ff ff       	call   80101120 <filealloc>
80105b1b:	85 c0                	test   %eax,%eax
80105b1d:	89 c7                	mov    %eax,%edi
80105b1f:	0f 84 a6 00 00 00    	je     80105bcb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105b25:	e8 e6 e4 ff ff       	call   80104010 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b2a:	31 db                	xor    %ebx,%ebx
80105b2c:	eb 0e                	jmp    80105b3c <sys_open+0x9c>
80105b2e:	66 90                	xchg   %ax,%ax
80105b30:	83 c3 01             	add    $0x1,%ebx
80105b33:	83 fb 10             	cmp    $0x10,%ebx
80105b36:	0f 84 ac 00 00 00    	je     80105be8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105b3c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105b40:	85 d2                	test   %edx,%edx
80105b42:	75 ec                	jne    80105b30 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b44:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b47:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b4b:	56                   	push   %esi
80105b4c:	e8 af bf ff ff       	call   80101b00 <iunlock>
  end_op();
80105b51:	e8 6a d8 ff ff       	call   801033c0 <end_op>

  f->type = FD_INODE;
80105b56:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b5f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b62:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105b65:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b6c:	89 d0                	mov    %edx,%eax
80105b6e:	f7 d0                	not    %eax
80105b70:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b73:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b76:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b79:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b80:	89 d8                	mov    %ebx,%eax
80105b82:	5b                   	pop    %ebx
80105b83:	5e                   	pop    %esi
80105b84:	5f                   	pop    %edi
80105b85:	5d                   	pop    %ebp
80105b86:	c3                   	ret    
80105b87:	89 f6                	mov    %esi,%esi
80105b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105b90:	6a 00                	push   $0x0
80105b92:	6a 00                	push   $0x0
80105b94:	6a 02                	push   $0x2
80105b96:	ff 75 e0             	pushl  -0x20(%ebp)
80105b99:	e8 52 fd ff ff       	call   801058f0 <create>
    if(ip == 0){
80105b9e:	83 c4 10             	add    $0x10,%esp
80105ba1:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105ba3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105ba5:	0f 85 6b ff ff ff    	jne    80105b16 <sys_open+0x76>
      end_op();
80105bab:	e8 10 d8 ff ff       	call   801033c0 <end_op>
      return -1;
80105bb0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105bb5:	eb c6                	jmp    80105b7d <sys_open+0xdd>
80105bb7:	89 f6                	mov    %esi,%esi
80105bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105bc0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105bc3:	85 c9                	test   %ecx,%ecx
80105bc5:	0f 84 4b ff ff ff    	je     80105b16 <sys_open+0x76>
    iunlockput(ip);
80105bcb:	83 ec 0c             	sub    $0xc,%esp
80105bce:	56                   	push   %esi
80105bcf:	e8 dc c0 ff ff       	call   80101cb0 <iunlockput>
    end_op();
80105bd4:	e8 e7 d7 ff ff       	call   801033c0 <end_op>
    return -1;
80105bd9:	83 c4 10             	add    $0x10,%esp
80105bdc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105be1:	eb 9a                	jmp    80105b7d <sys_open+0xdd>
80105be3:	90                   	nop
80105be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105be8:	83 ec 0c             	sub    $0xc,%esp
80105beb:	57                   	push   %edi
80105bec:	e8 ef b5 ff ff       	call   801011e0 <fileclose>
80105bf1:	83 c4 10             	add    $0x10,%esp
80105bf4:	eb d5                	jmp    80105bcb <sys_open+0x12b>
80105bf6:	8d 76 00             	lea    0x0(%esi),%esi
80105bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c00 <sys_mkdir>:

int
sys_mkdir(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105c06:	e8 45 d7 ff ff       	call   80103350 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105c0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c0e:	83 ec 08             	sub    $0x8,%esp
80105c11:	50                   	push   %eax
80105c12:	6a 00                	push   $0x0
80105c14:	e8 97 f6 ff ff       	call   801052b0 <argstr>
80105c19:	83 c4 10             	add    $0x10,%esp
80105c1c:	85 c0                	test   %eax,%eax
80105c1e:	78 30                	js     80105c50 <sys_mkdir+0x50>
80105c20:	6a 00                	push   $0x0
80105c22:	6a 00                	push   $0x0
80105c24:	6a 01                	push   $0x1
80105c26:	ff 75 f4             	pushl  -0xc(%ebp)
80105c29:	e8 c2 fc ff ff       	call   801058f0 <create>
80105c2e:	83 c4 10             	add    $0x10,%esp
80105c31:	85 c0                	test   %eax,%eax
80105c33:	74 1b                	je     80105c50 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c35:	83 ec 0c             	sub    $0xc,%esp
80105c38:	50                   	push   %eax
80105c39:	e8 72 c0 ff ff       	call   80101cb0 <iunlockput>
  end_op();
80105c3e:	e8 7d d7 ff ff       	call   801033c0 <end_op>
  return 0;
80105c43:	83 c4 10             	add    $0x10,%esp
80105c46:	31 c0                	xor    %eax,%eax
}
80105c48:	c9                   	leave  
80105c49:	c3                   	ret    
80105c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105c50:	e8 6b d7 ff ff       	call   801033c0 <end_op>
    return -1;
80105c55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c5a:	c9                   	leave  
80105c5b:	c3                   	ret    
80105c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c60 <sys_mknod>:

int
sys_mknod(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c66:	e8 e5 d6 ff ff       	call   80103350 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c6b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c6e:	83 ec 08             	sub    $0x8,%esp
80105c71:	50                   	push   %eax
80105c72:	6a 00                	push   $0x0
80105c74:	e8 37 f6 ff ff       	call   801052b0 <argstr>
80105c79:	83 c4 10             	add    $0x10,%esp
80105c7c:	85 c0                	test   %eax,%eax
80105c7e:	78 60                	js     80105ce0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105c80:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c83:	83 ec 08             	sub    $0x8,%esp
80105c86:	50                   	push   %eax
80105c87:	6a 01                	push   $0x1
80105c89:	e8 72 f5 ff ff       	call   80105200 <argint>
  if((argstr(0, &path)) < 0 ||
80105c8e:	83 c4 10             	add    $0x10,%esp
80105c91:	85 c0                	test   %eax,%eax
80105c93:	78 4b                	js     80105ce0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105c95:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c98:	83 ec 08             	sub    $0x8,%esp
80105c9b:	50                   	push   %eax
80105c9c:	6a 02                	push   $0x2
80105c9e:	e8 5d f5 ff ff       	call   80105200 <argint>
     argint(1, &major) < 0 ||
80105ca3:	83 c4 10             	add    $0x10,%esp
80105ca6:	85 c0                	test   %eax,%eax
80105ca8:	78 36                	js     80105ce0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105caa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105cae:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
80105caf:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105cb3:	50                   	push   %eax
80105cb4:	6a 03                	push   $0x3
80105cb6:	ff 75 ec             	pushl  -0x14(%ebp)
80105cb9:	e8 32 fc ff ff       	call   801058f0 <create>
80105cbe:	83 c4 10             	add    $0x10,%esp
80105cc1:	85 c0                	test   %eax,%eax
80105cc3:	74 1b                	je     80105ce0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105cc5:	83 ec 0c             	sub    $0xc,%esp
80105cc8:	50                   	push   %eax
80105cc9:	e8 e2 bf ff ff       	call   80101cb0 <iunlockput>
  end_op();
80105cce:	e8 ed d6 ff ff       	call   801033c0 <end_op>
  return 0;
80105cd3:	83 c4 10             	add    $0x10,%esp
80105cd6:	31 c0                	xor    %eax,%eax
}
80105cd8:	c9                   	leave  
80105cd9:	c3                   	ret    
80105cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105ce0:	e8 db d6 ff ff       	call   801033c0 <end_op>
    return -1;
80105ce5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cea:	c9                   	leave  
80105ceb:	c3                   	ret    
80105cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cf0 <sys_chdir>:

int
sys_chdir(void)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	56                   	push   %esi
80105cf4:	53                   	push   %ebx
80105cf5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105cf8:	e8 13 e3 ff ff       	call   80104010 <myproc>
80105cfd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105cff:	e8 4c d6 ff ff       	call   80103350 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105d04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d07:	83 ec 08             	sub    $0x8,%esp
80105d0a:	50                   	push   %eax
80105d0b:	6a 00                	push   $0x0
80105d0d:	e8 9e f5 ff ff       	call   801052b0 <argstr>
80105d12:	83 c4 10             	add    $0x10,%esp
80105d15:	85 c0                	test   %eax,%eax
80105d17:	78 77                	js     80105d90 <sys_chdir+0xa0>
80105d19:	83 ec 0c             	sub    $0xc,%esp
80105d1c:	ff 75 f4             	pushl  -0xc(%ebp)
80105d1f:	e8 5c c5 ff ff       	call   80102280 <namei>
80105d24:	83 c4 10             	add    $0x10,%esp
80105d27:	85 c0                	test   %eax,%eax
80105d29:	89 c3                	mov    %eax,%ebx
80105d2b:	74 63                	je     80105d90 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105d2d:	83 ec 0c             	sub    $0xc,%esp
80105d30:	50                   	push   %eax
80105d31:	e8 ea bc ff ff       	call   80101a20 <ilock>
  if(ip->type != T_DIR){
80105d36:	83 c4 10             	add    $0x10,%esp
80105d39:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d3e:	75 30                	jne    80105d70 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105d40:	83 ec 0c             	sub    $0xc,%esp
80105d43:	53                   	push   %ebx
80105d44:	e8 b7 bd ff ff       	call   80101b00 <iunlock>
  iput(curproc->cwd);
80105d49:	58                   	pop    %eax
80105d4a:	ff 76 68             	pushl  0x68(%esi)
80105d4d:	e8 fe bd ff ff       	call   80101b50 <iput>
  end_op();
80105d52:	e8 69 d6 ff ff       	call   801033c0 <end_op>
  curproc->cwd = ip;
80105d57:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105d5a:	83 c4 10             	add    $0x10,%esp
80105d5d:	31 c0                	xor    %eax,%eax
}
80105d5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d62:	5b                   	pop    %ebx
80105d63:	5e                   	pop    %esi
80105d64:	5d                   	pop    %ebp
80105d65:	c3                   	ret    
80105d66:	8d 76 00             	lea    0x0(%esi),%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105d70:	83 ec 0c             	sub    $0xc,%esp
80105d73:	53                   	push   %ebx
80105d74:	e8 37 bf ff ff       	call   80101cb0 <iunlockput>
    end_op();
80105d79:	e8 42 d6 ff ff       	call   801033c0 <end_op>
    return -1;
80105d7e:	83 c4 10             	add    $0x10,%esp
80105d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d86:	eb d7                	jmp    80105d5f <sys_chdir+0x6f>
80105d88:	90                   	nop
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105d90:	e8 2b d6 ff ff       	call   801033c0 <end_op>
    return -1;
80105d95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d9a:	eb c3                	jmp    80105d5f <sys_chdir+0x6f>
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105da0 <sys_exec>:

int
sys_exec(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	57                   	push   %edi
80105da4:	56                   	push   %esi
80105da5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105da6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105dac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105db2:	50                   	push   %eax
80105db3:	6a 00                	push   $0x0
80105db5:	e8 f6 f4 ff ff       	call   801052b0 <argstr>
80105dba:	83 c4 10             	add    $0x10,%esp
80105dbd:	85 c0                	test   %eax,%eax
80105dbf:	0f 88 87 00 00 00    	js     80105e4c <sys_exec+0xac>
80105dc5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105dcb:	83 ec 08             	sub    $0x8,%esp
80105dce:	50                   	push   %eax
80105dcf:	6a 01                	push   $0x1
80105dd1:	e8 2a f4 ff ff       	call   80105200 <argint>
80105dd6:	83 c4 10             	add    $0x10,%esp
80105dd9:	85 c0                	test   %eax,%eax
80105ddb:	78 6f                	js     80105e4c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105ddd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105de3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105de6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105de8:	68 80 00 00 00       	push   $0x80
80105ded:	6a 00                	push   $0x0
80105def:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105df5:	50                   	push   %eax
80105df6:	e8 05 f1 ff ff       	call   80104f00 <memset>
80105dfb:	83 c4 10             	add    $0x10,%esp
80105dfe:	eb 2c                	jmp    80105e2c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105e00:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105e06:	85 c0                	test   %eax,%eax
80105e08:	74 56                	je     80105e60 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e0a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105e10:	83 ec 08             	sub    $0x8,%esp
80105e13:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105e16:	52                   	push   %edx
80105e17:	50                   	push   %eax
80105e18:	e8 73 f3 ff ff       	call   80105190 <fetchstr>
80105e1d:	83 c4 10             	add    $0x10,%esp
80105e20:	85 c0                	test   %eax,%eax
80105e22:	78 28                	js     80105e4c <sys_exec+0xac>
  for(i=0;; i++){
80105e24:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105e27:	83 fb 20             	cmp    $0x20,%ebx
80105e2a:	74 20                	je     80105e4c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105e2c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105e32:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105e39:	83 ec 08             	sub    $0x8,%esp
80105e3c:	57                   	push   %edi
80105e3d:	01 f0                	add    %esi,%eax
80105e3f:	50                   	push   %eax
80105e40:	e8 0b f3 ff ff       	call   80105150 <fetchint>
80105e45:	83 c4 10             	add    $0x10,%esp
80105e48:	85 c0                	test   %eax,%eax
80105e4a:	79 b4                	jns    80105e00 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105e4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e54:	5b                   	pop    %ebx
80105e55:	5e                   	pop    %esi
80105e56:	5f                   	pop    %edi
80105e57:	5d                   	pop    %ebp
80105e58:	c3                   	ret    
80105e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105e60:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105e66:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105e69:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e70:	00 00 00 00 
  return exec(path, argv);
80105e74:	50                   	push   %eax
80105e75:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105e7b:	e8 20 ac ff ff       	call   80100aa0 <exec>
80105e80:	83 c4 10             	add    $0x10,%esp
}
80105e83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e86:	5b                   	pop    %ebx
80105e87:	5e                   	pop    %esi
80105e88:	5f                   	pop    %edi
80105e89:	5d                   	pop    %ebp
80105e8a:	c3                   	ret    
80105e8b:	90                   	nop
80105e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e90 <sys_pipe>:

int
sys_pipe(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	57                   	push   %edi
80105e94:	56                   	push   %esi
80105e95:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e96:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e99:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e9c:	6a 08                	push   $0x8
80105e9e:	50                   	push   %eax
80105e9f:	6a 00                	push   $0x0
80105ea1:	e8 aa f3 ff ff       	call   80105250 <argptr>
80105ea6:	83 c4 10             	add    $0x10,%esp
80105ea9:	85 c0                	test   %eax,%eax
80105eab:	0f 88 ae 00 00 00    	js     80105f5f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105eb1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105eb4:	83 ec 08             	sub    $0x8,%esp
80105eb7:	50                   	push   %eax
80105eb8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ebb:	50                   	push   %eax
80105ebc:	e8 2f db ff ff       	call   801039f0 <pipealloc>
80105ec1:	83 c4 10             	add    $0x10,%esp
80105ec4:	85 c0                	test   %eax,%eax
80105ec6:	0f 88 93 00 00 00    	js     80105f5f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ecc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105ecf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105ed1:	e8 3a e1 ff ff       	call   80104010 <myproc>
80105ed6:	eb 10                	jmp    80105ee8 <sys_pipe+0x58>
80105ed8:	90                   	nop
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105ee0:	83 c3 01             	add    $0x1,%ebx
80105ee3:	83 fb 10             	cmp    $0x10,%ebx
80105ee6:	74 60                	je     80105f48 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105ee8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105eec:	85 f6                	test   %esi,%esi
80105eee:	75 f0                	jne    80105ee0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105ef0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ef3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ef7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105efa:	e8 11 e1 ff ff       	call   80104010 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105eff:	31 d2                	xor    %edx,%edx
80105f01:	eb 0d                	jmp    80105f10 <sys_pipe+0x80>
80105f03:	90                   	nop
80105f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f08:	83 c2 01             	add    $0x1,%edx
80105f0b:	83 fa 10             	cmp    $0x10,%edx
80105f0e:	74 28                	je     80105f38 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105f10:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105f14:	85 c9                	test   %ecx,%ecx
80105f16:	75 f0                	jne    80105f08 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105f18:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105f1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f1f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105f21:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f24:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105f27:	31 c0                	xor    %eax,%eax
}
80105f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f2c:	5b                   	pop    %ebx
80105f2d:	5e                   	pop    %esi
80105f2e:	5f                   	pop    %edi
80105f2f:	5d                   	pop    %ebp
80105f30:	c3                   	ret    
80105f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105f38:	e8 d3 e0 ff ff       	call   80104010 <myproc>
80105f3d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105f44:	00 
80105f45:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105f48:	83 ec 0c             	sub    $0xc,%esp
80105f4b:	ff 75 e0             	pushl  -0x20(%ebp)
80105f4e:	e8 8d b2 ff ff       	call   801011e0 <fileclose>
    fileclose(wf);
80105f53:	58                   	pop    %eax
80105f54:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f57:	e8 84 b2 ff ff       	call   801011e0 <fileclose>
    return -1;
80105f5c:	83 c4 10             	add    $0x10,%esp
80105f5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f64:	eb c3                	jmp    80105f29 <sys_pipe+0x99>
80105f66:	66 90                	xchg   %ax,%ax
80105f68:	66 90                	xchg   %ax,%ax
80105f6a:	66 90                	xchg   %ax,%ax
80105f6c:	66 90                	xchg   %ax,%ax
80105f6e:	66 90                	xchg   %ax,%ax

80105f70 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105f73:	5d                   	pop    %ebp
  return fork();
80105f74:	e9 67 e2 ff ff       	jmp    801041e0 <fork>
80105f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f80 <sys_exit>:

int
sys_exit(void)
{
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f86:	e8 55 e6 ff ff       	call   801045e0 <exit>
  return 0;  // not reached
}
80105f8b:	31 c0                	xor    %eax,%eax
80105f8d:	c9                   	leave  
80105f8e:	c3                   	ret    
80105f8f:	90                   	nop

80105f90 <sys_wait>:

int
sys_wait(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105f93:	5d                   	pop    %ebp
  return wait();
80105f94:	e9 97 e8 ff ff       	jmp    80104830 <wait>
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fa0 <sys_kill>:

int
sys_kill(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105fa6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fa9:	50                   	push   %eax
80105faa:	6a 00                	push   $0x0
80105fac:	e8 4f f2 ff ff       	call   80105200 <argint>
80105fb1:	83 c4 10             	add    $0x10,%esp
80105fb4:	85 c0                	test   %eax,%eax
80105fb6:	78 18                	js     80105fd0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105fb8:	83 ec 0c             	sub    $0xc,%esp
80105fbb:	ff 75 f4             	pushl  -0xc(%ebp)
80105fbe:	e8 5d ea ff ff       	call   80104a20 <kill>
80105fc3:	83 c4 10             	add    $0x10,%esp
}
80105fc6:	c9                   	leave  
80105fc7:	c3                   	ret    
80105fc8:	90                   	nop
80105fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fd5:	c9                   	leave  
80105fd6:	c3                   	ret    
80105fd7:	89 f6                	mov    %esi,%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fe0 <sys_getpid>:

int
sys_getpid(void)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105fe6:	e8 25 e0 ff ff       	call   80104010 <myproc>
80105feb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105fee:	c9                   	leave  
80105fef:	c3                   	ret    

80105ff0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ff4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ff7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105ffa:	50                   	push   %eax
80105ffb:	6a 00                	push   $0x0
80105ffd:	e8 fe f1 ff ff       	call   80105200 <argint>
80106002:	83 c4 10             	add    $0x10,%esp
80106005:	85 c0                	test   %eax,%eax
80106007:	78 27                	js     80106030 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106009:	e8 02 e0 ff ff       	call   80104010 <myproc>
  if(growproc(n) < 0)
8010600e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106011:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106013:	ff 75 f4             	pushl  -0xc(%ebp)
80106016:	e8 15 e1 ff ff       	call   80104130 <growproc>
8010601b:	83 c4 10             	add    $0x10,%esp
8010601e:	85 c0                	test   %eax,%eax
80106020:	78 0e                	js     80106030 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106022:	89 d8                	mov    %ebx,%eax
80106024:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106027:	c9                   	leave  
80106028:	c3                   	ret    
80106029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106030:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106035:	eb eb                	jmp    80106022 <sys_sbrk+0x32>
80106037:	89 f6                	mov    %esi,%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106040 <sys_sleep>:

int
sys_sleep(void)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106044:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106047:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010604a:	50                   	push   %eax
8010604b:	6a 00                	push   $0x0
8010604d:	e8 ae f1 ff ff       	call   80105200 <argint>
80106052:	83 c4 10             	add    $0x10,%esp
80106055:	85 c0                	test   %eax,%eax
80106057:	0f 88 8a 00 00 00    	js     801060e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010605d:	83 ec 0c             	sub    $0xc,%esp
80106060:	68 e0 11 13 80       	push   $0x801311e0
80106065:	e8 86 ed ff ff       	call   80104df0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010606a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010606d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106070:	8b 1d 20 1a 13 80    	mov    0x80131a20,%ebx
  while(ticks - ticks0 < n){
80106076:	85 d2                	test   %edx,%edx
80106078:	75 27                	jne    801060a1 <sys_sleep+0x61>
8010607a:	eb 54                	jmp    801060d0 <sys_sleep+0x90>
8010607c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106080:	83 ec 08             	sub    $0x8,%esp
80106083:	68 e0 11 13 80       	push   $0x801311e0
80106088:	68 20 1a 13 80       	push   $0x80131a20
8010608d:	e8 de e6 ff ff       	call   80104770 <sleep>
  while(ticks - ticks0 < n){
80106092:	a1 20 1a 13 80       	mov    0x80131a20,%eax
80106097:	83 c4 10             	add    $0x10,%esp
8010609a:	29 d8                	sub    %ebx,%eax
8010609c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010609f:	73 2f                	jae    801060d0 <sys_sleep+0x90>
    if(myproc()->killed){
801060a1:	e8 6a df ff ff       	call   80104010 <myproc>
801060a6:	8b 40 24             	mov    0x24(%eax),%eax
801060a9:	85 c0                	test   %eax,%eax
801060ab:	74 d3                	je     80106080 <sys_sleep+0x40>
      release(&tickslock);
801060ad:	83 ec 0c             	sub    $0xc,%esp
801060b0:	68 e0 11 13 80       	push   $0x801311e0
801060b5:	e8 f6 ed ff ff       	call   80104eb0 <release>
      return -1;
801060ba:	83 c4 10             	add    $0x10,%esp
801060bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801060c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060c5:	c9                   	leave  
801060c6:	c3                   	ret    
801060c7:	89 f6                	mov    %esi,%esi
801060c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801060d0:	83 ec 0c             	sub    $0xc,%esp
801060d3:	68 e0 11 13 80       	push   $0x801311e0
801060d8:	e8 d3 ed ff ff       	call   80104eb0 <release>
  return 0;
801060dd:	83 c4 10             	add    $0x10,%esp
801060e0:	31 c0                	xor    %eax,%eax
}
801060e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060e5:	c9                   	leave  
801060e6:	c3                   	ret    
    return -1;
801060e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ec:	eb f4                	jmp    801060e2 <sys_sleep+0xa2>
801060ee:	66 90                	xchg   %ax,%ax

801060f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	53                   	push   %ebx
801060f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801060f7:	68 e0 11 13 80       	push   $0x801311e0
801060fc:	e8 ef ec ff ff       	call   80104df0 <acquire>
  xticks = ticks;
80106101:	8b 1d 20 1a 13 80    	mov    0x80131a20,%ebx
  release(&tickslock);
80106107:	c7 04 24 e0 11 13 80 	movl   $0x801311e0,(%esp)
8010610e:	e8 9d ed ff ff       	call   80104eb0 <release>
  return xticks;
}
80106113:	89 d8                	mov    %ebx,%eax
80106115:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106118:	c9                   	leave  
80106119:	c3                   	ret    
8010611a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106120 <sys_get_number_of_free_pages>:

int sys_get_number_of_free_pages(void){
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
  return sys_get_number_of_free_pages_impl();
}
80106123:	5d                   	pop    %ebp
  return sys_get_number_of_free_pages_impl();
80106124:	e9 87 e0 ff ff       	jmp    801041b0 <sys_get_number_of_free_pages_impl>

80106129 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106129:	1e                   	push   %ds
  pushl %es
8010612a:	06                   	push   %es
  pushl %fs
8010612b:	0f a0                	push   %fs
  pushl %gs
8010612d:	0f a8                	push   %gs
  pushal
8010612f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106130:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106134:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106136:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106138:	54                   	push   %esp
  call trap
80106139:	e8 c2 00 00 00       	call   80106200 <trap>
  addl $4, %esp
8010613e:	83 c4 04             	add    $0x4,%esp

80106141 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106141:	61                   	popa   
  popl %gs
80106142:	0f a9                	pop    %gs
  popl %fs
80106144:	0f a1                	pop    %fs
  popl %es
80106146:	07                   	pop    %es
  popl %ds
80106147:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106148:	83 c4 08             	add    $0x8,%esp
  iret
8010614b:	cf                   	iret   
8010614c:	66 90                	xchg   %ax,%ax
8010614e:	66 90                	xchg   %ax,%ax

80106150 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106150:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106151:	31 c0                	xor    %eax,%eax
{
80106153:	89 e5                	mov    %esp,%ebp
80106155:	83 ec 08             	sub    $0x8,%esp
80106158:	90                   	nop
80106159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106160:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106167:	c7 04 c5 22 12 13 80 	movl   $0x8e000008,-0x7fecedde(,%eax,8)
8010616e:	08 00 00 8e 
80106172:	66 89 14 c5 20 12 13 	mov    %dx,-0x7fecede0(,%eax,8)
80106179:	80 
8010617a:	c1 ea 10             	shr    $0x10,%edx
8010617d:	66 89 14 c5 26 12 13 	mov    %dx,-0x7fecedda(,%eax,8)
80106184:	80 
  for(i = 0; i < 256; i++)
80106185:	83 c0 01             	add    $0x1,%eax
80106188:	3d 00 01 00 00       	cmp    $0x100,%eax
8010618d:	75 d1                	jne    80106160 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010618f:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
80106194:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106197:	c7 05 22 14 13 80 08 	movl   $0xef000008,0x80131422
8010619e:	00 00 ef 
  initlock(&tickslock, "time");
801061a1:	68 f9 8d 10 80       	push   $0x80108df9
801061a6:	68 e0 11 13 80       	push   $0x801311e0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061ab:	66 a3 20 14 13 80    	mov    %ax,0x80131420
801061b1:	c1 e8 10             	shr    $0x10,%eax
801061b4:	66 a3 26 14 13 80    	mov    %ax,0x80131426
  initlock(&tickslock, "time");
801061ba:	e8 f1 ea ff ff       	call   80104cb0 <initlock>
}
801061bf:	83 c4 10             	add    $0x10,%esp
801061c2:	c9                   	leave  
801061c3:	c3                   	ret    
801061c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801061ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801061d0 <idtinit>:

void
idtinit(void)
{
801061d0:	55                   	push   %ebp
  pd[0] = size-1;
801061d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061d6:	89 e5                	mov    %esp,%ebp
801061d8:	83 ec 10             	sub    $0x10,%esp
801061db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061df:	b8 20 12 13 80       	mov    $0x80131220,%eax
801061e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801061e8:	c1 e8 10             	shr    $0x10,%eax
801061eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801061ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801061f2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801061f5:	c9                   	leave  
801061f6:	c3                   	ret    
801061f7:	89 f6                	mov    %esi,%esi
801061f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106200 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106200:	55                   	push   %ebp
80106201:	89 e5                	mov    %esp,%ebp
80106203:	57                   	push   %edi
80106204:	56                   	push   %esi
80106205:	53                   	push   %ebx
80106206:	83 ec 1c             	sub    $0x1c,%esp
80106209:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010620c:	8b 47 30             	mov    0x30(%edi),%eax
8010620f:	83 f8 40             	cmp    $0x40,%eax
80106212:	0f 84 38 01 00 00    	je     80106350 <trap+0x150>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106218:	83 e8 0e             	sub    $0xe,%eax
8010621b:	83 f8 31             	cmp    $0x31,%eax
8010621e:	0f 87 0c 02 00 00    	ja     80106430 <trap+0x230>
80106224:	ff 24 85 cc 8e 10 80 	jmp    *-0x7fef7134(,%eax,4)
8010622b:	90                   	nop
8010622c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106230:	0f 20 d3             	mov    %cr2,%ebx

  case T_PGFLT:
  ;
    
    uint faulting_addr = rcr2();
    struct proc* p = myproc();
80106233:	e8 d8 dd ff ff       	call   80104010 <myproc>
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80106238:	83 ec 04             	sub    $0x4,%esp
    struct proc* p = myproc();
8010623b:	89 c6                	mov    %eax,%esi
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
8010623d:	6a 00                	push   $0x0
8010623f:	53                   	push   %ebx
80106240:	ff 70 04             	pushl  0x4(%eax)
80106243:	e8 c8 14 00 00       	call   80107710 <public_walkpgdir>
    if (!(pte_ptr == 0) && (*pte_ptr & PTE_U) && (*pte_ptr & PTE_PG)){
80106248:	83 c4 10             	add    $0x10,%esp
8010624b:	85 c0                	test   %eax,%eax
8010624d:	0f 84 dd 01 00 00    	je     80106430 <trap+0x230>
80106253:	8b 10                	mov    (%eax),%edx
80106255:	89 d1                	mov    %edx,%ecx
80106257:	81 e1 04 02 00 00    	and    $0x204,%ecx
8010625d:	81 f9 04 02 00 00    	cmp    $0x204,%ecx
80106263:	0f 84 57 02 00 00    	je     801064c0 <trap+0x2c0>
        }
      }
      p->num_of_pagefaults_occurs++;
      break;
    }
    if (!(pte_ptr == 0) && *pte_ptr & PTE_COW){
80106269:	80 e6 08             	and    $0x8,%dh
8010626c:	0f 84 be 01 00 00    	je     80106430 <trap+0x230>
      // cprintf("trap %d\n", p->pid);
      acquire(cow_lock);
80106272:	83 ec 0c             	sub    $0xc,%esp
80106275:	ff 35 40 ff 11 80    	pushl  0x8011ff40
8010627b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010627e:	e8 6d eb ff ff       	call   80104df0 <acquire>
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
80106283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      if (*ref_count == 1){
80106286:	83 c4 10             	add    $0x10,%esp
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
80106289:	8b 18                	mov    (%eax),%ebx
8010628b:	89 d9                	mov    %ebx,%ecx
8010628d:	c1 e9 0c             	shr    $0xc,%ecx
      if (*ref_count == 1){
80106290:	0f b6 91 40 1f 11 80 	movzbl -0x7feee0c0(%ecx),%edx
80106297:	80 fa 01             	cmp    $0x1,%dl
8010629a:	0f 84 a4 02 00 00    	je     80106544 <trap+0x344>
801062a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        *pte_ptr &= (~PTE_COW);
        // cprintf("rel trap %d\n", p->pid);
        release(cow_lock);
        break;
      }
      else if (*ref_count > 1){
801062a3:	0f 8e e1 02 00 00    	jle    8010658a <trap+0x38a>
        (*ref_count)--;
        // cprintf("rel trap %d\n", p->pid);
        release(cow_lock);
801062a9:	83 ec 0c             	sub    $0xc,%esp
801062ac:	ff 35 40 ff 11 80    	pushl  0x8011ff40
        (*ref_count)--;
801062b2:	83 ea 01             	sub    $0x1,%edx
801062b5:	88 91 40 1f 11 80    	mov    %dl,-0x7feee0c0(%ecx)
        release(cow_lock);
801062bb:	e8 f0 eb ff ff       	call   80104eb0 <release>
        int result = copy_page(p->pgdir, pte_ptr);
801062c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062c3:	59                   	pop    %ecx
801062c4:	5b                   	pop    %ebx
801062c5:	50                   	push   %eax
801062c6:	ff 76 04             	pushl  0x4(%esi)
801062c9:	e8 d2 22 00 00       	call   801085a0 <copy_page>
        if (result < 0){
801062ce:	83 c4 10             	add    $0x10,%esp
801062d1:	85 c0                	test   %eax,%eax
801062d3:	79 13                	jns    801062e8 <trap+0xe8>
          p->killed = 1;
801062d5:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
          exit();
801062dc:	e8 ff e2 ff ff       	call   801045e0 <exit>
801062e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062e8:	e8 23 dd ff ff       	call   80104010 <myproc>
801062ed:	85 c0                	test   %eax,%eax
801062ef:	74 1d                	je     8010630e <trap+0x10e>
801062f1:	e8 1a dd ff ff       	call   80104010 <myproc>
801062f6:	8b 50 24             	mov    0x24(%eax),%edx
801062f9:	85 d2                	test   %edx,%edx
801062fb:	74 11                	je     8010630e <trap+0x10e>
801062fd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106301:	83 e0 03             	and    $0x3,%eax
80106304:	66 83 f8 03          	cmp    $0x3,%ax
80106308:	0f 84 a2 01 00 00    	je     801064b0 <trap+0x2b0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
8010630e:	e8 fd dc ff ff       	call   80104010 <myproc>
80106313:	85 c0                	test   %eax,%eax
80106315:	74 0b                	je     80106322 <trap+0x122>
80106317:	e8 f4 dc ff ff       	call   80104010 <myproc>
8010631c:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106320:	74 66                	je     80106388 <trap+0x188>
      yield();
    }
    

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106322:	e8 e9 dc ff ff       	call   80104010 <myproc>
80106327:	85 c0                	test   %eax,%eax
80106329:	74 19                	je     80106344 <trap+0x144>
8010632b:	e8 e0 dc ff ff       	call   80104010 <myproc>
80106330:	8b 40 24             	mov    0x24(%eax),%eax
80106333:	85 c0                	test   %eax,%eax
80106335:	74 0d                	je     80106344 <trap+0x144>
80106337:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
8010633b:	83 e0 03             	and    $0x3,%eax
8010633e:	66 83 f8 03          	cmp    $0x3,%ax
80106342:	74 35                	je     80106379 <trap+0x179>
    exit();
}
80106344:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106347:	5b                   	pop    %ebx
80106348:	5e                   	pop    %esi
80106349:	5f                   	pop    %edi
8010634a:	5d                   	pop    %ebp
8010634b:	c3                   	ret    
8010634c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106350:	e8 bb dc ff ff       	call   80104010 <myproc>
80106355:	8b 40 24             	mov    0x24(%eax),%eax
80106358:	85 c0                	test   %eax,%eax
8010635a:	0f 85 c0 00 00 00    	jne    80106420 <trap+0x220>
    myproc()->tf = tf;
80106360:	e8 ab dc ff ff       	call   80104010 <myproc>
80106365:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106368:	e8 83 ef ff ff       	call   801052f0 <syscall>
    if(myproc()->killed)
8010636d:	e8 9e dc ff ff       	call   80104010 <myproc>
80106372:	8b 70 24             	mov    0x24(%eax),%esi
80106375:	85 f6                	test   %esi,%esi
80106377:	74 cb                	je     80106344 <trap+0x144>
}
80106379:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010637c:	5b                   	pop    %ebx
8010637d:	5e                   	pop    %esi
8010637e:	5f                   	pop    %edi
8010637f:	5d                   	pop    %ebp
      exit();
80106380:	e9 5b e2 ff ff       	jmp    801045e0 <exit>
80106385:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106388:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010638c:	75 94                	jne    80106322 <trap+0x122>
      yield();
8010638e:	e8 8d e3 ff ff       	call   80104720 <yield>
80106393:	eb 8d                	jmp    80106322 <trap+0x122>
80106395:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106398:	e8 53 dc ff ff       	call   80103ff0 <cpuid>
8010639d:	85 c0                	test   %eax,%eax
8010639f:	0f 84 6b 01 00 00    	je     80106510 <trap+0x310>
    lapiceoi();
801063a5:	e8 56 cb ff ff       	call   80102f00 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063aa:	e8 61 dc ff ff       	call   80104010 <myproc>
801063af:	85 c0                	test   %eax,%eax
801063b1:	0f 85 3a ff ff ff    	jne    801062f1 <trap+0xf1>
801063b7:	e9 52 ff ff ff       	jmp    8010630e <trap+0x10e>
801063bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801063c0:	e8 4b 03 00 00       	call   80106710 <uartintr>
    lapiceoi();
801063c5:	e8 36 cb ff ff       	call   80102f00 <lapiceoi>
    break;
801063ca:	e9 19 ff ff ff       	jmp    801062e8 <trap+0xe8>
801063cf:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801063d0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801063d4:	8b 77 38             	mov    0x38(%edi),%esi
801063d7:	e8 14 dc ff ff       	call   80103ff0 <cpuid>
801063dc:	56                   	push   %esi
801063dd:	53                   	push   %ebx
801063de:	50                   	push   %eax
801063df:	68 04 8e 10 80       	push   $0x80108e04
801063e4:	e8 77 a2 ff ff       	call   80100660 <cprintf>
    lapiceoi();
801063e9:	e8 12 cb ff ff       	call   80102f00 <lapiceoi>
    break;
801063ee:	83 c4 10             	add    $0x10,%esp
801063f1:	e9 f2 fe ff ff       	jmp    801062e8 <trap+0xe8>
801063f6:	8d 76 00             	lea    0x0(%esi),%esi
801063f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106400:	e8 ab c3 ff ff       	call   801027b0 <ideintr>
80106405:	eb 9e                	jmp    801063a5 <trap+0x1a5>
80106407:	89 f6                	mov    %esi,%esi
80106409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    kbdintr();
80106410:	e8 ab c9 ff ff       	call   80102dc0 <kbdintr>
    lapiceoi();
80106415:	e8 e6 ca ff ff       	call   80102f00 <lapiceoi>
    break;
8010641a:	e9 c9 fe ff ff       	jmp    801062e8 <trap+0xe8>
8010641f:	90                   	nop
      exit();
80106420:	e8 bb e1 ff ff       	call   801045e0 <exit>
80106425:	e9 36 ff ff ff       	jmp    80106360 <trap+0x160>
8010642a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106430:	e8 db db ff ff       	call   80104010 <myproc>
80106435:	85 c0                	test   %eax,%eax
80106437:	8b 5f 38             	mov    0x38(%edi),%ebx
8010643a:	0f 84 22 01 00 00    	je     80106562 <trap+0x362>
80106440:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106444:	0f 84 18 01 00 00    	je     80106562 <trap+0x362>
8010644a:	0f 20 d1             	mov    %cr2,%ecx
8010644d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106450:	e8 9b db ff ff       	call   80103ff0 <cpuid>
80106455:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106458:	8b 47 34             	mov    0x34(%edi),%eax
8010645b:	8b 77 30             	mov    0x30(%edi),%esi
8010645e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106461:	e8 aa db ff ff       	call   80104010 <myproc>
80106466:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106469:	e8 a2 db ff ff       	call   80104010 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010646e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106471:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106474:	51                   	push   %ecx
80106475:	53                   	push   %ebx
80106476:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106477:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010647a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010647d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010647e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106481:	52                   	push   %edx
80106482:	ff 70 10             	pushl  0x10(%eax)
80106485:	68 88 8e 10 80       	push   $0x80108e88
8010648a:	e8 d1 a1 ff ff       	call   80100660 <cprintf>
    myproc()->killed = 1;
8010648f:	83 c4 20             	add    $0x20,%esp
80106492:	e8 79 db ff ff       	call   80104010 <myproc>
80106497:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010649e:	e8 6d db ff ff       	call   80104010 <myproc>
801064a3:	85 c0                	test   %eax,%eax
801064a5:	0f 85 46 fe ff ff    	jne    801062f1 <trap+0xf1>
801064ab:	e9 5e fe ff ff       	jmp    8010630e <trap+0x10e>
    exit();
801064b0:	e8 2b e1 ff ff       	call   801045e0 <exit>
801064b5:	e9 54 fe ff ff       	jmp    8010630e <trap+0x10e>
801064ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801064c0:	8d 96 90 00 00 00    	lea    0x90(%esi),%edx
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
801064c6:	31 c0                	xor    %eax,%eax
801064c8:	eb 11                	jmp    801064db <trap+0x2db>
801064ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801064d0:	83 c0 01             	add    $0x1,%eax
801064d3:	83 c2 18             	add    $0x18,%edx
801064d6:	83 f8 10             	cmp    $0x10,%eax
801064d9:	74 23                	je     801064fe <trap+0x2fe>
        if (PGROUNDDOWN((uint)(p->swapped_out_pages[i].va)) == PGROUNDDOWN(faulting_addr)){
801064db:	8b 0a                	mov    (%edx),%ecx
801064dd:	31 d9                	xor    %ebx,%ecx
801064df:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
801064e5:	75 e9                	jne    801064d0 <trap+0x2d0>
          swap_page_back(p, &(p->swapped_out_pages[i]));
801064e7:	8d 04 40             	lea    (%eax,%eax,2),%eax
801064ea:	83 ec 08             	sub    $0x8,%esp
801064ed:	8d 84 c6 80 00 00 00 	lea    0x80(%esi,%eax,8),%eax
801064f4:	50                   	push   %eax
801064f5:	56                   	push   %esi
801064f6:	e8 75 1f 00 00       	call   80108470 <swap_page_back>
          break;
801064fb:	83 c4 10             	add    $0x10,%esp
      p->num_of_pagefaults_occurs++;
801064fe:	83 86 88 03 00 00 01 	addl   $0x1,0x388(%esi)
      break;
80106505:	e9 de fd ff ff       	jmp    801062e8 <trap+0xe8>
8010650a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106510:	83 ec 0c             	sub    $0xc,%esp
80106513:	68 e0 11 13 80       	push   $0x801311e0
80106518:	e8 d3 e8 ff ff       	call   80104df0 <acquire>
      wakeup(&ticks);
8010651d:	c7 04 24 20 1a 13 80 	movl   $0x80131a20,(%esp)
      ticks++;
80106524:	83 05 20 1a 13 80 01 	addl   $0x1,0x80131a20
      wakeup(&ticks);
8010652b:	e8 90 e4 ff ff       	call   801049c0 <wakeup>
      release(&tickslock);
80106530:	c7 04 24 e0 11 13 80 	movl   $0x801311e0,(%esp)
80106537:	e8 74 e9 ff ff       	call   80104eb0 <release>
8010653c:	83 c4 10             	add    $0x10,%esp
8010653f:	e9 61 fe ff ff       	jmp    801063a5 <trap+0x1a5>
        *pte_ptr &= (~PTE_COW);
80106544:	80 e7 f7             	and    $0xf7,%bh
        release(cow_lock);
80106547:	83 ec 0c             	sub    $0xc,%esp
        *pte_ptr &= (~PTE_COW);
8010654a:	83 cb 02             	or     $0x2,%ebx
8010654d:	89 18                	mov    %ebx,(%eax)
        release(cow_lock);
8010654f:	ff 35 40 ff 11 80    	pushl  0x8011ff40
80106555:	e8 56 e9 ff ff       	call   80104eb0 <release>
        break;
8010655a:	83 c4 10             	add    $0x10,%esp
8010655d:	e9 86 fd ff ff       	jmp    801062e8 <trap+0xe8>
80106562:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106565:	e8 86 da ff ff       	call   80103ff0 <cpuid>
8010656a:	83 ec 0c             	sub    $0xc,%esp
8010656d:	56                   	push   %esi
8010656e:	53                   	push   %ebx
8010656f:	50                   	push   %eax
80106570:	ff 77 30             	pushl  0x30(%edi)
80106573:	68 54 8e 10 80       	push   $0x80108e54
80106578:	e8 e3 a0 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010657d:	83 c4 14             	add    $0x14,%esp
80106580:	68 fe 8d 10 80       	push   $0x80108dfe
80106585:	e8 06 9e ff ff       	call   80100390 <panic>
        panic("ref count to page is 0 but it was reffed");
8010658a:	83 ec 0c             	sub    $0xc,%esp
8010658d:	68 28 8e 10 80       	push   $0x80108e28
80106592:	e8 f9 9d ff ff       	call   80100390 <panic>
80106597:	66 90                	xchg   %ax,%ax
80106599:	66 90                	xchg   %ax,%ax
8010659b:	66 90                	xchg   %ax,%ax
8010659d:	66 90                	xchg   %ax,%ax
8010659f:	90                   	nop

801065a0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801065a0:	a1 bc c5 10 80       	mov    0x8010c5bc,%eax
{
801065a5:	55                   	push   %ebp
801065a6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801065a8:	85 c0                	test   %eax,%eax
801065aa:	74 1c                	je     801065c8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065ac:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065b1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801065b2:	a8 01                	test   $0x1,%al
801065b4:	74 12                	je     801065c8 <uartgetc+0x28>
801065b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065bb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801065bc:	0f b6 c0             	movzbl %al,%eax
}
801065bf:	5d                   	pop    %ebp
801065c0:	c3                   	ret    
801065c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801065c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065cd:	5d                   	pop    %ebp
801065ce:	c3                   	ret    
801065cf:	90                   	nop

801065d0 <uartputc.part.0>:
uartputc(int c)
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	57                   	push   %edi
801065d4:	56                   	push   %esi
801065d5:	53                   	push   %ebx
801065d6:	89 c7                	mov    %eax,%edi
801065d8:	bb 80 00 00 00       	mov    $0x80,%ebx
801065dd:	be fd 03 00 00       	mov    $0x3fd,%esi
801065e2:	83 ec 0c             	sub    $0xc,%esp
801065e5:	eb 1b                	jmp    80106602 <uartputc.part.0+0x32>
801065e7:	89 f6                	mov    %esi,%esi
801065e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801065f0:	83 ec 0c             	sub    $0xc,%esp
801065f3:	6a 0a                	push   $0xa
801065f5:	e8 26 c9 ff ff       	call   80102f20 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065fa:	83 c4 10             	add    $0x10,%esp
801065fd:	83 eb 01             	sub    $0x1,%ebx
80106600:	74 07                	je     80106609 <uartputc.part.0+0x39>
80106602:	89 f2                	mov    %esi,%edx
80106604:	ec                   	in     (%dx),%al
80106605:	a8 20                	test   $0x20,%al
80106607:	74 e7                	je     801065f0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106609:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010660e:	89 f8                	mov    %edi,%eax
80106610:	ee                   	out    %al,(%dx)
}
80106611:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106614:	5b                   	pop    %ebx
80106615:	5e                   	pop    %esi
80106616:	5f                   	pop    %edi
80106617:	5d                   	pop    %ebp
80106618:	c3                   	ret    
80106619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106620 <uartinit>:
{
80106620:	55                   	push   %ebp
80106621:	31 c9                	xor    %ecx,%ecx
80106623:	89 c8                	mov    %ecx,%eax
80106625:	89 e5                	mov    %esp,%ebp
80106627:	57                   	push   %edi
80106628:	56                   	push   %esi
80106629:	53                   	push   %ebx
8010662a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010662f:	89 da                	mov    %ebx,%edx
80106631:	83 ec 0c             	sub    $0xc,%esp
80106634:	ee                   	out    %al,(%dx)
80106635:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010663a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010663f:	89 fa                	mov    %edi,%edx
80106641:	ee                   	out    %al,(%dx)
80106642:	b8 0c 00 00 00       	mov    $0xc,%eax
80106647:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010664c:	ee                   	out    %al,(%dx)
8010664d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106652:	89 c8                	mov    %ecx,%eax
80106654:	89 f2                	mov    %esi,%edx
80106656:	ee                   	out    %al,(%dx)
80106657:	b8 03 00 00 00       	mov    $0x3,%eax
8010665c:	89 fa                	mov    %edi,%edx
8010665e:	ee                   	out    %al,(%dx)
8010665f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106664:	89 c8                	mov    %ecx,%eax
80106666:	ee                   	out    %al,(%dx)
80106667:	b8 01 00 00 00       	mov    $0x1,%eax
8010666c:	89 f2                	mov    %esi,%edx
8010666e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010666f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106674:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106675:	3c ff                	cmp    $0xff,%al
80106677:	74 5a                	je     801066d3 <uartinit+0xb3>
  uart = 1;
80106679:	c7 05 bc c5 10 80 01 	movl   $0x1,0x8010c5bc
80106680:	00 00 00 
80106683:	89 da                	mov    %ebx,%edx
80106685:	ec                   	in     (%dx),%al
80106686:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010668b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010668c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010668f:	bb 94 8f 10 80       	mov    $0x80108f94,%ebx
  ioapicenable(IRQ_COM1, 0);
80106694:	6a 00                	push   $0x0
80106696:	6a 04                	push   $0x4
80106698:	e8 63 c3 ff ff       	call   80102a00 <ioapicenable>
8010669d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801066a0:	b8 78 00 00 00       	mov    $0x78,%eax
801066a5:	eb 13                	jmp    801066ba <uartinit+0x9a>
801066a7:	89 f6                	mov    %esi,%esi
801066a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801066b0:	83 c3 01             	add    $0x1,%ebx
801066b3:	0f be 03             	movsbl (%ebx),%eax
801066b6:	84 c0                	test   %al,%al
801066b8:	74 19                	je     801066d3 <uartinit+0xb3>
  if(!uart)
801066ba:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
801066c0:	85 d2                	test   %edx,%edx
801066c2:	74 ec                	je     801066b0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801066c4:	83 c3 01             	add    $0x1,%ebx
801066c7:	e8 04 ff ff ff       	call   801065d0 <uartputc.part.0>
801066cc:	0f be 03             	movsbl (%ebx),%eax
801066cf:	84 c0                	test   %al,%al
801066d1:	75 e7                	jne    801066ba <uartinit+0x9a>
}
801066d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066d6:	5b                   	pop    %ebx
801066d7:	5e                   	pop    %esi
801066d8:	5f                   	pop    %edi
801066d9:	5d                   	pop    %ebp
801066da:	c3                   	ret    
801066db:	90                   	nop
801066dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801066e0 <uartputc>:
  if(!uart)
801066e0:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
{
801066e6:	55                   	push   %ebp
801066e7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801066e9:	85 d2                	test   %edx,%edx
{
801066eb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801066ee:	74 10                	je     80106700 <uartputc+0x20>
}
801066f0:	5d                   	pop    %ebp
801066f1:	e9 da fe ff ff       	jmp    801065d0 <uartputc.part.0>
801066f6:	8d 76 00             	lea    0x0(%esi),%esi
801066f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106700:	5d                   	pop    %ebp
80106701:	c3                   	ret    
80106702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106710 <uartintr>:

void
uartintr(void)
{
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106716:	68 a0 65 10 80       	push   $0x801065a0
8010671b:	e8 f0 a0 ff ff       	call   80100810 <consoleintr>
}
80106720:	83 c4 10             	add    $0x10,%esp
80106723:	c9                   	leave  
80106724:	c3                   	ret    

80106725 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106725:	6a 00                	push   $0x0
  pushl $0
80106727:	6a 00                	push   $0x0
  jmp alltraps
80106729:	e9 fb f9 ff ff       	jmp    80106129 <alltraps>

8010672e <vector1>:
.globl vector1
vector1:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $1
80106730:	6a 01                	push   $0x1
  jmp alltraps
80106732:	e9 f2 f9 ff ff       	jmp    80106129 <alltraps>

80106737 <vector2>:
.globl vector2
vector2:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $2
80106739:	6a 02                	push   $0x2
  jmp alltraps
8010673b:	e9 e9 f9 ff ff       	jmp    80106129 <alltraps>

80106740 <vector3>:
.globl vector3
vector3:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $3
80106742:	6a 03                	push   $0x3
  jmp alltraps
80106744:	e9 e0 f9 ff ff       	jmp    80106129 <alltraps>

80106749 <vector4>:
.globl vector4
vector4:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $4
8010674b:	6a 04                	push   $0x4
  jmp alltraps
8010674d:	e9 d7 f9 ff ff       	jmp    80106129 <alltraps>

80106752 <vector5>:
.globl vector5
vector5:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $5
80106754:	6a 05                	push   $0x5
  jmp alltraps
80106756:	e9 ce f9 ff ff       	jmp    80106129 <alltraps>

8010675b <vector6>:
.globl vector6
vector6:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $6
8010675d:	6a 06                	push   $0x6
  jmp alltraps
8010675f:	e9 c5 f9 ff ff       	jmp    80106129 <alltraps>

80106764 <vector7>:
.globl vector7
vector7:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $7
80106766:	6a 07                	push   $0x7
  jmp alltraps
80106768:	e9 bc f9 ff ff       	jmp    80106129 <alltraps>

8010676d <vector8>:
.globl vector8
vector8:
  pushl $8
8010676d:	6a 08                	push   $0x8
  jmp alltraps
8010676f:	e9 b5 f9 ff ff       	jmp    80106129 <alltraps>

80106774 <vector9>:
.globl vector9
vector9:
  pushl $0
80106774:	6a 00                	push   $0x0
  pushl $9
80106776:	6a 09                	push   $0x9
  jmp alltraps
80106778:	e9 ac f9 ff ff       	jmp    80106129 <alltraps>

8010677d <vector10>:
.globl vector10
vector10:
  pushl $10
8010677d:	6a 0a                	push   $0xa
  jmp alltraps
8010677f:	e9 a5 f9 ff ff       	jmp    80106129 <alltraps>

80106784 <vector11>:
.globl vector11
vector11:
  pushl $11
80106784:	6a 0b                	push   $0xb
  jmp alltraps
80106786:	e9 9e f9 ff ff       	jmp    80106129 <alltraps>

8010678b <vector12>:
.globl vector12
vector12:
  pushl $12
8010678b:	6a 0c                	push   $0xc
  jmp alltraps
8010678d:	e9 97 f9 ff ff       	jmp    80106129 <alltraps>

80106792 <vector13>:
.globl vector13
vector13:
  pushl $13
80106792:	6a 0d                	push   $0xd
  jmp alltraps
80106794:	e9 90 f9 ff ff       	jmp    80106129 <alltraps>

80106799 <vector14>:
.globl vector14
vector14:
  pushl $14
80106799:	6a 0e                	push   $0xe
  jmp alltraps
8010679b:	e9 89 f9 ff ff       	jmp    80106129 <alltraps>

801067a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801067a0:	6a 00                	push   $0x0
  pushl $15
801067a2:	6a 0f                	push   $0xf
  jmp alltraps
801067a4:	e9 80 f9 ff ff       	jmp    80106129 <alltraps>

801067a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $16
801067ab:	6a 10                	push   $0x10
  jmp alltraps
801067ad:	e9 77 f9 ff ff       	jmp    80106129 <alltraps>

801067b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801067b2:	6a 11                	push   $0x11
  jmp alltraps
801067b4:	e9 70 f9 ff ff       	jmp    80106129 <alltraps>

801067b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801067b9:	6a 00                	push   $0x0
  pushl $18
801067bb:	6a 12                	push   $0x12
  jmp alltraps
801067bd:	e9 67 f9 ff ff       	jmp    80106129 <alltraps>

801067c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801067c2:	6a 00                	push   $0x0
  pushl $19
801067c4:	6a 13                	push   $0x13
  jmp alltraps
801067c6:	e9 5e f9 ff ff       	jmp    80106129 <alltraps>

801067cb <vector20>:
.globl vector20
vector20:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $20
801067cd:	6a 14                	push   $0x14
  jmp alltraps
801067cf:	e9 55 f9 ff ff       	jmp    80106129 <alltraps>

801067d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801067d4:	6a 00                	push   $0x0
  pushl $21
801067d6:	6a 15                	push   $0x15
  jmp alltraps
801067d8:	e9 4c f9 ff ff       	jmp    80106129 <alltraps>

801067dd <vector22>:
.globl vector22
vector22:
  pushl $0
801067dd:	6a 00                	push   $0x0
  pushl $22
801067df:	6a 16                	push   $0x16
  jmp alltraps
801067e1:	e9 43 f9 ff ff       	jmp    80106129 <alltraps>

801067e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801067e6:	6a 00                	push   $0x0
  pushl $23
801067e8:	6a 17                	push   $0x17
  jmp alltraps
801067ea:	e9 3a f9 ff ff       	jmp    80106129 <alltraps>

801067ef <vector24>:
.globl vector24
vector24:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $24
801067f1:	6a 18                	push   $0x18
  jmp alltraps
801067f3:	e9 31 f9 ff ff       	jmp    80106129 <alltraps>

801067f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801067f8:	6a 00                	push   $0x0
  pushl $25
801067fa:	6a 19                	push   $0x19
  jmp alltraps
801067fc:	e9 28 f9 ff ff       	jmp    80106129 <alltraps>

80106801 <vector26>:
.globl vector26
vector26:
  pushl $0
80106801:	6a 00                	push   $0x0
  pushl $26
80106803:	6a 1a                	push   $0x1a
  jmp alltraps
80106805:	e9 1f f9 ff ff       	jmp    80106129 <alltraps>

8010680a <vector27>:
.globl vector27
vector27:
  pushl $0
8010680a:	6a 00                	push   $0x0
  pushl $27
8010680c:	6a 1b                	push   $0x1b
  jmp alltraps
8010680e:	e9 16 f9 ff ff       	jmp    80106129 <alltraps>

80106813 <vector28>:
.globl vector28
vector28:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $28
80106815:	6a 1c                	push   $0x1c
  jmp alltraps
80106817:	e9 0d f9 ff ff       	jmp    80106129 <alltraps>

8010681c <vector29>:
.globl vector29
vector29:
  pushl $0
8010681c:	6a 00                	push   $0x0
  pushl $29
8010681e:	6a 1d                	push   $0x1d
  jmp alltraps
80106820:	e9 04 f9 ff ff       	jmp    80106129 <alltraps>

80106825 <vector30>:
.globl vector30
vector30:
  pushl $0
80106825:	6a 00                	push   $0x0
  pushl $30
80106827:	6a 1e                	push   $0x1e
  jmp alltraps
80106829:	e9 fb f8 ff ff       	jmp    80106129 <alltraps>

8010682e <vector31>:
.globl vector31
vector31:
  pushl $0
8010682e:	6a 00                	push   $0x0
  pushl $31
80106830:	6a 1f                	push   $0x1f
  jmp alltraps
80106832:	e9 f2 f8 ff ff       	jmp    80106129 <alltraps>

80106837 <vector32>:
.globl vector32
vector32:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $32
80106839:	6a 20                	push   $0x20
  jmp alltraps
8010683b:	e9 e9 f8 ff ff       	jmp    80106129 <alltraps>

80106840 <vector33>:
.globl vector33
vector33:
  pushl $0
80106840:	6a 00                	push   $0x0
  pushl $33
80106842:	6a 21                	push   $0x21
  jmp alltraps
80106844:	e9 e0 f8 ff ff       	jmp    80106129 <alltraps>

80106849 <vector34>:
.globl vector34
vector34:
  pushl $0
80106849:	6a 00                	push   $0x0
  pushl $34
8010684b:	6a 22                	push   $0x22
  jmp alltraps
8010684d:	e9 d7 f8 ff ff       	jmp    80106129 <alltraps>

80106852 <vector35>:
.globl vector35
vector35:
  pushl $0
80106852:	6a 00                	push   $0x0
  pushl $35
80106854:	6a 23                	push   $0x23
  jmp alltraps
80106856:	e9 ce f8 ff ff       	jmp    80106129 <alltraps>

8010685b <vector36>:
.globl vector36
vector36:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $36
8010685d:	6a 24                	push   $0x24
  jmp alltraps
8010685f:	e9 c5 f8 ff ff       	jmp    80106129 <alltraps>

80106864 <vector37>:
.globl vector37
vector37:
  pushl $0
80106864:	6a 00                	push   $0x0
  pushl $37
80106866:	6a 25                	push   $0x25
  jmp alltraps
80106868:	e9 bc f8 ff ff       	jmp    80106129 <alltraps>

8010686d <vector38>:
.globl vector38
vector38:
  pushl $0
8010686d:	6a 00                	push   $0x0
  pushl $38
8010686f:	6a 26                	push   $0x26
  jmp alltraps
80106871:	e9 b3 f8 ff ff       	jmp    80106129 <alltraps>

80106876 <vector39>:
.globl vector39
vector39:
  pushl $0
80106876:	6a 00                	push   $0x0
  pushl $39
80106878:	6a 27                	push   $0x27
  jmp alltraps
8010687a:	e9 aa f8 ff ff       	jmp    80106129 <alltraps>

8010687f <vector40>:
.globl vector40
vector40:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $40
80106881:	6a 28                	push   $0x28
  jmp alltraps
80106883:	e9 a1 f8 ff ff       	jmp    80106129 <alltraps>

80106888 <vector41>:
.globl vector41
vector41:
  pushl $0
80106888:	6a 00                	push   $0x0
  pushl $41
8010688a:	6a 29                	push   $0x29
  jmp alltraps
8010688c:	e9 98 f8 ff ff       	jmp    80106129 <alltraps>

80106891 <vector42>:
.globl vector42
vector42:
  pushl $0
80106891:	6a 00                	push   $0x0
  pushl $42
80106893:	6a 2a                	push   $0x2a
  jmp alltraps
80106895:	e9 8f f8 ff ff       	jmp    80106129 <alltraps>

8010689a <vector43>:
.globl vector43
vector43:
  pushl $0
8010689a:	6a 00                	push   $0x0
  pushl $43
8010689c:	6a 2b                	push   $0x2b
  jmp alltraps
8010689e:	e9 86 f8 ff ff       	jmp    80106129 <alltraps>

801068a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $44
801068a5:	6a 2c                	push   $0x2c
  jmp alltraps
801068a7:	e9 7d f8 ff ff       	jmp    80106129 <alltraps>

801068ac <vector45>:
.globl vector45
vector45:
  pushl $0
801068ac:	6a 00                	push   $0x0
  pushl $45
801068ae:	6a 2d                	push   $0x2d
  jmp alltraps
801068b0:	e9 74 f8 ff ff       	jmp    80106129 <alltraps>

801068b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801068b5:	6a 00                	push   $0x0
  pushl $46
801068b7:	6a 2e                	push   $0x2e
  jmp alltraps
801068b9:	e9 6b f8 ff ff       	jmp    80106129 <alltraps>

801068be <vector47>:
.globl vector47
vector47:
  pushl $0
801068be:	6a 00                	push   $0x0
  pushl $47
801068c0:	6a 2f                	push   $0x2f
  jmp alltraps
801068c2:	e9 62 f8 ff ff       	jmp    80106129 <alltraps>

801068c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $48
801068c9:	6a 30                	push   $0x30
  jmp alltraps
801068cb:	e9 59 f8 ff ff       	jmp    80106129 <alltraps>

801068d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801068d0:	6a 00                	push   $0x0
  pushl $49
801068d2:	6a 31                	push   $0x31
  jmp alltraps
801068d4:	e9 50 f8 ff ff       	jmp    80106129 <alltraps>

801068d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801068d9:	6a 00                	push   $0x0
  pushl $50
801068db:	6a 32                	push   $0x32
  jmp alltraps
801068dd:	e9 47 f8 ff ff       	jmp    80106129 <alltraps>

801068e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801068e2:	6a 00                	push   $0x0
  pushl $51
801068e4:	6a 33                	push   $0x33
  jmp alltraps
801068e6:	e9 3e f8 ff ff       	jmp    80106129 <alltraps>

801068eb <vector52>:
.globl vector52
vector52:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $52
801068ed:	6a 34                	push   $0x34
  jmp alltraps
801068ef:	e9 35 f8 ff ff       	jmp    80106129 <alltraps>

801068f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801068f4:	6a 00                	push   $0x0
  pushl $53
801068f6:	6a 35                	push   $0x35
  jmp alltraps
801068f8:	e9 2c f8 ff ff       	jmp    80106129 <alltraps>

801068fd <vector54>:
.globl vector54
vector54:
  pushl $0
801068fd:	6a 00                	push   $0x0
  pushl $54
801068ff:	6a 36                	push   $0x36
  jmp alltraps
80106901:	e9 23 f8 ff ff       	jmp    80106129 <alltraps>

80106906 <vector55>:
.globl vector55
vector55:
  pushl $0
80106906:	6a 00                	push   $0x0
  pushl $55
80106908:	6a 37                	push   $0x37
  jmp alltraps
8010690a:	e9 1a f8 ff ff       	jmp    80106129 <alltraps>

8010690f <vector56>:
.globl vector56
vector56:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $56
80106911:	6a 38                	push   $0x38
  jmp alltraps
80106913:	e9 11 f8 ff ff       	jmp    80106129 <alltraps>

80106918 <vector57>:
.globl vector57
vector57:
  pushl $0
80106918:	6a 00                	push   $0x0
  pushl $57
8010691a:	6a 39                	push   $0x39
  jmp alltraps
8010691c:	e9 08 f8 ff ff       	jmp    80106129 <alltraps>

80106921 <vector58>:
.globl vector58
vector58:
  pushl $0
80106921:	6a 00                	push   $0x0
  pushl $58
80106923:	6a 3a                	push   $0x3a
  jmp alltraps
80106925:	e9 ff f7 ff ff       	jmp    80106129 <alltraps>

8010692a <vector59>:
.globl vector59
vector59:
  pushl $0
8010692a:	6a 00                	push   $0x0
  pushl $59
8010692c:	6a 3b                	push   $0x3b
  jmp alltraps
8010692e:	e9 f6 f7 ff ff       	jmp    80106129 <alltraps>

80106933 <vector60>:
.globl vector60
vector60:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $60
80106935:	6a 3c                	push   $0x3c
  jmp alltraps
80106937:	e9 ed f7 ff ff       	jmp    80106129 <alltraps>

8010693c <vector61>:
.globl vector61
vector61:
  pushl $0
8010693c:	6a 00                	push   $0x0
  pushl $61
8010693e:	6a 3d                	push   $0x3d
  jmp alltraps
80106940:	e9 e4 f7 ff ff       	jmp    80106129 <alltraps>

80106945 <vector62>:
.globl vector62
vector62:
  pushl $0
80106945:	6a 00                	push   $0x0
  pushl $62
80106947:	6a 3e                	push   $0x3e
  jmp alltraps
80106949:	e9 db f7 ff ff       	jmp    80106129 <alltraps>

8010694e <vector63>:
.globl vector63
vector63:
  pushl $0
8010694e:	6a 00                	push   $0x0
  pushl $63
80106950:	6a 3f                	push   $0x3f
  jmp alltraps
80106952:	e9 d2 f7 ff ff       	jmp    80106129 <alltraps>

80106957 <vector64>:
.globl vector64
vector64:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $64
80106959:	6a 40                	push   $0x40
  jmp alltraps
8010695b:	e9 c9 f7 ff ff       	jmp    80106129 <alltraps>

80106960 <vector65>:
.globl vector65
vector65:
  pushl $0
80106960:	6a 00                	push   $0x0
  pushl $65
80106962:	6a 41                	push   $0x41
  jmp alltraps
80106964:	e9 c0 f7 ff ff       	jmp    80106129 <alltraps>

80106969 <vector66>:
.globl vector66
vector66:
  pushl $0
80106969:	6a 00                	push   $0x0
  pushl $66
8010696b:	6a 42                	push   $0x42
  jmp alltraps
8010696d:	e9 b7 f7 ff ff       	jmp    80106129 <alltraps>

80106972 <vector67>:
.globl vector67
vector67:
  pushl $0
80106972:	6a 00                	push   $0x0
  pushl $67
80106974:	6a 43                	push   $0x43
  jmp alltraps
80106976:	e9 ae f7 ff ff       	jmp    80106129 <alltraps>

8010697b <vector68>:
.globl vector68
vector68:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $68
8010697d:	6a 44                	push   $0x44
  jmp alltraps
8010697f:	e9 a5 f7 ff ff       	jmp    80106129 <alltraps>

80106984 <vector69>:
.globl vector69
vector69:
  pushl $0
80106984:	6a 00                	push   $0x0
  pushl $69
80106986:	6a 45                	push   $0x45
  jmp alltraps
80106988:	e9 9c f7 ff ff       	jmp    80106129 <alltraps>

8010698d <vector70>:
.globl vector70
vector70:
  pushl $0
8010698d:	6a 00                	push   $0x0
  pushl $70
8010698f:	6a 46                	push   $0x46
  jmp alltraps
80106991:	e9 93 f7 ff ff       	jmp    80106129 <alltraps>

80106996 <vector71>:
.globl vector71
vector71:
  pushl $0
80106996:	6a 00                	push   $0x0
  pushl $71
80106998:	6a 47                	push   $0x47
  jmp alltraps
8010699a:	e9 8a f7 ff ff       	jmp    80106129 <alltraps>

8010699f <vector72>:
.globl vector72
vector72:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $72
801069a1:	6a 48                	push   $0x48
  jmp alltraps
801069a3:	e9 81 f7 ff ff       	jmp    80106129 <alltraps>

801069a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801069a8:	6a 00                	push   $0x0
  pushl $73
801069aa:	6a 49                	push   $0x49
  jmp alltraps
801069ac:	e9 78 f7 ff ff       	jmp    80106129 <alltraps>

801069b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801069b1:	6a 00                	push   $0x0
  pushl $74
801069b3:	6a 4a                	push   $0x4a
  jmp alltraps
801069b5:	e9 6f f7 ff ff       	jmp    80106129 <alltraps>

801069ba <vector75>:
.globl vector75
vector75:
  pushl $0
801069ba:	6a 00                	push   $0x0
  pushl $75
801069bc:	6a 4b                	push   $0x4b
  jmp alltraps
801069be:	e9 66 f7 ff ff       	jmp    80106129 <alltraps>

801069c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $76
801069c5:	6a 4c                	push   $0x4c
  jmp alltraps
801069c7:	e9 5d f7 ff ff       	jmp    80106129 <alltraps>

801069cc <vector77>:
.globl vector77
vector77:
  pushl $0
801069cc:	6a 00                	push   $0x0
  pushl $77
801069ce:	6a 4d                	push   $0x4d
  jmp alltraps
801069d0:	e9 54 f7 ff ff       	jmp    80106129 <alltraps>

801069d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801069d5:	6a 00                	push   $0x0
  pushl $78
801069d7:	6a 4e                	push   $0x4e
  jmp alltraps
801069d9:	e9 4b f7 ff ff       	jmp    80106129 <alltraps>

801069de <vector79>:
.globl vector79
vector79:
  pushl $0
801069de:	6a 00                	push   $0x0
  pushl $79
801069e0:	6a 4f                	push   $0x4f
  jmp alltraps
801069e2:	e9 42 f7 ff ff       	jmp    80106129 <alltraps>

801069e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $80
801069e9:	6a 50                	push   $0x50
  jmp alltraps
801069eb:	e9 39 f7 ff ff       	jmp    80106129 <alltraps>

801069f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801069f0:	6a 00                	push   $0x0
  pushl $81
801069f2:	6a 51                	push   $0x51
  jmp alltraps
801069f4:	e9 30 f7 ff ff       	jmp    80106129 <alltraps>

801069f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801069f9:	6a 00                	push   $0x0
  pushl $82
801069fb:	6a 52                	push   $0x52
  jmp alltraps
801069fd:	e9 27 f7 ff ff       	jmp    80106129 <alltraps>

80106a02 <vector83>:
.globl vector83
vector83:
  pushl $0
80106a02:	6a 00                	push   $0x0
  pushl $83
80106a04:	6a 53                	push   $0x53
  jmp alltraps
80106a06:	e9 1e f7 ff ff       	jmp    80106129 <alltraps>

80106a0b <vector84>:
.globl vector84
vector84:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $84
80106a0d:	6a 54                	push   $0x54
  jmp alltraps
80106a0f:	e9 15 f7 ff ff       	jmp    80106129 <alltraps>

80106a14 <vector85>:
.globl vector85
vector85:
  pushl $0
80106a14:	6a 00                	push   $0x0
  pushl $85
80106a16:	6a 55                	push   $0x55
  jmp alltraps
80106a18:	e9 0c f7 ff ff       	jmp    80106129 <alltraps>

80106a1d <vector86>:
.globl vector86
vector86:
  pushl $0
80106a1d:	6a 00                	push   $0x0
  pushl $86
80106a1f:	6a 56                	push   $0x56
  jmp alltraps
80106a21:	e9 03 f7 ff ff       	jmp    80106129 <alltraps>

80106a26 <vector87>:
.globl vector87
vector87:
  pushl $0
80106a26:	6a 00                	push   $0x0
  pushl $87
80106a28:	6a 57                	push   $0x57
  jmp alltraps
80106a2a:	e9 fa f6 ff ff       	jmp    80106129 <alltraps>

80106a2f <vector88>:
.globl vector88
vector88:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $88
80106a31:	6a 58                	push   $0x58
  jmp alltraps
80106a33:	e9 f1 f6 ff ff       	jmp    80106129 <alltraps>

80106a38 <vector89>:
.globl vector89
vector89:
  pushl $0
80106a38:	6a 00                	push   $0x0
  pushl $89
80106a3a:	6a 59                	push   $0x59
  jmp alltraps
80106a3c:	e9 e8 f6 ff ff       	jmp    80106129 <alltraps>

80106a41 <vector90>:
.globl vector90
vector90:
  pushl $0
80106a41:	6a 00                	push   $0x0
  pushl $90
80106a43:	6a 5a                	push   $0x5a
  jmp alltraps
80106a45:	e9 df f6 ff ff       	jmp    80106129 <alltraps>

80106a4a <vector91>:
.globl vector91
vector91:
  pushl $0
80106a4a:	6a 00                	push   $0x0
  pushl $91
80106a4c:	6a 5b                	push   $0x5b
  jmp alltraps
80106a4e:	e9 d6 f6 ff ff       	jmp    80106129 <alltraps>

80106a53 <vector92>:
.globl vector92
vector92:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $92
80106a55:	6a 5c                	push   $0x5c
  jmp alltraps
80106a57:	e9 cd f6 ff ff       	jmp    80106129 <alltraps>

80106a5c <vector93>:
.globl vector93
vector93:
  pushl $0
80106a5c:	6a 00                	push   $0x0
  pushl $93
80106a5e:	6a 5d                	push   $0x5d
  jmp alltraps
80106a60:	e9 c4 f6 ff ff       	jmp    80106129 <alltraps>

80106a65 <vector94>:
.globl vector94
vector94:
  pushl $0
80106a65:	6a 00                	push   $0x0
  pushl $94
80106a67:	6a 5e                	push   $0x5e
  jmp alltraps
80106a69:	e9 bb f6 ff ff       	jmp    80106129 <alltraps>

80106a6e <vector95>:
.globl vector95
vector95:
  pushl $0
80106a6e:	6a 00                	push   $0x0
  pushl $95
80106a70:	6a 5f                	push   $0x5f
  jmp alltraps
80106a72:	e9 b2 f6 ff ff       	jmp    80106129 <alltraps>

80106a77 <vector96>:
.globl vector96
vector96:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $96
80106a79:	6a 60                	push   $0x60
  jmp alltraps
80106a7b:	e9 a9 f6 ff ff       	jmp    80106129 <alltraps>

80106a80 <vector97>:
.globl vector97
vector97:
  pushl $0
80106a80:	6a 00                	push   $0x0
  pushl $97
80106a82:	6a 61                	push   $0x61
  jmp alltraps
80106a84:	e9 a0 f6 ff ff       	jmp    80106129 <alltraps>

80106a89 <vector98>:
.globl vector98
vector98:
  pushl $0
80106a89:	6a 00                	push   $0x0
  pushl $98
80106a8b:	6a 62                	push   $0x62
  jmp alltraps
80106a8d:	e9 97 f6 ff ff       	jmp    80106129 <alltraps>

80106a92 <vector99>:
.globl vector99
vector99:
  pushl $0
80106a92:	6a 00                	push   $0x0
  pushl $99
80106a94:	6a 63                	push   $0x63
  jmp alltraps
80106a96:	e9 8e f6 ff ff       	jmp    80106129 <alltraps>

80106a9b <vector100>:
.globl vector100
vector100:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $100
80106a9d:	6a 64                	push   $0x64
  jmp alltraps
80106a9f:	e9 85 f6 ff ff       	jmp    80106129 <alltraps>

80106aa4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106aa4:	6a 00                	push   $0x0
  pushl $101
80106aa6:	6a 65                	push   $0x65
  jmp alltraps
80106aa8:	e9 7c f6 ff ff       	jmp    80106129 <alltraps>

80106aad <vector102>:
.globl vector102
vector102:
  pushl $0
80106aad:	6a 00                	push   $0x0
  pushl $102
80106aaf:	6a 66                	push   $0x66
  jmp alltraps
80106ab1:	e9 73 f6 ff ff       	jmp    80106129 <alltraps>

80106ab6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106ab6:	6a 00                	push   $0x0
  pushl $103
80106ab8:	6a 67                	push   $0x67
  jmp alltraps
80106aba:	e9 6a f6 ff ff       	jmp    80106129 <alltraps>

80106abf <vector104>:
.globl vector104
vector104:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $104
80106ac1:	6a 68                	push   $0x68
  jmp alltraps
80106ac3:	e9 61 f6 ff ff       	jmp    80106129 <alltraps>

80106ac8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106ac8:	6a 00                	push   $0x0
  pushl $105
80106aca:	6a 69                	push   $0x69
  jmp alltraps
80106acc:	e9 58 f6 ff ff       	jmp    80106129 <alltraps>

80106ad1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106ad1:	6a 00                	push   $0x0
  pushl $106
80106ad3:	6a 6a                	push   $0x6a
  jmp alltraps
80106ad5:	e9 4f f6 ff ff       	jmp    80106129 <alltraps>

80106ada <vector107>:
.globl vector107
vector107:
  pushl $0
80106ada:	6a 00                	push   $0x0
  pushl $107
80106adc:	6a 6b                	push   $0x6b
  jmp alltraps
80106ade:	e9 46 f6 ff ff       	jmp    80106129 <alltraps>

80106ae3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $108
80106ae5:	6a 6c                	push   $0x6c
  jmp alltraps
80106ae7:	e9 3d f6 ff ff       	jmp    80106129 <alltraps>

80106aec <vector109>:
.globl vector109
vector109:
  pushl $0
80106aec:	6a 00                	push   $0x0
  pushl $109
80106aee:	6a 6d                	push   $0x6d
  jmp alltraps
80106af0:	e9 34 f6 ff ff       	jmp    80106129 <alltraps>

80106af5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106af5:	6a 00                	push   $0x0
  pushl $110
80106af7:	6a 6e                	push   $0x6e
  jmp alltraps
80106af9:	e9 2b f6 ff ff       	jmp    80106129 <alltraps>

80106afe <vector111>:
.globl vector111
vector111:
  pushl $0
80106afe:	6a 00                	push   $0x0
  pushl $111
80106b00:	6a 6f                	push   $0x6f
  jmp alltraps
80106b02:	e9 22 f6 ff ff       	jmp    80106129 <alltraps>

80106b07 <vector112>:
.globl vector112
vector112:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $112
80106b09:	6a 70                	push   $0x70
  jmp alltraps
80106b0b:	e9 19 f6 ff ff       	jmp    80106129 <alltraps>

80106b10 <vector113>:
.globl vector113
vector113:
  pushl $0
80106b10:	6a 00                	push   $0x0
  pushl $113
80106b12:	6a 71                	push   $0x71
  jmp alltraps
80106b14:	e9 10 f6 ff ff       	jmp    80106129 <alltraps>

80106b19 <vector114>:
.globl vector114
vector114:
  pushl $0
80106b19:	6a 00                	push   $0x0
  pushl $114
80106b1b:	6a 72                	push   $0x72
  jmp alltraps
80106b1d:	e9 07 f6 ff ff       	jmp    80106129 <alltraps>

80106b22 <vector115>:
.globl vector115
vector115:
  pushl $0
80106b22:	6a 00                	push   $0x0
  pushl $115
80106b24:	6a 73                	push   $0x73
  jmp alltraps
80106b26:	e9 fe f5 ff ff       	jmp    80106129 <alltraps>

80106b2b <vector116>:
.globl vector116
vector116:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $116
80106b2d:	6a 74                	push   $0x74
  jmp alltraps
80106b2f:	e9 f5 f5 ff ff       	jmp    80106129 <alltraps>

80106b34 <vector117>:
.globl vector117
vector117:
  pushl $0
80106b34:	6a 00                	push   $0x0
  pushl $117
80106b36:	6a 75                	push   $0x75
  jmp alltraps
80106b38:	e9 ec f5 ff ff       	jmp    80106129 <alltraps>

80106b3d <vector118>:
.globl vector118
vector118:
  pushl $0
80106b3d:	6a 00                	push   $0x0
  pushl $118
80106b3f:	6a 76                	push   $0x76
  jmp alltraps
80106b41:	e9 e3 f5 ff ff       	jmp    80106129 <alltraps>

80106b46 <vector119>:
.globl vector119
vector119:
  pushl $0
80106b46:	6a 00                	push   $0x0
  pushl $119
80106b48:	6a 77                	push   $0x77
  jmp alltraps
80106b4a:	e9 da f5 ff ff       	jmp    80106129 <alltraps>

80106b4f <vector120>:
.globl vector120
vector120:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $120
80106b51:	6a 78                	push   $0x78
  jmp alltraps
80106b53:	e9 d1 f5 ff ff       	jmp    80106129 <alltraps>

80106b58 <vector121>:
.globl vector121
vector121:
  pushl $0
80106b58:	6a 00                	push   $0x0
  pushl $121
80106b5a:	6a 79                	push   $0x79
  jmp alltraps
80106b5c:	e9 c8 f5 ff ff       	jmp    80106129 <alltraps>

80106b61 <vector122>:
.globl vector122
vector122:
  pushl $0
80106b61:	6a 00                	push   $0x0
  pushl $122
80106b63:	6a 7a                	push   $0x7a
  jmp alltraps
80106b65:	e9 bf f5 ff ff       	jmp    80106129 <alltraps>

80106b6a <vector123>:
.globl vector123
vector123:
  pushl $0
80106b6a:	6a 00                	push   $0x0
  pushl $123
80106b6c:	6a 7b                	push   $0x7b
  jmp alltraps
80106b6e:	e9 b6 f5 ff ff       	jmp    80106129 <alltraps>

80106b73 <vector124>:
.globl vector124
vector124:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $124
80106b75:	6a 7c                	push   $0x7c
  jmp alltraps
80106b77:	e9 ad f5 ff ff       	jmp    80106129 <alltraps>

80106b7c <vector125>:
.globl vector125
vector125:
  pushl $0
80106b7c:	6a 00                	push   $0x0
  pushl $125
80106b7e:	6a 7d                	push   $0x7d
  jmp alltraps
80106b80:	e9 a4 f5 ff ff       	jmp    80106129 <alltraps>

80106b85 <vector126>:
.globl vector126
vector126:
  pushl $0
80106b85:	6a 00                	push   $0x0
  pushl $126
80106b87:	6a 7e                	push   $0x7e
  jmp alltraps
80106b89:	e9 9b f5 ff ff       	jmp    80106129 <alltraps>

80106b8e <vector127>:
.globl vector127
vector127:
  pushl $0
80106b8e:	6a 00                	push   $0x0
  pushl $127
80106b90:	6a 7f                	push   $0x7f
  jmp alltraps
80106b92:	e9 92 f5 ff ff       	jmp    80106129 <alltraps>

80106b97 <vector128>:
.globl vector128
vector128:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $128
80106b99:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106b9e:	e9 86 f5 ff ff       	jmp    80106129 <alltraps>

80106ba3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $129
80106ba5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106baa:	e9 7a f5 ff ff       	jmp    80106129 <alltraps>

80106baf <vector130>:
.globl vector130
vector130:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $130
80106bb1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106bb6:	e9 6e f5 ff ff       	jmp    80106129 <alltraps>

80106bbb <vector131>:
.globl vector131
vector131:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $131
80106bbd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106bc2:	e9 62 f5 ff ff       	jmp    80106129 <alltraps>

80106bc7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $132
80106bc9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106bce:	e9 56 f5 ff ff       	jmp    80106129 <alltraps>

80106bd3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $133
80106bd5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106bda:	e9 4a f5 ff ff       	jmp    80106129 <alltraps>

80106bdf <vector134>:
.globl vector134
vector134:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $134
80106be1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106be6:	e9 3e f5 ff ff       	jmp    80106129 <alltraps>

80106beb <vector135>:
.globl vector135
vector135:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $135
80106bed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106bf2:	e9 32 f5 ff ff       	jmp    80106129 <alltraps>

80106bf7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $136
80106bf9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106bfe:	e9 26 f5 ff ff       	jmp    80106129 <alltraps>

80106c03 <vector137>:
.globl vector137
vector137:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $137
80106c05:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106c0a:	e9 1a f5 ff ff       	jmp    80106129 <alltraps>

80106c0f <vector138>:
.globl vector138
vector138:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $138
80106c11:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106c16:	e9 0e f5 ff ff       	jmp    80106129 <alltraps>

80106c1b <vector139>:
.globl vector139
vector139:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $139
80106c1d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106c22:	e9 02 f5 ff ff       	jmp    80106129 <alltraps>

80106c27 <vector140>:
.globl vector140
vector140:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $140
80106c29:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106c2e:	e9 f6 f4 ff ff       	jmp    80106129 <alltraps>

80106c33 <vector141>:
.globl vector141
vector141:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $141
80106c35:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106c3a:	e9 ea f4 ff ff       	jmp    80106129 <alltraps>

80106c3f <vector142>:
.globl vector142
vector142:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $142
80106c41:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106c46:	e9 de f4 ff ff       	jmp    80106129 <alltraps>

80106c4b <vector143>:
.globl vector143
vector143:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $143
80106c4d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106c52:	e9 d2 f4 ff ff       	jmp    80106129 <alltraps>

80106c57 <vector144>:
.globl vector144
vector144:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $144
80106c59:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106c5e:	e9 c6 f4 ff ff       	jmp    80106129 <alltraps>

80106c63 <vector145>:
.globl vector145
vector145:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $145
80106c65:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106c6a:	e9 ba f4 ff ff       	jmp    80106129 <alltraps>

80106c6f <vector146>:
.globl vector146
vector146:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $146
80106c71:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106c76:	e9 ae f4 ff ff       	jmp    80106129 <alltraps>

80106c7b <vector147>:
.globl vector147
vector147:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $147
80106c7d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106c82:	e9 a2 f4 ff ff       	jmp    80106129 <alltraps>

80106c87 <vector148>:
.globl vector148
vector148:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $148
80106c89:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106c8e:	e9 96 f4 ff ff       	jmp    80106129 <alltraps>

80106c93 <vector149>:
.globl vector149
vector149:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $149
80106c95:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106c9a:	e9 8a f4 ff ff       	jmp    80106129 <alltraps>

80106c9f <vector150>:
.globl vector150
vector150:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $150
80106ca1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ca6:	e9 7e f4 ff ff       	jmp    80106129 <alltraps>

80106cab <vector151>:
.globl vector151
vector151:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $151
80106cad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106cb2:	e9 72 f4 ff ff       	jmp    80106129 <alltraps>

80106cb7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $152
80106cb9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106cbe:	e9 66 f4 ff ff       	jmp    80106129 <alltraps>

80106cc3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $153
80106cc5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106cca:	e9 5a f4 ff ff       	jmp    80106129 <alltraps>

80106ccf <vector154>:
.globl vector154
vector154:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $154
80106cd1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106cd6:	e9 4e f4 ff ff       	jmp    80106129 <alltraps>

80106cdb <vector155>:
.globl vector155
vector155:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $155
80106cdd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ce2:	e9 42 f4 ff ff       	jmp    80106129 <alltraps>

80106ce7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $156
80106ce9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106cee:	e9 36 f4 ff ff       	jmp    80106129 <alltraps>

80106cf3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $157
80106cf5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106cfa:	e9 2a f4 ff ff       	jmp    80106129 <alltraps>

80106cff <vector158>:
.globl vector158
vector158:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $158
80106d01:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106d06:	e9 1e f4 ff ff       	jmp    80106129 <alltraps>

80106d0b <vector159>:
.globl vector159
vector159:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $159
80106d0d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106d12:	e9 12 f4 ff ff       	jmp    80106129 <alltraps>

80106d17 <vector160>:
.globl vector160
vector160:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $160
80106d19:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106d1e:	e9 06 f4 ff ff       	jmp    80106129 <alltraps>

80106d23 <vector161>:
.globl vector161
vector161:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $161
80106d25:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106d2a:	e9 fa f3 ff ff       	jmp    80106129 <alltraps>

80106d2f <vector162>:
.globl vector162
vector162:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $162
80106d31:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106d36:	e9 ee f3 ff ff       	jmp    80106129 <alltraps>

80106d3b <vector163>:
.globl vector163
vector163:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $163
80106d3d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106d42:	e9 e2 f3 ff ff       	jmp    80106129 <alltraps>

80106d47 <vector164>:
.globl vector164
vector164:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $164
80106d49:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106d4e:	e9 d6 f3 ff ff       	jmp    80106129 <alltraps>

80106d53 <vector165>:
.globl vector165
vector165:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $165
80106d55:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106d5a:	e9 ca f3 ff ff       	jmp    80106129 <alltraps>

80106d5f <vector166>:
.globl vector166
vector166:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $166
80106d61:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106d66:	e9 be f3 ff ff       	jmp    80106129 <alltraps>

80106d6b <vector167>:
.globl vector167
vector167:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $167
80106d6d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106d72:	e9 b2 f3 ff ff       	jmp    80106129 <alltraps>

80106d77 <vector168>:
.globl vector168
vector168:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $168
80106d79:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106d7e:	e9 a6 f3 ff ff       	jmp    80106129 <alltraps>

80106d83 <vector169>:
.globl vector169
vector169:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $169
80106d85:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106d8a:	e9 9a f3 ff ff       	jmp    80106129 <alltraps>

80106d8f <vector170>:
.globl vector170
vector170:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $170
80106d91:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106d96:	e9 8e f3 ff ff       	jmp    80106129 <alltraps>

80106d9b <vector171>:
.globl vector171
vector171:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $171
80106d9d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106da2:	e9 82 f3 ff ff       	jmp    80106129 <alltraps>

80106da7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $172
80106da9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106dae:	e9 76 f3 ff ff       	jmp    80106129 <alltraps>

80106db3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $173
80106db5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106dba:	e9 6a f3 ff ff       	jmp    80106129 <alltraps>

80106dbf <vector174>:
.globl vector174
vector174:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $174
80106dc1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106dc6:	e9 5e f3 ff ff       	jmp    80106129 <alltraps>

80106dcb <vector175>:
.globl vector175
vector175:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $175
80106dcd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106dd2:	e9 52 f3 ff ff       	jmp    80106129 <alltraps>

80106dd7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $176
80106dd9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106dde:	e9 46 f3 ff ff       	jmp    80106129 <alltraps>

80106de3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $177
80106de5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106dea:	e9 3a f3 ff ff       	jmp    80106129 <alltraps>

80106def <vector178>:
.globl vector178
vector178:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $178
80106df1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106df6:	e9 2e f3 ff ff       	jmp    80106129 <alltraps>

80106dfb <vector179>:
.globl vector179
vector179:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $179
80106dfd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106e02:	e9 22 f3 ff ff       	jmp    80106129 <alltraps>

80106e07 <vector180>:
.globl vector180
vector180:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $180
80106e09:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106e0e:	e9 16 f3 ff ff       	jmp    80106129 <alltraps>

80106e13 <vector181>:
.globl vector181
vector181:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $181
80106e15:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106e1a:	e9 0a f3 ff ff       	jmp    80106129 <alltraps>

80106e1f <vector182>:
.globl vector182
vector182:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $182
80106e21:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106e26:	e9 fe f2 ff ff       	jmp    80106129 <alltraps>

80106e2b <vector183>:
.globl vector183
vector183:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $183
80106e2d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106e32:	e9 f2 f2 ff ff       	jmp    80106129 <alltraps>

80106e37 <vector184>:
.globl vector184
vector184:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $184
80106e39:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106e3e:	e9 e6 f2 ff ff       	jmp    80106129 <alltraps>

80106e43 <vector185>:
.globl vector185
vector185:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $185
80106e45:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106e4a:	e9 da f2 ff ff       	jmp    80106129 <alltraps>

80106e4f <vector186>:
.globl vector186
vector186:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $186
80106e51:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106e56:	e9 ce f2 ff ff       	jmp    80106129 <alltraps>

80106e5b <vector187>:
.globl vector187
vector187:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $187
80106e5d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106e62:	e9 c2 f2 ff ff       	jmp    80106129 <alltraps>

80106e67 <vector188>:
.globl vector188
vector188:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $188
80106e69:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106e6e:	e9 b6 f2 ff ff       	jmp    80106129 <alltraps>

80106e73 <vector189>:
.globl vector189
vector189:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $189
80106e75:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106e7a:	e9 aa f2 ff ff       	jmp    80106129 <alltraps>

80106e7f <vector190>:
.globl vector190
vector190:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $190
80106e81:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106e86:	e9 9e f2 ff ff       	jmp    80106129 <alltraps>

80106e8b <vector191>:
.globl vector191
vector191:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $191
80106e8d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106e92:	e9 92 f2 ff ff       	jmp    80106129 <alltraps>

80106e97 <vector192>:
.globl vector192
vector192:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $192
80106e99:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106e9e:	e9 86 f2 ff ff       	jmp    80106129 <alltraps>

80106ea3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $193
80106ea5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106eaa:	e9 7a f2 ff ff       	jmp    80106129 <alltraps>

80106eaf <vector194>:
.globl vector194
vector194:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $194
80106eb1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106eb6:	e9 6e f2 ff ff       	jmp    80106129 <alltraps>

80106ebb <vector195>:
.globl vector195
vector195:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $195
80106ebd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ec2:	e9 62 f2 ff ff       	jmp    80106129 <alltraps>

80106ec7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $196
80106ec9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106ece:	e9 56 f2 ff ff       	jmp    80106129 <alltraps>

80106ed3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $197
80106ed5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106eda:	e9 4a f2 ff ff       	jmp    80106129 <alltraps>

80106edf <vector198>:
.globl vector198
vector198:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $198
80106ee1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106ee6:	e9 3e f2 ff ff       	jmp    80106129 <alltraps>

80106eeb <vector199>:
.globl vector199
vector199:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $199
80106eed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ef2:	e9 32 f2 ff ff       	jmp    80106129 <alltraps>

80106ef7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $200
80106ef9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106efe:	e9 26 f2 ff ff       	jmp    80106129 <alltraps>

80106f03 <vector201>:
.globl vector201
vector201:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $201
80106f05:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106f0a:	e9 1a f2 ff ff       	jmp    80106129 <alltraps>

80106f0f <vector202>:
.globl vector202
vector202:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $202
80106f11:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106f16:	e9 0e f2 ff ff       	jmp    80106129 <alltraps>

80106f1b <vector203>:
.globl vector203
vector203:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $203
80106f1d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106f22:	e9 02 f2 ff ff       	jmp    80106129 <alltraps>

80106f27 <vector204>:
.globl vector204
vector204:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $204
80106f29:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106f2e:	e9 f6 f1 ff ff       	jmp    80106129 <alltraps>

80106f33 <vector205>:
.globl vector205
vector205:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $205
80106f35:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106f3a:	e9 ea f1 ff ff       	jmp    80106129 <alltraps>

80106f3f <vector206>:
.globl vector206
vector206:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $206
80106f41:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106f46:	e9 de f1 ff ff       	jmp    80106129 <alltraps>

80106f4b <vector207>:
.globl vector207
vector207:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $207
80106f4d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106f52:	e9 d2 f1 ff ff       	jmp    80106129 <alltraps>

80106f57 <vector208>:
.globl vector208
vector208:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $208
80106f59:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106f5e:	e9 c6 f1 ff ff       	jmp    80106129 <alltraps>

80106f63 <vector209>:
.globl vector209
vector209:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $209
80106f65:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106f6a:	e9 ba f1 ff ff       	jmp    80106129 <alltraps>

80106f6f <vector210>:
.globl vector210
vector210:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $210
80106f71:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106f76:	e9 ae f1 ff ff       	jmp    80106129 <alltraps>

80106f7b <vector211>:
.globl vector211
vector211:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $211
80106f7d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106f82:	e9 a2 f1 ff ff       	jmp    80106129 <alltraps>

80106f87 <vector212>:
.globl vector212
vector212:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $212
80106f89:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106f8e:	e9 96 f1 ff ff       	jmp    80106129 <alltraps>

80106f93 <vector213>:
.globl vector213
vector213:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $213
80106f95:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106f9a:	e9 8a f1 ff ff       	jmp    80106129 <alltraps>

80106f9f <vector214>:
.globl vector214
vector214:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $214
80106fa1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106fa6:	e9 7e f1 ff ff       	jmp    80106129 <alltraps>

80106fab <vector215>:
.globl vector215
vector215:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $215
80106fad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106fb2:	e9 72 f1 ff ff       	jmp    80106129 <alltraps>

80106fb7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $216
80106fb9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106fbe:	e9 66 f1 ff ff       	jmp    80106129 <alltraps>

80106fc3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $217
80106fc5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106fca:	e9 5a f1 ff ff       	jmp    80106129 <alltraps>

80106fcf <vector218>:
.globl vector218
vector218:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $218
80106fd1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106fd6:	e9 4e f1 ff ff       	jmp    80106129 <alltraps>

80106fdb <vector219>:
.globl vector219
vector219:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $219
80106fdd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106fe2:	e9 42 f1 ff ff       	jmp    80106129 <alltraps>

80106fe7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $220
80106fe9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106fee:	e9 36 f1 ff ff       	jmp    80106129 <alltraps>

80106ff3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $221
80106ff5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106ffa:	e9 2a f1 ff ff       	jmp    80106129 <alltraps>

80106fff <vector222>:
.globl vector222
vector222:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $222
80107001:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107006:	e9 1e f1 ff ff       	jmp    80106129 <alltraps>

8010700b <vector223>:
.globl vector223
vector223:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $223
8010700d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107012:	e9 12 f1 ff ff       	jmp    80106129 <alltraps>

80107017 <vector224>:
.globl vector224
vector224:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $224
80107019:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010701e:	e9 06 f1 ff ff       	jmp    80106129 <alltraps>

80107023 <vector225>:
.globl vector225
vector225:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $225
80107025:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010702a:	e9 fa f0 ff ff       	jmp    80106129 <alltraps>

8010702f <vector226>:
.globl vector226
vector226:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $226
80107031:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107036:	e9 ee f0 ff ff       	jmp    80106129 <alltraps>

8010703b <vector227>:
.globl vector227
vector227:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $227
8010703d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107042:	e9 e2 f0 ff ff       	jmp    80106129 <alltraps>

80107047 <vector228>:
.globl vector228
vector228:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $228
80107049:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010704e:	e9 d6 f0 ff ff       	jmp    80106129 <alltraps>

80107053 <vector229>:
.globl vector229
vector229:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $229
80107055:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010705a:	e9 ca f0 ff ff       	jmp    80106129 <alltraps>

8010705f <vector230>:
.globl vector230
vector230:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $230
80107061:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107066:	e9 be f0 ff ff       	jmp    80106129 <alltraps>

8010706b <vector231>:
.globl vector231
vector231:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $231
8010706d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107072:	e9 b2 f0 ff ff       	jmp    80106129 <alltraps>

80107077 <vector232>:
.globl vector232
vector232:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $232
80107079:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010707e:	e9 a6 f0 ff ff       	jmp    80106129 <alltraps>

80107083 <vector233>:
.globl vector233
vector233:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $233
80107085:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010708a:	e9 9a f0 ff ff       	jmp    80106129 <alltraps>

8010708f <vector234>:
.globl vector234
vector234:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $234
80107091:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107096:	e9 8e f0 ff ff       	jmp    80106129 <alltraps>

8010709b <vector235>:
.globl vector235
vector235:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $235
8010709d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801070a2:	e9 82 f0 ff ff       	jmp    80106129 <alltraps>

801070a7 <vector236>:
.globl vector236
vector236:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $236
801070a9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801070ae:	e9 76 f0 ff ff       	jmp    80106129 <alltraps>

801070b3 <vector237>:
.globl vector237
vector237:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $237
801070b5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801070ba:	e9 6a f0 ff ff       	jmp    80106129 <alltraps>

801070bf <vector238>:
.globl vector238
vector238:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $238
801070c1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801070c6:	e9 5e f0 ff ff       	jmp    80106129 <alltraps>

801070cb <vector239>:
.globl vector239
vector239:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $239
801070cd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801070d2:	e9 52 f0 ff ff       	jmp    80106129 <alltraps>

801070d7 <vector240>:
.globl vector240
vector240:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $240
801070d9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801070de:	e9 46 f0 ff ff       	jmp    80106129 <alltraps>

801070e3 <vector241>:
.globl vector241
vector241:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $241
801070e5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801070ea:	e9 3a f0 ff ff       	jmp    80106129 <alltraps>

801070ef <vector242>:
.globl vector242
vector242:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $242
801070f1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801070f6:	e9 2e f0 ff ff       	jmp    80106129 <alltraps>

801070fb <vector243>:
.globl vector243
vector243:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $243
801070fd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107102:	e9 22 f0 ff ff       	jmp    80106129 <alltraps>

80107107 <vector244>:
.globl vector244
vector244:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $244
80107109:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010710e:	e9 16 f0 ff ff       	jmp    80106129 <alltraps>

80107113 <vector245>:
.globl vector245
vector245:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $245
80107115:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010711a:	e9 0a f0 ff ff       	jmp    80106129 <alltraps>

8010711f <vector246>:
.globl vector246
vector246:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $246
80107121:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107126:	e9 fe ef ff ff       	jmp    80106129 <alltraps>

8010712b <vector247>:
.globl vector247
vector247:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $247
8010712d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107132:	e9 f2 ef ff ff       	jmp    80106129 <alltraps>

80107137 <vector248>:
.globl vector248
vector248:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $248
80107139:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010713e:	e9 e6 ef ff ff       	jmp    80106129 <alltraps>

80107143 <vector249>:
.globl vector249
vector249:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $249
80107145:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010714a:	e9 da ef ff ff       	jmp    80106129 <alltraps>

8010714f <vector250>:
.globl vector250
vector250:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $250
80107151:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107156:	e9 ce ef ff ff       	jmp    80106129 <alltraps>

8010715b <vector251>:
.globl vector251
vector251:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $251
8010715d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107162:	e9 c2 ef ff ff       	jmp    80106129 <alltraps>

80107167 <vector252>:
.globl vector252
vector252:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $252
80107169:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010716e:	e9 b6 ef ff ff       	jmp    80106129 <alltraps>

80107173 <vector253>:
.globl vector253
vector253:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $253
80107175:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010717a:	e9 aa ef ff ff       	jmp    80106129 <alltraps>

8010717f <vector254>:
.globl vector254
vector254:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $254
80107181:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107186:	e9 9e ef ff ff       	jmp    80106129 <alltraps>

8010718b <vector255>:
.globl vector255
vector255:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $255
8010718d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107192:	e9 92 ef ff ff       	jmp    80106129 <alltraps>
80107197:	66 90                	xchg   %ax,%ax
80107199:	66 90                	xchg   %ax,%ax
8010719b:	66 90                	xchg   %ax,%ax
8010719d:	66 90                	xchg   %ax,%ax
8010719f:	90                   	nop

801071a0 <cow_kfree>:
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc);
int swap_in(struct proc* p, struct pageinfo* pi);
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir);

void cow_kfree(char* to_free_kva){
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	56                   	push   %esi
801071a4:	53                   	push   %ebx
801071a5:	8b 75 08             	mov    0x8(%ebp),%esi
  char count;
  int acq = 0;
  if (lapicid() != 0){
801071a8:	e8 33 bd ff ff       	call   80102ee0 <lapicid>
801071ad:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
801071b3:	c1 eb 0c             	shr    $0xc,%ebx
801071b6:	85 c0                	test   %eax,%eax
801071b8:	75 16                	jne    801071d0 <cow_kfree+0x30>
    acquire(cow_lock);
  }
  // struct proc* p = myproc();
  // if (p != 0 ){ // && p->pid > 2
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
  if (count != 0){
801071ba:	80 ab 40 1f 11 80 01 	subb   $0x1,-0x7feee0c0(%ebx)
801071c1:	74 43                	je     80107206 <cow_kfree+0x66>
  if (acq){
    // cprintf("rel kfree %d\n", myproc()->pid);
    release(cow_lock);
  }
  kfree(to_free_kva);
}
801071c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071c6:	5b                   	pop    %ebx
801071c7:	5e                   	pop    %esi
801071c8:	5d                   	pop    %ebp
801071c9:	c3                   	ret    
801071ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(cow_lock);
801071d0:	83 ec 0c             	sub    $0xc,%esp
801071d3:	ff 35 40 ff 11 80    	pushl  0x8011ff40
801071d9:	e8 12 dc ff ff       	call   80104df0 <acquire>
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
801071de:	0f b6 83 40 1f 11 80 	movzbl -0x7feee0c0(%ebx),%eax
  if (count != 0){
801071e5:	83 c4 10             	add    $0x10,%esp
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
801071e8:	83 e8 01             	sub    $0x1,%eax
  if (count != 0){
801071eb:	84 c0                	test   %al,%al
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
801071ed:	88 83 40 1f 11 80    	mov    %al,-0x7feee0c0(%ebx)
  if (count != 0){
801071f3:	75 23                	jne    80107218 <cow_kfree+0x78>
    release(cow_lock);
801071f5:	83 ec 0c             	sub    $0xc,%esp
801071f8:	ff 35 40 ff 11 80    	pushl  0x8011ff40
801071fe:	e8 ad dc ff ff       	call   80104eb0 <release>
80107203:	83 c4 10             	add    $0x10,%esp
  kfree(to_free_kva);
80107206:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107209:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010720c:	5b                   	pop    %ebx
8010720d:	5e                   	pop    %esi
8010720e:	5d                   	pop    %ebp
  kfree(to_free_kva);
8010720f:	e9 7c b8 ff ff       	jmp    80102a90 <kfree>
80107214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(cow_lock);
80107218:	a1 40 ff 11 80       	mov    0x8011ff40,%eax
8010721d:	89 45 08             	mov    %eax,0x8(%ebp)
}
80107220:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107223:	5b                   	pop    %ebx
80107224:	5e                   	pop    %esi
80107225:	5d                   	pop    %ebp
      release(cow_lock);
80107226:	e9 85 dc ff ff       	jmp    80104eb0 <release>
8010722b:	90                   	nop
8010722c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107230 <cow_kalloc>:

char* cow_kalloc(){
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
80107235:	53                   	push   %ebx
80107236:	83 ec 0c             	sub    $0xc,%esp
  char* r = kalloc();
80107239:	e8 32 ba ff ff       	call   80102c70 <kalloc>
  if (r == 0){
8010723e:	85 c0                	test   %eax,%eax
  char* r = kalloc();
80107240:	89 c3                	mov    %eax,%ebx
  if (r == 0){
80107242:	74 28                	je     8010726c <cow_kalloc+0x3c>
80107244:	8d bb 00 00 00 80    	lea    -0x80000000(%ebx),%edi
    return r;
  }
  int acq = 0;
  // cprintf("kalloc \n");
  if (lapicid() != 0){
8010724a:	e8 91 bc ff ff       	call   80102ee0 <lapicid>
8010724f:	89 fe                	mov    %edi,%esi
80107251:	c1 ee 0c             	shr    $0xc,%esi
80107254:	85 c0                	test   %eax,%eax
80107256:	75 28                	jne    80107280 <cow_kalloc+0x50>
    acq = 1;
    // cprintf("kalloc %d\n", myproc()->pid);
    acquire(cow_lock);
  }
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
80107258:	0f b6 86 40 1f 11 80 	movzbl -0x7feee0c0(%esi),%eax
8010725f:	8d 50 01             	lea    0x1(%eax),%edx
80107262:	84 c0                	test   %al,%al
80107264:	88 96 40 1f 11 80    	mov    %dl,-0x7feee0c0(%esi)
8010726a:	75 54                	jne    801072c0 <cow_kalloc+0x90>
  }
  if (acq){
    release(cow_lock);
  }
  return r;
}
8010726c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010726f:	89 d8                	mov    %ebx,%eax
80107271:	5b                   	pop    %ebx
80107272:	5e                   	pop    %esi
80107273:	5f                   	pop    %edi
80107274:	5d                   	pop    %ebp
80107275:	c3                   	ret    
80107276:	8d 76 00             	lea    0x0(%esi),%esi
80107279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    acquire(cow_lock);
80107280:	83 ec 0c             	sub    $0xc,%esp
80107283:	ff 35 40 ff 11 80    	pushl  0x8011ff40
80107289:	e8 62 db ff ff       	call   80104df0 <acquire>
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
8010728e:	0f b6 86 40 1f 11 80 	movzbl -0x7feee0c0(%esi),%eax
80107295:	83 c4 10             	add    $0x10,%esp
80107298:	8d 50 01             	lea    0x1(%eax),%edx
8010729b:	84 c0                	test   %al,%al
8010729d:	88 96 40 1f 11 80    	mov    %dl,-0x7feee0c0(%esi)
801072a3:	75 1b                	jne    801072c0 <cow_kalloc+0x90>
      release(cow_lock);
801072a5:	83 ec 0c             	sub    $0xc,%esp
801072a8:	ff 35 40 ff 11 80    	pushl  0x8011ff40
801072ae:	e8 fd db ff ff       	call   80104eb0 <release>
801072b3:	83 c4 10             	add    $0x10,%esp
}
801072b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072b9:	89 d8                	mov    %ebx,%eax
801072bb:	5b                   	pop    %ebx
801072bc:	5e                   	pop    %esi
801072bd:	5f                   	pop    %edi
801072be:	5d                   	pop    %ebp
801072bf:	c3                   	ret    
    cprintf("actual ref count = %d, pg index = %x, pg pa = %x\n", pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE] - 1, PGROUNDDOWN(V2P(r)) / PGSIZE, V2P(r));
801072c0:	0f be c2             	movsbl %dl,%eax
801072c3:	57                   	push   %edi
801072c4:	56                   	push   %esi
801072c5:	83 e8 01             	sub    $0x1,%eax
801072c8:	50                   	push   %eax
801072c9:	68 9c 8f 10 80       	push   $0x80108f9c
801072ce:	e8 8d 93 ff ff       	call   80100660 <cprintf>
    panic("kalloc allocated something with a reference");
801072d3:	c7 04 24 d0 8f 10 80 	movl   $0x80108fd0,(%esp)
801072da:	e8 b1 90 ff ff       	call   80100390 <panic>
801072df:	90                   	nop

801072e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	57                   	push   %edi
801072e4:	56                   	push   %esi
801072e5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801072e6:	89 d3                	mov    %edx,%ebx
{
801072e8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801072ea:	c1 eb 16             	shr    $0x16,%ebx
801072ed:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801072f0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801072f3:	8b 06                	mov    (%esi),%eax
801072f5:	a8 01                	test   $0x1,%al
801072f7:	74 27                	je     80107320 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801072fe:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107304:	c1 ef 0a             	shr    $0xa,%edi
}
80107307:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010730a:	89 fa                	mov    %edi,%edx
8010730c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107312:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107315:	5b                   	pop    %ebx
80107316:	5e                   	pop    %esi
80107317:	5f                   	pop    %edi
80107318:	5d                   	pop    %ebp
80107319:	c3                   	ret    
8010731a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)cow_kalloc()) == 0)
80107320:	85 c9                	test   %ecx,%ecx
80107322:	74 2c                	je     80107350 <walkpgdir+0x70>
80107324:	e8 07 ff ff ff       	call   80107230 <cow_kalloc>
80107329:	85 c0                	test   %eax,%eax
8010732b:	89 c3                	mov    %eax,%ebx
8010732d:	74 21                	je     80107350 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010732f:	83 ec 04             	sub    $0x4,%esp
80107332:	68 00 10 00 00       	push   $0x1000
80107337:	6a 00                	push   $0x0
80107339:	50                   	push   %eax
8010733a:	e8 c1 db ff ff       	call   80104f00 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010733f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107345:	83 c4 10             	add    $0x10,%esp
80107348:	83 c8 07             	or     $0x7,%eax
8010734b:	89 06                	mov    %eax,(%esi)
8010734d:	eb b5                	jmp    80107304 <walkpgdir+0x24>
8010734f:	90                   	nop
}
80107350:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107353:	31 c0                	xor    %eax,%eax
}
80107355:	5b                   	pop    %ebx
80107356:	5e                   	pop    %esi
80107357:	5f                   	pop    %edi
80107358:	5d                   	pop    %ebp
80107359:	c3                   	ret    
8010735a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107360 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	57                   	push   %edi
80107364:	56                   	push   %esi
80107365:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107366:	89 d3                	mov    %edx,%ebx
80107368:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010736e:	83 ec 1c             	sub    $0x1c,%esp
80107371:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107374:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107378:	8b 7d 08             	mov    0x8(%ebp),%edi
8010737b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107380:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107383:	8b 45 0c             	mov    0xc(%ebp),%eax
80107386:	29 df                	sub    %ebx,%edi
80107388:	83 c8 01             	or     $0x1,%eax
8010738b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010738e:	eb 15                	jmp    801073a5 <mappages+0x45>
    if(*pte & PTE_P)
80107390:	f6 00 01             	testb  $0x1,(%eax)
80107393:	75 45                	jne    801073da <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107395:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107398:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010739b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010739d:	74 31                	je     801073d0 <mappages+0x70>
      break;
    a += PGSIZE;
8010739f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801073a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073a8:	b9 01 00 00 00       	mov    $0x1,%ecx
801073ad:	89 da                	mov    %ebx,%edx
801073af:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801073b2:	e8 29 ff ff ff       	call   801072e0 <walkpgdir>
801073b7:	85 c0                	test   %eax,%eax
801073b9:	75 d5                	jne    80107390 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801073bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073c3:	5b                   	pop    %ebx
801073c4:	5e                   	pop    %esi
801073c5:	5f                   	pop    %edi
801073c6:	5d                   	pop    %ebp
801073c7:	c3                   	ret    
801073c8:	90                   	nop
801073c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073d3:	31 c0                	xor    %eax,%eax
}
801073d5:	5b                   	pop    %ebx
801073d6:	5e                   	pop    %esi
801073d7:	5f                   	pop    %edi
801073d8:	5d                   	pop    %ebp
801073d9:	c3                   	ret    
      panic("remap");
801073da:	83 ec 0c             	sub    $0xc,%esp
801073dd:	68 98 90 10 80       	push   $0x80109098
801073e2:	e8 a9 8f ff ff       	call   80100390 <panic>
801073e7:	89 f6                	mov    %esi,%esi
801073e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073f0 <update_age>:
void update_age(struct proc* p){
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	57                   	push   %edi
801073f4:	56                   	push   %esi
801073f5:	53                   	push   %ebx
801073f6:	83 ec 0c             	sub    $0xc,%esp
801073f9:	8b 45 08             	mov    0x8(%ebp),%eax
801073fc:	8d 98 00 02 00 00    	lea    0x200(%eax),%ebx
80107402:	8d b0 80 03 00 00    	lea    0x380(%eax),%esi
80107408:	eb 0d                	jmp    80107417 <update_age+0x27>
8010740a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107410:	83 c3 18             	add    $0x18,%ebx
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107413:	39 f3                	cmp    %esi,%ebx
80107415:	74 55                	je     8010746c <update_age+0x7c>
    if (!(pi->is_free)){
80107417:	8b 03                	mov    (%ebx),%eax
80107419:	85 c0                	test   %eax,%eax
8010741b:	75 f3                	jne    80107410 <update_age+0x20>
      old_age = pi->aging_counter;
8010741d:	8b 7b 08             	mov    0x8(%ebx),%edi
      pte_t* pte = walkpgdir(p->pgdir,(void*) pi->va, 0);
80107420:	8b 53 10             	mov    0x10(%ebx),%edx
80107423:	31 c9                	xor    %ecx,%ecx
      pi->aging_counter =  pi->aging_counter >> 1;
80107425:	89 f8                	mov    %edi,%eax
80107427:	d1 e8                	shr    %eax
80107429:	89 43 08             	mov    %eax,0x8(%ebx)
      pte_t* pte = walkpgdir(p->pgdir,(void*) pi->va, 0);
8010742c:	8b 45 08             	mov    0x8(%ebp),%eax
8010742f:	8b 40 04             	mov    0x4(%eax),%eax
80107432:	e8 a9 fe ff ff       	call   801072e0 <walkpgdir>
      if(!(uint)*pte){
80107437:	8b 08                	mov    (%eax),%ecx
80107439:	85 c9                	test   %ecx,%ecx
8010743b:	74 4f                	je     8010748c <update_age+0x9c>
      if (*pte & PTE_A){
8010743d:	83 e1 20             	and    $0x20,%ecx
80107440:	8b 53 08             	mov    0x8(%ebx),%edx
80107443:	74 33                	je     80107478 <update_age+0x88>
        pi->aging_counter = pi->aging_counter| 0x80000000;//(1<<31);
80107445:	81 ca 00 00 00 80    	or     $0x80000000,%edx
        cprintf("PTE_A old age:  %d, new age:  %d\n",old_age, pi->aging_counter );
8010744b:	83 ec 04             	sub    $0x4,%esp
8010744e:	83 c3 18             	add    $0x18,%ebx
        pi->aging_counter = pi->aging_counter| 0x80000000;//(1<<31);
80107451:	89 53 f0             	mov    %edx,-0x10(%ebx)
        *pte &= ~PTE_A;
80107454:	83 20 df             	andl   $0xffffffdf,(%eax)
        cprintf("PTE_A old age:  %d, new age:  %d\n",old_age, pi->aging_counter );
80107457:	ff 73 f0             	pushl  -0x10(%ebx)
8010745a:	57                   	push   %edi
8010745b:	68 fc 8f 10 80       	push   $0x80108ffc
80107460:	e8 fb 91 ff ff       	call   80100660 <cprintf>
80107465:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107468:	39 f3                	cmp    %esi,%ebx
8010746a:	75 ab                	jne    80107417 <update_age+0x27>
}
8010746c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010746f:	5b                   	pop    %ebx
80107470:	5e                   	pop    %esi
80107471:	5f                   	pop    %edi
80107472:	5d                   	pop    %ebp
80107473:	c3                   	ret    
80107474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("old age:  %d, new age:  %d\n",old_age, pi->aging_counter );
80107478:	83 ec 04             	sub    $0x4,%esp
8010747b:	52                   	push   %edx
8010747c:	57                   	push   %edi
8010747d:	68 b8 90 10 80       	push   $0x801090b8
80107482:	e8 d9 91 ff ff       	call   80100660 <cprintf>
80107487:	83 c4 10             	add    $0x10,%esp
8010748a:	eb 84                	jmp    80107410 <update_age+0x20>
        panic("can't find page from NFUA");
8010748c:	83 ec 0c             	sub    $0xc,%esp
8010748f:	68 9e 90 10 80       	push   $0x8010909e
80107494:	e8 f7 8e ff ff       	call   80100390 <panic>
80107499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074a0 <count_ones>:
unsigned int count_ones(unsigned int n) { 
801074a0:	55                   	push   %ebp
    unsigned int count = 0; 
801074a1:	31 c0                	xor    %eax,%eax
unsigned int count_ones(unsigned int n) { 
801074a3:	89 e5                	mov    %esp,%ebp
801074a5:	8b 55 08             	mov    0x8(%ebp),%edx
    while (n) { 
801074a8:	85 d2                	test   %edx,%edx
801074aa:	74 0f                	je     801074bb <count_ones+0x1b>
801074ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1; 
801074b0:	89 d1                	mov    %edx,%ecx
801074b2:	83 e1 01             	and    $0x1,%ecx
801074b5:	01 c8                	add    %ecx,%eax
    while (n) { 
801074b7:	d1 ea                	shr    %edx
801074b9:	75 f5                	jne    801074b0 <count_ones+0x10>
} 
801074bb:	5d                   	pop    %ebp
801074bc:	c3                   	ret    
801074bd:	8d 76 00             	lea    0x0(%esi),%esi

801074c0 <find_page_to_swap_lapa>:
struct pageinfo* find_page_to_swap_lapa(struct proc* p, pde_t* pgdir){
801074c0:	55                   	push   %ebp
801074c1:	89 e5                	mov    %esp,%ebp
801074c3:	57                   	push   %edi
801074c4:	56                   	push   %esi
801074c5:	53                   	push   %ebx
801074c6:	8d 5d a8             	lea    -0x58(%ebp),%ebx
801074c9:	83 ec 5c             	sub    $0x5c,%esp
801074cc:	8b 45 08             	mov    0x8(%ebp),%eax
801074cf:	8d b0 00 02 00 00    	lea    0x200(%eax),%esi
801074d5:	89 f7                	mov    %esi,%edi
801074d7:	eb 25                	jmp    801074fe <find_page_to_swap_lapa+0x3e>
801074d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d, ",num_of_ones[i]);
801074e0:	83 ec 08             	sub    $0x8,%esp
801074e3:	83 c3 04             	add    $0x4,%ebx
801074e6:	83 c7 18             	add    $0x18,%edi
801074e9:	52                   	push   %edx
801074ea:	68 d4 90 10 80       	push   $0x801090d4
801074ef:	e8 6c 91 ff ff       	call   80100660 <cprintf>
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
801074f4:	8d 45 e8             	lea    -0x18(%ebp),%eax
801074f7:	83 c4 10             	add    $0x10,%esp
801074fa:	39 c3                	cmp    %eax,%ebx
801074fc:	74 32                	je     80107530 <find_page_to_swap_lapa+0x70>
    if (!p->ram_pages[i].is_free){
801074fe:	8b 0f                	mov    (%edi),%ecx
    num_of_ones[i]= MAX_UINT;
80107500:	c7 03 ff ff ff ff    	movl   $0xffffffff,(%ebx)
80107506:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    if (!p->ram_pages[i].is_free){
8010750b:	85 c9                	test   %ecx,%ecx
8010750d:	75 d1                	jne    801074e0 <find_page_to_swap_lapa+0x20>
      num_of_ones[i]= count_ones(p->ram_pages[i].aging_counter);
8010750f:	8b 47 08             	mov    0x8(%edi),%eax
    unsigned int count = 0; 
80107512:	31 d2                	xor    %edx,%edx
    while (n) { 
80107514:	85 c0                	test   %eax,%eax
80107516:	74 13                	je     8010752b <find_page_to_swap_lapa+0x6b>
80107518:	90                   	nop
80107519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1; 
80107520:	89 c1                	mov    %eax,%ecx
80107522:	83 e1 01             	and    $0x1,%ecx
80107525:	01 ca                	add    %ecx,%edx
    while (n) { 
80107527:	d1 e8                	shr    %eax
80107529:	75 f5                	jne    80107520 <find_page_to_swap_lapa+0x60>
      num_of_ones[i]= count_ones(p->ram_pages[i].aging_counter);
8010752b:	89 13                	mov    %edx,(%ebx)
8010752d:	eb b1                	jmp    801074e0 <find_page_to_swap_lapa+0x20>
8010752f:	90                   	nop
  cprintf("\n");
80107530:	83 ec 0c             	sub    $0xc,%esp
  struct pageinfo* min_pi = 0;
80107533:	31 ff                	xor    %edi,%edi
  uint min_num_of_ones = 0xFFFFFFFF;
80107535:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  cprintf("\n");
8010753a:	68 08 92 10 80       	push   $0x80109208
8010753f:	e8 1c 91 ff ff       	call   80100660 <cprintf>
  uint min_age_value = 0xFFFFFFFF;
80107544:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  cprintf("\n");
80107549:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
8010754c:	31 d2                	xor    %edx,%edx
  uint min_num_of_ones = 0xFFFFFFFF;
8010754e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
80107551:	eb 1a                	jmp    8010756d <find_page_to_swap_lapa+0xad>
80107553:	90                   	nop
80107554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107558:	8b 46 08             	mov    0x8(%esi),%eax
8010755b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
8010755e:	89 f7                	mov    %esi,%edi
    if (!pi->is_free && ((num_of_ones[i] < min_num_of_ones)||(num_of_ones[i] == min_num_of_ones &&  pi->aging_counter < min_age_value))){
80107560:	89 cb                	mov    %ecx,%ebx
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107562:	83 c2 01             	add    $0x1,%edx
80107565:	83 c6 18             	add    $0x18,%esi
80107568:	83 fa 10             	cmp    $0x10,%edx
8010756b:	74 23                	je     80107590 <find_page_to_swap_lapa+0xd0>
    if (!pi->is_free && ((num_of_ones[i] < min_num_of_ones)||(num_of_ones[i] == min_num_of_ones &&  pi->aging_counter < min_age_value))){
8010756d:	8b 06                	mov    (%esi),%eax
8010756f:	85 c0                	test   %eax,%eax
80107571:	75 ef                	jne    80107562 <find_page_to_swap_lapa+0xa2>
80107573:	8b 4c 95 a8          	mov    -0x58(%ebp,%edx,4),%ecx
80107577:	39 d9                	cmp    %ebx,%ecx
80107579:	72 dd                	jb     80107558 <find_page_to_swap_lapa+0x98>
8010757b:	75 e5                	jne    80107562 <find_page_to_swap_lapa+0xa2>
8010757d:	8b 46 08             	mov    0x8(%esi),%eax
80107580:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
80107583:	73 dd                	jae    80107562 <find_page_to_swap_lapa+0xa2>
80107585:	89 45 a4             	mov    %eax,-0x5c(%ebp)
80107588:	eb d4                	jmp    8010755e <find_page_to_swap_lapa+0x9e>
8010758a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  cprintf("min_age: %d\n",min_pi->aging_counter);
80107590:	83 ec 08             	sub    $0x8,%esp
80107593:	ff 77 08             	pushl  0x8(%edi)
80107596:	68 d9 90 10 80       	push   $0x801090d9
8010759b:	e8 c0 90 ff ff       	call   80100660 <cprintf>
}
801075a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075a3:	89 f8                	mov    %edi,%eax
801075a5:	5b                   	pop    %ebx
801075a6:	5e                   	pop    %esi
801075a7:	5f                   	pop    %edi
801075a8:	5d                   	pop    %ebp
801075a9:	c3                   	ret    
801075aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075b0 <find_page_to_swap>:
struct pageinfo* find_page_to_swap(struct proc* p, pde_t* pgdir){
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	56                   	push   %esi
801075b4:	53                   	push   %ebx
801075b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801075b8:	8b 75 0c             	mov    0xc(%ebp),%esi
    update_age(p);
801075bb:	83 ec 0c             	sub    $0xc,%esp
801075be:	53                   	push   %ebx
801075bf:	e8 2c fe ff ff       	call   801073f0 <update_age>
    pi = find_page_to_swap_lapa(p,pgdir);
801075c4:	89 75 0c             	mov    %esi,0xc(%ebp)
801075c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
801075ca:	83 c4 10             	add    $0x10,%esp
}
801075cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075d0:	5b                   	pop    %ebx
801075d1:	5e                   	pop    %esi
801075d2:	5d                   	pop    %ebp
    pi = find_page_to_swap_lapa(p,pgdir);
801075d3:	e9 e8 fe ff ff       	jmp    801074c0 <find_page_to_swap_lapa>
801075d8:	90                   	nop
801075d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075e0 <find_page_to_swap1>:
struct pageinfo* find_page_to_swap1(struct proc* p, pde_t* pgdir){
801075e0:	55                   	push   %ebp
  j = j % 16;
801075e1:	99                   	cltd   
801075e2:	c1 ea 1c             	shr    $0x1c,%edx
struct pageinfo* find_page_to_swap1(struct proc* p, pde_t* pgdir){
801075e5:	89 e5                	mov    %esp,%ebp
801075e7:	57                   	push   %edi
801075e8:	56                   	push   %esi
801075e9:	53                   	push   %ebx
  j = j % 16;
801075ea:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
801075ed:	83 e3 0f             	and    $0xf,%ebx
struct pageinfo* find_page_to_swap1(struct proc* p, pde_t* pgdir){
801075f0:	83 ec 14             	sub    $0x14,%esp
  j = j % 16;
801075f3:	29 d3                	sub    %edx,%ebx
  cprintf("%d\n", j);
801075f5:	53                   	push   %ebx
  for (int i = j; i != (j - 1) % 16; i = (i + 1) % 16){
801075f6:	8d 73 ff             	lea    -0x1(%ebx),%esi
  cprintf("%d\n", j);
801075f9:	68 d0 90 10 80       	push   $0x801090d0
801075fe:	e8 5d 90 ff ff       	call   80100660 <cprintf>
  for (int i = j; i != (j - 1) % 16; i = (i + 1) % 16){
80107603:	89 f0                	mov    %esi,%eax
80107605:	83 c4 10             	add    $0x10,%esp
80107608:	c1 f8 1f             	sar    $0x1f,%eax
8010760b:	c1 e8 1c             	shr    $0x1c,%eax
8010760e:	01 c6                	add    %eax,%esi
80107610:	83 e6 0f             	and    $0xf,%esi
80107613:	29 c6                	sub    %eax,%esi
80107615:	39 f3                	cmp    %esi,%ebx
80107617:	74 57                	je     80107670 <find_page_to_swap1+0x90>
80107619:	89 df                	mov    %ebx,%edi
8010761b:	eb 17                	jmp    80107634 <find_page_to_swap1+0x54>
8010761d:	8d 76 00             	lea    0x0(%esi),%esi
80107620:	8d 47 01             	lea    0x1(%edi),%eax
80107623:	99                   	cltd   
80107624:	c1 ea 1c             	shr    $0x1c,%edx
80107627:	01 d0                	add    %edx,%eax
80107629:	83 e0 0f             	and    $0xf,%eax
8010762c:	29 d0                	sub    %edx,%eax
8010762e:	39 f0                	cmp    %esi,%eax
80107630:	89 c7                	mov    %eax,%edi
80107632:	74 3c                	je     80107670 <find_page_to_swap1+0x90>
    cprintf("%d\n", j);
80107634:	83 ec 08             	sub    $0x8,%esp
80107637:	53                   	push   %ebx
80107638:	68 d0 90 10 80       	push   $0x801090d0
8010763d:	e8 1e 90 ff ff       	call   80100660 <cprintf>
    if (!p->ram_pages[i].is_free){
80107642:	8d 14 7f             	lea    (%edi,%edi,2),%edx
80107645:	8b 45 08             	mov    0x8(%ebp),%eax
80107648:	83 c4 10             	add    $0x10,%esp
8010764b:	c1 e2 03             	shl    $0x3,%edx
8010764e:	8b 8c 10 00 02 00 00 	mov    0x200(%eax,%edx,1),%ecx
80107655:	85 c9                	test   %ecx,%ecx
80107657:	75 c7                	jne    80107620 <find_page_to_swap1+0x40>
}
80107659:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return &p->ram_pages[i];
8010765c:	8d 84 10 00 02 00 00 	lea    0x200(%eax,%edx,1),%eax
}
80107663:	5b                   	pop    %ebx
80107664:	5e                   	pop    %esi
80107665:	5f                   	pop    %edi
80107666:	5d                   	pop    %ebp
80107667:	c3                   	ret    
80107668:	90                   	nop
80107669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107670:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107673:	31 c0                	xor    %eax,%eax
}
80107675:	5b                   	pop    %ebx
80107676:	5e                   	pop    %esi
80107677:	5f                   	pop    %edi
80107678:	5d                   	pop    %ebp
80107679:	c3                   	ret    
8010767a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107680 <seginit>:
{
80107680:	55                   	push   %ebp
80107681:	89 e5                	mov    %esp,%ebp
80107683:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107686:	e8 65 c9 ff ff       	call   80103ff0 <cpuid>
8010768b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107691:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107696:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010769a:	c7 80 78 28 12 80 ff 	movl   $0xffff,-0x7fedd788(%eax)
801076a1:	ff 00 00 
801076a4:	c7 80 7c 28 12 80 00 	movl   $0xcf9a00,-0x7fedd784(%eax)
801076ab:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801076ae:	c7 80 80 28 12 80 ff 	movl   $0xffff,-0x7fedd780(%eax)
801076b5:	ff 00 00 
801076b8:	c7 80 84 28 12 80 00 	movl   $0xcf9200,-0x7fedd77c(%eax)
801076bf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801076c2:	c7 80 88 28 12 80 ff 	movl   $0xffff,-0x7fedd778(%eax)
801076c9:	ff 00 00 
801076cc:	c7 80 8c 28 12 80 00 	movl   $0xcffa00,-0x7fedd774(%eax)
801076d3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801076d6:	c7 80 90 28 12 80 ff 	movl   $0xffff,-0x7fedd770(%eax)
801076dd:	ff 00 00 
801076e0:	c7 80 94 28 12 80 00 	movl   $0xcff200,-0x7fedd76c(%eax)
801076e7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801076ea:	05 70 28 12 80       	add    $0x80122870,%eax
  pd[1] = (uint)p;
801076ef:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801076f3:	c1 e8 10             	shr    $0x10,%eax
801076f6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801076fa:	8d 45 f2             	lea    -0xe(%ebp),%eax
801076fd:	0f 01 10             	lgdtl  (%eax)
}
80107700:	c9                   	leave  
80107701:	c3                   	ret    
80107702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107710 <public_walkpgdir>:
public_walkpgdir(pde_t *pgdir, const void *va, int alloc){
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, va, alloc);
80107713:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107716:	8b 55 0c             	mov    0xc(%ebp),%edx
80107719:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010771c:	5d                   	pop    %ebp
  return walkpgdir(pgdir, va, alloc);
8010771d:	e9 be fb ff ff       	jmp    801072e0 <walkpgdir>
80107722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107730 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107730:	a1 24 1a 13 80       	mov    0x80131a24,%eax
{
80107735:	55                   	push   %ebp
80107736:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107738:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010773d:	0f 22 d8             	mov    %eax,%cr3
}
80107740:	5d                   	pop    %ebp
80107741:	c3                   	ret    
80107742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107750 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	57                   	push   %edi
80107754:	56                   	push   %esi
80107755:	53                   	push   %ebx
80107756:	83 ec 1c             	sub    $0x1c,%esp
80107759:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010775c:	85 db                	test   %ebx,%ebx
8010775e:	0f 84 cb 00 00 00    	je     8010782f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107764:	8b 43 08             	mov    0x8(%ebx),%eax
80107767:	85 c0                	test   %eax,%eax
80107769:	0f 84 da 00 00 00    	je     80107849 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010776f:	8b 43 04             	mov    0x4(%ebx),%eax
80107772:	85 c0                	test   %eax,%eax
80107774:	0f 84 c2 00 00 00    	je     8010783c <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
8010777a:	e8 a1 d5 ff ff       	call   80104d20 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010777f:	e8 dc c7 ff ff       	call   80103f60 <mycpu>
80107784:	89 c6                	mov    %eax,%esi
80107786:	e8 d5 c7 ff ff       	call   80103f60 <mycpu>
8010778b:	89 c7                	mov    %eax,%edi
8010778d:	e8 ce c7 ff ff       	call   80103f60 <mycpu>
80107792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107795:	83 c7 08             	add    $0x8,%edi
80107798:	e8 c3 c7 ff ff       	call   80103f60 <mycpu>
8010779d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801077a0:	83 c0 08             	add    $0x8,%eax
801077a3:	ba 67 00 00 00       	mov    $0x67,%edx
801077a8:	c1 e8 18             	shr    $0x18,%eax
801077ab:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801077b2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801077b9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801077bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801077c4:	83 c1 08             	add    $0x8,%ecx
801077c7:	c1 e9 10             	shr    $0x10,%ecx
801077ca:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801077d0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801077d5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801077dc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801077e1:	e8 7a c7 ff ff       	call   80103f60 <mycpu>
801077e6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801077ed:	e8 6e c7 ff ff       	call   80103f60 <mycpu>
801077f2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801077f6:	8b 73 08             	mov    0x8(%ebx),%esi
801077f9:	e8 62 c7 ff ff       	call   80103f60 <mycpu>
801077fe:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107804:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107807:	e8 54 c7 ff ff       	call   80103f60 <mycpu>
8010780c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107810:	b8 28 00 00 00       	mov    $0x28,%eax
80107815:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107818:	8b 43 04             	mov    0x4(%ebx),%eax
8010781b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107820:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107823:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107826:	5b                   	pop    %ebx
80107827:	5e                   	pop    %esi
80107828:	5f                   	pop    %edi
80107829:	5d                   	pop    %ebp
  popcli();
8010782a:	e9 31 d5 ff ff       	jmp    80104d60 <popcli>
    panic("switchuvm: no process");
8010782f:	83 ec 0c             	sub    $0xc,%esp
80107832:	68 e6 90 10 80       	push   $0x801090e6
80107837:	e8 54 8b ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010783c:	83 ec 0c             	sub    $0xc,%esp
8010783f:	68 11 91 10 80       	push   $0x80109111
80107844:	e8 47 8b ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107849:	83 ec 0c             	sub    $0xc,%esp
8010784c:	68 fc 90 10 80       	push   $0x801090fc
80107851:	e8 3a 8b ff ff       	call   80100390 <panic>
80107856:	8d 76 00             	lea    0x0(%esi),%esi
80107859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107860 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107860:	55                   	push   %ebp
80107861:	89 e5                	mov    %esp,%ebp
80107863:	57                   	push   %edi
80107864:	56                   	push   %esi
80107865:	53                   	push   %ebx
80107866:	83 ec 1c             	sub    $0x1c,%esp
80107869:	8b 75 10             	mov    0x10(%ebp),%esi
8010786c:	8b 45 08             	mov    0x8(%ebp),%eax
8010786f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107872:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107878:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010787b:	77 49                	ja     801078c6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = cow_kalloc();
8010787d:	e8 ae f9 ff ff       	call   80107230 <cow_kalloc>
  memset(mem, 0, PGSIZE);
80107882:	83 ec 04             	sub    $0x4,%esp
  mem = cow_kalloc();
80107885:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107887:	68 00 10 00 00       	push   $0x1000
8010788c:	6a 00                	push   $0x0
8010788e:	50                   	push   %eax
8010788f:	e8 6c d6 ff ff       	call   80104f00 <memset>
  // cprintf("init1");
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107894:	58                   	pop    %eax
80107895:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010789b:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078a0:	5a                   	pop    %edx
801078a1:	6a 06                	push   $0x6
801078a3:	50                   	push   %eax
801078a4:	31 d2                	xor    %edx,%edx
801078a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078a9:	e8 b2 fa ff ff       	call   80107360 <mappages>
  // cprintf("init2");
  memmove(mem, init, sz);
801078ae:	89 75 10             	mov    %esi,0x10(%ebp)
801078b1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801078b4:	83 c4 10             	add    $0x10,%esp
801078b7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801078ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078bd:	5b                   	pop    %ebx
801078be:	5e                   	pop    %esi
801078bf:	5f                   	pop    %edi
801078c0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801078c1:	e9 ea d6 ff ff       	jmp    80104fb0 <memmove>
    panic("inituvm: more than a page");
801078c6:	83 ec 0c             	sub    $0xc,%esp
801078c9:	68 25 91 10 80       	push   $0x80109125
801078ce:	e8 bd 8a ff ff       	call   80100390 <panic>
801078d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801078d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801078e0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	57                   	push   %edi
801078e4:	56                   	push   %esi
801078e5:	53                   	push   %ebx
801078e6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801078e9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801078f0:	0f 85 91 00 00 00    	jne    80107987 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801078f6:	8b 75 18             	mov    0x18(%ebp),%esi
801078f9:	31 db                	xor    %ebx,%ebx
801078fb:	85 f6                	test   %esi,%esi
801078fd:	75 1a                	jne    80107919 <loaduvm+0x39>
801078ff:	eb 6f                	jmp    80107970 <loaduvm+0x90>
80107901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107908:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010790e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107914:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107917:	76 57                	jbe    80107970 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107919:	8b 55 0c             	mov    0xc(%ebp),%edx
8010791c:	8b 45 08             	mov    0x8(%ebp),%eax
8010791f:	31 c9                	xor    %ecx,%ecx
80107921:	01 da                	add    %ebx,%edx
80107923:	e8 b8 f9 ff ff       	call   801072e0 <walkpgdir>
80107928:	85 c0                	test   %eax,%eax
8010792a:	74 4e                	je     8010797a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010792c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010792e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107931:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107936:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010793b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107941:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107944:	01 d9                	add    %ebx,%ecx
80107946:	05 00 00 00 80       	add    $0x80000000,%eax
8010794b:	57                   	push   %edi
8010794c:	51                   	push   %ecx
8010794d:	50                   	push   %eax
8010794e:	ff 75 10             	pushl  0x10(%ebp)
80107951:	e8 aa a3 ff ff       	call   80101d00 <readi>
80107956:	83 c4 10             	add    $0x10,%esp
80107959:	39 f8                	cmp    %edi,%eax
8010795b:	74 ab                	je     80107908 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010795d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107965:	5b                   	pop    %ebx
80107966:	5e                   	pop    %esi
80107967:	5f                   	pop    %edi
80107968:	5d                   	pop    %ebp
80107969:	c3                   	ret    
8010796a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107970:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107973:	31 c0                	xor    %eax,%eax
}
80107975:	5b                   	pop    %ebx
80107976:	5e                   	pop    %esi
80107977:	5f                   	pop    %edi
80107978:	5d                   	pop    %ebp
80107979:	c3                   	ret    
      panic("loaduvm: address should exist");
8010797a:	83 ec 0c             	sub    $0xc,%esp
8010797d:	68 3f 91 10 80       	push   $0x8010913f
80107982:	e8 09 8a ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107987:	83 ec 0c             	sub    $0xc,%esp
8010798a:	68 20 90 10 80       	push   $0x80109020
8010798f:	e8 fc 89 ff ff       	call   80100390 <panic>
80107994:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010799a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801079a0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801079a0:	55                   	push   %ebp
801079a1:	89 e5                	mov    %esp,%ebp
801079a3:	57                   	push   %edi
801079a4:	56                   	push   %esi
801079a5:	53                   	push   %ebx
801079a6:	83 ec 1c             	sub    $0x1c,%esp
801079a9:	8b 75 0c             	mov    0xc(%ebp),%esi
801079ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  pte_t *pte;
  uint a, pa;
  struct proc* p = myproc();
801079af:	e8 5c c6 ff ff       	call   80104010 <myproc>

  if(newsz >= oldsz)
801079b4:	39 75 10             	cmp    %esi,0x10(%ebp)
  struct proc* p = myproc();
801079b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldsz;
801079ba:	89 f0                	mov    %esi,%eax
  if(newsz >= oldsz)
801079bc:	0f 83 8f 00 00 00    	jae    80107a51 <deallocuvm+0xb1>

  a = PGROUNDUP(newsz);
801079c2:	8b 45 10             	mov    0x10(%ebp),%eax
801079c5:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801079cb:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801079d1:	39 de                	cmp    %ebx,%esi
801079d3:	77 54                	ja     80107a29 <deallocuvm+0x89>
801079d5:	eb 77                	jmp    80107a4e <deallocuvm+0xae>
801079d7:	89 f6                	mov    %esi,%esi
801079d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801079e0:	8b 10                	mov    (%eax),%edx
801079e2:	f6 c2 01             	test   $0x1,%dl
801079e5:	74 38                	je     80107a1f <deallocuvm+0x7f>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801079e7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801079ed:	0f 84 bf 00 00 00    	je     80107ab2 <deallocuvm+0x112>
        panic("cow_kfree");
      char *v = P2V(pa);
      cow_kfree(v);
801079f3:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801079f6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801079fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      cow_kfree(v);
801079ff:	52                   	push   %edx
80107a00:	e8 9b f7 ff ff       	call   801071a0 <cow_kfree>
      if (p->pid > 2 && pgdir == p->pgdir){
80107a05:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80107a08:	83 c4 10             	add    $0x10,%esp
80107a0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a0e:	83 79 10 02          	cmpl   $0x2,0x10(%ecx)
80107a12:	7e 05                	jle    80107a19 <deallocuvm+0x79>
80107a14:	39 79 04             	cmp    %edi,0x4(%ecx)
80107a17:	74 47                	je     80107a60 <deallocuvm+0xc0>
            p->ram_pages[i].va = 0;
            break;
          }
        }
      }
      *pte = 0;
80107a19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107a1f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a25:	39 de                	cmp    %ebx,%esi
80107a27:	76 25                	jbe    80107a4e <deallocuvm+0xae>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107a29:	31 c9                	xor    %ecx,%ecx
80107a2b:	89 da                	mov    %ebx,%edx
80107a2d:	89 f8                	mov    %edi,%eax
80107a2f:	e8 ac f8 ff ff       	call   801072e0 <walkpgdir>
    if(!pte)
80107a34:	85 c0                	test   %eax,%eax
80107a36:	75 a8                	jne    801079e0 <deallocuvm+0x40>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107a38:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107a3e:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107a44:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a4a:	39 de                	cmp    %ebx,%esi
80107a4c:	77 db                	ja     80107a29 <deallocuvm+0x89>
    }
  }

  return newsz;
80107a4e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a54:	5b                   	pop    %ebx
80107a55:	5e                   	pop    %esi
80107a56:	5f                   	pop    %edi
80107a57:	5d                   	pop    %ebp
80107a58:	c3                   	ret    
80107a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a60:	81 c1 10 02 00 00    	add    $0x210,%ecx
        for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107a66:	31 d2                	xor    %edx,%edx
80107a68:	eb 11                	jmp    80107a7b <deallocuvm+0xdb>
80107a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a70:	83 c2 01             	add    $0x1,%edx
80107a73:	83 c1 18             	add    $0x18,%ecx
80107a76:	83 fa 10             	cmp    $0x10,%edx
80107a79:	74 9e                	je     80107a19 <deallocuvm+0x79>
          if (p->ram_pages[i].va == (void*)a){
80107a7b:	3b 19                	cmp    (%ecx),%ebx
80107a7d:	75 f1                	jne    80107a70 <deallocuvm+0xd0>
            p->num_of_actual_pages_in_mem--;
80107a7f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
            p->ram_pages[i].is_free = 1;
80107a82:	8d 14 52             	lea    (%edx,%edx,2),%edx
80107a85:	8d 14 d1             	lea    (%ecx,%edx,8),%edx
            p->num_of_actual_pages_in_mem--;
80107a88:	83 a9 84 03 00 00 01 	subl   $0x1,0x384(%ecx)
            p->ram_pages[i].is_free = 1;
80107a8f:	c7 82 00 02 00 00 01 	movl   $0x1,0x200(%edx)
80107a96:	00 00 00 
            p->ram_pages[i].aging_counter = 0XFFFFFFFF;//NFUA
80107a99:	c7 82 08 02 00 00 ff 	movl   $0xffffffff,0x208(%edx)
80107aa0:	ff ff ff 
            p->ram_pages[i].va = 0;
80107aa3:	c7 82 10 02 00 00 00 	movl   $0x0,0x210(%edx)
80107aaa:	00 00 00 
            break;
80107aad:	e9 67 ff ff ff       	jmp    80107a19 <deallocuvm+0x79>
        panic("cow_kfree");
80107ab2:	83 ec 0c             	sub    $0xc,%esp
80107ab5:	68 5d 91 10 80       	push   $0x8010915d
80107aba:	e8 d1 88 ff ff       	call   80100390 <panic>
80107abf:	90                   	nop

80107ac0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107ac0:	55                   	push   %ebp
80107ac1:	89 e5                	mov    %esp,%ebp
80107ac3:	57                   	push   %edi
80107ac4:	56                   	push   %esi
80107ac5:	53                   	push   %ebx
80107ac6:	83 ec 0c             	sub    $0xc,%esp
80107ac9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;
  struct proc* p = myproc();
80107acc:	e8 3f c5 ff ff       	call   80104010 <myproc>
  if(pgdir == 0)
80107ad1:	85 f6                	test   %esi,%esi
80107ad3:	0f 84 de 00 00 00    	je     80107bb7 <freevm+0xf7>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80107ad9:	83 ec 04             	sub    $0x4,%esp
80107adc:	89 c3                	mov    %eax,%ebx
80107ade:	6a 00                	push   $0x0
80107ae0:	68 00 00 00 80       	push   $0x80000000
80107ae5:	56                   	push   %esi
80107ae6:	e8 b5 fe ff ff       	call   801079a0 <deallocuvm>
  if (p->pid > 2 && p->pgdir == pgdir){
80107aeb:	83 c4 10             	add    $0x10,%esp
80107aee:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80107af2:	7e 05                	jle    80107af9 <freevm+0x39>
80107af4:	39 73 04             	cmp    %esi,0x4(%ebx)
80107af7:	74 48                	je     80107b41 <freevm+0x81>
80107af9:	89 f3                	mov    %esi,%ebx
80107afb:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107b01:	eb 0c                	jmp    80107b0f <freevm+0x4f>
80107b03:	90                   	nop
80107b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107b08:	83 c3 04             	add    $0x4,%ebx
      p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
    }
  }
  for(i = 0; i < NPDENTRIES; i++){
80107b0b:	39 fb                	cmp    %edi,%ebx
80107b0d:	74 23                	je     80107b32 <freevm+0x72>
    if(pgdir[i] & PTE_P){
80107b0f:	8b 03                	mov    (%ebx),%eax
80107b11:	a8 01                	test   $0x1,%al
80107b13:	74 f3                	je     80107b08 <freevm+0x48>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107b15:	25 00 f0 ff ff       	and    $0xfffff000,%eax
       cow_kfree(v);
80107b1a:	83 ec 0c             	sub    $0xc,%esp
80107b1d:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107b20:	05 00 00 00 80       	add    $0x80000000,%eax
       cow_kfree(v);
80107b25:	50                   	push   %eax
80107b26:	e8 75 f6 ff ff       	call   801071a0 <cow_kfree>
80107b2b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107b2e:	39 fb                	cmp    %edi,%ebx
80107b30:	75 dd                	jne    80107b0f <freevm+0x4f>
    }
  }
   cow_kfree((char*)pgdir);
80107b32:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b38:	5b                   	pop    %ebx
80107b39:	5e                   	pop    %esi
80107b3a:	5f                   	pop    %edi
80107b3b:	5d                   	pop    %ebp
   cow_kfree((char*)pgdir);
80107b3c:	e9 5f f6 ff ff       	jmp    801071a0 <cow_kfree>
    p->num_of_actual_pages_in_mem = 0;
80107b41:	c7 83 84 03 00 00 00 	movl   $0x0,0x384(%ebx)
80107b48:	00 00 00 
    p->num_of_pages_in_swap_file = 0;
80107b4b:	c7 83 80 03 00 00 00 	movl   $0x0,0x380(%ebx)
80107b52:	00 00 00 
80107b55:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80107b5b:	81 c3 00 02 00 00    	add    $0x200,%ebx
80107b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80107b68:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80107b6e:	c7 80 80 01 00 00 01 	movl   $0x1,0x180(%eax)
80107b75:	00 00 00 
80107b78:	83 c0 18             	add    $0x18,%eax
      p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
80107b7b:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
80107b82:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
80107b89:	00 00 00 
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80107b8c:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
80107b93:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
80107b9a:	00 00 00 
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80107b9d:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80107ba4:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
80107bab:	00 00 00 
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107bae:	39 d8                	cmp    %ebx,%eax
80107bb0:	75 b6                	jne    80107b68 <freevm+0xa8>
80107bb2:	e9 42 ff ff ff       	jmp    80107af9 <freevm+0x39>
    panic("freevm: no pgdir");
80107bb7:	83 ec 0c             	sub    $0xc,%esp
80107bba:	68 67 91 10 80       	push   $0x80109167
80107bbf:	e8 cc 87 ff ff       	call   80100390 <panic>
80107bc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107bca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107bd0 <setupkvm>:
{
80107bd0:	55                   	push   %ebp
80107bd1:	89 e5                	mov    %esp,%ebp
80107bd3:	56                   	push   %esi
80107bd4:	53                   	push   %ebx
  if((pgdir = (pde_t*)cow_kalloc()) == 0)
80107bd5:	e8 56 f6 ff ff       	call   80107230 <cow_kalloc>
80107bda:	85 c0                	test   %eax,%eax
80107bdc:	89 c6                	mov    %eax,%esi
80107bde:	74 42                	je     80107c22 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107be0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
80107be3:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107be8:	68 00 10 00 00       	push   $0x1000
80107bed:	6a 00                	push   $0x0
80107bef:	50                   	push   %eax
80107bf0:	e8 0b d3 ff ff       	call   80104f00 <memset>
80107bf5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107bf8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107bfb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107bfe:	83 ec 08             	sub    $0x8,%esp
80107c01:	8b 13                	mov    (%ebx),%edx
80107c03:	ff 73 0c             	pushl  0xc(%ebx)
80107c06:	50                   	push   %eax
80107c07:	29 c1                	sub    %eax,%ecx
80107c09:	89 f0                	mov    %esi,%eax
80107c0b:	e8 50 f7 ff ff       	call   80107360 <mappages>
80107c10:	83 c4 10             	add    $0x10,%esp
80107c13:	85 c0                	test   %eax,%eax
80107c15:	78 19                	js     80107c30 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
80107c17:	83 c3 10             	add    $0x10,%ebx
80107c1a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107c20:	75 d6                	jne    80107bf8 <setupkvm+0x28>
}
80107c22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107c25:	89 f0                	mov    %esi,%eax
80107c27:	5b                   	pop    %ebx
80107c28:	5e                   	pop    %esi
80107c29:	5d                   	pop    %ebp
80107c2a:	c3                   	ret    
80107c2b:	90                   	nop
80107c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107c30:	83 ec 0c             	sub    $0xc,%esp
80107c33:	56                   	push   %esi
      return 0;
80107c34:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107c36:	e8 85 fe ff ff       	call   80107ac0 <freevm>
      return 0;
80107c3b:	83 c4 10             	add    $0x10,%esp
}
80107c3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107c41:	89 f0                	mov    %esi,%eax
80107c43:	5b                   	pop    %ebx
80107c44:	5e                   	pop    %esi
80107c45:	5d                   	pop    %ebp
80107c46:	c3                   	ret    
80107c47:	89 f6                	mov    %esi,%esi
80107c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c50 <kvmalloc>:
{
80107c50:	55                   	push   %ebp
80107c51:	89 e5                	mov    %esp,%ebp
80107c53:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107c56:	e8 75 ff ff ff       	call   80107bd0 <setupkvm>
80107c5b:	a3 24 1a 13 80       	mov    %eax,0x80131a24
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107c60:	05 00 00 00 80       	add    $0x80000000,%eax
80107c65:	0f 22 d8             	mov    %eax,%cr3
}
80107c68:	c9                   	leave  
80107c69:	c3                   	ret    
80107c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107c70 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107c70:	55                   	push   %ebp
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
80107c71:	31 c9                	xor    %ecx,%ecx
{
80107c73:	89 e5                	mov    %esp,%ebp
80107c75:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107c78:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c7b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c7e:	e8 5d f6 ff ff       	call   801072e0 <walkpgdir>
  if(pte == 0)
80107c83:	85 c0                	test   %eax,%eax
80107c85:	74 05                	je     80107c8c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107c87:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107c8a:	c9                   	leave  
80107c8b:	c3                   	ret    
    panic("clearpteu");
80107c8c:	83 ec 0c             	sub    $0xc,%esp
80107c8f:	68 78 91 10 80       	push   $0x80109178
80107c94:	e8 f7 86 ff ff       	call   80100390 <panic>
80107c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107ca0 <cow_copyuvm>:

pde_t*
cow_copyuvm(pde_t *pgdir, uint sz)
{
80107ca0:	55                   	push   %ebp
80107ca1:	89 e5                	mov    %esp,%ebp
80107ca3:	57                   	push   %edi
80107ca4:	56                   	push   %esi
80107ca5:	53                   	push   %ebx
80107ca6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  if((d = setupkvm()) == 0)
80107ca9:	e8 22 ff ff ff       	call   80107bd0 <setupkvm>
80107cae:	85 c0                	test   %eax,%eax
80107cb0:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107cb3:	0f 84 d0 00 00 00    	je     80107d89 <cow_copyuvm+0xe9>
    return 0;
  //cprintf("cow : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());

  // cprintf("cow_copyuvm : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());
  for(i = 0; i < sz; i += PGSIZE){
80107cb9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107cbc:	85 db                	test   %ebx,%ebx
80107cbe:	0f 84 c5 00 00 00    	je     80107d89 <cow_copyuvm+0xe9>
80107cc4:	31 ff                	xor    %edi,%edi
80107cc6:	eb 1e                	jmp    80107ce6 <cow_copyuvm+0x46>
80107cc8:	90                   	nop
80107cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      // cprintf("cow2");
      goto bad;
    }
    // cprintf("cow2");
    // update parents flags
    *pte |= (PTE_W & flags ? PTE_COW : 0);
80107cd0:	0b 1e                	or     (%esi),%ebx
  for(i = 0; i < sz; i += PGSIZE){
80107cd2:	81 c7 00 10 00 00    	add    $0x1000,%edi
    *pte &= (~PTE_W);
80107cd8:	83 e3 fd             	and    $0xfffffffd,%ebx
  for(i = 0; i < sz; i += PGSIZE){
80107cdb:	39 7d 0c             	cmp    %edi,0xc(%ebp)
    *pte &= (~PTE_W);
80107cde:	89 1e                	mov    %ebx,(%esi)
  for(i = 0; i < sz; i += PGSIZE){
80107ce0:	0f 86 a3 00 00 00    	jbe    80107d89 <cow_copyuvm+0xe9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80107ce9:	31 c9                	xor    %ecx,%ecx
80107ceb:	89 fa                	mov    %edi,%edx
80107ced:	e8 ee f5 ff ff       	call   801072e0 <walkpgdir>
80107cf2:	85 c0                	test   %eax,%eax
80107cf4:	89 c6                	mov    %eax,%esi
80107cf6:	0f 84 a5 00 00 00    	je     80107da1 <cow_copyuvm+0x101>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80107cfc:	f7 00 01 02 00 00    	testl  $0x201,(%eax)
80107d02:	0f 84 8c 00 00 00    	je     80107d94 <cow_copyuvm+0xf4>
    acquire(cow_lock);
80107d08:	83 ec 0c             	sub    $0xc,%esp
80107d0b:	ff 35 40 ff 11 80    	pushl  0x8011ff40
80107d11:	e8 da d0 ff ff       	call   80104df0 <acquire>
    pa = PTE_ADDR(*pte);
80107d16:	8b 06                	mov    (%esi),%eax
80107d18:	89 c2                	mov    %eax,%edx
80107d1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    release(cow_lock);
80107d1d:	58                   	pop    %eax
    pa = PTE_ADDR(*pte);
80107d1e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    release(cow_lock);
80107d24:	ff 35 40 ff 11 80    	pushl  0x8011ff40
    pg_ref_counts[PGROUNDDOWN(pa)/PGSIZE]++;
80107d2a:	89 d1                	mov    %edx,%ecx
80107d2c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107d2f:	c1 e9 0c             	shr    $0xc,%ecx
80107d32:	80 81 40 1f 11 80 01 	addb   $0x1,-0x7feee0c0(%ecx)
    release(cow_lock);
80107d39:	e8 72 d1 ff ff       	call   80104eb0 <release>
    if(mappages(d, (void*)i, PGSIZE, pa, (flags & (~PTE_W)) | (PTE_W & flags ? PTE_COW : 0)) < 0) {
80107d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107d41:	5a                   	pop    %edx
80107d42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107d45:	89 c3                	mov    %eax,%ebx
80107d47:	25 fd 0f 00 00       	and    $0xffd,%eax
80107d4c:	c1 e3 0a             	shl    $0xa,%ebx
80107d4f:	81 e3 00 08 00 00    	and    $0x800,%ebx
80107d55:	59                   	pop    %ecx
80107d56:	09 d8                	or     %ebx,%eax
80107d58:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d5d:	50                   	push   %eax
80107d5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107d61:	52                   	push   %edx
80107d62:	89 fa                	mov    %edi,%edx
80107d64:	e8 f7 f5 ff ff       	call   80107360 <mappages>
80107d69:	83 c4 10             	add    $0x10,%esp
80107d6c:	85 c0                	test   %eax,%eax
80107d6e:	0f 89 5c ff ff ff    	jns    80107cd0 <cow_copyuvm+0x30>
  }
  return d;

bad:
  // release(cow_lock);
  freevm(d);
80107d74:	83 ec 0c             	sub    $0xc,%esp
80107d77:	ff 75 dc             	pushl  -0x24(%ebp)
80107d7a:	e8 41 fd ff ff       	call   80107ac0 <freevm>
  return 0;
80107d7f:	83 c4 10             	add    $0x10,%esp
80107d82:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80107d89:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107d8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d8f:	5b                   	pop    %ebx
80107d90:	5e                   	pop    %esi
80107d91:	5f                   	pop    %edi
80107d92:	5d                   	pop    %ebp
80107d93:	c3                   	ret    
      panic("copyuvm: page not present");
80107d94:	83 ec 0c             	sub    $0xc,%esp
80107d97:	68 9c 91 10 80       	push   $0x8010919c
80107d9c:	e8 ef 85 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107da1:	83 ec 0c             	sub    $0xc,%esp
80107da4:	68 82 91 10 80       	push   $0x80109182
80107da9:	e8 e2 85 ff ff       	call   80100390 <panic>
80107dae:	66 90                	xchg   %ax,%ax

80107db0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107db0:	55                   	push   %ebp
80107db1:	89 e5                	mov    %esp,%ebp
80107db3:	57                   	push   %edi
80107db4:	56                   	push   %esi
80107db5:	53                   	push   %ebx
80107db6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107db9:	e8 12 fe ff ff       	call   80107bd0 <setupkvm>
80107dbe:	85 c0                	test   %eax,%eax
80107dc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107dc3:	0f 84 a2 00 00 00    	je     80107e6b <copyuvm+0xbb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107dc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107dcc:	85 c9                	test   %ecx,%ecx
80107dce:	0f 84 97 00 00 00    	je     80107e6b <copyuvm+0xbb>
80107dd4:	31 ff                	xor    %edi,%edi
80107dd6:	eb 4a                	jmp    80107e22 <copyuvm+0x72>
80107dd8:	90                   	nop
80107dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = cow_kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107de0:	83 ec 04             	sub    $0x4,%esp
80107de3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107de9:	68 00 10 00 00       	push   $0x1000
80107dee:	53                   	push   %ebx
80107def:	50                   	push   %eax
80107df0:	e8 bb d1 ff ff       	call   80104fb0 <memmove>
    // cprintf("copy1");
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107df5:	58                   	pop    %eax
80107df6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107dfc:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107e01:	5a                   	pop    %edx
80107e02:	ff 75 e4             	pushl  -0x1c(%ebp)
80107e05:	50                   	push   %eax
80107e06:	89 fa                	mov    %edi,%edx
80107e08:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e0b:	e8 50 f5 ff ff       	call   80107360 <mappages>
80107e10:	83 c4 10             	add    $0x10,%esp
80107e13:	85 c0                	test   %eax,%eax
80107e15:	78 69                	js     80107e80 <copyuvm+0xd0>
  for(i = 0; i < sz; i += PGSIZE){
80107e17:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107e1d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107e20:	76 49                	jbe    80107e6b <copyuvm+0xbb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107e22:	8b 45 08             	mov    0x8(%ebp),%eax
80107e25:	31 c9                	xor    %ecx,%ecx
80107e27:	89 fa                	mov    %edi,%edx
80107e29:	e8 b2 f4 ff ff       	call   801072e0 <walkpgdir>
80107e2e:	85 c0                	test   %eax,%eax
80107e30:	74 69                	je     80107e9b <copyuvm+0xeb>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80107e32:	8b 00                	mov    (%eax),%eax
80107e34:	a9 01 02 00 00       	test   $0x201,%eax
80107e39:	74 53                	je     80107e8e <copyuvm+0xde>
    pa = PTE_ADDR(*pte);
80107e3b:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80107e3d:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80107e42:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107e48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = cow_kalloc()) == 0)
80107e4b:	e8 e0 f3 ff ff       	call   80107230 <cow_kalloc>
80107e50:	85 c0                	test   %eax,%eax
80107e52:	89 c6                	mov    %eax,%esi
80107e54:	75 8a                	jne    80107de0 <copyuvm+0x30>
    // cprintf("copy2");
  }
  return d;

bad:
  freevm(d);
80107e56:	83 ec 0c             	sub    $0xc,%esp
80107e59:	ff 75 e0             	pushl  -0x20(%ebp)
80107e5c:	e8 5f fc ff ff       	call   80107ac0 <freevm>
  return 0;
80107e61:	83 c4 10             	add    $0x10,%esp
80107e64:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107e6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e71:	5b                   	pop    %ebx
80107e72:	5e                   	pop    %esi
80107e73:	5f                   	pop    %edi
80107e74:	5d                   	pop    %ebp
80107e75:	c3                   	ret    
80107e76:	8d 76 00             	lea    0x0(%esi),%esi
80107e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
       cow_kfree(mem);
80107e80:	83 ec 0c             	sub    $0xc,%esp
80107e83:	56                   	push   %esi
80107e84:	e8 17 f3 ff ff       	call   801071a0 <cow_kfree>
      goto bad;
80107e89:	83 c4 10             	add    $0x10,%esp
80107e8c:	eb c8                	jmp    80107e56 <copyuvm+0xa6>
      panic("copyuvm: page not present");
80107e8e:	83 ec 0c             	sub    $0xc,%esp
80107e91:	68 9c 91 10 80       	push   $0x8010919c
80107e96:	e8 f5 84 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107e9b:	83 ec 0c             	sub    $0xc,%esp
80107e9e:	68 82 91 10 80       	push   $0x80109182
80107ea3:	e8 e8 84 ff ff       	call   80100390 <panic>
80107ea8:	90                   	nop
80107ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107eb0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107eb0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107eb1:	31 c9                	xor    %ecx,%ecx
{
80107eb3:	89 e5                	mov    %esp,%ebp
80107eb5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ebb:	8b 45 08             	mov    0x8(%ebp),%eax
80107ebe:	e8 1d f4 ff ff       	call   801072e0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107ec3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107ec5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107ec6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107ec8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107ecd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107ed0:	05 00 00 00 80       	add    $0x80000000,%eax
80107ed5:	83 fa 05             	cmp    $0x5,%edx
80107ed8:	ba 00 00 00 00       	mov    $0x0,%edx
80107edd:	0f 45 c2             	cmovne %edx,%eax
}
80107ee0:	c3                   	ret    
80107ee1:	eb 0d                	jmp    80107ef0 <copyout>
80107ee3:	90                   	nop
80107ee4:	90                   	nop
80107ee5:	90                   	nop
80107ee6:	90                   	nop
80107ee7:	90                   	nop
80107ee8:	90                   	nop
80107ee9:	90                   	nop
80107eea:	90                   	nop
80107eeb:	90                   	nop
80107eec:	90                   	nop
80107eed:	90                   	nop
80107eee:	90                   	nop
80107eef:	90                   	nop

80107ef0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107ef0:	55                   	push   %ebp
80107ef1:	89 e5                	mov    %esp,%ebp
80107ef3:	57                   	push   %edi
80107ef4:	56                   	push   %esi
80107ef5:	53                   	push   %ebx
80107ef6:	83 ec 1c             	sub    $0x1c,%esp
80107ef9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107efc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107eff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107f02:	85 db                	test   %ebx,%ebx
80107f04:	75 40                	jne    80107f46 <copyout+0x56>
80107f06:	eb 70                	jmp    80107f78 <copyout+0x88>
80107f08:	90                   	nop
80107f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107f10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107f13:	89 f1                	mov    %esi,%ecx
80107f15:	29 d1                	sub    %edx,%ecx
80107f17:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107f1d:	39 d9                	cmp    %ebx,%ecx
80107f1f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107f22:	29 f2                	sub    %esi,%edx
80107f24:	83 ec 04             	sub    $0x4,%esp
80107f27:	01 d0                	add    %edx,%eax
80107f29:	51                   	push   %ecx
80107f2a:	57                   	push   %edi
80107f2b:	50                   	push   %eax
80107f2c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107f2f:	e8 7c d0 ff ff       	call   80104fb0 <memmove>
    len -= n;
    buf += n;
80107f34:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107f37:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107f3a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107f40:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107f42:	29 cb                	sub    %ecx,%ebx
80107f44:	74 32                	je     80107f78 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107f46:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107f48:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107f4b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107f4e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107f54:	56                   	push   %esi
80107f55:	ff 75 08             	pushl  0x8(%ebp)
80107f58:	e8 53 ff ff ff       	call   80107eb0 <uva2ka>
    if(pa0 == 0)
80107f5d:	83 c4 10             	add    $0x10,%esp
80107f60:	85 c0                	test   %eax,%eax
80107f62:	75 ac                	jne    80107f10 <copyout+0x20>
  }
  return 0;
}
80107f64:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107f67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f6c:	5b                   	pop    %ebx
80107f6d:	5e                   	pop    %esi
80107f6e:	5f                   	pop    %edi
80107f6f:	5d                   	pop    %ebp
80107f70:	c3                   	ret    
80107f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107f7b:	31 c0                	xor    %eax,%eax
}
80107f7d:	5b                   	pop    %ebx
80107f7e:	5e                   	pop    %esi
80107f7f:	5f                   	pop    %edi
80107f80:	5d                   	pop    %ebp
80107f81:	c3                   	ret    
80107f82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107f90 <swap_out>:


//  if buffer == 0 then we put buffer <-- kernel_va(page_to_swap->va)  // p2v(phiscal(va))
//  and use buffer to swap out from
//  we assume that if buffer is not 0, it is kernel virtual address
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir){
80107f90:	55                   	push   %ebp
80107f91:	89 e5                	mov    %esp,%ebp
80107f93:	57                   	push   %edi
80107f94:	56                   	push   %esi
80107f95:	53                   	push   %ebx
80107f96:	83 ec 1c             	sub    $0x1c,%esp
  // cprintf("SWAP OUT : ");
  // print_user_char(pgdir, page_to_swap->va);
  if (buffer == 0){
80107f99:	8b 75 10             	mov    0x10(%ebp),%esi
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir){
80107f9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (buffer == 0){
80107f9f:	85 f6                	test   %esi,%esi
80107fa1:	0f 84 f9 00 00 00    	je     801080a0 <swap_out+0x110>
  // swap page
  // INV  : cell swapped_out_pages[i] is free iff there isnt a page that is written in offset i * PGSIZE in the swap file
  int index;
  int found = 0;
  int count = 0;
  p->num_of_pages_in_swap_file++;
80107fa7:	8b 83 80 03 00 00    	mov    0x380(%ebx),%eax
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107fad:	31 c9                	xor    %ecx,%ecx
  p->num_of_pages_in_swap_file++;
80107faf:	83 c0 01             	add    $0x1,%eax
80107fb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107fb5:	89 83 80 03 00 00    	mov    %eax,0x380(%ebx)
80107fbb:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80107fc1:	89 c2                	mov    %eax,%edx
80107fc3:	eb 0e                	jmp    80107fd3 <swap_out+0x43>
80107fc5:	8d 76 00             	lea    0x0(%esi),%esi
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107fc8:	83 c1 01             	add    $0x1,%ecx
80107fcb:	83 c2 18             	add    $0x18,%edx
80107fce:	83 f9 10             	cmp    $0x10,%ecx
80107fd1:	74 32                	je     80108005 <swap_out+0x75>
    if (p->swapped_out_pages[index].is_free){
80107fd3:	8b 3a                	mov    (%edx),%edi
80107fd5:	85 ff                	test   %edi,%edi
80107fd7:	74 ef                	je     80107fc8 <swap_out+0x38>
      p->swapped_out_pages[index].is_free = 0;
80107fd9:	8d 14 49             	lea    (%ecx,%ecx,2),%edx
      p->swapped_out_pages[index].va = page_to_swap->va;
80107fdc:	8b 7d 0c             	mov    0xc(%ebp),%edi
      p->swapped_out_pages[index].is_free = 0;
80107fdf:	8d 14 d3             	lea    (%ebx,%edx,8),%edx
80107fe2:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
80107fe9:	00 00 00 
      p->swapped_out_pages[index].va = page_to_swap->va;
80107fec:	8b 77 10             	mov    0x10(%edi),%esi
      p->swapped_out_pages[index].swap_file_offset = index * PGSIZE;
      found = 1;
80107fef:	bf 01 00 00 00       	mov    $0x1,%edi
      p->swapped_out_pages[index].va = page_to_swap->va;
80107ff4:	89 b2 90 00 00 00    	mov    %esi,0x90(%edx)
      p->swapped_out_pages[index].swap_file_offset = index * PGSIZE;
80107ffa:	89 ce                	mov    %ecx,%esi
80107ffc:	c1 e6 0c             	shl    $0xc,%esi
80107fff:	89 b2 84 00 00 00    	mov    %esi,0x84(%edx)
80108005:	8d b3 00 02 00 00    	lea    0x200(%ebx),%esi
  int count = 0;
8010800b:	31 d2                	xor    %edx,%edx
8010800d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
  }
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
    if (!p->swapped_out_pages[i].is_free){
      count++;
80108010:	83 38 01             	cmpl   $0x1,(%eax)
80108013:	83 d2 00             	adc    $0x0,%edx
80108016:	83 c0 18             	add    $0x18,%eax
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80108019:	39 f0                	cmp    %esi,%eax
8010801b:	75 f3                	jne    80108010 <swap_out+0x80>
    }
  }
  if (!found){
8010801d:	85 ff                	test   %edi,%edi
8010801f:	0f 84 9f 00 00 00    	je     801080c4 <swap_out+0x134>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_pages_in_swap_file, count);
    panic("SWAP OUT BALAGAN- no place in swap array\n");
  }
  if (index < 0 || index > 15){
80108025:	83 f9 10             	cmp    $0x10,%ecx
80108028:	0f 84 be 00 00 00    	je     801080ec <swap_out+0x15c>
    panic("we have a bug\n");
  }
  int result = writeToSwapFile(p, buffer, index * PGSIZE, PGSIZE);
8010802e:	c1 e1 0c             	shl    $0xc,%ecx
80108031:	68 00 10 00 00       	push   $0x1000
80108036:	51                   	push   %ecx
80108037:	ff 75 10             	pushl  0x10(%ebp)
8010803a:	53                   	push   %ebx
8010803b:	e8 b0 a5 ff ff       	call   801025f0 <writeToSwapFile>
80108040:	89 c6                	mov    %eax,%esi


  
  // update flags in PTE
  pte_t* pte_ptr = walkpgdir(pgdir, page_to_swap->va, 0);
80108042:	8b 45 0c             	mov    0xc(%ebp),%eax
80108045:	31 c9                	xor    %ecx,%ecx
80108047:	8b 50 10             	mov    0x10(%eax),%edx
8010804a:	8b 45 14             	mov    0x14(%ebp),%eax
8010804d:	e8 8e f2 ff ff       	call   801072e0 <walkpgdir>
  *pte_ptr |= PTE_PG;
  *pte_ptr &= ~PTE_P;
80108052:	8b 10                	mov    (%eax),%edx
80108054:	83 e2 fe             	and    $0xfffffffe,%edx
80108057:	80 ce 02             	or     $0x2,%dh
8010805a:	89 10                	mov    %edx,(%eax)
  // *pte_ptr |= PTE_U;
  cow_kfree(buffer);
8010805c:	58                   	pop    %eax
8010805d:	ff 75 10             	pushl  0x10(%ebp)
80108060:	e8 3b f1 ff ff       	call   801071a0 <cow_kfree>
  // refresh cr3
  lcr3(V2P(p->pgdir));
80108065:	8b 43 04             	mov    0x4(%ebx),%eax
80108068:	05 00 00 00 80       	add    $0x80000000,%eax
8010806d:	0f 22 d8             	mov    %eax,%cr3
  page_to_swap->is_free = 1;
80108070:	8b 45 0c             	mov    0xc(%ebp),%eax
  if (result < 0){
80108073:	83 c4 10             	add    $0x10,%esp
80108076:	85 f6                	test   %esi,%esi
  page_to_swap->is_free = 1;
80108078:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  if (result < 0){
8010807e:	78 5f                	js     801080df <swap_out+0x14f>
    panic("swap out failed\n");
  }
  p->num_of_pageOut_occured++;
80108080:	83 83 8c 03 00 00 01 	addl   $0x1,0x38c(%ebx)
  p->num_of_actual_pages_in_mem--;
80108087:	83 ab 84 03 00 00 01 	subl   $0x1,0x384(%ebx)
}
8010808e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108091:	5b                   	pop    %ebx
80108092:	5e                   	pop    %esi
80108093:	5f                   	pop    %edi
80108094:	5d                   	pop    %ebp
80108095:	c3                   	ret    
80108096:	8d 76 00             	lea    0x0(%esi),%esi
80108099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    buffer = P2V((PTE_ADDR(*(walkpgdir(pgdir, page_to_swap->va, 0)))));
801080a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801080a3:	31 c9                	xor    %ecx,%ecx
801080a5:	8b 50 10             	mov    0x10(%eax),%edx
801080a8:	8b 45 14             	mov    0x14(%ebp),%eax
801080ab:	e8 30 f2 ff ff       	call   801072e0 <walkpgdir>
801080b0:	8b 00                	mov    (%eax),%eax
801080b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080b7:	05 00 00 00 80       	add    $0x80000000,%eax
801080bc:	89 45 10             	mov    %eax,0x10(%ebp)
801080bf:	e9 e3 fe ff ff       	jmp    80107fa7 <swap_out+0x17>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_pages_in_swap_file, count);
801080c4:	51                   	push   %ecx
801080c5:	52                   	push   %edx
801080c6:	ff 75 e4             	pushl  -0x1c(%ebp)
801080c9:	68 44 90 10 80       	push   $0x80109044
801080ce:	e8 8d 85 ff ff       	call   80100660 <cprintf>
    panic("SWAP OUT BALAGAN- no place in swap array\n");
801080d3:	c7 04 24 6c 90 10 80 	movl   $0x8010906c,(%esp)
801080da:	e8 b1 82 ff ff       	call   80100390 <panic>
    panic("swap out failed\n");
801080df:	83 ec 0c             	sub    $0xc,%esp
801080e2:	68 c5 91 10 80       	push   $0x801091c5
801080e7:	e8 a4 82 ff ff       	call   80100390 <panic>
    panic("we have a bug\n");
801080ec:	83 ec 0c             	sub    $0xc,%esp
801080ef:	68 b6 91 10 80       	push   $0x801091b6
801080f4:	e8 97 82 ff ff       	call   80100390 <panic>
801080f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108100 <allocuvm>:
{
80108100:	55                   	push   %ebp
80108101:	89 e5                	mov    %esp,%ebp
80108103:	57                   	push   %edi
80108104:	56                   	push   %esi
80108105:	53                   	push   %ebx
80108106:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* p = myproc();
80108109:	e8 02 bf ff ff       	call   80104010 <myproc>
8010810e:	89 c3                	mov    %eax,%ebx
  if(newsz >= KERNBASE)
80108110:	8b 45 10             	mov    0x10(%ebp),%eax
80108113:	85 c0                	test   %eax,%eax
80108115:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108118:	0f 88 42 01 00 00    	js     80108260 <allocuvm+0x160>
  if(newsz < oldsz)
8010811e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80108121:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80108124:	0f 82 26 01 00 00    	jb     80108250 <allocuvm+0x150>
  a = PGROUNDUP(oldsz);
8010812a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80108130:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80108136:	39 75 10             	cmp    %esi,0x10(%ebp)
80108139:	0f 86 14 01 00 00    	jbe    80108253 <allocuvm+0x153>
8010813f:	8b 4b 10             	mov    0x10(%ebx),%ecx
80108142:	eb 13                	jmp    80108157 <allocuvm+0x57>
80108144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108148:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010814e:	39 75 10             	cmp    %esi,0x10(%ebp)
80108151:	0f 86 fc 00 00 00    	jbe    80108253 <allocuvm+0x153>
    if (p->pid > 2){
80108157:	83 f9 02             	cmp    $0x2,%ecx
8010815a:	7e 4a                	jle    801081a6 <allocuvm+0xa6>
      if (p->num_of_actual_pages_in_mem >= 16){
8010815c:	8b 83 84 03 00 00    	mov    0x384(%ebx),%eax
80108162:	83 f8 0f             	cmp    $0xf,%eax
80108165:	76 36                	jbe    8010819d <allocuvm+0x9d>
        if (p->num_of_pages_in_swap_file >= 16){
80108167:	83 bb 80 03 00 00 0f 	cmpl   $0xf,0x380(%ebx)
8010816e:	0f 87 04 01 00 00    	ja     80108278 <allocuvm+0x178>
    update_age(p);
80108174:	83 ec 0c             	sub    $0xc,%esp
80108177:	53                   	push   %ebx
80108178:	e8 73 f2 ff ff       	call   801073f0 <update_age>
    pi = find_page_to_swap_lapa(p,pgdir);
8010817d:	59                   	pop    %ecx
8010817e:	5f                   	pop    %edi
8010817f:	ff 75 08             	pushl  0x8(%ebp)
80108182:	53                   	push   %ebx
80108183:	e8 38 f3 ff ff       	call   801074c0 <find_page_to_swap_lapa>
        swap_out(p, page_to_swap, 0, pgdir);
80108188:	ff 75 08             	pushl  0x8(%ebp)
8010818b:	6a 00                	push   $0x0
8010818d:	50                   	push   %eax
8010818e:	53                   	push   %ebx
8010818f:	e8 fc fd ff ff       	call   80107f90 <swap_out>
80108194:	8b 83 84 03 00 00    	mov    0x384(%ebx),%eax
8010819a:	83 c4 20             	add    $0x20,%esp
      p->num_of_actual_pages_in_mem++;
8010819d:	83 c0 01             	add    $0x1,%eax
801081a0:	89 83 84 03 00 00    	mov    %eax,0x384(%ebx)
    mem = cow_kalloc();
801081a6:	e8 85 f0 ff ff       	call   80107230 <cow_kalloc>
    if(mem == 0){
801081ab:	85 c0                	test   %eax,%eax
    mem = cow_kalloc();
801081ad:	89 c7                	mov    %eax,%edi
    if(mem == 0){
801081af:	0f 84 c3 00 00 00    	je     80108278 <allocuvm+0x178>
    memset(mem, 0, PGSIZE);
801081b5:	83 ec 04             	sub    $0x4,%esp
801081b8:	68 00 10 00 00       	push   $0x1000
801081bd:	6a 00                	push   $0x0
801081bf:	50                   	push   %eax
801081c0:	e8 3b cd ff ff       	call   80104f00 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801081c5:	58                   	pop    %eax
801081c6:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
801081cc:	b9 00 10 00 00       	mov    $0x1000,%ecx
801081d1:	5a                   	pop    %edx
801081d2:	6a 06                	push   $0x6
801081d4:	50                   	push   %eax
801081d5:	89 f2                	mov    %esi,%edx
801081d7:	8b 45 08             	mov    0x8(%ebp),%eax
801081da:	e8 81 f1 ff ff       	call   80107360 <mappages>
801081df:	83 c4 10             	add    $0x10,%esp
801081e2:	85 c0                	test   %eax,%eax
801081e4:	0f 88 c6 00 00 00    	js     801082b0 <allocuvm+0x1b0>
    if (p->pid > 2){
801081ea:	8b 4b 10             	mov    0x10(%ebx),%ecx
801081ed:	83 f9 02             	cmp    $0x2,%ecx
801081f0:	0f 8e 52 ff ff ff    	jle    80108148 <allocuvm+0x48>
801081f6:	8d 93 00 02 00 00    	lea    0x200(%ebx),%edx
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
801081fc:	31 c0                	xor    %eax,%eax
801081fe:	eb 0f                	jmp    8010820f <allocuvm+0x10f>
80108200:	83 c0 01             	add    $0x1,%eax
80108203:	83 c2 18             	add    $0x18,%edx
80108206:	83 f8 10             	cmp    $0x10,%eax
80108209:	0f 84 39 ff ff ff    	je     80108148 <allocuvm+0x48>
        if (p->ram_pages[i].is_free){
8010820f:	8b 3a                	mov    (%edx),%edi
80108211:	85 ff                	test   %edi,%edi
80108213:	74 eb                	je     80108200 <allocuvm+0x100>
          p->ram_pages[i].page_index = ++page_counter;
80108215:	8b 3d c0 c5 10 80    	mov    0x8010c5c0,%edi
          p->ram_pages[i].is_free = 0;
8010821b:	8d 04 40             	lea    (%eax,%eax,2),%eax
8010821e:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
          p->ram_pages[i].page_index = ++page_counter;
80108221:	8d 57 01             	lea    0x1(%edi),%edx
          p->ram_pages[i].is_free = 0;
80108224:	c7 80 00 02 00 00 00 	movl   $0x0,0x200(%eax)
8010822b:	00 00 00 
          p->ram_pages[i].va = (void *)a;
8010822e:	89 b0 10 02 00 00    	mov    %esi,0x210(%eax)
          p->ram_pages[i].page_index = ++page_counter;
80108234:	89 15 c0 c5 10 80    	mov    %edx,0x8010c5c0
8010823a:	89 90 0c 02 00 00    	mov    %edx,0x20c(%eax)
          p->ram_pages[i].aging_counter = 0XFFFFFFFF;//NFUA
80108240:	c7 80 08 02 00 00 ff 	movl   $0xffffffff,0x208(%eax)
80108247:	ff ff ff 
          break;
8010824a:	e9 f9 fe ff ff       	jmp    80108148 <allocuvm+0x48>
8010824f:	90                   	nop
    return oldsz;
80108250:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80108253:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108256:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108259:	5b                   	pop    %ebx
8010825a:	5e                   	pop    %esi
8010825b:	5f                   	pop    %edi
8010825c:	5d                   	pop    %ebp
8010825d:	c3                   	ret    
8010825e:	66 90                	xchg   %ax,%ax
    return 0;
80108260:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010826a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010826d:	5b                   	pop    %ebx
8010826e:	5e                   	pop    %esi
8010826f:	5f                   	pop    %edi
80108270:	5d                   	pop    %ebp
80108271:	c3                   	ret    
80108272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          cprintf("allocuvm out of memory\n");
80108278:	83 ec 0c             	sub    $0xc,%esp
8010827b:	68 d6 91 10 80       	push   $0x801091d6
80108280:	e8 db 83 ff ff       	call   80100660 <cprintf>
          deallocuvm(pgdir, newsz, oldsz);
80108285:	83 c4 0c             	add    $0xc,%esp
80108288:	ff 75 0c             	pushl  0xc(%ebp)
8010828b:	ff 75 10             	pushl  0x10(%ebp)
8010828e:	ff 75 08             	pushl  0x8(%ebp)
80108291:	e8 0a f7 ff ff       	call   801079a0 <deallocuvm>
          return 0;
80108296:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010829d:	83 c4 10             	add    $0x10,%esp
}
801082a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801082a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082a6:	5b                   	pop    %ebx
801082a7:	5e                   	pop    %esi
801082a8:	5f                   	pop    %edi
801082a9:	5d                   	pop    %ebp
801082aa:	c3                   	ret    
801082ab:	90                   	nop
801082ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
801082b0:	83 ec 0c             	sub    $0xc,%esp
801082b3:	68 ee 91 10 80       	push   $0x801091ee
801082b8:	e8 a3 83 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801082bd:	83 c4 0c             	add    $0xc,%esp
801082c0:	ff 75 0c             	pushl  0xc(%ebp)
801082c3:	ff 75 10             	pushl  0x10(%ebp)
801082c6:	ff 75 08             	pushl  0x8(%ebp)
801082c9:	e8 d2 f6 ff ff       	call   801079a0 <deallocuvm>
      cow_kfree(mem);
801082ce:	89 3c 24             	mov    %edi,(%esp)
801082d1:	e8 ca ee ff ff       	call   801071a0 <cow_kfree>
      return 0;
801082d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801082dd:	83 c4 10             	add    $0x10,%esp
}
801082e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801082e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082e6:	5b                   	pop    %ebx
801082e7:	5e                   	pop    %esi
801082e8:	5f                   	pop    %edi
801082e9:	5d                   	pop    %ebp
801082ea:	c3                   	ret    
801082eb:	90                   	nop
801082ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801082f0 <swap_in>:

// we assume there are at most MAX_PYSC_PAGES in the RAM 
int swap_in(struct proc* p, struct pageinfo* pi){
801082f0:	55                   	push   %ebp
801082f1:	89 e5                	mov    %esp,%ebp
801082f3:	57                   	push   %edi
801082f4:	56                   	push   %esi
801082f5:	53                   	push   %ebx
  // print_user_char(pgdir, pi->va);
  int found = 0;
  int index;
  int count = 0;
  // cprintf("SWAP IN: va = %d\n", pi->va);
  for (index = 0; index < MAX_PYSC_PAGES; index++){
801082f6:	31 db                	xor    %ebx,%ebx
int swap_in(struct proc* p, struct pageinfo* pi){
801082f8:	83 ec 1c             	sub    $0x1c,%esp
801082fb:	8b 75 08             	mov    0x8(%ebp),%esi
  pde_t* pgdir = p->pgdir;
801082fe:	8b 46 04             	mov    0x4(%esi),%eax
80108301:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint offset = pi->swap_file_offset;
80108304:	8b 45 0c             	mov    0xc(%ebp),%eax
80108307:	8b 40 04             	mov    0x4(%eax),%eax
8010830a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010830d:	8d 86 00 02 00 00    	lea    0x200(%esi),%eax
80108313:	89 c2                	mov    %eax,%edx
80108315:	eb 14                	jmp    8010832b <swap_in+0x3b>
80108317:	89 f6                	mov    %esi,%esi
80108319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80108320:	83 c3 01             	add    $0x1,%ebx
80108323:	83 c2 18             	add    $0x18,%edx
80108326:	83 fb 10             	cmp    $0x10,%ebx
80108329:	74 19                	je     80108344 <swap_in+0x54>
    if (p->ram_pages[index].is_free){
8010832b:	8b 3a                	mov    (%edx),%edi
8010832d:	85 ff                	test   %edi,%edi
8010832f:	74 ef                	je     80108320 <swap_in+0x30>
      found = 1;
      p->ram_pages[index].is_free = 0;
80108331:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
      found = 1;
80108334:	bf 01 00 00 00       	mov    $0x1,%edi
      p->ram_pages[index].is_free = 0;
80108339:	c7 84 d6 00 02 00 00 	movl   $0x0,0x200(%esi,%edx,8)
80108340:	00 00 00 00 
80108344:	8d 8e 80 03 00 00    	lea    0x380(%esi),%ecx
  int count = 0;
8010834a:	31 d2                	xor    %edx,%edx
8010834c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    }
  }
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
    if (!p->ram_pages[i].is_free){
      count++;
80108350:	83 38 01             	cmpl   $0x1,(%eax)
80108353:	83 d2 00             	adc    $0x0,%edx
80108356:	83 c0 18             	add    $0x18,%eax
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80108359:	39 c1                	cmp    %eax,%ecx
8010835b:	75 f3                	jne    80108350 <swap_in+0x60>
    }
  }
  if (!found){
8010835d:	85 ff                	test   %edi,%edi
8010835f:	0f 84 d2 00 00 00    	je     80108437 <swap_in+0x147>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_actual_pages_in_mem, count);
    panic("SWAP IN BALAGAN\n");
  }
  void* mem = cow_kalloc();
80108365:	e8 c6 ee ff ff       	call   80107230 <cow_kalloc>
  // mem = cow_kalloc();
  if(mem == 0){
8010836a:	85 c0                	test   %eax,%eax
  void* mem = cow_kalloc();
8010836c:	89 c7                	mov    %eax,%edi
  if(mem == 0){
8010836e:	0f 84 ac 00 00 00    	je     80108420 <swap_in+0x130>
    cprintf("swap in - out of memory\n");
    // deallocuvm(pgdir, newsz, oldsz);
    return -1;
  }

  void* va = pi->va;
80108374:	8b 45 0c             	mov    0xc(%ebp),%eax
  pte_t* pte_ptr = walkpgdir(pgdir, va, 0);
80108377:	31 c9                	xor    %ecx,%ecx
  void* va = pi->va;
80108379:	8b 40 10             	mov    0x10(%eax),%eax
  pte_t* pte_ptr = walkpgdir(pgdir, va, 0);
8010837c:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010837f:	89 c2                	mov    %eax,%edx
80108381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108384:	e8 57 ef ff ff       	call   801072e0 <walkpgdir>
  *pte_ptr &= ~PTE_PG;
  *pte_ptr |= (PTE_P | PTE_U | PTE_W);

  // updating physical address written in the page table entry
  *pte_ptr = PTE_FLAGS(*pte_ptr);
  *pte_ptr |= PTE_ADDR(V2P(mem));
80108389:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
8010838f:	8b 08                	mov    (%eax),%ecx
80108391:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80108397:	81 e1 ff 0d 00 00    	and    $0xdff,%ecx
8010839d:	83 ca 07             	or     $0x7,%edx
801083a0:	09 ca                	or     %ecx,%edx
801083a2:	89 10                	mov    %edx,(%eax)
  #if SELECTION==NFUA
  p->ram_pages[index].aging_counter = 0;//NFUA
  #endif
  #if SELECTION==LAPA
  p->ram_pages[index].aging_counter = 0XFFFFFFFF;//NFUA
801083a4:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
  #endif
  p->ram_pages[index].page_index = ++page_counter;
801083a7:	8b 1d c0 c5 10 80    	mov    0x8010c5c0,%ebx
  p->ram_pages[index].aging_counter = 0XFFFFFFFF;//NFUA
801083ad:	8d 14 c6             	lea    (%esi,%eax,8),%edx
  p->ram_pages[index].page_index = ++page_counter;
801083b0:	8d 43 01             	lea    0x1(%ebx),%eax
  p->ram_pages[index].aging_counter = 0XFFFFFFFF;//NFUA
801083b3:	c7 82 08 02 00 00 ff 	movl   $0xffffffff,0x208(%edx)
801083ba:	ff ff ff 
  p->ram_pages[index].page_index = ++page_counter;
801083bd:	89 82 0c 02 00 00    	mov    %eax,0x20c(%edx)
801083c3:	a3 c0 c5 10 80       	mov    %eax,0x8010c5c0
  p->ram_pages[index].va = va;
801083c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801083cb:	89 82 10 02 00 00    	mov    %eax,0x210(%edx)
  int result = readFromSwapFile(p, mem, offset, PGSIZE);
801083d1:	68 00 10 00 00       	push   $0x1000
801083d6:	ff 75 e0             	pushl  -0x20(%ebp)
801083d9:	57                   	push   %edi
801083da:	56                   	push   %esi
801083db:	e8 40 a2 ff ff       	call   80102620 <readFromSwapFile>

  // clean the struct
  pi->is_free = 1;
801083e0:	8b 7d 0c             	mov    0xc(%ebp),%edi
801083e3:	c7 07 01 00 00 00    	movl   $0x1,(%edi)
  pi->va = 0;
801083e9:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  pi->swap_file_offset = 0;
801083f0:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)

  // refresh rc3
  lcr3(V2P(p->pgdir));
801083f7:	8b 7e 04             	mov    0x4(%esi),%edi
801083fa:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
80108400:	0f 22 da             	mov    %edx,%cr3

  p->num_of_actual_pages_in_mem++;
80108403:	83 86 84 03 00 00 01 	addl   $0x1,0x384(%esi)
  p->num_of_pages_in_swap_file--;
8010840a:	83 ae 80 03 00 00 01 	subl   $0x1,0x380(%esi)

  if (result < 0){
80108411:	83 c4 10             	add    $0x10,%esp
80108414:	85 c0                	test   %eax,%eax
80108416:	78 3d                	js     80108455 <swap_in+0x165>
    panic("swap in failed");
  }
  return result;
}
80108418:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010841b:	5b                   	pop    %ebx
8010841c:	5e                   	pop    %esi
8010841d:	5f                   	pop    %edi
8010841e:	5d                   	pop    %ebp
8010841f:	c3                   	ret    
    cprintf("swap in - out of memory\n");
80108420:	83 ec 0c             	sub    $0xc,%esp
80108423:	68 1b 92 10 80       	push   $0x8010921b
80108428:	e8 33 82 ff ff       	call   80100660 <cprintf>
    return -1;
8010842d:	83 c4 10             	add    $0x10,%esp
80108430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108435:	eb e1                	jmp    80108418 <swap_in+0x128>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_actual_pages_in_mem, count);
80108437:	50                   	push   %eax
80108438:	52                   	push   %edx
80108439:	ff b6 84 03 00 00    	pushl  0x384(%esi)
8010843f:	68 44 90 10 80       	push   $0x80109044
80108444:	e8 17 82 ff ff       	call   80100660 <cprintf>
    panic("SWAP IN BALAGAN\n");
80108449:	c7 04 24 0a 92 10 80 	movl   $0x8010920a,(%esp)
80108450:	e8 3b 7f ff ff       	call   80100390 <panic>
    panic("swap in failed");
80108455:	83 ec 0c             	sub    $0xc,%esp
80108458:	68 34 92 10 80       	push   $0x80109234
8010845d:	e8 2e 7f ff ff       	call   80100390 <panic>
80108462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108470 <swap_page_back>:
 * 3. ram not full - swap in
 * 
 * 
 * */

void swap_page_back(struct proc* p, struct pageinfo* pi_to_swapin){
80108470:	55                   	push   %ebp
80108471:	89 e5                	mov    %esp,%ebp
80108473:	57                   	push   %edi
80108474:	56                   	push   %esi
80108475:	53                   	push   %ebx
80108476:	83 ec 2c             	sub    $0x2c,%esp
80108479:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //   if (!p->swapped_out_pages[i].is_free){
  //     swap++;
  //   }
  // }
  // cprintf("RAM: %d SWAP: %d\n", ram, swap);
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
8010847c:	83 bb 84 03 00 00 10 	cmpl   $0x10,0x384(%ebx)
80108483:	74 2b                	je     801084b0 <swap_page_back+0x40>
    // cprintf("swap page back 2\n");
    swap_out(p, page_to_swap, 0, p->pgdir);
    swap_in(p, pi_to_swapin);
  }
  else{
    cprintf("PGFAULT C\n");
80108485:	83 ec 0c             	sub    $0xc,%esp
80108488:	68 59 92 10 80       	push   $0x80109259
8010848d:	e8 ce 81 ff ff       	call   80100660 <cprintf>
    swap_in(p, pi_to_swapin);
80108492:	58                   	pop    %eax
80108493:	5a                   	pop    %edx
80108494:	ff 75 0c             	pushl  0xc(%ebp)
80108497:	53                   	push   %ebx
80108498:	e8 53 fe ff ff       	call   801082f0 <swap_in>
8010849d:	83 c4 10             	add    $0x10,%esp
  }
}
801084a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084a3:	5b                   	pop    %ebx
801084a4:	5e                   	pop    %esi
801084a5:	5f                   	pop    %edi
801084a6:	5d                   	pop    %ebp
801084a7:	c3                   	ret    
801084a8:	90                   	nop
801084a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
801084b0:	8b 83 80 03 00 00    	mov    0x380(%ebx),%eax
801084b6:	83 f8 10             	cmp    $0x10,%eax
801084b9:	74 4d                	je     80108508 <swap_page_back+0x98>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
801084bb:	83 f8 0f             	cmp    $0xf,%eax
801084be:	77 c5                	ja     80108485 <swap_page_back+0x15>
    cprintf("PGFAULT B\n");
801084c0:	83 ec 0c             	sub    $0xc,%esp
801084c3:	68 4e 92 10 80       	push   $0x8010924e
801084c8:	e8 93 81 ff ff       	call   80100660 <cprintf>
    struct pageinfo* page_to_swap = find_page_to_swap(p, p->pgdir);
801084cd:	8b 73 04             	mov    0x4(%ebx),%esi
    update_age(p);
801084d0:	89 1c 24             	mov    %ebx,(%esp)
801084d3:	e8 18 ef ff ff       	call   801073f0 <update_age>
    pi = find_page_to_swap_lapa(p,pgdir);
801084d8:	59                   	pop    %ecx
801084d9:	5f                   	pop    %edi
801084da:	56                   	push   %esi
801084db:	53                   	push   %ebx
801084dc:	e8 df ef ff ff       	call   801074c0 <find_page_to_swap_lapa>
    swap_out(p, page_to_swap, 0, p->pgdir);
801084e1:	ff 73 04             	pushl  0x4(%ebx)
801084e4:	6a 00                	push   $0x0
801084e6:	50                   	push   %eax
801084e7:	53                   	push   %ebx
801084e8:	e8 a3 fa ff ff       	call   80107f90 <swap_out>
    swap_in(p, pi_to_swapin);
801084ed:	83 c4 18             	add    $0x18,%esp
801084f0:	ff 75 0c             	pushl  0xc(%ebp)
801084f3:	53                   	push   %ebx
801084f4:	e8 f7 fd ff ff       	call   801082f0 <swap_in>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
801084f9:	83 c4 10             	add    $0x10,%esp
}
801084fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084ff:	5b                   	pop    %ebx
80108500:	5e                   	pop    %esi
80108501:	5f                   	pop    %edi
80108502:	5d                   	pop    %ebp
80108503:	c3                   	ret    
80108504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("PGFAULT A\n");
80108508:	83 ec 0c             	sub    $0xc,%esp
8010850b:	68 43 92 10 80       	push   $0x80109243
80108510:	e8 4b 81 ff ff       	call   80100660 <cprintf>
    char* buffer = cow_kalloc();
80108515:	e8 16 ed ff ff       	call   80107230 <cow_kalloc>
    struct pageinfo* page_to_swap = find_page_to_swap(p, p->pgdir);
8010851a:	8b 73 04             	mov    0x4(%ebx),%esi
    char* buffer = cow_kalloc();
8010851d:	89 c7                	mov    %eax,%edi
    update_age(p);
8010851f:	89 1c 24             	mov    %ebx,(%esp)
80108522:	e8 c9 ee ff ff       	call   801073f0 <update_age>
    pi = find_page_to_swap_lapa(p,pgdir);
80108527:	58                   	pop    %eax
80108528:	5a                   	pop    %edx
80108529:	56                   	push   %esi
8010852a:	53                   	push   %ebx
8010852b:	e8 90 ef ff ff       	call   801074c0 <find_page_to_swap_lapa>
    memmove(buffer, page_to_swap->va, PGSIZE);
80108530:	83 c4 0c             	add    $0xc,%esp
    pi = find_page_to_swap_lapa(p,pgdir);
80108533:	89 c6                	mov    %eax,%esi
    memmove(buffer, page_to_swap->va, PGSIZE);
80108535:	68 00 10 00 00       	push   $0x1000
8010853a:	ff 70 10             	pushl  0x10(%eax)
8010853d:	57                   	push   %edi
8010853e:	e8 6d ca ff ff       	call   80104fb0 <memmove>
    p->num_of_actual_pages_in_mem--;
80108543:	83 ab 84 03 00 00 01 	subl   $0x1,0x384(%ebx)
    pi = *page_to_swap;
8010854a:	8b 06                	mov    (%esi),%eax
8010854c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010854f:	8b 46 04             	mov    0x4(%esi),%eax
80108552:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80108555:	8b 46 08             	mov    0x8(%esi),%eax
80108558:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010855b:	8b 46 0c             	mov    0xc(%esi),%eax
8010855e:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108561:	8b 46 10             	mov    0x10(%esi),%eax
80108564:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108567:	8b 46 14             	mov    0x14(%esi),%eax
8010856a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    page_to_swap->is_free = 1;
8010856d:	c7 06 01 00 00 00    	movl   $0x1,(%esi)
    swap_in(p, page_to_swap);
80108573:	59                   	pop    %ecx
80108574:	58                   	pop    %eax
80108575:	56                   	push   %esi
80108576:	53                   	push   %ebx
80108577:	e8 74 fd ff ff       	call   801082f0 <swap_in>
    swap_out(p, &pi, buffer, p->pgdir);
8010857c:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010857f:	ff 73 04             	pushl  0x4(%ebx)
80108582:	57                   	push   %edi
80108583:	50                   	push   %eax
80108584:	53                   	push   %ebx
80108585:	e8 06 fa ff ff       	call   80107f90 <swap_out>
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
8010858a:	83 c4 20             	add    $0x20,%esp
8010858d:	e9 0e ff ff ff       	jmp    801084a0 <swap_page_back+0x30>
80108592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801085a0 <copy_page>:

int copy_page(pde_t* pgdir, pte_t* pte_ptr){
801085a0:	55                   	push   %ebp
801085a1:	89 e5                	mov    %esp,%ebp
801085a3:	57                   	push   %edi
801085a4:	56                   	push   %esi
801085a5:	53                   	push   %ebx
801085a6:	83 ec 0c             	sub    $0xc,%esp
801085a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint pa = PTE_ADDR(*pte_ptr);
801085ac:	8b 3e                	mov    (%esi),%edi
  char* mem = cow_kalloc();
801085ae:	e8 7d ec ff ff       	call   80107230 <cow_kalloc>
  uint pa = PTE_ADDR(*pte_ptr);
801085b3:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if (mem == 0){
801085b9:	85 c0                	test   %eax,%eax
801085bb:	74 3b                	je     801085f8 <copy_page+0x58>
801085bd:	89 c3                	mov    %eax,%ebx
    return -1;
  }
  memmove(mem, P2V(pa), PGSIZE);
801085bf:	83 ec 04             	sub    $0x4,%esp
801085c2:	81 c7 00 00 00 80    	add    $0x80000000,%edi
  *pte_ptr = PTE_ADDR(P2V(mem)) | PTE_U | PTE_W | PTE_P;
801085c8:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
801085ce:	68 00 10 00 00       	push   $0x1000
801085d3:	57                   	push   %edi
  *pte_ptr = PTE_ADDR(P2V(mem)) | PTE_U | PTE_W | PTE_P;
801085d4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
801085da:	50                   	push   %eax
  *pte_ptr = PTE_ADDR(P2V(mem)) | PTE_U | PTE_W | PTE_P;
801085db:	83 cb 07             	or     $0x7,%ebx
  memmove(mem, P2V(pa), PGSIZE);
801085de:	e8 cd c9 ff ff       	call   80104fb0 <memmove>
  *pte_ptr = PTE_ADDR(P2V(mem)) | PTE_U | PTE_W | PTE_P;
801085e3:	89 1e                	mov    %ebx,(%esi)
  return 0;
801085e5:	83 c4 10             	add    $0x10,%esp
801085e8:	31 c0                	xor    %eax,%eax
}
801085ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085ed:	5b                   	pop    %ebx
801085ee:	5e                   	pop    %esi
801085ef:	5f                   	pop    %edi
801085f0:	5d                   	pop    %ebp
801085f1:	c3                   	ret    
801085f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801085f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801085fd:	eb eb                	jmp    801085ea <copy_page+0x4a>
