
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
8010002d:	b8 50 33 10 80       	mov    $0x80103350,%eax
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
8010004c:	68 a0 77 10 80       	push   $0x801077a0
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
80100092:	68 a7 77 10 80       	push   $0x801077a7
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
8010017e:	e8 cd 23 00 00       	call   80102550 <iderw>
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
80100193:	68 ae 77 10 80       	push   $0x801077ae
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
801001c4:	e9 87 23 00 00       	jmp    80102550 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 77 10 80       	push   $0x801077bf
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
80100264:	68 c6 77 10 80       	push   $0x801077c6
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
80100280:	e8 7b 15 00 00       	call   80101800 <iunlock>
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
801002db:	e8 c0 39 00 00       	call   80103ca0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 2c 46 00 00       	call   80104920 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 24 14 00 00       	call   80101720 <ilock>
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
80100355:	e8 c6 13 00 00       	call   80101720 <ilock>
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
801003a9:	e8 32 28 00 00       	call   80102be0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 cd 77 10 80       	push   $0x801077cd
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 79 82 10 80 	movl   $0x80108279,(%esp)
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
801003e8:	68 e1 77 10 80       	push   $0x801077e1
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
8010043a:	e8 a1 5c 00 00       	call   801060e0 <uartputc>
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
801004ec:	e8 ef 5b 00 00       	call   801060e0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 e3 5b 00 00       	call   801060e0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 d7 5b 00 00       	call   801060e0 <uartputc>
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
80100551:	68 e5 77 10 80       	push   $0x801077e5
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
801005b1:	0f b6 92 10 78 10 80 	movzbl -0x7fef87f0(%edx),%edx
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
8010060f:	e8 ec 11 00 00       	call   80101800 <iunlock>
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
80100650:	e8 cb 10 00 00       	call   80101720 <ilock>

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
801007d0:	ba f8 77 10 80       	mov    $0x801077f8,%edx
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
80100800:	68 ff 77 10 80       	push   $0x801077ff
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
801009c6:	68 08 78 10 80       	push   $0x80107808
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
801009f9:	e8 02 1d 00 00       	call   80102700 <ioapicenable>
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
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 df 31 00 00       	call   80103ca0 <myproc>
80100ac1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  struct pageinfo swp_pginfo_bu[MAX_PYSC_PAGES];
  int advance_q_bu[MAX_PYSC_PAGES];
  struct file* swap_file_bu = 0;
  struct file* temp_swap_file = 0;
  #endif
  begin_op();
80100ac7:	e8 84 25 00 00       	call   80103050 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	pushl  0x8(%ebp)
80100ad2:	e8 a9 14 00 00       	call   80101f80 <namei>
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
80100ae8:	e8 33 0c 00 00       	call   80101720 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 02 0f 00 00       	call   80101a00 <readi>
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
80100b0a:	e8 a1 0e 00 00       	call   801019b0 <iunlockput>
    end_op();
80100b0f:	e8 ac 25 00 00       	call   801030c0 <end_op>
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
80100b34:	e8 57 68 00 00       	call   80107390 <setupkvm>
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
80100b59:	0f 84 8c 02 00 00    	je     80100deb <exec+0x33b>
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
80100b96:	e8 15 66 00 00       	call   801071b0 <allocuvm>
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
80100bc8:	e8 23 65 00 00       	call   801070f0 <loaduvm>
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
80100bf8:	e8 03 0e 00 00       	call   80101a00 <readi>
80100bfd:	83 c4 10             	add    $0x10,%esp
80100c00:	83 f8 20             	cmp    $0x20,%eax
80100c03:	0f 84 5f ff ff ff    	je     80100b68 <exec+0xb8>
    freevm(pgdir);
80100c09:	83 ec 0c             	sub    $0xc,%esp
80100c0c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c12:	e8 f9 66 00 00       	call   80107310 <freevm>
80100c17:	83 c4 10             	add    $0x10,%esp
80100c1a:	e9 e7 fe ff ff       	jmp    80100b06 <exec+0x56>
80100c1f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c25:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c2b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c31:	83 ec 0c             	sub    $0xc,%esp
80100c34:	53                   	push   %ebx
80100c35:	e8 76 0d 00 00       	call   801019b0 <iunlockput>
  end_op();
80100c3a:	e8 81 24 00 00       	call   801030c0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c3f:	83 c4 0c             	add    $0xc,%esp
80100c42:	56                   	push   %esi
80100c43:	57                   	push   %edi
80100c44:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c4a:	e8 61 65 00 00       	call   801071b0 <allocuvm>
80100c4f:	83 c4 10             	add    $0x10,%esp
80100c52:	85 c0                	test   %eax,%eax
80100c54:	89 c6                	mov    %eax,%esi
80100c56:	75 3a                	jne    80100c92 <exec+0x1e2>
    freevm(pgdir);
80100c58:	83 ec 0c             	sub    $0xc,%esp
80100c5b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c61:	e8 aa 66 00 00       	call   80107310 <freevm>
80100c66:	83 c4 10             	add    $0x10,%esp
  return -1;
80100c69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c6e:	e9 a9 fe ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100c73:	e8 48 24 00 00       	call   801030c0 <end_op>
    cprintf("exec: fail\n");
80100c78:	83 ec 0c             	sub    $0xc,%esp
80100c7b:	68 21 78 10 80       	push   $0x80107821
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
80100ca6:	e8 85 67 00 00       	call   80107430 <clearpteu>
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
80100cfd:	e8 9e 69 00 00       	call   801076a0 <copyout>
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
80100d67:	e8 34 69 00 00       	call   801076a0 <copyout>
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
80100da4:	89 f8                	mov    %edi,%eax
80100da6:	83 c0 6c             	add    $0x6c,%eax
80100da9:	50                   	push   %eax
80100daa:	e8 a1 3d 00 00       	call   80104b50 <safestrcpy>
  curproc->pgdir = pgdir;
80100daf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100db5:	89 f9                	mov    %edi,%ecx
80100db7:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100dba:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100dbd:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100dbf:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100dc2:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dc8:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dcb:	8b 41 18             	mov    0x18(%ecx),%eax
80100dce:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dd1:	89 0c 24             	mov    %ecx,(%esp)
80100dd4:	e8 87 61 00 00       	call   80106f60 <switchuvm>
  freevm(oldpgdir);
80100dd9:	89 3c 24             	mov    %edi,(%esp)
80100ddc:	e8 2f 65 00 00       	call   80107310 <freevm>
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
80100de4:	31 c0                	xor    %eax,%eax
80100de6:	e9 31 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100deb:	be 00 20 00 00       	mov    $0x2000,%esi
80100df0:	e9 3c fe ff ff       	jmp    80100c31 <exec+0x181>
80100df5:	66 90                	xchg   %ax,%ax
80100df7:	66 90                	xchg   %ax,%ax
80100df9:	66 90                	xchg   %ax,%ax
80100dfb:	66 90                	xchg   %ax,%ax
80100dfd:	66 90                	xchg   %ax,%ax
80100dff:	90                   	nop

80100e00 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e06:	68 2d 78 10 80       	push   $0x8010782d
80100e0b:	68 00 f0 11 80       	push   $0x8011f000
80100e10:	e8 0b 39 00 00       	call   80104720 <initlock>
}
80100e15:	83 c4 10             	add    $0x10,%esp
80100e18:	c9                   	leave  
80100e19:	c3                   	ret    
80100e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e20 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e24:	bb 34 f0 11 80       	mov    $0x8011f034,%ebx
{
80100e29:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e2c:	68 00 f0 11 80       	push   $0x8011f000
80100e31:	e8 2a 3a 00 00       	call   80104860 <acquire>
80100e36:	83 c4 10             	add    $0x10,%esp
80100e39:	eb 10                	jmp    80100e4b <filealloc+0x2b>
80100e3b:	90                   	nop
80100e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e40:	83 c3 18             	add    $0x18,%ebx
80100e43:	81 fb 94 f9 11 80    	cmp    $0x8011f994,%ebx
80100e49:	73 25                	jae    80100e70 <filealloc+0x50>
    if(f->ref == 0){
80100e4b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e4e:	85 c0                	test   %eax,%eax
80100e50:	75 ee                	jne    80100e40 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e52:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e55:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e5c:	68 00 f0 11 80       	push   $0x8011f000
80100e61:	e8 ba 3a 00 00       	call   80104920 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e66:	89 d8                	mov    %ebx,%eax
      return f;
80100e68:	83 c4 10             	add    $0x10,%esp
}
80100e6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e6e:	c9                   	leave  
80100e6f:	c3                   	ret    
  release(&ftable.lock);
80100e70:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e73:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e75:	68 00 f0 11 80       	push   $0x8011f000
80100e7a:	e8 a1 3a 00 00       	call   80104920 <release>
}
80100e7f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e81:	83 c4 10             	add    $0x10,%esp
}
80100e84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e87:	c9                   	leave  
80100e88:	c3                   	ret    
80100e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e90 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e90:	55                   	push   %ebp
80100e91:	89 e5                	mov    %esp,%ebp
80100e93:	53                   	push   %ebx
80100e94:	83 ec 10             	sub    $0x10,%esp
80100e97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e9a:	68 00 f0 11 80       	push   $0x8011f000
80100e9f:	e8 bc 39 00 00       	call   80104860 <acquire>
  if(f->ref < 1)
80100ea4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ea7:	83 c4 10             	add    $0x10,%esp
80100eaa:	85 c0                	test   %eax,%eax
80100eac:	7e 1a                	jle    80100ec8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100eae:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100eb1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100eb4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100eb7:	68 00 f0 11 80       	push   $0x8011f000
80100ebc:	e8 5f 3a 00 00       	call   80104920 <release>
  return f;
}
80100ec1:	89 d8                	mov    %ebx,%eax
80100ec3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ec6:	c9                   	leave  
80100ec7:	c3                   	ret    
    panic("filedup");
80100ec8:	83 ec 0c             	sub    $0xc,%esp
80100ecb:	68 34 78 10 80       	push   $0x80107834
80100ed0:	e8 bb f4 ff ff       	call   80100390 <panic>
80100ed5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ee0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	57                   	push   %edi
80100ee4:	56                   	push   %esi
80100ee5:	53                   	push   %ebx
80100ee6:	83 ec 28             	sub    $0x28,%esp
80100ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100eec:	68 00 f0 11 80       	push   $0x8011f000
80100ef1:	e8 6a 39 00 00       	call   80104860 <acquire>
  if(f->ref < 1)
80100ef6:	8b 43 04             	mov    0x4(%ebx),%eax
80100ef9:	83 c4 10             	add    $0x10,%esp
80100efc:	85 c0                	test   %eax,%eax
80100efe:	0f 8e 9b 00 00 00    	jle    80100f9f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f04:	83 e8 01             	sub    $0x1,%eax
80100f07:	85 c0                	test   %eax,%eax
80100f09:	89 43 04             	mov    %eax,0x4(%ebx)
80100f0c:	74 1a                	je     80100f28 <fileclose+0x48>
    release(&ftable.lock);
80100f0e:	c7 45 08 00 f0 11 80 	movl   $0x8011f000,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f18:	5b                   	pop    %ebx
80100f19:	5e                   	pop    %esi
80100f1a:	5f                   	pop    %edi
80100f1b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f1c:	e9 ff 39 00 00       	jmp    80104920 <release>
80100f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100f28:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100f2c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100f2e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f31:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100f34:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f3a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f3d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f40:	68 00 f0 11 80       	push   $0x8011f000
  ff = *f;
80100f45:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f48:	e8 d3 39 00 00       	call   80104920 <release>
  if(ff.type == FD_PIPE)
80100f4d:	83 c4 10             	add    $0x10,%esp
80100f50:	83 ff 01             	cmp    $0x1,%edi
80100f53:	74 13                	je     80100f68 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100f55:	83 ff 02             	cmp    $0x2,%edi
80100f58:	74 26                	je     80100f80 <fileclose+0xa0>
}
80100f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5d:	5b                   	pop    %ebx
80100f5e:	5e                   	pop    %esi
80100f5f:	5f                   	pop    %edi
80100f60:	5d                   	pop    %ebp
80100f61:	c3                   	ret    
80100f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100f68:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f6c:	83 ec 08             	sub    $0x8,%esp
80100f6f:	53                   	push   %ebx
80100f70:	56                   	push   %esi
80100f71:	e8 8a 28 00 00       	call   80103800 <pipeclose>
80100f76:	83 c4 10             	add    $0x10,%esp
80100f79:	eb df                	jmp    80100f5a <fileclose+0x7a>
80100f7b:	90                   	nop
80100f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f80:	e8 cb 20 00 00       	call   80103050 <begin_op>
    iput(ff.ip);
80100f85:	83 ec 0c             	sub    $0xc,%esp
80100f88:	ff 75 e0             	pushl  -0x20(%ebp)
80100f8b:	e8 c0 08 00 00       	call   80101850 <iput>
    end_op();
80100f90:	83 c4 10             	add    $0x10,%esp
}
80100f93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f96:	5b                   	pop    %ebx
80100f97:	5e                   	pop    %esi
80100f98:	5f                   	pop    %edi
80100f99:	5d                   	pop    %ebp
    end_op();
80100f9a:	e9 21 21 00 00       	jmp    801030c0 <end_op>
    panic("fileclose");
80100f9f:	83 ec 0c             	sub    $0xc,%esp
80100fa2:	68 3c 78 10 80       	push   $0x8010783c
80100fa7:	e8 e4 f3 ff ff       	call   80100390 <panic>
80100fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fb0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fb0:	55                   	push   %ebp
80100fb1:	89 e5                	mov    %esp,%ebp
80100fb3:	53                   	push   %ebx
80100fb4:	83 ec 04             	sub    $0x4,%esp
80100fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fba:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fbd:	75 31                	jne    80100ff0 <filestat+0x40>
    ilock(f->ip);
80100fbf:	83 ec 0c             	sub    $0xc,%esp
80100fc2:	ff 73 10             	pushl  0x10(%ebx)
80100fc5:	e8 56 07 00 00       	call   80101720 <ilock>
    stati(f->ip, st);
80100fca:	58                   	pop    %eax
80100fcb:	5a                   	pop    %edx
80100fcc:	ff 75 0c             	pushl  0xc(%ebp)
80100fcf:	ff 73 10             	pushl  0x10(%ebx)
80100fd2:	e8 f9 09 00 00       	call   801019d0 <stati>
    iunlock(f->ip);
80100fd7:	59                   	pop    %ecx
80100fd8:	ff 73 10             	pushl  0x10(%ebx)
80100fdb:	e8 20 08 00 00       	call   80101800 <iunlock>
    return 0;
80100fe0:	83 c4 10             	add    $0x10,%esp
80100fe3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ff5:	eb ee                	jmp    80100fe5 <filestat+0x35>
80100ff7:	89 f6                	mov    %esi,%esi
80100ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101000 <fileread>:

// Read from file f.
int
fileread(struct file* f, char *addr, int n)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	57                   	push   %edi
80101004:	56                   	push   %esi
80101005:	53                   	push   %ebx
80101006:	83 ec 0c             	sub    $0xc,%esp
80101009:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010100c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010100f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101012:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101016:	74 60                	je     80101078 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101018:	8b 03                	mov    (%ebx),%eax
8010101a:	83 f8 01             	cmp    $0x1,%eax
8010101d:	74 41                	je     80101060 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101f:	83 f8 02             	cmp    $0x2,%eax
80101022:	75 5b                	jne    8010107f <fileread+0x7f>
    ilock(f->ip);
80101024:	83 ec 0c             	sub    $0xc,%esp
80101027:	ff 73 10             	pushl  0x10(%ebx)
8010102a:	e8 f1 06 00 00       	call   80101720 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010102f:	57                   	push   %edi
80101030:	ff 73 14             	pushl  0x14(%ebx)
80101033:	56                   	push   %esi
80101034:	ff 73 10             	pushl  0x10(%ebx)
80101037:	e8 c4 09 00 00       	call   80101a00 <readi>
8010103c:	83 c4 20             	add    $0x20,%esp
8010103f:	85 c0                	test   %eax,%eax
80101041:	89 c6                	mov    %eax,%esi
80101043:	7e 03                	jle    80101048 <fileread+0x48>
      f->off += r;
80101045:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101048:	83 ec 0c             	sub    $0xc,%esp
8010104b:	ff 73 10             	pushl  0x10(%ebx)
8010104e:	e8 ad 07 00 00       	call   80101800 <iunlock>
    return r;
80101053:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101059:	89 f0                	mov    %esi,%eax
8010105b:	5b                   	pop    %ebx
8010105c:	5e                   	pop    %esi
8010105d:	5f                   	pop    %edi
8010105e:	5d                   	pop    %ebp
8010105f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101060:	8b 43 0c             	mov    0xc(%ebx),%eax
80101063:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101066:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101069:	5b                   	pop    %ebx
8010106a:	5e                   	pop    %esi
8010106b:	5f                   	pop    %edi
8010106c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010106d:	e9 3e 29 00 00       	jmp    801039b0 <piperead>
80101072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101078:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010107d:	eb d7                	jmp    80101056 <fileread+0x56>
  panic("fileread");
8010107f:	83 ec 0c             	sub    $0xc,%esp
80101082:	68 46 78 10 80       	push   $0x80107846
80101087:	e8 04 f3 ff ff       	call   80100390 <panic>
8010108c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	57                   	push   %edi
80101094:	56                   	push   %esi
80101095:	53                   	push   %ebx
80101096:	83 ec 1c             	sub    $0x1c,%esp
80101099:	8b 75 08             	mov    0x8(%ebp),%esi
8010109c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010109f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
801010a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010ac:	0f 84 aa 00 00 00    	je     8010115c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801010b2:	8b 06                	mov    (%esi),%eax
801010b4:	83 f8 01             	cmp    $0x1,%eax
801010b7:	0f 84 c3 00 00 00    	je     80101180 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010bd:	83 f8 02             	cmp    $0x2,%eax
801010c0:	0f 85 d9 00 00 00    	jne    8010119f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010c9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cb:	85 c0                	test   %eax,%eax
801010cd:	7f 34                	jg     80101103 <filewrite+0x73>
801010cf:	e9 9c 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010d8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010db:	83 ec 0c             	sub    $0xc,%esp
801010de:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010e4:	e8 17 07 00 00       	call   80101800 <iunlock>
      end_op();
801010e9:	e8 d2 1f 00 00       	call   801030c0 <end_op>
801010ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801010f4:	39 c3                	cmp    %eax,%ebx
801010f6:	0f 85 96 00 00 00    	jne    80101192 <filewrite+0x102>
        panic("short filewrite");
      i += r;
801010fc:	01 df                	add    %ebx,%edi
    while(i < n){
801010fe:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101101:	7e 6d                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101103:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101106:	b8 00 06 00 00       	mov    $0x600,%eax
8010110b:	29 fb                	sub    %edi,%ebx
8010110d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101113:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101116:	e8 35 1f 00 00       	call   80103050 <begin_op>
      ilock(f->ip);
8010111b:	83 ec 0c             	sub    $0xc,%esp
8010111e:	ff 76 10             	pushl  0x10(%esi)
80101121:	e8 fa 05 00 00       	call   80101720 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101126:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101129:	53                   	push   %ebx
8010112a:	ff 76 14             	pushl  0x14(%esi)
8010112d:	01 f8                	add    %edi,%eax
8010112f:	50                   	push   %eax
80101130:	ff 76 10             	pushl  0x10(%esi)
80101133:	e8 c8 09 00 00       	call   80101b00 <writei>
80101138:	83 c4 20             	add    $0x20,%esp
8010113b:	85 c0                	test   %eax,%eax
8010113d:	7f 99                	jg     801010d8 <filewrite+0x48>
      iunlock(f->ip);
8010113f:	83 ec 0c             	sub    $0xc,%esp
80101142:	ff 76 10             	pushl  0x10(%esi)
80101145:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101148:	e8 b3 06 00 00       	call   80101800 <iunlock>
      end_op();
8010114d:	e8 6e 1f 00 00       	call   801030c0 <end_op>
      if(r < 0)
80101152:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101155:	83 c4 10             	add    $0x10,%esp
80101158:	85 c0                	test   %eax,%eax
8010115a:	74 98                	je     801010f4 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010115c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010115f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101164:	89 f8                	mov    %edi,%eax
80101166:	5b                   	pop    %ebx
80101167:	5e                   	pop    %esi
80101168:	5f                   	pop    %edi
80101169:	5d                   	pop    %ebp
8010116a:	c3                   	ret    
8010116b:	90                   	nop
8010116c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101170:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101173:	75 e7                	jne    8010115c <filewrite+0xcc>
}
80101175:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101178:	89 f8                	mov    %edi,%eax
8010117a:	5b                   	pop    %ebx
8010117b:	5e                   	pop    %esi
8010117c:	5f                   	pop    %edi
8010117d:	5d                   	pop    %ebp
8010117e:	c3                   	ret    
8010117f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101180:	8b 46 0c             	mov    0xc(%esi),%eax
80101183:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101189:	5b                   	pop    %ebx
8010118a:	5e                   	pop    %esi
8010118b:	5f                   	pop    %edi
8010118c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010118d:	e9 0e 27 00 00       	jmp    801038a0 <pipewrite>
        panic("short filewrite");
80101192:	83 ec 0c             	sub    $0xc,%esp
80101195:	68 4f 78 10 80       	push   $0x8010784f
8010119a:	e8 f1 f1 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010119f:	83 ec 0c             	sub    $0xc,%esp
801011a2:	68 55 78 10 80       	push   $0x80107855
801011a7:	e8 e4 f1 ff ff       	call   80100390 <panic>
801011ac:	66 90                	xchg   %ax,%ax
801011ae:	66 90                	xchg   %ax,%ax

801011b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	56                   	push   %esi
801011b4:	53                   	push   %ebx
801011b5:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011b7:	c1 ea 0c             	shr    $0xc,%edx
801011ba:	03 15 18 fa 11 80    	add    0x8011fa18,%edx
801011c0:	83 ec 08             	sub    $0x8,%esp
801011c3:	52                   	push   %edx
801011c4:	50                   	push   %eax
801011c5:	e8 06 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ca:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011cc:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011cf:	ba 01 00 00 00       	mov    $0x1,%edx
801011d4:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011d7:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011dd:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011e0:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011e2:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011e7:	85 d1                	test   %edx,%ecx
801011e9:	74 25                	je     80101210 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011eb:	f7 d2                	not    %edx
801011ed:	89 c6                	mov    %eax,%esi
  log_write(bp);
801011ef:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801011f2:	21 ca                	and    %ecx,%edx
801011f4:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801011f8:	56                   	push   %esi
801011f9:	e8 22 20 00 00       	call   80103220 <log_write>
  brelse(bp);
801011fe:	89 34 24             	mov    %esi,(%esp)
80101201:	e8 da ef ff ff       	call   801001e0 <brelse>
}
80101206:	83 c4 10             	add    $0x10,%esp
80101209:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010120c:	5b                   	pop    %ebx
8010120d:	5e                   	pop    %esi
8010120e:	5d                   	pop    %ebp
8010120f:	c3                   	ret    
    panic("freeing free block");
80101210:	83 ec 0c             	sub    $0xc,%esp
80101213:	68 5f 78 10 80       	push   $0x8010785f
80101218:	e8 73 f1 ff ff       	call   80100390 <panic>
8010121d:	8d 76 00             	lea    0x0(%esi),%esi

80101220 <balloc>:
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101229:	8b 0d 00 fa 11 80    	mov    0x8011fa00,%ecx
{
8010122f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101232:	85 c9                	test   %ecx,%ecx
80101234:	0f 84 87 00 00 00    	je     801012c1 <balloc+0xa1>
8010123a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101241:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101244:	83 ec 08             	sub    $0x8,%esp
80101247:	89 f0                	mov    %esi,%eax
80101249:	c1 f8 0c             	sar    $0xc,%eax
8010124c:	03 05 18 fa 11 80    	add    0x8011fa18,%eax
80101252:	50                   	push   %eax
80101253:	ff 75 d8             	pushl  -0x28(%ebp)
80101256:	e8 75 ee ff ff       	call   801000d0 <bread>
8010125b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010125e:	a1 00 fa 11 80       	mov    0x8011fa00,%eax
80101263:	83 c4 10             	add    $0x10,%esp
80101266:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101269:	31 c0                	xor    %eax,%eax
8010126b:	eb 2f                	jmp    8010129c <balloc+0x7c>
8010126d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101270:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101272:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101275:	bb 01 00 00 00       	mov    $0x1,%ebx
8010127a:	83 e1 07             	and    $0x7,%ecx
8010127d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010127f:	89 c1                	mov    %eax,%ecx
80101281:	c1 f9 03             	sar    $0x3,%ecx
80101284:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101289:	85 df                	test   %ebx,%edi
8010128b:	89 fa                	mov    %edi,%edx
8010128d:	74 41                	je     801012d0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010128f:	83 c0 01             	add    $0x1,%eax
80101292:	83 c6 01             	add    $0x1,%esi
80101295:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010129a:	74 05                	je     801012a1 <balloc+0x81>
8010129c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010129f:	77 cf                	ja     80101270 <balloc+0x50>
    brelse(bp);
801012a1:	83 ec 0c             	sub    $0xc,%esp
801012a4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012a7:	e8 34 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012ac:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012b3:	83 c4 10             	add    $0x10,%esp
801012b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012b9:	39 05 00 fa 11 80    	cmp    %eax,0x8011fa00
801012bf:	77 80                	ja     80101241 <balloc+0x21>
  panic("balloc: out of blocks");
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	68 72 78 10 80       	push   $0x80107872
801012c9:	e8 c2 f0 ff ff       	call   80100390 <panic>
801012ce:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012d3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012d6:	09 da                	or     %ebx,%edx
801012d8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012dc:	57                   	push   %edi
801012dd:	e8 3e 1f 00 00       	call   80103220 <log_write>
        brelse(bp);
801012e2:	89 3c 24             	mov    %edi,(%esp)
801012e5:	e8 f6 ee ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801012ea:	58                   	pop    %eax
801012eb:	5a                   	pop    %edx
801012ec:	56                   	push   %esi
801012ed:	ff 75 d8             	pushl  -0x28(%ebp)
801012f0:	e8 db ed ff ff       	call   801000d0 <bread>
801012f5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801012fa:	83 c4 0c             	add    $0xc,%esp
801012fd:	68 00 02 00 00       	push   $0x200
80101302:	6a 00                	push   $0x0
80101304:	50                   	push   %eax
80101305:	e8 66 36 00 00       	call   80104970 <memset>
  log_write(bp);
8010130a:	89 1c 24             	mov    %ebx,(%esp)
8010130d:	e8 0e 1f 00 00       	call   80103220 <log_write>
  brelse(bp);
80101312:	89 1c 24             	mov    %ebx,(%esp)
80101315:	e8 c6 ee ff ff       	call   801001e0 <brelse>
}
8010131a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131d:	89 f0                	mov    %esi,%eax
8010131f:	5b                   	pop    %ebx
80101320:	5e                   	pop    %esi
80101321:	5f                   	pop    %edi
80101322:	5d                   	pop    %ebp
80101323:	c3                   	ret    
80101324:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010132a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101330 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101330:	55                   	push   %ebp
80101331:	89 e5                	mov    %esp,%ebp
80101333:	57                   	push   %edi
80101334:	56                   	push   %esi
80101335:	53                   	push   %ebx
80101336:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101338:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010133a:	bb 54 fa 11 80       	mov    $0x8011fa54,%ebx
{
8010133f:	83 ec 28             	sub    $0x28,%esp
80101342:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101345:	68 20 fa 11 80       	push   $0x8011fa20
8010134a:	e8 11 35 00 00       	call   80104860 <acquire>
8010134f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101352:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101355:	eb 17                	jmp    8010136e <iget+0x3e>
80101357:	89 f6                	mov    %esi,%esi
80101359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101360:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101366:	81 fb 74 16 12 80    	cmp    $0x80121674,%ebx
8010136c:	73 22                	jae    80101390 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010136e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101371:	85 c9                	test   %ecx,%ecx
80101373:	7e 04                	jle    80101379 <iget+0x49>
80101375:	39 3b                	cmp    %edi,(%ebx)
80101377:	74 4f                	je     801013c8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101379:	85 f6                	test   %esi,%esi
8010137b:	75 e3                	jne    80101360 <iget+0x30>
8010137d:	85 c9                	test   %ecx,%ecx
8010137f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101382:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101388:	81 fb 74 16 12 80    	cmp    $0x80121674,%ebx
8010138e:	72 de                	jb     8010136e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101390:	85 f6                	test   %esi,%esi
80101392:	74 5b                	je     801013ef <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101394:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101397:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101399:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010139c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013a3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013aa:	68 20 fa 11 80       	push   $0x8011fa20
801013af:	e8 6c 35 00 00       	call   80104920 <release>

  return ip;
801013b4:	83 c4 10             	add    $0x10,%esp
}
801013b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ba:	89 f0                	mov    %esi,%eax
801013bc:	5b                   	pop    %ebx
801013bd:	5e                   	pop    %esi
801013be:	5f                   	pop    %edi
801013bf:	5d                   	pop    %ebp
801013c0:	c3                   	ret    
801013c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c8:	39 53 04             	cmp    %edx,0x4(%ebx)
801013cb:	75 ac                	jne    80101379 <iget+0x49>
      release(&icache.lock);
801013cd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013d0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013d3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013d5:	68 20 fa 11 80       	push   $0x8011fa20
      ip->ref++;
801013da:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013dd:	e8 3e 35 00 00       	call   80104920 <release>
      return ip;
801013e2:	83 c4 10             	add    $0x10,%esp
}
801013e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e8:	89 f0                	mov    %esi,%eax
801013ea:	5b                   	pop    %ebx
801013eb:	5e                   	pop    %esi
801013ec:	5f                   	pop    %edi
801013ed:	5d                   	pop    %ebp
801013ee:	c3                   	ret    
    panic("iget: no inodes");
801013ef:	83 ec 0c             	sub    $0xc,%esp
801013f2:	68 88 78 10 80       	push   $0x80107888
801013f7:	e8 94 ef ff ff       	call   80100390 <panic>
801013fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101400 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	57                   	push   %edi
80101404:	56                   	push   %esi
80101405:	53                   	push   %ebx
80101406:	89 c6                	mov    %eax,%esi
80101408:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010140b:	83 fa 0b             	cmp    $0xb,%edx
8010140e:	77 18                	ja     80101428 <bmap+0x28>
80101410:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101413:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101416:	85 db                	test   %ebx,%ebx
80101418:	74 76                	je     80101490 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010141a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010141d:	89 d8                	mov    %ebx,%eax
8010141f:	5b                   	pop    %ebx
80101420:	5e                   	pop    %esi
80101421:	5f                   	pop    %edi
80101422:	5d                   	pop    %ebp
80101423:	c3                   	ret    
80101424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101428:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010142b:	83 fb 7f             	cmp    $0x7f,%ebx
8010142e:	0f 87 90 00 00 00    	ja     801014c4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101434:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010143a:	8b 00                	mov    (%eax),%eax
8010143c:	85 d2                	test   %edx,%edx
8010143e:	74 70                	je     801014b0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101440:	83 ec 08             	sub    $0x8,%esp
80101443:	52                   	push   %edx
80101444:	50                   	push   %eax
80101445:	e8 86 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010144a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010144e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101451:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101453:	8b 1a                	mov    (%edx),%ebx
80101455:	85 db                	test   %ebx,%ebx
80101457:	75 1d                	jne    80101476 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101459:	8b 06                	mov    (%esi),%eax
8010145b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010145e:	e8 bd fd ff ff       	call   80101220 <balloc>
80101463:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101466:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101469:	89 c3                	mov    %eax,%ebx
8010146b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010146d:	57                   	push   %edi
8010146e:	e8 ad 1d 00 00       	call   80103220 <log_write>
80101473:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101476:	83 ec 0c             	sub    $0xc,%esp
80101479:	57                   	push   %edi
8010147a:	e8 61 ed ff ff       	call   801001e0 <brelse>
8010147f:	83 c4 10             	add    $0x10,%esp
}
80101482:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101485:	89 d8                	mov    %ebx,%eax
80101487:	5b                   	pop    %ebx
80101488:	5e                   	pop    %esi
80101489:	5f                   	pop    %edi
8010148a:	5d                   	pop    %ebp
8010148b:	c3                   	ret    
8010148c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101490:	8b 00                	mov    (%eax),%eax
80101492:	e8 89 fd ff ff       	call   80101220 <balloc>
80101497:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010149a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010149d:	89 c3                	mov    %eax,%ebx
}
8010149f:	89 d8                	mov    %ebx,%eax
801014a1:	5b                   	pop    %ebx
801014a2:	5e                   	pop    %esi
801014a3:	5f                   	pop    %edi
801014a4:	5d                   	pop    %ebp
801014a5:	c3                   	ret    
801014a6:	8d 76 00             	lea    0x0(%esi),%esi
801014a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b0:	e8 6b fd ff ff       	call   80101220 <balloc>
801014b5:	89 c2                	mov    %eax,%edx
801014b7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014bd:	8b 06                	mov    (%esi),%eax
801014bf:	e9 7c ff ff ff       	jmp    80101440 <bmap+0x40>
  panic("bmap: out of range");
801014c4:	83 ec 0c             	sub    $0xc,%esp
801014c7:	68 98 78 10 80       	push   $0x80107898
801014cc:	e8 bf ee ff ff       	call   80100390 <panic>
801014d1:	eb 0d                	jmp    801014e0 <readsb>
801014d3:	90                   	nop
801014d4:	90                   	nop
801014d5:	90                   	nop
801014d6:	90                   	nop
801014d7:	90                   	nop
801014d8:	90                   	nop
801014d9:	90                   	nop
801014da:	90                   	nop
801014db:	90                   	nop
801014dc:	90                   	nop
801014dd:	90                   	nop
801014de:	90                   	nop
801014df:	90                   	nop

801014e0 <readsb>:
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	56                   	push   %esi
801014e4:	53                   	push   %ebx
801014e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801014e8:	83 ec 08             	sub    $0x8,%esp
801014eb:	6a 01                	push   $0x1
801014ed:	ff 75 08             	pushl  0x8(%ebp)
801014f0:	e8 db eb ff ff       	call   801000d0 <bread>
801014f5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801014f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801014fa:	83 c4 0c             	add    $0xc,%esp
801014fd:	6a 1c                	push   $0x1c
801014ff:	50                   	push   %eax
80101500:	56                   	push   %esi
80101501:	e8 1a 35 00 00       	call   80104a20 <memmove>
  brelse(bp);
80101506:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101509:	83 c4 10             	add    $0x10,%esp
}
8010150c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010150f:	5b                   	pop    %ebx
80101510:	5e                   	pop    %esi
80101511:	5d                   	pop    %ebp
  brelse(bp);
80101512:	e9 c9 ec ff ff       	jmp    801001e0 <brelse>
80101517:	89 f6                	mov    %esi,%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101520 <iinit>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	53                   	push   %ebx
80101524:	bb 60 fa 11 80       	mov    $0x8011fa60,%ebx
80101529:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010152c:	68 ab 78 10 80       	push   $0x801078ab
80101531:	68 20 fa 11 80       	push   $0x8011fa20
80101536:	e8 e5 31 00 00       	call   80104720 <initlock>
8010153b:	83 c4 10             	add    $0x10,%esp
8010153e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101540:	83 ec 08             	sub    $0x8,%esp
80101543:	68 b2 78 10 80       	push   $0x801078b2
80101548:	53                   	push   %ebx
80101549:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010154f:	e8 9c 30 00 00       	call   801045f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101554:	83 c4 10             	add    $0x10,%esp
80101557:	81 fb 80 16 12 80    	cmp    $0x80121680,%ebx
8010155d:	75 e1                	jne    80101540 <iinit+0x20>
  readsb(dev, &sb);
8010155f:	83 ec 08             	sub    $0x8,%esp
80101562:	68 00 fa 11 80       	push   $0x8011fa00
80101567:	ff 75 08             	pushl  0x8(%ebp)
8010156a:	e8 71 ff ff ff       	call   801014e0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010156f:	ff 35 18 fa 11 80    	pushl  0x8011fa18
80101575:	ff 35 14 fa 11 80    	pushl  0x8011fa14
8010157b:	ff 35 10 fa 11 80    	pushl  0x8011fa10
80101581:	ff 35 0c fa 11 80    	pushl  0x8011fa0c
80101587:	ff 35 08 fa 11 80    	pushl  0x8011fa08
8010158d:	ff 35 04 fa 11 80    	pushl  0x8011fa04
80101593:	ff 35 00 fa 11 80    	pushl  0x8011fa00
80101599:	68 5c 79 10 80       	push   $0x8010795c
8010159e:	e8 bd f0 ff ff       	call   80100660 <cprintf>
}
801015a3:	83 c4 30             	add    $0x30,%esp
801015a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015a9:	c9                   	leave  
801015aa:	c3                   	ret    
801015ab:	90                   	nop
801015ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015b0 <ialloc>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	57                   	push   %edi
801015b4:	56                   	push   %esi
801015b5:	53                   	push   %ebx
801015b6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015b9:	83 3d 08 fa 11 80 01 	cmpl   $0x1,0x8011fa08
{
801015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801015c3:	8b 75 08             	mov    0x8(%ebp),%esi
801015c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015c9:	0f 86 91 00 00 00    	jbe    80101660 <ialloc+0xb0>
801015cf:	bb 01 00 00 00       	mov    $0x1,%ebx
801015d4:	eb 21                	jmp    801015f7 <ialloc+0x47>
801015d6:	8d 76 00             	lea    0x0(%esi),%esi
801015d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801015e0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015e3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801015e6:	57                   	push   %edi
801015e7:	e8 f4 eb ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015ec:	83 c4 10             	add    $0x10,%esp
801015ef:	39 1d 08 fa 11 80    	cmp    %ebx,0x8011fa08
801015f5:	76 69                	jbe    80101660 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015f7:	89 d8                	mov    %ebx,%eax
801015f9:	83 ec 08             	sub    $0x8,%esp
801015fc:	c1 e8 03             	shr    $0x3,%eax
801015ff:	03 05 14 fa 11 80    	add    0x8011fa14,%eax
80101605:	50                   	push   %eax
80101606:	56                   	push   %esi
80101607:	e8 c4 ea ff ff       	call   801000d0 <bread>
8010160c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010160e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101610:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101613:	83 e0 07             	and    $0x7,%eax
80101616:	c1 e0 06             	shl    $0x6,%eax
80101619:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010161d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101621:	75 bd                	jne    801015e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101623:	83 ec 04             	sub    $0x4,%esp
80101626:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101629:	6a 40                	push   $0x40
8010162b:	6a 00                	push   $0x0
8010162d:	51                   	push   %ecx
8010162e:	e8 3d 33 00 00       	call   80104970 <memset>
      dip->type = type;
80101633:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101637:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010163a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010163d:	89 3c 24             	mov    %edi,(%esp)
80101640:	e8 db 1b 00 00       	call   80103220 <log_write>
      brelse(bp);
80101645:	89 3c 24             	mov    %edi,(%esp)
80101648:	e8 93 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010164d:	83 c4 10             	add    $0x10,%esp
}
80101650:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101653:	89 da                	mov    %ebx,%edx
80101655:	89 f0                	mov    %esi,%eax
}
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5f                   	pop    %edi
8010165a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010165b:	e9 d0 fc ff ff       	jmp    80101330 <iget>
  panic("ialloc: no inodes");
80101660:	83 ec 0c             	sub    $0xc,%esp
80101663:	68 b8 78 10 80       	push   $0x801078b8
80101668:	e8 23 ed ff ff       	call   80100390 <panic>
8010166d:	8d 76 00             	lea    0x0(%esi),%esi

80101670 <iupdate>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101678:	83 ec 08             	sub    $0x8,%esp
8010167b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010167e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101681:	c1 e8 03             	shr    $0x3,%eax
80101684:	03 05 14 fa 11 80    	add    0x8011fa14,%eax
8010168a:	50                   	push   %eax
8010168b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010168e:	e8 3d ea ff ff       	call   801000d0 <bread>
80101693:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101695:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101698:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010169c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010169f:	83 e0 07             	and    $0x7,%eax
801016a2:	c1 e0 06             	shl    $0x6,%eax
801016a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016ac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016b0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016b3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016b7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016bb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016bf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016c3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016c7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016ca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cd:	6a 34                	push   $0x34
801016cf:	53                   	push   %ebx
801016d0:	50                   	push   %eax
801016d1:	e8 4a 33 00 00       	call   80104a20 <memmove>
  log_write(bp);
801016d6:	89 34 24             	mov    %esi,(%esp)
801016d9:	e8 42 1b 00 00       	call   80103220 <log_write>
  brelse(bp);
801016de:	89 75 08             	mov    %esi,0x8(%ebp)
801016e1:	83 c4 10             	add    $0x10,%esp
}
801016e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016e7:	5b                   	pop    %ebx
801016e8:	5e                   	pop    %esi
801016e9:	5d                   	pop    %ebp
  brelse(bp);
801016ea:	e9 f1 ea ff ff       	jmp    801001e0 <brelse>
801016ef:	90                   	nop

801016f0 <idup>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	53                   	push   %ebx
801016f4:	83 ec 10             	sub    $0x10,%esp
801016f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016fa:	68 20 fa 11 80       	push   $0x8011fa20
801016ff:	e8 5c 31 00 00       	call   80104860 <acquire>
  ip->ref++;
80101704:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101708:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
8010170f:	e8 0c 32 00 00       	call   80104920 <release>
}
80101714:	89 d8                	mov    %ebx,%eax
80101716:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101719:	c9                   	leave  
8010171a:	c3                   	ret    
8010171b:	90                   	nop
8010171c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101720 <ilock>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	56                   	push   %esi
80101724:	53                   	push   %ebx
80101725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101728:	85 db                	test   %ebx,%ebx
8010172a:	0f 84 b7 00 00 00    	je     801017e7 <ilock+0xc7>
80101730:	8b 53 08             	mov    0x8(%ebx),%edx
80101733:	85 d2                	test   %edx,%edx
80101735:	0f 8e ac 00 00 00    	jle    801017e7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010173b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010173e:	83 ec 0c             	sub    $0xc,%esp
80101741:	50                   	push   %eax
80101742:	e8 e9 2e 00 00       	call   80104630 <acquiresleep>
  if(ip->valid == 0){
80101747:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010174a:	83 c4 10             	add    $0x10,%esp
8010174d:	85 c0                	test   %eax,%eax
8010174f:	74 0f                	je     80101760 <ilock+0x40>
}
80101751:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101754:	5b                   	pop    %ebx
80101755:	5e                   	pop    %esi
80101756:	5d                   	pop    %ebp
80101757:	c3                   	ret    
80101758:	90                   	nop
80101759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101760:	8b 43 04             	mov    0x4(%ebx),%eax
80101763:	83 ec 08             	sub    $0x8,%esp
80101766:	c1 e8 03             	shr    $0x3,%eax
80101769:	03 05 14 fa 11 80    	add    0x8011fa14,%eax
8010176f:	50                   	push   %eax
80101770:	ff 33                	pushl  (%ebx)
80101772:	e8 59 e9 ff ff       	call   801000d0 <bread>
80101777:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101779:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010177c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010177f:	83 e0 07             	and    $0x7,%eax
80101782:	c1 e0 06             	shl    $0x6,%eax
80101785:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101789:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010178c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010178f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101793:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101797:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010179b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010179f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017a3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017a7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017ab:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b1:	6a 34                	push   $0x34
801017b3:	50                   	push   %eax
801017b4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017b7:	50                   	push   %eax
801017b8:	e8 63 32 00 00       	call   80104a20 <memmove>
    brelse(bp);
801017bd:	89 34 24             	mov    %esi,(%esp)
801017c0:	e8 1b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801017c5:	83 c4 10             	add    $0x10,%esp
801017c8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017cd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017d4:	0f 85 77 ff ff ff    	jne    80101751 <ilock+0x31>
      panic("ilock: no type");
801017da:	83 ec 0c             	sub    $0xc,%esp
801017dd:	68 d0 78 10 80       	push   $0x801078d0
801017e2:	e8 a9 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017e7:	83 ec 0c             	sub    $0xc,%esp
801017ea:	68 ca 78 10 80       	push   $0x801078ca
801017ef:	e8 9c eb ff ff       	call   80100390 <panic>
801017f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101800 <iunlock>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	56                   	push   %esi
80101804:	53                   	push   %ebx
80101805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101808:	85 db                	test   %ebx,%ebx
8010180a:	74 28                	je     80101834 <iunlock+0x34>
8010180c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010180f:	83 ec 0c             	sub    $0xc,%esp
80101812:	56                   	push   %esi
80101813:	e8 b8 2e 00 00       	call   801046d0 <holdingsleep>
80101818:	83 c4 10             	add    $0x10,%esp
8010181b:	85 c0                	test   %eax,%eax
8010181d:	74 15                	je     80101834 <iunlock+0x34>
8010181f:	8b 43 08             	mov    0x8(%ebx),%eax
80101822:	85 c0                	test   %eax,%eax
80101824:	7e 0e                	jle    80101834 <iunlock+0x34>
  releasesleep(&ip->lock);
80101826:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101829:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010182c:	5b                   	pop    %ebx
8010182d:	5e                   	pop    %esi
8010182e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010182f:	e9 5c 2e 00 00       	jmp    80104690 <releasesleep>
    panic("iunlock");
80101834:	83 ec 0c             	sub    $0xc,%esp
80101837:	68 df 78 10 80       	push   $0x801078df
8010183c:	e8 4f eb ff ff       	call   80100390 <panic>
80101841:	eb 0d                	jmp    80101850 <iput>
80101843:	90                   	nop
80101844:	90                   	nop
80101845:	90                   	nop
80101846:	90                   	nop
80101847:	90                   	nop
80101848:	90                   	nop
80101849:	90                   	nop
8010184a:	90                   	nop
8010184b:	90                   	nop
8010184c:	90                   	nop
8010184d:	90                   	nop
8010184e:	90                   	nop
8010184f:	90                   	nop

80101850 <iput>:
{
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	57                   	push   %edi
80101854:	56                   	push   %esi
80101855:	53                   	push   %ebx
80101856:	83 ec 28             	sub    $0x28,%esp
80101859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010185c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010185f:	57                   	push   %edi
80101860:	e8 cb 2d 00 00       	call   80104630 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101865:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101868:	83 c4 10             	add    $0x10,%esp
8010186b:	85 d2                	test   %edx,%edx
8010186d:	74 07                	je     80101876 <iput+0x26>
8010186f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101874:	74 32                	je     801018a8 <iput+0x58>
  releasesleep(&ip->lock);
80101876:	83 ec 0c             	sub    $0xc,%esp
80101879:	57                   	push   %edi
8010187a:	e8 11 2e 00 00       	call   80104690 <releasesleep>
  acquire(&icache.lock);
8010187f:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
80101886:	e8 d5 2f 00 00       	call   80104860 <acquire>
  ip->ref--;
8010188b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010188f:	83 c4 10             	add    $0x10,%esp
80101892:	c7 45 08 20 fa 11 80 	movl   $0x8011fa20,0x8(%ebp)
}
80101899:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010189c:	5b                   	pop    %ebx
8010189d:	5e                   	pop    %esi
8010189e:	5f                   	pop    %edi
8010189f:	5d                   	pop    %ebp
  release(&icache.lock);
801018a0:	e9 7b 30 00 00       	jmp    80104920 <release>
801018a5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018a8:	83 ec 0c             	sub    $0xc,%esp
801018ab:	68 20 fa 11 80       	push   $0x8011fa20
801018b0:	e8 ab 2f 00 00       	call   80104860 <acquire>
    int r = ip->ref;
801018b5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018b8:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
801018bf:	e8 5c 30 00 00       	call   80104920 <release>
    if(r == 1){
801018c4:	83 c4 10             	add    $0x10,%esp
801018c7:	83 fe 01             	cmp    $0x1,%esi
801018ca:	75 aa                	jne    80101876 <iput+0x26>
801018cc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018d2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018d8:	89 cf                	mov    %ecx,%edi
801018da:	eb 0b                	jmp    801018e7 <iput+0x97>
801018dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018e0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018e3:	39 fe                	cmp    %edi,%esi
801018e5:	74 19                	je     80101900 <iput+0xb0>
    if(ip->addrs[i]){
801018e7:	8b 16                	mov    (%esi),%edx
801018e9:	85 d2                	test   %edx,%edx
801018eb:	74 f3                	je     801018e0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018ed:	8b 03                	mov    (%ebx),%eax
801018ef:	e8 bc f8 ff ff       	call   801011b0 <bfree>
      ip->addrs[i] = 0;
801018f4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801018fa:	eb e4                	jmp    801018e0 <iput+0x90>
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101900:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101906:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101909:	85 c0                	test   %eax,%eax
8010190b:	75 33                	jne    80101940 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010190d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101910:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101917:	53                   	push   %ebx
80101918:	e8 53 fd ff ff       	call   80101670 <iupdate>
      ip->type = 0;
8010191d:	31 c0                	xor    %eax,%eax
8010191f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101923:	89 1c 24             	mov    %ebx,(%esp)
80101926:	e8 45 fd ff ff       	call   80101670 <iupdate>
      ip->valid = 0;
8010192b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101932:	83 c4 10             	add    $0x10,%esp
80101935:	e9 3c ff ff ff       	jmp    80101876 <iput+0x26>
8010193a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101940:	83 ec 08             	sub    $0x8,%esp
80101943:	50                   	push   %eax
80101944:	ff 33                	pushl  (%ebx)
80101946:	e8 85 e7 ff ff       	call   801000d0 <bread>
8010194b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101951:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101954:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101957:	8d 70 5c             	lea    0x5c(%eax),%esi
8010195a:	83 c4 10             	add    $0x10,%esp
8010195d:	89 cf                	mov    %ecx,%edi
8010195f:	eb 0e                	jmp    8010196f <iput+0x11f>
80101961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101968:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010196b:	39 fe                	cmp    %edi,%esi
8010196d:	74 0f                	je     8010197e <iput+0x12e>
      if(a[j])
8010196f:	8b 16                	mov    (%esi),%edx
80101971:	85 d2                	test   %edx,%edx
80101973:	74 f3                	je     80101968 <iput+0x118>
        bfree(ip->dev, a[j]);
80101975:	8b 03                	mov    (%ebx),%eax
80101977:	e8 34 f8 ff ff       	call   801011b0 <bfree>
8010197c:	eb ea                	jmp    80101968 <iput+0x118>
    brelse(bp);
8010197e:	83 ec 0c             	sub    $0xc,%esp
80101981:	ff 75 e4             	pushl  -0x1c(%ebp)
80101984:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101987:	e8 54 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010198c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101992:	8b 03                	mov    (%ebx),%eax
80101994:	e8 17 f8 ff ff       	call   801011b0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101999:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019a0:	00 00 00 
801019a3:	83 c4 10             	add    $0x10,%esp
801019a6:	e9 62 ff ff ff       	jmp    8010190d <iput+0xbd>
801019ab:	90                   	nop
801019ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019b0 <iunlockput>:
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	53                   	push   %ebx
801019b4:	83 ec 10             	sub    $0x10,%esp
801019b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019ba:	53                   	push   %ebx
801019bb:	e8 40 fe ff ff       	call   80101800 <iunlock>
  iput(ip);
801019c0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019c3:	83 c4 10             	add    $0x10,%esp
}
801019c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019c9:	c9                   	leave  
  iput(ip);
801019ca:	e9 81 fe ff ff       	jmp    80101850 <iput>
801019cf:	90                   	nop

801019d0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	8b 55 08             	mov    0x8(%ebp),%edx
801019d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019d9:	8b 0a                	mov    (%edx),%ecx
801019db:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019de:	8b 4a 04             	mov    0x4(%edx),%ecx
801019e1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019e4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019e8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019eb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019ef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019f3:	8b 52 58             	mov    0x58(%edx),%edx
801019f6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019f9:	5d                   	pop    %ebp
801019fa:	c3                   	ret    
801019fb:	90                   	nop
801019fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	57                   	push   %edi
80101a04:	56                   	push   %esi
80101a05:	53                   	push   %ebx
80101a06:	83 ec 1c             	sub    $0x1c,%esp
80101a09:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a17:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101a1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a20:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a23:	0f 84 a7 00 00 00    	je     80101ad0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a2c:	8b 40 58             	mov    0x58(%eax),%eax
80101a2f:	39 c6                	cmp    %eax,%esi
80101a31:	0f 87 ba 00 00 00    	ja     80101af1 <readi+0xf1>
80101a37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a3a:	89 f9                	mov    %edi,%ecx
80101a3c:	01 f1                	add    %esi,%ecx
80101a3e:	0f 82 ad 00 00 00    	jb     80101af1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a44:	89 c2                	mov    %eax,%edx
80101a46:	29 f2                	sub    %esi,%edx
80101a48:	39 c8                	cmp    %ecx,%eax
80101a4a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a4d:	31 ff                	xor    %edi,%edi
80101a4f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101a51:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a54:	74 6c                	je     80101ac2 <readi+0xc2>
80101a56:	8d 76 00             	lea    0x0(%esi),%esi
80101a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a63:	89 f2                	mov    %esi,%edx
80101a65:	c1 ea 09             	shr    $0x9,%edx
80101a68:	89 d8                	mov    %ebx,%eax
80101a6a:	e8 91 f9 ff ff       	call   80101400 <bmap>
80101a6f:	83 ec 08             	sub    $0x8,%esp
80101a72:	50                   	push   %eax
80101a73:	ff 33                	pushl  (%ebx)
80101a75:	e8 56 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a7d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a7f:	89 f0                	mov    %esi,%eax
80101a81:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a86:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a8b:	83 c4 0c             	add    $0xc,%esp
80101a8e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a90:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a94:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a97:	29 fb                	sub    %edi,%ebx
80101a99:	39 d9                	cmp    %ebx,%ecx
80101a9b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a9e:	53                   	push   %ebx
80101a9f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aa0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101aa2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aa5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101aa7:	e8 74 2f 00 00       	call   80104a20 <memmove>
    brelse(bp);
80101aac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101aaf:	89 14 24             	mov    %edx,(%esp)
80101ab2:	e8 29 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ab7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aba:	83 c4 10             	add    $0x10,%esp
80101abd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ac0:	77 9e                	ja     80101a60 <readi+0x60>
  }
  return n;
80101ac2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ac5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ac8:	5b                   	pop    %ebx
80101ac9:	5e                   	pop    %esi
80101aca:	5f                   	pop    %edi
80101acb:	5d                   	pop    %ebp
80101acc:	c3                   	ret    
80101acd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ad0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ad4:	66 83 f8 09          	cmp    $0x9,%ax
80101ad8:	77 17                	ja     80101af1 <readi+0xf1>
80101ada:	8b 04 c5 a0 f9 11 80 	mov    -0x7fee0660(,%eax,8),%eax
80101ae1:	85 c0                	test   %eax,%eax
80101ae3:	74 0c                	je     80101af1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ae5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aeb:	5b                   	pop    %ebx
80101aec:	5e                   	pop    %esi
80101aed:	5f                   	pop    %edi
80101aee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101aef:	ff e0                	jmp    *%eax
      return -1;
80101af1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101af6:	eb cd                	jmp    80101ac5 <readi+0xc5>
80101af8:	90                   	nop
80101af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101b00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 1c             	sub    $0x1c,%esp
80101b09:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b17:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b20:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b23:	0f 84 b7 00 00 00    	je     80101be0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b2f:	0f 82 eb 00 00 00    	jb     80101c20 <writei+0x120>
80101b35:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b38:	31 d2                	xor    %edx,%edx
80101b3a:	89 f8                	mov    %edi,%eax
80101b3c:	01 f0                	add    %esi,%eax
80101b3e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b41:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b46:	0f 87 d4 00 00 00    	ja     80101c20 <writei+0x120>
80101b4c:	85 d2                	test   %edx,%edx
80101b4e:	0f 85 cc 00 00 00    	jne    80101c20 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b54:	85 ff                	test   %edi,%edi
80101b56:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b5d:	74 72                	je     80101bd1 <writei+0xd1>
80101b5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b60:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b63:	89 f2                	mov    %esi,%edx
80101b65:	c1 ea 09             	shr    $0x9,%edx
80101b68:	89 f8                	mov    %edi,%eax
80101b6a:	e8 91 f8 ff ff       	call   80101400 <bmap>
80101b6f:	83 ec 08             	sub    $0x8,%esp
80101b72:	50                   	push   %eax
80101b73:	ff 37                	pushl  (%edi)
80101b75:	e8 56 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b7d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b80:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b82:	89 f0                	mov    %esi,%eax
80101b84:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b89:	83 c4 0c             	add    $0xc,%esp
80101b8c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b91:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b93:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b97:	39 d9                	cmp    %ebx,%ecx
80101b99:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b9c:	53                   	push   %ebx
80101b9d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ba0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101ba2:	50                   	push   %eax
80101ba3:	e8 78 2e 00 00       	call   80104a20 <memmove>
    log_write(bp);
80101ba8:	89 3c 24             	mov    %edi,(%esp)
80101bab:	e8 70 16 00 00       	call   80103220 <log_write>
    brelse(bp);
80101bb0:	89 3c 24             	mov    %edi,(%esp)
80101bb3:	e8 28 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bbb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bbe:	83 c4 10             	add    $0x10,%esp
80101bc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bc4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101bc7:	77 97                	ja     80101b60 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bcf:	77 37                	ja     80101c08 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd7:	5b                   	pop    %ebx
80101bd8:	5e                   	pop    %esi
80101bd9:	5f                   	pop    %edi
80101bda:	5d                   	pop    %ebp
80101bdb:	c3                   	ret    
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101be0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101be4:	66 83 f8 09          	cmp    $0x9,%ax
80101be8:	77 36                	ja     80101c20 <writei+0x120>
80101bea:	8b 04 c5 a4 f9 11 80 	mov    -0x7fee065c(,%eax,8),%eax
80101bf1:	85 c0                	test   %eax,%eax
80101bf3:	74 2b                	je     80101c20 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101bf5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfb:	5b                   	pop    %ebx
80101bfc:	5e                   	pop    %esi
80101bfd:	5f                   	pop    %edi
80101bfe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101bff:	ff e0                	jmp    *%eax
80101c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c08:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c0b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c0e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c11:	50                   	push   %eax
80101c12:	e8 59 fa ff ff       	call   80101670 <iupdate>
80101c17:	83 c4 10             	add    $0x10,%esp
80101c1a:	eb b5                	jmp    80101bd1 <writei+0xd1>
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c25:	eb ad                	jmp    80101bd4 <writei+0xd4>
80101c27:	89 f6                	mov    %esi,%esi
80101c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c36:	6a 0e                	push   $0xe
80101c38:	ff 75 0c             	pushl  0xc(%ebp)
80101c3b:	ff 75 08             	pushl  0x8(%ebp)
80101c3e:	e8 4d 2e 00 00       	call   80104a90 <strncmp>
}
80101c43:	c9                   	leave  
80101c44:	c3                   	ret    
80101c45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	83 ec 1c             	sub    $0x1c,%esp
80101c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c61:	0f 85 85 00 00 00    	jne    80101cec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c67:	8b 53 58             	mov    0x58(%ebx),%edx
80101c6a:	31 ff                	xor    %edi,%edi
80101c6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c6f:	85 d2                	test   %edx,%edx
80101c71:	74 3e                	je     80101cb1 <dirlookup+0x61>
80101c73:	90                   	nop
80101c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c78:	6a 10                	push   $0x10
80101c7a:	57                   	push   %edi
80101c7b:	56                   	push   %esi
80101c7c:	53                   	push   %ebx
80101c7d:	e8 7e fd ff ff       	call   80101a00 <readi>
80101c82:	83 c4 10             	add    $0x10,%esp
80101c85:	83 f8 10             	cmp    $0x10,%eax
80101c88:	75 55                	jne    80101cdf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c8f:	74 18                	je     80101ca9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c91:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c94:	83 ec 04             	sub    $0x4,%esp
80101c97:	6a 0e                	push   $0xe
80101c99:	50                   	push   %eax
80101c9a:	ff 75 0c             	pushl  0xc(%ebp)
80101c9d:	e8 ee 2d 00 00       	call   80104a90 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ca2:	83 c4 10             	add    $0x10,%esp
80101ca5:	85 c0                	test   %eax,%eax
80101ca7:	74 17                	je     80101cc0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ca9:	83 c7 10             	add    $0x10,%edi
80101cac:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101caf:	72 c7                	jb     80101c78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cb4:	31 c0                	xor    %eax,%eax
}
80101cb6:	5b                   	pop    %ebx
80101cb7:	5e                   	pop    %esi
80101cb8:	5f                   	pop    %edi
80101cb9:	5d                   	pop    %ebp
80101cba:	c3                   	ret    
80101cbb:	90                   	nop
80101cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101cc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cc3:	85 c0                	test   %eax,%eax
80101cc5:	74 05                	je     80101ccc <dirlookup+0x7c>
        *poff = off;
80101cc7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ccc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cd0:	8b 03                	mov    (%ebx),%eax
80101cd2:	e8 59 f6 ff ff       	call   80101330 <iget>
}
80101cd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cda:	5b                   	pop    %ebx
80101cdb:	5e                   	pop    %esi
80101cdc:	5f                   	pop    %edi
80101cdd:	5d                   	pop    %ebp
80101cde:	c3                   	ret    
      panic("dirlookup read");
80101cdf:	83 ec 0c             	sub    $0xc,%esp
80101ce2:	68 f9 78 10 80       	push   $0x801078f9
80101ce7:	e8 a4 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cec:	83 ec 0c             	sub    $0xc,%esp
80101cef:	68 e7 78 10 80       	push   $0x801078e7
80101cf4:	e8 97 e6 ff ff       	call   80100390 <panic>
80101cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	89 cf                	mov    %ecx,%edi
80101d08:	89 c3                	mov    %eax,%ebx
80101d0a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d0d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d10:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101d13:	0f 84 67 01 00 00    	je     80101e80 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d19:	e8 82 1f 00 00       	call   80103ca0 <myproc>
  acquire(&icache.lock);
80101d1e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101d21:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d24:	68 20 fa 11 80       	push   $0x8011fa20
80101d29:	e8 32 2b 00 00       	call   80104860 <acquire>
  ip->ref++;
80101d2e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d32:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
80101d39:	e8 e2 2b 00 00       	call   80104920 <release>
80101d3e:	83 c4 10             	add    $0x10,%esp
80101d41:	eb 08                	jmp    80101d4b <namex+0x4b>
80101d43:	90                   	nop
80101d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101d48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d4b:	0f b6 03             	movzbl (%ebx),%eax
80101d4e:	3c 2f                	cmp    $0x2f,%al
80101d50:	74 f6                	je     80101d48 <namex+0x48>
  if(*path == 0)
80101d52:	84 c0                	test   %al,%al
80101d54:	0f 84 ee 00 00 00    	je     80101e48 <namex+0x148>
  while(*path != '/' && *path != 0)
80101d5a:	0f b6 03             	movzbl (%ebx),%eax
80101d5d:	3c 2f                	cmp    $0x2f,%al
80101d5f:	0f 84 b3 00 00 00    	je     80101e18 <namex+0x118>
80101d65:	84 c0                	test   %al,%al
80101d67:	89 da                	mov    %ebx,%edx
80101d69:	75 09                	jne    80101d74 <namex+0x74>
80101d6b:	e9 a8 00 00 00       	jmp    80101e18 <namex+0x118>
80101d70:	84 c0                	test   %al,%al
80101d72:	74 0a                	je     80101d7e <namex+0x7e>
    path++;
80101d74:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d77:	0f b6 02             	movzbl (%edx),%eax
80101d7a:	3c 2f                	cmp    $0x2f,%al
80101d7c:	75 f2                	jne    80101d70 <namex+0x70>
80101d7e:	89 d1                	mov    %edx,%ecx
80101d80:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d82:	83 f9 0d             	cmp    $0xd,%ecx
80101d85:	0f 8e 91 00 00 00    	jle    80101e1c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d8b:	83 ec 04             	sub    $0x4,%esp
80101d8e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d91:	6a 0e                	push   $0xe
80101d93:	53                   	push   %ebx
80101d94:	57                   	push   %edi
80101d95:	e8 86 2c 00 00       	call   80104a20 <memmove>
    path++;
80101d9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d9d:	83 c4 10             	add    $0x10,%esp
    path++;
80101da0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101da2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101da5:	75 11                	jne    80101db8 <namex+0xb8>
80101da7:	89 f6                	mov    %esi,%esi
80101da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101db0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101db3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101db6:	74 f8                	je     80101db0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101db8:	83 ec 0c             	sub    $0xc,%esp
80101dbb:	56                   	push   %esi
80101dbc:	e8 5f f9 ff ff       	call   80101720 <ilock>
    if(ip->type != T_DIR){
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101dc9:	0f 85 91 00 00 00    	jne    80101e60 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dcf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dd2:	85 d2                	test   %edx,%edx
80101dd4:	74 09                	je     80101ddf <namex+0xdf>
80101dd6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101dd9:	0f 84 b7 00 00 00    	je     80101e96 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ddf:	83 ec 04             	sub    $0x4,%esp
80101de2:	6a 00                	push   $0x0
80101de4:	57                   	push   %edi
80101de5:	56                   	push   %esi
80101de6:	e8 65 fe ff ff       	call   80101c50 <dirlookup>
80101deb:	83 c4 10             	add    $0x10,%esp
80101dee:	85 c0                	test   %eax,%eax
80101df0:	74 6e                	je     80101e60 <namex+0x160>
  iunlock(ip);
80101df2:	83 ec 0c             	sub    $0xc,%esp
80101df5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101df8:	56                   	push   %esi
80101df9:	e8 02 fa ff ff       	call   80101800 <iunlock>
  iput(ip);
80101dfe:	89 34 24             	mov    %esi,(%esp)
80101e01:	e8 4a fa ff ff       	call   80101850 <iput>
80101e06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e09:	83 c4 10             	add    $0x10,%esp
80101e0c:	89 c6                	mov    %eax,%esi
80101e0e:	e9 38 ff ff ff       	jmp    80101d4b <namex+0x4b>
80101e13:	90                   	nop
80101e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101e18:	89 da                	mov    %ebx,%edx
80101e1a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e22:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e25:	51                   	push   %ecx
80101e26:	53                   	push   %ebx
80101e27:	57                   	push   %edi
80101e28:	e8 f3 2b 00 00       	call   80104a20 <memmove>
    name[len] = 0;
80101e2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e30:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e33:	83 c4 10             	add    $0x10,%esp
80101e36:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e3a:	89 d3                	mov    %edx,%ebx
80101e3c:	e9 61 ff ff ff       	jmp    80101da2 <namex+0xa2>
80101e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e4b:	85 c0                	test   %eax,%eax
80101e4d:	75 5d                	jne    80101eac <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e52:	89 f0                	mov    %esi,%eax
80101e54:	5b                   	pop    %ebx
80101e55:	5e                   	pop    %esi
80101e56:	5f                   	pop    %edi
80101e57:	5d                   	pop    %ebp
80101e58:	c3                   	ret    
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e60:	83 ec 0c             	sub    $0xc,%esp
80101e63:	56                   	push   %esi
80101e64:	e8 97 f9 ff ff       	call   80101800 <iunlock>
  iput(ip);
80101e69:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e6c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e6e:	e8 dd f9 ff ff       	call   80101850 <iput>
      return 0;
80101e73:	83 c4 10             	add    $0x10,%esp
}
80101e76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e79:	89 f0                	mov    %esi,%eax
80101e7b:	5b                   	pop    %ebx
80101e7c:	5e                   	pop    %esi
80101e7d:	5f                   	pop    %edi
80101e7e:	5d                   	pop    %ebp
80101e7f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e80:	ba 01 00 00 00       	mov    $0x1,%edx
80101e85:	b8 01 00 00 00       	mov    $0x1,%eax
80101e8a:	e8 a1 f4 ff ff       	call   80101330 <iget>
80101e8f:	89 c6                	mov    %eax,%esi
80101e91:	e9 b5 fe ff ff       	jmp    80101d4b <namex+0x4b>
      iunlock(ip);
80101e96:	83 ec 0c             	sub    $0xc,%esp
80101e99:	56                   	push   %esi
80101e9a:	e8 61 f9 ff ff       	call   80101800 <iunlock>
      return ip;
80101e9f:	83 c4 10             	add    $0x10,%esp
}
80101ea2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea5:	89 f0                	mov    %esi,%eax
80101ea7:	5b                   	pop    %ebx
80101ea8:	5e                   	pop    %esi
80101ea9:	5f                   	pop    %edi
80101eaa:	5d                   	pop    %ebp
80101eab:	c3                   	ret    
    iput(ip);
80101eac:	83 ec 0c             	sub    $0xc,%esp
80101eaf:	56                   	push   %esi
    return 0;
80101eb0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101eb2:	e8 99 f9 ff ff       	call   80101850 <iput>
    return 0;
80101eb7:	83 c4 10             	add    $0x10,%esp
80101eba:	eb 93                	jmp    80101e4f <namex+0x14f>
80101ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ec0 <dirlink>:
{
80101ec0:	55                   	push   %ebp
80101ec1:	89 e5                	mov    %esp,%ebp
80101ec3:	57                   	push   %edi
80101ec4:	56                   	push   %esi
80101ec5:	53                   	push   %ebx
80101ec6:	83 ec 20             	sub    $0x20,%esp
80101ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ecc:	6a 00                	push   $0x0
80101ece:	ff 75 0c             	pushl  0xc(%ebp)
80101ed1:	53                   	push   %ebx
80101ed2:	e8 79 fd ff ff       	call   80101c50 <dirlookup>
80101ed7:	83 c4 10             	add    $0x10,%esp
80101eda:	85 c0                	test   %eax,%eax
80101edc:	75 67                	jne    80101f45 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ede:	8b 7b 58             	mov    0x58(%ebx),%edi
80101ee1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ee4:	85 ff                	test   %edi,%edi
80101ee6:	74 29                	je     80101f11 <dirlink+0x51>
80101ee8:	31 ff                	xor    %edi,%edi
80101eea:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101eed:	eb 09                	jmp    80101ef8 <dirlink+0x38>
80101eef:	90                   	nop
80101ef0:	83 c7 10             	add    $0x10,%edi
80101ef3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ef6:	73 19                	jae    80101f11 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ef8:	6a 10                	push   $0x10
80101efa:	57                   	push   %edi
80101efb:	56                   	push   %esi
80101efc:	53                   	push   %ebx
80101efd:	e8 fe fa ff ff       	call   80101a00 <readi>
80101f02:	83 c4 10             	add    $0x10,%esp
80101f05:	83 f8 10             	cmp    $0x10,%eax
80101f08:	75 4e                	jne    80101f58 <dirlink+0x98>
    if(de.inum == 0)
80101f0a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f0f:	75 df                	jne    80101ef0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f11:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f14:	83 ec 04             	sub    $0x4,%esp
80101f17:	6a 0e                	push   $0xe
80101f19:	ff 75 0c             	pushl  0xc(%ebp)
80101f1c:	50                   	push   %eax
80101f1d:	e8 ce 2b 00 00       	call   80104af0 <strncpy>
  de.inum = inum;
80101f22:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f25:	6a 10                	push   $0x10
80101f27:	57                   	push   %edi
80101f28:	56                   	push   %esi
80101f29:	53                   	push   %ebx
  de.inum = inum;
80101f2a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f2e:	e8 cd fb ff ff       	call   80101b00 <writei>
80101f33:	83 c4 20             	add    $0x20,%esp
80101f36:	83 f8 10             	cmp    $0x10,%eax
80101f39:	75 2a                	jne    80101f65 <dirlink+0xa5>
  return 0;
80101f3b:	31 c0                	xor    %eax,%eax
}
80101f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f40:	5b                   	pop    %ebx
80101f41:	5e                   	pop    %esi
80101f42:	5f                   	pop    %edi
80101f43:	5d                   	pop    %ebp
80101f44:	c3                   	ret    
    iput(ip);
80101f45:	83 ec 0c             	sub    $0xc,%esp
80101f48:	50                   	push   %eax
80101f49:	e8 02 f9 ff ff       	call   80101850 <iput>
    return -1;
80101f4e:	83 c4 10             	add    $0x10,%esp
80101f51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f56:	eb e5                	jmp    80101f3d <dirlink+0x7d>
      panic("dirlink read");
80101f58:	83 ec 0c             	sub    $0xc,%esp
80101f5b:	68 08 79 10 80       	push   $0x80107908
80101f60:	e8 2b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f65:	83 ec 0c             	sub    $0xc,%esp
80101f68:	68 91 7f 10 80       	push   $0x80107f91
80101f6d:	e8 1e e4 ff ff       	call   80100390 <panic>
80101f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f80 <namei>:

struct inode*
namei(char *path)
{
80101f80:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f81:	31 d2                	xor    %edx,%edx
{
80101f83:	89 e5                	mov    %esp,%ebp
80101f85:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f88:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f8e:	e8 6d fd ff ff       	call   80101d00 <namex>
}
80101f93:	c9                   	leave  
80101f94:	c3                   	ret    
80101f95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fa0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fa0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fa1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fa6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fa8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101fab:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fae:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101faf:	e9 4c fd ff ff       	jmp    80101d00 <namex>
80101fb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101fc0 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101fc0:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101fc1:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80101fc6:	89 e5                	mov    %esp,%ebp
80101fc8:	57                   	push   %edi
80101fc9:	56                   	push   %esi
80101fca:	53                   	push   %ebx
80101fcb:	83 ec 10             	sub    $0x10,%esp
80101fce:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101fd1:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101fd8:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101fdf:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80101fe3:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80101fe7:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
80101fea:	85 c9                	test   %ecx,%ecx
80101fec:	79 0a                	jns    80101ff8 <itoa+0x38>
80101fee:	89 f0                	mov    %esi,%eax
80101ff0:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80101ff3:	f7 d9                	neg    %ecx
        *p++ = '-';
80101ff5:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80101ff8:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
80101ffa:	bf 67 66 66 66       	mov    $0x66666667,%edi
80101fff:	90                   	nop
80102000:	89 d8                	mov    %ebx,%eax
80102002:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80102005:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80102008:	f7 ef                	imul   %edi
8010200a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
8010200d:	29 da                	sub    %ebx,%edx
8010200f:	89 d3                	mov    %edx,%ebx
80102011:	75 ed                	jne    80102000 <itoa+0x40>
    *p = '\0';
80102013:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102016:	bb 67 66 66 66       	mov    $0x66666667,%ebx
8010201b:	90                   	nop
8010201c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102020:	89 c8                	mov    %ecx,%eax
80102022:	83 ee 01             	sub    $0x1,%esi
80102025:	f7 eb                	imul   %ebx
80102027:	89 c8                	mov    %ecx,%eax
80102029:	c1 f8 1f             	sar    $0x1f,%eax
8010202c:	c1 fa 02             	sar    $0x2,%edx
8010202f:	29 c2                	sub    %eax,%edx
80102031:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102034:	01 c0                	add    %eax,%eax
80102036:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80102038:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
8010203a:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
8010203f:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102041:	88 06                	mov    %al,(%esi)
    }while(i);
80102043:	75 db                	jne    80102020 <itoa+0x60>
    return b;
}
80102045:	8b 45 0c             	mov    0xc(%ebp),%eax
80102048:	83 c4 10             	add    $0x10,%esp
8010204b:	5b                   	pop    %ebx
8010204c:	5e                   	pop    %esi
8010204d:	5f                   	pop    %edi
8010204e:	5d                   	pop    %ebp
8010204f:	c3                   	ret    

80102050 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102056:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80102059:	83 ec 40             	sub    $0x40,%esp
8010205c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010205f:	6a 06                	push   $0x6
80102061:	68 15 79 10 80       	push   $0x80107915
80102066:	56                   	push   %esi
80102067:	e8 b4 29 00 00       	call   80104a20 <memmove>
  itoa(p->pid, path+ 6);
8010206c:	58                   	pop    %eax
8010206d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102070:	5a                   	pop    %edx
80102071:	50                   	push   %eax
80102072:	ff 73 10             	pushl  0x10(%ebx)
80102075:	e8 46 ff ff ff       	call   80101fc0 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010207a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010207d:	83 c4 10             	add    $0x10,%esp
80102080:	85 c0                	test   %eax,%eax
80102082:	0f 84 88 01 00 00    	je     80102210 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102088:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010208b:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
8010208e:	50                   	push   %eax
8010208f:	e8 4c ee ff ff       	call   80100ee0 <fileclose>

  begin_op();
80102094:	e8 b7 0f 00 00       	call   80103050 <begin_op>
  return namex(path, 1, name);
80102099:	89 f0                	mov    %esi,%eax
8010209b:	89 d9                	mov    %ebx,%ecx
8010209d:	ba 01 00 00 00       	mov    $0x1,%edx
801020a2:	e8 59 fc ff ff       	call   80101d00 <namex>
  if((dp = nameiparent(path, name)) == 0)
801020a7:	83 c4 10             	add    $0x10,%esp
801020aa:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
801020ac:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
801020ae:	0f 84 66 01 00 00    	je     8010221a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
801020b4:	83 ec 0c             	sub    $0xc,%esp
801020b7:	50                   	push   %eax
801020b8:	e8 63 f6 ff ff       	call   80101720 <ilock>
  return strncmp(s, t, DIRSIZ);
801020bd:	83 c4 0c             	add    $0xc,%esp
801020c0:	6a 0e                	push   $0xe
801020c2:	68 1d 79 10 80       	push   $0x8010791d
801020c7:	53                   	push   %ebx
801020c8:	e8 c3 29 00 00       	call   80104a90 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801020cd:	83 c4 10             	add    $0x10,%esp
801020d0:	85 c0                	test   %eax,%eax
801020d2:	0f 84 f8 00 00 00    	je     801021d0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801020d8:	83 ec 04             	sub    $0x4,%esp
801020db:	6a 0e                	push   $0xe
801020dd:	68 1c 79 10 80       	push   $0x8010791c
801020e2:	53                   	push   %ebx
801020e3:	e8 a8 29 00 00       	call   80104a90 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801020e8:	83 c4 10             	add    $0x10,%esp
801020eb:	85 c0                	test   %eax,%eax
801020ed:	0f 84 dd 00 00 00    	je     801021d0 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801020f3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801020f6:	83 ec 04             	sub    $0x4,%esp
801020f9:	50                   	push   %eax
801020fa:	53                   	push   %ebx
801020fb:	56                   	push   %esi
801020fc:	e8 4f fb ff ff       	call   80101c50 <dirlookup>
80102101:	83 c4 10             	add    $0x10,%esp
80102104:	85 c0                	test   %eax,%eax
80102106:	89 c3                	mov    %eax,%ebx
80102108:	0f 84 c2 00 00 00    	je     801021d0 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010210e:	83 ec 0c             	sub    $0xc,%esp
80102111:	50                   	push   %eax
80102112:	e8 09 f6 ff ff       	call   80101720 <ilock>

  if(ip->nlink < 1)
80102117:	83 c4 10             	add    $0x10,%esp
8010211a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010211f:	0f 8e 11 01 00 00    	jle    80102236 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102125:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010212a:	74 74                	je     801021a0 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010212c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010212f:	83 ec 04             	sub    $0x4,%esp
80102132:	6a 10                	push   $0x10
80102134:	6a 00                	push   $0x0
80102136:	57                   	push   %edi
80102137:	e8 34 28 00 00       	call   80104970 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010213c:	6a 10                	push   $0x10
8010213e:	ff 75 b8             	pushl  -0x48(%ebp)
80102141:	57                   	push   %edi
80102142:	56                   	push   %esi
80102143:	e8 b8 f9 ff ff       	call   80101b00 <writei>
80102148:	83 c4 20             	add    $0x20,%esp
8010214b:	83 f8 10             	cmp    $0x10,%eax
8010214e:	0f 85 d5 00 00 00    	jne    80102229 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102154:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102159:	0f 84 91 00 00 00    	je     801021f0 <removeSwapFile+0x1a0>
  iunlock(ip);
8010215f:	83 ec 0c             	sub    $0xc,%esp
80102162:	56                   	push   %esi
80102163:	e8 98 f6 ff ff       	call   80101800 <iunlock>
  iput(ip);
80102168:	89 34 24             	mov    %esi,(%esp)
8010216b:	e8 e0 f6 ff ff       	call   80101850 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102170:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102175:	89 1c 24             	mov    %ebx,(%esp)
80102178:	e8 f3 f4 ff ff       	call   80101670 <iupdate>
  iunlock(ip);
8010217d:	89 1c 24             	mov    %ebx,(%esp)
80102180:	e8 7b f6 ff ff       	call   80101800 <iunlock>
  iput(ip);
80102185:	89 1c 24             	mov    %ebx,(%esp)
80102188:	e8 c3 f6 ff ff       	call   80101850 <iput>
  iunlockput(ip);

  end_op();
8010218d:	e8 2e 0f 00 00       	call   801030c0 <end_op>

  return 0;
80102192:	83 c4 10             	add    $0x10,%esp
80102195:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102197:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010219a:	5b                   	pop    %ebx
8010219b:	5e                   	pop    %esi
8010219c:	5f                   	pop    %edi
8010219d:	5d                   	pop    %ebp
8010219e:	c3                   	ret    
8010219f:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
801021a0:	83 ec 0c             	sub    $0xc,%esp
801021a3:	53                   	push   %ebx
801021a4:	e8 a7 2f 00 00       	call   80105150 <isdirempty>
801021a9:	83 c4 10             	add    $0x10,%esp
801021ac:	85 c0                	test   %eax,%eax
801021ae:	0f 85 78 ff ff ff    	jne    8010212c <removeSwapFile+0xdc>
  iunlock(ip);
801021b4:	83 ec 0c             	sub    $0xc,%esp
801021b7:	53                   	push   %ebx
801021b8:	e8 43 f6 ff ff       	call   80101800 <iunlock>
  iput(ip);
801021bd:	89 1c 24             	mov    %ebx,(%esp)
801021c0:	e8 8b f6 ff ff       	call   80101850 <iput>
801021c5:	83 c4 10             	add    $0x10,%esp
801021c8:	90                   	nop
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801021d0:	83 ec 0c             	sub    $0xc,%esp
801021d3:	56                   	push   %esi
801021d4:	e8 27 f6 ff ff       	call   80101800 <iunlock>
  iput(ip);
801021d9:	89 34 24             	mov    %esi,(%esp)
801021dc:	e8 6f f6 ff ff       	call   80101850 <iput>
    end_op();
801021e1:	e8 da 0e 00 00       	call   801030c0 <end_op>
    return -1;
801021e6:	83 c4 10             	add    $0x10,%esp
801021e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021ee:	eb a7                	jmp    80102197 <removeSwapFile+0x147>
    dp->nlink--;
801021f0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801021f5:	83 ec 0c             	sub    $0xc,%esp
801021f8:	56                   	push   %esi
801021f9:	e8 72 f4 ff ff       	call   80101670 <iupdate>
801021fe:	83 c4 10             	add    $0x10,%esp
80102201:	e9 59 ff ff ff       	jmp    8010215f <removeSwapFile+0x10f>
80102206:	8d 76 00             	lea    0x0(%esi),%esi
80102209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102215:	e9 7d ff ff ff       	jmp    80102197 <removeSwapFile+0x147>
    end_op();
8010221a:	e8 a1 0e 00 00       	call   801030c0 <end_op>
    return -1;
8010221f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102224:	e9 6e ff ff ff       	jmp    80102197 <removeSwapFile+0x147>
    panic("unlink: writei");
80102229:	83 ec 0c             	sub    $0xc,%esp
8010222c:	68 31 79 10 80       	push   $0x80107931
80102231:	e8 5a e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102236:	83 ec 0c             	sub    $0xc,%esp
80102239:	68 1f 79 10 80       	push   $0x8010791f
8010223e:	e8 4d e1 ff ff       	call   80100390 <panic>
80102243:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102250 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	56                   	push   %esi
80102254:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102255:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
80102258:	83 ec 14             	sub    $0x14,%esp
8010225b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010225e:	6a 06                	push   $0x6
80102260:	68 15 79 10 80       	push   $0x80107915
80102265:	56                   	push   %esi
80102266:	e8 b5 27 00 00       	call   80104a20 <memmove>
  itoa(p->pid, path+ 6);
8010226b:	58                   	pop    %eax
8010226c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010226f:	5a                   	pop    %edx
80102270:	50                   	push   %eax
80102271:	ff 73 10             	pushl  0x10(%ebx)
80102274:	e8 47 fd ff ff       	call   80101fc0 <itoa>

    begin_op();
80102279:	e8 d2 0d 00 00       	call   80103050 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010227e:	6a 00                	push   $0x0
80102280:	6a 00                	push   $0x0
80102282:	6a 02                	push   $0x2
80102284:	56                   	push   %esi
80102285:	e8 d6 30 00 00       	call   80105360 <create>
  iunlock(in);
8010228a:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
8010228d:	89 c6                	mov    %eax,%esi
  iunlock(in);
8010228f:	50                   	push   %eax
80102290:	e8 6b f5 ff ff       	call   80101800 <iunlock>

  p->swapFile = filealloc();
80102295:	e8 86 eb ff ff       	call   80100e20 <filealloc>
  if (p->swapFile == 0)
8010229a:	83 c4 10             	add    $0x10,%esp
8010229d:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
8010229f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
801022a2:	74 32                	je     801022d6 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
801022a4:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
801022a7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022aa:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
801022b0:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022b3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
801022ba:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022bd:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
801022c1:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022c4:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
801022c8:	e8 f3 0d 00 00       	call   801030c0 <end_op>

    return 0;
}
801022cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022d0:	31 c0                	xor    %eax,%eax
801022d2:	5b                   	pop    %ebx
801022d3:	5e                   	pop    %esi
801022d4:	5d                   	pop    %ebp
801022d5:	c3                   	ret    
    panic("no slot for files on /store");
801022d6:	83 ec 0c             	sub    $0xc,%esp
801022d9:	68 40 79 10 80       	push   $0x80107940
801022de:	e8 ad e0 ff ff       	call   80100390 <panic>
801022e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022f0 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc* p, char* buffer, uint placeOnFile, uint size)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801022f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801022f9:	8b 50 7c             	mov    0x7c(%eax),%edx
801022fc:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
801022ff:	8b 55 14             	mov    0x14(%ebp),%edx
80102302:	89 55 10             	mov    %edx,0x10(%ebp)
80102305:	8b 40 7c             	mov    0x7c(%eax),%eax
80102308:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010230b:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
8010230c:	e9 7f ed ff ff       	jmp    80101090 <filewrite>
80102311:	eb 0d                	jmp    80102320 <readFromSwapFile>
80102313:	90                   	nop
80102314:	90                   	nop
80102315:	90                   	nop
80102316:	90                   	nop
80102317:	90                   	nop
80102318:	90                   	nop
80102319:	90                   	nop
8010231a:	90                   	nop
8010231b:	90                   	nop
8010231c:	90                   	nop
8010231d:	90                   	nop
8010231e:	90                   	nop
8010231f:	90                   	nop

80102320 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102326:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102329:	8b 50 7c             	mov    0x7c(%eax),%edx
8010232c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010232f:	8b 55 14             	mov    0x14(%ebp),%edx
80102332:	89 55 10             	mov    %edx,0x10(%ebp)
80102335:	8b 40 7c             	mov    0x7c(%eax),%eax
80102338:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010233b:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
8010233c:	e9 bf ec ff ff       	jmp    80101000 <fileread>
80102341:	66 90                	xchg   %ax,%ax
80102343:	66 90                	xchg   %ax,%ax
80102345:	66 90                	xchg   %ax,%ax
80102347:	66 90                	xchg   %ax,%ax
80102349:	66 90                	xchg   %ax,%ax
8010234b:	66 90                	xchg   %ax,%ax
8010234d:	66 90                	xchg   %ax,%ax
8010234f:	90                   	nop

80102350 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	57                   	push   %edi
80102354:	56                   	push   %esi
80102355:	53                   	push   %ebx
80102356:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102359:	85 c0                	test   %eax,%eax
8010235b:	0f 84 b4 00 00 00    	je     80102415 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102361:	8b 58 08             	mov    0x8(%eax),%ebx
80102364:	89 c6                	mov    %eax,%esi
80102366:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010236c:	0f 87 96 00 00 00    	ja     80102408 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102372:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102377:	89 f6                	mov    %esi,%esi
80102379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102380:	89 ca                	mov    %ecx,%edx
80102382:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102383:	83 e0 c0             	and    $0xffffffc0,%eax
80102386:	3c 40                	cmp    $0x40,%al
80102388:	75 f6                	jne    80102380 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010238a:	31 ff                	xor    %edi,%edi
8010238c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102391:	89 f8                	mov    %edi,%eax
80102393:	ee                   	out    %al,(%dx)
80102394:	b8 01 00 00 00       	mov    $0x1,%eax
80102399:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010239e:	ee                   	out    %al,(%dx)
8010239f:	ba f3 01 00 00       	mov    $0x1f3,%edx
801023a4:	89 d8                	mov    %ebx,%eax
801023a6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801023a7:	89 d8                	mov    %ebx,%eax
801023a9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801023ae:	c1 f8 08             	sar    $0x8,%eax
801023b1:	ee                   	out    %al,(%dx)
801023b2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801023b7:	89 f8                	mov    %edi,%eax
801023b9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801023ba:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801023be:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023c3:	c1 e0 04             	shl    $0x4,%eax
801023c6:	83 e0 10             	and    $0x10,%eax
801023c9:	83 c8 e0             	or     $0xffffffe0,%eax
801023cc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801023cd:	f6 06 04             	testb  $0x4,(%esi)
801023d0:	75 16                	jne    801023e8 <idestart+0x98>
801023d2:	b8 20 00 00 00       	mov    $0x20,%eax
801023d7:	89 ca                	mov    %ecx,%edx
801023d9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801023da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023dd:	5b                   	pop    %ebx
801023de:	5e                   	pop    %esi
801023df:	5f                   	pop    %edi
801023e0:	5d                   	pop    %ebp
801023e1:	c3                   	ret    
801023e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801023e8:	b8 30 00 00 00       	mov    $0x30,%eax
801023ed:	89 ca                	mov    %ecx,%edx
801023ef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801023f0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801023f5:	83 c6 5c             	add    $0x5c,%esi
801023f8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023fd:	fc                   	cld    
801023fe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102400:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102403:	5b                   	pop    %ebx
80102404:	5e                   	pop    %esi
80102405:	5f                   	pop    %edi
80102406:	5d                   	pop    %ebp
80102407:	c3                   	ret    
    panic("incorrect blockno");
80102408:	83 ec 0c             	sub    $0xc,%esp
8010240b:	68 b8 79 10 80       	push   $0x801079b8
80102410:	e8 7b df ff ff       	call   80100390 <panic>
    panic("idestart");
80102415:	83 ec 0c             	sub    $0xc,%esp
80102418:	68 af 79 10 80       	push   $0x801079af
8010241d:	e8 6e df ff ff       	call   80100390 <panic>
80102422:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102430 <ideinit>:
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102436:	68 ca 79 10 80       	push   $0x801079ca
8010243b:	68 80 b5 10 80       	push   $0x8010b580
80102440:	e8 db 22 00 00       	call   80104720 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102445:	58                   	pop    %eax
80102446:	a1 80 1d 12 80       	mov    0x80121d80,%eax
8010244b:	5a                   	pop    %edx
8010244c:	83 e8 01             	sub    $0x1,%eax
8010244f:	50                   	push   %eax
80102450:	6a 0e                	push   $0xe
80102452:	e8 a9 02 00 00       	call   80102700 <ioapicenable>
80102457:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010245a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010245f:	90                   	nop
80102460:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102461:	83 e0 c0             	and    $0xffffffc0,%eax
80102464:	3c 40                	cmp    $0x40,%al
80102466:	75 f8                	jne    80102460 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102468:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010246d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102472:	ee                   	out    %al,(%dx)
80102473:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102478:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010247d:	eb 06                	jmp    80102485 <ideinit+0x55>
8010247f:	90                   	nop
  for(i=0; i<1000; i++){
80102480:	83 e9 01             	sub    $0x1,%ecx
80102483:	74 0f                	je     80102494 <ideinit+0x64>
80102485:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102486:	84 c0                	test   %al,%al
80102488:	74 f6                	je     80102480 <ideinit+0x50>
      havedisk1 = 1;
8010248a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102491:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102494:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102499:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010249e:	ee                   	out    %al,(%dx)
}
8010249f:	c9                   	leave  
801024a0:	c3                   	ret    
801024a1:	eb 0d                	jmp    801024b0 <ideintr>
801024a3:	90                   	nop
801024a4:	90                   	nop
801024a5:	90                   	nop
801024a6:	90                   	nop
801024a7:	90                   	nop
801024a8:	90                   	nop
801024a9:	90                   	nop
801024aa:	90                   	nop
801024ab:	90                   	nop
801024ac:	90                   	nop
801024ad:	90                   	nop
801024ae:	90                   	nop
801024af:	90                   	nop

801024b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	57                   	push   %edi
801024b4:	56                   	push   %esi
801024b5:	53                   	push   %ebx
801024b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801024b9:	68 80 b5 10 80       	push   $0x8010b580
801024be:	e8 9d 23 00 00       	call   80104860 <acquire>

  if((b = idequeue) == 0){
801024c3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801024c9:	83 c4 10             	add    $0x10,%esp
801024cc:	85 db                	test   %ebx,%ebx
801024ce:	74 67                	je     80102537 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801024d0:	8b 43 58             	mov    0x58(%ebx),%eax
801024d3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801024d8:	8b 3b                	mov    (%ebx),%edi
801024da:	f7 c7 04 00 00 00    	test   $0x4,%edi
801024e0:	75 31                	jne    80102513 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024e7:	89 f6                	mov    %esi,%esi
801024e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801024f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024f1:	89 c6                	mov    %eax,%esi
801024f3:	83 e6 c0             	and    $0xffffffc0,%esi
801024f6:	89 f1                	mov    %esi,%ecx
801024f8:	80 f9 40             	cmp    $0x40,%cl
801024fb:	75 f3                	jne    801024f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024fd:	a8 21                	test   $0x21,%al
801024ff:	75 12                	jne    80102513 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102501:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102504:	b9 80 00 00 00       	mov    $0x80,%ecx
80102509:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010250e:	fc                   	cld    
8010250f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102511:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102513:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102516:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102519:	89 f9                	mov    %edi,%ecx
8010251b:	83 c9 02             	or     $0x2,%ecx
8010251e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102520:	53                   	push   %ebx
80102521:	e8 1a 1f 00 00       	call   80104440 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102526:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010252b:	83 c4 10             	add    $0x10,%esp
8010252e:	85 c0                	test   %eax,%eax
80102530:	74 05                	je     80102537 <ideintr+0x87>
    idestart(idequeue);
80102532:	e8 19 fe ff ff       	call   80102350 <idestart>
    release(&idelock);
80102537:	83 ec 0c             	sub    $0xc,%esp
8010253a:	68 80 b5 10 80       	push   $0x8010b580
8010253f:	e8 dc 23 00 00       	call   80104920 <release>

  release(&idelock);
}
80102544:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102547:	5b                   	pop    %ebx
80102548:	5e                   	pop    %esi
80102549:	5f                   	pop    %edi
8010254a:	5d                   	pop    %ebp
8010254b:	c3                   	ret    
8010254c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102550 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	53                   	push   %ebx
80102554:	83 ec 10             	sub    $0x10,%esp
80102557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010255a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010255d:	50                   	push   %eax
8010255e:	e8 6d 21 00 00       	call   801046d0 <holdingsleep>
80102563:	83 c4 10             	add    $0x10,%esp
80102566:	85 c0                	test   %eax,%eax
80102568:	0f 84 c6 00 00 00    	je     80102634 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010256e:	8b 03                	mov    (%ebx),%eax
80102570:	83 e0 06             	and    $0x6,%eax
80102573:	83 f8 02             	cmp    $0x2,%eax
80102576:	0f 84 ab 00 00 00    	je     80102627 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010257c:	8b 53 04             	mov    0x4(%ebx),%edx
8010257f:	85 d2                	test   %edx,%edx
80102581:	74 0d                	je     80102590 <iderw+0x40>
80102583:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102588:	85 c0                	test   %eax,%eax
8010258a:	0f 84 b1 00 00 00    	je     80102641 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102590:	83 ec 0c             	sub    $0xc,%esp
80102593:	68 80 b5 10 80       	push   $0x8010b580
80102598:	e8 c3 22 00 00       	call   80104860 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010259d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801025a3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801025a6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025ad:	85 d2                	test   %edx,%edx
801025af:	75 09                	jne    801025ba <iderw+0x6a>
801025b1:	eb 6d                	jmp    80102620 <iderw+0xd0>
801025b3:	90                   	nop
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025b8:	89 c2                	mov    %eax,%edx
801025ba:	8b 42 58             	mov    0x58(%edx),%eax
801025bd:	85 c0                	test   %eax,%eax
801025bf:	75 f7                	jne    801025b8 <iderw+0x68>
801025c1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801025c4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801025c6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801025cc:	74 42                	je     80102610 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801025ce:	8b 03                	mov    (%ebx),%eax
801025d0:	83 e0 06             	and    $0x6,%eax
801025d3:	83 f8 02             	cmp    $0x2,%eax
801025d6:	74 23                	je     801025fb <iderw+0xab>
801025d8:	90                   	nop
801025d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801025e0:	83 ec 08             	sub    $0x8,%esp
801025e3:	68 80 b5 10 80       	push   $0x8010b580
801025e8:	53                   	push   %ebx
801025e9:	e8 92 1c 00 00       	call   80104280 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801025ee:	8b 03                	mov    (%ebx),%eax
801025f0:	83 c4 10             	add    $0x10,%esp
801025f3:	83 e0 06             	and    $0x6,%eax
801025f6:	83 f8 02             	cmp    $0x2,%eax
801025f9:	75 e5                	jne    801025e0 <iderw+0x90>
  }


  release(&idelock);
801025fb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102602:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102605:	c9                   	leave  
  release(&idelock);
80102606:	e9 15 23 00 00       	jmp    80104920 <release>
8010260b:	90                   	nop
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102610:	89 d8                	mov    %ebx,%eax
80102612:	e8 39 fd ff ff       	call   80102350 <idestart>
80102617:	eb b5                	jmp    801025ce <iderw+0x7e>
80102619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102620:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102625:	eb 9d                	jmp    801025c4 <iderw+0x74>
    panic("iderw: nothing to do");
80102627:	83 ec 0c             	sub    $0xc,%esp
8010262a:	68 e4 79 10 80       	push   $0x801079e4
8010262f:	e8 5c dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102634:	83 ec 0c             	sub    $0xc,%esp
80102637:	68 ce 79 10 80       	push   $0x801079ce
8010263c:	e8 4f dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102641:	83 ec 0c             	sub    $0xc,%esp
80102644:	68 f9 79 10 80       	push   $0x801079f9
80102649:	e8 42 dd ff ff       	call   80100390 <panic>
8010264e:	66 90                	xchg   %ax,%ax

80102650 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102650:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102651:	c7 05 74 16 12 80 00 	movl   $0xfec00000,0x80121674
80102658:	00 c0 fe 
{
8010265b:	89 e5                	mov    %esp,%ebp
8010265d:	56                   	push   %esi
8010265e:	53                   	push   %ebx
  ioapic->reg = reg;
8010265f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102666:	00 00 00 
  return ioapic->data;
80102669:	a1 74 16 12 80       	mov    0x80121674,%eax
8010266e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102671:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102677:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010267d:	0f b6 15 e0 17 12 80 	movzbl 0x801217e0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102684:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102687:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010268a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010268d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102690:	39 c2                	cmp    %eax,%edx
80102692:	74 16                	je     801026aa <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102694:	83 ec 0c             	sub    $0xc,%esp
80102697:	68 18 7a 10 80       	push   $0x80107a18
8010269c:	e8 bf df ff ff       	call   80100660 <cprintf>
801026a1:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
801026a7:	83 c4 10             	add    $0x10,%esp
801026aa:	83 c3 21             	add    $0x21,%ebx
{
801026ad:	ba 10 00 00 00       	mov    $0x10,%edx
801026b2:	b8 20 00 00 00       	mov    $0x20,%eax
801026b7:	89 f6                	mov    %esi,%esi
801026b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801026c0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801026c2:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801026c8:	89 c6                	mov    %eax,%esi
801026ca:	81 ce 00 00 01 00    	or     $0x10000,%esi
801026d0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026d3:	89 71 10             	mov    %esi,0x10(%ecx)
801026d6:	8d 72 01             	lea    0x1(%edx),%esi
801026d9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801026dc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801026de:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801026e0:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
801026e6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801026ed:	75 d1                	jne    801026c0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801026ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026f2:	5b                   	pop    %ebx
801026f3:	5e                   	pop    %esi
801026f4:	5d                   	pop    %ebp
801026f5:	c3                   	ret    
801026f6:	8d 76 00             	lea    0x0(%esi),%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102700 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102700:	55                   	push   %ebp
  ioapic->reg = reg;
80102701:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
{
80102707:	89 e5                	mov    %esp,%ebp
80102709:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010270c:	8d 50 20             	lea    0x20(%eax),%edx
8010270f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102713:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102715:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010271b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010271e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102721:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102724:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102726:	a1 74 16 12 80       	mov    0x80121674,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010272b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010272e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102731:	5d                   	pop    %ebp
80102732:	c3                   	ret    
80102733:	66 90                	xchg   %ax,%ax
80102735:	66 90                	xchg   %ax,%ax
80102737:	66 90                	xchg   %ax,%ax
80102739:	66 90                	xchg   %ax,%ax
8010273b:	66 90                	xchg   %ax,%ax
8010273d:	66 90                	xchg   %ax,%ax
8010273f:	90                   	nop

80102740 <init_cow>:



struct spinlock r_cow_lock;

void init_cow(){
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	83 ec 14             	sub    $0x14,%esp
  cprintf("initing cow\n");
80102746:	68 4a 7a 10 80       	push   $0x80107a4a
8010274b:	e8 10 df ff ff       	call   80100660 <cprintf>
  memset((void*)pg_ref_counts, 0, sizeof(pg_ref_counts));
80102750:	83 c4 0c             	add    $0xc,%esp
80102753:	68 00 e0 00 00       	push   $0xe000
80102758:	6a 00                	push   $0x0
8010275a:	68 40 0f 11 80       	push   $0x80110f40
8010275f:	e8 0c 22 00 00       	call   80104970 <memset>
  initlock(&r_cow_lock, "cow lock");
80102764:	58                   	pop    %eax
80102765:	5a                   	pop    %edx
80102766:	68 57 7a 10 80       	push   $0x80107a57
8010276b:	68 c0 16 12 80       	push   $0x801216c0
80102770:	e8 ab 1f 00 00       	call   80104720 <initlock>
  cow_lock = &r_cow_lock;
  cprintf("initing cow end\n");
80102775:	c7 04 24 60 7a 10 80 	movl   $0x80107a60,(%esp)
  cow_lock = &r_cow_lock;
8010277c:	c7 05 40 ef 11 80 c0 	movl   $0x801216c0,0x8011ef40
80102783:	16 12 80 
  cprintf("initing cow end\n");
80102786:	e8 d5 de ff ff       	call   80100660 <cprintf>
}
8010278b:	83 c4 10             	add    $0x10,%esp
8010278e:	c9                   	leave  
8010278f:	c3                   	ret    

80102790 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	53                   	push   %ebx
80102794:	83 ec 04             	sub    $0x4,%esp
80102797:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010279a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801027a0:	75 70                	jne    80102812 <kfree+0x82>
801027a2:	81 fb 28 1a 13 80    	cmp    $0x80131a28,%ebx
801027a8:	72 68                	jb     80102812 <kfree+0x82>
801027aa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801027b0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801027b5:	77 5b                	ja     80102812 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801027b7:	83 ec 04             	sub    $0x4,%esp
801027ba:	68 00 10 00 00       	push   $0x1000
801027bf:	6a 01                	push   $0x1
801027c1:	53                   	push   %ebx
801027c2:	e8 a9 21 00 00       	call   80104970 <memset>

  if(kmem.use_lock)
801027c7:	8b 15 b4 16 12 80    	mov    0x801216b4,%edx
801027cd:	83 c4 10             	add    $0x10,%esp
801027d0:	85 d2                	test   %edx,%edx
801027d2:	75 2c                	jne    80102800 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801027d4:	a1 b8 16 12 80       	mov    0x801216b8,%eax
801027d9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801027db:	a1 b4 16 12 80       	mov    0x801216b4,%eax
  kmem.freelist = r;
801027e0:	89 1d b8 16 12 80    	mov    %ebx,0x801216b8
  if(kmem.use_lock)
801027e6:	85 c0                	test   %eax,%eax
801027e8:	75 06                	jne    801027f0 <kfree+0x60>
    release(&kmem.lock);
}
801027ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ed:	c9                   	leave  
801027ee:	c3                   	ret    
801027ef:	90                   	nop
    release(&kmem.lock);
801027f0:	c7 45 08 80 16 12 80 	movl   $0x80121680,0x8(%ebp)
}
801027f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027fa:	c9                   	leave  
    release(&kmem.lock);
801027fb:	e9 20 21 00 00       	jmp    80104920 <release>
    acquire(&kmem.lock);
80102800:	83 ec 0c             	sub    $0xc,%esp
80102803:	68 80 16 12 80       	push   $0x80121680
80102808:	e8 53 20 00 00       	call   80104860 <acquire>
8010280d:	83 c4 10             	add    $0x10,%esp
80102810:	eb c2                	jmp    801027d4 <kfree+0x44>
    panic("kfree");
80102812:	83 ec 0c             	sub    $0xc,%esp
80102815:	68 ca 81 10 80       	push   $0x801081ca
8010281a:	e8 71 db ff ff       	call   80100390 <panic>
8010281f:	90                   	nop

80102820 <freerange>:
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
80102823:	56                   	push   %esi
80102824:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102825:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102828:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010282b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102831:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102837:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010283d:	39 de                	cmp    %ebx,%esi
8010283f:	72 33                	jb     80102874 <freerange+0x54>
80102841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102848:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010284e:	83 ec 0c             	sub    $0xc,%esp
80102851:	50                   	push   %eax
80102852:	e8 39 ff ff ff       	call   80102790 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102857:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010285d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102863:	83 c4 10             	add    $0x10,%esp
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102866:	c1 e8 0c             	shr    $0xc,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102869:	39 f3                	cmp    %esi,%ebx
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
8010286b:	c6 80 40 0f 11 80 00 	movb   $0x0,-0x7feef0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102872:	76 d4                	jbe    80102848 <freerange+0x28>
}
80102874:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102877:	5b                   	pop    %ebx
80102878:	5e                   	pop    %esi
80102879:	5d                   	pop    %ebp
8010287a:	c3                   	ret    
8010287b:	90                   	nop
8010287c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102880 <kinit1>:
{
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
80102883:	56                   	push   %esi
80102884:	53                   	push   %ebx
80102885:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102888:	83 ec 08             	sub    $0x8,%esp
8010288b:	68 71 7a 10 80       	push   $0x80107a71
80102890:	68 80 16 12 80       	push   $0x80121680
80102895:	e8 86 1e 00 00       	call   80104720 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010289a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010289d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801028a0:	c7 05 b4 16 12 80 00 	movl   $0x0,0x801216b4
801028a7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801028aa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028b0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028b6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028bc:	39 de                	cmp    %ebx,%esi
801028be:	72 2c                	jb     801028ec <kinit1+0x6c>
    kfree(p);
801028c0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801028c6:	83 ec 0c             	sub    $0xc,%esp
801028c9:	50                   	push   %eax
801028ca:	e8 c1 fe ff ff       	call   80102790 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
801028cf:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028d5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028db:	83 c4 10             	add    $0x10,%esp
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
801028de:	c1 e8 0c             	shr    $0xc,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028e1:	39 de                	cmp    %ebx,%esi
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
801028e3:	c6 80 40 0f 11 80 00 	movb   $0x0,-0x7feef0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028ea:	73 d4                	jae    801028c0 <kinit1+0x40>
}
801028ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028ef:	5b                   	pop    %ebx
801028f0:	5e                   	pop    %esi
801028f1:	5d                   	pop    %ebp
801028f2:	c3                   	ret    
801028f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801028f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102900 <kinit2>:
{
80102900:	55                   	push   %ebp
80102901:	89 e5                	mov    %esp,%ebp
80102903:	56                   	push   %esi
80102904:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102905:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102908:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010290b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102911:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102917:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010291d:	39 de                	cmp    %ebx,%esi
8010291f:	72 33                	jb     80102954 <kinit2+0x54>
80102921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102928:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010292e:	83 ec 0c             	sub    $0xc,%esp
80102931:	50                   	push   %eax
80102932:	e8 59 fe ff ff       	call   80102790 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102937:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010293d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102943:	83 c4 10             	add    $0x10,%esp
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102946:	c1 e8 0c             	shr    $0xc,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102949:	39 de                	cmp    %ebx,%esi
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
8010294b:	c6 80 40 0f 11 80 00 	movb   $0x0,-0x7feef0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102952:	73 d4                	jae    80102928 <kinit2+0x28>
  kmem.use_lock = 1;
80102954:	c7 05 b4 16 12 80 01 	movl   $0x1,0x801216b4
8010295b:	00 00 00 
}
8010295e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102961:	5b                   	pop    %ebx
80102962:	5e                   	pop    %esi
80102963:	5d                   	pop    %ebp
80102964:	c3                   	ret    
80102965:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102970 <kalloc>:
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;
  if(kmem.use_lock)
80102970:	a1 b4 16 12 80       	mov    0x801216b4,%eax
80102975:	85 c0                	test   %eax,%eax
80102977:	75 1f                	jne    80102998 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102979:	a1 b8 16 12 80       	mov    0x801216b8,%eax
  if(r)
8010297e:	85 c0                	test   %eax,%eax
80102980:	74 0e                	je     80102990 <kalloc+0x20>
    kmem.freelist = r->next;
80102982:	8b 10                	mov    (%eax),%edx
80102984:	89 15 b8 16 12 80    	mov    %edx,0x801216b8
8010298a:	c3                   	ret    
8010298b:	90                   	nop
8010298c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102990:	f3 c3                	repz ret 
80102992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102998:	55                   	push   %ebp
80102999:	89 e5                	mov    %esp,%ebp
8010299b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010299e:	68 80 16 12 80       	push   $0x80121680
801029a3:	e8 b8 1e 00 00       	call   80104860 <acquire>
  r = kmem.freelist;
801029a8:	a1 b8 16 12 80       	mov    0x801216b8,%eax
  if(r)
801029ad:	83 c4 10             	add    $0x10,%esp
801029b0:	8b 15 b4 16 12 80    	mov    0x801216b4,%edx
801029b6:	85 c0                	test   %eax,%eax
801029b8:	74 08                	je     801029c2 <kalloc+0x52>
    kmem.freelist = r->next;
801029ba:	8b 08                	mov    (%eax),%ecx
801029bc:	89 0d b8 16 12 80    	mov    %ecx,0x801216b8
  if(kmem.use_lock)
801029c2:	85 d2                	test   %edx,%edx
801029c4:	74 16                	je     801029dc <kalloc+0x6c>
    release(&kmem.lock);
801029c6:	83 ec 0c             	sub    $0xc,%esp
801029c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029cc:	68 80 16 12 80       	push   $0x80121680
801029d1:	e8 4a 1f 00 00       	call   80104920 <release>
  return (char*)r;
801029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801029d9:	83 c4 10             	add    $0x10,%esp
}
801029dc:	c9                   	leave  
801029dd:	c3                   	ret    
801029de:	66 90                	xchg   %ax,%ax

801029e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e0:	ba 64 00 00 00       	mov    $0x64,%edx
801029e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801029e6:	a8 01                	test   $0x1,%al
801029e8:	0f 84 c2 00 00 00    	je     80102ab0 <kbdgetc+0xd0>
801029ee:	ba 60 00 00 00       	mov    $0x60,%edx
801029f3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801029f4:	0f b6 d0             	movzbl %al,%edx
801029f7:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
801029fd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102a03:	0f 84 7f 00 00 00    	je     80102a88 <kbdgetc+0xa8>
{
80102a09:	55                   	push   %ebp
80102a0a:	89 e5                	mov    %esp,%ebp
80102a0c:	53                   	push   %ebx
80102a0d:	89 cb                	mov    %ecx,%ebx
80102a0f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102a12:	84 c0                	test   %al,%al
80102a14:	78 4a                	js     80102a60 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102a16:	85 db                	test   %ebx,%ebx
80102a18:	74 09                	je     80102a23 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102a1a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102a1d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102a20:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102a23:	0f b6 82 a0 7b 10 80 	movzbl -0x7fef8460(%edx),%eax
80102a2a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102a2c:	0f b6 82 a0 7a 10 80 	movzbl -0x7fef8560(%edx),%eax
80102a33:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a35:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102a37:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102a3d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102a40:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102a43:	8b 04 85 80 7a 10 80 	mov    -0x7fef8580(,%eax,4),%eax
80102a4a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102a4e:	74 31                	je     80102a81 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102a50:	8d 50 9f             	lea    -0x61(%eax),%edx
80102a53:	83 fa 19             	cmp    $0x19,%edx
80102a56:	77 40                	ja     80102a98 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102a58:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a5b:	5b                   	pop    %ebx
80102a5c:	5d                   	pop    %ebp
80102a5d:	c3                   	ret    
80102a5e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102a60:	83 e0 7f             	and    $0x7f,%eax
80102a63:	85 db                	test   %ebx,%ebx
80102a65:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102a68:	0f b6 82 a0 7b 10 80 	movzbl -0x7fef8460(%edx),%eax
80102a6f:	83 c8 40             	or     $0x40,%eax
80102a72:	0f b6 c0             	movzbl %al,%eax
80102a75:	f7 d0                	not    %eax
80102a77:	21 c1                	and    %eax,%ecx
    return 0;
80102a79:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102a7b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102a81:	5b                   	pop    %ebx
80102a82:	5d                   	pop    %ebp
80102a83:	c3                   	ret    
80102a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102a88:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102a8b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102a8d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102a98:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102a9b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102a9e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102a9f:	83 f9 1a             	cmp    $0x1a,%ecx
80102aa2:	0f 42 c2             	cmovb  %edx,%eax
}
80102aa5:	5d                   	pop    %ebp
80102aa6:	c3                   	ret    
80102aa7:	89 f6                	mov    %esi,%esi
80102aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ab5:	c3                   	ret    
80102ab6:	8d 76 00             	lea    0x0(%esi),%esi
80102ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ac0 <kbdintr>:

void
kbdintr(void)
{
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
80102ac3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102ac6:	68 e0 29 10 80       	push   $0x801029e0
80102acb:	e8 40 dd ff ff       	call   80100810 <consoleintr>
}
80102ad0:	83 c4 10             	add    $0x10,%esp
80102ad3:	c9                   	leave  
80102ad4:	c3                   	ret    
80102ad5:	66 90                	xchg   %ax,%ax
80102ad7:	66 90                	xchg   %ax,%ax
80102ad9:	66 90                	xchg   %ax,%ax
80102adb:	66 90                	xchg   %ax,%ax
80102add:	66 90                	xchg   %ax,%ax
80102adf:	90                   	nop

80102ae0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102ae0:	a1 f4 16 12 80       	mov    0x801216f4,%eax
{
80102ae5:	55                   	push   %ebp
80102ae6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102ae8:	85 c0                	test   %eax,%eax
80102aea:	0f 84 c8 00 00 00    	je     80102bb8 <lapicinit+0xd8>
  lapic[index] = value;
80102af0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102af7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102afa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102afd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102b04:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b07:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b0a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102b11:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102b14:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b17:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102b1e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102b21:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b24:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102b2b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b2e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b31:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102b38:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b3b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102b3e:	8b 50 30             	mov    0x30(%eax),%edx
80102b41:	c1 ea 10             	shr    $0x10,%edx
80102b44:	80 fa 03             	cmp    $0x3,%dl
80102b47:	77 77                	ja     80102bc0 <lapicinit+0xe0>
  lapic[index] = value;
80102b49:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102b50:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b53:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b56:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b5d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b60:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b63:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b6a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b6d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b70:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b77:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b7a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b7d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102b84:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b87:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b8a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102b91:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102b94:	8b 50 20             	mov    0x20(%eax),%edx
80102b97:	89 f6                	mov    %esi,%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102ba0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102ba6:	80 e6 10             	and    $0x10,%dh
80102ba9:	75 f5                	jne    80102ba0 <lapicinit+0xc0>
  lapic[index] = value;
80102bab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102bb2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bb5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102bc0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102bc7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102bca:	8b 50 20             	mov    0x20(%eax),%edx
80102bcd:	e9 77 ff ff ff       	jmp    80102b49 <lapicinit+0x69>
80102bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102be0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102be0:	8b 15 f4 16 12 80    	mov    0x801216f4,%edx
{
80102be6:	55                   	push   %ebp
80102be7:	31 c0                	xor    %eax,%eax
80102be9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102beb:	85 d2                	test   %edx,%edx
80102bed:	74 06                	je     80102bf5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102bef:	8b 42 20             	mov    0x20(%edx),%eax
80102bf2:	c1 e8 18             	shr    $0x18,%eax
}
80102bf5:	5d                   	pop    %ebp
80102bf6:	c3                   	ret    
80102bf7:	89 f6                	mov    %esi,%esi
80102bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c00 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102c00:	a1 f4 16 12 80       	mov    0x801216f4,%eax
{
80102c05:	55                   	push   %ebp
80102c06:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102c08:	85 c0                	test   %eax,%eax
80102c0a:	74 0d                	je     80102c19 <lapiceoi+0x19>
  lapic[index] = value;
80102c0c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102c13:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c16:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102c19:	5d                   	pop    %ebp
80102c1a:	c3                   	ret    
80102c1b:	90                   	nop
80102c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c20 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
}
80102c23:	5d                   	pop    %ebp
80102c24:	c3                   	ret    
80102c25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c30 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102c30:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c31:	b8 0f 00 00 00       	mov    $0xf,%eax
80102c36:	ba 70 00 00 00       	mov    $0x70,%edx
80102c3b:	89 e5                	mov    %esp,%ebp
80102c3d:	53                   	push   %ebx
80102c3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102c41:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102c44:	ee                   	out    %al,(%dx)
80102c45:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c4a:	ba 71 00 00 00       	mov    $0x71,%edx
80102c4f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102c50:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c52:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102c55:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102c5b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c5d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102c60:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102c63:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c65:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102c68:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102c6e:	a1 f4 16 12 80       	mov    0x801216f4,%eax
80102c73:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c79:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c7c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102c83:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c86:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c89:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102c90:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c93:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c96:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c9c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c9f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ca5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ca8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cb1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102cb7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102cba:	5b                   	pop    %ebx
80102cbb:	5d                   	pop    %ebp
80102cbc:	c3                   	ret    
80102cbd:	8d 76 00             	lea    0x0(%esi),%esi

80102cc0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102cc0:	55                   	push   %ebp
80102cc1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102cc6:	ba 70 00 00 00       	mov    $0x70,%edx
80102ccb:	89 e5                	mov    %esp,%ebp
80102ccd:	57                   	push   %edi
80102cce:	56                   	push   %esi
80102ccf:	53                   	push   %ebx
80102cd0:	83 ec 4c             	sub    $0x4c,%esp
80102cd3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cd4:	ba 71 00 00 00       	mov    $0x71,%edx
80102cd9:	ec                   	in     (%dx),%al
80102cda:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cdd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ce2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ce5:	8d 76 00             	lea    0x0(%esi),%esi
80102ce8:	31 c0                	xor    %eax,%eax
80102cea:	89 da                	mov    %ebx,%edx
80102cec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ced:	b9 71 00 00 00       	mov    $0x71,%ecx
80102cf2:	89 ca                	mov    %ecx,%edx
80102cf4:	ec                   	in     (%dx),%al
80102cf5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf8:	89 da                	mov    %ebx,%edx
80102cfa:	b8 02 00 00 00       	mov    $0x2,%eax
80102cff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d00:	89 ca                	mov    %ecx,%edx
80102d02:	ec                   	in     (%dx),%al
80102d03:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d06:	89 da                	mov    %ebx,%edx
80102d08:	b8 04 00 00 00       	mov    $0x4,%eax
80102d0d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d0e:	89 ca                	mov    %ecx,%edx
80102d10:	ec                   	in     (%dx),%al
80102d11:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d14:	89 da                	mov    %ebx,%edx
80102d16:	b8 07 00 00 00       	mov    $0x7,%eax
80102d1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d1c:	89 ca                	mov    %ecx,%edx
80102d1e:	ec                   	in     (%dx),%al
80102d1f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d22:	89 da                	mov    %ebx,%edx
80102d24:	b8 08 00 00 00       	mov    $0x8,%eax
80102d29:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d2a:	89 ca                	mov    %ecx,%edx
80102d2c:	ec                   	in     (%dx),%al
80102d2d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d2f:	89 da                	mov    %ebx,%edx
80102d31:	b8 09 00 00 00       	mov    $0x9,%eax
80102d36:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d37:	89 ca                	mov    %ecx,%edx
80102d39:	ec                   	in     (%dx),%al
80102d3a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d3c:	89 da                	mov    %ebx,%edx
80102d3e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102d43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d44:	89 ca                	mov    %ecx,%edx
80102d46:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102d47:	84 c0                	test   %al,%al
80102d49:	78 9d                	js     80102ce8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102d4b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102d4f:	89 fa                	mov    %edi,%edx
80102d51:	0f b6 fa             	movzbl %dl,%edi
80102d54:	89 f2                	mov    %esi,%edx
80102d56:	0f b6 f2             	movzbl %dl,%esi
80102d59:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d5c:	89 da                	mov    %ebx,%edx
80102d5e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102d61:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102d64:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102d68:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102d6b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102d6f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102d72:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102d76:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102d79:	31 c0                	xor    %eax,%eax
80102d7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d7c:	89 ca                	mov    %ecx,%edx
80102d7e:	ec                   	in     (%dx),%al
80102d7f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d82:	89 da                	mov    %ebx,%edx
80102d84:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102d87:	b8 02 00 00 00       	mov    $0x2,%eax
80102d8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d8d:	89 ca                	mov    %ecx,%edx
80102d8f:	ec                   	in     (%dx),%al
80102d90:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d93:	89 da                	mov    %ebx,%edx
80102d95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102d98:	b8 04 00 00 00       	mov    $0x4,%eax
80102d9d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d9e:	89 ca                	mov    %ecx,%edx
80102da0:	ec                   	in     (%dx),%al
80102da1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102da4:	89 da                	mov    %ebx,%edx
80102da6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102da9:	b8 07 00 00 00       	mov    $0x7,%eax
80102dae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102daf:	89 ca                	mov    %ecx,%edx
80102db1:	ec                   	in     (%dx),%al
80102db2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db5:	89 da                	mov    %ebx,%edx
80102db7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102dba:	b8 08 00 00 00       	mov    $0x8,%eax
80102dbf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dc0:	89 ca                	mov    %ecx,%edx
80102dc2:	ec                   	in     (%dx),%al
80102dc3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc6:	89 da                	mov    %ebx,%edx
80102dc8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102dcb:	b8 09 00 00 00       	mov    $0x9,%eax
80102dd0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dd1:	89 ca                	mov    %ecx,%edx
80102dd3:	ec                   	in     (%dx),%al
80102dd4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102dd7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102dda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ddd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102de0:	6a 18                	push   $0x18
80102de2:	50                   	push   %eax
80102de3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102de6:	50                   	push   %eax
80102de7:	e8 d4 1b 00 00       	call   801049c0 <memcmp>
80102dec:	83 c4 10             	add    $0x10,%esp
80102def:	85 c0                	test   %eax,%eax
80102df1:	0f 85 f1 fe ff ff    	jne    80102ce8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102df7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102dfb:	75 78                	jne    80102e75 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102dfd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e00:	89 c2                	mov    %eax,%edx
80102e02:	83 e0 0f             	and    $0xf,%eax
80102e05:	c1 ea 04             	shr    $0x4,%edx
80102e08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e0e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102e11:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e14:	89 c2                	mov    %eax,%edx
80102e16:	83 e0 0f             	and    $0xf,%eax
80102e19:	c1 ea 04             	shr    $0x4,%edx
80102e1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e22:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102e25:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e28:	89 c2                	mov    %eax,%edx
80102e2a:	83 e0 0f             	and    $0xf,%eax
80102e2d:	c1 ea 04             	shr    $0x4,%edx
80102e30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e36:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102e39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e3c:	89 c2                	mov    %eax,%edx
80102e3e:	83 e0 0f             	and    $0xf,%eax
80102e41:	c1 ea 04             	shr    $0x4,%edx
80102e44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e4a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102e4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e50:	89 c2                	mov    %eax,%edx
80102e52:	83 e0 0f             	and    $0xf,%eax
80102e55:	c1 ea 04             	shr    $0x4,%edx
80102e58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102e61:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e64:	89 c2                	mov    %eax,%edx
80102e66:	83 e0 0f             	and    $0xf,%eax
80102e69:	c1 ea 04             	shr    $0x4,%edx
80102e6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e72:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102e75:	8b 75 08             	mov    0x8(%ebp),%esi
80102e78:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e7b:	89 06                	mov    %eax,(%esi)
80102e7d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e80:	89 46 04             	mov    %eax,0x4(%esi)
80102e83:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e86:	89 46 08             	mov    %eax,0x8(%esi)
80102e89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e8c:	89 46 0c             	mov    %eax,0xc(%esi)
80102e8f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e92:	89 46 10             	mov    %eax,0x10(%esi)
80102e95:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e98:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102e9b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ea2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ea5:	5b                   	pop    %ebx
80102ea6:	5e                   	pop    %esi
80102ea7:	5f                   	pop    %edi
80102ea8:	5d                   	pop    %ebp
80102ea9:	c3                   	ret    
80102eaa:	66 90                	xchg   %ax,%ax
80102eac:	66 90                	xchg   %ax,%ax
80102eae:	66 90                	xchg   %ax,%ax

80102eb0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102eb0:	8b 0d 48 17 12 80    	mov    0x80121748,%ecx
80102eb6:	85 c9                	test   %ecx,%ecx
80102eb8:	0f 8e 8a 00 00 00    	jle    80102f48 <install_trans+0x98>
{
80102ebe:	55                   	push   %ebp
80102ebf:	89 e5                	mov    %esp,%ebp
80102ec1:	57                   	push   %edi
80102ec2:	56                   	push   %esi
80102ec3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102ec4:	31 db                	xor    %ebx,%ebx
{
80102ec6:	83 ec 0c             	sub    $0xc,%esp
80102ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ed0:	a1 34 17 12 80       	mov    0x80121734,%eax
80102ed5:	83 ec 08             	sub    $0x8,%esp
80102ed8:	01 d8                	add    %ebx,%eax
80102eda:	83 c0 01             	add    $0x1,%eax
80102edd:	50                   	push   %eax
80102ede:	ff 35 44 17 12 80    	pushl  0x80121744
80102ee4:	e8 e7 d1 ff ff       	call   801000d0 <bread>
80102ee9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102eeb:	58                   	pop    %eax
80102eec:	5a                   	pop    %edx
80102eed:	ff 34 9d 4c 17 12 80 	pushl  -0x7fede8b4(,%ebx,4)
80102ef4:	ff 35 44 17 12 80    	pushl  0x80121744
  for (tail = 0; tail < log.lh.n; tail++) {
80102efa:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102efd:	e8 ce d1 ff ff       	call   801000d0 <bread>
80102f02:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102f04:	8d 47 5c             	lea    0x5c(%edi),%eax
80102f07:	83 c4 0c             	add    $0xc,%esp
80102f0a:	68 00 02 00 00       	push   $0x200
80102f0f:	50                   	push   %eax
80102f10:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f13:	50                   	push   %eax
80102f14:	e8 07 1b 00 00       	call   80104a20 <memmove>
    bwrite(dbuf);  // write dst to disk
80102f19:	89 34 24             	mov    %esi,(%esp)
80102f1c:	e8 7f d2 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102f21:	89 3c 24             	mov    %edi,(%esp)
80102f24:	e8 b7 d2 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102f29:	89 34 24             	mov    %esi,(%esp)
80102f2c:	e8 af d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f31:	83 c4 10             	add    $0x10,%esp
80102f34:	39 1d 48 17 12 80    	cmp    %ebx,0x80121748
80102f3a:	7f 94                	jg     80102ed0 <install_trans+0x20>
  }
}
80102f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f3f:	5b                   	pop    %ebx
80102f40:	5e                   	pop    %esi
80102f41:	5f                   	pop    %edi
80102f42:	5d                   	pop    %ebp
80102f43:	c3                   	ret    
80102f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f48:	f3 c3                	repz ret 
80102f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102f50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	56                   	push   %esi
80102f54:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102f55:	83 ec 08             	sub    $0x8,%esp
80102f58:	ff 35 34 17 12 80    	pushl  0x80121734
80102f5e:	ff 35 44 17 12 80    	pushl  0x80121744
80102f64:	e8 67 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102f69:	8b 1d 48 17 12 80    	mov    0x80121748,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102f6f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f72:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102f74:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102f76:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102f79:	7e 16                	jle    80102f91 <write_head+0x41>
80102f7b:	c1 e3 02             	shl    $0x2,%ebx
80102f7e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102f80:	8b 8a 4c 17 12 80    	mov    -0x7fede8b4(%edx),%ecx
80102f86:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102f8a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102f8d:	39 da                	cmp    %ebx,%edx
80102f8f:	75 ef                	jne    80102f80 <write_head+0x30>
  }
  bwrite(buf);
80102f91:	83 ec 0c             	sub    $0xc,%esp
80102f94:	56                   	push   %esi
80102f95:	e8 06 d2 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102f9a:	89 34 24             	mov    %esi,(%esp)
80102f9d:	e8 3e d2 ff ff       	call   801001e0 <brelse>
}
80102fa2:	83 c4 10             	add    $0x10,%esp
80102fa5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102fa8:	5b                   	pop    %ebx
80102fa9:	5e                   	pop    %esi
80102faa:	5d                   	pop    %ebp
80102fab:	c3                   	ret    
80102fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102fb0 <initlog>:
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	53                   	push   %ebx
80102fb4:	83 ec 2c             	sub    $0x2c,%esp
80102fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102fba:	68 a0 7c 10 80       	push   $0x80107ca0
80102fbf:	68 00 17 12 80       	push   $0x80121700
80102fc4:	e8 57 17 00 00       	call   80104720 <initlock>
  readsb(dev, &sb);
80102fc9:	58                   	pop    %eax
80102fca:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102fcd:	5a                   	pop    %edx
80102fce:	50                   	push   %eax
80102fcf:	53                   	push   %ebx
80102fd0:	e8 0b e5 ff ff       	call   801014e0 <readsb>
  log.size = sb.nlog;
80102fd5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102fd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102fdb:	59                   	pop    %ecx
  log.dev = dev;
80102fdc:	89 1d 44 17 12 80    	mov    %ebx,0x80121744
  log.size = sb.nlog;
80102fe2:	89 15 38 17 12 80    	mov    %edx,0x80121738
  log.start = sb.logstart;
80102fe8:	a3 34 17 12 80       	mov    %eax,0x80121734
  struct buf *buf = bread(log.dev, log.start);
80102fed:	5a                   	pop    %edx
80102fee:	50                   	push   %eax
80102fef:	53                   	push   %ebx
80102ff0:	e8 db d0 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102ff5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ff8:	83 c4 10             	add    $0x10,%esp
80102ffb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102ffd:	89 1d 48 17 12 80    	mov    %ebx,0x80121748
  for (i = 0; i < log.lh.n; i++) {
80103003:	7e 1c                	jle    80103021 <initlog+0x71>
80103005:	c1 e3 02             	shl    $0x2,%ebx
80103008:	31 d2                	xor    %edx,%edx
8010300a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103010:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103014:	83 c2 04             	add    $0x4,%edx
80103017:	89 8a 48 17 12 80    	mov    %ecx,-0x7fede8b8(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010301d:	39 d3                	cmp    %edx,%ebx
8010301f:	75 ef                	jne    80103010 <initlog+0x60>
  brelse(buf);
80103021:	83 ec 0c             	sub    $0xc,%esp
80103024:	50                   	push   %eax
80103025:	e8 b6 d1 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010302a:	e8 81 fe ff ff       	call   80102eb0 <install_trans>
  log.lh.n = 0;
8010302f:	c7 05 48 17 12 80 00 	movl   $0x0,0x80121748
80103036:	00 00 00 
  write_head(); // clear the log
80103039:	e8 12 ff ff ff       	call   80102f50 <write_head>
}
8010303e:	83 c4 10             	add    $0x10,%esp
80103041:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103044:	c9                   	leave  
80103045:	c3                   	ret    
80103046:	8d 76 00             	lea    0x0(%esi),%esi
80103049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103050 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103056:	68 00 17 12 80       	push   $0x80121700
8010305b:	e8 00 18 00 00       	call   80104860 <acquire>
80103060:	83 c4 10             	add    $0x10,%esp
80103063:	eb 18                	jmp    8010307d <begin_op+0x2d>
80103065:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103068:	83 ec 08             	sub    $0x8,%esp
8010306b:	68 00 17 12 80       	push   $0x80121700
80103070:	68 00 17 12 80       	push   $0x80121700
80103075:	e8 06 12 00 00       	call   80104280 <sleep>
8010307a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010307d:	a1 40 17 12 80       	mov    0x80121740,%eax
80103082:	85 c0                	test   %eax,%eax
80103084:	75 e2                	jne    80103068 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103086:	a1 3c 17 12 80       	mov    0x8012173c,%eax
8010308b:	8b 15 48 17 12 80    	mov    0x80121748,%edx
80103091:	83 c0 01             	add    $0x1,%eax
80103094:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103097:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010309a:	83 fa 1e             	cmp    $0x1e,%edx
8010309d:	7f c9                	jg     80103068 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010309f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801030a2:	a3 3c 17 12 80       	mov    %eax,0x8012173c
      release(&log.lock);
801030a7:	68 00 17 12 80       	push   $0x80121700
801030ac:	e8 6f 18 00 00       	call   80104920 <release>
      break;
    }
  }
}
801030b1:	83 c4 10             	add    $0x10,%esp
801030b4:	c9                   	leave  
801030b5:	c3                   	ret    
801030b6:	8d 76 00             	lea    0x0(%esi),%esi
801030b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030c0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	57                   	push   %edi
801030c4:	56                   	push   %esi
801030c5:	53                   	push   %ebx
801030c6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801030c9:	68 00 17 12 80       	push   $0x80121700
801030ce:	e8 8d 17 00 00       	call   80104860 <acquire>
  log.outstanding -= 1;
801030d3:	a1 3c 17 12 80       	mov    0x8012173c,%eax
  if(log.committing)
801030d8:	8b 35 40 17 12 80    	mov    0x80121740,%esi
801030de:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801030e1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
801030e4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
801030e6:	89 1d 3c 17 12 80    	mov    %ebx,0x8012173c
  if(log.committing)
801030ec:	0f 85 1a 01 00 00    	jne    8010320c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
801030f2:	85 db                	test   %ebx,%ebx
801030f4:	0f 85 ee 00 00 00    	jne    801031e8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801030fa:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
801030fd:	c7 05 40 17 12 80 01 	movl   $0x1,0x80121740
80103104:	00 00 00 
  release(&log.lock);
80103107:	68 00 17 12 80       	push   $0x80121700
8010310c:	e8 0f 18 00 00       	call   80104920 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103111:	8b 0d 48 17 12 80    	mov    0x80121748,%ecx
80103117:	83 c4 10             	add    $0x10,%esp
8010311a:	85 c9                	test   %ecx,%ecx
8010311c:	0f 8e 85 00 00 00    	jle    801031a7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103122:	a1 34 17 12 80       	mov    0x80121734,%eax
80103127:	83 ec 08             	sub    $0x8,%esp
8010312a:	01 d8                	add    %ebx,%eax
8010312c:	83 c0 01             	add    $0x1,%eax
8010312f:	50                   	push   %eax
80103130:	ff 35 44 17 12 80    	pushl  0x80121744
80103136:	e8 95 cf ff ff       	call   801000d0 <bread>
8010313b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010313d:	58                   	pop    %eax
8010313e:	5a                   	pop    %edx
8010313f:	ff 34 9d 4c 17 12 80 	pushl  -0x7fede8b4(,%ebx,4)
80103146:	ff 35 44 17 12 80    	pushl  0x80121744
  for (tail = 0; tail < log.lh.n; tail++) {
8010314c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010314f:	e8 7c cf ff ff       	call   801000d0 <bread>
80103154:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103156:	8d 40 5c             	lea    0x5c(%eax),%eax
80103159:	83 c4 0c             	add    $0xc,%esp
8010315c:	68 00 02 00 00       	push   $0x200
80103161:	50                   	push   %eax
80103162:	8d 46 5c             	lea    0x5c(%esi),%eax
80103165:	50                   	push   %eax
80103166:	e8 b5 18 00 00       	call   80104a20 <memmove>
    bwrite(to);  // write the log
8010316b:	89 34 24             	mov    %esi,(%esp)
8010316e:	e8 2d d0 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103173:	89 3c 24             	mov    %edi,(%esp)
80103176:	e8 65 d0 ff ff       	call   801001e0 <brelse>
    brelse(to);
8010317b:	89 34 24             	mov    %esi,(%esp)
8010317e:	e8 5d d0 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103183:	83 c4 10             	add    $0x10,%esp
80103186:	3b 1d 48 17 12 80    	cmp    0x80121748,%ebx
8010318c:	7c 94                	jl     80103122 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010318e:	e8 bd fd ff ff       	call   80102f50 <write_head>
    install_trans(); // Now install writes to home locations
80103193:	e8 18 fd ff ff       	call   80102eb0 <install_trans>
    log.lh.n = 0;
80103198:	c7 05 48 17 12 80 00 	movl   $0x0,0x80121748
8010319f:	00 00 00 
    write_head();    // Erase the transaction from the log
801031a2:	e8 a9 fd ff ff       	call   80102f50 <write_head>
    acquire(&log.lock);
801031a7:	83 ec 0c             	sub    $0xc,%esp
801031aa:	68 00 17 12 80       	push   $0x80121700
801031af:	e8 ac 16 00 00       	call   80104860 <acquire>
    wakeup(&log);
801031b4:	c7 04 24 00 17 12 80 	movl   $0x80121700,(%esp)
    log.committing = 0;
801031bb:	c7 05 40 17 12 80 00 	movl   $0x0,0x80121740
801031c2:	00 00 00 
    wakeup(&log);
801031c5:	e8 76 12 00 00       	call   80104440 <wakeup>
    release(&log.lock);
801031ca:	c7 04 24 00 17 12 80 	movl   $0x80121700,(%esp)
801031d1:	e8 4a 17 00 00       	call   80104920 <release>
801031d6:	83 c4 10             	add    $0x10,%esp
}
801031d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031dc:	5b                   	pop    %ebx
801031dd:	5e                   	pop    %esi
801031de:	5f                   	pop    %edi
801031df:	5d                   	pop    %ebp
801031e0:	c3                   	ret    
801031e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
801031e8:	83 ec 0c             	sub    $0xc,%esp
801031eb:	68 00 17 12 80       	push   $0x80121700
801031f0:	e8 4b 12 00 00       	call   80104440 <wakeup>
  release(&log.lock);
801031f5:	c7 04 24 00 17 12 80 	movl   $0x80121700,(%esp)
801031fc:	e8 1f 17 00 00       	call   80104920 <release>
80103201:	83 c4 10             	add    $0x10,%esp
}
80103204:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103207:	5b                   	pop    %ebx
80103208:	5e                   	pop    %esi
80103209:	5f                   	pop    %edi
8010320a:	5d                   	pop    %ebp
8010320b:	c3                   	ret    
    panic("log.committing");
8010320c:	83 ec 0c             	sub    $0xc,%esp
8010320f:	68 a4 7c 10 80       	push   $0x80107ca4
80103214:	e8 77 d1 ff ff       	call   80100390 <panic>
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103220 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	53                   	push   %ebx
80103224:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103227:	8b 15 48 17 12 80    	mov    0x80121748,%edx
{
8010322d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103230:	83 fa 1d             	cmp    $0x1d,%edx
80103233:	0f 8f 9d 00 00 00    	jg     801032d6 <log_write+0xb6>
80103239:	a1 38 17 12 80       	mov    0x80121738,%eax
8010323e:	83 e8 01             	sub    $0x1,%eax
80103241:	39 c2                	cmp    %eax,%edx
80103243:	0f 8d 8d 00 00 00    	jge    801032d6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103249:	a1 3c 17 12 80       	mov    0x8012173c,%eax
8010324e:	85 c0                	test   %eax,%eax
80103250:	0f 8e 8d 00 00 00    	jle    801032e3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103256:	83 ec 0c             	sub    $0xc,%esp
80103259:	68 00 17 12 80       	push   $0x80121700
8010325e:	e8 fd 15 00 00       	call   80104860 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103263:	8b 0d 48 17 12 80    	mov    0x80121748,%ecx
80103269:	83 c4 10             	add    $0x10,%esp
8010326c:	83 f9 00             	cmp    $0x0,%ecx
8010326f:	7e 57                	jle    801032c8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103271:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103274:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103276:	3b 15 4c 17 12 80    	cmp    0x8012174c,%edx
8010327c:	75 0b                	jne    80103289 <log_write+0x69>
8010327e:	eb 38                	jmp    801032b8 <log_write+0x98>
80103280:	39 14 85 4c 17 12 80 	cmp    %edx,-0x7fede8b4(,%eax,4)
80103287:	74 2f                	je     801032b8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103289:	83 c0 01             	add    $0x1,%eax
8010328c:	39 c1                	cmp    %eax,%ecx
8010328e:	75 f0                	jne    80103280 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103290:	89 14 85 4c 17 12 80 	mov    %edx,-0x7fede8b4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103297:	83 c0 01             	add    $0x1,%eax
8010329a:	a3 48 17 12 80       	mov    %eax,0x80121748
  b->flags |= B_DIRTY; // prevent eviction
8010329f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801032a2:	c7 45 08 00 17 12 80 	movl   $0x80121700,0x8(%ebp)
}
801032a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032ac:	c9                   	leave  
  release(&log.lock);
801032ad:	e9 6e 16 00 00       	jmp    80104920 <release>
801032b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801032b8:	89 14 85 4c 17 12 80 	mov    %edx,-0x7fede8b4(,%eax,4)
801032bf:	eb de                	jmp    8010329f <log_write+0x7f>
801032c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032c8:	8b 43 08             	mov    0x8(%ebx),%eax
801032cb:	a3 4c 17 12 80       	mov    %eax,0x8012174c
  if (i == log.lh.n)
801032d0:	75 cd                	jne    8010329f <log_write+0x7f>
801032d2:	31 c0                	xor    %eax,%eax
801032d4:	eb c1                	jmp    80103297 <log_write+0x77>
    panic("too big a transaction");
801032d6:	83 ec 0c             	sub    $0xc,%esp
801032d9:	68 b3 7c 10 80       	push   $0x80107cb3
801032de:	e8 ad d0 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801032e3:	83 ec 0c             	sub    $0xc,%esp
801032e6:	68 c9 7c 10 80       	push   $0x80107cc9
801032eb:	e8 a0 d0 ff ff       	call   80100390 <panic>

801032f0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	53                   	push   %ebx
801032f4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801032f7:	e8 84 09 00 00       	call   80103c80 <cpuid>
801032fc:	89 c3                	mov    %eax,%ebx
801032fe:	e8 7d 09 00 00       	call   80103c80 <cpuid>
80103303:	83 ec 04             	sub    $0x4,%esp
80103306:	53                   	push   %ebx
80103307:	50                   	push   %eax
80103308:	68 e4 7c 10 80       	push   $0x80107ce4
8010330d:	e8 4e d3 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103312:	e8 29 29 00 00       	call   80105c40 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103317:	e8 d4 08 00 00       	call   80103bf0 <mycpu>
8010331c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010331e:	b8 01 00 00 00       	mov    $0x1,%eax
80103323:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010332a:	e8 61 0c 00 00       	call   80103f90 <scheduler>
8010332f:	90                   	nop

80103330 <mpenter>:
{
80103330:	55                   	push   %ebp
80103331:	89 e5                	mov    %esp,%ebp
80103333:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103336:	e8 05 3c 00 00       	call   80106f40 <switchkvm>
  seginit();
8010333b:	e8 50 3b 00 00       	call   80106e90 <seginit>
  lapicinit();
80103340:	e8 9b f7 ff ff       	call   80102ae0 <lapicinit>
  mpmain();
80103345:	e8 a6 ff ff ff       	call   801032f0 <mpmain>
8010334a:	66 90                	xchg   %ax,%ax
8010334c:	66 90                	xchg   %ax,%ax
8010334e:	66 90                	xchg   %ax,%ax

80103350 <main>:
{
80103350:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103354:	83 e4 f0             	and    $0xfffffff0,%esp
80103357:	ff 71 fc             	pushl  -0x4(%ecx)
8010335a:	55                   	push   %ebp
8010335b:	89 e5                	mov    %esp,%ebp
8010335d:	53                   	push   %ebx
8010335e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010335f:	83 ec 08             	sub    $0x8,%esp
80103362:	68 00 00 40 80       	push   $0x80400000
80103367:	68 28 1a 13 80       	push   $0x80131a28
8010336c:	e8 0f f5 ff ff       	call   80102880 <kinit1>
  kvmalloc();      // kernel page table
80103371:	e8 9a 40 00 00       	call   80107410 <kvmalloc>
  mpinit();        // detect other processors
80103376:	e8 75 01 00 00       	call   801034f0 <mpinit>
  lapicinit();     // interrupt controller
8010337b:	e8 60 f7 ff ff       	call   80102ae0 <lapicinit>
  init_cow();
80103380:	e8 bb f3 ff ff       	call   80102740 <init_cow>
  seginit();       // segment descriptors
80103385:	e8 06 3b 00 00       	call   80106e90 <seginit>
  picinit();       // disable pic
8010338a:	e8 41 03 00 00       	call   801036d0 <picinit>
  ioapicinit();    // another interrupt controller
8010338f:	e8 bc f2 ff ff       	call   80102650 <ioapicinit>
  consoleinit();   // console hardware
80103394:	e8 27 d6 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103399:	e8 82 2c 00 00       	call   80106020 <uartinit>
  pinit();         // process table
8010339e:	e8 2d 08 00 00       	call   80103bd0 <pinit>
  tvinit();        // trap vectors
801033a3:	e8 18 28 00 00       	call   80105bc0 <tvinit>
  binit();         // buffer cache
801033a8:	e8 93 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
801033ad:	e8 4e da ff ff       	call   80100e00 <fileinit>
  ideinit();       // disk 
801033b2:	e8 79 f0 ff ff       	call   80102430 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801033b7:	83 c4 0c             	add    $0xc,%esp
801033ba:	68 8a 00 00 00       	push   $0x8a
801033bf:	68 8c b4 10 80       	push   $0x8010b48c
801033c4:	68 00 70 00 80       	push   $0x80007000
801033c9:	e8 52 16 00 00       	call   80104a20 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801033ce:	69 05 80 1d 12 80 b0 	imul   $0xb0,0x80121d80,%eax
801033d5:	00 00 00 
801033d8:	83 c4 10             	add    $0x10,%esp
801033db:	05 00 18 12 80       	add    $0x80121800,%eax
801033e0:	3d 00 18 12 80       	cmp    $0x80121800,%eax
801033e5:	76 6c                	jbe    80103453 <main+0x103>
801033e7:	bb 00 18 12 80       	mov    $0x80121800,%ebx
801033ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
801033f0:	e8 fb 07 00 00       	call   80103bf0 <mycpu>
801033f5:	39 d8                	cmp    %ebx,%eax
801033f7:	74 41                	je     8010343a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = cow_kalloc();
801033f9:	e8 32 38 00 00       	call   80106c30 <cow_kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801033fe:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103403:	c7 05 f8 6f 00 80 30 	movl   $0x80103330,0x80006ff8
8010340a:	33 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010340d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103414:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103417:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010341c:	0f b6 03             	movzbl (%ebx),%eax
8010341f:	83 ec 08             	sub    $0x8,%esp
80103422:	68 00 70 00 00       	push   $0x7000
80103427:	50                   	push   %eax
80103428:	e8 03 f8 ff ff       	call   80102c30 <lapicstartap>
8010342d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103430:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103436:	85 c0                	test   %eax,%eax
80103438:	74 f6                	je     80103430 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010343a:	69 05 80 1d 12 80 b0 	imul   $0xb0,0x80121d80,%eax
80103441:	00 00 00 
80103444:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010344a:	05 00 18 12 80       	add    $0x80121800,%eax
8010344f:	39 c3                	cmp    %eax,%ebx
80103451:	72 9d                	jb     801033f0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103453:	83 ec 08             	sub    $0x8,%esp
80103456:	68 00 00 00 8e       	push   $0x8e000000
8010345b:	68 00 00 40 80       	push   $0x80400000
80103460:	e8 9b f4 ff ff       	call   80102900 <kinit2>
  userinit();      // first user process
80103465:	e8 66 08 00 00       	call   80103cd0 <userinit>
  mpmain();        // finish this processor's setup
8010346a:	e8 81 fe ff ff       	call   801032f0 <mpmain>
8010346f:	90                   	nop

80103470 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	57                   	push   %edi
80103474:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103475:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010347b:	53                   	push   %ebx
  e = addr+len;
8010347c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010347f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103482:	39 de                	cmp    %ebx,%esi
80103484:	72 10                	jb     80103496 <mpsearch1+0x26>
80103486:	eb 50                	jmp    801034d8 <mpsearch1+0x68>
80103488:	90                   	nop
80103489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103490:	39 fb                	cmp    %edi,%ebx
80103492:	89 fe                	mov    %edi,%esi
80103494:	76 42                	jbe    801034d8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103496:	83 ec 04             	sub    $0x4,%esp
80103499:	8d 7e 10             	lea    0x10(%esi),%edi
8010349c:	6a 04                	push   $0x4
8010349e:	68 f8 7c 10 80       	push   $0x80107cf8
801034a3:	56                   	push   %esi
801034a4:	e8 17 15 00 00       	call   801049c0 <memcmp>
801034a9:	83 c4 10             	add    $0x10,%esp
801034ac:	85 c0                	test   %eax,%eax
801034ae:	75 e0                	jne    80103490 <mpsearch1+0x20>
801034b0:	89 f1                	mov    %esi,%ecx
801034b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801034b8:	0f b6 11             	movzbl (%ecx),%edx
801034bb:	83 c1 01             	add    $0x1,%ecx
801034be:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801034c0:	39 f9                	cmp    %edi,%ecx
801034c2:	75 f4                	jne    801034b8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034c4:	84 c0                	test   %al,%al
801034c6:	75 c8                	jne    80103490 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801034c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034cb:	89 f0                	mov    %esi,%eax
801034cd:	5b                   	pop    %ebx
801034ce:	5e                   	pop    %esi
801034cf:	5f                   	pop    %edi
801034d0:	5d                   	pop    %ebp
801034d1:	c3                   	ret    
801034d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034db:	31 f6                	xor    %esi,%esi
}
801034dd:	89 f0                	mov    %esi,%eax
801034df:	5b                   	pop    %ebx
801034e0:	5e                   	pop    %esi
801034e1:	5f                   	pop    %edi
801034e2:	5d                   	pop    %ebp
801034e3:	c3                   	ret    
801034e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801034ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801034f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	57                   	push   %edi
801034f4:	56                   	push   %esi
801034f5:	53                   	push   %ebx
801034f6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801034f9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103500:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103507:	c1 e0 08             	shl    $0x8,%eax
8010350a:	09 d0                	or     %edx,%eax
8010350c:	c1 e0 04             	shl    $0x4,%eax
8010350f:	85 c0                	test   %eax,%eax
80103511:	75 1b                	jne    8010352e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103513:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010351a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103521:	c1 e0 08             	shl    $0x8,%eax
80103524:	09 d0                	or     %edx,%eax
80103526:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103529:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010352e:	ba 00 04 00 00       	mov    $0x400,%edx
80103533:	e8 38 ff ff ff       	call   80103470 <mpsearch1>
80103538:	85 c0                	test   %eax,%eax
8010353a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010353d:	0f 84 3d 01 00 00    	je     80103680 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103546:	8b 58 04             	mov    0x4(%eax),%ebx
80103549:	85 db                	test   %ebx,%ebx
8010354b:	0f 84 4f 01 00 00    	je     801036a0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103551:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103557:	83 ec 04             	sub    $0x4,%esp
8010355a:	6a 04                	push   $0x4
8010355c:	68 15 7d 10 80       	push   $0x80107d15
80103561:	56                   	push   %esi
80103562:	e8 59 14 00 00       	call   801049c0 <memcmp>
80103567:	83 c4 10             	add    $0x10,%esp
8010356a:	85 c0                	test   %eax,%eax
8010356c:	0f 85 2e 01 00 00    	jne    801036a0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103572:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103579:	3c 01                	cmp    $0x1,%al
8010357b:	0f 95 c2             	setne  %dl
8010357e:	3c 04                	cmp    $0x4,%al
80103580:	0f 95 c0             	setne  %al
80103583:	20 c2                	and    %al,%dl
80103585:	0f 85 15 01 00 00    	jne    801036a0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010358b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103592:	66 85 ff             	test   %di,%di
80103595:	74 1a                	je     801035b1 <mpinit+0xc1>
80103597:	89 f0                	mov    %esi,%eax
80103599:	01 f7                	add    %esi,%edi
  sum = 0;
8010359b:	31 d2                	xor    %edx,%edx
8010359d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801035a0:	0f b6 08             	movzbl (%eax),%ecx
801035a3:	83 c0 01             	add    $0x1,%eax
801035a6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801035a8:	39 c7                	cmp    %eax,%edi
801035aa:	75 f4                	jne    801035a0 <mpinit+0xb0>
801035ac:	84 d2                	test   %dl,%dl
801035ae:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801035b1:	85 f6                	test   %esi,%esi
801035b3:	0f 84 e7 00 00 00    	je     801036a0 <mpinit+0x1b0>
801035b9:	84 d2                	test   %dl,%dl
801035bb:	0f 85 df 00 00 00    	jne    801036a0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801035c1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801035c7:	a3 f4 16 12 80       	mov    %eax,0x801216f4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035cc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801035d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801035d9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035de:	01 d6                	add    %edx,%esi
801035e0:	39 c6                	cmp    %eax,%esi
801035e2:	76 23                	jbe    80103607 <mpinit+0x117>
    switch(*p){
801035e4:	0f b6 10             	movzbl (%eax),%edx
801035e7:	80 fa 04             	cmp    $0x4,%dl
801035ea:	0f 87 ca 00 00 00    	ja     801036ba <mpinit+0x1ca>
801035f0:	ff 24 95 3c 7d 10 80 	jmp    *-0x7fef82c4(,%edx,4)
801035f7:	89 f6                	mov    %esi,%esi
801035f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103600:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103603:	39 c6                	cmp    %eax,%esi
80103605:	77 dd                	ja     801035e4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103607:	85 db                	test   %ebx,%ebx
80103609:	0f 84 9e 00 00 00    	je     801036ad <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010360f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103612:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103616:	74 15                	je     8010362d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103618:	b8 70 00 00 00       	mov    $0x70,%eax
8010361d:	ba 22 00 00 00       	mov    $0x22,%edx
80103622:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103623:	ba 23 00 00 00       	mov    $0x23,%edx
80103628:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103629:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010362c:	ee                   	out    %al,(%dx)
  }
}
8010362d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103630:	5b                   	pop    %ebx
80103631:	5e                   	pop    %esi
80103632:	5f                   	pop    %edi
80103633:	5d                   	pop    %ebp
80103634:	c3                   	ret    
80103635:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103638:	8b 0d 80 1d 12 80    	mov    0x80121d80,%ecx
8010363e:	83 f9 07             	cmp    $0x7,%ecx
80103641:	7f 19                	jg     8010365c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103643:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103647:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010364d:	83 c1 01             	add    $0x1,%ecx
80103650:	89 0d 80 1d 12 80    	mov    %ecx,0x80121d80
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103656:	88 97 00 18 12 80    	mov    %dl,-0x7fede800(%edi)
      p += sizeof(struct mpproc);
8010365c:	83 c0 14             	add    $0x14,%eax
      continue;
8010365f:	e9 7c ff ff ff       	jmp    801035e0 <mpinit+0xf0>
80103664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103668:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010366c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010366f:	88 15 e0 17 12 80    	mov    %dl,0x801217e0
      continue;
80103675:	e9 66 ff ff ff       	jmp    801035e0 <mpinit+0xf0>
8010367a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103680:	ba 00 00 01 00       	mov    $0x10000,%edx
80103685:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010368a:	e8 e1 fd ff ff       	call   80103470 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010368f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103691:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103694:	0f 85 a9 fe ff ff    	jne    80103543 <mpinit+0x53>
8010369a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801036a0:	83 ec 0c             	sub    $0xc,%esp
801036a3:	68 fd 7c 10 80       	push   $0x80107cfd
801036a8:	e8 e3 cc ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801036ad:	83 ec 0c             	sub    $0xc,%esp
801036b0:	68 1c 7d 10 80       	push   $0x80107d1c
801036b5:	e8 d6 cc ff ff       	call   80100390 <panic>
      ismp = 0;
801036ba:	31 db                	xor    %ebx,%ebx
801036bc:	e9 26 ff ff ff       	jmp    801035e7 <mpinit+0xf7>
801036c1:	66 90                	xchg   %ax,%ax
801036c3:	66 90                	xchg   %ax,%ax
801036c5:	66 90                	xchg   %ax,%ax
801036c7:	66 90                	xchg   %ax,%ax
801036c9:	66 90                	xchg   %ax,%ax
801036cb:	66 90                	xchg   %ax,%ax
801036cd:	66 90                	xchg   %ax,%ax
801036cf:	90                   	nop

801036d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801036d0:	55                   	push   %ebp
801036d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801036d6:	ba 21 00 00 00       	mov    $0x21,%edx
801036db:	89 e5                	mov    %esp,%ebp
801036dd:	ee                   	out    %al,(%dx)
801036de:	ba a1 00 00 00       	mov    $0xa1,%edx
801036e3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801036e4:	5d                   	pop    %ebp
801036e5:	c3                   	ret    
801036e6:	66 90                	xchg   %ax,%ax
801036e8:	66 90                	xchg   %ax,%ax
801036ea:	66 90                	xchg   %ax,%ax
801036ec:	66 90                	xchg   %ax,%ax
801036ee:	66 90                	xchg   %ax,%ax

801036f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	57                   	push   %edi
801036f4:	56                   	push   %esi
801036f5:	53                   	push   %ebx
801036f6:	83 ec 0c             	sub    $0xc,%esp
801036f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801036ff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103705:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010370b:	e8 10 d7 ff ff       	call   80100e20 <filealloc>
80103710:	85 c0                	test   %eax,%eax
80103712:	89 03                	mov    %eax,(%ebx)
80103714:	74 22                	je     80103738 <pipealloc+0x48>
80103716:	e8 05 d7 ff ff       	call   80100e20 <filealloc>
8010371b:	85 c0                	test   %eax,%eax
8010371d:	89 06                	mov    %eax,(%esi)
8010371f:	74 3f                	je     80103760 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)cow_kalloc()) == 0)
80103721:	e8 0a 35 00 00       	call   80106c30 <cow_kalloc>
80103726:	85 c0                	test   %eax,%eax
80103728:	89 c7                	mov    %eax,%edi
8010372a:	75 54                	jne    80103780 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    cow_kfree((char*)p);
  if(*f0)
8010372c:	8b 03                	mov    (%ebx),%eax
8010372e:	85 c0                	test   %eax,%eax
80103730:	75 34                	jne    80103766 <pipealloc+0x76>
80103732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103738:	8b 06                	mov    (%esi),%eax
8010373a:	85 c0                	test   %eax,%eax
8010373c:	74 0c                	je     8010374a <pipealloc+0x5a>
    fileclose(*f1);
8010373e:	83 ec 0c             	sub    $0xc,%esp
80103741:	50                   	push   %eax
80103742:	e8 99 d7 ff ff       	call   80100ee0 <fileclose>
80103747:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010374a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010374d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103752:	5b                   	pop    %ebx
80103753:	5e                   	pop    %esi
80103754:	5f                   	pop    %edi
80103755:	5d                   	pop    %ebp
80103756:	c3                   	ret    
80103757:	89 f6                	mov    %esi,%esi
80103759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103760:	8b 03                	mov    (%ebx),%eax
80103762:	85 c0                	test   %eax,%eax
80103764:	74 e4                	je     8010374a <pipealloc+0x5a>
    fileclose(*f0);
80103766:	83 ec 0c             	sub    $0xc,%esp
80103769:	50                   	push   %eax
8010376a:	e8 71 d7 ff ff       	call   80100ee0 <fileclose>
  if(*f1)
8010376f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103771:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103774:	85 c0                	test   %eax,%eax
80103776:	75 c6                	jne    8010373e <pipealloc+0x4e>
80103778:	eb d0                	jmp    8010374a <pipealloc+0x5a>
8010377a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103780:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103783:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010378a:	00 00 00 
  p->writeopen = 1;
8010378d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103794:	00 00 00 
  p->nwrite = 0;
80103797:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010379e:	00 00 00 
  p->nread = 0;
801037a1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801037a8:	00 00 00 
  initlock(&p->lock, "pipe");
801037ab:	68 50 7d 10 80       	push   $0x80107d50
801037b0:	50                   	push   %eax
801037b1:	e8 6a 0f 00 00       	call   80104720 <initlock>
  (*f0)->type = FD_PIPE;
801037b6:	8b 03                	mov    (%ebx),%eax
  return 0;
801037b8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801037bb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801037c1:	8b 03                	mov    (%ebx),%eax
801037c3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801037c7:	8b 03                	mov    (%ebx),%eax
801037c9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801037cd:	8b 03                	mov    (%ebx),%eax
801037cf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801037d2:	8b 06                	mov    (%esi),%eax
801037d4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801037da:	8b 06                	mov    (%esi),%eax
801037dc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801037e0:	8b 06                	mov    (%esi),%eax
801037e2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801037e6:	8b 06                	mov    (%esi),%eax
801037e8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801037eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801037ee:	31 c0                	xor    %eax,%eax
}
801037f0:	5b                   	pop    %ebx
801037f1:	5e                   	pop    %esi
801037f2:	5f                   	pop    %edi
801037f3:	5d                   	pop    %ebp
801037f4:	c3                   	ret    
801037f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103800 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
80103805:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103808:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010380b:	83 ec 0c             	sub    $0xc,%esp
8010380e:	53                   	push   %ebx
8010380f:	e8 4c 10 00 00       	call   80104860 <acquire>
  if(writable){
80103814:	83 c4 10             	add    $0x10,%esp
80103817:	85 f6                	test   %esi,%esi
80103819:	74 45                	je     80103860 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010381b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103821:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103824:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010382b:	00 00 00 
    wakeup(&p->nread);
8010382e:	50                   	push   %eax
8010382f:	e8 0c 0c 00 00       	call   80104440 <wakeup>
80103834:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103837:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010383d:	85 d2                	test   %edx,%edx
8010383f:	75 0a                	jne    8010384b <pipeclose+0x4b>
80103841:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103847:	85 c0                	test   %eax,%eax
80103849:	74 35                	je     80103880 <pipeclose+0x80>
    release(&p->lock);
    cow_kfree((char*)p);
  } else
    release(&p->lock);
8010384b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010384e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103851:	5b                   	pop    %ebx
80103852:	5e                   	pop    %esi
80103853:	5d                   	pop    %ebp
    release(&p->lock);
80103854:	e9 c7 10 00 00       	jmp    80104920 <release>
80103859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103860:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103866:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103869:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103870:	00 00 00 
    wakeup(&p->nwrite);
80103873:	50                   	push   %eax
80103874:	e8 c7 0b 00 00       	call   80104440 <wakeup>
80103879:	83 c4 10             	add    $0x10,%esp
8010387c:	eb b9                	jmp    80103837 <pipeclose+0x37>
8010387e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
80103883:	53                   	push   %ebx
80103884:	e8 97 10 00 00       	call   80104920 <release>
    cow_kfree((char*)p);
80103889:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010388c:	83 c4 10             	add    $0x10,%esp
}
8010388f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103892:	5b                   	pop    %ebx
80103893:	5e                   	pop    %esi
80103894:	5d                   	pop    %ebp
    cow_kfree((char*)p);
80103895:	e9 06 33 00 00       	jmp    80106ba0 <cow_kfree>
8010389a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	57                   	push   %edi
801038a4:	56                   	push   %esi
801038a5:	53                   	push   %ebx
801038a6:	83 ec 28             	sub    $0x28,%esp
801038a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801038ac:	53                   	push   %ebx
801038ad:	e8 ae 0f 00 00       	call   80104860 <acquire>
  for(i = 0; i < n; i++){
801038b2:	8b 45 10             	mov    0x10(%ebp),%eax
801038b5:	83 c4 10             	add    $0x10,%esp
801038b8:	85 c0                	test   %eax,%eax
801038ba:	0f 8e c9 00 00 00    	jle    80103989 <pipewrite+0xe9>
801038c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801038c3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801038c9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801038cf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801038d2:	03 4d 10             	add    0x10(%ebp),%ecx
801038d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038d8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801038de:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801038e4:	39 d0                	cmp    %edx,%eax
801038e6:	75 71                	jne    80103959 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801038e8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801038ee:	85 c0                	test   %eax,%eax
801038f0:	74 4e                	je     80103940 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801038f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801038f8:	eb 3a                	jmp    80103934 <pipewrite+0x94>
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103900:	83 ec 0c             	sub    $0xc,%esp
80103903:	57                   	push   %edi
80103904:	e8 37 0b 00 00       	call   80104440 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103909:	5a                   	pop    %edx
8010390a:	59                   	pop    %ecx
8010390b:	53                   	push   %ebx
8010390c:	56                   	push   %esi
8010390d:	e8 6e 09 00 00       	call   80104280 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103912:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103918:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010391e:	83 c4 10             	add    $0x10,%esp
80103921:	05 00 02 00 00       	add    $0x200,%eax
80103926:	39 c2                	cmp    %eax,%edx
80103928:	75 36                	jne    80103960 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010392a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103930:	85 c0                	test   %eax,%eax
80103932:	74 0c                	je     80103940 <pipewrite+0xa0>
80103934:	e8 67 03 00 00       	call   80103ca0 <myproc>
80103939:	8b 40 24             	mov    0x24(%eax),%eax
8010393c:	85 c0                	test   %eax,%eax
8010393e:	74 c0                	je     80103900 <pipewrite+0x60>
        release(&p->lock);
80103940:	83 ec 0c             	sub    $0xc,%esp
80103943:	53                   	push   %ebx
80103944:	e8 d7 0f 00 00       	call   80104920 <release>
        return -1;
80103949:	83 c4 10             	add    $0x10,%esp
8010394c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103951:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103954:	5b                   	pop    %ebx
80103955:	5e                   	pop    %esi
80103956:	5f                   	pop    %edi
80103957:	5d                   	pop    %ebp
80103958:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103959:	89 c2                	mov    %eax,%edx
8010395b:	90                   	nop
8010395c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103960:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103963:	8d 42 01             	lea    0x1(%edx),%eax
80103966:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010396c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103972:	83 c6 01             	add    $0x1,%esi
80103975:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103979:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010397c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010397f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103983:	0f 85 4f ff ff ff    	jne    801038d8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103989:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010398f:	83 ec 0c             	sub    $0xc,%esp
80103992:	50                   	push   %eax
80103993:	e8 a8 0a 00 00       	call   80104440 <wakeup>
  release(&p->lock);
80103998:	89 1c 24             	mov    %ebx,(%esp)
8010399b:	e8 80 0f 00 00       	call   80104920 <release>
  return n;
801039a0:	83 c4 10             	add    $0x10,%esp
801039a3:	8b 45 10             	mov    0x10(%ebp),%eax
801039a6:	eb a9                	jmp    80103951 <pipewrite+0xb1>
801039a8:	90                   	nop
801039a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	57                   	push   %edi
801039b4:	56                   	push   %esi
801039b5:	53                   	push   %ebx
801039b6:	83 ec 18             	sub    $0x18,%esp
801039b9:	8b 75 08             	mov    0x8(%ebp),%esi
801039bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801039bf:	56                   	push   %esi
801039c0:	e8 9b 0e 00 00       	call   80104860 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801039c5:	83 c4 10             	add    $0x10,%esp
801039c8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801039ce:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801039d4:	75 6a                	jne    80103a40 <piperead+0x90>
801039d6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801039dc:	85 db                	test   %ebx,%ebx
801039de:	0f 84 c4 00 00 00    	je     80103aa8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801039e4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801039ea:	eb 2d                	jmp    80103a19 <piperead+0x69>
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039f0:	83 ec 08             	sub    $0x8,%esp
801039f3:	56                   	push   %esi
801039f4:	53                   	push   %ebx
801039f5:	e8 86 08 00 00       	call   80104280 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801039fa:	83 c4 10             	add    $0x10,%esp
801039fd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a03:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a09:	75 35                	jne    80103a40 <piperead+0x90>
80103a0b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103a11:	85 d2                	test   %edx,%edx
80103a13:	0f 84 8f 00 00 00    	je     80103aa8 <piperead+0xf8>
    if(myproc()->killed){
80103a19:	e8 82 02 00 00       	call   80103ca0 <myproc>
80103a1e:	8b 48 24             	mov    0x24(%eax),%ecx
80103a21:	85 c9                	test   %ecx,%ecx
80103a23:	74 cb                	je     801039f0 <piperead+0x40>
      release(&p->lock);
80103a25:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103a28:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103a2d:	56                   	push   %esi
80103a2e:	e8 ed 0e 00 00       	call   80104920 <release>
      return -1;
80103a33:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103a36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a39:	89 d8                	mov    %ebx,%eax
80103a3b:	5b                   	pop    %ebx
80103a3c:	5e                   	pop    %esi
80103a3d:	5f                   	pop    %edi
80103a3e:	5d                   	pop    %ebp
80103a3f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a40:	8b 45 10             	mov    0x10(%ebp),%eax
80103a43:	85 c0                	test   %eax,%eax
80103a45:	7e 61                	jle    80103aa8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103a47:	31 db                	xor    %ebx,%ebx
80103a49:	eb 13                	jmp    80103a5e <piperead+0xae>
80103a4b:	90                   	nop
80103a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a50:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a56:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a5c:	74 1f                	je     80103a7d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103a5e:	8d 41 01             	lea    0x1(%ecx),%eax
80103a61:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103a67:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103a6d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103a72:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a75:	83 c3 01             	add    $0x1,%ebx
80103a78:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103a7b:	75 d3                	jne    80103a50 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103a7d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103a83:	83 ec 0c             	sub    $0xc,%esp
80103a86:	50                   	push   %eax
80103a87:	e8 b4 09 00 00       	call   80104440 <wakeup>
  release(&p->lock);
80103a8c:	89 34 24             	mov    %esi,(%esp)
80103a8f:	e8 8c 0e 00 00       	call   80104920 <release>
  return i;
80103a94:	83 c4 10             	add    $0x10,%esp
}
80103a97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a9a:	89 d8                	mov    %ebx,%eax
80103a9c:	5b                   	pop    %ebx
80103a9d:	5e                   	pop    %esi
80103a9e:	5f                   	pop    %edi
80103a9f:	5d                   	pop    %ebp
80103aa0:	c3                   	ret    
80103aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aa8:	31 db                	xor    %ebx,%ebx
80103aaa:	eb d1                	jmp    80103a7d <piperead+0xcd>
80103aac:	66 90                	xchg   %ax,%ax
80103aae:	66 90                	xchg   %ax,%ax

80103ab0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ab4:	bb d4 1d 12 80       	mov    $0x80121dd4,%ebx
{
80103ab9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103abc:	68 a0 1d 12 80       	push   $0x80121da0
80103ac1:	e8 9a 0d 00 00       	call   80104860 <acquire>
80103ac6:	83 c4 10             	add    $0x10,%esp
80103ac9:	eb 13                	jmp    80103ade <allocproc+0x2e>
80103acb:	90                   	nop
80103acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ad0:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
80103ad6:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
80103adc:	73 7a                	jae    80103b58 <allocproc+0xa8>
    if(p->state == UNUSED)
80103ade:	8b 43 0c             	mov    0xc(%ebx),%eax
80103ae1:	85 c0                	test   %eax,%eax
80103ae3:	75 eb                	jne    80103ad0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103ae5:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103aea:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103aed:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103af4:	8d 50 01             	lea    0x1(%eax),%edx
80103af7:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103afa:	68 a0 1d 12 80       	push   $0x80121da0
  p->pid = nextpid++;
80103aff:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103b05:	e8 16 0e 00 00       	call   80104920 <release>

  // Allocate kernel stack.
  if((p->kstack = cow_kalloc()) == 0){
80103b0a:	e8 21 31 00 00       	call   80106c30 <cow_kalloc>
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	85 c0                	test   %eax,%eax
80103b14:	89 43 08             	mov    %eax,0x8(%ebx)
80103b17:	74 58                	je     80103b71 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103b19:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103b1f:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103b22:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103b27:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103b2a:	c7 40 14 b1 5b 10 80 	movl   $0x80105bb1,0x14(%eax)
  p->context = (struct context*)sp;
80103b31:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103b34:	6a 14                	push   $0x14
80103b36:	6a 00                	push   $0x0
80103b38:	50                   	push   %eax
80103b39:	e8 32 0e 00 00       	call   80104970 <memset>
  p->context->eip = (uint)forkret;
80103b3e:	8b 43 1c             	mov    0x1c(%ebx),%eax
      p->advance_queue[i] = -1;
      #endif
    }
 }
 #endif
  return p;
80103b41:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103b44:	c7 40 10 80 3b 10 80 	movl   $0x80103b80,0x10(%eax)
}
80103b4b:	89 d8                	mov    %ebx,%eax
80103b4d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b50:	c9                   	leave  
80103b51:	c3                   	ret    
80103b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103b58:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103b5b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103b5d:	68 a0 1d 12 80       	push   $0x80121da0
80103b62:	e8 b9 0d 00 00       	call   80104920 <release>
}
80103b67:	89 d8                	mov    %ebx,%eax
  return 0;
80103b69:	83 c4 10             	add    $0x10,%esp
}
80103b6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b6f:	c9                   	leave  
80103b70:	c3                   	ret    
    p->state = UNUSED;
80103b71:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103b78:	31 db                	xor    %ebx,%ebx
80103b7a:	eb cf                	jmp    80103b4b <allocproc+0x9b>
80103b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103b86:	68 a0 1d 12 80       	push   $0x80121da0
80103b8b:	e8 90 0d 00 00       	call   80104920 <release>

  if (first) {
80103b90:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103b95:	83 c4 10             	add    $0x10,%esp
80103b98:	85 c0                	test   %eax,%eax
80103b9a:	75 04                	jne    80103ba0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103b9c:	c9                   	leave  
80103b9d:	c3                   	ret    
80103b9e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103ba0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103ba3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103baa:	00 00 00 
    iinit(ROOTDEV);
80103bad:	6a 01                	push   $0x1
80103baf:	e8 6c d9 ff ff       	call   80101520 <iinit>
    initlog(ROOTDEV);
80103bb4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103bbb:	e8 f0 f3 ff ff       	call   80102fb0 <initlog>
80103bc0:	83 c4 10             	add    $0x10,%esp
}
80103bc3:	c9                   	leave  
80103bc4:	c3                   	ret    
80103bc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bd0 <pinit>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103bd6:	68 55 7d 10 80       	push   $0x80107d55
80103bdb:	68 a0 1d 12 80       	push   $0x80121da0
80103be0:	e8 3b 0b 00 00       	call   80104720 <initlock>
}
80103be5:	83 c4 10             	add    $0x10,%esp
80103be8:	c9                   	leave  
80103be9:	c3                   	ret    
80103bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bf0 <mycpu>:
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	56                   	push   %esi
80103bf4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bf5:	9c                   	pushf  
80103bf6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103bf7:	f6 c4 02             	test   $0x2,%ah
80103bfa:	75 6b                	jne    80103c67 <mycpu+0x77>
  apicid = lapicid();
80103bfc:	e8 df ef ff ff       	call   80102be0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103c01:	8b 35 80 1d 12 80    	mov    0x80121d80,%esi
80103c07:	85 f6                	test   %esi,%esi
80103c09:	7e 42                	jle    80103c4d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103c0b:	0f b6 15 00 18 12 80 	movzbl 0x80121800,%edx
80103c12:	39 d0                	cmp    %edx,%eax
80103c14:	74 30                	je     80103c46 <mycpu+0x56>
80103c16:	b9 b0 18 12 80       	mov    $0x801218b0,%ecx
  for (i = 0; i < ncpu; ++i) {
80103c1b:	31 d2                	xor    %edx,%edx
80103c1d:	8d 76 00             	lea    0x0(%esi),%esi
80103c20:	83 c2 01             	add    $0x1,%edx
80103c23:	39 f2                	cmp    %esi,%edx
80103c25:	74 26                	je     80103c4d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103c27:	0f b6 19             	movzbl (%ecx),%ebx
80103c2a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103c30:	39 c3                	cmp    %eax,%ebx
80103c32:	75 ec                	jne    80103c20 <mycpu+0x30>
80103c34:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103c3a:	05 00 18 12 80       	add    $0x80121800,%eax
}
80103c3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c42:	5b                   	pop    %ebx
80103c43:	5e                   	pop    %esi
80103c44:	5d                   	pop    %ebp
80103c45:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103c46:	b8 00 18 12 80       	mov    $0x80121800,%eax
      return &cpus[i];
80103c4b:	eb f2                	jmp    80103c3f <mycpu+0x4f>
  cprintf("The unknown apicid is %d\n", apicid);
80103c4d:	83 ec 08             	sub    $0x8,%esp
80103c50:	50                   	push   %eax
80103c51:	68 5c 7d 10 80       	push   $0x80107d5c
80103c56:	e8 05 ca ff ff       	call   80100660 <cprintf>
  panic("unknown apicid\n");
80103c5b:	c7 04 24 76 7d 10 80 	movl   $0x80107d76,(%esp)
80103c62:	e8 29 c7 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103c67:	83 ec 0c             	sub    $0xc,%esp
80103c6a:	68 54 7e 10 80       	push   $0x80107e54
80103c6f:	e8 1c c7 ff ff       	call   80100390 <panic>
80103c74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c80 <cpuid>:
cpuid() {
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c86:	e8 65 ff ff ff       	call   80103bf0 <mycpu>
80103c8b:	2d 00 18 12 80       	sub    $0x80121800,%eax
}
80103c90:	c9                   	leave  
  return mycpu()-cpus;
80103c91:	c1 f8 04             	sar    $0x4,%eax
80103c94:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c9a:	c3                   	ret    
80103c9b:	90                   	nop
80103c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ca0 <myproc>:
myproc(void) {
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	53                   	push   %ebx
80103ca4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ca7:	e8 e4 0a 00 00       	call   80104790 <pushcli>
  c = mycpu();
80103cac:	e8 3f ff ff ff       	call   80103bf0 <mycpu>
  p = c->proc;
80103cb1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cb7:	e8 14 0b 00 00       	call   801047d0 <popcli>
}
80103cbc:	83 c4 04             	add    $0x4,%esp
80103cbf:	89 d8                	mov    %ebx,%eax
80103cc1:	5b                   	pop    %ebx
80103cc2:	5d                   	pop    %ebp
80103cc3:	c3                   	ret    
80103cc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103cca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103cd0 <userinit>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	53                   	push   %ebx
80103cd4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103cd7:	e8 d4 fd ff ff       	call   80103ab0 <allocproc>
80103cdc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103cde:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103ce3:	e8 a8 36 00 00       	call   80107390 <setupkvm>
80103ce8:	85 c0                	test   %eax,%eax
80103cea:	89 43 04             	mov    %eax,0x4(%ebx)
80103ced:	0f 84 bd 00 00 00    	je     80103db0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103cf3:	83 ec 04             	sub    $0x4,%esp
80103cf6:	68 2c 00 00 00       	push   $0x2c
80103cfb:	68 60 b4 10 80       	push   $0x8010b460
80103d00:	50                   	push   %eax
80103d01:	e8 6a 33 00 00       	call   80107070 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103d06:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103d09:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103d0f:	6a 4c                	push   $0x4c
80103d11:	6a 00                	push   $0x0
80103d13:	ff 73 18             	pushl  0x18(%ebx)
80103d16:	e8 55 0c 00 00       	call   80104970 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d1b:	8b 43 18             	mov    0x18(%ebx),%eax
80103d1e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d23:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d28:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d2b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d2f:	8b 43 18             	mov    0x18(%ebx),%eax
80103d32:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103d36:	8b 43 18             	mov    0x18(%ebx),%eax
80103d39:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d3d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d41:	8b 43 18             	mov    0x18(%ebx),%eax
80103d44:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d48:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d4c:	8b 43 18             	mov    0x18(%ebx),%eax
80103d4f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d56:	8b 43 18             	mov    0x18(%ebx),%eax
80103d59:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d60:	8b 43 18             	mov    0x18(%ebx),%eax
80103d63:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d6a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d6d:	6a 10                	push   $0x10
80103d6f:	68 9f 7d 10 80       	push   $0x80107d9f
80103d74:	50                   	push   %eax
80103d75:	e8 d6 0d 00 00       	call   80104b50 <safestrcpy>
  p->cwd = namei("/");
80103d7a:	c7 04 24 a8 7d 10 80 	movl   $0x80107da8,(%esp)
80103d81:	e8 fa e1 ff ff       	call   80101f80 <namei>
80103d86:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103d89:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
80103d90:	e8 cb 0a 00 00       	call   80104860 <acquire>
  p->state = RUNNABLE;
80103d95:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103d9c:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
80103da3:	e8 78 0b 00 00       	call   80104920 <release>
}
80103da8:	83 c4 10             	add    $0x10,%esp
80103dab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dae:	c9                   	leave  
80103daf:	c3                   	ret    
    panic("userinit: out of memory?");
80103db0:	83 ec 0c             	sub    $0xc,%esp
80103db3:	68 86 7d 10 80       	push   $0x80107d86
80103db8:	e8 d3 c5 ff ff       	call   80100390 <panic>
80103dbd:	8d 76 00             	lea    0x0(%esi),%esi

80103dc0 <growproc>:
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	56                   	push   %esi
80103dc4:	53                   	push   %ebx
80103dc5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103dc8:	e8 c3 09 00 00       	call   80104790 <pushcli>
  c = mycpu();
80103dcd:	e8 1e fe ff ff       	call   80103bf0 <mycpu>
  p = c->proc;
80103dd2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dd8:	e8 f3 09 00 00       	call   801047d0 <popcli>
  if(n > 0){
80103ddd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103de0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103de2:	7f 1c                	jg     80103e00 <growproc+0x40>
  } else if(n < 0){
80103de4:	75 3a                	jne    80103e20 <growproc+0x60>
  switchuvm(curproc);
80103de6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103de9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103deb:	53                   	push   %ebx
80103dec:	e8 6f 31 00 00       	call   80106f60 <switchuvm>
  return 0;
80103df1:	83 c4 10             	add    $0x10,%esp
80103df4:	31 c0                	xor    %eax,%eax
}
80103df6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103df9:	5b                   	pop    %ebx
80103dfa:	5e                   	pop    %esi
80103dfb:	5d                   	pop    %ebp
80103dfc:	c3                   	ret    
80103dfd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e00:	83 ec 04             	sub    $0x4,%esp
80103e03:	01 c6                	add    %eax,%esi
80103e05:	56                   	push   %esi
80103e06:	50                   	push   %eax
80103e07:	ff 73 04             	pushl  0x4(%ebx)
80103e0a:	e8 a1 33 00 00       	call   801071b0 <allocuvm>
80103e0f:	83 c4 10             	add    $0x10,%esp
80103e12:	85 c0                	test   %eax,%eax
80103e14:	75 d0                	jne    80103de6 <growproc+0x26>
      return -1;
80103e16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e1b:	eb d9                	jmp    80103df6 <growproc+0x36>
80103e1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e20:	83 ec 04             	sub    $0x4,%esp
80103e23:	01 c6                	add    %eax,%esi
80103e25:	56                   	push   %esi
80103e26:	50                   	push   %eax
80103e27:	ff 73 04             	pushl  0x4(%ebx)
80103e2a:	e8 b1 34 00 00       	call   801072e0 <deallocuvm>
80103e2f:	83 c4 10             	add    $0x10,%esp
80103e32:	85 c0                	test   %eax,%eax
80103e34:	75 b0                	jne    80103de6 <growproc+0x26>
80103e36:	eb de                	jmp    80103e16 <growproc+0x56>
80103e38:	90                   	nop
80103e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e40 <sys_get_number_of_free_pages_impl>:
int sys_get_number_of_free_pages_impl(void){
80103e40:	55                   	push   %ebp
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80103e41:	31 c0                	xor    %eax,%eax
  int count = 0;
80103e43:	31 d2                	xor    %edx,%edx
int sys_get_number_of_free_pages_impl(void){
80103e45:	89 e5                	mov    %esp,%ebp
80103e47:	89 f6                	mov    %esi,%esi
80103e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      count++;
80103e50:	80 b8 40 0f 11 80 01 	cmpb   $0x1,-0x7feef0c0(%eax)
80103e57:	83 da ff             	sbb    $0xffffffff,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80103e5a:	83 c0 01             	add    $0x1,%eax
80103e5d:	3d 00 e0 00 00       	cmp    $0xe000,%eax
80103e62:	75 ec                	jne    80103e50 <sys_get_number_of_free_pages_impl+0x10>
  return (PHYSTOP/PGSIZE) - count;
80103e64:	29 d0                	sub    %edx,%eax
}
80103e66:	5d                   	pop    %ebp
80103e67:	c3                   	ret    
80103e68:	90                   	nop
80103e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e70 <fork>:
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	57                   	push   %edi
80103e74:	56                   	push   %esi
80103e75:	53                   	push   %ebx
80103e76:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103e79:	e8 12 09 00 00       	call   80104790 <pushcli>
  c = mycpu();
80103e7e:	e8 6d fd ff ff       	call   80103bf0 <mycpu>
  p = c->proc;
80103e83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e89:	e8 42 09 00 00       	call   801047d0 <popcli>
  if((np = allocproc()) == 0){
80103e8e:	e8 1d fc ff ff       	call   80103ab0 <allocproc>
80103e93:	85 c0                	test   %eax,%eax
80103e95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e98:	0f 84 b7 00 00 00    	je     80103f55 <fork+0xe5>
  if((np->pgdir = cow_copyuvm(curproc->pgdir, curproc->sz)) == 0){ // (np->pid > 2 ? cow_copyuvm : copyuvm)
80103e9e:	83 ec 08             	sub    $0x8,%esp
80103ea1:	ff 33                	pushl  (%ebx)
80103ea3:	ff 73 04             	pushl  0x4(%ebx)
80103ea6:	89 c7                	mov    %eax,%edi
80103ea8:	e8 b3 35 00 00       	call   80107460 <cow_copyuvm>
80103ead:	83 c4 10             	add    $0x10,%esp
80103eb0:	85 c0                	test   %eax,%eax
80103eb2:	89 47 04             	mov    %eax,0x4(%edi)
80103eb5:	0f 84 a1 00 00 00    	je     80103f5c <fork+0xec>
  np->sz = curproc->sz;
80103ebb:	8b 03                	mov    (%ebx),%eax
80103ebd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ec0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103ec2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103ec5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103ec7:	8b 79 18             	mov    0x18(%ecx),%edi
80103eca:	8b 73 18             	mov    0x18(%ebx),%esi
80103ecd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103ed2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ed4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ed6:	8b 40 18             	mov    0x18(%eax),%eax
80103ed9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ee0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ee4:	85 c0                	test   %eax,%eax
80103ee6:	74 13                	je     80103efb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ee8:	83 ec 0c             	sub    $0xc,%esp
80103eeb:	50                   	push   %eax
80103eec:	e8 9f cf ff ff       	call   80100e90 <filedup>
80103ef1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ef4:	83 c4 10             	add    $0x10,%esp
80103ef7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103efb:	83 c6 01             	add    $0x1,%esi
80103efe:	83 fe 10             	cmp    $0x10,%esi
80103f01:	75 dd                	jne    80103ee0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103f03:	83 ec 0c             	sub    $0xc,%esp
80103f06:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f09:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103f0c:	e8 df d7 ff ff       	call   801016f0 <idup>
80103f11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f14:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103f17:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f1a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f1d:	6a 10                	push   $0x10
80103f1f:	53                   	push   %ebx
80103f20:	50                   	push   %eax
80103f21:	e8 2a 0c 00 00       	call   80104b50 <safestrcpy>
  pid = np->pid;
80103f26:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103f29:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
80103f30:	e8 2b 09 00 00       	call   80104860 <acquire>
  np->state = RUNNABLE;
80103f35:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103f3c:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
80103f43:	e8 d8 09 00 00       	call   80104920 <release>
  return pid;
80103f48:	83 c4 10             	add    $0x10,%esp
}
80103f4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f4e:	89 d8                	mov    %ebx,%eax
80103f50:	5b                   	pop    %ebx
80103f51:	5e                   	pop    %esi
80103f52:	5f                   	pop    %edi
80103f53:	5d                   	pop    %ebp
80103f54:	c3                   	ret    
    return -1;
80103f55:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f5a:	eb ef                	jmp    80103f4b <fork+0xdb>
    cow_kfree(np->kstack);
80103f5c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103f5f:	83 ec 0c             	sub    $0xc,%esp
80103f62:	ff 73 08             	pushl  0x8(%ebx)
80103f65:	e8 36 2c 00 00       	call   80106ba0 <cow_kfree>
    np->kstack = 0;
80103f6a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103f71:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103f78:	83 c4 10             	add    $0x10,%esp
80103f7b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f80:	eb c9                	jmp    80103f4b <fork+0xdb>
80103f82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f90 <scheduler>:
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	57                   	push   %edi
80103f94:	56                   	push   %esi
80103f95:	53                   	push   %ebx
80103f96:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103f99:	e8 52 fc ff ff       	call   80103bf0 <mycpu>
80103f9e:	8d 78 04             	lea    0x4(%eax),%edi
80103fa1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103fa3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103faa:	00 00 00 
80103fad:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103fb0:	fb                   	sti    
    acquire(&ptable.lock);
80103fb1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fb4:	bb d4 1d 12 80       	mov    $0x80121dd4,%ebx
    acquire(&ptable.lock);
80103fb9:	68 a0 1d 12 80       	push   $0x80121da0
80103fbe:	e8 9d 08 00 00       	call   80104860 <acquire>
80103fc3:	83 c4 10             	add    $0x10,%esp
80103fc6:	8d 76 00             	lea    0x0(%esi),%esi
80103fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103fd0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103fd4:	75 33                	jne    80104009 <scheduler+0x79>
      switchuvm(p);
80103fd6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103fd9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103fdf:	53                   	push   %ebx
80103fe0:	e8 7b 2f 00 00       	call   80106f60 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103fe5:	58                   	pop    %eax
80103fe6:	5a                   	pop    %edx
80103fe7:	ff 73 1c             	pushl  0x1c(%ebx)
80103fea:	57                   	push   %edi
      p->state = RUNNING;
80103feb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ff2:	e8 b4 0b 00 00       	call   80104bab <swtch>
      switchkvm();
80103ff7:	e8 44 2f 00 00       	call   80106f40 <switchkvm>
      c->proc = 0;
80103ffc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104003:	00 00 00 
80104006:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104009:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
8010400f:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
80104015:	72 b9                	jb     80103fd0 <scheduler+0x40>
    release(&ptable.lock);
80104017:	83 ec 0c             	sub    $0xc,%esp
8010401a:	68 a0 1d 12 80       	push   $0x80121da0
8010401f:	e8 fc 08 00 00       	call   80104920 <release>
    sti();
80104024:	83 c4 10             	add    $0x10,%esp
80104027:	eb 87                	jmp    80103fb0 <scheduler+0x20>
80104029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104030 <sched>:
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	56                   	push   %esi
80104034:	53                   	push   %ebx
  pushcli();
80104035:	e8 56 07 00 00       	call   80104790 <pushcli>
  c = mycpu();
8010403a:	e8 b1 fb ff ff       	call   80103bf0 <mycpu>
  p = c->proc;
8010403f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104045:	e8 86 07 00 00       	call   801047d0 <popcli>
  if(!holding(&ptable.lock))
8010404a:	83 ec 0c             	sub    $0xc,%esp
8010404d:	68 a0 1d 12 80       	push   $0x80121da0
80104052:	e8 d9 07 00 00       	call   80104830 <holding>
80104057:	83 c4 10             	add    $0x10,%esp
8010405a:	85 c0                	test   %eax,%eax
8010405c:	74 4f                	je     801040ad <sched+0x7d>
  if(mycpu()->ncli != 1)
8010405e:	e8 8d fb ff ff       	call   80103bf0 <mycpu>
80104063:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010406a:	75 68                	jne    801040d4 <sched+0xa4>
  if(p->state == RUNNING)
8010406c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104070:	74 55                	je     801040c7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104072:	9c                   	pushf  
80104073:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104074:	f6 c4 02             	test   $0x2,%ah
80104077:	75 41                	jne    801040ba <sched+0x8a>
  intena = mycpu()->intena;
80104079:	e8 72 fb ff ff       	call   80103bf0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010407e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104081:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104087:	e8 64 fb ff ff       	call   80103bf0 <mycpu>
8010408c:	83 ec 08             	sub    $0x8,%esp
8010408f:	ff 70 04             	pushl  0x4(%eax)
80104092:	53                   	push   %ebx
80104093:	e8 13 0b 00 00       	call   80104bab <swtch>
  mycpu()->intena = intena;
80104098:	e8 53 fb ff ff       	call   80103bf0 <mycpu>
}
8010409d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801040a0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801040a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040a9:	5b                   	pop    %ebx
801040aa:	5e                   	pop    %esi
801040ab:	5d                   	pop    %ebp
801040ac:	c3                   	ret    
    panic("sched ptable.lock");
801040ad:	83 ec 0c             	sub    $0xc,%esp
801040b0:	68 aa 7d 10 80       	push   $0x80107daa
801040b5:	e8 d6 c2 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801040ba:	83 ec 0c             	sub    $0xc,%esp
801040bd:	68 d6 7d 10 80       	push   $0x80107dd6
801040c2:	e8 c9 c2 ff ff       	call   80100390 <panic>
    panic("sched running");
801040c7:	83 ec 0c             	sub    $0xc,%esp
801040ca:	68 c8 7d 10 80       	push   $0x80107dc8
801040cf:	e8 bc c2 ff ff       	call   80100390 <panic>
    panic("sched locks");
801040d4:	83 ec 0c             	sub    $0xc,%esp
801040d7:	68 bc 7d 10 80       	push   $0x80107dbc
801040dc:	e8 af c2 ff ff       	call   80100390 <panic>
801040e1:	eb 0d                	jmp    801040f0 <exit>
801040e3:	90                   	nop
801040e4:	90                   	nop
801040e5:	90                   	nop
801040e6:	90                   	nop
801040e7:	90                   	nop
801040e8:	90                   	nop
801040e9:	90                   	nop
801040ea:	90                   	nop
801040eb:	90                   	nop
801040ec:	90                   	nop
801040ed:	90                   	nop
801040ee:	90                   	nop
801040ef:	90                   	nop

801040f0 <exit>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	57                   	push   %edi
801040f4:	56                   	push   %esi
801040f5:	53                   	push   %ebx
801040f6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801040f9:	e8 92 06 00 00       	call   80104790 <pushcli>
  c = mycpu();
801040fe:	e8 ed fa ff ff       	call   80103bf0 <mycpu>
  p = c->proc;
80104103:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104109:	e8 c2 06 00 00       	call   801047d0 <popcli>
  if(curproc == initproc)
8010410e:	39 1d b8 b5 10 80    	cmp    %ebx,0x8010b5b8
80104114:	8d 73 28             	lea    0x28(%ebx),%esi
80104117:	8d 7b 68             	lea    0x68(%ebx),%edi
8010411a:	0f 84 01 01 00 00    	je     80104221 <exit+0x131>
    if(curproc->ofile[fd]){
80104120:	8b 06                	mov    (%esi),%eax
80104122:	85 c0                	test   %eax,%eax
80104124:	74 12                	je     80104138 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104126:	83 ec 0c             	sub    $0xc,%esp
80104129:	50                   	push   %eax
8010412a:	e8 b1 cd ff ff       	call   80100ee0 <fileclose>
      curproc->ofile[fd] = 0;
8010412f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104135:	83 c4 10             	add    $0x10,%esp
80104138:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010413b:	39 fe                	cmp    %edi,%esi
8010413d:	75 e1                	jne    80104120 <exit+0x30>
  begin_op();
8010413f:	e8 0c ef ff ff       	call   80103050 <begin_op>
  iput(curproc->cwd);
80104144:	83 ec 0c             	sub    $0xc,%esp
80104147:	ff 73 68             	pushl  0x68(%ebx)
8010414a:	e8 01 d7 ff ff       	call   80101850 <iput>
  end_op();
8010414f:	e8 6c ef ff ff       	call   801030c0 <end_op>
  curproc->cwd = 0;
80104154:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  removeSwapFile(curproc);
8010415b:	89 1c 24             	mov    %ebx,(%esp)
8010415e:	e8 ed de ff ff       	call   80102050 <removeSwapFile>
  acquire(&ptable.lock);
80104163:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
8010416a:	e8 f1 06 00 00       	call   80104860 <acquire>
  wakeup1(curproc->parent);
8010416f:	8b 53 14             	mov    0x14(%ebx),%edx
80104172:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104175:	b8 d4 1d 12 80       	mov    $0x80121dd4,%eax
8010417a:	eb 10                	jmp    8010418c <exit+0x9c>
8010417c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104180:	05 d0 03 00 00       	add    $0x3d0,%eax
80104185:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
8010418a:	73 1e                	jae    801041aa <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
8010418c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104190:	75 ee                	jne    80104180 <exit+0x90>
80104192:	3b 50 20             	cmp    0x20(%eax),%edx
80104195:	75 e9                	jne    80104180 <exit+0x90>
      p->state = RUNNABLE;
80104197:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010419e:	05 d0 03 00 00       	add    $0x3d0,%eax
801041a3:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
801041a8:	72 e2                	jb     8010418c <exit+0x9c>
      p->parent = initproc;
801041aa:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b0:	ba d4 1d 12 80       	mov    $0x80121dd4,%edx
801041b5:	eb 17                	jmp    801041ce <exit+0xde>
801041b7:	89 f6                	mov    %esi,%esi
801041b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801041c0:	81 c2 d0 03 00 00    	add    $0x3d0,%edx
801041c6:	81 fa d4 11 13 80    	cmp    $0x801311d4,%edx
801041cc:	73 3a                	jae    80104208 <exit+0x118>
    if(p->parent == curproc){
801041ce:	39 5a 14             	cmp    %ebx,0x14(%edx)
801041d1:	75 ed                	jne    801041c0 <exit+0xd0>
      if(p->state == ZOMBIE)
801041d3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801041d7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801041da:	75 e4                	jne    801041c0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041dc:	b8 d4 1d 12 80       	mov    $0x80121dd4,%eax
801041e1:	eb 11                	jmp    801041f4 <exit+0x104>
801041e3:	90                   	nop
801041e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041e8:	05 d0 03 00 00       	add    $0x3d0,%eax
801041ed:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
801041f2:	73 cc                	jae    801041c0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
801041f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041f8:	75 ee                	jne    801041e8 <exit+0xf8>
801041fa:	3b 48 20             	cmp    0x20(%eax),%ecx
801041fd:	75 e9                	jne    801041e8 <exit+0xf8>
      p->state = RUNNABLE;
801041ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104206:	eb e0                	jmp    801041e8 <exit+0xf8>
  curproc->state = ZOMBIE;
80104208:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010420f:	e8 1c fe ff ff       	call   80104030 <sched>
  panic("zombie exit");
80104214:	83 ec 0c             	sub    $0xc,%esp
80104217:	68 f7 7d 10 80       	push   $0x80107df7
8010421c:	e8 6f c1 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104221:	83 ec 0c             	sub    $0xc,%esp
80104224:	68 ea 7d 10 80       	push   $0x80107dea
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
80104246:	e8 a5 f9 ff ff       	call   80103bf0 <mycpu>
  p = c->proc;
8010424b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104251:	e8 7a 05 00 00       	call   801047d0 <popcli>
  myproc()->state = RUNNABLE;
80104256:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010425d:	e8 ce fd ff ff       	call   80104030 <sched>
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
80104294:	e8 57 f9 ff ff       	call   80103bf0 <mycpu>
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
801042d7:	e8 54 fd ff ff       	call   80104030 <sched>
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
80104312:	e8 19 fd ff ff       	call   80104030 <sched>
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
80104329:	68 09 7e 10 80       	push   $0x80107e09
8010432e:	e8 5d c0 ff ff       	call   80100390 <panic>
    panic("sleep");
80104333:	83 ec 0c             	sub    $0xc,%esp
80104336:	68 03 7e 10 80       	push   $0x80107e03
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
8010434a:	e8 a1 f8 ff ff       	call   80103bf0 <mycpu>
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
801043d1:	e8 ca 27 00 00       	call   80106ba0 <cow_kfree>
        freevm(p->pgdir);
801043d6:	5a                   	pop    %edx
801043d7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801043da:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801043e1:	e8 2a 2f 00 00       	call   80107310 <freevm>
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
8010453b:	68 79 82 10 80       	push   $0x80108279
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
80104564:	ba 1a 7e 10 80       	mov    $0x80107e1a,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104569:	77 11                	ja     8010457c <procdump+0x5c>
8010456b:	8b 14 85 7c 7e 10 80 	mov    -0x7fef8184(,%eax,4),%edx
      state = "???";
80104572:	b8 1a 7e 10 80       	mov    $0x80107e1a,%eax
80104577:	85 d2                	test   %edx,%edx
80104579:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010457c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010457f:	50                   	push   %eax
80104580:	52                   	push   %edx
80104581:	ff 73 10             	pushl  0x10(%ebx)
80104584:	68 1e 7e 10 80       	push   $0x80107e1e
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
801045c9:	68 e1 77 10 80       	push   $0x801077e1
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
801045fa:	68 94 7e 10 80       	push   $0x80107e94
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
80104669:	e8 32 f6 ff ff       	call   80103ca0 <myproc>
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
801046f3:	e8 a8 f5 ff ff       	call   80103ca0 <myproc>
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
8010479a:	e8 51 f4 ff ff       	call   80103bf0 <mycpu>
8010479f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801047a5:	85 c0                	test   %eax,%eax
801047a7:	75 11                	jne    801047ba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801047a9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801047af:	e8 3c f4 ff ff       	call   80103bf0 <mycpu>
801047b4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801047ba:	e8 31 f4 ff ff       	call   80103bf0 <mycpu>
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
801047dd:	e8 0e f4 ff ff       	call   80103bf0 <mycpu>
801047e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801047e9:	78 34                	js     8010481f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047eb:	e8 00 f4 ff ff       	call   80103bf0 <mycpu>
801047f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801047f6:	85 d2                	test   %edx,%edx
801047f8:	74 06                	je     80104800 <popcli+0x30>
    sti();
}
801047fa:	c9                   	leave  
801047fb:	c3                   	ret    
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104800:	e8 eb f3 ff ff       	call   80103bf0 <mycpu>
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
80104815:	68 9f 7e 10 80       	push   $0x80107e9f
8010481a:	e8 71 bb ff ff       	call   80100390 <panic>
    panic("popcli");
8010481f:	83 ec 0c             	sub    $0xc,%esp
80104822:	68 b6 7e 10 80       	push   $0x80107eb6
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
80104848:	e8 a3 f3 ff ff       	call   80103bf0 <mycpu>
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
801048a4:	e8 47 f3 ff ff       	call   80103bf0 <mycpu>
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
80104907:	68 bd 7e 10 80       	push   $0x80107ebd
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
8010495c:	68 c5 7e 10 80       	push   $0x80107ec5
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
80104bca:	e8 d1 f0 ff ff       	call   80103ca0 <myproc>

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
80104c0a:	e8 91 f0 ff ff       	call   80103ca0 <myproc>

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
80104c75:	e8 26 f0 ff ff       	call   80103ca0 <myproc>
80104c7a:	8b 40 18             	mov    0x18(%eax),%eax
80104c7d:	8b 55 08             	mov    0x8(%ebp),%edx
80104c80:	8b 40 44             	mov    0x44(%eax),%eax
80104c83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c86:	e8 15 f0 ff ff       	call   80103ca0 <myproc>
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
80104ccb:	e8 d0 ef ff ff       	call   80103ca0 <myproc>
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
80104d67:	e8 34 ef ff ff       	call   80103ca0 <myproc>
80104d6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d6e:	8b 40 18             	mov    0x18(%eax),%eax
80104d71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d77:	83 fa 15             	cmp    $0x15,%edx
80104d7a:	77 1c                	ja     80104d98 <syscall+0x38>
80104d7c:	8b 14 85 00 7f 10 80 	mov    -0x7fef8100(,%eax,4),%edx
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
80104da0:	68 cd 7e 10 80       	push   $0x80107ecd
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
80104de4:	e8 b7 ee ff ff       	call   80103ca0 <myproc>
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
80104e2b:	e8 70 ee ff ff       	call   80103ca0 <myproc>
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
80104e52:	e8 39 c0 ff ff       	call   80100e90 <filedup>
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
80104ecd:	e8 2e c1 ff ff       	call   80101000 <fileread>
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
80104f3d:	e8 4e c1 ff ff       	call   80101090 <filewrite>
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
80104f75:	e8 26 ed ff ff       	call   80103ca0 <myproc>
80104f7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104f7d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f80:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104f87:	00 
  fileclose(f);
80104f88:	ff 75 f4             	pushl  -0xc(%ebp)
80104f8b:	e8 50 bf ff ff       	call   80100ee0 <fileclose>
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
80104fe4:	e8 c7 bf ff ff       	call   80100fb0 <filestat>
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
80105038:	e8 13 e0 ff ff       	call   80103050 <begin_op>
  if((ip = namei(old)) == 0){
8010503d:	83 ec 0c             	sub    $0xc,%esp
80105040:	ff 75 d4             	pushl  -0x2c(%ebp)
80105043:	e8 38 cf ff ff       	call   80101f80 <namei>
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
80105059:	e8 c2 c6 ff ff       	call   80101720 <ilock>
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
80105078:	e8 f3 c5 ff ff       	call   80101670 <iupdate>
  iunlock(ip);
8010507d:	89 1c 24             	mov    %ebx,(%esp)
80105080:	e8 7b c7 ff ff       	call   80101800 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105085:	58                   	pop    %eax
80105086:	5a                   	pop    %edx
80105087:	57                   	push   %edi
80105088:	ff 75 d0             	pushl  -0x30(%ebp)
8010508b:	e8 10 cf ff ff       	call   80101fa0 <nameiparent>
80105090:	83 c4 10             	add    $0x10,%esp
80105093:	85 c0                	test   %eax,%eax
80105095:	89 c6                	mov    %eax,%esi
80105097:	74 5b                	je     801050f4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105099:	83 ec 0c             	sub    $0xc,%esp
8010509c:	50                   	push   %eax
8010509d:	e8 7e c6 ff ff       	call   80101720 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801050a2:	83 c4 10             	add    $0x10,%esp
801050a5:	8b 03                	mov    (%ebx),%eax
801050a7:	39 06                	cmp    %eax,(%esi)
801050a9:	75 3d                	jne    801050e8 <sys_link+0xe8>
801050ab:	83 ec 04             	sub    $0x4,%esp
801050ae:	ff 73 04             	pushl  0x4(%ebx)
801050b1:	57                   	push   %edi
801050b2:	56                   	push   %esi
801050b3:	e8 08 ce ff ff       	call   80101ec0 <dirlink>
801050b8:	83 c4 10             	add    $0x10,%esp
801050bb:	85 c0                	test   %eax,%eax
801050bd:	78 29                	js     801050e8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801050bf:	83 ec 0c             	sub    $0xc,%esp
801050c2:	56                   	push   %esi
801050c3:	e8 e8 c8 ff ff       	call   801019b0 <iunlockput>
  iput(ip);
801050c8:	89 1c 24             	mov    %ebx,(%esp)
801050cb:	e8 80 c7 ff ff       	call   80101850 <iput>

  end_op();
801050d0:	e8 eb df ff ff       	call   801030c0 <end_op>

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
801050ec:	e8 bf c8 ff ff       	call   801019b0 <iunlockput>
    goto bad;
801050f1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801050f4:	83 ec 0c             	sub    $0xc,%esp
801050f7:	53                   	push   %ebx
801050f8:	e8 23 c6 ff ff       	call   80101720 <ilock>
  ip->nlink--;
801050fd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105102:	89 1c 24             	mov    %ebx,(%esp)
80105105:	e8 66 c5 ff ff       	call   80101670 <iupdate>
  iunlockput(ip);
8010510a:	89 1c 24             	mov    %ebx,(%esp)
8010510d:	e8 9e c8 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105112:	e8 a9 df ff ff       	call   801030c0 <end_op>
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
8010512b:	e8 80 c8 ff ff       	call   801019b0 <iunlockput>
    end_op();
80105130:	e8 8b df ff ff       	call   801030c0 <end_op>
    return -1;
80105135:	83 c4 10             	add    $0x10,%esp
80105138:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010513d:	eb 9b                	jmp    801050da <sys_link+0xda>
    end_op();
8010513f:	e8 7c df ff ff       	call   801030c0 <end_op>
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
8010517d:	e8 7e c8 ff ff       	call   80101a00 <readi>
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
801051b0:	68 5c 7f 10 80       	push   $0x80107f5c
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
801051e2:	e8 69 de ff ff       	call   80103050 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801051e7:	83 ec 08             	sub    $0x8,%esp
801051ea:	53                   	push   %ebx
801051eb:	ff 75 c0             	pushl  -0x40(%ebp)
801051ee:	e8 ad cd ff ff       	call   80101fa0 <nameiparent>
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
80105204:	e8 17 c5 ff ff       	call   80101720 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105209:	58                   	pop    %eax
8010520a:	5a                   	pop    %edx
8010520b:	68 1d 79 10 80       	push   $0x8010791d
80105210:	53                   	push   %ebx
80105211:	e8 1a ca ff ff       	call   80101c30 <namecmp>
80105216:	83 c4 10             	add    $0x10,%esp
80105219:	85 c0                	test   %eax,%eax
8010521b:	0f 84 d7 00 00 00    	je     801052f8 <sys_unlink+0x138>
80105221:	83 ec 08             	sub    $0x8,%esp
80105224:	68 1c 79 10 80       	push   $0x8010791c
80105229:	53                   	push   %ebx
8010522a:	e8 01 ca ff ff       	call   80101c30 <namecmp>
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
80105243:	e8 08 ca ff ff       	call   80101c50 <dirlookup>
80105248:	83 c4 10             	add    $0x10,%esp
8010524b:	85 c0                	test   %eax,%eax
8010524d:	89 c3                	mov    %eax,%ebx
8010524f:	0f 84 a3 00 00 00    	je     801052f8 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105255:	83 ec 0c             	sub    $0xc,%esp
80105258:	50                   	push   %eax
80105259:	e8 c2 c4 ff ff       	call   80101720 <ilock>

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
8010528a:	e8 71 c8 ff ff       	call   80101b00 <writei>
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
801052a6:	e8 05 c7 ff ff       	call   801019b0 <iunlockput>

  ip->nlink--;
801052ab:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052b0:	89 1c 24             	mov    %ebx,(%esp)
801052b3:	e8 b8 c3 ff ff       	call   80101670 <iupdate>
  iunlockput(ip);
801052b8:	89 1c 24             	mov    %ebx,(%esp)
801052bb:	e8 f0 c6 ff ff       	call   801019b0 <iunlockput>

  end_op();
801052c0:	e8 fb dd ff ff       	call   801030c0 <end_op>

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
801052ec:	e8 bf c6 ff ff       	call   801019b0 <iunlockput>
    goto bad;
801052f1:	83 c4 10             	add    $0x10,%esp
801052f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801052f8:	83 ec 0c             	sub    $0xc,%esp
801052fb:	56                   	push   %esi
801052fc:	e8 af c6 ff ff       	call   801019b0 <iunlockput>
  end_op();
80105301:	e8 ba dd ff ff       	call   801030c0 <end_op>
  return -1;
80105306:	83 c4 10             	add    $0x10,%esp
80105309:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010530e:	eb ba                	jmp    801052ca <sys_unlink+0x10a>
    dp->nlink--;
80105310:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105315:	83 ec 0c             	sub    $0xc,%esp
80105318:	56                   	push   %esi
80105319:	e8 52 c3 ff ff       	call   80101670 <iupdate>
8010531e:	83 c4 10             	add    $0x10,%esp
80105321:	e9 7c ff ff ff       	jmp    801052a2 <sys_unlink+0xe2>
80105326:	8d 76 00             	lea    0x0(%esi),%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105335:	eb 93                	jmp    801052ca <sys_unlink+0x10a>
    end_op();
80105337:	e8 84 dd ff ff       	call   801030c0 <end_op>
    return -1;
8010533c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105341:	eb 87                	jmp    801052ca <sys_unlink+0x10a>
    panic("unlink: writei");
80105343:	83 ec 0c             	sub    $0xc,%esp
80105346:	68 31 79 10 80       	push   $0x80107931
8010534b:	e8 40 b0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105350:	83 ec 0c             	sub    $0xc,%esp
80105353:	68 1f 79 10 80       	push   $0x8010791f
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
80105382:	e8 19 cc ff ff       	call   80101fa0 <nameiparent>
80105387:	83 c4 10             	add    $0x10,%esp
8010538a:	85 c0                	test   %eax,%eax
8010538c:	0f 84 4e 01 00 00    	je     801054e0 <create+0x180>
    return 0;
  ilock(dp);
80105392:	83 ec 0c             	sub    $0xc,%esp
80105395:	89 c3                	mov    %eax,%ebx
80105397:	50                   	push   %eax
80105398:	e8 83 c3 ff ff       	call   80101720 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
8010539d:	83 c4 0c             	add    $0xc,%esp
801053a0:	6a 00                	push   $0x0
801053a2:	56                   	push   %esi
801053a3:	53                   	push   %ebx
801053a4:	e8 a7 c8 ff ff       	call   80101c50 <dirlookup>
801053a9:	83 c4 10             	add    $0x10,%esp
801053ac:	85 c0                	test   %eax,%eax
801053ae:	89 c7                	mov    %eax,%edi
801053b0:	74 3e                	je     801053f0 <create+0x90>
    iunlockput(dp);
801053b2:	83 ec 0c             	sub    $0xc,%esp
801053b5:	53                   	push   %ebx
801053b6:	e8 f5 c5 ff ff       	call   801019b0 <iunlockput>
    ilock(ip);
801053bb:	89 3c 24             	mov    %edi,(%esp)
801053be:	e8 5d c3 ff ff       	call   80101720 <ilock>
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
801053fa:	e8 b1 c1 ff ff       	call   801015b0 <ialloc>
801053ff:	83 c4 10             	add    $0x10,%esp
80105402:	85 c0                	test   %eax,%eax
80105404:	89 c7                	mov    %eax,%edi
80105406:	0f 84 e8 00 00 00    	je     801054f4 <create+0x194>
  ilock(ip);
8010540c:	83 ec 0c             	sub    $0xc,%esp
8010540f:	50                   	push   %eax
80105410:	e8 0b c3 ff ff       	call   80101720 <ilock>
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
80105431:	e8 3a c2 ff ff       	call   80101670 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105436:	83 c4 10             	add    $0x10,%esp
80105439:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010543e:	74 50                	je     80105490 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105440:	83 ec 04             	sub    $0x4,%esp
80105443:	ff 77 04             	pushl  0x4(%edi)
80105446:	56                   	push   %esi
80105447:	53                   	push   %ebx
80105448:	e8 73 ca ff ff       	call   80101ec0 <dirlink>
8010544d:	83 c4 10             	add    $0x10,%esp
80105450:	85 c0                	test   %eax,%eax
80105452:	0f 88 8f 00 00 00    	js     801054e7 <create+0x187>
  iunlockput(dp);
80105458:	83 ec 0c             	sub    $0xc,%esp
8010545b:	53                   	push   %ebx
8010545c:	e8 4f c5 ff ff       	call   801019b0 <iunlockput>
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
80105476:	e8 35 c5 ff ff       	call   801019b0 <iunlockput>
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
80105499:	e8 d2 c1 ff ff       	call   80101670 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010549e:	83 c4 0c             	add    $0xc,%esp
801054a1:	ff 77 04             	pushl  0x4(%edi)
801054a4:	68 1d 79 10 80       	push   $0x8010791d
801054a9:	57                   	push   %edi
801054aa:	e8 11 ca ff ff       	call   80101ec0 <dirlink>
801054af:	83 c4 10             	add    $0x10,%esp
801054b2:	85 c0                	test   %eax,%eax
801054b4:	78 1c                	js     801054d2 <create+0x172>
801054b6:	83 ec 04             	sub    $0x4,%esp
801054b9:	ff 73 04             	pushl  0x4(%ebx)
801054bc:	68 1c 79 10 80       	push   $0x8010791c
801054c1:	57                   	push   %edi
801054c2:	e8 f9 c9 ff ff       	call   80101ec0 <dirlink>
801054c7:	83 c4 10             	add    $0x10,%esp
801054ca:	85 c0                	test   %eax,%eax
801054cc:	0f 89 6e ff ff ff    	jns    80105440 <create+0xe0>
      panic("create dots");
801054d2:	83 ec 0c             	sub    $0xc,%esp
801054d5:	68 7d 7f 10 80       	push   $0x80107f7d
801054da:	e8 b1 ae ff ff       	call   80100390 <panic>
801054df:	90                   	nop
    return 0;
801054e0:	31 ff                	xor    %edi,%edi
801054e2:	e9 f5 fe ff ff       	jmp    801053dc <create+0x7c>
    panic("create: dirlink");
801054e7:	83 ec 0c             	sub    $0xc,%esp
801054ea:	68 89 7f 10 80       	push   $0x80107f89
801054ef:	e8 9c ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801054f4:	83 ec 0c             	sub    $0xc,%esp
801054f7:	68 6e 7f 10 80       	push   $0x80107f6e
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
80105548:	e8 03 db ff ff       	call   80103050 <begin_op>

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
8010555d:	e8 1e ca ff ff       	call   80101f80 <namei>
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
80105573:	e8 a8 c1 ff ff       	call   80101720 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105578:	83 c4 10             	add    $0x10,%esp
8010557b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105580:	0f 84 aa 00 00 00    	je     80105630 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105586:	e8 95 b8 ff ff       	call   80100e20 <filealloc>
8010558b:	85 c0                	test   %eax,%eax
8010558d:	89 c7                	mov    %eax,%edi
8010558f:	0f 84 a6 00 00 00    	je     8010563b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105595:	e8 06 e7 ff ff       	call   80103ca0 <myproc>
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
801055bc:	e8 3f c2 ff ff       	call   80101800 <iunlock>
  end_op();
801055c1:	e8 fa da ff ff       	call   801030c0 <end_op>

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
8010561b:	e8 a0 da ff ff       	call   801030c0 <end_op>
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
8010563f:	e8 6c c3 ff ff       	call   801019b0 <iunlockput>
    end_op();
80105644:	e8 77 da ff ff       	call   801030c0 <end_op>
    return -1;
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105651:	eb 9a                	jmp    801055ed <sys_open+0xdd>
80105653:	90                   	nop
80105654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105658:	83 ec 0c             	sub    $0xc,%esp
8010565b:	57                   	push   %edi
8010565c:	e8 7f b8 ff ff       	call   80100ee0 <fileclose>
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
80105676:	e8 d5 d9 ff ff       	call   80103050 <begin_op>
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
801056a9:	e8 02 c3 ff ff       	call   801019b0 <iunlockput>
  end_op();
801056ae:	e8 0d da ff ff       	call   801030c0 <end_op>
  return 0;
801056b3:	83 c4 10             	add    $0x10,%esp
801056b6:	31 c0                	xor    %eax,%eax
}
801056b8:	c9                   	leave  
801056b9:	c3                   	ret    
801056ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
801056c0:	e8 fb d9 ff ff       	call   801030c0 <end_op>
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
801056d6:	e8 75 d9 ff ff       	call   80103050 <begin_op>
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
80105739:	e8 72 c2 ff ff       	call   801019b0 <iunlockput>
  end_op();
8010573e:	e8 7d d9 ff ff       	call   801030c0 <end_op>
  return 0;
80105743:	83 c4 10             	add    $0x10,%esp
80105746:	31 c0                	xor    %eax,%eax
}
80105748:	c9                   	leave  
80105749:	c3                   	ret    
8010574a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105750:	e8 6b d9 ff ff       	call   801030c0 <end_op>
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
80105768:	e8 33 e5 ff ff       	call   80103ca0 <myproc>
8010576d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010576f:	e8 dc d8 ff ff       	call   80103050 <begin_op>
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
8010578f:	e8 ec c7 ff ff       	call   80101f80 <namei>
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
801057a1:	e8 7a bf ff ff       	call   80101720 <ilock>
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
801057b4:	e8 47 c0 ff ff       	call   80101800 <iunlock>
  iput(curproc->cwd);
801057b9:	58                   	pop    %eax
801057ba:	ff 76 68             	pushl  0x68(%esi)
801057bd:	e8 8e c0 ff ff       	call   80101850 <iput>
  end_op();
801057c2:	e8 f9 d8 ff ff       	call   801030c0 <end_op>
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
801057e4:	e8 c7 c1 ff ff       	call   801019b0 <iunlockput>
    end_op();
801057e9:	e8 d2 d8 ff ff       	call   801030c0 <end_op>
    return -1;
801057ee:	83 c4 10             	add    $0x10,%esp
801057f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f6:	eb d7                	jmp    801057cf <sys_chdir+0x6f>
801057f8:	90                   	nop
801057f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105800:	e8 bb d8 ff ff       	call   801030c0 <end_op>
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
8010592c:	e8 bf dd ff ff       	call   801036f0 <pipealloc>
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
80105941:	e8 5a e3 ff ff       	call   80103ca0 <myproc>
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
8010596a:	e8 31 e3 ff ff       	call   80103ca0 <myproc>
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
801059a8:	e8 f3 e2 ff ff       	call   80103ca0 <myproc>
801059ad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801059b4:	00 
801059b5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801059b8:	83 ec 0c             	sub    $0xc,%esp
801059bb:	ff 75 e0             	pushl  -0x20(%ebp)
801059be:	e8 1d b5 ff ff       	call   80100ee0 <fileclose>
    fileclose(wf);
801059c3:	58                   	pop    %eax
801059c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801059c7:	e8 14 b5 ff ff       	call   80100ee0 <fileclose>
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
801059e4:	e9 87 e4 ff ff       	jmp    80103e70 <fork>
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_exit>:

int
sys_exit(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059f6:	e8 f5 e6 ff ff       	call   801040f0 <exit>
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
80105a56:	e8 45 e2 ff ff       	call   80103ca0 <myproc>
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
80105a79:	e8 22 e2 ff ff       	call   80103ca0 <myproc>
  if(growproc(n) < 0)
80105a7e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a81:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a83:	ff 75 f4             	pushl  -0xc(%ebp)
80105a86:	e8 35 e3 ff ff       	call   80103dc0 <growproc>
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
80105b11:	e8 8a e1 ff ff       	call   80103ca0 <myproc>
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
80105b94:	e9 a7 e2 ff ff       	jmp    80103e40 <sys_get_number_of_free_pages_impl>

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
80105c11:	68 99 7f 10 80       	push   $0x80107f99
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
80105c76:	83 ec 1c             	sub    $0x1c,%esp
80105c79:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105c7c:	8b 47 30             	mov    0x30(%edi),%eax
80105c7f:	83 f8 40             	cmp    $0x40,%eax
80105c82:	0f 84 18 01 00 00    	je     80105da0 <trap+0x130>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c88:	83 e8 0e             	sub    $0xe,%eax
80105c8b:	83 f8 31             	cmp    $0x31,%eax
80105c8e:	0f 87 ec 01 00 00    	ja     80105e80 <trap+0x210>
80105c94:	ff 24 85 6c 80 10 80 	jmp    *-0x7fef7f94(,%eax,4)
80105c9b:	90                   	nop
80105c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105ca0:	0f 20 d3             	mov    %cr2,%ebx

  case T_PGFLT:
  ;//verify none includes cow
  
    uint faulting_addr = rcr2();
    struct proc* p = myproc();
80105ca3:	e8 f8 df ff ff       	call   80103ca0 <myproc>
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80105ca8:	83 ec 04             	sub    $0x4,%esp
    struct proc* p = myproc();
80105cab:	89 c6                	mov    %eax,%esi
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80105cad:	6a 00                	push   $0x0
80105caf:	53                   	push   %ebx
80105cb0:	ff 70 04             	pushl  0x4(%eax)
80105cb3:	e8 68 12 00 00       	call   80106f20 <public_walkpgdir>
      }
      p->num_of_pagefaults_occurs++;
      break;
    }
#endif
    if (!(pte_ptr == 0) && *pte_ptr & PTE_COW){
80105cb8:	83 c4 10             	add    $0x10,%esp
80105cbb:	85 c0                	test   %eax,%eax
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80105cbd:	89 c3                	mov    %eax,%ebx
    if (!(pte_ptr == 0) && *pte_ptr & PTE_COW){
80105cbf:	0f 84 bb 01 00 00    	je     80105e80 <trap+0x210>
80105cc5:	f7 00 00 08 00 00    	testl  $0x800,(%eax)
80105ccb:	0f 84 af 01 00 00    	je     80105e80 <trap+0x210>
      // cprintf("trap %d\n", p->pid);
      acquire(cow_lock);
80105cd1:	83 ec 0c             	sub    $0xc,%esp
80105cd4:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80105cda:	e8 81 eb ff ff       	call   80104860 <acquire>
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
80105cdf:	8b 0b                	mov    (%ebx),%ecx
      if (*ref_count == 1){
80105ce1:	83 c4 10             	add    $0x10,%esp
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
80105ce4:	89 ca                	mov    %ecx,%edx
80105ce6:	c1 ea 0c             	shr    $0xc,%edx
      if (*ref_count == 1){
80105ce9:	0f b6 82 40 0f 11 80 	movzbl -0x7feef0c0(%edx),%eax
80105cf0:	3c 01                	cmp    $0x1,%al
80105cf2:	0f 84 4c 02 00 00    	je     80105f44 <trap+0x2d4>
        *pte_ptr &= (~PTE_COW);
        // cprintf("rel trap %d\n", p->pid);
        release(cow_lock);
        break;
      }
      else if (*ref_count > 1){
80105cf8:	0f 8e 8c 02 00 00    	jle    80105f8a <trap+0x31a>
        (*ref_count)--;
        // cprintf("rel trap %d\n", p->pid);
        release(cow_lock);
80105cfe:	83 ec 0c             	sub    $0xc,%esp
80105d01:	ff 35 40 ef 11 80    	pushl  0x8011ef40
        (*ref_count)--;
80105d07:	83 e8 01             	sub    $0x1,%eax
80105d0a:	88 82 40 0f 11 80    	mov    %al,-0x7feef0c0(%edx)
        release(cow_lock);
80105d10:	e8 0b ec ff ff       	call   80104920 <release>
        int result = copy_page(p->pgdir, pte_ptr);
80105d15:	59                   	pop    %ecx
80105d16:	58                   	pop    %eax
80105d17:	53                   	push   %ebx
80105d18:	ff 76 04             	pushl  0x4(%esi)
80105d1b:	e8 20 1a 00 00       	call   80107740 <copy_page>
        if (result < 0){
80105d20:	83 c4 10             	add    $0x10,%esp
80105d23:	85 c0                	test   %eax,%eax
80105d25:	79 11                	jns    80105d38 <trap+0xc8>
          p->killed = 1;
80105d27:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
          exit();
80105d2e:	e8 bd e3 ff ff       	call   801040f0 <exit>
80105d33:	90                   	nop
80105d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d38:	e8 63 df ff ff       	call   80103ca0 <myproc>
80105d3d:	85 c0                	test   %eax,%eax
80105d3f:	74 1d                	je     80105d5e <trap+0xee>
80105d41:	e8 5a df ff ff       	call   80103ca0 <myproc>
80105d46:	8b 50 24             	mov    0x24(%eax),%edx
80105d49:	85 d2                	test   %edx,%edx
80105d4b:	74 11                	je     80105d5e <trap+0xee>
80105d4d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d51:	83 e0 03             	and    $0x3,%eax
80105d54:	66 83 f8 03          	cmp    $0x3,%ax
80105d58:	0f 84 a2 01 00 00    	je     80105f00 <trap+0x290>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80105d5e:	e8 3d df ff ff       	call   80103ca0 <myproc>
80105d63:	85 c0                	test   %eax,%eax
80105d65:	74 0b                	je     80105d72 <trap+0x102>
80105d67:	e8 34 df ff ff       	call   80103ca0 <myproc>
80105d6c:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d70:	74 66                	je     80105dd8 <trap+0x168>
      yield();
    }
    

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d72:	e8 29 df ff ff       	call   80103ca0 <myproc>
80105d77:	85 c0                	test   %eax,%eax
80105d79:	74 19                	je     80105d94 <trap+0x124>
80105d7b:	e8 20 df ff ff       	call   80103ca0 <myproc>
80105d80:	8b 40 24             	mov    0x24(%eax),%eax
80105d83:	85 c0                	test   %eax,%eax
80105d85:	74 0d                	je     80105d94 <trap+0x124>
80105d87:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d8b:	83 e0 03             	and    $0x3,%eax
80105d8e:	66 83 f8 03          	cmp    $0x3,%ax
80105d92:	74 35                	je     80105dc9 <trap+0x159>
    exit();
}
80105d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d97:	5b                   	pop    %ebx
80105d98:	5e                   	pop    %esi
80105d99:	5f                   	pop    %edi
80105d9a:	5d                   	pop    %ebp
80105d9b:	c3                   	ret    
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105da0:	e8 fb de ff ff       	call   80103ca0 <myproc>
80105da5:	8b 40 24             	mov    0x24(%eax),%eax
80105da8:	85 c0                	test   %eax,%eax
80105daa:	0f 85 c0 00 00 00    	jne    80105e70 <trap+0x200>
    myproc()->tf = tf;
80105db0:	e8 eb de ff ff       	call   80103ca0 <myproc>
80105db5:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105db8:	e8 a3 ef ff ff       	call   80104d60 <syscall>
    if(myproc()->killed)
80105dbd:	e8 de de ff ff       	call   80103ca0 <myproc>
80105dc2:	8b 40 24             	mov    0x24(%eax),%eax
80105dc5:	85 c0                	test   %eax,%eax
80105dc7:	74 cb                	je     80105d94 <trap+0x124>
}
80105dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dcc:	5b                   	pop    %ebx
80105dcd:	5e                   	pop    %esi
80105dce:	5f                   	pop    %edi
80105dcf:	5d                   	pop    %ebp
      exit();
80105dd0:	e9 1b e3 ff ff       	jmp    801040f0 <exit>
80105dd5:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80105dd8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105ddc:	75 94                	jne    80105d72 <trap+0x102>
      yield();
80105dde:	e8 4d e4 ff ff       	call   80104230 <yield>
80105de3:	eb 8d                	jmp    80105d72 <trap+0x102>
80105de5:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105de8:	e8 93 de ff ff       	call   80103c80 <cpuid>
80105ded:	85 c0                	test   %eax,%eax
80105def:	0f 84 1b 01 00 00    	je     80105f10 <trap+0x2a0>
    lapiceoi();
80105df5:	e8 06 ce ff ff       	call   80102c00 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dfa:	e8 a1 de ff ff       	call   80103ca0 <myproc>
80105dff:	85 c0                	test   %eax,%eax
80105e01:	0f 85 3a ff ff ff    	jne    80105d41 <trap+0xd1>
80105e07:	e9 52 ff ff ff       	jmp    80105d5e <trap+0xee>
80105e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e10:	e8 ab cc ff ff       	call   80102ac0 <kbdintr>
    lapiceoi();
80105e15:	e8 e6 cd ff ff       	call   80102c00 <lapiceoi>
    break;
80105e1a:	e9 19 ff ff ff       	jmp    80105d38 <trap+0xc8>
80105e1f:	90                   	nop
    uartintr();
80105e20:	e8 eb 02 00 00       	call   80106110 <uartintr>
    lapiceoi();
80105e25:	e8 d6 cd ff ff       	call   80102c00 <lapiceoi>
    break;
80105e2a:	e9 09 ff ff ff       	jmp    80105d38 <trap+0xc8>
80105e2f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e30:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105e34:	8b 77 38             	mov    0x38(%edi),%esi
80105e37:	e8 44 de ff ff       	call   80103c80 <cpuid>
80105e3c:	56                   	push   %esi
80105e3d:	53                   	push   %ebx
80105e3e:	50                   	push   %eax
80105e3f:	68 a4 7f 10 80       	push   $0x80107fa4
80105e44:	e8 17 a8 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105e49:	e8 b2 cd ff ff       	call   80102c00 <lapiceoi>
    break;
80105e4e:	83 c4 10             	add    $0x10,%esp
80105e51:	e9 e2 fe ff ff       	jmp    80105d38 <trap+0xc8>
80105e56:	8d 76 00             	lea    0x0(%esi),%esi
80105e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80105e60:	e8 4b c6 ff ff       	call   801024b0 <ideintr>
80105e65:	eb 8e                	jmp    80105df5 <trap+0x185>
80105e67:	89 f6                	mov    %esi,%esi
80105e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80105e70:	e8 7b e2 ff ff       	call   801040f0 <exit>
80105e75:	e9 36 ff ff ff       	jmp    80105db0 <trap+0x140>
80105e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e80:	e8 1b de ff ff       	call   80103ca0 <myproc>
80105e85:	85 c0                	test   %eax,%eax
80105e87:	8b 5f 38             	mov    0x38(%edi),%ebx
80105e8a:	0f 84 d2 00 00 00    	je     80105f62 <trap+0x2f2>
80105e90:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105e94:	0f 84 c8 00 00 00    	je     80105f62 <trap+0x2f2>
80105e9a:	0f 20 d1             	mov    %cr2,%ecx
80105e9d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ea0:	e8 db dd ff ff       	call   80103c80 <cpuid>
80105ea5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105ea8:	8b 47 34             	mov    0x34(%edi),%eax
80105eab:	8b 77 30             	mov    0x30(%edi),%esi
80105eae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105eb1:	e8 ea dd ff ff       	call   80103ca0 <myproc>
80105eb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105eb9:	e8 e2 dd ff ff       	call   80103ca0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ebe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ec1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ec4:	51                   	push   %ecx
80105ec5:	53                   	push   %ebx
80105ec6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105ec7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105eca:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ecd:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105ece:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ed1:	52                   	push   %edx
80105ed2:	ff 70 10             	pushl  0x10(%eax)
80105ed5:	68 28 80 10 80       	push   $0x80108028
80105eda:	e8 81 a7 ff ff       	call   80100660 <cprintf>
    myproc()->killed = 1;
80105edf:	83 c4 20             	add    $0x20,%esp
80105ee2:	e8 b9 dd ff ff       	call   80103ca0 <myproc>
80105ee7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eee:	e8 ad dd ff ff       	call   80103ca0 <myproc>
80105ef3:	85 c0                	test   %eax,%eax
80105ef5:	0f 85 46 fe ff ff    	jne    80105d41 <trap+0xd1>
80105efb:	e9 5e fe ff ff       	jmp    80105d5e <trap+0xee>
    exit();
80105f00:	e8 eb e1 ff ff       	call   801040f0 <exit>
80105f05:	e9 54 fe ff ff       	jmp    80105d5e <trap+0xee>
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105f10:	83 ec 0c             	sub    $0xc,%esp
80105f13:	68 e0 11 13 80       	push   $0x801311e0
80105f18:	e8 43 e9 ff ff       	call   80104860 <acquire>
      wakeup(&ticks);
80105f1d:	c7 04 24 20 1a 13 80 	movl   $0x80131a20,(%esp)
      ticks++;
80105f24:	83 05 20 1a 13 80 01 	addl   $0x1,0x80131a20
      wakeup(&ticks);
80105f2b:	e8 10 e5 ff ff       	call   80104440 <wakeup>
      release(&tickslock);
80105f30:	c7 04 24 e0 11 13 80 	movl   $0x801311e0,(%esp)
80105f37:	e8 e4 e9 ff ff       	call   80104920 <release>
80105f3c:	83 c4 10             	add    $0x10,%esp
80105f3f:	e9 b1 fe ff ff       	jmp    80105df5 <trap+0x185>
        *pte_ptr &= (~PTE_COW);
80105f44:	80 e5 f7             	and    $0xf7,%ch
        release(cow_lock);
80105f47:	83 ec 0c             	sub    $0xc,%esp
        *pte_ptr &= (~PTE_COW);
80105f4a:	83 c9 02             	or     $0x2,%ecx
80105f4d:	89 0b                	mov    %ecx,(%ebx)
        release(cow_lock);
80105f4f:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80105f55:	e8 c6 e9 ff ff       	call   80104920 <release>
        break;
80105f5a:	83 c4 10             	add    $0x10,%esp
80105f5d:	e9 d6 fd ff ff       	jmp    80105d38 <trap+0xc8>
80105f62:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f65:	e8 16 dd ff ff       	call   80103c80 <cpuid>
80105f6a:	83 ec 0c             	sub    $0xc,%esp
80105f6d:	56                   	push   %esi
80105f6e:	53                   	push   %ebx
80105f6f:	50                   	push   %eax
80105f70:	ff 77 30             	pushl  0x30(%edi)
80105f73:	68 f4 7f 10 80       	push   $0x80107ff4
80105f78:	e8 e3 a6 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105f7d:	83 c4 14             	add    $0x14,%esp
80105f80:	68 9e 7f 10 80       	push   $0x80107f9e
80105f85:	e8 06 a4 ff ff       	call   80100390 <panic>
        panic("ref count to page is 0 but it was reffed");
80105f8a:	83 ec 0c             	sub    $0xc,%esp
80105f8d:	68 c8 7f 10 80       	push   $0x80107fc8
80105f92:	e8 f9 a3 ff ff       	call   80100390 <panic>
80105f97:	66 90                	xchg   %ax,%ax
80105f99:	66 90                	xchg   %ax,%ax
80105f9b:	66 90                	xchg   %ax,%ax
80105f9d:	66 90                	xchg   %ax,%ax
80105f9f:	90                   	nop

80105fa0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105fa0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80105fa5:	55                   	push   %ebp
80105fa6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105fa8:	85 c0                	test   %eax,%eax
80105faa:	74 1c                	je     80105fc8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fac:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fb1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105fb2:	a8 01                	test   $0x1,%al
80105fb4:	74 12                	je     80105fc8 <uartgetc+0x28>
80105fb6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fbb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105fbc:	0f b6 c0             	movzbl %al,%eax
}
80105fbf:	5d                   	pop    %ebp
80105fc0:	c3                   	ret    
80105fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fcd:	5d                   	pop    %ebp
80105fce:	c3                   	ret    
80105fcf:	90                   	nop

80105fd0 <uartputc.part.0>:
uartputc(int c)
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	57                   	push   %edi
80105fd4:	56                   	push   %esi
80105fd5:	53                   	push   %ebx
80105fd6:	89 c7                	mov    %eax,%edi
80105fd8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105fdd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105fe2:	83 ec 0c             	sub    $0xc,%esp
80105fe5:	eb 1b                	jmp    80106002 <uartputc.part.0+0x32>
80105fe7:	89 f6                	mov    %esi,%esi
80105fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105ff0:	83 ec 0c             	sub    $0xc,%esp
80105ff3:	6a 0a                	push   $0xa
80105ff5:	e8 26 cc ff ff       	call   80102c20 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ffa:	83 c4 10             	add    $0x10,%esp
80105ffd:	83 eb 01             	sub    $0x1,%ebx
80106000:	74 07                	je     80106009 <uartputc.part.0+0x39>
80106002:	89 f2                	mov    %esi,%edx
80106004:	ec                   	in     (%dx),%al
80106005:	a8 20                	test   $0x20,%al
80106007:	74 e7                	je     80105ff0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106009:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010600e:	89 f8                	mov    %edi,%eax
80106010:	ee                   	out    %al,(%dx)
}
80106011:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106014:	5b                   	pop    %ebx
80106015:	5e                   	pop    %esi
80106016:	5f                   	pop    %edi
80106017:	5d                   	pop    %ebp
80106018:	c3                   	ret    
80106019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106020 <uartinit>:
{
80106020:	55                   	push   %ebp
80106021:	31 c9                	xor    %ecx,%ecx
80106023:	89 c8                	mov    %ecx,%eax
80106025:	89 e5                	mov    %esp,%ebp
80106027:	57                   	push   %edi
80106028:	56                   	push   %esi
80106029:	53                   	push   %ebx
8010602a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010602f:	89 da                	mov    %ebx,%edx
80106031:	83 ec 0c             	sub    $0xc,%esp
80106034:	ee                   	out    %al,(%dx)
80106035:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010603a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010603f:	89 fa                	mov    %edi,%edx
80106041:	ee                   	out    %al,(%dx)
80106042:	b8 0c 00 00 00       	mov    $0xc,%eax
80106047:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010604c:	ee                   	out    %al,(%dx)
8010604d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106052:	89 c8                	mov    %ecx,%eax
80106054:	89 f2                	mov    %esi,%edx
80106056:	ee                   	out    %al,(%dx)
80106057:	b8 03 00 00 00       	mov    $0x3,%eax
8010605c:	89 fa                	mov    %edi,%edx
8010605e:	ee                   	out    %al,(%dx)
8010605f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106064:	89 c8                	mov    %ecx,%eax
80106066:	ee                   	out    %al,(%dx)
80106067:	b8 01 00 00 00       	mov    $0x1,%eax
8010606c:	89 f2                	mov    %esi,%edx
8010606e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010606f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106074:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106075:	3c ff                	cmp    $0xff,%al
80106077:	74 5a                	je     801060d3 <uartinit+0xb3>
  uart = 1;
80106079:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106080:	00 00 00 
80106083:	89 da                	mov    %ebx,%edx
80106085:	ec                   	in     (%dx),%al
80106086:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010608b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010608c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010608f:	bb 34 81 10 80       	mov    $0x80108134,%ebx
  ioapicenable(IRQ_COM1, 0);
80106094:	6a 00                	push   $0x0
80106096:	6a 04                	push   $0x4
80106098:	e8 63 c6 ff ff       	call   80102700 <ioapicenable>
8010609d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801060a0:	b8 78 00 00 00       	mov    $0x78,%eax
801060a5:	eb 13                	jmp    801060ba <uartinit+0x9a>
801060a7:	89 f6                	mov    %esi,%esi
801060a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801060b0:	83 c3 01             	add    $0x1,%ebx
801060b3:	0f be 03             	movsbl (%ebx),%eax
801060b6:	84 c0                	test   %al,%al
801060b8:	74 19                	je     801060d3 <uartinit+0xb3>
  if(!uart)
801060ba:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801060c0:	85 d2                	test   %edx,%edx
801060c2:	74 ec                	je     801060b0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801060c4:	83 c3 01             	add    $0x1,%ebx
801060c7:	e8 04 ff ff ff       	call   80105fd0 <uartputc.part.0>
801060cc:	0f be 03             	movsbl (%ebx),%eax
801060cf:	84 c0                	test   %al,%al
801060d1:	75 e7                	jne    801060ba <uartinit+0x9a>
}
801060d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060d6:	5b                   	pop    %ebx
801060d7:	5e                   	pop    %esi
801060d8:	5f                   	pop    %edi
801060d9:	5d                   	pop    %ebp
801060da:	c3                   	ret    
801060db:	90                   	nop
801060dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060e0 <uartputc>:
  if(!uart)
801060e0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801060e6:	55                   	push   %ebp
801060e7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801060e9:	85 d2                	test   %edx,%edx
{
801060eb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801060ee:	74 10                	je     80106100 <uartputc+0x20>
}
801060f0:	5d                   	pop    %ebp
801060f1:	e9 da fe ff ff       	jmp    80105fd0 <uartputc.part.0>
801060f6:	8d 76 00             	lea    0x0(%esi),%esi
801060f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106100:	5d                   	pop    %ebp
80106101:	c3                   	ret    
80106102:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106110 <uartintr>:

void
uartintr(void)
{
80106110:	55                   	push   %ebp
80106111:	89 e5                	mov    %esp,%ebp
80106113:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106116:	68 a0 5f 10 80       	push   $0x80105fa0
8010611b:	e8 f0 a6 ff ff       	call   80100810 <consoleintr>
}
80106120:	83 c4 10             	add    $0x10,%esp
80106123:	c9                   	leave  
80106124:	c3                   	ret    

80106125 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106125:	6a 00                	push   $0x0
  pushl $0
80106127:	6a 00                	push   $0x0
  jmp alltraps
80106129:	e9 6b fa ff ff       	jmp    80105b99 <alltraps>

8010612e <vector1>:
.globl vector1
vector1:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $1
80106130:	6a 01                	push   $0x1
  jmp alltraps
80106132:	e9 62 fa ff ff       	jmp    80105b99 <alltraps>

80106137 <vector2>:
.globl vector2
vector2:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $2
80106139:	6a 02                	push   $0x2
  jmp alltraps
8010613b:	e9 59 fa ff ff       	jmp    80105b99 <alltraps>

80106140 <vector3>:
.globl vector3
vector3:
  pushl $0
80106140:	6a 00                	push   $0x0
  pushl $3
80106142:	6a 03                	push   $0x3
  jmp alltraps
80106144:	e9 50 fa ff ff       	jmp    80105b99 <alltraps>

80106149 <vector4>:
.globl vector4
vector4:
  pushl $0
80106149:	6a 00                	push   $0x0
  pushl $4
8010614b:	6a 04                	push   $0x4
  jmp alltraps
8010614d:	e9 47 fa ff ff       	jmp    80105b99 <alltraps>

80106152 <vector5>:
.globl vector5
vector5:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $5
80106154:	6a 05                	push   $0x5
  jmp alltraps
80106156:	e9 3e fa ff ff       	jmp    80105b99 <alltraps>

8010615b <vector6>:
.globl vector6
vector6:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $6
8010615d:	6a 06                	push   $0x6
  jmp alltraps
8010615f:	e9 35 fa ff ff       	jmp    80105b99 <alltraps>

80106164 <vector7>:
.globl vector7
vector7:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $7
80106166:	6a 07                	push   $0x7
  jmp alltraps
80106168:	e9 2c fa ff ff       	jmp    80105b99 <alltraps>

8010616d <vector8>:
.globl vector8
vector8:
  pushl $8
8010616d:	6a 08                	push   $0x8
  jmp alltraps
8010616f:	e9 25 fa ff ff       	jmp    80105b99 <alltraps>

80106174 <vector9>:
.globl vector9
vector9:
  pushl $0
80106174:	6a 00                	push   $0x0
  pushl $9
80106176:	6a 09                	push   $0x9
  jmp alltraps
80106178:	e9 1c fa ff ff       	jmp    80105b99 <alltraps>

8010617d <vector10>:
.globl vector10
vector10:
  pushl $10
8010617d:	6a 0a                	push   $0xa
  jmp alltraps
8010617f:	e9 15 fa ff ff       	jmp    80105b99 <alltraps>

80106184 <vector11>:
.globl vector11
vector11:
  pushl $11
80106184:	6a 0b                	push   $0xb
  jmp alltraps
80106186:	e9 0e fa ff ff       	jmp    80105b99 <alltraps>

8010618b <vector12>:
.globl vector12
vector12:
  pushl $12
8010618b:	6a 0c                	push   $0xc
  jmp alltraps
8010618d:	e9 07 fa ff ff       	jmp    80105b99 <alltraps>

80106192 <vector13>:
.globl vector13
vector13:
  pushl $13
80106192:	6a 0d                	push   $0xd
  jmp alltraps
80106194:	e9 00 fa ff ff       	jmp    80105b99 <alltraps>

80106199 <vector14>:
.globl vector14
vector14:
  pushl $14
80106199:	6a 0e                	push   $0xe
  jmp alltraps
8010619b:	e9 f9 f9 ff ff       	jmp    80105b99 <alltraps>

801061a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801061a0:	6a 00                	push   $0x0
  pushl $15
801061a2:	6a 0f                	push   $0xf
  jmp alltraps
801061a4:	e9 f0 f9 ff ff       	jmp    80105b99 <alltraps>

801061a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $16
801061ab:	6a 10                	push   $0x10
  jmp alltraps
801061ad:	e9 e7 f9 ff ff       	jmp    80105b99 <alltraps>

801061b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801061b2:	6a 11                	push   $0x11
  jmp alltraps
801061b4:	e9 e0 f9 ff ff       	jmp    80105b99 <alltraps>

801061b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801061b9:	6a 00                	push   $0x0
  pushl $18
801061bb:	6a 12                	push   $0x12
  jmp alltraps
801061bd:	e9 d7 f9 ff ff       	jmp    80105b99 <alltraps>

801061c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $19
801061c4:	6a 13                	push   $0x13
  jmp alltraps
801061c6:	e9 ce f9 ff ff       	jmp    80105b99 <alltraps>

801061cb <vector20>:
.globl vector20
vector20:
  pushl $0
801061cb:	6a 00                	push   $0x0
  pushl $20
801061cd:	6a 14                	push   $0x14
  jmp alltraps
801061cf:	e9 c5 f9 ff ff       	jmp    80105b99 <alltraps>

801061d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801061d4:	6a 00                	push   $0x0
  pushl $21
801061d6:	6a 15                	push   $0x15
  jmp alltraps
801061d8:	e9 bc f9 ff ff       	jmp    80105b99 <alltraps>

801061dd <vector22>:
.globl vector22
vector22:
  pushl $0
801061dd:	6a 00                	push   $0x0
  pushl $22
801061df:	6a 16                	push   $0x16
  jmp alltraps
801061e1:	e9 b3 f9 ff ff       	jmp    80105b99 <alltraps>

801061e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $23
801061e8:	6a 17                	push   $0x17
  jmp alltraps
801061ea:	e9 aa f9 ff ff       	jmp    80105b99 <alltraps>

801061ef <vector24>:
.globl vector24
vector24:
  pushl $0
801061ef:	6a 00                	push   $0x0
  pushl $24
801061f1:	6a 18                	push   $0x18
  jmp alltraps
801061f3:	e9 a1 f9 ff ff       	jmp    80105b99 <alltraps>

801061f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801061f8:	6a 00                	push   $0x0
  pushl $25
801061fa:	6a 19                	push   $0x19
  jmp alltraps
801061fc:	e9 98 f9 ff ff       	jmp    80105b99 <alltraps>

80106201 <vector26>:
.globl vector26
vector26:
  pushl $0
80106201:	6a 00                	push   $0x0
  pushl $26
80106203:	6a 1a                	push   $0x1a
  jmp alltraps
80106205:	e9 8f f9 ff ff       	jmp    80105b99 <alltraps>

8010620a <vector27>:
.globl vector27
vector27:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $27
8010620c:	6a 1b                	push   $0x1b
  jmp alltraps
8010620e:	e9 86 f9 ff ff       	jmp    80105b99 <alltraps>

80106213 <vector28>:
.globl vector28
vector28:
  pushl $0
80106213:	6a 00                	push   $0x0
  pushl $28
80106215:	6a 1c                	push   $0x1c
  jmp alltraps
80106217:	e9 7d f9 ff ff       	jmp    80105b99 <alltraps>

8010621c <vector29>:
.globl vector29
vector29:
  pushl $0
8010621c:	6a 00                	push   $0x0
  pushl $29
8010621e:	6a 1d                	push   $0x1d
  jmp alltraps
80106220:	e9 74 f9 ff ff       	jmp    80105b99 <alltraps>

80106225 <vector30>:
.globl vector30
vector30:
  pushl $0
80106225:	6a 00                	push   $0x0
  pushl $30
80106227:	6a 1e                	push   $0x1e
  jmp alltraps
80106229:	e9 6b f9 ff ff       	jmp    80105b99 <alltraps>

8010622e <vector31>:
.globl vector31
vector31:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $31
80106230:	6a 1f                	push   $0x1f
  jmp alltraps
80106232:	e9 62 f9 ff ff       	jmp    80105b99 <alltraps>

80106237 <vector32>:
.globl vector32
vector32:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $32
80106239:	6a 20                	push   $0x20
  jmp alltraps
8010623b:	e9 59 f9 ff ff       	jmp    80105b99 <alltraps>

80106240 <vector33>:
.globl vector33
vector33:
  pushl $0
80106240:	6a 00                	push   $0x0
  pushl $33
80106242:	6a 21                	push   $0x21
  jmp alltraps
80106244:	e9 50 f9 ff ff       	jmp    80105b99 <alltraps>

80106249 <vector34>:
.globl vector34
vector34:
  pushl $0
80106249:	6a 00                	push   $0x0
  pushl $34
8010624b:	6a 22                	push   $0x22
  jmp alltraps
8010624d:	e9 47 f9 ff ff       	jmp    80105b99 <alltraps>

80106252 <vector35>:
.globl vector35
vector35:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $35
80106254:	6a 23                	push   $0x23
  jmp alltraps
80106256:	e9 3e f9 ff ff       	jmp    80105b99 <alltraps>

8010625b <vector36>:
.globl vector36
vector36:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $36
8010625d:	6a 24                	push   $0x24
  jmp alltraps
8010625f:	e9 35 f9 ff ff       	jmp    80105b99 <alltraps>

80106264 <vector37>:
.globl vector37
vector37:
  pushl $0
80106264:	6a 00                	push   $0x0
  pushl $37
80106266:	6a 25                	push   $0x25
  jmp alltraps
80106268:	e9 2c f9 ff ff       	jmp    80105b99 <alltraps>

8010626d <vector38>:
.globl vector38
vector38:
  pushl $0
8010626d:	6a 00                	push   $0x0
  pushl $38
8010626f:	6a 26                	push   $0x26
  jmp alltraps
80106271:	e9 23 f9 ff ff       	jmp    80105b99 <alltraps>

80106276 <vector39>:
.globl vector39
vector39:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $39
80106278:	6a 27                	push   $0x27
  jmp alltraps
8010627a:	e9 1a f9 ff ff       	jmp    80105b99 <alltraps>

8010627f <vector40>:
.globl vector40
vector40:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $40
80106281:	6a 28                	push   $0x28
  jmp alltraps
80106283:	e9 11 f9 ff ff       	jmp    80105b99 <alltraps>

80106288 <vector41>:
.globl vector41
vector41:
  pushl $0
80106288:	6a 00                	push   $0x0
  pushl $41
8010628a:	6a 29                	push   $0x29
  jmp alltraps
8010628c:	e9 08 f9 ff ff       	jmp    80105b99 <alltraps>

80106291 <vector42>:
.globl vector42
vector42:
  pushl $0
80106291:	6a 00                	push   $0x0
  pushl $42
80106293:	6a 2a                	push   $0x2a
  jmp alltraps
80106295:	e9 ff f8 ff ff       	jmp    80105b99 <alltraps>

8010629a <vector43>:
.globl vector43
vector43:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $43
8010629c:	6a 2b                	push   $0x2b
  jmp alltraps
8010629e:	e9 f6 f8 ff ff       	jmp    80105b99 <alltraps>

801062a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $44
801062a5:	6a 2c                	push   $0x2c
  jmp alltraps
801062a7:	e9 ed f8 ff ff       	jmp    80105b99 <alltraps>

801062ac <vector45>:
.globl vector45
vector45:
  pushl $0
801062ac:	6a 00                	push   $0x0
  pushl $45
801062ae:	6a 2d                	push   $0x2d
  jmp alltraps
801062b0:	e9 e4 f8 ff ff       	jmp    80105b99 <alltraps>

801062b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801062b5:	6a 00                	push   $0x0
  pushl $46
801062b7:	6a 2e                	push   $0x2e
  jmp alltraps
801062b9:	e9 db f8 ff ff       	jmp    80105b99 <alltraps>

801062be <vector47>:
.globl vector47
vector47:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $47
801062c0:	6a 2f                	push   $0x2f
  jmp alltraps
801062c2:	e9 d2 f8 ff ff       	jmp    80105b99 <alltraps>

801062c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $48
801062c9:	6a 30                	push   $0x30
  jmp alltraps
801062cb:	e9 c9 f8 ff ff       	jmp    80105b99 <alltraps>

801062d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801062d0:	6a 00                	push   $0x0
  pushl $49
801062d2:	6a 31                	push   $0x31
  jmp alltraps
801062d4:	e9 c0 f8 ff ff       	jmp    80105b99 <alltraps>

801062d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801062d9:	6a 00                	push   $0x0
  pushl $50
801062db:	6a 32                	push   $0x32
  jmp alltraps
801062dd:	e9 b7 f8 ff ff       	jmp    80105b99 <alltraps>

801062e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $51
801062e4:	6a 33                	push   $0x33
  jmp alltraps
801062e6:	e9 ae f8 ff ff       	jmp    80105b99 <alltraps>

801062eb <vector52>:
.globl vector52
vector52:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $52
801062ed:	6a 34                	push   $0x34
  jmp alltraps
801062ef:	e9 a5 f8 ff ff       	jmp    80105b99 <alltraps>

801062f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801062f4:	6a 00                	push   $0x0
  pushl $53
801062f6:	6a 35                	push   $0x35
  jmp alltraps
801062f8:	e9 9c f8 ff ff       	jmp    80105b99 <alltraps>

801062fd <vector54>:
.globl vector54
vector54:
  pushl $0
801062fd:	6a 00                	push   $0x0
  pushl $54
801062ff:	6a 36                	push   $0x36
  jmp alltraps
80106301:	e9 93 f8 ff ff       	jmp    80105b99 <alltraps>

80106306 <vector55>:
.globl vector55
vector55:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $55
80106308:	6a 37                	push   $0x37
  jmp alltraps
8010630a:	e9 8a f8 ff ff       	jmp    80105b99 <alltraps>

8010630f <vector56>:
.globl vector56
vector56:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $56
80106311:	6a 38                	push   $0x38
  jmp alltraps
80106313:	e9 81 f8 ff ff       	jmp    80105b99 <alltraps>

80106318 <vector57>:
.globl vector57
vector57:
  pushl $0
80106318:	6a 00                	push   $0x0
  pushl $57
8010631a:	6a 39                	push   $0x39
  jmp alltraps
8010631c:	e9 78 f8 ff ff       	jmp    80105b99 <alltraps>

80106321 <vector58>:
.globl vector58
vector58:
  pushl $0
80106321:	6a 00                	push   $0x0
  pushl $58
80106323:	6a 3a                	push   $0x3a
  jmp alltraps
80106325:	e9 6f f8 ff ff       	jmp    80105b99 <alltraps>

8010632a <vector59>:
.globl vector59
vector59:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $59
8010632c:	6a 3b                	push   $0x3b
  jmp alltraps
8010632e:	e9 66 f8 ff ff       	jmp    80105b99 <alltraps>

80106333 <vector60>:
.globl vector60
vector60:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $60
80106335:	6a 3c                	push   $0x3c
  jmp alltraps
80106337:	e9 5d f8 ff ff       	jmp    80105b99 <alltraps>

8010633c <vector61>:
.globl vector61
vector61:
  pushl $0
8010633c:	6a 00                	push   $0x0
  pushl $61
8010633e:	6a 3d                	push   $0x3d
  jmp alltraps
80106340:	e9 54 f8 ff ff       	jmp    80105b99 <alltraps>

80106345 <vector62>:
.globl vector62
vector62:
  pushl $0
80106345:	6a 00                	push   $0x0
  pushl $62
80106347:	6a 3e                	push   $0x3e
  jmp alltraps
80106349:	e9 4b f8 ff ff       	jmp    80105b99 <alltraps>

8010634e <vector63>:
.globl vector63
vector63:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $63
80106350:	6a 3f                	push   $0x3f
  jmp alltraps
80106352:	e9 42 f8 ff ff       	jmp    80105b99 <alltraps>

80106357 <vector64>:
.globl vector64
vector64:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $64
80106359:	6a 40                	push   $0x40
  jmp alltraps
8010635b:	e9 39 f8 ff ff       	jmp    80105b99 <alltraps>

80106360 <vector65>:
.globl vector65
vector65:
  pushl $0
80106360:	6a 00                	push   $0x0
  pushl $65
80106362:	6a 41                	push   $0x41
  jmp alltraps
80106364:	e9 30 f8 ff ff       	jmp    80105b99 <alltraps>

80106369 <vector66>:
.globl vector66
vector66:
  pushl $0
80106369:	6a 00                	push   $0x0
  pushl $66
8010636b:	6a 42                	push   $0x42
  jmp alltraps
8010636d:	e9 27 f8 ff ff       	jmp    80105b99 <alltraps>

80106372 <vector67>:
.globl vector67
vector67:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $67
80106374:	6a 43                	push   $0x43
  jmp alltraps
80106376:	e9 1e f8 ff ff       	jmp    80105b99 <alltraps>

8010637b <vector68>:
.globl vector68
vector68:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $68
8010637d:	6a 44                	push   $0x44
  jmp alltraps
8010637f:	e9 15 f8 ff ff       	jmp    80105b99 <alltraps>

80106384 <vector69>:
.globl vector69
vector69:
  pushl $0
80106384:	6a 00                	push   $0x0
  pushl $69
80106386:	6a 45                	push   $0x45
  jmp alltraps
80106388:	e9 0c f8 ff ff       	jmp    80105b99 <alltraps>

8010638d <vector70>:
.globl vector70
vector70:
  pushl $0
8010638d:	6a 00                	push   $0x0
  pushl $70
8010638f:	6a 46                	push   $0x46
  jmp alltraps
80106391:	e9 03 f8 ff ff       	jmp    80105b99 <alltraps>

80106396 <vector71>:
.globl vector71
vector71:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $71
80106398:	6a 47                	push   $0x47
  jmp alltraps
8010639a:	e9 fa f7 ff ff       	jmp    80105b99 <alltraps>

8010639f <vector72>:
.globl vector72
vector72:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $72
801063a1:	6a 48                	push   $0x48
  jmp alltraps
801063a3:	e9 f1 f7 ff ff       	jmp    80105b99 <alltraps>

801063a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801063a8:	6a 00                	push   $0x0
  pushl $73
801063aa:	6a 49                	push   $0x49
  jmp alltraps
801063ac:	e9 e8 f7 ff ff       	jmp    80105b99 <alltraps>

801063b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801063b1:	6a 00                	push   $0x0
  pushl $74
801063b3:	6a 4a                	push   $0x4a
  jmp alltraps
801063b5:	e9 df f7 ff ff       	jmp    80105b99 <alltraps>

801063ba <vector75>:
.globl vector75
vector75:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $75
801063bc:	6a 4b                	push   $0x4b
  jmp alltraps
801063be:	e9 d6 f7 ff ff       	jmp    80105b99 <alltraps>

801063c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $76
801063c5:	6a 4c                	push   $0x4c
  jmp alltraps
801063c7:	e9 cd f7 ff ff       	jmp    80105b99 <alltraps>

801063cc <vector77>:
.globl vector77
vector77:
  pushl $0
801063cc:	6a 00                	push   $0x0
  pushl $77
801063ce:	6a 4d                	push   $0x4d
  jmp alltraps
801063d0:	e9 c4 f7 ff ff       	jmp    80105b99 <alltraps>

801063d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801063d5:	6a 00                	push   $0x0
  pushl $78
801063d7:	6a 4e                	push   $0x4e
  jmp alltraps
801063d9:	e9 bb f7 ff ff       	jmp    80105b99 <alltraps>

801063de <vector79>:
.globl vector79
vector79:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $79
801063e0:	6a 4f                	push   $0x4f
  jmp alltraps
801063e2:	e9 b2 f7 ff ff       	jmp    80105b99 <alltraps>

801063e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $80
801063e9:	6a 50                	push   $0x50
  jmp alltraps
801063eb:	e9 a9 f7 ff ff       	jmp    80105b99 <alltraps>

801063f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801063f0:	6a 00                	push   $0x0
  pushl $81
801063f2:	6a 51                	push   $0x51
  jmp alltraps
801063f4:	e9 a0 f7 ff ff       	jmp    80105b99 <alltraps>

801063f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801063f9:	6a 00                	push   $0x0
  pushl $82
801063fb:	6a 52                	push   $0x52
  jmp alltraps
801063fd:	e9 97 f7 ff ff       	jmp    80105b99 <alltraps>

80106402 <vector83>:
.globl vector83
vector83:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $83
80106404:	6a 53                	push   $0x53
  jmp alltraps
80106406:	e9 8e f7 ff ff       	jmp    80105b99 <alltraps>

8010640b <vector84>:
.globl vector84
vector84:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $84
8010640d:	6a 54                	push   $0x54
  jmp alltraps
8010640f:	e9 85 f7 ff ff       	jmp    80105b99 <alltraps>

80106414 <vector85>:
.globl vector85
vector85:
  pushl $0
80106414:	6a 00                	push   $0x0
  pushl $85
80106416:	6a 55                	push   $0x55
  jmp alltraps
80106418:	e9 7c f7 ff ff       	jmp    80105b99 <alltraps>

8010641d <vector86>:
.globl vector86
vector86:
  pushl $0
8010641d:	6a 00                	push   $0x0
  pushl $86
8010641f:	6a 56                	push   $0x56
  jmp alltraps
80106421:	e9 73 f7 ff ff       	jmp    80105b99 <alltraps>

80106426 <vector87>:
.globl vector87
vector87:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $87
80106428:	6a 57                	push   $0x57
  jmp alltraps
8010642a:	e9 6a f7 ff ff       	jmp    80105b99 <alltraps>

8010642f <vector88>:
.globl vector88
vector88:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $88
80106431:	6a 58                	push   $0x58
  jmp alltraps
80106433:	e9 61 f7 ff ff       	jmp    80105b99 <alltraps>

80106438 <vector89>:
.globl vector89
vector89:
  pushl $0
80106438:	6a 00                	push   $0x0
  pushl $89
8010643a:	6a 59                	push   $0x59
  jmp alltraps
8010643c:	e9 58 f7 ff ff       	jmp    80105b99 <alltraps>

80106441 <vector90>:
.globl vector90
vector90:
  pushl $0
80106441:	6a 00                	push   $0x0
  pushl $90
80106443:	6a 5a                	push   $0x5a
  jmp alltraps
80106445:	e9 4f f7 ff ff       	jmp    80105b99 <alltraps>

8010644a <vector91>:
.globl vector91
vector91:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $91
8010644c:	6a 5b                	push   $0x5b
  jmp alltraps
8010644e:	e9 46 f7 ff ff       	jmp    80105b99 <alltraps>

80106453 <vector92>:
.globl vector92
vector92:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $92
80106455:	6a 5c                	push   $0x5c
  jmp alltraps
80106457:	e9 3d f7 ff ff       	jmp    80105b99 <alltraps>

8010645c <vector93>:
.globl vector93
vector93:
  pushl $0
8010645c:	6a 00                	push   $0x0
  pushl $93
8010645e:	6a 5d                	push   $0x5d
  jmp alltraps
80106460:	e9 34 f7 ff ff       	jmp    80105b99 <alltraps>

80106465 <vector94>:
.globl vector94
vector94:
  pushl $0
80106465:	6a 00                	push   $0x0
  pushl $94
80106467:	6a 5e                	push   $0x5e
  jmp alltraps
80106469:	e9 2b f7 ff ff       	jmp    80105b99 <alltraps>

8010646e <vector95>:
.globl vector95
vector95:
  pushl $0
8010646e:	6a 00                	push   $0x0
  pushl $95
80106470:	6a 5f                	push   $0x5f
  jmp alltraps
80106472:	e9 22 f7 ff ff       	jmp    80105b99 <alltraps>

80106477 <vector96>:
.globl vector96
vector96:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $96
80106479:	6a 60                	push   $0x60
  jmp alltraps
8010647b:	e9 19 f7 ff ff       	jmp    80105b99 <alltraps>

80106480 <vector97>:
.globl vector97
vector97:
  pushl $0
80106480:	6a 00                	push   $0x0
  pushl $97
80106482:	6a 61                	push   $0x61
  jmp alltraps
80106484:	e9 10 f7 ff ff       	jmp    80105b99 <alltraps>

80106489 <vector98>:
.globl vector98
vector98:
  pushl $0
80106489:	6a 00                	push   $0x0
  pushl $98
8010648b:	6a 62                	push   $0x62
  jmp alltraps
8010648d:	e9 07 f7 ff ff       	jmp    80105b99 <alltraps>

80106492 <vector99>:
.globl vector99
vector99:
  pushl $0
80106492:	6a 00                	push   $0x0
  pushl $99
80106494:	6a 63                	push   $0x63
  jmp alltraps
80106496:	e9 fe f6 ff ff       	jmp    80105b99 <alltraps>

8010649b <vector100>:
.globl vector100
vector100:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $100
8010649d:	6a 64                	push   $0x64
  jmp alltraps
8010649f:	e9 f5 f6 ff ff       	jmp    80105b99 <alltraps>

801064a4 <vector101>:
.globl vector101
vector101:
  pushl $0
801064a4:	6a 00                	push   $0x0
  pushl $101
801064a6:	6a 65                	push   $0x65
  jmp alltraps
801064a8:	e9 ec f6 ff ff       	jmp    80105b99 <alltraps>

801064ad <vector102>:
.globl vector102
vector102:
  pushl $0
801064ad:	6a 00                	push   $0x0
  pushl $102
801064af:	6a 66                	push   $0x66
  jmp alltraps
801064b1:	e9 e3 f6 ff ff       	jmp    80105b99 <alltraps>

801064b6 <vector103>:
.globl vector103
vector103:
  pushl $0
801064b6:	6a 00                	push   $0x0
  pushl $103
801064b8:	6a 67                	push   $0x67
  jmp alltraps
801064ba:	e9 da f6 ff ff       	jmp    80105b99 <alltraps>

801064bf <vector104>:
.globl vector104
vector104:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $104
801064c1:	6a 68                	push   $0x68
  jmp alltraps
801064c3:	e9 d1 f6 ff ff       	jmp    80105b99 <alltraps>

801064c8 <vector105>:
.globl vector105
vector105:
  pushl $0
801064c8:	6a 00                	push   $0x0
  pushl $105
801064ca:	6a 69                	push   $0x69
  jmp alltraps
801064cc:	e9 c8 f6 ff ff       	jmp    80105b99 <alltraps>

801064d1 <vector106>:
.globl vector106
vector106:
  pushl $0
801064d1:	6a 00                	push   $0x0
  pushl $106
801064d3:	6a 6a                	push   $0x6a
  jmp alltraps
801064d5:	e9 bf f6 ff ff       	jmp    80105b99 <alltraps>

801064da <vector107>:
.globl vector107
vector107:
  pushl $0
801064da:	6a 00                	push   $0x0
  pushl $107
801064dc:	6a 6b                	push   $0x6b
  jmp alltraps
801064de:	e9 b6 f6 ff ff       	jmp    80105b99 <alltraps>

801064e3 <vector108>:
.globl vector108
vector108:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $108
801064e5:	6a 6c                	push   $0x6c
  jmp alltraps
801064e7:	e9 ad f6 ff ff       	jmp    80105b99 <alltraps>

801064ec <vector109>:
.globl vector109
vector109:
  pushl $0
801064ec:	6a 00                	push   $0x0
  pushl $109
801064ee:	6a 6d                	push   $0x6d
  jmp alltraps
801064f0:	e9 a4 f6 ff ff       	jmp    80105b99 <alltraps>

801064f5 <vector110>:
.globl vector110
vector110:
  pushl $0
801064f5:	6a 00                	push   $0x0
  pushl $110
801064f7:	6a 6e                	push   $0x6e
  jmp alltraps
801064f9:	e9 9b f6 ff ff       	jmp    80105b99 <alltraps>

801064fe <vector111>:
.globl vector111
vector111:
  pushl $0
801064fe:	6a 00                	push   $0x0
  pushl $111
80106500:	6a 6f                	push   $0x6f
  jmp alltraps
80106502:	e9 92 f6 ff ff       	jmp    80105b99 <alltraps>

80106507 <vector112>:
.globl vector112
vector112:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $112
80106509:	6a 70                	push   $0x70
  jmp alltraps
8010650b:	e9 89 f6 ff ff       	jmp    80105b99 <alltraps>

80106510 <vector113>:
.globl vector113
vector113:
  pushl $0
80106510:	6a 00                	push   $0x0
  pushl $113
80106512:	6a 71                	push   $0x71
  jmp alltraps
80106514:	e9 80 f6 ff ff       	jmp    80105b99 <alltraps>

80106519 <vector114>:
.globl vector114
vector114:
  pushl $0
80106519:	6a 00                	push   $0x0
  pushl $114
8010651b:	6a 72                	push   $0x72
  jmp alltraps
8010651d:	e9 77 f6 ff ff       	jmp    80105b99 <alltraps>

80106522 <vector115>:
.globl vector115
vector115:
  pushl $0
80106522:	6a 00                	push   $0x0
  pushl $115
80106524:	6a 73                	push   $0x73
  jmp alltraps
80106526:	e9 6e f6 ff ff       	jmp    80105b99 <alltraps>

8010652b <vector116>:
.globl vector116
vector116:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $116
8010652d:	6a 74                	push   $0x74
  jmp alltraps
8010652f:	e9 65 f6 ff ff       	jmp    80105b99 <alltraps>

80106534 <vector117>:
.globl vector117
vector117:
  pushl $0
80106534:	6a 00                	push   $0x0
  pushl $117
80106536:	6a 75                	push   $0x75
  jmp alltraps
80106538:	e9 5c f6 ff ff       	jmp    80105b99 <alltraps>

8010653d <vector118>:
.globl vector118
vector118:
  pushl $0
8010653d:	6a 00                	push   $0x0
  pushl $118
8010653f:	6a 76                	push   $0x76
  jmp alltraps
80106541:	e9 53 f6 ff ff       	jmp    80105b99 <alltraps>

80106546 <vector119>:
.globl vector119
vector119:
  pushl $0
80106546:	6a 00                	push   $0x0
  pushl $119
80106548:	6a 77                	push   $0x77
  jmp alltraps
8010654a:	e9 4a f6 ff ff       	jmp    80105b99 <alltraps>

8010654f <vector120>:
.globl vector120
vector120:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $120
80106551:	6a 78                	push   $0x78
  jmp alltraps
80106553:	e9 41 f6 ff ff       	jmp    80105b99 <alltraps>

80106558 <vector121>:
.globl vector121
vector121:
  pushl $0
80106558:	6a 00                	push   $0x0
  pushl $121
8010655a:	6a 79                	push   $0x79
  jmp alltraps
8010655c:	e9 38 f6 ff ff       	jmp    80105b99 <alltraps>

80106561 <vector122>:
.globl vector122
vector122:
  pushl $0
80106561:	6a 00                	push   $0x0
  pushl $122
80106563:	6a 7a                	push   $0x7a
  jmp alltraps
80106565:	e9 2f f6 ff ff       	jmp    80105b99 <alltraps>

8010656a <vector123>:
.globl vector123
vector123:
  pushl $0
8010656a:	6a 00                	push   $0x0
  pushl $123
8010656c:	6a 7b                	push   $0x7b
  jmp alltraps
8010656e:	e9 26 f6 ff ff       	jmp    80105b99 <alltraps>

80106573 <vector124>:
.globl vector124
vector124:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $124
80106575:	6a 7c                	push   $0x7c
  jmp alltraps
80106577:	e9 1d f6 ff ff       	jmp    80105b99 <alltraps>

8010657c <vector125>:
.globl vector125
vector125:
  pushl $0
8010657c:	6a 00                	push   $0x0
  pushl $125
8010657e:	6a 7d                	push   $0x7d
  jmp alltraps
80106580:	e9 14 f6 ff ff       	jmp    80105b99 <alltraps>

80106585 <vector126>:
.globl vector126
vector126:
  pushl $0
80106585:	6a 00                	push   $0x0
  pushl $126
80106587:	6a 7e                	push   $0x7e
  jmp alltraps
80106589:	e9 0b f6 ff ff       	jmp    80105b99 <alltraps>

8010658e <vector127>:
.globl vector127
vector127:
  pushl $0
8010658e:	6a 00                	push   $0x0
  pushl $127
80106590:	6a 7f                	push   $0x7f
  jmp alltraps
80106592:	e9 02 f6 ff ff       	jmp    80105b99 <alltraps>

80106597 <vector128>:
.globl vector128
vector128:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $128
80106599:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010659e:	e9 f6 f5 ff ff       	jmp    80105b99 <alltraps>

801065a3 <vector129>:
.globl vector129
vector129:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $129
801065a5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801065aa:	e9 ea f5 ff ff       	jmp    80105b99 <alltraps>

801065af <vector130>:
.globl vector130
vector130:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $130
801065b1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801065b6:	e9 de f5 ff ff       	jmp    80105b99 <alltraps>

801065bb <vector131>:
.globl vector131
vector131:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $131
801065bd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801065c2:	e9 d2 f5 ff ff       	jmp    80105b99 <alltraps>

801065c7 <vector132>:
.globl vector132
vector132:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $132
801065c9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801065ce:	e9 c6 f5 ff ff       	jmp    80105b99 <alltraps>

801065d3 <vector133>:
.globl vector133
vector133:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $133
801065d5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065da:	e9 ba f5 ff ff       	jmp    80105b99 <alltraps>

801065df <vector134>:
.globl vector134
vector134:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $134
801065e1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801065e6:	e9 ae f5 ff ff       	jmp    80105b99 <alltraps>

801065eb <vector135>:
.globl vector135
vector135:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $135
801065ed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801065f2:	e9 a2 f5 ff ff       	jmp    80105b99 <alltraps>

801065f7 <vector136>:
.globl vector136
vector136:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $136
801065f9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801065fe:	e9 96 f5 ff ff       	jmp    80105b99 <alltraps>

80106603 <vector137>:
.globl vector137
vector137:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $137
80106605:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010660a:	e9 8a f5 ff ff       	jmp    80105b99 <alltraps>

8010660f <vector138>:
.globl vector138
vector138:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $138
80106611:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106616:	e9 7e f5 ff ff       	jmp    80105b99 <alltraps>

8010661b <vector139>:
.globl vector139
vector139:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $139
8010661d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106622:	e9 72 f5 ff ff       	jmp    80105b99 <alltraps>

80106627 <vector140>:
.globl vector140
vector140:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $140
80106629:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010662e:	e9 66 f5 ff ff       	jmp    80105b99 <alltraps>

80106633 <vector141>:
.globl vector141
vector141:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $141
80106635:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010663a:	e9 5a f5 ff ff       	jmp    80105b99 <alltraps>

8010663f <vector142>:
.globl vector142
vector142:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $142
80106641:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106646:	e9 4e f5 ff ff       	jmp    80105b99 <alltraps>

8010664b <vector143>:
.globl vector143
vector143:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $143
8010664d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106652:	e9 42 f5 ff ff       	jmp    80105b99 <alltraps>

80106657 <vector144>:
.globl vector144
vector144:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $144
80106659:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010665e:	e9 36 f5 ff ff       	jmp    80105b99 <alltraps>

80106663 <vector145>:
.globl vector145
vector145:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $145
80106665:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010666a:	e9 2a f5 ff ff       	jmp    80105b99 <alltraps>

8010666f <vector146>:
.globl vector146
vector146:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $146
80106671:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106676:	e9 1e f5 ff ff       	jmp    80105b99 <alltraps>

8010667b <vector147>:
.globl vector147
vector147:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $147
8010667d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106682:	e9 12 f5 ff ff       	jmp    80105b99 <alltraps>

80106687 <vector148>:
.globl vector148
vector148:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $148
80106689:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010668e:	e9 06 f5 ff ff       	jmp    80105b99 <alltraps>

80106693 <vector149>:
.globl vector149
vector149:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $149
80106695:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010669a:	e9 fa f4 ff ff       	jmp    80105b99 <alltraps>

8010669f <vector150>:
.globl vector150
vector150:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $150
801066a1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801066a6:	e9 ee f4 ff ff       	jmp    80105b99 <alltraps>

801066ab <vector151>:
.globl vector151
vector151:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $151
801066ad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801066b2:	e9 e2 f4 ff ff       	jmp    80105b99 <alltraps>

801066b7 <vector152>:
.globl vector152
vector152:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $152
801066b9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801066be:	e9 d6 f4 ff ff       	jmp    80105b99 <alltraps>

801066c3 <vector153>:
.globl vector153
vector153:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $153
801066c5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801066ca:	e9 ca f4 ff ff       	jmp    80105b99 <alltraps>

801066cf <vector154>:
.globl vector154
vector154:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $154
801066d1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066d6:	e9 be f4 ff ff       	jmp    80105b99 <alltraps>

801066db <vector155>:
.globl vector155
vector155:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $155
801066dd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801066e2:	e9 b2 f4 ff ff       	jmp    80105b99 <alltraps>

801066e7 <vector156>:
.globl vector156
vector156:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $156
801066e9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801066ee:	e9 a6 f4 ff ff       	jmp    80105b99 <alltraps>

801066f3 <vector157>:
.globl vector157
vector157:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $157
801066f5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801066fa:	e9 9a f4 ff ff       	jmp    80105b99 <alltraps>

801066ff <vector158>:
.globl vector158
vector158:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $158
80106701:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106706:	e9 8e f4 ff ff       	jmp    80105b99 <alltraps>

8010670b <vector159>:
.globl vector159
vector159:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $159
8010670d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106712:	e9 82 f4 ff ff       	jmp    80105b99 <alltraps>

80106717 <vector160>:
.globl vector160
vector160:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $160
80106719:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010671e:	e9 76 f4 ff ff       	jmp    80105b99 <alltraps>

80106723 <vector161>:
.globl vector161
vector161:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $161
80106725:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010672a:	e9 6a f4 ff ff       	jmp    80105b99 <alltraps>

8010672f <vector162>:
.globl vector162
vector162:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $162
80106731:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106736:	e9 5e f4 ff ff       	jmp    80105b99 <alltraps>

8010673b <vector163>:
.globl vector163
vector163:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $163
8010673d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106742:	e9 52 f4 ff ff       	jmp    80105b99 <alltraps>

80106747 <vector164>:
.globl vector164
vector164:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $164
80106749:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010674e:	e9 46 f4 ff ff       	jmp    80105b99 <alltraps>

80106753 <vector165>:
.globl vector165
vector165:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $165
80106755:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010675a:	e9 3a f4 ff ff       	jmp    80105b99 <alltraps>

8010675f <vector166>:
.globl vector166
vector166:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $166
80106761:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106766:	e9 2e f4 ff ff       	jmp    80105b99 <alltraps>

8010676b <vector167>:
.globl vector167
vector167:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $167
8010676d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106772:	e9 22 f4 ff ff       	jmp    80105b99 <alltraps>

80106777 <vector168>:
.globl vector168
vector168:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $168
80106779:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010677e:	e9 16 f4 ff ff       	jmp    80105b99 <alltraps>

80106783 <vector169>:
.globl vector169
vector169:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $169
80106785:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010678a:	e9 0a f4 ff ff       	jmp    80105b99 <alltraps>

8010678f <vector170>:
.globl vector170
vector170:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $170
80106791:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106796:	e9 fe f3 ff ff       	jmp    80105b99 <alltraps>

8010679b <vector171>:
.globl vector171
vector171:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $171
8010679d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801067a2:	e9 f2 f3 ff ff       	jmp    80105b99 <alltraps>

801067a7 <vector172>:
.globl vector172
vector172:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $172
801067a9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801067ae:	e9 e6 f3 ff ff       	jmp    80105b99 <alltraps>

801067b3 <vector173>:
.globl vector173
vector173:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $173
801067b5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801067ba:	e9 da f3 ff ff       	jmp    80105b99 <alltraps>

801067bf <vector174>:
.globl vector174
vector174:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $174
801067c1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801067c6:	e9 ce f3 ff ff       	jmp    80105b99 <alltraps>

801067cb <vector175>:
.globl vector175
vector175:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $175
801067cd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067d2:	e9 c2 f3 ff ff       	jmp    80105b99 <alltraps>

801067d7 <vector176>:
.globl vector176
vector176:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $176
801067d9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067de:	e9 b6 f3 ff ff       	jmp    80105b99 <alltraps>

801067e3 <vector177>:
.globl vector177
vector177:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $177
801067e5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801067ea:	e9 aa f3 ff ff       	jmp    80105b99 <alltraps>

801067ef <vector178>:
.globl vector178
vector178:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $178
801067f1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801067f6:	e9 9e f3 ff ff       	jmp    80105b99 <alltraps>

801067fb <vector179>:
.globl vector179
vector179:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $179
801067fd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106802:	e9 92 f3 ff ff       	jmp    80105b99 <alltraps>

80106807 <vector180>:
.globl vector180
vector180:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $180
80106809:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010680e:	e9 86 f3 ff ff       	jmp    80105b99 <alltraps>

80106813 <vector181>:
.globl vector181
vector181:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $181
80106815:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010681a:	e9 7a f3 ff ff       	jmp    80105b99 <alltraps>

8010681f <vector182>:
.globl vector182
vector182:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $182
80106821:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106826:	e9 6e f3 ff ff       	jmp    80105b99 <alltraps>

8010682b <vector183>:
.globl vector183
vector183:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $183
8010682d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106832:	e9 62 f3 ff ff       	jmp    80105b99 <alltraps>

80106837 <vector184>:
.globl vector184
vector184:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $184
80106839:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010683e:	e9 56 f3 ff ff       	jmp    80105b99 <alltraps>

80106843 <vector185>:
.globl vector185
vector185:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $185
80106845:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010684a:	e9 4a f3 ff ff       	jmp    80105b99 <alltraps>

8010684f <vector186>:
.globl vector186
vector186:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $186
80106851:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106856:	e9 3e f3 ff ff       	jmp    80105b99 <alltraps>

8010685b <vector187>:
.globl vector187
vector187:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $187
8010685d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106862:	e9 32 f3 ff ff       	jmp    80105b99 <alltraps>

80106867 <vector188>:
.globl vector188
vector188:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $188
80106869:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010686e:	e9 26 f3 ff ff       	jmp    80105b99 <alltraps>

80106873 <vector189>:
.globl vector189
vector189:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $189
80106875:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010687a:	e9 1a f3 ff ff       	jmp    80105b99 <alltraps>

8010687f <vector190>:
.globl vector190
vector190:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $190
80106881:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106886:	e9 0e f3 ff ff       	jmp    80105b99 <alltraps>

8010688b <vector191>:
.globl vector191
vector191:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $191
8010688d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106892:	e9 02 f3 ff ff       	jmp    80105b99 <alltraps>

80106897 <vector192>:
.globl vector192
vector192:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $192
80106899:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010689e:	e9 f6 f2 ff ff       	jmp    80105b99 <alltraps>

801068a3 <vector193>:
.globl vector193
vector193:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $193
801068a5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801068aa:	e9 ea f2 ff ff       	jmp    80105b99 <alltraps>

801068af <vector194>:
.globl vector194
vector194:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $194
801068b1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801068b6:	e9 de f2 ff ff       	jmp    80105b99 <alltraps>

801068bb <vector195>:
.globl vector195
vector195:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $195
801068bd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801068c2:	e9 d2 f2 ff ff       	jmp    80105b99 <alltraps>

801068c7 <vector196>:
.globl vector196
vector196:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $196
801068c9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801068ce:	e9 c6 f2 ff ff       	jmp    80105b99 <alltraps>

801068d3 <vector197>:
.globl vector197
vector197:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $197
801068d5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068da:	e9 ba f2 ff ff       	jmp    80105b99 <alltraps>

801068df <vector198>:
.globl vector198
vector198:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $198
801068e1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801068e6:	e9 ae f2 ff ff       	jmp    80105b99 <alltraps>

801068eb <vector199>:
.globl vector199
vector199:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $199
801068ed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801068f2:	e9 a2 f2 ff ff       	jmp    80105b99 <alltraps>

801068f7 <vector200>:
.globl vector200
vector200:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $200
801068f9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801068fe:	e9 96 f2 ff ff       	jmp    80105b99 <alltraps>

80106903 <vector201>:
.globl vector201
vector201:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $201
80106905:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010690a:	e9 8a f2 ff ff       	jmp    80105b99 <alltraps>

8010690f <vector202>:
.globl vector202
vector202:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $202
80106911:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106916:	e9 7e f2 ff ff       	jmp    80105b99 <alltraps>

8010691b <vector203>:
.globl vector203
vector203:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $203
8010691d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106922:	e9 72 f2 ff ff       	jmp    80105b99 <alltraps>

80106927 <vector204>:
.globl vector204
vector204:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $204
80106929:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010692e:	e9 66 f2 ff ff       	jmp    80105b99 <alltraps>

80106933 <vector205>:
.globl vector205
vector205:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $205
80106935:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010693a:	e9 5a f2 ff ff       	jmp    80105b99 <alltraps>

8010693f <vector206>:
.globl vector206
vector206:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $206
80106941:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106946:	e9 4e f2 ff ff       	jmp    80105b99 <alltraps>

8010694b <vector207>:
.globl vector207
vector207:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $207
8010694d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106952:	e9 42 f2 ff ff       	jmp    80105b99 <alltraps>

80106957 <vector208>:
.globl vector208
vector208:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $208
80106959:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010695e:	e9 36 f2 ff ff       	jmp    80105b99 <alltraps>

80106963 <vector209>:
.globl vector209
vector209:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $209
80106965:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010696a:	e9 2a f2 ff ff       	jmp    80105b99 <alltraps>

8010696f <vector210>:
.globl vector210
vector210:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $210
80106971:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106976:	e9 1e f2 ff ff       	jmp    80105b99 <alltraps>

8010697b <vector211>:
.globl vector211
vector211:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $211
8010697d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106982:	e9 12 f2 ff ff       	jmp    80105b99 <alltraps>

80106987 <vector212>:
.globl vector212
vector212:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $212
80106989:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010698e:	e9 06 f2 ff ff       	jmp    80105b99 <alltraps>

80106993 <vector213>:
.globl vector213
vector213:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $213
80106995:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010699a:	e9 fa f1 ff ff       	jmp    80105b99 <alltraps>

8010699f <vector214>:
.globl vector214
vector214:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $214
801069a1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801069a6:	e9 ee f1 ff ff       	jmp    80105b99 <alltraps>

801069ab <vector215>:
.globl vector215
vector215:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $215
801069ad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801069b2:	e9 e2 f1 ff ff       	jmp    80105b99 <alltraps>

801069b7 <vector216>:
.globl vector216
vector216:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $216
801069b9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801069be:	e9 d6 f1 ff ff       	jmp    80105b99 <alltraps>

801069c3 <vector217>:
.globl vector217
vector217:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $217
801069c5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801069ca:	e9 ca f1 ff ff       	jmp    80105b99 <alltraps>

801069cf <vector218>:
.globl vector218
vector218:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $218
801069d1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069d6:	e9 be f1 ff ff       	jmp    80105b99 <alltraps>

801069db <vector219>:
.globl vector219
vector219:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $219
801069dd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801069e2:	e9 b2 f1 ff ff       	jmp    80105b99 <alltraps>

801069e7 <vector220>:
.globl vector220
vector220:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $220
801069e9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801069ee:	e9 a6 f1 ff ff       	jmp    80105b99 <alltraps>

801069f3 <vector221>:
.globl vector221
vector221:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $221
801069f5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801069fa:	e9 9a f1 ff ff       	jmp    80105b99 <alltraps>

801069ff <vector222>:
.globl vector222
vector222:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $222
80106a01:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a06:	e9 8e f1 ff ff       	jmp    80105b99 <alltraps>

80106a0b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $223
80106a0d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a12:	e9 82 f1 ff ff       	jmp    80105b99 <alltraps>

80106a17 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $224
80106a19:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a1e:	e9 76 f1 ff ff       	jmp    80105b99 <alltraps>

80106a23 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $225
80106a25:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a2a:	e9 6a f1 ff ff       	jmp    80105b99 <alltraps>

80106a2f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $226
80106a31:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a36:	e9 5e f1 ff ff       	jmp    80105b99 <alltraps>

80106a3b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $227
80106a3d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a42:	e9 52 f1 ff ff       	jmp    80105b99 <alltraps>

80106a47 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $228
80106a49:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a4e:	e9 46 f1 ff ff       	jmp    80105b99 <alltraps>

80106a53 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $229
80106a55:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a5a:	e9 3a f1 ff ff       	jmp    80105b99 <alltraps>

80106a5f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $230
80106a61:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a66:	e9 2e f1 ff ff       	jmp    80105b99 <alltraps>

80106a6b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $231
80106a6d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a72:	e9 22 f1 ff ff       	jmp    80105b99 <alltraps>

80106a77 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $232
80106a79:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a7e:	e9 16 f1 ff ff       	jmp    80105b99 <alltraps>

80106a83 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $233
80106a85:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a8a:	e9 0a f1 ff ff       	jmp    80105b99 <alltraps>

80106a8f <vector234>:
.globl vector234
vector234:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $234
80106a91:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a96:	e9 fe f0 ff ff       	jmp    80105b99 <alltraps>

80106a9b <vector235>:
.globl vector235
vector235:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $235
80106a9d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106aa2:	e9 f2 f0 ff ff       	jmp    80105b99 <alltraps>

80106aa7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $236
80106aa9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106aae:	e9 e6 f0 ff ff       	jmp    80105b99 <alltraps>

80106ab3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $237
80106ab5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106aba:	e9 da f0 ff ff       	jmp    80105b99 <alltraps>

80106abf <vector238>:
.globl vector238
vector238:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $238
80106ac1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ac6:	e9 ce f0 ff ff       	jmp    80105b99 <alltraps>

80106acb <vector239>:
.globl vector239
vector239:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $239
80106acd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ad2:	e9 c2 f0 ff ff       	jmp    80105b99 <alltraps>

80106ad7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $240
80106ad9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106ade:	e9 b6 f0 ff ff       	jmp    80105b99 <alltraps>

80106ae3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $241
80106ae5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106aea:	e9 aa f0 ff ff       	jmp    80105b99 <alltraps>

80106aef <vector242>:
.globl vector242
vector242:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $242
80106af1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106af6:	e9 9e f0 ff ff       	jmp    80105b99 <alltraps>

80106afb <vector243>:
.globl vector243
vector243:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $243
80106afd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b02:	e9 92 f0 ff ff       	jmp    80105b99 <alltraps>

80106b07 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $244
80106b09:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b0e:	e9 86 f0 ff ff       	jmp    80105b99 <alltraps>

80106b13 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $245
80106b15:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b1a:	e9 7a f0 ff ff       	jmp    80105b99 <alltraps>

80106b1f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $246
80106b21:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b26:	e9 6e f0 ff ff       	jmp    80105b99 <alltraps>

80106b2b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $247
80106b2d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b32:	e9 62 f0 ff ff       	jmp    80105b99 <alltraps>

80106b37 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $248
80106b39:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b3e:	e9 56 f0 ff ff       	jmp    80105b99 <alltraps>

80106b43 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $249
80106b45:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b4a:	e9 4a f0 ff ff       	jmp    80105b99 <alltraps>

80106b4f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $250
80106b51:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b56:	e9 3e f0 ff ff       	jmp    80105b99 <alltraps>

80106b5b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $251
80106b5d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b62:	e9 32 f0 ff ff       	jmp    80105b99 <alltraps>

80106b67 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $252
80106b69:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b6e:	e9 26 f0 ff ff       	jmp    80105b99 <alltraps>

80106b73 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $253
80106b75:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b7a:	e9 1a f0 ff ff       	jmp    80105b99 <alltraps>

80106b7f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $254
80106b81:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b86:	e9 0e f0 ff ff       	jmp    80105b99 <alltraps>

80106b8b <vector255>:
.globl vector255
vector255:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $255
80106b8d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b92:	e9 02 f0 ff ff       	jmp    80105b99 <alltraps>
80106b97:	66 90                	xchg   %ax,%ax
80106b99:	66 90                	xchg   %ax,%ax
80106b9b:	66 90                	xchg   %ax,%ax
80106b9d:	66 90                	xchg   %ax,%ax
80106b9f:	90                   	nop

80106ba0 <cow_kfree>:
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc);
int swap_in(struct proc* p, struct pageinfo* pi);
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir);

void cow_kfree(char* to_free_kva){
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	56                   	push   %esi
80106ba4:	53                   	push   %ebx
80106ba5:	8b 75 08             	mov    0x8(%ebp),%esi
  char count;
  int acq = 0;
  if (lapicid() != 0){
80106ba8:	e8 33 c0 ff ff       	call   80102be0 <lapicid>
80106bad:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
80106bb3:	c1 eb 0c             	shr    $0xc,%ebx
80106bb6:	85 c0                	test   %eax,%eax
80106bb8:	75 16                	jne    80106bd0 <cow_kfree+0x30>
    acquire(cow_lock);
  }
  // struct proc* p = myproc();
  // if (p != 0 ){ // && p->pid > 2
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
  if (count != 0){
80106bba:	80 ab 40 0f 11 80 01 	subb   $0x1,-0x7feef0c0(%ebx)
80106bc1:	74 43                	je     80106c06 <cow_kfree+0x66>
  if (acq){
    // cprintf("rel kfree %d\n", myproc()->pid);
    release(cow_lock);
  }
  kfree(to_free_kva);
}
80106bc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106bc6:	5b                   	pop    %ebx
80106bc7:	5e                   	pop    %esi
80106bc8:	5d                   	pop    %ebp
80106bc9:	c3                   	ret    
80106bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(cow_lock);
80106bd0:	83 ec 0c             	sub    $0xc,%esp
80106bd3:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106bd9:	e8 82 dc ff ff       	call   80104860 <acquire>
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
80106bde:	0f b6 83 40 0f 11 80 	movzbl -0x7feef0c0(%ebx),%eax
  if (count != 0){
80106be5:	83 c4 10             	add    $0x10,%esp
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
80106be8:	83 e8 01             	sub    $0x1,%eax
  if (count != 0){
80106beb:	84 c0                	test   %al,%al
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
80106bed:	88 83 40 0f 11 80    	mov    %al,-0x7feef0c0(%ebx)
  if (count != 0){
80106bf3:	75 23                	jne    80106c18 <cow_kfree+0x78>
    release(cow_lock);
80106bf5:	83 ec 0c             	sub    $0xc,%esp
80106bf8:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106bfe:	e8 1d dd ff ff       	call   80104920 <release>
80106c03:	83 c4 10             	add    $0x10,%esp
  kfree(to_free_kva);
80106c06:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106c09:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106c0c:	5b                   	pop    %ebx
80106c0d:	5e                   	pop    %esi
80106c0e:	5d                   	pop    %ebp
  kfree(to_free_kva);
80106c0f:	e9 7c bb ff ff       	jmp    80102790 <kfree>
80106c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(cow_lock);
80106c18:	a1 40 ef 11 80       	mov    0x8011ef40,%eax
80106c1d:	89 45 08             	mov    %eax,0x8(%ebp)
}
80106c20:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106c23:	5b                   	pop    %ebx
80106c24:	5e                   	pop    %esi
80106c25:	5d                   	pop    %ebp
      release(cow_lock);
80106c26:	e9 f5 dc ff ff       	jmp    80104920 <release>
80106c2b:	90                   	nop
80106c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c30 <cow_kalloc>:

char* cow_kalloc(){
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	57                   	push   %edi
80106c34:	56                   	push   %esi
80106c35:	53                   	push   %ebx
80106c36:	83 ec 0c             	sub    $0xc,%esp
  char* r = kalloc();
80106c39:	e8 32 bd ff ff       	call   80102970 <kalloc>
  if (r == 0){
80106c3e:	85 c0                	test   %eax,%eax
  char* r = kalloc();
80106c40:	89 c3                	mov    %eax,%ebx
  if (r == 0){
80106c42:	74 28                	je     80106c6c <cow_kalloc+0x3c>
80106c44:	8d bb 00 00 00 80    	lea    -0x80000000(%ebx),%edi
    return r;
  }
  int acq = 0;
  // cprintf("kalloc \n");
  if (lapicid() != 0){
80106c4a:	e8 91 bf ff ff       	call   80102be0 <lapicid>
80106c4f:	89 fe                	mov    %edi,%esi
80106c51:	c1 ee 0c             	shr    $0xc,%esi
80106c54:	85 c0                	test   %eax,%eax
80106c56:	75 28                	jne    80106c80 <cow_kalloc+0x50>
    acq = 1;
    // cprintf("kalloc %d\n", myproc()->pid);
    acquire(cow_lock);
  }
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
80106c58:	0f b6 86 40 0f 11 80 	movzbl -0x7feef0c0(%esi),%eax
80106c5f:	8d 50 01             	lea    0x1(%eax),%edx
80106c62:	84 c0                	test   %al,%al
80106c64:	88 96 40 0f 11 80    	mov    %dl,-0x7feef0c0(%esi)
80106c6a:	75 54                	jne    80106cc0 <cow_kalloc+0x90>
  }
  if (acq){
    release(cow_lock);
  }
  return r;
}
80106c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c6f:	89 d8                	mov    %ebx,%eax
80106c71:	5b                   	pop    %ebx
80106c72:	5e                   	pop    %esi
80106c73:	5f                   	pop    %edi
80106c74:	5d                   	pop    %ebp
80106c75:	c3                   	ret    
80106c76:	8d 76 00             	lea    0x0(%esi),%esi
80106c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    acquire(cow_lock);
80106c80:	83 ec 0c             	sub    $0xc,%esp
80106c83:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106c89:	e8 d2 db ff ff       	call   80104860 <acquire>
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
80106c8e:	0f b6 86 40 0f 11 80 	movzbl -0x7feef0c0(%esi),%eax
80106c95:	83 c4 10             	add    $0x10,%esp
80106c98:	8d 50 01             	lea    0x1(%eax),%edx
80106c9b:	84 c0                	test   %al,%al
80106c9d:	88 96 40 0f 11 80    	mov    %dl,-0x7feef0c0(%esi)
80106ca3:	75 1b                	jne    80106cc0 <cow_kalloc+0x90>
      release(cow_lock);
80106ca5:	83 ec 0c             	sub    $0xc,%esp
80106ca8:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106cae:	e8 6d dc ff ff       	call   80104920 <release>
80106cb3:	83 c4 10             	add    $0x10,%esp
}
80106cb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cb9:	89 d8                	mov    %ebx,%eax
80106cbb:	5b                   	pop    %ebx
80106cbc:	5e                   	pop    %esi
80106cbd:	5f                   	pop    %edi
80106cbe:	5d                   	pop    %ebp
80106cbf:	c3                   	ret    
    cprintf("actual ref count = %d, pg index = %x, pg pa = %x\n", pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE] - 1, PGROUNDDOWN(V2P(r)) / PGSIZE, V2P(r));
80106cc0:	0f be c2             	movsbl %dl,%eax
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	83 e8 01             	sub    $0x1,%eax
80106cc8:	50                   	push   %eax
80106cc9:	68 3c 81 10 80       	push   $0x8010813c
80106cce:	e8 8d 99 ff ff       	call   80100660 <cprintf>
    panic("kalloc allocated something with a reference");
80106cd3:	c7 04 24 70 81 10 80 	movl   $0x80108170,(%esp)
80106cda:	e8 b1 96 ff ff       	call   80100390 <panic>
80106cdf:	90                   	nop

80106ce0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	57                   	push   %edi
80106ce4:	56                   	push   %esi
80106ce5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ce6:	89 d3                	mov    %edx,%ebx
{
80106ce8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106cea:	c1 eb 16             	shr    $0x16,%ebx
80106ced:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106cf0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106cf3:	8b 06                	mov    (%esi),%eax
80106cf5:	a8 01                	test   $0x1,%al
80106cf7:	74 27                	je     80106d20 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cf9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cfe:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106d04:	c1 ef 0a             	shr    $0xa,%edi
}
80106d07:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106d0a:	89 fa                	mov    %edi,%edx
80106d0c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106d12:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106d15:	5b                   	pop    %ebx
80106d16:	5e                   	pop    %esi
80106d17:	5f                   	pop    %edi
80106d18:	5d                   	pop    %ebp
80106d19:	c3                   	ret    
80106d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)cow_kalloc()) == 0)
80106d20:	85 c9                	test   %ecx,%ecx
80106d22:	74 2c                	je     80106d50 <walkpgdir+0x70>
80106d24:	e8 07 ff ff ff       	call   80106c30 <cow_kalloc>
80106d29:	85 c0                	test   %eax,%eax
80106d2b:	89 c3                	mov    %eax,%ebx
80106d2d:	74 21                	je     80106d50 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106d2f:	83 ec 04             	sub    $0x4,%esp
80106d32:	68 00 10 00 00       	push   $0x1000
80106d37:	6a 00                	push   $0x0
80106d39:	50                   	push   %eax
80106d3a:	e8 31 dc ff ff       	call   80104970 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d3f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d45:	83 c4 10             	add    $0x10,%esp
80106d48:	83 c8 07             	or     $0x7,%eax
80106d4b:	89 06                	mov    %eax,(%esi)
80106d4d:	eb b5                	jmp    80106d04 <walkpgdir+0x24>
80106d4f:	90                   	nop
}
80106d50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106d53:	31 c0                	xor    %eax,%eax
}
80106d55:	5b                   	pop    %ebx
80106d56:	5e                   	pop    %esi
80106d57:	5f                   	pop    %edi
80106d58:	5d                   	pop    %ebp
80106d59:	c3                   	ret    
80106d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d60 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	56                   	push   %esi
80106d65:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106d66:	89 d3                	mov    %edx,%ebx
80106d68:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106d6e:	83 ec 1c             	sub    $0x1c,%esp
80106d71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d74:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d78:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d80:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d83:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d86:	29 df                	sub    %ebx,%edi
80106d88:	83 c8 01             	or     $0x1,%eax
80106d8b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d8e:	eb 15                	jmp    80106da5 <mappages+0x45>
    if(*pte & PTE_P)
80106d90:	f6 00 01             	testb  $0x1,(%eax)
80106d93:	75 45                	jne    80106dda <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106d95:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106d98:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106d9b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d9d:	74 31                	je     80106dd0 <mappages+0x70>
      break;
    a += PGSIZE;
80106d9f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106da5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106da8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106dad:	89 da                	mov    %ebx,%edx
80106daf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106db2:	e8 29 ff ff ff       	call   80106ce0 <walkpgdir>
80106db7:	85 c0                	test   %eax,%eax
80106db9:	75 d5                	jne    80106d90 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106dbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106dbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106dc3:	5b                   	pop    %ebx
80106dc4:	5e                   	pop    %esi
80106dc5:	5f                   	pop    %edi
80106dc6:	5d                   	pop    %ebp
80106dc7:	c3                   	ret    
80106dc8:	90                   	nop
80106dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106dd3:	31 c0                	xor    %eax,%eax
}
80106dd5:	5b                   	pop    %ebx
80106dd6:	5e                   	pop    %esi
80106dd7:	5f                   	pop    %edi
80106dd8:	5d                   	pop    %ebp
80106dd9:	c3                   	ret    
      panic("remap");
80106dda:	83 ec 0c             	sub    $0xc,%esp
80106ddd:	68 c0 81 10 80       	push   $0x801081c0
80106de2:	e8 a9 95 ff ff       	call   80100390 <panic>
80106de7:	89 f6                	mov    %esi,%esi
80106de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106df0 <deallocuvm.part.2>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
  #endif
  
  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106df6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106dfc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106dfe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e04:	83 ec 1c             	sub    $0x1c,%esp
80106e07:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106e0a:	39 d3                	cmp    %edx,%ebx
80106e0c:	73 66                	jae    80106e74 <deallocuvm.part.2+0x84>
80106e0e:	89 d6                	mov    %edx,%esi
80106e10:	eb 3d                	jmp    80106e4f <deallocuvm.part.2+0x5f>
80106e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106e18:	8b 10                	mov    (%eax),%edx
80106e1a:	f6 c2 01             	test   $0x1,%dl
80106e1d:	74 26                	je     80106e45 <deallocuvm.part.2+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106e1f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106e25:	74 58                	je     80106e7f <deallocuvm.part.2+0x8f>
        panic("cow_kfree");
      char *v = P2V(pa);
      cow_kfree(v);
80106e27:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106e2a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106e30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      cow_kfree(v);
80106e33:	52                   	push   %edx
80106e34:	e8 67 fd ff ff       	call   80106ba0 <cow_kfree>
            break;
          }
        }
      }
      #endif
      *pte = 0;
80106e39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e3c:	83 c4 10             	add    $0x10,%esp
80106e3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106e45:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e4b:	39 f3                	cmp    %esi,%ebx
80106e4d:	73 25                	jae    80106e74 <deallocuvm.part.2+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106e4f:	31 c9                	xor    %ecx,%ecx
80106e51:	89 da                	mov    %ebx,%edx
80106e53:	89 f8                	mov    %edi,%eax
80106e55:	e8 86 fe ff ff       	call   80106ce0 <walkpgdir>
    if(!pte)
80106e5a:	85 c0                	test   %eax,%eax
80106e5c:	75 ba                	jne    80106e18 <deallocuvm.part.2+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106e5e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106e64:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106e6a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e70:	39 f3                	cmp    %esi,%ebx
80106e72:	72 db                	jb     80106e4f <deallocuvm.part.2+0x5f>
    }
  }

  return newsz;
}
80106e74:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e7a:	5b                   	pop    %ebx
80106e7b:	5e                   	pop    %esi
80106e7c:	5f                   	pop    %edi
80106e7d:	5d                   	pop    %ebp
80106e7e:	c3                   	ret    
        panic("cow_kfree");
80106e7f:	83 ec 0c             	sub    $0xc,%esp
80106e82:	68 c6 81 10 80       	push   $0x801081c6
80106e87:	e8 04 95 ff ff       	call   80100390 <panic>
80106e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e90 <seginit>:
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e96:	e8 e5 cd ff ff       	call   80103c80 <cpuid>
80106e9b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106ea1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106ea6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106eaa:	c7 80 78 18 12 80 ff 	movl   $0xffff,-0x7fede788(%eax)
80106eb1:	ff 00 00 
80106eb4:	c7 80 7c 18 12 80 00 	movl   $0xcf9a00,-0x7fede784(%eax)
80106ebb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ebe:	c7 80 80 18 12 80 ff 	movl   $0xffff,-0x7fede780(%eax)
80106ec5:	ff 00 00 
80106ec8:	c7 80 84 18 12 80 00 	movl   $0xcf9200,-0x7fede77c(%eax)
80106ecf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ed2:	c7 80 88 18 12 80 ff 	movl   $0xffff,-0x7fede778(%eax)
80106ed9:	ff 00 00 
80106edc:	c7 80 8c 18 12 80 00 	movl   $0xcffa00,-0x7fede774(%eax)
80106ee3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ee6:	c7 80 90 18 12 80 ff 	movl   $0xffff,-0x7fede770(%eax)
80106eed:	ff 00 00 
80106ef0:	c7 80 94 18 12 80 00 	movl   $0xcff200,-0x7fede76c(%eax)
80106ef7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106efa:	05 70 18 12 80       	add    $0x80121870,%eax
  pd[1] = (uint)p;
80106eff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f03:	c1 e8 10             	shr    $0x10,%eax
80106f06:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f0a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f0d:	0f 01 10             	lgdtl  (%eax)
}
80106f10:	c9                   	leave  
80106f11:	c3                   	ret    
80106f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f20 <public_walkpgdir>:
public_walkpgdir(pde_t *pgdir, const void *va, int alloc){
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, va, alloc);
80106f23:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106f26:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f29:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106f2c:	5d                   	pop    %ebp
  return walkpgdir(pgdir, va, alloc);
80106f2d:	e9 ae fd ff ff       	jmp    80106ce0 <walkpgdir>
80106f32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f40 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f40:	a1 24 1a 13 80       	mov    0x80131a24,%eax
{
80106f45:	55                   	push   %ebp
80106f46:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f48:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f4d:	0f 22 d8             	mov    %eax,%cr3
}
80106f50:	5d                   	pop    %ebp
80106f51:	c3                   	ret    
80106f52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f60 <switchuvm>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 1c             	sub    $0x1c,%esp
80106f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106f6c:	85 db                	test   %ebx,%ebx
80106f6e:	0f 84 cb 00 00 00    	je     8010703f <switchuvm+0xdf>
  if(p->kstack == 0)
80106f74:	8b 43 08             	mov    0x8(%ebx),%eax
80106f77:	85 c0                	test   %eax,%eax
80106f79:	0f 84 da 00 00 00    	je     80107059 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106f7f:	8b 43 04             	mov    0x4(%ebx),%eax
80106f82:	85 c0                	test   %eax,%eax
80106f84:	0f 84 c2 00 00 00    	je     8010704c <switchuvm+0xec>
  pushcli();
80106f8a:	e8 01 d8 ff ff       	call   80104790 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f8f:	e8 5c cc ff ff       	call   80103bf0 <mycpu>
80106f94:	89 c6                	mov    %eax,%esi
80106f96:	e8 55 cc ff ff       	call   80103bf0 <mycpu>
80106f9b:	89 c7                	mov    %eax,%edi
80106f9d:	e8 4e cc ff ff       	call   80103bf0 <mycpu>
80106fa2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fa5:	83 c7 08             	add    $0x8,%edi
80106fa8:	e8 43 cc ff ff       	call   80103bf0 <mycpu>
80106fad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106fb0:	83 c0 08             	add    $0x8,%eax
80106fb3:	ba 67 00 00 00       	mov    $0x67,%edx
80106fb8:	c1 e8 18             	shr    $0x18,%eax
80106fbb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106fc2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106fc9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fcf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fd4:	83 c1 08             	add    $0x8,%ecx
80106fd7:	c1 e9 10             	shr    $0x10,%ecx
80106fda:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106fe0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106fe5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106fec:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106ff1:	e8 fa cb ff ff       	call   80103bf0 <mycpu>
80106ff6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ffd:	e8 ee cb ff ff       	call   80103bf0 <mycpu>
80107002:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107006:	8b 73 08             	mov    0x8(%ebx),%esi
80107009:	e8 e2 cb ff ff       	call   80103bf0 <mycpu>
8010700e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107014:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107017:	e8 d4 cb ff ff       	call   80103bf0 <mycpu>
8010701c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107020:	b8 28 00 00 00       	mov    $0x28,%eax
80107025:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107028:	8b 43 04             	mov    0x4(%ebx),%eax
8010702b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107030:	0f 22 d8             	mov    %eax,%cr3
}
80107033:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107036:	5b                   	pop    %ebx
80107037:	5e                   	pop    %esi
80107038:	5f                   	pop    %edi
80107039:	5d                   	pop    %ebp
  popcli();
8010703a:	e9 91 d7 ff ff       	jmp    801047d0 <popcli>
    panic("switchuvm: no process");
8010703f:	83 ec 0c             	sub    $0xc,%esp
80107042:	68 d0 81 10 80       	push   $0x801081d0
80107047:	e8 44 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010704c:	83 ec 0c             	sub    $0xc,%esp
8010704f:	68 fb 81 10 80       	push   $0x801081fb
80107054:	e8 37 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107059:	83 ec 0c             	sub    $0xc,%esp
8010705c:	68 e6 81 10 80       	push   $0x801081e6
80107061:	e8 2a 93 ff ff       	call   80100390 <panic>
80107066:	8d 76 00             	lea    0x0(%esi),%esi
80107069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107070 <inituvm>:
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	53                   	push   %ebx
80107076:	83 ec 1c             	sub    $0x1c,%esp
80107079:	8b 75 10             	mov    0x10(%ebp),%esi
8010707c:	8b 45 08             	mov    0x8(%ebp),%eax
8010707f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107082:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107088:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010708b:	77 49                	ja     801070d6 <inituvm+0x66>
  mem = cow_kalloc();
8010708d:	e8 9e fb ff ff       	call   80106c30 <cow_kalloc>
  memset(mem, 0, PGSIZE);
80107092:	83 ec 04             	sub    $0x4,%esp
  mem = cow_kalloc();
80107095:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107097:	68 00 10 00 00       	push   $0x1000
8010709c:	6a 00                	push   $0x0
8010709e:	50                   	push   %eax
8010709f:	e8 cc d8 ff ff       	call   80104970 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801070a4:	58                   	pop    %eax
801070a5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070ab:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070b0:	5a                   	pop    %edx
801070b1:	6a 06                	push   $0x6
801070b3:	50                   	push   %eax
801070b4:	31 d2                	xor    %edx,%edx
801070b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070b9:	e8 a2 fc ff ff       	call   80106d60 <mappages>
  memmove(mem, init, sz);
801070be:	89 75 10             	mov    %esi,0x10(%ebp)
801070c1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801070c4:	83 c4 10             	add    $0x10,%esp
801070c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801070ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070cd:	5b                   	pop    %ebx
801070ce:	5e                   	pop    %esi
801070cf:	5f                   	pop    %edi
801070d0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801070d1:	e9 4a d9 ff ff       	jmp    80104a20 <memmove>
    panic("inituvm: more than a page");
801070d6:	83 ec 0c             	sub    $0xc,%esp
801070d9:	68 0f 82 10 80       	push   $0x8010820f
801070de:	e8 ad 92 ff ff       	call   80100390 <panic>
801070e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070f0 <loaduvm>:
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	56                   	push   %esi
801070f5:	53                   	push   %ebx
801070f6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801070f9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107100:	0f 85 91 00 00 00    	jne    80107197 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107106:	8b 75 18             	mov    0x18(%ebp),%esi
80107109:	31 db                	xor    %ebx,%ebx
8010710b:	85 f6                	test   %esi,%esi
8010710d:	75 1a                	jne    80107129 <loaduvm+0x39>
8010710f:	eb 6f                	jmp    80107180 <loaduvm+0x90>
80107111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107118:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010711e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107124:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107127:	76 57                	jbe    80107180 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107129:	8b 55 0c             	mov    0xc(%ebp),%edx
8010712c:	8b 45 08             	mov    0x8(%ebp),%eax
8010712f:	31 c9                	xor    %ecx,%ecx
80107131:	01 da                	add    %ebx,%edx
80107133:	e8 a8 fb ff ff       	call   80106ce0 <walkpgdir>
80107138:	85 c0                	test   %eax,%eax
8010713a:	74 4e                	je     8010718a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010713c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010713e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107141:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107146:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010714b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107151:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107154:	01 d9                	add    %ebx,%ecx
80107156:	05 00 00 00 80       	add    $0x80000000,%eax
8010715b:	57                   	push   %edi
8010715c:	51                   	push   %ecx
8010715d:	50                   	push   %eax
8010715e:	ff 75 10             	pushl  0x10(%ebp)
80107161:	e8 9a a8 ff ff       	call   80101a00 <readi>
80107166:	83 c4 10             	add    $0x10,%esp
80107169:	39 f8                	cmp    %edi,%eax
8010716b:	74 ab                	je     80107118 <loaduvm+0x28>
}
8010716d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107175:	5b                   	pop    %ebx
80107176:	5e                   	pop    %esi
80107177:	5f                   	pop    %edi
80107178:	5d                   	pop    %ebp
80107179:	c3                   	ret    
8010717a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107180:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107183:	31 c0                	xor    %eax,%eax
}
80107185:	5b                   	pop    %ebx
80107186:	5e                   	pop    %esi
80107187:	5f                   	pop    %edi
80107188:	5d                   	pop    %ebp
80107189:	c3                   	ret    
      panic("loaduvm: address should exist");
8010718a:	83 ec 0c             	sub    $0xc,%esp
8010718d:	68 29 82 10 80       	push   $0x80108229
80107192:	e8 f9 91 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107197:	83 ec 0c             	sub    $0xc,%esp
8010719a:	68 9c 81 10 80       	push   $0x8010819c
8010719f:	e8 ec 91 ff ff       	call   80100390 <panic>
801071a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801071b0 <allocuvm>:
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801071b9:	8b 7d 10             	mov    0x10(%ebp),%edi
801071bc:	85 ff                	test   %edi,%edi
801071be:	0f 88 8e 00 00 00    	js     80107252 <allocuvm+0xa2>
  if(newsz < oldsz)
801071c4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801071c7:	0f 82 93 00 00 00    	jb     80107260 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
801071cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801071d0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801071d6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801071dc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801071df:	0f 86 7e 00 00 00    	jbe    80107263 <allocuvm+0xb3>
801071e5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801071e8:	8b 7d 08             	mov    0x8(%ebp),%edi
801071eb:	eb 42                	jmp    8010722f <allocuvm+0x7f>
801071ed:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801071f0:	83 ec 04             	sub    $0x4,%esp
801071f3:	68 00 10 00 00       	push   $0x1000
801071f8:	6a 00                	push   $0x0
801071fa:	50                   	push   %eax
801071fb:	e8 70 d7 ff ff       	call   80104970 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107200:	58                   	pop    %eax
80107201:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107207:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010720c:	5a                   	pop    %edx
8010720d:	6a 06                	push   $0x6
8010720f:	50                   	push   %eax
80107210:	89 da                	mov    %ebx,%edx
80107212:	89 f8                	mov    %edi,%eax
80107214:	e8 47 fb ff ff       	call   80106d60 <mappages>
80107219:	83 c4 10             	add    $0x10,%esp
8010721c:	85 c0                	test   %eax,%eax
8010721e:	78 50                	js     80107270 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107220:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107226:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107229:	0f 86 81 00 00 00    	jbe    801072b0 <allocuvm+0x100>
    mem = cow_kalloc();
8010722f:	e8 fc f9 ff ff       	call   80106c30 <cow_kalloc>
    if(mem == 0){
80107234:	85 c0                	test   %eax,%eax
    mem = cow_kalloc();
80107236:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107238:	75 b6                	jne    801071f0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010723a:	83 ec 0c             	sub    $0xc,%esp
8010723d:	68 47 82 10 80       	push   $0x80108247
80107242:	e8 19 94 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107247:	83 c4 10             	add    $0x10,%esp
8010724a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010724d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107250:	77 6e                	ja     801072c0 <allocuvm+0x110>
}
80107252:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107255:	31 ff                	xor    %edi,%edi
}
80107257:	89 f8                	mov    %edi,%eax
80107259:	5b                   	pop    %ebx
8010725a:	5e                   	pop    %esi
8010725b:	5f                   	pop    %edi
8010725c:	5d                   	pop    %ebp
8010725d:	c3                   	ret    
8010725e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107260:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107263:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107266:	89 f8                	mov    %edi,%eax
80107268:	5b                   	pop    %ebx
80107269:	5e                   	pop    %esi
8010726a:	5f                   	pop    %edi
8010726b:	5d                   	pop    %ebp
8010726c:	c3                   	ret    
8010726d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107270:	83 ec 0c             	sub    $0xc,%esp
80107273:	68 5f 82 10 80       	push   $0x8010825f
80107278:	e8 e3 93 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010727d:	83 c4 10             	add    $0x10,%esp
80107280:	8b 45 0c             	mov    0xc(%ebp),%eax
80107283:	39 45 10             	cmp    %eax,0x10(%ebp)
80107286:	76 0d                	jbe    80107295 <allocuvm+0xe5>
80107288:	89 c1                	mov    %eax,%ecx
8010728a:	8b 55 10             	mov    0x10(%ebp),%edx
8010728d:	8b 45 08             	mov    0x8(%ebp),%eax
80107290:	e8 5b fb ff ff       	call   80106df0 <deallocuvm.part.2>
      cow_kfree(mem);
80107295:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107298:	31 ff                	xor    %edi,%edi
      cow_kfree(mem);
8010729a:	56                   	push   %esi
8010729b:	e8 00 f9 ff ff       	call   80106ba0 <cow_kfree>
      return 0;
801072a0:	83 c4 10             	add    $0x10,%esp
}
801072a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072a6:	89 f8                	mov    %edi,%eax
801072a8:	5b                   	pop    %ebx
801072a9:	5e                   	pop    %esi
801072aa:	5f                   	pop    %edi
801072ab:	5d                   	pop    %ebp
801072ac:	c3                   	ret    
801072ad:	8d 76 00             	lea    0x0(%esi),%esi
801072b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801072b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072b6:	5b                   	pop    %ebx
801072b7:	89 f8                	mov    %edi,%eax
801072b9:	5e                   	pop    %esi
801072ba:	5f                   	pop    %edi
801072bb:	5d                   	pop    %ebp
801072bc:	c3                   	ret    
801072bd:	8d 76 00             	lea    0x0(%esi),%esi
801072c0:	89 c1                	mov    %eax,%ecx
801072c2:	8b 55 10             	mov    0x10(%ebp),%edx
801072c5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
801072c8:	31 ff                	xor    %edi,%edi
801072ca:	e8 21 fb ff ff       	call   80106df0 <deallocuvm.part.2>
801072cf:	eb 92                	jmp    80107263 <allocuvm+0xb3>
801072d1:	eb 0d                	jmp    801072e0 <deallocuvm>
801072d3:	90                   	nop
801072d4:	90                   	nop
801072d5:	90                   	nop
801072d6:	90                   	nop
801072d7:	90                   	nop
801072d8:	90                   	nop
801072d9:	90                   	nop
801072da:	90                   	nop
801072db:	90                   	nop
801072dc:	90                   	nop
801072dd:	90                   	nop
801072de:	90                   	nop
801072df:	90                   	nop

801072e0 <deallocuvm>:
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801072e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801072e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801072ec:	39 d1                	cmp    %edx,%ecx
801072ee:	73 10                	jae    80107300 <deallocuvm+0x20>
}
801072f0:	5d                   	pop    %ebp
801072f1:	e9 fa fa ff ff       	jmp    80106df0 <deallocuvm.part.2>
801072f6:	8d 76 00             	lea    0x0(%esi),%esi
801072f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107300:	89 d0                	mov    %edx,%eax
80107302:	5d                   	pop    %ebp
80107303:	c3                   	ret    
80107304:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010730a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107310 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	57                   	push   %edi
80107314:	56                   	push   %esi
80107315:	53                   	push   %ebx
80107316:	83 ec 0c             	sub    $0xc,%esp
80107319:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;
  
  if(pgdir == 0)
8010731c:	85 f6                	test   %esi,%esi
8010731e:	74 59                	je     80107379 <freevm+0x69>
80107320:	31 c9                	xor    %ecx,%ecx
80107322:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107327:	89 f0                	mov    %esi,%eax
80107329:	e8 c2 fa ff ff       	call   80106df0 <deallocuvm.part.2>
8010732e:	89 f3                	mov    %esi,%ebx
80107330:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107336:	eb 0f                	jmp    80107347 <freevm+0x37>
80107338:	90                   	nop
80107339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107340:	83 c3 04             	add    $0x4,%ebx
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
    }
  }
  #endif
  for(i = 0; i < NPDENTRIES; i++){
80107343:	39 fb                	cmp    %edi,%ebx
80107345:	74 23                	je     8010736a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107347:	8b 03                	mov    (%ebx),%eax
80107349:	a8 01                	test   $0x1,%al
8010734b:	74 f3                	je     80107340 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010734d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
       cow_kfree(v);
80107352:	83 ec 0c             	sub    $0xc,%esp
80107355:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107358:	05 00 00 00 80       	add    $0x80000000,%eax
       cow_kfree(v);
8010735d:	50                   	push   %eax
8010735e:	e8 3d f8 ff ff       	call   80106ba0 <cow_kfree>
80107363:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107366:	39 fb                	cmp    %edi,%ebx
80107368:	75 dd                	jne    80107347 <freevm+0x37>
    }
  }
   cow_kfree((char*)pgdir);
8010736a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010736d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107370:	5b                   	pop    %ebx
80107371:	5e                   	pop    %esi
80107372:	5f                   	pop    %edi
80107373:	5d                   	pop    %ebp
   cow_kfree((char*)pgdir);
80107374:	e9 27 f8 ff ff       	jmp    80106ba0 <cow_kfree>
    panic("freevm: no pgdir");
80107379:	83 ec 0c             	sub    $0xc,%esp
8010737c:	68 7b 82 10 80       	push   $0x8010827b
80107381:	e8 0a 90 ff ff       	call   80100390 <panic>
80107386:	8d 76 00             	lea    0x0(%esi),%esi
80107389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107390 <setupkvm>:
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	56                   	push   %esi
80107394:	53                   	push   %ebx
  if((pgdir = (pde_t*)cow_kalloc()) == 0)
80107395:	e8 96 f8 ff ff       	call   80106c30 <cow_kalloc>
8010739a:	85 c0                	test   %eax,%eax
8010739c:	89 c6                	mov    %eax,%esi
8010739e:	74 42                	je     801073e2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801073a0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
801073a3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801073a8:	68 00 10 00 00       	push   $0x1000
801073ad:	6a 00                	push   $0x0
801073af:	50                   	push   %eax
801073b0:	e8 bb d5 ff ff       	call   80104970 <memset>
801073b5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801073b8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801073bb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801073be:	83 ec 08             	sub    $0x8,%esp
801073c1:	8b 13                	mov    (%ebx),%edx
801073c3:	ff 73 0c             	pushl  0xc(%ebx)
801073c6:	50                   	push   %eax
801073c7:	29 c1                	sub    %eax,%ecx
801073c9:	89 f0                	mov    %esi,%eax
801073cb:	e8 90 f9 ff ff       	call   80106d60 <mappages>
801073d0:	83 c4 10             	add    $0x10,%esp
801073d3:	85 c0                	test   %eax,%eax
801073d5:	78 19                	js     801073f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
801073d7:	83 c3 10             	add    $0x10,%ebx
801073da:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801073e0:	75 d6                	jne    801073b8 <setupkvm+0x28>
}
801073e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073e5:	89 f0                	mov    %esi,%eax
801073e7:	5b                   	pop    %ebx
801073e8:	5e                   	pop    %esi
801073e9:	5d                   	pop    %ebp
801073ea:	c3                   	ret    
801073eb:	90                   	nop
801073ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801073f0:	83 ec 0c             	sub    $0xc,%esp
801073f3:	56                   	push   %esi
      return 0;
801073f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801073f6:	e8 15 ff ff ff       	call   80107310 <freevm>
      return 0;
801073fb:	83 c4 10             	add    $0x10,%esp
}
801073fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107401:	89 f0                	mov    %esi,%eax
80107403:	5b                   	pop    %ebx
80107404:	5e                   	pop    %esi
80107405:	5d                   	pop    %ebp
80107406:	c3                   	ret    
80107407:	89 f6                	mov    %esi,%esi
80107409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107410 <kvmalloc>:
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107416:	e8 75 ff ff ff       	call   80107390 <setupkvm>
8010741b:	a3 24 1a 13 80       	mov    %eax,0x80131a24
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107420:	05 00 00 00 80       	add    $0x80000000,%eax
80107425:	0f 22 d8             	mov    %eax,%cr3
}
80107428:	c9                   	leave  
80107429:	c3                   	ret    
8010742a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107430 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107430:	55                   	push   %ebp
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
80107431:	31 c9                	xor    %ecx,%ecx
{
80107433:	89 e5                	mov    %esp,%ebp
80107435:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107438:	8b 55 0c             	mov    0xc(%ebp),%edx
8010743b:	8b 45 08             	mov    0x8(%ebp),%eax
8010743e:	e8 9d f8 ff ff       	call   80106ce0 <walkpgdir>
  if(pte == 0)
80107443:	85 c0                	test   %eax,%eax
80107445:	74 05                	je     8010744c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107447:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010744a:	c9                   	leave  
8010744b:	c3                   	ret    
    panic("clearpteu");
8010744c:	83 ec 0c             	sub    $0xc,%esp
8010744f:	68 8c 82 10 80       	push   $0x8010828c
80107454:	e8 37 8f ff ff       	call   80100390 <panic>
80107459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107460 <cow_copyuvm>:
#endif

#if SELECTION == NONE
pde_t*
cow_copyuvm(pde_t *pgdir, uint sz)
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	57                   	push   %edi
80107464:	56                   	push   %esi
80107465:	53                   	push   %ebx
80107466:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  if((d = setupkvm()) == 0)
80107469:	e8 22 ff ff ff       	call   80107390 <setupkvm>
8010746e:	85 c0                	test   %eax,%eax
80107470:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107473:	0f 84 cd 00 00 00    	je     80107546 <cow_copyuvm+0xe6>
    return 0;
  //cprintf("cow : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());

  // cprintf("cow_copyuvm : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());
  for(i = 0; i < sz; i += PGSIZE){
80107479:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010747c:	85 db                	test   %ebx,%ebx
8010747e:	0f 84 c2 00 00 00    	je     80107546 <cow_copyuvm+0xe6>
80107484:	31 ff                	xor    %edi,%edi
80107486:	eb 1e                	jmp    801074a6 <cow_copyuvm+0x46>
80107488:	90                   	nop
80107489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      // cprintf("cow2");
      goto bad;
    }
    // cprintf("cow2");
    // update parents flags
    *pte |= (PTE_W & flags ? PTE_COW : 0);
80107490:	0b 1e                	or     (%esi),%ebx
  for(i = 0; i < sz; i += PGSIZE){
80107492:	81 c7 00 10 00 00    	add    $0x1000,%edi
    *pte &= (~PTE_W);
80107498:	83 e3 fd             	and    $0xfffffffd,%ebx
  for(i = 0; i < sz; i += PGSIZE){
8010749b:	39 7d 0c             	cmp    %edi,0xc(%ebp)
    *pte &= (~PTE_W);
8010749e:	89 1e                	mov    %ebx,(%esi)
  for(i = 0; i < sz; i += PGSIZE){
801074a0:	0f 86 a0 00 00 00    	jbe    80107546 <cow_copyuvm+0xe6>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801074a6:	8b 45 08             	mov    0x8(%ebp),%eax
801074a9:	31 c9                	xor    %ecx,%ecx
801074ab:	89 fa                	mov    %edi,%edx
801074ad:	e8 2e f8 ff ff       	call   80106ce0 <walkpgdir>
801074b2:	85 c0                	test   %eax,%eax
801074b4:	89 c6                	mov    %eax,%esi
801074b6:	0f 84 a2 00 00 00    	je     8010755e <cow_copyuvm+0xfe>
    if(!(*pte & PTE_P) )
801074bc:	f6 00 01             	testb  $0x1,(%eax)
801074bf:	0f 84 8c 00 00 00    	je     80107551 <cow_copyuvm+0xf1>
    acquire(cow_lock);
801074c5:	83 ec 0c             	sub    $0xc,%esp
801074c8:	ff 35 40 ef 11 80    	pushl  0x8011ef40
801074ce:	e8 8d d3 ff ff       	call   80104860 <acquire>
    pa = PTE_ADDR(*pte);
801074d3:	8b 06                	mov    (%esi),%eax
801074d5:	89 c2                	mov    %eax,%edx
801074d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    release(cow_lock);
801074da:	58                   	pop    %eax
    pa = PTE_ADDR(*pte);
801074db:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    release(cow_lock);
801074e1:	ff 35 40 ef 11 80    	pushl  0x8011ef40
    pg_ref_counts[PGROUNDDOWN(pa)/PGSIZE]++;
801074e7:	89 d1                	mov    %edx,%ecx
801074e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801074ec:	c1 e9 0c             	shr    $0xc,%ecx
801074ef:	80 81 40 0f 11 80 01 	addb   $0x1,-0x7feef0c0(%ecx)
    release(cow_lock);
801074f6:	e8 25 d4 ff ff       	call   80104920 <release>
    if(mappages(d, (void*)i, PGSIZE, pa, (flags & (~PTE_W)) | (PTE_W & flags ? PTE_COW : 0)) < 0) {
801074fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074fe:	5a                   	pop    %edx
801074ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107502:	89 c3                	mov    %eax,%ebx
80107504:	25 fd 0f 00 00       	and    $0xffd,%eax
80107509:	c1 e3 0a             	shl    $0xa,%ebx
8010750c:	81 e3 00 08 00 00    	and    $0x800,%ebx
80107512:	59                   	pop    %ecx
80107513:	09 d8                	or     %ebx,%eax
80107515:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010751a:	50                   	push   %eax
8010751b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010751e:	52                   	push   %edx
8010751f:	89 fa                	mov    %edi,%edx
80107521:	e8 3a f8 ff ff       	call   80106d60 <mappages>
80107526:	83 c4 10             	add    $0x10,%esp
80107529:	85 c0                	test   %eax,%eax
8010752b:	0f 89 5f ff ff ff    	jns    80107490 <cow_copyuvm+0x30>
  }
  return d;

bad:
  // release(cow_lock);
  freevm(d);
80107531:	83 ec 0c             	sub    $0xc,%esp
80107534:	ff 75 dc             	pushl  -0x24(%ebp)
80107537:	e8 d4 fd ff ff       	call   80107310 <freevm>
  return 0;
8010753c:	83 c4 10             	add    $0x10,%esp
8010753f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80107546:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107549:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010754c:	5b                   	pop    %ebx
8010754d:	5e                   	pop    %esi
8010754e:	5f                   	pop    %edi
8010754f:	5d                   	pop    %ebp
80107550:	c3                   	ret    
      panic("copyuvm: page not present");
80107551:	83 ec 0c             	sub    $0xc,%esp
80107554:	68 b0 82 10 80       	push   $0x801082b0
80107559:	e8 32 8e ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
8010755e:	83 ec 0c             	sub    $0xc,%esp
80107561:	68 96 82 10 80       	push   $0x80108296
80107566:	e8 25 8e ff ff       	call   80100390 <panic>
8010756b:	90                   	nop
8010756c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107570 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	57                   	push   %edi
80107574:	56                   	push   %esi
80107575:	53                   	push   %ebx
80107576:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107579:	e8 12 fe ff ff       	call   80107390 <setupkvm>
8010757e:	85 c0                	test   %eax,%eax
80107580:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107583:	0f 84 9f 00 00 00    	je     80107628 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107589:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010758c:	85 c9                	test   %ecx,%ecx
8010758e:	0f 84 94 00 00 00    	je     80107628 <copyuvm+0xb8>
80107594:	31 ff                	xor    %edi,%edi
80107596:	eb 4a                	jmp    801075e2 <copyuvm+0x72>
80107598:	90                   	nop
80107599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = cow_kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801075a0:	83 ec 04             	sub    $0x4,%esp
801075a3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801075a9:	68 00 10 00 00       	push   $0x1000
801075ae:	53                   	push   %ebx
801075af:	50                   	push   %eax
801075b0:	e8 6b d4 ff ff       	call   80104a20 <memmove>
    // cprintf("copy1");
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801075b5:	58                   	pop    %eax
801075b6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801075bc:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075c1:	5a                   	pop    %edx
801075c2:	ff 75 e4             	pushl  -0x1c(%ebp)
801075c5:	50                   	push   %eax
801075c6:	89 fa                	mov    %edi,%edx
801075c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075cb:	e8 90 f7 ff ff       	call   80106d60 <mappages>
801075d0:	83 c4 10             	add    $0x10,%esp
801075d3:	85 c0                	test   %eax,%eax
801075d5:	78 61                	js     80107638 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801075d7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801075dd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801075e0:	76 46                	jbe    80107628 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801075e2:	8b 45 08             	mov    0x8(%ebp),%eax
801075e5:	31 c9                	xor    %ecx,%ecx
801075e7:	89 fa                	mov    %edi,%edx
801075e9:	e8 f2 f6 ff ff       	call   80106ce0 <walkpgdir>
801075ee:	85 c0                	test   %eax,%eax
801075f0:	74 61                	je     80107653 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801075f2:	8b 00                	mov    (%eax),%eax
801075f4:	a8 01                	test   $0x1,%al
801075f6:	74 4e                	je     80107646 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801075f8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801075fa:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801075ff:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107605:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = cow_kalloc()) == 0)
80107608:	e8 23 f6 ff ff       	call   80106c30 <cow_kalloc>
8010760d:	85 c0                	test   %eax,%eax
8010760f:	89 c6                	mov    %eax,%esi
80107611:	75 8d                	jne    801075a0 <copyuvm+0x30>
    // cprintf("copy2");
  }
  return d;

bad:
  freevm(d);
80107613:	83 ec 0c             	sub    $0xc,%esp
80107616:	ff 75 e0             	pushl  -0x20(%ebp)
80107619:	e8 f2 fc ff ff       	call   80107310 <freevm>
  return 0;
8010761e:	83 c4 10             	add    $0x10,%esp
80107621:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107628:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010762b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010762e:	5b                   	pop    %ebx
8010762f:	5e                   	pop    %esi
80107630:	5f                   	pop    %edi
80107631:	5d                   	pop    %ebp
80107632:	c3                   	ret    
80107633:	90                   	nop
80107634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
       cow_kfree(mem);
80107638:	83 ec 0c             	sub    $0xc,%esp
8010763b:	56                   	push   %esi
8010763c:	e8 5f f5 ff ff       	call   80106ba0 <cow_kfree>
      goto bad;
80107641:	83 c4 10             	add    $0x10,%esp
80107644:	eb cd                	jmp    80107613 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107646:	83 ec 0c             	sub    $0xc,%esp
80107649:	68 b0 82 10 80       	push   $0x801082b0
8010764e:	e8 3d 8d ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107653:	83 ec 0c             	sub    $0xc,%esp
80107656:	68 96 82 10 80       	push   $0x80108296
8010765b:	e8 30 8d ff ff       	call   80100390 <panic>

80107660 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107660:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107661:	31 c9                	xor    %ecx,%ecx
{
80107663:	89 e5                	mov    %esp,%ebp
80107665:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107668:	8b 55 0c             	mov    0xc(%ebp),%edx
8010766b:	8b 45 08             	mov    0x8(%ebp),%eax
8010766e:	e8 6d f6 ff ff       	call   80106ce0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107673:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107675:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107676:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107678:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010767d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107680:	05 00 00 00 80       	add    $0x80000000,%eax
80107685:	83 fa 05             	cmp    $0x5,%edx
80107688:	ba 00 00 00 00       	mov    $0x0,%edx
8010768d:	0f 45 c2             	cmovne %edx,%eax
}
80107690:	c3                   	ret    
80107691:	eb 0d                	jmp    801076a0 <copyout>
80107693:	90                   	nop
80107694:	90                   	nop
80107695:	90                   	nop
80107696:	90                   	nop
80107697:	90                   	nop
80107698:	90                   	nop
80107699:	90                   	nop
8010769a:	90                   	nop
8010769b:	90                   	nop
8010769c:	90                   	nop
8010769d:	90                   	nop
8010769e:	90                   	nop
8010769f:	90                   	nop

801076a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801076a0:	55                   	push   %ebp
801076a1:	89 e5                	mov    %esp,%ebp
801076a3:	57                   	push   %edi
801076a4:	56                   	push   %esi
801076a5:	53                   	push   %ebx
801076a6:	83 ec 1c             	sub    $0x1c,%esp
801076a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801076ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801076af:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801076b2:	85 db                	test   %ebx,%ebx
801076b4:	75 40                	jne    801076f6 <copyout+0x56>
801076b6:	eb 70                	jmp    80107728 <copyout+0x88>
801076b8:	90                   	nop
801076b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801076c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801076c3:	89 f1                	mov    %esi,%ecx
801076c5:	29 d1                	sub    %edx,%ecx
801076c7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801076cd:	39 d9                	cmp    %ebx,%ecx
801076cf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801076d2:	29 f2                	sub    %esi,%edx
801076d4:	83 ec 04             	sub    $0x4,%esp
801076d7:	01 d0                	add    %edx,%eax
801076d9:	51                   	push   %ecx
801076da:	57                   	push   %edi
801076db:	50                   	push   %eax
801076dc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801076df:	e8 3c d3 ff ff       	call   80104a20 <memmove>
    len -= n;
    buf += n;
801076e4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801076e7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801076ea:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801076f0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801076f2:	29 cb                	sub    %ecx,%ebx
801076f4:	74 32                	je     80107728 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801076f6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801076f8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801076fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801076fe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107704:	56                   	push   %esi
80107705:	ff 75 08             	pushl  0x8(%ebp)
80107708:	e8 53 ff ff ff       	call   80107660 <uva2ka>
    if(pa0 == 0)
8010770d:	83 c4 10             	add    $0x10,%esp
80107710:	85 c0                	test   %eax,%eax
80107712:	75 ac                	jne    801076c0 <copyout+0x20>
  }
  return 0;
}
80107714:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107717:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010771c:	5b                   	pop    %ebx
8010771d:	5e                   	pop    %esi
8010771e:	5f                   	pop    %edi
8010771f:	5d                   	pop    %ebp
80107720:	c3                   	ret    
80107721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107728:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010772b:	31 c0                	xor    %eax,%eax
}
8010772d:	5b                   	pop    %ebx
8010772e:	5e                   	pop    %esi
8010772f:	5f                   	pop    %edi
80107730:	5d                   	pop    %ebp
80107731:	c3                   	ret    
80107732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107740 <copy_page>:
    cprintf("PGFAULT C\n");
    swap_in(p, pi_to_swapin);
  }
}
#endif
int copy_page(pde_t* pgdir, pte_t* pte_ptr){
80107740:	55                   	push   %ebp
80107741:	89 e5                	mov    %esp,%ebp
80107743:	57                   	push   %edi
80107744:	56                   	push   %esi
80107745:	53                   	push   %ebx
80107746:	83 ec 0c             	sub    $0xc,%esp
80107749:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint pa = PTE_ADDR(*pte_ptr);
8010774c:	8b 3e                	mov    (%esi),%edi
  char* mem = cow_kalloc();
8010774e:	e8 dd f4 ff ff       	call   80106c30 <cow_kalloc>
  uint pa = PTE_ADDR(*pte_ptr);
80107753:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if (mem == 0){
80107759:	85 c0                	test   %eax,%eax
8010775b:	74 3b                	je     80107798 <copy_page+0x58>
8010775d:	89 c3                	mov    %eax,%ebx
    return -1;
  }
  memmove(mem, P2V(pa), PGSIZE);
8010775f:	83 ec 04             	sub    $0x4,%esp
80107762:	81 c7 00 00 00 80    	add    $0x80000000,%edi
  *pte_ptr = PTE_ADDR(P2V(mem)) | PTE_U | PTE_W | PTE_P;
80107768:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
8010776e:	68 00 10 00 00       	push   $0x1000
80107773:	57                   	push   %edi
  *pte_ptr = PTE_ADDR(P2V(mem)) | PTE_U | PTE_W | PTE_P;
80107774:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
8010777a:	50                   	push   %eax
  *pte_ptr = PTE_ADDR(P2V(mem)) | PTE_U | PTE_W | PTE_P;
8010777b:	83 cb 07             	or     $0x7,%ebx
  memmove(mem, P2V(pa), PGSIZE);
8010777e:	e8 9d d2 ff ff       	call   80104a20 <memmove>
  *pte_ptr = PTE_ADDR(P2V(mem)) | PTE_U | PTE_W | PTE_P;
80107783:	89 1e                	mov    %ebx,(%esi)
  return 0;
80107785:	83 c4 10             	add    $0x10,%esp
80107788:	31 c0                	xor    %eax,%eax
}
8010778a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010778d:	5b                   	pop    %ebx
8010778e:	5e                   	pop    %esi
8010778f:	5f                   	pop    %edi
80107790:	5d                   	pop    %ebp
80107791:	c3                   	ret    
80107792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80107798:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010779d:	eb eb                	jmp    8010778a <copy_page+0x4a>
