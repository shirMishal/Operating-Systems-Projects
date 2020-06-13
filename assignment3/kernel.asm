
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
8010002d:	b8 60 33 10 80       	mov    $0x80103360,%eax
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
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 77 10 80       	push   $0x801077e0
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 c5 46 00 00       	call   80104720 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 0c 11 80       	mov    $0x80110cdc,%edx
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
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 77 10 80       	push   $0x801077e7
80100097:	50                   	push   %eax
80100098:	e8 53 45 00 00       	call   801045f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
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
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 77 47 00 00       	call   80104860 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
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
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
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
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 b9 47 00 00       	call   80104920 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 44 00 00       	call   80104630 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 dd 23 00 00       	call   80102560 <iderw>
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
80100193:	68 ee 77 10 80       	push   $0x801077ee
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
801001ae:	e8 1d 45 00 00       	call   801046d0 <holdingsleep>
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
801001c4:	e9 97 23 00 00       	jmp    80102560 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 77 10 80       	push   $0x801077ff
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
801001ef:	e8 dc 44 00 00       	call   801046d0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 44 00 00       	call   80104690 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 50 46 00 00       	call   80104860 <acquire>
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
80100232:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 0d 11 80       	mov    0x80110d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 bf 46 00 00       	jmp    80104920 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 78 10 80       	push   $0x80107806
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
80100280:	e8 8b 15 00 00       	call   80101810 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 cf 45 00 00       	call   80104860 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 e0 ef 11 80    	mov    0x8011efe0,%edx
801002a7:	39 15 e4 ef 11 80    	cmp    %edx,0x8011efe4
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
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 e0 ef 11 80       	push   $0x8011efe0
801002c5:	e8 b6 3f 00 00       	call   80104280 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 e0 ef 11 80    	mov    0x8011efe0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 e4 ef 11 80    	cmp    0x8011efe4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 d0 39 00 00       	call   80103cb0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 2c 46 00 00       	call   80104920 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 34 14 00 00       	call   80101730 <ilock>
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
80100313:	a3 e0 ef 11 80       	mov    %eax,0x8011efe0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 60 ef 11 80 	movsbl -0x7fee10a0(%eax),%eax
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
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 ce 45 00 00       	call   80104920 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 d6 13 00 00       	call   80101730 <ilock>
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
80100372:	89 15 e0 ef 11 80    	mov    %edx,0x8011efe0
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
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 42 28 00 00       	call   80102bf0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 0d 78 10 80       	push   $0x8010780d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 0d 83 10 80 	movl   $0x8010830d,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 63 43 00 00       	call   80104740 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 21 78 10 80       	push   $0x80107821
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
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
8010043a:	e8 01 5d 00 00       	call   80106140 <uartputc>
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
801004ec:	e8 4f 5c 00 00       	call   80106140 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 43 5c 00 00       	call   80106140 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 37 5c 00 00       	call   80106140 <uartputc>
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
80100524:	e8 f7 44 00 00       	call   80104a20 <memmove>
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
80100541:	e8 2a 44 00 00       	call   80104970 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 25 78 10 80       	push   $0x80107825
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
801005b1:	0f b6 92 50 78 10 80 	movzbl -0x7fef87b0(%edx),%edx
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
8010060f:	e8 fc 11 00 00       	call   80101810 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 40 42 00 00       	call   80104860 <acquire>
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
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 d4 42 00 00       	call   80104920 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 db 10 00 00       	call   80101730 <ilock>

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
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
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
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 fc 41 00 00       	call   80104920 <release>
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
801007d0:	ba 38 78 10 80       	mov    $0x80107838,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 6b 40 00 00       	call   80104860 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 3f 78 10 80       	push   $0x8010783f
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
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 38 40 00 00       	call   80104860 <acquire>
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
80100851:	a1 e8 ef 11 80       	mov    0x8011efe8,%eax
80100856:	3b 05 e4 ef 11 80    	cmp    0x8011efe4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 e8 ef 11 80       	mov    %eax,0x8011efe8
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
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 93 40 00 00       	call   80104920 <release>
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
801008a9:	a1 e8 ef 11 80       	mov    0x8011efe8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 e0 ef 11 80    	sub    0x8011efe0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 e8 ef 11 80    	mov    %edx,0x8011efe8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 60 ef 11 80    	mov    %cl,-0x7fee10a0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 e0 ef 11 80       	mov    0x8011efe0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 e8 ef 11 80    	cmp    %eax,0x8011efe8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 e4 ef 11 80       	mov    %eax,0x8011efe4
          wakeup(&input.r);
80100911:	68 e0 ef 11 80       	push   $0x8011efe0
80100916:	e8 25 3b 00 00       	call   80104440 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 e8 ef 11 80       	mov    0x8011efe8,%eax
8010093d:	39 05 e4 ef 11 80    	cmp    %eax,0x8011efe4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 e8 ef 11 80       	mov    %eax,0x8011efe8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 e8 ef 11 80       	mov    0x8011efe8,%eax
80100964:	3b 05 e4 ef 11 80    	cmp    0x8011efe4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 60 ef 11 80 0a 	cmpb   $0xa,-0x7fee10a0(%edx)
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
80100997:	e9 84 3b 00 00       	jmp    80104520 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 60 ef 11 80 0a 	movb   $0xa,-0x7fee10a0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 e8 ef 11 80       	mov    0x8011efe8,%eax
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
801009c6:	68 48 78 10 80       	push   $0x80107848
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 4b 3d 00 00       	call   80104720 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 ac f9 11 80 00 	movl   $0x80100600,0x8011f9ac
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 a8 f9 11 80 70 	movl   $0x80100270,0x8011f9a8
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 12 1d 00 00       	call   80102710 <ioapicenable>
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
80100a13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  p->num_of_pageOut_occured = 0;
80100a16:	c7 81 cc 03 00 00 00 	movl   $0x0,0x3cc(%ecx)
80100a1d:	00 00 00 
  p->num_of_pagefaults_occurs = 0;
80100a20:	c7 81 c8 03 00 00 00 	movl   $0x0,0x3c8(%ecx)
80100a27:	00 00 00 
80100a2a:	8d 81 80 00 00 00    	lea    0x80(%ecx),%eax
  p->num_of_actual_pages_in_mem = 0;
80100a30:	c7 81 c4 03 00 00 00 	movl   $0x0,0x3c4(%ecx)
80100a37:	00 00 00 
  p->num_of_pages_in_swap_file = 0;
80100a3a:	c7 81 c0 03 00 00 00 	movl   $0x0,0x3c0(%ecx)
80100a41:	00 00 00 
80100a44:	8d 91 80 03 00 00    	lea    0x380(%ecx),%edx
80100a4a:	81 c1 00 02 00 00    	add    $0x200,%ecx
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
80100a74:	83 c2 04             	add    $0x4,%edx
    p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80100a77:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
80100a7e:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
80100a85:	00 00 00 
    p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80100a88:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80100a8f:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
80100a96:	00 00 00 
    p->advance_queue[i] = -1;//AQ
80100a99:	c7 42 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%edx)
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100aa0:	39 c8                	cmp    %ecx,%eax
80100aa2:	75 ac                	jne    80100a50 <intiate_pg_info+0x40>
  }
}
80100aa4:	5d                   	pop    %ebp
80100aa5:	c3                   	ret    
80100aa6:	8d 76 00             	lea    0x0(%esi),%esi
80100aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ab0 <exec>:


int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  // cprintf("before setup\n");
  struct proc *curproc = myproc();
80100abc:	e8 ef 31 00 00       	call   80103cb0 <myproc>
80100ac1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  int advance_q_bu[MAX_PYSC_PAGES];
  struct file* swap_file_bu = 0;
  struct file* temp_swap_file = 0;
  #endif

  begin_op();
80100ac7:	e8 94 25 00 00       	call   80103060 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	pushl  0x8(%ebp)
80100ad2:	e8 b9 14 00 00       	call   80101f90 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 91 01 00 00    	je     80100c73 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 43 0c 00 00       	call   80101730 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 12 0f 00 00       	call   80101a10 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>
    }
    #endif
    freevm(pgdir);
  }
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 b1 0e 00 00       	call   801019c0 <iunlockput>
    end_op();
80100b0f:	e8 bc 25 00 00       	call   801030d0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 27 69 00 00       	call   80107460 <setupkvm>
80100b39:	85 c0                	test   %eax,%eax
80100b3b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  sz = 0;
80100b43:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b45:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4c:	00 
80100b4d:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100b53:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b59:	0f 84 98 02 00 00    	je     80100df7 <exec+0x347>
80100b5f:	31 f6                	xor    %esi,%esi
80100b61:	eb 7f                	jmp    80100be2 <exec+0x132>
80100b63:	90                   	nop
80100b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100b68:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b6f:	75 63                	jne    80100bd4 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100b71:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b77:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b7d:	0f 82 86 00 00 00    	jb     80100c09 <exec+0x159>
80100b83:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b89:	72 7e                	jb     80100c09 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b8b:	83 ec 04             	sub    $0x4,%esp
80100b8e:	50                   	push   %eax
80100b8f:	57                   	push   %edi
80100b90:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b96:	e8 e5 66 00 00       	call   80107280 <allocuvm>
80100b9b:	83 c4 10             	add    $0x10,%esp
80100b9e:	85 c0                	test   %eax,%eax
80100ba0:	89 c7                	mov    %eax,%edi
80100ba2:	74 65                	je     80100c09 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100ba4:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100baa:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100baf:	75 58                	jne    80100c09 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bb1:	83 ec 0c             	sub    $0xc,%esp
80100bb4:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100bba:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100bc0:	53                   	push   %ebx
80100bc1:	50                   	push   %eax
80100bc2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc8:	e8 f3 65 00 00       	call   801071c0 <loaduvm>
80100bcd:	83 c4 20             	add    $0x20,%esp
80100bd0:	85 c0                	test   %eax,%eax
80100bd2:	78 35                	js     80100c09 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bd4:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bdb:	83 c6 01             	add    $0x1,%esi
80100bde:	39 f0                	cmp    %esi,%eax
80100be0:	7e 3d                	jle    80100c1f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100be2:	89 f0                	mov    %esi,%eax
80100be4:	6a 20                	push   $0x20
80100be6:	c1 e0 05             	shl    $0x5,%eax
80100be9:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100bef:	50                   	push   %eax
80100bf0:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bf6:	50                   	push   %eax
80100bf7:	53                   	push   %ebx
80100bf8:	e8 13 0e 00 00       	call   80101a10 <readi>
80100bfd:	83 c4 10             	add    $0x10,%esp
80100c00:	83 f8 20             	cmp    $0x20,%eax
80100c03:	0f 84 5f ff ff ff    	je     80100b68 <exec+0xb8>
    freevm(pgdir);
80100c09:	83 ec 0c             	sub    $0xc,%esp
80100c0c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c12:	e8 c9 67 00 00       	call   801073e0 <freevm>
80100c17:	83 c4 10             	add    $0x10,%esp
80100c1a:	e9 e7 fe ff ff       	jmp    80100b06 <exec+0x56>
80100c1f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c25:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c2b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c31:	83 ec 0c             	sub    $0xc,%esp
80100c34:	53                   	push   %ebx
80100c35:	e8 86 0d 00 00       	call   801019c0 <iunlockput>
  end_op();
80100c3a:	e8 91 24 00 00       	call   801030d0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0){
80100c3f:	83 c4 0c             	add    $0xc,%esp
80100c42:	56                   	push   %esi
80100c43:	57                   	push   %edi
80100c44:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c4a:	e8 31 66 00 00       	call   80107280 <allocuvm>
80100c4f:	83 c4 10             	add    $0x10,%esp
80100c52:	85 c0                	test   %eax,%eax
80100c54:	89 c6                	mov    %eax,%esi
80100c56:	75 3a                	jne    80100c92 <exec+0x1e2>
    freevm(pgdir);
80100c58:	83 ec 0c             	sub    $0xc,%esp
80100c5b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c61:	e8 7a 67 00 00       	call   801073e0 <freevm>
80100c66:	83 c4 10             	add    $0x10,%esp
  return -1;
80100c69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c6e:	e9 a9 fe ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100c73:	e8 58 24 00 00       	call   801030d0 <end_op>
    cprintf("exec: fail\n");
80100c78:	83 ec 0c             	sub    $0xc,%esp
80100c7b:	68 61 78 10 80       	push   $0x80107861
80100c80:	e8 db f9 ff ff       	call   80100660 <cprintf>
    return -1;
80100c85:	83 c4 10             	add    $0x10,%esp
80100c88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c8d:	e9 8a fe ff ff       	jmp    80100b1c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c92:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100c98:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100c9b:	31 ff                	xor    %edi,%edi
80100c9d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c9f:	50                   	push   %eax
80100ca0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100ca6:	e8 55 68 00 00       	call   80107500 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cab:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cae:	83 c4 10             	add    $0x10,%esp
80100cb1:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100cb7:	8b 00                	mov    (%eax),%eax
80100cb9:	85 c0                	test   %eax,%eax
80100cbb:	74 70                	je     80100d2d <exec+0x27d>
80100cbd:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100cc3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100cc9:	eb 0a                	jmp    80100cd5 <exec+0x225>
80100ccb:	90                   	nop
80100ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100cd0:	83 ff 20             	cmp    $0x20,%edi
80100cd3:	74 83                	je     80100c58 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd5:	83 ec 0c             	sub    $0xc,%esp
80100cd8:	50                   	push   %eax
80100cd9:	e8 b2 3e 00 00       	call   80104b90 <strlen>
80100cde:	f7 d0                	not    %eax
80100ce0:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ce5:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce6:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce9:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cec:	e8 9f 3e 00 00       	call   80104b90 <strlen>
80100cf1:	83 c0 01             	add    $0x1,%eax
80100cf4:	50                   	push   %eax
80100cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf8:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cfb:	53                   	push   %ebx
80100cfc:	56                   	push   %esi
80100cfd:	e8 be 69 00 00       	call   801076c0 <copyout>
80100d02:	83 c4 20             	add    $0x20,%esp
80100d05:	85 c0                	test   %eax,%eax
80100d07:	0f 88 4b ff ff ff    	js     80100c58 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100d10:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100d17:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100d1a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100d20:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100d23:	85 c0                	test   %eax,%eax
80100d25:	75 a9                	jne    80100cd0 <exec+0x220>
80100d27:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d34:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d36:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d3d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100d41:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d48:	ff ff ff 
  ustack[1] = argc;
80100d4b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d51:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d53:	83 c0 0c             	add    $0xc,%eax
80100d56:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d58:	50                   	push   %eax
80100d59:	52                   	push   %edx
80100d5a:	53                   	push   %ebx
80100d5b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d61:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d67:	e8 54 69 00 00       	call   801076c0 <copyout>
80100d6c:	83 c4 10             	add    $0x10,%esp
80100d6f:	85 c0                	test   %eax,%eax
80100d71:	0f 88 e1 fe ff ff    	js     80100c58 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100d77:	8b 45 08             	mov    0x8(%ebp),%eax
80100d7a:	0f b6 00             	movzbl (%eax),%eax
80100d7d:	84 c0                	test   %al,%al
80100d7f:	74 17                	je     80100d98 <exec+0x2e8>
80100d81:	8b 55 08             	mov    0x8(%ebp),%edx
80100d84:	89 d1                	mov    %edx,%ecx
80100d86:	83 c1 01             	add    $0x1,%ecx
80100d89:	3c 2f                	cmp    $0x2f,%al
80100d8b:	0f b6 01             	movzbl (%ecx),%eax
80100d8e:	0f 44 d1             	cmove  %ecx,%edx
80100d91:	84 c0                	test   %al,%al
80100d93:	75 f1                	jne    80100d86 <exec+0x2d6>
80100d95:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d98:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100d9e:	50                   	push   %eax
80100d9f:	6a 10                	push   $0x10
80100da1:	ff 75 08             	pushl  0x8(%ebp)
80100da4:	8d 47 6c             	lea    0x6c(%edi),%eax
80100da7:	50                   	push   %eax
80100da8:	e8 a3 3d 00 00       	call   80104b50 <safestrcpy>
  curproc->pgdir = pgdir;
80100dad:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100db3:	89 f9                	mov    %edi,%ecx
80100db5:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db8:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100dba:	89 41 04             	mov    %eax,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100dbd:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc0:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dc6:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc9:	8b 41 18             	mov    0x18(%ecx),%eax
80100dcc:	89 58 44             	mov    %ebx,0x44(%eax)
  lcr3(V2P(pgdir));
80100dcf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100dd5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80100dda:	0f 22 d8             	mov    %eax,%cr3
  switchuvm(curproc);
80100ddd:	89 0c 24             	mov    %ecx,(%esp)
80100de0:	e8 4b 62 00 00       	call   80107030 <switchuvm>
  freevm(oldpgdir);
80100de5:	89 3c 24             	mov    %edi,(%esp)
80100de8:	e8 f3 65 00 00       	call   801073e0 <freevm>
  return 0;
80100ded:	83 c4 10             	add    $0x10,%esp
80100df0:	31 c0                	xor    %eax,%eax
80100df2:	e9 25 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100df7:	be 00 20 00 00       	mov    $0x2000,%esi
80100dfc:	e9 30 fe ff ff       	jmp    80100c31 <exec+0x181>
80100e01:	66 90                	xchg   %ax,%ax
80100e03:	66 90                	xchg   %ax,%ax
80100e05:	66 90                	xchg   %ax,%ax
80100e07:	66 90                	xchg   %ax,%ax
80100e09:	66 90                	xchg   %ax,%ax
80100e0b:	66 90                	xchg   %ax,%ax
80100e0d:	66 90                	xchg   %ax,%ax
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 6d 78 10 80       	push   $0x8010786d
80100e1b:	68 00 f0 11 80       	push   $0x8011f000
80100e20:	e8 fb 38 00 00       	call   80104720 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 34 f0 11 80       	mov    $0x8011f034,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 00 f0 11 80       	push   $0x8011f000
80100e41:	e8 1a 3a 00 00       	call   80104860 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	90                   	nop
80100e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb 94 f9 11 80    	cmp    $0x8011f994,%ebx
80100e59:	73 25                	jae    80100e80 <filealloc+0x50>
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
80100e6c:	68 00 f0 11 80       	push   $0x8011f000
80100e71:	e8 aa 3a 00 00       	call   80104920 <release>
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
80100e85:	68 00 f0 11 80       	push   $0x8011f000
80100e8a:	e8 91 3a 00 00       	call   80104920 <release>
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
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 00 f0 11 80       	push   $0x8011f000
80100eaf:	e8 ac 39 00 00       	call   80104860 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 00 f0 11 80       	push   $0x8011f000
80100ecc:	e8 4f 3a 00 00       	call   80104920 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 74 78 10 80       	push   $0x80107874
80100ee0:	e8 ab f4 ff ff       	call   80100390 <panic>
80100ee5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 00 f0 11 80       	push   $0x8011f000
80100f01:	e8 5a 39 00 00       	call   80104860 <acquire>
  if(f->ref < 1)
80100f06:	8b 43 04             	mov    0x4(%ebx),%eax
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 c0                	test   %eax,%eax
80100f0e:	0f 8e 9b 00 00 00    	jle    80100faf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 e8 01             	sub    $0x1,%eax
80100f17:	85 c0                	test   %eax,%eax
80100f19:	89 43 04             	mov    %eax,0x4(%ebx)
80100f1c:	74 1a                	je     80100f38 <fileclose+0x48>
    release(&ftable.lock);
80100f1e:	c7 45 08 00 f0 11 80 	movl   $0x8011f000,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f28:	5b                   	pop    %ebx
80100f29:	5e                   	pop    %esi
80100f2a:	5f                   	pop    %edi
80100f2b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f2c:	e9 ef 39 00 00       	jmp    80104920 <release>
80100f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100f38:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100f3c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100f3e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f41:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100f44:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f4d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f50:	68 00 f0 11 80       	push   $0x8011f000
  ff = *f;
80100f55:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f58:	e8 c3 39 00 00       	call   80104920 <release>
  if(ff.type == FD_PIPE)
80100f5d:	83 c4 10             	add    $0x10,%esp
80100f60:	83 ff 01             	cmp    $0x1,%edi
80100f63:	74 13                	je     80100f78 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100f65:	83 ff 02             	cmp    $0x2,%edi
80100f68:	74 26                	je     80100f90 <fileclose+0xa0>
}
80100f6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6d:	5b                   	pop    %ebx
80100f6e:	5e                   	pop    %esi
80100f6f:	5f                   	pop    %edi
80100f70:	5d                   	pop    %ebp
80100f71:	c3                   	ret    
80100f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100f78:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f7c:	83 ec 08             	sub    $0x8,%esp
80100f7f:	53                   	push   %ebx
80100f80:	56                   	push   %esi
80100f81:	e8 8a 28 00 00       	call   80103810 <pipeclose>
80100f86:	83 c4 10             	add    $0x10,%esp
80100f89:	eb df                	jmp    80100f6a <fileclose+0x7a>
80100f8b:	90                   	nop
80100f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f90:	e8 cb 20 00 00       	call   80103060 <begin_op>
    iput(ff.ip);
80100f95:	83 ec 0c             	sub    $0xc,%esp
80100f98:	ff 75 e0             	pushl  -0x20(%ebp)
80100f9b:	e8 c0 08 00 00       	call   80101860 <iput>
    end_op();
80100fa0:	83 c4 10             	add    $0x10,%esp
}
80100fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa6:	5b                   	pop    %ebx
80100fa7:	5e                   	pop    %esi
80100fa8:	5f                   	pop    %edi
80100fa9:	5d                   	pop    %ebp
    end_op();
80100faa:	e9 21 21 00 00       	jmp    801030d0 <end_op>
    panic("fileclose");
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	68 7c 78 10 80       	push   $0x8010787c
80100fb7:	e8 d4 f3 ff ff       	call   80100390 <panic>
80100fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	53                   	push   %ebx
80100fc4:	83 ec 04             	sub    $0x4,%esp
80100fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fca:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fcd:	75 31                	jne    80101000 <filestat+0x40>
    ilock(f->ip);
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	ff 73 10             	pushl  0x10(%ebx)
80100fd5:	e8 56 07 00 00       	call   80101730 <ilock>
    stati(f->ip, st);
80100fda:	58                   	pop    %eax
80100fdb:	5a                   	pop    %edx
80100fdc:	ff 75 0c             	pushl  0xc(%ebp)
80100fdf:	ff 73 10             	pushl  0x10(%ebx)
80100fe2:	e8 f9 09 00 00       	call   801019e0 <stati>
    iunlock(f->ip);
80100fe7:	59                   	pop    %ecx
80100fe8:	ff 73 10             	pushl  0x10(%ebx)
80100feb:	e8 20 08 00 00       	call   80101810 <iunlock>
    return 0;
80100ff0:	83 c4 10             	add    $0x10,%esp
80100ff3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100ff5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101005:	eb ee                	jmp    80100ff5 <filestat+0x35>
80101007:	89 f6                	mov    %esi,%esi
80101009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101010 <fileread>:

// Read from file f.
int
fileread(struct file* f, char *addr, int n)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 0c             	sub    $0xc,%esp
80101019:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010101c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010101f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101022:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101026:	74 60                	je     80101088 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101028:	8b 03                	mov    (%ebx),%eax
8010102a:	83 f8 01             	cmp    $0x1,%eax
8010102d:	74 41                	je     80101070 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010102f:	83 f8 02             	cmp    $0x2,%eax
80101032:	75 5b                	jne    8010108f <fileread+0x7f>
    ilock(f->ip);
80101034:	83 ec 0c             	sub    $0xc,%esp
80101037:	ff 73 10             	pushl  0x10(%ebx)
8010103a:	e8 f1 06 00 00       	call   80101730 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010103f:	57                   	push   %edi
80101040:	ff 73 14             	pushl  0x14(%ebx)
80101043:	56                   	push   %esi
80101044:	ff 73 10             	pushl  0x10(%ebx)
80101047:	e8 c4 09 00 00       	call   80101a10 <readi>
8010104c:	83 c4 20             	add    $0x20,%esp
8010104f:	85 c0                	test   %eax,%eax
80101051:	89 c6                	mov    %eax,%esi
80101053:	7e 03                	jle    80101058 <fileread+0x48>
      f->off += r;
80101055:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101058:	83 ec 0c             	sub    $0xc,%esp
8010105b:	ff 73 10             	pushl  0x10(%ebx)
8010105e:	e8 ad 07 00 00       	call   80101810 <iunlock>
    return r;
80101063:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101066:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101069:	89 f0                	mov    %esi,%eax
8010106b:	5b                   	pop    %ebx
8010106c:	5e                   	pop    %esi
8010106d:	5f                   	pop    %edi
8010106e:	5d                   	pop    %ebp
8010106f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101070:	8b 43 0c             	mov    0xc(%ebx),%eax
80101073:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	5b                   	pop    %ebx
8010107a:	5e                   	pop    %esi
8010107b:	5f                   	pop    %edi
8010107c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010107d:	e9 3e 29 00 00       	jmp    801039c0 <piperead>
80101082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101088:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010108d:	eb d7                	jmp    80101066 <fileread+0x56>
  panic("fileread");
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	68 86 78 10 80       	push   $0x80107886
80101097:	e8 f4 f2 ff ff       	call   80100390 <panic>
8010109c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010a0:	55                   	push   %ebp
801010a1:	89 e5                	mov    %esp,%ebp
801010a3:	57                   	push   %edi
801010a4:	56                   	push   %esi
801010a5:	53                   	push   %ebx
801010a6:	83 ec 1c             	sub    $0x1c,%esp
801010a9:	8b 75 08             	mov    0x8(%ebp),%esi
801010ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801010af:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010b6:	8b 45 10             	mov    0x10(%ebp),%eax
801010b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010bc:	0f 84 aa 00 00 00    	je     8010116c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801010c2:	8b 06                	mov    (%esi),%eax
801010c4:	83 f8 01             	cmp    $0x1,%eax
801010c7:	0f 84 c3 00 00 00    	je     80101190 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010cd:	83 f8 02             	cmp    $0x2,%eax
801010d0:	0f 85 d9 00 00 00    	jne    801011af <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010d9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010db:	85 c0                	test   %eax,%eax
801010dd:	7f 34                	jg     80101113 <filewrite+0x73>
801010df:	e9 9c 00 00 00       	jmp    80101180 <filewrite+0xe0>
801010e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010eb:	83 ec 0c             	sub    $0xc,%esp
801010ee:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010f4:	e8 17 07 00 00       	call   80101810 <iunlock>
      end_op();
801010f9:	e8 d2 1f 00 00       	call   801030d0 <end_op>
801010fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101101:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101104:	39 c3                	cmp    %eax,%ebx
80101106:	0f 85 96 00 00 00    	jne    801011a2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010110c:	01 df                	add    %ebx,%edi
    while(i < n){
8010110e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101111:	7e 6d                	jle    80101180 <filewrite+0xe0>
      int n1 = n - i;
80101113:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101116:	b8 00 06 00 00       	mov    $0x600,%eax
8010111b:	29 fb                	sub    %edi,%ebx
8010111d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101123:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101126:	e8 35 1f 00 00       	call   80103060 <begin_op>
      ilock(f->ip);
8010112b:	83 ec 0c             	sub    $0xc,%esp
8010112e:	ff 76 10             	pushl  0x10(%esi)
80101131:	e8 fa 05 00 00       	call   80101730 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101136:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101139:	53                   	push   %ebx
8010113a:	ff 76 14             	pushl  0x14(%esi)
8010113d:	01 f8                	add    %edi,%eax
8010113f:	50                   	push   %eax
80101140:	ff 76 10             	pushl  0x10(%esi)
80101143:	e8 c8 09 00 00       	call   80101b10 <writei>
80101148:	83 c4 20             	add    $0x20,%esp
8010114b:	85 c0                	test   %eax,%eax
8010114d:	7f 99                	jg     801010e8 <filewrite+0x48>
      iunlock(f->ip);
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	ff 76 10             	pushl  0x10(%esi)
80101155:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101158:	e8 b3 06 00 00       	call   80101810 <iunlock>
      end_op();
8010115d:	e8 6e 1f 00 00       	call   801030d0 <end_op>
      if(r < 0)
80101162:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101165:	83 c4 10             	add    $0x10,%esp
80101168:	85 c0                	test   %eax,%eax
8010116a:	74 98                	je     80101104 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010116c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010116f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101174:	89 f8                	mov    %edi,%eax
80101176:	5b                   	pop    %ebx
80101177:	5e                   	pop    %esi
80101178:	5f                   	pop    %edi
80101179:	5d                   	pop    %ebp
8010117a:	c3                   	ret    
8010117b:	90                   	nop
8010117c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101180:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101183:	75 e7                	jne    8010116c <filewrite+0xcc>
}
80101185:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101188:	89 f8                	mov    %edi,%eax
8010118a:	5b                   	pop    %ebx
8010118b:	5e                   	pop    %esi
8010118c:	5f                   	pop    %edi
8010118d:	5d                   	pop    %ebp
8010118e:	c3                   	ret    
8010118f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101190:	8b 46 0c             	mov    0xc(%esi),%eax
80101193:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101199:	5b                   	pop    %ebx
8010119a:	5e                   	pop    %esi
8010119b:	5f                   	pop    %edi
8010119c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010119d:	e9 0e 27 00 00       	jmp    801038b0 <pipewrite>
        panic("short filewrite");
801011a2:	83 ec 0c             	sub    $0xc,%esp
801011a5:	68 8f 78 10 80       	push   $0x8010788f
801011aa:	e8 e1 f1 ff ff       	call   80100390 <panic>
  panic("filewrite");
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	68 95 78 10 80       	push   $0x80107895
801011b7:	e8 d4 f1 ff ff       	call   80100390 <panic>
801011bc:	66 90                	xchg   %ax,%ax
801011be:	66 90                	xchg   %ax,%ax

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	56                   	push   %esi
801011c4:	53                   	push   %ebx
801011c5:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c7:	c1 ea 0c             	shr    $0xc,%edx
801011ca:	03 15 18 fa 11 80    	add    0x8011fa18,%edx
801011d0:	83 ec 08             	sub    $0x8,%esp
801011d3:	52                   	push   %edx
801011d4:	50                   	push   %eax
801011d5:	e8 f6 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011da:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011dc:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011df:	ba 01 00 00 00       	mov    $0x1,%edx
801011e4:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e7:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011ed:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011f0:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011f2:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011f7:	85 d1                	test   %edx,%ecx
801011f9:	74 25                	je     80101220 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011fb:	f7 d2                	not    %edx
801011fd:	89 c6                	mov    %eax,%esi
  log_write(bp);
801011ff:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101202:	21 ca                	and    %ecx,%edx
80101204:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101208:	56                   	push   %esi
80101209:	e8 22 20 00 00       	call   80103230 <log_write>
  brelse(bp);
8010120e:	89 34 24             	mov    %esi,(%esp)
80101211:	e8 ca ef ff ff       	call   801001e0 <brelse>
}
80101216:	83 c4 10             	add    $0x10,%esp
80101219:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010121c:	5b                   	pop    %ebx
8010121d:	5e                   	pop    %esi
8010121e:	5d                   	pop    %ebp
8010121f:	c3                   	ret    
    panic("freeing free block");
80101220:	83 ec 0c             	sub    $0xc,%esp
80101223:	68 9f 78 10 80       	push   $0x8010789f
80101228:	e8 63 f1 ff ff       	call   80100390 <panic>
8010122d:	8d 76 00             	lea    0x0(%esi),%esi

80101230 <balloc>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d 00 fa 11 80    	mov    0x8011fa00,%ecx
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
8010125c:	03 05 18 fa 11 80    	add    0x8011fa18,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010126e:	a1 00 fa 11 80       	mov    0x8011fa00,%eax
80101273:	83 c4 10             	add    $0x10,%esp
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2f                	jmp    801012ac <balloc+0x7c>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101282:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101285:	bb 01 00 00 00       	mov    $0x1,%ebx
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101299:	85 df                	test   %ebx,%edi
8010129b:	89 fa                	mov    %edi,%edx
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
801012b7:	e8 24 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c9:	39 05 00 fa 11 80    	cmp    %eax,0x8011fa00
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 b2 78 10 80       	push   $0x801078b2
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
801012ed:	e8 3e 1f 00 00       	call   80103230 <log_write>
        brelse(bp);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 e6 ee ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801012fa:	58                   	pop    %eax
801012fb:	5a                   	pop    %edx
801012fc:	56                   	push   %esi
801012fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
80101305:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101307:	8d 40 5c             	lea    0x5c(%eax),%eax
8010130a:	83 c4 0c             	add    $0xc,%esp
8010130d:	68 00 02 00 00       	push   $0x200
80101312:	6a 00                	push   $0x0
80101314:	50                   	push   %eax
80101315:	e8 56 36 00 00       	call   80104970 <memset>
  log_write(bp);
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 0e 1f 00 00       	call   80103230 <log_write>
  brelse(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 b6 ee ff ff       	call   801001e0 <brelse>
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 f0                	mov    %esi,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010133a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

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
80101344:	56                   	push   %esi
80101345:	53                   	push   %ebx
80101346:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101348:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 54 fa 11 80       	mov    $0x8011fa54,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 20 fa 11 80       	push   $0x8011fa20
8010135a:	e8 01 35 00 00       	call   80104860 <acquire>
8010135f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101362:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101365:	eb 17                	jmp    8010137e <iget+0x3e>
80101367:	89 f6                	mov    %esi,%esi
80101369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101370:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101376:	81 fb 74 16 12 80    	cmp    $0x80121674,%ebx
8010137c:	73 22                	jae    801013a0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010137e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101381:	85 c9                	test   %ecx,%ecx
80101383:	7e 04                	jle    80101389 <iget+0x49>
80101385:	39 3b                	cmp    %edi,(%ebx)
80101387:	74 4f                	je     801013d8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e3                	jne    80101370 <iget+0x30>
8010138d:	85 c9                	test   %ecx,%ecx
8010138f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101392:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101398:	81 fb 74 16 12 80    	cmp    $0x80121674,%ebx
8010139e:	72 de                	jb     8010137e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a0:	85 f6                	test   %esi,%esi
801013a2:	74 5b                	je     801013ff <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013a4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013ba:	68 20 fa 11 80       	push   $0x8011fa20
801013bf:	e8 5c 35 00 00       	call   80104920 <release>

  return ip;
801013c4:	83 c4 10             	add    $0x10,%esp
}
801013c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ca:	89 f0                	mov    %esi,%eax
801013cc:	5b                   	pop    %ebx
801013cd:	5e                   	pop    %esi
801013ce:	5f                   	pop    %edi
801013cf:	5d                   	pop    %ebp
801013d0:	c3                   	ret    
801013d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013d8:	39 53 04             	cmp    %edx,0x4(%ebx)
801013db:	75 ac                	jne    80101389 <iget+0x49>
      release(&icache.lock);
801013dd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013e3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013e5:	68 20 fa 11 80       	push   $0x8011fa20
      ip->ref++;
801013ea:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013ed:	e8 2e 35 00 00       	call   80104920 <release>
      return ip;
801013f2:	83 c4 10             	add    $0x10,%esp
}
801013f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f8:	89 f0                	mov    %esi,%eax
801013fa:	5b                   	pop    %ebx
801013fb:	5e                   	pop    %esi
801013fc:	5f                   	pop    %edi
801013fd:	5d                   	pop    %ebp
801013fe:	c3                   	ret    
    panic("iget: no inodes");
801013ff:	83 ec 0c             	sub    $0xc,%esp
80101402:	68 c8 78 10 80       	push   $0x801078c8
80101407:	e8 84 ef ff ff       	call   80100390 <panic>
8010140c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101410 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	57                   	push   %edi
80101414:	56                   	push   %esi
80101415:	53                   	push   %ebx
80101416:	89 c6                	mov    %eax,%esi
80101418:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010141b:	83 fa 0b             	cmp    $0xb,%edx
8010141e:	77 18                	ja     80101438 <bmap+0x28>
80101420:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101423:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101426:	85 db                	test   %ebx,%ebx
80101428:	74 76                	je     801014a0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010142a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010142d:	89 d8                	mov    %ebx,%eax
8010142f:	5b                   	pop    %ebx
80101430:	5e                   	pop    %esi
80101431:	5f                   	pop    %edi
80101432:	5d                   	pop    %ebp
80101433:	c3                   	ret    
80101434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101438:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010143b:	83 fb 7f             	cmp    $0x7f,%ebx
8010143e:	0f 87 90 00 00 00    	ja     801014d4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101444:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010144a:	8b 00                	mov    (%eax),%eax
8010144c:	85 d2                	test   %edx,%edx
8010144e:	74 70                	je     801014c0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101450:	83 ec 08             	sub    $0x8,%esp
80101453:	52                   	push   %edx
80101454:	50                   	push   %eax
80101455:	e8 76 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010145a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010145e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101461:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101463:	8b 1a                	mov    (%edx),%ebx
80101465:	85 db                	test   %ebx,%ebx
80101467:	75 1d                	jne    80101486 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101469:	8b 06                	mov    (%esi),%eax
8010146b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010146e:	e8 bd fd ff ff       	call   80101230 <balloc>
80101473:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101476:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101479:	89 c3                	mov    %eax,%ebx
8010147b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010147d:	57                   	push   %edi
8010147e:	e8 ad 1d 00 00       	call   80103230 <log_write>
80101483:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101486:	83 ec 0c             	sub    $0xc,%esp
80101489:	57                   	push   %edi
8010148a:	e8 51 ed ff ff       	call   801001e0 <brelse>
8010148f:	83 c4 10             	add    $0x10,%esp
}
80101492:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101495:	89 d8                	mov    %ebx,%eax
80101497:	5b                   	pop    %ebx
80101498:	5e                   	pop    %esi
80101499:	5f                   	pop    %edi
8010149a:	5d                   	pop    %ebp
8010149b:	c3                   	ret    
8010149c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801014a0:	8b 00                	mov    (%eax),%eax
801014a2:	e8 89 fd ff ff       	call   80101230 <balloc>
801014a7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801014aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801014ad:	89 c3                	mov    %eax,%ebx
}
801014af:	89 d8                	mov    %ebx,%eax
801014b1:	5b                   	pop    %ebx
801014b2:	5e                   	pop    %esi
801014b3:	5f                   	pop    %edi
801014b4:	5d                   	pop    %ebp
801014b5:	c3                   	ret    
801014b6:	8d 76 00             	lea    0x0(%esi),%esi
801014b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014c0:	e8 6b fd ff ff       	call   80101230 <balloc>
801014c5:	89 c2                	mov    %eax,%edx
801014c7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014cd:	8b 06                	mov    (%esi),%eax
801014cf:	e9 7c ff ff ff       	jmp    80101450 <bmap+0x40>
  panic("bmap: out of range");
801014d4:	83 ec 0c             	sub    $0xc,%esp
801014d7:	68 d8 78 10 80       	push   $0x801078d8
801014dc:	e8 af ee ff ff       	call   80100390 <panic>
801014e1:	eb 0d                	jmp    801014f0 <readsb>
801014e3:	90                   	nop
801014e4:	90                   	nop
801014e5:	90                   	nop
801014e6:	90                   	nop
801014e7:	90                   	nop
801014e8:	90                   	nop
801014e9:	90                   	nop
801014ea:	90                   	nop
801014eb:	90                   	nop
801014ec:	90                   	nop
801014ed:	90                   	nop
801014ee:	90                   	nop
801014ef:	90                   	nop

801014f0 <readsb>:
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	56                   	push   %esi
801014f4:	53                   	push   %ebx
801014f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801014f8:	83 ec 08             	sub    $0x8,%esp
801014fb:	6a 01                	push   $0x1
801014fd:	ff 75 08             	pushl  0x8(%ebp)
80101500:	e8 cb eb ff ff       	call   801000d0 <bread>
80101505:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101507:	8d 40 5c             	lea    0x5c(%eax),%eax
8010150a:	83 c4 0c             	add    $0xc,%esp
8010150d:	6a 1c                	push   $0x1c
8010150f:	50                   	push   %eax
80101510:	56                   	push   %esi
80101511:	e8 0a 35 00 00       	call   80104a20 <memmove>
  brelse(bp);
80101516:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101519:	83 c4 10             	add    $0x10,%esp
}
8010151c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010151f:	5b                   	pop    %ebx
80101520:	5e                   	pop    %esi
80101521:	5d                   	pop    %ebp
  brelse(bp);
80101522:	e9 b9 ec ff ff       	jmp    801001e0 <brelse>
80101527:	89 f6                	mov    %esi,%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101530 <iinit>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	53                   	push   %ebx
80101534:	bb 60 fa 11 80       	mov    $0x8011fa60,%ebx
80101539:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010153c:	68 eb 78 10 80       	push   $0x801078eb
80101541:	68 20 fa 11 80       	push   $0x8011fa20
80101546:	e8 d5 31 00 00       	call   80104720 <initlock>
8010154b:	83 c4 10             	add    $0x10,%esp
8010154e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101550:	83 ec 08             	sub    $0x8,%esp
80101553:	68 f2 78 10 80       	push   $0x801078f2
80101558:	53                   	push   %ebx
80101559:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010155f:	e8 8c 30 00 00       	call   801045f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101564:	83 c4 10             	add    $0x10,%esp
80101567:	81 fb 80 16 12 80    	cmp    $0x80121680,%ebx
8010156d:	75 e1                	jne    80101550 <iinit+0x20>
  readsb(dev, &sb);
8010156f:	83 ec 08             	sub    $0x8,%esp
80101572:	68 00 fa 11 80       	push   $0x8011fa00
80101577:	ff 75 08             	pushl  0x8(%ebp)
8010157a:	e8 71 ff ff ff       	call   801014f0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010157f:	ff 35 18 fa 11 80    	pushl  0x8011fa18
80101585:	ff 35 14 fa 11 80    	pushl  0x8011fa14
8010158b:	ff 35 10 fa 11 80    	pushl  0x8011fa10
80101591:	ff 35 0c fa 11 80    	pushl  0x8011fa0c
80101597:	ff 35 08 fa 11 80    	pushl  0x8011fa08
8010159d:	ff 35 04 fa 11 80    	pushl  0x8011fa04
801015a3:	ff 35 00 fa 11 80    	pushl  0x8011fa00
801015a9:	68 9c 79 10 80       	push   $0x8010799c
801015ae:	e8 ad f0 ff ff       	call   80100660 <cprintf>
}
801015b3:	83 c4 30             	add    $0x30,%esp
801015b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015b9:	c9                   	leave  
801015ba:	c3                   	ret    
801015bb:	90                   	nop
801015bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015c0 <ialloc>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	57                   	push   %edi
801015c4:	56                   	push   %esi
801015c5:	53                   	push   %ebx
801015c6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015c9:	83 3d 08 fa 11 80 01 	cmpl   $0x1,0x8011fa08
{
801015d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801015d3:	8b 75 08             	mov    0x8(%ebp),%esi
801015d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015d9:	0f 86 91 00 00 00    	jbe    80101670 <ialloc+0xb0>
801015df:	bb 01 00 00 00       	mov    $0x1,%ebx
801015e4:	eb 21                	jmp    80101607 <ialloc+0x47>
801015e6:	8d 76 00             	lea    0x0(%esi),%esi
801015e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801015f0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015f3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801015f6:	57                   	push   %edi
801015f7:	e8 e4 eb ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015fc:	83 c4 10             	add    $0x10,%esp
801015ff:	39 1d 08 fa 11 80    	cmp    %ebx,0x8011fa08
80101605:	76 69                	jbe    80101670 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101607:	89 d8                	mov    %ebx,%eax
80101609:	83 ec 08             	sub    $0x8,%esp
8010160c:	c1 e8 03             	shr    $0x3,%eax
8010160f:	03 05 14 fa 11 80    	add    0x8011fa14,%eax
80101615:	50                   	push   %eax
80101616:	56                   	push   %esi
80101617:	e8 b4 ea ff ff       	call   801000d0 <bread>
8010161c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010161e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101620:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101623:	83 e0 07             	and    $0x7,%eax
80101626:	c1 e0 06             	shl    $0x6,%eax
80101629:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010162d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101631:	75 bd                	jne    801015f0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101633:	83 ec 04             	sub    $0x4,%esp
80101636:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101639:	6a 40                	push   $0x40
8010163b:	6a 00                	push   $0x0
8010163d:	51                   	push   %ecx
8010163e:	e8 2d 33 00 00       	call   80104970 <memset>
      dip->type = type;
80101643:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101647:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010164a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010164d:	89 3c 24             	mov    %edi,(%esp)
80101650:	e8 db 1b 00 00       	call   80103230 <log_write>
      brelse(bp);
80101655:	89 3c 24             	mov    %edi,(%esp)
80101658:	e8 83 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010165d:	83 c4 10             	add    $0x10,%esp
}
80101660:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101663:	89 da                	mov    %ebx,%edx
80101665:	89 f0                	mov    %esi,%eax
}
80101667:	5b                   	pop    %ebx
80101668:	5e                   	pop    %esi
80101669:	5f                   	pop    %edi
8010166a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010166b:	e9 d0 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101670:	83 ec 0c             	sub    $0xc,%esp
80101673:	68 f8 78 10 80       	push   $0x801078f8
80101678:	e8 13 ed ff ff       	call   80100390 <panic>
8010167d:	8d 76 00             	lea    0x0(%esi),%esi

80101680 <iupdate>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101688:	83 ec 08             	sub    $0x8,%esp
8010168b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010168e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101691:	c1 e8 03             	shr    $0x3,%eax
80101694:	03 05 14 fa 11 80    	add    0x8011fa14,%eax
8010169a:	50                   	push   %eax
8010169b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010169e:	e8 2d ea ff ff       	call   801000d0 <bread>
801016a3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016a5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801016a8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ac:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016af:	83 e0 07             	and    $0x7,%eax
801016b2:	c1 e0 06             	shl    $0x6,%eax
801016b5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016b9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016bc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016c0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016c3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016c7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016cb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016cf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016d3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016d7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016da:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016dd:	6a 34                	push   $0x34
801016df:	53                   	push   %ebx
801016e0:	50                   	push   %eax
801016e1:	e8 3a 33 00 00       	call   80104a20 <memmove>
  log_write(bp);
801016e6:	89 34 24             	mov    %esi,(%esp)
801016e9:	e8 42 1b 00 00       	call   80103230 <log_write>
  brelse(bp);
801016ee:	89 75 08             	mov    %esi,0x8(%ebp)
801016f1:	83 c4 10             	add    $0x10,%esp
}
801016f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016f7:	5b                   	pop    %ebx
801016f8:	5e                   	pop    %esi
801016f9:	5d                   	pop    %ebp
  brelse(bp);
801016fa:	e9 e1 ea ff ff       	jmp    801001e0 <brelse>
801016ff:	90                   	nop

80101700 <idup>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	53                   	push   %ebx
80101704:	83 ec 10             	sub    $0x10,%esp
80101707:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010170a:	68 20 fa 11 80       	push   $0x8011fa20
8010170f:	e8 4c 31 00 00       	call   80104860 <acquire>
  ip->ref++;
80101714:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101718:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
8010171f:	e8 fc 31 00 00       	call   80104920 <release>
}
80101724:	89 d8                	mov    %ebx,%eax
80101726:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101729:	c9                   	leave  
8010172a:	c3                   	ret    
8010172b:	90                   	nop
8010172c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101730 <ilock>:
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	56                   	push   %esi
80101734:	53                   	push   %ebx
80101735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101738:	85 db                	test   %ebx,%ebx
8010173a:	0f 84 b7 00 00 00    	je     801017f7 <ilock+0xc7>
80101740:	8b 53 08             	mov    0x8(%ebx),%edx
80101743:	85 d2                	test   %edx,%edx
80101745:	0f 8e ac 00 00 00    	jle    801017f7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010174b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010174e:	83 ec 0c             	sub    $0xc,%esp
80101751:	50                   	push   %eax
80101752:	e8 d9 2e 00 00       	call   80104630 <acquiresleep>
  if(ip->valid == 0){
80101757:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010175a:	83 c4 10             	add    $0x10,%esp
8010175d:	85 c0                	test   %eax,%eax
8010175f:	74 0f                	je     80101770 <ilock+0x40>
}
80101761:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101764:	5b                   	pop    %ebx
80101765:	5e                   	pop    %esi
80101766:	5d                   	pop    %ebp
80101767:	c3                   	ret    
80101768:	90                   	nop
80101769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101770:	8b 43 04             	mov    0x4(%ebx),%eax
80101773:	83 ec 08             	sub    $0x8,%esp
80101776:	c1 e8 03             	shr    $0x3,%eax
80101779:	03 05 14 fa 11 80    	add    0x8011fa14,%eax
8010177f:	50                   	push   %eax
80101780:	ff 33                	pushl  (%ebx)
80101782:	e8 49 e9 ff ff       	call   801000d0 <bread>
80101787:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101789:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010178c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010178f:	83 e0 07             	and    $0x7,%eax
80101792:	c1 e0 06             	shl    $0x6,%eax
80101795:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101799:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010179c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010179f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017a3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017a7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017ab:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017af:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017b3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017b7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017bb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017be:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017c1:	6a 34                	push   $0x34
801017c3:	50                   	push   %eax
801017c4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017c7:	50                   	push   %eax
801017c8:	e8 53 32 00 00       	call   80104a20 <memmove>
    brelse(bp);
801017cd:	89 34 24             	mov    %esi,(%esp)
801017d0:	e8 0b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801017d5:	83 c4 10             	add    $0x10,%esp
801017d8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017dd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017e4:	0f 85 77 ff ff ff    	jne    80101761 <ilock+0x31>
      panic("ilock: no type");
801017ea:	83 ec 0c             	sub    $0xc,%esp
801017ed:	68 10 79 10 80       	push   $0x80107910
801017f2:	e8 99 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017f7:	83 ec 0c             	sub    $0xc,%esp
801017fa:	68 0a 79 10 80       	push   $0x8010790a
801017ff:	e8 8c eb ff ff       	call   80100390 <panic>
80101804:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010180a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101810 <iunlock>:
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	56                   	push   %esi
80101814:	53                   	push   %ebx
80101815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101818:	85 db                	test   %ebx,%ebx
8010181a:	74 28                	je     80101844 <iunlock+0x34>
8010181c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010181f:	83 ec 0c             	sub    $0xc,%esp
80101822:	56                   	push   %esi
80101823:	e8 a8 2e 00 00       	call   801046d0 <holdingsleep>
80101828:	83 c4 10             	add    $0x10,%esp
8010182b:	85 c0                	test   %eax,%eax
8010182d:	74 15                	je     80101844 <iunlock+0x34>
8010182f:	8b 43 08             	mov    0x8(%ebx),%eax
80101832:	85 c0                	test   %eax,%eax
80101834:	7e 0e                	jle    80101844 <iunlock+0x34>
  releasesleep(&ip->lock);
80101836:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101839:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010183c:	5b                   	pop    %ebx
8010183d:	5e                   	pop    %esi
8010183e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010183f:	e9 4c 2e 00 00       	jmp    80104690 <releasesleep>
    panic("iunlock");
80101844:	83 ec 0c             	sub    $0xc,%esp
80101847:	68 1f 79 10 80       	push   $0x8010791f
8010184c:	e8 3f eb ff ff       	call   80100390 <panic>
80101851:	eb 0d                	jmp    80101860 <iput>
80101853:	90                   	nop
80101854:	90                   	nop
80101855:	90                   	nop
80101856:	90                   	nop
80101857:	90                   	nop
80101858:	90                   	nop
80101859:	90                   	nop
8010185a:	90                   	nop
8010185b:	90                   	nop
8010185c:	90                   	nop
8010185d:	90                   	nop
8010185e:	90                   	nop
8010185f:	90                   	nop

80101860 <iput>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	57                   	push   %edi
80101864:	56                   	push   %esi
80101865:	53                   	push   %ebx
80101866:	83 ec 28             	sub    $0x28,%esp
80101869:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010186c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010186f:	57                   	push   %edi
80101870:	e8 bb 2d 00 00       	call   80104630 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101875:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 d2                	test   %edx,%edx
8010187d:	74 07                	je     80101886 <iput+0x26>
8010187f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101884:	74 32                	je     801018b8 <iput+0x58>
  releasesleep(&ip->lock);
80101886:	83 ec 0c             	sub    $0xc,%esp
80101889:	57                   	push   %edi
8010188a:	e8 01 2e 00 00       	call   80104690 <releasesleep>
  acquire(&icache.lock);
8010188f:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
80101896:	e8 c5 2f 00 00       	call   80104860 <acquire>
  ip->ref--;
8010189b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010189f:	83 c4 10             	add    $0x10,%esp
801018a2:	c7 45 08 20 fa 11 80 	movl   $0x8011fa20,0x8(%ebp)
}
801018a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5f                   	pop    %edi
801018af:	5d                   	pop    %ebp
  release(&icache.lock);
801018b0:	e9 6b 30 00 00       	jmp    80104920 <release>
801018b5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018b8:	83 ec 0c             	sub    $0xc,%esp
801018bb:	68 20 fa 11 80       	push   $0x8011fa20
801018c0:	e8 9b 2f 00 00       	call   80104860 <acquire>
    int r = ip->ref;
801018c5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018c8:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
801018cf:	e8 4c 30 00 00       	call   80104920 <release>
    if(r == 1){
801018d4:	83 c4 10             	add    $0x10,%esp
801018d7:	83 fe 01             	cmp    $0x1,%esi
801018da:	75 aa                	jne    80101886 <iput+0x26>
801018dc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018e2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018e8:	89 cf                	mov    %ecx,%edi
801018ea:	eb 0b                	jmp    801018f7 <iput+0x97>
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018f0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018f3:	39 fe                	cmp    %edi,%esi
801018f5:	74 19                	je     80101910 <iput+0xb0>
    if(ip->addrs[i]){
801018f7:	8b 16                	mov    (%esi),%edx
801018f9:	85 d2                	test   %edx,%edx
801018fb:	74 f3                	je     801018f0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018fd:	8b 03                	mov    (%ebx),%eax
801018ff:	e8 bc f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101904:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010190a:	eb e4                	jmp    801018f0 <iput+0x90>
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101910:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101916:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101919:	85 c0                	test   %eax,%eax
8010191b:	75 33                	jne    80101950 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010191d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101920:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101927:	53                   	push   %ebx
80101928:	e8 53 fd ff ff       	call   80101680 <iupdate>
      ip->type = 0;
8010192d:	31 c0                	xor    %eax,%eax
8010192f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101933:	89 1c 24             	mov    %ebx,(%esp)
80101936:	e8 45 fd ff ff       	call   80101680 <iupdate>
      ip->valid = 0;
8010193b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101942:	83 c4 10             	add    $0x10,%esp
80101945:	e9 3c ff ff ff       	jmp    80101886 <iput+0x26>
8010194a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101950:	83 ec 08             	sub    $0x8,%esp
80101953:	50                   	push   %eax
80101954:	ff 33                	pushl  (%ebx)
80101956:	e8 75 e7 ff ff       	call   801000d0 <bread>
8010195b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101961:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101964:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101967:	8d 70 5c             	lea    0x5c(%eax),%esi
8010196a:	83 c4 10             	add    $0x10,%esp
8010196d:	89 cf                	mov    %ecx,%edi
8010196f:	eb 0e                	jmp    8010197f <iput+0x11f>
80101971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101978:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010197b:	39 fe                	cmp    %edi,%esi
8010197d:	74 0f                	je     8010198e <iput+0x12e>
      if(a[j])
8010197f:	8b 16                	mov    (%esi),%edx
80101981:	85 d2                	test   %edx,%edx
80101983:	74 f3                	je     80101978 <iput+0x118>
        bfree(ip->dev, a[j]);
80101985:	8b 03                	mov    (%ebx),%eax
80101987:	e8 34 f8 ff ff       	call   801011c0 <bfree>
8010198c:	eb ea                	jmp    80101978 <iput+0x118>
    brelse(bp);
8010198e:	83 ec 0c             	sub    $0xc,%esp
80101991:	ff 75 e4             	pushl  -0x1c(%ebp)
80101994:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101997:	e8 44 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010199c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019a2:	8b 03                	mov    (%ebx),%eax
801019a4:	e8 17 f8 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019a9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019b0:	00 00 00 
801019b3:	83 c4 10             	add    $0x10,%esp
801019b6:	e9 62 ff ff ff       	jmp    8010191d <iput+0xbd>
801019bb:	90                   	nop
801019bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019c0 <iunlockput>:
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	53                   	push   %ebx
801019c4:	83 ec 10             	sub    $0x10,%esp
801019c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019ca:	53                   	push   %ebx
801019cb:	e8 40 fe ff ff       	call   80101810 <iunlock>
  iput(ip);
801019d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019d3:	83 c4 10             	add    $0x10,%esp
}
801019d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019d9:	c9                   	leave  
  iput(ip);
801019da:	e9 81 fe ff ff       	jmp    80101860 <iput>
801019df:	90                   	nop

801019e0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	8b 55 08             	mov    0x8(%ebp),%edx
801019e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019e9:	8b 0a                	mov    (%edx),%ecx
801019eb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019ee:	8b 4a 04             	mov    0x4(%edx),%ecx
801019f1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019f4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019f8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019fb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019ff:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a03:	8b 52 58             	mov    0x58(%edx),%edx
80101a06:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a09:	5d                   	pop    %ebp
80101a0a:	c3                   	ret    
80101a0b:	90                   	nop
80101a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a10 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	57                   	push   %edi
80101a14:	56                   	push   %esi
80101a15:	53                   	push   %ebx
80101a16:	83 ec 1c             	sub    $0x1c,%esp
80101a19:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a27:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101a2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a30:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a33:	0f 84 a7 00 00 00    	je     80101ae0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a3c:	8b 40 58             	mov    0x58(%eax),%eax
80101a3f:	39 c6                	cmp    %eax,%esi
80101a41:	0f 87 ba 00 00 00    	ja     80101b01 <readi+0xf1>
80101a47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a4a:	89 f9                	mov    %edi,%ecx
80101a4c:	01 f1                	add    %esi,%ecx
80101a4e:	0f 82 ad 00 00 00    	jb     80101b01 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a54:	89 c2                	mov    %eax,%edx
80101a56:	29 f2                	sub    %esi,%edx
80101a58:	39 c8                	cmp    %ecx,%eax
80101a5a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a5d:	31 ff                	xor    %edi,%edi
80101a5f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101a61:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a64:	74 6c                	je     80101ad2 <readi+0xc2>
80101a66:	8d 76 00             	lea    0x0(%esi),%esi
80101a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a70:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a73:	89 f2                	mov    %esi,%edx
80101a75:	c1 ea 09             	shr    $0x9,%edx
80101a78:	89 d8                	mov    %ebx,%eax
80101a7a:	e8 91 f9 ff ff       	call   80101410 <bmap>
80101a7f:	83 ec 08             	sub    $0x8,%esp
80101a82:	50                   	push   %eax
80101a83:	ff 33                	pushl  (%ebx)
80101a85:	e8 46 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a8a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a8d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a8f:	89 f0                	mov    %esi,%eax
80101a91:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a96:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a9b:	83 c4 0c             	add    $0xc,%esp
80101a9e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101aa0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101aa4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa7:	29 fb                	sub    %edi,%ebx
80101aa9:	39 d9                	cmp    %ebx,%ecx
80101aab:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101aae:	53                   	push   %ebx
80101aaf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ab0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101ab2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ab5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ab7:	e8 64 2f 00 00       	call   80104a20 <memmove>
    brelse(bp);
80101abc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101abf:	89 14 24             	mov    %edx,(%esp)
80101ac2:	e8 19 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ac7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aca:	83 c4 10             	add    $0x10,%esp
80101acd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ad0:	77 9e                	ja     80101a70 <readi+0x60>
  }
  return n;
80101ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ad5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ad8:	5b                   	pop    %ebx
80101ad9:	5e                   	pop    %esi
80101ada:	5f                   	pop    %edi
80101adb:	5d                   	pop    %ebp
80101adc:	c3                   	ret    
80101add:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ae0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ae4:	66 83 f8 09          	cmp    $0x9,%ax
80101ae8:	77 17                	ja     80101b01 <readi+0xf1>
80101aea:	8b 04 c5 a0 f9 11 80 	mov    -0x7fee0660(,%eax,8),%eax
80101af1:	85 c0                	test   %eax,%eax
80101af3:	74 0c                	je     80101b01 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101af5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101af8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101afb:	5b                   	pop    %ebx
80101afc:	5e                   	pop    %esi
80101afd:	5f                   	pop    %edi
80101afe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101aff:	ff e0                	jmp    *%eax
      return -1;
80101b01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b06:	eb cd                	jmp    80101ad5 <readi+0xc5>
80101b08:	90                   	nop
80101b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101b10 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	57                   	push   %edi
80101b14:	56                   	push   %esi
80101b15:	53                   	push   %ebx
80101b16:	83 ec 1c             	sub    $0x1c,%esp
80101b19:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b27:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b30:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b33:	0f 84 b7 00 00 00    	je     80101bf0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b3f:	0f 82 eb 00 00 00    	jb     80101c30 <writei+0x120>
80101b45:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b48:	31 d2                	xor    %edx,%edx
80101b4a:	89 f8                	mov    %edi,%eax
80101b4c:	01 f0                	add    %esi,%eax
80101b4e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b51:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b56:	0f 87 d4 00 00 00    	ja     80101c30 <writei+0x120>
80101b5c:	85 d2                	test   %edx,%edx
80101b5e:	0f 85 cc 00 00 00    	jne    80101c30 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b64:	85 ff                	test   %edi,%edi
80101b66:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b6d:	74 72                	je     80101be1 <writei+0xd1>
80101b6f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b70:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b73:	89 f2                	mov    %esi,%edx
80101b75:	c1 ea 09             	shr    $0x9,%edx
80101b78:	89 f8                	mov    %edi,%eax
80101b7a:	e8 91 f8 ff ff       	call   80101410 <bmap>
80101b7f:	83 ec 08             	sub    $0x8,%esp
80101b82:	50                   	push   %eax
80101b83:	ff 37                	pushl  (%edi)
80101b85:	e8 46 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b8a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b8d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b90:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b92:	89 f0                	mov    %esi,%eax
80101b94:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b99:	83 c4 0c             	add    $0xc,%esp
80101b9c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ba1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ba3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba7:	39 d9                	cmp    %ebx,%ecx
80101ba9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bac:	53                   	push   %ebx
80101bad:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bb2:	50                   	push   %eax
80101bb3:	e8 68 2e 00 00       	call   80104a20 <memmove>
    log_write(bp);
80101bb8:	89 3c 24             	mov    %edi,(%esp)
80101bbb:	e8 70 16 00 00       	call   80103230 <log_write>
    brelse(bp);
80101bc0:	89 3c 24             	mov    %edi,(%esp)
80101bc3:	e8 18 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bc8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bcb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bce:	83 c4 10             	add    $0x10,%esp
80101bd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bd4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101bd7:	77 97                	ja     80101b70 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101bd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bdc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bdf:	77 37                	ja     80101c18 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101be4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101be7:	5b                   	pop    %ebx
80101be8:	5e                   	pop    %esi
80101be9:	5f                   	pop    %edi
80101bea:	5d                   	pop    %ebp
80101beb:	c3                   	ret    
80101bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bf0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bf4:	66 83 f8 09          	cmp    $0x9,%ax
80101bf8:	77 36                	ja     80101c30 <writei+0x120>
80101bfa:	8b 04 c5 a4 f9 11 80 	mov    -0x7fee065c(,%eax,8),%eax
80101c01:	85 c0                	test   %eax,%eax
80101c03:	74 2b                	je     80101c30 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101c05:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0b:	5b                   	pop    %ebx
80101c0c:	5e                   	pop    %esi
80101c0d:	5f                   	pop    %edi
80101c0e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c0f:	ff e0                	jmp    *%eax
80101c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c18:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c1b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c1e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c21:	50                   	push   %eax
80101c22:	e8 59 fa ff ff       	call   80101680 <iupdate>
80101c27:	83 c4 10             	add    $0x10,%esp
80101c2a:	eb b5                	jmp    80101be1 <writei+0xd1>
80101c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c35:	eb ad                	jmp    80101be4 <writei+0xd4>
80101c37:	89 f6                	mov    %esi,%esi
80101c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c40 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c46:	6a 0e                	push   $0xe
80101c48:	ff 75 0c             	pushl  0xc(%ebp)
80101c4b:	ff 75 08             	pushl  0x8(%ebp)
80101c4e:	e8 3d 2e 00 00       	call   80104a90 <strncmp>
}
80101c53:	c9                   	leave  
80101c54:	c3                   	ret    
80101c55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c60 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	83 ec 1c             	sub    $0x1c,%esp
80101c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c6c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c71:	0f 85 85 00 00 00    	jne    80101cfc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c77:	8b 53 58             	mov    0x58(%ebx),%edx
80101c7a:	31 ff                	xor    %edi,%edi
80101c7c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c7f:	85 d2                	test   %edx,%edx
80101c81:	74 3e                	je     80101cc1 <dirlookup+0x61>
80101c83:	90                   	nop
80101c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c88:	6a 10                	push   $0x10
80101c8a:	57                   	push   %edi
80101c8b:	56                   	push   %esi
80101c8c:	53                   	push   %ebx
80101c8d:	e8 7e fd ff ff       	call   80101a10 <readi>
80101c92:	83 c4 10             	add    $0x10,%esp
80101c95:	83 f8 10             	cmp    $0x10,%eax
80101c98:	75 55                	jne    80101cef <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c9f:	74 18                	je     80101cb9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101ca1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ca4:	83 ec 04             	sub    $0x4,%esp
80101ca7:	6a 0e                	push   $0xe
80101ca9:	50                   	push   %eax
80101caa:	ff 75 0c             	pushl  0xc(%ebp)
80101cad:	e8 de 2d 00 00       	call   80104a90 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101cb2:	83 c4 10             	add    $0x10,%esp
80101cb5:	85 c0                	test   %eax,%eax
80101cb7:	74 17                	je     80101cd0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101cb9:	83 c7 10             	add    $0x10,%edi
80101cbc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101cbf:	72 c7                	jb     80101c88 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cc4:	31 c0                	xor    %eax,%eax
}
80101cc6:	5b                   	pop    %ebx
80101cc7:	5e                   	pop    %esi
80101cc8:	5f                   	pop    %edi
80101cc9:	5d                   	pop    %ebp
80101cca:	c3                   	ret    
80101ccb:	90                   	nop
80101ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101cd0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cd3:	85 c0                	test   %eax,%eax
80101cd5:	74 05                	je     80101cdc <dirlookup+0x7c>
        *poff = off;
80101cd7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cda:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cdc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ce0:	8b 03                	mov    (%ebx),%eax
80101ce2:	e8 59 f6 ff ff       	call   80101340 <iget>
}
80101ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cea:	5b                   	pop    %ebx
80101ceb:	5e                   	pop    %esi
80101cec:	5f                   	pop    %edi
80101ced:	5d                   	pop    %ebp
80101cee:	c3                   	ret    
      panic("dirlookup read");
80101cef:	83 ec 0c             	sub    $0xc,%esp
80101cf2:	68 39 79 10 80       	push   $0x80107939
80101cf7:	e8 94 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cfc:	83 ec 0c             	sub    $0xc,%esp
80101cff:	68 27 79 10 80       	push   $0x80107927
80101d04:	e8 87 e6 ff ff       	call   80100390 <panic>
80101d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d10 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	57                   	push   %edi
80101d14:	56                   	push   %esi
80101d15:	53                   	push   %ebx
80101d16:	89 cf                	mov    %ecx,%edi
80101d18:	89 c3                	mov    %eax,%ebx
80101d1a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d1d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d20:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101d23:	0f 84 67 01 00 00    	je     80101e90 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d29:	e8 82 1f 00 00       	call   80103cb0 <myproc>
  acquire(&icache.lock);
80101d2e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101d31:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d34:	68 20 fa 11 80       	push   $0x8011fa20
80101d39:	e8 22 2b 00 00       	call   80104860 <acquire>
  ip->ref++;
80101d3e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d42:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
80101d49:	e8 d2 2b 00 00       	call   80104920 <release>
80101d4e:	83 c4 10             	add    $0x10,%esp
80101d51:	eb 08                	jmp    80101d5b <namex+0x4b>
80101d53:	90                   	nop
80101d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101d58:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d5b:	0f b6 03             	movzbl (%ebx),%eax
80101d5e:	3c 2f                	cmp    $0x2f,%al
80101d60:	74 f6                	je     80101d58 <namex+0x48>
  if(*path == 0)
80101d62:	84 c0                	test   %al,%al
80101d64:	0f 84 ee 00 00 00    	je     80101e58 <namex+0x148>
  while(*path != '/' && *path != 0)
80101d6a:	0f b6 03             	movzbl (%ebx),%eax
80101d6d:	3c 2f                	cmp    $0x2f,%al
80101d6f:	0f 84 b3 00 00 00    	je     80101e28 <namex+0x118>
80101d75:	84 c0                	test   %al,%al
80101d77:	89 da                	mov    %ebx,%edx
80101d79:	75 09                	jne    80101d84 <namex+0x74>
80101d7b:	e9 a8 00 00 00       	jmp    80101e28 <namex+0x118>
80101d80:	84 c0                	test   %al,%al
80101d82:	74 0a                	je     80101d8e <namex+0x7e>
    path++;
80101d84:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d87:	0f b6 02             	movzbl (%edx),%eax
80101d8a:	3c 2f                	cmp    $0x2f,%al
80101d8c:	75 f2                	jne    80101d80 <namex+0x70>
80101d8e:	89 d1                	mov    %edx,%ecx
80101d90:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d92:	83 f9 0d             	cmp    $0xd,%ecx
80101d95:	0f 8e 91 00 00 00    	jle    80101e2c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d9b:	83 ec 04             	sub    $0x4,%esp
80101d9e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101da1:	6a 0e                	push   $0xe
80101da3:	53                   	push   %ebx
80101da4:	57                   	push   %edi
80101da5:	e8 76 2c 00 00       	call   80104a20 <memmove>
    path++;
80101daa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101dad:	83 c4 10             	add    $0x10,%esp
    path++;
80101db0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101db2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101db5:	75 11                	jne    80101dc8 <namex+0xb8>
80101db7:	89 f6                	mov    %esi,%esi
80101db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101dc0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101dc3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101dc6:	74 f8                	je     80101dc0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101dc8:	83 ec 0c             	sub    $0xc,%esp
80101dcb:	56                   	push   %esi
80101dcc:	e8 5f f9 ff ff       	call   80101730 <ilock>
    if(ip->type != T_DIR){
80101dd1:	83 c4 10             	add    $0x10,%esp
80101dd4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101dd9:	0f 85 91 00 00 00    	jne    80101e70 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ddf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101de2:	85 d2                	test   %edx,%edx
80101de4:	74 09                	je     80101def <namex+0xdf>
80101de6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101de9:	0f 84 b7 00 00 00    	je     80101ea6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101def:	83 ec 04             	sub    $0x4,%esp
80101df2:	6a 00                	push   $0x0
80101df4:	57                   	push   %edi
80101df5:	56                   	push   %esi
80101df6:	e8 65 fe ff ff       	call   80101c60 <dirlookup>
80101dfb:	83 c4 10             	add    $0x10,%esp
80101dfe:	85 c0                	test   %eax,%eax
80101e00:	74 6e                	je     80101e70 <namex+0x160>
  iunlock(ip);
80101e02:	83 ec 0c             	sub    $0xc,%esp
80101e05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e08:	56                   	push   %esi
80101e09:	e8 02 fa ff ff       	call   80101810 <iunlock>
  iput(ip);
80101e0e:	89 34 24             	mov    %esi,(%esp)
80101e11:	e8 4a fa ff ff       	call   80101860 <iput>
80101e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e19:	83 c4 10             	add    $0x10,%esp
80101e1c:	89 c6                	mov    %eax,%esi
80101e1e:	e9 38 ff ff ff       	jmp    80101d5b <namex+0x4b>
80101e23:	90                   	nop
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101e28:	89 da                	mov    %ebx,%edx
80101e2a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e32:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e35:	51                   	push   %ecx
80101e36:	53                   	push   %ebx
80101e37:	57                   	push   %edi
80101e38:	e8 e3 2b 00 00       	call   80104a20 <memmove>
    name[len] = 0;
80101e3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e40:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e43:	83 c4 10             	add    $0x10,%esp
80101e46:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e4a:	89 d3                	mov    %edx,%ebx
80101e4c:	e9 61 ff ff ff       	jmp    80101db2 <namex+0xa2>
80101e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e5b:	85 c0                	test   %eax,%eax
80101e5d:	75 5d                	jne    80101ebc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e62:	89 f0                	mov    %esi,%eax
80101e64:	5b                   	pop    %ebx
80101e65:	5e                   	pop    %esi
80101e66:	5f                   	pop    %edi
80101e67:	5d                   	pop    %ebp
80101e68:	c3                   	ret    
80101e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e70:	83 ec 0c             	sub    $0xc,%esp
80101e73:	56                   	push   %esi
80101e74:	e8 97 f9 ff ff       	call   80101810 <iunlock>
  iput(ip);
80101e79:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e7c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e7e:	e8 dd f9 ff ff       	call   80101860 <iput>
      return 0;
80101e83:	83 c4 10             	add    $0x10,%esp
}
80101e86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e89:	89 f0                	mov    %esi,%eax
80101e8b:	5b                   	pop    %ebx
80101e8c:	5e                   	pop    %esi
80101e8d:	5f                   	pop    %edi
80101e8e:	5d                   	pop    %ebp
80101e8f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e90:	ba 01 00 00 00       	mov    $0x1,%edx
80101e95:	b8 01 00 00 00       	mov    $0x1,%eax
80101e9a:	e8 a1 f4 ff ff       	call   80101340 <iget>
80101e9f:	89 c6                	mov    %eax,%esi
80101ea1:	e9 b5 fe ff ff       	jmp    80101d5b <namex+0x4b>
      iunlock(ip);
80101ea6:	83 ec 0c             	sub    $0xc,%esp
80101ea9:	56                   	push   %esi
80101eaa:	e8 61 f9 ff ff       	call   80101810 <iunlock>
      return ip;
80101eaf:	83 c4 10             	add    $0x10,%esp
}
80101eb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb5:	89 f0                	mov    %esi,%eax
80101eb7:	5b                   	pop    %ebx
80101eb8:	5e                   	pop    %esi
80101eb9:	5f                   	pop    %edi
80101eba:	5d                   	pop    %ebp
80101ebb:	c3                   	ret    
    iput(ip);
80101ebc:	83 ec 0c             	sub    $0xc,%esp
80101ebf:	56                   	push   %esi
    return 0;
80101ec0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ec2:	e8 99 f9 ff ff       	call   80101860 <iput>
    return 0;
80101ec7:	83 c4 10             	add    $0x10,%esp
80101eca:	eb 93                	jmp    80101e5f <namex+0x14f>
80101ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ed0 <dirlink>:
{
80101ed0:	55                   	push   %ebp
80101ed1:	89 e5                	mov    %esp,%ebp
80101ed3:	57                   	push   %edi
80101ed4:	56                   	push   %esi
80101ed5:	53                   	push   %ebx
80101ed6:	83 ec 20             	sub    $0x20,%esp
80101ed9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101edc:	6a 00                	push   $0x0
80101ede:	ff 75 0c             	pushl  0xc(%ebp)
80101ee1:	53                   	push   %ebx
80101ee2:	e8 79 fd ff ff       	call   80101c60 <dirlookup>
80101ee7:	83 c4 10             	add    $0x10,%esp
80101eea:	85 c0                	test   %eax,%eax
80101eec:	75 67                	jne    80101f55 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101eee:	8b 7b 58             	mov    0x58(%ebx),%edi
80101ef1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ef4:	85 ff                	test   %edi,%edi
80101ef6:	74 29                	je     80101f21 <dirlink+0x51>
80101ef8:	31 ff                	xor    %edi,%edi
80101efa:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101efd:	eb 09                	jmp    80101f08 <dirlink+0x38>
80101eff:	90                   	nop
80101f00:	83 c7 10             	add    $0x10,%edi
80101f03:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f06:	73 19                	jae    80101f21 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f08:	6a 10                	push   $0x10
80101f0a:	57                   	push   %edi
80101f0b:	56                   	push   %esi
80101f0c:	53                   	push   %ebx
80101f0d:	e8 fe fa ff ff       	call   80101a10 <readi>
80101f12:	83 c4 10             	add    $0x10,%esp
80101f15:	83 f8 10             	cmp    $0x10,%eax
80101f18:	75 4e                	jne    80101f68 <dirlink+0x98>
    if(de.inum == 0)
80101f1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f1f:	75 df                	jne    80101f00 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f21:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f24:	83 ec 04             	sub    $0x4,%esp
80101f27:	6a 0e                	push   $0xe
80101f29:	ff 75 0c             	pushl  0xc(%ebp)
80101f2c:	50                   	push   %eax
80101f2d:	e8 be 2b 00 00       	call   80104af0 <strncpy>
  de.inum = inum;
80101f32:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f35:	6a 10                	push   $0x10
80101f37:	57                   	push   %edi
80101f38:	56                   	push   %esi
80101f39:	53                   	push   %ebx
  de.inum = inum;
80101f3a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f3e:	e8 cd fb ff ff       	call   80101b10 <writei>
80101f43:	83 c4 20             	add    $0x20,%esp
80101f46:	83 f8 10             	cmp    $0x10,%eax
80101f49:	75 2a                	jne    80101f75 <dirlink+0xa5>
  return 0;
80101f4b:	31 c0                	xor    %eax,%eax
}
80101f4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f50:	5b                   	pop    %ebx
80101f51:	5e                   	pop    %esi
80101f52:	5f                   	pop    %edi
80101f53:	5d                   	pop    %ebp
80101f54:	c3                   	ret    
    iput(ip);
80101f55:	83 ec 0c             	sub    $0xc,%esp
80101f58:	50                   	push   %eax
80101f59:	e8 02 f9 ff ff       	call   80101860 <iput>
    return -1;
80101f5e:	83 c4 10             	add    $0x10,%esp
80101f61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f66:	eb e5                	jmp    80101f4d <dirlink+0x7d>
      panic("dirlink read");
80101f68:	83 ec 0c             	sub    $0xc,%esp
80101f6b:	68 48 79 10 80       	push   $0x80107948
80101f70:	e8 1b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f75:	83 ec 0c             	sub    $0xc,%esp
80101f78:	68 d1 7f 10 80       	push   $0x80107fd1
80101f7d:	e8 0e e4 ff ff       	call   80100390 <panic>
80101f82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f90 <namei>:

struct inode*
namei(char *path)
{
80101f90:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f91:	31 d2                	xor    %edx,%edx
{
80101f93:	89 e5                	mov    %esp,%ebp
80101f95:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f98:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f9e:	e8 6d fd ff ff       	call   80101d10 <namex>
}
80101fa3:	c9                   	leave  
80101fa4:	c3                   	ret    
80101fa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fb0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fb0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fb1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fb6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101fbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fbe:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fbf:	e9 4c fd ff ff       	jmp    80101d10 <namex>
80101fc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101fd0 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101fd0:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101fd1:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80101fd6:	89 e5                	mov    %esp,%ebp
80101fd8:	57                   	push   %edi
80101fd9:	56                   	push   %esi
80101fda:	53                   	push   %ebx
80101fdb:	83 ec 10             	sub    $0x10,%esp
80101fde:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101fe1:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101fe8:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101fef:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80101ff3:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80101ff7:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
80101ffa:	85 c9                	test   %ecx,%ecx
80101ffc:	79 0a                	jns    80102008 <itoa+0x38>
80101ffe:	89 f0                	mov    %esi,%eax
80102000:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80102003:	f7 d9                	neg    %ecx
        *p++ = '-';
80102005:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80102008:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
8010200a:	bf 67 66 66 66       	mov    $0x66666667,%edi
8010200f:	90                   	nop
80102010:	89 d8                	mov    %ebx,%eax
80102012:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80102015:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80102018:	f7 ef                	imul   %edi
8010201a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
8010201d:	29 da                	sub    %ebx,%edx
8010201f:	89 d3                	mov    %edx,%ebx
80102021:	75 ed                	jne    80102010 <itoa+0x40>
    *p = '\0';
80102023:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102026:	bb 67 66 66 66       	mov    $0x66666667,%ebx
8010202b:	90                   	nop
8010202c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102030:	89 c8                	mov    %ecx,%eax
80102032:	83 ee 01             	sub    $0x1,%esi
80102035:	f7 eb                	imul   %ebx
80102037:	89 c8                	mov    %ecx,%eax
80102039:	c1 f8 1f             	sar    $0x1f,%eax
8010203c:	c1 fa 02             	sar    $0x2,%edx
8010203f:	29 c2                	sub    %eax,%edx
80102041:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102044:	01 c0                	add    %eax,%eax
80102046:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80102048:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
8010204a:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
8010204f:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102051:	88 06                	mov    %al,(%esi)
    }while(i);
80102053:	75 db                	jne    80102030 <itoa+0x60>
    return b;
}
80102055:	8b 45 0c             	mov    0xc(%ebp),%eax
80102058:	83 c4 10             	add    $0x10,%esp
8010205b:	5b                   	pop    %ebx
8010205c:	5e                   	pop    %esi
8010205d:	5f                   	pop    %edi
8010205e:	5d                   	pop    %ebp
8010205f:	c3                   	ret    

80102060 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	57                   	push   %edi
80102064:	56                   	push   %esi
80102065:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102066:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80102069:	83 ec 40             	sub    $0x40,%esp
8010206c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010206f:	6a 06                	push   $0x6
80102071:	68 55 79 10 80       	push   $0x80107955
80102076:	56                   	push   %esi
80102077:	e8 a4 29 00 00       	call   80104a20 <memmove>
  itoa(p->pid, path+ 6);
8010207c:	58                   	pop    %eax
8010207d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102080:	5a                   	pop    %edx
80102081:	50                   	push   %eax
80102082:	ff 73 10             	pushl  0x10(%ebx)
80102085:	e8 46 ff ff ff       	call   80101fd0 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010208a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010208d:	83 c4 10             	add    $0x10,%esp
80102090:	85 c0                	test   %eax,%eax
80102092:	0f 84 88 01 00 00    	je     80102220 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102098:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010209b:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
8010209e:	50                   	push   %eax
8010209f:	e8 4c ee ff ff       	call   80100ef0 <fileclose>

  begin_op();
801020a4:	e8 b7 0f 00 00       	call   80103060 <begin_op>
  return namex(path, 1, name);
801020a9:	89 f0                	mov    %esi,%eax
801020ab:	89 d9                	mov    %ebx,%ecx
801020ad:	ba 01 00 00 00       	mov    $0x1,%edx
801020b2:	e8 59 fc ff ff       	call   80101d10 <namex>
  if((dp = nameiparent(path, name)) == 0)
801020b7:	83 c4 10             	add    $0x10,%esp
801020ba:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
801020bc:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
801020be:	0f 84 66 01 00 00    	je     8010222a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
801020c4:	83 ec 0c             	sub    $0xc,%esp
801020c7:	50                   	push   %eax
801020c8:	e8 63 f6 ff ff       	call   80101730 <ilock>
  return strncmp(s, t, DIRSIZ);
801020cd:	83 c4 0c             	add    $0xc,%esp
801020d0:	6a 0e                	push   $0xe
801020d2:	68 5d 79 10 80       	push   $0x8010795d
801020d7:	53                   	push   %ebx
801020d8:	e8 b3 29 00 00       	call   80104a90 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801020dd:	83 c4 10             	add    $0x10,%esp
801020e0:	85 c0                	test   %eax,%eax
801020e2:	0f 84 f8 00 00 00    	je     801021e0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801020e8:	83 ec 04             	sub    $0x4,%esp
801020eb:	6a 0e                	push   $0xe
801020ed:	68 5c 79 10 80       	push   $0x8010795c
801020f2:	53                   	push   %ebx
801020f3:	e8 98 29 00 00       	call   80104a90 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801020f8:	83 c4 10             	add    $0x10,%esp
801020fb:	85 c0                	test   %eax,%eax
801020fd:	0f 84 dd 00 00 00    	je     801021e0 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102103:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102106:	83 ec 04             	sub    $0x4,%esp
80102109:	50                   	push   %eax
8010210a:	53                   	push   %ebx
8010210b:	56                   	push   %esi
8010210c:	e8 4f fb ff ff       	call   80101c60 <dirlookup>
80102111:	83 c4 10             	add    $0x10,%esp
80102114:	85 c0                	test   %eax,%eax
80102116:	89 c3                	mov    %eax,%ebx
80102118:	0f 84 c2 00 00 00    	je     801021e0 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010211e:	83 ec 0c             	sub    $0xc,%esp
80102121:	50                   	push   %eax
80102122:	e8 09 f6 ff ff       	call   80101730 <ilock>

  if(ip->nlink < 1)
80102127:	83 c4 10             	add    $0x10,%esp
8010212a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010212f:	0f 8e 11 01 00 00    	jle    80102246 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102135:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010213a:	74 74                	je     801021b0 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010213c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010213f:	83 ec 04             	sub    $0x4,%esp
80102142:	6a 10                	push   $0x10
80102144:	6a 00                	push   $0x0
80102146:	57                   	push   %edi
80102147:	e8 24 28 00 00       	call   80104970 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010214c:	6a 10                	push   $0x10
8010214e:	ff 75 b8             	pushl  -0x48(%ebp)
80102151:	57                   	push   %edi
80102152:	56                   	push   %esi
80102153:	e8 b8 f9 ff ff       	call   80101b10 <writei>
80102158:	83 c4 20             	add    $0x20,%esp
8010215b:	83 f8 10             	cmp    $0x10,%eax
8010215e:	0f 85 d5 00 00 00    	jne    80102239 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102164:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102169:	0f 84 91 00 00 00    	je     80102200 <removeSwapFile+0x1a0>
  iunlock(ip);
8010216f:	83 ec 0c             	sub    $0xc,%esp
80102172:	56                   	push   %esi
80102173:	e8 98 f6 ff ff       	call   80101810 <iunlock>
  iput(ip);
80102178:	89 34 24             	mov    %esi,(%esp)
8010217b:	e8 e0 f6 ff ff       	call   80101860 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102180:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102185:	89 1c 24             	mov    %ebx,(%esp)
80102188:	e8 f3 f4 ff ff       	call   80101680 <iupdate>
  iunlock(ip);
8010218d:	89 1c 24             	mov    %ebx,(%esp)
80102190:	e8 7b f6 ff ff       	call   80101810 <iunlock>
  iput(ip);
80102195:	89 1c 24             	mov    %ebx,(%esp)
80102198:	e8 c3 f6 ff ff       	call   80101860 <iput>
  iunlockput(ip);

  end_op();
8010219d:	e8 2e 0f 00 00       	call   801030d0 <end_op>

  return 0;
801021a2:	83 c4 10             	add    $0x10,%esp
801021a5:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
801021a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021aa:	5b                   	pop    %ebx
801021ab:	5e                   	pop    %esi
801021ac:	5f                   	pop    %edi
801021ad:	5d                   	pop    %ebp
801021ae:	c3                   	ret    
801021af:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
801021b0:	83 ec 0c             	sub    $0xc,%esp
801021b3:	53                   	push   %ebx
801021b4:	e8 97 2f 00 00       	call   80105150 <isdirempty>
801021b9:	83 c4 10             	add    $0x10,%esp
801021bc:	85 c0                	test   %eax,%eax
801021be:	0f 85 78 ff ff ff    	jne    8010213c <removeSwapFile+0xdc>
  iunlock(ip);
801021c4:	83 ec 0c             	sub    $0xc,%esp
801021c7:	53                   	push   %ebx
801021c8:	e8 43 f6 ff ff       	call   80101810 <iunlock>
  iput(ip);
801021cd:	89 1c 24             	mov    %ebx,(%esp)
801021d0:	e8 8b f6 ff ff       	call   80101860 <iput>
801021d5:	83 c4 10             	add    $0x10,%esp
801021d8:	90                   	nop
801021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801021e0:	83 ec 0c             	sub    $0xc,%esp
801021e3:	56                   	push   %esi
801021e4:	e8 27 f6 ff ff       	call   80101810 <iunlock>
  iput(ip);
801021e9:	89 34 24             	mov    %esi,(%esp)
801021ec:	e8 6f f6 ff ff       	call   80101860 <iput>
    end_op();
801021f1:	e8 da 0e 00 00       	call   801030d0 <end_op>
    return -1;
801021f6:	83 c4 10             	add    $0x10,%esp
801021f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021fe:	eb a7                	jmp    801021a7 <removeSwapFile+0x147>
    dp->nlink--;
80102200:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102205:	83 ec 0c             	sub    $0xc,%esp
80102208:	56                   	push   %esi
80102209:	e8 72 f4 ff ff       	call   80101680 <iupdate>
8010220e:	83 c4 10             	add    $0x10,%esp
80102211:	e9 59 ff ff ff       	jmp    8010216f <removeSwapFile+0x10f>
80102216:	8d 76 00             	lea    0x0(%esi),%esi
80102219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102225:	e9 7d ff ff ff       	jmp    801021a7 <removeSwapFile+0x147>
    end_op();
8010222a:	e8 a1 0e 00 00       	call   801030d0 <end_op>
    return -1;
8010222f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102234:	e9 6e ff ff ff       	jmp    801021a7 <removeSwapFile+0x147>
    panic("unlink: writei");
80102239:	83 ec 0c             	sub    $0xc,%esp
8010223c:	68 71 79 10 80       	push   $0x80107971
80102241:	e8 4a e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102246:	83 ec 0c             	sub    $0xc,%esp
80102249:	68 5f 79 10 80       	push   $0x8010795f
8010224e:	e8 3d e1 ff ff       	call   80100390 <panic>
80102253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102260 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	56                   	push   %esi
80102264:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102265:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
80102268:	83 ec 14             	sub    $0x14,%esp
8010226b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010226e:	6a 06                	push   $0x6
80102270:	68 55 79 10 80       	push   $0x80107955
80102275:	56                   	push   %esi
80102276:	e8 a5 27 00 00       	call   80104a20 <memmove>
  itoa(p->pid, path+ 6);
8010227b:	58                   	pop    %eax
8010227c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010227f:	5a                   	pop    %edx
80102280:	50                   	push   %eax
80102281:	ff 73 10             	pushl  0x10(%ebx)
80102284:	e8 47 fd ff ff       	call   80101fd0 <itoa>

    begin_op();
80102289:	e8 d2 0d 00 00       	call   80103060 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010228e:	6a 00                	push   $0x0
80102290:	6a 00                	push   $0x0
80102292:	6a 02                	push   $0x2
80102294:	56                   	push   %esi
80102295:	e8 c6 30 00 00       	call   80105360 <create>
  iunlock(in);
8010229a:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
8010229d:	89 c6                	mov    %eax,%esi
  iunlock(in);
8010229f:	50                   	push   %eax
801022a0:	e8 6b f5 ff ff       	call   80101810 <iunlock>

  p->swapFile = filealloc();
801022a5:	e8 86 eb ff ff       	call   80100e30 <filealloc>
  if (p->swapFile == 0)
801022aa:	83 c4 10             	add    $0x10,%esp
801022ad:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
801022af:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
801022b2:	74 32                	je     801022e6 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
801022b4:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
801022b7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022ba:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
801022c0:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022c3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
801022ca:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022cd:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
801022d1:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022d4:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
801022d8:	e8 f3 0d 00 00       	call   801030d0 <end_op>

    return 0;
}
801022dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022e0:	31 c0                	xor    %eax,%eax
801022e2:	5b                   	pop    %ebx
801022e3:	5e                   	pop    %esi
801022e4:	5d                   	pop    %ebp
801022e5:	c3                   	ret    
    panic("no slot for files on /store");
801022e6:	83 ec 0c             	sub    $0xc,%esp
801022e9:	68 80 79 10 80       	push   $0x80107980
801022ee:	e8 9d e0 ff ff       	call   80100390 <panic>
801022f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102300 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc* p, char* buffer, uint placeOnFile, uint size)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102306:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102309:	8b 50 7c             	mov    0x7c(%eax),%edx
8010230c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010230f:	8b 55 14             	mov    0x14(%ebp),%edx
80102312:	89 55 10             	mov    %edx,0x10(%ebp)
80102315:	8b 40 7c             	mov    0x7c(%eax),%eax
80102318:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010231b:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
8010231c:	e9 7f ed ff ff       	jmp    801010a0 <filewrite>
80102321:	eb 0d                	jmp    80102330 <readFromSwapFile>
80102323:	90                   	nop
80102324:	90                   	nop
80102325:	90                   	nop
80102326:	90                   	nop
80102327:	90                   	nop
80102328:	90                   	nop
80102329:	90                   	nop
8010232a:	90                   	nop
8010232b:	90                   	nop
8010232c:	90                   	nop
8010232d:	90                   	nop
8010232e:	90                   	nop
8010232f:	90                   	nop

80102330 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102336:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102339:	8b 50 7c             	mov    0x7c(%eax),%edx
8010233c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010233f:	8b 55 14             	mov    0x14(%ebp),%edx
80102342:	89 55 10             	mov    %edx,0x10(%ebp)
80102345:	8b 40 7c             	mov    0x7c(%eax),%eax
80102348:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010234b:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
8010234c:	e9 bf ec ff ff       	jmp    80101010 <fileread>
80102351:	66 90                	xchg   %ax,%ax
80102353:	66 90                	xchg   %ax,%ax
80102355:	66 90                	xchg   %ax,%ax
80102357:	66 90                	xchg   %ax,%ax
80102359:	66 90                	xchg   %ax,%ax
8010235b:	66 90                	xchg   %ax,%ax
8010235d:	66 90                	xchg   %ax,%ax
8010235f:	90                   	nop

80102360 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	57                   	push   %edi
80102364:	56                   	push   %esi
80102365:	53                   	push   %ebx
80102366:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102369:	85 c0                	test   %eax,%eax
8010236b:	0f 84 b4 00 00 00    	je     80102425 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102371:	8b 58 08             	mov    0x8(%eax),%ebx
80102374:	89 c6                	mov    %eax,%esi
80102376:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010237c:	0f 87 96 00 00 00    	ja     80102418 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102382:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102387:	89 f6                	mov    %esi,%esi
80102389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102390:	89 ca                	mov    %ecx,%edx
80102392:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102393:	83 e0 c0             	and    $0xffffffc0,%eax
80102396:	3c 40                	cmp    $0x40,%al
80102398:	75 f6                	jne    80102390 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010239a:	31 ff                	xor    %edi,%edi
8010239c:	ba f6 03 00 00       	mov    $0x3f6,%edx
801023a1:	89 f8                	mov    %edi,%eax
801023a3:	ee                   	out    %al,(%dx)
801023a4:	b8 01 00 00 00       	mov    $0x1,%eax
801023a9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801023ae:	ee                   	out    %al,(%dx)
801023af:	ba f3 01 00 00       	mov    $0x1f3,%edx
801023b4:	89 d8                	mov    %ebx,%eax
801023b6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801023b7:	89 d8                	mov    %ebx,%eax
801023b9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801023be:	c1 f8 08             	sar    $0x8,%eax
801023c1:	ee                   	out    %al,(%dx)
801023c2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801023c7:	89 f8                	mov    %edi,%eax
801023c9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801023ca:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801023ce:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023d3:	c1 e0 04             	shl    $0x4,%eax
801023d6:	83 e0 10             	and    $0x10,%eax
801023d9:	83 c8 e0             	or     $0xffffffe0,%eax
801023dc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801023dd:	f6 06 04             	testb  $0x4,(%esi)
801023e0:	75 16                	jne    801023f8 <idestart+0x98>
801023e2:	b8 20 00 00 00       	mov    $0x20,%eax
801023e7:	89 ca                	mov    %ecx,%edx
801023e9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801023ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023ed:	5b                   	pop    %ebx
801023ee:	5e                   	pop    %esi
801023ef:	5f                   	pop    %edi
801023f0:	5d                   	pop    %ebp
801023f1:	c3                   	ret    
801023f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801023f8:	b8 30 00 00 00       	mov    $0x30,%eax
801023fd:	89 ca                	mov    %ecx,%edx
801023ff:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102400:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102405:	83 c6 5c             	add    $0x5c,%esi
80102408:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010240d:	fc                   	cld    
8010240e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102410:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102413:	5b                   	pop    %ebx
80102414:	5e                   	pop    %esi
80102415:	5f                   	pop    %edi
80102416:	5d                   	pop    %ebp
80102417:	c3                   	ret    
    panic("incorrect blockno");
80102418:	83 ec 0c             	sub    $0xc,%esp
8010241b:	68 f8 79 10 80       	push   $0x801079f8
80102420:	e8 6b df ff ff       	call   80100390 <panic>
    panic("idestart");
80102425:	83 ec 0c             	sub    $0xc,%esp
80102428:	68 ef 79 10 80       	push   $0x801079ef
8010242d:	e8 5e df ff ff       	call   80100390 <panic>
80102432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <ideinit>:
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102446:	68 0a 7a 10 80       	push   $0x80107a0a
8010244b:	68 80 b5 10 80       	push   $0x8010b580
80102450:	e8 cb 22 00 00       	call   80104720 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102455:	58                   	pop    %eax
80102456:	a1 80 1d 12 80       	mov    0x80121d80,%eax
8010245b:	5a                   	pop    %edx
8010245c:	83 e8 01             	sub    $0x1,%eax
8010245f:	50                   	push   %eax
80102460:	6a 0e                	push   $0xe
80102462:	e8 a9 02 00 00       	call   80102710 <ioapicenable>
80102467:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010246a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010246f:	90                   	nop
80102470:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102471:	83 e0 c0             	and    $0xffffffc0,%eax
80102474:	3c 40                	cmp    $0x40,%al
80102476:	75 f8                	jne    80102470 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102478:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010247d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102482:	ee                   	out    %al,(%dx)
80102483:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102488:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010248d:	eb 06                	jmp    80102495 <ideinit+0x55>
8010248f:	90                   	nop
  for(i=0; i<1000; i++){
80102490:	83 e9 01             	sub    $0x1,%ecx
80102493:	74 0f                	je     801024a4 <ideinit+0x64>
80102495:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102496:	84 c0                	test   %al,%al
80102498:	74 f6                	je     80102490 <ideinit+0x50>
      havedisk1 = 1;
8010249a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801024a1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024a4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801024a9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024ae:	ee                   	out    %al,(%dx)
}
801024af:	c9                   	leave  
801024b0:	c3                   	ret    
801024b1:	eb 0d                	jmp    801024c0 <ideintr>
801024b3:	90                   	nop
801024b4:	90                   	nop
801024b5:	90                   	nop
801024b6:	90                   	nop
801024b7:	90                   	nop
801024b8:	90                   	nop
801024b9:	90                   	nop
801024ba:	90                   	nop
801024bb:	90                   	nop
801024bc:	90                   	nop
801024bd:	90                   	nop
801024be:	90                   	nop
801024bf:	90                   	nop

801024c0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	57                   	push   %edi
801024c4:	56                   	push   %esi
801024c5:	53                   	push   %ebx
801024c6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801024c9:	68 80 b5 10 80       	push   $0x8010b580
801024ce:	e8 8d 23 00 00       	call   80104860 <acquire>

  if((b = idequeue) == 0){
801024d3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801024d9:	83 c4 10             	add    $0x10,%esp
801024dc:	85 db                	test   %ebx,%ebx
801024de:	74 67                	je     80102547 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801024e0:	8b 43 58             	mov    0x58(%ebx),%eax
801024e3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801024e8:	8b 3b                	mov    (%ebx),%edi
801024ea:	f7 c7 04 00 00 00    	test   $0x4,%edi
801024f0:	75 31                	jne    80102523 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024f7:	89 f6                	mov    %esi,%esi
801024f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102500:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102501:	89 c6                	mov    %eax,%esi
80102503:	83 e6 c0             	and    $0xffffffc0,%esi
80102506:	89 f1                	mov    %esi,%ecx
80102508:	80 f9 40             	cmp    $0x40,%cl
8010250b:	75 f3                	jne    80102500 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010250d:	a8 21                	test   $0x21,%al
8010250f:	75 12                	jne    80102523 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102511:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102514:	b9 80 00 00 00       	mov    $0x80,%ecx
80102519:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010251e:	fc                   	cld    
8010251f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102521:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102523:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102526:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102529:	89 f9                	mov    %edi,%ecx
8010252b:	83 c9 02             	or     $0x2,%ecx
8010252e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102530:	53                   	push   %ebx
80102531:	e8 0a 1f 00 00       	call   80104440 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102536:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010253b:	83 c4 10             	add    $0x10,%esp
8010253e:	85 c0                	test   %eax,%eax
80102540:	74 05                	je     80102547 <ideintr+0x87>
    idestart(idequeue);
80102542:	e8 19 fe ff ff       	call   80102360 <idestart>
    release(&idelock);
80102547:	83 ec 0c             	sub    $0xc,%esp
8010254a:	68 80 b5 10 80       	push   $0x8010b580
8010254f:	e8 cc 23 00 00       	call   80104920 <release>

  release(&idelock);
}
80102554:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102557:	5b                   	pop    %ebx
80102558:	5e                   	pop    %esi
80102559:	5f                   	pop    %edi
8010255a:	5d                   	pop    %ebp
8010255b:	c3                   	ret    
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	53                   	push   %ebx
80102564:	83 ec 10             	sub    $0x10,%esp
80102567:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010256a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010256d:	50                   	push   %eax
8010256e:	e8 5d 21 00 00       	call   801046d0 <holdingsleep>
80102573:	83 c4 10             	add    $0x10,%esp
80102576:	85 c0                	test   %eax,%eax
80102578:	0f 84 c6 00 00 00    	je     80102644 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010257e:	8b 03                	mov    (%ebx),%eax
80102580:	83 e0 06             	and    $0x6,%eax
80102583:	83 f8 02             	cmp    $0x2,%eax
80102586:	0f 84 ab 00 00 00    	je     80102637 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010258c:	8b 53 04             	mov    0x4(%ebx),%edx
8010258f:	85 d2                	test   %edx,%edx
80102591:	74 0d                	je     801025a0 <iderw+0x40>
80102593:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102598:	85 c0                	test   %eax,%eax
8010259a:	0f 84 b1 00 00 00    	je     80102651 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801025a0:	83 ec 0c             	sub    $0xc,%esp
801025a3:	68 80 b5 10 80       	push   $0x8010b580
801025a8:	e8 b3 22 00 00       	call   80104860 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025ad:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801025b3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801025b6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025bd:	85 d2                	test   %edx,%edx
801025bf:	75 09                	jne    801025ca <iderw+0x6a>
801025c1:	eb 6d                	jmp    80102630 <iderw+0xd0>
801025c3:	90                   	nop
801025c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025c8:	89 c2                	mov    %eax,%edx
801025ca:	8b 42 58             	mov    0x58(%edx),%eax
801025cd:	85 c0                	test   %eax,%eax
801025cf:	75 f7                	jne    801025c8 <iderw+0x68>
801025d1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801025d4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801025d6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801025dc:	74 42                	je     80102620 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801025de:	8b 03                	mov    (%ebx),%eax
801025e0:	83 e0 06             	and    $0x6,%eax
801025e3:	83 f8 02             	cmp    $0x2,%eax
801025e6:	74 23                	je     8010260b <iderw+0xab>
801025e8:	90                   	nop
801025e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801025f0:	83 ec 08             	sub    $0x8,%esp
801025f3:	68 80 b5 10 80       	push   $0x8010b580
801025f8:	53                   	push   %ebx
801025f9:	e8 82 1c 00 00       	call   80104280 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801025fe:	8b 03                	mov    (%ebx),%eax
80102600:	83 c4 10             	add    $0x10,%esp
80102603:	83 e0 06             	and    $0x6,%eax
80102606:	83 f8 02             	cmp    $0x2,%eax
80102609:	75 e5                	jne    801025f0 <iderw+0x90>
  }


  release(&idelock);
8010260b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102612:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102615:	c9                   	leave  
  release(&idelock);
80102616:	e9 05 23 00 00       	jmp    80104920 <release>
8010261b:	90                   	nop
8010261c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102620:	89 d8                	mov    %ebx,%eax
80102622:	e8 39 fd ff ff       	call   80102360 <idestart>
80102627:	eb b5                	jmp    801025de <iderw+0x7e>
80102629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102630:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102635:	eb 9d                	jmp    801025d4 <iderw+0x74>
    panic("iderw: nothing to do");
80102637:	83 ec 0c             	sub    $0xc,%esp
8010263a:	68 24 7a 10 80       	push   $0x80107a24
8010263f:	e8 4c dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102644:	83 ec 0c             	sub    $0xc,%esp
80102647:	68 0e 7a 10 80       	push   $0x80107a0e
8010264c:	e8 3f dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102651:	83 ec 0c             	sub    $0xc,%esp
80102654:	68 39 7a 10 80       	push   $0x80107a39
80102659:	e8 32 dd ff ff       	call   80100390 <panic>
8010265e:	66 90                	xchg   %ax,%ax

80102660 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102660:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102661:	c7 05 74 16 12 80 00 	movl   $0xfec00000,0x80121674
80102668:	00 c0 fe 
{
8010266b:	89 e5                	mov    %esp,%ebp
8010266d:	56                   	push   %esi
8010266e:	53                   	push   %ebx
  ioapic->reg = reg;
8010266f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102676:	00 00 00 
  return ioapic->data;
80102679:	a1 74 16 12 80       	mov    0x80121674,%eax
8010267e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102681:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102687:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010268d:	0f b6 15 e0 17 12 80 	movzbl 0x801217e0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102694:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102697:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010269a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010269d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801026a0:	39 c2                	cmp    %eax,%edx
801026a2:	74 16                	je     801026ba <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801026a4:	83 ec 0c             	sub    $0xc,%esp
801026a7:	68 58 7a 10 80       	push   $0x80107a58
801026ac:	e8 af df ff ff       	call   80100660 <cprintf>
801026b1:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
801026b7:	83 c4 10             	add    $0x10,%esp
801026ba:	83 c3 21             	add    $0x21,%ebx
{
801026bd:	ba 10 00 00 00       	mov    $0x10,%edx
801026c2:	b8 20 00 00 00       	mov    $0x20,%eax
801026c7:	89 f6                	mov    %esi,%esi
801026c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801026d0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801026d2:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801026d8:	89 c6                	mov    %eax,%esi
801026da:	81 ce 00 00 01 00    	or     $0x10000,%esi
801026e0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026e3:	89 71 10             	mov    %esi,0x10(%ecx)
801026e6:	8d 72 01             	lea    0x1(%edx),%esi
801026e9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801026ec:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801026ee:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801026f0:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
801026f6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801026fd:	75 d1                	jne    801026d0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801026ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102702:	5b                   	pop    %ebx
80102703:	5e                   	pop    %esi
80102704:	5d                   	pop    %ebp
80102705:	c3                   	ret    
80102706:	8d 76 00             	lea    0x0(%esi),%esi
80102709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102710 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102710:	55                   	push   %ebp
  ioapic->reg = reg;
80102711:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
{
80102717:	89 e5                	mov    %esp,%ebp
80102719:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010271c:	8d 50 20             	lea    0x20(%eax),%edx
8010271f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102723:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102725:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010272b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010272e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102731:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102734:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102736:	a1 74 16 12 80       	mov    0x80121674,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010273b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010273e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102741:	5d                   	pop    %ebp
80102742:	c3                   	ret    
80102743:	66 90                	xchg   %ax,%ax
80102745:	66 90                	xchg   %ax,%ax
80102747:	66 90                	xchg   %ax,%ax
80102749:	66 90                	xchg   %ax,%ax
8010274b:	66 90                	xchg   %ax,%ax
8010274d:	66 90                	xchg   %ax,%ax
8010274f:	90                   	nop

80102750 <init_cow>:



struct spinlock r_cow_lock;

void init_cow(){
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	83 ec 14             	sub    $0x14,%esp
  cprintf("initing cow\n");
80102756:	68 8a 7a 10 80       	push   $0x80107a8a
8010275b:	e8 00 df ff ff       	call   80100660 <cprintf>
  memset((void*)pg_ref_counts, 0, sizeof(pg_ref_counts));
80102760:	83 c4 0c             	add    $0xc,%esp
80102763:	68 00 e0 00 00       	push   $0xe000
80102768:	6a 00                	push   $0x0
8010276a:	68 40 0f 11 80       	push   $0x80110f40
8010276f:	e8 fc 21 00 00       	call   80104970 <memset>
  initlock(&r_cow_lock, "cow lock");
80102774:	58                   	pop    %eax
80102775:	5a                   	pop    %edx
80102776:	68 97 7a 10 80       	push   $0x80107a97
8010277b:	68 c0 16 12 80       	push   $0x801216c0
80102780:	e8 9b 1f 00 00       	call   80104720 <initlock>
  cow_lock = &r_cow_lock;
  cprintf("initing cow end\n");
80102785:	c7 04 24 a0 7a 10 80 	movl   $0x80107aa0,(%esp)
  cow_lock = &r_cow_lock;
8010278c:	c7 05 40 ef 11 80 c0 	movl   $0x801216c0,0x8011ef40
80102793:	16 12 80 
  cprintf("initing cow end\n");
80102796:	e8 c5 de ff ff       	call   80100660 <cprintf>
}
8010279b:	83 c4 10             	add    $0x10,%esp
8010279e:	c9                   	leave  
8010279f:	c3                   	ret    

801027a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	53                   	push   %ebx
801027a4:	83 ec 04             	sub    $0x4,%esp
801027a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801027aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801027b0:	75 70                	jne    80102822 <kfree+0x82>
801027b2:	81 fb 28 1a 13 80    	cmp    $0x80131a28,%ebx
801027b8:	72 68                	jb     80102822 <kfree+0x82>
801027ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801027c0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801027c5:	77 5b                	ja     80102822 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801027c7:	83 ec 04             	sub    $0x4,%esp
801027ca:	68 00 10 00 00       	push   $0x1000
801027cf:	6a 01                	push   $0x1
801027d1:	53                   	push   %ebx
801027d2:	e8 99 21 00 00       	call   80104970 <memset>

  if(kmem.use_lock)
801027d7:	8b 15 b4 16 12 80    	mov    0x801216b4,%edx
801027dd:	83 c4 10             	add    $0x10,%esp
801027e0:	85 d2                	test   %edx,%edx
801027e2:	75 2c                	jne    80102810 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801027e4:	a1 b8 16 12 80       	mov    0x801216b8,%eax
801027e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801027eb:	a1 b4 16 12 80       	mov    0x801216b4,%eax
  kmem.freelist = r;
801027f0:	89 1d b8 16 12 80    	mov    %ebx,0x801216b8
  if(kmem.use_lock)
801027f6:	85 c0                	test   %eax,%eax
801027f8:	75 06                	jne    80102800 <kfree+0x60>
    release(&kmem.lock);
}
801027fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027fd:	c9                   	leave  
801027fe:	c3                   	ret    
801027ff:	90                   	nop
    release(&kmem.lock);
80102800:	c7 45 08 80 16 12 80 	movl   $0x80121680,0x8(%ebp)
}
80102807:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010280a:	c9                   	leave  
    release(&kmem.lock);
8010280b:	e9 10 21 00 00       	jmp    80104920 <release>
    acquire(&kmem.lock);
80102810:	83 ec 0c             	sub    $0xc,%esp
80102813:	68 80 16 12 80       	push   $0x80121680
80102818:	e8 43 20 00 00       	call   80104860 <acquire>
8010281d:	83 c4 10             	add    $0x10,%esp
80102820:	eb c2                	jmp    801027e4 <kfree+0x44>
    panic("kfree");
80102822:	83 ec 0c             	sub    $0xc,%esp
80102825:	68 5e 82 10 80       	push   $0x8010825e
8010282a:	e8 61 db ff ff       	call   80100390 <panic>
8010282f:	90                   	nop

80102830 <freerange>:
{
80102830:	55                   	push   %ebp
80102831:	89 e5                	mov    %esp,%ebp
80102833:	56                   	push   %esi
80102834:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102835:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102838:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010283b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102841:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102847:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010284d:	39 de                	cmp    %ebx,%esi
8010284f:	72 33                	jb     80102884 <freerange+0x54>
80102851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102858:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010285e:	83 ec 0c             	sub    $0xc,%esp
80102861:	50                   	push   %eax
80102862:	e8 39 ff ff ff       	call   801027a0 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102867:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010286d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102873:	83 c4 10             	add    $0x10,%esp
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102876:	c1 e8 0c             	shr    $0xc,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102879:	39 f3                	cmp    %esi,%ebx
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
8010287b:	c6 80 40 0f 11 80 00 	movb   $0x0,-0x7feef0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102882:	76 d4                	jbe    80102858 <freerange+0x28>
}
80102884:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102887:	5b                   	pop    %ebx
80102888:	5e                   	pop    %esi
80102889:	5d                   	pop    %ebp
8010288a:	c3                   	ret    
8010288b:	90                   	nop
8010288c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102890 <kinit1>:
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
80102893:	56                   	push   %esi
80102894:	53                   	push   %ebx
80102895:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102898:	83 ec 08             	sub    $0x8,%esp
8010289b:	68 b1 7a 10 80       	push   $0x80107ab1
801028a0:	68 80 16 12 80       	push   $0x80121680
801028a5:	e8 76 1e 00 00       	call   80104720 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801028aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028ad:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801028b0:	c7 05 b4 16 12 80 00 	movl   $0x0,0x801216b4
801028b7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801028ba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028cc:	39 de                	cmp    %ebx,%esi
801028ce:	72 2c                	jb     801028fc <kinit1+0x6c>
    kfree(p);
801028d0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801028d6:	83 ec 0c             	sub    $0xc,%esp
801028d9:	50                   	push   %eax
801028da:	e8 c1 fe ff ff       	call   801027a0 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
801028df:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028e5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028eb:	83 c4 10             	add    $0x10,%esp
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
801028ee:	c1 e8 0c             	shr    $0xc,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028f1:	39 de                	cmp    %ebx,%esi
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
801028f3:	c6 80 40 0f 11 80 00 	movb   $0x0,-0x7feef0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028fa:	73 d4                	jae    801028d0 <kinit1+0x40>
}
801028fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028ff:	5b                   	pop    %ebx
80102900:	5e                   	pop    %esi
80102901:	5d                   	pop    %ebp
80102902:	c3                   	ret    
80102903:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102910 <kinit2>:
{
80102910:	55                   	push   %ebp
80102911:	89 e5                	mov    %esp,%ebp
80102913:	56                   	push   %esi
80102914:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102915:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102918:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010291b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102921:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102927:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010292d:	39 de                	cmp    %ebx,%esi
8010292f:	72 33                	jb     80102964 <kinit2+0x54>
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102938:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010293e:	83 ec 0c             	sub    $0xc,%esp
80102941:	50                   	push   %eax
80102942:	e8 59 fe ff ff       	call   801027a0 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102947:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010294d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102953:	83 c4 10             	add    $0x10,%esp
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102956:	c1 e8 0c             	shr    $0xc,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102959:	39 de                	cmp    %ebx,%esi
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
8010295b:	c6 80 40 0f 11 80 00 	movb   $0x0,-0x7feef0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102962:	73 d4                	jae    80102938 <kinit2+0x28>
  kmem.use_lock = 1;
80102964:	c7 05 b4 16 12 80 01 	movl   $0x1,0x801216b4
8010296b:	00 00 00 
}
8010296e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102971:	5b                   	pop    %ebx
80102972:	5e                   	pop    %esi
80102973:	5d                   	pop    %ebp
80102974:	c3                   	ret    
80102975:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102980 <kalloc>:
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;
  if(kmem.use_lock)
80102980:	a1 b4 16 12 80       	mov    0x801216b4,%eax
80102985:	85 c0                	test   %eax,%eax
80102987:	75 1f                	jne    801029a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102989:	a1 b8 16 12 80       	mov    0x801216b8,%eax
  if(r)
8010298e:	85 c0                	test   %eax,%eax
80102990:	74 0e                	je     801029a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102992:	8b 10                	mov    (%eax),%edx
80102994:	89 15 b8 16 12 80    	mov    %edx,0x801216b8
8010299a:	c3                   	ret    
8010299b:	90                   	nop
8010299c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801029a0:	f3 c3                	repz ret 
801029a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801029a8:	55                   	push   %ebp
801029a9:	89 e5                	mov    %esp,%ebp
801029ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801029ae:	68 80 16 12 80       	push   $0x80121680
801029b3:	e8 a8 1e 00 00       	call   80104860 <acquire>
  r = kmem.freelist;
801029b8:	a1 b8 16 12 80       	mov    0x801216b8,%eax
  if(r)
801029bd:	83 c4 10             	add    $0x10,%esp
801029c0:	8b 15 b4 16 12 80    	mov    0x801216b4,%edx
801029c6:	85 c0                	test   %eax,%eax
801029c8:	74 08                	je     801029d2 <kalloc+0x52>
    kmem.freelist = r->next;
801029ca:	8b 08                	mov    (%eax),%ecx
801029cc:	89 0d b8 16 12 80    	mov    %ecx,0x801216b8
  if(kmem.use_lock)
801029d2:	85 d2                	test   %edx,%edx
801029d4:	74 16                	je     801029ec <kalloc+0x6c>
    release(&kmem.lock);
801029d6:	83 ec 0c             	sub    $0xc,%esp
801029d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029dc:	68 80 16 12 80       	push   $0x80121680
801029e1:	e8 3a 1f 00 00       	call   80104920 <release>
  return (char*)r;
801029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801029e9:	83 c4 10             	add    $0x10,%esp
}
801029ec:	c9                   	leave  
801029ed:	c3                   	ret    
801029ee:	66 90                	xchg   %ax,%ax

801029f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f0:	ba 64 00 00 00       	mov    $0x64,%edx
801029f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801029f6:	a8 01                	test   $0x1,%al
801029f8:	0f 84 c2 00 00 00    	je     80102ac0 <kbdgetc+0xd0>
801029fe:	ba 60 00 00 00       	mov    $0x60,%edx
80102a03:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102a04:	0f b6 d0             	movzbl %al,%edx
80102a07:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
80102a0d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102a13:	0f 84 7f 00 00 00    	je     80102a98 <kbdgetc+0xa8>
{
80102a19:	55                   	push   %ebp
80102a1a:	89 e5                	mov    %esp,%ebp
80102a1c:	53                   	push   %ebx
80102a1d:	89 cb                	mov    %ecx,%ebx
80102a1f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102a22:	84 c0                	test   %al,%al
80102a24:	78 4a                	js     80102a70 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102a26:	85 db                	test   %ebx,%ebx
80102a28:	74 09                	je     80102a33 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102a2a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102a2d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102a30:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102a33:	0f b6 82 e0 7b 10 80 	movzbl -0x7fef8420(%edx),%eax
80102a3a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102a3c:	0f b6 82 e0 7a 10 80 	movzbl -0x7fef8520(%edx),%eax
80102a43:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a45:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102a47:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102a4d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a50:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a53:	8b 04 85 c0 7a 10 80 	mov    -0x7fef8540(,%eax,4),%eax
80102a5a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102a5e:	74 31                	je     80102a91 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102a60:	8d 50 9f             	lea    -0x61(%eax),%edx
80102a63:	83 fa 19             	cmp    $0x19,%edx
80102a66:	77 40                	ja     80102aa8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102a68:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a6b:	5b                   	pop    %ebx
80102a6c:	5d                   	pop    %ebp
80102a6d:	c3                   	ret    
80102a6e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102a70:	83 e0 7f             	and    $0x7f,%eax
80102a73:	85 db                	test   %ebx,%ebx
80102a75:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102a78:	0f b6 82 e0 7b 10 80 	movzbl -0x7fef8420(%edx),%eax
80102a7f:	83 c8 40             	or     $0x40,%eax
80102a82:	0f b6 c0             	movzbl %al,%eax
80102a85:	f7 d0                	not    %eax
80102a87:	21 c1                	and    %eax,%ecx
    return 0;
80102a89:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102a8b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102a91:	5b                   	pop    %ebx
80102a92:	5d                   	pop    %ebp
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102a98:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102a9b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102a9d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102aa3:	c3                   	ret    
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102aa8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102aab:	8d 50 20             	lea    0x20(%eax),%edx
}
80102aae:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102aaf:	83 f9 1a             	cmp    $0x1a,%ecx
80102ab2:	0f 42 c2             	cmovb  %edx,%eax
}
80102ab5:	5d                   	pop    %ebp
80102ab6:	c3                   	ret    
80102ab7:	89 f6                	mov    %esi,%esi
80102ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ac5:	c3                   	ret    
80102ac6:	8d 76 00             	lea    0x0(%esi),%esi
80102ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ad0 <kbdintr>:

void
kbdintr(void)
{
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102ad6:	68 f0 29 10 80       	push   $0x801029f0
80102adb:	e8 30 dd ff ff       	call   80100810 <consoleintr>
}
80102ae0:	83 c4 10             	add    $0x10,%esp
80102ae3:	c9                   	leave  
80102ae4:	c3                   	ret    
80102ae5:	66 90                	xchg   %ax,%ax
80102ae7:	66 90                	xchg   %ax,%ax
80102ae9:	66 90                	xchg   %ax,%ax
80102aeb:	66 90                	xchg   %ax,%ax
80102aed:	66 90                	xchg   %ax,%ax
80102aef:	90                   	nop

80102af0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102af0:	a1 f4 16 12 80       	mov    0x801216f4,%eax
{
80102af5:	55                   	push   %ebp
80102af6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102af8:	85 c0                	test   %eax,%eax
80102afa:	0f 84 c8 00 00 00    	je     80102bc8 <lapicinit+0xd8>
  lapic[index] = value;
80102b00:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102b07:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b0a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b0d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102b14:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b17:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b1a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102b21:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102b24:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b27:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102b2e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102b31:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b34:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102b3b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b3e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b41:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b48:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b4b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b4e:	8b 50 30             	mov    0x30(%eax),%edx
80102b51:	c1 ea 10             	shr    $0x10,%edx
80102b54:	80 fa 03             	cmp    $0x3,%dl
80102b57:	77 77                	ja     80102bd0 <lapicinit+0xe0>
  lapic[index] = value;
80102b59:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102b60:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b63:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b66:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b6d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b70:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b73:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b7a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b7d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b80:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b87:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b8a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b8d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102b94:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b97:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b9a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ba1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ba4:	8b 50 20             	mov    0x20(%eax),%edx
80102ba7:	89 f6                	mov    %esi,%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102bb0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102bb6:	80 e6 10             	and    $0x10,%dh
80102bb9:	75 f5                	jne    80102bb0 <lapicinit+0xc0>
  lapic[index] = value;
80102bbb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102bc2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102bc8:	5d                   	pop    %ebp
80102bc9:	c3                   	ret    
80102bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102bd0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102bd7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bda:	8b 50 20             	mov    0x20(%eax),%edx
80102bdd:	e9 77 ff ff ff       	jmp    80102b59 <lapicinit+0x69>
80102be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bf0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102bf0:	8b 15 f4 16 12 80    	mov    0x801216f4,%edx
{
80102bf6:	55                   	push   %ebp
80102bf7:	31 c0                	xor    %eax,%eax
80102bf9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102bfb:	85 d2                	test   %edx,%edx
80102bfd:	74 06                	je     80102c05 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102bff:	8b 42 20             	mov    0x20(%edx),%eax
80102c02:	c1 e8 18             	shr    $0x18,%eax
}
80102c05:	5d                   	pop    %ebp
80102c06:	c3                   	ret    
80102c07:	89 f6                	mov    %esi,%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102c10:	a1 f4 16 12 80       	mov    0x801216f4,%eax
{
80102c15:	55                   	push   %ebp
80102c16:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102c18:	85 c0                	test   %eax,%eax
80102c1a:	74 0d                	je     80102c29 <lapiceoi+0x19>
  lapic[index] = value;
80102c1c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c23:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c26:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102c29:	5d                   	pop    %ebp
80102c2a:	c3                   	ret    
80102c2b:	90                   	nop
80102c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c30 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
}
80102c33:	5d                   	pop    %ebp
80102c34:	c3                   	ret    
80102c35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c40 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c40:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c41:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c46:	ba 70 00 00 00       	mov    $0x70,%edx
80102c4b:	89 e5                	mov    %esp,%ebp
80102c4d:	53                   	push   %ebx
80102c4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102c51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c54:	ee                   	out    %al,(%dx)
80102c55:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c5a:	ba 71 00 00 00       	mov    $0x71,%edx
80102c5f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102c60:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c62:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102c65:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102c6b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c6d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102c70:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102c73:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c75:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102c78:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102c7e:	a1 f4 16 12 80       	mov    0x801216f4,%eax
80102c83:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c89:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c8c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102c93:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c96:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c99:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ca0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ca3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ca6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102caf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cb5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102cb8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cbe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cc1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cc7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102cca:	5b                   	pop    %ebx
80102ccb:	5d                   	pop    %ebp
80102ccc:	c3                   	ret    
80102ccd:	8d 76 00             	lea    0x0(%esi),%esi

80102cd0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102cd0:	55                   	push   %ebp
80102cd1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102cd6:	ba 70 00 00 00       	mov    $0x70,%edx
80102cdb:	89 e5                	mov    %esp,%ebp
80102cdd:	57                   	push   %edi
80102cde:	56                   	push   %esi
80102cdf:	53                   	push   %ebx
80102ce0:	83 ec 4c             	sub    $0x4c,%esp
80102ce3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ce9:	ec                   	in     (%dx),%al
80102cea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ced:	bb 70 00 00 00       	mov    $0x70,%ebx
80102cf2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102cf5:	8d 76 00             	lea    0x0(%esi),%esi
80102cf8:	31 c0                	xor    %eax,%eax
80102cfa:	89 da                	mov    %ebx,%edx
80102cfc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cfd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102d02:	89 ca                	mov    %ecx,%edx
80102d04:	ec                   	in     (%dx),%al
80102d05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d08:	89 da                	mov    %ebx,%edx
80102d0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102d0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d10:	89 ca                	mov    %ecx,%edx
80102d12:	ec                   	in     (%dx),%al
80102d13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d16:	89 da                	mov    %ebx,%edx
80102d18:	b8 04 00 00 00       	mov    $0x4,%eax
80102d1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d1e:	89 ca                	mov    %ecx,%edx
80102d20:	ec                   	in     (%dx),%al
80102d21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d24:	89 da                	mov    %ebx,%edx
80102d26:	b8 07 00 00 00       	mov    $0x7,%eax
80102d2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d2c:	89 ca                	mov    %ecx,%edx
80102d2e:	ec                   	in     (%dx),%al
80102d2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d32:	89 da                	mov    %ebx,%edx
80102d34:	b8 08 00 00 00       	mov    $0x8,%eax
80102d39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d3a:	89 ca                	mov    %ecx,%edx
80102d3c:	ec                   	in     (%dx),%al
80102d3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d3f:	89 da                	mov    %ebx,%edx
80102d41:	b8 09 00 00 00       	mov    $0x9,%eax
80102d46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d47:	89 ca                	mov    %ecx,%edx
80102d49:	ec                   	in     (%dx),%al
80102d4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d4c:	89 da                	mov    %ebx,%edx
80102d4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d54:	89 ca                	mov    %ecx,%edx
80102d56:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102d57:	84 c0                	test   %al,%al
80102d59:	78 9d                	js     80102cf8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102d5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102d5f:	89 fa                	mov    %edi,%edx
80102d61:	0f b6 fa             	movzbl %dl,%edi
80102d64:	89 f2                	mov    %esi,%edx
80102d66:	0f b6 f2             	movzbl %dl,%esi
80102d69:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d6c:	89 da                	mov    %ebx,%edx
80102d6e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102d71:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102d74:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102d78:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102d7b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102d7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102d82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102d86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102d89:	31 c0                	xor    %eax,%eax
80102d8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d8c:	89 ca                	mov    %ecx,%edx
80102d8e:	ec                   	in     (%dx),%al
80102d8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d92:	89 da                	mov    %ebx,%edx
80102d94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102d97:	b8 02 00 00 00       	mov    $0x2,%eax
80102d9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d9d:	89 ca                	mov    %ecx,%edx
80102d9f:	ec                   	in     (%dx),%al
80102da0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102da3:	89 da                	mov    %ebx,%edx
80102da5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102da8:	b8 04 00 00 00       	mov    $0x4,%eax
80102dad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dae:	89 ca                	mov    %ecx,%edx
80102db0:	ec                   	in     (%dx),%al
80102db1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db4:	89 da                	mov    %ebx,%edx
80102db6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102db9:	b8 07 00 00 00       	mov    $0x7,%eax
80102dbe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dbf:	89 ca                	mov    %ecx,%edx
80102dc1:	ec                   	in     (%dx),%al
80102dc2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc5:	89 da                	mov    %ebx,%edx
80102dc7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102dca:	b8 08 00 00 00       	mov    $0x8,%eax
80102dcf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dd0:	89 ca                	mov    %ecx,%edx
80102dd2:	ec                   	in     (%dx),%al
80102dd3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dd6:	89 da                	mov    %ebx,%edx
80102dd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ddb:	b8 09 00 00 00       	mov    $0x9,%eax
80102de0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102de1:	89 ca                	mov    %ecx,%edx
80102de3:	ec                   	in     (%dx),%al
80102de4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102de7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102dea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ded:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102df0:	6a 18                	push   $0x18
80102df2:	50                   	push   %eax
80102df3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102df6:	50                   	push   %eax
80102df7:	e8 c4 1b 00 00       	call   801049c0 <memcmp>
80102dfc:	83 c4 10             	add    $0x10,%esp
80102dff:	85 c0                	test   %eax,%eax
80102e01:	0f 85 f1 fe ff ff    	jne    80102cf8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102e07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102e0b:	75 78                	jne    80102e85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102e0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e10:	89 c2                	mov    %eax,%edx
80102e12:	83 e0 0f             	and    $0xf,%eax
80102e15:	c1 ea 04             	shr    $0x4,%edx
80102e18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102e21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e24:	89 c2                	mov    %eax,%edx
80102e26:	83 e0 0f             	and    $0xf,%eax
80102e29:	c1 ea 04             	shr    $0x4,%edx
80102e2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102e35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e38:	89 c2                	mov    %eax,%edx
80102e3a:	83 e0 0f             	and    $0xf,%eax
80102e3d:	c1 ea 04             	shr    $0x4,%edx
80102e40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e4c:	89 c2                	mov    %eax,%edx
80102e4e:	83 e0 0f             	and    $0xf,%eax
80102e51:	c1 ea 04             	shr    $0x4,%edx
80102e54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102e5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e60:	89 c2                	mov    %eax,%edx
80102e62:	83 e0 0f             	and    $0xf,%eax
80102e65:	c1 ea 04             	shr    $0x4,%edx
80102e68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102e71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e74:	89 c2                	mov    %eax,%edx
80102e76:	83 e0 0f             	and    $0xf,%eax
80102e79:	c1 ea 04             	shr    $0x4,%edx
80102e7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102e85:	8b 75 08             	mov    0x8(%ebp),%esi
80102e88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e8b:	89 06                	mov    %eax,(%esi)
80102e8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e90:	89 46 04             	mov    %eax,0x4(%esi)
80102e93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e96:	89 46 08             	mov    %eax,0x8(%esi)
80102e99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102e9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ea2:	89 46 10             	mov    %eax,0x10(%esi)
80102ea5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ea8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102eab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102eb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eb5:	5b                   	pop    %ebx
80102eb6:	5e                   	pop    %esi
80102eb7:	5f                   	pop    %edi
80102eb8:	5d                   	pop    %ebp
80102eb9:	c3                   	ret    
80102eba:	66 90                	xchg   %ax,%ax
80102ebc:	66 90                	xchg   %ax,%ax
80102ebe:	66 90                	xchg   %ax,%ax

80102ec0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ec0:	8b 0d 48 17 12 80    	mov    0x80121748,%ecx
80102ec6:	85 c9                	test   %ecx,%ecx
80102ec8:	0f 8e 8a 00 00 00    	jle    80102f58 <install_trans+0x98>
{
80102ece:	55                   	push   %ebp
80102ecf:	89 e5                	mov    %esp,%ebp
80102ed1:	57                   	push   %edi
80102ed2:	56                   	push   %esi
80102ed3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed4:	31 db                	xor    %ebx,%ebx
{
80102ed6:	83 ec 0c             	sub    $0xc,%esp
80102ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ee0:	a1 34 17 12 80       	mov    0x80121734,%eax
80102ee5:	83 ec 08             	sub    $0x8,%esp
80102ee8:	01 d8                	add    %ebx,%eax
80102eea:	83 c0 01             	add    $0x1,%eax
80102eed:	50                   	push   %eax
80102eee:	ff 35 44 17 12 80    	pushl  0x80121744
80102ef4:	e8 d7 d1 ff ff       	call   801000d0 <bread>
80102ef9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102efb:	58                   	pop    %eax
80102efc:	5a                   	pop    %edx
80102efd:	ff 34 9d 4c 17 12 80 	pushl  -0x7fede8b4(,%ebx,4)
80102f04:	ff 35 44 17 12 80    	pushl  0x80121744
  for (tail = 0; tail < log.lh.n; tail++) {
80102f0a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102f0d:	e8 be d1 ff ff       	call   801000d0 <bread>
80102f12:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f14:	8d 47 5c             	lea    0x5c(%edi),%eax
80102f17:	83 c4 0c             	add    $0xc,%esp
80102f1a:	68 00 02 00 00       	push   $0x200
80102f1f:	50                   	push   %eax
80102f20:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f23:	50                   	push   %eax
80102f24:	e8 f7 1a 00 00       	call   80104a20 <memmove>
    bwrite(dbuf);  // write dst to disk
80102f29:	89 34 24             	mov    %esi,(%esp)
80102f2c:	e8 6f d2 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102f31:	89 3c 24             	mov    %edi,(%esp)
80102f34:	e8 a7 d2 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102f39:	89 34 24             	mov    %esi,(%esp)
80102f3c:	e8 9f d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f41:	83 c4 10             	add    $0x10,%esp
80102f44:	39 1d 48 17 12 80    	cmp    %ebx,0x80121748
80102f4a:	7f 94                	jg     80102ee0 <install_trans+0x20>
  }
}
80102f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f4f:	5b                   	pop    %ebx
80102f50:	5e                   	pop    %esi
80102f51:	5f                   	pop    %edi
80102f52:	5d                   	pop    %ebp
80102f53:	c3                   	ret    
80102f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f58:	f3 c3                	repz ret 
80102f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102f60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	56                   	push   %esi
80102f64:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102f65:	83 ec 08             	sub    $0x8,%esp
80102f68:	ff 35 34 17 12 80    	pushl  0x80121734
80102f6e:	ff 35 44 17 12 80    	pushl  0x80121744
80102f74:	e8 57 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102f79:	8b 1d 48 17 12 80    	mov    0x80121748,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102f7f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f82:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102f84:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102f86:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102f89:	7e 16                	jle    80102fa1 <write_head+0x41>
80102f8b:	c1 e3 02             	shl    $0x2,%ebx
80102f8e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102f90:	8b 8a 4c 17 12 80    	mov    -0x7fede8b4(%edx),%ecx
80102f96:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102f9a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102f9d:	39 da                	cmp    %ebx,%edx
80102f9f:	75 ef                	jne    80102f90 <write_head+0x30>
  }
  bwrite(buf);
80102fa1:	83 ec 0c             	sub    $0xc,%esp
80102fa4:	56                   	push   %esi
80102fa5:	e8 f6 d1 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102faa:	89 34 24             	mov    %esi,(%esp)
80102fad:	e8 2e d2 ff ff       	call   801001e0 <brelse>
}
80102fb2:	83 c4 10             	add    $0x10,%esp
80102fb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102fb8:	5b                   	pop    %ebx
80102fb9:	5e                   	pop    %esi
80102fba:	5d                   	pop    %ebp
80102fbb:	c3                   	ret    
80102fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102fc0 <initlog>:
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	53                   	push   %ebx
80102fc4:	83 ec 2c             	sub    $0x2c,%esp
80102fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102fca:	68 e0 7c 10 80       	push   $0x80107ce0
80102fcf:	68 00 17 12 80       	push   $0x80121700
80102fd4:	e8 47 17 00 00       	call   80104720 <initlock>
  readsb(dev, &sb);
80102fd9:	58                   	pop    %eax
80102fda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102fdd:	5a                   	pop    %edx
80102fde:	50                   	push   %eax
80102fdf:	53                   	push   %ebx
80102fe0:	e8 0b e5 ff ff       	call   801014f0 <readsb>
  log.size = sb.nlog;
80102fe5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102fe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102feb:	59                   	pop    %ecx
  log.dev = dev;
80102fec:	89 1d 44 17 12 80    	mov    %ebx,0x80121744
  log.size = sb.nlog;
80102ff2:	89 15 38 17 12 80    	mov    %edx,0x80121738
  log.start = sb.logstart;
80102ff8:	a3 34 17 12 80       	mov    %eax,0x80121734
  struct buf *buf = bread(log.dev, log.start);
80102ffd:	5a                   	pop    %edx
80102ffe:	50                   	push   %eax
80102fff:	53                   	push   %ebx
80103000:	e8 cb d0 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103005:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103008:	83 c4 10             	add    $0x10,%esp
8010300b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010300d:	89 1d 48 17 12 80    	mov    %ebx,0x80121748
  for (i = 0; i < log.lh.n; i++) {
80103013:	7e 1c                	jle    80103031 <initlog+0x71>
80103015:	c1 e3 02             	shl    $0x2,%ebx
80103018:	31 d2                	xor    %edx,%edx
8010301a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103020:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103024:	83 c2 04             	add    $0x4,%edx
80103027:	89 8a 48 17 12 80    	mov    %ecx,-0x7fede8b8(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010302d:	39 d3                	cmp    %edx,%ebx
8010302f:	75 ef                	jne    80103020 <initlog+0x60>
  brelse(buf);
80103031:	83 ec 0c             	sub    $0xc,%esp
80103034:	50                   	push   %eax
80103035:	e8 a6 d1 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010303a:	e8 81 fe ff ff       	call   80102ec0 <install_trans>
  log.lh.n = 0;
8010303f:	c7 05 48 17 12 80 00 	movl   $0x0,0x80121748
80103046:	00 00 00 
  write_head(); // clear the log
80103049:	e8 12 ff ff ff       	call   80102f60 <write_head>
}
8010304e:	83 c4 10             	add    $0x10,%esp
80103051:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103054:	c9                   	leave  
80103055:	c3                   	ret    
80103056:	8d 76 00             	lea    0x0(%esi),%esi
80103059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103060 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103066:	68 00 17 12 80       	push   $0x80121700
8010306b:	e8 f0 17 00 00       	call   80104860 <acquire>
80103070:	83 c4 10             	add    $0x10,%esp
80103073:	eb 18                	jmp    8010308d <begin_op+0x2d>
80103075:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103078:	83 ec 08             	sub    $0x8,%esp
8010307b:	68 00 17 12 80       	push   $0x80121700
80103080:	68 00 17 12 80       	push   $0x80121700
80103085:	e8 f6 11 00 00       	call   80104280 <sleep>
8010308a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010308d:	a1 40 17 12 80       	mov    0x80121740,%eax
80103092:	85 c0                	test   %eax,%eax
80103094:	75 e2                	jne    80103078 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103096:	a1 3c 17 12 80       	mov    0x8012173c,%eax
8010309b:	8b 15 48 17 12 80    	mov    0x80121748,%edx
801030a1:	83 c0 01             	add    $0x1,%eax
801030a4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801030a7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801030aa:	83 fa 1e             	cmp    $0x1e,%edx
801030ad:	7f c9                	jg     80103078 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801030af:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801030b2:	a3 3c 17 12 80       	mov    %eax,0x8012173c
      release(&log.lock);
801030b7:	68 00 17 12 80       	push   $0x80121700
801030bc:	e8 5f 18 00 00       	call   80104920 <release>
      break;
    }
  }
}
801030c1:	83 c4 10             	add    $0x10,%esp
801030c4:	c9                   	leave  
801030c5:	c3                   	ret    
801030c6:	8d 76 00             	lea    0x0(%esi),%esi
801030c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030d0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	57                   	push   %edi
801030d4:	56                   	push   %esi
801030d5:	53                   	push   %ebx
801030d6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801030d9:	68 00 17 12 80       	push   $0x80121700
801030de:	e8 7d 17 00 00       	call   80104860 <acquire>
  log.outstanding -= 1;
801030e3:	a1 3c 17 12 80       	mov    0x8012173c,%eax
  if(log.committing)
801030e8:	8b 35 40 17 12 80    	mov    0x80121740,%esi
801030ee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801030f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
801030f4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
801030f6:	89 1d 3c 17 12 80    	mov    %ebx,0x8012173c
  if(log.committing)
801030fc:	0f 85 1a 01 00 00    	jne    8010321c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103102:	85 db                	test   %ebx,%ebx
80103104:	0f 85 ee 00 00 00    	jne    801031f8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010310a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010310d:	c7 05 40 17 12 80 01 	movl   $0x1,0x80121740
80103114:	00 00 00 
  release(&log.lock);
80103117:	68 00 17 12 80       	push   $0x80121700
8010311c:	e8 ff 17 00 00       	call   80104920 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103121:	8b 0d 48 17 12 80    	mov    0x80121748,%ecx
80103127:	83 c4 10             	add    $0x10,%esp
8010312a:	85 c9                	test   %ecx,%ecx
8010312c:	0f 8e 85 00 00 00    	jle    801031b7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103132:	a1 34 17 12 80       	mov    0x80121734,%eax
80103137:	83 ec 08             	sub    $0x8,%esp
8010313a:	01 d8                	add    %ebx,%eax
8010313c:	83 c0 01             	add    $0x1,%eax
8010313f:	50                   	push   %eax
80103140:	ff 35 44 17 12 80    	pushl  0x80121744
80103146:	e8 85 cf ff ff       	call   801000d0 <bread>
8010314b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010314d:	58                   	pop    %eax
8010314e:	5a                   	pop    %edx
8010314f:	ff 34 9d 4c 17 12 80 	pushl  -0x7fede8b4(,%ebx,4)
80103156:	ff 35 44 17 12 80    	pushl  0x80121744
  for (tail = 0; tail < log.lh.n; tail++) {
8010315c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010315f:	e8 6c cf ff ff       	call   801000d0 <bread>
80103164:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103166:	8d 40 5c             	lea    0x5c(%eax),%eax
80103169:	83 c4 0c             	add    $0xc,%esp
8010316c:	68 00 02 00 00       	push   $0x200
80103171:	50                   	push   %eax
80103172:	8d 46 5c             	lea    0x5c(%esi),%eax
80103175:	50                   	push   %eax
80103176:	e8 a5 18 00 00       	call   80104a20 <memmove>
    bwrite(to);  // write the log
8010317b:	89 34 24             	mov    %esi,(%esp)
8010317e:	e8 1d d0 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103183:	89 3c 24             	mov    %edi,(%esp)
80103186:	e8 55 d0 ff ff       	call   801001e0 <brelse>
    brelse(to);
8010318b:	89 34 24             	mov    %esi,(%esp)
8010318e:	e8 4d d0 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103193:	83 c4 10             	add    $0x10,%esp
80103196:	3b 1d 48 17 12 80    	cmp    0x80121748,%ebx
8010319c:	7c 94                	jl     80103132 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010319e:	e8 bd fd ff ff       	call   80102f60 <write_head>
    install_trans(); // Now install writes to home locations
801031a3:	e8 18 fd ff ff       	call   80102ec0 <install_trans>
    log.lh.n = 0;
801031a8:	c7 05 48 17 12 80 00 	movl   $0x0,0x80121748
801031af:	00 00 00 
    write_head();    // Erase the transaction from the log
801031b2:	e8 a9 fd ff ff       	call   80102f60 <write_head>
    acquire(&log.lock);
801031b7:	83 ec 0c             	sub    $0xc,%esp
801031ba:	68 00 17 12 80       	push   $0x80121700
801031bf:	e8 9c 16 00 00       	call   80104860 <acquire>
    wakeup(&log);
801031c4:	c7 04 24 00 17 12 80 	movl   $0x80121700,(%esp)
    log.committing = 0;
801031cb:	c7 05 40 17 12 80 00 	movl   $0x0,0x80121740
801031d2:	00 00 00 
    wakeup(&log);
801031d5:	e8 66 12 00 00       	call   80104440 <wakeup>
    release(&log.lock);
801031da:	c7 04 24 00 17 12 80 	movl   $0x80121700,(%esp)
801031e1:	e8 3a 17 00 00       	call   80104920 <release>
801031e6:	83 c4 10             	add    $0x10,%esp
}
801031e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031ec:	5b                   	pop    %ebx
801031ed:	5e                   	pop    %esi
801031ee:	5f                   	pop    %edi
801031ef:	5d                   	pop    %ebp
801031f0:	c3                   	ret    
801031f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
801031f8:	83 ec 0c             	sub    $0xc,%esp
801031fb:	68 00 17 12 80       	push   $0x80121700
80103200:	e8 3b 12 00 00       	call   80104440 <wakeup>
  release(&log.lock);
80103205:	c7 04 24 00 17 12 80 	movl   $0x80121700,(%esp)
8010320c:	e8 0f 17 00 00       	call   80104920 <release>
80103211:	83 c4 10             	add    $0x10,%esp
}
80103214:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103217:	5b                   	pop    %ebx
80103218:	5e                   	pop    %esi
80103219:	5f                   	pop    %edi
8010321a:	5d                   	pop    %ebp
8010321b:	c3                   	ret    
    panic("log.committing");
8010321c:	83 ec 0c             	sub    $0xc,%esp
8010321f:	68 e4 7c 10 80       	push   $0x80107ce4
80103224:	e8 67 d1 ff ff       	call   80100390 <panic>
80103229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103230 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103230:	55                   	push   %ebp
80103231:	89 e5                	mov    %esp,%ebp
80103233:	53                   	push   %ebx
80103234:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103237:	8b 15 48 17 12 80    	mov    0x80121748,%edx
{
8010323d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103240:	83 fa 1d             	cmp    $0x1d,%edx
80103243:	0f 8f 9d 00 00 00    	jg     801032e6 <log_write+0xb6>
80103249:	a1 38 17 12 80       	mov    0x80121738,%eax
8010324e:	83 e8 01             	sub    $0x1,%eax
80103251:	39 c2                	cmp    %eax,%edx
80103253:	0f 8d 8d 00 00 00    	jge    801032e6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103259:	a1 3c 17 12 80       	mov    0x8012173c,%eax
8010325e:	85 c0                	test   %eax,%eax
80103260:	0f 8e 8d 00 00 00    	jle    801032f3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103266:	83 ec 0c             	sub    $0xc,%esp
80103269:	68 00 17 12 80       	push   $0x80121700
8010326e:	e8 ed 15 00 00       	call   80104860 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103273:	8b 0d 48 17 12 80    	mov    0x80121748,%ecx
80103279:	83 c4 10             	add    $0x10,%esp
8010327c:	83 f9 00             	cmp    $0x0,%ecx
8010327f:	7e 57                	jle    801032d8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103281:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103284:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103286:	3b 15 4c 17 12 80    	cmp    0x8012174c,%edx
8010328c:	75 0b                	jne    80103299 <log_write+0x69>
8010328e:	eb 38                	jmp    801032c8 <log_write+0x98>
80103290:	39 14 85 4c 17 12 80 	cmp    %edx,-0x7fede8b4(,%eax,4)
80103297:	74 2f                	je     801032c8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103299:	83 c0 01             	add    $0x1,%eax
8010329c:	39 c1                	cmp    %eax,%ecx
8010329e:	75 f0                	jne    80103290 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801032a0:	89 14 85 4c 17 12 80 	mov    %edx,-0x7fede8b4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801032a7:	83 c0 01             	add    $0x1,%eax
801032aa:	a3 48 17 12 80       	mov    %eax,0x80121748
  b->flags |= B_DIRTY; // prevent eviction
801032af:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801032b2:	c7 45 08 00 17 12 80 	movl   $0x80121700,0x8(%ebp)
}
801032b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032bc:	c9                   	leave  
  release(&log.lock);
801032bd:	e9 5e 16 00 00       	jmp    80104920 <release>
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801032c8:	89 14 85 4c 17 12 80 	mov    %edx,-0x7fede8b4(,%eax,4)
801032cf:	eb de                	jmp    801032af <log_write+0x7f>
801032d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032d8:	8b 43 08             	mov    0x8(%ebx),%eax
801032db:	a3 4c 17 12 80       	mov    %eax,0x8012174c
  if (i == log.lh.n)
801032e0:	75 cd                	jne    801032af <log_write+0x7f>
801032e2:	31 c0                	xor    %eax,%eax
801032e4:	eb c1                	jmp    801032a7 <log_write+0x77>
    panic("too big a transaction");
801032e6:	83 ec 0c             	sub    $0xc,%esp
801032e9:	68 f3 7c 10 80       	push   $0x80107cf3
801032ee:	e8 9d d0 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801032f3:	83 ec 0c             	sub    $0xc,%esp
801032f6:	68 09 7d 10 80       	push   $0x80107d09
801032fb:	e8 90 d0 ff ff       	call   80100390 <panic>

80103300 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	53                   	push   %ebx
80103304:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103307:	e8 84 09 00 00       	call   80103c90 <cpuid>
8010330c:	89 c3                	mov    %eax,%ebx
8010330e:	e8 7d 09 00 00       	call   80103c90 <cpuid>
80103313:	83 ec 04             	sub    $0x4,%esp
80103316:	53                   	push   %ebx
80103317:	50                   	push   %eax
80103318:	68 24 7d 10 80       	push   $0x80107d24
8010331d:	e8 3e d3 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103322:	e8 19 29 00 00       	call   80105c40 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103327:	e8 d4 08 00 00       	call   80103c00 <mycpu>
8010332c:	89 c2                	mov    %eax,%edx
  asm volatile("lock; xchgl %0, %1" :
8010332e:	b8 01 00 00 00       	mov    $0x1,%eax
80103333:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010333a:	e8 61 0c 00 00       	call   80103fa0 <scheduler>
8010333f:	90                   	nop

80103340 <mpenter>:
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103346:	e8 c5 3c 00 00       	call   80107010 <switchkvm>
  seginit();
8010334b:	e8 10 3c 00 00       	call   80106f60 <seginit>
  lapicinit();
80103350:	e8 9b f7 ff ff       	call   80102af0 <lapicinit>
  mpmain();
80103355:	e8 a6 ff ff ff       	call   80103300 <mpmain>
8010335a:	66 90                	xchg   %ax,%ax
8010335c:	66 90                	xchg   %ax,%ax
8010335e:	66 90                	xchg   %ax,%ax

80103360 <main>:
{
80103360:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103364:	83 e4 f0             	and    $0xfffffff0,%esp
80103367:	ff 71 fc             	pushl  -0x4(%ecx)
8010336a:	55                   	push   %ebp
8010336b:	89 e5                	mov    %esp,%ebp
8010336d:	53                   	push   %ebx
8010336e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010336f:	83 ec 08             	sub    $0x8,%esp
80103372:	68 00 00 40 80       	push   $0x80400000
80103377:	68 28 1a 13 80       	push   $0x80131a28
8010337c:	e8 0f f5 ff ff       	call   80102890 <kinit1>
  kvmalloc();      // kernel page table
80103381:	e8 5a 41 00 00       	call   801074e0 <kvmalloc>
  mpinit();        // detect other processors
80103386:	e8 75 01 00 00       	call   80103500 <mpinit>
  lapicinit();     // interrupt controller
8010338b:	e8 60 f7 ff ff       	call   80102af0 <lapicinit>
  init_cow();
80103390:	e8 bb f3 ff ff       	call   80102750 <init_cow>
  seginit();       // segment descriptors
80103395:	e8 c6 3b 00 00       	call   80106f60 <seginit>
  picinit();       // disable pic
8010339a:	e8 41 03 00 00       	call   801036e0 <picinit>
  ioapicinit();    // another interrupt controller
8010339f:	e8 bc f2 ff ff       	call   80102660 <ioapicinit>
  consoleinit();   // console hardware
801033a4:	e8 17 d6 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
801033a9:	e8 d2 2c 00 00       	call   80106080 <uartinit>
  pinit();         // process table
801033ae:	e8 2d 08 00 00       	call   80103be0 <pinit>
  tvinit();        // trap vectors
801033b3:	e8 08 28 00 00       	call   80105bc0 <tvinit>
  binit();         // buffer cache
801033b8:	e8 83 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
801033bd:	e8 4e da ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801033c2:	e8 79 f0 ff ff       	call   80102440 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801033c7:	83 c4 0c             	add    $0xc,%esp
801033ca:	68 8a 00 00 00       	push   $0x8a
801033cf:	68 8c b4 10 80       	push   $0x8010b48c
801033d4:	68 00 70 00 80       	push   $0x80007000
801033d9:	e8 42 16 00 00       	call   80104a20 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801033de:	69 05 80 1d 12 80 b0 	imul   $0xb0,0x80121d80,%eax
801033e5:	00 00 00 
801033e8:	83 c4 10             	add    $0x10,%esp
801033eb:	05 00 18 12 80       	add    $0x80121800,%eax
801033f0:	3d 00 18 12 80       	cmp    $0x80121800,%eax
801033f5:	76 6c                	jbe    80103463 <main+0x103>
801033f7:	bb 00 18 12 80       	mov    $0x80121800,%ebx
801033fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103400:	e8 fb 07 00 00       	call   80103c00 <mycpu>
80103405:	39 d8                	cmp    %ebx,%eax
80103407:	74 41                	je     8010344a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = cow_kalloc();
80103409:	e8 92 38 00 00       	call   80106ca0 <cow_kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010340e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103413:	c7 05 f8 6f 00 80 40 	movl   $0x80103340,0x80006ff8
8010341a:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010341d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103424:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103427:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010342c:	0f b6 03             	movzbl (%ebx),%eax
8010342f:	83 ec 08             	sub    $0x8,%esp
80103432:	68 00 70 00 00       	push   $0x7000
80103437:	50                   	push   %eax
80103438:	e8 03 f8 ff ff       	call   80102c40 <lapicstartap>
8010343d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103440:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103446:	85 c0                	test   %eax,%eax
80103448:	74 f6                	je     80103440 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010344a:	69 05 80 1d 12 80 b0 	imul   $0xb0,0x80121d80,%eax
80103451:	00 00 00 
80103454:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010345a:	05 00 18 12 80       	add    $0x80121800,%eax
8010345f:	39 c3                	cmp    %eax,%ebx
80103461:	72 9d                	jb     80103400 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103463:	83 ec 08             	sub    $0x8,%esp
80103466:	68 00 00 00 8e       	push   $0x8e000000
8010346b:	68 00 00 40 80       	push   $0x80400000
80103470:	e8 9b f4 ff ff       	call   80102910 <kinit2>
  userinit();      // first user process
80103475:	e8 66 08 00 00       	call   80103ce0 <userinit>
  mpmain();        // finish this processor's setup
8010347a:	e8 81 fe ff ff       	call   80103300 <mpmain>
8010347f:	90                   	nop

80103480 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103485:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010348b:	53                   	push   %ebx
  e = addr+len;
8010348c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010348f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103492:	39 de                	cmp    %ebx,%esi
80103494:	72 10                	jb     801034a6 <mpsearch1+0x26>
80103496:	eb 50                	jmp    801034e8 <mpsearch1+0x68>
80103498:	90                   	nop
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034a0:	39 fb                	cmp    %edi,%ebx
801034a2:	89 fe                	mov    %edi,%esi
801034a4:	76 42                	jbe    801034e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034a6:	83 ec 04             	sub    $0x4,%esp
801034a9:	8d 7e 10             	lea    0x10(%esi),%edi
801034ac:	6a 04                	push   $0x4
801034ae:	68 38 7d 10 80       	push   $0x80107d38
801034b3:	56                   	push   %esi
801034b4:	e8 07 15 00 00       	call   801049c0 <memcmp>
801034b9:	83 c4 10             	add    $0x10,%esp
801034bc:	85 c0                	test   %eax,%eax
801034be:	75 e0                	jne    801034a0 <mpsearch1+0x20>
801034c0:	89 f1                	mov    %esi,%ecx
801034c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801034c8:	0f b6 11             	movzbl (%ecx),%edx
801034cb:	83 c1 01             	add    $0x1,%ecx
801034ce:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801034d0:	39 f9                	cmp    %edi,%ecx
801034d2:	75 f4                	jne    801034c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034d4:	84 c0                	test   %al,%al
801034d6:	75 c8                	jne    801034a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801034d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034db:	89 f0                	mov    %esi,%eax
801034dd:	5b                   	pop    %ebx
801034de:	5e                   	pop    %esi
801034df:	5f                   	pop    %edi
801034e0:	5d                   	pop    %ebp
801034e1:	c3                   	ret    
801034e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034eb:	31 f6                	xor    %esi,%esi
}
801034ed:	89 f0                	mov    %esi,%eax
801034ef:	5b                   	pop    %ebx
801034f0:	5e                   	pop    %esi
801034f1:	5f                   	pop    %edi
801034f2:	5d                   	pop    %ebp
801034f3:	c3                   	ret    
801034f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103500 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103509:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103510:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103517:	c1 e0 08             	shl    $0x8,%eax
8010351a:	09 d0                	or     %edx,%eax
8010351c:	c1 e0 04             	shl    $0x4,%eax
8010351f:	85 c0                	test   %eax,%eax
80103521:	75 1b                	jne    8010353e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103523:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010352a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103531:	c1 e0 08             	shl    $0x8,%eax
80103534:	09 d0                	or     %edx,%eax
80103536:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103539:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010353e:	ba 00 04 00 00       	mov    $0x400,%edx
80103543:	e8 38 ff ff ff       	call   80103480 <mpsearch1>
80103548:	85 c0                	test   %eax,%eax
8010354a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010354d:	0f 84 3d 01 00 00    	je     80103690 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103556:	8b 58 04             	mov    0x4(%eax),%ebx
80103559:	85 db                	test   %ebx,%ebx
8010355b:	0f 84 4f 01 00 00    	je     801036b0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103561:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103567:	83 ec 04             	sub    $0x4,%esp
8010356a:	6a 04                	push   $0x4
8010356c:	68 55 7d 10 80       	push   $0x80107d55
80103571:	56                   	push   %esi
80103572:	e8 49 14 00 00       	call   801049c0 <memcmp>
80103577:	83 c4 10             	add    $0x10,%esp
8010357a:	85 c0                	test   %eax,%eax
8010357c:	0f 85 2e 01 00 00    	jne    801036b0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103582:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103589:	3c 01                	cmp    $0x1,%al
8010358b:	0f 95 c2             	setne  %dl
8010358e:	3c 04                	cmp    $0x4,%al
80103590:	0f 95 c0             	setne  %al
80103593:	20 c2                	and    %al,%dl
80103595:	0f 85 15 01 00 00    	jne    801036b0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010359b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801035a2:	66 85 ff             	test   %di,%di
801035a5:	74 1a                	je     801035c1 <mpinit+0xc1>
801035a7:	89 f0                	mov    %esi,%eax
801035a9:	01 f7                	add    %esi,%edi
  sum = 0;
801035ab:	31 d2                	xor    %edx,%edx
801035ad:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035b0:	0f b6 08             	movzbl (%eax),%ecx
801035b3:	83 c0 01             	add    $0x1,%eax
801035b6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801035b8:	39 c7                	cmp    %eax,%edi
801035ba:	75 f4                	jne    801035b0 <mpinit+0xb0>
801035bc:	84 d2                	test   %dl,%dl
801035be:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801035c1:	85 f6                	test   %esi,%esi
801035c3:	0f 84 e7 00 00 00    	je     801036b0 <mpinit+0x1b0>
801035c9:	84 d2                	test   %dl,%dl
801035cb:	0f 85 df 00 00 00    	jne    801036b0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801035d1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801035d7:	a3 f4 16 12 80       	mov    %eax,0x801216f4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035dc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801035e3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801035e9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035ee:	01 d6                	add    %edx,%esi
801035f0:	39 c6                	cmp    %eax,%esi
801035f2:	76 23                	jbe    80103617 <mpinit+0x117>
    switch(*p){
801035f4:	0f b6 10             	movzbl (%eax),%edx
801035f7:	80 fa 04             	cmp    $0x4,%dl
801035fa:	0f 87 ca 00 00 00    	ja     801036ca <mpinit+0x1ca>
80103600:	ff 24 95 7c 7d 10 80 	jmp    *-0x7fef8284(,%edx,4)
80103607:	89 f6                	mov    %esi,%esi
80103609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103610:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103613:	39 c6                	cmp    %eax,%esi
80103615:	77 dd                	ja     801035f4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103617:	85 db                	test   %ebx,%ebx
80103619:	0f 84 9e 00 00 00    	je     801036bd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010361f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103622:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103626:	74 15                	je     8010363d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103628:	b8 70 00 00 00       	mov    $0x70,%eax
8010362d:	ba 22 00 00 00       	mov    $0x22,%edx
80103632:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103633:	ba 23 00 00 00       	mov    $0x23,%edx
80103638:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103639:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010363c:	ee                   	out    %al,(%dx)
  }
}
8010363d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103640:	5b                   	pop    %ebx
80103641:	5e                   	pop    %esi
80103642:	5f                   	pop    %edi
80103643:	5d                   	pop    %ebp
80103644:	c3                   	ret    
80103645:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103648:	8b 0d 80 1d 12 80    	mov    0x80121d80,%ecx
8010364e:	83 f9 07             	cmp    $0x7,%ecx
80103651:	7f 19                	jg     8010366c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103653:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103657:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010365d:	83 c1 01             	add    $0x1,%ecx
80103660:	89 0d 80 1d 12 80    	mov    %ecx,0x80121d80
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103666:	88 97 00 18 12 80    	mov    %dl,-0x7fede800(%edi)
      p += sizeof(struct mpproc);
8010366c:	83 c0 14             	add    $0x14,%eax
      continue;
8010366f:	e9 7c ff ff ff       	jmp    801035f0 <mpinit+0xf0>
80103674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103678:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010367c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010367f:	88 15 e0 17 12 80    	mov    %dl,0x801217e0
      continue;
80103685:	e9 66 ff ff ff       	jmp    801035f0 <mpinit+0xf0>
8010368a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103690:	ba 00 00 01 00       	mov    $0x10000,%edx
80103695:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010369a:	e8 e1 fd ff ff       	call   80103480 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010369f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801036a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801036a4:	0f 85 a9 fe ff ff    	jne    80103553 <mpinit+0x53>
801036aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	68 3d 7d 10 80       	push   $0x80107d3d
801036b8:	e8 d3 cc ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801036bd:	83 ec 0c             	sub    $0xc,%esp
801036c0:	68 5c 7d 10 80       	push   $0x80107d5c
801036c5:	e8 c6 cc ff ff       	call   80100390 <panic>
      ismp = 0;
801036ca:	31 db                	xor    %ebx,%ebx
801036cc:	e9 26 ff ff ff       	jmp    801035f7 <mpinit+0xf7>
801036d1:	66 90                	xchg   %ax,%ax
801036d3:	66 90                	xchg   %ax,%ax
801036d5:	66 90                	xchg   %ax,%ax
801036d7:	66 90                	xchg   %ax,%ax
801036d9:	66 90                	xchg   %ax,%ax
801036db:	66 90                	xchg   %ax,%ax
801036dd:	66 90                	xchg   %ax,%ax
801036df:	90                   	nop

801036e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801036e0:	55                   	push   %ebp
801036e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036e6:	ba 21 00 00 00       	mov    $0x21,%edx
801036eb:	89 e5                	mov    %esp,%ebp
801036ed:	ee                   	out    %al,(%dx)
801036ee:	ba a1 00 00 00       	mov    $0xa1,%edx
801036f3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801036f4:	5d                   	pop    %ebp
801036f5:	c3                   	ret    
801036f6:	66 90                	xchg   %ax,%ax
801036f8:	66 90                	xchg   %ax,%ax
801036fa:	66 90                	xchg   %ax,%ax
801036fc:	66 90                	xchg   %ax,%ax
801036fe:	66 90                	xchg   %ax,%ax

80103700 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	57                   	push   %edi
80103704:	56                   	push   %esi
80103705:	53                   	push   %ebx
80103706:	83 ec 0c             	sub    $0xc,%esp
80103709:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010370c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010370f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103715:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010371b:	e8 10 d7 ff ff       	call   80100e30 <filealloc>
80103720:	85 c0                	test   %eax,%eax
80103722:	89 03                	mov    %eax,(%ebx)
80103724:	74 22                	je     80103748 <pipealloc+0x48>
80103726:	e8 05 d7 ff ff       	call   80100e30 <filealloc>
8010372b:	85 c0                	test   %eax,%eax
8010372d:	89 06                	mov    %eax,(%esi)
8010372f:	74 3f                	je     80103770 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)cow_kalloc()) == 0)
80103731:	e8 6a 35 00 00       	call   80106ca0 <cow_kalloc>
80103736:	85 c0                	test   %eax,%eax
80103738:	89 c7                	mov    %eax,%edi
8010373a:	75 54                	jne    80103790 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    cow_kfree((char*)p);
  if(*f0)
8010373c:	8b 03                	mov    (%ebx),%eax
8010373e:	85 c0                	test   %eax,%eax
80103740:	75 34                	jne    80103776 <pipealloc+0x76>
80103742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103748:	8b 06                	mov    (%esi),%eax
8010374a:	85 c0                	test   %eax,%eax
8010374c:	74 0c                	je     8010375a <pipealloc+0x5a>
    fileclose(*f1);
8010374e:	83 ec 0c             	sub    $0xc,%esp
80103751:	50                   	push   %eax
80103752:	e8 99 d7 ff ff       	call   80100ef0 <fileclose>
80103757:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010375a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010375d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103762:	5b                   	pop    %ebx
80103763:	5e                   	pop    %esi
80103764:	5f                   	pop    %edi
80103765:	5d                   	pop    %ebp
80103766:	c3                   	ret    
80103767:	89 f6                	mov    %esi,%esi
80103769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103770:	8b 03                	mov    (%ebx),%eax
80103772:	85 c0                	test   %eax,%eax
80103774:	74 e4                	je     8010375a <pipealloc+0x5a>
    fileclose(*f0);
80103776:	83 ec 0c             	sub    $0xc,%esp
80103779:	50                   	push   %eax
8010377a:	e8 71 d7 ff ff       	call   80100ef0 <fileclose>
  if(*f1)
8010377f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103781:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103784:	85 c0                	test   %eax,%eax
80103786:	75 c6                	jne    8010374e <pipealloc+0x4e>
80103788:	eb d0                	jmp    8010375a <pipealloc+0x5a>
8010378a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103790:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103793:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010379a:	00 00 00 
  p->writeopen = 1;
8010379d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801037a4:	00 00 00 
  p->nwrite = 0;
801037a7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801037ae:	00 00 00 
  p->nread = 0;
801037b1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801037b8:	00 00 00 
  initlock(&p->lock, "pipe");
801037bb:	68 90 7d 10 80       	push   $0x80107d90
801037c0:	50                   	push   %eax
801037c1:	e8 5a 0f 00 00       	call   80104720 <initlock>
  (*f0)->type = FD_PIPE;
801037c6:	8b 03                	mov    (%ebx),%eax
  return 0;
801037c8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801037cb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801037d1:	8b 03                	mov    (%ebx),%eax
801037d3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801037d7:	8b 03                	mov    (%ebx),%eax
801037d9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801037dd:	8b 03                	mov    (%ebx),%eax
801037df:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801037e2:	8b 06                	mov    (%esi),%eax
801037e4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801037ea:	8b 06                	mov    (%esi),%eax
801037ec:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801037f0:	8b 06                	mov    (%esi),%eax
801037f2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801037f6:	8b 06                	mov    (%esi),%eax
801037f8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801037fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801037fe:	31 c0                	xor    %eax,%eax
}
80103800:	5b                   	pop    %ebx
80103801:	5e                   	pop    %esi
80103802:	5f                   	pop    %edi
80103803:	5d                   	pop    %ebp
80103804:	c3                   	ret    
80103805:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103810 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	56                   	push   %esi
80103814:	53                   	push   %ebx
80103815:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103818:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010381b:	83 ec 0c             	sub    $0xc,%esp
8010381e:	53                   	push   %ebx
8010381f:	e8 3c 10 00 00       	call   80104860 <acquire>
  if(writable){
80103824:	83 c4 10             	add    $0x10,%esp
80103827:	85 f6                	test   %esi,%esi
80103829:	74 45                	je     80103870 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010382b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103831:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103834:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010383b:	00 00 00 
    wakeup(&p->nread);
8010383e:	50                   	push   %eax
8010383f:	e8 fc 0b 00 00       	call   80104440 <wakeup>
80103844:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103847:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010384d:	85 d2                	test   %edx,%edx
8010384f:	75 0a                	jne    8010385b <pipeclose+0x4b>
80103851:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103857:	85 c0                	test   %eax,%eax
80103859:	74 35                	je     80103890 <pipeclose+0x80>
    release(&p->lock);
    cow_kfree((char*)p);
  } else
    release(&p->lock);
8010385b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010385e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103861:	5b                   	pop    %ebx
80103862:	5e                   	pop    %esi
80103863:	5d                   	pop    %ebp
    release(&p->lock);
80103864:	e9 b7 10 00 00       	jmp    80104920 <release>
80103869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103870:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103876:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103879:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103880:	00 00 00 
    wakeup(&p->nwrite);
80103883:	50                   	push   %eax
80103884:	e8 b7 0b 00 00       	call   80104440 <wakeup>
80103889:	83 c4 10             	add    $0x10,%esp
8010388c:	eb b9                	jmp    80103847 <pipeclose+0x37>
8010388e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103890:	83 ec 0c             	sub    $0xc,%esp
80103893:	53                   	push   %ebx
80103894:	e8 87 10 00 00       	call   80104920 <release>
    cow_kfree((char*)p);
80103899:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010389c:	83 c4 10             	add    $0x10,%esp
}
8010389f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038a2:	5b                   	pop    %ebx
801038a3:	5e                   	pop    %esi
801038a4:	5d                   	pop    %ebp
    cow_kfree((char*)p);
801038a5:	e9 56 33 00 00       	jmp    80106c00 <cow_kfree>
801038aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	57                   	push   %edi
801038b4:	56                   	push   %esi
801038b5:	53                   	push   %ebx
801038b6:	83 ec 28             	sub    $0x28,%esp
801038b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801038bc:	53                   	push   %ebx
801038bd:	e8 9e 0f 00 00       	call   80104860 <acquire>
  for(i = 0; i < n; i++){
801038c2:	8b 45 10             	mov    0x10(%ebp),%eax
801038c5:	83 c4 10             	add    $0x10,%esp
801038c8:	85 c0                	test   %eax,%eax
801038ca:	0f 8e c9 00 00 00    	jle    80103999 <pipewrite+0xe9>
801038d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801038d3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801038d9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801038df:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801038e2:	03 4d 10             	add    0x10(%ebp),%ecx
801038e5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038e8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801038ee:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801038f4:	39 d0                	cmp    %edx,%eax
801038f6:	75 71                	jne    80103969 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801038f8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801038fe:	85 c0                	test   %eax,%eax
80103900:	74 4e                	je     80103950 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103902:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103908:	eb 3a                	jmp    80103944 <pipewrite+0x94>
8010390a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103910:	83 ec 0c             	sub    $0xc,%esp
80103913:	57                   	push   %edi
80103914:	e8 27 0b 00 00       	call   80104440 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103919:	5a                   	pop    %edx
8010391a:	59                   	pop    %ecx
8010391b:	53                   	push   %ebx
8010391c:	56                   	push   %esi
8010391d:	e8 5e 09 00 00       	call   80104280 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103922:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103928:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010392e:	83 c4 10             	add    $0x10,%esp
80103931:	05 00 02 00 00       	add    $0x200,%eax
80103936:	39 c2                	cmp    %eax,%edx
80103938:	75 36                	jne    80103970 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010393a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103940:	85 c0                	test   %eax,%eax
80103942:	74 0c                	je     80103950 <pipewrite+0xa0>
80103944:	e8 67 03 00 00       	call   80103cb0 <myproc>
80103949:	8b 40 24             	mov    0x24(%eax),%eax
8010394c:	85 c0                	test   %eax,%eax
8010394e:	74 c0                	je     80103910 <pipewrite+0x60>
        release(&p->lock);
80103950:	83 ec 0c             	sub    $0xc,%esp
80103953:	53                   	push   %ebx
80103954:	e8 c7 0f 00 00       	call   80104920 <release>
        return -1;
80103959:	83 c4 10             	add    $0x10,%esp
8010395c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103961:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103964:	5b                   	pop    %ebx
80103965:	5e                   	pop    %esi
80103966:	5f                   	pop    %edi
80103967:	5d                   	pop    %ebp
80103968:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103969:	89 c2                	mov    %eax,%edx
8010396b:	90                   	nop
8010396c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103970:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103973:	8d 42 01             	lea    0x1(%edx),%eax
80103976:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010397c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103982:	83 c6 01             	add    $0x1,%esi
80103985:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103989:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010398c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010398f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103993:	0f 85 4f ff ff ff    	jne    801038e8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103999:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010399f:	83 ec 0c             	sub    $0xc,%esp
801039a2:	50                   	push   %eax
801039a3:	e8 98 0a 00 00       	call   80104440 <wakeup>
  release(&p->lock);
801039a8:	89 1c 24             	mov    %ebx,(%esp)
801039ab:	e8 70 0f 00 00       	call   80104920 <release>
  return n;
801039b0:	83 c4 10             	add    $0x10,%esp
801039b3:	8b 45 10             	mov    0x10(%ebp),%eax
801039b6:	eb a9                	jmp    80103961 <pipewrite+0xb1>
801039b8:	90                   	nop
801039b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	57                   	push   %edi
801039c4:	56                   	push   %esi
801039c5:	53                   	push   %ebx
801039c6:	83 ec 18             	sub    $0x18,%esp
801039c9:	8b 75 08             	mov    0x8(%ebp),%esi
801039cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801039cf:	56                   	push   %esi
801039d0:	e8 8b 0e 00 00       	call   80104860 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801039d5:	83 c4 10             	add    $0x10,%esp
801039d8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801039de:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801039e4:	75 6a                	jne    80103a50 <piperead+0x90>
801039e6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801039ec:	85 db                	test   %ebx,%ebx
801039ee:	0f 84 c4 00 00 00    	je     80103ab8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801039f4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801039fa:	eb 2d                	jmp    80103a29 <piperead+0x69>
801039fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a00:	83 ec 08             	sub    $0x8,%esp
80103a03:	56                   	push   %esi
80103a04:	53                   	push   %ebx
80103a05:	e8 76 08 00 00       	call   80104280 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103a0a:	83 c4 10             	add    $0x10,%esp
80103a0d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a13:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a19:	75 35                	jne    80103a50 <piperead+0x90>
80103a1b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103a21:	85 d2                	test   %edx,%edx
80103a23:	0f 84 8f 00 00 00    	je     80103ab8 <piperead+0xf8>
    if(myproc()->killed){
80103a29:	e8 82 02 00 00       	call   80103cb0 <myproc>
80103a2e:	8b 48 24             	mov    0x24(%eax),%ecx
80103a31:	85 c9                	test   %ecx,%ecx
80103a33:	74 cb                	je     80103a00 <piperead+0x40>
      release(&p->lock);
80103a35:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103a38:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103a3d:	56                   	push   %esi
80103a3e:	e8 dd 0e 00 00       	call   80104920 <release>
      return -1;
80103a43:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103a46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a49:	89 d8                	mov    %ebx,%eax
80103a4b:	5b                   	pop    %ebx
80103a4c:	5e                   	pop    %esi
80103a4d:	5f                   	pop    %edi
80103a4e:	5d                   	pop    %ebp
80103a4f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a50:	8b 45 10             	mov    0x10(%ebp),%eax
80103a53:	85 c0                	test   %eax,%eax
80103a55:	7e 61                	jle    80103ab8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103a57:	31 db                	xor    %ebx,%ebx
80103a59:	eb 13                	jmp    80103a6e <piperead+0xae>
80103a5b:	90                   	nop
80103a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a60:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a66:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a6c:	74 1f                	je     80103a8d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103a6e:	8d 41 01             	lea    0x1(%ecx),%eax
80103a71:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103a77:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103a7d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103a82:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a85:	83 c3 01             	add    $0x1,%ebx
80103a88:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103a8b:	75 d3                	jne    80103a60 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103a8d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103a93:	83 ec 0c             	sub    $0xc,%esp
80103a96:	50                   	push   %eax
80103a97:	e8 a4 09 00 00       	call   80104440 <wakeup>
  release(&p->lock);
80103a9c:	89 34 24             	mov    %esi,(%esp)
80103a9f:	e8 7c 0e 00 00       	call   80104920 <release>
  return i;
80103aa4:	83 c4 10             	add    $0x10,%esp
}
80103aa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103aaa:	89 d8                	mov    %ebx,%eax
80103aac:	5b                   	pop    %ebx
80103aad:	5e                   	pop    %esi
80103aae:	5f                   	pop    %edi
80103aaf:	5d                   	pop    %ebp
80103ab0:	c3                   	ret    
80103ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ab8:	31 db                	xor    %ebx,%ebx
80103aba:	eb d1                	jmp    80103a8d <piperead+0xcd>
80103abc:	66 90                	xchg   %ax,%ax
80103abe:	66 90                	xchg   %ax,%ax

80103ac0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ac4:	bb d4 1d 12 80       	mov    $0x80121dd4,%ebx
{
80103ac9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103acc:	68 a0 1d 12 80       	push   $0x80121da0
80103ad1:	e8 8a 0d 00 00       	call   80104860 <acquire>
80103ad6:	83 c4 10             	add    $0x10,%esp
80103ad9:	eb 13                	jmp    80103aee <allocproc+0x2e>
80103adb:	90                   	nop
80103adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ae0:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
80103ae6:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
80103aec:	73 7a                	jae    80103b68 <allocproc+0xa8>
    if(p->state == UNUSED)
80103aee:	8b 43 0c             	mov    0xc(%ebx),%eax
80103af1:	85 c0                	test   %eax,%eax
80103af3:	75 eb                	jne    80103ae0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103af5:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103afa:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103afd:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103b04:	8d 50 01             	lea    0x1(%eax),%edx
80103b07:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103b0a:	68 a0 1d 12 80       	push   $0x80121da0
  p->pid = nextpid++;
80103b0f:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103b15:	e8 06 0e 00 00       	call   80104920 <release>

  // Allocate kernel stack.
  if((p->kstack = cow_kalloc()) == 0){
80103b1a:	e8 81 31 00 00       	call   80106ca0 <cow_kalloc>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	89 43 08             	mov    %eax,0x8(%ebx)
80103b27:	74 58                	je     80103b81 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b29:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103b2f:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103b32:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103b37:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103b3a:	c7 40 14 b1 5b 10 80 	movl   $0x80105bb1,0x14(%eax)
  p->context = (struct context*)sp;
80103b41:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103b44:	6a 14                	push   $0x14
80103b46:	6a 00                	push   $0x0
80103b48:	50                   	push   %eax
80103b49:	e8 22 0e 00 00       	call   80104970 <memset>
  p->context->eip = (uint)forkret;
80103b4e:	8b 43 1c             	mov    0x1c(%ebx),%eax
      p->advance_queue[i] = -1;
      #endif
    }
 }
 #endif
  return p;
80103b51:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b54:	c7 40 10 90 3b 10 80 	movl   $0x80103b90,0x10(%eax)
}
80103b5b:	89 d8                	mov    %ebx,%eax
80103b5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b60:	c9                   	leave  
80103b61:	c3                   	ret    
80103b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103b68:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103b6b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103b6d:	68 a0 1d 12 80       	push   $0x80121da0
80103b72:	e8 a9 0d 00 00       	call   80104920 <release>
}
80103b77:	89 d8                	mov    %ebx,%eax
  return 0;
80103b79:	83 c4 10             	add    $0x10,%esp
}
80103b7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b7f:	c9                   	leave  
80103b80:	c3                   	ret    
    p->state = UNUSED;
80103b81:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103b88:	31 db                	xor    %ebx,%ebx
80103b8a:	eb cf                	jmp    80103b5b <allocproc+0x9b>
80103b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b90 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103b96:	68 a0 1d 12 80       	push   $0x80121da0
80103b9b:	e8 80 0d 00 00       	call   80104920 <release>

  if (first) {
80103ba0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103ba5:	83 c4 10             	add    $0x10,%esp
80103ba8:	85 c0                	test   %eax,%eax
80103baa:	75 04                	jne    80103bb0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103bac:	c9                   	leave  
80103bad:	c3                   	ret    
80103bae:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103bb0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103bb3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103bba:	00 00 00 
    iinit(ROOTDEV);
80103bbd:	6a 01                	push   $0x1
80103bbf:	e8 6c d9 ff ff       	call   80101530 <iinit>
    initlog(ROOTDEV);
80103bc4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103bcb:	e8 f0 f3 ff ff       	call   80102fc0 <initlog>
80103bd0:	83 c4 10             	add    $0x10,%esp
}
80103bd3:	c9                   	leave  
80103bd4:	c3                   	ret    
80103bd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103be0 <pinit>:
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103be6:	68 95 7d 10 80       	push   $0x80107d95
80103beb:	68 a0 1d 12 80       	push   $0x80121da0
80103bf0:	e8 2b 0b 00 00       	call   80104720 <initlock>
}
80103bf5:	83 c4 10             	add    $0x10,%esp
80103bf8:	c9                   	leave  
80103bf9:	c3                   	ret    
80103bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c00 <mycpu>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	56                   	push   %esi
80103c04:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c05:	9c                   	pushf  
80103c06:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c07:	f6 c4 02             	test   $0x2,%ah
80103c0a:	75 6b                	jne    80103c77 <mycpu+0x77>
  apicid = lapicid();
80103c0c:	e8 df ef ff ff       	call   80102bf0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103c11:	8b 35 80 1d 12 80    	mov    0x80121d80,%esi
80103c17:	85 f6                	test   %esi,%esi
80103c19:	7e 42                	jle    80103c5d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103c1b:	0f b6 15 00 18 12 80 	movzbl 0x80121800,%edx
80103c22:	39 d0                	cmp    %edx,%eax
80103c24:	74 30                	je     80103c56 <mycpu+0x56>
80103c26:	b9 b0 18 12 80       	mov    $0x801218b0,%ecx
  for (i = 0; i < ncpu; ++i) {
80103c2b:	31 d2                	xor    %edx,%edx
80103c2d:	8d 76 00             	lea    0x0(%esi),%esi
80103c30:	83 c2 01             	add    $0x1,%edx
80103c33:	39 f2                	cmp    %esi,%edx
80103c35:	74 26                	je     80103c5d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103c37:	0f b6 19             	movzbl (%ecx),%ebx
80103c3a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103c40:	39 c3                	cmp    %eax,%ebx
80103c42:	75 ec                	jne    80103c30 <mycpu+0x30>
80103c44:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103c4a:	05 00 18 12 80       	add    $0x80121800,%eax
}
80103c4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c52:	5b                   	pop    %ebx
80103c53:	5e                   	pop    %esi
80103c54:	5d                   	pop    %ebp
80103c55:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103c56:	b8 00 18 12 80       	mov    $0x80121800,%eax
      return &cpus[i];
80103c5b:	eb f2                	jmp    80103c4f <mycpu+0x4f>
  cprintf("The unknown apicid is %d\n", apicid);
80103c5d:	83 ec 08             	sub    $0x8,%esp
80103c60:	50                   	push   %eax
80103c61:	68 9c 7d 10 80       	push   $0x80107d9c
80103c66:	e8 f5 c9 ff ff       	call   80100660 <cprintf>
  panic("unknown apicid\n");
80103c6b:	c7 04 24 b6 7d 10 80 	movl   $0x80107db6,(%esp)
80103c72:	e8 19 c7 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103c77:	83 ec 0c             	sub    $0xc,%esp
80103c7a:	68 94 7e 10 80       	push   $0x80107e94
80103c7f:	e8 0c c7 ff ff       	call   80100390 <panic>
80103c84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c90 <cpuid>:
cpuid() {
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c96:	e8 65 ff ff ff       	call   80103c00 <mycpu>
80103c9b:	2d 00 18 12 80       	sub    $0x80121800,%eax
}
80103ca0:	c9                   	leave  
  return mycpu()-cpus;
80103ca1:	c1 f8 04             	sar    $0x4,%eax
80103ca4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103caa:	c3                   	ret    
80103cab:	90                   	nop
80103cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103cb0 <myproc>:
myproc(void) {
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	53                   	push   %ebx
80103cb4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103cb7:	e8 d4 0a 00 00       	call   80104790 <pushcli>
  c = mycpu();
80103cbc:	e8 3f ff ff ff       	call   80103c00 <mycpu>
  p = c->proc;
80103cc1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cc7:	e8 04 0b 00 00       	call   801047d0 <popcli>
}
80103ccc:	83 c4 04             	add    $0x4,%esp
80103ccf:	89 d8                	mov    %ebx,%eax
80103cd1:	5b                   	pop    %ebx
80103cd2:	5d                   	pop    %ebp
80103cd3:	c3                   	ret    
80103cd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103cda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ce0 <userinit>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	53                   	push   %ebx
80103ce4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ce7:	e8 d4 fd ff ff       	call   80103ac0 <allocproc>
80103cec:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103cee:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103cf3:	e8 68 37 00 00       	call   80107460 <setupkvm>
80103cf8:	85 c0                	test   %eax,%eax
80103cfa:	89 43 04             	mov    %eax,0x4(%ebx)
80103cfd:	0f 84 bd 00 00 00    	je     80103dc0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d03:	83 ec 04             	sub    $0x4,%esp
80103d06:	68 2c 00 00 00       	push   $0x2c
80103d0b:	68 60 b4 10 80       	push   $0x8010b460
80103d10:	50                   	push   %eax
80103d11:	e8 2a 34 00 00       	call   80107140 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103d16:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103d19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103d1f:	6a 4c                	push   $0x4c
80103d21:	6a 00                	push   $0x0
80103d23:	ff 73 18             	pushl  0x18(%ebx)
80103d26:	e8 45 0c 00 00       	call   80104970 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d2b:	8b 43 18             	mov    0x18(%ebx),%eax
80103d2e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d33:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d38:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d3b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d3f:	8b 43 18             	mov    0x18(%ebx),%eax
80103d42:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103d46:	8b 43 18             	mov    0x18(%ebx),%eax
80103d49:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d4d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d51:	8b 43 18             	mov    0x18(%ebx),%eax
80103d54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d58:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d5c:	8b 43 18             	mov    0x18(%ebx),%eax
80103d5f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d66:	8b 43 18             	mov    0x18(%ebx),%eax
80103d69:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d70:	8b 43 18             	mov    0x18(%ebx),%eax
80103d73:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d7a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d7d:	6a 10                	push   $0x10
80103d7f:	68 df 7d 10 80       	push   $0x80107ddf
80103d84:	50                   	push   %eax
80103d85:	e8 c6 0d 00 00       	call   80104b50 <safestrcpy>
  p->cwd = namei("/");
80103d8a:	c7 04 24 e8 7d 10 80 	movl   $0x80107de8,(%esp)
80103d91:	e8 fa e1 ff ff       	call   80101f90 <namei>
80103d96:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103d99:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
80103da0:	e8 bb 0a 00 00       	call   80104860 <acquire>
  p->state = RUNNABLE;
80103da5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103dac:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
80103db3:	e8 68 0b 00 00       	call   80104920 <release>
}
80103db8:	83 c4 10             	add    $0x10,%esp
80103dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dbe:	c9                   	leave  
80103dbf:	c3                   	ret    
    panic("userinit: out of memory?");
80103dc0:	83 ec 0c             	sub    $0xc,%esp
80103dc3:	68 c6 7d 10 80       	push   $0x80107dc6
80103dc8:	e8 c3 c5 ff ff       	call   80100390 <panic>
80103dcd:	8d 76 00             	lea    0x0(%esi),%esi

80103dd0 <growproc>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	56                   	push   %esi
80103dd4:	53                   	push   %ebx
80103dd5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103dd8:	e8 b3 09 00 00       	call   80104790 <pushcli>
  c = mycpu();
80103ddd:	e8 1e fe ff ff       	call   80103c00 <mycpu>
  p = c->proc;
80103de2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103de8:	e8 e3 09 00 00       	call   801047d0 <popcli>
  if(n > 0){
80103ded:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103df0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103df2:	7f 1c                	jg     80103e10 <growproc+0x40>
  } else if(n < 0){
80103df4:	75 3a                	jne    80103e30 <growproc+0x60>
  switchuvm(curproc);
80103df6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103df9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103dfb:	53                   	push   %ebx
80103dfc:	e8 2f 32 00 00       	call   80107030 <switchuvm>
  return 0;
80103e01:	83 c4 10             	add    $0x10,%esp
80103e04:	31 c0                	xor    %eax,%eax
}
80103e06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e09:	5b                   	pop    %ebx
80103e0a:	5e                   	pop    %esi
80103e0b:	5d                   	pop    %ebp
80103e0c:	c3                   	ret    
80103e0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e10:	83 ec 04             	sub    $0x4,%esp
80103e13:	01 c6                	add    %eax,%esi
80103e15:	56                   	push   %esi
80103e16:	50                   	push   %eax
80103e17:	ff 73 04             	pushl  0x4(%ebx)
80103e1a:	e8 61 34 00 00       	call   80107280 <allocuvm>
80103e1f:	83 c4 10             	add    $0x10,%esp
80103e22:	85 c0                	test   %eax,%eax
80103e24:	75 d0                	jne    80103df6 <growproc+0x26>
      return -1;
80103e26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e2b:	eb d9                	jmp    80103e06 <growproc+0x36>
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e30:	83 ec 04             	sub    $0x4,%esp
80103e33:	01 c6                	add    %eax,%esi
80103e35:	56                   	push   %esi
80103e36:	50                   	push   %eax
80103e37:	ff 73 04             	pushl  0x4(%ebx)
80103e3a:	e8 71 35 00 00       	call   801073b0 <deallocuvm>
80103e3f:	83 c4 10             	add    $0x10,%esp
80103e42:	85 c0                	test   %eax,%eax
80103e44:	75 b0                	jne    80103df6 <growproc+0x26>
80103e46:	eb de                	jmp    80103e26 <growproc+0x56>
80103e48:	90                   	nop
80103e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e50 <sys_get_number_of_free_pages_impl>:
int sys_get_number_of_free_pages_impl(void){
80103e50:	55                   	push   %ebp
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80103e51:	31 c0                	xor    %eax,%eax
  int count = 0;
80103e53:	31 d2                	xor    %edx,%edx
int sys_get_number_of_free_pages_impl(void){
80103e55:	89 e5                	mov    %esp,%ebp
80103e57:	89 f6                	mov    %esi,%esi
80103e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      count++;
80103e60:	80 b8 40 0f 11 80 01 	cmpb   $0x1,-0x7feef0c0(%eax)
80103e67:	83 da ff             	sbb    $0xffffffff,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80103e6a:	83 c0 01             	add    $0x1,%eax
80103e6d:	3d 00 e0 00 00       	cmp    $0xe000,%eax
80103e72:	75 ec                	jne    80103e60 <sys_get_number_of_free_pages_impl+0x10>
  return (PHYSTOP/PGSIZE) - count;
80103e74:	29 d0                	sub    %edx,%eax
}
80103e76:	5d                   	pop    %ebp
80103e77:	c3                   	ret    
80103e78:	90                   	nop
80103e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e80 <fork>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	57                   	push   %edi
80103e84:	56                   	push   %esi
80103e85:	53                   	push   %ebx
80103e86:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103e89:	e8 02 09 00 00       	call   80104790 <pushcli>
  c = mycpu();
80103e8e:	e8 6d fd ff ff       	call   80103c00 <mycpu>
  p = c->proc;
80103e93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e99:	e8 32 09 00 00       	call   801047d0 <popcli>
  if((np = allocproc()) == 0){
80103e9e:	e8 1d fc ff ff       	call   80103ac0 <allocproc>
80103ea3:	85 c0                	test   %eax,%eax
80103ea5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ea8:	0f 84 b7 00 00 00    	je     80103f65 <fork+0xe5>
  if((np->pgdir = cow_copyuvm(curproc->pgdir, curproc->sz)) == 0){ // (np->pid > 2 ? cow_copyuvm : copyuvm)
80103eae:	83 ec 08             	sub    $0x8,%esp
80103eb1:	ff 33                	pushl  (%ebx)
80103eb3:	ff 73 04             	pushl  0x4(%ebx)
80103eb6:	89 c7                	mov    %eax,%edi
80103eb8:	e8 73 36 00 00       	call   80107530 <cow_copyuvm>
80103ebd:	83 c4 10             	add    $0x10,%esp
80103ec0:	85 c0                	test   %eax,%eax
80103ec2:	89 47 04             	mov    %eax,0x4(%edi)
80103ec5:	0f 84 a1 00 00 00    	je     80103f6c <fork+0xec>
  np->sz = curproc->sz;
80103ecb:	8b 03                	mov    (%ebx),%eax
80103ecd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ed0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103ed2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103ed5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103ed7:	8b 79 18             	mov    0x18(%ecx),%edi
80103eda:	8b 73 18             	mov    0x18(%ebx),%esi
80103edd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103ee2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ee4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ee6:	8b 40 18             	mov    0x18(%eax),%eax
80103ee9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ef0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ef4:	85 c0                	test   %eax,%eax
80103ef6:	74 13                	je     80103f0b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ef8:	83 ec 0c             	sub    $0xc,%esp
80103efb:	50                   	push   %eax
80103efc:	e8 9f cf ff ff       	call   80100ea0 <filedup>
80103f01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f04:	83 c4 10             	add    $0x10,%esp
80103f07:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103f0b:	83 c6 01             	add    $0x1,%esi
80103f0e:	83 fe 10             	cmp    $0x10,%esi
80103f11:	75 dd                	jne    80103ef0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103f13:	83 ec 0c             	sub    $0xc,%esp
80103f16:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f19:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103f1c:	e8 df d7 ff ff       	call   80101700 <idup>
80103f21:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f24:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103f27:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f2a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f2d:	6a 10                	push   $0x10
80103f2f:	53                   	push   %ebx
80103f30:	50                   	push   %eax
80103f31:	e8 1a 0c 00 00       	call   80104b50 <safestrcpy>
  pid = np->pid;
80103f36:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103f39:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
80103f40:	e8 1b 09 00 00       	call   80104860 <acquire>
  np->state = RUNNABLE;
80103f45:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103f4c:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
80103f53:	e8 c8 09 00 00       	call   80104920 <release>
  return pid;
80103f58:	83 c4 10             	add    $0x10,%esp
}
80103f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f5e:	89 d8                	mov    %ebx,%eax
80103f60:	5b                   	pop    %ebx
80103f61:	5e                   	pop    %esi
80103f62:	5f                   	pop    %edi
80103f63:	5d                   	pop    %ebp
80103f64:	c3                   	ret    
    return -1;
80103f65:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f6a:	eb ef                	jmp    80103f5b <fork+0xdb>
    cow_kfree(np->kstack);
80103f6c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103f6f:	83 ec 0c             	sub    $0xc,%esp
80103f72:	ff 73 08             	pushl  0x8(%ebx)
80103f75:	e8 86 2c 00 00       	call   80106c00 <cow_kfree>
    np->kstack = 0;
80103f7a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103f81:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103f88:	83 c4 10             	add    $0x10,%esp
80103f8b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f90:	eb c9                	jmp    80103f5b <fork+0xdb>
80103f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fa0 <scheduler>:
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	57                   	push   %edi
80103fa4:	56                   	push   %esi
80103fa5:	53                   	push   %ebx
80103fa6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103fa9:	e8 52 fc ff ff       	call   80103c00 <mycpu>
80103fae:	8d 78 04             	lea    0x4(%eax),%edi
80103fb1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103fb3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103fba:	00 00 00 
80103fbd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103fc0:	fb                   	sti    
    acquire(&ptable.lock);
80103fc1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fc4:	bb d4 1d 12 80       	mov    $0x80121dd4,%ebx
    acquire(&ptable.lock);
80103fc9:	68 a0 1d 12 80       	push   $0x80121da0
80103fce:	e8 8d 08 00 00       	call   80104860 <acquire>
80103fd3:	83 c4 10             	add    $0x10,%esp
80103fd6:	8d 76 00             	lea    0x0(%esi),%esi
80103fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103fe0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103fe4:	75 33                	jne    80104019 <scheduler+0x79>
      switchuvm(p);
80103fe6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103fe9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103fef:	53                   	push   %ebx
80103ff0:	e8 3b 30 00 00       	call   80107030 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ff5:	58                   	pop    %eax
80103ff6:	5a                   	pop    %edx
80103ff7:	ff 73 1c             	pushl  0x1c(%ebx)
80103ffa:	57                   	push   %edi
      p->state = RUNNING;
80103ffb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104002:	e8 a4 0b 00 00       	call   80104bab <swtch>
      switchkvm();
80104007:	e8 04 30 00 00       	call   80107010 <switchkvm>
      c->proc = 0;
8010400c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104013:	00 00 00 
80104016:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104019:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
8010401f:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
80104025:	72 b9                	jb     80103fe0 <scheduler+0x40>
    release(&ptable.lock);
80104027:	83 ec 0c             	sub    $0xc,%esp
8010402a:	68 a0 1d 12 80       	push   $0x80121da0
8010402f:	e8 ec 08 00 00       	call   80104920 <release>
    sti();
80104034:	83 c4 10             	add    $0x10,%esp
80104037:	eb 87                	jmp    80103fc0 <scheduler+0x20>
80104039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104040 <sched>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	56                   	push   %esi
80104044:	53                   	push   %ebx
  pushcli();
80104045:	e8 46 07 00 00       	call   80104790 <pushcli>
  c = mycpu();
8010404a:	e8 b1 fb ff ff       	call   80103c00 <mycpu>
  p = c->proc;
8010404f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104055:	e8 76 07 00 00       	call   801047d0 <popcli>
  if(!holding(&ptable.lock))
8010405a:	83 ec 0c             	sub    $0xc,%esp
8010405d:	68 a0 1d 12 80       	push   $0x80121da0
80104062:	e8 c9 07 00 00       	call   80104830 <holding>
80104067:	83 c4 10             	add    $0x10,%esp
8010406a:	85 c0                	test   %eax,%eax
8010406c:	74 4f                	je     801040bd <sched+0x7d>
  if(mycpu()->ncli != 1)
8010406e:	e8 8d fb ff ff       	call   80103c00 <mycpu>
80104073:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010407a:	75 68                	jne    801040e4 <sched+0xa4>
  if(p->state == RUNNING)
8010407c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104080:	74 55                	je     801040d7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104082:	9c                   	pushf  
80104083:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104084:	f6 c4 02             	test   $0x2,%ah
80104087:	75 41                	jne    801040ca <sched+0x8a>
  intena = mycpu()->intena;
80104089:	e8 72 fb ff ff       	call   80103c00 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010408e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104091:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104097:	e8 64 fb ff ff       	call   80103c00 <mycpu>
8010409c:	83 ec 08             	sub    $0x8,%esp
8010409f:	ff 70 04             	pushl  0x4(%eax)
801040a2:	53                   	push   %ebx
801040a3:	e8 03 0b 00 00       	call   80104bab <swtch>
  mycpu()->intena = intena;
801040a8:	e8 53 fb ff ff       	call   80103c00 <mycpu>
}
801040ad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801040b0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801040b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040b9:	5b                   	pop    %ebx
801040ba:	5e                   	pop    %esi
801040bb:	5d                   	pop    %ebp
801040bc:	c3                   	ret    
    panic("sched ptable.lock");
801040bd:	83 ec 0c             	sub    $0xc,%esp
801040c0:	68 ea 7d 10 80       	push   $0x80107dea
801040c5:	e8 c6 c2 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801040ca:	83 ec 0c             	sub    $0xc,%esp
801040cd:	68 16 7e 10 80       	push   $0x80107e16
801040d2:	e8 b9 c2 ff ff       	call   80100390 <panic>
    panic("sched running");
801040d7:	83 ec 0c             	sub    $0xc,%esp
801040da:	68 08 7e 10 80       	push   $0x80107e08
801040df:	e8 ac c2 ff ff       	call   80100390 <panic>
    panic("sched locks");
801040e4:	83 ec 0c             	sub    $0xc,%esp
801040e7:	68 fc 7d 10 80       	push   $0x80107dfc
801040ec:	e8 9f c2 ff ff       	call   80100390 <panic>
801040f1:	eb 0d                	jmp    80104100 <exit>
801040f3:	90                   	nop
801040f4:	90                   	nop
801040f5:	90                   	nop
801040f6:	90                   	nop
801040f7:	90                   	nop
801040f8:	90                   	nop
801040f9:	90                   	nop
801040fa:	90                   	nop
801040fb:	90                   	nop
801040fc:	90                   	nop
801040fd:	90                   	nop
801040fe:	90                   	nop
801040ff:	90                   	nop

80104100 <exit>:
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	57                   	push   %edi
80104104:	56                   	push   %esi
80104105:	53                   	push   %ebx
80104106:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104109:	e8 82 06 00 00       	call   80104790 <pushcli>
  c = mycpu();
8010410e:	e8 ed fa ff ff       	call   80103c00 <mycpu>
  p = c->proc;
80104113:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104119:	e8 b2 06 00 00       	call   801047d0 <popcli>
  if(curproc == initproc)
8010411e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104124:	8d 5e 28             	lea    0x28(%esi),%ebx
80104127:	8d 7e 68             	lea    0x68(%esi),%edi
8010412a:	0f 84 f1 00 00 00    	je     80104221 <exit+0x121>
    if(curproc->ofile[fd]){
80104130:	8b 03                	mov    (%ebx),%eax
80104132:	85 c0                	test   %eax,%eax
80104134:	74 12                	je     80104148 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104136:	83 ec 0c             	sub    $0xc,%esp
80104139:	50                   	push   %eax
8010413a:	e8 b1 cd ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
8010413f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104145:	83 c4 10             	add    $0x10,%esp
80104148:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010414b:	39 fb                	cmp    %edi,%ebx
8010414d:	75 e1                	jne    80104130 <exit+0x30>
  begin_op();
8010414f:	e8 0c ef ff ff       	call   80103060 <begin_op>
  iput(curproc->cwd);
80104154:	83 ec 0c             	sub    $0xc,%esp
80104157:	ff 76 68             	pushl  0x68(%esi)
8010415a:	e8 01 d7 ff ff       	call   80101860 <iput>
  end_op();
8010415f:	e8 6c ef ff ff       	call   801030d0 <end_op>
  curproc->cwd = 0;
80104164:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010416b:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
80104172:	e8 e9 06 00 00       	call   80104860 <acquire>
  wakeup1(curproc->parent);
80104177:	8b 56 14             	mov    0x14(%esi),%edx
8010417a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010417d:	b8 d4 1d 12 80       	mov    $0x80121dd4,%eax
80104182:	eb 10                	jmp    80104194 <exit+0x94>
80104184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104188:	05 d0 03 00 00       	add    $0x3d0,%eax
8010418d:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
80104192:	73 1e                	jae    801041b2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104194:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104198:	75 ee                	jne    80104188 <exit+0x88>
8010419a:	3b 50 20             	cmp    0x20(%eax),%edx
8010419d:	75 e9                	jne    80104188 <exit+0x88>
      p->state = RUNNABLE;
8010419f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041a6:	05 d0 03 00 00       	add    $0x3d0,%eax
801041ab:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
801041b0:	72 e2                	jb     80104194 <exit+0x94>
      p->parent = initproc;
801041b2:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b8:	ba d4 1d 12 80       	mov    $0x80121dd4,%edx
801041bd:	eb 0f                	jmp    801041ce <exit+0xce>
801041bf:	90                   	nop
801041c0:	81 c2 d0 03 00 00    	add    $0x3d0,%edx
801041c6:	81 fa d4 11 13 80    	cmp    $0x801311d4,%edx
801041cc:	73 3a                	jae    80104208 <exit+0x108>
    if(p->parent == curproc){
801041ce:	39 72 14             	cmp    %esi,0x14(%edx)
801041d1:	75 ed                	jne    801041c0 <exit+0xc0>
      if(p->state == ZOMBIE)
801041d3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801041d7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801041da:	75 e4                	jne    801041c0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041dc:	b8 d4 1d 12 80       	mov    $0x80121dd4,%eax
801041e1:	eb 11                	jmp    801041f4 <exit+0xf4>
801041e3:	90                   	nop
801041e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041e8:	05 d0 03 00 00       	add    $0x3d0,%eax
801041ed:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
801041f2:	73 cc                	jae    801041c0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801041f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041f8:	75 ee                	jne    801041e8 <exit+0xe8>
801041fa:	3b 48 20             	cmp    0x20(%eax),%ecx
801041fd:	75 e9                	jne    801041e8 <exit+0xe8>
      p->state = RUNNABLE;
801041ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104206:	eb e0                	jmp    801041e8 <exit+0xe8>
  curproc->state = ZOMBIE;
80104208:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010420f:	e8 2c fe ff ff       	call   80104040 <sched>
  panic("zombie exit");
80104214:	83 ec 0c             	sub    $0xc,%esp
80104217:	68 37 7e 10 80       	push   $0x80107e37
8010421c:	e8 6f c1 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104221:	83 ec 0c             	sub    $0xc,%esp
80104224:	68 2a 7e 10 80       	push   $0x80107e2a
80104229:	e8 62 c1 ff ff       	call   80100390 <panic>
8010422e:	66 90                	xchg   %ax,%ax

80104230 <yield>:
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	53                   	push   %ebx
80104234:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104237:	68 a0 1d 12 80       	push   $0x80121da0
8010423c:	e8 1f 06 00 00       	call   80104860 <acquire>
  pushcli();
80104241:	e8 4a 05 00 00       	call   80104790 <pushcli>
  c = mycpu();
80104246:	e8 b5 f9 ff ff       	call   80103c00 <mycpu>
  p = c->proc;
8010424b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104251:	e8 7a 05 00 00       	call   801047d0 <popcli>
  myproc()->state = RUNNABLE;
80104256:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010425d:	e8 de fd ff ff       	call   80104040 <sched>
  release(&ptable.lock);
80104262:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
80104269:	e8 b2 06 00 00       	call   80104920 <release>
}
8010426e:	83 c4 10             	add    $0x10,%esp
80104271:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104274:	c9                   	leave  
80104275:	c3                   	ret    
80104276:	8d 76 00             	lea    0x0(%esi),%esi
80104279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104280 <sleep>:
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	57                   	push   %edi
80104284:	56                   	push   %esi
80104285:	53                   	push   %ebx
80104286:	83 ec 0c             	sub    $0xc,%esp
80104289:	8b 7d 08             	mov    0x8(%ebp),%edi
8010428c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010428f:	e8 fc 04 00 00       	call   80104790 <pushcli>
  c = mycpu();
80104294:	e8 67 f9 ff ff       	call   80103c00 <mycpu>
  p = c->proc;
80104299:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010429f:	e8 2c 05 00 00       	call   801047d0 <popcli>
  if(p == 0)
801042a4:	85 db                	test   %ebx,%ebx
801042a6:	0f 84 87 00 00 00    	je     80104333 <sleep+0xb3>
  if(lk == 0)
801042ac:	85 f6                	test   %esi,%esi
801042ae:	74 76                	je     80104326 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042b0:	81 fe a0 1d 12 80    	cmp    $0x80121da0,%esi
801042b6:	74 50                	je     80104308 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042b8:	83 ec 0c             	sub    $0xc,%esp
801042bb:	68 a0 1d 12 80       	push   $0x80121da0
801042c0:	e8 9b 05 00 00       	call   80104860 <acquire>
    release(lk);
801042c5:	89 34 24             	mov    %esi,(%esp)
801042c8:	e8 53 06 00 00       	call   80104920 <release>
  p->chan = chan;
801042cd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042d7:	e8 64 fd ff ff       	call   80104040 <sched>
  p->chan = 0;
801042dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042e3:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
801042ea:	e8 31 06 00 00       	call   80104920 <release>
    acquire(lk);
801042ef:	89 75 08             	mov    %esi,0x8(%ebp)
801042f2:	83 c4 10             	add    $0x10,%esp
}
801042f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042f8:	5b                   	pop    %ebx
801042f9:	5e                   	pop    %esi
801042fa:	5f                   	pop    %edi
801042fb:	5d                   	pop    %ebp
    acquire(lk);
801042fc:	e9 5f 05 00 00       	jmp    80104860 <acquire>
80104301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104308:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010430b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104312:	e8 29 fd ff ff       	call   80104040 <sched>
  p->chan = 0;
80104317:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010431e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104321:	5b                   	pop    %ebx
80104322:	5e                   	pop    %esi
80104323:	5f                   	pop    %edi
80104324:	5d                   	pop    %ebp
80104325:	c3                   	ret    
    panic("sleep without lk");
80104326:	83 ec 0c             	sub    $0xc,%esp
80104329:	68 49 7e 10 80       	push   $0x80107e49
8010432e:	e8 5d c0 ff ff       	call   80100390 <panic>
    panic("sleep");
80104333:	83 ec 0c             	sub    $0xc,%esp
80104336:	68 43 7e 10 80       	push   $0x80107e43
8010433b:	e8 50 c0 ff ff       	call   80100390 <panic>

80104340 <wait>:
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	56                   	push   %esi
80104344:	53                   	push   %ebx
  pushcli();
80104345:	e8 46 04 00 00       	call   80104790 <pushcli>
  c = mycpu();
8010434a:	e8 b1 f8 ff ff       	call   80103c00 <mycpu>
  p = c->proc;
8010434f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104355:	e8 76 04 00 00       	call   801047d0 <popcli>
  acquire(&ptable.lock);
8010435a:	83 ec 0c             	sub    $0xc,%esp
8010435d:	68 a0 1d 12 80       	push   $0x80121da0
80104362:	e8 f9 04 00 00       	call   80104860 <acquire>
80104367:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010436a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010436c:	bb d4 1d 12 80       	mov    $0x80121dd4,%ebx
80104371:	eb 13                	jmp    80104386 <wait+0x46>
80104373:	90                   	nop
80104374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104378:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
8010437e:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
80104384:	73 1e                	jae    801043a4 <wait+0x64>
      if(p->parent != curproc)
80104386:	39 73 14             	cmp    %esi,0x14(%ebx)
80104389:	75 ed                	jne    80104378 <wait+0x38>
      if(p->state == ZOMBIE){
8010438b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010438f:	74 37                	je     801043c8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104391:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
      havekids = 1;
80104397:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010439c:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
801043a2:	72 e2                	jb     80104386 <wait+0x46>
    if(!havekids || curproc->killed){
801043a4:	85 c0                	test   %eax,%eax
801043a6:	74 76                	je     8010441e <wait+0xde>
801043a8:	8b 46 24             	mov    0x24(%esi),%eax
801043ab:	85 c0                	test   %eax,%eax
801043ad:	75 6f                	jne    8010441e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801043af:	83 ec 08             	sub    $0x8,%esp
801043b2:	68 a0 1d 12 80       	push   $0x80121da0
801043b7:	56                   	push   %esi
801043b8:	e8 c3 fe ff ff       	call   80104280 <sleep>
    havekids = 0;
801043bd:	83 c4 10             	add    $0x10,%esp
801043c0:	eb a8                	jmp    8010436a <wait+0x2a>
801043c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cow_kfree(p->kstack);
801043c8:	83 ec 0c             	sub    $0xc,%esp
801043cb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801043ce:	8b 73 10             	mov    0x10(%ebx),%esi
        cow_kfree(p->kstack);
801043d1:	e8 2a 28 00 00       	call   80106c00 <cow_kfree>
        freevm(p->pgdir);
801043d6:	5a                   	pop    %edx
801043d7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801043da:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801043e1:	e8 fa 2f 00 00       	call   801073e0 <freevm>
        release(&ptable.lock);
801043e6:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
        p->pid = 0;
801043ed:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801043f4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801043fb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801043ff:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104406:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010440d:	e8 0e 05 00 00       	call   80104920 <release>
        return pid;
80104412:	83 c4 10             	add    $0x10,%esp
}
80104415:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104418:	89 f0                	mov    %esi,%eax
8010441a:	5b                   	pop    %ebx
8010441b:	5e                   	pop    %esi
8010441c:	5d                   	pop    %ebp
8010441d:	c3                   	ret    
      release(&ptable.lock);
8010441e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104421:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104426:	68 a0 1d 12 80       	push   $0x80121da0
8010442b:	e8 f0 04 00 00       	call   80104920 <release>
      return -1;
80104430:	83 c4 10             	add    $0x10,%esp
80104433:	eb e0                	jmp    80104415 <wait+0xd5>
80104435:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104440 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	53                   	push   %ebx
80104444:	83 ec 10             	sub    $0x10,%esp
80104447:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010444a:	68 a0 1d 12 80       	push   $0x80121da0
8010444f:	e8 0c 04 00 00       	call   80104860 <acquire>
80104454:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104457:	b8 d4 1d 12 80       	mov    $0x80121dd4,%eax
8010445c:	eb 0e                	jmp    8010446c <wakeup+0x2c>
8010445e:	66 90                	xchg   %ax,%ax
80104460:	05 d0 03 00 00       	add    $0x3d0,%eax
80104465:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
8010446a:	73 1e                	jae    8010448a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010446c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104470:	75 ee                	jne    80104460 <wakeup+0x20>
80104472:	3b 58 20             	cmp    0x20(%eax),%ebx
80104475:	75 e9                	jne    80104460 <wakeup+0x20>
      p->state = RUNNABLE;
80104477:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010447e:	05 d0 03 00 00       	add    $0x3d0,%eax
80104483:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
80104488:	72 e2                	jb     8010446c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010448a:	c7 45 08 a0 1d 12 80 	movl   $0x80121da0,0x8(%ebp)
}
80104491:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104494:	c9                   	leave  
  release(&ptable.lock);
80104495:	e9 86 04 00 00       	jmp    80104920 <release>
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	53                   	push   %ebx
801044a4:	83 ec 10             	sub    $0x10,%esp
801044a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801044aa:	68 a0 1d 12 80       	push   $0x80121da0
801044af:	e8 ac 03 00 00       	call   80104860 <acquire>
801044b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b7:	b8 d4 1d 12 80       	mov    $0x80121dd4,%eax
801044bc:	eb 0e                	jmp    801044cc <kill+0x2c>
801044be:	66 90                	xchg   %ax,%ax
801044c0:	05 d0 03 00 00       	add    $0x3d0,%eax
801044c5:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
801044ca:	73 34                	jae    80104500 <kill+0x60>
    if(p->pid == pid){
801044cc:	39 58 10             	cmp    %ebx,0x10(%eax)
801044cf:	75 ef                	jne    801044c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801044d1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801044d5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801044dc:	75 07                	jne    801044e5 <kill+0x45>
        p->state = RUNNABLE;
801044de:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801044e5:	83 ec 0c             	sub    $0xc,%esp
801044e8:	68 a0 1d 12 80       	push   $0x80121da0
801044ed:	e8 2e 04 00 00       	call   80104920 <release>
      return 0;
801044f2:	83 c4 10             	add    $0x10,%esp
801044f5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801044f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044fa:	c9                   	leave  
801044fb:	c3                   	ret    
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104500:	83 ec 0c             	sub    $0xc,%esp
80104503:	68 a0 1d 12 80       	push   $0x80121da0
80104508:	e8 13 04 00 00       	call   80104920 <release>
  return -1;
8010450d:	83 c4 10             	add    $0x10,%esp
80104510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104518:	c9                   	leave  
80104519:	c3                   	ret    
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104520 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	57                   	push   %edi
80104524:	56                   	push   %esi
80104525:	53                   	push   %ebx
80104526:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104529:	bb d4 1d 12 80       	mov    $0x80121dd4,%ebx
{
8010452e:	83 ec 3c             	sub    $0x3c,%esp
80104531:	eb 27                	jmp    8010455a <procdump+0x3a>
80104533:	90                   	nop
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104538:	83 ec 0c             	sub    $0xc,%esp
8010453b:	68 0d 83 10 80       	push   $0x8010830d
80104540:	e8 1b c1 ff ff       	call   80100660 <cprintf>
80104545:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104548:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
8010454e:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
80104554:	0f 83 86 00 00 00    	jae    801045e0 <procdump+0xc0>
    if(p->state == UNUSED)
8010455a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010455d:	85 c0                	test   %eax,%eax
8010455f:	74 e7                	je     80104548 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104561:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104564:	ba 5a 7e 10 80       	mov    $0x80107e5a,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104569:	77 11                	ja     8010457c <procdump+0x5c>
8010456b:	8b 14 85 bc 7e 10 80 	mov    -0x7fef8144(,%eax,4),%edx
      state = "???";
80104572:	b8 5a 7e 10 80       	mov    $0x80107e5a,%eax
80104577:	85 d2                	test   %edx,%edx
80104579:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s ", p->pid, state, p->name);
8010457c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010457f:	50                   	push   %eax
80104580:	52                   	push   %edx
80104581:	ff 73 10             	pushl  0x10(%ebx)
80104584:	68 5e 7e 10 80       	push   $0x80107e5e
80104589:	e8 d2 c0 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010458e:	83 c4 10             	add    $0x10,%esp
80104591:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104595:	75 a1                	jne    80104538 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104597:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010459a:	83 ec 08             	sub    $0x8,%esp
8010459d:	8d 7d c0             	lea    -0x40(%ebp),%edi
801045a0:	50                   	push   %eax
801045a1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801045a4:	8b 40 0c             	mov    0xc(%eax),%eax
801045a7:	83 c0 08             	add    $0x8,%eax
801045aa:	50                   	push   %eax
801045ab:	e8 90 01 00 00       	call   80104740 <getcallerpcs>
801045b0:	83 c4 10             	add    $0x10,%esp
801045b3:	90                   	nop
801045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801045b8:	8b 17                	mov    (%edi),%edx
801045ba:	85 d2                	test   %edx,%edx
801045bc:	0f 84 76 ff ff ff    	je     80104538 <procdump+0x18>
        cprintf(" %p", pc[i]);
801045c2:	83 ec 08             	sub    $0x8,%esp
801045c5:	83 c7 04             	add    $0x4,%edi
801045c8:	52                   	push   %edx
801045c9:	68 21 78 10 80       	push   $0x80107821
801045ce:	e8 8d c0 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801045d3:	83 c4 10             	add    $0x10,%esp
801045d6:	39 fe                	cmp    %edi,%esi
801045d8:	75 de                	jne    801045b8 <procdump+0x98>
801045da:	e9 59 ff ff ff       	jmp    80104538 <procdump+0x18>
801045df:	90                   	nop
  #if SELECTION != NONE
  int currentFree = sys_get_number_of_free_pages_impl();
  int totalFree = (PHYSTOP-EXTMEM) / PGSIZE ;///verify
  cprintf("%d / %d free page frames in the system\n", currentFree, totalFree);
  #endif
}
801045e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045e3:	5b                   	pop    %ebx
801045e4:	5e                   	pop    %esi
801045e5:	5f                   	pop    %edi
801045e6:	5d                   	pop    %ebp
801045e7:	c3                   	ret    
801045e8:	66 90                	xchg   %ax,%ax
801045ea:	66 90                	xchg   %ax,%ax
801045ec:	66 90                	xchg   %ax,%ax
801045ee:	66 90                	xchg   %ax,%ax

801045f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	83 ec 0c             	sub    $0xc,%esp
801045f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801045fa:	68 d4 7e 10 80       	push   $0x80107ed4
801045ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104602:	50                   	push   %eax
80104603:	e8 18 01 00 00       	call   80104720 <initlock>
  lk->name = name;
80104608:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010460b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104611:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104614:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010461b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010461e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104621:	c9                   	leave  
80104622:	c3                   	ret    
80104623:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104630 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	8d 73 04             	lea    0x4(%ebx),%esi
8010463e:	56                   	push   %esi
8010463f:	e8 1c 02 00 00       	call   80104860 <acquire>
  while (lk->locked) {
80104644:	8b 13                	mov    (%ebx),%edx
80104646:	83 c4 10             	add    $0x10,%esp
80104649:	85 d2                	test   %edx,%edx
8010464b:	74 16                	je     80104663 <acquiresleep+0x33>
8010464d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104650:	83 ec 08             	sub    $0x8,%esp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
80104655:	e8 26 fc ff ff       	call   80104280 <sleep>
  while (lk->locked) {
8010465a:	8b 03                	mov    (%ebx),%eax
8010465c:	83 c4 10             	add    $0x10,%esp
8010465f:	85 c0                	test   %eax,%eax
80104661:	75 ed                	jne    80104650 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104663:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104669:	e8 42 f6 ff ff       	call   80103cb0 <myproc>
8010466e:	8b 40 10             	mov    0x10(%eax),%eax
80104671:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104674:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104677:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010467a:	5b                   	pop    %ebx
8010467b:	5e                   	pop    %esi
8010467c:	5d                   	pop    %ebp
  release(&lk->lk);
8010467d:	e9 9e 02 00 00       	jmp    80104920 <release>
80104682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104690 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	53                   	push   %ebx
80104695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104698:	83 ec 0c             	sub    $0xc,%esp
8010469b:	8d 73 04             	lea    0x4(%ebx),%esi
8010469e:	56                   	push   %esi
8010469f:	e8 bc 01 00 00       	call   80104860 <acquire>
  lk->locked = 0;
801046a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801046aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801046b1:	89 1c 24             	mov    %ebx,(%esp)
801046b4:	e8 87 fd ff ff       	call   80104440 <wakeup>
  release(&lk->lk);
801046b9:	89 75 08             	mov    %esi,0x8(%ebp)
801046bc:	83 c4 10             	add    $0x10,%esp
}
801046bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c2:	5b                   	pop    %ebx
801046c3:	5e                   	pop    %esi
801046c4:	5d                   	pop    %ebp
  release(&lk->lk);
801046c5:	e9 56 02 00 00       	jmp    80104920 <release>
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	57                   	push   %edi
801046d4:	56                   	push   %esi
801046d5:	53                   	push   %ebx
801046d6:	31 ff                	xor    %edi,%edi
801046d8:	83 ec 18             	sub    $0x18,%esp
801046db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801046de:	8d 73 04             	lea    0x4(%ebx),%esi
801046e1:	56                   	push   %esi
801046e2:	e8 79 01 00 00       	call   80104860 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801046e7:	8b 03                	mov    (%ebx),%eax
801046e9:	83 c4 10             	add    $0x10,%esp
801046ec:	85 c0                	test   %eax,%eax
801046ee:	74 13                	je     80104703 <holdingsleep+0x33>
801046f0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801046f3:	e8 b8 f5 ff ff       	call   80103cb0 <myproc>
801046f8:	39 58 10             	cmp    %ebx,0x10(%eax)
801046fb:	0f 94 c0             	sete   %al
801046fe:	0f b6 c0             	movzbl %al,%eax
80104701:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104703:	83 ec 0c             	sub    $0xc,%esp
80104706:	56                   	push   %esi
80104707:	e8 14 02 00 00       	call   80104920 <release>
  return r;
}
8010470c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010470f:	89 f8                	mov    %edi,%eax
80104711:	5b                   	pop    %ebx
80104712:	5e                   	pop    %esi
80104713:	5f                   	pop    %edi
80104714:	5d                   	pop    %ebp
80104715:	c3                   	ret    
80104716:	66 90                	xchg   %ax,%ax
80104718:	66 90                	xchg   %ax,%ax
8010471a:	66 90                	xchg   %ax,%ax
8010471c:	66 90                	xchg   %ax,%ax
8010471e:	66 90                	xchg   %ax,%ax

80104720 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104726:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104729:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010472f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104732:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104739:	5d                   	pop    %ebp
8010473a:	c3                   	ret    
8010473b:	90                   	nop
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104740 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104740:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104741:	31 d2                	xor    %edx,%edx
{
80104743:	89 e5                	mov    %esp,%ebp
80104745:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104746:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104749:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010474c:	83 e8 08             	sub    $0x8,%eax
8010474f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104750:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104756:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010475c:	77 1a                	ja     80104778 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010475e:	8b 58 04             	mov    0x4(%eax),%ebx
80104761:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104764:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104767:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104769:	83 fa 0a             	cmp    $0xa,%edx
8010476c:	75 e2                	jne    80104750 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010476e:	5b                   	pop    %ebx
8010476f:	5d                   	pop    %ebp
80104770:	c3                   	ret    
80104771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104778:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010477b:	83 c1 28             	add    $0x28,%ecx
8010477e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104780:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104786:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104789:	39 c1                	cmp    %eax,%ecx
8010478b:	75 f3                	jne    80104780 <getcallerpcs+0x40>
}
8010478d:	5b                   	pop    %ebx
8010478e:	5d                   	pop    %ebp
8010478f:	c3                   	ret    

80104790 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	53                   	push   %ebx
80104794:	83 ec 04             	sub    $0x4,%esp
80104797:	9c                   	pushf  
80104798:	5b                   	pop    %ebx
  asm volatile("cli");
80104799:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010479a:	e8 61 f4 ff ff       	call   80103c00 <mycpu>
8010479f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801047a5:	85 c0                	test   %eax,%eax
801047a7:	75 11                	jne    801047ba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801047a9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801047af:	e8 4c f4 ff ff       	call   80103c00 <mycpu>
801047b4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801047ba:	e8 41 f4 ff ff       	call   80103c00 <mycpu>
801047bf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801047c6:	83 c4 04             	add    $0x4,%esp
801047c9:	5b                   	pop    %ebx
801047ca:	5d                   	pop    %ebp
801047cb:	c3                   	ret    
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047d0 <popcli>:

void
popcli(void)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047d6:	9c                   	pushf  
801047d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801047d8:	f6 c4 02             	test   $0x2,%ah
801047db:	75 35                	jne    80104812 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801047dd:	e8 1e f4 ff ff       	call   80103c00 <mycpu>
801047e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801047e9:	78 34                	js     8010481f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047eb:	e8 10 f4 ff ff       	call   80103c00 <mycpu>
801047f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801047f6:	85 d2                	test   %edx,%edx
801047f8:	74 06                	je     80104800 <popcli+0x30>
    sti();
}
801047fa:	c9                   	leave  
801047fb:	c3                   	ret    
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104800:	e8 fb f3 ff ff       	call   80103c00 <mycpu>
80104805:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010480b:	85 c0                	test   %eax,%eax
8010480d:	74 eb                	je     801047fa <popcli+0x2a>
  asm volatile("sti");
8010480f:	fb                   	sti    
}
80104810:	c9                   	leave  
80104811:	c3                   	ret    
    panic("popcli - interruptible");
80104812:	83 ec 0c             	sub    $0xc,%esp
80104815:	68 df 7e 10 80       	push   $0x80107edf
8010481a:	e8 71 bb ff ff       	call   80100390 <panic>
    panic("popcli");
8010481f:	83 ec 0c             	sub    $0xc,%esp
80104822:	68 f6 7e 10 80       	push   $0x80107ef6
80104827:	e8 64 bb ff ff       	call   80100390 <panic>
8010482c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104830 <holding>:
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
80104835:	8b 75 08             	mov    0x8(%ebp),%esi
80104838:	31 db                	xor    %ebx,%ebx
  pushcli();
8010483a:	e8 51 ff ff ff       	call   80104790 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010483f:	8b 06                	mov    (%esi),%eax
80104841:	85 c0                	test   %eax,%eax
80104843:	74 10                	je     80104855 <holding+0x25>
80104845:	8b 5e 08             	mov    0x8(%esi),%ebx
80104848:	e8 b3 f3 ff ff       	call   80103c00 <mycpu>
8010484d:	39 c3                	cmp    %eax,%ebx
8010484f:	0f 94 c3             	sete   %bl
80104852:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104855:	e8 76 ff ff ff       	call   801047d0 <popcli>
}
8010485a:	89 d8                	mov    %ebx,%eax
8010485c:	5b                   	pop    %ebx
8010485d:	5e                   	pop    %esi
8010485e:	5d                   	pop    %ebp
8010485f:	c3                   	ret    

80104860 <acquire>:
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104865:	e8 26 ff ff ff       	call   80104790 <pushcli>
  if(holding(lk))
8010486a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010486d:	83 ec 0c             	sub    $0xc,%esp
80104870:	53                   	push   %ebx
80104871:	e8 ba ff ff ff       	call   80104830 <holding>
80104876:	83 c4 10             	add    $0x10,%esp
80104879:	85 c0                	test   %eax,%eax
8010487b:	0f 85 83 00 00 00    	jne    80104904 <acquire+0xa4>
80104881:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104883:	ba 01 00 00 00       	mov    $0x1,%edx
80104888:	eb 09                	jmp    80104893 <acquire+0x33>
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104890:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104893:	89 d0                	mov    %edx,%eax
80104895:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104898:	85 c0                	test   %eax,%eax
8010489a:	75 f4                	jne    80104890 <acquire+0x30>
  __sync_synchronize();
8010489c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801048a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048a4:	e8 57 f3 ff ff       	call   80103c00 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801048a9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801048ac:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801048af:	89 e8                	mov    %ebp,%eax
801048b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048b8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801048be:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801048c4:	77 1a                	ja     801048e0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801048c6:	8b 48 04             	mov    0x4(%eax),%ecx
801048c9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801048cc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801048cf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801048d1:	83 fe 0a             	cmp    $0xa,%esi
801048d4:	75 e2                	jne    801048b8 <acquire+0x58>
}
801048d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048d9:	5b                   	pop    %ebx
801048da:	5e                   	pop    %esi
801048db:	5d                   	pop    %ebp
801048dc:	c3                   	ret    
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
801048e0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801048e3:	83 c2 28             	add    $0x28,%edx
801048e6:	8d 76 00             	lea    0x0(%esi),%esi
801048e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801048f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801048f6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801048f9:	39 d0                	cmp    %edx,%eax
801048fb:	75 f3                	jne    801048f0 <acquire+0x90>
}
801048fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104900:	5b                   	pop    %ebx
80104901:	5e                   	pop    %esi
80104902:	5d                   	pop    %ebp
80104903:	c3                   	ret    
    panic("acquire");
80104904:	83 ec 0c             	sub    $0xc,%esp
80104907:	68 fd 7e 10 80       	push   $0x80107efd
8010490c:	e8 7f ba ff ff       	call   80100390 <panic>
80104911:	eb 0d                	jmp    80104920 <release>
80104913:	90                   	nop
80104914:	90                   	nop
80104915:	90                   	nop
80104916:	90                   	nop
80104917:	90                   	nop
80104918:	90                   	nop
80104919:	90                   	nop
8010491a:	90                   	nop
8010491b:	90                   	nop
8010491c:	90                   	nop
8010491d:	90                   	nop
8010491e:	90                   	nop
8010491f:	90                   	nop

80104920 <release>:
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	83 ec 10             	sub    $0x10,%esp
80104927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010492a:	53                   	push   %ebx
8010492b:	e8 00 ff ff ff       	call   80104830 <holding>
80104930:	83 c4 10             	add    $0x10,%esp
80104933:	85 c0                	test   %eax,%eax
80104935:	74 22                	je     80104959 <release+0x39>
  lk->pcs[0] = 0;
80104937:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010493e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104945:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010494a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104950:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104953:	c9                   	leave  
  popcli();
80104954:	e9 77 fe ff ff       	jmp    801047d0 <popcli>
    panic("release");
80104959:	83 ec 0c             	sub    $0xc,%esp
8010495c:	68 05 7f 10 80       	push   $0x80107f05
80104961:	e8 2a ba ff ff       	call   80100390 <panic>
80104966:	66 90                	xchg   %ax,%ax
80104968:	66 90                	xchg   %ax,%ax
8010496a:	66 90                	xchg   %ax,%ax
8010496c:	66 90                	xchg   %ax,%ax
8010496e:	66 90                	xchg   %ax,%ax

80104970 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	57                   	push   %edi
80104974:	53                   	push   %ebx
80104975:	8b 55 08             	mov    0x8(%ebp),%edx
80104978:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010497b:	f6 c2 03             	test   $0x3,%dl
8010497e:	75 05                	jne    80104985 <memset+0x15>
80104980:	f6 c1 03             	test   $0x3,%cl
80104983:	74 13                	je     80104998 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104985:	89 d7                	mov    %edx,%edi
80104987:	8b 45 0c             	mov    0xc(%ebp),%eax
8010498a:	fc                   	cld    
8010498b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010498d:	5b                   	pop    %ebx
8010498e:	89 d0                	mov    %edx,%eax
80104990:	5f                   	pop    %edi
80104991:	5d                   	pop    %ebp
80104992:	c3                   	ret    
80104993:	90                   	nop
80104994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104998:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010499c:	c1 e9 02             	shr    $0x2,%ecx
8010499f:	89 f8                	mov    %edi,%eax
801049a1:	89 fb                	mov    %edi,%ebx
801049a3:	c1 e0 18             	shl    $0x18,%eax
801049a6:	c1 e3 10             	shl    $0x10,%ebx
801049a9:	09 d8                	or     %ebx,%eax
801049ab:	09 f8                	or     %edi,%eax
801049ad:	c1 e7 08             	shl    $0x8,%edi
801049b0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801049b2:	89 d7                	mov    %edx,%edi
801049b4:	fc                   	cld    
801049b5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801049b7:	5b                   	pop    %ebx
801049b8:	89 d0                	mov    %edx,%eax
801049ba:	5f                   	pop    %edi
801049bb:	5d                   	pop    %ebp
801049bc:	c3                   	ret    
801049bd:	8d 76 00             	lea    0x0(%esi),%esi

801049c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	57                   	push   %edi
801049c4:	56                   	push   %esi
801049c5:	53                   	push   %ebx
801049c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801049c9:	8b 75 08             	mov    0x8(%ebp),%esi
801049cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049cf:	85 db                	test   %ebx,%ebx
801049d1:	74 29                	je     801049fc <memcmp+0x3c>
    if(*s1 != *s2)
801049d3:	0f b6 16             	movzbl (%esi),%edx
801049d6:	0f b6 0f             	movzbl (%edi),%ecx
801049d9:	38 d1                	cmp    %dl,%cl
801049db:	75 2b                	jne    80104a08 <memcmp+0x48>
801049dd:	b8 01 00 00 00       	mov    $0x1,%eax
801049e2:	eb 14                	jmp    801049f8 <memcmp+0x38>
801049e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801049ec:	83 c0 01             	add    $0x1,%eax
801049ef:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801049f4:	38 ca                	cmp    %cl,%dl
801049f6:	75 10                	jne    80104a08 <memcmp+0x48>
  while(n-- > 0){
801049f8:	39 d8                	cmp    %ebx,%eax
801049fa:	75 ec                	jne    801049e8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801049fc:	5b                   	pop    %ebx
  return 0;
801049fd:	31 c0                	xor    %eax,%eax
}
801049ff:	5e                   	pop    %esi
80104a00:	5f                   	pop    %edi
80104a01:	5d                   	pop    %ebp
80104a02:	c3                   	ret    
80104a03:	90                   	nop
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104a08:	0f b6 c2             	movzbl %dl,%eax
}
80104a0b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104a0c:	29 c8                	sub    %ecx,%eax
}
80104a0e:	5e                   	pop    %esi
80104a0f:	5f                   	pop    %edi
80104a10:	5d                   	pop    %ebp
80104a11:	c3                   	ret    
80104a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a20 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
80104a25:	8b 45 08             	mov    0x8(%ebp),%eax
80104a28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104a2b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a2e:	39 c3                	cmp    %eax,%ebx
80104a30:	73 26                	jae    80104a58 <memmove+0x38>
80104a32:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104a35:	39 c8                	cmp    %ecx,%eax
80104a37:	73 1f                	jae    80104a58 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104a39:	85 f6                	test   %esi,%esi
80104a3b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104a3e:	74 0f                	je     80104a4f <memmove+0x2f>
      *--d = *--s;
80104a40:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a44:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104a47:	83 ea 01             	sub    $0x1,%edx
80104a4a:	83 fa ff             	cmp    $0xffffffff,%edx
80104a4d:	75 f1                	jne    80104a40 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a4f:	5b                   	pop    %ebx
80104a50:	5e                   	pop    %esi
80104a51:	5d                   	pop    %ebp
80104a52:	c3                   	ret    
80104a53:	90                   	nop
80104a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104a58:	31 d2                	xor    %edx,%edx
80104a5a:	85 f6                	test   %esi,%esi
80104a5c:	74 f1                	je     80104a4f <memmove+0x2f>
80104a5e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104a60:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104a64:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104a67:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104a6a:	39 d6                	cmp    %edx,%esi
80104a6c:	75 f2                	jne    80104a60 <memmove+0x40>
}
80104a6e:	5b                   	pop    %ebx
80104a6f:	5e                   	pop    %esi
80104a70:	5d                   	pop    %ebp
80104a71:	c3                   	ret    
80104a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104a83:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104a84:	eb 9a                	jmp    80104a20 <memmove>
80104a86:	8d 76 00             	lea    0x0(%esi),%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a90 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	57                   	push   %edi
80104a94:	56                   	push   %esi
80104a95:	8b 7d 10             	mov    0x10(%ebp),%edi
80104a98:	53                   	push   %ebx
80104a99:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104a9f:	85 ff                	test   %edi,%edi
80104aa1:	74 2f                	je     80104ad2 <strncmp+0x42>
80104aa3:	0f b6 01             	movzbl (%ecx),%eax
80104aa6:	0f b6 1e             	movzbl (%esi),%ebx
80104aa9:	84 c0                	test   %al,%al
80104aab:	74 37                	je     80104ae4 <strncmp+0x54>
80104aad:	38 c3                	cmp    %al,%bl
80104aaf:	75 33                	jne    80104ae4 <strncmp+0x54>
80104ab1:	01 f7                	add    %esi,%edi
80104ab3:	eb 13                	jmp    80104ac8 <strncmp+0x38>
80104ab5:	8d 76 00             	lea    0x0(%esi),%esi
80104ab8:	0f b6 01             	movzbl (%ecx),%eax
80104abb:	84 c0                	test   %al,%al
80104abd:	74 21                	je     80104ae0 <strncmp+0x50>
80104abf:	0f b6 1a             	movzbl (%edx),%ebx
80104ac2:	89 d6                	mov    %edx,%esi
80104ac4:	38 d8                	cmp    %bl,%al
80104ac6:	75 1c                	jne    80104ae4 <strncmp+0x54>
    n--, p++, q++;
80104ac8:	8d 56 01             	lea    0x1(%esi),%edx
80104acb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104ace:	39 fa                	cmp    %edi,%edx
80104ad0:	75 e6                	jne    80104ab8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104ad2:	5b                   	pop    %ebx
    return 0;
80104ad3:	31 c0                	xor    %eax,%eax
}
80104ad5:	5e                   	pop    %esi
80104ad6:	5f                   	pop    %edi
80104ad7:	5d                   	pop    %ebp
80104ad8:	c3                   	ret    
80104ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ae0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104ae4:	29 d8                	sub    %ebx,%eax
}
80104ae6:	5b                   	pop    %ebx
80104ae7:	5e                   	pop    %esi
80104ae8:	5f                   	pop    %edi
80104ae9:	5d                   	pop    %ebp
80104aea:	c3                   	ret    
80104aeb:	90                   	nop
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104af0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
80104af5:	8b 45 08             	mov    0x8(%ebp),%eax
80104af8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104afb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104afe:	89 c2                	mov    %eax,%edx
80104b00:	eb 19                	jmp    80104b1b <strncpy+0x2b>
80104b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b08:	83 c3 01             	add    $0x1,%ebx
80104b0b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104b0f:	83 c2 01             	add    $0x1,%edx
80104b12:	84 c9                	test   %cl,%cl
80104b14:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b17:	74 09                	je     80104b22 <strncpy+0x32>
80104b19:	89 f1                	mov    %esi,%ecx
80104b1b:	85 c9                	test   %ecx,%ecx
80104b1d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104b20:	7f e6                	jg     80104b08 <strncpy+0x18>
    ;
  while(n-- > 0)
80104b22:	31 c9                	xor    %ecx,%ecx
80104b24:	85 f6                	test   %esi,%esi
80104b26:	7e 17                	jle    80104b3f <strncpy+0x4f>
80104b28:	90                   	nop
80104b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104b30:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104b34:	89 f3                	mov    %esi,%ebx
80104b36:	83 c1 01             	add    $0x1,%ecx
80104b39:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104b3b:	85 db                	test   %ebx,%ebx
80104b3d:	7f f1                	jg     80104b30 <strncpy+0x40>
  return os;
}
80104b3f:	5b                   	pop    %ebx
80104b40:	5e                   	pop    %esi
80104b41:	5d                   	pop    %ebp
80104b42:	c3                   	ret    
80104b43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	53                   	push   %ebx
80104b55:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b58:	8b 45 08             	mov    0x8(%ebp),%eax
80104b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104b5e:	85 c9                	test   %ecx,%ecx
80104b60:	7e 26                	jle    80104b88 <safestrcpy+0x38>
80104b62:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104b66:	89 c1                	mov    %eax,%ecx
80104b68:	eb 17                	jmp    80104b81 <safestrcpy+0x31>
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b70:	83 c2 01             	add    $0x1,%edx
80104b73:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104b77:	83 c1 01             	add    $0x1,%ecx
80104b7a:	84 db                	test   %bl,%bl
80104b7c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104b7f:	74 04                	je     80104b85 <safestrcpy+0x35>
80104b81:	39 f2                	cmp    %esi,%edx
80104b83:	75 eb                	jne    80104b70 <safestrcpy+0x20>
    ;
  *s = 0;
80104b85:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104b88:	5b                   	pop    %ebx
80104b89:	5e                   	pop    %esi
80104b8a:	5d                   	pop    %ebp
80104b8b:	c3                   	ret    
80104b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b90 <strlen>:

int
strlen(const char *s)
{
80104b90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b91:	31 c0                	xor    %eax,%eax
{
80104b93:	89 e5                	mov    %esp,%ebp
80104b95:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b98:	80 3a 00             	cmpb   $0x0,(%edx)
80104b9b:	74 0c                	je     80104ba9 <strlen+0x19>
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi
80104ba0:	83 c0 01             	add    $0x1,%eax
80104ba3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ba7:	75 f7                	jne    80104ba0 <strlen+0x10>
    ;
  return n;
}
80104ba9:	5d                   	pop    %ebp
80104baa:	c3                   	ret    

80104bab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104bab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104baf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104bb3:	55                   	push   %ebp
  pushl %ebx
80104bb4:	53                   	push   %ebx
  pushl %esi
80104bb5:	56                   	push   %esi
  pushl %edi
80104bb6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104bb7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104bb9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104bbb:	5f                   	pop    %edi
  popl %esi
80104bbc:	5e                   	pop    %esi
  popl %ebx
80104bbd:	5b                   	pop    %ebx
  popl %ebp
80104bbe:	5d                   	pop    %ebp
  ret
80104bbf:	c3                   	ret    

80104bc0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
80104bc4:	83 ec 04             	sub    $0x4,%esp
80104bc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104bca:	e8 e1 f0 ff ff       	call   80103cb0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bcf:	8b 00                	mov    (%eax),%eax
80104bd1:	39 d8                	cmp    %ebx,%eax
80104bd3:	76 1b                	jbe    80104bf0 <fetchint+0x30>
80104bd5:	8d 53 04             	lea    0x4(%ebx),%edx
80104bd8:	39 d0                	cmp    %edx,%eax
80104bda:	72 14                	jb     80104bf0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bdf:	8b 13                	mov    (%ebx),%edx
80104be1:	89 10                	mov    %edx,(%eax)
  return 0;
80104be3:	31 c0                	xor    %eax,%eax
}
80104be5:	83 c4 04             	add    $0x4,%esp
80104be8:	5b                   	pop    %ebx
80104be9:	5d                   	pop    %ebp
80104bea:	c3                   	ret    
80104beb:	90                   	nop
80104bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bf5:	eb ee                	jmp    80104be5 <fetchint+0x25>
80104bf7:	89 f6                	mov    %esi,%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	53                   	push   %ebx
80104c04:	83 ec 04             	sub    $0x4,%esp
80104c07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c0a:	e8 a1 f0 ff ff       	call   80103cb0 <myproc>

  if(addr >= curproc->sz)
80104c0f:	39 18                	cmp    %ebx,(%eax)
80104c11:	76 29                	jbe    80104c3c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104c13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104c16:	89 da                	mov    %ebx,%edx
80104c18:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104c1a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104c1c:	39 c3                	cmp    %eax,%ebx
80104c1e:	73 1c                	jae    80104c3c <fetchstr+0x3c>
    if(*s == 0)
80104c20:	80 3b 00             	cmpb   $0x0,(%ebx)
80104c23:	75 10                	jne    80104c35 <fetchstr+0x35>
80104c25:	eb 39                	jmp    80104c60 <fetchstr+0x60>
80104c27:	89 f6                	mov    %esi,%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c30:	80 3a 00             	cmpb   $0x0,(%edx)
80104c33:	74 1b                	je     80104c50 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104c35:	83 c2 01             	add    $0x1,%edx
80104c38:	39 d0                	cmp    %edx,%eax
80104c3a:	77 f4                	ja     80104c30 <fetchstr+0x30>
    return -1;
80104c3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104c41:	83 c4 04             	add    $0x4,%esp
80104c44:	5b                   	pop    %ebx
80104c45:	5d                   	pop    %ebp
80104c46:	c3                   	ret    
80104c47:	89 f6                	mov    %esi,%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104c50:	83 c4 04             	add    $0x4,%esp
80104c53:	89 d0                	mov    %edx,%eax
80104c55:	29 d8                	sub    %ebx,%eax
80104c57:	5b                   	pop    %ebx
80104c58:	5d                   	pop    %ebp
80104c59:	c3                   	ret    
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104c60:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104c62:	eb dd                	jmp    80104c41 <fetchstr+0x41>
80104c64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104c70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c75:	e8 36 f0 ff ff       	call   80103cb0 <myproc>
80104c7a:	8b 40 18             	mov    0x18(%eax),%eax
80104c7d:	8b 55 08             	mov    0x8(%ebp),%edx
80104c80:	8b 40 44             	mov    0x44(%eax),%eax
80104c83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c86:	e8 25 f0 ff ff       	call   80103cb0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c8b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c8d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c90:	39 c6                	cmp    %eax,%esi
80104c92:	73 1c                	jae    80104cb0 <argint+0x40>
80104c94:	8d 53 08             	lea    0x8(%ebx),%edx
80104c97:	39 d0                	cmp    %edx,%eax
80104c99:	72 15                	jb     80104cb0 <argint+0x40>
  *ip = *(int*)(addr);
80104c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104ca1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ca3:	31 c0                	xor    %eax,%eax
}
80104ca5:	5b                   	pop    %ebx
80104ca6:	5e                   	pop    %esi
80104ca7:	5d                   	pop    %ebp
80104ca8:	c3                   	ret    
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cb5:	eb ee                	jmp    80104ca5 <argint+0x35>
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	56                   	push   %esi
80104cc4:	53                   	push   %ebx
80104cc5:	83 ec 10             	sub    $0x10,%esp
80104cc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104ccb:	e8 e0 ef ff ff       	call   80103cb0 <myproc>
80104cd0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104cd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cd5:	83 ec 08             	sub    $0x8,%esp
80104cd8:	50                   	push   %eax
80104cd9:	ff 75 08             	pushl  0x8(%ebp)
80104cdc:	e8 8f ff ff ff       	call   80104c70 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ce1:	83 c4 10             	add    $0x10,%esp
80104ce4:	85 c0                	test   %eax,%eax
80104ce6:	78 28                	js     80104d10 <argptr+0x50>
80104ce8:	85 db                	test   %ebx,%ebx
80104cea:	78 24                	js     80104d10 <argptr+0x50>
80104cec:	8b 16                	mov    (%esi),%edx
80104cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf1:	39 c2                	cmp    %eax,%edx
80104cf3:	76 1b                	jbe    80104d10 <argptr+0x50>
80104cf5:	01 c3                	add    %eax,%ebx
80104cf7:	39 da                	cmp    %ebx,%edx
80104cf9:	72 15                	jb     80104d10 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104cfb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cfe:	89 02                	mov    %eax,(%edx)
  return 0;
80104d00:	31 c0                	xor    %eax,%eax
}
80104d02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d05:	5b                   	pop    %ebx
80104d06:	5e                   	pop    %esi
80104d07:	5d                   	pop    %ebp
80104d08:	c3                   	ret    
80104d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d15:	eb eb                	jmp    80104d02 <argptr+0x42>
80104d17:	89 f6                	mov    %esi,%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104d26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d29:	50                   	push   %eax
80104d2a:	ff 75 08             	pushl  0x8(%ebp)
80104d2d:	e8 3e ff ff ff       	call   80104c70 <argint>
80104d32:	83 c4 10             	add    $0x10,%esp
80104d35:	85 c0                	test   %eax,%eax
80104d37:	78 17                	js     80104d50 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104d39:	83 ec 08             	sub    $0x8,%esp
80104d3c:	ff 75 0c             	pushl  0xc(%ebp)
80104d3f:	ff 75 f4             	pushl  -0xc(%ebp)
80104d42:	e8 b9 fe ff ff       	call   80104c00 <fetchstr>
80104d47:	83 c4 10             	add    $0x10,%esp
}
80104d4a:	c9                   	leave  
80104d4b:	c3                   	ret    
80104d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d55:	c9                   	leave  
80104d56:	c3                   	ret    
80104d57:	89 f6                	mov    %esi,%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d60 <syscall>:
[SYS_get_number_of_free_pages] sys_get_number_of_free_pages
};

void
syscall(void)
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	53                   	push   %ebx
80104d64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d67:	e8 44 ef ff ff       	call   80103cb0 <myproc>
80104d6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d6e:	8b 40 18             	mov    0x18(%eax),%eax
80104d71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d77:	83 fa 15             	cmp    $0x15,%edx
80104d7a:	77 1c                	ja     80104d98 <syscall+0x38>
80104d7c:	8b 14 85 40 7f 10 80 	mov    -0x7fef80c0(,%eax,4),%edx
80104d83:	85 d2                	test   %edx,%edx
80104d85:	74 11                	je     80104d98 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104d87:	ff d2                	call   *%edx
80104d89:	8b 53 18             	mov    0x18(%ebx),%edx
80104d8c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d92:	c9                   	leave  
80104d93:	c3                   	ret    
80104d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d98:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d99:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d9c:	50                   	push   %eax
80104d9d:	ff 73 10             	pushl  0x10(%ebx)
80104da0:	68 0d 7f 10 80       	push   $0x80107f0d
80104da5:	e8 b6 b8 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104daa:	8b 43 18             	mov    0x18(%ebx),%eax
80104dad:	83 c4 10             	add    $0x10,%esp
80104db0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104db7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dba:	c9                   	leave  
80104dbb:	c3                   	ret    
80104dbc:	66 90                	xchg   %ax,%ax
80104dbe:	66 90                	xchg   %ax,%ax

80104dc0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	56                   	push   %esi
80104dc4:	53                   	push   %ebx
80104dc5:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104dc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104dca:	89 d6                	mov    %edx,%esi
80104dcc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104dcf:	50                   	push   %eax
80104dd0:	6a 00                	push   $0x0
80104dd2:	e8 99 fe ff ff       	call   80104c70 <argint>
80104dd7:	83 c4 10             	add    $0x10,%esp
80104dda:	85 c0                	test   %eax,%eax
80104ddc:	78 2a                	js     80104e08 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dde:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104de2:	77 24                	ja     80104e08 <argfd.constprop.0+0x48>
80104de4:	e8 c7 ee ff ff       	call   80103cb0 <myproc>
80104de9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104dec:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104df0:	85 c0                	test   %eax,%eax
80104df2:	74 14                	je     80104e08 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80104df4:	85 db                	test   %ebx,%ebx
80104df6:	74 02                	je     80104dfa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104df8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
80104dfa:	89 06                	mov    %eax,(%esi)
  return 0;
80104dfc:	31 c0                	xor    %eax,%eax
}
80104dfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e01:	5b                   	pop    %ebx
80104e02:	5e                   	pop    %esi
80104e03:	5d                   	pop    %ebp
80104e04:	c3                   	ret    
80104e05:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e0d:	eb ef                	jmp    80104dfe <argfd.constprop.0+0x3e>
80104e0f:	90                   	nop

80104e10 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104e10:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104e11:	31 c0                	xor    %eax,%eax
{
80104e13:	89 e5                	mov    %esp,%ebp
80104e15:	56                   	push   %esi
80104e16:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104e17:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104e1a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104e1d:	e8 9e ff ff ff       	call   80104dc0 <argfd.constprop.0>
80104e22:	85 c0                	test   %eax,%eax
80104e24:	78 42                	js     80104e68 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104e26:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104e29:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104e2b:	e8 80 ee ff ff       	call   80103cb0 <myproc>
80104e30:	eb 0e                	jmp    80104e40 <sys_dup+0x30>
80104e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104e38:	83 c3 01             	add    $0x1,%ebx
80104e3b:	83 fb 10             	cmp    $0x10,%ebx
80104e3e:	74 28                	je     80104e68 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104e40:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e44:	85 d2                	test   %edx,%edx
80104e46:	75 f0                	jne    80104e38 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104e48:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
80104e4c:	83 ec 0c             	sub    $0xc,%esp
80104e4f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e52:	e8 49 c0 ff ff       	call   80100ea0 <filedup>
  return fd;
80104e57:	83 c4 10             	add    $0x10,%esp
}
80104e5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e5d:	89 d8                	mov    %ebx,%eax
80104e5f:	5b                   	pop    %ebx
80104e60:	5e                   	pop    %esi
80104e61:	5d                   	pop    %ebp
80104e62:	c3                   	ret    
80104e63:	90                   	nop
80104e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e68:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e6b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e70:	89 d8                	mov    %ebx,%eax
80104e72:	5b                   	pop    %ebx
80104e73:	5e                   	pop    %esi
80104e74:	5d                   	pop    %ebp
80104e75:	c3                   	ret    
80104e76:	8d 76 00             	lea    0x0(%esi),%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e80 <sys_read>:

int
sys_read(void)
{
80104e80:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e81:	31 c0                	xor    %eax,%eax
{
80104e83:	89 e5                	mov    %esp,%ebp
80104e85:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e88:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e8b:	e8 30 ff ff ff       	call   80104dc0 <argfd.constprop.0>
80104e90:	85 c0                	test   %eax,%eax
80104e92:	78 4c                	js     80104ee0 <sys_read+0x60>
80104e94:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e97:	83 ec 08             	sub    $0x8,%esp
80104e9a:	50                   	push   %eax
80104e9b:	6a 02                	push   $0x2
80104e9d:	e8 ce fd ff ff       	call   80104c70 <argint>
80104ea2:	83 c4 10             	add    $0x10,%esp
80104ea5:	85 c0                	test   %eax,%eax
80104ea7:	78 37                	js     80104ee0 <sys_read+0x60>
80104ea9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eac:	83 ec 04             	sub    $0x4,%esp
80104eaf:	ff 75 f0             	pushl  -0x10(%ebp)
80104eb2:	50                   	push   %eax
80104eb3:	6a 01                	push   $0x1
80104eb5:	e8 06 fe ff ff       	call   80104cc0 <argptr>
80104eba:	83 c4 10             	add    $0x10,%esp
80104ebd:	85 c0                	test   %eax,%eax
80104ebf:	78 1f                	js     80104ee0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104ec1:	83 ec 04             	sub    $0x4,%esp
80104ec4:	ff 75 f0             	pushl  -0x10(%ebp)
80104ec7:	ff 75 f4             	pushl  -0xc(%ebp)
80104eca:	ff 75 ec             	pushl  -0x14(%ebp)
80104ecd:	e8 3e c1 ff ff       	call   80101010 <fileread>
80104ed2:	83 c4 10             	add    $0x10,%esp
}
80104ed5:	c9                   	leave  
80104ed6:	c3                   	ret    
80104ed7:	89 f6                	mov    %esi,%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ee5:	c9                   	leave  
80104ee6:	c3                   	ret    
80104ee7:	89 f6                	mov    %esi,%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ef0 <sys_write>:

int
sys_write(void)
{
80104ef0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ef1:	31 c0                	xor    %eax,%eax
{
80104ef3:	89 e5                	mov    %esp,%ebp
80104ef5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ef8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104efb:	e8 c0 fe ff ff       	call   80104dc0 <argfd.constprop.0>
80104f00:	85 c0                	test   %eax,%eax
80104f02:	78 4c                	js     80104f50 <sys_write+0x60>
80104f04:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f07:	83 ec 08             	sub    $0x8,%esp
80104f0a:	50                   	push   %eax
80104f0b:	6a 02                	push   $0x2
80104f0d:	e8 5e fd ff ff       	call   80104c70 <argint>
80104f12:	83 c4 10             	add    $0x10,%esp
80104f15:	85 c0                	test   %eax,%eax
80104f17:	78 37                	js     80104f50 <sys_write+0x60>
80104f19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f1c:	83 ec 04             	sub    $0x4,%esp
80104f1f:	ff 75 f0             	pushl  -0x10(%ebp)
80104f22:	50                   	push   %eax
80104f23:	6a 01                	push   $0x1
80104f25:	e8 96 fd ff ff       	call   80104cc0 <argptr>
80104f2a:	83 c4 10             	add    $0x10,%esp
80104f2d:	85 c0                	test   %eax,%eax
80104f2f:	78 1f                	js     80104f50 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104f31:	83 ec 04             	sub    $0x4,%esp
80104f34:	ff 75 f0             	pushl  -0x10(%ebp)
80104f37:	ff 75 f4             	pushl  -0xc(%ebp)
80104f3a:	ff 75 ec             	pushl  -0x14(%ebp)
80104f3d:	e8 5e c1 ff ff       	call   801010a0 <filewrite>
80104f42:	83 c4 10             	add    $0x10,%esp
}
80104f45:	c9                   	leave  
80104f46:	c3                   	ret    
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f55:	c9                   	leave  
80104f56:	c3                   	ret    
80104f57:	89 f6                	mov    %esi,%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f60 <sys_close>:

int
sys_close(void)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104f66:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104f69:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f6c:	e8 4f fe ff ff       	call   80104dc0 <argfd.constprop.0>
80104f71:	85 c0                	test   %eax,%eax
80104f73:	78 2b                	js     80104fa0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104f75:	e8 36 ed ff ff       	call   80103cb0 <myproc>
80104f7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104f7d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f80:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104f87:	00 
  fileclose(f);
80104f88:	ff 75 f4             	pushl  -0xc(%ebp)
80104f8b:	e8 60 bf ff ff       	call   80100ef0 <fileclose>
  return 0;
80104f90:	83 c4 10             	add    $0x10,%esp
80104f93:	31 c0                	xor    %eax,%eax
}
80104f95:	c9                   	leave  
80104f96:	c3                   	ret    
80104f97:	89 f6                	mov    %esi,%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fa5:	c9                   	leave  
80104fa6:	c3                   	ret    
80104fa7:	89 f6                	mov    %esi,%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fb0 <sys_fstat>:

int
sys_fstat(void)
{
80104fb0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104fb1:	31 c0                	xor    %eax,%eax
{
80104fb3:	89 e5                	mov    %esp,%ebp
80104fb5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104fb8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104fbb:	e8 00 fe ff ff       	call   80104dc0 <argfd.constprop.0>
80104fc0:	85 c0                	test   %eax,%eax
80104fc2:	78 2c                	js     80104ff0 <sys_fstat+0x40>
80104fc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fc7:	83 ec 04             	sub    $0x4,%esp
80104fca:	6a 14                	push   $0x14
80104fcc:	50                   	push   %eax
80104fcd:	6a 01                	push   $0x1
80104fcf:	e8 ec fc ff ff       	call   80104cc0 <argptr>
80104fd4:	83 c4 10             	add    $0x10,%esp
80104fd7:	85 c0                	test   %eax,%eax
80104fd9:	78 15                	js     80104ff0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104fdb:	83 ec 08             	sub    $0x8,%esp
80104fde:	ff 75 f4             	pushl  -0xc(%ebp)
80104fe1:	ff 75 f0             	pushl  -0x10(%ebp)
80104fe4:	e8 d7 bf ff ff       	call   80100fc0 <filestat>
80104fe9:	83 c4 10             	add    $0x10,%esp
}
80104fec:	c9                   	leave  
80104fed:	c3                   	ret    
80104fee:	66 90                	xchg   %ax,%ax
    return -1;
80104ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ff5:	c9                   	leave  
80104ff6:	c3                   	ret    
80104ff7:	89 f6                	mov    %esi,%esi
80104ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105000 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	57                   	push   %edi
80105004:	56                   	push   %esi
80105005:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105006:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105009:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010500c:	50                   	push   %eax
8010500d:	6a 00                	push   $0x0
8010500f:	e8 0c fd ff ff       	call   80104d20 <argstr>
80105014:	83 c4 10             	add    $0x10,%esp
80105017:	85 c0                	test   %eax,%eax
80105019:	0f 88 fb 00 00 00    	js     8010511a <sys_link+0x11a>
8010501f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105022:	83 ec 08             	sub    $0x8,%esp
80105025:	50                   	push   %eax
80105026:	6a 01                	push   $0x1
80105028:	e8 f3 fc ff ff       	call   80104d20 <argstr>
8010502d:	83 c4 10             	add    $0x10,%esp
80105030:	85 c0                	test   %eax,%eax
80105032:	0f 88 e2 00 00 00    	js     8010511a <sys_link+0x11a>
    return -1;

  begin_op();
80105038:	e8 23 e0 ff ff       	call   80103060 <begin_op>
  if((ip = namei(old)) == 0){
8010503d:	83 ec 0c             	sub    $0xc,%esp
80105040:	ff 75 d4             	pushl  -0x2c(%ebp)
80105043:	e8 48 cf ff ff       	call   80101f90 <namei>
80105048:	83 c4 10             	add    $0x10,%esp
8010504b:	85 c0                	test   %eax,%eax
8010504d:	89 c3                	mov    %eax,%ebx
8010504f:	0f 84 ea 00 00 00    	je     8010513f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105055:	83 ec 0c             	sub    $0xc,%esp
80105058:	50                   	push   %eax
80105059:	e8 d2 c6 ff ff       	call   80101730 <ilock>
  if(ip->type == T_DIR){
8010505e:	83 c4 10             	add    $0x10,%esp
80105061:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105066:	0f 84 bb 00 00 00    	je     80105127 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010506c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105071:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105074:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105077:	53                   	push   %ebx
80105078:	e8 03 c6 ff ff       	call   80101680 <iupdate>
  iunlock(ip);
8010507d:	89 1c 24             	mov    %ebx,(%esp)
80105080:	e8 8b c7 ff ff       	call   80101810 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105085:	58                   	pop    %eax
80105086:	5a                   	pop    %edx
80105087:	57                   	push   %edi
80105088:	ff 75 d0             	pushl  -0x30(%ebp)
8010508b:	e8 20 cf ff ff       	call   80101fb0 <nameiparent>
80105090:	83 c4 10             	add    $0x10,%esp
80105093:	85 c0                	test   %eax,%eax
80105095:	89 c6                	mov    %eax,%esi
80105097:	74 5b                	je     801050f4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105099:	83 ec 0c             	sub    $0xc,%esp
8010509c:	50                   	push   %eax
8010509d:	e8 8e c6 ff ff       	call   80101730 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801050a2:	83 c4 10             	add    $0x10,%esp
801050a5:	8b 03                	mov    (%ebx),%eax
801050a7:	39 06                	cmp    %eax,(%esi)
801050a9:	75 3d                	jne    801050e8 <sys_link+0xe8>
801050ab:	83 ec 04             	sub    $0x4,%esp
801050ae:	ff 73 04             	pushl  0x4(%ebx)
801050b1:	57                   	push   %edi
801050b2:	56                   	push   %esi
801050b3:	e8 18 ce ff ff       	call   80101ed0 <dirlink>
801050b8:	83 c4 10             	add    $0x10,%esp
801050bb:	85 c0                	test   %eax,%eax
801050bd:	78 29                	js     801050e8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801050bf:	83 ec 0c             	sub    $0xc,%esp
801050c2:	56                   	push   %esi
801050c3:	e8 f8 c8 ff ff       	call   801019c0 <iunlockput>
  iput(ip);
801050c8:	89 1c 24             	mov    %ebx,(%esp)
801050cb:	e8 90 c7 ff ff       	call   80101860 <iput>

  end_op();
801050d0:	e8 fb df ff ff       	call   801030d0 <end_op>

  return 0;
801050d5:	83 c4 10             	add    $0x10,%esp
801050d8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801050da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050dd:	5b                   	pop    %ebx
801050de:	5e                   	pop    %esi
801050df:	5f                   	pop    %edi
801050e0:	5d                   	pop    %ebp
801050e1:	c3                   	ret    
801050e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801050e8:	83 ec 0c             	sub    $0xc,%esp
801050eb:	56                   	push   %esi
801050ec:	e8 cf c8 ff ff       	call   801019c0 <iunlockput>
    goto bad;
801050f1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801050f4:	83 ec 0c             	sub    $0xc,%esp
801050f7:	53                   	push   %ebx
801050f8:	e8 33 c6 ff ff       	call   80101730 <ilock>
  ip->nlink--;
801050fd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105102:	89 1c 24             	mov    %ebx,(%esp)
80105105:	e8 76 c5 ff ff       	call   80101680 <iupdate>
  iunlockput(ip);
8010510a:	89 1c 24             	mov    %ebx,(%esp)
8010510d:	e8 ae c8 ff ff       	call   801019c0 <iunlockput>
  end_op();
80105112:	e8 b9 df ff ff       	call   801030d0 <end_op>
  return -1;
80105117:	83 c4 10             	add    $0x10,%esp
}
8010511a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010511d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105122:	5b                   	pop    %ebx
80105123:	5e                   	pop    %esi
80105124:	5f                   	pop    %edi
80105125:	5d                   	pop    %ebp
80105126:	c3                   	ret    
    iunlockput(ip);
80105127:	83 ec 0c             	sub    $0xc,%esp
8010512a:	53                   	push   %ebx
8010512b:	e8 90 c8 ff ff       	call   801019c0 <iunlockput>
    end_op();
80105130:	e8 9b df ff ff       	call   801030d0 <end_op>
    return -1;
80105135:	83 c4 10             	add    $0x10,%esp
80105138:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010513d:	eb 9b                	jmp    801050da <sys_link+0xda>
    end_op();
8010513f:	e8 8c df ff ff       	call   801030d0 <end_op>
    return -1;
80105144:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105149:	eb 8f                	jmp    801050da <sys_link+0xda>
8010514b:	90                   	nop
8010514c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105150 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	57                   	push   %edi
80105154:	56                   	push   %esi
80105155:	53                   	push   %ebx
80105156:	83 ec 1c             	sub    $0x1c,%esp
80105159:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010515c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105160:	76 3e                	jbe    801051a0 <isdirempty+0x50>
80105162:	bb 20 00 00 00       	mov    $0x20,%ebx
80105167:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010516a:	eb 0c                	jmp    80105178 <isdirempty+0x28>
8010516c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105170:	83 c3 10             	add    $0x10,%ebx
80105173:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105176:	73 28                	jae    801051a0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105178:	6a 10                	push   $0x10
8010517a:	53                   	push   %ebx
8010517b:	57                   	push   %edi
8010517c:	56                   	push   %esi
8010517d:	e8 8e c8 ff ff       	call   80101a10 <readi>
80105182:	83 c4 10             	add    $0x10,%esp
80105185:	83 f8 10             	cmp    $0x10,%eax
80105188:	75 23                	jne    801051ad <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010518a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010518f:	74 df                	je     80105170 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105191:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105194:	31 c0                	xor    %eax,%eax
}
80105196:	5b                   	pop    %ebx
80105197:	5e                   	pop    %esi
80105198:	5f                   	pop    %edi
80105199:	5d                   	pop    %ebp
8010519a:	c3                   	ret    
8010519b:	90                   	nop
8010519c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
801051a3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801051a8:	5b                   	pop    %ebx
801051a9:	5e                   	pop    %esi
801051aa:	5f                   	pop    %edi
801051ab:	5d                   	pop    %ebp
801051ac:	c3                   	ret    
      panic("isdirempty: readi");
801051ad:	83 ec 0c             	sub    $0xc,%esp
801051b0:	68 9c 7f 10 80       	push   $0x80107f9c
801051b5:	e8 d6 b1 ff ff       	call   80100390 <panic>
801051ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801051c0 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	57                   	push   %edi
801051c4:	56                   	push   %esi
801051c5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801051c6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801051c9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801051cc:	50                   	push   %eax
801051cd:	6a 00                	push   $0x0
801051cf:	e8 4c fb ff ff       	call   80104d20 <argstr>
801051d4:	83 c4 10             	add    $0x10,%esp
801051d7:	85 c0                	test   %eax,%eax
801051d9:	0f 88 51 01 00 00    	js     80105330 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
801051df:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801051e2:	e8 79 de ff ff       	call   80103060 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801051e7:	83 ec 08             	sub    $0x8,%esp
801051ea:	53                   	push   %ebx
801051eb:	ff 75 c0             	pushl  -0x40(%ebp)
801051ee:	e8 bd cd ff ff       	call   80101fb0 <nameiparent>
801051f3:	83 c4 10             	add    $0x10,%esp
801051f6:	85 c0                	test   %eax,%eax
801051f8:	89 c6                	mov    %eax,%esi
801051fa:	0f 84 37 01 00 00    	je     80105337 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105200:	83 ec 0c             	sub    $0xc,%esp
80105203:	50                   	push   %eax
80105204:	e8 27 c5 ff ff       	call   80101730 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105209:	58                   	pop    %eax
8010520a:	5a                   	pop    %edx
8010520b:	68 5d 79 10 80       	push   $0x8010795d
80105210:	53                   	push   %ebx
80105211:	e8 2a ca ff ff       	call   80101c40 <namecmp>
80105216:	83 c4 10             	add    $0x10,%esp
80105219:	85 c0                	test   %eax,%eax
8010521b:	0f 84 d7 00 00 00    	je     801052f8 <sys_unlink+0x138>
80105221:	83 ec 08             	sub    $0x8,%esp
80105224:	68 5c 79 10 80       	push   $0x8010795c
80105229:	53                   	push   %ebx
8010522a:	e8 11 ca ff ff       	call   80101c40 <namecmp>
8010522f:	83 c4 10             	add    $0x10,%esp
80105232:	85 c0                	test   %eax,%eax
80105234:	0f 84 be 00 00 00    	je     801052f8 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010523a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010523d:	83 ec 04             	sub    $0x4,%esp
80105240:	50                   	push   %eax
80105241:	53                   	push   %ebx
80105242:	56                   	push   %esi
80105243:	e8 18 ca ff ff       	call   80101c60 <dirlookup>
80105248:	83 c4 10             	add    $0x10,%esp
8010524b:	85 c0                	test   %eax,%eax
8010524d:	89 c3                	mov    %eax,%ebx
8010524f:	0f 84 a3 00 00 00    	je     801052f8 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105255:	83 ec 0c             	sub    $0xc,%esp
80105258:	50                   	push   %eax
80105259:	e8 d2 c4 ff ff       	call   80101730 <ilock>

  if(ip->nlink < 1)
8010525e:	83 c4 10             	add    $0x10,%esp
80105261:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105266:	0f 8e e4 00 00 00    	jle    80105350 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010526c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105271:	74 65                	je     801052d8 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105273:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105276:	83 ec 04             	sub    $0x4,%esp
80105279:	6a 10                	push   $0x10
8010527b:	6a 00                	push   $0x0
8010527d:	57                   	push   %edi
8010527e:	e8 ed f6 ff ff       	call   80104970 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105283:	6a 10                	push   $0x10
80105285:	ff 75 c4             	pushl  -0x3c(%ebp)
80105288:	57                   	push   %edi
80105289:	56                   	push   %esi
8010528a:	e8 81 c8 ff ff       	call   80101b10 <writei>
8010528f:	83 c4 20             	add    $0x20,%esp
80105292:	83 f8 10             	cmp    $0x10,%eax
80105295:	0f 85 a8 00 00 00    	jne    80105343 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010529b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052a0:	74 6e                	je     80105310 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801052a2:	83 ec 0c             	sub    $0xc,%esp
801052a5:	56                   	push   %esi
801052a6:	e8 15 c7 ff ff       	call   801019c0 <iunlockput>

  ip->nlink--;
801052ab:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052b0:	89 1c 24             	mov    %ebx,(%esp)
801052b3:	e8 c8 c3 ff ff       	call   80101680 <iupdate>
  iunlockput(ip);
801052b8:	89 1c 24             	mov    %ebx,(%esp)
801052bb:	e8 00 c7 ff ff       	call   801019c0 <iunlockput>

  end_op();
801052c0:	e8 0b de ff ff       	call   801030d0 <end_op>

  return 0;
801052c5:	83 c4 10             	add    $0x10,%esp
801052c8:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801052ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052cd:	5b                   	pop    %ebx
801052ce:	5e                   	pop    %esi
801052cf:	5f                   	pop    %edi
801052d0:	5d                   	pop    %ebp
801052d1:	c3                   	ret    
801052d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
801052d8:	83 ec 0c             	sub    $0xc,%esp
801052db:	53                   	push   %ebx
801052dc:	e8 6f fe ff ff       	call   80105150 <isdirempty>
801052e1:	83 c4 10             	add    $0x10,%esp
801052e4:	85 c0                	test   %eax,%eax
801052e6:	75 8b                	jne    80105273 <sys_unlink+0xb3>
    iunlockput(ip);
801052e8:	83 ec 0c             	sub    $0xc,%esp
801052eb:	53                   	push   %ebx
801052ec:	e8 cf c6 ff ff       	call   801019c0 <iunlockput>
    goto bad;
801052f1:	83 c4 10             	add    $0x10,%esp
801052f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801052f8:	83 ec 0c             	sub    $0xc,%esp
801052fb:	56                   	push   %esi
801052fc:	e8 bf c6 ff ff       	call   801019c0 <iunlockput>
  end_op();
80105301:	e8 ca dd ff ff       	call   801030d0 <end_op>
  return -1;
80105306:	83 c4 10             	add    $0x10,%esp
80105309:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010530e:	eb ba                	jmp    801052ca <sys_unlink+0x10a>
    dp->nlink--;
80105310:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105315:	83 ec 0c             	sub    $0xc,%esp
80105318:	56                   	push   %esi
80105319:	e8 62 c3 ff ff       	call   80101680 <iupdate>
8010531e:	83 c4 10             	add    $0x10,%esp
80105321:	e9 7c ff ff ff       	jmp    801052a2 <sys_unlink+0xe2>
80105326:	8d 76 00             	lea    0x0(%esi),%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105335:	eb 93                	jmp    801052ca <sys_unlink+0x10a>
    end_op();
80105337:	e8 94 dd ff ff       	call   801030d0 <end_op>
    return -1;
8010533c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105341:	eb 87                	jmp    801052ca <sys_unlink+0x10a>
    panic("unlink: writei");
80105343:	83 ec 0c             	sub    $0xc,%esp
80105346:	68 71 79 10 80       	push   $0x80107971
8010534b:	e8 40 b0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105350:	83 ec 0c             	sub    $0xc,%esp
80105353:	68 5f 79 10 80       	push   $0x8010795f
80105358:	e8 33 b0 ff ff       	call   80100390 <panic>
8010535d:	8d 76 00             	lea    0x0(%esi),%esi

80105360 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
80105365:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105366:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105369:	83 ec 34             	sub    $0x34,%esp
8010536c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010536f:	8b 55 10             	mov    0x10(%ebp),%edx
80105372:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105375:	56                   	push   %esi
80105376:	ff 75 08             	pushl  0x8(%ebp)
{
80105379:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010537c:	89 55 d0             	mov    %edx,-0x30(%ebp)
8010537f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105382:	e8 29 cc ff ff       	call   80101fb0 <nameiparent>
80105387:	83 c4 10             	add    $0x10,%esp
8010538a:	85 c0                	test   %eax,%eax
8010538c:	0f 84 4e 01 00 00    	je     801054e0 <create+0x180>
    return 0;
  ilock(dp);
80105392:	83 ec 0c             	sub    $0xc,%esp
80105395:	89 c3                	mov    %eax,%ebx
80105397:	50                   	push   %eax
80105398:	e8 93 c3 ff ff       	call   80101730 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
8010539d:	83 c4 0c             	add    $0xc,%esp
801053a0:	6a 00                	push   $0x0
801053a2:	56                   	push   %esi
801053a3:	53                   	push   %ebx
801053a4:	e8 b7 c8 ff ff       	call   80101c60 <dirlookup>
801053a9:	83 c4 10             	add    $0x10,%esp
801053ac:	85 c0                	test   %eax,%eax
801053ae:	89 c7                	mov    %eax,%edi
801053b0:	74 3e                	je     801053f0 <create+0x90>
    iunlockput(dp);
801053b2:	83 ec 0c             	sub    $0xc,%esp
801053b5:	53                   	push   %ebx
801053b6:	e8 05 c6 ff ff       	call   801019c0 <iunlockput>
    ilock(ip);
801053bb:	89 3c 24             	mov    %edi,(%esp)
801053be:	e8 6d c3 ff ff       	call   80101730 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801053c3:	83 c4 10             	add    $0x10,%esp
801053c6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801053cb:	0f 85 9f 00 00 00    	jne    80105470 <create+0x110>
801053d1:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801053d6:	0f 85 94 00 00 00    	jne    80105470 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801053dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053df:	89 f8                	mov    %edi,%eax
801053e1:	5b                   	pop    %ebx
801053e2:	5e                   	pop    %esi
801053e3:	5f                   	pop    %edi
801053e4:	5d                   	pop    %ebp
801053e5:	c3                   	ret    
801053e6:	8d 76 00             	lea    0x0(%esi),%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
801053f0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801053f4:	83 ec 08             	sub    $0x8,%esp
801053f7:	50                   	push   %eax
801053f8:	ff 33                	pushl  (%ebx)
801053fa:	e8 c1 c1 ff ff       	call   801015c0 <ialloc>
801053ff:	83 c4 10             	add    $0x10,%esp
80105402:	85 c0                	test   %eax,%eax
80105404:	89 c7                	mov    %eax,%edi
80105406:	0f 84 e8 00 00 00    	je     801054f4 <create+0x194>
  ilock(ip);
8010540c:	83 ec 0c             	sub    $0xc,%esp
8010540f:	50                   	push   %eax
80105410:	e8 1b c3 ff ff       	call   80101730 <ilock>
  ip->major = major;
80105415:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105419:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010541d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105421:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105425:	b8 01 00 00 00       	mov    $0x1,%eax
8010542a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010542e:	89 3c 24             	mov    %edi,(%esp)
80105431:	e8 4a c2 ff ff       	call   80101680 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105436:	83 c4 10             	add    $0x10,%esp
80105439:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010543e:	74 50                	je     80105490 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105440:	83 ec 04             	sub    $0x4,%esp
80105443:	ff 77 04             	pushl  0x4(%edi)
80105446:	56                   	push   %esi
80105447:	53                   	push   %ebx
80105448:	e8 83 ca ff ff       	call   80101ed0 <dirlink>
8010544d:	83 c4 10             	add    $0x10,%esp
80105450:	85 c0                	test   %eax,%eax
80105452:	0f 88 8f 00 00 00    	js     801054e7 <create+0x187>
  iunlockput(dp);
80105458:	83 ec 0c             	sub    $0xc,%esp
8010545b:	53                   	push   %ebx
8010545c:	e8 5f c5 ff ff       	call   801019c0 <iunlockput>
  return ip;
80105461:	83 c4 10             	add    $0x10,%esp
}
80105464:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105467:	89 f8                	mov    %edi,%eax
80105469:	5b                   	pop    %ebx
8010546a:	5e                   	pop    %esi
8010546b:	5f                   	pop    %edi
8010546c:	5d                   	pop    %ebp
8010546d:	c3                   	ret    
8010546e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105470:	83 ec 0c             	sub    $0xc,%esp
80105473:	57                   	push   %edi
    return 0;
80105474:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105476:	e8 45 c5 ff ff       	call   801019c0 <iunlockput>
    return 0;
8010547b:	83 c4 10             	add    $0x10,%esp
}
8010547e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105481:	89 f8                	mov    %edi,%eax
80105483:	5b                   	pop    %ebx
80105484:	5e                   	pop    %esi
80105485:	5f                   	pop    %edi
80105486:	5d                   	pop    %ebp
80105487:	c3                   	ret    
80105488:	90                   	nop
80105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105490:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105495:	83 ec 0c             	sub    $0xc,%esp
80105498:	53                   	push   %ebx
80105499:	e8 e2 c1 ff ff       	call   80101680 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010549e:	83 c4 0c             	add    $0xc,%esp
801054a1:	ff 77 04             	pushl  0x4(%edi)
801054a4:	68 5d 79 10 80       	push   $0x8010795d
801054a9:	57                   	push   %edi
801054aa:	e8 21 ca ff ff       	call   80101ed0 <dirlink>
801054af:	83 c4 10             	add    $0x10,%esp
801054b2:	85 c0                	test   %eax,%eax
801054b4:	78 1c                	js     801054d2 <create+0x172>
801054b6:	83 ec 04             	sub    $0x4,%esp
801054b9:	ff 73 04             	pushl  0x4(%ebx)
801054bc:	68 5c 79 10 80       	push   $0x8010795c
801054c1:	57                   	push   %edi
801054c2:	e8 09 ca ff ff       	call   80101ed0 <dirlink>
801054c7:	83 c4 10             	add    $0x10,%esp
801054ca:	85 c0                	test   %eax,%eax
801054cc:	0f 89 6e ff ff ff    	jns    80105440 <create+0xe0>
      panic("create dots");
801054d2:	83 ec 0c             	sub    $0xc,%esp
801054d5:	68 bd 7f 10 80       	push   $0x80107fbd
801054da:	e8 b1 ae ff ff       	call   80100390 <panic>
801054df:	90                   	nop
    return 0;
801054e0:	31 ff                	xor    %edi,%edi
801054e2:	e9 f5 fe ff ff       	jmp    801053dc <create+0x7c>
    panic("create: dirlink");
801054e7:	83 ec 0c             	sub    $0xc,%esp
801054ea:	68 c9 7f 10 80       	push   $0x80107fc9
801054ef:	e8 9c ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801054f4:	83 ec 0c             	sub    $0xc,%esp
801054f7:	68 ae 7f 10 80       	push   $0x80107fae
801054fc:	e8 8f ae ff ff       	call   80100390 <panic>
80105501:	eb 0d                	jmp    80105510 <sys_open>
80105503:	90                   	nop
80105504:	90                   	nop
80105505:	90                   	nop
80105506:	90                   	nop
80105507:	90                   	nop
80105508:	90                   	nop
80105509:	90                   	nop
8010550a:	90                   	nop
8010550b:	90                   	nop
8010550c:	90                   	nop
8010550d:	90                   	nop
8010550e:	90                   	nop
8010550f:	90                   	nop

80105510 <sys_open>:

int
sys_open(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	57                   	push   %edi
80105514:	56                   	push   %esi
80105515:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105516:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105519:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010551c:	50                   	push   %eax
8010551d:	6a 00                	push   $0x0
8010551f:	e8 fc f7 ff ff       	call   80104d20 <argstr>
80105524:	83 c4 10             	add    $0x10,%esp
80105527:	85 c0                	test   %eax,%eax
80105529:	0f 88 1d 01 00 00    	js     8010564c <sys_open+0x13c>
8010552f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105532:	83 ec 08             	sub    $0x8,%esp
80105535:	50                   	push   %eax
80105536:	6a 01                	push   $0x1
80105538:	e8 33 f7 ff ff       	call   80104c70 <argint>
8010553d:	83 c4 10             	add    $0x10,%esp
80105540:	85 c0                	test   %eax,%eax
80105542:	0f 88 04 01 00 00    	js     8010564c <sys_open+0x13c>
    return -1;

  begin_op();
80105548:	e8 13 db ff ff       	call   80103060 <begin_op>

  if(omode & O_CREATE){
8010554d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105551:	0f 85 a9 00 00 00    	jne    80105600 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105557:	83 ec 0c             	sub    $0xc,%esp
8010555a:	ff 75 e0             	pushl  -0x20(%ebp)
8010555d:	e8 2e ca ff ff       	call   80101f90 <namei>
80105562:	83 c4 10             	add    $0x10,%esp
80105565:	85 c0                	test   %eax,%eax
80105567:	89 c6                	mov    %eax,%esi
80105569:	0f 84 ac 00 00 00    	je     8010561b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
8010556f:	83 ec 0c             	sub    $0xc,%esp
80105572:	50                   	push   %eax
80105573:	e8 b8 c1 ff ff       	call   80101730 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105578:	83 c4 10             	add    $0x10,%esp
8010557b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105580:	0f 84 aa 00 00 00    	je     80105630 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105586:	e8 a5 b8 ff ff       	call   80100e30 <filealloc>
8010558b:	85 c0                	test   %eax,%eax
8010558d:	89 c7                	mov    %eax,%edi
8010558f:	0f 84 a6 00 00 00    	je     8010563b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105595:	e8 16 e7 ff ff       	call   80103cb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010559a:	31 db                	xor    %ebx,%ebx
8010559c:	eb 0e                	jmp    801055ac <sys_open+0x9c>
8010559e:	66 90                	xchg   %ax,%ax
801055a0:	83 c3 01             	add    $0x1,%ebx
801055a3:	83 fb 10             	cmp    $0x10,%ebx
801055a6:	0f 84 ac 00 00 00    	je     80105658 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801055ac:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055b0:	85 d2                	test   %edx,%edx
801055b2:	75 ec                	jne    801055a0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055b4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801055b7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801055bb:	56                   	push   %esi
801055bc:	e8 4f c2 ff ff       	call   80101810 <iunlock>
  end_op();
801055c1:	e8 0a db ff ff       	call   801030d0 <end_op>

  f->type = FD_INODE;
801055c6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055cf:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055d2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801055d5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801055dc:	89 d0                	mov    %edx,%eax
801055de:	f7 d0                	not    %eax
801055e0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055e3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055e6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055e9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801055ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055f0:	89 d8                	mov    %ebx,%eax
801055f2:	5b                   	pop    %ebx
801055f3:	5e                   	pop    %esi
801055f4:	5f                   	pop    %edi
801055f5:	5d                   	pop    %ebp
801055f6:	c3                   	ret    
801055f7:	89 f6                	mov    %esi,%esi
801055f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105600:	6a 00                	push   $0x0
80105602:	6a 00                	push   $0x0
80105604:	6a 02                	push   $0x2
80105606:	ff 75 e0             	pushl  -0x20(%ebp)
80105609:	e8 52 fd ff ff       	call   80105360 <create>
    if(ip == 0){
8010560e:	83 c4 10             	add    $0x10,%esp
80105611:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105613:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105615:	0f 85 6b ff ff ff    	jne    80105586 <sys_open+0x76>
      end_op();
8010561b:	e8 b0 da ff ff       	call   801030d0 <end_op>
      return -1;
80105620:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105625:	eb c6                	jmp    801055ed <sys_open+0xdd>
80105627:	89 f6                	mov    %esi,%esi
80105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105630:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105633:	85 c9                	test   %ecx,%ecx
80105635:	0f 84 4b ff ff ff    	je     80105586 <sys_open+0x76>
    iunlockput(ip);
8010563b:	83 ec 0c             	sub    $0xc,%esp
8010563e:	56                   	push   %esi
8010563f:	e8 7c c3 ff ff       	call   801019c0 <iunlockput>
    end_op();
80105644:	e8 87 da ff ff       	call   801030d0 <end_op>
    return -1;
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105651:	eb 9a                	jmp    801055ed <sys_open+0xdd>
80105653:	90                   	nop
80105654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105658:	83 ec 0c             	sub    $0xc,%esp
8010565b:	57                   	push   %edi
8010565c:	e8 8f b8 ff ff       	call   80100ef0 <fileclose>
80105661:	83 c4 10             	add    $0x10,%esp
80105664:	eb d5                	jmp    8010563b <sys_open+0x12b>
80105666:	8d 76 00             	lea    0x0(%esi),%esi
80105669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105670 <sys_mkdir>:

int
sys_mkdir(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105676:	e8 e5 d9 ff ff       	call   80103060 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010567b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010567e:	83 ec 08             	sub    $0x8,%esp
80105681:	50                   	push   %eax
80105682:	6a 00                	push   $0x0
80105684:	e8 97 f6 ff ff       	call   80104d20 <argstr>
80105689:	83 c4 10             	add    $0x10,%esp
8010568c:	85 c0                	test   %eax,%eax
8010568e:	78 30                	js     801056c0 <sys_mkdir+0x50>
80105690:	6a 00                	push   $0x0
80105692:	6a 00                	push   $0x0
80105694:	6a 01                	push   $0x1
80105696:	ff 75 f4             	pushl  -0xc(%ebp)
80105699:	e8 c2 fc ff ff       	call   80105360 <create>
8010569e:	83 c4 10             	add    $0x10,%esp
801056a1:	85 c0                	test   %eax,%eax
801056a3:	74 1b                	je     801056c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056a5:	83 ec 0c             	sub    $0xc,%esp
801056a8:	50                   	push   %eax
801056a9:	e8 12 c3 ff ff       	call   801019c0 <iunlockput>
  end_op();
801056ae:	e8 1d da ff ff       	call   801030d0 <end_op>
  return 0;
801056b3:	83 c4 10             	add    $0x10,%esp
801056b6:	31 c0                	xor    %eax,%eax
}
801056b8:	c9                   	leave  
801056b9:	c3                   	ret    
801056ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
801056c0:	e8 0b da ff ff       	call   801030d0 <end_op>
    return -1;
801056c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ca:	c9                   	leave  
801056cb:	c3                   	ret    
801056cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056d0 <sys_mknod>:

int
sys_mknod(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801056d6:	e8 85 d9 ff ff       	call   80103060 <begin_op>
  if((argstr(0, &path)) < 0 ||
801056db:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056de:	83 ec 08             	sub    $0x8,%esp
801056e1:	50                   	push   %eax
801056e2:	6a 00                	push   $0x0
801056e4:	e8 37 f6 ff ff       	call   80104d20 <argstr>
801056e9:	83 c4 10             	add    $0x10,%esp
801056ec:	85 c0                	test   %eax,%eax
801056ee:	78 60                	js     80105750 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801056f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056f3:	83 ec 08             	sub    $0x8,%esp
801056f6:	50                   	push   %eax
801056f7:	6a 01                	push   $0x1
801056f9:	e8 72 f5 ff ff       	call   80104c70 <argint>
  if((argstr(0, &path)) < 0 ||
801056fe:	83 c4 10             	add    $0x10,%esp
80105701:	85 c0                	test   %eax,%eax
80105703:	78 4b                	js     80105750 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105705:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105708:	83 ec 08             	sub    $0x8,%esp
8010570b:	50                   	push   %eax
8010570c:	6a 02                	push   $0x2
8010570e:	e8 5d f5 ff ff       	call   80104c70 <argint>
     argint(1, &major) < 0 ||
80105713:	83 c4 10             	add    $0x10,%esp
80105716:	85 c0                	test   %eax,%eax
80105718:	78 36                	js     80105750 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010571a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010571e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
8010571f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105723:	50                   	push   %eax
80105724:	6a 03                	push   $0x3
80105726:	ff 75 ec             	pushl  -0x14(%ebp)
80105729:	e8 32 fc ff ff       	call   80105360 <create>
8010572e:	83 c4 10             	add    $0x10,%esp
80105731:	85 c0                	test   %eax,%eax
80105733:	74 1b                	je     80105750 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105735:	83 ec 0c             	sub    $0xc,%esp
80105738:	50                   	push   %eax
80105739:	e8 82 c2 ff ff       	call   801019c0 <iunlockput>
  end_op();
8010573e:	e8 8d d9 ff ff       	call   801030d0 <end_op>
  return 0;
80105743:	83 c4 10             	add    $0x10,%esp
80105746:	31 c0                	xor    %eax,%eax
}
80105748:	c9                   	leave  
80105749:	c3                   	ret    
8010574a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105750:	e8 7b d9 ff ff       	call   801030d0 <end_op>
    return -1;
80105755:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010575a:	c9                   	leave  
8010575b:	c3                   	ret    
8010575c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105760 <sys_chdir>:

int
sys_chdir(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	56                   	push   %esi
80105764:	53                   	push   %ebx
80105765:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105768:	e8 43 e5 ff ff       	call   80103cb0 <myproc>
8010576d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010576f:	e8 ec d8 ff ff       	call   80103060 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105774:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105777:	83 ec 08             	sub    $0x8,%esp
8010577a:	50                   	push   %eax
8010577b:	6a 00                	push   $0x0
8010577d:	e8 9e f5 ff ff       	call   80104d20 <argstr>
80105782:	83 c4 10             	add    $0x10,%esp
80105785:	85 c0                	test   %eax,%eax
80105787:	78 77                	js     80105800 <sys_chdir+0xa0>
80105789:	83 ec 0c             	sub    $0xc,%esp
8010578c:	ff 75 f4             	pushl  -0xc(%ebp)
8010578f:	e8 fc c7 ff ff       	call   80101f90 <namei>
80105794:	83 c4 10             	add    $0x10,%esp
80105797:	85 c0                	test   %eax,%eax
80105799:	89 c3                	mov    %eax,%ebx
8010579b:	74 63                	je     80105800 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010579d:	83 ec 0c             	sub    $0xc,%esp
801057a0:	50                   	push   %eax
801057a1:	e8 8a bf ff ff       	call   80101730 <ilock>
  if(ip->type != T_DIR){
801057a6:	83 c4 10             	add    $0x10,%esp
801057a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057ae:	75 30                	jne    801057e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	53                   	push   %ebx
801057b4:	e8 57 c0 ff ff       	call   80101810 <iunlock>
  iput(curproc->cwd);
801057b9:	58                   	pop    %eax
801057ba:	ff 76 68             	pushl  0x68(%esi)
801057bd:	e8 9e c0 ff ff       	call   80101860 <iput>
  end_op();
801057c2:	e8 09 d9 ff ff       	call   801030d0 <end_op>
  curproc->cwd = ip;
801057c7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801057ca:	83 c4 10             	add    $0x10,%esp
801057cd:	31 c0                	xor    %eax,%eax
}
801057cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057d2:	5b                   	pop    %ebx
801057d3:	5e                   	pop    %esi
801057d4:	5d                   	pop    %ebp
801057d5:	c3                   	ret    
801057d6:	8d 76 00             	lea    0x0(%esi),%esi
801057d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801057e0:	83 ec 0c             	sub    $0xc,%esp
801057e3:	53                   	push   %ebx
801057e4:	e8 d7 c1 ff ff       	call   801019c0 <iunlockput>
    end_op();
801057e9:	e8 e2 d8 ff ff       	call   801030d0 <end_op>
    return -1;
801057ee:	83 c4 10             	add    $0x10,%esp
801057f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f6:	eb d7                	jmp    801057cf <sys_chdir+0x6f>
801057f8:	90                   	nop
801057f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105800:	e8 cb d8 ff ff       	call   801030d0 <end_op>
    return -1;
80105805:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580a:	eb c3                	jmp    801057cf <sys_chdir+0x6f>
8010580c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105810 <sys_exec>:

int
sys_exec(void)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	57                   	push   %edi
80105814:	56                   	push   %esi
80105815:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105816:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010581c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105822:	50                   	push   %eax
80105823:	6a 00                	push   $0x0
80105825:	e8 f6 f4 ff ff       	call   80104d20 <argstr>
8010582a:	83 c4 10             	add    $0x10,%esp
8010582d:	85 c0                	test   %eax,%eax
8010582f:	0f 88 87 00 00 00    	js     801058bc <sys_exec+0xac>
80105835:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010583b:	83 ec 08             	sub    $0x8,%esp
8010583e:	50                   	push   %eax
8010583f:	6a 01                	push   $0x1
80105841:	e8 2a f4 ff ff       	call   80104c70 <argint>
80105846:	83 c4 10             	add    $0x10,%esp
80105849:	85 c0                	test   %eax,%eax
8010584b:	78 6f                	js     801058bc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010584d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105853:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105856:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105858:	68 80 00 00 00       	push   $0x80
8010585d:	6a 00                	push   $0x0
8010585f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105865:	50                   	push   %eax
80105866:	e8 05 f1 ff ff       	call   80104970 <memset>
8010586b:	83 c4 10             	add    $0x10,%esp
8010586e:	eb 2c                	jmp    8010589c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105870:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105876:	85 c0                	test   %eax,%eax
80105878:	74 56                	je     801058d0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010587a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105880:	83 ec 08             	sub    $0x8,%esp
80105883:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105886:	52                   	push   %edx
80105887:	50                   	push   %eax
80105888:	e8 73 f3 ff ff       	call   80104c00 <fetchstr>
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	85 c0                	test   %eax,%eax
80105892:	78 28                	js     801058bc <sys_exec+0xac>
  for(i=0;; i++){
80105894:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105897:	83 fb 20             	cmp    $0x20,%ebx
8010589a:	74 20                	je     801058bc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010589c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801058a2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801058a9:	83 ec 08             	sub    $0x8,%esp
801058ac:	57                   	push   %edi
801058ad:	01 f0                	add    %esi,%eax
801058af:	50                   	push   %eax
801058b0:	e8 0b f3 ff ff       	call   80104bc0 <fetchint>
801058b5:	83 c4 10             	add    $0x10,%esp
801058b8:	85 c0                	test   %eax,%eax
801058ba:	79 b4                	jns    80105870 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801058bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801058bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058c4:	5b                   	pop    %ebx
801058c5:	5e                   	pop    %esi
801058c6:	5f                   	pop    %edi
801058c7:	5d                   	pop    %ebp
801058c8:	c3                   	ret    
801058c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801058d0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801058d6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801058d9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801058e0:	00 00 00 00 
  return exec(path, argv);
801058e4:	50                   	push   %eax
801058e5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801058eb:	e8 c0 b1 ff ff       	call   80100ab0 <exec>
801058f0:	83 c4 10             	add    $0x10,%esp
}
801058f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058f6:	5b                   	pop    %ebx
801058f7:	5e                   	pop    %esi
801058f8:	5f                   	pop    %edi
801058f9:	5d                   	pop    %ebp
801058fa:	c3                   	ret    
801058fb:	90                   	nop
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105900 <sys_pipe>:

int
sys_pipe(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	57                   	push   %edi
80105904:	56                   	push   %esi
80105905:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105906:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105909:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010590c:	6a 08                	push   $0x8
8010590e:	50                   	push   %eax
8010590f:	6a 00                	push   $0x0
80105911:	e8 aa f3 ff ff       	call   80104cc0 <argptr>
80105916:	83 c4 10             	add    $0x10,%esp
80105919:	85 c0                	test   %eax,%eax
8010591b:	0f 88 ae 00 00 00    	js     801059cf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105921:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105924:	83 ec 08             	sub    $0x8,%esp
80105927:	50                   	push   %eax
80105928:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010592b:	50                   	push   %eax
8010592c:	e8 cf dd ff ff       	call   80103700 <pipealloc>
80105931:	83 c4 10             	add    $0x10,%esp
80105934:	85 c0                	test   %eax,%eax
80105936:	0f 88 93 00 00 00    	js     801059cf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010593c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010593f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105941:	e8 6a e3 ff ff       	call   80103cb0 <myproc>
80105946:	eb 10                	jmp    80105958 <sys_pipe+0x58>
80105948:	90                   	nop
80105949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105950:	83 c3 01             	add    $0x1,%ebx
80105953:	83 fb 10             	cmp    $0x10,%ebx
80105956:	74 60                	je     801059b8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105958:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010595c:	85 f6                	test   %esi,%esi
8010595e:	75 f0                	jne    80105950 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105960:	8d 73 08             	lea    0x8(%ebx),%esi
80105963:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105967:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010596a:	e8 41 e3 ff ff       	call   80103cb0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010596f:	31 d2                	xor    %edx,%edx
80105971:	eb 0d                	jmp    80105980 <sys_pipe+0x80>
80105973:	90                   	nop
80105974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105978:	83 c2 01             	add    $0x1,%edx
8010597b:	83 fa 10             	cmp    $0x10,%edx
8010597e:	74 28                	je     801059a8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105980:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105984:	85 c9                	test   %ecx,%ecx
80105986:	75 f0                	jne    80105978 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105988:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010598c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010598f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105991:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105994:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105997:	31 c0                	xor    %eax,%eax
}
80105999:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010599c:	5b                   	pop    %ebx
8010599d:	5e                   	pop    %esi
8010599e:	5f                   	pop    %edi
8010599f:	5d                   	pop    %ebp
801059a0:	c3                   	ret    
801059a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801059a8:	e8 03 e3 ff ff       	call   80103cb0 <myproc>
801059ad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801059b4:	00 
801059b5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801059b8:	83 ec 0c             	sub    $0xc,%esp
801059bb:	ff 75 e0             	pushl  -0x20(%ebp)
801059be:	e8 2d b5 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
801059c3:	58                   	pop    %eax
801059c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801059c7:	e8 24 b5 ff ff       	call   80100ef0 <fileclose>
    return -1;
801059cc:	83 c4 10             	add    $0x10,%esp
801059cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059d4:	eb c3                	jmp    80105999 <sys_pipe+0x99>
801059d6:	66 90                	xchg   %ax,%ax
801059d8:	66 90                	xchg   %ax,%ax
801059da:	66 90                	xchg   %ax,%ax
801059dc:	66 90                	xchg   %ax,%ax
801059de:	66 90                	xchg   %ax,%ax

801059e0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801059e3:	5d                   	pop    %ebp
  return fork();
801059e4:	e9 97 e4 ff ff       	jmp    80103e80 <fork>
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_exit>:

int
sys_exit(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059f6:	e8 05 e7 ff ff       	call   80104100 <exit>
  return 0;  // not reached
}
801059fb:	31 c0                	xor    %eax,%eax
801059fd:	c9                   	leave  
801059fe:	c3                   	ret    
801059ff:	90                   	nop

80105a00 <sys_wait>:

int
sys_wait(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105a03:	5d                   	pop    %ebp
  return wait();
80105a04:	e9 37 e9 ff ff       	jmp    80104340 <wait>
80105a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a10 <sys_kill>:

int
sys_kill(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a19:	50                   	push   %eax
80105a1a:	6a 00                	push   $0x0
80105a1c:	e8 4f f2 ff ff       	call   80104c70 <argint>
80105a21:	83 c4 10             	add    $0x10,%esp
80105a24:	85 c0                	test   %eax,%eax
80105a26:	78 18                	js     80105a40 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a28:	83 ec 0c             	sub    $0xc,%esp
80105a2b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a2e:	e8 6d ea ff ff       	call   801044a0 <kill>
80105a33:	83 c4 10             	add    $0x10,%esp
}
80105a36:	c9                   	leave  
80105a37:	c3                   	ret    
80105a38:	90                   	nop
80105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a45:	c9                   	leave  
80105a46:	c3                   	ret    
80105a47:	89 f6                	mov    %esi,%esi
80105a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a50 <sys_getpid>:

int
sys_getpid(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a56:	e8 55 e2 ff ff       	call   80103cb0 <myproc>
80105a5b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a5e:	c9                   	leave  
80105a5f:	c3                   	ret    

80105a60 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a64:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a67:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a6a:	50                   	push   %eax
80105a6b:	6a 00                	push   $0x0
80105a6d:	e8 fe f1 ff ff       	call   80104c70 <argint>
80105a72:	83 c4 10             	add    $0x10,%esp
80105a75:	85 c0                	test   %eax,%eax
80105a77:	78 27                	js     80105aa0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a79:	e8 32 e2 ff ff       	call   80103cb0 <myproc>
  if(growproc(n) < 0)
80105a7e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a81:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a83:	ff 75 f4             	pushl  -0xc(%ebp)
80105a86:	e8 45 e3 ff ff       	call   80103dd0 <growproc>
80105a8b:	83 c4 10             	add    $0x10,%esp
80105a8e:	85 c0                	test   %eax,%eax
80105a90:	78 0e                	js     80105aa0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a92:	89 d8                	mov    %ebx,%eax
80105a94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a97:	c9                   	leave  
80105a98:	c3                   	ret    
80105a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105aa0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105aa5:	eb eb                	jmp    80105a92 <sys_sbrk+0x32>
80105aa7:	89 f6                	mov    %esi,%esi
80105aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ab0 <sys_sleep>:

int
sys_sleep(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ab4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ab7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105aba:	50                   	push   %eax
80105abb:	6a 00                	push   $0x0
80105abd:	e8 ae f1 ff ff       	call   80104c70 <argint>
80105ac2:	83 c4 10             	add    $0x10,%esp
80105ac5:	85 c0                	test   %eax,%eax
80105ac7:	0f 88 8a 00 00 00    	js     80105b57 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105acd:	83 ec 0c             	sub    $0xc,%esp
80105ad0:	68 e0 11 13 80       	push   $0x801311e0
80105ad5:	e8 86 ed ff ff       	call   80104860 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105ada:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105add:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105ae0:	8b 1d 20 1a 13 80    	mov    0x80131a20,%ebx
  while(ticks - ticks0 < n){
80105ae6:	85 d2                	test   %edx,%edx
80105ae8:	75 27                	jne    80105b11 <sys_sleep+0x61>
80105aea:	eb 54                	jmp    80105b40 <sys_sleep+0x90>
80105aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105af0:	83 ec 08             	sub    $0x8,%esp
80105af3:	68 e0 11 13 80       	push   $0x801311e0
80105af8:	68 20 1a 13 80       	push   $0x80131a20
80105afd:	e8 7e e7 ff ff       	call   80104280 <sleep>
  while(ticks - ticks0 < n){
80105b02:	a1 20 1a 13 80       	mov    0x80131a20,%eax
80105b07:	83 c4 10             	add    $0x10,%esp
80105b0a:	29 d8                	sub    %ebx,%eax
80105b0c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b0f:	73 2f                	jae    80105b40 <sys_sleep+0x90>
    if(myproc()->killed){
80105b11:	e8 9a e1 ff ff       	call   80103cb0 <myproc>
80105b16:	8b 40 24             	mov    0x24(%eax),%eax
80105b19:	85 c0                	test   %eax,%eax
80105b1b:	74 d3                	je     80105af0 <sys_sleep+0x40>
      release(&tickslock);
80105b1d:	83 ec 0c             	sub    $0xc,%esp
80105b20:	68 e0 11 13 80       	push   $0x801311e0
80105b25:	e8 f6 ed ff ff       	call   80104920 <release>
      return -1;
80105b2a:	83 c4 10             	add    $0x10,%esp
80105b2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105b32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b35:	c9                   	leave  
80105b36:	c3                   	ret    
80105b37:	89 f6                	mov    %esi,%esi
80105b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105b40:	83 ec 0c             	sub    $0xc,%esp
80105b43:	68 e0 11 13 80       	push   $0x801311e0
80105b48:	e8 d3 ed ff ff       	call   80104920 <release>
  return 0;
80105b4d:	83 c4 10             	add    $0x10,%esp
80105b50:	31 c0                	xor    %eax,%eax
}
80105b52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b55:	c9                   	leave  
80105b56:	c3                   	ret    
    return -1;
80105b57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5c:	eb f4                	jmp    80105b52 <sys_sleep+0xa2>
80105b5e:	66 90                	xchg   %ax,%ax

80105b60 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	53                   	push   %ebx
80105b64:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b67:	68 e0 11 13 80       	push   $0x801311e0
80105b6c:	e8 ef ec ff ff       	call   80104860 <acquire>
  xticks = ticks;
80105b71:	8b 1d 20 1a 13 80    	mov    0x80131a20,%ebx
  release(&tickslock);
80105b77:	c7 04 24 e0 11 13 80 	movl   $0x801311e0,(%esp)
80105b7e:	e8 9d ed ff ff       	call   80104920 <release>
  return xticks;
}
80105b83:	89 d8                	mov    %ebx,%eax
80105b85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b88:	c9                   	leave  
80105b89:	c3                   	ret    
80105b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b90 <sys_get_number_of_free_pages>:

int sys_get_number_of_free_pages(void){
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
  return sys_get_number_of_free_pages_impl();
}
80105b93:	5d                   	pop    %ebp
  return sys_get_number_of_free_pages_impl();
80105b94:	e9 b7 e2 ff ff       	jmp    80103e50 <sys_get_number_of_free_pages_impl>

80105b99 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b99:	1e                   	push   %ds
  pushl %es
80105b9a:	06                   	push   %es
  pushl %fs
80105b9b:	0f a0                	push   %fs
  pushl %gs
80105b9d:	0f a8                	push   %gs
  pushal
80105b9f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ba0:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105ba4:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ba6:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ba8:	54                   	push   %esp
  call trap
80105ba9:	e8 c2 00 00 00       	call   80105c70 <trap>
  addl $4, %esp
80105bae:	83 c4 04             	add    $0x4,%esp

80105bb1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105bb1:	61                   	popa   
  popl %gs
80105bb2:	0f a9                	pop    %gs
  popl %fs
80105bb4:	0f a1                	pop    %fs
  popl %es
80105bb6:	07                   	pop    %es
  popl %ds
80105bb7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105bb8:	83 c4 08             	add    $0x8,%esp
  iret
80105bbb:	cf                   	iret   
80105bbc:	66 90                	xchg   %ax,%ax
80105bbe:	66 90                	xchg   %ax,%ax

80105bc0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105bc0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105bc1:	31 c0                	xor    %eax,%eax
{
80105bc3:	89 e5                	mov    %esp,%ebp
80105bc5:	83 ec 08             	sub    $0x8,%esp
80105bc8:	90                   	nop
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105bd0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105bd7:	c7 04 c5 22 12 13 80 	movl   $0x8e000008,-0x7fecedde(,%eax,8)
80105bde:	08 00 00 8e 
80105be2:	66 89 14 c5 20 12 13 	mov    %dx,-0x7fecede0(,%eax,8)
80105be9:	80 
80105bea:	c1 ea 10             	shr    $0x10,%edx
80105bed:	66 89 14 c5 26 12 13 	mov    %dx,-0x7fecedda(,%eax,8)
80105bf4:	80 
  for(i = 0; i < 256; i++)
80105bf5:	83 c0 01             	add    $0x1,%eax
80105bf8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bfd:	75 d1                	jne    80105bd0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bff:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105c04:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c07:	c7 05 22 14 13 80 08 	movl   $0xef000008,0x80131422
80105c0e:	00 00 ef 
  initlock(&tickslock, "time");
80105c11:	68 d9 7f 10 80       	push   $0x80107fd9
80105c16:	68 e0 11 13 80       	push   $0x801311e0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c1b:	66 a3 20 14 13 80    	mov    %ax,0x80131420
80105c21:	c1 e8 10             	shr    $0x10,%eax
80105c24:	66 a3 26 14 13 80    	mov    %ax,0x80131426
  initlock(&tickslock, "time");
80105c2a:	e8 f1 ea ff ff       	call   80104720 <initlock>
}
80105c2f:	83 c4 10             	add    $0x10,%esp
80105c32:	c9                   	leave  
80105c33:	c3                   	ret    
80105c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105c40 <idtinit>:

void
idtinit(void)
{
80105c40:	55                   	push   %ebp
  pd[0] = size-1;
80105c41:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c46:	89 e5                	mov    %esp,%ebp
80105c48:	83 ec 10             	sub    $0x10,%esp
80105c4b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c4f:	b8 20 12 13 80       	mov    $0x80131220,%eax
80105c54:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c58:	c1 e8 10             	shr    $0x10,%eax
80105c5b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c5f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c62:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c65:	c9                   	leave  
80105c66:	c3                   	ret    
80105c67:	89 f6                	mov    %esi,%esi
80105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c70 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	57                   	push   %edi
80105c74:	56                   	push   %esi
80105c75:	53                   	push   %ebx
80105c76:	83 ec 2c             	sub    $0x2c,%esp
80105c79:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105c7c:	8b 47 30             	mov    0x30(%edi),%eax
80105c7f:	83 f8 40             	cmp    $0x40,%eax
80105c82:	0f 84 78 01 00 00    	je     80105e00 <trap+0x190>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c88:	83 e8 0e             	sub    $0xe,%eax
80105c8b:	83 f8 31             	cmp    $0x31,%eax
80105c8e:	0f 87 99 00 00 00    	ja     80105d2d <trap+0xbd>
80105c94:	ff 24 85 00 81 10 80 	jmp    *-0x7fef7f00(,%eax,4)
80105c9b:	90                   	nop
80105c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105ca0:	0f 20 d6             	mov    %cr2,%esi
    break;

  case T_PGFLT:
  ;//verify none includes cow
    uint faulting_addr = rcr2();
    struct proc* p = myproc();
80105ca3:	e8 08 e0 ff ff       	call   80103cb0 <myproc>
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80105ca8:	83 ec 04             	sub    $0x4,%esp
    struct proc* p = myproc();
80105cab:	89 c3                	mov    %eax,%ebx
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80105cad:	6a 00                	push   $0x0
80105caf:	56                   	push   %esi
80105cb0:	ff 70 04             	pushl  0x4(%eax)
80105cb3:	e8 38 13 00 00       	call   80106ff0 <public_walkpgdir>
      }
      p->num_of_pagefaults_occurs++;
      return;
    }
    #endif
    if (!(pte_ptr == 0) && *pte_ptr & PTE_COW){
80105cb8:	83 c4 10             	add    $0x10,%esp
80105cbb:	85 c0                	test   %eax,%eax
80105cbd:	0f 84 d5 02 00 00    	je     80105f98 <trap+0x328>
80105cc3:	8b 10                	mov    (%eax),%edx
80105cc5:	f6 c6 08             	test   $0x8,%dh
80105cc8:	0f 85 5a 02 00 00    	jne    80105f28 <trap+0x2b8>
      }
      else{
        panic("ref count to page is 0 but it was reffed");
      }
    }
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cce:	8b 4b 10             	mov    0x10(%ebx),%ecx
80105cd1:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105cd4:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80105cd7:	0f 20 d0             	mov    %cr2,%eax
80105cda:	8b 5f 38             	mov    0x38(%edi),%ebx
80105cdd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80105ce0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80105ce3:	e8 a8 df ff ff       	call   80103c90 <cpuid>
80105ce8:	8b 4f 34             	mov    0x34(%edi),%ecx
80105ceb:	89 c6                	mov    %eax,%esi
80105ced:	8b 5f 30             	mov    0x30(%edi),%ebx
80105cf0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
            "eip 0x%x addr 0x%x pte %x pid %d --kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105cf3:	e8 b8 df ff ff       	call   80103cb0 <myproc>
80105cf8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105cfb:	e8 b0 df ff ff       	call   80103cb0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d00:	8b 55 d0             	mov    -0x30(%ebp),%edx
80105d03:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80105d06:	83 ec 08             	sub    $0x8,%esp
80105d09:	51                   	push   %ecx
80105d0a:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105d0b:	8b 55 dc             	mov    -0x24(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d0e:	ff 75 d8             	pushl  -0x28(%ebp)
80105d11:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d14:	56                   	push   %esi
80105d15:	ff 75 e0             	pushl  -0x20(%ebp)
80105d18:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
80105d19:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d1c:	52                   	push   %edx
80105d1d:	ff 70 10             	pushl  0x10(%eax)
80105d20:	68 34 80 10 80       	push   $0x80108034
80105d25:	e8 36 a9 ff ff       	call   80100660 <cprintf>
80105d2a:	83 c4 30             	add    $0x30,%esp
            tf->err, cpuid(), tf->eip, rcr2(), *pte_ptr, p->pid);
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d2d:	e8 7e df ff ff       	call   80103cb0 <myproc>
80105d32:	85 c0                	test   %eax,%eax
80105d34:	8b 5f 38             	mov    0x38(%edi),%ebx
80105d37:	0f 84 85 02 00 00    	je     80105fc2 <trap+0x352>
80105d3d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105d41:	0f 84 7b 02 00 00    	je     80105fc2 <trap+0x352>
80105d47:	0f 20 d1             	mov    %cr2,%ecx
80105d4a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d4d:	e8 3e df ff ff       	call   80103c90 <cpuid>
80105d52:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d55:	8b 47 34             	mov    0x34(%edi),%eax
80105d58:	8b 77 30             	mov    0x30(%edi),%esi
80105d5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105d5e:	e8 4d df ff ff       	call   80103cb0 <myproc>
80105d63:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d66:	e8 45 df ff ff       	call   80103cb0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d6b:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d71:	51                   	push   %ecx
80105d72:	53                   	push   %ebx
80105d73:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105d74:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d77:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d7a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d7b:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d7e:	52                   	push   %edx
80105d7f:	ff 70 10             	pushl  0x10(%eax)
80105d82:	68 bc 80 10 80       	push   $0x801080bc
80105d87:	e8 d4 a8 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105d8c:	83 c4 20             	add    $0x20,%esp
80105d8f:	e8 1c df ff ff       	call   80103cb0 <myproc>
80105d94:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d9b:	e8 10 df ff ff       	call   80103cb0 <myproc>
80105da0:	85 c0                	test   %eax,%eax
80105da2:	74 1d                	je     80105dc1 <trap+0x151>
80105da4:	e8 07 df ff ff       	call   80103cb0 <myproc>
80105da9:	8b 50 24             	mov    0x24(%eax),%edx
80105dac:	85 d2                	test   %edx,%edx
80105dae:	74 11                	je     80105dc1 <trap+0x151>
80105db0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105db4:	83 e0 03             	and    $0x3,%eax
80105db7:	66 83 f8 03          	cmp    $0x3,%ax
80105dbb:	0f 84 1f 01 00 00    	je     80105ee0 <trap+0x270>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80105dc1:	e8 ea de ff ff       	call   80103cb0 <myproc>
80105dc6:	85 c0                	test   %eax,%eax
80105dc8:	74 0b                	je     80105dd5 <trap+0x165>
80105dca:	e8 e1 de ff ff       	call   80103cb0 <myproc>
80105dcf:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105dd3:	74 63                	je     80105e38 <trap+0x1c8>
      yield();
    }
    

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dd5:	e8 d6 de ff ff       	call   80103cb0 <myproc>
80105dda:	85 c0                	test   %eax,%eax
80105ddc:	74 19                	je     80105df7 <trap+0x187>
80105dde:	e8 cd de ff ff       	call   80103cb0 <myproc>
80105de3:	8b 40 24             	mov    0x24(%eax),%eax
80105de6:	85 c0                	test   %eax,%eax
80105de8:	74 0d                	je     80105df7 <trap+0x187>
80105dea:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105dee:	83 e0 03             	and    $0x3,%eax
80105df1:	66 83 f8 03          	cmp    $0x3,%ax
80105df5:	74 32                	je     80105e29 <trap+0x1b9>
    exit();
}
80105df7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dfa:	5b                   	pop    %ebx
80105dfb:	5e                   	pop    %esi
80105dfc:	5f                   	pop    %edi
80105dfd:	5d                   	pop    %ebp
80105dfe:	c3                   	ret    
80105dff:	90                   	nop
    if(myproc()->killed)
80105e00:	e8 ab de ff ff       	call   80103cb0 <myproc>
80105e05:	8b 70 24             	mov    0x24(%eax),%esi
80105e08:	85 f6                	test   %esi,%esi
80105e0a:	0f 85 c0 00 00 00    	jne    80105ed0 <trap+0x260>
    myproc()->tf = tf;
80105e10:	e8 9b de ff ff       	call   80103cb0 <myproc>
80105e15:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105e18:	e8 43 ef ff ff       	call   80104d60 <syscall>
    if(myproc()->killed)
80105e1d:	e8 8e de ff ff       	call   80103cb0 <myproc>
80105e22:	8b 58 24             	mov    0x24(%eax),%ebx
80105e25:	85 db                	test   %ebx,%ebx
80105e27:	74 ce                	je     80105df7 <trap+0x187>
}
80105e29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e2c:	5b                   	pop    %ebx
80105e2d:	5e                   	pop    %esi
80105e2e:	5f                   	pop    %edi
80105e2f:	5d                   	pop    %ebp
          exit();
80105e30:	e9 cb e2 ff ff       	jmp    80104100 <exit>
80105e35:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80105e38:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105e3c:	75 97                	jne    80105dd5 <trap+0x165>
      yield();
80105e3e:	e8 ed e3 ff ff       	call   80104230 <yield>
80105e43:	eb 90                	jmp    80105dd5 <trap+0x165>
80105e45:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105e48:	e8 43 de ff ff       	call   80103c90 <cpuid>
80105e4d:	85 c0                	test   %eax,%eax
80105e4f:	0f 84 9b 00 00 00    	je     80105ef0 <trap+0x280>
    lapiceoi();
80105e55:	e8 b6 cd ff ff       	call   80102c10 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e5a:	e8 51 de ff ff       	call   80103cb0 <myproc>
80105e5f:	85 c0                	test   %eax,%eax
80105e61:	0f 85 3d ff ff ff    	jne    80105da4 <trap+0x134>
80105e67:	e9 55 ff ff ff       	jmp    80105dc1 <trap+0x151>
80105e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e70:	e8 5b cc ff ff       	call   80102ad0 <kbdintr>
    lapiceoi();
80105e75:	e8 96 cd ff ff       	call   80102c10 <lapiceoi>
    break;
80105e7a:	e9 1c ff ff ff       	jmp    80105d9b <trap+0x12b>
80105e7f:	90                   	nop
    uartintr();
80105e80:	e8 eb 02 00 00       	call   80106170 <uartintr>
    lapiceoi();
80105e85:	e8 86 cd ff ff       	call   80102c10 <lapiceoi>
    break;
80105e8a:	e9 0c ff ff ff       	jmp    80105d9b <trap+0x12b>
80105e8f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e90:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105e94:	8b 77 38             	mov    0x38(%edi),%esi
80105e97:	e8 f4 dd ff ff       	call   80103c90 <cpuid>
80105e9c:	56                   	push   %esi
80105e9d:	53                   	push   %ebx
80105e9e:	50                   	push   %eax
80105e9f:	68 e4 7f 10 80       	push   $0x80107fe4
80105ea4:	e8 b7 a7 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105ea9:	e8 62 cd ff ff       	call   80102c10 <lapiceoi>
    break;
80105eae:	83 c4 10             	add    $0x10,%esp
80105eb1:	e9 e5 fe ff ff       	jmp    80105d9b <trap+0x12b>
80105eb6:	8d 76 00             	lea    0x0(%esi),%esi
80105eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80105ec0:	e8 fb c5 ff ff       	call   801024c0 <ideintr>
80105ec5:	eb 8e                	jmp    80105e55 <trap+0x1e5>
80105ec7:	89 f6                	mov    %esi,%esi
80105ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80105ed0:	e8 2b e2 ff ff       	call   80104100 <exit>
80105ed5:	e9 36 ff ff ff       	jmp    80105e10 <trap+0x1a0>
80105eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105ee0:	e8 1b e2 ff ff       	call   80104100 <exit>
80105ee5:	e9 d7 fe ff ff       	jmp    80105dc1 <trap+0x151>
80105eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105ef0:	83 ec 0c             	sub    $0xc,%esp
80105ef3:	68 e0 11 13 80       	push   $0x801311e0
80105ef8:	e8 63 e9 ff ff       	call   80104860 <acquire>
      wakeup(&ticks);
80105efd:	c7 04 24 20 1a 13 80 	movl   $0x80131a20,(%esp)
      ticks++;
80105f04:	83 05 20 1a 13 80 01 	addl   $0x1,0x80131a20
      wakeup(&ticks);
80105f0b:	e8 30 e5 ff ff       	call   80104440 <wakeup>
      release(&tickslock);
80105f10:	c7 04 24 e0 11 13 80 	movl   $0x801311e0,(%esp)
80105f17:	e8 04 ea ff ff       	call   80104920 <release>
80105f1c:	83 c4 10             	add    $0x10,%esp
80105f1f:	e9 31 ff ff ff       	jmp    80105e55 <trap+0x1e5>
80105f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      acquire(cow_lock);
80105f28:	83 ec 0c             	sub    $0xc,%esp
80105f2b:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80105f31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105f34:	e8 27 e9 ff ff       	call   80104860 <acquire>
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
80105f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      if (*ref_count == 1){
80105f3c:	83 c4 10             	add    $0x10,%esp
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
80105f3f:	8b 30                	mov    (%eax),%esi
80105f41:	89 f1                	mov    %esi,%ecx
80105f43:	c1 e9 0c             	shr    $0xc,%ecx
      if (*ref_count == 1){
80105f46:	0f b6 91 40 0f 11 80 	movzbl -0x7feef0c0(%ecx),%edx
80105f4d:	80 fa 01             	cmp    $0x1,%dl
80105f50:	74 51                	je     80105fa3 <trap+0x333>
      else if (*ref_count > 1){
80105f52:	0f 8e 92 00 00 00    	jle    80105fea <trap+0x37a>
        int result = copy_page(p->pgdir, pte_ptr);
80105f58:	83 ec 08             	sub    $0x8,%esp
        (*ref_count)--;
80105f5b:	83 ea 01             	sub    $0x1,%edx
        int result = copy_page(p->pgdir, pte_ptr);
80105f5e:	50                   	push   %eax
        (*ref_count)--;
80105f5f:	88 91 40 0f 11 80    	mov    %dl,-0x7feef0c0(%ecx)
        int result = copy_page(p->pgdir, pte_ptr);
80105f65:	ff 73 04             	pushl  0x4(%ebx)
80105f68:	e8 f3 17 00 00       	call   80107760 <copy_page>
        release(cow_lock);
80105f6d:	59                   	pop    %ecx
80105f6e:	ff 35 40 ef 11 80    	pushl  0x8011ef40
        int result = copy_page(p->pgdir, pte_ptr);
80105f74:	89 c6                	mov    %eax,%esi
        release(cow_lock);
80105f76:	e8 a5 e9 ff ff       	call   80104920 <release>
        if (result < 0){
80105f7b:	83 c4 10             	add    $0x10,%esp
80105f7e:	85 f6                	test   %esi,%esi
80105f80:	0f 89 71 fe ff ff    	jns    80105df7 <trap+0x187>
          p->killed = 1;
80105f86:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
80105f8d:	e9 97 fe ff ff       	jmp    80105e29 <trap+0x1b9>
80105f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f98:	8b 15 00 00 00 00    	mov    0x0,%edx
80105f9e:	e9 2b fd ff ff       	jmp    80105cce <trap+0x5e>
        *pte_ptr &= (~PTE_COW);
80105fa3:	81 e6 ff f7 ff ff    	and    $0xfffff7ff,%esi
80105fa9:	83 ce 02             	or     $0x2,%esi
80105fac:	89 30                	mov    %esi,(%eax)
        release(cow_lock);
80105fae:	a1 40 ef 11 80       	mov    0x8011ef40,%eax
80105fb3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80105fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fb9:	5b                   	pop    %ebx
80105fba:	5e                   	pop    %esi
80105fbb:	5f                   	pop    %edi
80105fbc:	5d                   	pop    %ebp
        release(cow_lock);
80105fbd:	e9 5e e9 ff ff       	jmp    80104920 <release>
80105fc2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105fc5:	e8 c6 dc ff ff       	call   80103c90 <cpuid>
80105fca:	83 ec 0c             	sub    $0xc,%esp
80105fcd:	56                   	push   %esi
80105fce:	53                   	push   %ebx
80105fcf:	50                   	push   %eax
80105fd0:	ff 77 30             	pushl  0x30(%edi)
80105fd3:	68 88 80 10 80       	push   $0x80108088
80105fd8:	e8 83 a6 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105fdd:	83 c4 14             	add    $0x14,%esp
80105fe0:	68 de 7f 10 80       	push   $0x80107fde
80105fe5:	e8 a6 a3 ff ff       	call   80100390 <panic>
        panic("ref count to page is 0 but it was reffed");
80105fea:	83 ec 0c             	sub    $0xc,%esp
80105fed:	68 08 80 10 80       	push   $0x80108008
80105ff2:	e8 99 a3 ff ff       	call   80100390 <panic>
80105ff7:	66 90                	xchg   %ax,%ax
80105ff9:	66 90                	xchg   %ax,%ax
80105ffb:	66 90                	xchg   %ax,%ax
80105ffd:	66 90                	xchg   %ax,%ax
80105fff:	90                   	nop

80106000 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106000:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80106005:	55                   	push   %ebp
80106006:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106008:	85 c0                	test   %eax,%eax
8010600a:	74 1c                	je     80106028 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010600c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106011:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106012:	a8 01                	test   $0x1,%al
80106014:	74 12                	je     80106028 <uartgetc+0x28>
80106016:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010601b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010601c:	0f b6 c0             	movzbl %al,%eax
}
8010601f:	5d                   	pop    %ebp
80106020:	c3                   	ret    
80106021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106028:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010602d:	5d                   	pop    %ebp
8010602e:	c3                   	ret    
8010602f:	90                   	nop

80106030 <uartputc.part.0>:
uartputc(int c)
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	57                   	push   %edi
80106034:	56                   	push   %esi
80106035:	53                   	push   %ebx
80106036:	89 c7                	mov    %eax,%edi
80106038:	bb 80 00 00 00       	mov    $0x80,%ebx
8010603d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106042:	83 ec 0c             	sub    $0xc,%esp
80106045:	eb 1b                	jmp    80106062 <uartputc.part.0+0x32>
80106047:	89 f6                	mov    %esi,%esi
80106049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106050:	83 ec 0c             	sub    $0xc,%esp
80106053:	6a 0a                	push   $0xa
80106055:	e8 d6 cb ff ff       	call   80102c30 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010605a:	83 c4 10             	add    $0x10,%esp
8010605d:	83 eb 01             	sub    $0x1,%ebx
80106060:	74 07                	je     80106069 <uartputc.part.0+0x39>
80106062:	89 f2                	mov    %esi,%edx
80106064:	ec                   	in     (%dx),%al
80106065:	a8 20                	test   $0x20,%al
80106067:	74 e7                	je     80106050 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106069:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010606e:	89 f8                	mov    %edi,%eax
80106070:	ee                   	out    %al,(%dx)
}
80106071:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106074:	5b                   	pop    %ebx
80106075:	5e                   	pop    %esi
80106076:	5f                   	pop    %edi
80106077:	5d                   	pop    %ebp
80106078:	c3                   	ret    
80106079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106080 <uartinit>:
{
80106080:	55                   	push   %ebp
80106081:	31 c9                	xor    %ecx,%ecx
80106083:	89 c8                	mov    %ecx,%eax
80106085:	89 e5                	mov    %esp,%ebp
80106087:	57                   	push   %edi
80106088:	56                   	push   %esi
80106089:	53                   	push   %ebx
8010608a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010608f:	89 da                	mov    %ebx,%edx
80106091:	83 ec 0c             	sub    $0xc,%esp
80106094:	ee                   	out    %al,(%dx)
80106095:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010609a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010609f:	89 fa                	mov    %edi,%edx
801060a1:	ee                   	out    %al,(%dx)
801060a2:	b8 0c 00 00 00       	mov    $0xc,%eax
801060a7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060ac:	ee                   	out    %al,(%dx)
801060ad:	be f9 03 00 00       	mov    $0x3f9,%esi
801060b2:	89 c8                	mov    %ecx,%eax
801060b4:	89 f2                	mov    %esi,%edx
801060b6:	ee                   	out    %al,(%dx)
801060b7:	b8 03 00 00 00       	mov    $0x3,%eax
801060bc:	89 fa                	mov    %edi,%edx
801060be:	ee                   	out    %al,(%dx)
801060bf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801060c4:	89 c8                	mov    %ecx,%eax
801060c6:	ee                   	out    %al,(%dx)
801060c7:	b8 01 00 00 00       	mov    $0x1,%eax
801060cc:	89 f2                	mov    %esi,%edx
801060ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060cf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060d4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801060d5:	3c ff                	cmp    $0xff,%al
801060d7:	74 5a                	je     80106133 <uartinit+0xb3>
  uart = 1;
801060d9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
801060e0:	00 00 00 
801060e3:	89 da                	mov    %ebx,%edx
801060e5:	ec                   	in     (%dx),%al
801060e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060eb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801060ec:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801060ef:	bb c8 81 10 80       	mov    $0x801081c8,%ebx
  ioapicenable(IRQ_COM1, 0);
801060f4:	6a 00                	push   $0x0
801060f6:	6a 04                	push   $0x4
801060f8:	e8 13 c6 ff ff       	call   80102710 <ioapicenable>
801060fd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106100:	b8 78 00 00 00       	mov    $0x78,%eax
80106105:	eb 13                	jmp    8010611a <uartinit+0x9a>
80106107:	89 f6                	mov    %esi,%esi
80106109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106110:	83 c3 01             	add    $0x1,%ebx
80106113:	0f be 03             	movsbl (%ebx),%eax
80106116:	84 c0                	test   %al,%al
80106118:	74 19                	je     80106133 <uartinit+0xb3>
  if(!uart)
8010611a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106120:	85 d2                	test   %edx,%edx
80106122:	74 ec                	je     80106110 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106124:	83 c3 01             	add    $0x1,%ebx
80106127:	e8 04 ff ff ff       	call   80106030 <uartputc.part.0>
8010612c:	0f be 03             	movsbl (%ebx),%eax
8010612f:	84 c0                	test   %al,%al
80106131:	75 e7                	jne    8010611a <uartinit+0x9a>
}
80106133:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106136:	5b                   	pop    %ebx
80106137:	5e                   	pop    %esi
80106138:	5f                   	pop    %edi
80106139:	5d                   	pop    %ebp
8010613a:	c3                   	ret    
8010613b:	90                   	nop
8010613c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106140 <uartputc>:
  if(!uart)
80106140:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106146:	55                   	push   %ebp
80106147:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106149:	85 d2                	test   %edx,%edx
{
8010614b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010614e:	74 10                	je     80106160 <uartputc+0x20>
}
80106150:	5d                   	pop    %ebp
80106151:	e9 da fe ff ff       	jmp    80106030 <uartputc.part.0>
80106156:	8d 76 00             	lea    0x0(%esi),%esi
80106159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106160:	5d                   	pop    %ebp
80106161:	c3                   	ret    
80106162:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106170 <uartintr>:

void
uartintr(void)
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106176:	68 00 60 10 80       	push   $0x80106000
8010617b:	e8 90 a6 ff ff       	call   80100810 <consoleintr>
}
80106180:	83 c4 10             	add    $0x10,%esp
80106183:	c9                   	leave  
80106184:	c3                   	ret    

80106185 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106185:	6a 00                	push   $0x0
  pushl $0
80106187:	6a 00                	push   $0x0
  jmp alltraps
80106189:	e9 0b fa ff ff       	jmp    80105b99 <alltraps>

8010618e <vector1>:
.globl vector1
vector1:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $1
80106190:	6a 01                	push   $0x1
  jmp alltraps
80106192:	e9 02 fa ff ff       	jmp    80105b99 <alltraps>

80106197 <vector2>:
.globl vector2
vector2:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $2
80106199:	6a 02                	push   $0x2
  jmp alltraps
8010619b:	e9 f9 f9 ff ff       	jmp    80105b99 <alltraps>

801061a0 <vector3>:
.globl vector3
vector3:
  pushl $0
801061a0:	6a 00                	push   $0x0
  pushl $3
801061a2:	6a 03                	push   $0x3
  jmp alltraps
801061a4:	e9 f0 f9 ff ff       	jmp    80105b99 <alltraps>

801061a9 <vector4>:
.globl vector4
vector4:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $4
801061ab:	6a 04                	push   $0x4
  jmp alltraps
801061ad:	e9 e7 f9 ff ff       	jmp    80105b99 <alltraps>

801061b2 <vector5>:
.globl vector5
vector5:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $5
801061b4:	6a 05                	push   $0x5
  jmp alltraps
801061b6:	e9 de f9 ff ff       	jmp    80105b99 <alltraps>

801061bb <vector6>:
.globl vector6
vector6:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $6
801061bd:	6a 06                	push   $0x6
  jmp alltraps
801061bf:	e9 d5 f9 ff ff       	jmp    80105b99 <alltraps>

801061c4 <vector7>:
.globl vector7
vector7:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $7
801061c6:	6a 07                	push   $0x7
  jmp alltraps
801061c8:	e9 cc f9 ff ff       	jmp    80105b99 <alltraps>

801061cd <vector8>:
.globl vector8
vector8:
  pushl $8
801061cd:	6a 08                	push   $0x8
  jmp alltraps
801061cf:	e9 c5 f9 ff ff       	jmp    80105b99 <alltraps>

801061d4 <vector9>:
.globl vector9
vector9:
  pushl $0
801061d4:	6a 00                	push   $0x0
  pushl $9
801061d6:	6a 09                	push   $0x9
  jmp alltraps
801061d8:	e9 bc f9 ff ff       	jmp    80105b99 <alltraps>

801061dd <vector10>:
.globl vector10
vector10:
  pushl $10
801061dd:	6a 0a                	push   $0xa
  jmp alltraps
801061df:	e9 b5 f9 ff ff       	jmp    80105b99 <alltraps>

801061e4 <vector11>:
.globl vector11
vector11:
  pushl $11
801061e4:	6a 0b                	push   $0xb
  jmp alltraps
801061e6:	e9 ae f9 ff ff       	jmp    80105b99 <alltraps>

801061eb <vector12>:
.globl vector12
vector12:
  pushl $12
801061eb:	6a 0c                	push   $0xc
  jmp alltraps
801061ed:	e9 a7 f9 ff ff       	jmp    80105b99 <alltraps>

801061f2 <vector13>:
.globl vector13
vector13:
  pushl $13
801061f2:	6a 0d                	push   $0xd
  jmp alltraps
801061f4:	e9 a0 f9 ff ff       	jmp    80105b99 <alltraps>

801061f9 <vector14>:
.globl vector14
vector14:
  pushl $14
801061f9:	6a 0e                	push   $0xe
  jmp alltraps
801061fb:	e9 99 f9 ff ff       	jmp    80105b99 <alltraps>

80106200 <vector15>:
.globl vector15
vector15:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $15
80106202:	6a 0f                	push   $0xf
  jmp alltraps
80106204:	e9 90 f9 ff ff       	jmp    80105b99 <alltraps>

80106209 <vector16>:
.globl vector16
vector16:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $16
8010620b:	6a 10                	push   $0x10
  jmp alltraps
8010620d:	e9 87 f9 ff ff       	jmp    80105b99 <alltraps>

80106212 <vector17>:
.globl vector17
vector17:
  pushl $17
80106212:	6a 11                	push   $0x11
  jmp alltraps
80106214:	e9 80 f9 ff ff       	jmp    80105b99 <alltraps>

80106219 <vector18>:
.globl vector18
vector18:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $18
8010621b:	6a 12                	push   $0x12
  jmp alltraps
8010621d:	e9 77 f9 ff ff       	jmp    80105b99 <alltraps>

80106222 <vector19>:
.globl vector19
vector19:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $19
80106224:	6a 13                	push   $0x13
  jmp alltraps
80106226:	e9 6e f9 ff ff       	jmp    80105b99 <alltraps>

8010622b <vector20>:
.globl vector20
vector20:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $20
8010622d:	6a 14                	push   $0x14
  jmp alltraps
8010622f:	e9 65 f9 ff ff       	jmp    80105b99 <alltraps>

80106234 <vector21>:
.globl vector21
vector21:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $21
80106236:	6a 15                	push   $0x15
  jmp alltraps
80106238:	e9 5c f9 ff ff       	jmp    80105b99 <alltraps>

8010623d <vector22>:
.globl vector22
vector22:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $22
8010623f:	6a 16                	push   $0x16
  jmp alltraps
80106241:	e9 53 f9 ff ff       	jmp    80105b99 <alltraps>

80106246 <vector23>:
.globl vector23
vector23:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $23
80106248:	6a 17                	push   $0x17
  jmp alltraps
8010624a:	e9 4a f9 ff ff       	jmp    80105b99 <alltraps>

8010624f <vector24>:
.globl vector24
vector24:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $24
80106251:	6a 18                	push   $0x18
  jmp alltraps
80106253:	e9 41 f9 ff ff       	jmp    80105b99 <alltraps>

80106258 <vector25>:
.globl vector25
vector25:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $25
8010625a:	6a 19                	push   $0x19
  jmp alltraps
8010625c:	e9 38 f9 ff ff       	jmp    80105b99 <alltraps>

80106261 <vector26>:
.globl vector26
vector26:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $26
80106263:	6a 1a                	push   $0x1a
  jmp alltraps
80106265:	e9 2f f9 ff ff       	jmp    80105b99 <alltraps>

8010626a <vector27>:
.globl vector27
vector27:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $27
8010626c:	6a 1b                	push   $0x1b
  jmp alltraps
8010626e:	e9 26 f9 ff ff       	jmp    80105b99 <alltraps>

80106273 <vector28>:
.globl vector28
vector28:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $28
80106275:	6a 1c                	push   $0x1c
  jmp alltraps
80106277:	e9 1d f9 ff ff       	jmp    80105b99 <alltraps>

8010627c <vector29>:
.globl vector29
vector29:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $29
8010627e:	6a 1d                	push   $0x1d
  jmp alltraps
80106280:	e9 14 f9 ff ff       	jmp    80105b99 <alltraps>

80106285 <vector30>:
.globl vector30
vector30:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $30
80106287:	6a 1e                	push   $0x1e
  jmp alltraps
80106289:	e9 0b f9 ff ff       	jmp    80105b99 <alltraps>

8010628e <vector31>:
.globl vector31
vector31:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $31
80106290:	6a 1f                	push   $0x1f
  jmp alltraps
80106292:	e9 02 f9 ff ff       	jmp    80105b99 <alltraps>

80106297 <vector32>:
.globl vector32
vector32:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $32
80106299:	6a 20                	push   $0x20
  jmp alltraps
8010629b:	e9 f9 f8 ff ff       	jmp    80105b99 <alltraps>

801062a0 <vector33>:
.globl vector33
vector33:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $33
801062a2:	6a 21                	push   $0x21
  jmp alltraps
801062a4:	e9 f0 f8 ff ff       	jmp    80105b99 <alltraps>

801062a9 <vector34>:
.globl vector34
vector34:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $34
801062ab:	6a 22                	push   $0x22
  jmp alltraps
801062ad:	e9 e7 f8 ff ff       	jmp    80105b99 <alltraps>

801062b2 <vector35>:
.globl vector35
vector35:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $35
801062b4:	6a 23                	push   $0x23
  jmp alltraps
801062b6:	e9 de f8 ff ff       	jmp    80105b99 <alltraps>

801062bb <vector36>:
.globl vector36
vector36:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $36
801062bd:	6a 24                	push   $0x24
  jmp alltraps
801062bf:	e9 d5 f8 ff ff       	jmp    80105b99 <alltraps>

801062c4 <vector37>:
.globl vector37
vector37:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $37
801062c6:	6a 25                	push   $0x25
  jmp alltraps
801062c8:	e9 cc f8 ff ff       	jmp    80105b99 <alltraps>

801062cd <vector38>:
.globl vector38
vector38:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $38
801062cf:	6a 26                	push   $0x26
  jmp alltraps
801062d1:	e9 c3 f8 ff ff       	jmp    80105b99 <alltraps>

801062d6 <vector39>:
.globl vector39
vector39:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $39
801062d8:	6a 27                	push   $0x27
  jmp alltraps
801062da:	e9 ba f8 ff ff       	jmp    80105b99 <alltraps>

801062df <vector40>:
.globl vector40
vector40:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $40
801062e1:	6a 28                	push   $0x28
  jmp alltraps
801062e3:	e9 b1 f8 ff ff       	jmp    80105b99 <alltraps>

801062e8 <vector41>:
.globl vector41
vector41:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $41
801062ea:	6a 29                	push   $0x29
  jmp alltraps
801062ec:	e9 a8 f8 ff ff       	jmp    80105b99 <alltraps>

801062f1 <vector42>:
.globl vector42
vector42:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $42
801062f3:	6a 2a                	push   $0x2a
  jmp alltraps
801062f5:	e9 9f f8 ff ff       	jmp    80105b99 <alltraps>

801062fa <vector43>:
.globl vector43
vector43:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $43
801062fc:	6a 2b                	push   $0x2b
  jmp alltraps
801062fe:	e9 96 f8 ff ff       	jmp    80105b99 <alltraps>

80106303 <vector44>:
.globl vector44
vector44:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $44
80106305:	6a 2c                	push   $0x2c
  jmp alltraps
80106307:	e9 8d f8 ff ff       	jmp    80105b99 <alltraps>

8010630c <vector45>:
.globl vector45
vector45:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $45
8010630e:	6a 2d                	push   $0x2d
  jmp alltraps
80106310:	e9 84 f8 ff ff       	jmp    80105b99 <alltraps>

80106315 <vector46>:
.globl vector46
vector46:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $46
80106317:	6a 2e                	push   $0x2e
  jmp alltraps
80106319:	e9 7b f8 ff ff       	jmp    80105b99 <alltraps>

8010631e <vector47>:
.globl vector47
vector47:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $47
80106320:	6a 2f                	push   $0x2f
  jmp alltraps
80106322:	e9 72 f8 ff ff       	jmp    80105b99 <alltraps>

80106327 <vector48>:
.globl vector48
vector48:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $48
80106329:	6a 30                	push   $0x30
  jmp alltraps
8010632b:	e9 69 f8 ff ff       	jmp    80105b99 <alltraps>

80106330 <vector49>:
.globl vector49
vector49:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $49
80106332:	6a 31                	push   $0x31
  jmp alltraps
80106334:	e9 60 f8 ff ff       	jmp    80105b99 <alltraps>

80106339 <vector50>:
.globl vector50
vector50:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $50
8010633b:	6a 32                	push   $0x32
  jmp alltraps
8010633d:	e9 57 f8 ff ff       	jmp    80105b99 <alltraps>

80106342 <vector51>:
.globl vector51
vector51:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $51
80106344:	6a 33                	push   $0x33
  jmp alltraps
80106346:	e9 4e f8 ff ff       	jmp    80105b99 <alltraps>

8010634b <vector52>:
.globl vector52
vector52:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $52
8010634d:	6a 34                	push   $0x34
  jmp alltraps
8010634f:	e9 45 f8 ff ff       	jmp    80105b99 <alltraps>

80106354 <vector53>:
.globl vector53
vector53:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $53
80106356:	6a 35                	push   $0x35
  jmp alltraps
80106358:	e9 3c f8 ff ff       	jmp    80105b99 <alltraps>

8010635d <vector54>:
.globl vector54
vector54:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $54
8010635f:	6a 36                	push   $0x36
  jmp alltraps
80106361:	e9 33 f8 ff ff       	jmp    80105b99 <alltraps>

80106366 <vector55>:
.globl vector55
vector55:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $55
80106368:	6a 37                	push   $0x37
  jmp alltraps
8010636a:	e9 2a f8 ff ff       	jmp    80105b99 <alltraps>

8010636f <vector56>:
.globl vector56
vector56:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $56
80106371:	6a 38                	push   $0x38
  jmp alltraps
80106373:	e9 21 f8 ff ff       	jmp    80105b99 <alltraps>

80106378 <vector57>:
.globl vector57
vector57:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $57
8010637a:	6a 39                	push   $0x39
  jmp alltraps
8010637c:	e9 18 f8 ff ff       	jmp    80105b99 <alltraps>

80106381 <vector58>:
.globl vector58
vector58:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $58
80106383:	6a 3a                	push   $0x3a
  jmp alltraps
80106385:	e9 0f f8 ff ff       	jmp    80105b99 <alltraps>

8010638a <vector59>:
.globl vector59
vector59:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $59
8010638c:	6a 3b                	push   $0x3b
  jmp alltraps
8010638e:	e9 06 f8 ff ff       	jmp    80105b99 <alltraps>

80106393 <vector60>:
.globl vector60
vector60:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $60
80106395:	6a 3c                	push   $0x3c
  jmp alltraps
80106397:	e9 fd f7 ff ff       	jmp    80105b99 <alltraps>

8010639c <vector61>:
.globl vector61
vector61:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $61
8010639e:	6a 3d                	push   $0x3d
  jmp alltraps
801063a0:	e9 f4 f7 ff ff       	jmp    80105b99 <alltraps>

801063a5 <vector62>:
.globl vector62
vector62:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $62
801063a7:	6a 3e                	push   $0x3e
  jmp alltraps
801063a9:	e9 eb f7 ff ff       	jmp    80105b99 <alltraps>

801063ae <vector63>:
.globl vector63
vector63:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $63
801063b0:	6a 3f                	push   $0x3f
  jmp alltraps
801063b2:	e9 e2 f7 ff ff       	jmp    80105b99 <alltraps>

801063b7 <vector64>:
.globl vector64
vector64:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $64
801063b9:	6a 40                	push   $0x40
  jmp alltraps
801063bb:	e9 d9 f7 ff ff       	jmp    80105b99 <alltraps>

801063c0 <vector65>:
.globl vector65
vector65:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $65
801063c2:	6a 41                	push   $0x41
  jmp alltraps
801063c4:	e9 d0 f7 ff ff       	jmp    80105b99 <alltraps>

801063c9 <vector66>:
.globl vector66
vector66:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $66
801063cb:	6a 42                	push   $0x42
  jmp alltraps
801063cd:	e9 c7 f7 ff ff       	jmp    80105b99 <alltraps>

801063d2 <vector67>:
.globl vector67
vector67:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $67
801063d4:	6a 43                	push   $0x43
  jmp alltraps
801063d6:	e9 be f7 ff ff       	jmp    80105b99 <alltraps>

801063db <vector68>:
.globl vector68
vector68:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $68
801063dd:	6a 44                	push   $0x44
  jmp alltraps
801063df:	e9 b5 f7 ff ff       	jmp    80105b99 <alltraps>

801063e4 <vector69>:
.globl vector69
vector69:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $69
801063e6:	6a 45                	push   $0x45
  jmp alltraps
801063e8:	e9 ac f7 ff ff       	jmp    80105b99 <alltraps>

801063ed <vector70>:
.globl vector70
vector70:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $70
801063ef:	6a 46                	push   $0x46
  jmp alltraps
801063f1:	e9 a3 f7 ff ff       	jmp    80105b99 <alltraps>

801063f6 <vector71>:
.globl vector71
vector71:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $71
801063f8:	6a 47                	push   $0x47
  jmp alltraps
801063fa:	e9 9a f7 ff ff       	jmp    80105b99 <alltraps>

801063ff <vector72>:
.globl vector72
vector72:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $72
80106401:	6a 48                	push   $0x48
  jmp alltraps
80106403:	e9 91 f7 ff ff       	jmp    80105b99 <alltraps>

80106408 <vector73>:
.globl vector73
vector73:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $73
8010640a:	6a 49                	push   $0x49
  jmp alltraps
8010640c:	e9 88 f7 ff ff       	jmp    80105b99 <alltraps>

80106411 <vector74>:
.globl vector74
vector74:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $74
80106413:	6a 4a                	push   $0x4a
  jmp alltraps
80106415:	e9 7f f7 ff ff       	jmp    80105b99 <alltraps>

8010641a <vector75>:
.globl vector75
vector75:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $75
8010641c:	6a 4b                	push   $0x4b
  jmp alltraps
8010641e:	e9 76 f7 ff ff       	jmp    80105b99 <alltraps>

80106423 <vector76>:
.globl vector76
vector76:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $76
80106425:	6a 4c                	push   $0x4c
  jmp alltraps
80106427:	e9 6d f7 ff ff       	jmp    80105b99 <alltraps>

8010642c <vector77>:
.globl vector77
vector77:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $77
8010642e:	6a 4d                	push   $0x4d
  jmp alltraps
80106430:	e9 64 f7 ff ff       	jmp    80105b99 <alltraps>

80106435 <vector78>:
.globl vector78
vector78:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $78
80106437:	6a 4e                	push   $0x4e
  jmp alltraps
80106439:	e9 5b f7 ff ff       	jmp    80105b99 <alltraps>

8010643e <vector79>:
.globl vector79
vector79:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $79
80106440:	6a 4f                	push   $0x4f
  jmp alltraps
80106442:	e9 52 f7 ff ff       	jmp    80105b99 <alltraps>

80106447 <vector80>:
.globl vector80
vector80:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $80
80106449:	6a 50                	push   $0x50
  jmp alltraps
8010644b:	e9 49 f7 ff ff       	jmp    80105b99 <alltraps>

80106450 <vector81>:
.globl vector81
vector81:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $81
80106452:	6a 51                	push   $0x51
  jmp alltraps
80106454:	e9 40 f7 ff ff       	jmp    80105b99 <alltraps>

80106459 <vector82>:
.globl vector82
vector82:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $82
8010645b:	6a 52                	push   $0x52
  jmp alltraps
8010645d:	e9 37 f7 ff ff       	jmp    80105b99 <alltraps>

80106462 <vector83>:
.globl vector83
vector83:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $83
80106464:	6a 53                	push   $0x53
  jmp alltraps
80106466:	e9 2e f7 ff ff       	jmp    80105b99 <alltraps>

8010646b <vector84>:
.globl vector84
vector84:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $84
8010646d:	6a 54                	push   $0x54
  jmp alltraps
8010646f:	e9 25 f7 ff ff       	jmp    80105b99 <alltraps>

80106474 <vector85>:
.globl vector85
vector85:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $85
80106476:	6a 55                	push   $0x55
  jmp alltraps
80106478:	e9 1c f7 ff ff       	jmp    80105b99 <alltraps>

8010647d <vector86>:
.globl vector86
vector86:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $86
8010647f:	6a 56                	push   $0x56
  jmp alltraps
80106481:	e9 13 f7 ff ff       	jmp    80105b99 <alltraps>

80106486 <vector87>:
.globl vector87
vector87:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $87
80106488:	6a 57                	push   $0x57
  jmp alltraps
8010648a:	e9 0a f7 ff ff       	jmp    80105b99 <alltraps>

8010648f <vector88>:
.globl vector88
vector88:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $88
80106491:	6a 58                	push   $0x58
  jmp alltraps
80106493:	e9 01 f7 ff ff       	jmp    80105b99 <alltraps>

80106498 <vector89>:
.globl vector89
vector89:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $89
8010649a:	6a 59                	push   $0x59
  jmp alltraps
8010649c:	e9 f8 f6 ff ff       	jmp    80105b99 <alltraps>

801064a1 <vector90>:
.globl vector90
vector90:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $90
801064a3:	6a 5a                	push   $0x5a
  jmp alltraps
801064a5:	e9 ef f6 ff ff       	jmp    80105b99 <alltraps>

801064aa <vector91>:
.globl vector91
vector91:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $91
801064ac:	6a 5b                	push   $0x5b
  jmp alltraps
801064ae:	e9 e6 f6 ff ff       	jmp    80105b99 <alltraps>

801064b3 <vector92>:
.globl vector92
vector92:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $92
801064b5:	6a 5c                	push   $0x5c
  jmp alltraps
801064b7:	e9 dd f6 ff ff       	jmp    80105b99 <alltraps>

801064bc <vector93>:
.globl vector93
vector93:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $93
801064be:	6a 5d                	push   $0x5d
  jmp alltraps
801064c0:	e9 d4 f6 ff ff       	jmp    80105b99 <alltraps>

801064c5 <vector94>:
.globl vector94
vector94:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $94
801064c7:	6a 5e                	push   $0x5e
  jmp alltraps
801064c9:	e9 cb f6 ff ff       	jmp    80105b99 <alltraps>

801064ce <vector95>:
.globl vector95
vector95:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $95
801064d0:	6a 5f                	push   $0x5f
  jmp alltraps
801064d2:	e9 c2 f6 ff ff       	jmp    80105b99 <alltraps>

801064d7 <vector96>:
.globl vector96
vector96:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $96
801064d9:	6a 60                	push   $0x60
  jmp alltraps
801064db:	e9 b9 f6 ff ff       	jmp    80105b99 <alltraps>

801064e0 <vector97>:
.globl vector97
vector97:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $97
801064e2:	6a 61                	push   $0x61
  jmp alltraps
801064e4:	e9 b0 f6 ff ff       	jmp    80105b99 <alltraps>

801064e9 <vector98>:
.globl vector98
vector98:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $98
801064eb:	6a 62                	push   $0x62
  jmp alltraps
801064ed:	e9 a7 f6 ff ff       	jmp    80105b99 <alltraps>

801064f2 <vector99>:
.globl vector99
vector99:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $99
801064f4:	6a 63                	push   $0x63
  jmp alltraps
801064f6:	e9 9e f6 ff ff       	jmp    80105b99 <alltraps>

801064fb <vector100>:
.globl vector100
vector100:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $100
801064fd:	6a 64                	push   $0x64
  jmp alltraps
801064ff:	e9 95 f6 ff ff       	jmp    80105b99 <alltraps>

80106504 <vector101>:
.globl vector101
vector101:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $101
80106506:	6a 65                	push   $0x65
  jmp alltraps
80106508:	e9 8c f6 ff ff       	jmp    80105b99 <alltraps>

8010650d <vector102>:
.globl vector102
vector102:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $102
8010650f:	6a 66                	push   $0x66
  jmp alltraps
80106511:	e9 83 f6 ff ff       	jmp    80105b99 <alltraps>

80106516 <vector103>:
.globl vector103
vector103:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $103
80106518:	6a 67                	push   $0x67
  jmp alltraps
8010651a:	e9 7a f6 ff ff       	jmp    80105b99 <alltraps>

8010651f <vector104>:
.globl vector104
vector104:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $104
80106521:	6a 68                	push   $0x68
  jmp alltraps
80106523:	e9 71 f6 ff ff       	jmp    80105b99 <alltraps>

80106528 <vector105>:
.globl vector105
vector105:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $105
8010652a:	6a 69                	push   $0x69
  jmp alltraps
8010652c:	e9 68 f6 ff ff       	jmp    80105b99 <alltraps>

80106531 <vector106>:
.globl vector106
vector106:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $106
80106533:	6a 6a                	push   $0x6a
  jmp alltraps
80106535:	e9 5f f6 ff ff       	jmp    80105b99 <alltraps>

8010653a <vector107>:
.globl vector107
vector107:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $107
8010653c:	6a 6b                	push   $0x6b
  jmp alltraps
8010653e:	e9 56 f6 ff ff       	jmp    80105b99 <alltraps>

80106543 <vector108>:
.globl vector108
vector108:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $108
80106545:	6a 6c                	push   $0x6c
  jmp alltraps
80106547:	e9 4d f6 ff ff       	jmp    80105b99 <alltraps>

8010654c <vector109>:
.globl vector109
vector109:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $109
8010654e:	6a 6d                	push   $0x6d
  jmp alltraps
80106550:	e9 44 f6 ff ff       	jmp    80105b99 <alltraps>

80106555 <vector110>:
.globl vector110
vector110:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $110
80106557:	6a 6e                	push   $0x6e
  jmp alltraps
80106559:	e9 3b f6 ff ff       	jmp    80105b99 <alltraps>

8010655e <vector111>:
.globl vector111
vector111:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $111
80106560:	6a 6f                	push   $0x6f
  jmp alltraps
80106562:	e9 32 f6 ff ff       	jmp    80105b99 <alltraps>

80106567 <vector112>:
.globl vector112
vector112:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $112
80106569:	6a 70                	push   $0x70
  jmp alltraps
8010656b:	e9 29 f6 ff ff       	jmp    80105b99 <alltraps>

80106570 <vector113>:
.globl vector113
vector113:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $113
80106572:	6a 71                	push   $0x71
  jmp alltraps
80106574:	e9 20 f6 ff ff       	jmp    80105b99 <alltraps>

80106579 <vector114>:
.globl vector114
vector114:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $114
8010657b:	6a 72                	push   $0x72
  jmp alltraps
8010657d:	e9 17 f6 ff ff       	jmp    80105b99 <alltraps>

80106582 <vector115>:
.globl vector115
vector115:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $115
80106584:	6a 73                	push   $0x73
  jmp alltraps
80106586:	e9 0e f6 ff ff       	jmp    80105b99 <alltraps>

8010658b <vector116>:
.globl vector116
vector116:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $116
8010658d:	6a 74                	push   $0x74
  jmp alltraps
8010658f:	e9 05 f6 ff ff       	jmp    80105b99 <alltraps>

80106594 <vector117>:
.globl vector117
vector117:
  pushl $0
80106594:	6a 00                	push   $0x0
  pushl $117
80106596:	6a 75                	push   $0x75
  jmp alltraps
80106598:	e9 fc f5 ff ff       	jmp    80105b99 <alltraps>

8010659d <vector118>:
.globl vector118
vector118:
  pushl $0
8010659d:	6a 00                	push   $0x0
  pushl $118
8010659f:	6a 76                	push   $0x76
  jmp alltraps
801065a1:	e9 f3 f5 ff ff       	jmp    80105b99 <alltraps>

801065a6 <vector119>:
.globl vector119
vector119:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $119
801065a8:	6a 77                	push   $0x77
  jmp alltraps
801065aa:	e9 ea f5 ff ff       	jmp    80105b99 <alltraps>

801065af <vector120>:
.globl vector120
vector120:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $120
801065b1:	6a 78                	push   $0x78
  jmp alltraps
801065b3:	e9 e1 f5 ff ff       	jmp    80105b99 <alltraps>

801065b8 <vector121>:
.globl vector121
vector121:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $121
801065ba:	6a 79                	push   $0x79
  jmp alltraps
801065bc:	e9 d8 f5 ff ff       	jmp    80105b99 <alltraps>

801065c1 <vector122>:
.globl vector122
vector122:
  pushl $0
801065c1:	6a 00                	push   $0x0
  pushl $122
801065c3:	6a 7a                	push   $0x7a
  jmp alltraps
801065c5:	e9 cf f5 ff ff       	jmp    80105b99 <alltraps>

801065ca <vector123>:
.globl vector123
vector123:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $123
801065cc:	6a 7b                	push   $0x7b
  jmp alltraps
801065ce:	e9 c6 f5 ff ff       	jmp    80105b99 <alltraps>

801065d3 <vector124>:
.globl vector124
vector124:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $124
801065d5:	6a 7c                	push   $0x7c
  jmp alltraps
801065d7:	e9 bd f5 ff ff       	jmp    80105b99 <alltraps>

801065dc <vector125>:
.globl vector125
vector125:
  pushl $0
801065dc:	6a 00                	push   $0x0
  pushl $125
801065de:	6a 7d                	push   $0x7d
  jmp alltraps
801065e0:	e9 b4 f5 ff ff       	jmp    80105b99 <alltraps>

801065e5 <vector126>:
.globl vector126
vector126:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $126
801065e7:	6a 7e                	push   $0x7e
  jmp alltraps
801065e9:	e9 ab f5 ff ff       	jmp    80105b99 <alltraps>

801065ee <vector127>:
.globl vector127
vector127:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $127
801065f0:	6a 7f                	push   $0x7f
  jmp alltraps
801065f2:	e9 a2 f5 ff ff       	jmp    80105b99 <alltraps>

801065f7 <vector128>:
.globl vector128
vector128:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $128
801065f9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801065fe:	e9 96 f5 ff ff       	jmp    80105b99 <alltraps>

80106603 <vector129>:
.globl vector129
vector129:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $129
80106605:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010660a:	e9 8a f5 ff ff       	jmp    80105b99 <alltraps>

8010660f <vector130>:
.globl vector130
vector130:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $130
80106611:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106616:	e9 7e f5 ff ff       	jmp    80105b99 <alltraps>

8010661b <vector131>:
.globl vector131
vector131:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $131
8010661d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106622:	e9 72 f5 ff ff       	jmp    80105b99 <alltraps>

80106627 <vector132>:
.globl vector132
vector132:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $132
80106629:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010662e:	e9 66 f5 ff ff       	jmp    80105b99 <alltraps>

80106633 <vector133>:
.globl vector133
vector133:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $133
80106635:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010663a:	e9 5a f5 ff ff       	jmp    80105b99 <alltraps>

8010663f <vector134>:
.globl vector134
vector134:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $134
80106641:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106646:	e9 4e f5 ff ff       	jmp    80105b99 <alltraps>

8010664b <vector135>:
.globl vector135
vector135:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $135
8010664d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106652:	e9 42 f5 ff ff       	jmp    80105b99 <alltraps>

80106657 <vector136>:
.globl vector136
vector136:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $136
80106659:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010665e:	e9 36 f5 ff ff       	jmp    80105b99 <alltraps>

80106663 <vector137>:
.globl vector137
vector137:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $137
80106665:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010666a:	e9 2a f5 ff ff       	jmp    80105b99 <alltraps>

8010666f <vector138>:
.globl vector138
vector138:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $138
80106671:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106676:	e9 1e f5 ff ff       	jmp    80105b99 <alltraps>

8010667b <vector139>:
.globl vector139
vector139:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $139
8010667d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106682:	e9 12 f5 ff ff       	jmp    80105b99 <alltraps>

80106687 <vector140>:
.globl vector140
vector140:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $140
80106689:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010668e:	e9 06 f5 ff ff       	jmp    80105b99 <alltraps>

80106693 <vector141>:
.globl vector141
vector141:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $141
80106695:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010669a:	e9 fa f4 ff ff       	jmp    80105b99 <alltraps>

8010669f <vector142>:
.globl vector142
vector142:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $142
801066a1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801066a6:	e9 ee f4 ff ff       	jmp    80105b99 <alltraps>

801066ab <vector143>:
.globl vector143
vector143:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $143
801066ad:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801066b2:	e9 e2 f4 ff ff       	jmp    80105b99 <alltraps>

801066b7 <vector144>:
.globl vector144
vector144:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $144
801066b9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801066be:	e9 d6 f4 ff ff       	jmp    80105b99 <alltraps>

801066c3 <vector145>:
.globl vector145
vector145:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $145
801066c5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801066ca:	e9 ca f4 ff ff       	jmp    80105b99 <alltraps>

801066cf <vector146>:
.globl vector146
vector146:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $146
801066d1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801066d6:	e9 be f4 ff ff       	jmp    80105b99 <alltraps>

801066db <vector147>:
.globl vector147
vector147:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $147
801066dd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801066e2:	e9 b2 f4 ff ff       	jmp    80105b99 <alltraps>

801066e7 <vector148>:
.globl vector148
vector148:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $148
801066e9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801066ee:	e9 a6 f4 ff ff       	jmp    80105b99 <alltraps>

801066f3 <vector149>:
.globl vector149
vector149:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $149
801066f5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801066fa:	e9 9a f4 ff ff       	jmp    80105b99 <alltraps>

801066ff <vector150>:
.globl vector150
vector150:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $150
80106701:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106706:	e9 8e f4 ff ff       	jmp    80105b99 <alltraps>

8010670b <vector151>:
.globl vector151
vector151:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $151
8010670d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106712:	e9 82 f4 ff ff       	jmp    80105b99 <alltraps>

80106717 <vector152>:
.globl vector152
vector152:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $152
80106719:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010671e:	e9 76 f4 ff ff       	jmp    80105b99 <alltraps>

80106723 <vector153>:
.globl vector153
vector153:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $153
80106725:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010672a:	e9 6a f4 ff ff       	jmp    80105b99 <alltraps>

8010672f <vector154>:
.globl vector154
vector154:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $154
80106731:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106736:	e9 5e f4 ff ff       	jmp    80105b99 <alltraps>

8010673b <vector155>:
.globl vector155
vector155:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $155
8010673d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106742:	e9 52 f4 ff ff       	jmp    80105b99 <alltraps>

80106747 <vector156>:
.globl vector156
vector156:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $156
80106749:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010674e:	e9 46 f4 ff ff       	jmp    80105b99 <alltraps>

80106753 <vector157>:
.globl vector157
vector157:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $157
80106755:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010675a:	e9 3a f4 ff ff       	jmp    80105b99 <alltraps>

8010675f <vector158>:
.globl vector158
vector158:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $158
80106761:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106766:	e9 2e f4 ff ff       	jmp    80105b99 <alltraps>

8010676b <vector159>:
.globl vector159
vector159:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $159
8010676d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106772:	e9 22 f4 ff ff       	jmp    80105b99 <alltraps>

80106777 <vector160>:
.globl vector160
vector160:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $160
80106779:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010677e:	e9 16 f4 ff ff       	jmp    80105b99 <alltraps>

80106783 <vector161>:
.globl vector161
vector161:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $161
80106785:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010678a:	e9 0a f4 ff ff       	jmp    80105b99 <alltraps>

8010678f <vector162>:
.globl vector162
vector162:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $162
80106791:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106796:	e9 fe f3 ff ff       	jmp    80105b99 <alltraps>

8010679b <vector163>:
.globl vector163
vector163:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $163
8010679d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801067a2:	e9 f2 f3 ff ff       	jmp    80105b99 <alltraps>

801067a7 <vector164>:
.globl vector164
vector164:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $164
801067a9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801067ae:	e9 e6 f3 ff ff       	jmp    80105b99 <alltraps>

801067b3 <vector165>:
.globl vector165
vector165:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $165
801067b5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801067ba:	e9 da f3 ff ff       	jmp    80105b99 <alltraps>

801067bf <vector166>:
.globl vector166
vector166:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $166
801067c1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801067c6:	e9 ce f3 ff ff       	jmp    80105b99 <alltraps>

801067cb <vector167>:
.globl vector167
vector167:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $167
801067cd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801067d2:	e9 c2 f3 ff ff       	jmp    80105b99 <alltraps>

801067d7 <vector168>:
.globl vector168
vector168:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $168
801067d9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801067de:	e9 b6 f3 ff ff       	jmp    80105b99 <alltraps>

801067e3 <vector169>:
.globl vector169
vector169:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $169
801067e5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801067ea:	e9 aa f3 ff ff       	jmp    80105b99 <alltraps>

801067ef <vector170>:
.globl vector170
vector170:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $170
801067f1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801067f6:	e9 9e f3 ff ff       	jmp    80105b99 <alltraps>

801067fb <vector171>:
.globl vector171
vector171:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $171
801067fd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106802:	e9 92 f3 ff ff       	jmp    80105b99 <alltraps>

80106807 <vector172>:
.globl vector172
vector172:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $172
80106809:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010680e:	e9 86 f3 ff ff       	jmp    80105b99 <alltraps>

80106813 <vector173>:
.globl vector173
vector173:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $173
80106815:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010681a:	e9 7a f3 ff ff       	jmp    80105b99 <alltraps>

8010681f <vector174>:
.globl vector174
vector174:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $174
80106821:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106826:	e9 6e f3 ff ff       	jmp    80105b99 <alltraps>

8010682b <vector175>:
.globl vector175
vector175:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $175
8010682d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106832:	e9 62 f3 ff ff       	jmp    80105b99 <alltraps>

80106837 <vector176>:
.globl vector176
vector176:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $176
80106839:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010683e:	e9 56 f3 ff ff       	jmp    80105b99 <alltraps>

80106843 <vector177>:
.globl vector177
vector177:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $177
80106845:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010684a:	e9 4a f3 ff ff       	jmp    80105b99 <alltraps>

8010684f <vector178>:
.globl vector178
vector178:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $178
80106851:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106856:	e9 3e f3 ff ff       	jmp    80105b99 <alltraps>

8010685b <vector179>:
.globl vector179
vector179:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $179
8010685d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106862:	e9 32 f3 ff ff       	jmp    80105b99 <alltraps>

80106867 <vector180>:
.globl vector180
vector180:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $180
80106869:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010686e:	e9 26 f3 ff ff       	jmp    80105b99 <alltraps>

80106873 <vector181>:
.globl vector181
vector181:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $181
80106875:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010687a:	e9 1a f3 ff ff       	jmp    80105b99 <alltraps>

8010687f <vector182>:
.globl vector182
vector182:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $182
80106881:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106886:	e9 0e f3 ff ff       	jmp    80105b99 <alltraps>

8010688b <vector183>:
.globl vector183
vector183:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $183
8010688d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106892:	e9 02 f3 ff ff       	jmp    80105b99 <alltraps>

80106897 <vector184>:
.globl vector184
vector184:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $184
80106899:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010689e:	e9 f6 f2 ff ff       	jmp    80105b99 <alltraps>

801068a3 <vector185>:
.globl vector185
vector185:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $185
801068a5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801068aa:	e9 ea f2 ff ff       	jmp    80105b99 <alltraps>

801068af <vector186>:
.globl vector186
vector186:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $186
801068b1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801068b6:	e9 de f2 ff ff       	jmp    80105b99 <alltraps>

801068bb <vector187>:
.globl vector187
vector187:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $187
801068bd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801068c2:	e9 d2 f2 ff ff       	jmp    80105b99 <alltraps>

801068c7 <vector188>:
.globl vector188
vector188:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $188
801068c9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801068ce:	e9 c6 f2 ff ff       	jmp    80105b99 <alltraps>

801068d3 <vector189>:
.globl vector189
vector189:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $189
801068d5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801068da:	e9 ba f2 ff ff       	jmp    80105b99 <alltraps>

801068df <vector190>:
.globl vector190
vector190:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $190
801068e1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801068e6:	e9 ae f2 ff ff       	jmp    80105b99 <alltraps>

801068eb <vector191>:
.globl vector191
vector191:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $191
801068ed:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801068f2:	e9 a2 f2 ff ff       	jmp    80105b99 <alltraps>

801068f7 <vector192>:
.globl vector192
vector192:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $192
801068f9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801068fe:	e9 96 f2 ff ff       	jmp    80105b99 <alltraps>

80106903 <vector193>:
.globl vector193
vector193:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $193
80106905:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010690a:	e9 8a f2 ff ff       	jmp    80105b99 <alltraps>

8010690f <vector194>:
.globl vector194
vector194:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $194
80106911:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106916:	e9 7e f2 ff ff       	jmp    80105b99 <alltraps>

8010691b <vector195>:
.globl vector195
vector195:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $195
8010691d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106922:	e9 72 f2 ff ff       	jmp    80105b99 <alltraps>

80106927 <vector196>:
.globl vector196
vector196:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $196
80106929:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010692e:	e9 66 f2 ff ff       	jmp    80105b99 <alltraps>

80106933 <vector197>:
.globl vector197
vector197:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $197
80106935:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010693a:	e9 5a f2 ff ff       	jmp    80105b99 <alltraps>

8010693f <vector198>:
.globl vector198
vector198:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $198
80106941:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106946:	e9 4e f2 ff ff       	jmp    80105b99 <alltraps>

8010694b <vector199>:
.globl vector199
vector199:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $199
8010694d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106952:	e9 42 f2 ff ff       	jmp    80105b99 <alltraps>

80106957 <vector200>:
.globl vector200
vector200:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $200
80106959:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010695e:	e9 36 f2 ff ff       	jmp    80105b99 <alltraps>

80106963 <vector201>:
.globl vector201
vector201:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $201
80106965:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010696a:	e9 2a f2 ff ff       	jmp    80105b99 <alltraps>

8010696f <vector202>:
.globl vector202
vector202:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $202
80106971:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106976:	e9 1e f2 ff ff       	jmp    80105b99 <alltraps>

8010697b <vector203>:
.globl vector203
vector203:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $203
8010697d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106982:	e9 12 f2 ff ff       	jmp    80105b99 <alltraps>

80106987 <vector204>:
.globl vector204
vector204:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $204
80106989:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010698e:	e9 06 f2 ff ff       	jmp    80105b99 <alltraps>

80106993 <vector205>:
.globl vector205
vector205:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $205
80106995:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010699a:	e9 fa f1 ff ff       	jmp    80105b99 <alltraps>

8010699f <vector206>:
.globl vector206
vector206:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $206
801069a1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801069a6:	e9 ee f1 ff ff       	jmp    80105b99 <alltraps>

801069ab <vector207>:
.globl vector207
vector207:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $207
801069ad:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801069b2:	e9 e2 f1 ff ff       	jmp    80105b99 <alltraps>

801069b7 <vector208>:
.globl vector208
vector208:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $208
801069b9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801069be:	e9 d6 f1 ff ff       	jmp    80105b99 <alltraps>

801069c3 <vector209>:
.globl vector209
vector209:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $209
801069c5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801069ca:	e9 ca f1 ff ff       	jmp    80105b99 <alltraps>

801069cf <vector210>:
.globl vector210
vector210:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $210
801069d1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801069d6:	e9 be f1 ff ff       	jmp    80105b99 <alltraps>

801069db <vector211>:
.globl vector211
vector211:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $211
801069dd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801069e2:	e9 b2 f1 ff ff       	jmp    80105b99 <alltraps>

801069e7 <vector212>:
.globl vector212
vector212:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $212
801069e9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801069ee:	e9 a6 f1 ff ff       	jmp    80105b99 <alltraps>

801069f3 <vector213>:
.globl vector213
vector213:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $213
801069f5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801069fa:	e9 9a f1 ff ff       	jmp    80105b99 <alltraps>

801069ff <vector214>:
.globl vector214
vector214:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $214
80106a01:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a06:	e9 8e f1 ff ff       	jmp    80105b99 <alltraps>

80106a0b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $215
80106a0d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a12:	e9 82 f1 ff ff       	jmp    80105b99 <alltraps>

80106a17 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $216
80106a19:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a1e:	e9 76 f1 ff ff       	jmp    80105b99 <alltraps>

80106a23 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $217
80106a25:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a2a:	e9 6a f1 ff ff       	jmp    80105b99 <alltraps>

80106a2f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $218
80106a31:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a36:	e9 5e f1 ff ff       	jmp    80105b99 <alltraps>

80106a3b <vector219>:
.globl vector219
vector219:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $219
80106a3d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a42:	e9 52 f1 ff ff       	jmp    80105b99 <alltraps>

80106a47 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $220
80106a49:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a4e:	e9 46 f1 ff ff       	jmp    80105b99 <alltraps>

80106a53 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $221
80106a55:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a5a:	e9 3a f1 ff ff       	jmp    80105b99 <alltraps>

80106a5f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $222
80106a61:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a66:	e9 2e f1 ff ff       	jmp    80105b99 <alltraps>

80106a6b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $223
80106a6d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a72:	e9 22 f1 ff ff       	jmp    80105b99 <alltraps>

80106a77 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $224
80106a79:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a7e:	e9 16 f1 ff ff       	jmp    80105b99 <alltraps>

80106a83 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $225
80106a85:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a8a:	e9 0a f1 ff ff       	jmp    80105b99 <alltraps>

80106a8f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $226
80106a91:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a96:	e9 fe f0 ff ff       	jmp    80105b99 <alltraps>

80106a9b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $227
80106a9d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106aa2:	e9 f2 f0 ff ff       	jmp    80105b99 <alltraps>

80106aa7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $228
80106aa9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106aae:	e9 e6 f0 ff ff       	jmp    80105b99 <alltraps>

80106ab3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $229
80106ab5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106aba:	e9 da f0 ff ff       	jmp    80105b99 <alltraps>

80106abf <vector230>:
.globl vector230
vector230:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $230
80106ac1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ac6:	e9 ce f0 ff ff       	jmp    80105b99 <alltraps>

80106acb <vector231>:
.globl vector231
vector231:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $231
80106acd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ad2:	e9 c2 f0 ff ff       	jmp    80105b99 <alltraps>

80106ad7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $232
80106ad9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ade:	e9 b6 f0 ff ff       	jmp    80105b99 <alltraps>

80106ae3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $233
80106ae5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106aea:	e9 aa f0 ff ff       	jmp    80105b99 <alltraps>

80106aef <vector234>:
.globl vector234
vector234:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $234
80106af1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106af6:	e9 9e f0 ff ff       	jmp    80105b99 <alltraps>

80106afb <vector235>:
.globl vector235
vector235:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $235
80106afd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b02:	e9 92 f0 ff ff       	jmp    80105b99 <alltraps>

80106b07 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $236
80106b09:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b0e:	e9 86 f0 ff ff       	jmp    80105b99 <alltraps>

80106b13 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $237
80106b15:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b1a:	e9 7a f0 ff ff       	jmp    80105b99 <alltraps>

80106b1f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $238
80106b21:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b26:	e9 6e f0 ff ff       	jmp    80105b99 <alltraps>

80106b2b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $239
80106b2d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b32:	e9 62 f0 ff ff       	jmp    80105b99 <alltraps>

80106b37 <vector240>:
.globl vector240
vector240:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $240
80106b39:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b3e:	e9 56 f0 ff ff       	jmp    80105b99 <alltraps>

80106b43 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $241
80106b45:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b4a:	e9 4a f0 ff ff       	jmp    80105b99 <alltraps>

80106b4f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $242
80106b51:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b56:	e9 3e f0 ff ff       	jmp    80105b99 <alltraps>

80106b5b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $243
80106b5d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b62:	e9 32 f0 ff ff       	jmp    80105b99 <alltraps>

80106b67 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $244
80106b69:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b6e:	e9 26 f0 ff ff       	jmp    80105b99 <alltraps>

80106b73 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $245
80106b75:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b7a:	e9 1a f0 ff ff       	jmp    80105b99 <alltraps>

80106b7f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $246
80106b81:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b86:	e9 0e f0 ff ff       	jmp    80105b99 <alltraps>

80106b8b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $247
80106b8d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b92:	e9 02 f0 ff ff       	jmp    80105b99 <alltraps>

80106b97 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $248
80106b99:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b9e:	e9 f6 ef ff ff       	jmp    80105b99 <alltraps>

80106ba3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $249
80106ba5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106baa:	e9 ea ef ff ff       	jmp    80105b99 <alltraps>

80106baf <vector250>:
.globl vector250
vector250:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $250
80106bb1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106bb6:	e9 de ef ff ff       	jmp    80105b99 <alltraps>

80106bbb <vector251>:
.globl vector251
vector251:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $251
80106bbd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106bc2:	e9 d2 ef ff ff       	jmp    80105b99 <alltraps>

80106bc7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $252
80106bc9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106bce:	e9 c6 ef ff ff       	jmp    80105b99 <alltraps>

80106bd3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $253
80106bd5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106bda:	e9 ba ef ff ff       	jmp    80105b99 <alltraps>

80106bdf <vector254>:
.globl vector254
vector254:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $254
80106be1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106be6:	e9 ae ef ff ff       	jmp    80105b99 <alltraps>

80106beb <vector255>:
.globl vector255
vector255:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $255
80106bed:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106bf2:	e9 a2 ef ff ff       	jmp    80105b99 <alltraps>
80106bf7:	66 90                	xchg   %ax,%ax
80106bf9:	66 90                	xchg   %ax,%ax
80106bfb:	66 90                	xchg   %ax,%ax
80106bfd:	66 90                	xchg   %ax,%ax
80106bff:	90                   	nop

80106c00 <cow_kfree>:
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc);
int swap_in(struct proc* p, struct pageinfo* pi);
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir);

void cow_kfree(char* to_free_kva){
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	56                   	push   %esi
80106c04:	53                   	push   %ebx
80106c05:	8b 75 08             	mov    0x8(%ebp),%esi
  char count;
  int acq = 0;
  if (lapicid() != 0 && !holding(cow_lock)){
80106c08:	e8 e3 bf ff ff       	call   80102bf0 <lapicid>
80106c0d:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
80106c13:	c1 eb 0c             	shr    $0xc,%ebx
80106c16:	85 c0                	test   %eax,%eax
80106c18:	75 36                	jne    80106c50 <cow_kfree+0x50>
    acquire(cow_lock);
  }
  // struct proc* p = myproc();
  // if (p != 0 ){ // && p->pid > 2
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
  if (count != 0){
80106c1a:	80 ab 40 0f 11 80 01 	subb   $0x1,-0x7feef0c0(%ebx)
80106c21:	74 1e                	je     80106c41 <cow_kfree+0x41>
  if (acq){
    // cprintf("rel kfree %d\n", myproc()->pid);
    release(cow_lock);
  }
  kfree(to_free_kva);
}
80106c23:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106c26:	5b                   	pop    %ebx
80106c27:	5e                   	pop    %esi
80106c28:	5d                   	pop    %ebp
80106c29:	c3                   	ret    
80106c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(cow_lock);
80106c30:	83 ec 0c             	sub    $0xc,%esp
80106c33:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106c39:	e8 e2 dc ff ff       	call   80104920 <release>
80106c3e:	83 c4 10             	add    $0x10,%esp
  kfree(to_free_kva);
80106c41:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106c44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106c47:	5b                   	pop    %ebx
80106c48:	5e                   	pop    %esi
80106c49:	5d                   	pop    %ebp
  kfree(to_free_kva);
80106c4a:	e9 51 bb ff ff       	jmp    801027a0 <kfree>
80106c4f:	90                   	nop
  if (lapicid() != 0 && !holding(cow_lock)){
80106c50:	83 ec 0c             	sub    $0xc,%esp
80106c53:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106c59:	e8 d2 db ff ff       	call   80104830 <holding>
80106c5e:	83 c4 10             	add    $0x10,%esp
80106c61:	85 c0                	test   %eax,%eax
80106c63:	75 b5                	jne    80106c1a <cow_kfree+0x1a>
    acquire(cow_lock);
80106c65:	83 ec 0c             	sub    $0xc,%esp
80106c68:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106c6e:	e8 ed db ff ff       	call   80104860 <acquire>
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
80106c73:	0f b6 83 40 0f 11 80 	movzbl -0x7feef0c0(%ebx),%eax
  if (count != 0){
80106c7a:	83 c4 10             	add    $0x10,%esp
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
80106c7d:	83 e8 01             	sub    $0x1,%eax
  if (count != 0){
80106c80:	84 c0                	test   %al,%al
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
80106c82:	88 83 40 0f 11 80    	mov    %al,-0x7feef0c0(%ebx)
  if (count != 0){
80106c88:	74 a6                	je     80106c30 <cow_kfree+0x30>
      release(cow_lock);
80106c8a:	a1 40 ef 11 80       	mov    0x8011ef40,%eax
80106c8f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80106c92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106c95:	5b                   	pop    %ebx
80106c96:	5e                   	pop    %esi
80106c97:	5d                   	pop    %ebp
      release(cow_lock);
80106c98:	e9 83 dc ff ff       	jmp    80104920 <release>
80106c9d:	8d 76 00             	lea    0x0(%esi),%esi

80106ca0 <cow_kalloc>:

char* cow_kalloc(){
80106ca0:	55                   	push   %ebp
80106ca1:	89 e5                	mov    %esp,%ebp
80106ca3:	57                   	push   %edi
80106ca4:	56                   	push   %esi
80106ca5:	53                   	push   %ebx
80106ca6:	83 ec 0c             	sub    $0xc,%esp
  char* r = kalloc();
80106ca9:	e8 d2 bc ff ff       	call   80102980 <kalloc>
  if (r == 0){
80106cae:	85 c0                	test   %eax,%eax
  char* r = kalloc();
80106cb0:	89 c3                	mov    %eax,%ebx
  if (r == 0){
80106cb2:	74 28                	je     80106cdc <cow_kalloc+0x3c>
80106cb4:	8d bb 00 00 00 80    	lea    -0x80000000(%ebx),%edi
    return r;
  }
  int acq = 0;
  // cprintf("kalloc \n");
  if (lapicid() != 0 && !holding(cow_lock)){
80106cba:	e8 31 bf ff ff       	call   80102bf0 <lapicid>
80106cbf:	89 fe                	mov    %edi,%esi
80106cc1:	c1 ee 0c             	shr    $0xc,%esi
80106cc4:	85 c0                	test   %eax,%eax
80106cc6:	75 28                	jne    80106cf0 <cow_kalloc+0x50>
    acq = 1;
    // cprintf("kalloc %d\n", myproc()->pid);
    acquire(cow_lock);
  }
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
80106cc8:	0f b6 86 40 0f 11 80 	movzbl -0x7feef0c0(%esi),%eax
80106ccf:	8d 50 01             	lea    0x1(%eax),%edx
80106cd2:	84 c0                	test   %al,%al
80106cd4:	88 96 40 0f 11 80    	mov    %dl,-0x7feef0c0(%esi)
80106cda:	75 69                	jne    80106d45 <cow_kalloc+0xa5>
  }
  if (acq){
    release(cow_lock);
  }
  return r;
}
80106cdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cdf:	89 d8                	mov    %ebx,%eax
80106ce1:	5b                   	pop    %ebx
80106ce2:	5e                   	pop    %esi
80106ce3:	5f                   	pop    %edi
80106ce4:	5d                   	pop    %ebp
80106ce5:	c3                   	ret    
80106ce6:	8d 76 00             	lea    0x0(%esi),%esi
80106ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if (lapicid() != 0 && !holding(cow_lock)){
80106cf0:	83 ec 0c             	sub    $0xc,%esp
80106cf3:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106cf9:	e8 32 db ff ff       	call   80104830 <holding>
80106cfe:	83 c4 10             	add    $0x10,%esp
80106d01:	85 c0                	test   %eax,%eax
80106d03:	75 c3                	jne    80106cc8 <cow_kalloc+0x28>
    acquire(cow_lock);
80106d05:	83 ec 0c             	sub    $0xc,%esp
80106d08:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106d0e:	e8 4d db ff ff       	call   80104860 <acquire>
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
80106d13:	0f b6 86 40 0f 11 80 	movzbl -0x7feef0c0(%esi),%eax
80106d1a:	83 c4 10             	add    $0x10,%esp
80106d1d:	8d 50 01             	lea    0x1(%eax),%edx
80106d20:	84 c0                	test   %al,%al
80106d22:	88 96 40 0f 11 80    	mov    %dl,-0x7feef0c0(%esi)
80106d28:	75 1b                	jne    80106d45 <cow_kalloc+0xa5>
      release(cow_lock);
80106d2a:	83 ec 0c             	sub    $0xc,%esp
80106d2d:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106d33:	e8 e8 db ff ff       	call   80104920 <release>
80106d38:	83 c4 10             	add    $0x10,%esp
}
80106d3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d3e:	89 d8                	mov    %ebx,%eax
80106d40:	5b                   	pop    %ebx
80106d41:	5e                   	pop    %esi
80106d42:	5f                   	pop    %edi
80106d43:	5d                   	pop    %ebp
80106d44:	c3                   	ret    
    cprintf("actual ref count = %d, pg index = %x, pg pa = %x\n", pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE] - 1, PGROUNDDOWN(V2P(r)) / PGSIZE, V2P(r));
80106d45:	0f be c2             	movsbl %dl,%eax
80106d48:	57                   	push   %edi
80106d49:	56                   	push   %esi
80106d4a:	83 e8 01             	sub    $0x1,%eax
80106d4d:	50                   	push   %eax
80106d4e:	68 d0 81 10 80       	push   $0x801081d0
80106d53:	e8 08 99 ff ff       	call   80100660 <cprintf>
    panic("kalloc allocated something with a reference");
80106d58:	c7 04 24 04 82 10 80 	movl   $0x80108204,(%esp)
80106d5f:	e8 2c 96 ff ff       	call   80100390 <panic>
80106d64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d70 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106d76:	89 d3                	mov    %edx,%ebx
{
80106d78:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106d7a:	c1 eb 16             	shr    $0x16,%ebx
80106d7d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106d80:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106d83:	8b 06                	mov    (%esi),%eax
80106d85:	a8 01                	test   $0x1,%al
80106d87:	74 27                	je     80106db0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d8e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106d94:	c1 ef 0a             	shr    $0xa,%edi
}
80106d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106d9a:	89 fa                	mov    %edi,%edx
80106d9c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106da2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106da5:	5b                   	pop    %ebx
80106da6:	5e                   	pop    %esi
80106da7:	5f                   	pop    %edi
80106da8:	5d                   	pop    %ebp
80106da9:	c3                   	ret    
80106daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)cow_kalloc()) == 0)
80106db0:	85 c9                	test   %ecx,%ecx
80106db2:	74 2c                	je     80106de0 <walkpgdir+0x70>
80106db4:	e8 e7 fe ff ff       	call   80106ca0 <cow_kalloc>
80106db9:	85 c0                	test   %eax,%eax
80106dbb:	89 c3                	mov    %eax,%ebx
80106dbd:	74 21                	je     80106de0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106dbf:	83 ec 04             	sub    $0x4,%esp
80106dc2:	68 00 10 00 00       	push   $0x1000
80106dc7:	6a 00                	push   $0x0
80106dc9:	50                   	push   %eax
80106dca:	e8 a1 db ff ff       	call   80104970 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106dcf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106dd5:	83 c4 10             	add    $0x10,%esp
80106dd8:	83 c8 07             	or     $0x7,%eax
80106ddb:	89 06                	mov    %eax,(%esi)
80106ddd:	eb b5                	jmp    80106d94 <walkpgdir+0x24>
80106ddf:	90                   	nop
}
80106de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106de3:	31 c0                	xor    %eax,%eax
}
80106de5:	5b                   	pop    %ebx
80106de6:	5e                   	pop    %esi
80106de7:	5f                   	pop    %edi
80106de8:	5d                   	pop    %ebp
80106de9:	c3                   	ret    
80106dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106df0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106df6:	89 d3                	mov    %edx,%ebx
80106df8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106dfe:	83 ec 1c             	sub    $0x1c,%esp
80106e01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e04:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106e08:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106e13:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e16:	29 df                	sub    %ebx,%edi
80106e18:	83 c8 01             	or     $0x1,%eax
80106e1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106e1e:	eb 15                	jmp    80106e35 <mappages+0x45>
    if(*pte & PTE_P)
80106e20:	f6 00 01             	testb  $0x1,(%eax)
80106e23:	75 45                	jne    80106e6a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106e25:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106e28:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106e2b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106e2d:	74 31                	je     80106e60 <mappages+0x70>
      break;
    a += PGSIZE;
80106e2f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106e35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e38:	b9 01 00 00 00       	mov    $0x1,%ecx
80106e3d:	89 da                	mov    %ebx,%edx
80106e3f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106e42:	e8 29 ff ff ff       	call   80106d70 <walkpgdir>
80106e47:	85 c0                	test   %eax,%eax
80106e49:	75 d5                	jne    80106e20 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e53:	5b                   	pop    %ebx
80106e54:	5e                   	pop    %esi
80106e55:	5f                   	pop    %edi
80106e56:	5d                   	pop    %ebp
80106e57:	c3                   	ret    
80106e58:	90                   	nop
80106e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e63:	31 c0                	xor    %eax,%eax
}
80106e65:	5b                   	pop    %ebx
80106e66:	5e                   	pop    %esi
80106e67:	5f                   	pop    %edi
80106e68:	5d                   	pop    %ebp
80106e69:	c3                   	ret    
      panic("remap");
80106e6a:	83 ec 0c             	sub    $0xc,%esp
80106e6d:	68 54 82 10 80       	push   $0x80108254
80106e72:	e8 19 95 ff ff       	call   80100390 <panic>
80106e77:	89 f6                	mov    %esi,%esi
80106e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e80 <deallocuvm.part.2>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	57                   	push   %edi
80106e84:	56                   	push   %esi
80106e85:	53                   	push   %ebx
  #endif
  
  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106e86:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e8c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106e8e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e94:	83 ec 1c             	sub    $0x1c,%esp
80106e97:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106e9a:	39 d3                	cmp    %edx,%ebx
80106e9c:	73 66                	jae    80106f04 <deallocuvm.part.2+0x84>
80106e9e:	89 d6                	mov    %edx,%esi
80106ea0:	eb 3d                	jmp    80106edf <deallocuvm.part.2+0x5f>
80106ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if ((*pte & PTE_P) != 0){
80106ea8:	8b 10                	mov    (%eax),%edx
80106eaa:	f6 c2 01             	test   $0x1,%dl
80106ead:	74 26                	je     80106ed5 <deallocuvm.part.2+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106eaf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106eb5:	74 58                	je     80106f0f <deallocuvm.part.2+0x8f>
        panic("cow_kfree");
      char *v = P2V(pa);
      cow_kfree(v);
80106eb7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106eba:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ec0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      cow_kfree(v);
80106ec3:	52                   	push   %edx
80106ec4:	e8 37 fd ff ff       	call   80106c00 <cow_kfree>
            break;
          }
        }
      }
      #endif
      *pte = 0;
80106ec9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ecc:	83 c4 10             	add    $0x10,%esp
80106ecf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106ed5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106edb:	39 f3                	cmp    %esi,%ebx
80106edd:	73 25                	jae    80106f04 <deallocuvm.part.2+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106edf:	31 c9                	xor    %ecx,%ecx
80106ee1:	89 da                	mov    %ebx,%edx
80106ee3:	89 f8                	mov    %edi,%eax
80106ee5:	e8 86 fe ff ff       	call   80106d70 <walkpgdir>
    if(!pte)
80106eea:	85 c0                	test   %eax,%eax
80106eec:	75 ba                	jne    80106ea8 <deallocuvm.part.2+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106eee:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106ef4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106efa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f00:	39 f3                	cmp    %esi,%ebx
80106f02:	72 db                	jb     80106edf <deallocuvm.part.2+0x5f>
    }
  }

  return newsz;
}
80106f04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f0a:	5b                   	pop    %ebx
80106f0b:	5e                   	pop    %esi
80106f0c:	5f                   	pop    %edi
80106f0d:	5d                   	pop    %ebp
80106f0e:	c3                   	ret    
        panic("cow_kfree");
80106f0f:	83 ec 0c             	sub    $0xc,%esp
80106f12:	68 5a 82 10 80       	push   $0x8010825a
80106f17:	e8 74 94 ff ff       	call   80100390 <panic>
80106f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f20 <print_user_char>:
void print_user_char(pde_t* pgdir, void* uva){
80106f20:	55                   	push   %ebp
  cprintf("%x\n", *(char *) P2V(PTE_ADDR(*(walkpgdir(pgdir, uva, 0)))));
80106f21:	31 c9                	xor    %ecx,%ecx
void print_user_char(pde_t* pgdir, void* uva){
80106f23:	89 e5                	mov    %esp,%ebp
80106f25:	83 ec 08             	sub    $0x8,%esp
  cprintf("%x\n", *(char *) P2V(PTE_ADDR(*(walkpgdir(pgdir, uva, 0)))));
80106f28:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f2e:	e8 3d fe ff ff       	call   80106d70 <walkpgdir>
80106f33:	8b 00                	mov    (%eax),%eax
80106f35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f3a:	0f be 80 00 00 00 80 	movsbl -0x80000000(%eax),%eax
80106f41:	c7 45 08 69 83 10 80 	movl   $0x80108369,0x8(%ebp)
80106f48:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106f4b:	c9                   	leave  
  cprintf("%x\n", *(char *) P2V(PTE_ADDR(*(walkpgdir(pgdir, uva, 0)))));
80106f4c:	e9 0f 97 ff ff       	jmp    80100660 <cprintf>
80106f51:	eb 0d                	jmp    80106f60 <seginit>
80106f53:	90                   	nop
80106f54:	90                   	nop
80106f55:	90                   	nop
80106f56:	90                   	nop
80106f57:	90                   	nop
80106f58:	90                   	nop
80106f59:	90                   	nop
80106f5a:	90                   	nop
80106f5b:	90                   	nop
80106f5c:	90                   	nop
80106f5d:	90                   	nop
80106f5e:	90                   	nop
80106f5f:	90                   	nop

80106f60 <seginit>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106f66:	e8 25 cd ff ff       	call   80103c90 <cpuid>
80106f6b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106f71:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106f76:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f7a:	c7 80 78 18 12 80 ff 	movl   $0xffff,-0x7fede788(%eax)
80106f81:	ff 00 00 
80106f84:	c7 80 7c 18 12 80 00 	movl   $0xcf9a00,-0x7fede784(%eax)
80106f8b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f8e:	c7 80 80 18 12 80 ff 	movl   $0xffff,-0x7fede780(%eax)
80106f95:	ff 00 00 
80106f98:	c7 80 84 18 12 80 00 	movl   $0xcf9200,-0x7fede77c(%eax)
80106f9f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106fa2:	c7 80 88 18 12 80 ff 	movl   $0xffff,-0x7fede778(%eax)
80106fa9:	ff 00 00 
80106fac:	c7 80 8c 18 12 80 00 	movl   $0xcffa00,-0x7fede774(%eax)
80106fb3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106fb6:	c7 80 90 18 12 80 ff 	movl   $0xffff,-0x7fede770(%eax)
80106fbd:	ff 00 00 
80106fc0:	c7 80 94 18 12 80 00 	movl   $0xcff200,-0x7fede76c(%eax)
80106fc7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106fca:	05 70 18 12 80       	add    $0x80121870,%eax
  pd[1] = (uint)p;
80106fcf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106fd3:	c1 e8 10             	shr    $0x10,%eax
80106fd6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106fda:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106fdd:	0f 01 10             	lgdtl  (%eax)
}
80106fe0:	c9                   	leave  
80106fe1:	c3                   	ret    
80106fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ff0 <public_walkpgdir>:
public_walkpgdir(pde_t *pgdir, const void *va, int alloc){
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, va, alloc);
80106ff3:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ff9:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106ffc:	5d                   	pop    %ebp
  return walkpgdir(pgdir, va, alloc);
80106ffd:	e9 6e fd ff ff       	jmp    80106d70 <walkpgdir>
80107002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107010 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107010:	a1 24 1a 13 80       	mov    0x80131a24,%eax
{
80107015:	55                   	push   %ebp
80107016:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107018:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010701d:	0f 22 d8             	mov    %eax,%cr3
}
80107020:	5d                   	pop    %ebp
80107021:	c3                   	ret    
80107022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107030 <switchuvm>:
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	57                   	push   %edi
80107034:	56                   	push   %esi
80107035:	53                   	push   %ebx
80107036:	83 ec 1c             	sub    $0x1c,%esp
80107039:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010703c:	85 db                	test   %ebx,%ebx
8010703e:	0f 84 cb 00 00 00    	je     8010710f <switchuvm+0xdf>
  if(p->kstack == 0)
80107044:	8b 43 08             	mov    0x8(%ebx),%eax
80107047:	85 c0                	test   %eax,%eax
80107049:	0f 84 da 00 00 00    	je     80107129 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010704f:	8b 43 04             	mov    0x4(%ebx),%eax
80107052:	85 c0                	test   %eax,%eax
80107054:	0f 84 c2 00 00 00    	je     8010711c <switchuvm+0xec>
  pushcli();
8010705a:	e8 31 d7 ff ff       	call   80104790 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010705f:	e8 9c cb ff ff       	call   80103c00 <mycpu>
80107064:	89 c6                	mov    %eax,%esi
80107066:	e8 95 cb ff ff       	call   80103c00 <mycpu>
8010706b:	89 c7                	mov    %eax,%edi
8010706d:	e8 8e cb ff ff       	call   80103c00 <mycpu>
80107072:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107075:	83 c7 08             	add    $0x8,%edi
80107078:	e8 83 cb ff ff       	call   80103c00 <mycpu>
8010707d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107080:	83 c0 08             	add    $0x8,%eax
80107083:	ba 67 00 00 00       	mov    $0x67,%edx
80107088:	c1 e8 18             	shr    $0x18,%eax
8010708b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107092:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107099:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010709f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801070a4:	83 c1 08             	add    $0x8,%ecx
801070a7:	c1 e9 10             	shr    $0x10,%ecx
801070aa:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801070b0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801070b5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801070bc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801070c1:	e8 3a cb ff ff       	call   80103c00 <mycpu>
801070c6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801070cd:	e8 2e cb ff ff       	call   80103c00 <mycpu>
801070d2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801070d6:	8b 73 08             	mov    0x8(%ebx),%esi
801070d9:	e8 22 cb ff ff       	call   80103c00 <mycpu>
801070de:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070e4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801070e7:	e8 14 cb ff ff       	call   80103c00 <mycpu>
801070ec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801070f0:	b8 28 00 00 00       	mov    $0x28,%eax
801070f5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801070f8:	8b 43 04             	mov    0x4(%ebx),%eax
801070fb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107100:	0f 22 d8             	mov    %eax,%cr3
}
80107103:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107106:	5b                   	pop    %ebx
80107107:	5e                   	pop    %esi
80107108:	5f                   	pop    %edi
80107109:	5d                   	pop    %ebp
  popcli();
8010710a:	e9 c1 d6 ff ff       	jmp    801047d0 <popcli>
    panic("switchuvm: no process");
8010710f:	83 ec 0c             	sub    $0xc,%esp
80107112:	68 64 82 10 80       	push   $0x80108264
80107117:	e8 74 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010711c:	83 ec 0c             	sub    $0xc,%esp
8010711f:	68 8f 82 10 80       	push   $0x8010828f
80107124:	e8 67 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107129:	83 ec 0c             	sub    $0xc,%esp
8010712c:	68 7a 82 10 80       	push   $0x8010827a
80107131:	e8 5a 92 ff ff       	call   80100390 <panic>
80107136:	8d 76 00             	lea    0x0(%esi),%esi
80107139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107140 <inituvm>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 1c             	sub    $0x1c,%esp
80107149:	8b 75 10             	mov    0x10(%ebp),%esi
8010714c:	8b 45 08             	mov    0x8(%ebp),%eax
8010714f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107152:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107158:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010715b:	77 49                	ja     801071a6 <inituvm+0x66>
  mem = cow_kalloc();
8010715d:	e8 3e fb ff ff       	call   80106ca0 <cow_kalloc>
  memset(mem, 0, PGSIZE);
80107162:	83 ec 04             	sub    $0x4,%esp
  mem = cow_kalloc();
80107165:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107167:	68 00 10 00 00       	push   $0x1000
8010716c:	6a 00                	push   $0x0
8010716e:	50                   	push   %eax
8010716f:	e8 fc d7 ff ff       	call   80104970 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107174:	58                   	pop    %eax
80107175:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010717b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107180:	5a                   	pop    %edx
80107181:	6a 06                	push   $0x6
80107183:	50                   	push   %eax
80107184:	31 d2                	xor    %edx,%edx
80107186:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107189:	e8 62 fc ff ff       	call   80106df0 <mappages>
  memmove(mem, init, sz);
8010718e:	89 75 10             	mov    %esi,0x10(%ebp)
80107191:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107194:	83 c4 10             	add    $0x10,%esp
80107197:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010719a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010719d:	5b                   	pop    %ebx
8010719e:	5e                   	pop    %esi
8010719f:	5f                   	pop    %edi
801071a0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801071a1:	e9 7a d8 ff ff       	jmp    80104a20 <memmove>
    panic("inituvm: more than a page");
801071a6:	83 ec 0c             	sub    $0xc,%esp
801071a9:	68 a3 82 10 80       	push   $0x801082a3
801071ae:	e8 dd 91 ff ff       	call   80100390 <panic>
801071b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071c0 <loaduvm>:
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	57                   	push   %edi
801071c4:	56                   	push   %esi
801071c5:	53                   	push   %ebx
801071c6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801071c9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801071d0:	0f 85 91 00 00 00    	jne    80107267 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801071d6:	8b 75 18             	mov    0x18(%ebp),%esi
801071d9:	31 db                	xor    %ebx,%ebx
801071db:	85 f6                	test   %esi,%esi
801071dd:	75 1a                	jne    801071f9 <loaduvm+0x39>
801071df:	eb 6f                	jmp    80107250 <loaduvm+0x90>
801071e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071ee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801071f4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801071f7:	76 57                	jbe    80107250 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801071f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801071fc:	8b 45 08             	mov    0x8(%ebp),%eax
801071ff:	31 c9                	xor    %ecx,%ecx
80107201:	01 da                	add    %ebx,%edx
80107203:	e8 68 fb ff ff       	call   80106d70 <walkpgdir>
80107208:	85 c0                	test   %eax,%eax
8010720a:	74 4e                	je     8010725a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010720c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010720e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107211:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107216:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010721b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107221:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107224:	01 d9                	add    %ebx,%ecx
80107226:	05 00 00 00 80       	add    $0x80000000,%eax
8010722b:	57                   	push   %edi
8010722c:	51                   	push   %ecx
8010722d:	50                   	push   %eax
8010722e:	ff 75 10             	pushl  0x10(%ebp)
80107231:	e8 da a7 ff ff       	call   80101a10 <readi>
80107236:	83 c4 10             	add    $0x10,%esp
80107239:	39 f8                	cmp    %edi,%eax
8010723b:	74 ab                	je     801071e8 <loaduvm+0x28>
}
8010723d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107245:	5b                   	pop    %ebx
80107246:	5e                   	pop    %esi
80107247:	5f                   	pop    %edi
80107248:	5d                   	pop    %ebp
80107249:	c3                   	ret    
8010724a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107250:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107253:	31 c0                	xor    %eax,%eax
}
80107255:	5b                   	pop    %ebx
80107256:	5e                   	pop    %esi
80107257:	5f                   	pop    %edi
80107258:	5d                   	pop    %ebp
80107259:	c3                   	ret    
      panic("loaduvm: address should exist");
8010725a:	83 ec 0c             	sub    $0xc,%esp
8010725d:	68 bd 82 10 80       	push   $0x801082bd
80107262:	e8 29 91 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107267:	83 ec 0c             	sub    $0xc,%esp
8010726a:	68 30 82 10 80       	push   $0x80108230
8010726f:	e8 1c 91 ff ff       	call   80100390 <panic>
80107274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010727a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107280 <allocuvm>:
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	57                   	push   %edi
80107284:	56                   	push   %esi
80107285:	53                   	push   %ebx
80107286:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107289:	8b 7d 10             	mov    0x10(%ebp),%edi
8010728c:	85 ff                	test   %edi,%edi
8010728e:	0f 88 8e 00 00 00    	js     80107322 <allocuvm+0xa2>
  if(newsz < oldsz)
80107294:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107297:	0f 82 93 00 00 00    	jb     80107330 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010729d:	8b 45 0c             	mov    0xc(%ebp),%eax
801072a0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801072a6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801072ac:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801072af:	0f 86 7e 00 00 00    	jbe    80107333 <allocuvm+0xb3>
801072b5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801072b8:	8b 7d 08             	mov    0x8(%ebp),%edi
801072bb:	eb 42                	jmp    801072ff <allocuvm+0x7f>
801072bd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801072c0:	83 ec 04             	sub    $0x4,%esp
801072c3:	68 00 10 00 00       	push   $0x1000
801072c8:	6a 00                	push   $0x0
801072ca:	50                   	push   %eax
801072cb:	e8 a0 d6 ff ff       	call   80104970 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0){
801072d0:	58                   	pop    %eax
801072d1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801072d7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072dc:	5a                   	pop    %edx
801072dd:	6a 06                	push   $0x6
801072df:	50                   	push   %eax
801072e0:	89 da                	mov    %ebx,%edx
801072e2:	89 f8                	mov    %edi,%eax
801072e4:	e8 07 fb ff ff       	call   80106df0 <mappages>
801072e9:	83 c4 10             	add    $0x10,%esp
801072ec:	85 c0                	test   %eax,%eax
801072ee:	78 50                	js     80107340 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801072f0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072f6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801072f9:	0f 86 81 00 00 00    	jbe    80107380 <allocuvm+0x100>
    mem = cow_kalloc();
801072ff:	e8 9c f9 ff ff       	call   80106ca0 <cow_kalloc>
    if(mem == 0){
80107304:	85 c0                	test   %eax,%eax
    mem = cow_kalloc();
80107306:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107308:	75 b6                	jne    801072c0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010730a:	83 ec 0c             	sub    $0xc,%esp
8010730d:	68 db 82 10 80       	push   $0x801082db
80107312:	e8 49 93 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107317:	83 c4 10             	add    $0x10,%esp
8010731a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010731d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107320:	77 6e                	ja     80107390 <allocuvm+0x110>
}
80107322:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107325:	31 ff                	xor    %edi,%edi
}
80107327:	89 f8                	mov    %edi,%eax
80107329:	5b                   	pop    %ebx
8010732a:	5e                   	pop    %esi
8010732b:	5f                   	pop    %edi
8010732c:	5d                   	pop    %ebp
8010732d:	c3                   	ret    
8010732e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107330:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107333:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107336:	89 f8                	mov    %edi,%eax
80107338:	5b                   	pop    %ebx
80107339:	5e                   	pop    %esi
8010733a:	5f                   	pop    %edi
8010733b:	5d                   	pop    %ebp
8010733c:	c3                   	ret    
8010733d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107340:	83 ec 0c             	sub    $0xc,%esp
80107343:	68 f3 82 10 80       	push   $0x801082f3
80107348:	e8 13 93 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010734d:	83 c4 10             	add    $0x10,%esp
80107350:	8b 45 0c             	mov    0xc(%ebp),%eax
80107353:	39 45 10             	cmp    %eax,0x10(%ebp)
80107356:	76 0d                	jbe    80107365 <allocuvm+0xe5>
80107358:	89 c1                	mov    %eax,%ecx
8010735a:	8b 55 10             	mov    0x10(%ebp),%edx
8010735d:	8b 45 08             	mov    0x8(%ebp),%eax
80107360:	e8 1b fb ff ff       	call   80106e80 <deallocuvm.part.2>
      cow_kfree(mem);
80107365:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107368:	31 ff                	xor    %edi,%edi
      cow_kfree(mem);
8010736a:	56                   	push   %esi
8010736b:	e8 90 f8 ff ff       	call   80106c00 <cow_kfree>
      return 0;
80107370:	83 c4 10             	add    $0x10,%esp
}
80107373:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107376:	89 f8                	mov    %edi,%eax
80107378:	5b                   	pop    %ebx
80107379:	5e                   	pop    %esi
8010737a:	5f                   	pop    %edi
8010737b:	5d                   	pop    %ebp
8010737c:	c3                   	ret    
8010737d:	8d 76 00             	lea    0x0(%esi),%esi
80107380:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107383:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107386:	5b                   	pop    %ebx
80107387:	89 f8                	mov    %edi,%eax
80107389:	5e                   	pop    %esi
8010738a:	5f                   	pop    %edi
8010738b:	5d                   	pop    %ebp
8010738c:	c3                   	ret    
8010738d:	8d 76 00             	lea    0x0(%esi),%esi
80107390:	89 c1                	mov    %eax,%ecx
80107392:	8b 55 10             	mov    0x10(%ebp),%edx
80107395:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107398:	31 ff                	xor    %edi,%edi
8010739a:	e8 e1 fa ff ff       	call   80106e80 <deallocuvm.part.2>
8010739f:	eb 92                	jmp    80107333 <allocuvm+0xb3>
801073a1:	eb 0d                	jmp    801073b0 <deallocuvm>
801073a3:	90                   	nop
801073a4:	90                   	nop
801073a5:	90                   	nop
801073a6:	90                   	nop
801073a7:	90                   	nop
801073a8:	90                   	nop
801073a9:	90                   	nop
801073aa:	90                   	nop
801073ab:	90                   	nop
801073ac:	90                   	nop
801073ad:	90                   	nop
801073ae:	90                   	nop
801073af:	90                   	nop

801073b0 <deallocuvm>:
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801073b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801073b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801073bc:	39 d1                	cmp    %edx,%ecx
801073be:	73 10                	jae    801073d0 <deallocuvm+0x20>
}
801073c0:	5d                   	pop    %ebp
801073c1:	e9 ba fa ff ff       	jmp    80106e80 <deallocuvm.part.2>
801073c6:	8d 76 00             	lea    0x0(%esi),%esi
801073c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801073d0:	89 d0                	mov    %edx,%eax
801073d2:	5d                   	pop    %ebp
801073d3:	c3                   	ret    
801073d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801073e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	57                   	push   %edi
801073e4:	56                   	push   %esi
801073e5:	53                   	push   %ebx
801073e6:	83 ec 0c             	sub    $0xc,%esp
801073e9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;
  
  if(pgdir == 0)
801073ec:	85 f6                	test   %esi,%esi
801073ee:	74 59                	je     80107449 <freevm+0x69>
801073f0:	31 c9                	xor    %ecx,%ecx
801073f2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801073f7:	89 f0                	mov    %esi,%eax
801073f9:	e8 82 fa ff ff       	call   80106e80 <deallocuvm.part.2>
801073fe:	89 f3                	mov    %esi,%ebx
80107400:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107406:	eb 0f                	jmp    80107417 <freevm+0x37>
80107408:	90                   	nop
80107409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107410:	83 c3 04             	add    $0x4,%ebx
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
    }
  }
  #endif
  for(i = 0; i < NPDENTRIES; i++){
80107413:	39 fb                	cmp    %edi,%ebx
80107415:	74 23                	je     8010743a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107417:	8b 03                	mov    (%ebx),%eax
80107419:	a8 01                	test   $0x1,%al
8010741b:	74 f3                	je     80107410 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010741d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      cow_kfree(v);
80107422:	83 ec 0c             	sub    $0xc,%esp
80107425:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107428:	05 00 00 00 80       	add    $0x80000000,%eax
      cow_kfree(v);
8010742d:	50                   	push   %eax
8010742e:	e8 cd f7 ff ff       	call   80106c00 <cow_kfree>
80107433:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107436:	39 fb                	cmp    %edi,%ebx
80107438:	75 dd                	jne    80107417 <freevm+0x37>
    }
  }
   cow_kfree((char*)pgdir);
8010743a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010743d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107440:	5b                   	pop    %ebx
80107441:	5e                   	pop    %esi
80107442:	5f                   	pop    %edi
80107443:	5d                   	pop    %ebp
   cow_kfree((char*)pgdir);
80107444:	e9 b7 f7 ff ff       	jmp    80106c00 <cow_kfree>
    panic("freevm: no pgdir");
80107449:	83 ec 0c             	sub    $0xc,%esp
8010744c:	68 0f 83 10 80       	push   $0x8010830f
80107451:	e8 3a 8f ff ff       	call   80100390 <panic>
80107456:	8d 76 00             	lea    0x0(%esi),%esi
80107459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107460 <setupkvm>:
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	56                   	push   %esi
80107464:	53                   	push   %ebx
  if((pgdir = (pde_t*)cow_kalloc()) == 0)
80107465:	e8 36 f8 ff ff       	call   80106ca0 <cow_kalloc>
8010746a:	85 c0                	test   %eax,%eax
8010746c:	89 c6                	mov    %eax,%esi
8010746e:	74 42                	je     801074b2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107470:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
80107473:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107478:	68 00 10 00 00       	push   $0x1000
8010747d:	6a 00                	push   $0x0
8010747f:	50                   	push   %eax
80107480:	e8 eb d4 ff ff       	call   80104970 <memset>
80107485:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107488:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010748b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010748e:	83 ec 08             	sub    $0x8,%esp
80107491:	8b 13                	mov    (%ebx),%edx
80107493:	ff 73 0c             	pushl  0xc(%ebx)
80107496:	50                   	push   %eax
80107497:	29 c1                	sub    %eax,%ecx
80107499:	89 f0                	mov    %esi,%eax
8010749b:	e8 50 f9 ff ff       	call   80106df0 <mappages>
801074a0:	83 c4 10             	add    $0x10,%esp
801074a3:	85 c0                	test   %eax,%eax
801074a5:	78 19                	js     801074c0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
801074a7:	83 c3 10             	add    $0x10,%ebx
801074aa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801074b0:	75 d6                	jne    80107488 <setupkvm+0x28>
}
801074b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074b5:	89 f0                	mov    %esi,%eax
801074b7:	5b                   	pop    %ebx
801074b8:	5e                   	pop    %esi
801074b9:	5d                   	pop    %ebp
801074ba:	c3                   	ret    
801074bb:	90                   	nop
801074bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801074c0:	83 ec 0c             	sub    $0xc,%esp
801074c3:	56                   	push   %esi
      return 0;
801074c4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801074c6:	e8 15 ff ff ff       	call   801073e0 <freevm>
      return 0;
801074cb:	83 c4 10             	add    $0x10,%esp
}
801074ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074d1:	89 f0                	mov    %esi,%eax
801074d3:	5b                   	pop    %ebx
801074d4:	5e                   	pop    %esi
801074d5:	5d                   	pop    %ebp
801074d6:	c3                   	ret    
801074d7:	89 f6                	mov    %esi,%esi
801074d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074e0 <kvmalloc>:
{
801074e0:	55                   	push   %ebp
801074e1:	89 e5                	mov    %esp,%ebp
801074e3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801074e6:	e8 75 ff ff ff       	call   80107460 <setupkvm>
801074eb:	a3 24 1a 13 80       	mov    %eax,0x80131a24
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801074f0:	05 00 00 00 80       	add    $0x80000000,%eax
801074f5:	0f 22 d8             	mov    %eax,%cr3
}
801074f8:	c9                   	leave  
801074f9:	c3                   	ret    
801074fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107500 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107500:	55                   	push   %ebp
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
80107501:	31 c9                	xor    %ecx,%ecx
{
80107503:	89 e5                	mov    %esp,%ebp
80107505:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107508:	8b 55 0c             	mov    0xc(%ebp),%edx
8010750b:	8b 45 08             	mov    0x8(%ebp),%eax
8010750e:	e8 5d f8 ff ff       	call   80106d70 <walkpgdir>
  if(pte == 0)
80107513:	85 c0                	test   %eax,%eax
80107515:	74 05                	je     8010751c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107517:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010751a:	c9                   	leave  
8010751b:	c3                   	ret    
    panic("clearpteu");
8010751c:	83 ec 0c             	sub    $0xc,%esp
8010751f:	68 20 83 10 80       	push   $0x80108320
80107524:	e8 67 8e ff ff       	call   80100390 <panic>
80107529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107530 <cow_copyuvm>:

pde_t*
cow_copyuvm(pde_t *pgdir, uint sz)
{
80107530:	55                   	push   %ebp
80107531:	89 e5                	mov    %esp,%ebp
80107533:	57                   	push   %edi
80107534:	56                   	push   %esi
80107535:	53                   	push   %ebx
80107536:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags, newflags;
  if((d = setupkvm()) == 0)
80107539:	e8 22 ff ff ff       	call   80107460 <setupkvm>
8010753e:	85 c0                	test   %eax,%eax
80107540:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107543:	0f 84 d5 00 00 00    	je     8010761e <cow_copyuvm+0xee>
    return 0;
  //cprintf("cow : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());

  // cprintf("cow_copyuvm : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());
  for(i = 0; i < sz; i += PGSIZE){
80107549:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010754c:	85 db                	test   %ebx,%ebx
8010754e:	0f 84 dc 00 00 00    	je     80107630 <cow_copyuvm+0x100>
80107554:	31 ff                	xor    %edi,%edi
80107556:	eb 27                	jmp    8010757f <cow_copyuvm+0x4f>
80107558:	90                   	nop
80107559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      // cprintf("cow2");
      goto bad;
    }
    // cprintf("cow2");
    // update parents flags
    *pte |= PTE_FLAGS((PTE_W & flags ? PTE_COW : 0));
80107560:	c1 e3 0a             	shl    $0xa,%ebx
  for(i = 0; i < sz; i += PGSIZE){
80107563:	81 c7 00 10 00 00    	add    $0x1000,%edi
    *pte |= PTE_FLAGS((PTE_W & flags ? PTE_COW : 0));
80107569:	81 e3 00 08 00 00    	and    $0x800,%ebx
8010756f:	0b 1e                	or     (%esi),%ebx
    *pte &= ~PTE_W;
80107571:	83 e3 fd             	and    $0xfffffffd,%ebx
  for(i = 0; i < sz; i += PGSIZE){
80107574:	39 7d 0c             	cmp    %edi,0xc(%ebp)
    *pte &= ~PTE_W;
80107577:	89 1e                	mov    %ebx,(%esi)
  for(i = 0; i < sz; i += PGSIZE){
80107579:	0f 86 b1 00 00 00    	jbe    80107630 <cow_copyuvm+0x100>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010757f:	8b 45 08             	mov    0x8(%ebp),%eax
80107582:	31 c9                	xor    %ecx,%ecx
80107584:	89 fa                	mov    %edi,%edx
80107586:	e8 e5 f7 ff ff       	call   80106d70 <walkpgdir>
8010758b:	85 c0                	test   %eax,%eax
8010758d:	89 c6                	mov    %eax,%esi
8010758f:	0f 84 db 00 00 00    	je     80107670 <cow_copyuvm+0x140>
    if(!(*pte & PTE_P))
80107595:	8b 18                	mov    (%eax),%ebx
80107597:	f6 c3 01             	test   $0x1,%bl
8010759a:	0f 84 c3 00 00 00    	je     80107663 <cow_copyuvm+0x133>
    pa = PTE_ADDR(*pte);
801075a0:	89 d8                	mov    %ebx,%eax
801075a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801075a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    newflags = flags & (~PTE_W);
801075aa:	89 d8                	mov    %ebx,%eax
801075ac:	25 fd 0f 00 00       	and    $0xffd,%eax
      newflags |= PTE_COW;
801075b1:	89 c2                	mov    %eax,%edx
801075b3:	80 ce 08             	or     $0x8,%dh
801075b6:	f6 c3 02             	test   $0x2,%bl
801075b9:	0f 45 c2             	cmovne %edx,%eax
    acquire(cow_lock);
801075bc:	83 ec 0c             	sub    $0xc,%esp
801075bf:	ff 35 40 ef 11 80    	pushl  0x8011ef40
      newflags |= PTE_COW;
801075c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    acquire(cow_lock);
801075c8:	e8 93 d2 ff ff       	call   80104860 <acquire>
    release(cow_lock);
801075cd:	58                   	pop    %eax
    pg_ref_counts[PGROUNDDOWN(pa)/PGSIZE]++;
801075ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    release(cow_lock);
801075d1:	ff 35 40 ef 11 80    	pushl  0x8011ef40
    pg_ref_counts[PGROUNDDOWN(pa)/PGSIZE]++;
801075d7:	c1 ea 0c             	shr    $0xc,%edx
801075da:	80 82 40 0f 11 80 01 	addb   $0x1,-0x7feef0c0(%edx)
    release(cow_lock);
801075e1:	e8 3a d3 ff ff       	call   80104920 <release>
    if(mappages(d, (void*)i, PGSIZE, pa, newflags) < 0) {
801075e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075e9:	5a                   	pop    %edx
801075ea:	59                   	pop    %ecx
801075eb:	50                   	push   %eax
801075ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801075ef:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801075f7:	89 fa                	mov    %edi,%edx
801075f9:	e8 f2 f7 ff ff       	call   80106df0 <mappages>
801075fe:	83 c4 10             	add    $0x10,%esp
80107601:	85 c0                	test   %eax,%eax
80107603:	0f 89 57 ff ff ff    	jns    80107560 <cow_copyuvm+0x30>
  lcr3(V2P(pgdir));
  return d;

bad:
  // release(cow_lock);
  freevm(d);
80107609:	83 ec 0c             	sub    $0xc,%esp
8010760c:	ff 75 dc             	pushl  -0x24(%ebp)
8010760f:	e8 cc fd ff ff       	call   801073e0 <freevm>
  return 0;
80107614:	83 c4 10             	add    $0x10,%esp
80107617:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
8010761e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107621:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107624:	5b                   	pop    %ebx
80107625:	5e                   	pop    %esi
80107626:	5f                   	pop    %edi
80107627:	5d                   	pop    %ebp
80107628:	c3                   	ret    
80107629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("movl %%cr3,%0" : "=r" (val));
80107630:	0f 20 d8             	mov    %cr3,%eax
  if (rcr3() != V2P(pgdir)){
80107633:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107636:	8d 99 00 00 00 80    	lea    -0x80000000(%ecx),%ebx
8010763c:	39 c3                	cmp    %eax,%ebx
8010763e:	74 15                	je     80107655 <cow_copyuvm+0x125>
80107640:	0f 20 d8             	mov    %cr3,%eax
    cprintf("old %x new %x\n", rcr3(), V2P(pgdir));
80107643:	83 ec 04             	sub    $0x4,%esp
80107646:	53                   	push   %ebx
80107647:	50                   	push   %eax
80107648:	68 5e 83 10 80       	push   $0x8010835e
8010764d:	e8 0e 90 ff ff       	call   80100660 <cprintf>
80107652:	83 c4 10             	add    $0x10,%esp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107655:	0f 22 db             	mov    %ebx,%cr3
}
80107658:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010765b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010765e:	5b                   	pop    %ebx
8010765f:	5e                   	pop    %esi
80107660:	5f                   	pop    %edi
80107661:	5d                   	pop    %ebp
80107662:	c3                   	ret    
      panic("copyuvm: page not present");
80107663:	83 ec 0c             	sub    $0xc,%esp
80107666:	68 44 83 10 80       	push   $0x80108344
8010766b:	e8 20 8d ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107670:	83 ec 0c             	sub    $0xc,%esp
80107673:	68 2a 83 10 80       	push   $0x8010832a
80107678:	e8 13 8d ff ff       	call   80100390 <panic>
8010767d:	8d 76 00             	lea    0x0(%esi),%esi

80107680 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107680:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107681:	31 c9                	xor    %ecx,%ecx
{
80107683:	89 e5                	mov    %esp,%ebp
80107685:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107688:	8b 55 0c             	mov    0xc(%ebp),%edx
8010768b:	8b 45 08             	mov    0x8(%ebp),%eax
8010768e:	e8 dd f6 ff ff       	call   80106d70 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107693:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107695:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107696:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107698:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010769d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801076a0:	05 00 00 00 80       	add    $0x80000000,%eax
801076a5:	83 fa 05             	cmp    $0x5,%edx
801076a8:	ba 00 00 00 00       	mov    $0x0,%edx
801076ad:	0f 45 c2             	cmovne %edx,%eax
}
801076b0:	c3                   	ret    
801076b1:	eb 0d                	jmp    801076c0 <copyout>
801076b3:	90                   	nop
801076b4:	90                   	nop
801076b5:	90                   	nop
801076b6:	90                   	nop
801076b7:	90                   	nop
801076b8:	90                   	nop
801076b9:	90                   	nop
801076ba:	90                   	nop
801076bb:	90                   	nop
801076bc:	90                   	nop
801076bd:	90                   	nop
801076be:	90                   	nop
801076bf:	90                   	nop

801076c0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801076c0:	55                   	push   %ebp
801076c1:	89 e5                	mov    %esp,%ebp
801076c3:	57                   	push   %edi
801076c4:	56                   	push   %esi
801076c5:	53                   	push   %ebx
801076c6:	83 ec 1c             	sub    $0x1c,%esp
801076c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801076cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801076cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801076d2:	85 db                	test   %ebx,%ebx
801076d4:	75 40                	jne    80107716 <copyout+0x56>
801076d6:	eb 70                	jmp    80107748 <copyout+0x88>
801076d8:	90                   	nop
801076d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801076e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801076e3:	89 f1                	mov    %esi,%ecx
801076e5:	29 d1                	sub    %edx,%ecx
801076e7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801076ed:	39 d9                	cmp    %ebx,%ecx
801076ef:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801076f2:	29 f2                	sub    %esi,%edx
801076f4:	83 ec 04             	sub    $0x4,%esp
801076f7:	01 d0                	add    %edx,%eax
801076f9:	51                   	push   %ecx
801076fa:	57                   	push   %edi
801076fb:	50                   	push   %eax
801076fc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801076ff:	e8 1c d3 ff ff       	call   80104a20 <memmove>
    len -= n;
    buf += n;
80107704:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107707:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010770a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107710:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107712:	29 cb                	sub    %ecx,%ebx
80107714:	74 32                	je     80107748 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107716:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107718:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010771b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010771e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107724:	56                   	push   %esi
80107725:	ff 75 08             	pushl  0x8(%ebp)
80107728:	e8 53 ff ff ff       	call   80107680 <uva2ka>
    if(pa0 == 0)
8010772d:	83 c4 10             	add    $0x10,%esp
80107730:	85 c0                	test   %eax,%eax
80107732:	75 ac                	jne    801076e0 <copyout+0x20>
  }
  return 0;
}
80107734:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107737:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010773c:	5b                   	pop    %ebx
8010773d:	5e                   	pop    %esi
8010773e:	5f                   	pop    %edi
8010773f:	5d                   	pop    %ebp
80107740:	c3                   	ret    
80107741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107748:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010774b:	31 c0                	xor    %eax,%eax
}
8010774d:	5b                   	pop    %ebx
8010774e:	5e                   	pop    %esi
8010774f:	5f                   	pop    %edi
80107750:	5d                   	pop    %ebp
80107751:	c3                   	ret    
80107752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107760 <copy_page>:
    #endif
    swap_in(p, pi_to_swapin);
  }
}
#endif
int copy_page(pde_t* pgdir, pte_t* pte_ptr){
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	57                   	push   %edi
80107764:	56                   	push   %esi
80107765:	53                   	push   %ebx
80107766:	83 ec 0c             	sub    $0xc,%esp
80107769:	8b 75 0c             	mov    0xc(%ebp),%esi
  
  uint pa = PTE_ADDR(*pte_ptr);
8010776c:	8b 3e                	mov    (%esi),%edi
  // release(cow_lock);
  char* mem = cow_kalloc();
8010776e:	e8 2d f5 ff ff       	call   80106ca0 <cow_kalloc>
  uint pa = PTE_ADDR(*pte_ptr);
80107773:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  // acquire(cow_lock);
  if (mem == 0){
80107779:	85 c0                	test   %eax,%eax
8010777b:	74 43                	je     801077c0 <copy_page+0x60>
    return -1;
  }

  // cprintf("copying page old pa %x new pa %x\n", pa, V2P(mem));

  memmove(mem, P2V(pa), PGSIZE);
8010777d:	83 ec 04             	sub    $0x4,%esp
80107780:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107786:	89 c3                	mov    %eax,%ebx
80107788:	68 00 10 00 00       	push   $0x1000
8010778d:	57                   	push   %edi

  // *pte_ptr = PTE_ADDR(P2V(mem)) | PTE_U | PTE_W | PTE_P;
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_FLAGS(*pte_ptr) | PTE_W | PTE_P | PTE_U;
8010778e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
80107794:	50                   	push   %eax
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_FLAGS(*pte_ptr) | PTE_W | PTE_P | PTE_U;
80107795:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
8010779b:	e8 80 d2 ff ff       	call   80104a20 <memmove>
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_FLAGS(*pte_ptr) | PTE_W | PTE_P | PTE_U;
801077a0:	8b 06                	mov    (%esi),%eax
  return 0;
801077a2:	83 c4 10             	add    $0x10,%esp
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_FLAGS(*pte_ptr) | PTE_W | PTE_P | PTE_U;
801077a5:	25 ff 0f 00 00       	and    $0xfff,%eax
801077aa:	83 c8 07             	or     $0x7,%eax
801077ad:	09 c3                	or     %eax,%ebx
  return 0;
801077af:	31 c0                	xor    %eax,%eax
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_FLAGS(*pte_ptr) | PTE_W | PTE_P | PTE_U;
801077b1:	89 1e                	mov    %ebx,(%esi)
}
801077b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077b6:	5b                   	pop    %ebx
801077b7:	5e                   	pop    %esi
801077b8:	5f                   	pop    %edi
801077b9:	5d                   	pop    %ebp
801077ba:	c3                   	ret    
801077bb:	90                   	nop
801077bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801077c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077c5:	eb ec                	jmp    801077b3 <copy_page+0x53>
